import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/features/trips/trip.dart';
import 'package:nomad_app/shared/shared.dart';
import 'package:go_router/go_router.dart';

class FindActivityScreen extends ConsumerStatefulWidget {
  const FindActivityScreen({super.key});

  @override
  ConsumerState<FindActivityScreen> createState() => _FindActivityScreenState();
}

class _FindActivityScreenState extends ConsumerState<FindActivityScreen> {
  @override
  Widget build(BuildContext context) {
    final trip = ref.watch(tripProvider);
    final findActivity = ref.watch(findActivityProvider);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildDarkOverlay(),
          _buildContent(context, trip, findActivity),
        ],
      ),
    );
  }

  // Background Image
  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        'assets/registro.jpg',
        fit: BoxFit.cover, // Changed to cover for better scaling
      ),
    );
  }

  // Dark transparent overlay on top of the background image
  Widget _buildDarkOverlay() {
    return Positioned.fill(
      child: Container(
        color: const Color.fromARGB(255, 2, 15, 21).withOpacity(0.5),
      ),
    );
  }

  // Main content with SliverAppBar and SliverList
  Widget _buildContent(
      BuildContext context, TripState trip, FindActivityState findActivity) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, trip, findActivity),
        _buildSliverList(context, findActivity),
      ],
    );
  }

// SliverAppBar with search dropdowns and back button
  Widget _buildSliverAppBar(
      BuildContext context, TripState trip, FindActivityState findActivity) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.27,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildFlexibleSpace(
            context, trip, findActivity), // Content of the AppBar
      ),
    );
  }

// Back button on SliverAppBar
  Widget _buildBackButton(
      BuildContext context, FindActivityState findActivity) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          ref.read(findActivityProvider.notifier).resetActivityList();
          context.go('/home_trip_screen');
        },
      ),
    );
  }

// FlexibleSpace content (Dropdowns + Header Text)
  Widget _buildFlexibleSpace(
      BuildContext context, TripState trip, FindActivityState findActivity) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 10, right: 10, top: 10), // Adjust padding to align with leading
      child: Column(
        // Align to start
        mainAxisAlignment:
            MainAxisAlignment.center, // Center in the SliverAppBar
        children: [
          Row(children: [
            _buildBackButton(context, findActivity),
            const SizedBox(width: 5),
            _buildHeaderText(),
          ]), // Title text
          const SizedBox(height: 16), // Space between title and dropdown
          _buildCategorySearch(context, trip, findActivity), // First dropdown
          const SizedBox(height: 10), // Space between dropdowns
          _buildLocationSearch(context, trip, findActivity), // Second dropdown
        ],
      ),
    );
  }

// Header text "Buscá tu Actividad."
  Widget _buildHeaderText() {
    return const Align(
      alignment: Alignment.center, // Align to start (same line as leading)
      child: Text(
        'Buscá tu Actividad.',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 27,
        ),
      ),
    );
  }

// Dropdown: Category selection
  Widget _buildCategorySearch(
      BuildContext context, TripState trip, FindActivityState findActivity) {
    return Align(
      alignment: Alignment.center, // Keep it aligned with leading
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.width * 0.12,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.transparent, // Background color for dropdown
        ),
        child: CustomSearchDD(
          list: trip.categories,
          texto: findActivity.categoryHome == null
              ? "Seleccionar categoría"
              : findActivity.categoryHome!.catergoryName,
          searchText: 'Buscar categoria',
        ),
      ),
    );
  }

  Widget _buildLocationSearch(
      BuildContext context, TripState trip, FindActivityState findActivity) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.width * 0.13,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            // Dropdown for location search
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.width * 0.9,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: CustomSearchDD(
                  list: trip.trip!.tripLocations!,
                  texto: 'Seleccionar localidad',
                  searchText: 'Buscar localidad',
                ),
              ),
            ),
            const SizedBox(
                width: 10), // Add some space between dropdown and button

            // "Buscar" button
            Container(
              height: MediaQuery.of(context).size.width * 0.13,
              child: ElevatedButton(
                onPressed: () {
                  ref.watch(findActivityProvider.notifier).getActivities(
                      '${findActivity.selectedLocation!.latitude},${findActivity.selectedLocation!.longitude}',
                      findActivity.selectedCategory!.categoryId);

                  _buildSliverList(context, findActivity);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16.0), // Rounded corners
                  ),
                ),
                child: const Text('Buscar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSliverList(BuildContext context, FindActivityState findActivity) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        if (findActivity.activities != null &&
            findActivity.activities!.isNotEmpty) {
          return _buildActivityItem(context, findActivity.activities![index]);
        } else {
          return const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              'No hay actividades.',
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          );
        }
      },
      childCount: findActivity.activities?.isNotEmpty == true
          ? findActivity.activities!.length
          : 1,
    ),
  );
}

// Build individual activity item
Widget _buildActivityItem(BuildContext context, Activity activity) {
  return Padding(
    padding: const EdgeInsets.all(11),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.09,
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
        ),
        child: ListTile(
          title: Text(
            activity.activityName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            textAlign: TextAlign.left,
          ),
          subtitle: Text(
            activity.activityAddress,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
        ),
        onPressed: () {
          //aca tiene que ir a la pantalla de la actividad
        },
      ),
    ),
  );
}