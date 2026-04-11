import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTextStyles.heading3),
      centerTitle: centerTitle,
      actions: actions,
      leading: leading,
      backgroundColor: backgroundColor ?? AppColors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
