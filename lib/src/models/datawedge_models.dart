class DataWedgeApi {
  const DataWedgeApi._();

  static const String action = 'com.symbol.datawedge.api.ACTION';
  static const String resultAction = 'com.symbol.datawedge.api.RESULT_ACTION';
  static const String notificationAction =
      'com.symbol.datawedge.api.NOTIFICATION_ACTION';
  static const String dataWedgePackage = 'com.symbol.datawedge';

  static const String sendResultKey = 'SEND_RESULT';
  static const String sendResultLast = 'LAST_RESULT';
  static const String sendResultComplete = 'COMPLETE_RESULT';
  static const String commandIdentifierKey = 'COMMAND_IDENTIFIER';
  static const String commandKey = 'COMMAND';
  static const String resultKey = 'RESULT';
  static const String resultInfoKey = 'RESULT_INFO';

  static const String applicationNameKey = 'APPLICATION_NAME';
  static const String applicationPackageKey = 'APPLICATION_PACKAGE';

  static const String createProfile = 'com.symbol.datawedge.api.CREATE_PROFILE';
  static const String cloneProfile = 'com.symbol.datawedge.api.CLONE_PROFILE';
  static const String deleteProfile = 'com.symbol.datawedge.api.DELETE_PROFILE';
  static const String renameProfile = 'com.symbol.datawedge.api.RENAME_PROFILE';
  static const String setConfig = 'com.symbol.datawedge.api.SET_CONFIG';
  static const String getConfig = 'com.symbol.datawedge.api.GET_CONFIG';
  static const String importConfig = 'com.symbol.datawedge.api.IMPORT_CONFIG';
  static const String exportConfig = 'com.symbol.datawedge.api.EXPORT_CONFIG';
  static const String setDisabledAppList =
      'com.symbol.datawedge.api.SET_DISABLED_APP_LIST';
  static const String getDisabledAppList =
      'com.symbol.datawedge.api.GET_DISABLED_APP_LIST';
  static const String setIgnoreDisabledProfiles =
      'com.symbol.datawedge.api.SET_IGNORE_DISABLED_PROFILES';
  static const String getIgnoreDisabledProfiles =
      'com.symbol.datawedge.api.GET_IGNORE_DISABLED_PROFILES';

  static const String registerForNotification =
      'com.symbol.datawedge.api.REGISTER_FOR_NOTIFICATION';
  static const String unregisterForNotification =
      'com.symbol.datawedge.api.UNREGISTER_FOR_NOTIFICATION';
  static const String notificationBundle = 'com.symbol.datawedge.api.NOTIFICATION';

  static const String enumerateScanners =
      'com.symbol.datawedge.api.ENUMERATE_SCANNERS';
  static const String getActiveProfile =
      'com.symbol.datawedge.api.GET_ACTIVE_PROFILE';
  static const String getProfilesList =
      'com.symbol.datawedge.api.GET_PROFILES_LIST';
  static const String getVersionInfo =
      'com.symbol.datawedge.api.GET_VERSION_INFO';
  static const String getDataWedgeStatus =
      'com.symbol.datawedge.api.GET_DATAWEDGE_STATUS';
  static const String getScannerStatus =
      'com.symbol.datawedge.api.GET_SCANNER_STATUS';
  static const String enumerateTriggers =
      'com.symbol.datawedge.api.ENUMERATE_TRIGGERS';
  static const String enumerateWorkflows =
      'com.symbol.datawedge.api.ENUMERATE_WORKFLOWS';

  static const String enableDataWedge =
      'com.symbol.datawedge.api.ENABLE_DATAWEDGE';
  static const String scannerInputPlugin =
      'com.symbol.datawedge.api.SCANNER_INPUT_PLUGIN';
  static const String softScanTrigger =
      'com.symbol.datawedge.api.SOFT_SCAN_TRIGGER';
  static const String softRfidTrigger =
      'com.symbol.datawedge.api.SOFT_RFID_TRIGGER';
  static const String softTrigger = 'com.symbol.datawedge.api.SOFT_TRIGGER';
  static const String switchToProfile =
      'com.symbol.datawedge.api.SWITCH_TO_PROFILE';
  static const String setDefaultProfile =
      'com.symbol.datawedge.api.SET_DEFAULT_PROFILE';
  static const String resetDefaultProfile =
      'com.symbol.datawedge.api.RESET_DEFAULT_PROFILE';
  static const String switchScanner = 'com.symbol.datawedge.api.SWITCH_SCANNER';
  static const String switchScannerEx =
      'com.symbol.datawedge.api.SWITCH_SCANNER_EX';
  static const String switchScannerParams =
      'com.symbol.datawedge.api.SWITCH_SCANNER_PARAMS';
  static const String switchDataCapture =
      'com.symbol.datawedge.api.SWITCH_DATACAPTURE';
  static const String scale = 'com.symbol.datawedge.api.SCALE';
  static const String notify = 'com.symbol.datawedge.api.notification.NOTIFY';

  static const String resultGetConfig = 'com.symbol.datawedge.api.RESULT_GET_CONFIG';
  static const String resultGetActiveProfile =
      'com.symbol.datawedge.api.RESULT_GET_ACTIVE_PROFILE';
  static const String resultGetProfilesList =
      'com.symbol.datawedge.api.RESULT_GET_PROFILES_LIST';
  static const String resultGetVersionInfo =
      'com.symbol.datawedge.api.RESULT_GET_VERSION_INFO';
  static const String resultGetDataWedgeStatus =
      'com.symbol.datawedge.api.RESULT_GET_DATAWEDGE_STATUS';
  static const String resultGetScannerStatus =
      'com.symbol.datawedge.api.RESULT_SCANNER_STATUS';
  static const String resultGetDisabledAppList =
      'com.symbol.datawedge.api.RESULT_GET_DISABLED_APP_LIST';
  static const String resultEnumerateScanners =
      'com.symbol.datawedge.api.RESULT_ENUMERATE_SCANNERS';
  static const String resultEnumerateTriggers =
      'com.symbol.datawedge.api.RESULT_ENUMERATE_TRIGGERS';
  static const String resultEnumerateWorkflows =
      'com.symbol.datawedge.api.RESULT_ENUMERATE_WORKFLOWS';

  static const String profileNameKey = 'PROFILE_NAME';
  static const String profileEnabledKey = 'PROFILE_ENABLED';
  static const String configModeKey = 'CONFIG_MODE';
  static const String resetConfigKey = 'RESET_CONFIG';
  static const String appListKey = 'APP_LIST';
  static const String pluginConfigKey = 'PLUGIN_CONFIG';
  static const String pluginNameKey = 'PLUGIN_NAME';
  static const String outputPluginNameKey = 'OUTPUT_PLUGIN_NAME';
  static const String processPluginNameKey = 'PROCESS_PLUGIN_NAME';
  static const String paramListKey = 'PARAM_LIST';
  static const String packageNameKey = 'PACKAGE_NAME';
  static const String activityListKey = 'ACTIVITY_LIST';
  static const String wildcard = '*';

  static const String scannerSelectionByIdentifier =
      'scanner_selection_by_identifier';
  static const String scannerSelection = 'scanner_selection';

  static const String defaultIntentCategory = 'android.intent.category.DEFAULT';
}

