import 'dart:math';

import 'package:bigcamera/Words.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SaveDialog extends StatefulWidget{
  final String ip, port, user, pass;

  SaveDialog({
    @required this.ip,
    @required this.port,
    @required this.user,
    @required this.pass,
  });
  _CustomSaveDialog createState() => _CustomSaveDialog(ip: ip, port: port, user: user, pass: pass);
}

class _CustomSaveDialog extends State with SingleTickerProviderStateMixin{
  final String ip, port, user, pass;

  String name = "";

  AnimationController controller;
  Animation<double> scaleAnimation;

  _CustomSaveDialog({
    @required this.ip,
    @required this.port,
    @required this.user,
    @required this.pass,
  });

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.linearToEaseOut);

    controller.addListener(() {
      setState(() {});
    });

    for(int i = 0; i < 3; i++){
      name = name + randomWord();
    }

    controller.forward();
  }

  String randomWord() {
    String generatedWord = words[Random(DateTime.now().microsecond).nextInt(words.length)];
    generatedWord = generatedWord.replaceFirst(generatedWord[0], generatedWord[0].toUpperCase());
    return generatedWord;
  }

  void save() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String dataChunk = "";

    dataChunk = dataChunk + name + ";" + ip + ";" + port + ";" + user + ";" + pass + ";";
    List<String> savedData = prefs.getStringList("cameras") ?? [];

    savedData.add(dataChunk);

    prefs.setStringList("cameras", savedData);

    Toast.show("Se ha guardado $name con IP $ip", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: dialogContent(context),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                "Atención",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "¿Desea guardar la cámara con IP $ip?\nSe guardará con el nombre de $name",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 24.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    onPressed: () {
                      save();
                      Navigator.of(context).pop(); // To close the dialog
                    },
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("Aceptar", style: TextStyle(color: Colors.white), textScaleFactor: 1.5,),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // To close the dialog
                    },
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("Cancelar", style: TextStyle(color: Colors.white), textScaleFactor: 1.5,),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          top: Consts.padding + 35,
          child: Icon(Icons.warning_amber_outlined, size: 60, color: Colors.blue,),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 50.0;
}

