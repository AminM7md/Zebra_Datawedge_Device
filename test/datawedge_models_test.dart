import 'package:flutter_test/flutter_test.dart';
import 'package:zebra_datawedge/zebra_datawedge.dart';

void main() {
  group('dataWedgeBool', () {
    test('returns true and false strings', () {
      expect(dataWedgeBool(true), 'true');
      expect(dataWedgeBool(false), 'false');
    });
  });

  group('DataWedgeEvent', () {
    test('maps known scan payload', () {
      final DataWedgeEvent event = DataWedgeEvent.fromMap(<String, dynamic>{
        'type': DataWedgeEventType.scan,
        'data': '123',
        'labelType': 'EAN13',
      });

      expect(event.type, DataWedgeEventType.scan);
      expect(event.isScan, isTrue);
      expect(event.isCommandResult, isFalse);
      expect(event.isNotification, isFalse);
      expect(event.scanData, '123');
      expect(event.labelType, 'EAN13');
    });

    test('falls back to unknown type and resolves command id aliases', () {
      final DataWedgeEvent event = DataWedgeEvent.fromMap(<String, dynamic>{
        DataWedgeApi.commandIdentifierKey: 'CMD-1',
      });

      expect(event.type, DataWedgeEventType.unknown);
      expect(event.commandIdentifier, 'CMD-1');
    });

    test('reads command result and notification helper fields', () {
      final DataWedgeEvent event = DataWedgeEvent.fromMap(<String, dynamic>{
        'type': DataWedgeEventType.commandResult,
        'command': DataWedgeApi.getProfilesList,
        'result': 'SUCCESS',
        'commandId': 'GET_PROFILES_LIST-1',
        'notificationType': DataWedgeNotificationType.scannerStatus,
        'status': 'WAITING',
      });

      expect(event.isCommandResult, isTrue);
      expect(event.command, DataWedgeApi.getProfilesList);
      expect(event.result, 'SUCCESS');
      expect(event.commandIdentifier, 'GET_PROFILES_LIST-1');
      expect(event.notificationType, DataWedgeNotificationType.scannerStatus);
      expect(event.scannerStatus, 'WAITING');
    });
  });

  group('toMap serializers', () {
    test('DataWedgeAppAssociation serializes package and activities', () {
      final DataWedgeAppAssociation association = DataWedgeAppAssociation(
        packageName: 'com.example.app',
        activityList: const <String>['MainActivity', '*'],
      );

      expect(association.toMap(), <String, dynamic>{
        DataWedgeApi.packageNameKey: 'com.example.app',
        DataWedgeApi.activityListKey: const <String>['MainActivity', '*'],
      });
    });

    test('DataWedgePluginConfiguration includes optional fields and extras', () {
      const DataWedgePluginConfiguration config = DataWedgePluginConfiguration(
        pluginName: DataWedgePluginName.intent,
        resetConfig: false,
        outputPluginName: DataWedgePluginName.keystroke,
        paramList: <String, dynamic>{'k': 'v'},
        extra: <String, dynamic>{'x': 1},
      );

      expect(config.toMap(), <String, dynamic>{
        DataWedgeApi.pluginNameKey: DataWedgePluginName.intent,
        DataWedgeApi.resetConfigKey: 'false',
        DataWedgeApi.outputPluginNameKey: DataWedgePluginName.keystroke,
        DataWedgeApi.paramListKey: const <String, dynamic>{'k': 'v'},
        'x': 1,
      });
    });

    test('DataWedgeProcessPluginRequest omits output plugin when null', () {
      const DataWedgeProcessPluginRequest request =
          DataWedgeProcessPluginRequest(pluginName: DataWedgePluginName.barcode);

      expect(request.toMap(), <String, dynamic>{
        DataWedgeApi.pluginNameKey: DataWedgePluginName.barcode,
      });
    });

    test('DataWedgeWorkflowConfiguration includes modules only when present', () {
      const DataWedgeWorkflowConfiguration withoutModules =
          DataWedgeWorkflowConfiguration(
        workflowName: DataWedgeWorkflowName.idScanning,
      );
      final Map<String, dynamic> baseMap = withoutModules.toMap();

      expect(baseMap['workflow_name'], DataWedgeWorkflowName.idScanning);
      expect(baseMap.containsKey('workflow_params'), isFalse);

      const DataWedgeWorkflowConfiguration withModules =
          DataWedgeWorkflowConfiguration(
        workflowName: DataWedgeWorkflowName.idScanning,
        modules: <DataWedgeWorkflowModule>[
          DataWedgeWorkflowModule(
            module: 'capture',
            moduleParams: <String, dynamic>{'resolution': 'high'},
          ),
        ],
      );

      expect(withModules.toMap()['workflow_params'], <Map<String, dynamic>>[
        <String, dynamic>{
          'module': 'capture',
          'module_params': <String, dynamic>{'resolution': 'high'},
        },
      ]);
    });

    test('DataWedgeProfileConfiguration serializes optional sections', () {
      const DataWedgeProfileConfiguration configuration =
          DataWedgeProfileConfiguration(
        profileName: 'PROFILE_A',
        configMode: DataWedgeConfigMode.overwrite,
        profileEnabled: true,
        resetConfig: false,
        pluginConfigurations: <DataWedgePluginConfiguration>[
          DataWedgePluginConfiguration(pluginName: DataWedgePluginName.barcode),
        ],
        appAssociations: <DataWedgeAppAssociation>[
          DataWedgeAppAssociation(packageName: 'com.example.app'),
        ],
        dataCapturePlus: <String, dynamic>{'enabled': true},
        enterpriseKeyboard: <String, dynamic>{'mode': 'standard'},
      );

      final Map<String, dynamic> map = configuration.toMap();
      expect(map[DataWedgeApi.profileNameKey], 'PROFILE_A');
      expect(map[DataWedgeApi.configModeKey], DataWedgeConfigMode.overwrite);
      expect(map[DataWedgeApi.profileEnabledKey], 'true');
      expect(map[DataWedgeApi.resetConfigKey], 'false');
      expect(map[DataWedgeApi.pluginConfigKey], hasLength(1));
      expect(map[DataWedgeApi.appListKey], hasLength(1));
      expect(map[DataWedgePluginName.dcp], const <String, dynamic>{'enabled': true});
      expect(
        map[DataWedgePluginName.ekb],
        const <String, dynamic>{'mode': 'standard'},
      );
    });

    test('DataWedgeProfileBuilder builds immutable plugin and app lists', () {
      final DataWedgeProfileConfiguration configuration = DataWedgeProfileBuilder(
        profileName: 'PROFILE_B',
      )
          .setProfileEnabled(true)
          .setResetConfig(false)
          .addPlugin(
            const DataWedgePluginConfiguration(
              pluginName: DataWedgePluginName.intent,
            ),
          )
          .addAppAssociation(
            const DataWedgeAppAssociation(packageName: 'com.example.app'),
          )
          .setDataCapturePlus(const <String, dynamic>{'enabled': true})
          .setEnterpriseKeyboard(const <String, dynamic>{'enabled': true})
          .build();

      expect(configuration.profileName, 'PROFILE_B');
      expect(configuration.profileEnabled, isTrue);
      expect(configuration.resetConfig, isFalse);
      expect(configuration.pluginConfigurations, hasLength(1));
      expect(configuration.appAssociations, hasLength(1));

      expect(
        () => configuration.pluginConfigurations.add(
          const DataWedgePluginConfiguration(pluginName: DataWedgePluginName.bdf),
        ),
        throwsUnsupportedError,
      );
      expect(
        () => configuration.appAssociations.add(
          const DataWedgeAppAssociation(packageName: 'other.package'),
        ),
        throwsUnsupportedError,
      );
    });

    test('DataWedgeExportConfigRequest includes profile only when not empty', () {
      const DataWedgeExportConfigRequest withoutProfile =
          DataWedgeExportConfigRequest(
        folderPath: '/tmp',
        exportType: DataWedgeExportType.fullConfig,
        profileName: '',
      );
      expect(withoutProfile.toMap().containsKey(DataWedgeApi.profileNameKey), isFalse);

      const DataWedgeExportConfigRequest withProfile = DataWedgeExportConfigRequest(
        folderPath: '/tmp',
        exportType: DataWedgeExportType.profileConfig,
        profileName: 'PROFILE_A',
      );
      expect(withProfile.toMap()[DataWedgeApi.profileNameKey], 'PROFILE_A');
    });

    test('DataWedgeImportConfigRequest includes file list only when non-empty', () {
      const DataWedgeImportConfigRequest withoutFiles = DataWedgeImportConfigRequest(
        folderPath: '/tmp',
        fileList: <String>[],
      );
      expect(withoutFiles.toMap().containsKey('FILE_LIST'), isFalse);

      const DataWedgeImportConfigRequest withFiles = DataWedgeImportConfigRequest(
        folderPath: '/tmp',
        fileList: <String>['a.db'],
      );
      expect(withFiles.toMap()['FILE_LIST'], const <String>['a.db']);
    });

    test('DataWedgeDisabledAppListRequest serializes app list', () {
      const DataWedgeDisabledAppListRequest request = DataWedgeDisabledAppListRequest(
        configMode: DataWedgeDisabledAppListMode.update,
        appList: <DataWedgeAppAssociation>[
          DataWedgeAppAssociation(packageName: 'com.example.app'),
        ],
      );

      expect(request.toMap(), <String, dynamic>{
        DataWedgeApi.configModeKey: DataWedgeDisabledAppListMode.update,
        DataWedgeApi.appListKey: <Map<String, dynamic>>[
          <String, dynamic>{
            DataWedgeApi.packageNameKey: 'com.example.app',
            DataWedgeApi.activityListKey: const <String>[DataWedgeApi.wildcard],
          },
        ],
      });
    });

    test('Scale, notification, and custom notification requests serialize payloads', () {
      const DataWedgeScaleRequest scaleRequest = DataWedgeScaleRequest(
        deviceIdentifier: DataWedgeScannerIdentifier.usbTgcsMp7000,
        command: DataWedgeScaleCommand.getWeight,
      );
      expect(scaleRequest.toMap(), <String, dynamic>{
        'SCALE_CONFIG': <String, dynamic>{
          'DEVICE_IDENTIFIER': DataWedgeScannerIdentifier.usbTgcsMp7000,
          'COMMAND': DataWedgeScaleCommand.getWeight,
        },
      });

      const DataWedgeNotificationRequest notificationRequest =
          DataWedgeNotificationRequest(
        deviceIdentifier: DataWedgeScannerIdentifier.bluetoothRs6000,
        notificationSettings: <int>[17, 47],
      );
      expect(notificationRequest.toMap(), <String, dynamic>{
        'NOTIFICATION_CONFIG': <String, dynamic>{
          'DEVICE_IDENTIFIER': DataWedgeScannerIdentifier.bluetoothRs6000,
          'NOTIFICATION_SETTINGS': const <int>[17, 47],
        },
      });

      const DataWedgeCustomNotificationRequest customRequest =
          DataWedgeCustomNotificationRequest(
        deviceIdentifier: DataWedgeScannerIdentifier.bluetoothRs6000,
        ledSettings: DataWedgeLedSettings(
          color: 0x00FF00,
          onTime: 10,
          offTime: 20,
          repeatCount: 3,
        ),
        beepSettings: <DataWedgeBeepSettings>[
          DataWedgeBeepSettings(
            frequency: 1000,
            onTime: 100,
            offTime: 100,
            repeatCount: 1,
          ),
        ],
        vibrationSettings: <DataWedgeVibrationSettings>[
          DataWedgeVibrationSettings(onTime: 50, offTime: 50, repeatCount: 2),
        ],
      );

      final Map<String, dynamic> customMap = customRequest.toMap();
      final Map<String, dynamic> notificationConfig =
          customMap['NOTIFICATION_CONFIG'] as Map<String, dynamic>;
      final Map<String, dynamic> settings =
          notificationConfig['NOTIFICATION_SETTINGS'] as Map<String, dynamic>;
      expect(notificationConfig['DEVICE_IDENTIFIER'], DataWedgeScannerIdentifier.bluetoothRs6000);
      expect(settings['LED_SETTINGS'], isA<Map<String, dynamic>>());
      expect(settings['BEEP_SETTINGS'], hasLength(1));
      expect(settings['VIBRATOR_SETTINGS'], hasLength(1));
    });

    test('simple settings models serialize to expected keys', () {
      const DataWedgeLedSettings led = DataWedgeLedSettings(
        color: 0xFF0000,
        onTime: 1,
        offTime: 2,
        repeatCount: 3,
      );
      expect(led.toMap(), <String, dynamic>{
        'COLOR': 0xFF0000,
        'ON_TIME': 1,
        'OFF_TIME': 2,
        'REPEAT_COUNT': 3,
      });

      const DataWedgeBeepSettings beep = DataWedgeBeepSettings(
        frequency: 440,
        onTime: 1,
        offTime: 2,
        repeatCount: 3,
      );
      expect(beep.toMap(), <String, dynamic>{
        'BEEP_FREQUENCY': 440,
        'ON_TIME': 1,
        'OFF_TIME': 2,
        'REPEAT_COUNT': 3,
      });

      const DataWedgeVibrationSettings vibration = DataWedgeVibrationSettings(
        onTime: 5,
        offTime: 6,
        repeatCount: 7,
      );
      expect(vibration.toMap(), <String, dynamic>{
        'ON_TIME': 5,
        'OFF_TIME': 6,
        'REPEAT_COUNT': 7,
      });
    });
  });
}
