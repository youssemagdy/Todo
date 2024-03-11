import 'package:flutter/material.dart';
typedef fieldVaildation = String? Function(String?)?;
class CustomFormField extends StatelessWidget
{
  String label;
  TextInputType keybord;
  bool obscureText;
  Widget? suffixIcon;
  fieldVaildation vaildator;
  TextEditingController controller;
  int maxLines;
  CustomFormField({
    Key? key,
    required this.label,
    required this.keybord,
    this.obscureText = false,
    this.suffixIcon,
    this.vaildator,
    required this.controller,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: vaildator,
      keyboardType: keybord,
      obscureText: obscureText,
      obscuringCharacter: '*',
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black, fontSize: 16,),
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
