import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/shared/models/models.dart';

class CustomSuggestButton extends ConsumerWidget {
  final Category? category;
  final String? label;
  final IconData? icon;
  final Function() onTap;

  // ignore: use_super_parameters
  const CustomSuggestButton({
    super.key,
    this.icon,
    this.label,
    this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return category != null
        ? GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.5),
              ),
              child: Column(
                children: [
                  Icon(
                    selectIcon(category!.categoryId),
                    color: Colors.white,
                    size: 30,
                  ),
                  const SizedBox(height: 5),
                  Text(category!.catergoryName,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.5),
              ),
              child: Column(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),
                  const SizedBox(height: 5),
                  Text(label!,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          );
  }
}

IconData selectIcon(int categroyId) {
  if (categroyId == 1) {
    return Icons.directions_bus;
  } else if (categroyId == 2) {
    return Icons.restaurant;
  } else {
    return Icons.local_activity;
  }
}
