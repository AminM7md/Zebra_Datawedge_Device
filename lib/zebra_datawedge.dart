import 'src/models/datawedge_models.dart';
import 'zebra_datawedge_platform_interface.dart';

export 'src/models/datawedge_models.dart';

class ZebraDataWedge {
  ZebraDataWedge({ZebraDataWedgePlatform? platform})
      : _platform = platform ?? ZebraDataWedgePlatform.instance;

  final ZebraDataWedgePlatform _platform;

  Stream<Map<String, dynamic>> get scanStream => _platform.events;

  Stream<DataWedgeEvent> get events {
    return _platform.events.map<DataWedgeEvent>(DataWedgeEvent.fromMap);
  }

  Future<bool> isAvailable() {
    return _platform.isDataWedgeAvailable();
  }

  Future<void> configureProfile(String profileName) {
    return _platform.configureProfile(profileName);
  }

  Future<void> switchToProfile(String profileName) {
    return _platform.switchToProfile(profileName);
  }

  Future<void> startSoftScan() {
    return _platform.startSoftScan();
  }

  Future<void> stopSoftScan() {
    return sendCommand(
      command: DataWedgeApi.softScanTrigger,
      value: DataWedgeSoftScanAction.stop,
      commandTag: 'SOFT_SCAN_STOP',
    );
  }

  Future<void> toggleSoftScan() {
    return sendCommand(
      command: DataWedgeApi.softScanTrigger,
      value: DataWedgeSoftScanAction.toggle,
      commandTag: 'SOFT_SCAN_TOGGLE',
    );
  }

  Future<void> enableScanner() {
    return _platform.enableScanner();
  }

  Future<void> disableScanner() {
    return _platform.disableScanner();
  }

  Future<void> registerForNotification(String notificationType) {
    return _platform.registerForNotification(notificationType);
  }

  Future<void> unregisterForNotification(String notificationType) {
    return _platform.unregisterForNotification(notificationType);
  }

  Future<void> getActiveProfile() {
    return _platform.getActiveProfile();
  }

  Future<void> getProfilesList() {
    return _platform.getProfilesList();
  }

  Future<void> getVersionInfo() {
    return _platform.getVersionInfo();
  }

  Future<void> enumerateScanners() {
    return _platform.enumerateScanners();
  }

