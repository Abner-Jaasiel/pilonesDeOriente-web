import 'package:flutter/material.dart';

class CustomButtonTextfieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double height;

  const CustomButtonTextfieldWidget({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.onTap,
    this.backgroundColor = const Color.fromARGB(17, 91, 135, 192),
    this.height = 55,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: GestureDetector(
        onTap: onTap ?? () {},
        child: Container(
          constraints: BoxConstraints(maxHeight: height),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(prefixIcon),
              const SizedBox(width: 8),
              Text(hintText),
            ],
          ),
        ),
      ),
    );
  }
}
