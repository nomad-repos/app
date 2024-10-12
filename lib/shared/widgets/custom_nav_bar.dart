import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:nomad_app/shared/presentation/presentation.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);

    return  ClipRRect(                                                            
          borderRadius: const BorderRadius.only(                                           
          topLeft: Radius.circular(30.0),                                            
          topRight: Radius.circular(30.0),                                           
        ),   
        child: BottomNavigationBar(
          currentIndex: indexBottomNavbar,
          onTap: (value) {
            ref.read(indexBottomNavbarProvider.notifier).update((state) => value);
        
            switch (value) {
              case 0:
                context.replace('/home_trip_screen');
                break;
              case 1:
                context.replace('/wallet_screen');
                break;
              case 2:
                break;
              case 3:
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Finanzas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Mapa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Perfil',
            ),
          ],
          iconSize: 28,
          selectedItemColor: Colors.deepOrange, // Color de los íconos seleccionados
          unselectedItemColor: Colors.grey, // Color de los íconos no seleccionados
          type: BottomNavigationBarType.fixed, // Asegura que los íconos no desaparezcan
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