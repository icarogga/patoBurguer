import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:patoburguer/screens/promocao.dart';
import 'package:patoburguer/screens/registerForm.dart';
import 'package:patoburguer/screens/showMessage.dart';

class RegisterPromocao extends StatefulWidget {
  @override
  _RegisterPromocaoState createState() => _RegisterPromocaoState();
}

class _RegisterPromocaoState extends State<RegisterPromocao> {
  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future _setDataPromocao() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    QuerySnapshot result = await _firestore.collection("promocoes").get();

    bool has = false;
    result.docs.forEach((d) {
      if (d.get("nome") == _nomeController.text) {
        has = true;
      }
    });

    if (!has) {
      if (_formKey.currentState.validate()) {
        if (_nomeController != null && _descricaoController != null) {
          _firestore.collection("promocoes").doc().set({
            "nome": _nomeController.text,
            "descricao": _descricaoController.text
          });
          showMyDialog("", "Promoção Cadastrada com sucesso", "OK", context);
          _nomeController.text = "";
          _descricaoController.text = "";
        }
      }
    } else {
      showMyDialog("", "Promoção já cadastrada!", "OK", context);
    }
  }

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
                  image: AssetImage('assets/images/voltar.png'),
                  width: 15.0,
                )),
          ),
          Spacer(),
          Text("CRIAR PROMOÇÃO",
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
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      getFormTextField("Nome", _nomeController, false),
                      Divider(color: Color(0xffF6F6F6)),
                      getFormTextField(
                          "Descrição", _descricaoController, false),
                    ],
                  )),
            ),
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
                      onPressed: () async {
                        await _setDataPromocao();
                      })),
            ),
          ],
        ),
      ),
    );
  }
}
