import 'package:bigcamera/CameraPage.dart';
import 'package:bigcamera/Dialog.dart';
import 'package:bigcamera/SaveDialog.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:regexed_validator/regexed_validator.dart';

class MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State {
  final _formKey = GlobalKey<FormState>();

  String ip;
  String port;

  bool usesUser = false;

  String user = "";
  String pass = "";

  List<String> cameraList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<String>> cargarCamaras() {

  }

  void connect() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraPage(
                  ip: ip,
                  port: port,
                  user: "admin",
                  passwd: "",
                )));
  }

  void save() {
    showDialog(context: context, builder: (BuildContext context) => SaveDialog(ip: ip, port: port, user: usesUser ? user : "", pass: usesUser ? pass : "",));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Big Camera"),),
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text("Nueva conexión",
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Card(
              color: Colors.white10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        cursorColor: Colors.yellow,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
                        style: TextStyle(color: Colors.white70),
                        decoration: new InputDecoration(
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "IP",
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                        onSaved: (String val) {
                          ip = val;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Este campo es obligatorio';
                          } else if (!validator.ip(value)) {
                            return "IP incorrecta";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        cursorColor: Colors.yellow,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: TextStyle(color: Colors.white70),
                        decoration: new InputDecoration(
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Puerto",
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                        onSaved: (String val) {
                          port = val;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Este campo es obligatorio';
                          } else if (int.parse(value) < 0 ||
                              int.parse(value) > 65353 ||
                              value.contains(".") ||
                              value.contains(",")) {
                            return "Puerto incorrecto";
                          }
                          return null;
                        },
                      ),
                      CheckboxListTile(
                        checkColor: Colors.white,
                          activeColor: Colors.blue,
                          title: Text("Credenciales", style: TextStyle(color: Colors.white54),),
                          value: usesUser,
                          onChanged: (value) {
                            setState(() {
                              usesUser = value;
                            });
                          }
                          ),
                      usesUser ? ExpandablePanel(
                        header: Padding(
                          padding: EdgeInsets.only(top: 15, left: 15),
                          child: Text("Usuario", style: TextStyle(color: Colors.white54),),
                        ),
                        collapsed: Container(),
                        expanded: Column(
                          children: [
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              cursorColor: Colors.yellow,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              style: TextStyle(color: Colors.white70),
                              decoration: new InputDecoration(
                                focusedBorder: new OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Usuario",
                                hintStyle: TextStyle(color: Colors.white54),
                              ),
                              onSaved: (String val) {
                                usesUser ? user = val : user = "";
                              },
                              validator: (value) {
                                if(usesUser && value.isEmpty){
                                  return "Este campo es obligatorio si usa credenciales";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              cursorColor: Colors.yellow,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              style: TextStyle(color: Colors.white70),
                              decoration: new InputDecoration(
                                focusedBorder: new OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Contraseña",
                                hintStyle: TextStyle(color: Colors.white54),
                              ),
                              onSaved: (String val) {
                                usesUser ? pass = val : pass = "";
                              },
                              validator: (value) {
                                return null;
                              },
                            ),
                          ],
                        ),
                      ) : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: RaisedButton(
                  child: Text(
                    "Guardar",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  onPressed: () {
                    final FormState form = _formKey.currentState;
                    if (_formKey.currentState.validate()) {
                      form.save();
                      save();
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: RaisedButton(
                  child: Text(
                    "Conectar",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  onPressed: () {
                    final FormState form = _formKey.currentState;
                    if (_formKey.currentState.validate()) {
                      form.save();
                      connect();
                    }
                  },
                ),
              ),
            ],
          ),
          GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: ), itemBuilder: null)
        ],
      ),
    );
  }
}
