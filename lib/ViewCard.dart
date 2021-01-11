import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'FullView.dart';

import 'package:toast/toast.dart';

class ViewCard extends StatelessWidget {

  String ip, port, user, passwd;
  int index;

  ViewCard({@required this.ip, @required this.port, @required this.index, @required this.user, @required this.passwd});

  VlcPlayerController _videoViewController;

  void takeScreenshot(BuildContext context) async{
    var status = await Permission.storage.status;
    if (status.isUndetermined || status.isDenied || status.isPermanentlyDenied) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Se necesitan permisos de almacenamiento para guardar la captura"),
        elevation: 2,
        action: SnackBarAction(
          label: "Permitir acceso",
          onPressed: openAppSettings,
        ),
      ));
    }else{
      Uint8List bytes = await _videoViewController.takeSnapshot();
      String dir = (await getApplicationDocumentsDirectory()).path;
      String fullPath = '$dir/CameraSnapshot_CH${index}_${DateTime.now().millisecond}.png';
      print("local file full path ${fullPath}");
      File file = File(fullPath);
      await file.writeAsBytes(bytes);
      print(file.path);

      final result = await ImageGallerySaver.saveImage(bytes);
      print(result);
      Toast.show("Se ha guardado una captura del canal $index en ${file.path}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: VlcPlayer(
                        aspectRatio: 1 / 1,
                        url: "rtsp://$ip:$port/live${index + 1}.264?user=$user&passwd=$passwd",
                        controller: _videoViewController,
                        placeholder: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    Positioned(
                      left: 165,
                      top: 165,
                      right: 0,
                      bottom: 0,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt_outlined, color: Colors.white70, size: 30,),
                        onPressed: () => takeScreenshot(context),
                      ),
                    ),
                  ],
                )
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
              connection: "rtsp://$ip:$port/live${index + 1}.264?user=$user&passwd=$passwd",
            ));
      },
    );
  }

}