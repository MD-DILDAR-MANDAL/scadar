import 'package:flutter/material.dart';
import 'package:scadar/core/constants/app_colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final void Function(T?) onChanged;
  final String Function(T)? displayText;
  final bool isExpanded;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.displayText,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        color: AppColors.tertiary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: isExpanded,
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
          items: items.map<DropdownMenuItem<T>>((T val) {
            return DropdownMenuItem<T>(
              value: val,
              child: Text(
                displayText != null ? displayText!(val) : val.toString(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
