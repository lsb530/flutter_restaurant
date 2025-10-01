# flutter_restaurant

A new Flutter project.

## Dev
### json_serializable
as-is
```dart
import 'package:flutter_restaurant/common/const/data.dart';
import 'package:json_annotation/json_annotation.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

class RestaurantModel {
  final String id;
  final String name;
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });
  
  factory RestaurantModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      thumbUrl: 'http://$hostPort${json['thumbUrl']}',
      tags: List<String>.from(json['tags']),
      priceRange: RestaurantPriceRange.values.firstWhere(
            (e) => e.name == json['priceRange'],
      ),
      ratings: json['ratings'],
      ratingsCount: json['ratingsCount'],
      deliveryTime: json['deliveryTime'],
      deliveryFee: json['deliveryFee'],
    );
  }
}
```
to-be
```dart
import 'package:flutter_restaurant/common/const/data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

@JsonSerializable()
class RestaurantModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: pathToUrl,
  )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json)
    => _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  static String pathToUrl(String value) {
    return 'http://$hostPort$value';
  }
}
```

CLI
```shell
  flutter pub run build_runner build
```
CLI(continuos build)
```shell
  flutter pub run build_runner watch
```

### Retrofit
Usage
```dart
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_restaurant/feat/restaurant/model/restaurant_detail_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // @GET('/')
  // paginate();

  @GET('/{id}')
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
    @Header('authorization') required String token,
  });
}
```

CLI
```shell
  flutter pub run build_runner build
```
CLI(continuos build)
```shell
  flutter pub run build_runner watch
```

error
```text
parseErrorLogger? errorLogger;
```
fix
```dart
import 'package:retrofit/retrofit.dart';
```

### Debounce & Throttle: 함수 실행 빈도 제어
- `Debounce`: 
  - 정의: 일정 시간 동안 입력(이벤트)이 추가로 발생하지 않을 때 `마지막 입력만 처리`한다.
  - 사용 예시)
    - 메뉴를 여러번 클릭하거나, 장바구니에서 +를 여러번 요청할 때 API가 즉각적으로 반응될 필요가 없이 1번만 요청되도록 함
    - 사용자가 검색창에 빠르게 텍스트를 입력할 때, 서버로 보내는 검색 요청 횟수를 줄이기 위해
    
- `Throttle`: 맨 처음 요청만 실행되도록 (이후 특정 시간동안 요청무시됨)
- 정의: 정해진 간격 내에서 `최대 1회만 실행`되도록 제한한다.
  - 사용 예시)
    - 무한스크롤에서 맨 아래로 빠르게 스크롤을하여 스크롤 이벤트가 발생할 때마다 데이터 요청이 과도하게 일어나는 경우 3회 요청 -> 1회만 요청

- 속성
  - `checkEquality`: 함수를 실행할때 넣는 값이 똑같으면 실행하지 않을지 결정(false -> 인자가 같아도 강제 호출)
```dart
/// 객체 생성 - Debounce
final updateBasketDebounce = Debouncer(
  Duration(seconds: 1),
  initialValue: null,
  checkEquality: false,
);

/// 객체 생성 - Throttle
final paginationThrottle = Throttle(
  Duration(seconds: 3),
  initialValue: _PaginationInfo(),
  checkEquality: false,
);

/// 사용 - Debounce
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
    /// Usage
    updateBasketDebounce.values.listen(
          (event) => patchBasket(),
    );
  }
}

/// 사용 - Throttle
class PaginationProvider<
T extends IModelWithId,
U extends IBasePaginationRepository<T>
> extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final paginationThrottle = Throttle(
    Duration(seconds: 3),
    initialValue: _PaginationInfo(),
    checkEquality: false,
  );

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
    
    /// Usage
    paginationThrottle.values.listen(
          (state) {
        _throttledPagination(state);
      },
    );
  }
}
```

## Tips
### File Nesting
- double shift -> File Nesting
- Project file Suffix: `.dart` -> Child File Suffix: .. ; `.g.dart; `

### Badges
- badges: ^3.1.2 를 사용하고 싶다면 material의 Badge 위젯을 hide해야됨
```dart
import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
```

### RefreshIndicator
- RefreshIndicator를 단순히 사용하면 Android 스타일만 제공된다.
- RefreshIndicator.adaptive를 사용하면 Android, iOS 각각의 플랫폼에 맞는 스타일로 제공된다.

### Null-Safe Rendering vs Condition Rendering
- Null-Safe Rendering
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  return Column(
    children: [
      // 기존 Widget들,
      ?renderFooter(ref),
    ],
  );
}

