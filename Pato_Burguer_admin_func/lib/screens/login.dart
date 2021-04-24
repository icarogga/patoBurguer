import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter/painting.dart';
import 'package:patoburguer/screens/admin.dart';
import 'package:patoburguer/screens/showMessage.dart';
import '../main.dart';
import 'func.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

String user, nome, senha; bool admin;

class _LoginState extends State<Login> {

  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);
  final _formKeyEmail = GlobalKey<FormFieldState>();
  final _formKeyPass = GlobalKey<FormFieldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _hasNoUser, isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: main_color,
        title: Text("BEM-VINDO", style: TextStyle(color: Color(0xffF6F6F6), fontSize: 21.0),),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xffF6F6F6),
        child: Column(
          children: <Widget>[
            Divider(color: Color(0xffF6F6F6), height: 17.0),
            Image(
                image: AssetImage('assets/images/logo_pato_burguer.png'),
                width: 150.0,
                alignment: Alignment.center),
            SizedBox(height: 16.0),
            Flexible(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  padding: EdgeInsets.only(
                      top: 17.0, bottom: 1.0, right: 17.0, left: 17.0),
                  width: 350.0,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[
                      TextFormField(
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black),
                        controller: _emailController,
                        key: _formKeyEmail,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xffE8E8E8),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: "E-mail",
                            hintStyle: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            errorStyle: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff631717),
                            )),
                        keyboardType: TextInputType.emailAddress,
                        // ignore: missing_return
                        validator: (text) {
                          if (text.isEmpty || !text.contains("@"))
                            return "E-mail inválido!";
                        },
                      ),
                      Divider(color: Color(0xffF6F6F6)),
                      TextFormField(
                        controller: _passController,
                        key: _formKeyPass,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xffE8E8E8),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: "Senha",
                            hintStyle: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            errorStyle: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff631717),
                            )),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        // ignore: missing_return
                        validator: (text) {
                          if (text.isEmpty || text.length < 6) {
                            return "Senha inválida!";
                          } else if (_hasNoUser) {
                            return "Usuário e\/ou Senha inválidos!";
                          }
                        },
                      ),
                      Divider(color: Color(0xffF6F6F6), height: 30.0),
                      Container(
                        padding: EdgeInsets.only(left: 50.0, right: 50.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: Color(0xffF6F6F6),
                            borderRadius: BorderRadius.all(Radius.circular(12.0))),
                        // ignore: deprecated_member_use
                        child: !isLoading ? RaisedButton(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                              "Entrar",
                              style:
                              TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            textColor: Colors.white,
                            color: main_color,
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                isLoading = true;
                              });
                              _hasNoUser = false;
                              if (_formKeyEmail.currentState.validate() &&
                                  _formKeyPass.currentState.validate()) {
                                try {
                                  final FirebaseFirestore _firestore =
                                      FirebaseFirestore.instance;
                                  QuerySnapshot result =
                                  await _firestore.collection("usuarios").get();
                                  bool has = false;
                                  result.docs.forEach((d) {
                                    if (d.get("email") == _emailController.text && d.get("senha") == generateSha(_passController.text)) {
                                      user = d.get("email");
                                      nome = d.get("nome");
                                      senha = d.get("senha");
                                      has = true;
                                      if (has && d.get("admin")) {
                                        admin = true;
                                      } else if(has && !d.get("admin")) {
                                        admin = false;
                                      }
                                    }
                                  });
                                  if (has && admin) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => Admin(),),
                                            (Route<dynamic> route) => false);
                                  } else if (has && !admin) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => Func()),
                                            (Route<dynamic> route) => false);
                                  } else {
                                    setState(() {
                                      _hasNoUser = true;
                                      _formKeyPass.currentState.validate();
                                    });
                                  }
                                } catch(e) {
                                  showMyDialog("Erro ao conectar",
                                      "Tente novamente mais tarde",
                                      "OK",
                                      context);
                                }
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }) : Center(child:CircularProgressIndicator()),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}