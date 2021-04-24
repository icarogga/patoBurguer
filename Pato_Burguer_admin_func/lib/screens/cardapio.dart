import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:patoburguer/screens/editCardapio.dart';
import 'package:patoburguer/screens/registerForm.dart';
import 'package:patoburguer/screens/showMessage.dart';
import 'admin.dart';
import 'func.dart';
import 'login.dart';
import 'package:path/path.dart' as Path;
import 'dart:io' as i;

class GerenciarCardapio extends StatefulWidget {
  @override
  _GerenciarCardapioState createState() => _GerenciarCardapioState();
}

class _GerenciarCardapioState extends State<GerenciarCardapio> {

  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);

  CollectionReference cardapio = FirebaseFirestore.instance.collection('cardapio');

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
                Text("CARDÁPIO",
                    style:
                    TextStyle(color: Color(0xffF6F6F6), fontSize: 21.0)),
                Spacer(),
                // ignore: deprecated_member_use
                SizedBox(
                  width: 52.0,
                  height: 80.0,
                )
              ]),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: cardapio.snapshots(),
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
                        for (var i in snapshot.data.docs)
                          if (i.get("tipo") == "Lanche" && i.get("foto") != null)
                            _buildCardCardapio(i.get("nome"), i.get("preco"), i.get("descricao"),i.get("foto"),  context),

                      if (!snapshot.hasData)
                        Center(child: CircularProgressIndicator())
                      else if(snapshot.connectionState == ConnectionState.waiting)
                        Center(child: CircularProgressIndicator())
                      else
                        for (var i in snapshot.data.docs)
                          if (i.get("tipo") == "Refrigerante" && i.get("foto") != null)
                            _buildCardCardapio(i.get("nome"), i.get("preco"), i.get("descricao"), i.get("foto"), context),

                      if (!snapshot.hasData)
                        Center(child: CircularProgressIndicator())
                      else if(snapshot.connectionState == ConnectionState.waiting)
                        Center(child: CircularProgressIndicator())
                      else
                        for (var i in snapshot.data.docs)
                          if (i.get("tipo") == "Combo" && i.get("foto") != null)
                            _buildCardCardapio(i.get("nome"), i.get("preco"), i.get("descricao"), i.get("foto"), context)
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
                  MaterialPageRoute(builder: (context) => RegisterCardapio()),
                );
              },
            )
      ,);
  }
}


class RegisterCardapio extends StatefulWidget {
  @override
  _RegisterCardapioState createState() => _RegisterCardapioState();
}

class _RegisterCardapioState extends State<RegisterCardapio> {

  // ignore: non_constant_identifier_names
  Color main_color = Color(0xff8F4599);
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String text = "Carregar imagem";

  Future _setDataCardapio() async {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    QuerySnapshot result = await _firestore.collection("cardapio").get();

    bool has = false;
    result.docs.forEach((d) {
      if(d.get("nome") == _nomeController.text) {
        has = true;
      }
    });

    if(!has) {
      if (_formKey.currentState.validate()) {
        if (_image != null && tipoCardapio != null) {
          _firestore.collection("cardapio").doc().set({
            "nome": _nomeController.text,
            "preco": _precoController.text,
            "descricao": _descricaoController.text,
            "tipo": tipoCardapio,
            "foto": await uploadImageToFirebase(context)
          });
          showCardapio("", "Item registrado com sucesso!", "OK", context);
          _image = null;
        } else if(_image == null && tipoCardapio != null) {
          _firestore.collection("cardapio").doc().set({
            "nome": _nomeController.text,
            "preco": _precoController.text,
            "descricao": _descricaoController.text,
            "tipo": tipoCardapio,
            "foto": "https://firebasestorage.googleapis.com/v0/b/pato-burguer-2bd8d.appspot.com/o/generico.png?alt=media&token=2dea194c-2f6e-461a-bcef-cdccad435414"
          });
          showCardapio("", "Item registrado com sucesso!", "OK", context);
        }
        else if (tipoCardapio == null) {
          showMyDialog("", "Selecione um tipo!", "OK", context);
        } else {
          showMyDialog("", "Outro!", "OK", context);
        }
      }
    } else {
      showMyDialog("", "Item já cadastrado!", "OK", context);
    }
  }

