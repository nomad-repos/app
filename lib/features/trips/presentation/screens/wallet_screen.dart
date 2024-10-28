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
      ref.read(indexBottomNavbarProvider.notifier).update((state) => 1);
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
            expandedHeight: MediaQuery.of(context).size.height * 0.16,
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
                  alignment: Alignment.topRight,
                  children: [ Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromRGBO(244, 245, 246, 1)),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Gastos Totales:',
                                style: TextStyle(
                                    color: Color.fromRGBO(51, 101, 138, 1),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                            Row(
                              children: [
                              Icon(Icons.attach_money, color: Colors.black),
                              Text(
                                '230,400',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600),
                              ),
                        
                            ])
                          ],
                        ),
                      )),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: CustomAddGastoButton(),
                      )
                      ]

                    ),

                  
                

                    const SizedBox(height: 30),
                      
                    const HorizontalListView(itemCount: 10),

                    const SizedBox(height: 30),

                    Container(
                      height: 100000,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(244, 245, 246, 1)
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(columns: const [
                          DataColumn(label: Text('Descripcion')),
                          DataColumn(label: Text('Monto')),
                          DataColumn(label: Text('Estado')),
                          DataColumn(label: Text('Fecha')),
                          DataColumn(label: Text('Categoria')),
                        ], rows: [
                          DataRow(cells: [
                            DataCell(Text('Comida')),
                            DataCell(Text('200')),
                            DataCell(Text('Pagado')),
                            DataCell(Text('12/12/2021')),
                            DataCell(Text('Comida')),
                          ]),
                        ]
                        ),
                      ),
                     ),
                  ]
                )
              )
        ]
        ),
        
        Visibility(
            visible: ref.watch(tripProvider).isPosting,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
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
            ref.read(indexBottomNavbarProvider.notifier).update((state) => 4);
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
          left: 10, right: 10,), // Adjust padding to align with leading
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
           ref.read(indexBottomNavbarProvider.notifier).update((state) => 0);
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
    return Container(
      width: MediaQuery.of(context).size.width * 0.12, 
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        color: Colors.deepOrange, // Color de fondo
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          context.push('/add_gasto_screen');
        },
      ),
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
                  color: Color.fromRGBO(244, 245, 246, 1),
                  borderRadius: BorderRadius.circular(20),
                  ),
            ),
          );
        },
      )
    );
  }
}
