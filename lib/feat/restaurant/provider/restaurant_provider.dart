import 'package:flutter_restaurant/common/model/cursor_pagination_model.dart';
import 'package:flutter_restaurant/feat/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
      (ref) {
        final repository = ref.watch(restaurantRepositoryProvider);
        return RestaurantStateNotifier(repository: repository);
      },
    );

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  void paginate({
    int fetchCount = 20,
    // 기존 데이터 유지 후, 추가로 데이터 요청
    bool fetchMore = false,
    // 강제로 전체 데이터 삭제 후, 다시 로딩(true: CursorPaginationLoading())
    bool forceRefetch = false,
  }) async {
    // 5가지 State
    /// 1) CursorPagination - 정상적으로 데이터가 존재
    /// 2) CursorPaginationLoading - 데이터 로딩중(현재 캐시 x)
    /// 3) CursorPaginationError - 에러 발생
    /// 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터 요청
    /// 5) CursorPaginationFetchMore - 추가 데이터를 paginate로 받아오라는 요청

    // 바로 반환하는 상태
    // 1) hasMore = false(기존 상태에서 이미 다음 데이터가 없다는 값을 들고 있다면)
    // 2) 로딩중 - fetchMore가 true일 떄
    //           fetchMore가 false일 때(새로고침 의도가 있는 경우)
    if (state is CursorPagination && !forceRefetch) {
      final pState = state as CursorPagination;

      if (!pState.meta.hasMore) {
        return;
      }
    }

    final isLoading = state is CursorPaginationLoading;
    final isRefetching = state is CursorPaginationRefetching;
    final isFetchingMore = state is CursorPaginationFetchingMore;

    // 2번
    if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
      return;
    }

    
  }
}
