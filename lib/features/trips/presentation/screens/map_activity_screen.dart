import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nomad_app/features/trips/trip.dart';

import 'package:nomad_app/shared/models/models.dart';
import 'package:nomad_app/shared/utils/utils.dart';

class MapActivityScreen extends ConsumerStatefulWidget {
  final GetEvent? getEvent;

  const MapActivityScreen({required this.getEvent, super.key});

  @override
  ConsumerState<MapActivityScreen> createState() => _MapActivityScreenState();
}

class _MapActivityScreenState extends ConsumerState<MapActivityScreen> {
  late GoogleMapController _mapController;
  bool _isMapInitialized = false;
  Activity? activity;

  @override
  void initState() {
    super.initState();
    // Asignar la actividad si está disponible
    Future.microtask(() {
      final eventProvider = ref.read(createEventProvider);
      if (eventProvider.activity != null) {
        setState(() {
          activity = eventProvider.activity;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.getEvent != null){
      return getEventActivity(widget.getEvent);
    }
    return normalActivity(activity);
  }
  
  Widget normalActivity(Activity? activity) {
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
                          activity?.activityName ?? 'Sin nombre', // Cargar dinámicamente
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          getFormattedDate(ref.watch(createEventProvider).date), // Cargar fecha dinámica si aplica
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${formatTimeOfDay(ref.watch(createEventProvider).startTime)}-${formatTimeOfDay(ref.watch(createEventProvider).endTime)}", // Cargar hora dinámica si aplica
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (activity != null) // Verificar que activity no sea nulo
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
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  activity.activityLongitude,
                                  activity.activityLatitude),
                              zoom: 14.4746,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('1'),
                                position: LatLng(
                                    activity.activityLatitude,
                                    activity.activityLongitude),
                                infoWindow: InfoWindow(
                                  title: activity.activityName,
                                ),
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
              if (activity == null)
                const Center(
                  child: CircularProgressIndicator(),
                ), // Mostrar indicador mientras se carga la actividad
            ],
          ),
        ),
      ),
    );
  }

  Widget getEventActivity(GetEvent? getEvent){
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
                           ref.watch(createEventProvider.notifier).onEditChange( getEvent!, context);
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
                          getEvent?.activity.activityName ?? 'Sin nombre', // Cargar dinámicamente
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          getFormattedDate(DateTime.tryParse(getEvent!.date)), // Cargar fecha dinámica si aplica
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${getEvent.startTime}-${getEvent.finishTime}", // Cargar hora dinámica si aplica
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (activity != null) // Verificar que activity no sea nulo
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
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  getEvent.activity.activityLatitude,
                                  getEvent.activity.activityLongitude
                                ),
                              zoom: 14.4746,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('1'),
                                position:  LatLng(
                                  getEvent.activity.activityLatitude,
                                  getEvent.activity.activityLongitude
                                ),
                                infoWindow: InfoWindow(
                                  title: getEvent.activity.activityName,
                                ),
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


