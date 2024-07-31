import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String selectedValue;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    Key? key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 7,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        underline: const SizedBox.shrink(),
        iconSize: 25,
        isDense: true,
        value: selectedValue,
        borderRadius: BorderRadius.circular(5),
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
