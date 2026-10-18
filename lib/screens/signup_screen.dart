import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../auth/iraqi_phone_number.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../theme/app_state.dart';
import '../widgets/auth_error_message.dart';
import '../widgets/profile_details_fields.dart';
import 'login_screen.dart';
import 'cv_upload_screen.dart';

enum _SignupMethod { email, phone }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileFieldsKey = GlobalKey<ProfileDetailsFieldsState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  _SignupMethod _method = _SignupMethod.email;
  bool _phoneCodeSent = false;
  bool _phoneCompletionInProgress = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    if (_method == _SignupMethod.phone) {
      if (_phoneCodeSent) {
        await _completePhoneSignup();
      } else {
        await _requestPhoneCode();
      }
      return;
    }
    final email = _emailCtrl.text.trim();
    final profile = _profileFieldsKey.currentState!.value;
    setState(() => _loading = true);
    try {
      await context.read<AppState>().signUp(
            name: _nameCtrl.text.trim(),
            email: email,
            password: _passCtrl.text,
            homeCountry: AppText.of(context, 'العراق', 'Iraq'),
            birthdate: profile.birthdate,
            governorate: profile.governorate,
            governorateRegion: profile.governorateRegion,
            academicAchievement: profile.academicAchievement,
            workPreferences: profile.workPreferences,
            workLocation: profile.workLocation,
          );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (_) => const CvUploadScreen(isOnboardingFlow: true)),
        (route) => false,
      );
    } on FirebaseException catch (error, stackTrace) {
      logAuthenticationFailure(error, stackTrace);
      if (mounted) {
        _showMessage(firebaseAuthErrorMessage(context, error, signingUp: true));
      }
    } catch (error, stackTrace) {
      logAuthenticationFailure(error, stackTrace);
      if (mounted) {
        _showMessage(AppText.of(context, 'تعذر إنشاء الحساب. حاول مجددًا.',
            'Could not create the account. Please try again.'));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _requestPhoneCode() async {
    final phoneNumber = normalizeIraqiPhoneNumber(_phoneCtrl.text);
    if (phoneNumber == null) return;
    setState(() => _loading = true);
    try {
      await context.read<AppState>().sendPhoneVerificationCode(
            phoneNumber: phoneNumber,
            onCodeSent: () {
              if (mounted) setState(() => _phoneCodeSent = true);
            },
            onVerificationFailed: (error) {
              if (mounted) {
                _showMessage(
                    firebaseAuthErrorMessage(context, error, signingUp: true));
              }
            },
            onVerificationCompleted: (credential) {
              unawaited(_completePhoneSignup(credential: credential));
            },
          );
    } on FirebaseException catch (error, stackTrace) {
      logAuthenticationFailure(error, stackTrace);
      if (mounted) {
        _showMessage(firebaseAuthErrorMessage(context, error, signingUp: true));
      }
    } catch (error, stackTrace) {
      logAuthenticationFailure(error, stackTrace);
      if (mounted) {
        _showMessage(AppText.of(context, 'تعذر إرسال رمز التحقق.',
            'Could not send the verification code.'));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _completePhoneSignup({PhoneAuthCredential? credential}) async {
    if (_phoneCompletionInProgress) return;
    _phoneCompletionInProgress = true;
    setState(() => _loading = true);
    try {
      final state = context.read<AppState>();
      final authCredential = credential == null
          ? await state.confirmPhoneCode(_codeCtrl.text.trim())
          : await state.signInWithPhoneCredential(credential);
      if (authCredential.additionalUserInfo?.isNewUser != true) {
        await state.signOut();
        if (mounted) {
          _showMessage(AppText.of(
              context,
              'هذا الرقم مسجل بالفعل. سجّل الدخول بدلًا من إنشاء حساب.',
              'This number is already registered. Sign in instead.'));
        }
        return;
      }
      final profile = _profileFieldsKey.currentState!.value;
      await state.completePhoneSignUpProfile(
        name: _nameCtrl.text.trim(),
        birthdate: profile.birthdate,
        governorate: profile.governorate,
        governorateRegion: profile.governorateRegion,
        academicAchievement: profile.academicAchievement,
        workPreferences: profile.workPreferences,
        workLocation: profile.workLocation,
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (_) => const CvUploadScreen(isOnboardingFlow: true)),
        (route) => false,
      );
    } on FirebaseException catch (error, stackTrace) {
      logAuthenticationFailure(error, stackTrace);
      if (mounted) {
        _showMessage(firebaseAuthErrorMessage(context, error, signingUp: true));
      }
    } catch (error, stackTrace) {
      logAuthenticationFailure(error, stackTrace);
      if (mounted) {
        _showMessage(AppText.of(context, 'تعذر إنشاء الحساب. حاول مجددًا.',
            'Could not create the account. Please try again.'));
      }
    } finally {
      _phoneCompletionInProgress = false;
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
      backgroundColor: AppColors.surfaceIndigo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 40, 28, 24),
          child: Theme(
            data: Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme.copyWith(
                    bodyLarge: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.black),
                  ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    AppText.of(context, 'إنشاء الحساب', 'Create account'),
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppText.of(context, 'خطوة واحدة تفصلك عن أول تقديم لك',
                        'One step away from your first application'),
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 32),
                  SegmentedButton<_SignupMethod>(
                    segments: [
                      ButtonSegment(
                        value: _SignupMethod.email,
                        label: Text(
                            AppText.of(context, 'البريد الإلكتروني', 'Email')),
                        icon: const Icon(Icons.mail_outline),
                      ),
                      ButtonSegment(
                        value: _SignupMethod.phone,
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
                  TextFormField(
                    controller: _nameCtrl,
                    maxLength: 120,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: AppColors.textDark),
                    decoration: InputDecoration(
                        hintText:
                            AppText.of(context, 'الاسم الكامل', 'Full name')),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? AppText.of(
                            context, 'الرجاء إدخال اسمك', 'Enter your name')
                        : null,
                  ),
                  const SizedBox(height: 14),
                  ProfileDetailsFields(key: _profileFieldsKey),
                  const SizedBox(height: 14),
                  if (_method == _SignupMethod.email) ...[
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.start,
                      style: const TextStyle(color: AppColors.textDark),
                      decoration: InputDecoration(
                          hintText: AppText.of(
                              context, 'البريد الإلكتروني', 'Email address')),
                      validator: (v) {
                        if (v == null || !v.contains('@')) {
                          return AppText.of(context, 'بريد إلكتروني غير صالح',
                              'Enter a valid email');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: true,
                      textAlign: TextAlign.start,
                      style: const TextStyle(color: AppColors.textDark),
                      decoration: InputDecoration(
                          hintText:
                              AppText.of(context, 'كلمة المرور', 'Password')),
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
                              ? AppText.of(
                                  context,
                                  'أدخل رقمًا عراقيًا صالحًا.',
                                  'Enter a valid Iraqi number.')
                              : null,
                    ),
                    if (_phoneCodeSent) ...[
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _codeCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
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
                  const SizedBox(height: 28),
                  PrimaryButton(
                      label: _method == _SignupMethod.phone
                          ? _phoneCodeSent
                              ? AppText.of(
                                  context, 'إنشاء الحساب', 'Create account')
                              : AppText.of(
                                  context, 'إرسال رمز التحقق', 'Send code')
                          : AppText.of(context, 'إنشاء', 'Create account'),
                      onPressed: _signup,
                      loading: _loading),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: Text(AppText.of(context, 'تسجيل الدخول', 'Sign in')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
