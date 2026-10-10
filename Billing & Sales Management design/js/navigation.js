/* ==========================================================================
   NAVIGATION & ROUTER CONTROLLER
   Billing & Sales Management - Mobile UI/UX Design
   Manages history stack, transitions, header state, and bottom navigation.
   ========================================================================== */

const SCREEN_CONFIG = {
  splash: {
    title: "Splash",
    hideHeader: true,
    hideBottomNav: true,
    statusBarMode: "light-content",
    render: () => Screens.renderSplash(),
    init: (c) => Screens.initSplash(c)
  },
  onboarding: {
    title: "Onboarding",
    hideHeader: true,
    hideBottomNav: true,
    statusBarMode: "dark-content",
    render: () => Screens.renderOnboarding(),
    init: (c) => Screens.initOnboarding(c)
  },
  login: {
    title: "Sign In",
    hideHeader: true,
    hideBottomNav: true,
    statusBarMode: "dark-content",
    render: () => Screens.renderLogin(),
    init: (c) => Screens.initLogin(c)
  },
  signup: {
    title: "Create Account",
    hideHeader: true,
    hideBottomNav: true,
    statusBarMode: "dark-content",
    render: () => Screens.renderSignUp(),
    init: (c) => Screens.initSignUp(c)
  },
  forgotPassword: {
    title: "Reset Password",
    hideHeader: true,
    hideBottomNav: true,
    statusBarMode: "dark-content",
    render: () => Screens.renderForgotPassword(),
    init: (c) => Screens.initForgotPassword(c)
  },
  otp: {
    title: "Verification",
    hideHeader: true,
    hideBottomNav: true,
    statusBarMode: "dark-content",
    render: () => Screens.renderOTP(),
    init: (c) => Screens.initOTP(c)
  },
  dashboard: {
    title: "Billing & Sales",
    subtitle: "Management",
    hideHeader: true, // Has custom hero header
    hideBottomNav: false,
    activeNavTab: "home",
    statusBarMode: "dark-content",
    render: () => Screens.renderDashboard(),
    init: (c) => Screens.initDashboard(c)
  },
  companies: {
    title: "Companies",
    subtitle: "Supplier & Brand Catalog",
    showBack: true,
    hideBottomNav: false,
    activeNavTab: "more",
    statusBarMode: "dark-content",
    render: () => Screens.renderCompaniesList(),
    init: (c) => Screens.initCompanies(c)
  },
  types: {
    title: "Types",
    subtitle: "Item Classifications",
    showBack: true,
    hideBottomNav: false,
    activeNavTab: "more",
    statusBarMode: "dark-content",
    render: () => Screens.renderTypesList(),
    init: (c) => Screens.initTypes(c)
  },
  units: {
    title: "Units",
    subtitle: "Measurement & Packaging",
    showBack: true,
    hideBottomNav: false,
    activeNavTab: "more",
    statusBarMode: "dark-content",
    render: () => Screens.renderUnitsList(),
    init: (c) => Screens.initUnits(c)
  },
  categories: {
    title: "Categories",
    subtitle: "Product Grouping",
    showBack: true,
    hideBottomNav: false,
    activeNavTab: "more",
    statusBarMode: "dark-content",
    render: () => Screens.renderCategoriesList(),
    init: (c) => Screens.initCategories(c)
  },
  items: {
    title: "Items",
    subtitle: "Product Catalog",
    showBack: false,
    hideBottomNav: false,
    activeNavTab: "items",
    statusBarMode: "dark-content",
    render: () => Screens.renderItemsList(),
    init: (c) => Screens.initItems(c)
  },
  clients: {
    title: "Clients",
    subtitle: "Customer Database",
    showBack: false,
    hideBottomNav: false,
    activeNavTab: "clients",
    statusBarMode: "dark-content",
    render: () => Screens.renderClientsList(),
    init: (c) => Screens.initClients(c)
  },
  newInvoiceStep1: {
    title: "New Invoice",
    subtitle: "Step 1: Bill Details",
    showBack: true,
    hideBottomNav: true,
    statusBarMode: "dark-content",
    render: () => Screens.renderInvoiceStep1(),
    init: (c) => Screens.initInvoiceStep1(c)
  },
  newInvoiceAddItem: {
    title: "New Invoice",
    subtitle: "Step 2: Add Item",
    showBack: true,
    hideBottomNav: true,
    statusBarMode: "dark-content",
    render: () => Screens.renderInvoiceAddItem(),
    init: (c) => Screens.initInvoiceAddItem(c)
  },
  newInvoiceItemsList: {
    title: "New Invoice",
    subtitle: "Step 2: Items List",
    showBack: true,
    hideBottomNav: true,
    statusBarMode: "dark-content",
    render: () => Screens.renderInvoiceItemsList(),
    init: (c) => Screens.initInvoiceItemsList(c)
  },
  newInvoiceSummary: {
    title: "New Invoice",
    subtitle: "Step 3: Summary",
    showBack: true,
    hideBottomNav: true,
    statusBarMode: "dark-content",
    render: () => Screens.renderInvoiceSummary(),
    init: (c) => Screens.initInvoiceSummary(c)
  },
  invoiceDetails: {
    title: "Invoice Details",
    subtitle: "View Receipt",
    showBack: true,
    hideBottomNav: false,
    activeNavTab: "home",
    statusBarMode: "dark-content",
    render: (params) => Screens.renderInvoiceDetails(params),
    init: (c) => Screens.initInvoiceDetails(c)
  },
  requestForm: {
    title: "Request a Form",
    subtitle: "SRS Section 4 Work Request",
    showBack: true,
    hideBottomNav: false,
    activeNavTab: "more",
    statusBarMode: "dark-content",
    render: () => Screens.renderRequestForm(),
    init: (c) => Screens.initRequestForm(c)
  },
  reports: {
    title: "Sales Report",
    subtitle: "Period Breakdown",
    showBack: false,
    hideBottomNav: false,
    activeNavTab: "reports",
    statusBarMode: "dark-content",
    render: () => Screens.renderSalesReport(),
    init: (c) => Screens.initSalesReport(c)
  },
  more: {
    title: "More & Catalog",
    subtitle: "Master Data Management",
    showBack: false,
    hideBottomNav: false,
    activeNavTab: "more",
    statusBarMode: "dark-content",
    render: () => Screens.renderMoreHub(),
    init: (c) => Screens.initMoreHub(c)
  }
};

