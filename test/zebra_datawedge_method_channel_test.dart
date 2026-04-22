
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zebra_scan_datawedge/zebra_datawedge_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MethodChannelZebraDataWedgePlatform platform;
  late TestDefaultBinaryMessenger messenger;
  late List<MethodCall> methodCalls;
  Object? availabilityResult;

  setUp(() {
    platform = MethodChannelZebraDataWedgePlatform();
    messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    methodCalls = <MethodCall>[];
    availabilityResult = true;

    messenger.setMockMethodCallHandler(
      platform.methodChannel,
      (MethodCall call) async {
        methodCalls.add(call);
        if (call.method == 'isDataWedgeAvailable') {
          return availabilityResult;
        }
        return null;
      },
    );
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(platform.methodChannel, null);
    messenger.setMockMessageHandler(platform.eventChannel.name, null);
  });

  group('method channel calls', () {
    test('isDataWedgeAvailable returns true and defaults to false on null', () async {
      availabilityResult = true;
      expect(await platform.isDataWedgeAvailable(), isTrue);

      availabilityResult = null;
      expect(await platform.isDataWedgeAvailable(), isFalse);
    });

    test('delegates standard methods and arguments', () async {
      await platform.configureProfile('PROFILE_A');
      await platform.switchToProfile('PROFILE_B');
      await platform.startSoftScan();
      await platform.enableScanner();
      await platform.disableScanner();
      await platform.registerForNotification('SCANNER_STATUS');
      await platform.unregisterForNotification('SCANNER_STATUS');
      await platform.getActiveProfile();
      await platform.getProfilesList();
      await platform.getVersionInfo();
      await platform.enumerateScanners();

      expect(methodCalls[0].method, 'configureProfile');
      expect(methodCalls[0].arguments, <String, dynamic>{'profileName': 'PROFILE_A'});

      expect(methodCalls[1].method, 'switchToProfile');
      expect(methodCalls[1].arguments, <String, dynamic>{'profileName': 'PROFILE_B'});

      expect(methodCalls[2].method, 'startSoftScan');
      expect(methodCalls[3].method, 'enableScanner');
      expect(methodCalls[4].method, 'disableScanner');

      expect(methodCalls[5].method, 'registerForNotification');
      expect(methodCalls[5].arguments, <String, dynamic>{
        'notificationType': 'SCANNER_STATUS',
      });

      expect(methodCalls[6].method, 'unregisterForNotification');
      expect(methodCalls[6].arguments, <String, dynamic>{
        'notificationType': 'SCANNER_STATUS',
      });

      expect(methodCalls[7].method, 'getActiveProfile');
      expect(methodCalls[8].method, 'getProfilesList');
      expect(methodCalls[9].method, 'getVersionInfo');
      expect(methodCalls[10].method, 'enumerateScanners');
    });

    test('sendCommand and sendCommandBundle invoke expected payload keys', () async {
      await platform.sendCommand(
        command: 'CUSTOM_COMMAND',
        value: 123,
        commandTag: 'TAG_A',
        requestResult: false,
      );

      expect(methodCalls.last.method, 'sendCommand');
      expect(methodCalls.last.arguments, <String, dynamic>{
        'command': 'CUSTOM_COMMAND',
        'value': 123,
        'commandTag': 'TAG_A',
        'requestResult': false,
      });

      await platform.sendCommandBundle(
        command: 'CUSTOM_BUNDLE',
        value: const <String, dynamic>{'x': 'y'},
        commandTag: 'TAG_B',
        requestResult: false,
      );

      expect(methodCalls.last.method, 'sendCommandBundle');
      expect(methodCalls.last.arguments, <String, dynamic>{
        'command': 'CUSTOM_BUNDLE',
        'value': const <String, dynamic>{'x': 'y'},
        'commandTag': 'TAG_B',
        'requestResult': false,
      });
    });

    test('sendIntent invokes expected payload keys', () async {
      await platform.sendIntent(
        extras: const <String, dynamic>{'k': 'v'},
        action: 'CUSTOM_ACTION',
        targetPackage: 'com.example.target',
        commandTag: 'TAG_C',
        requestResult: false,
        orderedBroadcast: true,
        includeApplicationPackage: true,
      );

      expect(methodCalls.last.method, 'sendIntent');
      expect(methodCalls.last.arguments, <String, dynamic>{
        'extras': const <String, dynamic>{'k': 'v'},
        'action': 'CUSTOM_ACTION',
        'targetPackage': 'com.example.target',
        'commandTag': 'TAG_C',
        'requestResult': false,
        'orderedBroadcast': true,
        'includeApplicationPackage': true,
      });
    });
  });

  group('event channel mapping', () {
    test('passes through map events unchanged', () async {
      final StandardMethodCodec codec = const StandardMethodCodec();
      const Map<String, dynamic> payload = <String, dynamic>{
        'type': 'scan',
        'data': 'ABC',
      };

      messenger.setMockMessageHandler(platform.eventChannel.name,
          (ByteData? message) async {
        final MethodCall call = codec.decodeMethodCall(message);
        if (call.method == 'listen') {
          Future<void>.microtask(() {
            messenger.handlePlatformMessage(
              platform.eventChannel.name,
              codec.encodeSuccessEnvelope(payload),
              (_) {},
            );
          });
        }
        return codec.encodeSuccessEnvelope(null);
      });

      expect(await platform.events.first, payload);
    });

    test('converts non-map events into scan payload shape', () async {
      final StandardMethodCodec codec = const StandardMethodCodec();
      const int scalarPayload = 42;

      messenger.setMockMessageHandler(platform.eventChannel.name,
          (ByteData? message) async {
        final MethodCall call = codec.decodeMethodCall(message);
        if (call.method == 'listen') {
          Future<void>.microtask(() {
            messenger.handlePlatformMessage(
              platform.eventChannel.name,
              codec.encodeSuccessEnvelope(scalarPayload),
              (_) {},
            );
          });
        }
        return codec.encodeSuccessEnvelope(null);
      });

      expect(await platform.events.first, <String, dynamic>{
        'type': 'scan',
        'data': '42',
      });
    });
  });
}
