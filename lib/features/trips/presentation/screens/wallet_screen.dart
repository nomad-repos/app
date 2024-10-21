import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/features/trips/presentation/presentation.dart';
import 'package:nomad_app/features/trips/trip.dart';
import 'package:nomad_app/shared/shared.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreen();
}

class _WalletScreen extends ConsumerState<WalletScreen> {
  Trip? trip;

  @override
  void initState() {
    super.initState();
    // Asignar la actividad si está disponible
    Future.microtask(() {
      final tripState = ref.read(tripProvider);
      if (tripState.trip != null) {
        setState(() {
          trip = tripState.trip;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripProvider);

    return Scaffold(
      //FONDO DE PANTALLA
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            'assets/registro.jpg',
            fit: BoxFit.fitHeight,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: const Color.fromARGB(255, 2, 15, 21).withOpacity(0.6),
          ),
        ),
        CustomScrollView(slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.1,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background:
                  _buildFlexibleSpace(context, trip), // Content of the AppBar
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Stack(
                  alignment: Alignment.centerRight,
                  children: [ Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child:  const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(25),
                            child: Column(
                              children: [
                                Text('Balance Total:',
                                    style: TextStyle(
                                        color: Color.fromRGBO(51, 101, 138, 1),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                                Row(children: [
                                  Icon(Icons.monetization_on),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '230,400',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600),
                                  ),
                            
                                ])
                              ],
                            ),
                          ),
                        ],
                      )),
                      Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.width * 0.3,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                          color: Colors.deepOrange),
                          child: CustomAddGastoButton() ,
                      ),
                      ]

                    ),

                  
                

                    const SizedBox(height: 30),
                      
                    const HorizontalListView(itemCount: 10),

                    const SizedBox(height: 30),

                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 100000,
                        decoration: const BoxDecoration(
                          color: Colors.white
                        ),
                        child: const Column(
                          children: [ 
                         
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Row (
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 20),
                                Text('Descripcion'),
                                SizedBox(width: 20),
                                Text('Monto'),
                                SizedBox(width: 20),
                                Text('Estado'),
                                SizedBox(width: 20),
                                 Text('Fecha'),
                                SizedBox(width: 20),
                                Text('Categoria'),
                                SizedBox(width: 20),
                              
                                //SliverList () aca tienen que ir todos los datos uno por uno
                                                  
                              ],
                              ),
                            )
                          ]
                        ),
                       ),
                    ),
                  ]
                )
              )
        ]
        )
      ]),

      //BARRA DE PANTALLAS
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 70,
        height: 65,
        child: FloatingActionButton(
          onPressed: () async {
            await ref.read(tripProvider.notifier).getEvents();
            context.push('/calendar_screen');
          },
          backgroundColor: Colors.deepOrange,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.calendar_today,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  //EL APPBAR DE SLIVER
  Widget _buildFlexibleSpace(BuildContext context, TripState trip) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 10, right: 10, top: 10), // Adjust padding to align with leading
      child: Column(
        // Align to start
        mainAxisAlignment:
            MainAxisAlignment.center, // Center in the SliverAppBar
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 37),
            child: Row(children: [
              _buildBackButton(
                context,
              ),
              const SizedBox(width: 5),
              _buildHeaderText(),
            ]),
          ), // Title text
        ],
      ),
    );
  }

  //BOTON PARA ATRAS
  Widget _buildBackButton(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          context.go('/home_trip_screen');
        },
      ),
    );
  }

  //TITULO DE REGISTRA GASTOS
  Widget _buildHeaderText() {
    return const Align(
      alignment: Alignment.center, // Align to start (same line as leading)
      child: Text(
        'Registrá tus Gastos.',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 27,
        ),
      ),
    );
  }
}

class CustomAddGastoButton extends StatelessWidget {
  const CustomAddGastoButton({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.push('/add_gasto_screen');
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.deepOrange),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
          ),
        ),
      ),
      child: null
    );
    
  }
}

class HorizontalListView extends StatelessWidget {
  final double? height;
  final int itemCount;
  final double? width;


  const HorizontalListView({
    super.key,
    this.height,
    required this.itemCount,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 10, left: index == 0 ? 23 : 0),
            child: Container(
              width: MediaQuery.of(context).size.height * 0.17,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  ),
            ),
          );
        },
      )
    );
  }
}
