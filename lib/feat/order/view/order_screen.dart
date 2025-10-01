import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/component/pagination_list_view.dart';
import 'package:flutter_restaurant/feat/order/component/order_card.dart';
import 'package:flutter_restaurant/feat/order/model/order_model.dart';
import 'package:flutter_restaurant/feat/order/provider/order_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => ref.read(orderProvider.notifier).paginate(forceRefetch: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PaginationListView<OrderModel>(
      provider: orderProvider,
      itemBuilder: <OrderModel>(_, index, model) {
        return OrderCard.fromModel(
          model: model,
        );
      },
    );
  }
}
