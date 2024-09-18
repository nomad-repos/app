import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:nomad_app/config/config.dart';
import 'package:nomad_app/config/theme/app_theme.dart';

typedef OnDateChanged = void Function(String date);

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({
    super.key,
    required this.hintText,
    required this.onDateChanged, 
    required this.firstDate,
    required this.lastDate,
    this.errorText, 
  });

  final String hintText;
  final OnDateChanged onDateChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? errorText;

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateController,
      readOnly: true,
      style: TextStyle(
        color: AppTheme().getTheme().primaryColor,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(

        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: AppTheme().getTheme().primaryColor,
          overflow: TextOverflow.ellipsis
        ),

        errorText: widget.errorText,   

        border: UnderlineInputBorder( 
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor, 
            width: 2
          ),
        ),

        focusedBorder: UnderlineInputBorder( 
          borderSide:  BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2
          ),
        ),

        enabledBorder: UnderlineInputBorder( 
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2
          ),
        ),

        errorBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Colors.red, 
            width: 2
          ),
        ),
        
        floatingLabelBehavior: FloatingLabelBehavior.always, 
        
      ),
      onTap: () async {
        DateTime? newDate = await showDatePicker(
          context: context, 
          initialDate: DateTime.now(), 
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          helpText: "Selecciona una fecha",
          locale: const Locale("es", "ES"),
        );
        //Si es null, no hace nada
        if( newDate == null ) return;
        //En caso de que haya seleccionado una fecha, que aparezca como debe.
        final formattedDate = DateFormat('dd/MM/yyyy').format(newDate);
        setState(() {
          dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
        });
        widget.onDateChanged(formattedDate);
      },
    );    
  }
}