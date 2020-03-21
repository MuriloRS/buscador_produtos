import 'package:buscador_produtos/controller/authentication_controller.dart';
import 'package:buscador_produtos/shared/styles.dart';
import 'package:buscador_produtos/view/home_store.dart';
import 'package:buscador_produtos/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignupStore extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKeySignup =
      new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  @override
  _SignupStoreState createState() => _SignupStoreState();
}

class _SignupStoreState extends State<SignupStore> {
  Styles style;
  bool isLoading = false;
  String password;

  @override
  Widget build(BuildContext context) {
    style = new Styles(context);
    return Scaffold(
      key: widget._scaffoldKeySignup,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Cadastrar Loja",
            style: TextStyle(color: Colors.black, fontSize: 22)),
      ),
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Form(
                  key: widget._fbKey,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          maxLength: 14,
                          controller: widget._cnpjController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            fillColor: Colors.grey,
                            labelText: 'CNPJ*',
                          ),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'O CNPJ é obrigatório'),
                            MinLengthValidator(14,
                                errorText: 'O CNPJ precisa ter 14 caracteres.'),
                          ]),
                        ),
                        TextFormField(
                          controller: widget._emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'O email é obrigatório'),
                            EmailValidator(errorText: "Email inválido")
                          ]),
                          decoration: InputDecoration(
                            fillColor: Colors.grey,
                            labelText: 'Email*',
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          maxLines: 1,
                          controller: widget._passwordController,
                          obscureText: true,
                          onChanged: (val) => password = val,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'A senha é obrigatória'),
                            MinLengthValidator(6,
                                errorText: 'O CNPJ precisa ter 6 caracteres.'),
                          ]),
                          decoration: InputDecoration(
                            fillColor: Colors.grey,
                            labelText: 'Senha*',
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          maxLines: 1,
                          controller: widget._passwordRepController,
                          obscureText: true,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'A senha é obrigatória'),
                            MinLengthValidator(6,
                                errorText: 'O CNPJ precisa ter 6 caracteres.'),
                          ]),
                          decoration: InputDecoration(
                            fillColor: Colors.grey,
                            labelText: 'Repetir Senha*',
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                            width: double.infinity,
                            child: CupertinoButton(
                              color: Theme.of(context).primaryColor,
                              padding: EdgeInsets.all(10),
                              onPressed: isLoading
                                  ? null
                                  : () => doSignupStore({
                                        'formKey': widget._fbKey,
                                        'email': widget._emailController.text,
                                        'password':
                                            widget._passwordController.text,
                                        'cnpj': widget._cnpjController.text,
                                      }),
                              child: isLoading
                                  ? Loader(color: Colors.red, size: 24)
                                  : Text('Cadastrar',
                                      style: style.primaryButtonStyle),
                            )),
                      ],
                    ),
                  )))),
    );
  }

  void doSignupStore(Map<String, dynamic> parameters) async {
    if (!widget._fbKey.currentState.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    Map<dynamic, dynamic> resultAuth = await new AuthenticationController()
        .doSignupUser(parameters: parameters);

    switch (resultAuth['type']) {
      case AuthenticationResults.emailAlreadyUsed:
        widget._scaffoldKeySignup.currentState.showSnackBar(SnackBar(
          content: Text(
            "Esse email já está sendo usado",
            textAlign: TextAlign.center,
            style: style.styleSnackbarText,
          ),
          backgroundColor: style.getSnackbarColor(type: SnackbarType.error),
          duration: Duration(seconds: 5),
        ));
        break;
      case AuthenticationResults.cnpjAlreadyUsed:
        widget._scaffoldKeySignup.currentState.showSnackBar(SnackBar(
          content: Text(
            "Esse CNPJ já está sendo usado",
            textAlign: TextAlign.center,
            style: style.styleSnackbarText,
          ),
          backgroundColor: style.getSnackbarColor(type: SnackbarType.error),
          duration: Duration(seconds: 5),
        ));
        break;
      case AuthenticationResults.success:
        final page = HomeStore(resultAuth['user']);
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => page));
        break;
    }

    setState(() {
      isLoading = false;
    });
  }
}
