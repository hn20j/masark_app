import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../l10n/app_text.dart';
import '../theme/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_error_message.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool _emailSent = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await context.read<AppState>().sendPasswordResetEmail(
            email: _emailController.text.trim(),
          );
      if (mounted) setState(() => _emailSent = true);
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      if (error.code == 'user-not-found') {
        setState(() => _emailSent = true);
      } else {
        _showMessage(
            firebaseAuthErrorMessage(context, error, signingUp: false));
      }
    } catch (_) {
      if (mounted) {
        _showMessage(AppText.of(context, 'تعذر إرسال رسالة الاستعادة.',
            'Could not send the reset email. Please try again.'));
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
          title:
              Text(AppText.of(context, 'استعادة الحساب', 'Recover account'))),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
          child: _emailSent ? _buildSuccess() : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildIcon(Icons.lock_reset_rounded),
          const SizedBox(height: 28),
          Text(
            AppText.of(context, 'نسيت كلمة المرور؟', 'Forgot your password?'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppText.of(
                context,
                'أدخل بريدك الإلكتروني وسنرسل إليك رابطًا لإعادة تعيين كلمة المرور.',
                'Enter your email and we will send a password reset link.'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
            autocorrect: false,
            style: const TextStyle(color: AppColors.textDark),
            decoration: const InputDecoration(
              hintText: 'Email address',
              prefixIcon: Icon(Icons.mail_outline, color: AppColors.textMuted),
            ),
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) {
                return AppText.of(context, 'الرجاء إدخال البريد الإلكتروني',
                    'Enter your email');
              }
              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                return AppText.of(context, 'يرجى إدخال بريد إلكتروني صحيح',
                    'Enter a valid email address');
              }
              return null;
            },
          ),
          const SizedBox(height: 22),
          PrimaryButton(
            label: AppText.of(context, 'متابعة', 'Continue'),
            icon: Icons.send_rounded,
            onPressed: _sendResetEmail,
            loading: _loading,
          ),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: Text(
                AppText.of(context, 'العودة لتسجيل الدخول', 'Back to sign in')),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildIcon(Icons.mark_email_read_outlined),
        const SizedBox(height: 28),
        Text(
          AppText.of(context, 'تحقق من بريدك', 'Check your email'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppText.of(
              context,
              'إذا كان البريد مرتبطًا بحساب، فستصلك رسالة لإعادة تعيين كلمة المرور. تحقق أيضًا من مجلد الرسائل غير المرغوب فيها.',
              'If an account matches that email, a password reset link will arrive shortly. Check your spam folder too.'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 30),
        PrimaryButton(
          label: AppText.of(context, 'العودة لتسجيل الدخول', 'Back to sign in'),
          icon: Icons.login_rounded,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => setState(() => _emailSent = false),
          child: Text(AppText.of(context, 'العودة', 'Back')),
        ),
      ],
    );
  }

  Widget _buildIcon(IconData icon) {
    return Align(
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: AppColors.surfaceIndigoLight,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(icon, color: AppColors.accentPink, size: 34),
      ),
    );
  }
}
