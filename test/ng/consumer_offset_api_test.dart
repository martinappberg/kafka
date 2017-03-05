import 'package:test/test.dart';
import 'package:kafka/ng.dart';

void main() {
  group('OffsetFetchApi:', () {
    Session session = new Session([new ContactPoint('127.0.0.1:9092')]);
    OffsetFetchRequest _request;
    Broker _coordinator;
    String _testGroup;

    setUp(() async {
      var now = new DateTime.now();
      var metadata = new Metadata(session);
      _testGroup = 'group:' + now.millisecondsSinceEpoch.toString();
      _coordinator = await metadata.fetchGroupCoordinator(_testGroup);
      _request = new OffsetFetchRequest(_testGroup, {
        'dartKafkaTest': [0]
      });
    });

    tearDownAll(() async {
      await session.close();
    });

    test('it fetches consumer offsets', () async {
      OffsetFetchResponse response =
          await session.send(_request, _coordinator.host, _coordinator.port);
      expect(response.offsets, hasLength(equals(1)));
      expect(response.offsets.first.topic, equals('dartKafkaTest'));
      expect(response.offsets.first.partition, equals(0));
      expect(response.offsets.first.error, equals(0));
    });
  });
}