  i.File _image;
  Future getImage() async {
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<String> uploadImageToFirebase(BuildContext context) async {
    String fileName = Path.basename(_image.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('$fileName');
    await firebaseStorageRef.putFile(_image);
    return await firebaseStorageRef.getDownloadURL();
  }

  bool isLoading = false;

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
                            builder: (context) => GerenciarCardapio(),
                          ),
                              (Route<dynamic> route) => false);
                    },
                    child: Image(
                      image: AssetImage('assets/images/voltar.png'),
                      width: 15.0,
                    )),
              ),
              Spacer(),
              Text("CADASTRAR ITEM",
                  style:
                  TextStyle(color: Color(0xffF6F6F6), fontSize: 21.0)),
              Spacer(),
              SizedBox(width: 45.0, height:80.0)
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
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        getFormTextField("Nome", _nomeController, false),
                        Divider(color: Color(0xffF6F6F6)),
                        getFormTextField("Preço", _precoController, false),
                        Divider(color: Color(0xffF6F6F6)),
                        getFormTextField("Descrição", _descricaoController, false),
                        Divider(color: Color(0xffF6F6F6)),
                        DropCardapio(),
                        Divider(color: Colors.black),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          child: Text(
                            "Carregar imagem",
                            style: TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                          color: main_color,
                          onPressed: getImage,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        ),
                        Divider(color: Color(0xffF6F6F6), height: 15.0),
                        if(_image == null)
                          Column(
                            children: <Widget>[
                              Text(
                                  "Imagem padrão:",
                                style: TextStyle(color: Colors.black, fontSize: 20.0),
                              ),
                              Divider(color: Color(0xffF6F6F6)),
                              Image(
                                width: 110.0,
                                image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/pato-burguer-2bd8d.appspot.com/o/generico.png?alt=media&token=2dea194c-2f6e-461a-bcef-cdccad435414"),
                              )
                            ],
                          ),
                        if(_image != null)
                          Column(
                            children: <Widget>[
                              Text(
                                  "Imagem selecionada:",
                                style: TextStyle(color: Colors.black, fontSize: 16.0),
                              ),
                              Divider(color: Color(0xffF6F6F6)),
                              Image(
                                  width: 110.0,
                                  image: FileImage(_image)
                              )
                            ],
                          ),
                        Divider(color: Colors.black),
                      ],
                    )),),
            Padding(
              padding: EdgeInsets.only(left: 100.0, right: 100.0),
              child: Container(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                width: 200.0,
                decoration: BoxDecoration(
                    color: Color(0xffF6F6F6),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                // ignore: deprecated_member_use
                child: !isLoading ? RaisedButton(
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
                      setState(() {
                        isLoading = true;
                      });
                      await _setDataCardapio();
                      setState(() {
                        isLoading = false;
                      });
                    }
                ) : Center(child:CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String nomeCardapio, tipoCardapio, descricaoCardapio, fotoCardapio; dynamic precoCardapio;

Widget _buildCardCardapio(String nome, dynamic preco, String descricao, String foto, BuildContext context) {
  return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
          onTap: () {
            nomeCardapio = nome;
            precoCardapio = preco;
            descricaoCardapio = descricao;
            fotoCardapio = foto;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditCardapio()),
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
                      image: NetworkImage(foto),
                    ),
                  ),
                  Text(
                    nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                      height: 30.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 1.0,
                              blurRadius: 1.0)
                        ],
                        color: Colors.orange[400],
                        border: Border.all(color: Colors.orange[800]),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "R\$" + preco,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
                ],
              ))));
}

class DropCardapio extends StatefulWidget {
  @override
  _DropCardapioState createState() => _DropCardapioState();
}

class _DropCardapioState extends State<DropCardapio> {
  String chosenTipo;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(0.0),
        child: DropdownButton<String>(
          hint: Text("Selecione o tipo", style: TextStyle(color: Colors.black, fontSize: 20.0),),
          value: chosenTipo,
          //elevation: 5,
          style: TextStyle(color: Colors.black, fontSize: 20.0),
          items: <String>[
            'Lanche',
            'Refrigerante',
            'Combo',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String value) {
            setState(() {
              FocusScope.of(context).requestFocus(FocusNode());
              chosenTipo = value;
              tipoCardapio = value;
            });
          },
        ),
      ),
    );
  }
}

Future<void> showCardapio(String title, String text, String button, BuildContext context) async {
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
          if(button == "OK")
            TextButton(
              child: Text(button),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => GerenciarCardapio(),
                    ),
                        (Route<dynamic> route) => false);
              },
            ),
        ],
      );
    },
  );
}
