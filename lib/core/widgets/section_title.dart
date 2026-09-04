import 'package:flutter/material.dart';
import 'package:scadar/core/constants/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Color? color;

  const SectionTitle(
    this.title, {
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.primary,
      ),
    );
  }
}
