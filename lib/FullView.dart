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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: AspectRatio(
        aspectRatio: 1,
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
                  height: 500,
                  child: InteractiveViewer(
                    panEnabled: false, // Set it to false to prevent panning.
                    boundaryMargin: EdgeInsets.all(0),
                    minScale: 1,
                    maxScale: 4,
                    child: VlcPlayer(
                      isLocalMedia: false,
                      options: [
                        '--quiet',
                        //'-vvv',
                        '--no-skip-frames',
                        '--rtsp-tcp',
                        '--network-caching=0',
                      ],
                      hwAcc: HwAcc.AUTO,
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
    );
  }

}