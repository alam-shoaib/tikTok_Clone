import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String lable;
  final IconData icon;
  final bool isObscurial;
  const TextInputField({Key? key,required this.controller,required this.lable,required this.icon,this.isObscurial=false}

      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: lable,
        prefixIcon: Icon(icon),
        labelStyle: const TextStyle(
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: borderColor
          )
        ),
      ),
      obscureText: isObscurial,
    );
  }
}
