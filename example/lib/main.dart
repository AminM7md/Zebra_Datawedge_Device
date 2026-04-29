import 'package:flutter/material.dart';
import 'package:zebra_wedge_scanner/zebra_datawedge.dart';

void main() {
  runApp(const MyApp());
}

/// The main application widget.
class MyApp extends StatelessWidget {
  /// Creates the main application widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zebra DataWedge Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

/// The main page of the example app.
class MyHomePage extends StatefulWidget {
  /// Creates the main page widget.
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ZebraDataWedge _zebra = ZebraDataWedge();
  final List<String> _scanResults = [];
  bool _isDataWedgeAvailable = false;
  String _status = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final available = await _zebra.isAvailable();
    setState(() {
      _isDataWedgeAvailable = available;
      _status =
          available ? 'DataWedge is available' : 'DataWedge is NOT available';
    });

    if (available) {
      _zebra.events.listen((event) {
        if (event.isScan) {
          setState(() {
            _scanResults.insert(
              0,
              'Scanned: ${event.scanData ?? 'N/A'} '
              '(Type: ${event.labelType ?? 'N/A'})',
            );
            if (_scanResults.length > 50) {
              _scanResults.removeLast();
            }
          });
        } else if (event.isCommandResult) {
          setState(() {
            _status = 'Command: ${event.command ?? 'N/A'}, '
                'Result: ${event.result ?? 'N/A'}';
          });
        } else if (event.isNotification) {
          setState(() {
            _status = 'Notification: ${event.notificationType ?? 'N/A'} - '
                '${event.scannerStatus ?? ''}';
          });
        }
      });

      try {
        await _zebra.configureClassicBarcodeProfile(
          profileName: 'ZebraScannerExample',
          packageName: 'com.example.zebra_datawedge_example',
        );
        await _zebra.registerForDefaultNotifications();
        setState(() {
          _status = 'Profile configured successfully';
        });
      } catch (e) {
        setState(() {
          _status = 'Error configuring profile: $e';
        });
      }
    }
  }

  Future<void> _startScan() async {
    try {
      await _zebra.startSoftScan();
    } catch (e) {
      setState(() {
        _status = 'Error starting scan: $e';
      });
    }
  }

  Future<void> _stopScan() async {
    try {
      await _zebra.stopSoftScan();
    } catch (e) {
      setState(() {
        _status = 'Error stopping scan: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zebra DataWedge Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: _isDataWedgeAvailable
                ? Colors.green.shade100
                : Colors.red.shade100,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _status,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'DataWedge Available: $_isDataWedgeAvailable',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isDataWedgeAvailable ? _startScan : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Scan'),
                ),
                ElevatedButton.icon(
                  onPressed: _isDataWedgeAvailable ? _stopScan : null,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop Scan'),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Scan Results:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _scanResults.isEmpty
                ? const Center(
                    child: Text(
                      'No scans yet.\nPress "Start Scan" to begin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _scanResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text(_scanResults[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
