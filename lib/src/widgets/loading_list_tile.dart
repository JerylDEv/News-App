import 'package:flutter/material.dart';

class LoadingListTile extends StatelessWidget {
  const LoadingListTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ListTile(
          title: buildContainer(),
          subtitle: buildContainer(),
        ),
        Divider(
          height: 8.0,
        )
      ],
    );
  }

  Widget buildContainer() {
    return Container(
      color: Colors.grey[200],
      height: 24.0,
      width: 150.0,
      margin: EdgeInsets.only(
        top: 5.0,
        bottom: 5.0,
      ),
    );
  }
}
