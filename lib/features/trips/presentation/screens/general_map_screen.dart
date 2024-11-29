import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nomad_app/features/trips/presentation/providers/trip_provider.dart';
import 'package:nomad_app/shared/presentation/providers/botom_nav_bar_provider.dart';
import 'package:nomad_app/shared/widgets/custom_nav_bar.dart';

class GeneralMapScreen extends ConsumerStatefulWidget {
  const GeneralMapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GeneralMapScreenState();
}

class _GeneralMapScreenState extends ConsumerState<GeneralMapScreen> {

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      extendBody: true,

      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 4,
        ),

        markers: ref.watch( tripProvider ).markers
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
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}