Widget? renderFooter(WidgetRef ref) {
  if (onSubtract != null && onAdd != null) {
    final basket = ref.watch(basketProvider);
    final foundProduct = basket.firstWhere((e) => e.product.id == id);

    final totalPrice = foundProduct.count * foundProduct.product.price;
    final basketCount = foundProduct.count;

    return _Footer(
      totalPrice: totalPrice.toString(),
      count: basketCount,
      onSubtract: onSubtract!,
      onAdd: onAdd!,
    );
  }

  return null;
}
```
- Condition Rendering
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  return Column(
    children: [
      // 기존 Widget들,
      if (onSubtract != null && onAdd != null) renderFooter(ref),
    ],
  );
}

Widget renderFooter(WidgetRef ref) {
  final basket = ref.watch(basketProvider);
  final foundProduct = basket.firstWhere((e) => e.product.id == id);

  final totalPrice = foundProduct.count * foundProduct.product.price;
  final basketCount = foundProduct.count;

  return _Footer(
    totalPrice: totalPrice.toString(),
    count: basketCount,
    onSubtract: onSubtract!,
    onAdd: onAdd!,
  );
}
```


## Debug
### build_runner version conflict
error
```text
build_runner                                                                                                                                                                                                                         
W .dart_tool/build/entrypoint/build.dart:5:8: Error: Error when reading '../../.pub-cache/hosted/pub.dev/build_runner-2.5.4/lib/src/package_graph/apply_builders.dart': No such file or directory                                    
  import 'package:build_runner/src/package_graph/apply_builders.dart' as _i1;                                                                                                                                                        
         ^                                                                                                                                                                                                                           
  .dart_tool/build/entrypoint/build.dart:16:24: Error: 'BuilderApplication' isn't a type.                                                                                                                                            
  final _builders = <_i1.BuilderApplication>[                                                                                                                                                                                        
                         ^^^^^^^^^^^^^^^^^^                                                                                                                                                                                          
  .dart_tool/build/entrypoint/build.dart:20:9: Error: Method not found: 'toDependentsOf'.                                                                                                                                            
      _i1.toDependentsOf(r'riverpod_generator'),                                                                                                                                                                                     
          ^^^^^^^^^^^^^^                                                                                                                                                                                                             
  .dart_tool/build/entrypoint/build.dart:17:7: Error: Method not found: 'apply'.                                                                                                                                                     
    _i1.apply(                                                                                                                                                                                                                       
        ^^^^^                                                                                                                                                                                                                        
  .dart_tool/build/entrypoint/build.dart:27:9: Error: Method not found: 'toDependentsOf'.                                                                                                                                            
      _i1.toDependentsOf(r'retrofit_generator'),                                                                                                                                                                                     
          ^^^^^^^^^^^^^^                                                                                                                                                                                                             
  .dart_tool/build/entrypoint/build.dart:24:7: Error: Method not found: 'apply'.                                                                                                                                                     
    _i1.apply(                                                                                                                                                                                                                       
        ^^^^^                                                                                                                                                                                                                        
  .dart_tool/build/entrypoint/build.dart:34:9: Error: Method not found: 'toDependentsOf'.                                                                                                                                            
      _i1.toDependentsOf(r'json_serializable'),                                                                                                                                                                                      
          ^^^^^^^^^^^^^^                                                                                                                                                                                                             
  .dart_tool/build/entrypoint/build.dart:31:7: Error: Method not found: 'apply'.                                                                                                                                                     
    _i1.apply(                                                                                                                                                                                                                       
        ^^^^^                                                                                                                                                                                                                        
  .dart_tool/build/entrypoint/build.dart:41:9: Error: Method not found: 'toNoneByDefault'.                                                                                                                                           
      _i1.toNoneByDefault(),                                                                                                                                                                                                         
          ^^^^^^^^^^^^^^^                                                                                                                                                                                                            
  .dart_tool/build/entrypoint/build.dart:38:7: Error: Method not found: 'apply'.                                                                                                                                                     
    _i1.apply(                                                                                                                                                                                                                       
        ^^^^^                                                                                                                                                                                                                        
  .dart_tool/build/entrypoint/build.dart:45:7: Error: Method not found: 'applyPostProcess'.                                                                                                                                          
    _i1.applyPostProcess(                                                                                                                                                                                                            
        ^^^^^^^^^^^^^^^^                                                                                                                                                                                                             
                                                                                                                                                                                                                                     
Compiling the build script.                                                                                                                                                                                                          
Log overflowed the console, switching to line-by-line logging.
E Failed to compile build script. Check builder definitions and generated script .dart_tool/build/entrypoint/build.dart.
Failed to update packages.
```

fix
```yaml
build_runner: ^2.5.4 # 기존 형태 build_runner:
```
```shell
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### go route with context variable
error
```text
======== Exception caught by gesture ===============================================================
The following NoSuchMethodError was thrown while handling a gesture:
Class 'SliverMultiBoxAdaptorElement' has no instance method 'go'.
Receiver: Instance of 'SliverMultiBoxAdaptorElement'
Tried calling: go("/restaurant/5ac83bfb-f2b5-55f4-be3c-564be3f01a5b")

