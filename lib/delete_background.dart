import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteBackground extends StatelessWidget {
  DeleteBackground({
    Key key,
    @required this.mainAxisAlignment,
  }) : super(key: key);

  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      color: Colors.red,
    );
  }
}
