import 'package:flutter_restaurant/common/model/cursor_pagination_model.dart';
import 'package:flutter_restaurant/common/provider/pagination_provider.dart';
import 'package:flutter_restaurant/feat/restaurant/model/restaurant_model.dart';
import 'package:flutter_restaurant/feat/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final restaurantDetailProvider = Provider.family<RestaurantModel?, String>((
  ref,
  id,
) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  // nullable
  return state.data.firstWhereOrNull((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
      (ref) {
        final repository = ref.watch(restaurantRepositoryProvider);
        return RestaurantStateNotifier(repository: repository);
      },
    );

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
  }) async {
    // 데이터가 하나도 없는 상태라면 데이터 획득 시도
    if (state is! CursorPagination) {
      await paginate();
    }

    // state가 CursorPagination이 아닐 때는 종료
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    final resp = await repository.getRestaurantDetail(id: id);

    // [RestaurantModel(1), RestaurantDetailModel(2), RestaurantModel(3)]
    // 요청 id: 10
    // 데이터가 없을 때는 캐시의 끝에다가 데이터를 추가
    // [RestaurantModel(1), RestaurantDetailModel(2), RestaurantModel(3), RestaurantModel(10)]
    if (pState.data.where((e) => e.id == id).isEmpty) {
      state = pState.copyWith(
        data: <RestaurantModel>[
          ...pState.data,
          resp,
        ],
      );
    } else {
      // [RestaurantModel(1), RestaurantDetailModel(2), RestaurantModel(3)]
      state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>((e) => e.id == id ? resp : e)
            .toList(),
      );
    }
  }
}
