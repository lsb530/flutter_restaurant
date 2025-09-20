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