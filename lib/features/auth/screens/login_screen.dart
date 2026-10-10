import 'package:flutter/material.dart';
import 'package:billing_and_sales_management/core/app_assets.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _submitting = false);
    await CustomSnackbar.showSuccess(context, 'Welcome back, Ahmed!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final topPadding = AppSpacing.xl.h;
            final bottomPadding = AppSpacing.s2xl.h;
            final minHeight = constraints.maxHeight.isFinite
                ? (constraints.maxHeight - topPadding - bottomPadding).clamp(
                    0.0,
                    double.infinity,
                  )
                : 0.0;

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg.w,
                topPadding,
                AppSpacing.lg.w,
                bottomPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: AppSpacing.lg.h),
                      _buildHeader(),
                      SizedBox(height: AppSpacing.xl.h),
                      SizedBox(height: 10.h),
                      _buildForm(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 68.r,
          height: 68.r,
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: AppShadows.sm,
          ),
          child: Image.asset(AppAssets.appLogo, fit: BoxFit.contain),
        ),
        SizedBox(height: AppSpacing.base.h),
        CustomText(
          text: 'Welcome Back',
          style: AppTextStyles.heroTitle,
          color: AppColors.neutral900,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.xs.h),
        CustomText(
          text: 'Sign in to continue',
          style: AppTextStyles.bodySmall,
          color: AppColors.neutral500,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            prefixIcon: Icon(Icons.mail_outline, size: 18.r),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Email is required'
                : null,
          ),
          SizedBox(height: AppSpacing.base.h),
          CustomTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter password',
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            prefixIcon: Icon(Icons.lock_outline, size: 18.r),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Password is required'
                : null,
          ),
          SizedBox(height: 14.h),
          CustomButton(
            text: 'Sign In',
            loading: _submitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
