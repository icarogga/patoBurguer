import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:patoburguer/main.dart';
import 'package:patoburguer/screens/func.dart';
import 'package:patoburguer/screens/registerForm.dart';
import 'package:patoburguer/screens/showMessage.dart';
import 'admin.dart';
import 'login.dart';

class Config extends StatefulWidget {
  @override
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config> {

  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: main_color,
        automaticallyImplyLeading: false,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    if(admin) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => Admin(),
                          ),
                              (Route<dynamic> route) => false);
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => Func(),
                          ),
                              (Route<dynamic> route) => false);
                    }
                  },
                  child: Image(
                    image: AssetImage('assets/images/voltar.png'),
                    width: 15.0,
                  )),
              Text("EDITAR USUÁRIO",
                  style: TextStyle(color: Color(0xffF6F6F6), fontSize: 21.0)),
            ]),
      ),
      body: Container(
        color: Color(0xffF6F6F6),
        child: ListView(
          children: <Widget>[
            Container(margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    color: Color(0xffF6F6F6),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                width: 351.0,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    Button("Email", "email", context, fieldToEdit()),
                    Divider(color: Color(0xffF6F6F6)),
                    Button("Nome", "nome", context, fieldToEdit()),
                    Divider(color: Color(0xffF6F6F6)),
                    Button("Senha", "senha", context, fieldToEdit()),
                    Divider(color: Color(0xffF6F6F6)),
                    Padding(
                      padding: EdgeInsets.only(left: 100.0, right: 100.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: Color(0xffF6F6F6),
                            borderRadius: BorderRadius.all(Radius.circular(12.0))),
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                              "Apagar",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            textColor: Colors.white,
                            color: Colors.red,
                            onPressed: () {
                              showMyDialogTwo("", "Tem certeza que deseja apagar?", "", context);
                            }
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class fieldToEdit extends StatefulWidget {
  @override
  _fieldToEditState createState() => _fieldToEditState();
}

// ignore: camel_case_types
class _fieldToEditState extends State<fieldToEdit> {

  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);
  final _controller = TextEditingController();
  final _novaSenha = TextEditingController();
  final _confNovaSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _updateEmail() async {

    if (_formKey.currentState.validate()) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final QuerySnapshot result = await _firestore.collection("usuarios")
          .get();

      if (_formKey.currentState.validate()) {

        bool userAlreadyExists = false;
        result.docs.forEach((d) {
          if (d.get("email") == _controller.text && _controller.text != user) {
            userAlreadyExists = true;
            showMyDialog("ERRO", "Este E-mail já está sendo utilizado!", "OK", context);
          } else if(d.get("email") == _controller.text && _controller.text == user) {
            userAlreadyExists = true;
            showMyDialog("", "Novo e-mail precisa ser diferente do atual!", "OK", context);
          }
        });

        if (!userAlreadyExists) {
          result.docs.forEach((d) {
            if (d.get("email") == user) {
              _firestore.collection("usuarios").doc(d.id).update({
                "email" : _controller.text
              });
              setState(() {
                user = _controller.text;
                _controller.text = "";
              });
              showMyDialogTwo("", "E-mail alterado com sucesso!", "OK", context);
            }
          });
        }
      }
    }
  }

  void _updateNome() async {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final QuerySnapshot result = await _firestore.collection("usuarios").get();

    if (_formKey.currentState.validate()) {
      result.docs.forEach((d) {
        if (d.get("email") == user && d.get("nome") != _controller.text) {
          _firestore.collection("usuarios").doc(d.id).update({
            "nome" : _controller.text
          });
          setState(() {
            nome = _controller.text;
            _controller.text = "";
          });
          showMyDialog("", "Nome alterado com sucesso!", "OK", context);
        } else if(d.get("email") == user && d.get("nome") == _controller.text) {
          showMyDialog("", "Novo nome precisa ser diferente do atual!", "OK", context);
        }
      });
    }
  }

  void _updateSenha() async {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final QuerySnapshot result = await _firestore.collection("usuarios").get();

    if (_formKey.currentState.validate()) {
      result.docs.forEach((d) {
        if (d.get("email") == user && d.get("senha") == generateSha(_controller.text) && _controller.text != _novaSenha.text && _novaSenha.text == _confNovaSenha.text) {
          _firestore.collection("usuarios").doc(d.id).update({
            "senha" : generateSha(_novaSenha.text)
          });
          setState(() {
            senha = generateSha(_novaSenha.text);
            _controller.text = "";
            _novaSenha.text = "";
            _confNovaSenha.text = "";
          });
          showMyDialogTwo("", "Senha alterada com sucesso, faça login novamente!", "OK", context);
        } else if(d.get("email") == user && d.get("senha") == generateSha(_controller.text) &&  _controller.text == _novaSenha.text) {
          showMyDialog("", "Nova senha precisa ser diferente do atual!", "OK", context);
        } else if(d.get("email") == user && d.get("senha") == generateSha(_controller.text) && _novaSenha.text != _confNovaSenha.text) {
          showMyDialog("", "Senhas novas não conferem!", "OK", context);
        } else if(d.get("email") == user && d.get("senha") != generateSha(_controller.text)) {
          showMyDialog("", "Senha atual não confere!", "OK", context);
        }
      });
    }
  }

  final String scaffoldText = "Editar $type";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: main_color,
        automaticallyImplyLeading: false,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Config()),
                    );
                  },
                  child: Image(
                    alignment: Alignment.topLeft,
                    image: AssetImage('assets/images/voltar.png'),
                    width: 15.0,
                  )),
              Text(scaffoldText.toUpperCase(),
                  style:
                  TextStyle(color: Color(0xffF6F6F6), fontSize: 21.0)),
            ]),
      ),
      body: Container(
        color: Color(0xffF6F6F6),
        child: ListView(
          children: <Widget>[
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                if(type == "Email")
                  Container(margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Color(0xffF6F6F6),
                          borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      width: 351.0,
                      child: Column(
                        children: <Widget>[
                          Text("Email atual: " + user,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Divider(color: Color(0xffF6F6F6), height: 30.0),
                          Form(
                              key: _formKey,
                              child: getFormTextField("Novo email", _controller, false)),
                          Divider(color: Color(0xffF6F6F6), height: 30.0),
                          // ignore: deprecated_member_use
                          RaisedButton(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                "Salvar",
                                style: TextStyle(fontSize: 16.0),
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              textColor: Colors.white,
                              color: main_color,
                              onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                _updateEmail();
                              }
                          ),
                        ],
                      )),
                if(type == "Nome")
                  Container(margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Color(0xffF6F6F6),
                          borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      width: 351.0,
                      child: Column(
                        children: <Widget>[
                          Text("Nome atual: " + nome,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Divider(color: Color(0xffF6F6F6), height: 30.0),
                          Form(
                              key: _formKey,
                              child: getFormTextField("Novo nome", _controller, false)),
                          Divider(color: Color(0xffF6F6F6), height: 30.0),
                          // ignore: deprecated_member_use
                          RaisedButton(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                "Salvar",
                                style: TextStyle(fontSize: 16.0),
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              textColor: Colors.white,
                              color: main_color,
                              onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                _updateNome();
                              }
                          ),
                        ],
                      )),
                if(type == "Senha")
                  Container(margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Color(0xffF6F6F6),
                          borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      width: 351.0,
                      child: Column(
                        children: <Widget>[
                          Form(
                              key: _formKey,
                              child: Column(
                                  children: [
                                    getFormTextField("Senha atual", _controller, true),
                                    Divider(color: Color(0xffF6F6F6)),
                                    getFormTextField("Nova senha", _novaSenha, true),
                                    Divider(color: Color(0xffF6F6F6)),
                                    getFormTextField("Repita a nova senha", _confNovaSenha, true),
                                  ]
                              )
                          ),
                          Divider(color: Color(0xffF6F6F6), height: 30.0),
                          // ignore: deprecated_member_use
                          RaisedButton(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                "Salvar",
                                style: TextStyle(fontSize: 16.0),
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              textColor: Colors.white,
                              color: main_color,
                              onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                _updateSenha();
                              }
                          ),
                        ],
                      )
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
