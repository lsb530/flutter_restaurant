import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

abstract class CursorPaginationBase {}

/// 최초 데이터 가져오는 중일 때
class CursorPaginationLoading extends CursorPaginationBase {}

/// 최초 데이터 가져오는 중 오류 발생시
class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  factory CursorPagination.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

/// 새로고침
class CursorPaginationRefetching extends CursorPagination {
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

/// 리스트의 맨 아래로 내려서 추가 데이터 요청
class CursorPaginationFetchingMore extends CursorPagination {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}
