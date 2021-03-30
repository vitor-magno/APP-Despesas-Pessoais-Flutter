import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class AdaptativeTextField extends StatelessWidget {

  final TextEditingController controller;
  final TextInputType keyboardType;
  final void Function(String) onSubmitted;
  final String label;

  //ISSO É O CONSTRUCTOR DO ANGULAR
  AdaptativeTextField({
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onSubmitted,
    this.label
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? CupertinoTextField(
        controller: controller,
        onSubmitted: onSubmitted,
        keyboardType: keyboardType,
        placeholder: label,

    ) : TextField(
              keyboardType: keyboardType,
              //onSubmitted serve para ao clicar no "ok" do teclado faça o "envio" do formulário
              onSubmitted: onSubmitted,
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
              ),
    );
  }
}