class DataWedgeConfigMode {
  const DataWedgeConfigMode._();

  static const String createIfNotExist = 'CREATE_IF_NOT_EXIST';
  static const String overwrite = 'OVERWRITE';
  static const String update = 'UPDATE';
}

class DataWedgeDisabledAppListMode {
  const DataWedgeDisabledAppListMode._();

  static const String update = 'UPDATE';
  static const String remove = 'REMOVE';
  static const String overwrite = 'OVERWRITE';
}

class DataWedgeExportType {
  const DataWedgeExportType._();

  static const String profileConfig = 'PROFILE_CONFIG';
  static const String fullConfig = 'FULL_CONFIG';
}

class DataWedgeNotificationType {
  const DataWedgeNotificationType._();

  static const String scannerStatus = 'SCANNER_STATUS';
  static const String profileSwitch = 'PROFILE_SWITCH';
  static const String configurationUpdate = 'CONFIGURATION_UPDATE';
  static const String workflowStatus = 'WORKFLOW_STATUS';
}

class DataWedgePluginName {
  const DataWedgePluginName._();

  static const String barcode = 'BARCODE';
  static const String msr = 'MSR';
  static const String rfid = 'RFID';
  static const String serial = 'SERIAL';
  static const String voice = 'VOICE';
  static const String workflow = 'WORKFLOW';
  static const String bdf = 'BDF';
  static const String adf = 'ADF';
  static const String token = 'TOKEN';
  static const String intent = 'INTENT';
  static const String keystroke = 'KEYSTROKE';
  static const String ip = 'IP';
  static const String dcp = 'DCP';
  static const String ekb = 'EKB';
}

