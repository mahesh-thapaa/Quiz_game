// lib/screens/settings/widgets/settings_dropdown_tile.dart

import 'package:flutter/material.dart';
import 'package:quiz_game/models/colors.dart';

class SettingsDropdownTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final Color? iconColor;
  final Color? labelColor;
  final Color? valueColor;
  final Color? dropdownBg;
  final Color? dropdownBorder;

  const SettingsDropdownTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.iconColor,
    this.labelColor,
    this.valueColor,
    this.dropdownBg,
    this.dropdownBorder,
  });

  @override
  State<SettingsDropdownTile> createState() => _SettingsDropdownTileState();
}

class _SettingsDropdownTileState extends State<SettingsDropdownTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: widget.iconColor ?? AppColors.stext,
                  size: 20,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: widget.labelColor ?? AppColors.hText,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.value,
                        style: TextStyle(
                          color: widget.valueColor ?? AppColors.stext,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: widget.iconColor ?? AppColors.stext,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: widget.dropdownBg ?? AppColors.deepCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: widget.dropdownBorder ?? AppColors.divider,
              ),
            ),
            child: Column(
              children: widget.options.map((opt) {
                final isSelected = opt == widget.value;
                return GestureDetector(
                  onTap: () {
                    widget.onChanged(opt);
                    setState(() => _expanded = false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            opt,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.primary
                                  : (widget.labelColor ?? AppColors.hText),
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check,
                            color: AppColors.primary,
                            size: 16,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}
