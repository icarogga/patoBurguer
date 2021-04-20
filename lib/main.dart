import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cardapio/assets/My_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller();

  @override
  Widget build(BuildContext context) {
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.30 - 50;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: Row(
            children: <Widget>[
              Container(
                width: 200,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.orange.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Promoção\nNic Cage",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "O Lanche\nvem estranho",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 200,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Promoção\nMegazord",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "6 Lanches\nem 1",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 200,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Promoção\nMinha Rola\nNa sua Cara",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Rolinho Primavera",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {

    });
  }

  final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;

//Instagram
  void launchInsta() async {
    const urlInsta = 'https://www.instagram.com/japa_manda_nuds/';
    if (await canLaunch(urlInsta)) {
      await launch(urlInsta);
    } else {
      throw 'Could not launch $urlInsta';
    }
  }

//Feedback
  void launchForms() async {
    const urlForms =
        'https://docs.google.com/forms/d/e/1FAIpQLSfDsCCA8KyAA068h0vF-9vQeyhyRkHi9k7v9DYyqAMw_nBFjA/viewform?usp=sf_link';
    if (await canLaunch(urlForms)) {
      await launch(urlForms);
    } else {
      throw 'Could not launch $urlForms';
    }
  }

//Rick Rolled
  void launchWhats() async {
    const urlWhats = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
    if (await canLaunch(urlWhats)) {
      await launch(urlWhats);
    } else {
      throw 'Could not launch $urlWhats';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.9;
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu_sharp, color: Colors.purple),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
              Image(
                image: AssetImage('images/Logo_letras.png'),
                fit: BoxFit.cover,
                height: 56,
              ),
            ]),
            toolbarHeight: 56.0,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ))),
        drawer: SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: Drawer(
              child: ListView(children: <Widget>[
                DrawerHeader(
                    child: Image.asset("images/pato.png", fit: BoxFit.contain)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Icon(
                        My_icons.contato,
                        color: Colors.deepPurple,
                        size: 40.0,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: Text("Contatos:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                  ],
                ),
                // Ícones de contato
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: <Widget>[
                        ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.blue[600],
                                      Colors.deepPurpleAccent,
                                      Colors.redAccent,
                                      Colors.yellow[400]
                                    ]).createShader(bounds),
                            child: IconButton(
                                icon:
                                    Icon(My_icons.instagram_square, size: 40.0),
                                onPressed: (launchInsta))),
                        Text("@patoburguer",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 8.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Colors.amber))
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              My_icons.whatsapp_square,
                              color: Colors.green,
                              size: 40.0,
                            ),
                            onPressed: (launchWhats)),
                        Text("",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 8.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Colors.amber))
                      ],
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 28.0, bottom: 16.0, left: 16.0, right: 16.0),
                    child: Text("Atendimento exclusivamente via What's App",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: Colors.black))),

                // Dúvidas
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 56.0, bottom: 16.0, right: 16.0),
                      child: IconButton(
                          icon: Icon(
                            Icons.question_answer,
                            color: Colors.deepPurple,
                            size: 32.0,
                          ),
                          onPressed: (launchWhats)),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 56.0, bottom: 16.0),
                        child: Text("Dúvidas",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                  ],
                ),
                // Feedbacks
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: IconButton(
                        icon: Icon(
                          My_icons.feedbacks,
                          color: Colors.deepPurple,
                          size: 40.0,
                        ),
                        onPressed: (launchForms),
                      ),
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.only(bottom: 24.0, left: 16.0),
                        child: Text("Feedbacks",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                  ],
                )
              ]),
            )),
        body: SlidingUpPanel(
          color: Color(0xffE8E8E8),
          boxShadow: [
            BoxShadow(color: Colors.grey, spreadRadius: 1.0, blurRadius: 5.0)
          ],
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
          panelBuilder: (ScrollController sc) => _scrollingList(sc),
          minHeight: size.height / 2,
          maxHeight: size.height,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Container(
              height: size.height /
                  1000, //this fuckery doesn't do anything you can put whatever you want
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 200,
                    margin: EdgeInsets.only(right: 20),
                    height: categoryHeight / 4,
                    decoration: BoxDecoration(
                        color: Colors.orange.shade400,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Promoção\nNic Cage",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "O Lanche\nvem estranho",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    margin: EdgeInsets.only(right: 20),
                    height: categoryHeight / 4,
                    decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Promoção\nMegazord",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "6 Lanches\nem 1",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    margin: EdgeInsets.only(right: 20),
                    height: categoryHeight / 4,
                    decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Promoção\nMinha Rola\nNa sua Cara",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Rolinho Primavera",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        //tabs[_currentIndex],
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: BottomNavigationBar(
                //currentIndex: _currentIndex,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                fixedColor: Colors.purple,
                //elevation: 100.0,
                selectedFontSize: 16,
                unselectedFontSize: 12,
                //selectedIconTheme: IconThemeData(color: Colors.black),
                unselectedItemColor: Colors.purple.withOpacity(.60),
                //selectedLabelStyle: TextStyle(color: Colors.red),
                unselectedLabelStyle: TextStyle(color: Colors.purple),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(My_icons.casa_footer),
                    label: ("Início"),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(My_icons.lanche_footer),
                    label: ('Lanches'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(My_icons
                        .bebida_footer), //Image.asset('images/bebida_footer.png'),
                    label: ('Bebidas'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(My_icons
                        .combo_footer), //Image.asset('images/combo_footer.png'),
                    label: ('Combos'),
                  ),
                ],
                /*onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    }*/
              ),
            )));
  }
}

