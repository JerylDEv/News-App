import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_list_tile.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';
import 'dart:async';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (BuildContext context,
          AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingListTile();
        }

        return FutureBuilder(
          future: snapshot.data[itemId],
          builder:
              (BuildContext context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingListTile();
            }

            return buildTile(context, itemSnapshot.data);
          },
        );
      },
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/${item.id}');
          },
          title: Text(item.title),
          subtitle: Text('${item.score} points'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.comment),
              Text('${item.descendants}'),
            ],
          ),
        ),
        Divider(
          height: 8.0,
        ),
      ],
    );
  }
}
