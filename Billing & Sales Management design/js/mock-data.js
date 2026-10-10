/* ==========================================================================
   MOCK DATA STORE
   Billing & Sales Management - Mobile UI/UX Design
   Initializes and provides reactive datasets for all SRS modules.
   ========================================================================== */

const INITIAL_DATA = {
  user: {
    name: "Ahmed",
    role: "Admin",
    email: "ahmed@business.com",
    avatar: "AH"
  },

  companies: [
    { id: 1, name: "Dell", notes: "Computer & Accessories, Laptops and Desktops", icon: "laptop" },
    { id: 2, name: "HP", notes: "Computers & Printers, Ink and Cartridges", icon: "printer" },
    { id: 3, name: "Apple", notes: "Premium Electronics, MacBooks, iPads and Displays", icon: "monitor" },
    { id: 4, name: "Lenovo", notes: "ThinkPad Computers and Office Workstations", icon: "box" },
    { id: 5, name: "Asus", notes: "Gaming hardware and ultra-portable laptops", icon: "laptop" },
    { id: 6, name: "Samsung", notes: "Monitors, Displays and Storage memory", icon: "monitor" },
    { id: 7, name: "Logitech", notes: "Peripherals, Keyboards, Mice and Webcams", icon: "accessories" }
  ],

  types: [
    { id: 1, company: "Dell", name: "Laptops", notes: "Consumer and Enterprise laptops" },
    { id: 2, company: "Samsung", name: "Monitors", notes: "OLED and IPS Displays" },
    { id: 3, company: "HP", name: "Printers", notes: "Laser and InkJet multi-function" },
    { id: 4, company: "Logitech", name: "Keyboards", notes: "Mechanical and wireless membrane" },
    { id: 5, company: "Logitech", name: "Mice", notes: "Ergonomic and high precision mice" },
    { id: 6, company: "Apple", name: "Accessories", notes: "Docks, adaptors, and chargers" }
  ],

  units: [
    { id: 1, name: "Piece (pcs)", notes: "Standard individual unit count" },
    { id: 2, name: "Box", notes: "Packaged box of items" },
    { id: 3, name: "Kg", notes: "Kilograms for bulk weight items" },
    { id: 4, name: "Meter", notes: "Length measurement for cables" },
    { id: 5, name: "Liter", notes: "Liquid volume measurement" }
  ],

  categories: [
    { id: 1, name: "Electronics", notes: "Broad electronic devices" },
    { id: 2, name: "Computers", notes: "Workstations, PC Towers and Laptops" },
    { id: 3, name: "Accessories", notes: "Peripherals and auxiliary hardware" },
    { id: 4, name: "Office Supplies", notes: "Printing paper, stationery and desk gear" },
    { id: 5, name: "Others", notes: "Miscellaneous inventory" }
  ],

  items: [
    {
      id: 1,
      code: "ITM-001",
      name: "Laptop Dell",
      company: "Dell",
      type: "Laptops",
      unit: "Piece (pcs)",
      sellingPrice: 15000,
      buyingPrice: 12500,
      notes: "Core i7, 16GB RAM, 512GB SSD"
    },
    {
      id: 2,
      code: "ITM-002",
      name: "Mouse Logitech",
      company: "Logitech",
      type: "Mice",
      unit: "Piece (pcs)",
      sellingPrice: 250,
      buyingPrice: 180,
      notes: "Wireless 2.4GHz with nano receiver"
    },
    {
      id: 3,
      code: "ITM-003",
      name: "Keyboard",
      company: "Logitech",
      type: "Keyboards",
      unit: "Piece (pcs)",
      sellingPrice: 400,
      buyingPrice: 300,
      notes: "Slim profile quiet keyboard"
    },
    {
      id: 4,
      code: "ITM-004",
      name: "Monitor 24\"",
      company: "Samsung",
      type: "Monitors",
      unit: "Piece (pcs)",
      sellingPrice: 3500,
      buyingPrice: 2900,
      notes: "Full HD 75Hz borderless display"
    },
    {
      id: 5,
      code: "ITM-005",
      name: "Printer HP",
      company: "HP",
      type: "Printers",
      unit: "Piece (pcs)",
      sellingPrice: 4200,
      buyingPrice: 3600,
      notes: "LaserJet Pro wireless printer"
    },
    {
      id: 6,
      code: "ITM-006",
      name: "MacBook Air",
      company: "Apple",
      type: "Laptops",
      unit: "Piece (pcs)",
      sellingPrice: 48000,
      buyingPrice: 42000,
      notes: "M2 Chip, 13.6-inch Retina Liquid Display"
    }
  ],

  clients: [
    {
      id: 1,
      number: 1025,
      name: "Ahmed Ali",
      phone: "01123456789",
      address: "12 Al-Noor St, Nasr City, Cairo",
      initials: "AA"
    },
    {
      id: 2,
      number: 1026,
      name: "Mohamed Tarek",
      phone: "01098765432",
      address: "44 Tahrir St, Dokki, Giza",
      initials: "MT"
    },
    {
      id: 3,
      number: 1027,
      name: "Sara Sameh",
      phone: "01234567890",
      address: "8 Palestine St, Maadi, Cairo",
      initials: "SS"
    },
    {
      id: 4,
      number: 1028,
      name: "Mostafa Adel",
      phone: "01122233344",
      address: "22 El-Haram St, Giza",
      initials: "MA"
    },
    {
      id: 5,
      number: 1029,
      name: "Nourhan Zaki",
      phone: "01022534455",
      address: "15 Abbasia Sq, Cairo",
      initials: "NZ"
    }
  ],

  invoices: [
    {
      id: 1044,
      billNumber: 1044,
      billDate: "2026-04-10",
      clientName: "Ahmed Ali",
      items: [
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
        }
      ],
      billsTotal: 31250,
      percentageDiscount: 0,
      valueDiscount: 0,
      theNet: 31250,
      paidUp: 31250,
      theRest: 0,
      status: "Paid"
    },
    {
      id: 1043,
      billNumber: 1043,
      billDate: "2026-04-08",
      clientName: "Mohamed Tarek",
      items: [
        {
          code: "ITM-003",
          name: "Keyboard",
          unit: "Piece",
          sellingPrice: 400,
          quantity: 6,
          discount: 0,
          total: 2400
        }
      ],
      billsTotal: 2400,
      percentageDiscount: 0,
      valueDiscount: 0,
      theNet: 2400,
      paidUp: 1000,
      theRest: 1400,
      status: "Unpaid"
    },
    {
      id: 1042,
      billNumber: 1042,
      billDate: "2026-04-05",
      clientName: "Sara Sameh",
      items: [
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
      paidUp: 32450,
      theRest: 0,
      status: "Paid"
    }
  ],

  employees: [
    { id: 1, name: "Ahmed Hassan" },
    { id: 2, name: "Mariam Youssef" },
    { id: 3, name: "Karim Adel" },
    { id: 4, name: "Nada Sherif" }
  ],

  requests: [
    {
      id: 1,
      employeeName: "Ahmed Hassan",
      date: "2026-04-10",
      startTime: "09:00 AM",
      endTime: "05:00 PM",
      status: "Approved"
    }
  ]
};

