import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/io_client.dart';

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

  Future<String> getUrls() async{

    //String url = "http://192.168.0.66:80/cgi-bin/jvsweb.cgi";

    //String url = "http://192.168.0.66:80/cgi-bin/jvsweb.cgi?username=admin&cmd=yst&action=get_video";

    final Map<String, String> _queryParameters = <String, String>{
      "cmd":"yst",
      "action": "get_video",
    };

    final msg = jsonEncode({"username": "admin", "cmd": "yst", "action": "get_video"});

    var url = Uri.http("$ip:80", "/cgi-bin/jvsweb.cgi", _queryParameters);

    Map<String, String> headers = {
      'Content-Type':'application/json',
    };

    print("CONNECTING TO $url .......................");
    print("HEADERS: $headers");

    http.Client client = new http.Client();
    var response = await client.read(url,);

    /*
    if (response.statusCode == 200) {
      print("CONNECTION ESTABLISHED...........................");
    }else{
      print("CONNECTION FAILED.......................");
      print("Couldn't get devices");
    }
    */
    print("DONE.....................");

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: MediaQuery.of(context).orientation == Orientation.landscape ? Center(
            child: cameraView(),
          ) : cameraView()
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
                Text("Channels: ", style: TextStyle(color: Colors.white, fontSize: 20),),
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
          ),
        ],
      ),
    );
  }

  Widget httpTest(){
    return FutureBuilder(
      future: getUrls(),
      builder: (context, AsyncSnapshot<String> snapshot){
        if(snapshot.hasData){
          return Center(
            child: Column(
              children: [
                Text("Status: ${snapshot.data}", style: TextStyle(color: Colors.white)),
                //Text("Body: ${snapshot.data.body}", style: TextStyle(color: Colors.white)),
              ],
            ),
          );
        }
        else if(snapshot.hasError){
          return Center(child: Column(
            children: [
              Text("An error has occurred while trying to connect.", style: TextStyle(color: Colors.white),),
              Text(snapshot.error.toString(), style: TextStyle(color: Colors.white),),
            ],
          ),);
        }
        else{
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

}