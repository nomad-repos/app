import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapActivityScreen extends ConsumerStatefulWidget {
  const MapActivityScreen({super.key});

  @override
  ConsumerState<MapActivityScreen> createState() => _MapActivityScreenState();
}

class _MapActivityScreenState extends ConsumerState<MapActivityScreen> {
  late GoogleMapController _mapController;
  bool _isMapInitialized = false;

  @override
  Widget build(BuildContext context) {
    CameraPosition cameraPosition = const CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), // Cambiar esto.
      zoom: 14.4746,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Visita CDS', // Cambiar esto.
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Miércoles, 24 de Agosto', // Cambiar esto.
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '10:00 AM - 12:00 PM', // Cambiar esto.
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), 
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: cameraPosition,
                          markers: {
                            Marker(
                              markerId: const MarkerId('1'),
                              position: LatLng(37.42796133580664, -122.085749655962), // Cambiar esto.
                              infoWindow: const InfoWindow(title: 'Nombre de la actividad'), // Cambiar esto.
                            ),
                          },
                          onMapCreated: (controller) {
                            _mapController = controller;
                            setState(() {
                              _isMapInitialized = true;
                            });
                          },
                        ),
                        if (!_isMapInitialized)
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
                          ],
          ),
        ),
      ),
    );
  }
}