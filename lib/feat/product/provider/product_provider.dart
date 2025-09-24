import 'package:flutter_restaurant/common/model/cursor_pagination_model.dart';
import 'package:flutter_restaurant/common/provider/pagination_provider.dart';
import 'package:flutter_restaurant/feat/product/model/product_model.dart';
import 'package:flutter_restaurant/feat/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider =
    StateNotifierProvider<ProductStateNotifier, CursorPaginationBase>(
      (ref) {
        final repository = ref.watch(productRepositoryProvider);
        return ProductStateNotifier(repository: repository);
      },
    );

class ProductStateNotifier
    extends PaginationProvider<ProductModel, ProductRepository> {
  ProductStateNotifier({
    required super.repository,
  });
}
