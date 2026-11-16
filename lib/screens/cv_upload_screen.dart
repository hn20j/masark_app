import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../theme/app_state.dart';
import 'cv_builder_screen.dart';
import 'home_screen.dart';

/// Wireframe 5: the CV upload prompt card with the pink "ارفع" CTA.
/// [isOnboardingFlow] controls whether this is shown right after signup
/// (in which case we route into the CV builder / home afterwards) or
/// re-opened later from Home to replace an existing CV.
class CvUploadScreen extends StatefulWidget {
  final bool isOnboardingFlow;
  const CvUploadScreen({super.key, this.isOnboardingFlow = false});

  @override
  State<CvUploadScreen> createState() => _CvUploadScreenState();
}

class _CvUploadScreenState extends State<CvUploadScreen> {
  bool _picking = false;
  String? _pickedFileName;

  Future<void> _pickCv() async {
    setState(() => _picking = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        withData: true,
      );
      if (result == null || result.files.isEmpty || !mounted) return;
      final PlatformFile file = result.files.first;
      final bytes = file.bytes;
      if (bytes == null) {
        throw StateError('The selected file could not be read.');
      }
      final mimeType = switch (file.extension?.toLowerCase()) {
        'pdf' => 'application/pdf',
        'doc' => 'application/msword',
        'docx' =>
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        _ => throw StateError('Choose a PDF, DOC, or DOCX file.'),
      };
      await context.read<AppState>().attachCv(
            fileName: file.name,
            bytes: bytes,
            mimeType: mimeType,
          );
      if (mounted) setState(() => _pickedFileName = file.name);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppState.errorMessage(error))),
        );
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  void _continue() {
    if (widget.isOnboardingFlow) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (_) => const CvBuilderScreen(fromOnboarding: true)),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appPalette.background,
      appBar: widget.isOnboardingFlow
          ? null
          : AppBar(
              title:
                  Text(AppText.of(context, 'رفع السيرة الذاتية', 'Upload CV'))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.cardLight,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppColors.pinkGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.description_outlined,
                          color: Colors.white, size: 26),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _pickedFileName == null
                          ? AppText.of(
                              context, 'ارفع سيرتك الذاتية', 'Upload your CV')
                          : AppText.of(
                              context, 'تم اختيار الملف', 'File selected'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _pickedFileName ??
                          AppText.of(
                              context,
                              'ارفع سيرتك الذاتية لحفظها في ملفك الشخصي بأمان.',
                              'Upload your CV to store it in your profile securely.'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                          height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    PinkButton(
                      label: _picking
                          ? AppText.of(context, 'جارٍ الرفع...', 'Uploading...')
                          : (_pickedFileName == null
                              ? AppText.of(context, 'ارفع', 'Upload')
                              : AppText.of(
                                  context, 'استبدال الملف', 'Replace file')),
                      icon: Icons.upload_file_outlined,
                      onPressed: _picking ? null : _pickCv,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppText.of(context, 'PDF, DOC, DOCX — حتى 5 ميجابايت',
                          'PDF, DOC, DOCX — up to 5 MB'),
                      style: TextStyle(
                          color: AppColors.textMuted.withValues(alpha: 0.8),
                          fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (_pickedFileName != null)
                PrimaryButton(
                    label: AppText.of(context, 'متابعة', 'Continue'),
                    onPressed: _continue)
              else
                TextButton(
                  onPressed: () {
                    if (widget.isOnboardingFlow) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(AppText.of(context, 'تخطي الآن، سأرفعها لاحقًا',
                      'Skip for now, upload it later')),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
