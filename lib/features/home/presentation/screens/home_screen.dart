import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/shared/shared.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverAppBar(
        expandedHeight: MediaQuery.of(context).size.height * 0.2,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            children: [
              Image.network(
                "https://images.unsplash.com/photo-1468774871041-fc64dd5522f3?q=80&w=3132&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                fit: BoxFit.fitHeight,
              ),
              Positioned.fill(
                child: Container(
                  color: const Color.fromARGB(255, 2, 15, 21).withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
        pinned: true, // Keeps the SliverAppBar visible when scrolling
        backgroundColor: Colors.transparent, // Makes the app bar transparent
      ),

      const SliverToBoxAdapter(
        child: ScrollHome()),
    ]));
  }
}

class ScrollHome extends StatelessWidget {
  const ScrollHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(244, 245, 246, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(2),
                child: Row(children: [
                  CustomHomeText(label: 'Explorá '),
                  CustomHomeText(
                    label: 'nomad.',
                    fontWeight: FontWeight.w900,
                  )
                ]),
              ),

              SizedBox(height: 5),

              GestureDetectorWidget(
                  url:
                      "https://images.unsplash.com/photo-1506807520672-c4a8d5bbe260?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  label:
                      'Planificar Nuevo Viaje'), //widget on tap action (planificar viajes)

              SizedBox(height: 5),

              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 4),
                child: CustomHomeText(
                  label: 'Mis Viajes',
                  fontsize: 21,
                ),
              ),

              HorizontalListView(
                  itemCount: 10,
                  url:
                      "https://images.unsplash.com/photo-1490806843957-31f4c9a91c65?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"), //widget mis viajes listview

              SizedBox(height: 5),

              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 4),
                child: CustomHomeText(
                  label: 'Viajes Recomendados',
                  fontsize: 21,
                ),
              ),

              HorizontalListView(
                  itemCount: 10,
                  url:
                      "https://images.unsplash.com/photo-1515859005217-8a1f08870f59?q=80&w=3210&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),

              SizedBox(height: 5),

              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 4),
                child: CustomHomeText(
                  label: 'Recordá tus historia',
                  fontsize: 21,
                ),
              ),

              SizedBox(height: 5),

              GestureDetectorWidget(
                  url:
                      'https://media.istockphoto.com/id/1971796553/photo/young-couple-is-standing-at-mountain-top-with-great-view.webp?b=1&s=612x612&w=0&k=20&c=IXoBQgZqFUb8SRI87J9BHWtbgyuuQiImJSt1pHAp5Cc=',
                  label: 'Mis Aventuras')
            ],
          ),
        ),
      ),
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
      height: MediaQuery.of(context).size.height * 0.15,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 13),
            child: Container(
              width: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
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

  const GestureDetectorWidget({
    super.key,
    required this.url,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.92,
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    blurRadius: 5,
                    offset: Offset(3, 5))
              ],
              borderRadius: BorderRadius.circular(16),
              image:
                  DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)),
          child: Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15 * 0.2,
              width: MediaQuery.of(context).size.width * 0.92,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(242, 100, 25, 0.82),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16))),
              child: Padding(
                padding: const EdgeInsets.only(left: 14, top: 2, bottom: 2),
                child: Text(label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w300)),
              ),
            ),
          )),
    );
  }
}
