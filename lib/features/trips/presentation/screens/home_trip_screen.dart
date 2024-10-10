import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/features/trips/presentation/presentation.dart';
import 'package:nomad_app/features/trips/presentation/providers/find_activity_provider.dart';

import 'package:nomad_app/features/trips/trip.dart';
import 'package:nomad_app/shared/shared.dart';


class HomeTripScreen extends ConsumerWidget {
  const HomeTripScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 

    final tripState = ref.watch(tripProvider);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/registro.jpg',
              fit: BoxFit.fill,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 2, 15, 21).withOpacity(0.6),
            ),
          ),
           SingleChildScrollView(
             child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height
              ),
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
                              fontWeight: FontWeight.w600, 
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
                              borderRadius: BorderRadius.circular(16),
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
                            borderRadius: BorderRadius.circular(16),
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
                              
                              const SizedBox(height: 6),
               
                              Container(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: tripState.categories.length,
                                  itemBuilder: (context, index){
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 4, left: 4),
                                      child: CustomSuggestButton(
                                        category: tripState.categories[index],
                                        onTap: (){
                                          ref.watch(findActivityProvider.notifier).onCategoryHomeChange(tripState.categories[index]);
                                          context.go('/find_activity_screen');
                                        }
                                      ),
                                    );
                                  }
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
                            borderRadius: BorderRadius.circular(16),
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
                            borderRadius: BorderRadius.circular(16),
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
          ),
        ],
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.push('/calendar_screen');   
        }, 
        backgroundColor: Colors.deepOrange,
        shape: const CircleBorder(),
        child: const Icon(Icons.calendar_today),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
