/* ==========================================================================
   APP INITIALIZER & TOOLBAR CONTROLS
   Billing & Sales Management - Mobile UI/UX Design
   Coordinates viewport sizes, design states, screenshot modes, and data reset.
   ========================================================================== */

document.addEventListener('DOMContentLoaded', () => {
  // 1. Initialize Navigation
  window.Navigation.init();

  // 2. Setup iOS Status Bar Live Clock
  updateStatusBarClock();
  setInterval(updateStatusBarClock, 30000);

  // 3. Setup Designer Control Toolbar
  initDesignerToolbar();

  // 4. Global Keyboard Shortcuts
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      BottomSheetManager.close();
    }
  });

  console.log("Billing & Sales Management UI/UX Project Initialized.");
});

function updateStatusBarClock() {
  const clockEl = document.getElementById('status-bar-time');
  if (clockEl) {
    const now = new Date();
    const hours = now.getHours();
    const minutes = now.getMinutes();
    const formatted = `${hours}:${minutes < 10 ? '0' : ''}${minutes}`;
    clockEl.textContent = formatted;
  }
}

function initDesignerToolbar() {
  const deviceFrame = document.getElementById('mobile-device-frame');
  const controlBar = document.getElementById('designer-control-bar');
  const exitScreenshotBtn = document.getElementById('exit-screenshot-btn');

  // Viewport Size Switcher
  document.querySelectorAll('[data-viewport]').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('[data-viewport]').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      const vp = btn.getAttribute('data-viewport');
      deviceFrame.className = `mobile-device-frame vp-${vp}`;
    });
  });

  // State Switcher (Populated, Loading, Empty)
  document.querySelectorAll('[data-ui-state]').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('[data-ui-state]').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      const state = btn.getAttribute('data-ui-state');
      Screens.setUIState(state);
      ToastManager.show(`Switched state to: ${state.toUpperCase()}`);
    });
  });

  // Screenshot / Figma Presentation Mode
  const screenshotBtn = document.getElementById('btn-screenshot-mode');
  if (screenshotBtn) {
    screenshotBtn.addEventListener('click', () => {
      controlBar.classList.add('screenshot-hidden');
      exitScreenshotBtn.style.display = 'block';
      ToastManager.show("Screenshot mode active. Press 'Exit Figma Mode' when done.");
    });
  }

  if (exitScreenshotBtn) {
    exitScreenshotBtn.addEventListener('click', () => {
      controlBar.classList.remove('screenshot-hidden');
      exitScreenshotBtn.style.display = 'none';
    });
  }

  // Reset Mock Data
  const resetBtn = document.getElementById('btn-reset-data');
  if (resetBtn) {
    resetBtn.addEventListener('click', () => {
      if (confirm("Reset all catalog items, clients, and invoices back to initial mock state?")) {
        window.appStore.resetToDefaults();
        window.invoiceManager.resetDraft();
        ToastManager.show("Mock data reset to initial values!");
        window.Navigation.navigateTo(window.Navigation.currentScreen, false);
      }
    });
  }
}
