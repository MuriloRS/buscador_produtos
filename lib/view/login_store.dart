import 'package:buscador_produtos/controller/authentication_controller.dart';
import 'package:buscador_produtos/shared/modals.dart';
import 'package:buscador_produtos/shared/styles.dart';
import 'package:buscador_produtos/view/home_store.dart';
import 'package:buscador_produtos/view/signup_store.dart';
import 'package:buscador_produtos/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginStore extends StatefulWidget {
  @override
  _LoginStoreState createState() => _LoginStoreState();
}

class _LoginStoreState extends State<LoginStore> {
  bool isLoading = false;
  var styles;
  Widget _formLogin;

  @override
  Widget build(BuildContext context) {
    styles = new Styles(context);

    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, AsyncSnapshot<FirebaseUser> user) {
        if (user.connectionState.index == ConnectionState.none.index ||
            user.connectionState.index == ConnectionState.waiting.index) {
          return Loader();
        }
        if (user.data != null) {
          return HomeStore(user.data);
        }

        if (_formLogin == null) {
          _formLogin = _buildForm();
        }

        return SafeArea(
            child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              'Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
          ),
          body: Container(padding: EdgeInsets.all(20), child: _formLogin),
        ));
      },
    );
  }

  void _doLogin({String email, String password}) async {
    setState(() {
      isLoading = true;
    });

    AuthenticationController login = AuthenticationController();

    try {
      FirebaseUser user = await login.doEmailLogin();

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeStore(user)));
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(e),
        backgroundColor: styles.getSnackbarColor(type: SnackbarType.error),
        duration: Duration(seconds: 5),
      ));
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget _buildForm() {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              fillColor: Colors.grey,
              labelText: 'Email',
            ),
            validator: MultiValidator([
              RequiredValidator(errorText: 'Email é obrigatório'),
              EmailValidator(errorText: 'Email inválido')
            ]),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            maxLines: 1,
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              fillColor: Colors.grey,
              labelText: 'Senha',
            ),
            validator: MultiValidator([
              RequiredValidator(errorText: 'Senha é obrigatório'),
              LengthRangeValidator(
                  min: 6,
                  max: 30,
                  errorText: 'A senha deve ter no mínimo 6 caracteres')
            ]),
          ),
          SizedBox(
            height: 16,
          ),
          FlatButton(
            child: Text("Esqueci minha senha",
                style: TextStyle(
                    color: Colors.grey[700],
                    decoration: TextDecoration.underline)),
            color: Colors.transparent,
            onPressed: () => new Modals().showDialogRecoverPassword(context),
          ),
          SizedBox(
            height: 25,
          ),
          isLoading
              ? Loader()
              : Container(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: EdgeInsets.all(10),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {},
                    child: Text('Entrar', style: styles.primaryButtonStyle),
                  ),
                ),
          SizedBox(
            height: 25,
          ),
          CupertinoButton(
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.grey[300],
            child: Text(
              'Cadastrar Loja',
              style: TextStyle(color: Colors.black, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SignupStore()));
            },
          )
        ],
      ),
    );
  }
}
