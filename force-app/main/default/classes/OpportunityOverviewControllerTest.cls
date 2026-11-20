@IsTest
private class OpportunityOverviewControllerTest {
  @TestSetup
  static void setup() {
    Account acc = new Account(Name = 'Demo Account');
    insert acc;

    Contact con = new Contact(
      FirstName = 'Asha',
      LastName = 'Patel',
      Email = 'asha.patel@example.com',
      Phone = '5551234567',
      AccountId = acc.Id
    );
    insert con;

    Opportunity opp = new Opportunity(
      Name = 'Demo Deal',
      AccountId = acc.Id,
      StageName = firstOpenStage(),
      CloseDate = Date.today().addDays(10),
      Amount = 50000,
      NextStep = 'Send proposal'
    );
    insert opp;

    insert new OpportunityContactRole(
      OpportunityId = opp.Id,
      ContactId = con.Id,
      IsPrimary = true,
      Role = 'Decision Maker'
    );
    insert new Task(
      Subject = 'Follow up call',
      WhatId = opp.Id,
      Status = 'Not Started'
    );
  }

  @IsTest
  static void returnsOverviewForOpenOpportunity() {
    Opportunity opp = [
      SELECT Id, StageName
      FROM Opportunity
      WHERE Name = 'Demo Deal'
    ];

    Test.startTest();
    OpportunityOverviewController.OverviewData data = OpportunityOverviewController.getOverview(
      opp.Id
    );
    Test.stopTest();

    Assert.areEqual('Demo Deal', data.name);
    Assert.areEqual('Demo Account', data.accountName);
    Assert.areEqual(50000, data.amount);
    Assert.areEqual('Send proposal', data.nextStep);
    Assert.areEqual(10, data.daysToClose);
    Assert.isFalse(data.isClosed);
    Assert.areEqual(1, data.openTaskCount, 'The open task should be counted');
    Assert.areEqual(1, data.contacts.size());
    Assert.areEqual('Asha Patel', data.contacts[0].name);
    Assert.isTrue(data.contacts[0].isPrimary);
    Assert.isTrue(
      data.stageNames.contains(opp.StageName),
      'Current stage should be part of the path'
    );
  }

  @IsTest
  static void lostOpportunityIsClosedAndNotWon() {
    Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Demo Deal'];
    opp.StageName = [
      SELECT ApiName
      FROM OpportunityStage
      WHERE IsActive = TRUE AND IsClosed = TRUE AND IsWon = FALSE
      LIMIT 1
    ]
    .ApiName;
    update opp;

    OpportunityOverviewController.OverviewData data = OpportunityOverviewController.getOverview(
      opp.Id
    );

    Assert.isTrue(data.isClosed);
    Assert.isFalse(data.isWon);
    Assert.isFalse(
      data.stageNames.contains(data.stageName),
      'Closed Lost is not part of the path'
    );
  }

  @IsTest
  static void throwsWhenRecordIdIsMissing() {
    try {
      OpportunityOverviewController.getOverview(null);
      Assert.fail('An exception was expected');
    } catch (AuraHandledException e) {
      Assert.areEqual('A record Id is required.', e.getMessage());
    }
  }

  @IsTest
  static void throwsWhenOpportunityDoesNotExist() {
    Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Demo Deal'];
    Id deletedId = opp.Id;
    delete opp;

    try {
      OpportunityOverviewController.getOverview(deletedId);
      Assert.fail('An exception was expected');
    } catch (AuraHandledException e) {
      Assert.isTrue(e.getMessage().contains('not found'));
    }
  }

  private static String firstOpenStage() {
    return [
      SELECT ApiName
      FROM OpportunityStage
      WHERE IsActive = TRUE AND IsClosed = FALSE
      ORDER BY SortOrder
      LIMIT 1
    ]
    .ApiName;
  }
}
