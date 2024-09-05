import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_app/config/config.dart';
import 'package:nomad_app/config/theme/app_theme.dart';

class PlanTripForm extends ConsumerWidget {
  const PlanTripForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    const List<String> _list = [
    'Developer',
    'Designer',
    'Consultant',
    'Student',
  ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificá.'),
        centerTitle: true,
        elevation: 10,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  
                  CustomTextFormFieldTrip(
                    text: 'Nombre del viaje',
                    hintText: 'Ej: Viaje a la playa',
                  ),

                  const SizedBox(height: 10),

                  CustomDropdown<String>(
                    hintText: 'Select job role',
                    items: _list,
                    initialItem: _list[0],
                    onChanged: (value) {
                      print(value);
                    },
                    decoration: CustomDropdownDecoration(
                      
                    ),
                  )
                
                ],
              ),
            ),
          )
        ),
      )
    );
  }
}

class CustomTextFormFieldTrip extends ConsumerWidget {
  final String text;
  final String hintText;
  final Function(String)? onChanged;
  
  const CustomTextFormFieldTrip({
    super.key,
    required this.text,
    required this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: AppTheme().getTheme().primaryColor,  
            fontSize: 18
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          decoration: InputDecoration(
          contentPadding: const EdgeInsets.all( 10 ), 
          hintText: hintText, 
          hintStyle: TextStyle(
            color: AppTheme().getTheme().primaryColor, 
            fontWeight: FontWeight.w200
          ),
          border: OutlineInputBorder( 
            borderSide: BorderSide(
              color: AppTheme().getTheme().primaryColor,
              width: 10, 
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: AppTheme().getTheme().primaryColor, 
              width: 2, 
            ),
          ),
          enabledBorder: OutlineInputBorder( 
            borderSide: BorderSide(
              color: AppTheme().getTheme().primaryColor,
              width: 1, 
            ),
          ),
          labelStyle: const TextStyle(
            color: Colors.black45, 
          )
        ),
        onChanged: onChanged,
        ),
      ],
    );
  }
}