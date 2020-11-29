import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class TopHeader extends StatelessWidget {
  const TopHeader({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height * 0.35,
      child: Column(
        children: [
          SizedBox(height: 50.0),
          Icon(
            FontAwesomeIcons.heartBroken,
            size: 100.0,
          ),
          Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: 'Drivers',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.red,
                  ),
                ),
                TextSpan(
                  text: 'Ticket',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Text('Find details of tickets issued and payments'),
        ],
      ),
    );
  }
}
