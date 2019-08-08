import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/widgets/loading_list_tile.dart';

class Comment extends StatelessWidget {
  // Instance Variables
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  Comment({this.itemId, this.itemMap, this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (BuildContext context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingListTile();
        }

        final item = snapshot.data;

        final children = <Widget>[
          ListTile(
            title: buildText(item),
            subtitle: item.by == '' ? Text('Deleted') : Text(item.by),
            contentPadding: EdgeInsets.only(
              left: (depth + 1) * 16.0,
              right: 16.0,
            ),
          ),
          Divider(),
        ];

        snapshot.data.kids.forEach(
          (kidId) {
            children.add(
              Comment(
                itemId: kidId,
                itemMap: itemMap,
                depth: depth + 1,
              ),
            );
          },
        );

        return Column(
          children: children,
        );
      },
    );
  }

  Widget buildText(ItemModel item) {
    final text = item.text
        .replaceAll('&#x27;', "'")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '')
        .replaceAll('&#x2F;', '/')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"');
    return Text(text);
  }
}
