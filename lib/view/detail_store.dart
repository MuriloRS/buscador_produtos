import 'package:buscador_produtos/controller/store_controller.dart';
import 'package:buscador_produtos/model/store_model.dart';
import 'package:buscador_produtos/shared/modals.dart';
import 'package:buscador_produtos/shared/styles.dart';
import 'package:buscador_produtos/shared/validators.dart';
import 'package:buscador_produtos/widgets/carousel.dart';
import 'package:buscador_produtos/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class DetailStore extends StatefulWidget {
  bool firstAccess;
  dynamic user;

  DetailStore(this.firstAccess, this.user);
  @override
  _DetailStoreState createState() => _DetailStoreState();
}

class _DetailStoreState extends State<DetailStore> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _fbKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  Styles styles;
  bool isLoading = false;
  bool showCard = false;
  StoreModel storeModel;
  StoreController controller;
  Validators validators;

  @override
  Widget build(BuildContext context) {
    styles = new Styles(context);

    storeModel = Provider.of<StoreModel>(context);
    controller = StoreController();
    validators = Validators();

    showCard = storeModel.nome != null &&
        storeModel.cidade != null &&
        storeModel.cnpj != null &&
        storeModel.email != null &&
        storeModel.endereco != null &&
        storeModel.images.length > 0;

    _populateFields();

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Sua Loja",
            style: TextStyle(color: Colors.black, fontSize: 22)),
      ),
      body: Stack(
        children: <Widget>[
          isLoading
              ? Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Loader(
                          size: 38,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                )
              : Form(
                  key: _fbKey,
                  child: Container(
                    padding: EdgeInsets.only(
                        right: 20, left: 20, bottom: 10, top: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          showCard
                              ? Card(
                                  child: Container(
                                      padding: EdgeInsets.all(25),
                                      child: Text(
                                          "ATENÇÃO! Você precisa preencher todos os campos abaixo para aparecer para os clientes.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ))),
                                  color: Colors.red,
                                  elevation: 5,
                                )
                              : Container(),
                          SizedBox(
                            height: 20,
                          ),
                          Carousel(
                            controller: controller,
                            modals: new Modals(),
                            store: storeModel,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _nomeController,
                            maxLines: 1,
                            maxLength: 30,
                            decoration: InputDecoration(
                                fillColor: Colors.grey,
                                labelText: 'Nome*',
                                enabledBorder: Styles.getTextFieldBorder(),
                                focusedBorder: Styles.getTextFieldBorder()),
                            onFieldSubmitted: (value) {
                              if (validators.validateName(value, context)) {
                                _saveStoreDetail(
                                    nome: value,
                                    cidade: storeModel.cidade,
                                    cnpj: storeModel.cnpj,
                                    email: storeModel.email,
                                    endereco: storeModel.endereco,
                                    user: storeModel.user);
                              }
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _emailController,
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            maxLength: 30,
                            enabled: false,
                            decoration: InputDecoration(
                              fillColor: Colors.grey,
                              labelText: 'Email*',
                            ),
                            onFieldSubmitted: (value) {
                              if (validators.validateEmail(value, context)) {
                                _saveStoreDetail(
                                    nome: storeModel.nome,
                                    cidade: storeModel.cidade,
                                    cnpj: storeModel.cnpj,
                                    email: value,
                                    endereco: storeModel.endereco,
                                    user: storeModel.user);
                              }
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _cnpjController,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            maxLength: 14,
                            decoration: InputDecoration(
                              fillColor: Colors.grey,
                              labelText: 'CNPJ*',
                            ),
                            onFieldSubmitted: (value) {
                              if (validators.validateCnpj(value, context)) {
                                _saveStoreDetail(
                                    nome: storeModel.nome,
                                    cidade: storeModel.cidade,
                                    cnpj: value,
                                    email: storeModel.email,
                                    endereco: storeModel.endereco,
                                    user: storeModel.user);
                              }
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _cidadeController,
                            maxLines: 1,
                            decoration: InputDecoration(
                              fillColor: Colors.grey,
                              labelText: 'Cidade*',
                            ),
                            onFieldSubmitted: (value) {
                              if (validators.validateCidade(value, context)) {
                                _saveStoreDetail(
                                    nome: storeModel.nome,
                                    cidade: value,
                                    cnpj: storeModel.cnpj,
                                    email: storeModel.email,
                                    endereco: storeModel.endereco,
                                    user: storeModel.user);
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            maxLines: 1,
                            decoration: InputDecoration(
                              fillColor: Colors.grey,
                              labelText: 'Endereço*',
                            ),
                            controller: _enderecoController,
                            onFieldSubmitted: (value) {
                              if (validators.validateEndereco(value, context)) {
                                _saveStoreDetail(
                                    nome: storeModel.nome,
                                    cidade: storeModel.cidade,
                                    cnpj: storeModel.cnpj,
                                    email: storeModel.email,
                                    endereco: value,
                                    user: storeModel.user);
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  )),
        ],
      ),
    );
  }

  void _populateFields() {
    if (storeModel.nome != null) {
      _nomeController.text = storeModel.nome;
    }
    if (storeModel.user.email != null) {
      _emailController.text = storeModel.user.email;
    }
    if (storeModel.endereco != null) {
      _enderecoController.text = storeModel.endereco;
    }
    if (storeModel.cidade != null) {
      _cidadeController.text = storeModel.cidade;
    }
    if (storeModel.cnpj != null) {
      _cnpjController.text = storeModel.cnpj;
    }
  }

  void _saveStoreDetail(
      {@required FirebaseUser user,
      @required String nome,
      @required String cnpj,
      @required String cidade,
      @required String endereco,
      @required String email}) async {
    setState(() {
      isLoading = true;
    });

    StoreModel store = new StoreModel(user: user);
    store.ofMap(
        cidade: cidade,
        cnpj: cnpj,
        email: email,
        endereco: endereco,
        nome: nome,
        user: user);

    dynamic result = await controller.saveStoreDetail(storeModel: store);

    if (result == StoreStatus.success) {
      storeModel.saveStoreModel(store);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Seus dados foram salvos!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.green,
      ));
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(result.toString()),
        backgroundColor: Colors.red,
      ));
    }

    setState(() {
      isLoading = false;
    });
  }
}