class NavigationController {
  constructor() {
    this.currentScreen = 'dashboard';
    this.screenHistory = [];
    this.currentParams = {};
  }

  init() {
    this.bindDOM();
    // Default to dashboard
    this.navigateTo('dashboard', false);
  }

  bindDOM() {
    // Top app bar back button
    const backBtn = document.getElementById('app-header-back-btn');
    if (backBtn) {
      backBtn.addEventListener('click', () => this.goBack());
    }

    // Bottom Navigation tabs
    const navHome = document.getElementById('nav-tab-home');
    const navClients = document.getElementById('nav-tab-clients');
    const navItems = document.getElementById('nav-tab-items');
    const navReports = document.getElementById('nav-tab-reports');
    const navMore = document.getElementById('nav-tab-more');
    const centerFab = document.getElementById('nav-tab-center-fab');

    if (navHome) navHome.addEventListener('click', () => this.navigateTo('dashboard'));
    if (navClients) navClients.addEventListener('click', () => this.navigateTo('clients'));
    if (navItems) navItems.addEventListener('click', () => this.navigateTo('items'));
    if (navReports) navReports.addEventListener('click', () => this.navigateTo('reports'));
    if (navMore) navMore.addEventListener('click', () => this.navigateTo('more'));
    if (centerFab) centerFab.addEventListener('click', () => this.navigateTo('newInvoiceStep1'));

    // Backdrop close for bottom sheet
    const sheetBackdrop = document.getElementById('app-bottom-sheet-backdrop');
    const sheetCloseBtn = document.getElementById('app-bottom-sheet-close-btn');

    if (sheetBackdrop) {
      sheetBackdrop.addEventListener('click', (e) => {
        if (e.target === sheetBackdrop) {
          BottomSheetManager.close();
        }
      });
    }
    if (sheetCloseBtn) {
      sheetCloseBtn.addEventListener('click', () => BottomSheetManager.close());
    }

    // Quick jump dropdown in designer toolbar
    const quickSelect = document.getElementById('designer-screen-select');
    if (quickSelect) {
      quickSelect.addEventListener('change', (e) => {
        this.navigateTo(e.target.value);
      });
    }
  }

