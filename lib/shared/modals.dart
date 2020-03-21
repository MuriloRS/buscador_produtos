import 'package:buscador_produtos/controller/authentication_controller.dart';
import 'package:buscador_produtos/controller/store_controller.dart';
import 'package:buscador_produtos/model/store_model.dart';
import 'package:buscador_produtos/shared/currency_formatter.dart';
import 'package:buscador_produtos/shared/styles.dart';
import 'package:buscador_produtos/shared/validators.dart';
import 'package:buscador_produtos/widgets/carousel.dart';
import 'package:buscador_produtos/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Modals {
  StoreController storeController;

  Modals() {
    storeController = StoreController();
  }

  void reserveProduct(context) {
    showDialog(
      context: context['context'],
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          titlePadding: EdgeInsets.only(left: 10, top: 5),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Que dia você quer buscar?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  )),
              IconButton(
                icon: Icon(Icons.close),
                iconSize: 20,
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  child: FlatButton(
                      color: Colors.grey[100],
                      textColor: Colors.grey[600],
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2018, 3, 5),
                            maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          print('confirm $date');
                        }, currentTime: DateTime.now(), locale: LocaleType.pt);
                      },
                      child: Text(
                        '20/12/2019',
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ))),
              Text(
                'Nós iremos reservar o produto para você apenas nesse dia.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: 200,
                child: CupertinoButton(
                  padding: EdgeInsets.all(10),
                  color: Theme.of(context).primaryColor,
                  onPressed: null,
                  child: Text('Cadastrar',
                      style: new Styles(context).primaryButtonStyle),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void showDialogRecoverPassword(context) {
    final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: emailController,
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: double.infinity,
                  child: CupertinoButton(
                    child: Text("Enviar"),
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      dynamic result = await new AuthenticationController()
                          .sendEmailRecoverPassword(emailController.text);

                      if (result == AuthenticationResults.success) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: new Styles(context)
                              .getSnackbarColor(type: SnackbarType.success),
                          content: Text(
                              "Te enviamos um link para você recuperar sua senha"),
                        ));
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: new Styles(context)
                              .getSnackbarColor(type: SnackbarType.error),
                          content: Text(result),
                        ));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDialogProductDetail(context, store) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(10),
            titlePadding: EdgeInsets.only(left: 10, top: 5),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Tênis Nike tam 42"),
                IconButton(
                  icon: Icon(Icons.close),
                  iconSize: 20,
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Carousel(
                    store: store, modals: this, controller: storeController),
                SizedBox(
                  height: 20,
                ),
                Text("Detalhes"),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'woejqwe qwo enqwoen qoweoq wneoq kdqwpdqs,dq spdqsd qd qwlekqwelqmwelq kwmeq wlek qwelq mqweqwelqweq',
                  maxLines: 5,
                  softWrap: true,
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[300],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "R\$ 200,00",
                      style: TextStyle(color: Colors.green),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.all(5),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Reservar',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {},
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  void newProduct(BuildContext scaffoldContext, StoreModel store,
      StoreController controller) {
    final GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
    final TextEditingController _nomeController = TextEditingController();
    final TextEditingController _precoController = TextEditingController();
    final TextEditingController _descricaoController = TextEditingController();
    final CurrencyInputFormatter _realFormatter = new CurrencyInputFormatter();

    Validators validators = new Validators();
    store.images.removeRange(0, store.images.length);

    showDialog(
        barrierDismissible: false,
        context: scaffoldContext,
        builder: (BuildContext context) {
          return AlertDialog(
              actions: <Widget>[
                FlatButton(
                  child: Text("Adicionar", style: TextStyle(fontSize: 18)),
                  onPressed: () async {
                    if (_fbKey.currentState.validate() ||
                        controller.files.length == 0) {
                      bool result = await controller.saveNewProduct(
                          store.user.uid,
                          _nomeController.text,
                          double.parse(_precoController.text),
                          _descricaoController.text);
                      if (result) {
                        Navigator.pop(scaffoldContext);
                        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
                          content: Text("Produto novo adicionado!"),
                          backgroundColor: Colors.green,
                        ));
                      }
                    }
                  },
                  color: Theme.of(context).primaryColor,
                ),
                FlatButton(
                    child: Text("Fechar",
                        style:
                            TextStyle(fontSize: 18, color: Colors.grey[700])),
                    onPressed: () => Navigator.pop(context))
              ],
              contentPadding:
                  EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 15),
              titleTextStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
              titlePadding: EdgeInsets.only(top: 15),
              title: Text("Novo Produto", textAlign: TextAlign.center),
              content: Form(
                  key: _fbKey,
                  child: Container(
                      padding: EdgeInsets.only(
                          right: 5, left: 5, bottom: 10, top: 10),
                      child: SingleChildScrollView(
                          child: Column(children: <Widget>[
                        Carousel(
                            idProductCarousel: true,
                            modals: this,
                            store: store,
                            controller: controller),
                        TextFormField(
                          controller: _nomeController,
                          maxLines: 1,
                          maxLength: 30,
                          decoration: InputDecoration(
                              fillColor: Colors.grey,
                              labelText: 'Nome*',
                              enabledBorder: Styles.getTextFieldBorder(),
                              focusedBorder: Styles.getTextFieldBorder()),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'O nome é obrigatório'),
                          ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _precoController,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly,
                            _realFormatter,
                          ],
                          decoration: InputDecoration(
                              fillColor: Colors.grey,
                              labelText: 'Preço*',
                              enabledBorder: Styles.getTextFieldBorder(),
                              focusedBorder: Styles.getTextFieldBorder()),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'O valor é obrigatório'),
                          ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _descricaoController,
                          maxLines: 5,
                          decoration: InputDecoration(
                              fillColor: Colors.grey,
                              labelText: 'Descrição*',
                              enabledBorder: Styles.getTextFieldBorder(),
                              focusedBorder: Styles.getTextFieldBorder()),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'A descrição é obrigatória'),
                          ]),
                        ),
                      ])))));
        });
  }

  void showModalConfirmImageDelete(String urlPhoto, BuildContext context,
      StoreController controller, StoreModel model) {
    bool isLoading = false;
    showDialog(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
                content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Você tem certeza que quer excluir a foto?",
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 20,
                ),
                isLoading
                    ? Loader()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () async {
                              setState(() => isLoading = true);

                              await controller.deleteImageStore(
                                  urlPhoto, model);

                              Navigator.pop(context);

                              setState(() => isLoading = false);
                            },
                            color: Theme.of(context).primaryColor,
                            child: Text("Sim",
                                style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          FlatButton(
                              onPressed: () => Navigator.pop(context),
                              color: Colors.grey[200],
                              child: Text("Não",
                                  style: TextStyle(color: Colors.grey[700])))
                        ],
                      )
              ],
            ));
          });
        });
  }
}
