import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/const/data.dart';
import 'package:flutter_restaurant/common/util/json_viewer.dart';
import 'package:flutter_restaurant/feat/restaurant/component/restaurant_card.dart';
import 'package:flutter_restaurant/feat/restaurant/model/restaurant_model.dart';
import 'package:flutter_restaurant/feat/restaurant/view/restaurant_detail_screen.dart';

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
                  final pItem = RestaurantModel.fromJson(
                    json: item,
                  );
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RestaurantDetailScreen(
                            id: pItem.id,
                          ),
                        ),
                      );
                    },
                    child: RestaurantCard.fromModel(
                      model: pItem,
                    ),
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
