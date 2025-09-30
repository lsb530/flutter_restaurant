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