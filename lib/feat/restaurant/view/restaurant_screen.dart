import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/model/cursor_pagination_model.dart';
import 'package:flutter_restaurant/feat/restaurant/component/restaurant_card.dart';
import 'package:flutter_restaurant/feat/restaurant/model/restaurant_model.dart';
import 'package:flutter_restaurant/feat/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_restaurant/feat/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<CursorPagination<RestaurantModel>>(
            future: ref.watch(restaurantRepositoryProvider).paginate(),
            builder: (context, snapshot) {
              // print(snapshot.error);
              // JsonViewer.printPretty(snapshot.data);

              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.separated(
                itemCount: snapshot.data!.data.length,
                itemBuilder: (context, index) {
                  final pItem = snapshot.data!.data[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RestaurantDetailScreen(
                            id: pItem.id,
                            title: pItem.name,
                          ),
                        ),
                      );
                    },
                    child: RestaurantCard.fromModel(
                      model: pItem,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 16.0);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
