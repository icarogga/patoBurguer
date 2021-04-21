import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patoburguer/screens/func.dart';
import 'package:patoburguer/screens/showMessage.dart';
import '../main.dart';
import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);
  final _emailController = TextEditingController();
  final _nomeController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _setData() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    QuerySnapshot result = await _firestore.collection("usuarios").get();

    bool has = false;
    result.docs.forEach((d) {
      if(d.get("email") == user) {
        has = true;
      }
    });

    if(has) {
      has = false;
      bool admin = false;
      if (_formKey.currentState.validate()) {
        result.docs.forEach((d) {
          if (d.get("email") == _emailController.text) {
            has = true;
          }
        });
        if (has) {
          showMyDialog("",
              "Este usuário já está cadastrado!",
              "OK",
              context);
        } else {
          if (chosenValue == "Administrador") {
            admin = true;
          }
          _firestore.collection("usuarios").doc().set({
            "nome": _nomeController.text,
            "email": _emailController.text,
            "senha": generateSha(_senhaController.text),
            "admin": admin
          });
          showMyDialog("",
              "Usuário cadastrado com sucesso!",
              "OK",
              context);
          _nomeController.text = "";
          _emailController.text = "";
          _senhaController.text = "";
        }
      }
    } else {
      showMyDialog("", "Ocorreu um erro na sua autenticação!", "OK", context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
              (Route<dynamic> route) => false);
    }
  }

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
              Text("REGISTRAR",
                  style:
                  TextStyle(color: Color(0xffF6F6F6), fontSize: 21.0)),
            ]),
      ),
      body: Container(
        color: Color(0xffF6F6F6),
        child: Column(
          children: <Widget>[
            Divider(color: Color(0xffF6F6F6), height: 17.0),
            Flexible(child: Container(margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    color: Color(0xffF6F6F6),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                width: 351.0,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            getFormTextField("Email", _emailController, false),
                            Divider(color: Color(0xffF6F6F6)),
                            getFormTextField("Nome", _nomeController, false),
                            Divider(color: Color(0xffF6F6F6)),
                            getFormTextField("Senha", _senhaController, true),
                            Divider(color: Color(0xffF6F6F6)),
                            DropDown()
                          ],
                        )),
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
                              "Salvar",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            textColor: Colors.white,
                            color: main_color,
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _setData();
                            }
                        ),
                      ),
                    )
                  ],
                )
            ),)
          ],
        ),
      ),
    );
  }
}

Widget getFormTextField(hint, fieldController, obscure) {
  return TextFormField(
    validator: (text) {
      if (text == null || text.isEmpty) {
        return 'Preencha o campo!';
      } else if (hint == "Email" || hint == "Novo email") {
        if (!text.contains("@") || !text.contains(".com")) {
          return "Insira um email válido!";
        }
      } else if(text.length < 6 && (hint == "Senha" || hint == "Senha atual" || hint == "Nova senha" || hint == "Repita a nova senha")) {
        return "Senha inválida!";
      } else if((hint == "Preço" || hint == "Novo preço")) {
          if(isNumeric(text) == false || double.parse(text) <= 0.0) {
            return "Preço inválido!";
          }
      }
      return null;
    },
    style: TextStyle(
        fontSize: 20.0,
        color: Colors.black),
    controller: fieldController,
    decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xffE8E8E8),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Color(0xffE8E8E8)),
        ),
        hintText: hint,
        errorStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Color(0xff631717),
        ),
        hintStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.brown.withOpacity(0.4))),
    keyboardType: TextInputType.text,
    obscureText: obscure,
  );
}

class DropDown extends StatefulWidget {
  @override
  _DropDownState createState() => _DropDownState();
}

String chosenValue;
class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(0.0),
        child: DropdownButton<String>(
          hint: Text("Selecione o tipo", style: TextStyle(color: Colors.black, fontSize: 20.0),),
          value: chosenValue,
          //elevation: 5,
          style: TextStyle(color: Colors.black, fontSize: 20.0),
          items: <String>[
            'Administrador',
            'Funcionário',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String value) {
            setState(() {
              FocusScope.of(context).requestFocus(FocusNode());
              chosenValue = value;
            });
          },
        ),
      ),
    );
  }
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}