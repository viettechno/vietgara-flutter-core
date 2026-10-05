import 'package:flutter_test/flutter_test.dart';
import 'package:vietgara_core/vietgara_core.dart';

ResultPage<int> page(Map<String, dynamic> json) =>
    ResultPage.fromJson(json, (item) => item['n'] as int);

void main() {
  test('reads the items and the pagination', () {
    final result = page({
      'data': [
        {'n': 1},
        {'n': 2},
      ],
      'pagination': {'total': 5, 'page': 1, 'pageSize': 2},
    });

    expect(result.items, [1, 2]);
    expect(result.total, 5);
    expect(result.hasMore, isTrue);
  });

  test('has no more on the last page', () {
    final result = page({
      'data': [
        {'n': 5},
      ],
      'pagination': {'total': 5, 'page': 3, 'pageSize': 2},
    });

    expect(result.hasMore, isFalse);
  });

  test('never loads more without pagination', () {
    final result = page({
      'data': [
        {'n': 1},
      ],
    });

    expect(result.total, 1);
    expect(result.hasMore, isFalse);
  });
}
