// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class TextFormGlobal extends StatefulWidget {
  const TextFormGlobal({
    Key? key,
    required this.controller,
    required this.text,
    required this.textInputType,
    required this.obscure,
    required this.labelText,
    this.onTap,
  }) : super(key: key);

  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure;
  final String labelText;
  final Function()? onTap;

  @override
  _TextFormGlobalState createState() => _TextFormGlobalState();
}

class _TextFormGlobalState extends State<TextFormGlobal> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(top: 3, left: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 7,
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.textInputType,
        obscureText: _obscureText && widget.obscure,
        decoration: InputDecoration(
          hintText: widget.text,
          border: InputBorder.none,
          labelText: widget.labelText,
          contentPadding: const EdgeInsets.all(0),
          hintStyle: const TextStyle(height: 1),
          suffixIcon: widget.obscure
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                )
              : null,
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
