import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'func.dart';
import 'login.dart';

Future<void> showMyDialog(String title, String text, String button, BuildContext context) async {
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
                    _deleteAccount(atualEmail, context);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => GerenciarFunc(),
                        ),
                            (Route<dynamic> route) => false);
                  },
                ),
              ],
            )
          else
            TextButton(
              child: Text(button),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
        ],
      );
    },
  );
}

Future<void> showMyDialogTwo(String title, String text, String button, BuildContext context) async {
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
                    _deleteAccount(user, context);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                            (Route<dynamic> route) => false);
                  },
                ),
              ],
            )
          else
            TextButton(
              child: Text(button),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                        (Route<dynamic> route) => false);
              },
            ),
        ],
      );
    },
  );
}

void _deleteAccount(String email, BuildContext context) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final QuerySnapshot result = await _firestore.collection("usuarios").get();

  if(result.docs.length == 1) {
    showMyDialog("", "Impossível excluir o único administrador", "OK", context);
  } else {
    result.docs.forEach((d) {
      if(d.get("email") == email) {
        _firestore.collection("usuarios").doc(d.id).delete();
      }
    });
  }
}
