import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/config/config.dart';
import 'package:nomad_app/config/theme/app_theme.dart';
import 'package:nomad_app/features/home/home.dart';
import 'package:nomad_app/shared/shared.dart';


class PlanTripForm extends ConsumerStatefulWidget {
  const PlanTripForm({super.key});

  @override
  ConsumerState<PlanTripForm> createState() => _PlanTripFormState();
}

class _PlanTripFormState extends ConsumerState<PlanTripForm> {

  @override
  void initState() {
    super.initState();
    ref.read(planTripFormProvider.notifier).getCountries();
  }

  @override
  Widget build(BuildContext context) {
    final planTripProvider = ref.watch(planTripFormProvider.notifier);

    return Scaffold(
      body: CustomScrollView(
        slivers: [

          const _CustomAppBar(),
     

          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: Column(
                      children: [
                        
                        CustomTextFormFieldTrip(
                          hintText: 'Nombre del viaje',
                          onChanged: (value) {
                            planTripProvider.onValueChange('name', value);
                          },
                        ),
                          
                        const SizedBox(height: 20),
                          
                        CustomDropdown<Country>(
                          items: ref.watch(planTripFormProvider).countries,
                          initialItem: ref.watch(planTripFormProvider).selectedCountry,
                          hintText: 'País de destino',
                          onChanged: (value) {
                            planTripProvider.selectCountry(value);
                          },
                        ),
                                  
                        const SizedBox(height: 20),
                          
                        Row(
                          children: [
                            // El Dropdown ocupa el espacio disponible
                            Expanded(
                              child: CustomDropdown<Location>(
                                items: ref.watch(planTripFormProvider).locations,
                                initialItem: planTripProvider.locationInLocations()
                                    ? ref.watch(planTripFormProvider).selectedLocation
                                    : null,
                                hintText: 'Localidad de destino',
                                onChanged: (value) {
                                  planTripProvider.selectLocation(value);
                                },
                              ),
                            ),

                            const SizedBox(width: 10),

                            // El botón tiene un ancho fijo
                            SizedBox(
                              child: IconButton(
                                onPressed: () => ref.watch(planTripFormProvider).selectedLocation != null
                                    ? planTripProvider.onLocationsChange(null, 'add')
                                    : null, 
                                icon: Icon(Icons.add, color: AppTheme().getTheme().primaryColor )
                              )
                            ),
                          ],
                        ),


                        const SizedBox(height: 20),

                        const ListOfLocations(),
                                  
                        const SizedBox(height: 20),
                                  
                        Row(
                          children: [
                            Expanded(
                              child: DateTimePicker(
                                hintText: "Inicio", 
                                onDateChanged: ( String date ){
                                  planTripProvider.onValueChange('initDate', date);
                                }, 
                                firstDate: DateTime.now(),
                                lastDate:  DateTime.now().add(const Duration(days: 730)),
                              ),
                            ),
                                  
                            const SizedBox(width: 20),
                                  
                            Expanded(
                              child: DateTimePicker(
                                hintText: "Finalización", 
                                onDateChanged: ( String date ){
                                  planTripProvider.onValueChange('endDate', date);
                                }, 
                                firstDate: DateTime.now(),
                                lastDate:  DateTime.now().add(const Duration(days: 730)),
                              ),
                            )
                          ],
                        ),
                      
                        const SizedBox(height: 20),
                                  
                        Row(
                          children: [
                            Text(
                              'Viajo solo', 
                              style: TextStyle(
                                color: AppTheme().getTheme().primaryColor, 
                                fontSize: 16, 
                                fontWeight: ref.watch(planTripFormProvider).isAlone ? FontWeight.w300 : FontWeight.w500,
                              )
                            ),
                            Expanded(child: Container()),
                            Switch(
                              value: ref.watch(planTripFormProvider).isAlone, 
                              onChanged: (value) => planTripProvider.onValueChange('isAlone', value)
                            ),
                            Expanded(child: Container()),
                            Text(
                              'Acompañado', 
                              style: TextStyle(
                                color: AppTheme().getTheme().primaryColor, 
                                fontSize: 16, 
                                fontWeight: ref.watch(planTripFormProvider).isAlone ? FontWeight.w500 : FontWeight.w300,
                              )
                            ),
                          ],
                        )
                                  
                      ],
                    ),
                  ),
                ),
                CustomFilledButton(
                  text: 'Explorá con nomad!',
                  onPressed: () {
                    
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      )
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      floating: true,
      automaticallyImplyLeading: false,
      expandedHeight: MediaQuery.of(context).size.height * 0.2,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        centerTitle: true,
    
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(flex: 3),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
    
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
                ),
    
                Expanded(child: Container()),
    
                const Text(
                  'Planificá.',
                  style: TextStyle(color: Colors.white, fontSize: 20
                  , fontWeight: FontWeight.w400),
                ),
    
                Expanded(child: Container()),
              
                Container(
                  width: 48,
                )
    
              ],
            ),
            const Spacer(flex: 1), 
          ],
        ),
    
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
    );
  }
}

class CustomTextFormFieldTrip extends ConsumerWidget {
  final String hintText;
  final Function(String)? onChanged;
  
  const CustomTextFormFieldTrip({
    super.key,
    required this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          style: TextStyle(
            color: AppTheme().getTheme().primaryColor, 
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),  
          decoration: InputDecoration(
          hintText: hintText, 
          hintStyle: TextStyle(
            color: AppTheme().getTheme().primaryColor, 
            fontSize: 16
          ),

          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme().getTheme().primaryColor, 
              width: 3, 
            ),
          ),
          enabledBorder: UnderlineInputBorder( 
            borderSide: BorderSide(
              color: AppTheme().getTheme().primaryColor,
              width: 2, 
            ),
          ),
        ),
        onChanged: onChanged,
        ),
      ],
    );
  }
}

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? initialItem;
  final Function(T) onChanged;
  final String hintText;

  const CustomDropdown({super.key, 
    required this.items,
    required this.initialItem,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      style: TextStyle(
        color: AppTheme().getTheme().primaryColor, 
        fontSize: 16,
        fontWeight: FontWeight.w500
      ),
      icon: Icon(Icons.arrow_drop_down_circle_rounded, color: AppTheme().getTheme().primaryColor),
      value: initialItem,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppTheme().getTheme().primaryColor, 
          fontWeight: FontWeight.w500,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme().getTheme().primaryColor, 
            width: 2, 
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme().getTheme().primaryColor,
            width: 2,
          ),
        ),
      ),

      items: items.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: (T? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }
}


Widget _locationWidget({required BuildContext context, required Location location, required WidgetRef ref}) {
  return Card(
    color: AppTheme().getTheme().primaryColor.withOpacity(0.2),
    child: Row(
      mainAxisSize: MainAxisSize.min, 
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(location.toString()),
        ),
        IconButton(
          onPressed: () => ref.watch(planTripFormProvider.notifier).onLocationsChange(location, "remove"),
          icon: const Icon(Icons.close),
        ),
      ],
    ),
  );
}


class ListOfLocations extends ConsumerStatefulWidget {
  const ListOfLocations({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListOfLocationsState();
}

class _ListOfLocationsState extends ConsumerState<ListOfLocations> {


  @override
  Widget build(BuildContext context) {
    
    final planTripForm = ref.watch(planTripFormProvider);

    return planTripForm.selectedLocations.isNotEmpty
    ? Wrap(children: planTripForm.selectedLocations.map((location) => _locationWidget(context: context, location: location, ref: ref)).toList()) 
    : const Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text('No hay lugares', style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

