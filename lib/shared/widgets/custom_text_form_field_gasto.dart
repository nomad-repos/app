import 'package:flutter/material.dart';

class CustomTextFormFieldGasto extends StatefulWidget {
  final String? label;
  final String? helper;
  final String? hint;
  final String? errorMessage;
  final String? initialValue;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final int maxLines;

  const CustomTextFormFieldGasto(
      {super.key,
      this.label,
      this.helper,
      this.hint,
      this.errorMessage,
      this.initialValue,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.onChanged,
      this.validator,
      this.maxLines = 1, required IconData icon});

  @override
  _CustomTextFormFieldGasto createState() => _CustomTextFormFieldGasto();
}

class _CustomTextFormFieldGasto extends State<CustomTextFormFieldGasto> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Color.fromRGBO(51, 101, 138, 1)),
      borderRadius: BorderRadius.circular(40),
    );

    const borderRadius = Radius.circular(15);

    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: borderRadius,
          bottomLeft: borderRadius,
          bottomRight: borderRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.transparent,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        onChanged: widget.onChanged,
        maxLines: widget.maxLines,
        validator: widget.validator,
        obscureText: _obscureText,
        keyboardType: widget.keyboardType,
        initialValue: widget.initialValue,
        style: const TextStyle(fontSize: 15, color: Colors.white),
        decoration: InputDecoration(
          floatingLabelStyle:
              const TextStyle(color: Color.fromARGB(255, 65, 63, 63), fontSize: 18),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith(
              borderSide: const BorderSide(color: Color.fromARGB(255, 65, 63, 63))),
          focusedErrorBorder: border.copyWith(
              borderSide: const BorderSide(color: Color.fromARGB(255, 65, 63, 63))),
          isDense: true,
          label: widget.label != null ? Text(widget.label!) : null,
          hintText: widget.hint,
          hintStyle: const TextStyle(
              color: Color.fromRGBO(51, 101, 138, 1), fontSize: 15, fontWeight: FontWeight.w300),
          helperText: widget.helper,
          alignLabelWithHint: true,
          errorText: widget.errorMessage,
          focusColor: colors.primary,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 25, vertical: 9),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Color.fromARGB(255, 65, 63, 63),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}