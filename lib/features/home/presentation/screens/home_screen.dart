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
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.29,
              width: MediaQuery.of(context).size.width,
              child: Image.network(

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
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 2, 15, 21).withOpacity(0.3),
            ),
          ),
          Positioned(
            bottom: 0,
            top: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            child: const ScrollHome(),
          ),
        ],
      ),
    );
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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(2),
                child: Row(children: [
                  CustomHomeText(label: 'Explorá '),
                  CustomHomeText(label: 'nomad.', fontWeight: FontWeight.w900,)
                ]),
              ),

              const SizedBox(height: 5),
              
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.92,
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(image: NetworkImage("https://images.unsplash.com/photo-1506807520672-c4a8d5bbe260?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                    fit: BoxFit.cover)
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Container (
                      height: MediaQuery.of(context).size.height * 0.15 * 0.2,
                      width: MediaQuery.of(context).size.width * 0.92,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(242, 100, 25, 0.82),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 14, top: 2, bottom: 2),
                        child: Text('Planificar Nuevo Viaje',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300)),
                      ),
                    ),
                  )
                  
                ),
              ),
  

              const SizedBox(height: 5),
              
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: CustomHomeText(label: 'Mis Viajes', fontsize: 21,),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.height * 0.15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: const DecorationImage(
                              image: NetworkImage(
                                  "https://images.unsplash.com/photo-1490806843957-31f4c9a91c65?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                              fit: BoxFit.cover,
                            )),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: CustomHomeText(label: 'Viajes Recomendados', fontsize: 21,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
