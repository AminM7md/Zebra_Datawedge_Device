import 'package:flutter_test/flutter_test.dart';
import 'package:zebra_wedge_scanner/zebra_datawedge_method_channel.dart';
import 'package:zebra_wedge_scanner/zebra_datawedge_platform_interface.dart';

class _BasePlatform extends ZebraDataWedgePlatform {}

class _TestPlatform extends ZebraDataWedgePlatform {}

void main() {
  group('ZebraDataWedgePlatform', () {
    test('default instance is method channel platform', () {
      expect(ZebraDataWedgePlatform.instance, isA<MethodChannelZebraDataWedgePlatform>());
    });

    test('allows replacing instance with extending implementation', () {
      final ZebraDataWedgePlatform original = ZebraDataWedgePlatform.instance;
      final ZebraDataWedgePlatform replacement = _TestPlatform();

      ZebraDataWedgePlatform.instance = replacement;
      expect(ZebraDataWedgePlatform.instance, replacement);

      ZebraDataWedgePlatform.instance = original;
    });

    test('base methods throw unimplemented errors', () {
      final ZebraDataWedgePlatform platform = _BasePlatform();

      expect(() => platform.events, throwsA(isA<UnimplementedError>()));
      expect(() => platform.isDataWedgeAvailable(), throwsA(isA<UnimplementedError>()));
      expect(() => platform.configureProfile('P'), throwsA(isA<UnimplementedError>()));
      expect(() => platform.switchToProfile('P'), throwsA(isA<UnimplementedError>()));
      expect(() => platform.startSoftScan(), throwsA(isA<UnimplementedError>()));
      expect(() => platform.enableScanner(), throwsA(isA<UnimplementedError>()));
      expect(() => platform.disableScanner(), throwsA(isA<UnimplementedError>()));
      expect(
        () => platform.registerForNotification('SCANNER_STATUS'),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => platform.unregisterForNotification('SCANNER_STATUS'),
        throwsA(isA<UnimplementedError>()),
      );
      expect(() => platform.getActiveProfile(), throwsA(isA<UnimplementedError>()));
      expect(() => platform.getProfilesList(), throwsA(isA<UnimplementedError>()));
      expect(() => platform.getVersionInfo(), throwsA(isA<UnimplementedError>()));
      expect(() => platform.enumerateScanners(), throwsA(isA<UnimplementedError>()));
      expect(
        () => platform.sendCommand(command: 'CMD'),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => platform.sendCommandBundle(command: 'CMD', value: const <String, dynamic>{}),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => platform.sendIntent(extras: const <String, dynamic>{}),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
