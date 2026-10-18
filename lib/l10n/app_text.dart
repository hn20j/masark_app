import 'package:flutter/material.dart';

class AppText {
  static const _englishContent = {
    'مطوّر تطبيقات Flutter': 'Flutter App Developer',
    'شركة نبراس التقنية': 'Nibras Technology',
    'بغداد، العراق': 'Baghdad, Iraq',
    'دوام كامل': 'Full-time',
    'محلل بيانات': 'Data Analyst',
    'مجموعة الرافدين المالية': 'Al-Rafidain Financial Group',
    'أربيل، العراق': 'Erbil, Iraq',
    'أخصائي تسويق رقمي': 'Digital Marketing Specialist',
    'داماس ميديا': 'Damas Media',
    'دبي، الإمارات (عن بعد)': 'Dubai, UAE (Remote)',
    'عن بعد': 'Remote',
    'عن بُعد': 'Remote',
    'مهندس شبكات': 'Network Engineer',
    'اتصالات الشرق': 'East Telecom',
    'البصرة، العراق': 'Basra, Iraq',
  };

  static String of(BuildContext context, String arabic, String english) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? arabic
        : english;
  }

  static String content(BuildContext context, String value) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? value
        : _englishContent[value] ?? value;
  }
}