  Future<void> createProfile(
    String profileName, {
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommand(
      command: DataWedgeApi.createProfile,
      value: profileName,
      commandTag: commandTag ?? 'CREATE_PROFILE_$profileName',
      requestResult: requestResult,
    );
  }

  Future<void> cloneProfile({
    required String sourceProfileName,
    required String destinationProfileName,
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommand(
      command: DataWedgeApi.cloneProfile,
      value: <String>[sourceProfileName, destinationProfileName],
      commandTag: commandTag ?? 'CLONE_PROFILE_$destinationProfileName',
      requestResult: requestResult,
    );
  }

  Future<void> renameProfile({
    required String profileName,
    required String newProfileName,
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommand(
      command: DataWedgeApi.renameProfile,
      value: <String>[profileName, newProfileName],
      commandTag: commandTag ?? 'RENAME_PROFILE_$newProfileName',
      requestResult: requestResult,
    );
  }

  Future<void> deleteProfiles(
    List<String> profileNames, {
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommand(
      command: DataWedgeApi.deleteProfile,
      value: profileNames,
      commandTag: commandTag ?? 'DELETE_PROFILE',
      requestResult: requestResult,
    );
  }

  Future<void> deleteAllDeletableProfiles({
    String? commandTag,
    bool requestResult = true,
  }) {
    return deleteProfiles(
      const <String>[DataWedgeApi.wildcard],
      commandTag: commandTag ?? 'DELETE_ALL_PROFILES',
      requestResult: requestResult,
    );
  }

  Future<void> setConfig(
    DataWedgeProfileConfiguration configuration, {
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommandBundle(
      command: DataWedgeApi.setConfig,
      value: configuration.toMap(),
      commandTag: commandTag ?? 'SET_CONFIG_${configuration.profileName}',
      requestResult: requestResult,
    );
  }

  Future<void> applyProfileConfiguration(
    DataWedgeProfileConfiguration configuration, {
    String? commandTag,
    bool requestResult = true,
  }) {
    return setConfig(
      configuration,
      commandTag: commandTag,
      requestResult: requestResult,
    );
  }

  Future<void> configureClassicBarcodeProfile({
    required String profileName,
    required String packageName,
    List<String> activityList = const <String>[DataWedgeApi.wildcard],
    String? intentAction,
    String intentCategory = DataWedgeApi.defaultIntentCategory,
    int intentDelivery = DataWedgeIntentDelivery.broadcast,
    bool registerDefaultNotifications = true,
    bool requestResult = true,
  }) async {
    final String resolvedIntentAction = intentAction ?? '$packageName.SCAN';

    final DataWedgeProfileConfiguration configuration =
        DataWedgeProfileBuilder(
      profileName: profileName,
      configMode: DataWedgeConfigMode.createIfNotExist,
    )
            .setProfileEnabled(true)
            .addPlugin(
              DataWedgePluginConfiguration(
                pluginName: DataWedgePluginName.barcode,
                resetConfig: true,
                paramList: <String, dynamic>{
                  'scanner_selection': 'auto',
                  'scanner_selection_by_identifier': DataWedgeScannerIdentifier.auto,
                  'scanner_input_enabled': dataWedgeBool(true),
                },
              ),
            )
            .addPlugin(
              DataWedgePluginConfiguration(
                pluginName: DataWedgePluginName.intent,
                resetConfig: true,
                paramList: <String, dynamic>{
                  'intent_output_enabled': dataWedgeBool(true),
                  'intent_action': resolvedIntentAction,
                  'intent_category': intentCategory,
                  'intent_delivery': intentDelivery,
                },
              ),
            )
            .addPlugin(
              DataWedgePluginConfiguration(
                pluginName: DataWedgePluginName.keystroke,
                resetConfig: true,
                paramList: <String, dynamic>{
                  'keystroke_output_enabled': dataWedgeBool(false),
                },
              ),
            )
            .addAppAssociation(
              DataWedgeAppAssociation(
                packageName: packageName,
                activityList: activityList,
              ),
            )
            .build();

    await setConfig(
      configuration,
      commandTag: 'SET_CONFIG_$profileName',
      requestResult: requestResult,
    );

    if (registerDefaultNotifications) {
      await registerForDefaultNotifications();
    }
  }

  Future<void> getConfig({
    required String profileName,
    List<String>? pluginNames,
    List<DataWedgeProcessPluginRequest>? processPlugins,
    bool includeAppList = false,
    bool includeDataCapturePlus = false,
    bool includeEnterpriseKeyboard = false,
    String? scannerSelectionByIdentifier,
    String? commandTag,
    bool requestResult = true,
  }) {
    final Map<String, dynamic> value = <String, dynamic>{
      DataWedgeApi.profileNameKey: profileName,
    };

    if ((pluginNames != null && pluginNames.isNotEmpty) ||
        (processPlugins != null && processPlugins.isNotEmpty)) {
      final Map<String, dynamic> pluginConfig = <String, dynamic>{};

      if (pluginNames != null && pluginNames.isNotEmpty) {
        pluginConfig[DataWedgeApi.pluginNameKey] =
            pluginNames.length == 1 ? pluginNames.first : pluginNames;
      }

      if (processPlugins != null && processPlugins.isNotEmpty) {
        pluginConfig[DataWedgeApi.processPluginNameKey] =
            processPlugins.map<Map<String, dynamic>>((
          DataWedgeProcessPluginRequest processPlugin,
        ) {
          return processPlugin.toMap();
        }).toList();
      }

      value[DataWedgeApi.pluginConfigKey] = pluginConfig;
    }

    if (includeAppList) {
      value[DataWedgeApi.appListKey] = '';
    }
    if (includeDataCapturePlus) {
      value[DataWedgePluginName.dcp] = '';
    }
    if (includeEnterpriseKeyboard) {
      value[DataWedgePluginName.ekb] = '';
    }
    if (scannerSelectionByIdentifier != null &&
        scannerSelectionByIdentifier.isNotEmpty) {
      value[DataWedgeApi.scannerSelectionByIdentifier] =
          scannerSelectionByIdentifier;
    }

    return sendCommandBundle(
      command: DataWedgeApi.getConfig,
      value: value,
      commandTag: commandTag ?? 'GET_CONFIG_$profileName',
      requestResult: requestResult,
    );
  }

  Future<void> setDefaultProfile(
    String profileName, {
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommand(
      command: DataWedgeApi.setDefaultProfile,
      value: profileName,
      commandTag: commandTag ?? 'SET_DEFAULT_PROFILE_$profileName',
      requestResult: requestResult,
    );
  }

  Future<void> resetDefaultProfile({
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommand(
      command: DataWedgeApi.resetDefaultProfile,
      value: '',
      commandTag: commandTag ?? 'RESET_DEFAULT_PROFILE',
      requestResult: requestResult,
    );
  }

  Future<void> importConfig(
    DataWedgeImportConfigRequest request, {
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommandBundle(
      command: DataWedgeApi.importConfig,
      value: request.toMap(),
      commandTag: commandTag ?? 'IMPORT_CONFIG',
      requestResult: requestResult,
    );
  }

  Future<void> exportConfig(
    DataWedgeExportConfigRequest request, {
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommandBundle(
      command: DataWedgeApi.exportConfig,
      value: request.toMap(),
      commandTag: commandTag ?? 'EXPORT_CONFIG',
      requestResult: requestResult,
    );
  }

  Future<void> setDisabledAppList(
    DataWedgeDisabledAppListRequest request, {
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommandBundle(
      command: DataWedgeApi.setDisabledAppList,
      value: request.toMap(),
      commandTag: commandTag ?? 'SET_DISABLED_APP_LIST',
      requestResult: requestResult,
    );
  }

  Future<void> getDisabledAppList({
    String? commandTag,
    bool requestResult = true,
  }) {
    return _sendQueryCommand(
      command: DataWedgeApi.getDisabledAppList,
      commandTag: commandTag ?? 'GET_DISABLED_APP_LIST',
      requestResult: requestResult,
    );
  }

  Future<void> setIgnoreDisabledProfiles(
    bool ignoreDisabledProfiles, {
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommand(
      command: DataWedgeApi.setIgnoreDisabledProfiles,
      value: dataWedgeBool(ignoreDisabledProfiles),
      commandTag: commandTag ?? 'SET_IGNORE_DISABLED_PROFILES',
      requestResult: requestResult,
    );
  }

  Future<void> getIgnoreDisabledProfiles({
    String? commandTag,
    bool requestResult = true,
  }) {
    return _sendQueryCommand(
      command: DataWedgeApi.getIgnoreDisabledProfiles,
      commandTag: commandTag ?? 'GET_IGNORE_DISABLED_PROFILES',
      requestResult: requestResult,
    );
  }

  Future<void> setDataWedgeEnabled(
    bool enabled, {
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommand(
      command: DataWedgeApi.enableDataWedge,
      value: enabled,
      commandTag: commandTag ?? (enabled ? 'ENABLE_DATAWEDGE' : 'DISABLE_DATAWEDGE'),
      requestResult: requestResult,
    );
  }

  Future<void> getDataWedgeStatus({
    String? commandTag,
    bool requestResult = true,
  }) {
    return _sendQueryCommand(
      command: DataWedgeApi.getDataWedgeStatus,
      commandTag: commandTag ?? 'GET_DATAWEDGE_STATUS',
      requestResult: requestResult,
    );
  }

  Future<void> getScannerStatus({
    String? commandTag,
    bool requestResult = true,
  }) {
    return _sendQueryCommand(
      command: DataWedgeApi.getScannerStatus,
      commandTag: commandTag ?? 'GET_SCANNER_STATUS',
      requestResult: requestResult,
    );
  }

  Future<void> enumerateTriggers({
    String? commandTag,
    bool requestResult = true,
  }) {
    return _sendQueryCommand(
      command: DataWedgeApi.enumerateTriggers,
      commandTag: commandTag ?? 'ENUMERATE_TRIGGERS',
      requestResult: requestResult,
    );
  }

  Future<void> enumerateWorkflows({
    String? commandTag,
    bool requestResult = true,
  }) {
    return _sendQueryCommand(
      command: DataWedgeApi.enumerateWorkflows,
      commandTag: commandTag ?? 'ENUMERATE_WORKFLOWS',
      requestResult: requestResult,
    );
  }

  Future<void> softScanTrigger({
    required String action,
    String? scannerSelectionByIdentifier,
    String? commandTag,
    bool requestResult = true,
  }) {
    if (scannerSelectionByIdentifier == null ||
        scannerSelectionByIdentifier.isEmpty) {
      return sendCommand(
        command: DataWedgeApi.softScanTrigger,
        value: action,
        commandTag: commandTag ?? 'SOFT_SCAN_TRIGGER',
        requestResult: requestResult,
      );
    }

    return sendIntent(
      extras: <String, dynamic>{
        DataWedgeApi.scannerSelectionByIdentifier: scannerSelectionByIdentifier,
        DataWedgeApi.softScanTrigger: action,
      },
      targetPackage: DataWedgeApi.dataWedgePackage,
      commandTag: commandTag ?? 'SOFT_SCAN_TRIGGER',
      requestResult: requestResult,
    );
  }

  Future<void> softRfidTrigger({
    required String action,
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommand(
      command: DataWedgeApi.softRfidTrigger,
      value: action,
      commandTag: commandTag ?? 'SOFT_RFID_TRIGGER',
      requestResult: requestResult,
    );
  }

  Future<void> softVoiceTrigger({
    required String action,
    String pluginName = DataWedgePluginName.voice,
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendIntent(
      extras: <String, dynamic>{
        DataWedgeApi.pluginNameKey: pluginName,
        DataWedgeApi.softTrigger: action,
      },
      targetPackage: DataWedgeApi.dataWedgePackage,
      commandTag: commandTag ?? 'SOFT_TRIGGER',
      requestResult: requestResult,
    );
  }

  Future<void> scannerInputPlugin(
    String action, {
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommand(
      command: DataWedgeApi.scannerInputPlugin,
      value: action,
      commandTag: commandTag ?? 'SCANNER_INPUT_PLUGIN',
      requestResult: requestResult,
    );
  }

  Future<void> suspendScanner({
    String? commandTag,
    bool requestResult = true,
  }) {
    return scannerInputPlugin(
      DataWedgeScannerInputAction.suspendPlugin,
      commandTag: commandTag ?? 'SUSPEND_SCANNER_PLUGIN',
      requestResult: requestResult,
    );
  }

  Future<void> resumeScanner({
    String? commandTag,
    bool requestResult = true,
  }) {
    return scannerInputPlugin(
      DataWedgeScannerInputAction.resumePlugin,
      commandTag: commandTag ?? 'RESUME_SCANNER_PLUGIN',
      requestResult: requestResult,
    );
  }

  Future<void> switchScannerByIndex(
    int scannerIndex, {
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommand(
      command: DataWedgeApi.switchScanner,
      value: scannerIndex.toString(),
      commandTag: commandTag ?? 'SWITCH_SCANNER_INDEX_$scannerIndex',
      requestResult: requestResult,
    );
  }

  Future<void> switchScannerByIdentifier(
    String scannerIdentifier, {
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommand(
      command: DataWedgeApi.switchScannerEx,
      value: scannerIdentifier,
      commandTag: commandTag ?? 'SWITCH_SCANNER_$scannerIdentifier',
      requestResult: requestResult,
    );
  }

  Future<void> switchScannerParams({
    required Map<String, dynamic> parameters,
    String? scannerSelectionByIdentifier,
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendIntent(
      extras: <String, dynamic>{
        if (scannerSelectionByIdentifier != null &&
            scannerSelectionByIdentifier.isNotEmpty)
          DataWedgeApi.scannerSelectionByIdentifier: scannerSelectionByIdentifier,
        DataWedgeApi.switchScannerParams: parameters,
      },
      targetPackage: DataWedgeApi.dataWedgePackage,
      commandTag: commandTag ?? 'SWITCH_SCANNER_PARAMS',
      requestResult: requestResult,
    );
  }

  Future<void> switchDataCapture({
    required String targetPlugin,
    Map<String, dynamic>? paramList,
    String? commandTag,
    bool requestResult = true,
    bool includeApplicationPackage = true,
  }) {
    return sendIntent(
      extras: <String, dynamic>{
        DataWedgeApi.switchDataCapture: targetPlugin,
        if (paramList != null && paramList.isNotEmpty)
          DataWedgeApi.paramListKey: paramList,
      },
      targetPackage: DataWedgeApi.dataWedgePackage,
      commandTag: commandTag ?? 'SWITCH_DATACAPTURE_$targetPlugin',
      requestResult: requestResult,
      includeApplicationPackage: includeApplicationPackage,
    );
  }

  Future<void> registerForDefaultNotifications() async {
    const List<String> notificationTypes = <String>[
      DataWedgeNotificationType.scannerStatus,
      DataWedgeNotificationType.profileSwitch,
      DataWedgeNotificationType.configurationUpdate,
      DataWedgeNotificationType.workflowStatus,
    ];

    for (final String notificationType in notificationTypes) {
      await registerForNotification(notificationType);
    }
  }

  Future<void> getWeight({
    String deviceIdentifier = DataWedgeScannerIdentifier.usbTgcsMp7000,
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommandBundle(
      command: DataWedgeApi.scale,
      value: DataWedgeScaleRequest(
        deviceIdentifier: deviceIdentifier,
        command: DataWedgeScaleCommand.getWeight,
      ).toMap(),
      commandTag: commandTag ?? 'GET_WEIGHT',
      requestResult: requestResult,
    );
  }

  Future<void> setScaleToZero({
    String deviceIdentifier = DataWedgeScannerIdentifier.usbTgcsMp7000,
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommandBundle(
      command: DataWedgeApi.scale,
      value: DataWedgeScaleRequest(
        deviceIdentifier: deviceIdentifier,
        command: DataWedgeScaleCommand.setScaleToZero,
      ).toMap(),
      commandTag: commandTag ?? 'SET_SCALE_TO_ZERO',
      requestResult: requestResult,
    );
  }

  Future<void> notifyBluetoothScanner(
    DataWedgeNotificationRequest request, {
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommandBundle(
      command: DataWedgeApi.notify,
      value: request.toMap(),
      commandTag: commandTag ?? 'NOTIFY_SCANNER',
      requestResult: requestResult,
    );
  }

  Future<void> customNotifyBluetoothScanner(
    DataWedgeCustomNotificationRequest request, {
    String? commandTag,
    bool requestResult = true,
  }) {
    return sendCommandBundle(
      command: DataWedgeApi.notify,
      value: request.toMap(),
      commandTag: commandTag ?? 'CUSTOM_NOTIFY_SCANNER',
      requestResult: requestResult,
    );
  }

  Future<void> sendCommand({
    required String command,
    dynamic value,
    String? commandTag,
    bool requestResult = true,
  }) {
    return _platform.sendCommand(
      command: command,
      value: value,
      commandTag: commandTag,
      requestResult: requestResult,
    );
  }

  Future<void> sendCommandBundle({
    required String command,
    required Map<String, dynamic> value,
    String? commandTag,
    bool requestResult = true,
  }) {
    return _platform.sendCommandBundle(
      command: command,
      value: value,
      commandTag: commandTag,
      requestResult: requestResult,
    );
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
    return _platform.sendIntent(
      extras: extras,
      action: action,
      targetPackage: targetPackage,
      commandTag: commandTag,
      requestResult: requestResult,
      orderedBroadcast: orderedBroadcast,
      includeApplicationPackage: includeApplicationPackage,
    );
  }

  Future<void> _sendQueryCommand({
    required String command,
    required String commandTag,
    bool requestResult = true,
  }) {
    return sendCommand(
      command: command,
      value: '',
      commandTag: commandTag,
      requestResult: requestResult,
    );
  }
}
