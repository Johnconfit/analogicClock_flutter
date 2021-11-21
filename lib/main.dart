import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Analogy clock with flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        color: Color.fromRGBO(33, 18, 18, 1),
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[PaintAnalogicClock()],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PaintAnalogicClock extends StatefulWidget {
  const PaintAnalogicClock({Key? key}) : super(key: key);

  @override
  _PaintAnalogicClockState createState() => _PaintAnalogicClockState();
}

class _PaintAnalogicClockState extends State<PaintAnalogicClock> {
  DateTime? dateheure;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        dateheure = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // pour bien formater la date on peut utiliser le package intl
        Container(
            padding: EdgeInsets.all(10.0),
            child: Text(dateheure!.hour.toString() +
                " : " +
                dateheure!.minute.toString() +
                " : " +
                dateheure!.second.toString())),

        // l'horloge
        Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                color: Color.fromRGBO(33, 33, 18, 1),
                borderRadius: BorderRadius.circular(25.0)),
            child: CustomPaint(
              painter: PaintClock(dateheure: dateheure),
            )),
      ],
    );
  }
}

//----------- paint clock class
class PaintClock extends CustomPainter {
  final DateTime? dateheure;

  PaintClock({required this.dateheure});

  @override
  void paint(Canvas canvas, Size size) {
    // here I paint my clock

    //1er cercle
    var paint1erCircle = Paint()
      ..color = Colors.white12
      ..strokeWidth = 10
      ..style = PaintingStyle.fill;

    var centreX = size.width / 2;
    var centreY = size.height / 2;
    // le rayon, pour on prend le plus petit entre la longueur et la largeur du canvas / 2 , cequi donne le rayon car width = diametre, pour notre cas je divise par 3
    var radius1cercle = min(size.width, size.height) / 2.5;
    canvas.drawCircle(Offset(centreX, centreY), radius1cercle, paint1erCircle);

    /* Pour avoir les coordonnes d'un point sur un cercle dans un repere, on applique la formule
         // t est l'angle en radian
        xp = x0 + r*cos(t) // xp = x du point
        yp = y0 + r*sin(t) // yp = y du point

        un radian = degre * pi / 180, donc pour tester avec 90 degree, on fait 90 *pi /180
    
    // pour avoir 270 , on a remarquee que -90 degree correspond a 00 en minute ou secondes et 90 a 30 secondes ou 30 minutes
    // donc -90 rentre les aiguilles a 00, c'est le repere de notre horloge, comme exactement votre montre, et comme un angle c'est 360 degree, en ajoutant 360 degree a - 90 on ne change rien (-90 +360) = 270 d'ou 270 degree = -90 , il est plus propre d'utiliser 270, ou -90 ca ne change rien
    // pour les secondes ou les minutes, on a 60 (secondes ou minutes) correspnd a 360 degree, un tour complet, donc x degree correspnd a =  (nbre de minutes ou secondes ) * 360 / 60 , simple regle de trois,  d' ou x degree = nbre de minute ou secondes * 6
    // Et ca marche sans soucis

    // Pour les heures , un tour complet c'est 12 qui correspond a 360, donc x degree = nbre H * 360 / 12 dou x degree = nbre H * 30
    */

    //le trait des heures
    var paintTraitHeure = Paint()
      ..color = Color.fromRGBO(51, 0, 38, 1)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10
      ..style = PaintingStyle.fill;

    // car ici get hour est sur 24 H [0..23], le modulo 12 le recadre
    var _hour = dateheure!.hour % 12;
    var rayonTraitHeureCercle = radius1cercle / 2.5;

    // (3* _hour) permer dobtenir la valeur en degree, on peut remplacer par 30 ou 45 degree, lors des tests ayant l'ajout des maths
    var finTraitHeureX = centreX +
        (rayonTraitHeureCercle * cos((270 + (30 * _hour)) * pi / 180));
    var finTraitHeureY = centreY +
        (rayonTraitHeureCercle * sin((270 + (30 * _hour)) * pi / 180));

    canvas.drawLine(Offset(centreX, centreY),
        Offset(finTraitHeureX, finTraitHeureY), paintTraitHeure);

    // le trait des minutes
    var paintTraitMinute = Paint()
      ..color = Color.fromRGBO(102, 0, 77, 1)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8
      ..style = PaintingStyle.fill;

    var _minute = dateheure!.minute;
    var rayonTraitMinuteCercle = radius1cercle / 1.7;
    var finTraitMinuteX = centreX +
        (rayonTraitMinuteCercle * cos((270 + (6 * _minute)) * pi / 180));
    var finTraitMinuteY = centreY +
        (rayonTraitMinuteCercle * sin((270 + (6 * _minute)) * pi / 180));

    canvas.drawLine(Offset(centreX, centreY),
        Offset(finTraitMinuteX, finTraitMinuteY), paintTraitMinute);

    // le trait des secondes
    var paintTraitSeconde = Paint()
      ..color = Color.fromRGBO(255, 255, 128, 1)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    var _seconde = dateheure!.second;
    var rayonTraitSecondeCercle = radius1cercle / 1.3;
    var finTraitSecondeX = centreX +
        (rayonTraitSecondeCercle * cos((270 + (6 * _seconde)) * pi / 180));
    var finTraitSecondeY = centreY +
        (rayonTraitSecondeCercle * sin((270 + (6 * _seconde)) * pi / 180));

    canvas.drawLine(Offset(centreX, centreY),
        Offset(finTraitSecondeX, finTraitSecondeY), paintTraitSeconde);

    //le petit cercle du milieu
    var paintpetitCircle = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 10
      ..style = PaintingStyle.fill;

    // le rayon, pour on prend le plus petit entre la longueur et la largeur du canvas / 2 , cequi donne le rayon car width = diametre, pour notre cas je divise par 3
    var radiuspetitcercle = min(size.width, size.height) / 30;
    canvas.drawCircle(
        Offset(centreX, centreY), radiuspetitcercle, paintpetitCircle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
