import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:zebra_scan_datawedge/zebra_datawedge.dart';
import 'package:zebra_scan_datawedge/zebra_datawedge_platform_interface.dart';

class _RecordedCall {
  _RecordedCall(this.name, this.arguments);

  final String name;
  final Map<String, Object?> arguments;
}

class _FakeZebraDataWedgePlatform extends ZebraDataWedgePlatform {
  final StreamController<Map<String, dynamic>> _eventController =
      StreamController<Map<String, dynamic>>.broadcast();

  final List<_RecordedCall> calls = <_RecordedCall>[];
  bool available = true;

  @override
  Stream<Map<String, dynamic>> get events => _eventController.stream;

  void emit(Map<String, dynamic> event) {
    _eventController.add(event);
  }

  void clearCalls() {
    calls.clear();
  }

  Future<void> dispose() async {
    await _eventController.close();
  }

  _RecordedCall get lastCall => calls.last;

  void _record(String name, [Map<String, Object?> arguments = const <String, Object?>{}]) {
    calls.add(_RecordedCall(name, Map<String, Object?>.from(arguments)));
  }

  @override
  Future<bool> isDataWedgeAvailable() async {
    _record('isDataWedgeAvailable');
    return available;
  }

  @override
  Future<void> configureProfile(String profileName) async {
    _record('configureProfile', <String, Object?>{'profileName': profileName});
  }

  @override
  Future<void> switchToProfile(String profileName) async {
    _record('switchToProfile', <String, Object?>{'profileName': profileName});
  }

  @override
  Future<void> startSoftScan() async {
    _record('startSoftScan');
  }

  @override
  Future<void> enableScanner() async {
    _record('enableScanner');
  }

  @override
  Future<void> disableScanner() async {
    _record('disableScanner');
  }

  @override
  Future<void> registerForNotification(String notificationType) async {
    _record(
      'registerForNotification',
      <String, Object?>{'notificationType': notificationType},
    );
  }

  @override
  Future<void> unregisterForNotification(String notificationType) async {
    _record(
      'unregisterForNotification',
      <String, Object?>{'notificationType': notificationType},
    );
  }

  @override
  Future<void> getActiveProfile() async {
    _record('getActiveProfile');
  }

  @override
  Future<void> getProfilesList() async {
    _record('getProfilesList');
  }

  @override
  Future<void> getVersionInfo() async {
    _record('getVersionInfo');
  }

  @override
  Future<void> enumerateScanners() async {
    _record('enumerateScanners');
  }

  @override
  Future<void> sendCommand({
    required String command,
    Object? value,
    String? commandTag,
    bool requestResult = true,
  }) async {
    _record('sendCommand', <String, Object?>{
      'command': command,
      'value': value,
      'commandTag': commandTag,
      'requestResult': requestResult,
    });
  }

  @override
  Future<void> sendCommandBundle({
    required String command,
    required Map<String, dynamic> value,
    String? commandTag,
    bool requestResult = true,
  }) async {
    _record('sendCommandBundle', <String, Object?>{
      'command': command,
      'value': value,
      'commandTag': commandTag,
      'requestResult': requestResult,
    });
  }

  @override
  Future<void> sendIntent({
    required Map<String, dynamic> extras,
    String? action,
    String? targetPackage,
    String? commandTag,
    bool requestResult = true,
    bool orderedBroadcast = false,
    bool includeApplicationPackage = false,
  }) async {
    _record('sendIntent', <String, Object?>{
      'extras': extras,
      'action': action,
      'targetPackage': targetPackage,
      'commandTag': commandTag,
      'requestResult': requestResult,
      'orderedBroadcast': orderedBroadcast,
      'includeApplicationPackage': includeApplicationPackage,
    });
  }
}

