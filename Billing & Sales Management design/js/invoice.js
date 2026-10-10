/* ==========================================================================
   INVOICE CALCULATION ENGINE & WORKFLOW STATE
   Billing & Sales Management - Mobile UI/UX Design
   Strict mathematical adherence to SRS rules and formatting.
   ========================================================================== */

class InvoiceManager {
  constructor() {
    this.currentStep = 1;
    this.draft = this.createEmptyDraft();
  }

  createEmptyDraft() {
    const nextBillNo = window.appStore ? window.appStore.getNextBillNumber() : 1045;
    const today = new Date().toISOString().split('T')[0];

    return {
      billNumber: nextBillNo,
      billDate: today,
      clientName: '',
      items: [
        // Pre-fill with reference design default items so designer/user can immediately see the flow in action
        {
          code: "ITM-001",
          name: "Laptop Dell",
          unit: "Piece",
          sellingPrice: 15000,
          quantity: 2,
          discount: 0,
          total: 30000
        },
        {
          code: "ITM-002",
          name: "Mouse Logitech",
          unit: "Piece",
          sellingPrice: 250,
          quantity: 5,
          discount: 0,
          total: 1250
        },
        {
          code: "ITM-003",
          name: "Keyboard",
          unit: "Piece",
          sellingPrice: 400,
          quantity: 3,
          discount: 0,
          total: 1200
        }
      ],
      billsTotal: 32450,
      percentageDiscount: 0,
      valueDiscount: 0,
      theNet: 32450,
      paidUp: 0,
      theRest: 32450,
      status: "Unpaid"
    };
  }

  resetDraft() {
    this.draft = this.createEmptyDraft();
    this.currentStep = 1;
    this.recalculate();
  }

  // Calculate single item total
  calculateItemTotal(sellingPrice, quantity, discount = 0) {
    const s = parseFloat(sellingPrice) || 0;
    const q = parseFloat(quantity) || 0;
    const d = parseFloat(discount) || 0;
    const rawTotal = s * q;
    return Math.max(0, rawTotal - d);
  }

  // Add item to draft
  addItem(item) {
    const total = this.calculateItemTotal(item.sellingPrice, item.quantity, item.discount || 0);
    this.draft.items.push({
      code: item.code || `ITM-${String(this.draft.items.length + 1).padStart(3, '0')}`,
      name: item.name,
      unit: item.unit || "Piece",
      sellingPrice: parseFloat(item.sellingPrice) || 0,
      quantity: parseFloat(item.quantity) || 1,
      discount: parseFloat(item.discount) || 0,
      total: total
    });
    this.recalculate();
  }

  // Remove item by index
  removeItem(index) {
    if (index >= 0 && index < this.draft.items.length) {
      this.draft.items.splice(index, 1);
      this.recalculate();
    }
  }

  // Update item quantity or rate
  updateItem(index, newProps) {
    if (this.draft.items[index]) {
      Object.assign(this.draft.items[index], newProps);
      this.draft.items[index].total = this.calculateItemTotal(
        this.draft.items[index].sellingPrice,
        this.draft.items[index].quantity,
        this.draft.items[index].discount
      );
      this.recalculate();
    }
  }

  // Recalculate Bills Total, Net, Rest
  recalculate() {
    // 1. Bills Total = Sum of items (SRS Section 1.6: "Bills Total is auto calculated from the Previous Item Table and the user can't edit it")
    const billsTotal = this.draft.items.reduce((sum, it) => sum + (parseFloat(it.total) || 0), 0);
    this.draft.billsTotal = billsTotal;

    // 2. Applied Discounts
    // SRS Section 1.6 Rule 4 states: "THE NET is auto Calculated according to Bill Total and applied discount and the user can't edit it."
    // Note: The SRS does not explicitly specify discount precedence/order between Percentage and Value discount.
    // For interactive visualization, we apply standard transparent linear deductions.
    const pct = parseFloat(this.draft.percentageDiscount) || 0;
    const val = parseFloat(this.draft.valueDiscount) || 0;

    const pctAmount = (billsTotal * pct) / 100;
    const theNet = Math.max(0, billsTotal - val - pctAmount);
    this.draft.theNet = theNet;

    // 3. Paid Up & The Rest
    // SRS Section 1.6 Rule 6 states: "The Rest is auto Calculated according to The NET and Paid UP and the user can't edit it."
    const paid = parseFloat(this.draft.paidUp) || 0;
    const theRest = theNet - paid;
    this.draft.theRest = theRest;

    // Status: Paid if Rest <= 0 and Net > 0, else Unpaid
    this.draft.status = (theRest <= 0 && theNet > 0) ? "Paid" : "Unpaid";

    return this.draft;
  }

  // Format currency helper (e.g. EGP 32,450)
  static formatCurrency(amount) {
    const num = Number(amount) || 0;
    return `EGP ${num.toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 2 })}`;
  }
}

window.InvoiceManager = InvoiceManager;
window.invoiceManager = new InvoiceManager();
