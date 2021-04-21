import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:patoburguer/screens/registerForm.dart';
import 'package:patoburguer/screens/showMessage.dart';
import 'admin.dart';
import 'func.dart';
import 'login.dart';

class Contato extends StatefulWidget {
  @override
  _ContatoState createState() => _ContatoState();
}

class _ContatoState extends State<Contato> {

  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);

  CollectionReference contatos =
  FirebaseFirestore.instance.collection('contatos');

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
                ),
                Spacer(),
                Text("CONTATOS",
                    style:
                    TextStyle(color: Color(0xffF6F6F6), fontSize: 21.0)),
                Spacer(),
                SizedBox(
                  width: 45.0,
                  height: 80.0
                )
              ]),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: contatos.snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      else if(snapshot.connectionState == ConnectionState.waiting)
                        Center(child: CircularProgressIndicator())
                      else
                        for(var i in snapshot.data.docs)
                          _buildContactCard(i.get("aplicativo"), i.get("link"), context)
                    ],
                  ));
            }));
  }
}

class EditContact extends StatefulWidget {
  @override
  _EditContactState createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {

  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);

  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _updateLink() async {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final QuerySnapshot result = await _firestore.collection("contatos").get();

    if (_formKey.currentState.validate()) {
      result.docs.forEach((d) {
        if (d.get("link") == atualLink && d.get("link") != _controller.text) {
          _firestore.collection("contatos").doc(d.id).update({
            "link" : _controller.text
          });
          setState(() {
            atualLink = _controller.text;
            _controller.text = "";
          });
          showMyDialog("", "Link alterado com sucesso!", "OK", context);
        }
      });
    }
  }

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
                            builder: (context) => Contato(),
                          ),
                              (Route<dynamic> route) => false);
                    },
                    child: Image(
                      image: AssetImage('assets/images/voltar.png'),
                      width: 15.0,
                    )),
              ),
              Spacer(),
              Text("EDITAR CONTATO",
                  style:
                  TextStyle(color: Color(0xffF6F6F6), fontSize: 21.0)),
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
              children: <Widget>[
                Container(margin: EdgeInsets.all(20.0),
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Color(0xffF6F6F6),
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    width: 351.0,
                    child: Column(
                      children: <Widget>[
                        Text("Link atual: " + atualLink,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Divider(color: Color(0xffF6F6F6), height: 30.0),
                        Form(
                            key: _formKey,
                            child: getFormTextField("Novo link", _controller, false)),
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
                              _updateLink();
                            }
                        ),
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

String atualLink;
Widget _buildContactCard(String aplicativo, String link, BuildContext context) {
  return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
          onTap: () {
            atualLink = link;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditContact()),
            );
          },
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, spreadRadius: 3.0, blurRadius: 5.0)
                ],
                  color: Color(0xffF6F6F6)
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Image(
                      width: 100.0,
                      image: AssetImage('assets/images/$aplicativo.png'),
                      alignment: Alignment.center,
                    ),
                  ),
                  Text(
                    aplicativo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ))));
}


