import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_restaurant/common/const/data.dart';
import 'package:flutter_restaurant/common/dio/dio.dart';
import 'package:flutter_restaurant/common/model/cursor_pagination_model.dart';
import 'package:flutter_restaurant/common/model/pagination_params.dart';
import 'package:flutter_restaurant/common/repository/base_pagination_repository.dart';
import 'package:flutter_restaurant/feat/product/model/product_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_repository.g.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return ProductRepository(dio, baseUrl: 'http://$hostPort/product');
  },
);

// http://$hostPort/product
@RestApi()
abstract class ProductRepository implements IBasePaginationRepository<ProductModel> {
  factory ProductRepository(Dio dio, {String baseUrl}) = _ProductRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  @override
  Future<CursorPagination<ProductModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
