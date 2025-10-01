import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/const/colors.dart';
import 'package:flutter_restaurant/feat/order/model/order_model.dart';

class OrderCard extends StatelessWidget {
  final DateTime orderDate;
  final Image image;
  final String name;
  final String productDetail;
  final int price;

  const OrderCard({
    super.key,
    required this.orderDate,
    required this.image,
    required this.name,
    required this.productDetail,
    required this.price,
  });

  factory OrderCard.fromModel({
    required OrderModel model,
  }) {
    // 상품이 1개일때는 해당 상품의 이름, 2개 이상일 때는 첫번째 상품 외 개수만 표시
    final productDetail =
        model.products.length < 2 ?
            model.products.first.product.name :
            '${model.products.first.product.name} 외 ${model.products.length -1}개';

    return OrderCard(
      orderDate: model.createdAt,
      image: Image.network(
        model.restaurant.thumbUrl,
        height: 50.0,
        width: 50.0,
        fit: BoxFit.cover,
      ),
      name: model.restaurant.name,
      price: model.totalPrice,
      productDetail: productDetail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${orderDate.year}.${orderDate.month.toString().padLeft(2, '0')}.${orderDate.day.toString().padLeft(2, '0')} 주문완료',
        ),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: image,
            ),
            const SizedBox(width: 16.0),
            Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  '$productDetail $price원',
                  style: TextStyle(
                    color: BODY_TEXT_COLOR,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
