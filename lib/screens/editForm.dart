import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:patoburguer/main.dart';
import 'package:patoburguer/screens/func.dart';
import 'package:patoburguer/screens/registerForm.dart';
import 'package:patoburguer/screens/showMessage.dart';
import 'admin.dart';

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {

  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: main_color,
        automaticallyImplyLeading: false,
        title: Row(
            children: <Widget>[
              SizedBox(
                width: 45.0,
                height: 80.0,
                // ignore: deprecated_member_use
                child: FlatButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => GerenciarFunc(),
                          ),
                              (Route<dynamic> route) => false);
                    },
                    child: Image(
                      image: AssetImage('assets/images/voltar.png'),
                      width: 15.0,
                    )),
              ),
              Spacer(),
              Text("EDITAR USUÁRIO",
                  style: TextStyle(color: Color(0xffF6F6F6), fontSize: 21.0)),
              Spacer(),
              SizedBox(
                width: 45.0,
                height: 80.0
              )
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
                              showMyDialog("", "Tem certeza que deseja apagar?", "", context);
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
          if (d.get("email") == _controller.text && _controller.text != atualEmail) {
            userAlreadyExists = true;
            showMyDialog("ERRO", "Este E-mail já está sendo utilizado!", "OK", context);
          } else if(d.get("email") == _controller.text && _controller.text == atualEmail) {
            userAlreadyExists = true;
            showMyDialog("", "Novo e-mail precisa ser diferente do atual!", "OK", context);
          }
        });

        if (!userAlreadyExists) {
          result.docs.forEach((d) {
            if (d.get("email") == atualEmail) {
              _firestore.collection("usuarios").doc(d.id).update({
                "email" : _controller.text
              });
              setState(() {
                atualEmail = _controller.text;
                _controller.text = "";
              });
              showMyDialog("", "E-mail alterado com sucesso, faça login novamente!", "OK", context);
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
        if (d.get("email") == atualEmail && d.get("nome") != _controller.text) {
          _firestore.collection("usuarios").doc(d.id).update({
            "nome" : _controller.text
          });
          setState(() {
            atualNome = _controller.text;
            _controller.text = "";
          });
          showMyDialog("", "Nome alterado com sucesso!", "OK", context);
        } else if(d.get("email") == atualEmail && d.get("nome") == _controller.text) {
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
        if (d.get("email") == atualEmail && d.get("senha") == generateSha(_controller.text) && _controller.text != _novaSenha.text && _novaSenha.text == _confNovaSenha.text) {
          _firestore.collection("usuarios").doc(d.id).update({
            "senha" : generateSha(_novaSenha.text)
          });
          setState(() {
            atualSenha = generateSha(_novaSenha.text);
            _controller.text = "";
            _novaSenha.text = "";
            _confNovaSenha.text = "";
          });
          showMyDialog("", "Senha alterada com sucesso!", "OK", context);
        } else if(d.get("email") == atualEmail && d.get("senha") == generateSha(_controller.text) &&  _controller.text == _novaSenha.text) {
          showMyDialog("", "Nova senha precisa ser diferente do atual!", "OK", context);
        } else if(d.get("email") == atualEmail && d.get("senha") == generateSha(_controller.text) && _novaSenha.text != _confNovaSenha.text) {
          showMyDialog("", "Senhas novas não conferem!", "OK", context);
        } else if(d.get("email") == atualEmail && d.get("senha") != generateSha(_controller.text)) {
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
            children: <Widget>[
              SizedBox(
                width: 45.0,
                height: 80.0,
                // ignore: deprecated_member_use
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => Edit(),
                          ),
                              (Route<dynamic> route) => false);
                    },
                    child: Image(
                      image: AssetImage('assets/images/voltar.png'),
                      width: 15.0,
                    )),
              ),
              Spacer(),
              Text(scaffoldText.toUpperCase(),
                  style:
                  TextStyle(color: Color(0xffF6F6F6), fontSize: 21.0)),
              Spacer(),
              SizedBox(
                width: 45.0,
                height: 80.0
              )
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
                      Text("Email atual: " + atualEmail,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                      Divider(color: Colors.white, height: 30.0),
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
                          Text("Nome atual: " + atualNome,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Divider(color: Colors.white, height: 30.0),
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
                                style: TextStyle(fontSize: 20.0),
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