class DataWedgeIntentDelivery {
  const DataWedgeIntentDelivery._();

  static const int startActivity = 0;
  static const int startService = 1;
  static const int broadcast = 2;
  static const int startForegroundService = 3;
}

class DataWedgeScannerInputAction {
  const DataWedgeScannerInputAction._();

  static const String enablePlugin = 'ENABLE_PLUGIN';
  static const String disablePlugin = 'DISABLE_PLUGIN';
  static const String suspendPlugin = 'SUSPEND_PLUGIN';
  static const String resumePlugin = 'RESUME_PLUGIN';
}

class DataWedgeSoftScanAction {
  const DataWedgeSoftScanAction._();

  static const String start = 'START_SCANNING';
  static const String stop = 'STOP_SCANNING';
  static const String toggle = 'TOGGLE_SCANNING';
}

class DataWedgeSoftTriggerAction {
  const DataWedgeSoftTriggerAction._();

  static const String start = 'START';
  static const String stop = 'STOP';
  static const String toggle = 'TOGGLE';
}

class DataWedgeSwitchDataCaptureTarget {
  const DataWedgeSwitchDataCaptureTarget._();

  static const String barcode = 'BARCODE';
  static const String workflow = 'WORKFLOW';
}

class DataWedgeWorkflowName {
  const DataWedgeWorkflowName._();

  static const String licensePlate = 'license_plate';
  static const String idScanning = 'id_scanning';
  static const String vinNumber = 'vin_number';
  static const String tinNumber = 'tin_number';
  static const String containerScanning = 'container_scanning';
  static const String meterReading = 'meter_reading';
  static const String freeFormCapture = 'free_form_capture';
  static const String documentCapture = 'document_capture';
  static const String picklistOcr = 'picklist_ocr';
  static const String freeFormOcr = 'free_form_ocr';
  static const String basicMultibarcode = 'basic_multibarcode';
}

class DataWedgeWorkflowInputSource {
  const DataWedgeWorkflowInputSource._();

  static const String imager = '1';
  static const String camera = '2';
}

class DataWedgeScaleCommand {
  const DataWedgeScaleCommand._();

  static const String getWeight = 'GET_WEIGHT';
  static const String setScaleToZero = 'SET_SCALE_TO_ZERO';
}

class DataWedgeScannerIdentifier {
  const DataWedgeScannerIdentifier._();

  static const String auto = 'AUTO';
  static const String internalImager = 'INTERNAL_IMAGER';
  static const String internalLaser = 'INTERNAL_LASER';
  static const String internalCamera = 'INTERNAL_CAMERA';
  static const String serialSsi = 'SERIAL_SSI';
  static const String bluetoothSsi = 'BLUETOOTH_SSI';
  static const String bluetoothRs5100 = 'BLUETOOTH_RS5100';
  static const String bluetoothRs6000 = 'BLUETOOTH_RS6000';
  static const String bluetoothDs2278 = 'BLUETOOTH_DS2278';
  static const String bluetoothDs3678 = 'BLUETOOTH_DS3678';
  static const String bluetoothDs8178 = 'BLUETOOTH_DS8178';
  static const String bluetoothLi3678 = 'BLUETOOTH_LI3678';
  static const String bluetoothZebra = 'BLUETOOTH_ZEBRA';
  static const String bluetoothGeneric = 'BLUETOOTH_GENERIC';
  static const String plugableSsi = 'PLUGABLE_SSI';
  static const String plugableSsiRs5000 = 'PLUGABLE_SSI_RS5000';
  static const String usbSsiDs3608 = 'USB_SSI_DS3608';
  static const String usbTgcsMp7000 = 'USB_TGCS_MP7000';
  static const String usbZebra = 'USB_ZEBRA';
}

class DataWedgeEventType {
  const DataWedgeEventType._();