// Data Store Manager
class DataStore {
  constructor() {
    this.storageKey = 'billing_sales_mgmt_data_v1';
    this.state = this.loadData();
  }

  loadData() {
    try {
      const stored = localStorage.getItem(this.storageKey);
      if (stored) {
        return JSON.parse(stored);
      }
    } catch (e) {
      console.warn("Could not load from localStorage, using defaults", e);
    }
    return JSON.parse(JSON.stringify(INITIAL_DATA));
  }

  saveData() {
    try {
      localStorage.setItem(this.storageKey, JSON.stringify(this.state));
    } catch (e) {
      console.error("Failed to save to localStorage", e);
    }
  }

  resetToDefaults() {
    this.state = JSON.parse(JSON.stringify(INITIAL_DATA));
    this.saveData();
  }

  // Auto-generation helpers
  getNextClientNumber() {
    if (!this.state.clients || this.state.clients.length === 0) return 1001;
    const maxNum = Math.max(...this.state.clients.map(c => c.number || 0));
    return maxNum + 1;
  }

  getNextBillNumber() {
    if (!this.state.invoices || this.state.invoices.length === 0) return 1001;
    const maxNum = Math.max(...this.state.invoices.map(i => i.billNumber || 0));
    return maxNum + 1;
  }

  getNextItemCode() {
    const count = (this.state.items ? this.state.items.length : 0) + 1;
    return `ITM-${String(count).padStart(3, '0')}`;
  }
}

// Global shared data store instance
window.appStore = new DataStore();
