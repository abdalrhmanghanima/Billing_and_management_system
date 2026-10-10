import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billing_and_sales_management/core/app_assets.dart';
import 'package:billing_and_sales_management/core/errors/auth_exception.dart';
import 'package:billing_and_sales_management/domain/auth/entities/auth_user.dart';
import 'package:billing_and_sales_management/features/auth/providers/login_provider.dart';
import 'package:billing_and_sales_management/features/auth/providers/password_visibility_provider.dart';
import 'package:billing_and_sales_management/features/home/screens/home_screen.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static final RegExp _emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ref.listenManual<AsyncValue<AuthUser?>>(loginProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user == null) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (context) => const HomeScreen()),
          );
        },
        error: (error, stackTrace) {
          final message = error is AuthException
              ? error.message
              : AuthException(AuthExceptionCodes.unknown).message;
          CustomSnackbar.showError(context, message);
        },
      );
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required';
    if (!_emailRegExp.hasMatch(email)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return null;
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    if (ref.read(loginProvider).isLoading) return;

    FocusScope.of(context).unfocus();

    await ref
        .read(loginProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);

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
                      SizedBox(height: AppSpacing.s2xl.h),
                      _buildHeader(),
                      SizedBox(height: AppSpacing.xl.h),
                      SizedBox(height: 25.h),
                      _buildForm(loginState.isLoading),
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

  Widget _buildForm(bool loading) {
    final passwordVisible = ref.watch(passwordVisibilityProvider);

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
            validator: _validateEmail,
          ),
          SizedBox(height: AppSpacing.base.h),
          CustomTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter password',
            obscureText: !passwordVisible,
            suffixIcon: IconButton(
              onPressed: () {
                ref.read(passwordVisibilityProvider.notifier).state =
                    !passwordVisible;
              },
              tooltip: passwordVisible ? 'Hide' : 'Show',
              icon: Icon(
                passwordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: AppDimensions.iconMd.r,
                color: AppColors.neutral400,
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            prefixIcon: Icon(Icons.lock_outline, size: 18.r),
            validator: _validatePassword,
          ),
          SizedBox(height: 24.h),
          CustomButton(text: 'Sign In', loading: loading, onPressed: _submit),
        ],
      ),
    );
  }
}
