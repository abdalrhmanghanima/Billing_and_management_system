# Billing & Sales Management — Mobile UI/UX Design System

A complete, production-quality, mobile-first UI/UX design project for **Billing & Sales Management**, crafted from the ground up according to the **Bills SRS** specification, the official **`app_logo.png`** brand identity, and modern Flutter mobile design standards.

---

## 🌟 Key Highlights

- **Native Mobile-First Design**: Optimized for standard smartphones (primary target: 390 × 844 iPhone 15 viewport; adapts fluidly to 375×812, 393×852, and 430×932).
- **Official Brand System**: Palette built directly from `app_logo.png`:
  - Deep Teal (`#0B678F`) & Darker Navy Slate (`#084E6D`)
  - Accent Brand Blue / Cyan (`#29A9E1`)
  - Coral / Warm Orange (`#F76D43`) with subtle backgrounds (`#FFF2ED`)
  - High-contrast typography: Google Font *Plus Jakarta Sans*
- **Strict SRS Implementation**: Full coverage of all SRS modules, entities, acceptance criteria, and exact validation messages.
- **11-Digit Phone Number Rule**: Implements the required override (`PHONE must be just a 11 digit number`).
- **Live Invoice Engine**:
  $$\text{Item Total} = \text{Selling Price} \times \text{Quantity}$$
  $$\text{Bills Total} = \sum \text{Item Totals}$$
  $$\text{The Net} = \text{Bills Total} - \text{Discounts}$$
  $$\text{The Rest} = \text{The Net} - \text{Paid Up}$$
  *(With strong Coral accent visual emphasis on "The Rest" representing the remaining balance)*.
- **Toast / Snackbar Layering**: Fixed top toasts rendered at $z$-index `99999` to ensure they are **never hidden under bottom sheets or navigation bars**.
- **Figma Screenshot Mode**: One-click toolbar toggle that eliminates browser and preview artifacts, giving a pristine mobile canvas ready for high-resolution Figma exports.

---

## 📱 Complete Screen Inventory (28+ Screens & States)

### A. Brand & Authentication Flow
1. **Splash Screen**: Deep teal radial gradient waves, centered pulsating official logo badge, typography, and animated status dots.
2. **Onboarding Screen**: Clean hero layout, logo header, value proposition, 3-dot pagination indicator, circular action button.
3. **Login Screen**: Welcome Back hero, email & password fields with eye visibility toggle, "Forgot Password?" link, Sign In button, and sign up switch.
4. **Sign Up Screen**: Name, email, password creation with validation hints.
5. **Forgot Password**: Registered email submission for OTP recovery.
6. **Verification / OTP Screen**: 4-digit verification input boxes with resend countdown timer.
7. **Auth Loading & Error States**: Realistic feedback states and field-level validation errors.

### B. Main Application & Dashboard
8. **Home / Dashboard**:
   - Greeting: `Good Morning Ahmed 👋` + notification bell with unread badge.
   - **Quick Actions Grid (2×2)**: *New Invoice* (coral highlight), *Add Client*, *Add Item*, *Sales Report*.
   - **Recent Invoices List**: Invoices `#1044`, `#1043`, `#1042` with status badges (`Paid` emerald, `Unpaid` amber).
   - **Bottom Navigation**: 5-destination mobile bar with central elevated `+ Invoice` button.

### C. Master Catalog & Entities (SRS Modules)
9. **Companies List & Add Company**:
   - Search bar + filter button.
   - Company card list with logos and descriptions.
   - Mobile bottom sheet with validation: `COMPANY NAME is Required` and uniqueness check (`COMPANY NAME has already existed before`).
10. **Types List & Add Type**:
    - Item classification by company.
    - Bottom sheet validation: `COMPANY NAME is Required`, `TYPE NAME is Required`, and `TYPE NAME has already existed before`.
11. **Units List & Add Unit**:
    - Measurement units (Piece, Box, Kg, Meter, Liter).
    - Bottom sheet validation: `UNIT NAME is Required` and uniqueness.
12. **Categories List & Add Category**:
    - Clean category cards (Electronics, Computers, Accessories, Office Supplies, Others).
13. **Items Catalog & Add Item**:
    - Clean mobile cards (Item Code, Name, Company, Unit, Selling Price).
    - Validation: Company required, Type required, Item Name required & unique, Selling Price $\ge 0$, Buying Price $\ge 0$, and `BUYING PRICE Must be less than or equal SELLING PRICE`.
14. **Clients Database & Add Client**:
    - Client cards with initials avatar, name, phone, account number (`#1025`).
    - Validation: `CLIENT NAME is Required` & unique, `PHONE is Required`, `PHONE must be just a 11 digit number`, `Address is Required`. Client number is automatically generated and disabled.

### D. Sales Invoice Flow (Core SRS Workflow)
15. **Step 1: Bill Details**:
    - Step indicator: Step 1 (Active), Step 2, Step 3.
    - `BILL DATE` date picker (`BILL DATE is Required`).
    - `Bill NUMBER` auto-generated integer, disabled.
    - `CLIENT NAME` dropdown (`CLIENT NAME is Required`).
