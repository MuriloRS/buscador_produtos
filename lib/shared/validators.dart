import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Validators {
  bool validateName(String name, BuildContext context) {
    String errorText = "";
    if (name.isEmpty) {
      errorText = "O nome é obrigatório";
    }

    if (name.length < 6) {
      errorText = "O nome precisa ter mais que 6 caracteres.";
    }

    if (errorText != "") {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          errorText,
          textAlign: TextAlign.center,
        ),
      ));
      return false;
    }

    return true;
  }

  bool validateEmail(String email, BuildContext context) {
    String errorText = "";
    if (email.isEmpty) {
      errorText = "O nome é obrigatório";
    }

    if (email.length < 6) {
      errorText = "O nome precisa ter mais que 6 caracteres.";
    }

    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      errorText = "Formato de email inválido";
    }

    if (errorText != "") {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          errorText,
          textAlign: TextAlign.center,
        ),
      ));
      return false;
    }

    return true;
  }

  bool validateCnpj(String cnpj, BuildContext context) {
    String errorText = "";
    if (cnpj.isEmpty) {
      errorText = "O CNPJ é obrigatório";
    }

    if (cnpj.length != 14) {
      errorText = "O CNPJ precisa ter 14 caracteres.";
    }

    if (errorText != "") {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          errorText,
          textAlign: TextAlign.center,
        ),
      ));
      return false;
    }

    return true;
  }

  bool validateCidade(String cidade, BuildContext context) {
    String errorText = "";
    if (cidade.isEmpty) {
      errorText = "A cidade é obrigatória.";
    }

    if (cidade.length > 30) {
      errorText = "A cidade pode ter até 30 caracteres.";
    }

    if (errorText != "") {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          errorText,
          textAlign: TextAlign.center,
        ),
      ));
      return false;
    }

    return true;
  }

  bool validateEndereco(String endereco, BuildContext context) {
    String errorText = "";
    if (endereco.isEmpty) {
      errorText = "O endereço é obrigatório";
    }

    if (endereco.length > 30) {
      errorText = "O endereço pode ter até 30 caracteres";
    }

    if (errorText != "") {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          errorText,
          textAlign: TextAlign.center,
        ),
      ));
      return false;
    }

    return true;
  }
}