Widget _scrollingList(ScrollController sc) {

  CollectionReference cardapio = FirebaseFirestore.instance.collection('cardapio');

  return ListView.builder(
    physics: BouncingScrollPhysics(),
    controller: sc,
    itemCount: 1,
    itemBuilder: (BuildContext context, int i) {
      return Column(children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xffE8E8E8),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 25.0, 20.0, 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Cardápio",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
            stream: cardapio.snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              return ListView(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(
                      child: Container(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          width: MediaQuery.of(context).size.width - 20.0,
                          height: MediaQuery.of(context).size.height + 200,
                          child: GridView.count(
                            crossAxisCount: 2,
                            primary: false,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 15.0,
                            childAspectRatio: 0.9,
                            children: [
                              if (!snapshot.hasData)
                                Center(child: CircularProgressIndicator())
                              else
                                for (var i in snapshot.data.docs)
                                  if (i.get("tipo") == "Lanche" && i.get("foto") != null)
                                    _buildCard(i.get("nome"), i.get("preco"), i.get("descricao"),i.get("foto"),  context),

                              if (!snapshot.hasData)
                                Center(child: CircularProgressIndicator())
                              else
                                for (var i in snapshot.data.docs)
                                  if (i.get("tipo") == "Refrigerante" && i.get("foto") != null)
                                    _buildCard(i.get("nome"), i.get("preco"), i.get("descricao"), i.get("foto"), context),

                              if (!snapshot.hasData)
                                Center(child: CircularProgressIndicator())
                              else
                                for (var i in snapshot.data.docs)
                                  if (i.get("tipo") == "Combo" && i.get("foto") != null)
                                    _buildCard(i.get("nome"), i.get("preco"), i.get("descricao"), i.get("foto"), context)
                            ],
                          )))
                ],
              );
            })
      ]);
    },
  );
}

Widget _buildCard(String nome, dynamic preco, String descricao, String foto, BuildContext context) {
  return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
      child: InkWell(
          onTap: () {},
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, spreadRadius: 1.0, blurRadius: 5.0)
                ],
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    width: 60.0,
                    alignment: Alignment.topRight,
                  ),
                  Image(
                    width: 95.0,
                    height: 85.0,
                    image: NetworkImage(foto),
                    alignment: Alignment.center,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Text(
                      nome,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )),
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
                        "R\$$preco",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
                ],
              ))));
}
