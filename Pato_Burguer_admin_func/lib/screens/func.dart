import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:patoburguer/screens/cardapio.dart';
import 'package:patoburguer/screens/promocao.dart';
import 'package:patoburguer/screens/registerForm.dart';
import 'admin.dart';
import 'config.dart';
import 'contato.dart';
import 'editForm.dart';
import 'login.dart';

// ignore: must_be_immutable
class Func extends StatelessWidget {
  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: main_color,
        automaticallyImplyLeading: false,
        title: Text(
          "ÁREA P/ FUNCIONÁRIO",
          textAlign: TextAlign.center,
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
          SizedBox(height: 20.0),
          Container(
            color: Color(0xffF6F6F6),
            padding: EdgeInsets.all(19.0),
            child: Column(
              children: <Widget>[
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

class GerenciarFunc extends StatefulWidget {
  @override
  _GerenciarFuncState createState() => _GerenciarFuncState();
}

class _GerenciarFuncState extends State<GerenciarFunc> {
  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);

  CollectionReference usuarios =
      FirebaseFirestore.instance.collection('usuarios');

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
                            builder: (context) => Admin(),
                          ),
                          (Route<dynamic> route) => false);
                    },
                    child: Image(
                      image: AssetImage('assets/images/voltar.png'),
                      width: 15.0,
                    )),
              ),
              Spacer(),
              Text("GERENCIAR",
                  style: TextStyle(color: Color(0xffF6F6F6), fontSize: 21.0)),
              Spacer(),
              SizedBox(
                width: 50.0,
                height: 80.0,
              )
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: usuarios.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: GridView.count(
                    crossAxisCount: 2,
                    primary: false,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: 0.9,
                    children: [
                      if (!snapshot.hasData)
                        Center(child: CircularProgressIndicator())
                      else if (snapshot.connectionState ==
                          ConnectionState.waiting)
                        Center(child: CircularProgressIndicator())
                      else
                        for (var i in snapshot.data.docs)
                          if (i.get("admin") && i.get("email") != user)
                            _buildCard(i.get("email"), i.get("nome"),
                                i.get("senha"), "administrador", context),
                      if (!snapshot.hasData)
                        Center(child: CircularProgressIndicator())
                      else if (snapshot.connectionState ==
                          ConnectionState.waiting)
                        Center(child: CircularProgressIndicator())
                      else
                        for (var i in snapshot.data.docs)
                          if (!i.get("admin") && i.get("email") != user)
                            _buildCard(i.get("email"), i.get("nome"),
                                i.get("senha"), "funcionario", context)
                    ],
                  ));
            }),
            floatingActionButton: FloatingActionButton(
              backgroundColor: main_color,
              child: Image(
                width: 20.0,
                image: AssetImage('assets/images/adicionar.png'),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
            ),
    );
  }
}

String atualEmail, atualNome, atualSenha;
Widget _buildCard(String email, String nome, String senha, String tipo,
    BuildContext context) {
  return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
          onTap: () {
            atualEmail = email;
            atualNome = nome;
            atualSenha = senha;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Edit()),
            );
          },
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, spreadRadius: 3.0, blurRadius: 5.0)
                ],
                color: Color(0xffF6F6F6),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Image(
                      height: 83,
                      width: 95.0,
                      image: AssetImage('assets/images/$tipo.png'),
                      alignment: Alignment.center,
                    ),
                  ),
                  Text(
                    nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ))));
}
