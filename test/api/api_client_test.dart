import 'package:flutter_test/flutter_test.dart';
import 'package:vietgara_core/testing.dart';
import 'package:vietgara_core/vietgara_core.dart';

import '../support/core_app.dart';

void main() {
  late FakeApi api;
  late MemoryTokenStore store;
  late ApiClient client;

  setUp(() {
    api = FakeApi();
    store = MemoryTokenStore(signedInTokens);
    client = ApiClient(
      client: api.client,
      tokenStore: store,
      baseUrl: 'https://vietgara.test/api/',
      language: () => 'en',
    );
  });

  test('sends the bearer token, language and query', () async {
    api.on('GET /garages', (request) => {'data': []});

    await client.get('/garages', query: {'page': 2, 'query': '', 'x': null});

    final request = api.calls('GET /garages').single;
    expect(
      request.url.toString(),
      'https://vietgara.test/api/v1/garages?page=2',
    );
    expect(request.headers['Authorization'], 'Bearer access-1');
    expect(request.headers['Accept-Language'], 'en');
  });

  test('public calls carry no bearer token', () async {
    api.on('POST /auth/login', (request) => {'accessToken': 'a'});

    await client.postPublic('/auth/login', {'email': 'a@b.c'});

    expect(
      api.calls('POST /auth/login').single.headers['Authorization'],
      isNull,
    );
  });

  test('turns an error answer into an ApiException with its details', () async {
    api.on(
      'POST /garages',
      (request) => const FakeResponse(400, {
        'error': {
          'code': 'VALIDATION_ERROR',
          'message': 'invalid',
          'details': [
            {'field': 'name', 'issue': 'required'},
          ],
        },
      }),
    );

    await expectLater(
      client.post('/garages', {}),
      throwsA(
        isA<ApiException>()
            .having((e) => e.status, 'status', 400)
            .having((e) => e.code, 'code', 'VALIDATION_ERROR')
            .having((e) => e.fieldIssue('name'), 'issue', 'required'),
      ),
    );
  });

  test('refreshes once on 401 and retries with the new token', () async {
    api.on(
      'GET /me',
      (request) => request.headers['Authorization'] == 'Bearer access-2'
          ? userJson()
          : FakeResponse.error(401, 'UNAUTHENTICATED'),
    );
    api.on('GET /garages', (request) {
      return request.headers['Authorization'] == 'Bearer access-2'
          ? {'data': []}
          : FakeResponse.error(401, 'UNAUTHENTICATED');
    });
    api.on(
      'POST /auth/refresh',
      (request) => {'accessToken': 'access-2', 'refreshToken': 'refresh-2'},
    );

    final results = await Future.wait([
      client.get('/me'),
      client.get('/garages'),
    ]);

    expect(results.first['email'], 'owner@example.com');
    expect(api.calls('POST /auth/refresh'), hasLength(1));
    expect(decodeBody(api.calls('POST /auth/refresh').single), {
      'refreshToken': 'refresh-1',
    });
    expect((await store.read())?.refreshToken, 'refresh-2');
  });

  test(
    'sends the Idempotency-Key, also on the retry after a refresh',
    () async {
      const route = 'POST /garages/g-1/settlements';
      api.on(
        route,
        (request) => request.headers['Authorization'] == 'Bearer access-2'
            ? {'id': 's-1'}
            : FakeResponse.error(401, 'UNAUTHENTICATED'),
      );
      api.on(
        'POST /auth/refresh',
        (request) => {'accessToken': 'access-2', 'refreshToken': 'refresh-2'},
      );

      final created = await client.postIdempotent('/garages/g-1/settlements', {
        'repairOrderId': 'ro-1',
      }, idempotencyKey: 'key-1');

      expect(created['id'], 's-1');
      final calls = api.calls(route);
      expect(calls, hasLength(2));
      expect(
        calls.map((request) => request.headers['Idempotency-Key']),
        everyElement('key-1'),
      );
      expect(decodeBody(calls.last), {'repairOrderId': 'ro-1'});
    },
  );

  test('other requests carry no Idempotency-Key', () async {
    api.on('POST /garages', (request) => {'id': 'g-1'});

    await client.post('/garages', {'name': 'A'});

    expect(
      api.calls('POST /garages').single.headers,
      isNot(contains('Idempotency-Key')),
    );
  });

  test('newIdempotencyKey makes distinct 32-hex keys', () {
    final keys = {for (var i = 0; i < 100; i++) newIdempotencyKey()};

    expect(keys, hasLength(100));
    expect(keys, everyElement(matches(RegExp(r'^[0-9a-f]{32}$'))));
  });

  test('clears the session and reports it when refresh fails', () async {
    var expired = false;
    client.onSessionExpired = () => expired = true;
    api.on('GET /me', (request) => FakeResponse.error(401, 'UNAUTHENTICATED'));
    api.on(
      'POST /auth/refresh',
      (request) => FakeResponse.error(401, 'REFRESH_TOKEN_INVALID'),
    );

    await expectLater(
      client.get('/me'),
      throwsA(isA<ApiException>().having((e) => e.status, 'status', 401)),
    );
    expect(expired, isTrue);
    expect(await store.read(), isNull);
  });

  test('reports an unreachable API as NETWORK', () async {
    api.on('GET /me', (request) => throw Exception('offline'));

    await expectLater(
      client.get('/me'),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'NETWORK')),
    );
  });

  test('downloads raw bytes', () async {
    api.on('GET /file', (request) => 'PDF');

    final bytes = await client.bytes('/file');

    expect(String.fromCharCodes(bytes), '"PDF"');
  });
}