  static const String scan = 'scan';
  static const String commandResult = 'commandResult';
  static const String notification = 'notification';
  static const String debug = 'debug';
  static const String unknown = 'unknown';
}

String dataWedgeBool(bool value) {
  return value ? 'true' : 'false';
}

class DataWedgeEvent {
  DataWedgeEvent({required this.type, required this.payload});

  factory DataWedgeEvent.fromMap(Map<String, dynamic> rawEvent) {
    final Map<String, dynamic> payload = Map<String, dynamic>.from(rawEvent);
    final String type = (payload['type'] as String?) ?? DataWedgeEventType.unknown;
    return DataWedgeEvent(type: type, payload: payload);
  }

  final String type;
  final Map<String, dynamic> payload;

  bool get isScan => type == DataWedgeEventType.scan;

  bool get isCommandResult => type == DataWedgeEventType.commandResult;

  bool get isNotification => type == DataWedgeEventType.notification;

  String? get scanData => payload['data'] as String?;

  String? get labelType => payload['labelType'] as String?;

  String? get notificationType => payload['notificationType'] as String?;

  String? get scannerStatus => payload['status'] as String?;

  String? get command => payload['command'] as String?;

  String? get commandIdentifier =>
      payload['commandId'] as String? ?? payload[DataWedgeApi.commandIdentifierKey] as String?;

  String? get result => payload['result'] as String?;
}

class DataWedgeAppAssociation {
  const DataWedgeAppAssociation({
    required this.packageName,
    this.activityList = const <String>[DataWedgeApi.wildcard],
  });

  final String packageName;
  final List<String> activityList;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      DataWedgeApi.packageNameKey: packageName,
      DataWedgeApi.activityListKey: activityList,
    };
  }
}

class DataWedgePluginConfiguration {
  const DataWedgePluginConfiguration({
    required this.pluginName,
    this.resetConfig = true,
    this.paramList,
    this.outputPluginName,
    this.extra = const <String, dynamic>{},
  });

  final String pluginName;
  final bool resetConfig;
  final Object? paramList;
  final String? outputPluginName;
  final Map<String, dynamic> extra;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      DataWedgeApi.pluginNameKey: pluginName,
      DataWedgeApi.resetConfigKey: dataWedgeBool(resetConfig),
    };

    if (outputPluginName != null) {
      map[DataWedgeApi.outputPluginNameKey] = outputPluginName;
    }
    if (paramList != null) {
      map[DataWedgeApi.paramListKey] = paramList;
    }
    map.addAll(extra);

    return map;
  }
}

class DataWedgeProcessPluginRequest {
  const DataWedgeProcessPluginRequest({
    required this.pluginName,
    this.outputPluginName,
  });

  final String pluginName;
  final String? outputPluginName;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      DataWedgeApi.pluginNameKey: pluginName,
    };
    if (outputPluginName != null) {
      map[DataWedgeApi.outputPluginNameKey] = outputPluginName;
    }
    return map;
  }
}

class DataWedgeWorkflowModule {
  const DataWedgeWorkflowModule({
    required this.module,
    required this.moduleParams,
  });

  final String module;
  final Map<String, dynamic> moduleParams;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'module': module,
      'module_params': moduleParams,
    };
  }
}

class DataWedgeWorkflowConfiguration {
  const DataWedgeWorkflowConfiguration({
    required this.workflowName,
    this.workflowInputSource = DataWedgeWorkflowInputSource.imager,
    this.modules = const <DataWedgeWorkflowModule>[],
  });

  final String workflowName;
  final String workflowInputSource;
  final List<DataWedgeWorkflowModule> modules;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      'workflow_name': workflowName,
      'workflow_input_source': workflowInputSource,
    };

    if (modules.isNotEmpty) {
      map['workflow_params'] =
          modules.map<Map<String, dynamic>>((DataWedgeWorkflowModule m) {
        return m.toMap();
      }).toList();
    }

    return map;
  }
}

class DataWedgeProfileConfiguration {
  const DataWedgeProfileConfiguration({
    required this.profileName,
    this.configMode = DataWedgeConfigMode.createIfNotExist,
    this.profileEnabled,
    this.resetConfig,
    this.pluginConfigurations = const <DataWedgePluginConfiguration>[],
    this.appAssociations = const <DataWedgeAppAssociation>[],
    this.dataCapturePlus,
    this.enterpriseKeyboard,
  });

