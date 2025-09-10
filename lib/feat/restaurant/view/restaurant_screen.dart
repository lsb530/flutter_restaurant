import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/const/data.dart';
import 'package:flutter_restaurant/common/util/json_viewer.dart';
import 'package:flutter_restaurant/feat/restaurant/component/restaurant_card.dart';
import 'package:flutter_restaurant/feat/restaurant/model/restaurant_model.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List>? paginationRestaurant() async {
    final dio = Dio();

    final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$hostPort/restaurant',
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List>(
            future: paginationRestaurant(),
            builder: (context, snapshot) {
              // print(snapshot.error);
              JsonViewer.printPretty(snapshot.data);

              if (!snapshot.hasData) {
                return Container();
              }

              return ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  // p: parsed
                  final pItem = RestaurantModel(
                    id: item['id'],
                    name: item['name'],
                    thumbUrl: 'http://$hostPort${item['thumbUrl']}',
                    tags: List<String>.from(item['tags']),
                    priceRange: RestaurantPriceRange.values.firstWhere(
                      (e) => e.name == item['priceRange'],
                    ),
                    ratings: item['ratings'],
                    ratingsCount: item['ratingsCount'],
                    deliveryTime: item['deliveryTime'],
                    deliveryFee: item['deliveryFee'],
                  );

                  return RestaurantCard(
                    image: Image.network(
                      pItem.thumbUrl,
                      fit: BoxFit.cover,
                    ),
                    name: item['name'],
                    tags: List<String>.from(item['tags']),
                    ratingsCount: item['ratingsCount'],
                    deliveryTime: item['deliveryTime'],
                    deliveryFee: item['deliveryFee'],
                    ratings: item['ratings'],
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 16.0);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
