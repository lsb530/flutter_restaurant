import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_restaurant/feat/product/model/product_model.dart';
import 'package:flutter_restaurant/feat/user/model/basket_item_model.dart';
import 'package:flutter_restaurant/feat/user/model/patch_basket_body.dart';
import 'package:flutter_restaurant/feat/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>(
      (ref) {
        final repository = ref.watch(userMeRepositoryProvider);

        return BasketProvider(
          repository: repository,
        );
      },
    );

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;
  final updateBasketDebounce = Debouncer(
    Duration(seconds: 1),
    initialValue: null,
    checkEquality: false,
  );

  BasketProvider({
    required this.repository,
  }) : super([]) {
    updateBasketDebounce.values.listen(
      (event) => patchBasket(),
    );
  }

  Future<void> patchBasket() async {
    await repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) => PatchBasketBodyBasket(
                productId: e.product.id,
                count: e.count,
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 기존: 요청 -> 응답 -> 캐시 업데이트
    // await Future.delayed(Duration(milliseconds: 500));

    /// 1) 아직 장바구니에 해당되는 상품이 없다면 장바구니에 상품을 추가
    /// 2) 만약 이미 들어있다면, 장바구니에 있는 값에 추가함
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state
          .map(
            (e) => e.product.id == product.id
                ? e.copyWith(
                    count: e.count + 1,
                  )
                : e,
          )
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(
          product: product,
          count: 1,
        ),
      ];
    }

    // Optimistic Response (긍정적 응답)
    // 응답이 성공할 것이라고 가정하고, 상태를 먼저 업데이트함
    // 이유: 에러가 크리티컬하지 않고, 유저가 앱이 빠르다는 인식이 더 중요하다고 판단했기 때문
    updateBasketDebounce.setValue(null);
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    bool isDelete = false, // true면 count와 관계 없이 삭제
  }) async {
    /// 1) 상품이 존재하지 않을 때
    ///   즉시 함수를 반환하고 아무것도 하지 않음
    /// 2) 장바구니에 상품이 존재할 때
    ///   a) 상품의 카운트가 1이면 삭제
    ///   b) 상품의 카운트가 1보다 크면 -1
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exists) {
      return;
    }

    final existingProduct = state.firstWhere((e) => e.product.id == product.id);

    if (existingProduct.count == 1 || isDelete) {
      state = state
          .where(
            (e) => e.product.id != product.id,
          )
          .toList();
    } else {
      state = state
          .map(
            (e) =>
                e.product.id == product.id ? e.copyWith(count: e.count - 1) : e,
          )
          .toList();
    }

    updateBasketDebounce.setValue(null);
  }

  Future<void> clearBasket() async {
    state = [];
  }
}
