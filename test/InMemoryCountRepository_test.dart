import 'package:async/async.dart';
import 'package:flutter_spike_state_management/InMemoryCountRepository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemoryCountRepository repo;
  late StreamQueue<int> streamQueue;

  setUp(() {
    repo = InMemoryCountRepository(200);
    streamQueue = StreamQueue<int>(repo.countSteam);
  });

  test("getCount", () async {
    await repo.saveCount(10);
    expect(await repo.getCount(), equals(10));
  });

  test("emitsCount", () async {
    // emits when new listener is attached.
    expect(await streamQueue.next, equals(0));

    await repo.saveCount(5);
    expect(await streamQueue.next, equals(5));

    repo.saveCount(10);
    expect(await streamQueue.next, equals(10));

    repo.saveCount(20);
    expect(await streamQueue.next, equals(20));
  });

  test("getAndUpdate", () async {
    // attach on first listener attached
    expect(await streamQueue.next, equals(0));

    repo.getAndUpdate((value) => value + 1);
    repo.getAndUpdate((value) => value + 3);

    expect(await streamQueue.next, equals(1));
    expect(await streamQueue.next, equals(4));
  });

  test("multipleListeners", () async {
    expect(await streamQueue.next, equals(0));

    await repo.saveCount(5);
    expect(await streamQueue.next, equals(5));

    final streamQueue2 = StreamQueue<int>(repo.countSteam);

    await repo.saveCount(10);

    expect(await streamQueue2.next, equals(10));
    expect(await streamQueue.next, equals(10));
  });
}
