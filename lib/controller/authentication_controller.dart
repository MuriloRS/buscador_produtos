import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthenticationResults {
  emailAlreadyUsed,
  cnpjAlreadyUsed,
  success,
}

class AuthenticationController {
  Future<FirebaseUser> doEmailLogin() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    return user;
  }

  Future<Map<dynamic,dynamic>> doSignupUser(
      {@required Map<String, dynamic> parameters}) async {
    GlobalKey<FormState> key = parameters['formKey'];
    String email = parameters['email'];
    String password = parameters['password'];
    String cnpj = parameters['cnpj'];

    if (key.currentState.validate()) {
      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;

        final AuthResult user = (await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ));

        bool validCnpj = await _verifyCnpj(cnpj: cnpj);
        if (!validCnpj) {
          if (user != null) {
            await Firestore.instance
                .collection('store')
                .document(user.user.uid)
                .setData({'email': email, 'cnpj': cnpj});

            var firebaseUser = await FirebaseAuth.instance.currentUser();

            return {
              'type': AuthenticationResults.success,
              'user': firebaseUser
            };
          }
        } else {
          return {
            'type': AuthenticationResults.cnpjAlreadyUsed,
          };
        }
      } catch (e) {
        String errorMsg = '';

        if (e.code != null) {
          if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
            errorMsg = "Esse email já está sendo usado";
          }
        } else{
          errorMsg = e.toString();
        }

        return {
          'type': AuthenticationResults.cnpjAlreadyUsed,
          'error': errorMsg
        };
      }
    }
  }

  Future<bool> _verifyCnpj({@required String cnpj}) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('store')
        .where('cnpj', isEqualTo: cnpj)
        .getDocuments();

    return snapshot.documents.length > 0 ? true : false;
  }

  Future<AuthenticationResults> sendEmailRecoverPassword(email) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.sendPasswordResetEmail(email: email);

      return AuthenticationResults.success;
    } catch (e) {
      return e;
    }
  }
}
