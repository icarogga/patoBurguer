import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patoburguer/screens/cardapio.dart';
import 'package:patoburguer/screens/registerForm.dart';
import 'package:patoburguer/screens/showMessage.dart';
import 'admin.dart';
import 'package:path/path.dart' as Path;
import 'dart:io' as i;

class EditCardapio extends StatefulWidget {
  @override
  _EditCardapioState createState() => _EditCardapioState();
}

class _EditCardapioState extends State<EditCardapio> {

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
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => GerenciarCardapio(),
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
              Text("EDITAR ITEM",
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
                    Button("Nome", "hamburguer", context, itemToEdit()),
                    Divider(color: Color(0xffF6F6F6)),
                    Button("Preço", "preco", context, itemToEdit()),
                    Divider(color: Color(0xffF6F6F6)),
                    Button("Descrição", "descricao", context, itemToEdit()),
                    Divider(color: Color(0xffF6F6F6)),
                    Button("Imagem", "imagem", context, itemToEdit()),
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
                              print(nomeCardapio);
                              print(fotoCardapio);
                              deleteCardapio("", "Tem certeza que deseja apagar?", "", context);
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
  
  void updateNomeCardapio() async {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final QuerySnapshot result = await _firestore.collection("cardapio").get();
    
    if (_formKey.currentState.validate()) {

      bool nameAlreadyExists = false;
      result.docs.forEach((d) {
        if (d.get("nome") == _controller.text && _controller.text != nomeCardapio) {
          nameAlreadyExists = true;
          showMyDialog("ERRO", "Este item já está cadastrado!", "OK", context);
        } else if(d.get("nome") == _controller.text && _controller.text == nomeCardapio) {
          nameAlreadyExists = true;
          showMyDialog("", "Novo nome precisa ser diferente do atual!", "OK", context);
        }
      });

      if (!nameAlreadyExists) {
        result.docs.forEach((d) {
          if (d.get("nome") == nomeCardapio) {
            _firestore.collection("cardapio").doc(d.id).update({
              "nome" : _controller.text
            });
            setState(() {
              nomeCardapio = _controller.text;
              _controller.text = "";
            });
            showMyDialog("", "Nome alterado com sucesso!", "OK", context);
          }
        });
      }
    } 
  }

  void updatePrecoCardapio() async {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final QuerySnapshot result = await _firestore.collection("cardapio").get();

    if (_formKey.currentState.validate()) {

      if(precoCardapio == _controller.text) {
        showMyDialog("", "Novo preço precisa ser diferente do atual!", "OK", context);
      } else {
        result.docs.forEach((d) {
          if (d.get("nome") == nomeCardapio) {
            _firestore.collection("cardapio").doc(d.id).update({
              "preco" : _controller.text
            });
            setState(() {
              precoCardapio = _controller.text;
              _controller.text = "";
            });
            showMyDialog("", "Preço alterado com sucesso!", "OK", context);
          }
        });
      }
    }
  }

  void updateDescricaoCardapio() async {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final QuerySnapshot result = await _firestore.collection("cardapio").get();

    if (_formKey.currentState.validate()) {
      if(descricaoCardapio == _controller.text) {
        showMyDialog("", "Nova descrição precisa ser diferente da atual!", "OK", context);
      } else {
        result.docs.forEach((d) {
          if (d.get("nome") == nomeCardapio) {
            _firestore.collection("cardapio").doc(d.id).update({
              "descricao" : _controller.text
            });
            setState(() {
              descricaoCardapio = _controller.text;
              _controller.text = "";
            });
            showMyDialog("", "Descrição alterado com sucesso!", "OK", context);
          }
        });
      }
    }
  }

  Future updateImagemCardapio() async {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final QuerySnapshot result = await _firestore.collection("cardapio").get();

    if(_image == null) {
      showMyDialog("", "Selecione uma foto!", "OK", context);
    } else {
      result.docs.forEach((d) async {
        fotoCardapio = await uploadImageToFirebase(context);
        if(d.get("nome") == nomeCardapio) {
          _firestore.collection("cardapio").doc(d.id).update({
            "foto" : fotoCardapio
          });
          setState(() {
            isLoading = false;
            textImagem = "Imagem atual: ";
          });
          showCardapio("", "Imagem alterada com sucesso!", "OK", context);
          _image = null;
        }
      });
    }
  }

  i.File _image;
  Future getImage() async {
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      if(_image != null) {
        textImagem = "Nova imagem: ";
      } else {
        textImagem = "Imagem atual: ";
      }
    });
  }

  Future<String> uploadImageToFirebase(BuildContext context) async {
    String fileName = Path.basename(_image.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('$fileName');
    await firebaseStorageRef.putFile(_image);
    return await firebaseStorageRef.getDownloadURL();
  }

  String textImagem = "Imagem atual: ";
  final String scaffoldText = "Editar $item";
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
                            builder: (context) => EditCardapio(),
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
                if(item == "Nome")
                  Container(margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Color(0xffF6F6F6),
                          borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      width: 351.0,
                      child: Column(
                        children: <Widget>[
                          Text("Nome atual: " + nomeCardapio,
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
                                updateNomeCardapio();
                              }
                          ),
                        ],
                      )),
                if(item == "Preço")
                  Container(margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Color(0xffF6F6F6),
                          borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      width: 351.0,
                      child: Column(
                        children: <Widget>[
                          Text("Preço atual: " + precoCardapio,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Divider(color: Color(0xffF6F6F6), height: 30.0),
                          Form(
                              key: _formKey,
                              child: getFormTextField("Novo preço", _controller, false)),
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
                                updatePrecoCardapio();
                              }
                          ),
                        ],
                      )),
                if(item == "Descrição")
                  Container(margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Color(0xffF6F6F6),
                          borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      width: 351.0,
                      child: Column(
                        children: <Widget>[
                          Text("Descrição atual: " + descricaoCardapio,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Divider(color: Color(0xffF6F6F6), height: 30.0),
                          Form(
                              key: _formKey,
                              child: getFormTextField("Nova descrição", _controller, false)),
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
                                updateDescricaoCardapio();
                              }
                          ),
                        ],
                      )),
                if(item == "Imagem")
                  Container(margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Color(0xffF6F6F6),
                          borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      width: 351.0,
                      child: Column(
                        children: <Widget>[
                          Text(textImagem,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Divider(color: Color(0xffF6F6F6), height: 30.0),
                          Column(
                            children: [
                              if(_image == null)
                                Image(
                                  width: 110.0,
                                  image: NetworkImage(fotoCardapio),
                                ),
                              if(_image != null)
                                Image(
                                  width: 110.0,
                                  image: FileImage(_image),
                                ),
                            ],
                          ),
                          Divider(color: Color(0xffF6F6F6), height: 30.0),
                          // ignore: deprecated_member_use
                          RaisedButton(
                            child: Text(
                              "Carregar imagem",
                              style: TextStyle(color: Colors.black, fontSize: 20.0),
                            ),
                            onPressed: getImage,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          ),
                          Divider(color: Color(0xffF6F6F6), height: 30.0),
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
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await updateImagemCardapio();
                                  }
                              ) : Center(child:CircularProgressIndicator()),
                            ),
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

Future<void> deleteCardapio(String title, String text, String button, BuildContext context) async {
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
          if(button == "")
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
                          builder: (context) => GerenciarCardapio(),
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
  final QuerySnapshot result = await _firestore.collection("cardapio").get();

  if(fotoCardapio != "https://firebasestorage.googleapis.com/v0/b/pato-burguer-2bd8d.appspot.com/o/generico.png?alt=media&token=2dea194c-2f6e-461a-bcef-cdccad435414") {
    Reference ref = FirebaseStorage.instance.refFromURL(fotoCardapio);
    ref.delete();
  }
  result.docs.forEach((d) {
    if(d.get("nome") == nomeCardapio) {
      _firestore.collection("cardapio").doc(d.id).delete();
    }
  });
}

