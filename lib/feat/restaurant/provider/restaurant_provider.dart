import 'package:flutter_restaurant/common/model/cursor_pagination_model.dart';
import 'package:flutter_restaurant/common/model/pagination_params.dart';
import 'package:flutter_restaurant/feat/restaurant/model/restaurant_model.dart';
import 'package:flutter_restaurant/feat/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider = Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination<RestaurantModel>) {
    return null;
  }
  
  return state.data.firstWhere((element) => element.id == id);
});

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
    try {
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

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchMore: 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } else {
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;

          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        // 기존 데이터에 새로운 데이터 추가
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        state = resp;
      }
    } catch(e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}
