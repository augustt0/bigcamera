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

  VlcPlayerController _videoViewController;

  _CameraPageState({this.ip, this.port, this.user, this.passwd});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoViewController = new VlcPlayerController(onInit: () {
      _videoViewController.play();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait ? 540 : 300,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? channels : 2),
        itemCount: 4,
        itemBuilder: (context, i){
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FullView(connection: "rtsp://$ip:$port/live${i + 1}.264?user=$user&passwd=$passwd",)),
              );
            },
          );
        },
      ),
    );
  }

}