  navigateTo(screenKey, pushHistory = true, params = {}) {
    const config = SCREEN_CONFIG[screenKey];
    if (!config) {
      console.error(`Screen "${screenKey}" not found in SCREEN_CONFIG`);
      return;
    }

    // Close any open bottom sheet
    BottomSheetManager.close();

    if (pushHistory && this.currentScreen && this.currentScreen !== screenKey) {
      this.screenHistory.push({ screen: this.currentScreen, params: this.currentParams });
    }

    this.currentScreen = screenKey;
    this.currentParams = params;

    // Synchronize quick-jump dropdown
    const quickSelect = document.getElementById('designer-screen-select');
    if (quickSelect && quickSelect.value !== screenKey) {
      quickSelect.value = screenKey;
    }

    // Update Status Bar Style
    const statusBar = document.getElementById('mobile-status-bar');
    if (statusBar) {
      statusBar.className = `mobile-status-bar ${config.statusBarMode || 'dark-content'}`;
    }

    // Update Header
    const appHeader = document.getElementById('mobile-app-header');
    const headerTitle = document.getElementById('app-header-title');
    const headerSubtitle = document.getElementById('app-header-subtitle');
    const backBtn = document.getElementById('app-header-back-btn');

    if (config.hideHeader) {
      appHeader.classList.add('hidden');
    } else {
      appHeader.classList.remove('hidden');
      headerTitle.textContent = config.title;
      if (config.subtitle) {
        headerSubtitle.textContent = config.subtitle;
        headerSubtitle.classList.remove('hidden');
      } else {
        headerSubtitle.classList.add('hidden');
      }

      if (config.showBack) {
        backBtn.classList.remove('hidden');
      } else {
        backBtn.classList.add('hidden');
      }
    }

    // Update Bottom Navigation Bar
    const bottomNav = document.getElementById('mobile-bottom-nav');
    const scrollContainer = document.getElementById('screen-scroll-container');

    if (config.hideBottomNav) {
      bottomNav.classList.add('hidden');
      scrollContainer.classList.add('no-nav');
    } else {
      bottomNav.classList.remove('hidden');
      scrollContainer.classList.remove('no-nav');

      // Update active tab highlight
      document.querySelectorAll('.nav-tab-item').forEach(tab => tab.classList.remove('active'));
      if (config.activeNavTab) {
        const activeEl = document.getElementById(`nav-tab-${config.activeNavTab}`);
        if (activeEl) activeEl.classList.add('active');
      }
    }

    // Render screen HTML into viewport
    const contentHtml = config.render(params);
    scrollContainer.innerHTML = contentHtml;

    // Reset scroll position to top
    scrollContainer.scrollTop = 0;

    // Initialize screen interactive handlers
    if (typeof config.init === 'function') {
      config.init(scrollContainer);
    }
  }

  goBack() {
    if (this.screenHistory.length > 0) {
      const prev = this.screenHistory.pop();
      this.navigateTo(prev.screen, false, prev.params);
    } else {
      this.navigateTo('dashboard', false);
    }
  }
}

window.Navigation = new NavigationController();