When the exception was thrown, this was the stack: 
#0      Object.noSuchMethod (dart:core-patch/object_patch.dart:38:5)
#1      RestaurantScreen.build.<anonymous closure>.<anonymous closure> (package:flutter_restaurant/feat/restaurant/view/restaurant_screen.dart:17:21)
#2      GestureRecognizer.invokeCallback (package:flutter/src/gestures/recognizer.dart:345:24)
#3      TapGestureRecognizer.handleTapUp (package:flutter/src/gestures/tap.dart:758:11)
#4      BaseTapGestureRecognizer._checkUp (package:flutter/src/gestures/tap.dart:383:5)
#5      BaseTapGestureRecognizer.acceptGesture (package:flutter/src/gestures/tap.dart:353:7)
#6      GestureArenaManager.sweep (package:flutter/src/gestures/arena.dart:173:27)
#7      GestureBinding.handleEvent (package:flutter/src/gestures/binding.dart:532:20)
#8      GestureBinding.dispatchEvent (package:flutter/src/gestures/binding.dart:498:22)
#9      RendererBinding.dispatchEvent (package:flutter/src/rendering/binding.dart:473:11)
#10     GestureBinding._handlePointerEventImmediately (package:flutter/src/gestures/binding.dart:437:7)
#11     GestureBinding.handlePointerEvent (package:flutter/src/gestures/binding.dart:394:5)
#12     GestureBinding._flushPointerEventQueue (package:flutter/src/gestures/binding.dart:341:7)
#13     GestureBinding._handlePointerDataPacket (package:flutter/src/gestures/binding.dart:308:9)
#14     _invoke1 (dart:ui/hooks.dart:346:13)
#15     PlatformDispatcher._dispatchPointerDataPacket (dart:ui/platform_dispatcher.dart:467:7)
#16     _dispatchPointerDataPacket (dart:ui/hooks.dart:281:31)
Handler: "onTap"
Recognizer: TapGestureRecognizer#b0880
  debugOwner: GestureDetector
  state: ready
  won arena
  finalPosition: Offset(213.3, 268.3)
  finalLocalPosition: Offset(197.3, 153.3)
  button: 1
  sent tap down
====================================================================================================
```

code
```dart
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/component/pagination_list_view.dart';
import 'package:flutter_restaurant/feat/restaurant/component/restaurant_card.dart';
import 'package:flutter_restaurant/feat/restaurant/provider/restaurant_provider.dart';
import 'package:go_router/go_router.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      provider: restaurantProvider,
      itemBuilder: <RestaurantModel>(context, index, model) {
        return GestureDetector(
          onTap: () {
            context.go('/restaurant/${model.id}');
          },
          child: RestaurantCard.fromModel(
            model: model,
          ),
        );
      },
    );
  }
}
```

fix
go_router를 쓸 때는 BuildContext의 context로 넘어가는것이기때문에 itemBuilder의 첫번째 인자를 _로 처리해야됨!
```dart
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/component/pagination_list_view.dart';
import 'package:flutter_restaurant/feat/restaurant/component/restaurant_card.dart';
import 'package:flutter_restaurant/feat/restaurant/provider/restaurant_provider.dart';
import 'package:go_router/go_router.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      provider: restaurantProvider,
      itemBuilder: <RestaurantModel>(_, index, model) { /// 여기 수정
        return GestureDetector(
          onTap: () {
            context.go('/restaurant/${model.id}');
          },
          child: RestaurantCard.fromModel(
            model: model,
          ),
        );
      },
    );
  }
}
```

### Widget Tree가 그려지기 전 Build 중인 상태에서 상태 변경이 일어나는 경우 발생한 에러
error
```text
flutter: At least listener of the StateNotifier Instance of 'OrderStateNotifier' threw an exception
when the notifier tried to update its state.

The exceptions thrown are:

Tried to modify a provider while the widget tree was building.
If you are encountering this error, chances are you tried to modify a provider
in a widget life-cycle, such as but not limited to:
- build
- initState
- dispose
- didUpdateWidget
- didChangeDependencies

Modifying a provider inside those life-cycles is not allowed, as it could
lead to an inconsistent UI state. For example, two widgets could listen to the
same provider, but incorrectly receive different states.


To fix this problem, you have one of two solutions:
- (preferred) Move the logic for modifying your provider outside of a widget
  life-cycle. For example, maybe you could update your provider inside a button's
  onPressed instead.

- Delay your modification, such as by encapsulating the modification
  in a `Future(() {...})`.
  This will perform your update a<…>
```

code
```dart
class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {

  @override
  void initState() {
    super.initState();

    ref.read(orderProvider.notifier).paginate(forceRefetch: true);
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
```

fix
Future.microtask or WidgetsBinding 사용해서 지연 실행
```dart
class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {

  @override
  void initState() {
    super.initState();

    /// 1번 방법
    Future.microtask(
      () => ref.read(orderProvider.notifier).paginate(forceRefetch: true),
    );
    
                    // 또는
    
    /// 2번 방법
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).paginate(forceRefetch: true);
    });
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
```