  final String profileName;
  final String configMode;
  final bool? profileEnabled;
  final bool? resetConfig;
  final List<DataWedgePluginConfiguration> pluginConfigurations;
  final List<DataWedgeAppAssociation> appAssociations;
  final Map<String, dynamic>? dataCapturePlus;
  final Map<String, dynamic>? enterpriseKeyboard;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      DataWedgeApi.profileNameKey: profileName,
      DataWedgeApi.configModeKey: configMode,
    };

    if (profileEnabled != null) {
      map[DataWedgeApi.profileEnabledKey] = dataWedgeBool(profileEnabled!);
    }
    if (resetConfig != null) {
      map[DataWedgeApi.resetConfigKey] = dataWedgeBool(resetConfig!);
    }
    if (pluginConfigurations.isNotEmpty) {
      map[DataWedgeApi.pluginConfigKey] =
          pluginConfigurations.map<Map<String, dynamic>>((
        DataWedgePluginConfiguration plugin,
      ) {
        return plugin.toMap();
      }).toList();
    }
    if (appAssociations.isNotEmpty) {
      map[DataWedgeApi.appListKey] =
          appAssociations.map<Map<String, dynamic>>((
        DataWedgeAppAssociation association,
      ) {
        return association.toMap();
      }).toList();
    }
    if (dataCapturePlus != null) {
      map[DataWedgePluginName.dcp] = dataCapturePlus;
    }
    if (enterpriseKeyboard != null) {
      map[DataWedgePluginName.ekb] = enterpriseKeyboard;
    }

    return map;
  }
}

class DataWedgeProfileBuilder {
  DataWedgeProfileBuilder({
    required this.profileName,
    this.configMode = DataWedgeConfigMode.createIfNotExist,
  });

  final String profileName;
  final String configMode;

  bool? _profileEnabled;
  bool? _resetConfig;
  final List<DataWedgePluginConfiguration> _plugins =
      <DataWedgePluginConfiguration>[];
  final List<DataWedgeAppAssociation> _appAssociations =
      <DataWedgeAppAssociation>[];
  Map<String, dynamic>? _dcp;
  Map<String, dynamic>? _ekb;

  DataWedgeProfileBuilder setProfileEnabled(bool enabled) {
    _profileEnabled = enabled;
    return this;
  }

  DataWedgeProfileBuilder setResetConfig(bool reset) {
    _resetConfig = reset;
    return this;
  }

  DataWedgeProfileBuilder addPlugin(DataWedgePluginConfiguration plugin) {
    _plugins.add(plugin);
    return this;
  }

  DataWedgeProfileBuilder addAppAssociation(DataWedgeAppAssociation association) {
    _appAssociations.add(association);
    return this;
  }

  DataWedgeProfileBuilder setDataCapturePlus(Map<String, dynamic> dcp) {
    _dcp = dcp;
    return this;
  }

  DataWedgeProfileBuilder setEnterpriseKeyboard(Map<String, dynamic> ekb) {
    _ekb = ekb;
    return this;
  }

  DataWedgeProfileConfiguration build() {
    return DataWedgeProfileConfiguration(
      profileName: profileName,
      configMode: configMode,
      profileEnabled: _profileEnabled,
      resetConfig: _resetConfig,
      pluginConfigurations: List<DataWedgePluginConfiguration>.unmodifiable(
        _plugins,
      ),
      appAssociations: List<DataWedgeAppAssociation>.unmodifiable(
        _appAssociations,
      ),
      dataCapturePlus: _dcp,
      enterpriseKeyboard: _ekb,
    );
  }
}

class DataWedgeExportConfigRequest {
  const DataWedgeExportConfigRequest({
    required this.folderPath,
    required this.exportType,
    this.profileName,
  });

  final String folderPath;
  final String exportType;
  final String? profileName;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      'FOLDER_PATH': folderPath,
      'EXPORT_TYPE': exportType,
    };

    if (profileName != null && profileName!.isNotEmpty) {
      map[DataWedgeApi.profileNameKey] = profileName;
    }

    return map;
  }
}

class DataWedgeImportConfigRequest {
  const DataWedgeImportConfigRequest({
    required this.folderPath,
    this.fileList,
  });

