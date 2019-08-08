import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news/src/resources/news_api_provider.dart';

void main() {
  // Fetch Top Ids Test
  test('FetchTopIds returns a list of ids', () async {
    // setup of test case
    final newsApi = NewsApiProvider();

    newsApi.client = MockClient((Request request) async {
      final jsonArray = [1, 2, 3, 4, 5];

      return Response(json.encode(jsonArray), 200);
    });

    final ids = await newsApi.fetchTopIds();

    // expectation
    expect(ids, [1, 2, 3, 4, 5]);
  });

  // Fetch Item Test
  test('FetchItem returns an item model', () async {
    // setup of test case
    final newsApi = NewsApiProvider();

    newsApi.client = MockClient((Request requeset) async {
      final jsonMap = {'id': 123, 'name': 'apple'};
      return Response(json.encode(jsonMap), 200);
    });

    final itemModel = await newsApi.fetchItem(999);

    // expectation
    expect(itemModel.id, 123);
  });
}
