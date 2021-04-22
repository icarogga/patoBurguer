import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:patoburguer/screens/editarPromocao.dart';
import 'package:patoburguer/screens/func.dart';
import 'package:patoburguer/screens/registrarPromocao.dart';
import 'admin.dart';
import 'login.dart';

class GerenciarPromocoes extends StatefulWidget {
  @override
  _GerenciarPromocoesState createState() => _GerenciarPromocoesState();
}

class _GerenciarPromocoesState extends State<GerenciarPromocoes> {
  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);

  CollectionReference promocoes =
      FirebaseFirestore.instance.collection('promocoes');

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
                      if (admin) {
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
              ),
              Spacer(),
              Text("PROMOÇÕES",
                  style: TextStyle(color: Color(0xffF6F6F6), fontSize: 21.0)),
              Spacer(),
              SizedBox(
                width: 50.0,
                height: 80.0,
                // ignore: deprecated_member_use
                child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPromocao()),
                      );
                    },
                    child: Image(
                      image: AssetImage('assets/images/adicionar.png'),
                    )),
              )
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: promocoes.snapshots(),
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
                          _buildCard(
                              i.get("nome"), i.get("descricao"), context),
                      if (!snapshot.hasData)
                        Center(child: CircularProgressIndicator())
                      else if (snapshot.connectionState ==
                          ConnectionState.waiting)
                        Center(child: CircularProgressIndicator())
                    ],
                  ));
            }));
  }
}

String atualNomePromocao, atualDescricaoPromocao;
Widget _buildCard(String nome, String descricao, BuildContext context) {
  return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
          onTap: () {
            atualDescricaoPromocao = descricao;
            atualNomePromocao = nome;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditPromocao()),
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
                      image: AssetImage('assets/images/promo-icone.png'),
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
