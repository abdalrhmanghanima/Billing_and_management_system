/* ==========================================================================
   SCREEN RENDERERS & EVENT HANDLERS
   Billing & Sales Management - Mobile UI/UX Design
   Complete screen definitions and interactivity covering all SRS flows.
   ========================================================================== */

const Screens = {
  // Current active view state: 'populated', 'loading', 'empty', 'error'
  uiState: 'populated',

  setUIState(state) {
    this.uiState = state;
    // Re-render current screen with state applied
    if (window.Navigation && window.Navigation.currentScreen) {
      window.Navigation.navigateTo(window.Navigation.currentScreen, false);
    }
  },

  // ------------------------------------------------------------------------
  // 1. Splash Screen
  // ------------------------------------------------------------------------
  renderSplash() {
    return `
      <div class="screen-splash" id="screen-splash">
        <div class="splash-wave-decor"></div>
        <div class="splash-center-content">
          <div class="splash-logo-container">
            <img src="assets/app_logo.png" alt="Billing & Sales Management Logo" />
          </div>
          <h1 class="splash-title">Billing & Sales<br/>Management</h1>
          <p class="splash-subtitle">Manage your business easily and efficiently</p>
        </div>
        <div class="splash-loader-dots">
          <div class="splash-dot"></div>
          <div class="splash-dot active"></div>
          <div class="splash-dot"></div>
        </div>
      </div>
    `;
  },

  initSplash(container) {
    container.addEventListener('click', () => {
      window.Navigation.navigateTo('onboarding');
    });
  },

  // ------------------------------------------------------------------------
  // 2. Onboarding Screen
  // ------------------------------------------------------------------------
  renderOnboarding() {
    return `
      <div class="screen-onboarding" id="screen-onboarding">
        <div style="display: flex; justify-content: flex-end; width: 100%;">
          <button class="btn-sm btn-secondary" id="btn-skip-onboarding" style="border: none; background: transparent; color: var(--neutral-500);">Skip</button>
        </div>
        <div style="display: flex; flex-direction: column; align-items: center; margin-top: auto; margin-bottom: auto;">
          <div class="onboarding-top-logo">
            <img src="assets/app_logo.png" alt="App Logo" />
          </div>
          <h2 class="onboarding-hero-title">Billing & Sales<br/>Management</h2>
          <h4 style="color: var(--primary); font-size: var(--font-size-md); font-weight: 700; margin-bottom: 8px;">All your business in one place</h4>
          <p class="onboarding-hero-desc">Manage companies, items, clients, invoices and more with simple and powerful tools.</p>
          <div class="onboarding-pagination">
            <div class="onboarding-page-dot"></div>
            <div class="onboarding-page-dot active"></div>
            <div class="onboarding-page-dot"></div>
          </div>
        </div>
        <div style="width: 100%; display: flex; justify-content: center;">
          <button class="onboarding-next-btn" id="btn-onboarding-next" aria-label="Next">
            ${Icons.arrowRight()}
          </button>
        </div>
      </div>
    `;
  },

  initOnboarding(container) {
    const nextBtn = container.querySelector('#btn-onboarding-next');
    const skipBtn = container.querySelector('#btn-skip-onboarding');

    if (nextBtn) nextBtn.addEventListener('click', () => window.Navigation.navigateTo('login'));
    if (skipBtn) skipBtn.addEventListener('click', () => window.Navigation.navigateTo('login'));
  },

  // ------------------------------------------------------------------------
  // 3. Login Screen
  // ------------------------------------------------------------------------
  renderLogin() {
    return `
      <div class="screen-auth" id="screen-login">
        <div class="auth-header" style="text-align: center; margin-top: 20px;">
          <div style="width: 68px; height: 68px; margin: 0 auto 16px; border-radius: 50%; box-shadow: var(--shadow-sm); padding: 4px; background: #fff;">
            <img src="assets/app_logo.png" alt="Logo" style="width: 100%; height: 100%; object-fit: contain;" />
          </div>
          <h2 class="auth-title">Welcome Back</h2>
          <p class="auth-subtitle">Sign in to continue</p>
        </div>

        <form id="form-login" novalidate style="margin-top: 10px;">
          <div class="form-group">
            <label class="form-label" for="login-email">Email</label>
            <div class="input-wrapper">
              <span class="input-prefix" style="left: 14px;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
              </span>
              <input type="email" id="login-email" class="input-field" placeholder="Enter your email" value="ahmed@business.com" />
            </div>
          </div>

          <div class="form-group">
            <label class="form-label" for="login-password">Password</label>
            <div class="input-wrapper">
              <span class="input-prefix" style="left: 14px;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
              </span>
              <input type="password" id="login-password" class="input-field" placeholder="Enter password" value="password123" />
              <button type="button" class="input-suffix input-suffix-btn" id="btn-toggle-password" aria-label="Toggle password">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></svg>
              </button>
            </div>
            <div style="text-align: right; margin-top: 6px;">
              <a href="javascript:void(0)" id="link-forgot-pass" style="font-size: var(--font-size-xs); font-weight: var(--font-weight-semibold); color: var(--primary);">Forgot Password?</a>
            </div>
          </div>

          <button type="submit" class="btn btn-primary" id="btn-submit-login" style="margin-top: 14px;">Sign In</button>
        </form>

        <div class="auth-footer-prompt">
          Don't have an account? <a href="javascript:void(0)" id="link-go-signup">Sign Up</a>
        </div>
      </div>
    `;
  },

  initLogin(container) {
    const form = container.querySelector('#form-login');
    const pwdInput = container.querySelector('#login-password');
    const togglePwd = container.querySelector('#btn-toggle-password');
    const forgotLink = container.querySelector('#link-forgot-pass');
    const signupLink = container.querySelector('#link-go-signup');

    if (togglePwd && pwdInput) {
      togglePwd.addEventListener('click', () => {
        pwdInput.type = pwdInput.type === 'password' ? 'text' : 'password';
      });
    }

    if (forgotLink) forgotLink.addEventListener('click', () => window.Navigation.navigateTo('forgotPassword'));
    if (signupLink) signupLink.addEventListener('click', () => window.Navigation.navigateTo('signup'));

    if (form) {
      form.addEventListener('submit', (e) => {
        e.preventDefault();
        const email = container.querySelector('#login-email').value;
        const pass = pwdInput.value;

        if (!email) {
          UI.showFieldError(container.querySelector('#login-email'), "Email is required");
          return;
        }
        if (!pass) {
          UI.showFieldError(pwdInput, "Password is required");
          return;
        }

        ToastManager.show("Welcome back, Ahmed!");
        window.Navigation.navigateTo('dashboard');
      });
    }
  },

  // ------------------------------------------------------------------------
  // 4. Sign Up Screen
  // ------------------------------------------------------------------------
  renderSignUp() {
    return `
      <div class="screen-auth" id="screen-signup">
        <div style="margin-bottom: 16px;">
          <button class="header-action-btn" id="btn-signup-back" style="margin-left: -8px;">${Icons.chevronLeft()}</button>
        </div>
        <div class="auth-header">
          <h2 class="auth-title">Create Account</h2>
          <p class="auth-subtitle">Join Billing & Sales Management</p>
        </div>

        <form id="form-signup" novalidate>
          <div class="form-group">
            <label class="form-label" for="signup-name">Full Name <span class="required-star">*</span></label>
            <input type="text" id="signup-name" class="input-field" placeholder="e.g. Ahmed Ali" />
          </div>

          <div class="form-group">
            <label class="form-label" for="signup-email">Email <span class="required-star">*</span></label>
            <input type="email" id="signup-email" class="input-field" placeholder="e.g. name@company.com" />
          </div>

          <div class="form-group">
            <label class="form-label" for="signup-password">Password <span class="required-star">*</span></label>
            <input type="password" id="signup-password" class="input-field" placeholder="Min. 8 characters" />
          </div>

          <button type="submit" class="btn btn-primary" style="margin-top: 16px;">Create Account</button>
        </form>

        <div class="auth-footer-prompt">
          Already have an account? <a href="javascript:void(0)" id="link-go-login">Sign In</a>
        </div>
      </div>
    `;
  },

  initSignUp(container) {
    const backBtn = container.querySelector('#btn-signup-back');
    const loginLink = container.querySelector('#link-go-login');
    const form = container.querySelector('#form-signup');

    if (backBtn) backBtn.addEventListener('click', () => window.Navigation.goBack());
    if (loginLink) loginLink.addEventListener('click', () => window.Navigation.navigateTo('login'));

    if (form) {
      form.addEventListener('submit', (e) => {
        e.preventDefault();
        UI.clearFieldErrors(form);

        const name = container.querySelector('#signup-name').value;
        const email = container.querySelector('#signup-email').value;
        const pass = container.querySelector('#signup-password').value;

        let hasError = false;
        if (!name.trim()) {
          UI.showFieldError(container.querySelector('#signup-name'), "Full name is required");
          hasError = true;
        }
        if (!email.trim()) {
          UI.showFieldError(container.querySelector('#signup-email'), "Email is required");
          hasError = true;
        }
        if (!pass.trim() || pass.length < 6) {
          UI.showFieldError(container.querySelector('#signup-password'), "Password must be at least 6 characters");
          hasError = true;
        }

        if (!hasError) {
          ToastManager.show("Account created! Verify your code.");
          window.Navigation.navigateTo('otp');
        }
      });
    }
  },

  // ------------------------------------------------------------------------
  // 5. Forgot Password & 6. OTP Screen
  // ------------------------------------------------------------------------
  renderForgotPassword() {
    return `
      <div class="screen-auth" id="screen-forgot-pwd">
        <div style="margin-bottom: 16px;">
          <button class="header-action-btn" id="btn-forgot-back" style="margin-left: -8px;">${Icons.chevronLeft()}</button>
        </div>
        <div class="auth-header">
          <h2 class="auth-title">Reset Password</h2>
          <p class="auth-subtitle">Enter your registered email address to receive a verification code.</p>
        </div>

        <form id="form-forgot-pwd" novalidate style="margin-top: 10px;">
          <div class="form-group">
            <label class="form-label" for="reset-email">Email Address <span class="required-star">*</span></label>
            <input type="email" id="reset-email" class="input-field" placeholder="name@company.com" value="ahmed@business.com" />
          </div>

          <button type="submit" class="btn btn-primary" style="margin-top: 16px;">Send Verification Code</button>
        </form>
      </div>
    `;
  },

  initForgotPassword(container) {
    const backBtn = container.querySelector('#btn-forgot-back');
    const form = container.querySelector('#form-forgot-pwd');

    if (backBtn) backBtn.addEventListener('click', () => window.Navigation.goBack());
    if (form) {
      form.addEventListener('submit', (e) => {
        e.preventDefault();
        ToastManager.show("Verification code sent to your email!");
        window.Navigation.navigateTo('otp');
      });
    }
  },

  renderOTP() {
    return `
      <div class="screen-auth" id="screen-otp">
        <div style="margin-bottom: 16px;">
          <button class="header-action-btn" id="btn-otp-back" style="margin-left: -8px;">${Icons.chevronLeft()}</button>
        </div>
        <div class="auth-header text-center">
          <h2 class="auth-title">Verify Code</h2>
          <p class="auth-subtitle">We sent a 4-digit code to ahmed@business.com</p>
        </div>

        <div class="otp-inputs-row">
          <input type="text" maxlength="1" class="otp-box" value="4" />
          <input type="text" maxlength="1" class="otp-box" value="9" />
          <input type="text" maxlength="1" class="otp-box" value="2" />
          <input type="text" maxlength="1" class="otp-box" value="8" />
        </div>

        <button type="button" class="btn btn-primary" id="btn-verify-otp" style="margin-top: 10px;">Verify & Continue</button>

        <div class="auth-footer-prompt">
          Didn't receive code? <a href="javascript:void(0)" id="link-resend-otp">Resend in 0:45</a>
        </div>
      </div>
    `;
  },

  initOTP(container) {
    const backBtn = container.querySelector('#btn-otp-back');
    const verifyBtn = container.querySelector('#btn-verify-otp');
    if (backBtn) backBtn.addEventListener('click', () => window.Navigation.goBack());
    if (verifyBtn) {
      verifyBtn.addEventListener('click', () => {
        ToastManager.show("Verification confirmed!");
        window.Navigation.navigateTo('dashboard');
      });
    }
  },

  // ------------------------------------------------------------------------
  // 7. Home / Dashboard Screen
  // ------------------------------------------------------------------------
  renderDashboard() {
    const state = window.appStore.state;
    const invoiceCount = state.invoices ? state.invoices.length : 0;
    const clientCount = state.clients ? state.clients.length : 0;

    return `
      <div class="screen-dashboard" id="screen-dashboard">
        <!-- Dashboard Hero Header -->
        <div class="dashboard-hero">
          <div class="dashboard-hero-left">
            <div class="dashboard-greeting">Good day 👋</div>
            <h1 class="dashboard-title">Billing &amp; Sales</h1>
          </div>
          <div class="dashboard-hero-right">
            <button class="icon-btn" id="btn-bell" aria-label="Notifications">
              ${Icons.bell()}
            </button>
          </div>
        </div>

        <!-- Summary Stats Row -->
        <div class="dashboard-stats-row">
          <div class="stat-chip">
            <span class="stat-chip-value">${invoiceCount}</span>
            <span class="stat-chip-label">Invoices</span>
          </div>
          <div class="stat-chip">
            <span class="stat-chip-value">${clientCount}</span>
            <span class="stat-chip-label">Clients</span>
          </div>
          <div class="stat-chip">
            <span class="stat-chip-value">${state.items ? state.items.length : 0}</span>
            <span class="stat-chip-label">Items</span>
          </div>
        </div>

        <!-- Quick Actions 2x2 Grid -->
        <div class="quick-actions-grid">
          <div class="action-card" id="card-action-new-invoice">
            <div class="action-card-icon coral-bg">
              ${Icons.invoice()}
            </div>
            <div class="action-card-title">New Invoice</div>
          </div>

          <div class="action-card" id="card-action-add-client">
            <div class="action-card-icon cyan-bg">
              ${Icons.clients()}
            </div>
            <div class="action-card-title">Add Client</div>
          </div>

          <div class="action-card" id="card-action-add-item">
            <div class="action-card-icon teal-bg">
              ${Icons.items()}
            </div>
            <div class="action-card-title">Add Item</div>
          </div>

          <div class="action-card" id="card-action-reports">
            <div class="action-card-icon purple-bg">
              ${Icons.report()}
            </div>
            <div class="action-card-title">Sales Report</div>
          </div>
        </div>

        <!-- Recent Invoices List -->
        <div class="section-header">
          <h3>Recent Invoices</h3>
          <a href="javascript:void(0)" id="link-see-all-invoices">See All</a>
        </div>

        <div class="recent-invoices-list" id="dashboard-recent-invoices">
          ${this.renderRecentInvoicesList(state.invoices)}
        </div>
      </div>
    `;
  },

  renderRecentInvoicesList(invoices) {
    if (this.uiState === 'loading') {
      return UI.createSkeletonList(3);
    }
    if (this.uiState === 'empty' || !invoices || invoices.length === 0) {
      return UI.createEmptyState({
        icon: Icons.invoice(),
        title: "No Invoices Yet",
        desc: "Create your first sales invoice to see it listed here.",
        actionText: "+ Create Invoice",
        actionId: "btn-empty-create-invoice"
      });
    }

    return invoices.slice(0, 5).map(inv => {
      const isPaid = inv.status === 'Paid';
      const badgeClass = isPaid ? 'badge-paid' : 'badge-unpaid';

      return `
        <div class="recent-invoice-card" data-invoice-id="${inv.id}">
          <div class="recent-invoice-left">
            <div class="invoice-icon-badge">#${inv.billNumber}</div>
            <div>
              <div class="recent-invoice-title">${inv.clientName}</div>
              <div class="recent-invoice-date">${inv.billDate}</div>
            </div>
          </div>
          <div class="recent-invoice-right">
            <div class="recent-invoice-amount">${InvoiceManager.formatCurrency(inv.billsTotal)}</div>
            <span class="badge ${badgeClass}">${inv.status}</span>
          </div>
        </div>
      `;
    }).join('');
  },

  initDashboard(container) {
    const newInv = container.querySelector('#card-action-new-invoice');
    const addClient = container.querySelector('#card-action-add-client');
    const addItem = container.querySelector('#card-action-add-item');
    const report = container.querySelector('#card-action-reports');
    const seeAll = container.querySelector('#link-see-all-invoices');
    const bellBtn = container.querySelector('#btn-bell');

    if (newInv) newInv.addEventListener('click', () => window.Navigation.navigateTo('newInvoiceStep1'));
    if (addClient) addClient.addEventListener('click', () => Screens.openAddClientSheet());
    if (addItem) addItem.addEventListener('click', () => Screens.openAddItemSheet());
    if (report) report.addEventListener('click', () => window.Navigation.navigateTo('reports'));
    if (seeAll) seeAll.addEventListener('click', () => window.Navigation.navigateTo('reports'));
    if (bellBtn) {
      bellBtn.addEventListener('click', () => ToastManager.show("No new notifications at this time."));
    }

    // Invoice cards click to inspect invoice
    container.querySelectorAll('.recent-invoice-card').forEach(card => {
      card.addEventListener('click', () => {
        const id = card.getAttribute('data-invoice-id');
        window.Navigation.navigateTo('invoiceDetails', true, { invoiceId: id });
      });
    });

    const emptyBtn = container.querySelector('#btn-empty-create-invoice');
    if (emptyBtn) emptyBtn.addEventListener('click', () => window.Navigation.navigateTo('newInvoiceStep1'));
  },

  // ------------------------------------------------------------------------
  // 8. Master Data: Companies List & Add Company
  // ------------------------------------------------------------------------
  renderCompaniesList() {
    const list = window.appStore.state.companies;

    return `
      <div class="screen-content-padded" id="screen-companies">
        <div class="search-filter-row">
          <div class="search-box">
            <span class="search-icon">${Icons.search()}</span>
            <input type="text" id="search-companies-input" placeholder="Search companies..." />
          </div>
          <button class="filter-btn" id="btn-filter-companies" aria-label="Filter">${Icons.filter()}</button>
        </div>

        <div class="entity-card-list" id="companies-container">
          ${this.renderCompanyCards(list)}
        </div>

        <button class="fab-add" id="fab-add-company" aria-label="Add Company">
          ${Icons.plus()}
        </button>
      </div>
    `;
  },

  renderCompanyCards(list) {
    if (this.uiState === 'loading') return UI.createSkeletonList(4);
    if (this.uiState === 'empty' || !list || list.length === 0) {
      return UI.createEmptyState({
        icon: Icons.company(),
        title: "No Companies Added",
        desc: "Add your supplier or brand companies here.",
        actionText: "+ Add Company",
        actionId: "btn-empty-add-company"
      });
    }

    return list.map(c => `
      <div class="entity-card" data-company-id="${c.id}">
        <div class="entity-card-left">
          <div class="entity-avatar cyan-avatar">
            ${Icons.company()}
          </div>
          <div class="entity-info">
            <div class="entity-title">${c.name}</div>
            <div class="entity-subtitle truncate" style="max-width: 220px;">${c.notes || 'No description notes'}</div>
          </div>
        </div>
        <div class="entity-card-right">
          <span class="chevron-icon">${Icons.chevronRight()}</span>
        </div>
      </div>
    `).join('');
  },

  initCompanies(container) {
    const fab = container.querySelector('#fab-add-company');
    if (fab) fab.addEventListener('click', () => Screens.openAddCompanySheet());

    const emptyBtn = container.querySelector('#btn-empty-add-company');
    if (emptyBtn) emptyBtn.addEventListener('click', () => Screens.openAddCompanySheet());

    const searchInput = container.querySelector('#search-companies-input');
    if (searchInput) {
      searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        const filtered = window.appStore.state.companies.filter(c =>
          c.name.toLowerCase().includes(query) || (c.notes && c.notes.toLowerCase().includes(query))
        );
        container.querySelector('#companies-container').innerHTML = Screens.renderCompanyCards(filtered);
      });
    }
  },

  openAddCompanySheet() {
    const html = `
      <div class="entity-icon-header-badge cyan-avatar">
        ${Icons.company()}
      </div>
      <form id="form-add-company" novalidate>
        <div class="form-group">
          <label class="form-label" for="sheet-company-name">Company Name <span class="required-star">*</span></label>
          <input type="text" id="sheet-company-name" class="input-field" placeholder="Enter company name" />
        </div>

        <div class="form-group">
          <label class="form-label" for="sheet-company-notes">Notes</label>
          <textarea id="sheet-company-notes" class="input-field" placeholder="Enter notes (optional)"></textarea>
        </div>

        <button type="submit" class="btn btn-primary" style="margin-top: 12px;" id="btn-save-company">Save Company</button>
      </form>
    `;

    BottomSheetManager.open({
      title: "Add Company",
      contentHtml: html,
      onRender: (sheetBody) => {
        const form = sheetBody.querySelector('#form-add-company');
        form.addEventListener('submit', (e) => {
          e.preventDefault();
          UI.clearFieldErrors(form);

          const nameInput = form.querySelector('#sheet-company-name');
          const notesInput = form.querySelector('#sheet-company-notes');

          const validation = Validator.validateCompany({
            name: nameInput.value,
            existingList: window.appStore.state.companies
          });

          if (!validation.isValid) {
            if (validation.errors.name) {
              UI.showFieldError(nameInput, validation.errors.name);
            }
            return;
          }

          // Save Company
          const newCompany = {
            id: Date.now(),
            name: nameInput.value.trim(),
            notes: notesInput.value.trim()
          };
          window.appStore.state.companies.push(newCompany);
          window.appStore.saveData();

          BottomSheetManager.close();
          // CRITICAL: Snackbar must be visible above sheets and nav!
          ToastManager.show(`Company "${newCompany.name}" saved successfully!`);

          // Refresh view if on companies screen
          if (window.Navigation.currentScreen === 'companies') {
            window.Navigation.navigateTo('companies', false);
          }
        });
      }
    });
  },

  // ------------------------------------------------------------------------
  // 9. Master Data: Types List & Add Type
  // ------------------------------------------------------------------------
  renderTypesList() {
    const list = window.appStore.state.types;

    return `
      <div class="screen-content-padded" id="screen-types">
        <div class="search-filter-row">
          <div class="search-box">
            <span class="search-icon">${Icons.search()}</span>
            <input type="text" id="search-types-input" placeholder="Search types..." />
          </div>
          <button class="filter-btn" id="btn-filter-types" aria-label="Filter">${Icons.filter()}</button>
        </div>

        <div class="entity-card-list" id="types-container">
          ${this.renderTypeCards(list)}
        </div>

        <button class="fab-add" id="fab-add-type" aria-label="Add Type">
          ${Icons.plus()}
        </button>
      </div>
    `;
  },

  renderTypeCards(list) {
    if (this.uiState === 'loading') return UI.createSkeletonList(4);
    if (this.uiState === 'empty' || !list || list.length === 0) {
      return UI.createEmptyState({
        icon: Icons.type(),
        title: "No Types Found",
        desc: "Create item categories/types under companies.",
        actionText: "+ Add Type",
        actionId: "btn-empty-add-type"
      });
    }

    return list.map(t => `
      <div class="entity-card" data-type-id="${t.id}">
        <div class="entity-card-left">
          <div class="entity-avatar teal-avatar">
            ${Icons.type()}
          </div>
          <div class="entity-info">
            <div class="entity-title">${t.name}</div>
            <div class="entity-subtitle">${t.company}</div>
          </div>
        </div>
        <div class="entity-card-right">
          <span class="chevron-icon">${Icons.chevronRight()}</span>
        </div>
      </div>
    `).join('');
  },

  initTypes(container) {
    const fab = container.querySelector('#fab-add-type');
    if (fab) fab.addEventListener('click', () => Screens.openAddTypeSheet());

    const emptyBtn = container.querySelector('#btn-empty-add-type');
    if (emptyBtn) emptyBtn.addEventListener('click', () => Screens.openAddTypeSheet());

    const searchInput = container.querySelector('#search-types-input');
    if (searchInput) {
      searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        const filtered = window.appStore.state.types.filter(t =>
          t.name.toLowerCase().includes(query) || t.company.toLowerCase().includes(query)
        );
        container.querySelector('#types-container').innerHTML = Screens.renderTypeCards(filtered);
      });
    }
  },

  openAddTypeSheet() {
    const companies = window.appStore.state.companies;
    const companyOptions = companies.map(c => `<option value="${c.name}">${c.name}</option>`).join('');

    const html = `
      <div class="entity-icon-header-badge">
        ${Icons.type()}
      </div>
      <form id="form-add-type" novalidate>
        <div class="form-group">
          <label class="form-label" for="sheet-type-company">Company Name <span class="required-star">*</span></label>
          <div class="select-wrapper">
            <select id="sheet-type-company" class="select-field">
              <option value="">Select company</option>
              ${companyOptions}
            </select>
            <span class="select-arrow">${Icons.chevronRight()}</span>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="sheet-type-name">Type Name <span class="required-star">*</span></label>
          <input type="text" id="sheet-type-name" class="input-field" placeholder="Enter type name" />
        </div>

        <div class="form-group">
          <label class="form-label" for="sheet-type-notes">Notes</label>
          <textarea id="sheet-type-notes" class="input-field" placeholder="Enter notes (optional)"></textarea>
        </div>

        <button type="submit" class="btn btn-primary" style="margin-top: 12px;" id="btn-save-type">Save Type</button>
      </form>
    `;

    BottomSheetManager.open({
      title: "Add Type",
      contentHtml: html,
      onRender: (sheetBody) => {
        const form = sheetBody.querySelector('#form-add-type');
        form.addEventListener('submit', (e) => {
          e.preventDefault();
          UI.clearFieldErrors(form);

          const companyInput = form.querySelector('#sheet-type-company');
          const typeInput = form.querySelector('#sheet-type-name');
          const notesInput = form.querySelector('#sheet-type-notes');

          const validation = Validator.validateType({
            companyName: companyInput.value,
            typeName: typeInput.value,
            existingList: window.appStore.state.types
          });

          if (!validation.isValid) {
            if (validation.errors.companyName) UI.showFieldError(companyInput, validation.errors.companyName);
            if (validation.errors.typeName) UI.showFieldError(typeInput, validation.errors.typeName);
            return;
          }

          const newType = {
            id: Date.now(),
            company: companyInput.value,
            name: typeInput.value.trim(),
            notes: notesInput.value.trim()
          };
          window.appStore.state.types.push(newType);
          window.appStore.saveData();

          BottomSheetManager.close();
          ToastManager.show(`Type "${newType.name}" saved successfully!`);

          if (window.Navigation.currentScreen === 'types') {
            window.Navigation.navigateTo('types', false);
          }
        });
      }
    });
  },

  // ------------------------------------------------------------------------
  // 10. Master Data: Units List & Add Unit
  // ------------------------------------------------------------------------
  renderUnitsList() {
    const list = window.appStore.state.units;

    return `
      <div class="screen-content-padded" id="screen-units">
        <div class="search-filter-row">
          <div class="search-box">
            <span class="search-icon">${Icons.search()}</span>
            <input type="text" id="search-units-input" placeholder="Search units..." />
          </div>
          <button class="filter-btn" id="btn-filter-units" aria-label="Filter">${Icons.filter()}</button>
        </div>

        <div class="entity-card-list" id="units-container">
          ${this.renderUnitCards(list)}
        </div>

        <button class="fab-add" id="fab-add-unit" aria-label="Add Unit">
          ${Icons.plus()}
        </button>
      </div>
    `;
  },

  renderUnitCards(list) {
    if (this.uiState === 'loading') return UI.createSkeletonList(4);
    if (this.uiState === 'empty' || !list || list.length === 0) {
      return UI.createEmptyState({
        icon: Icons.unit(),
        title: "No Units Defined",
        desc: "Define packaging units like Piece, Box, Kg, etc.",
        actionText: "+ Add Unit",
        actionId: "btn-empty-add-unit"
      });
    }

    return list.map(u => `
      <div class="entity-card" data-unit-id="${u.id}">
        <div class="entity-card-left">
          <div class="entity-avatar cyan-avatar">
            ${Icons.unit()}
          </div>
          <div class="entity-info">
            <div class="entity-title">${u.name}</div>
            <div class="entity-subtitle">${u.notes || 'Unit of measurement'}</div>
          </div>
        </div>
        <div class="entity-card-right">
          <span class="chevron-icon">${Icons.chevronRight()}</span>
        </div>
      </div>
    `).join('');
  },

  initUnits(container) {
    const fab = container.querySelector('#fab-add-unit');
    if (fab) fab.addEventListener('click', () => Screens.openAddUnitSheet());

    const emptyBtn = container.querySelector('#btn-empty-add-unit');
    if (emptyBtn) emptyBtn.addEventListener('click', () => Screens.openAddUnitSheet());

    const searchInput = container.querySelector('#search-units-input');
    if (searchInput) {
      searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        const filtered = window.appStore.state.units.filter(u =>
          u.name.toLowerCase().includes(query)
        );
        container.querySelector('#units-container').innerHTML = Screens.renderUnitCards(filtered);
      });
    }
  },

  openAddUnitSheet() {
    const html = `
      <div class="entity-icon-header-badge cyan-avatar">
        ${Icons.unit()}
      </div>
      <form id="form-add-unit" novalidate>
        <div class="form-group">
          <label class="form-label" for="sheet-unit-name">Unit Name <span class="required-star">*</span></label>
          <input type="text" id="sheet-unit-name" class="input-field" placeholder="Enter unit name (e.g. Piece)" />
        </div>

        <div class="form-group">
          <label class="form-label" for="sheet-unit-notes">Notes</label>
          <textarea id="sheet-unit-notes" class="input-field" placeholder="Enter notes (optional)"></textarea>
        </div>

        <button type="submit" class="btn btn-primary" style="margin-top: 12px;" id="btn-save-unit">Save Unit</button>
      </form>
    `;

    BottomSheetManager.open({
      title: "Add Unit",
      contentHtml: html,
      onRender: (sheetBody) => {
        const form = sheetBody.querySelector('#form-add-unit');
        form.addEventListener('submit', (e) => {
          e.preventDefault();
          UI.clearFieldErrors(form);

          const nameInput = form.querySelector('#sheet-unit-name');
          const notesInput = form.querySelector('#sheet-unit-notes');

          const validation = Validator.validateUnit({
            unitName: nameInput.value,
            existingList: window.appStore.state.units
          });

          if (!validation.isValid) {
            if (validation.errors.unitName) UI.showFieldError(nameInput, validation.errors.unitName);
            return;
          }

          const newUnit = {
            id: Date.now(),
            name: nameInput.value.trim(),
            notes: notesInput.value.trim()
          };
          window.appStore.state.units.push(newUnit);
          window.appStore.saveData();

          BottomSheetManager.close();
          ToastManager.show(`Unit "${newUnit.name}" saved successfully!`);

          if (window.Navigation.currentScreen === 'units') {
            window.Navigation.navigateTo('units', false);
          }
        });
      }
    });
  },

  // ------------------------------------------------------------------------
  // 11. Master Data: Categories List & Add Category
  // ------------------------------------------------------------------------
  renderCategoriesList() {
    const list = window.appStore.state.categories;

    return `
      <div class="screen-content-padded" id="screen-categories">
        <div class="search-filter-row">
          <div class="search-box">
            <span class="search-icon">${Icons.search()}</span>
            <input type="text" id="search-categories-input" placeholder="Search categories..." />
          </div>
          <button class="filter-btn" id="btn-filter-categories" aria-label="Filter">${Icons.filter()}</button>
        </div>

        <div class="entity-card-list" id="categories-container">
          ${this.renderCategoryCards(list)}
        </div>

        <button class="fab-add" id="fab-add-category" aria-label="Add Category">
          ${Icons.plus()}
        </button>
      </div>
    `;
  },

  renderCategoryCards(list) {
    if (this.uiState === 'loading') return UI.createSkeletonList(4);
    if (this.uiState === 'empty' || !list || list.length === 0) {
      return UI.createEmptyState({
        icon: Icons.category(),
        title: "No Categories Added",
        desc: "Group your product inventory into clean categories.",
        actionText: "+ Add Category",
        actionId: "btn-empty-add-category"
      });
    }

    return list.map(c => `
      <div class="entity-card" data-category-id="${c.id}">
        <div class="entity-card-left">
          <div class="entity-avatar coral-avatar">
            ${Icons.category()}
          </div>
          <div class="entity-info">
            <div class="entity-title">${c.name}</div>
            <div class="entity-subtitle">${c.notes || 'Product category'}</div>
          </div>
        </div>
        <div class="entity-card-right">
          <span class="chevron-icon">${Icons.chevronRight()}</span>
        </div>
      </div>
    `).join('');
  },

  initCategories(container) {
    const fab = container.querySelector('#fab-add-category');
    if (fab) fab.addEventListener('click', () => Screens.openAddCategorySheet());

    const emptyBtn = container.querySelector('#btn-empty-add-category');
    if (emptyBtn) emptyBtn.addEventListener('click', () => Screens.openAddCategorySheet());

    const searchInput = container.querySelector('#search-categories-input');
    if (searchInput) {
      searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        const filtered = window.appStore.state.categories.filter(c =>
          c.name.toLowerCase().includes(query)
        );
        container.querySelector('#categories-container').innerHTML = Screens.renderCategoryCards(filtered);
      });
    }
  },

  openAddCategorySheet() {
    const html = `
      <div class="entity-icon-header-badge coral-avatar">
        ${Icons.category()}
      </div>
      <form id="form-add-category" novalidate>
        <div class="form-group">
          <label class="form-label" for="sheet-category-name">Category Name <span class="required-star">*</span></label>
          <input type="text" id="sheet-category-name" class="input-field" placeholder="Enter category name" />
        </div>

        <div class="form-group">
          <label class="form-label" for="sheet-category-notes">Notes</label>
          <textarea id="sheet-category-notes" class="input-field" placeholder="Enter notes (optional)"></textarea>
        </div>

        <button type="submit" class="btn btn-primary" style="margin-top: 12px;" id="btn-save-category">Save Category</button>
      </form>
    `;

    BottomSheetManager.open({
      title: "Add Category",
      contentHtml: html,
      onRender: (sheetBody) => {
        const form = sheetBody.querySelector('#form-add-category');
        form.addEventListener('submit', (e) => {
          e.preventDefault();
          UI.clearFieldErrors(form);

          const nameInput = form.querySelector('#sheet-category-name');
          const notesInput = form.querySelector('#sheet-category-notes');

          const validation = Validator.validateCategory({
            categoryName: nameInput.value,
            existingList: window.appStore.state.categories
          });

          if (!validation.isValid) {
            if (validation.errors.categoryName) UI.showFieldError(nameInput, validation.errors.categoryName);
            return;
          }

          const newCat = {
            id: Date.now(),
            name: nameInput.value.trim(),
            notes: notesInput.value.trim()
          };
          window.appStore.state.categories.push(newCat);
          window.appStore.saveData();

          BottomSheetManager.close();
          ToastManager.show(`Category "${newCat.name}" saved successfully!`);

          if (window.Navigation.currentScreen === 'categories') {
            window.Navigation.navigateTo('categories', false);
          }
        });
      }
    });
  },

  // ------------------------------------------------------------------------
  // 12. Master Data: Items List & Add Item
  // ------------------------------------------------------------------------
  renderItemsList() {
    const list = window.appStore.state.items;

    return `
      <div class="screen-content-padded" id="screen-items">
        <div class="search-filter-row">
          <div class="search-box">
            <span class="search-icon">${Icons.search()}</span>
            <input type="text" id="search-items-input" placeholder="Search items..." />
          </div>
          <button class="filter-btn" id="btn-filter-items" aria-label="Filter">${Icons.filter()}</button>
        </div>

        <div class="entity-card-list" id="items-container">
          ${this.renderItemCards(list)}
        </div>

        <button class="fab-add" id="fab-add-item" aria-label="Add Item">
          ${Icons.plus()}
        </button>
      </div>
    `;
  },

  renderItemCards(list) {
    if (this.uiState === 'loading') return UI.createSkeletonList(4);
    if (this.uiState === 'empty' || !list || list.length === 0) {
      return UI.createEmptyState({
        icon: Icons.items(),
        title: "No Items in Catalog",
        desc: "Register product inventory to start selling.",
        actionText: "+ Add Item",
        actionId: "btn-empty-add-item"
      });
    }

    return list.map(item => `
      <div class="entity-card" data-item-id="${item.id}">
        <div class="entity-card-left">
          <div class="entity-avatar teal-avatar">
            ${Icons.items()}
          </div>
          <div class="entity-info">
            <div class="entity-title">${item.name}</div>
            <div class="entity-subtitle">${item.code} · ${item.company} · ${item.unit}</div>
          </div>
        </div>
        <div class="entity-card-right">
          <div class="entity-price">${InvoiceManager.formatCurrency(item.sellingPrice)}</div>
          <span class="chevron-icon">${Icons.chevronRight()}</span>
        </div>
      </div>
    `).join('');
  },

  initItems(container) {
    const fab = container.querySelector('#fab-add-item');
    if (fab) fab.addEventListener('click', () => Screens.openAddItemSheet());

    const emptyBtn = container.querySelector('#btn-empty-add-item');
    if (emptyBtn) emptyBtn.addEventListener('click', () => Screens.openAddItemSheet());

    const searchInput = container.querySelector('#search-items-input');
    if (searchInput) {
      searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        const filtered = window.appStore.state.items.filter(i =>
          i.name.toLowerCase().includes(query) || i.code.toLowerCase().includes(query) || i.company.toLowerCase().includes(query)
        );
        container.querySelector('#items-container').innerHTML = Screens.renderItemCards(filtered);
      });
    }
  },

  openAddItemSheet() {
    const companies = window.appStore.state.companies;
    const types = window.appStore.state.types;

    const companyOptions = companies.map(c => `<option value="${c.name}">${c.name}</option>`).join('');
    const typeOptions = types.map(t => `<option value="${t.name}">${t.name}</option>`).join('');

    const html = `
      <div class="entity-icon-header-badge">
        ${Icons.items()}
      </div>
      <form id="form-add-item" novalidate>
        <div class="form-group">
          <label class="form-label" for="sheet-item-company">Company <span class="required-star">*</span></label>
          <div class="select-wrapper">
            <select id="sheet-item-company" class="select-field">
              <option value="">Select company</option>
              ${companyOptions}
            </select>
            <span class="select-arrow">${Icons.chevronRight()}</span>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="sheet-item-type">Type <span class="required-star">*</span></label>
          <div class="select-wrapper">
            <select id="sheet-item-type" class="select-field">
              <option value="">Select type</option>
              ${typeOptions}
            </select>
            <span class="select-arrow">${Icons.chevronRight()}</span>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="sheet-item-name">Item Name <span class="required-star">*</span></label>
          <input type="text" id="sheet-item-name" class="input-field" placeholder="Enter item name" />
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
          <div class="form-group">
            <label class="form-label" for="sheet-item-selling">Selling Price <span class="required-star">*</span></label>
            <input type="number" step="0.01" id="sheet-item-selling" class="input-field" placeholder="0.00" />
          </div>

          <div class="form-group">
            <label class="form-label" for="sheet-item-buying">Buying Price <span class="required-star">*</span></label>
            <input type="number" step="0.01" id="sheet-item-buying" class="input-field" placeholder="0.00" />
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="sheet-item-notes">Notes</label>
          <textarea id="sheet-item-notes" class="input-field" placeholder="Enter notes (optional)"></textarea>
        </div>

        <button type="submit" class="btn btn-primary" style="margin-top: 12px;" id="btn-save-item">Save Item</button>
      </form>
    `;

    BottomSheetManager.open({
      title: "Add Item",
      contentHtml: html,
      onRender: (sheetBody) => {
        const form = sheetBody.querySelector('#form-add-item');
        form.addEventListener('submit', (e) => {
          e.preventDefault();
          UI.clearFieldErrors(form);

          const companyInput = form.querySelector('#sheet-item-company');
          const typeInput = form.querySelector('#sheet-item-type');
          const nameInput = form.querySelector('#sheet-item-name');
          const sellingInput = form.querySelector('#sheet-item-selling');
          const buyingInput = form.querySelector('#sheet-item-buying');
          const notesInput = form.querySelector('#sheet-item-notes');

          const validation = Validator.validateItem({
            companyName: companyInput.value,
            typeName: typeInput.value,
            itemName: nameInput.value,
            sellingPrice: sellingInput.value,
            buyingPrice: buyingInput.value,
            existingList: window.appStore.state.items
          });

          if (!validation.isValid) {
            if (validation.errors.companyName) UI.showFieldError(companyInput, validation.errors.companyName);
            if (validation.errors.typeName) UI.showFieldError(typeInput, validation.errors.typeName);
            if (validation.errors.itemName) UI.showFieldError(nameInput, validation.errors.itemName);
            if (validation.errors.sellingPrice) UI.showFieldError(sellingInput, validation.errors.sellingPrice);
            if (validation.errors.buyingPrice) UI.showFieldError(buyingInput, validation.errors.buyingPrice);
            return;
          }

          const newItem = {
            id: Date.now(),
            code: window.appStore.getNextItemCode(),
            name: nameInput.value.trim(),
            company: companyInput.value,
            type: typeInput.value,
            unit: "Piece (pcs)",
            sellingPrice: parseFloat(sellingInput.value) || 0,
            buyingPrice: parseFloat(buyingInput.value) || 0,
            notes: notesInput.value.trim()
          };

          window.appStore.state.items.push(newItem);
          window.appStore.saveData();

          BottomSheetManager.close();
          ToastManager.show(`Item "${newItem.name}" saved successfully!`);

          if (window.Navigation.currentScreen === 'items') {
            window.Navigation.navigateTo('items', false);
          }
        });
      }
    });
  },

  // ------------------------------------------------------------------------
  // 13. Master Data: Clients List & Add Client (with 11-digit phone check)
  // ------------------------------------------------------------------------
  renderClientsList() {
    const list = window.appStore.state.clients;

    return `
      <div class="screen-content-padded" id="screen-clients">
        <div class="search-filter-row">
          <div class="search-box">
            <span class="search-icon">${Icons.search()}</span>
            <input type="text" id="search-clients-input" placeholder="Search clients..." />
          </div>
          <button class="filter-btn" id="btn-filter-clients" aria-label="Filter">${Icons.filter()}</button>
        </div>

        <div class="entity-card-list" id="clients-container">
          ${this.renderClientCards(list)}
        </div>

        <button class="fab-add" id="fab-add-client" aria-label="Add Client">
          ${Icons.plus()}
        </button>
      </div>
    `;
  },

  renderClientCards(list) {
    if (this.uiState === 'loading') return UI.createSkeletonList(4);
    if (this.uiState === 'empty' || !list || list.length === 0) {
      return UI.createEmptyState({
        icon: Icons.clients(),
        title: "No Clients Registered",
        desc: "Add customer accounts to invoice them directly.",
        actionText: "+ Add Client",
        actionId: "btn-empty-add-client"
      });
    }

    return list.map(c => `
      <div class="entity-card" data-client-id="${c.id}">
        <div class="entity-card-left">
          <div class="entity-avatar ${c.id % 2 === 0 ? 'coral-avatar' : 'teal-avatar'}">
            ${c.initials || c.name.substring(0, 2).toUpperCase()}
          </div>
          <div class="entity-info">
            <div class="entity-title">${c.name}</div>
            <div class="entity-subtitle">${c.phone} · #${c.number}</div>
          </div>
        </div>
        <div class="entity-card-right">
          <span class="chevron-icon">${Icons.chevronRight()}</span>
        </div>
      </div>
    `).join('');
  },

  initClients(container) {
    const fab = container.querySelector('#fab-add-client');
    if (fab) fab.addEventListener('click', () => Screens.openAddClientSheet());

    const emptyBtn = container.querySelector('#btn-empty-add-client');
    if (emptyBtn) emptyBtn.addEventListener('click', () => Screens.openAddClientSheet());

    const searchInput = container.querySelector('#search-clients-input');
    if (searchInput) {
      searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        const filtered = window.appStore.state.clients.filter(c =>
          c.name.toLowerCase().includes(query) || c.phone.includes(query) || (c.address && c.address.toLowerCase().includes(query))
        );
        container.querySelector('#clients-container').innerHTML = Screens.renderClientCards(filtered);
      });
    }
  },

  openAddClientSheet() {
    const nextClientNum = window.appStore.getNextClientNumber();

    const html = `
      <div class="entity-icon-header-badge cyan-avatar">
        ${Icons.clientSingle()}
      </div>
      <form id="form-add-client" novalidate>
        <div class="form-group">
          <label class="form-label" for="sheet-client-name">Client Name <span class="required-star">*</span></label>
          <input type="text" id="sheet-client-name" class="input-field" placeholder="Enter client name" />
        </div>

        <div class="form-group">
          <label class="form-label" for="sheet-client-phone">Phone Number <span class="required-star">*</span> (11 digits)</label>
          <input type="tel" id="sheet-client-phone" class="input-field" placeholder="01123456789" maxlength="11" />
        </div>

        <div class="form-group">
          <label class="form-label" for="sheet-client-number">Client Number (Auto)</label>
          <input type="text" id="sheet-client-number" class="input-field disabled" value="#${nextClientNum}" disabled />
        </div>

        <div class="form-group">
          <label class="form-label" for="sheet-client-address">Address <span class="required-star">*</span></label>
          <input type="text" id="sheet-client-address" class="input-field" placeholder="Enter address" />
        </div>

        <button type="submit" class="btn btn-primary" style="margin-top: 12px;" id="btn-save-client">Save Client</button>
      </form>
    `;

    BottomSheetManager.open({
      title: "Add Client",
      contentHtml: html,
      onRender: (sheetBody) => {
        const form = sheetBody.querySelector('#form-add-client');
        form.addEventListener('submit', (e) => {
          e.preventDefault();
          UI.clearFieldErrors(form);

          const nameInput = form.querySelector('#sheet-client-name');
          const phoneInput = form.querySelector('#sheet-client-phone');
          const addressInput = form.querySelector('#sheet-client-address');

          const validation = Validator.validateClient({
            name: nameInput.value,
            phone: phoneInput.value,
            address: addressInput.value,
            existingList: window.appStore.state.clients
          });

          if (!validation.isValid) {
            if (validation.errors.name) UI.showFieldError(nameInput, validation.errors.name);
            if (validation.errors.phone) UI.showFieldError(phoneInput, validation.errors.phone);
            if (validation.errors.address) UI.showFieldError(addressInput, validation.errors.address);
            return;
          }

          const initials = nameInput.value.trim().split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase();

          const newClient = {
            id: Date.now(),
            number: nextClientNum,
            name: nameInput.value.trim(),
            phone: phoneInput.value.trim(),
            address: addressInput.value.trim(),
            initials: initials
          };

          window.appStore.state.clients.push(newClient);
          window.appStore.saveData();

          BottomSheetManager.close();
          ToastManager.show(`Client "${newClient.name}" added successfully!`);

          if (window.Navigation.currentScreen === 'clients') {
            window.Navigation.navigateTo('clients', false);
          }
        });
      }
    });
  },

  // ------------------------------------------------------------------------
  // 14. SALES INVOICE MULTI-STEP FLOW (Steps 1, 2, 3, 4)
  // ------------------------------------------------------------------------

  // Step 1: Bill Details
  renderInvoiceStep1() {
    const draft = window.invoiceManager.draft;
    const clients = window.appStore.state.clients;
    const clientOptions = clients.map(c => `
      <option value="${c.name}" ${draft.clientName === c.name ? 'selected' : ''}>${c.name}</option>
    `).join('');

    return `
      <div class="invoice-stepper-container" id="screen-inv-step1">
        <!-- Step Indicator -->
        <div class="step-indicator-wrapper">
          <div class="step-item active">
            <div class="step-circle">1</div>
            <span class="step-label">Bill Details</span>
          </div>
          <div class="step-connector-line"></div>
          <div class="step-item">
            <div class="step-circle">2</div>
            <span class="step-label">Items</span>
          </div>
          <div class="step-connector-line"></div>
          <div class="step-item">
            <div class="step-circle">3</div>
            <span class="step-label">Summary</span>
          </div>
        </div>

        <form id="form-inv-step1" novalidate>
          <div class="form-group">
            <label class="form-label" for="inv-bill-date">Bill Date <span class="required-star">*</span></label>
            <div class="input-wrapper">
              <span class="input-prefix" style="left: 14px;">${Icons.calendar()}</span>
              <input type="date" id="inv-bill-date" class="input-field" value="${draft.billDate}" />
            </div>
          </div>

          <div class="form-group">
            <label class="form-label" for="inv-bill-num">Bill Number</label>
            <input type="text" id="inv-bill-num" class="input-field disabled" value="#${draft.billNumber}" disabled />
          </div>

          <div class="form-group">
            <label class="form-label" for="inv-client-name">Client Name <span class="required-star">*</span></label>
            <div class="select-wrapper">
              <select id="inv-client-name" class="select-field">
                <option value="">Select client</option>
                ${clientOptions}
              </select>
              <span class="select-arrow">${Icons.chevronRight()}</span>
            </div>
          </div>

          <div style="margin-top: 36px;">
            <button type="submit" class="btn btn-primary" id="btn-step1-next">Next</button>
          </div>
        </form>
      </div>
    `;
  },

  initInvoiceStep1(container) {
    const form = container.querySelector('#form-inv-step1');
    if (form) {
      form.addEventListener('submit', (e) => {
        e.preventDefault();
        UI.clearFieldErrors(form);

        const dateInput = form.querySelector('#inv-bill-date');
        const clientInput = form.querySelector('#inv-client-name');

        const validation = Validator.validateInvoiceBillDetails({
          billDate: dateInput.value,
          clientName: clientInput.value
        });

        if (!validation.isValid) {
          if (validation.errors.billDate) UI.showFieldError(dateInput, validation.errors.billDate);
          if (validation.errors.clientName) UI.showFieldError(clientInput, validation.errors.clientName);
          return;
        }

        window.invoiceManager.draft.billDate = dateInput.value;
        window.invoiceManager.draft.clientName = clientInput.value;

        window.Navigation.navigateTo('newInvoiceItemsList');
      });
    }
  },

  // Step 2: Add Item to Invoice Form
  renderInvoiceAddItem() {
    const items = window.appStore.state.items;
    const itemOptions = items.map(i => `<option value="${i.name}" data-price="${i.sellingPrice}" data-unit="${i.unit}" data-code="${i.code}">${i.name}</option>`).join('');

    return `
      <div class="invoice-stepper-container" id="screen-inv-add-item">
        <!-- Step Indicator -->
        <div class="step-indicator-wrapper">
          <div class="step-item completed">
            <div class="step-circle">${Icons.check()}</div>
            <span class="step-label">Bill Details</span>
          </div>
          <div class="step-connector-line active"></div>
          <div class="step-item active">
            <div class="step-circle">2</div>
            <span class="step-label">Items</span>
          </div>
          <div class="step-connector-line"></div>
          <div class="step-item">
            <div class="step-circle">3</div>
            <span class="step-label">Summary</span>
          </div>
        </div>

        <form id="form-inv-add-item" novalidate>
          <div class="form-group">
            <label class="form-label" for="inv-select-item">Item Name <span class="required-star">*</span></label>
            <div class="select-wrapper">
              <select id="inv-select-item" class="select-field">
                <option value="">Select item</option>
                ${itemOptions}
              </select>
              <span class="select-arrow">${Icons.chevronRight()}</span>
            </div>
          </div>

          <div class="form-group">
            <label class="form-label" for="inv-selling-price">Selling Price</label>
            <input type="number" step="0.01" id="inv-selling-price" class="input-field" placeholder="0.00" value="0.00" />
          </div>

          <div class="form-group">
            <label class="form-label">Quantity <span class="required-star">*</span></label>
            <div class="stepper-control">
              <button type="button" class="stepper-btn" id="btn-qty-minus">-</button>
              <input type="number" id="inv-item-qty" class="stepper-input" value="1" min="1" />
              <button type="button" class="stepper-btn" id="btn-qty-plus">+</button>
            </div>
          </div>

          <div class="form-group">
            <label class="form-label" for="inv-item-total">Total</label>
            <input type="text" id="inv-item-total" class="input-field disabled" value="0.00" disabled />
          </div>

          <div style="margin-top: 24px;">
            <button type="submit" class="btn btn-primary" id="btn-add-item-to-list">Add to Invoice</button>
          </div>
        </form>
      </div>
    `;
  },

  initInvoiceAddItem(container) {
    const itemSelect = container.querySelector('#inv-select-item');
    const priceInput = container.querySelector('#inv-selling-price');
    const qtyInput = container.querySelector('#inv-item-qty');
    const totalInput = container.querySelector('#inv-item-total');
    const minusBtn = container.querySelector('#btn-qty-minus');
    const plusBtn = container.querySelector('#btn-qty-plus');
    const form = container.querySelector('#form-inv-add-item');

    let currentItemMeta = null;

    const updateTotal = () => {
      const p = parseFloat(priceInput.value) || 0;
      const q = parseFloat(qtyInput.value) || 0;
      totalInput.value = (p * q).toFixed(2);
    };

    if (itemSelect) {
      itemSelect.addEventListener('change', () => {
        const selectedOpt = itemSelect.options[itemSelect.selectedIndex];
        if (selectedOpt && selectedOpt.value) {
          const price = selectedOpt.getAttribute('data-price');
          priceInput.value = price;
          currentItemMeta = {
            code: selectedOpt.getAttribute('data-code'),
            unit: selectedOpt.getAttribute('data-unit')
          };
        } else {
          priceInput.value = "0.00";
          currentItemMeta = null;
        }
        updateTotal();
      });
    }

    if (priceInput) priceInput.addEventListener('input', updateTotal);

    if (minusBtn && qtyInput) {
      minusBtn.addEventListener('click', () => {
        let val = parseInt(qtyInput.value) || 1;
        if (val > 1) {
          qtyInput.value = val - 1;
          updateTotal();
        }
      });
    }

    if (plusBtn && qtyInput) {
      plusBtn.addEventListener('click', () => {
        let val = parseInt(qtyInput.value) || 1;
        qtyInput.value = val + 1;
        updateTotal();
      });
    }

    if (qtyInput) qtyInput.addEventListener('input', updateTotal);

    if (form) {
      form.addEventListener('submit', (e) => {
        e.preventDefault();
        UI.clearFieldErrors(form);

        const validation = Validator.validateInvoiceAddItem({
          itemName: itemSelect.value,
          quantity: qtyInput.value
        });

        if (!validation.isValid) {
          if (validation.errors.itemName) UI.showFieldError(itemSelect, validation.errors.itemName);
          if (validation.errors.quantity) UI.showFieldError(qtyInput, validation.errors.quantity);
          return;
        }

        // Add to invoice draft
        window.invoiceManager.addItem({
          code: currentItemMeta ? currentItemMeta.code : 'ITM-NEW',
          name: itemSelect.value,
          unit: currentItemMeta ? currentItemMeta.unit : 'Piece',
          sellingPrice: parseFloat(priceInput.value) || 0,
          quantity: parseFloat(qtyInput.value) || 1,
          discount: 0
        });

        ToastManager.show(`Added "${itemSelect.value}" to invoice`);
        window.Navigation.navigateTo('newInvoiceItemsList');
      });
    }
  },

  // Step 2: Items List view
  renderInvoiceItemsList() {
    const draft = window.invoiceManager.draft;

    return `
      <div class="invoice-stepper-container" id="screen-inv-items-list">
        <!-- Step Indicator -->
        <div class="step-indicator-wrapper">
          <div class="step-item completed">
            <div class="step-circle">${Icons.check()}</div>
            <span class="step-label">Bill Details</span>
          </div>
          <div class="step-connector-line active"></div>
          <div class="step-item active">
            <div class="step-circle">2</div>
            <span class="step-label">Items</span>
          </div>
          <div class="step-connector-line"></div>
          <div class="step-item">
            <div class="step-circle">3</div>
            <span class="step-label">Summary</span>
          </div>
        </div>

        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px;">
          <h3 style="font-size: var(--font-size-md);">Invoice Items (${draft.items.length})</h3>
          <button class="btn btn-outline btn-sm" id="btn-add-another-item" style="width: auto;">+ Add Item</button>
        </div>

        <div id="invoice-items-cards-container">
          ${draft.items.length === 0 ? UI.createEmptyState({
            icon: Icons.items(),
            title: "No Items Added",
            desc: "Add items to calculate invoice totals.",
            actionText: "+ Add Item",
            actionId: "btn-list-empty-add"
          }) : draft.items.map((item, index) => `
            <div class="invoice-item-card" data-index="${index}">
              <div class="invoice-item-header">
                <div>
                  <div class="invoice-item-name">${item.name}</div>
                  <div class="invoice-item-code">${item.code} | ${item.unit}</div>
                </div>
                <div class="invoice-item-actions">
                  <button class="item-action-icon-btn btn-delete-item" data-index="${index}" aria-label="Delete">
                    ${Icons.trash()}
                  </button>
                </div>
              </div>

              <div class="invoice-item-meta">
                <div class="invoice-item-qty-rate">${item.quantity} × ${InvoiceManager.formatCurrency(item.sellingPrice)}</div>
                <div class="invoice-item-total">${InvoiceManager.formatCurrency(item.total)}</div>
              </div>
            </div>
          `).join('')}
        </div>

        <div class="stepper-actions-bar">
          <button type="button" class="btn btn-secondary" id="btn-items-back">Back</button>
          <button type="button" class="btn btn-primary" id="btn-items-next" ${draft.items.length === 0 ? 'disabled' : ''}>Next</button>
        </div>
      </div>
    `;
  },

  initInvoiceItemsList(container) {
    const addAnother = container.querySelector('#btn-add-another-item');
    const emptyAdd = container.querySelector('#btn-list-empty-add');
    const backBtn = container.querySelector('#btn-items-back');
    const nextBtn = container.querySelector('#btn-items-next');

    if (addAnother) addAnother.addEventListener('click', () => window.Navigation.navigateTo('newInvoiceAddItem'));
    if (emptyAdd) emptyAdd.addEventListener('click', () => window.Navigation.navigateTo('newInvoiceAddItem'));
    if (backBtn) backBtn.addEventListener('click', () => window.Navigation.navigateTo('newInvoiceStep1'));
    if (nextBtn) nextBtn.addEventListener('click', () => window.Navigation.navigateTo('newInvoiceSummary'));

    // Delete item handlers
    container.querySelectorAll('.btn-delete-item').forEach(btn => {
      btn.addEventListener('click', (e) => {
        const idx = parseInt(btn.getAttribute('data-index'));
        window.invoiceManager.removeItem(idx);
        ToastManager.show("Item removed from invoice");
        window.Navigation.navigateTo('newInvoiceItemsList', false);
      });
    });
  },

  // Step 3: Other Details / Financial Summary
  renderInvoiceSummary() {
    const draft = window.invoiceManager.recalculate();

    return `
      <div class="invoice-stepper-container" id="screen-inv-summary">
        <!-- Step Indicator -->
        <div class="step-indicator-wrapper">
          <div class="step-item completed">
            <div class="step-circle">${Icons.check()}</div>
            <span class="step-label">Bill Details</span>
          </div>
          <div class="step-connector-line active"></div>
          <div class="step-item completed">
            <div class="step-circle">${Icons.check()}</div>
            <span class="step-label">Items</span>
          </div>
          <div class="step-connector-line active"></div>
          <div class="step-item active">
            <div class="step-circle">3</div>
            <span class="step-label">Summary</span>
          </div>
        </div>

        <form id="form-inv-summary" novalidate>
          <!-- Financial Summary Card -->
          <div class="financial-summary-card">
            <div class="summary-row">
              <span class="font-semibold">Bills Total</span>
              <span class="font-bold" id="disp-bills-total">${InvoiceManager.formatCurrency(draft.billsTotal)}</span>
            </div>

            <div class="form-group" style="margin-bottom: 4px;">
              <label class="form-label" for="inv-pct-discount">Percentage Discount (%)</label>
              <input type="number" step="0.1" id="inv-pct-discount" class="input-field" value="${draft.percentageDiscount}" placeholder="0" min="0" />
            </div>

            <div class="form-group" style="margin-bottom: 4px;">
              <label class="form-label" for="inv-val-discount">Value Discount</label>
              <input type="number" step="1" id="inv-val-discount" class="input-field" value="${draft.valueDiscount}" placeholder="0" min="0" />
            </div>

            <div class="summary-row net-row">
              <span>The Net</span>
              <span id="disp-the-net">${InvoiceManager.formatCurrency(draft.theNet)}</span>
            </div>

            <div class="form-group" style="margin-bottom: 4px;">
              <label class="form-label" for="inv-paid-up">Paid Up</label>
              <input type="number" step="1" id="inv-paid-up" class="input-field" value="${draft.paidUp}" placeholder="0" min="0" />
            </div>

            <!-- THE REST - WITH STRONG CORAL ACCENT EMPHASIS -->
            <div class="summary-row rest-row">
              <span>The Rest</span>
              <span class="rest-value" id="disp-the-rest">${InvoiceManager.formatCurrency(draft.theRest)}</span>
            </div>
          </div>

          <div class="stepper-actions-bar">
            <button type="button" class="btn btn-secondary" id="btn-summary-back">Back</button>
            <button type="submit" class="btn btn-primary" id="btn-create-invoice">Create Invoice</button>
          </div>
        </form>
      </div>
    `;
  },

  initInvoiceSummary(container) {
    const pctInput = container.querySelector('#inv-pct-discount');
    const valInput = container.querySelector('#inv-val-discount');
    const paidInput = container.querySelector('#inv-paid-up');
    const netDisp = container.querySelector('#disp-the-net');
    const restDisp = container.querySelector('#disp-the-rest');
    const backBtn = container.querySelector('#btn-summary-back');
    const form = container.querySelector('#form-inv-summary');

    const recalculateUI = () => {
      window.invoiceManager.draft.percentageDiscount = parseFloat(pctInput.value) || 0;
      window.invoiceManager.draft.valueDiscount = parseFloat(valInput.value) || 0;
      window.invoiceManager.draft.paidUp = parseFloat(paidInput.value) || 0;

      const updated = window.invoiceManager.recalculate();
      netDisp.textContent = InvoiceManager.formatCurrency(updated.theNet);
      restDisp.textContent = InvoiceManager.formatCurrency(updated.theRest);
    };

    if (pctInput) pctInput.addEventListener('input', recalculateUI);
    if (valInput) valInput.addEventListener('input', recalculateUI);
    if (paidInput) paidInput.addEventListener('input', recalculateUI);

    if (backBtn) backBtn.addEventListener('click', () => window.Navigation.navigateTo('newInvoiceItemsList'));

    if (form) {
      form.addEventListener('submit', (e) => {
        e.preventDefault();
        UI.clearFieldErrors(form);

        const validation = Validator.validateInvoiceSummary({
          percentageDiscount: pctInput.value,
          valueDiscount: valInput.value,
          paidUp: paidInput.value
        });

        if (!validation.isValid) {
          if (validation.errors.percentageDiscount) UI.showFieldError(pctInput, validation.errors.percentageDiscount);
          if (validation.errors.valueDiscount) UI.showFieldError(valInput, validation.errors.valueDiscount);
          if (validation.errors.paidUp) UI.showFieldError(paidInput, validation.errors.paidUp);
          return;
        }

        // Commit invoice to store
        const newInvoice = {
          ...window.invoiceManager.draft,
          id: window.invoiceManager.draft.billNumber
        };

        window.appStore.state.invoices.unshift(newInvoice);
        window.appStore.saveData();

        ToastManager.show(`Sales Invoice #${newInvoice.billNumber} created successfully!`);

        // Reset draft for next time
        window.invoiceManager.resetDraft();

        // Navigate to Invoice Details
        window.Navigation.navigateTo('invoiceDetails', true, { invoiceId: newInvoice.id });
      });
    }
  },

  // Invoice Details View
  renderInvoiceDetails(params = {}) {
    const id = parseInt(params.invoiceId) || 1044;
    const invoice = window.appStore.state.invoices.find(i => i.id === id) || window.appStore.state.invoices[0];

    if (!invoice) return `<div>Invoice not found</div>`;

    const isPaid = invoice.status === 'Paid';

    return `
      <div class="screen-content-padded" id="screen-invoice-details">
        <div style="background: var(--white); border-radius: var(--radius-xl); padding: 18px; border: 1px solid var(--neutral-200); box-shadow: var(--shadow-sm); margin-bottom: 16px;">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
            <div>
              <h2 style="font-size: var(--font-size-xl); font-weight: 800; color: var(--neutral-900);">Invoice #${invoice.billNumber}</h2>
              <p style="font-size: var(--font-size-xs); color: var(--neutral-500);">${invoice.billDate}</p>
            </div>
            <span class="badge ${isPaid ? 'badge-paid' : 'badge-unpaid'}">${invoice.status}</span>
          </div>

          <div style="background: var(--neutral-50); border-radius: var(--radius-md); padding: 10px 12px; margin-bottom: 14px; display: flex; align-items: center; gap: 10px;">
            <div class="entity-avatar teal-avatar" style="width: 38px; height: 38px; font-size: 13px;">
              ${invoice.clientName.substring(0, 2).toUpperCase()}
            </div>
            <div>
              <div style="font-weight: 700; font-size: var(--font-size-sm);">${invoice.clientName}</div>
              <div style="font-size: var(--font-size-2xs); color: var(--neutral-500);">Client Account</div>
            </div>
          </div>

          <h4 style="font-size: var(--font-size-sm); margin-bottom: 8px;">Items (${invoice.items.length})</h4>
          <div style="display: flex; flex-direction: column; gap: 8px; margin-bottom: 14px;">
            ${invoice.items.map(item => `
              <div style="display: flex; justify-content: space-between; font-size: var(--font-size-xs); border-bottom: 1px dashed var(--neutral-200); padding-bottom: 6px;">
                <div>
                  <div style="font-weight: 600; color: var(--neutral-800);">${item.name}</div>
                  <div style="color: var(--neutral-500);">${item.quantity} × ${InvoiceManager.formatCurrency(item.sellingPrice)}</div>
                </div>
                <div style="font-weight: 700; color: var(--neutral-900);">${InvoiceManager.formatCurrency(item.total)}</div>
              </div>
            `).join('')}
          </div>

          <!-- Totals Breakdown -->
          <div style="display: flex; flex-direction: column; gap: 6px; font-size: var(--font-size-xs); border-top: 1px solid var(--neutral-200); padding-top: 10px;">
            <div style="display: flex; justify-content: space-between; color: var(--neutral-600);">
              <span>Bills Total</span>
              <span>${InvoiceManager.formatCurrency(invoice.billsTotal)}</span>
            </div>
            ${invoice.percentageDiscount > 0 ? `
              <div style="display: flex; justify-content: space-between; color: var(--neutral-600);">
                <span>Discount (${invoice.percentageDiscount}%)</span>
                <span>-${InvoiceManager.formatCurrency((invoice.billsTotal * invoice.percentageDiscount) / 100)}</span>
              </div>
            ` : ''}
            ${invoice.valueDiscount > 0 ? `
              <div style="display: flex; justify-content: space-between; color: var(--neutral-600);">
                <span>Value Discount</span>
                <span>-${InvoiceManager.formatCurrency(invoice.valueDiscount)}</span>
              </div>
            ` : ''}
            <div style="display: flex; justify-content: space-between; font-weight: 700; color: var(--primary);">
              <span>The Net</span>
              <span>${InvoiceManager.formatCurrency(invoice.theNet)}</span>
            </div>
            <div style="display: flex; justify-content: space-between; color: var(--neutral-600);">
              <span>Paid Up</span>
              <span>${InvoiceManager.formatCurrency(invoice.paidUp)}</span>
            </div>
            <div style="display: flex; justify-content: space-between; font-weight: 800; color: var(--accent-coral); background: var(--accent-coral-subtle); padding: 8px 10px; border-radius: var(--radius-md);">
              <span>The Rest</span>
              <span>${InvoiceManager.formatCurrency(invoice.theRest)}</span>
            </div>
          </div>
        </div>

        <div style="margin-top: 16px;">
          <button class="btn btn-primary" id="btn-back-to-invoices">Back to Invoices</button>
        </div>
      </div>
    `;
  },

  initInvoiceDetails(container) {
    const backBtn = container.querySelector('#btn-back-to-invoices');
    if (backBtn) backBtn.addEventListener('click', () => window.Navigation.navigateTo('dashboard'));
  },

  // ------------------------------------------------------------------------
  // 15. REQUEST A FORM (Section 4 of Invoices in SRS)
  // ------------------------------------------------------------------------
  renderRequestForm() {
    const employees = window.appStore.state.employees;
    const empOptions = employees.map(e => `<option value="${e.name}">${e.name}</option>`).join('');
    const today = new Date().toISOString().split('T')[0];

    return `
      <div class="screen-content-padded" id="screen-request-form">
        <form id="form-request-work" novalidate>
          <div class="form-group">
            <label class="form-label" for="req-emp-name">Employee NAME <span class="required-star">*</span></label>
            <div class="select-wrapper">
              <select id="req-emp-name" class="select-field">
                <option value="">Select employee</option>
                ${empOptions}
              </select>
              <span class="select-arrow">${Icons.chevronRight()}</span>
            </div>
          </div>

          <div class="form-group">
            <label class="form-label" for="req-date">DATE <span class="required-star">*</span></label>
            <div class="input-wrapper">
              <span class="input-prefix" style="left: 14px;">${Icons.calendar()}</span>
              <input type="date" id="req-date" class="input-field" value="${today}" />
            </div>
          </div>

          <div class="form-group">
            <label class="form-label" for="req-start-time">Start Time <span class="required-star">*</span></label>
            <div class="input-wrapper">
              <span class="input-prefix" style="left: 14px;">${Icons.clock()}</span>
              <input type="time" id="req-start-time" class="input-field" value="09:00" />
            </div>
          </div>

          <div class="form-group">
            <label class="form-label" for="req-end-time">End Time <span class="required-star">*</span></label>
            <div class="input-wrapper">
              <span class="input-prefix" style="left: 14px;">${Icons.clock()}</span>
              <input type="time" id="req-end-time" class="input-field" value="17:00" />
            </div>
          </div>

          <div style="margin-top: 32px;">
            <button type="submit" class="btn btn-primary" id="btn-submit-request">Submit Request</button>
          </div>
        </form>
      </div>
    `;
  },

  initRequestForm(container) {
    const form = container.querySelector('#form-request-work');
    if (form) {
      form.addEventListener('submit', (e) => {
        e.preventDefault();
        UI.clearFieldErrors(form);

        const empInput = form.querySelector('#req-emp-name');
        const dateInput = form.querySelector('#req-date');
        const startInput = form.querySelector('#req-start-time');
        const endInput = form.querySelector('#req-end-time');

        const validation = Validator.validateRequestForm({
          employeeName: empInput.value,
          date: dateInput.value,
          startTime: startInput.value,
          endTime: endInput.value
        });

        if (!validation.isValid) {
          if (validation.errors.employeeName) UI.showFieldError(empInput, validation.errors.employeeName);
          if (validation.errors.date) UI.showFieldError(dateInput, validation.errors.date);
          if (validation.errors.startTime) UI.showFieldError(startInput, validation.errors.startTime);
          if (validation.errors.endTime) UI.showFieldError(endInput, validation.errors.endTime);
          return;
        }

        window.appStore.state.requests.push({
          id: Date.now(),
          employeeName: empInput.value,
          date: dateInput.value,
          startTime: startInput.value,
          endTime: endInput.value,
          status: "Pending"
        });
        window.appStore.saveData();

        ToastManager.show("Request form submitted successfully!");
        window.Navigation.navigateTo('dashboard');
      });
    }
  },

  // ------------------------------------------------------------------------
  // 16. SALES REPORT SCREEN (Period selection & Results per SRS)
  // ------------------------------------------------------------------------
  reportGenerated: false,

  renderSalesReport() {
    const today = new Date().toISOString().split('T')[0];

    return `
      <div class="screen-content-padded" id="screen-sales-report">
        <!-- Choose Period Card -->
        <div class="report-period-card">
          <div class="report-date-row">
            <div class="form-group" style="margin-bottom: 0;">
              <label class="form-label" for="report-from-date">From Date <span class="required-star">*</span></label>
              <div class="input-wrapper">
                <input type="date" id="report-from-date" class="input-field" value="2026-04-01" />
              </div>
            </div>

            <div class="form-group" style="margin-bottom: 0;">
              <label class="form-label" for="report-to-date">To Date <span class="required-star">*</span></label>
              <div class="input-wrapper">
                <input type="date" id="report-to-date" class="input-field" value="${today}" />
              </div>
            </div>
          </div>

          <button type="button" class="btn btn-primary" id="btn-show-report" style="margin-top: 14px;">Show Report</button>
        </div>

        <!-- Report Output Container -->
        <div id="report-results-container">
          ${this.renderReportState()}
        </div>
      </div>
    `;
  },

  renderReportState() {
    if (this.uiState === 'loading') {
      return UI.createSkeletonList(3);
    }

    if (!this.reportGenerated && this.uiState !== 'populated') {
      return UI.createEmptyState({
        icon: Icons.report(),
        title: "No Data Yet",
        desc: "Select a period and tap Show Report to view sales figures."
      });
    }

    const invoices = window.appStore.state.invoices || [];

    if (invoices.length === 0) {
      return UI.createEmptyState({
        icon: Icons.report(),
        title: "No Invoices Found",
        desc: "There are no invoices in the selected period."
      });
    }

    return `
      <div class="section-header">
        <h3>Sales Invoices</h3>
      </div>

      <div class="recent-invoices-list">
        ${invoices.map(inv => `
          <div class="recent-invoice-card" data-invoice-id="${inv.id}">
            <div class="recent-invoice-left">
              <div class="invoice-icon-badge">#${inv.billNumber}</div>
              <div>
                <div class="recent-invoice-title">${inv.clientName}</div>
                <div class="recent-invoice-date">${inv.billDate}</div>
              </div>
            </div>
            <div class="recent-invoice-right">
              <div class="recent-invoice-amount">${InvoiceManager.formatCurrency(inv.billsTotal)}</div>
              <span class="badge ${inv.status === 'Paid' ? 'badge-paid' : 'badge-unpaid'}">${inv.status}</span>
            </div>
          </div>
        `).join('')}
      </div>
    `;
  },

  initSalesReport(container) {
    const showBtn = container.querySelector('#btn-show-report');
    if (showBtn) {
      showBtn.addEventListener('click', () => {
        const fromDate = container.querySelector('#report-from-date').value;
        const toDate = container.querySelector('#report-to-date').value;

        if (!fromDate || !toDate) {
          ToastManager.show("Please select both From and To dates", "error");
          return;
        }

        // Show loading state briefly then display results
        const resultsBox = container.querySelector('#report-results-container');
        resultsBox.innerHTML = UI.createSkeletonList(3);

        setTimeout(() => {
          Screens.reportGenerated = true;
          resultsBox.innerHTML = Screens.renderReportState();
          ToastManager.show("Sales Report loaded for selected period");

          resultsBox.querySelectorAll('.recent-invoice-card').forEach(card => {
            card.addEventListener('click', () => {
              const id = card.getAttribute('data-invoice-id');
              window.Navigation.navigateTo('invoiceDetails', true, { invoiceId: id });
            });
          });
        }, 500);
      });
    }

    container.querySelectorAll('.recent-invoice-card').forEach(card => {
      card.addEventListener('click', () => {
        const id = card.getAttribute('data-invoice-id');
        window.Navigation.navigateTo('invoiceDetails', true, { invoiceId: id });
      });
    });
  },

  // ------------------------------------------------------------------------
  // 17. Master Data Hub / More Screen
  // ------------------------------------------------------------------------
  renderMoreHub() {
    return `
      <div class="screen-content-padded" id="screen-more">
        <h3 style="margin-bottom: 4px; font-size: var(--font-size-md);">Master Catalog & Admin</h3>
        <p style="font-size: var(--font-size-xs); color: var(--neutral-500); margin-bottom: 16px;">Manage system entities and official requests</p>

        <div class="management-hub-grid">
          <div class="hub-tile" id="hub-tile-companies">
            <div class="hub-tile-icon cyan-avatar">
              ${Icons.company()}
            </div>
            <div class="hub-tile-title">Companies</div>
            <div class="hub-tile-desc">${window.appStore.state.companies.length} records</div>
          </div>

          <div class="hub-tile" id="hub-tile-types">
            <div class="hub-tile-icon teal-avatar">
              ${Icons.type()}
            </div>
            <div class="hub-tile-title">Types</div>
            <div class="hub-tile-desc">${window.appStore.state.types.length} records</div>
          </div>

          <div class="hub-tile" id="hub-tile-units">
            <div class="hub-tile-icon cyan-avatar">
              ${Icons.unit()}
            </div>
            <div class="hub-tile-title">Units</div>
            <div class="hub-tile-desc">${window.appStore.state.units.length} units</div>
          </div>

          <div class="hub-tile" id="hub-tile-categories">
            <div class="hub-tile-icon coral-avatar">
              ${Icons.category()}
            </div>
            <div class="hub-tile-title">Categories</div>
            <div class="hub-tile-desc">${window.appStore.state.categories.length} categories</div>
          </div>

          <div class="hub-tile" id="hub-tile-request-form" style="grid-column: span 2;">
            <div class="hub-tile-icon purple-bg" style="width: 44px; height: 44px;">
              ${Icons.requestForm()}
            </div>
            <div class="hub-tile-title">Request a Form (SRS Section 4)</div>
            <div class="hub-tile-desc">Employee working hours and shift requests</div>
          </div>
        </div>

        <div style="margin-top: 24px; padding-top: 16px; border-top: 1px solid var(--neutral-200); text-align: center;">
          <button class="btn btn-secondary btn-sm" id="btn-logout" style="color: var(--color-error); border-color: var(--color-error-border);">
            Sign Out
          </button>
        </div>
      </div>
    `;
  },

  initMoreHub(container) {
    const comp = container.querySelector('#hub-tile-companies');
    const types = container.querySelector('#hub-tile-types');
    const units = container.querySelector('#hub-tile-units');
    const cats = container.querySelector('#hub-tile-categories');
    const reqForm = container.querySelector('#hub-tile-request-form');
    const logout = container.querySelector('#btn-logout');

    if (comp) comp.addEventListener('click', () => window.Navigation.navigateTo('companies'));
    if (types) types.addEventListener('click', () => window.Navigation.navigateTo('types'));
    if (units) units.addEventListener('click', () => window.Navigation.navigateTo('units'));
    if (cats) cats.addEventListener('click', () => window.Navigation.navigateTo('categories'));
    if (reqForm) reqForm.addEventListener('click', () => window.Navigation.navigateTo('requestForm'));
    if (logout) {
      logout.addEventListener('click', () => {
        ToastManager.show("Signed out successfully");
        window.Navigation.navigateTo('login');
      });
    }
  }
};

window.Screens = Screens;
