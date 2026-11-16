import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AnimatedSearchButton extends StatefulWidget {
  final String hintText;
  final String searchLabel;
  final String closeLabel;
  final ValueChanged<String> onChanged;

  const AnimatedSearchButton({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.searchLabel = 'Search',
    this.closeLabel = 'Close search',
  });

  @override
  State<AnimatedSearchButton> createState() => _AnimatedSearchButtonState();
}

class _AnimatedSearchButtonState extends State<AnimatedSearchButton> {
  static const double _height = 52;
  static const double _collapsedWidth = 52;
  static const double _contentThreshold = 120;

  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isExpanded = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _expand() {
    setState(() => _isExpanded = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  void _collapse() {
    _focusNode.unfocus();
    setState(() => _isExpanded = false);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final animationDuration = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 420);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth =
            constraints.maxWidth.isFinite ? constraints.maxWidth : 360.0;
        final compactWidth =
            availableWidth < _collapsedWidth ? availableWidth : _collapsedWidth;
        final targetWidth = _isExpanded ? availableWidth : compactWidth;

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: compactWidth, end: targetWidth),
          duration: animationDuration,
          curve: Curves.easeInOutCubicEmphasized,
          builder: (context, width, _) {
            final progress = availableWidth == compactWidth
                ? 0.0
                : ((width - compactWidth) / (availableWidth - compactWidth))
                    .clamp(0.0, 1.0);
            final showSearchField = width >= _contentThreshold;
            final backgroundColor = Color.lerp(
              AppColors.primaryViolet,
              palette.surfaceIndigo,
              progress,
            )!;

            return Align(
              alignment: AlignmentDirectional.centerStart,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.pill),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: width,
                  height: _height,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(
                      AppRadii.pill - (AppRadii.pill - AppRadii.md) * progress,
                    ),
                    border: Border.all(
                      color: Color.lerp(
                        Colors.transparent,
                        AppColors.primaryViolet.withValues(alpha: 0.65),
                        progress,
                      )!,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IgnorePointer(
                        ignoring: _isExpanded,
                        child: Opacity(
                          opacity: 1 - progress,
                          child: IconButton(
                            tooltip: widget.searchLabel,
                            onPressed: _expand,
                            icon: const Icon(Icons.search),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (showSearchField)
                        IgnorePointer(
                          ignoring: progress < 0.8,
                          child: Opacity(
                            opacity: progress,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    focusNode: _focusNode,
                                    onChanged: widget.onChanged,
                                    textAlign: TextAlign.start,
                                    textInputAction: TextInputAction.search,
                                    style: TextStyle(
                                      color: palette.textPrimary,
                                      fontSize: 14,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: widget.hintText,
                                      filled: false,
                                      fillColor: Colors.transparent,
                                      hintStyle: TextStyle(
                                        color: palette.textMuted,
                                        fontSize: 13,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        size: 20,
                                        color: AppColors.primaryViolet,
                                        semanticLabel: widget.searchLabel,
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                        minWidth: 40,
                                        maxHeight: 36,
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 0,
                                        maxHeight: 36,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: widget.closeLabel,
                                  onPressed: _collapse,
                                  icon: const Icon(Icons.close, size: 20),
                                  color: palette.textSecondary,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints.tightFor(
                                    width: 36,
                                    height: 36,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
