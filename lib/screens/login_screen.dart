import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../auth/iraqi_phone_number.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../theme/app_state.dart';
import '../widgets/language_selector.dart';
import 'signup_type_screen.dart';
import 'home_screen.dart';
import 'forgot_password_screen.dart';

enum _LoginMethod { email, phone }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  _LoginMethod _method = _LoginMethod.email;
  bool _phoneCodeSent = false;
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    if (_method == _LoginMethod.phone) {
      _showMessage(AppText.of(
        context,
        'تسجيل الدخول عبر الهاتف غير مهيأ. استخدم البريد الإلكتروني.',
        'Phone sign-in is not configured. Use email and password.',
      ));
      return;
    }
    final email = _emailCtrl.text.trim();
    setState(() => _loading = true);
    try {
      await context.read<AppState>().signIn(
            email: email,
            password: _passCtrl.text,
            homeCountry: AppText.of(context, 'العراق', 'Iraq'),
          );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } catch (error) {
      if (mounted) {
        _showMessage(AppState.errorMessage(error));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appPalette.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 40, 28, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: LanguageSelector(),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: context.appPalette.surfaceIndigoLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.auto_awesome,
                      color: AppColors.accentPink, size: 28),
                ),
                const SizedBox(height: 28),
                Text(
                  AppText.of(context, 'سجل الآن', 'Sign in'),
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: context.appPalette.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  AppText.of(context, 'ادخل بياناتك للمتابعة إلى حسابك',
                      'Enter your details to continue to your account'),
                  style: TextStyle(
                      fontSize: 13, color: context.appPalette.textSecondary),
                ),
                const SizedBox(height: 32),
                SegmentedButton<_LoginMethod>(
                  segments: [
                    ButtonSegment(
                      value: _LoginMethod.email,
                      label: Text(
                          AppText.of(context, 'البريد الإلكتروني', 'Email')),
                      icon: const Icon(Icons.mail_outline),
                    ),
                    ButtonSegment(
                      value: _LoginMethod.phone,
                      label: Text(AppText.of(context, 'رقم الهاتف', 'Phone')),
                      icon: const Icon(Icons.phone_outlined),
                    ),
                  ],
                  selected: {_method},
                  onSelectionChanged: _loading
                      ? null
                      : (selection) => setState(() {
                            _method = selection.first;
                            _phoneCodeSent = false;
                            _codeCtrl.clear();
                          }),
                ),
                const SizedBox(height: 20),
                if (_method == _LoginMethod.email) ...[
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: AppColors.textDark),
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      prefixIcon:
                          Icon(Icons.mail_outline, color: AppColors.textMuted),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return AppText.of(
                            context,
                            'الرجاء إدخال البريد الإلكتروني',
                            'Enter your email');
                      }
                      if (!v.contains('@')) {
                        return AppText.of(context, 'بريد إلكتروني غير صالح',
                            'Enter a valid email');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: AppColors.textDark),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColors.textMuted),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.length < 6) {
                        return AppText.of(
                            context,
                            'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
                            'Password must be at least 6 characters');
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ForgotPasswordScreen(
                            initialEmail: _emailCtrl.text.trim(),
                          ),
                        ),
                      ),
                      child: Text(AppText.of(
                          context, 'نسيت كلمة المرور؟', 'Forgot password?')),
                    ),
                  ),
                ] else ...[
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 11,
                    style: const TextStyle(color: AppColors.textDark),
                    decoration: InputDecoration(
                      labelText:
                          AppText.of(context, 'رقم الهاتف', 'Phone number'),
                      prefixIcon: const Icon(Icons.phone_outlined),
                      prefixText: '+964 ',
                      counterText: '',
                      hintText: '7XXXXXXXXX',
                    ),
                    validator: (value) =>
                        normalizeIraqiPhoneNumber(value ?? '') == null
                            ? AppText.of(context, 'أدخل رقمًا عراقيًا صالحًا.',
                                'Enter a valid Iraqi number.')
                            : null,
                  ),
                  if (_phoneCodeSent) ...[
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _codeCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(color: AppColors.textDark),
                      decoration: InputDecoration(
                        labelText: AppText.of(
                            context, 'رمز التحقق', 'Verification code'),
                        prefixIcon: const Icon(Icons.sms_outlined),
                      ),
                      validator: (value) => _phoneCodeSent &&
                              (value == null || value.trim().length < 6)
                          ? AppText.of(context, 'أدخل رمز الرسالة.',
                              'Enter the code from the SMS.')
                          : null,
                    ),
                  ],
                ],
                const SizedBox(height: 10),
                PrimaryButton(
                    label: _method == _LoginMethod.phone
                        ? _phoneCodeSent
                            ? AppText.of(
                                context, 'تحقق وسجل الدخول', 'Verify & sign in')
                            : AppText.of(
                                context, 'إرسال رمز التحقق', 'Send code')
                        : AppText.of(context, 'تسجيل', 'Sign in'),
                    onPressed: _login,
                    loading: _loading),
                const SizedBox(height: 18),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SignupTypeScreen()),
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: AppText.of(context, 'ليس لديك حساب؟ ',
                          "Don't have an account? "),
                      children: [
                        TextSpan(
                          text: AppText.of(context, 'أنشئ حسابك', 'Create one'),
                          style: const TextStyle(
                              color: AppColors.accentPink,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
