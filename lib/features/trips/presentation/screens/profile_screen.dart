import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/features/trips/presentation/providers/trip_provider.dart';
import 'package:nomad_app/helpers/helpers.dart';
import 'package:nomad_app/shared/presentation/providers/botom_nav_bar_provider.dart';
import 'package:nomad_app/shared/widgets/custom_nav_bar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                
                //Boton para eliminar el viaje
                ListTile(
                  title: const Text('Eliminar viaje'),
                  leading: const Icon(Icons.delete),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Eliminar viaje'),
                          content: const Text('¿Estás seguro de que deseas eliminar este viaje?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                showSnackbar(context, "Funcionalidad en consutrcción", Colors.red); 
                                context.pop(  );
                              },
                              child: const Text('Eliminar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),


              ],
            ),
          ),
        ),
      ),  

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          width: 70,
          height: 65,
          child: FloatingActionButton(
            onPressed: () async {
              await ref.read(tripProvider.notifier).getEvents();
              ref.read(indexBottomNavbarProvider.notifier).update((state) => 4);
              context.push('/calendar_screen');
            },
            backgroundColor: Colors.deepOrange,
            shape: const CircleBorder(),
            child:  const Icon(Icons.calendar_today, color: Colors.white,),
          ),
        ),

      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}