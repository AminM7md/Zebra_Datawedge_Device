import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'zebra_datawedge_method_channel.dart';

abstract class ZebraDataWedgePlatform extends PlatformInterface {
  ZebraDataWedgePlatform() : super(token: _token);

  static final Object _token = Object();

  static ZebraDataWedgePlatform _instance = MethodChannelZebraDataWedgePlatform();

  static ZebraDataWedgePlatform get instance => _instance;

  static set instance(ZebraDataWedgePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<Map<String, dynamic>> get events {
    throw UnimplementedError('events has not been implemented.');
  }

  Future<bool> isDataWedgeAvailable() {
    throw UnimplementedError('isDataWedgeAvailable() has not been implemented.');
  }

  Future<void> configureProfile(String profileName) {
    throw UnimplementedError('configureProfile() has not been implemented.');
  }

  Future<void> switchToProfile(String profileName) {
    throw UnimplementedError('switchToProfile() has not been implemented.');
  }

  Future<void> startSoftScan() {
    throw UnimplementedError('startSoftScan() has not been implemented.');
  }

  Future<void> enableScanner() {
    throw UnimplementedError('enableScanner() has not been implemented.');
  }

  Future<void> disableScanner() {
    throw UnimplementedError('disableScanner() has not been implemented.');
  }

  Future<void> registerForNotification(String notificationType) {
    throw UnimplementedError('registerForNotification() has not been implemented.');
  }

  Future<void> unregisterForNotification(String notificationType) {
    throw UnimplementedError('unregisterForNotification() has not been implemented.');
  }

  Future<void> getActiveProfile() {
    throw UnimplementedError('getActiveProfile() has not been implemented.');
  }

  Future<void> getProfilesList() {
    throw UnimplementedError('getProfilesList() has not been implemented.');
  }

  Future<void> getVersionInfo() {
    throw UnimplementedError('getVersionInfo() has not been implemented.');
  }

  Future<void> enumerateScanners() {
    throw UnimplementedError('enumerateScanners() has not been implemented.');
  }

  Future<void> sendCommand({
    required String command,
    dynamic value,
    String? commandTag,
    bool requestResult = true,
  }) {
    throw UnimplementedError('sendCommand() has not been implemented.');
  }

  Future<void> sendCommandBundle({
    required String command,
    required Map<String, dynamic> value,
    String? commandTag,
    bool requestResult = true,
  }) {
    throw UnimplementedError('sendCommandBundle() has not been implemented.');
  }

  Future<void> sendIntent({
    required Map<String, dynamic> extras,
    String? action,
    String? targetPackage,
    String? commandTag,
    bool requestResult = true,
    bool orderedBroadcast = false,
    bool includeApplicationPackage = false,
  }) {
    throw UnimplementedError('sendIntent() has not been implemented.');
  }
}
