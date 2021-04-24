import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:patoburguer/screens/func.dart';
import 'package:patoburguer/screens/promocao.dart';
import 'cardapio.dart';
import 'config.dart';
import 'contato.dart';
import 'login.dart';

// ignore: must_be_immutable
class Admin extends StatelessWidget {
  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: main_color,
        title: Text(
          "ÁREA ADMINISTRATIVA",
          style: TextStyle(color: Color(0xffF6F6F6), fontSize: 21.0),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xffF6F6F6),
        child: ListView(children: <Widget>[
          Divider(color: Color(0xffF6F6F6), height: 17.0),
          Container(
            alignment: Alignment.center,
            child: Image(
              image: AssetImage('assets/images/logo_pato_burguer.png'),
              width: 150.0,
              alignment: Alignment.center,
            ),
          ),
          Container(
            color: Color(0xffF6F6F6),
            padding: EdgeInsets.all(19.0),
            child: Column(
              children: <Widget>[
                Button("Gerenciar Usuários", "funcionario", context,
                    GerenciarFunc()),
                Divider(color: Color(0xffF6F6F6), height: 15.0),
                Button("Alterar Cardápio", "cardapio", context,
                    GerenciarCardapio()),
                Divider(color: Color(0xffF6F6F6), height: 15.0),
                Button("Alterar Contatos", "contato", context, Contato()),
                Divider(color: Color(0xffF6F6F6), height: 15.0),
                Button("Promoções", "promo-icone-menu", context,
                    GerenciarPromocoes()),
                Divider(color: Color(0xffF6F6F6), height: 15.0),
                Button("Configurações", "config", context, Config()),
                SizedBox(height: 30.0),
                Container(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Color(0xffF6F6F6),
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        "Sair",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      textColor: Colors.white,
                      color: main_color,
                      onPressed: () async {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ),
                            (Route<dynamic> route) => false);
                      }),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

String type, item;

// ignore: non_constant_identifier_names
Widget Button(String text, String image, BuildContext context, Widget newPage) {
  return ButtonTheme(
    minWidth: 350.0,
    height: 60.0,
    // ignore: deprecated_member_use
    child: RaisedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "$text",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Image(
            image: AssetImage('assets/images/$image.png'),
            width: 40.0,
          ),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Color(0xffE8E8E8),
      onPressed: () {
        if (text == "Email") {
          type = "Email";
        } else if (text == "Nome") {
          type = "Nome";
          item = "Nome";
        } else if (text == "Senha") {
          type = "Senha";
        } else if (text == "Preço") {
          item = "Preço";
        } else if (text == "Descrição") {
          item = "Descrição";
        } else if (text == "Imagem") {
          item = "Imagem";
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => newPage),
        );
      },
    ),
  );
}
