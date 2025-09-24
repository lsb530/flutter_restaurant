import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/component/pagination_list_view.dart';
import 'package:flutter_restaurant/feat/product/component/product_card.dart';
import 'package:flutter_restaurant/feat/product/model/product_model.dart';
import 'package:flutter_restaurant/feat/product/provider/product_provider.dart';
import 'package:flutter_restaurant/feat/restaurant/view/restaurant_detail_screen.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      provider: productProvider,
      itemBuilder: <ProductModel>(context, index, model) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RestaurantDetailScreen(
                  id: model.restaurant.id,
                  title: model.restaurant.name,
                ),
              ),
            );
          },
          child: ProductCard.fromProductModel(
            model: model,
          ),
        );
      },
    );
  }
}
