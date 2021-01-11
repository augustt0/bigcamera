import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;


import 'ViewCard.dart';

class CameraPage extends StatefulWidget {
  String ip;
  String port;

  String user;
  String passwd;

  CameraPage({@required this.ip, @required this.port, @required this.user, @required this.passwd});

  _CameraPageState createState() => _CameraPageState(ip: ip, port: port, user: user, passwd: passwd);
}

class _CameraPageState extends State {
  String ip;
  String port;

  String user;
  String passwd;

  String finalUrl = "";
  
  int channels = 4;

  List<String> selectedChannels = [];

  _CameraPageState({this.ip, this.port, this.user, this.passwd});
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int crossCount(){
    int x;

    Orientation orientation = MediaQuery.of(context).orientation;

    switch(channels){
      case 4:
        x = orientation == Orientation.portrait ? 2 : 4;
        break;
      case 8:
        x = orientation == Orientation.portrait ? 3 : 4;
        break;
      case 16:
        x = orientation == Orientation.portrait ? 4 : 6;
        break;
      default:
        x = 2;
    }
    return x;
  }

  double heightChannelRelated(){
    double x;

    Orientation orientation = MediaQuery.of(context).orientation;

    switch(channels){
      case 4:
        x = orientation == Orientation.portrait ? 540.00 : 300.00;
        break;
      case 8:
        x = orientation == Orientation.portrait ? 540.00 : 580.00;
        break;
      case 16:
        x = orientation == Orientation.portrait ? 540.00 : 600.00;
        break;
      default:
        x = 540.00;
    }
    return x;
  }

  Future<bool> verifyUrl() async{
    bool x = false;
    String index = "1";
    List<String> urls = [
      "rtsp://$ip:$port/live$index.264?user=$user&passwd=$passwd",
      "rtsp://$user:$passwd@$ip:$port",
      "rtsp://$ip:$port/h264.sdp$index?profile=profile_1",
      "rtsp://$ip:$port/channel$index",
      "rtsp://$ip:$port/streaming/channels/$index",
      "rtsp://$ip:$port/ch$index",
      "rtsp://$ip:$port/CH00$index.sdp",
      "rtsp://$ip:$port/ch$index/main/av_stream",
      "rtsp://$ip:$port/$index/profile2/media.smp",
      "rtsp://$ip:$port/media/video$index",
    ];

    for(int i = 0; i < urls.length; i++){
      if(!x){
        var response = await http.get(urls[i]);
        if(response.statusCode == 200){
          finalUrl = urls[i];
          x = true;
        }
      }
    }
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: FutureBuilder(
            future: verifyUrl(),
            builder: (context, AsyncSnapshot<bool> snapshot){
              if(snapshot.hasData){
                if(snapshot.data){
                  return MediaQuery.of(context).orientation == Orientation.landscape ? Center(
                    child: cameraView(),
                  ) : cameraView();
                }else{
                  return Column(
                    children: [
                      Text("No se han podido encontrar las cámaras IP. Verifique la información provista.\nPuede usar esta lista para corroborar:"),
                      Text("● Verifique la dirección IP."),
                      Text("● Verifique el puerto."),
                      Text("● Verifique el usuario y contraseña."),
                      Text("● Si esta accediendo desde una red externa verifique si el puerto requerido está abierto en su enrutador."),
                    ],
                  );
                }
              }
              return Center(child: CircularProgressIndicator(),);
            },
          )
      )
    );
  }

  Widget cameraView(){
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: heightChannelRelated(),
            child: GridView.builder(
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossCount()),
              itemCount: channels,
              itemBuilder: (context, i){
                return ViewCard(ip: ip, port: port, index: i, user: user, passwd: passwd);
              },
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Canales: ", style: TextStyle(color: Colors.white, fontSize: 20),),
                DropdownButton(
                  value: channels.toString(),
                  items: <String>['4', '8', '16'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value, style: TextStyle(color: Colors.white),),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      channels = int.parse(val);
                    });
                  },
                  dropdownColor: Colors.blue,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}