16. **Step 2: Add Item**:
    - `ITEM NAME` dropdown (`ITEM NAME is Required`).
    - `Selling Price` auto-populated from item and editable.
    - `Quantity` stepper `[- 1 +]` (`Quantity is Required`, `Quantity Must be Greater than Zero`).
    - `Total` auto-calculated (`Selling Price × Quantity`), read-only.
17. **Step 2: Items List**:
    - Summary of all added items with code, unit, rate, quantity, and total balance.
    - Action buttons to edit quantity and remove items.
18. **Step 3: Other Details / Summary**:
    - `Bills Total`: Auto-calculated sum of items, read-only.
    - `Percentage discount`: $\ge 0$ validation.
    - `Value discount`: $\ge 0$ validation.
    - `The Net`: Auto-calculated net balance.
    - `Paid Up`: User-entered payment amount ($\ge 0$).
    - **`The Rest`**: Auto-calculated remaining balance with high-visibility Coral (`#F76D43`) accent styling.
19. **Completed Invoice Details**:
    - View invoice receipt breakdown, client details, item list, payment status.
20. **Request a Form (SRS Section 4)**:
    - Employee Name (`Employee NAME is Required`).
    - Date (`DATE is Required`).
    - Start Time & End Time (`End Time must be greater than Start Time`).

### E. Sales Reporting (SRS Section 1.7)
21. **Sales Report**:
    - `From Date` & `To Date` period pickers.
    - Action: `Show Report`.
    - Live state transitions:
      - **Empty State**: Initial guide illustration.
      - **Loading State**: Animated skeleton cards.
      - **Results State**: Invoices retrieved for the selected period.

---

## 🚀 How to Run Locally

This project runs completely in the browser without needing a backend server or npm build step.

### Option 1: Python HTTP Server (Recommended)
Open a terminal in this directory and run:

```bash
python -m http.server 3000
```

Then open your browser at:
```
http://localhost:3000
```

*(You can also use ports `5000`, `5500`, or `8000`)*.

### Option 2: Node.js `npx serve` or `http-server`
```bash
npx serve .
# or
npx http-server -p 3000
```

### Option 3: Direct File Opening
Double-click `index.html` to open it directly in Google Chrome, Microsoft Edge, Safari, or Firefox.

---

## 🎨 Design System & File Structure

```
Billing & Sales Management design/
│
├── index.html               # Main interactive mobile application container
├── README.md                # Project documentation, screen guide & run instructions
├── Bills SRS.pdf            # Original SRS requirements specification
├── app_logo.png             # Official brand logo
├── reference_design.png     # Visual design reference
│
├── assets/
│   ├── app_logo.png         # Official high-resolution brand logo
│   └── reference_design.png # Visual direction reference
│
├── css/
│   ├── variables.css        # Color tokens, typography, radii, elevations & spacing
│   ├── base.css             # CSS reset, typography, and scrollbar styling
│   ├── layout.css           # Device frame (375/390/393/430), status bar, dynamic island, nav
│   ├── components.css       # Buttons, form controls, stepper, cards, bottom sheets, toasts
│   └── screens.css          # Screen-specific styles (Splash, Auth, Dashboard, Stepper, Reports)
│
└── js/
    ├── mock-data.js         # Reactive data store with localStorage persistence & reset
    ├── validation.js        # Pure validation engine with all SRS rules & error messages
    ├── invoice.js           # Live mathematical calculation engine for invoice totals
    ├── components.js        # SVG icon library, Toast manager (z-99999), Bottom Sheet controller
    ├── screens.js           # Interactive renderers and event bindings for all 28+ screens
    ├── navigation.js        # Screen router, history stack, and mobile bottom nav
    └── app.js              # Application entrypoint, iOS status clock, and designer toolbar
```

---

## 📸 Capturing Screenshots for Figma

1. Open `http://localhost:3000` in your browser.
2. Use the **Screen** dropdown in the top bar to jump directly to any screen you wish to capture (e.g. *Invoice Step 3: Summary*, *Dashboard*, *Clients List*, etc.).
3. Choose your preferred viewport preset:
   - **`390`** (Default iPhone 15: 390 × 844)
   - **`375`** (Compact iPhone: 375 × 812)
   - **`393`** (iPhone 16 / 15 Pro: 393 × 852)
   - **`430`** (iPhone Pro Max: 430 × 932)
   - **`Clean`** (Frameless edge-to-edge view)
4. Click **`Figma Mode`**:
   - The top toolbar will slide away, leaving only the pristine mobile device.
   - Capture a screenshot with `Win + Shift + S` (Windows) or your favorite tool.
   - Click **`Exit Figma Mode`** in the top right to restore control tools.
5. Toggle between **Populated**, **Loading** (skeleton loaders), and **Empty** states to capture all edge cases for your Figma design system.
