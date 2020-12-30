import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class FullView extends StatefulWidget {
  String connection;

  FullView({@required this.connection});

  _FullViewState createState() => _FullViewState(connection: connection);
}

class _FullViewState extends State<FullView> {
  String connection;

  VlcPlayerController _videoViewController;

  _FullViewState({@required this.connection});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoViewController = new VlcPlayerController(onInit: () {
      _videoViewController.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            height: 500,
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
                        options: [
                          ""
                        ],
                        aspectRatio: 1 / 1,
                        url: connection,
                        controller: _videoViewController,
                        placeholder: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}