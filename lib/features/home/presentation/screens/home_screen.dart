import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/features/home/home.dart';
import 'package:nomad_app/shared/shared.dart';

import '../../../trips/trip.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userProvider);
    
    return Scaffold(
      body: CustomScrollView( 
        slivers: [
      SliverAppBar(
        automaticallyImplyLeading: false,
        floating: true,
        expandedHeight: MediaQuery.of(context).size.height * 0.2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            
            const Text(
              'Bienvenido ', 
              style: TextStyle(color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 25)
            ),

            Text(
              userInfo.user!.userSurname,
              style: const TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.w900,
                fontSize: 25
              ),
            )
          ]
        ),

        flexibleSpace: FlexibleSpaceBar(
          background: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), 
              BlendMode.srcATop,
            ),
            child: FutureBuilder<File>(
              future: DefaultCacheManager().getSingleFile(
                "https://images.unsplash.com/photo-1468774871041-fc64dd5522f3?q=80&w=3132&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading image'));
                }

                return Image.file(snapshot.data!, fit: BoxFit.cover);
              },
            ),
          ),
        ),

      ),
     
      const SliverToBoxAdapter(
        child: ScrollHome()),
    
      ])

    );
  }
}

class ScrollHome extends ConsumerWidget {
  const ScrollHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final homeState = ref.watch(homeProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Padding(
          padding: EdgeInsets.only(left:13, top: 13),
          child: Row(children: [
            CustomHomeText(label: 'Explorá ', fontsize: 25,),
            CustomHomeText(label: 'nomad.', fontWeight: FontWeight.w900, fontsize: 25,)
          ]),
        ),

        const SizedBox(height: 10),

        Align(
          alignment: Alignment.topCenter,
          child: GestureDetectorWidget(
            url: "https://images.unsplash.com/photo-1498307833015-e7b400441eb8?q=80&w=3028&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            label:'Planificar Nuevo Viaje',
            onTap: () => context.push('/plan_trip_form')
          ),
        ), //widget on tap action (planificar viajes)
    
        const SizedBox(height: 5),
    
        const Padding(
          padding: EdgeInsets.only(right:10, top:10, left: 13),
          child: CustomHomeText(
            label: 'Mis Proximos Viajes',
          ),
        ),

        const SizedBox(height: 2),
    
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.17,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return TripSquare(
                trip: homeState.trips[index],
                index: index,
              );
            },
            itemCount: homeState.trips.length,
            scrollDirection: Axis.horizontal,
          ),
        ),


        const SizedBox(height: 5),
    
        const Padding(
          padding: EdgeInsets.only(right:10, top:10, left: 13),
          child: CustomHomeText(
            label: 'Viajes Recomendados',
          ),
        ),

        const SizedBox(height: 2),
    
        const HorizontalListView(
            itemCount: 10,
            url:
                "https://images.unsplash.com/photo-1515859005217-8a1f08870f59?q=80&w=3210&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
    
        const SizedBox(height: 5),
    
        const Padding(
          padding: EdgeInsets.only(right:10, top:10, left: 13),
          child: CustomHomeText(
            label: 'Recordá tus historia',
          ),
        ),
    
        const SizedBox(height: 2),
    
        const Align(
          alignment: Alignment.topCenter,
          child: GestureDetectorWidget(
              url:
                  'https://media.istockphoto.com/id/1971796553/photo/young-couple-is-standing-at-mountain-top-with-great-view.webp?b=1&s=612x612&w=0&k=20&c=IXoBQgZqFUb8SRI87J9BHWtbgyuuQiImJSt1pHAp5Cc=',
              label: 'Mis Aventuras'),
        ),

        const SizedBox(height: 5),

        const Padding(
          padding: EdgeInsets.only(right:10, top:10, left: 13),
          child: CustomHomeText(
            label: 'Itinerarios de la Comunidad',
          ),
        ),

        const SizedBox(height: 2),

        const HorizontalListView(
            itemCount: 10,
            url:
                "https://media.istockphoto.com/id/1059713466/photo/teamwork-couple-climbing-helping-hand.webp?b=1&s=612x612&w=0&k=20&c=XqwznpAgGJapLnY2LonSJyMtVAay7aAMwSD184RTf6I="),
        
        const SizedBox(height: 5),
      ],
    );
  }
}

/*
Este es el widget que te deja hacer los 10 widget y la list view en row
 */
class HorizontalListView extends StatelessWidget {
  final double? height;
  final int itemCount;
  final double? width;
  final String url;

  const HorizontalListView({
    super.key,
    this.height,
    required this.itemCount,
    this.width,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.17,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 10, left: index == 0 ? 13 : 0),
            child: Container(
              width: MediaQuery.of(context).size.height * 0.17,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(url),
                    fit: BoxFit.cover,
                  )),
            ),
          );
        },
      ),
    );
  }
}

/*
El ScheduleNewTripWidget es todo el cuadrado de Planificar Nuevo Viaje 
*/
class GestureDetectorWidget extends StatelessWidget {
  final String url;
  final String label;
  final Function()? onTap;

  const GestureDetectorWidget({
    super.key,
    required this.url,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: MediaQuery.of(context).size.height * 0.18,
          width: MediaQuery.of(context).size.width * 0.93,
          
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    blurRadius: 5,
                    offset: Offset(3, 5))
              ],
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)
            ),

          child: Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15 * 0.3,
              width: MediaQuery.of(context).size.width * 0.93,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(242, 100, 25, 0.82),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),  
              child: Align(
                alignment: const Alignment(-0.85, 0),
                child: Text(
                  label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300)
                ),
              ),
            
            ),
          )),
    );
  }
}


class TripSquare extends ConsumerWidget {
  final Trip trip;
  final int index;
  const TripSquare({super.key, required this.trip, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final tripNotifier = ref.watch(tripProvider.notifier);

    return GestureDetector(
      onTap: () {
        tripNotifier.setTrip(trip);
        context.push('/home_trip_screen');
      },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10, left: index == 0 ? 13 : 0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.17,
                width: MediaQuery.of(context).size.height * 0.17,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(trip.photoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        
            SizedBox(
              width:MediaQuery.of(context).size.height * 0.15,
              child: Align(
                alignment: Alignment.topLeft, // Alinea el texto a la izquierda
                child: Container(
                  margin: EdgeInsets.only(top: 10, left: index == 0 ? 23 : 10), // Asegura el mismo espacio para todos
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      trip.tripName,
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis,  // Muestra puntos suspensivos si el texto es largo
                      softWrap: false,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}