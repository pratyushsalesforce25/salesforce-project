/**
 * Supplies the data shown by the opportunityOverview Lightning Web Component
 * on the Opportunity record page.
 *
 * - Runs "with sharing" and queries "WITH USER_MODE" so the current user's
 *   record access and field-level security are always respected.
 * - Returns one wrapper object so the component needs a single server call.
 */
public with sharing class OpportunityOverviewController {
  private static final Integer MAX_CONTACTS = 5;

  public class OverviewData {
    @AuraEnabled
    public Id recordId;
    @AuraEnabled
    public String name;
    @AuraEnabled
    public Id accountId;
    @AuraEnabled
    public String accountName;
    @AuraEnabled
    public String ownerName;
    @AuraEnabled
    public String stageName;
    @AuraEnabled
    public Decimal amount;
    @AuraEnabled
    public Decimal probability;
    @AuraEnabled
    public Date closeDate;
    @AuraEnabled
    public Integer daysToClose;
    @AuraEnabled
    public Boolean isClosed;
    @AuraEnabled
    public Boolean isWon;
    @AuraEnabled
    public String nextStep;
    @AuraEnabled
    public Integer openTaskCount;
    @AuraEnabled
    public List<String> stageNames = new List<String>();
    @AuraEnabled
    public List<ContactInfo> contacts = new List<ContactInfo>();
  }

  public class ContactInfo {
    @AuraEnabled
    public Id contactId;
    @AuraEnabled
    public String name;
    @AuraEnabled
    public String email;
    @AuraEnabled
    public String phone;
    @AuraEnabled
    public String role;
    @AuraEnabled
    public Boolean isPrimary;
  }

  @AuraEnabled(cacheable=true)
  public static OverviewData getOverview(Id recordId) {
    if (recordId == null) {
      throw buildError('A record Id is required.');
    }

    Opportunity opp;
    OverviewData result = new OverviewData();

    try {
      List<Opportunity> opps = [
        SELECT
          Id,
          Name,
          AccountId,
          Account.Name,
          Owner.Name,
          StageName,
          Amount,
          Probability,
          CloseDate,
          IsClosed,
          IsWon,
          NextStep
        FROM Opportunity
        WHERE Id = :recordId
        WITH USER_MODE
        LIMIT 1
      ];
      if (opps.isEmpty()) {
        throw buildError(
          'Opportunity not found or you do not have access to it.'
        );
      }
      opp = opps[0];

      result.openTaskCount = [
        SELECT COUNT()
        FROM Task
        WHERE WhatId = :recordId AND IsClosed = FALSE
        WITH USER_MODE
      ];

      for (OpportunityContactRole role : [
        SELECT
          ContactId,
          Contact.Name,
          Contact.Email,
          Contact.Phone,
          Role,
          IsPrimary
        FROM OpportunityContactRole
        WHERE OpportunityId = :recordId
        WITH USER_MODE
        ORDER BY IsPrimary DESC, Contact.Name
        LIMIT :MAX_CONTACTS
      ]) {
        ContactInfo info = new ContactInfo();
        info.contactId = role.ContactId;
        info.name = role.Contact.Name;
        info.email = role.Contact.Email;
        info.phone = role.Contact.Phone;
        info.role = role.Role;
        info.isPrimary = role.IsPrimary;
        result.contacts.add(info);
      }
    } catch (AuraHandledException e) {
      throw e;
    } catch (Exception e) {
      throw buildError(e.getMessage());
    }

    result.recordId = opp.Id;
    result.name = opp.Name;
    result.accountId = opp.AccountId;
    result.accountName = opp.Account?.Name;
    result.ownerName = opp.Owner?.Name;
    result.stageName = opp.StageName;
    result.amount = opp.Amount;
    result.probability = opp.Probability;
    result.closeDate = opp.CloseDate;
    result.daysToClose = opp.CloseDate == null
      ? null
      : Date.today().daysBetween(opp.CloseDate);
    result.isClosed = opp.IsClosed;
    result.isWon = opp.IsWon;
    result.nextStep = opp.NextStep;
    result.stageNames = getStagePath();
    return result;
  }

  /**
   * The stages shown in the path: every active stage except "Closed Lost".
   * A lost deal is shown with no highlighted step instead.
   */
  private static List<String> getStagePath() {
    List<String> stages = new List<String>();
    for (OpportunityStage stage : [
      SELECT ApiName
      FROM OpportunityStage
      WHERE IsActive = TRUE AND (IsClosed = FALSE OR IsWon = TRUE)
      ORDER BY SortOrder
    ]) {
      stages.add(stage.ApiName);
    }
    return stages;
  }

  private static AuraHandledException buildError(String message) {
    AuraHandledException ex = new AuraHandledException(message);
    ex.setMessage(message);
    return ex;
  }
}
