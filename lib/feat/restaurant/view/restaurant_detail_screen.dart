import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/const/data.dart';
import 'package:flutter_restaurant/common/dio/dio.dart';
import 'package:flutter_restaurant/common/layout/default_layout.dart';
import 'package:flutter_restaurant/common/util/json_viewer.dart';
import 'package:flutter_restaurant/feat/product/component/product_card.dart';
import 'package:flutter_restaurant/feat/restaurant/component/restaurant_card.dart';
import 'package:flutter_restaurant/feat/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_restaurant/feat/restaurant/repository/restaurant_repository.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({
    super.key,
    required this.id,
  });

  Future<RestaurantDetailModel> getRestaurantDetail() async {
    final dio = Dio();

    dio.interceptors.add(
      CustomInterceptor(secureStorage: secureStorage),
    );

    final repository = RestaurantRepository(dio, baseUrl: 'http://$hostPort/restaurant');

    final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);
    return repository.getRestaurantDetail(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder<RestaurantDetailModel>(
        future: getRestaurantDetail(),
        builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return CustomScrollView(
            slivers: [
              renderTop(model: snapshot.data!),
              renderLabel(),
              renderProducts(
                products: snapshot.data!.products,
              ),
            ],
          );
        },
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
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

  SliverPadding renderProducts({
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: products.length,
          (context, index) {
            final model = products[index];

            return Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(
                model: model,
              ),
            );
          },
        ),
      ),
    );
  }
}
