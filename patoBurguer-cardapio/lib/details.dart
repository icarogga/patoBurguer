import "package:flutter/material.dart";
import 'assets/My_icons.dart';
import 'main.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 17.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Image(
              height: MediaQuery.of(context).size.height / 2 - 50,
              image: NetworkImage(fotoAtual),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text("(Foto meramente ilustrativa)",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 22,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, spreadRadius: 1.0, blurRadius: 1.0)
              ],
              color: Color(0xffE8E8E8),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(nomeAtual,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 60,
                  child: Text(
                    descricaoAtual,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 25.0),
                SizedBox(
                    width: MediaQuery.of(context).size.width - 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "R\$" + precoAtual,
                          style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              decorationThickness: 0.5,
                              decoration: TextDecoration.underline),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 70),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Peça já:",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: IconButton(
                                    icon: Icon(
                                      My_icons.whatsapp_square,
                                      color: Colors.green,
                                      size: 50.0,
                                    ),
                                    onPressed: (launchWhats)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
