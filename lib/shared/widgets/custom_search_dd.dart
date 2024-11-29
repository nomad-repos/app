import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/features/trips/presentation/providers/expense_provider.dart';
import 'package:nomad_app/features/trips/trip.dart';

import '../models/models.dart';

class CustomSearchDD extends ConsumerWidget {
  final List list;
  final String texto;
  final String searchText;
  final Color color;

  const CustomSearchDD(
      {super.key,
      required this.list,
      required this.texto,
      required this.searchText,
      required this.color});

  List<dynamic> verifyListContent() {
    List<dynamic> listaItem = [];

    if (list.isNotEmpty) {
      var firstElement = list.first;

      if (firstElement is Location) {
        listaItem = list
            .map((location) => location as Location)
            .toList(); // Devolver instancias de Location
      } else {
        listaItem = list
            .map((category) => category as Category)
            .toList(); // Devolver instancias de Category
      }
    }
    return listaItem;
  }

  setSelectedOption(dynamic value, FindActivityNotifier findActivityPro) {
    if (list.isNotEmpty) {
      var firstElement = list.first;

      if (firstElement is Location) {
        findActivityPro.setLocation(value); // Ahora pasas la instancia completa de Location
      } else {
        findActivityPro.setCategory(value); // Ahora pasas la instancia completa de Category
      }
    }
  }

  // Esta función ahora solo devolverá el valor categoryId directamente.
  int? getCategoryId(dynamic value) {
    if (value is Category) {
      return value.categoryId;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<dynamic> items = verifyListContent(); // Ahora contiene las instancias
    final findActivityPro = ref.watch(findActivityProvider.notifier);
    final expenseNotifier = ref.read(expenseProvider.notifier); 

    return CustomDropdown(
      hintText: texto,
      items: items.map((item) {
        if (item is Location) {
          return item.localityName; // Muestra el nombre en el dropdown
        } else if (item is Category) {
          return item.catergoryName; // Muestra el nombre en el dropdown
        }
        return '';
      }).toList(),
      onChanged: (value) {
        final selectedItem = items.firstWhere((item) {
          if (item is Location) {
            return item.localityName == value;
          } else if (item is Category) {
            return item.catergoryName == value;
          }
          return false;
        });
        setSelectedOption(selectedItem, findActivityPro); 
        //expenseNotifier.onCategoryChanged(selectedItem.categoryId);
      },

      decoration: CustomDropdownDecoration(
        listItemStyle: const TextStyle( fontSize: 19),
        closedBorderRadius: BorderRadius.circular(16),
        closedBorder: Border.all(
          color: color,
          width: 1.0,
        ),
        hintStyle:  TextStyle(
          fontSize: 19,
          color: color,
        ),
        headerStyle:  TextStyle(
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
