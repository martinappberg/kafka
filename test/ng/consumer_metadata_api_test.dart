import 'dart:async';
import 'package:test/test.dart';
import 'package:kafka/ng.dart';

void main() {
  group('Protocol.NG Consumer Metadata API: ', () {
    setUpAll(() async {
      try {
        var session = new KSession();
        var request = new GroupCoordinatorRequestV0('testGroup');
        await session.send(request, '127.0.0.1', 9092);
      } catch (error) {
        await new Future.delayed(new Duration(milliseconds: 1000));
      }
    });

    test('we can send group coordinator requests to Kafka broker', () async {
      var session = new KSession();
      var request = new GroupCoordinatorRequestV0('testGroup');
      var response = await session.send(request, '127.0.0.1', 9092);
      expect(response, new isInstanceOf<GroupCoordinatorResponseV0>());
      expect(response.coordinatorId, greaterThanOrEqualTo(0));
      expect(response.coordinatorHost, '127.0.0.1');
      expect(response.coordinatorPort, isIn([9092, 9093]));
    });

    test('group coordinator response throws server error if present', () {
      expect(() {
        new GroupCoordinatorResponseV0(
            KafkaServerError.ConsumerCoordinatorNotAvailable, null, null, null);
      }, throwsA(new isInstanceOf<KafkaServerError>()));
    });
  });
}