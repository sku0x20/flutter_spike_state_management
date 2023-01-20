import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:simple_hello_world/CountRepository.dart';
import 'package:simple_hello_world/screens/screen_1/Screen1Vm.dart';

@GenerateMocks([CountRepository])
import "Screen1Vm_test.mocks.dart";

void main() {

  test("adds1OnPressed", () async {
    final countRepo = MockCountRepository();
    final vm = Screen1Vm(countRepo);

    when(countRepo.getCount()).thenAnswer((_) => Future.value(11));

    vm.onPressed();

    await Future.delayed(const Duration(milliseconds: 1));
    verify(countRepo.saveCount(12));
  });

  test("exposesCountStream", () async {
    final countRepo = MockCountRepository();
    final vm = Screen1Vm(countRepo);

    final streamController = StreamController<int>();
    when(countRepo.countSteam).thenAnswer((_) => streamController.stream);

    final streamQueue = StreamQueue<int>(vm.countStream);

    streamController.add(22);

    expect(await streamQueue.next, equals(22));
  });


}
