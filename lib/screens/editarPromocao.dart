import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:patoburguer/screens/promocao.dart';
import 'package:patoburguer/screens/registerForm.dart';
import 'package:patoburguer/screens/showMessage.dart';
import 'admin.dart';

class EditPromocao extends StatefulWidget {
  @override
  _EditPromocaoState createState() => _EditPromocaoState();
}

class _EditPromocaoState extends State<EditPromocao> {
  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: main_color,
        automaticallyImplyLeading: false,
        title: Row(children: <Widget>[
          SizedBox(
            width: 45.0,
            height: 80.0,
            // ignore: deprecated_member_use
            child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => GerenciarPromocoes(),
                      ),
                      (Route<dynamic> route) => false);
                },
                child: Image(
                  alignment: Alignment.topLeft,
                  image: AssetImage('assets/images/voltar.png'),
                  width: 15.0,
                )),
          ),
          Spacer(),
          Text("EDITAR PROMOÇÃO",
              style: TextStyle(color: Color(0xffF6F6F6), fontSize: 21.0)),
          Spacer(),
          SizedBox(width: 45.0, height: 80.0)
        ]),
      ),
      body: Container(
        color: Color(0xffF6F6F6),
        child: ListView(
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    color: Color(0xffF6F6F6),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                width: 351.0,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    Button("Nome", "promo-icone-menu", context, itemToEdit()),
                    Divider(color: Color(0xffF6F6F6)),
                    Button("Descrição", "descricao", context, itemToEdit()),
                    Divider(color: Color(0xffF6F6F6)),
                    Padding(
                      padding: EdgeInsets.only(left: 100.0, right: 100.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: Color(0xffF6F6F6),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
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
                              print(atualNomePromocao);
                              print(atualDescricaoPromocao);
                              deletePromocao(
                                  "",
                                  "Tem certeza que deseja apagar?",
                                  "",
                                  context);
                            }),
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
class itemToEdit extends StatefulWidget {
  @override
  _itemToEditState createState() => _itemToEditState();
}

// ignore: camel_case_types
class _itemToEditState extends State<itemToEdit> {
  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);

  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void updateNomePromocao() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final QuerySnapshot result = await _firestore.collection("promocoes").get();

    if (_formKey.currentState.validate()) {
      bool nameAlreadyExists = false;
      result.docs.forEach((d) {
        if (d.get("nome") == _controller.text &&
            _controller.text != atualNomePromocao) {
          nameAlreadyExists = true;
          showMyDialog("ERRO", "Este item já está cadastrado!", "OK", context);
        } else if (d.get("nome") == _controller.text &&
            _controller.text == atualNomePromocao) {
          nameAlreadyExists = true;
          showMyDialog(
              "", "Novo nome precisa ser diferente do atual!", "OK", context);
        }
      });

      if (!nameAlreadyExists) {
        result.docs.forEach((d) {
          if (d.get("nome") == atualNomePromocao) {
            _firestore
                .collection("promocoes")
                .doc(d.id)
                .update({"nome": _controller.text});
            setState(() {
              atualNomePromocao = _controller.text;
              _controller.text = "";
            });
            showMyDialog("", "Nome alterado com sucesso!", "OK", context);
          }
        });
      }
    }
  }

  void updateDescricaoPromocao() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final QuerySnapshot result = await _firestore.collection("promocoes").get();

    if (_formKey.currentState.validate()) {
      if (atualDescricaoPromocao == _controller.text) {
        showMyDialog("", "Nova descrição precisa ser diferente da atual!", "OK",
            context);
      } else {
        result.docs.forEach((d) {
          if (d.get("nome") == atualNomePromocao) {
            _firestore
                .collection("promocoes")
                .doc(d.id)
                .update({"descricao": _controller.text});
            setState(() {
              atualDescricaoPromocao = _controller.text;
              _controller.text = "";
            });
            showMyDialog("", "Descrição alterado com sucesso!", "OK", context);
          }
        });
      }
    }
  }

  final String scaffoldText = "Editar $item";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: main_color,
        automaticallyImplyLeading: false,
        title: Row(children: <Widget>[
          SizedBox(
            width: 45.0,
            height: 80.0,
            // ignore: deprecated_member_use
            child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => EditPromocao(),
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
              style: TextStyle(color: Color(0xffF6F6F6), fontSize: 21.0)),
          Spacer(),
          SizedBox(
            width: 45.0,
            height: 80.0,
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
                if (item == "Nome")
                  Container(
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Color(0xffF6F6F6),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      width: 351.0,
                      child: Column(
                        children: <Widget>[
                          Text("Nome atual: " + atualNomePromocao,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Divider(color: Color(0xffF6F6F6), height: 30.0),
                          Form(
                              key: _formKey,
                              child: getFormTextField(
                                  "Novo nome", _controller, false)),
                          Divider(color: Color(0xffF6F6F6), height: 30.0),
                          // ignore: deprecated_member_use
                          RaisedButton(
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
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                updateNomePromocao();
                              }),
                        ],
                      )),
                if (item == "Descrição")
                  Container(
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Color(0xffF6F6F6),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      width: 351.0,
                      child: Column(
                        children: <Widget>[
                          Text("Descrição atual: " + atualDescricaoPromocao,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Divider(color: Color(0xffF6F6F6), height: 30.0),
                          Form(
                              key: _formKey,
                              child: getFormTextField(
                                  "Nova descrição", _controller, false)),
                          Divider(color: Color(0xffF6F6F6), height: 30.0),
                          // ignore: deprecated_member_use
                          RaisedButton(
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
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                updateDescricaoPromocao();
                              }),
                        ],
                      )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> deletePromocao(
    String title, String text, String button, BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text),
            ],
          ),
        ),
        actions: [
          if (button == "")
            Row(
              children: <Widget>[
                TextButton(
                  child: Text("CANCELAR"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("SIM"),
                  onPressed: () {
                    _deleteCardapio(context);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => GerenciarPromocoes(),
                        ),
                        (Route<dynamic> route) => false);
                  },
                ),
              ],
            )
        ],
      );
    },
  );
}

void _deleteCardapio(BuildContext context) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final QuerySnapshot result = await _firestore.collection("promocoes").get();
  result.docs.forEach((d) {
    if (d.get("nome") == atualNomePromocao) {
      _firestore.collection("promocoes").doc(d.id).delete();
    }
  });
}
