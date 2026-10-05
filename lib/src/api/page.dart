import 'json.dart';

/// A page of a server-side listing: `{data, pagination}` (API Specification
/// Section 1.1).
class ResultPage<T> {
  const ResultPage({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory ResultPage.fromJson(Json json, T Function(Json json) parse) {
    final pagination = json.obj('pagination');
    final items = json.list('data', parse);
    return ResultPage(
      items: items,
      total: pagination.containsKey('total')
          ? pagination.int32('total')
          : items.length,
      page: pagination.containsKey('page') ? pagination.int32('page') : 1,
      pageSize: pagination.int32('pageSize'),
    );
  }

  final List<T> items;
  final int total;
  final int page;
  final int pageSize;

  /// Whether a later page exists (never without a known page size, so a
  /// listing answered without pagination cannot load forever).
  bool get hasMore =>
      pageSize > 0 && items.isNotEmpty && page * pageSize < total;
}
