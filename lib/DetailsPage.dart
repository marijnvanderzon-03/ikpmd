import 'package:eindopdracht/Record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({Key? key, required this.detailRecord}) : super(key: key);
  final Data? detailRecord;

  BuildContext? get context => null;

  Size size = WidgetsBinding.instance!.window.physicalSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speedrun information"),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return buildPortrait();
        } else {
          return buildLandscape();
        }
      }),
    );
  }

  Widget buildLandscape() => Row(
        children: [
          Image.network(
              "http://10.0.2.2:8080/downloadFile/${detailRecord!.image}"),
          Container(
            margin: const EdgeInsets.all(15.0),
            color: Colors.red.shade900,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Text("time: " + detailRecord!.time.toString()),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Text("Game: " + detailRecord!.game.toString()),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Text("Description: " +
                          detailRecord!.description.toString()),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2.0),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      );

  Widget buildPortrait() => ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(15.0),
            color: Colors.red.shade900,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Text("time: " + detailRecord!.time.toString()),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Text("Game: " + detailRecord!.game.toString()),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Text("Description: " +
                          detailRecord!.description.toString()),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Image.network(
              "http://10.0.2.2:8080/downloadFile/${detailRecord!.image}"),
        ],
      );
}
