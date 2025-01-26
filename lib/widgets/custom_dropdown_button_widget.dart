import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String? selectedCountry;
  final Function(String?)? onChanged;
  final List<String> countries;
  final String hint;

  const CustomDropdownButton({
    super.key,
    required this.selectedCountry,
    required this.onChanged,
    required this.countries,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // Usamos el color de fondo del tema
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: theme.dividerColor, // Usa el color de borde según el tema
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor
                .withOpacity(0.1), // Sombra ajustada según tema
            blurRadius: 5.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: selectedCountry,
        hint: Text(
          hint,
          style: TextStyle(
            color: theme
                .textTheme.bodyLarge?.color, // Color de texto según el tema
            fontSize: 16,
          ),
        ),
        onChanged: onChanged,
        underline: const SizedBox(),
        isExpanded: true,
        icon: Icon(
          Icons.arrow_drop_down,
          color: theme.iconTheme.color, // Color del ícono según el tema
        ),
        items: countries.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: theme.textTheme.bodyMedium
                    ?.color, // Color del texto según el tema
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
