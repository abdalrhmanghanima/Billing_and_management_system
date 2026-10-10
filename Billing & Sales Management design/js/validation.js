/* ==========================================================================
   VALIDATION ENGINE
   Billing & Sales Management - Mobile UI/UX Design
   Strict implementation of all SRS Acceptance Criteria and custom overrides.
   ========================================================================== */

const Validator = {
  // 1.1 Manage Companies
  validateCompany({ name, existingList = [] }) {
    const errors = {};
    const trimmedName = (name || '').trim();

    if (!trimmedName) {
      errors.name = "COMPANY NAME is Required";
    } else {
      const exists = existingList.some(
        c => c.name.toLowerCase() === trimmedName.toLowerCase()
      );
      if (exists) {
        errors.name = "COMPANY NAME has already existed before";
      }
    }

    return { isValid: Object.keys(errors).length === 0, errors };
  },

  // 1.2 Manage Types
  validateType({ companyName, typeName, existingList = [] }) {
    const errors = {};
    const trimmedCompany = (companyName || '').trim();
    const trimmedType = (typeName || '').trim();

    if (!trimmedCompany) {
      errors.companyName = "COMPANY NAME is Required";
    }

    if (!trimmedType) {
      errors.typeName = "TYPE NAME is Required";
    } else {
      const exists = existingList.some(
        t => t.name.toLowerCase() === trimmedType.toLowerCase()
      );
      if (exists) {
        errors.typeName = "TYPE NAME has already existed before";
      }
    }

    return { isValid: Object.keys(errors).length === 0, errors };
  },

  // 1.3 Manage Units
  validateUnit({ unitName, existingList = [] }) {
    const errors = {};
    const trimmedName = (unitName || '').trim();

    if (!trimmedName) {
      errors.unitName = "UNIT NAME is Required";
    } else {
      const exists = existingList.some(
        u => u.name.toLowerCase() === trimmedName.toLowerCase()
      );
      if (exists) {
        errors.unitName = "UNIT NAME has already existed before";
      }
    }

    return { isValid: Object.keys(errors).length === 0, errors };
  },

  // Categories (Simplified & consistent)
  validateCategory({ categoryName, existingList = [] }) {
    const errors = {};
    const trimmed = (categoryName || '').trim();

    if (!trimmed) {
      errors.categoryName = "Category Name is Required";
    } else {
      const exists = existingList.some(
        c => c.name.toLowerCase() === trimmed.toLowerCase()
      );
      if (exists) {
        errors.categoryName = "Category Name has already existed before";
      }
    }

    return { isValid: Object.keys(errors).length === 0, errors };
  },

  // 1.4 Manage Items
  validateItem({ companyName, typeName, itemName, sellingPrice, buyingPrice, existingList = [] }) {
    const errors = {};
    const trimmedCompany = (companyName || '').trim();
    const trimmedType = (typeName || '').trim();
    const trimmedName = (itemName || '').trim();

    if (!trimmedCompany) {
      errors.companyName = "COMPANY NAME is Required";
    }

    if (!trimmedType) {
      errors.typeName = "TYPE NAME is Required";
    }

    if (!trimmedName) {
      errors.itemName = "ITEM NAME is Required";
    } else {
      const exists = existingList.some(
        i => i.name.toLowerCase() === trimmedName.toLowerCase()
      );
      if (exists) {
        errors.itemName = "ITEM NAME has already existed before";
      }
    }

    const sPrice = parseFloat(sellingPrice);
    if (isNaN(sPrice) || sPrice < 0) {
      errors.sellingPrice = "SELLING PRICE Must be Greater than or equal Zero";
    }

    const bPrice = parseFloat(buyingPrice);
    if (isNaN(bPrice) || bPrice < 0) {
      errors.buyingPrice = "BUYING PRICE Must be Greater than or equal Zero";
    } else if (!isNaN(sPrice) && bPrice > sPrice) {
      errors.buyingPrice = "BUYING PRICE Must be less than or equal SELLING PRICE";
    }

    return { isValid: Object.keys(errors).length === 0, errors };
  },

  // 1.5 Manage Clients (with 11-digit phone override)
  validateClient({ name, phone, address, existingList = [] }) {
    const errors = {};
    const trimmedName = (name || '').trim();
    const trimmedPhone = (phone || '').trim();
    const trimmedAddress = (address || '').trim();

    if (!trimmedName) {
      errors.name = "CLIENT NAME is Required";
    } else {
      const exists = existingList.some(
        c => c.name.toLowerCase() === trimmedName.toLowerCase()
      );
      if (exists) {
        errors.name = "CLIENT NAME has already existed before";
      }
    }

    if (!trimmedPhone) {
      errors.phone = "PHONE is Required";
    } else {
      // Must be exactly 11 digits
      const phoneDigits = trimmedPhone.replace(/\D/g, '');
      if (phoneDigits.length !== 11) {
        errors.phone = "PHONE must be just a 11 digit number";
      }
    }

    if (!trimmedAddress) {
      errors.address = "Address is Required";
    }

    return { isValid: Object.keys(errors).length === 0, errors };
  },

  // 1.6 Creating Sales Invoices - Bill Details (Step 1)
  validateInvoiceBillDetails({ billDate, clientName }) {
    const errors = {};
    if (!billDate || !billDate.trim()) {
      errors.billDate = "BILL DATE is Required";
    }
    if (!clientName || !clientName.trim()) {
      errors.clientName = "CLIENT NAME is Required";
    }
    return { isValid: Object.keys(errors).length === 0, errors };
  },

  // 1.6 Creating Sales Invoices - Add Item (Step 2)
  validateInvoiceAddItem({ itemName, quantity }) {
    const errors = {};
    if (!itemName || !itemName.trim()) {
      errors.itemName = "ITEM NAME is Required";
    }

    const qty = parseFloat(quantity);
    if (quantity === undefined || quantity === null || String(quantity).trim() === '') {
      errors.quantity = "Quantity is Required";
    } else if (isNaN(qty) || qty <= 0) {
      errors.quantity = "Quantity Must be Greater than Zero";
    }

    return { isValid: Object.keys(errors).length === 0, errors };
  },

  // 1.6 Creating Sales Invoices - Financial Summary (Step 3)
  validateInvoiceSummary({ percentageDiscount, valueDiscount, paidUp, theNet }) {
    const errors = {};
    const pct = parseFloat(percentageDiscount);
    if (!isNaN(pct) && pct < 0) {
      errors.percentageDiscount = "Percentage discount Must be Greater than or equal Zero";
    }

    const val = parseFloat(valueDiscount);
    if (!isNaN(val) && val < 0) {
      errors.valueDiscount = "Value discount Must be Greater than or equal Zero";
    }

    const paid = parseFloat(paidUp);
    if (!isNaN(paid) && paid < 0) {
      errors.paidUp = "Paid Up Must be Greater than or equal Zero";
    }

    return { isValid: Object.keys(errors).length === 0, errors };
  },

  // 1.6 Request a Form (Step 4)
  validateRequestForm({ employeeName, date, startTime, endTime }) {
    const errors = {};
    if (!employeeName || !employeeName.trim()) {
      errors.employeeName = "Employee NAME is Required";
    }

    if (!date || !date.trim()) {
      errors.date = "DATE is Required";
    }

    if (!startTime) {
      errors.startTime = "Start Time is Required";
    }

    if (!endTime) {
      errors.endTime = "End Time is Required";
    } else if (startTime && endTime) {
      // Compare 24h or HH:MM times
      const sVal = this.timeToMinutes(startTime);
      const eVal = this.timeToMinutes(endTime);
      if (eVal <= sVal) {
        errors.endTime = "End Time must be greater than Start Time";
      }
    }

    return { isValid: Object.keys(errors).length === 0, errors };
  },

  timeToMinutes(timeStr) {
    if (!timeStr) return 0;
    // Handles "09:00", "09:00 AM", "17:00", "05:00 PM"
    const isPM = /PM/i.test(timeStr);
    const isAM = /AM/i.test(timeStr);
    const clean = timeStr.replace(/(AM|PM)/gi, '').trim();
    const parts = clean.split(':').map(Number);
    let hours = parts[0] || 0;
    const mins = parts[1] || 0;

    if (isPM && hours < 12) hours += 12;
    if (isAM && hours === 12) hours = 0;

    return hours * 60 + mins;
  }
};

window.Validator = Validator;
