import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool filled;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<PointerDownEvent>? onTapOutside;
  final TextInputType keyboardType;
  final double height;
  final bool obscureText;
  final TextEditingController? controller;
  final bool autofocus;
  final FocusNode? focusNode;
  final Color? backgroundColor;
  final double maxWidth;
  const CustomTextField(
      {super.key,
      required this.hintText,
      required this.prefixIcon,
      this.filled = false,
      this.onChanged,
      this.onTap,
      this.onTapOutside,
      this.keyboardType = TextInputType.text,
      this.height = 55,
      this.obscureText = false,
      this.controller,
      this.autofocus = false,
      this.focusNode,
      this.backgroundColor = const Color.fromARGB(17, 91, 135, 192),
      this.maxWidth = 500});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      height: height,
      child: Center(
        child: TextField(
          controller: controller,
          textAlignVertical: TextAlignVertical.center,
          focusNode: focusNode,
          autofocus: autofocus,
          decoration: InputDecoration(
            filled: filled,
            fillColor: filled ? backgroundColor : null,
            contentPadding: EdgeInsets.zero,
            prefixIcon: Icon(prefixIcon),
            hintText: hintText,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          onTap: onTap ?? () {},
          onTapOutside: onTapOutside ?? (x) {},
        ),
      ),
    );
  }
}

class CustomButtonSearch extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool filled;
  final VoidCallback? onTap;
  final ValueChanged<PointerDownEvent>? onTapOutside;
  final double height;
  final bool obscureText;
  final TextEditingController? controller;
  final bool autofocus;
  final FocusNode? focusNode;
  final Color? backgroundColor;
  final double maxWidth;

  const CustomButtonSearch({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.filled = false,
    this.onTap,
    this.onTapOutside,
    this.height = 55,
    this.obscureText = false,
    this.controller,
    this.autofocus = false,
    this.focusNode,
    this.backgroundColor = const Color.fromARGB(17, 91, 135, 192),
    this.maxWidth = 500,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color buttonTextColor =
        theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    final Color buttonBackgroundColor =
        filled ? backgroundColor ?? theme.primaryColor : Colors.transparent;
    final Color borderColor = theme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.5)
        : Colors.black.withOpacity(0.3);

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      height: height,
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: buttonBackgroundColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            height: height,
            child: Row(
              children: [
                Icon(prefixIcon, color: buttonTextColor),
                const SizedBox(width: 10),
                Text(
                  hintText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
