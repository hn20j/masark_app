import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../l10n/app_text.dart';

String firebaseAuthErrorMessage(
  BuildContext context,
  FirebaseException error, {
  required bool signingUp,
}) {
  final message = switch (error.code) {
    'email-already-in-use' => (
        'هذا البريد الإلكتروني مستخدم بالفعل.',
        'This email address is already in use.'
      ),
    'invalid-email' => (
        'صيغة البريد الإلكتروني غير صحيحة.',
        'Enter a valid email address.'
      ),
    'weak-password' => (
        'كلمة المرور ضعيفة. استخدم 6 أحرف على الأقل.',
        'Password is too weak. Use at least 6 characters.'
      ),
    'user-disabled' => (
        'تم تعطيل هذا الحساب. تواصل مع الدعم.',
        'This account has been disabled. Contact support.'
      ),
    'user-not-found' || 'wrong-password' || 'invalid-credential' => (
        'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
        'The email or password is incorrect.'
      ),
    'operation-not-allowed' => (
        'فعّل مزود تسجيل الدخول المطلوب في Firebase Authentication.',
        'Enable the requested sign-in provider in Firebase Authentication.'
      ),
    'account-type-mismatch' => (
        'نوع الحساب لا يطابق الخيار المحدد. اختر نوع الحساب الصحيح.',
        'This account uses a different account type. Choose the matching option.'
      ),
    'invalid-phone-number' => (
        'رقم الهاتف غير صالح. استخدم رقمًا عراقيًا يبدأ بـ 07.',
        'Invalid phone number. Enter an Iraqi mobile number starting with 07.'
      ),
    'invalid-verification-code' => (
        'رمز التحقق غير صحيح.',
        'The verification code is incorrect.'
      ),
    'code-expired' || 'session-expired' => (
        'انتهت صلاحية رمز التحقق. اطلب رمزًا جديدًا.',
        'The verification code expired. Request a new code.'
      ),
    'quota-exceeded' => (
        'تم تجاوز حد الرسائل. حاول لاحقًا.',
        'SMS quota exceeded. Try again later.'
      ),
    'network-request-failed' => (
        'تعذر الاتصال بالإنترنت. تحقق من اتصالك وحاول مجددًا.',
        'Could not connect. Check your internet connection and try again.'
      ),
    'permission-denied' => (
        'رفض Firebase حفظ بيانات الحساب. تحقق من صلاحيات Firestore.',
        'Firebase denied access to the account data. Check the Firestore rules.'
      ),
    'unavailable' || 'deadline-exceeded' => (
        'خدمة Firebase غير متاحة حاليًا. تحقق من الاتصال وحاول مجددًا.',
        'Firebase is temporarily unavailable. Check your connection and retry.'
      ),
    'failed-precondition' => (
        'إعداد Firebase غير مكتمل لهذه العملية.',
        'Firebase is not fully configured for this operation.'
      ),
    'too-many-requests' => (
        'محاولات كثيرة. انتظر قليلًا ثم حاول مجددًا.',
        'Too many attempts. Wait a moment and try again.'
      ),
    _ => signingUp
        ? (
            'تعذر إنشاء الحساب. حاول مجددًا.',
            'Could not create the account. Please try again.'
          )
        : (
            'تعذر تسجيل الدخول. حاول مجددًا.',
            'Could not sign in. Please try again.'
          ),
  };
  return AppText.of(context, message.$1, message.$2);
}

void logAuthenticationFailure(Object error, StackTrace stackTrace) {
  final category = error is FirebaseException
      ? '${error.plugin}/${error.code}'
      : error.runtimeType.toString();
  debugPrint('Authentication operation failed: $category');
  debugPrintStack(stackTrace: stackTrace);
}