void main() {
  late _FakeZebraDataWedgePlatform platform;
  late ZebraDataWedge dataWedge;

  setUp(() {
    platform = _FakeZebraDataWedgePlatform();
    dataWedge = ZebraDataWedge(platform: platform);
  });

  tearDown(() async {
    await platform.dispose();
  });

  group('streams and direct delegations', () {
    test('scanStream emits raw payloads from platform events', () async {
      final Future<Map<String, dynamic>> firstEvent = dataWedge.scanStream.first;
      platform.emit(<String, dynamic>{'type': 'scan', 'data': 'ABC'});

      expect(await firstEvent, <String, dynamic>{'type': 'scan', 'data': 'ABC'});
    });

    test('events maps payloads into DataWedgeEvent objects', () async {
      final Future<DataWedgeEvent> firstEvent = dataWedge.events.first;
      platform.emit(<String, dynamic>{
        'type': DataWedgeEventType.scan,
        'data': '12345',
      });

      final DataWedgeEvent event = await firstEvent;
      expect(event.isScan, isTrue);
      expect(event.scanData, '12345');
    });

    test('delegates simple API calls directly to platform', () async {
      await dataWedge.isAvailable();
      await dataWedge.configureProfile('PROFILE_A');
      await dataWedge.switchToProfile('PROFILE_A');
      await dataWedge.startSoftScan();
      await dataWedge.enableScanner();
      await dataWedge.disableScanner();
      await dataWedge.registerForNotification(DataWedgeNotificationType.scannerStatus);
      await dataWedge.unregisterForNotification(
        DataWedgeNotificationType.scannerStatus,
      );
      await dataWedge.getActiveProfile();
      await dataWedge.getProfilesList();
      await dataWedge.getVersionInfo();
      await dataWedge.enumerateScanners();

      expect(platform.calls.map((c) => c.name), <String>[
        'isDataWedgeAvailable',
        'configureProfile',
        'switchToProfile',
        'startSoftScan',
        'enableScanner',
        'disableScanner',
        'registerForNotification',
        'unregisterForNotification',
        'getActiveProfile',
        'getProfilesList',
        'getVersionInfo',
        'enumerateScanners',
      ]);
    });
  });

  group('profile and config wrappers', () {
    test('stopSoftScan and toggleSoftScan send expected commands', () async {
      await dataWedge.stopSoftScan();
      expect(platform.lastCall.name, 'sendCommand');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.softScanTrigger);
      expect(platform.lastCall.arguments['value'], DataWedgeSoftScanAction.stop);
      expect(platform.lastCall.arguments['commandTag'], 'SOFT_SCAN_STOP');

      await dataWedge.toggleSoftScan();
      expect(platform.lastCall.name, 'sendCommand');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.softScanTrigger);
      expect(platform.lastCall.arguments['value'], DataWedgeSoftScanAction.toggle);
      expect(platform.lastCall.arguments['commandTag'], 'SOFT_SCAN_TOGGLE');
    });

    test('create, clone, rename, delete profile commands use expected payloads', () async {
      await dataWedge.createProfile('PROFILE_A');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.createProfile);
      expect(platform.lastCall.arguments['value'], 'PROFILE_A');
      expect(platform.lastCall.arguments['commandTag'], 'CREATE_PROFILE_PROFILE_A');

      await dataWedge.cloneProfile(
        sourceProfileName: 'SOURCE',
        destinationProfileName: 'DEST',
      );
      expect(platform.lastCall.arguments['command'], DataWedgeApi.cloneProfile);
      expect(platform.lastCall.arguments['value'], <String>['SOURCE', 'DEST']);
      expect(platform.lastCall.arguments['commandTag'], 'CLONE_PROFILE_DEST');

      await dataWedge.renameProfile(profileName: 'OLD', newProfileName: 'NEW');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.renameProfile);
      expect(platform.lastCall.arguments['value'], <String>['OLD', 'NEW']);
      expect(platform.lastCall.arguments['commandTag'], 'RENAME_PROFILE_NEW');

      await dataWedge.deleteProfiles(<String>['A', 'B']);
      expect(platform.lastCall.arguments['command'], DataWedgeApi.deleteProfile);
      expect(platform.lastCall.arguments['value'], <String>['A', 'B']);
      expect(platform.lastCall.arguments['commandTag'], 'DELETE_PROFILE');

      await dataWedge.deleteAllDeletableProfiles();
      expect(platform.lastCall.arguments['command'], DataWedgeApi.deleteProfile);
      expect(platform.lastCall.arguments['value'], <String>[DataWedgeApi.wildcard]);
      expect(platform.lastCall.arguments['commandTag'], 'DELETE_ALL_PROFILES');
    });

    test('setConfig and applyProfileConfiguration send bundle payloads', () async {
      const DataWedgeProfileConfiguration configuration = DataWedgeProfileConfiguration(
        profileName: 'PROFILE_A',
      );

      await dataWedge.setConfig(configuration);
      expect(platform.lastCall.name, 'sendCommandBundle');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.setConfig);
      expect(platform.lastCall.arguments['commandTag'], 'SET_CONFIG_PROFILE_A');

      await dataWedge.applyProfileConfiguration(
        configuration,
        commandTag: 'CUSTOM_TAG',
        requestResult: false,
      );
      expect(platform.lastCall.name, 'sendCommandBundle');
      expect(platform.lastCall.arguments['commandTag'], 'CUSTOM_TAG');
      expect(platform.lastCall.arguments['requestResult'], isFalse);
    });

    test('configureClassicBarcodeProfile builds full profile and notifications', () async {
      await dataWedge.configureClassicBarcodeProfile(
        profileName: 'WAREHOUSE_PROFILE',
        packageName: 'com.example.app',
      );

      expect(platform.calls.first.name, 'sendCommandBundle');
      expect(platform.calls.first.arguments['command'], DataWedgeApi.setConfig);
      expect(platform.calls.first.arguments['commandTag'], 'SET_CONFIG_WAREHOUSE_PROFILE');

      final Map<String, dynamic> configMap =
          platform.calls.first.arguments['value']! as Map<String, dynamic>;
      final List<dynamic> plugins = configMap[DataWedgeApi.pluginConfigKey] as List<dynamic>;
      expect(configMap[DataWedgeApi.profileNameKey], 'WAREHOUSE_PROFILE');
      expect(configMap[DataWedgeApi.profileEnabledKey], 'true');
      expect(plugins, hasLength(3));
      expect(
        (plugins[1] as Map<String, dynamic>)[DataWedgeApi.pluginNameKey],
        DataWedgePluginName.intent,
      );

      final List<String> notificationCalls = platform.calls
          .where((c) => c.name == 'registerForNotification')
          .map((c) => c.arguments['notificationType']! as String)
          .toList();

      expect(notificationCalls, <String>[
        DataWedgeNotificationType.scannerStatus,
        DataWedgeNotificationType.profileSwitch,
        DataWedgeNotificationType.configurationUpdate,
        DataWedgeNotificationType.workflowStatus,
      ]);
    });

    test('configureClassicBarcodeProfile can skip default notifications', () async {
      await dataWedge.configureClassicBarcodeProfile(
        profileName: 'NO_NOTIFICATIONS',
        packageName: 'com.example.app',
        registerDefaultNotifications: false,
      );

      expect(platform.calls.where((c) => c.name == 'sendCommandBundle'), hasLength(1));
      expect(platform.calls.where((c) => c.name == 'registerForNotification'), isEmpty);
    });

    test('getConfig builds query payload for defaults and extended options', () async {
      await dataWedge.getConfig(profileName: 'PROFILE_A');
      expect(platform.lastCall.name, 'sendCommandBundle');

      final Map<String, dynamic> defaultValue =
          platform.lastCall.arguments['value']! as Map<String, dynamic>;
      expect(defaultValue, <String, dynamic>{DataWedgeApi.profileNameKey: 'PROFILE_A'});
      expect(platform.lastCall.arguments['commandTag'], 'GET_CONFIG_PROFILE_A');

      await dataWedge.getConfig(
        profileName: 'PROFILE_B',
        pluginNames: const <String>[DataWedgePluginName.barcode],
        processPlugins: const <DataWedgeProcessPluginRequest>[
          DataWedgeProcessPluginRequest(
            pluginName: DataWedgePluginName.intent,
            outputPluginName: DataWedgePluginName.keystroke,
          ),
        ],
        includeAppList: true,
        includeDataCapturePlus: true,
        includeEnterpriseKeyboard: true,
        scannerSelectionByIdentifier: DataWedgeScannerIdentifier.internalImager,
      );

      final Map<String, dynamic> extendedValue =
          platform.lastCall.arguments['value']! as Map<String, dynamic>;
      final Map<String, dynamic> pluginConfig =
          extendedValue[DataWedgeApi.pluginConfigKey] as Map<String, dynamic>;
      expect(pluginConfig[DataWedgeApi.pluginNameKey], DataWedgePluginName.barcode);
      expect(pluginConfig[DataWedgeApi.processPluginNameKey], hasLength(1));
      expect(extendedValue[DataWedgeApi.appListKey], '');
      expect(extendedValue[DataWedgePluginName.dcp], '');
      expect(extendedValue[DataWedgePluginName.ekb], '');
      expect(
        extendedValue[DataWedgeApi.scannerSelectionByIdentifier],
        DataWedgeScannerIdentifier.internalImager,
      );

      await dataWedge.getConfig(
        profileName: 'PROFILE_C',
        pluginNames: const <String>[
          DataWedgePluginName.barcode,
          DataWedgePluginName.intent,
        ],
      );
      final Map<String, dynamic> multiPluginValue =
          platform.lastCall.arguments['value']! as Map<String, dynamic>;
      final Map<String, dynamic> multiPluginConfig =
          multiPluginValue[DataWedgeApi.pluginConfigKey] as Map<String, dynamic>;
      expect(multiPluginConfig[DataWedgeApi.pluginNameKey], <String>[
        DataWedgePluginName.barcode,
        DataWedgePluginName.intent,
      ]);
    });
  });

  group('query and runtime wrappers', () {
    test('query helpers send empty-value commands with expected tags', () async {
      await dataWedge.getDisabledAppList();
      expect(platform.lastCall.arguments['command'], DataWedgeApi.getDisabledAppList);
      expect(platform.lastCall.arguments['value'], '');
      expect(platform.lastCall.arguments['commandTag'], 'GET_DISABLED_APP_LIST');

      await dataWedge.getIgnoreDisabledProfiles();
      expect(platform.lastCall.arguments['command'], DataWedgeApi.getIgnoreDisabledProfiles);
      expect(platform.lastCall.arguments['value'], '');
      expect(platform.lastCall.arguments['commandTag'], 'GET_IGNORE_DISABLED_PROFILES');

      await dataWedge.getDataWedgeStatus();
      expect(platform.lastCall.arguments['command'], DataWedgeApi.getDataWedgeStatus);
      expect(platform.lastCall.arguments['commandTag'], 'GET_DATAWEDGE_STATUS');

      await dataWedge.getScannerStatus();
      expect(platform.lastCall.arguments['command'], DataWedgeApi.getScannerStatus);
      expect(platform.lastCall.arguments['commandTag'], 'GET_SCANNER_STATUS');

      await dataWedge.enumerateTriggers();
      expect(platform.lastCall.arguments['command'], DataWedgeApi.enumerateTriggers);
      expect(platform.lastCall.arguments['commandTag'], 'ENUMERATE_TRIGGERS');

      await dataWedge.enumerateWorkflows();
      expect(platform.lastCall.arguments['command'], DataWedgeApi.enumerateWorkflows);
      expect(platform.lastCall.arguments['commandTag'], 'ENUMERATE_WORKFLOWS');
    });

    test('default profile and import/export wrappers send expected payloads', () async {
      await dataWedge.setDefaultProfile('PROFILE_A');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.setDefaultProfile);
      expect(platform.lastCall.arguments['value'], 'PROFILE_A');
      expect(platform.lastCall.arguments['commandTag'], 'SET_DEFAULT_PROFILE_PROFILE_A');

      await dataWedge.resetDefaultProfile();
      expect(platform.lastCall.arguments['command'], DataWedgeApi.resetDefaultProfile);
      expect(platform.lastCall.arguments['value'], '');
      expect(platform.lastCall.arguments['commandTag'], 'RESET_DEFAULT_PROFILE');

      await dataWedge.importConfig(
        const DataWedgeImportConfigRequest(folderPath: '/tmp', fileList: <String>['a.db']),
      );
      expect(platform.lastCall.name, 'sendCommandBundle');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.importConfig);
      expect(platform.lastCall.arguments['commandTag'], 'IMPORT_CONFIG');

      await dataWedge.exportConfig(
        const DataWedgeExportConfigRequest(
          folderPath: '/tmp',
          exportType: DataWedgeExportType.fullConfig,
        ),
      );
      expect(platform.lastCall.name, 'sendCommandBundle');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.exportConfig);
      expect(platform.lastCall.arguments['commandTag'], 'EXPORT_CONFIG');
    });

    test('disabled app and ignore-disabled settings wrappers serialize values', () async {
      await dataWedge.setDisabledAppList(
        const DataWedgeDisabledAppListRequest(
          configMode: DataWedgeDisabledAppListMode.overwrite,
        ),
      );
      expect(platform.lastCall.name, 'sendCommandBundle');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.setDisabledAppList);
      expect(platform.lastCall.arguments['commandTag'], 'SET_DISABLED_APP_LIST');

      await dataWedge.setIgnoreDisabledProfiles(true);
      expect(platform.lastCall.name, 'sendCommand');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.setIgnoreDisabledProfiles);
      expect(platform.lastCall.arguments['value'], 'true');

      await dataWedge.setIgnoreDisabledProfiles(false);
      expect(platform.lastCall.arguments['value'], 'false');
    });

    test('setDataWedgeEnabled uses dynamic default command tags', () async {
      await dataWedge.setDataWedgeEnabled(true);
      expect(platform.lastCall.arguments['command'], DataWedgeApi.enableDataWedge);
      expect(platform.lastCall.arguments['value'], isTrue);
      expect(platform.lastCall.arguments['commandTag'], 'ENABLE_DATAWEDGE');

      await dataWedge.setDataWedgeEnabled(false);
      expect(platform.lastCall.arguments['commandTag'], 'DISABLE_DATAWEDGE');
    });

    test('soft scan, rfid, voice, and scanner input wrappers route correctly', () async {
      await dataWedge.softScanTrigger(action: DataWedgeSoftScanAction.start);
      expect(platform.lastCall.name, 'sendCommand');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.softScanTrigger);
      expect(platform.lastCall.arguments['value'], DataWedgeSoftScanAction.start);

      await dataWedge.softScanTrigger(
        action: DataWedgeSoftScanAction.toggle,
        scannerSelectionByIdentifier: DataWedgeScannerIdentifier.bluetoothRs6000,
      );
      expect(platform.lastCall.name, 'sendIntent');
      final Map<String, dynamic> softScanExtras =
          platform.lastCall.arguments['extras']! as Map<String, dynamic>;
      expect(
        softScanExtras[DataWedgeApi.scannerSelectionByIdentifier],
        DataWedgeScannerIdentifier.bluetoothRs6000,
      );
      expect(softScanExtras[DataWedgeApi.softScanTrigger], DataWedgeSoftScanAction.toggle);
      expect(platform.lastCall.arguments['targetPackage'], DataWedgeApi.dataWedgePackage);

      await dataWedge.softRfidTrigger(action: DataWedgeSoftTriggerAction.start);
      expect(platform.lastCall.name, 'sendCommand');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.softRfidTrigger);
      expect(platform.lastCall.arguments['value'], DataWedgeSoftTriggerAction.start);

      await dataWedge.softVoiceTrigger(action: DataWedgeSoftTriggerAction.stop);
      expect(platform.lastCall.name, 'sendIntent');
      final Map<String, dynamic> voiceExtras =
          platform.lastCall.arguments['extras']! as Map<String, dynamic>;
      expect(voiceExtras[DataWedgeApi.pluginNameKey], DataWedgePluginName.voice);
      expect(voiceExtras[DataWedgeApi.softTrigger], DataWedgeSoftTriggerAction.stop);

      await dataWedge.scannerInputPlugin(DataWedgeScannerInputAction.disablePlugin);
      expect(platform.lastCall.name, 'sendCommand');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.scannerInputPlugin);
      expect(platform.lastCall.arguments['value'], DataWedgeScannerInputAction.disablePlugin);

      await dataWedge.suspendScanner();
      expect(platform.lastCall.arguments['value'], DataWedgeScannerInputAction.suspendPlugin);
      expect(platform.lastCall.arguments['commandTag'], 'SUSPEND_SCANNER_PLUGIN');

      await dataWedge.resumeScanner();
      expect(platform.lastCall.arguments['value'], DataWedgeScannerInputAction.resumePlugin);
      expect(platform.lastCall.arguments['commandTag'], 'RESUME_SCANNER_PLUGIN');
    });

    test('scanner switching wrappers serialize identifiers and params', () async {
      await dataWedge.switchScannerByIndex(3);
      expect(platform.lastCall.name, 'sendCommand');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.switchScanner);
      expect(platform.lastCall.arguments['value'], '3');
      expect(platform.lastCall.arguments['commandTag'], 'SWITCH_SCANNER_INDEX_3');

      await dataWedge.switchScannerByIdentifier(DataWedgeScannerIdentifier.internalImager);
      expect(platform.lastCall.arguments['command'], DataWedgeApi.switchScannerEx);
      expect(platform.lastCall.arguments['value'], DataWedgeScannerIdentifier.internalImager);

      await dataWedge.switchScannerParams(
        parameters: const <String, dynamic>{'illumination_mode': 'off'},
      );
      expect(platform.lastCall.name, 'sendIntent');
      Map<String, dynamic> extras =
          platform.lastCall.arguments['extras']! as Map<String, dynamic>;
      expect(extras.containsKey(DataWedgeApi.scannerSelectionByIdentifier), isFalse);
      expect(extras[DataWedgeApi.switchScannerParams], const <String, dynamic>{
        'illumination_mode': 'off',
      });

      await dataWedge.switchScannerParams(
        parameters: const <String, dynamic>{'decode_audio_feedback_uri': 'Heaven'},
        scannerSelectionByIdentifier: DataWedgeScannerIdentifier.bluetoothRs6000,
      );
      extras = platform.lastCall.arguments['extras']! as Map<String, dynamic>;
      expect(
        extras[DataWedgeApi.scannerSelectionByIdentifier],
        DataWedgeScannerIdentifier.bluetoothRs6000,
      );
    });

    test('switchDataCapture forwards includeApplicationPackage and optional params', () async {
      await dataWedge.switchDataCapture(targetPlugin: DataWedgeSwitchDataCaptureTarget.workflow);
      expect(platform.lastCall.name, 'sendIntent');
      expect(platform.lastCall.arguments['includeApplicationPackage'], isTrue);

      final Map<String, dynamic> withoutParams =
          platform.lastCall.arguments['extras']! as Map<String, dynamic>;
      expect(withoutParams[DataWedgeApi.switchDataCapture], DataWedgeSwitchDataCaptureTarget.workflow);
      expect(withoutParams.containsKey(DataWedgeApi.paramListKey), isFalse);

      await dataWedge.switchDataCapture(
        targetPlugin: DataWedgeSwitchDataCaptureTarget.workflow,
        paramList: const <String, dynamic>{'workflow_name': DataWedgeWorkflowName.idScanning},
        includeApplicationPackage: false,
      );

      expect(platform.lastCall.arguments['includeApplicationPackage'], isFalse);
      final Map<String, dynamic> withParams =
          platform.lastCall.arguments['extras']! as Map<String, dynamic>;
      expect(withParams[DataWedgeApi.paramListKey], const <String, dynamic>{
        'workflow_name': DataWedgeWorkflowName.idScanning,
      });
    });
  });

  group('notification and generic APIs', () {
    test('registerForDefaultNotifications requests all default notification types', () async {
      await dataWedge.registerForDefaultNotifications();

      final List<String> requested = platform.calls
          .where((c) => c.name == 'registerForNotification')
          .map((c) => c.arguments['notificationType']! as String)
          .toList();

      expect(requested, <String>[
        DataWedgeNotificationType.scannerStatus,
        DataWedgeNotificationType.profileSwitch,
        DataWedgeNotificationType.configurationUpdate,
        DataWedgeNotificationType.workflowStatus,
      ]);
    });

    test('weight and scale APIs send SCALE bundle payloads', () async {
      await dataWedge.getWeight();
      expect(platform.lastCall.name, 'sendCommandBundle');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.scale);

      Map<String, dynamic> value = platform.lastCall.arguments['value']! as Map<String, dynamic>;
      Map<String, dynamic> scaleConfig = value['SCALE_CONFIG'] as Map<String, dynamic>;
      expect(scaleConfig['COMMAND'], DataWedgeScaleCommand.getWeight);

      await dataWedge.setScaleToZero(deviceIdentifier: DataWedgeScannerIdentifier.usbZebra);
      value = platform.lastCall.arguments['value']! as Map<String, dynamic>;
      scaleConfig = value['SCALE_CONFIG'] as Map<String, dynamic>;
      expect(scaleConfig['DEVICE_IDENTIFIER'], DataWedgeScannerIdentifier.usbZebra);
      expect(scaleConfig['COMMAND'], DataWedgeScaleCommand.setScaleToZero);
    });

    test('notify wrappers send notification bundle commands', () async {
      await dataWedge.notifyBluetoothScanner(
        const DataWedgeNotificationRequest(
          deviceIdentifier: DataWedgeScannerIdentifier.bluetoothRs6000,
          notificationSettings: <int>[1, 2],
        ),
      );
      expect(platform.lastCall.name, 'sendCommandBundle');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.notify);
      expect(platform.lastCall.arguments['commandTag'], 'NOTIFY_SCANNER');

      await dataWedge.customNotifyBluetoothScanner(
        const DataWedgeCustomNotificationRequest(
          deviceIdentifier: DataWedgeScannerIdentifier.bluetoothRs6000,
          beepSettings: <DataWedgeBeepSettings>[
            DataWedgeBeepSettings(
              frequency: 1000,
              onTime: 50,
              offTime: 50,
              repeatCount: 2,
            ),
          ],
        ),
      );
      expect(platform.lastCall.name, 'sendCommandBundle');
      expect(platform.lastCall.arguments['command'], DataWedgeApi.notify);
      expect(platform.lastCall.arguments['commandTag'], 'CUSTOM_NOTIFY_SCANNER');
    });

    test('generic command wrappers pass through parameters unchanged', () async {
      await dataWedge.sendCommand(
        command: 'CUSTOM_COMMAND',
        value: 123,
        commandTag: 'TAG_A',
        requestResult: false,
      );
      expect(platform.lastCall.name, 'sendCommand');
      expect(platform.lastCall.arguments, <String, Object?>{
        'command': 'CUSTOM_COMMAND',
        'value': 123,
        'commandTag': 'TAG_A',
        'requestResult': false,
      });

      await dataWedge.sendCommandBundle(
        command: 'CUSTOM_BUNDLE',
        value: const <String, dynamic>{'x': 'y'},
        commandTag: 'TAG_B',
        requestResult: false,
      );
      expect(platform.lastCall.name, 'sendCommandBundle');
      expect(platform.lastCall.arguments['command'], 'CUSTOM_BUNDLE');
      expect(platform.lastCall.arguments['value'], const <String, dynamic>{'x': 'y'});
      expect(platform.lastCall.arguments['commandTag'], 'TAG_B');
      expect(platform.lastCall.arguments['requestResult'], isFalse);

      await dataWedge.sendIntent(
        extras: const <String, dynamic>{'k': 'v'},
        action: 'CUSTOM_ACTION',
        targetPackage: 'com.target.app',
        commandTag: 'TAG_C',
        requestResult: false,
        orderedBroadcast: true,
        includeApplicationPackage: true,
      );
      expect(platform.lastCall.name, 'sendIntent');
      expect(platform.lastCall.arguments, <String, Object?>{
        'extras': const <String, dynamic>{'k': 'v'},
        'action': 'CUSTOM_ACTION',
        'targetPackage': 'com.target.app',
        'commandTag': 'TAG_C',
        'requestResult': false,
        'orderedBroadcast': true,
        'includeApplicationPackage': true,
      });
    });
  });
}
