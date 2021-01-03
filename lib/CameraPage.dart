import 'dart:async';
import 'dart:ui';

import 'package:bigcamera/FullView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

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
                VlcPlayerController _videoViewController;
                _videoViewController = new VlcPlayerController(onInit: () {
                  _videoViewController.play();
                });
                return InkWell(
                  child: Card(
                    color: Colors.white10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Container(
                            child: VlcPlayer(
                              aspectRatio: 1 / 1,
                              url: "rtsp://$ip:$port/live${i + 1}.264?user=$user&passwd=$passwd",
                              controller: _videoViewController,
                              placeholder: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) => FullView(
                          connection: "rtsp://$ip:$port/live${i + 1}.264?user=$user&passwd=$passwd",
                        ));
                  },
                );
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