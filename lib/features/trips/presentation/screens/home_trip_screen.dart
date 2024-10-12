import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/features/trips/presentation/presentation.dart';
import 'package:nomad_app/features/trips/trip.dart';
import 'package:nomad_app/shared/shared.dart';

class HomeTripScreen extends ConsumerStatefulWidget {
  const HomeTripScreen({super.key});

  @override
  ConsumerState<HomeTripScreen> createState() => _HomeTripScreenState();
}

class _HomeTripScreenState extends ConsumerState<HomeTripScreen> {
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
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      // Botones de navegación
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
                      // Nombre del viaje
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            trip != null
                                ? "Mi viaje ${trip!.tripName}"
                                : "Cargando viaje...",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Días restantes
                      Row(
                        children: [
                          Container(
                            height: 2,
                            width: MediaQuery.of(context).size.width * 0.4,
                            color: Colors.deepOrange,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              tripState.dayRemaining,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 20),
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
                      // Te sugerimos
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
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: tripState.categories.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: CustomSuggestButton(
                                        category: tripState.categories[index],
                                        onTap: () {
                                          ref
                                              .watch(findActivityProvider.notifier)
                                              .onCategoryHomeChange(
                                                  tripState.categories[index]);
                                          context.go('/find_activity_screen');
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Mis archivos
                      buildSection(
                        title: "Mis archivos",
                        children: [], // Añadir tus widgets aquí
                      ),
                      const SizedBox(height: 20),
                      // Guardados
                      buildSection(
                        title: "Guardados",
                        children: [], // Añadir tus widgets aquí
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Visibility(
            visible: tripState.isPosting,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ref.read(tripProvider.notifier).getEvents();
          context.push('/calendar_screen');
        },
        backgroundColor: Colors.deepOrange,
        shape: const CircleBorder(),
        child: const Icon(Icons.calendar_today),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Padding buildSection({required String title, required List<Widget> children}) {
    return Padding(
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
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: children,
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}