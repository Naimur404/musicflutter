import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/constants.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onClear;
  
  const CustomSearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Search for songs, artists, or albums',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: FONT_SIZE_MEDIUM,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: FONT_SIZE_MEDIUM,
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              child: const Icon(
                Icons.clear_rounded,
                color: Colors.grey,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}