import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/features/trips/presentation/presentation.dart';

import 'package:nomad_app/features/trips/trip.dart';
import 'package:nomad_app/shared/shared.dart';


class HomeTripScreen extends ConsumerWidget {
  const HomeTripScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 

    final tripState = ref.watch(tripProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/iniciarsesion.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 2, 15, 21).withOpacity(0.7),
            ),
          ),
           SingleChildScrollView(
             child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    
                    //Botones de navegación
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.go('/home_screen');
                            }, 
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                                  
                          Expanded(child: Container()),
                                  
                          IconButton(
                            onPressed: () {
                              context.go('/home_screen');
                            }, 
                            icon: const Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
              
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    
                    //Nombre del viaje
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Mi viaje ${tripState.trip!.tripName}", 
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 30, 
                            fontWeight: FontWeight.w300, 
                            overflow: TextOverflow.ellipsis,
                          )
                        ),
                      ),
                    ),
              
                    const SizedBox(height: 20),
             
                    //Dias restantes
                    Row(
                      children: [
                        Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width * 0.4,
                          color: Colors.deepOrange,
                        ),
              
                        Container(
                          padding: const  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            tripState.dayRemaining,
                            textAlign: TextAlign.center, 
                            style: const TextStyle(
                              color: Colors.white, 
                              fontSize: 20
                            )
                          ),
                        ),
              
                        Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width * 0.1,
                          color: Colors.deepOrange,
                        ),
                      ],
                    ),
             
                    const SizedBox(height: 50),
             
                    //Te sugerimos
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        width: double.infinity,
                        
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                      
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            const Text(
                              "Te sugerimos", 
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 20
                              )
                            ),
                            
                            const SizedBox(height: 10),
             
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                              
                                  SuggestButton(
                                    label: 'Restoran', 
                                    icon: Icons.restaurant, 
                                    onTap: () {
                                      print('Restoran');
                                    }
                                  ),
                              
                                  const SizedBox(width: 10),
                              
                                  SuggestButton(
                                    label: "Transporte", 
                                    icon: Icons.directions_bus, 
                                    onTap: () {
                                      print('Transporte');
                                    }
                                  ),
                              
                                  const SizedBox(width: 10),
                              
                                  SuggestButton(
                                    label: "Shopping", 
                                    icon: Icons.shopping_cart, 
                                    onTap: () {
                                      print('Shopping');
                                    }
                                  ),
             
                                  const SizedBox(width: 10),
             
                                  SuggestButton(
                                    label: 'Cafés', 
                                    icon: Icons.local_cafe, 
                                    onTap: () {
                                      print('Cafés');
                                    }
                                  ),
                              
                                  const SizedBox(width: 10),
                              
                                  SuggestButton(
                                    label: "Actividades", 
                                    icon: Icons.local_activity, 
                                    onTap: () {
                                      print('Actividades');
                                    }
                                  ),
                                  
                                  
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
             
                    const SizedBox(height: 20),
             
                    //Mis archivos
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        width: double.infinity,
                        
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                      
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            const Text(
                              "Mis archivos", 
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 20
                              )
                            ),
                            
                            const SizedBox(height: 10),
             
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                              
                                  SuggestButton(
                                    label: 'Comprobante', 
                                    icon: Icons.receipt, 
                                    onTap: () {
                                      print('Comprobante');
                                    }
                                  ),
                              
                                  const SizedBox(width: 10),
                              
                                  SuggestButton(
                                    label: "Entradas", 
                                    icon: Icons.confirmation_number, 
                                    onTap: () {
                                      print('Entradas');
                                    }
                                  ),
                              
                                  const SizedBox(width: 10),
                              
                                  SuggestButton(
                                    label: "Pasajes", 
                                    icon: Icons.airplanemode_active, 
                                    onTap: () {
                                      print('Pasajes');
                                    }
                                  ),
             
                                  const SizedBox(width: 10),
             
                                  SuggestButton(
                                    label: 'Transporte', 
                                    icon: Icons.directions_bus, 
                                    onTap: () {
                                      print('Transporte');
                                    }
                                  ),
                              
                                  const SizedBox(width: 10),
                              
                                  SuggestButton(
                                    label: "Otros", 
                                    icon: Icons.add, 
                                    onTap: () {
                                      print('Otros');
                                    }
                                  ),
                                  
                                  
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
             
                    //Guardados
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        width: double.infinity,
                        
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                      
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            const Text(
                              "Guardados", 
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 20
                              )
                            ),
                            
                            const SizedBox(height: 10),
             
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                              
                                  SuggestButton(
                                    label: 'Actividades', 
                                    icon: Icons.save, 
                                    onTap: () {
                                      print('Actividades');
                                    }
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ), 
          ),
        ],
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.push('/calendar_screen');   
        }, 
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.calendar_today),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}



class SuggestButton extends ConsumerWidget {
  final String label;
  final IconData icon;
  final Function() onTap;

  const SuggestButton({required this.label, required this.icon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 30,),
            
            const SizedBox(height: 5),
      
            Text(
              label,
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 12
              )
            ),
          ],
        ),
      ),
    );
  }
}