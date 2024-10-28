import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/features/trips/presentation/providers/expense_provider.dart';

class CustomSearchStatusDD extends ConsumerWidget {
  final List<String> options; // Cambia 'list' a 'options'
  final String texto;
  final Color color;

  const CustomSearchStatusDD({
    super.key,
    required this.options,
    required this.texto,
    required this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseNotifier = ref.read(expenseProvider.notifier); 

    return CustomDropdown(
      hintText: texto,
      items: options,
      onChanged: (value) {
        if (value == 'Pagado') {
          // Manejar la opción "Pagado"
          expenseNotifier.onStatusChanged("paid"); // Asigna el ID correspondiente
        } else if (value == 'Pendiente') {
          // Manejar la opción "Pendiente"
          expenseNotifier.onStatusChanged("pending"); // Asigna el ID correspondiente
        }
      },
      decoration: CustomDropdownDecoration(
        listItemStyle: const TextStyle(fontSize: 19),
        closedBorderRadius: BorderRadius.circular(16),
        closedBorder: Border.all(
          color: color,
          width: 1.0,
        ),
        hintStyle: TextStyle(
          fontSize: 19,
          color: color,
        ),
        headerStyle: TextStyle(
          color: color,
          fontSize: 20,
        ),
        closedFillColor: Colors.transparent,
        closedSuffixIcon: const Icon(
          Icons.expand_more,
          color: Colors.white,
        ),
        overlayScrollbarDecoration: const ScrollbarThemeData(),
      ),
      hideSelectedFieldWhenExpanded: true,
      listItemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      listItemBuilder: (context, item, isSelected, onTap) {
        return ListTile(
          title: Text(
            item,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 19,
            ),
          ),
          selected: isSelected,
          onTap: onTap,
        );
      },
      closedHeaderPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
    );
  }
}