  final String folderPath;
  final List<String>? fileList;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      'FOLDER_PATH': folderPath,
    };

    if (fileList != null && fileList!.isNotEmpty) {
      map['FILE_LIST'] = fileList;
    }

    return map;
  }
}

class DataWedgeDisabledAppListRequest {
  const DataWedgeDisabledAppListRequest({
    required this.configMode,
    this.appList = const <DataWedgeAppAssociation>[],
  });

  final String configMode;
  final List<DataWedgeAppAssociation> appList;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      DataWedgeApi.configModeKey: configMode,
      DataWedgeApi.appListKey:
          appList.map<Map<String, dynamic>>((DataWedgeAppAssociation app) {
        return app.toMap();
      }).toList(),
    };
  }
}

class DataWedgeScaleRequest {
  const DataWedgeScaleRequest({
    required this.deviceIdentifier,
    required this.command,
  });

  final String deviceIdentifier;
  final String command;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'SCALE_CONFIG': <String, dynamic>{
        'DEVICE_IDENTIFIER': deviceIdentifier,
        'COMMAND': command,
      },
    };
  }
}

class DataWedgeNotificationRequest {
  const DataWedgeNotificationRequest({
    required this.deviceIdentifier,
    required this.notificationSettings,
  });

  final String deviceIdentifier;
  final List<int> notificationSettings;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'NOTIFICATION_CONFIG': <String, dynamic>{
        'DEVICE_IDENTIFIER': deviceIdentifier,
        'NOTIFICATION_SETTINGS': notificationSettings,
      },
    };
  }
}

class DataWedgeCustomNotificationRequest {
  const DataWedgeCustomNotificationRequest({
    required this.deviceIdentifier,
    this.ledSettings,
    this.beepSettings = const <DataWedgeBeepSettings>[],
    this.vibrationSettings = const <DataWedgeVibrationSettings>[],
  });

  final String deviceIdentifier;
  final DataWedgeLedSettings? ledSettings;
  final List<DataWedgeBeepSettings> beepSettings;
  final List<DataWedgeVibrationSettings> vibrationSettings;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> notificationSettings = <String, dynamic>{};

    if (ledSettings != null) {
      notificationSettings['LED_SETTINGS'] = ledSettings!.toMap();
    }
    if (beepSettings.isNotEmpty) {
      notificationSettings['BEEP_SETTINGS'] =
          beepSettings.map<Map<String, dynamic>>((DataWedgeBeepSettings b) {
        return b.toMap();
      }).toList();
    }
    if (vibrationSettings.isNotEmpty) {
      notificationSettings['VIBRATOR_SETTINGS'] = vibrationSettings
          .map<Map<String, dynamic>>((DataWedgeVibrationSettings v) {
        return v.toMap();
      }).toList();
    }

    return <String, dynamic>{
      'NOTIFICATION_CONFIG': <String, dynamic>{
        'DEVICE_IDENTIFIER': deviceIdentifier,
        'NOTIFICATION_SETTINGS': notificationSettings,
      },
    };
  }
}

class DataWedgeLedSettings {
  const DataWedgeLedSettings({
    required this.color,
    required this.onTime,
    required this.offTime,
    required this.repeatCount,
  });

  final int color;
  final int onTime;
  final int offTime;
  final int repeatCount;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'COLOR': color,
      'ON_TIME': onTime,
      'OFF_TIME': offTime,
      'REPEAT_COUNT': repeatCount,
    };
  }
}

class DataWedgeBeepSettings {
  const DataWedgeBeepSettings({
    required this.frequency,
    required this.onTime,
    required this.offTime,
    required this.repeatCount,
  });

  final int frequency;
  final int onTime;
  final int offTime;
  final int repeatCount;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'BEEP_FREQUENCY': frequency,
      'ON_TIME': onTime,
      'OFF_TIME': offTime,
      'REPEAT_COUNT': repeatCount,
    };
  }
}

class DataWedgeVibrationSettings {
  const DataWedgeVibrationSettings({
    required this.onTime,
    required this.offTime,
    required this.repeatCount,
  });

  final int onTime;
  final int offTime;
  final int repeatCount;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ON_TIME': onTime,
      'OFF_TIME': offTime,
      'REPEAT_COUNT': repeatCount,
    };
  }
}
