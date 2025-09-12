import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/const/data.dart';
import 'package:flutter_restaurant/common/layout/default_layout.dart';
import 'package:flutter_restaurant/common/util/json_viewer.dart';
import 'package:flutter_restaurant/feat/product/component/product_card.dart';
import 'package:flutter_restaurant/feat/restaurant/component/restaurant_card.dart';
import 'package:flutter_restaurant/feat/restaurant/model/restaurant_model.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({
    super.key,
    required this.id,
  });

  Future? getRestaurantDetail() async {
    final dio = Dio();

    final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$hostPort/restaurant/$id',
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken'
        }
      ),
    );

    JsonViewer.printPretty(resp.data);

    return resp;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder(
        future: getRestaurantDetail(),
        builder: (_, snapshot) {
          return CustomScrollView(
            slivers: [
              renderTop(),
              renderLabel(),
              renderProducts(),
            ],
          );
        }
      ),
    );
  }

  SliverToBoxAdapter renderTop() {
    return SliverToBoxAdapter(
      child: RestaurantCard(
        image: Image.asset(
          'asset/img/food/ddeok_bok_gi.jpg',
        ),
        name: '불타는 떡볶이',
        tags: ['떡볶이', '맛있음', '치즈'],
        ratingsCount: 100,
        deliveryTime: 30,
        deliveryFee: 3000,
        ratings: 4.76,
        isDetail: true,
        detail: '맛있는 떡볶이',
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverPadding renderProducts() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: 10,
          (context, index) => Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: ProductCard(),
          ),
        ),
      ),
    );
  }
}
