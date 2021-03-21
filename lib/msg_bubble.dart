import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final map;
  MessageBubble(this.map);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (map["msg"]!=null)?
        Row(
          mainAxisAlignment:
              map["isSharee"] ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: map["isSharee"] == true
                    ? Colors.greenAccent//grey[300]
                    : Colors.black54,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(20),
                  bottomLeft: map["isSharee"]? Radius.circular(12) : Radius.circular(0),
                  bottomRight: !map["isSharee"] ? Radius.circular(12) : Radius.circular(0),
                ),
              ),
              width: 160,
              // height: 100,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Column(
                crossAxisAlignment:
                  CrossAxisAlignment.start,
                children: [
                  Text(
                   map["isSharee"]?map["sentBy"]+" (H)": map["sentBy"],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: map["isSharee"] == true
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline1.color,
                    ),
                  ),
                  Divider(color: map["isSharee"]?Colors.grey[700]:Colors.white,),
                  Text(
                    map["msg"],
                    style: TextStyle(
                      fontSize: 18,
                      color: map["isSharee"] == true
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline1.color,
                    ),
                    textAlign:! map["isSharee"] ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ):Container(),
      ],
      clipBehavior:Clip.hardEdge,
    );
  }
}
