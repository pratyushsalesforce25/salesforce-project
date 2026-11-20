import { LightningElement, api, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";
import CURRENCY from "@salesforce/i18n/currency";
import LAST_MODIFIED_FIELD from "@salesforce/schema/Opportunity.LastModifiedDate";
import getOverview from "@salesforce/apex/OpportunityOverviewController.getOverview";

export default class OpportunityOverview extends NavigationMixin(
  LightningElement
) {
  @api recordId;
  /** Set from the Lightning App Builder (see the .js-meta.xml file). */
  @api showContacts;

  data;
  error;
  isLoading = true;
  isRefreshing = false;
  currencyCode = CURRENCY;

  wiredOverview;
  lastModified;

  // Main data call: one Apex method returns everything the card needs.
  @wire(getOverview, { recordId: "$recordId" })
  handleOverview(result) {
    this.wiredOverview = result;
    const { data, error } = result;
    if (data) {
      this.data = data;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.data = undefined;
    }
    if (data || error) {
      this.isLoading = false;
    }
  }

  // Watches the record, so the card refreshes after the user edits it
  // (for example, when the stage is changed on the path above).
  @wire(getRecord, { recordId: "$recordId", fields: [LAST_MODIFIED_FIELD] })
  handleRecordChange({ data }) {
    if (!data) {
      return;
    }
    const stamp = getFieldValue(data, LAST_MODIFIED_FIELD);
    if (
      this.lastModified &&
      this.lastModified !== stamp &&
      this.wiredOverview
    ) {
      this.refresh();
    }
    this.lastModified = stamp;
  }

  // ----- State of the deal -----

  get hasStages() {
    return this.data && this.data.stageNames && this.data.stageNames.length > 0;
  }

  /** A lost deal has no highlighted step in the path. */
  get currentStep() {
    const lost = this.data.isClosed && !this.data.isWon;
    return lost ? undefined : this.data.stageName;
  }

  get statusLabel() {
    if (!this.data.isClosed) {
      return "Open";
    }
    return this.data.isWon ? "Closed Won" : "Closed Lost";
  }

  get statusClass() {
    const base = "status";
    if (!this.data.isClosed) {
      return `${base} status-open`;
    }
    return this.data.isWon ? `${base} status-won` : `${base} status-lost`;
  }

  get ownerLabel() {
    return this.data.ownerName || "Unassigned";
  }

  // ----- KPI tiles -----

  get hasAmount() {
    return this.data.amount !== null && this.data.amount !== undefined;
  }

  get probabilityValue() {
    return Math.round(this.data.probability || 0);
  }

  get ringVariant() {
    if (this.data.isClosed) {
      return this.data.isWon ? "base-autocomplete" : "warning";
    }
    return "base";
  }

  get daysLabel() {
    if (this.data.isClosed) {
      return "Deal closed";
    }
    const days = this.data.daysToClose;
    if (days === null || days === undefined) {
      return "";
    }
    if (days < 0) {
      const late = Math.abs(days);
      return `${late} day${late === 1 ? "" : "s"} overdue`;
    }
    if (days === 0) {
      return "Closes today";
    }
    return `${days} day${days === 1 ? "" : "s"} left`;
  }

  get daysClass() {
    const base = "days";
    if (this.data.isClosed) {
      return `${base} days-neutral`;
    }
    const days = this.data.daysToClose;
    if (days !== null && days !== undefined && days < 0) {
      return `${base} days-late`;
    }
    if (days !== null && days !== undefined && days <= 7) {
      return `${base} days-soon`;
    }
    return `${base} days-ok`;
  }

  // ----- Activities and contacts -----

  get tasksLabel() {
    const count = this.data.openTaskCount || 0;
    if (count === 0) {
      return "No open tasks";
    }
    return `${count} open task${count === 1 ? "" : "s"}`;
  }

  get showContactSection() {
    return this.showContacts !== false;
  }

  get hasContacts() {
    return this.contacts.length > 0;
  }

  get contacts() {
    return (this.data.contacts || []).map((contact) => ({
      ...contact,
      initials: this.getInitials(contact.name),
      roleLabel: contact.role || "No role set",
      mailto: contact.email ? `mailto:${contact.email}` : undefined,
      mailTitle: `Email ${contact.name}`
    }));
  }

  getInitials(name) {
    if (!name) {
      return "?";
    }
    const parts = name.trim().split(/\s+/);
    const first = parts[0].charAt(0);
    const last = parts.length > 1 ? parts[parts.length - 1].charAt(0) : "";
    return (first + last).toUpperCase();
  }

  // ----- Errors -----

  get errorMessage() {
    const err = this.error;
    if (!err) {
      return "";
    }
    if (Array.isArray(err.body)) {
      return err.body.map((e) => e.message).join(", ");
    }
    if (err.body && typeof err.body.message === "string") {
      return err.body.message;
    }
    return (
      err.message || "Something went wrong while loading this opportunity."
    );
  }

  // ----- Actions -----

  handleRefresh() {
    this.refresh();
  }

  async refresh() {
    this.isRefreshing = true;
    try {
      await refreshApex(this.wiredOverview);
    } finally {
      this.isRefreshing = false;
    }
  }

  handleOpenAccount(event) {
    event.preventDefault();
    this.navigateToRecord(this.data.accountId);
  }

  handleOpenContact(event) {
    event.preventDefault();
    this.navigateToRecord(event.currentTarget.dataset.id);
  }

  navigateToRecord(recordId) {
    if (!recordId) {
      return;
    }
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: { recordId, actionName: "view" }
    });
  }
}
