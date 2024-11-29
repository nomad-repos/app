

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:nomad_app/shared/presentation/presentation.dart';

import '../../features/trips/presentation/providers/expense_provider.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25.0),
      ),
      child: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacio entre los íconos
          children: [
            _buildBottomNavItem(
              context,
              icon: Icons.home,
              label: 'Inicio',
              index: 0,
              currentIndex: indexBottomNavbar,
              paddingLeft: 15,
              ref: ref,
            ),
            _buildBottomNavItem(
              context,
              icon: Icons.attach_money,
              label: 'Finanzas',
              index: 1,
              currentIndex: indexBottomNavbar,
              ref: ref,
              paddingLeft: 15,
              paddingRight: 20 // Espacio a la izquierda para "Finanzas"
            ),
            _buildBottomNavItem(
              context,
              icon: Icons.map,
              label: 'Mapa',
              index: 2,
              currentIndex: indexBottomNavbar,
              ref: ref,
              paddingLeft: 20,
              paddingRight: 15, // Espacio a la derecha para "Mapa"
            ),
            _buildBottomNavItem(
              context,
              icon: Icons.group,
              label: 'Perfil',
              index: 3,
              currentIndex: indexBottomNavbar,
              paddingRight: 20,
              ref: ref,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(BuildContext context, {required IconData icon, required String label, required int index, required int currentIndex, required WidgetRef ref, double paddingLeft = 0, double paddingRight = 0}) {
    return GestureDetector(
      onTap: () {
        ref.read(indexBottomNavbarProvider.notifier).update((state) => index);
        switch (index) {
          case 0:
            context.replace('/home_trip_screen');
            break;
          case 1:
            ref.read(expenseProvider.notifier).getExpenses();
            context.replace('/wallet_screen');
            break;
          case 2:
            context.replace('/general_map_screen');
            break;
          case 3:
            context.replace('/profile_screen');
            break;
        }
      },
      child: Padding(
        padding: EdgeInsets.only(left: paddingLeft, right: paddingRight, top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: currentIndex == index ? Colors.deepOrange : Colors.grey,
              size: 28,
            ),
            Text(
              label,
              style: TextStyle(
                color: currentIndex == index ? Colors.deepOrange : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// GNav(
//           selectedIndex: indexBottomNavbar,
//           onTabChange: (value) {
//             ref.read(indexBottomNavbarProvider.notifier).update((state) => value);
//             switch (value) {
//               case 0:
//                 context.replace('/home');
//                 break;
//               case 1:
//                 calendarNotifier.reset();
//                 calendarNotifier.getDepartments(); 
//                 context.replace('/calendar', extra: UniqueKey());
//                 break;
//               case 2:
//                 context.replace('/contact');
//                 break;
//             }
//           },
//           tabs: const [
//             GButton(
//               icon: Icons.home,
//               text: 'Inicio',
//             ),
//             GButton(
//               icon: Icons.calendar_month,
//               text: 'Calendario',
//             ),
//             GButton(
//               icon: Icons.phone,
//               text: 'Contacto',
//             ),
//           ],
//           gap: 8,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           tabBackgroundColor: Color.fromARGB(255, 214, 138, 134).withOpacity(0.3),
//           textStyle: const TextStyle(fontSize: 14, color: Colors.black),
//         ),