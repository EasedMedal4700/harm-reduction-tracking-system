import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const WearCompanionApp());
}

class WearCompanionApp extends StatelessWidget {
  const WearCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.tealAccent,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Wear Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final WearSensorController _controller = WearSensorController();
  final Map<int, SensorReading> _readings = {};

  StreamSubscription<SensorSample>? _sensorSubscription;
  bool _hasPermission = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final granted = await _controller.requestPermissions();
    setState(() {
      _hasPermission = granted;
      _errorMessage = null;
    });

    _sensorSubscription = _controller.sensorStream.listen(
      (sample) {
        setState(() {
          _readings[sample.sensorType] = SensorReading.fromSample(sample);
        });
      },
      onError: (error) {
        setState(() {
          _errorMessage = error.toString();
        });
      },
    );
  }

  @override
  void dispose() {
    _sensorSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cards = sensorConfigs.values
        .map(
          (config) => SensorCard(
            config: config,
            reading: _readings[config.sensorType],
          ),
        )
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Vitals & Movement',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Live metrics from your Galaxy Watch',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              if (!_hasPermission)
                ElevatedButton.icon(
                  onPressed: _bootstrap,
                  icon: const Icon(Icons.favorite_outlined),
                  label: const Text('Enable body sensors'),
                ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.05,
                  children: cards,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SensorCard extends StatelessWidget {
  const SensorCard({
    required this.config,
    this.reading,
    super.key,
  });

  final SensorConfig config;
  final SensorReading? reading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final valueText = reading != null
        ? '${reading!.formattedValue}${config.unit ?? ''}'
        : '--';

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: config.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(config.icon, size: 28, color: Colors.white),
            Text(
              valueText,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.label,
                  style: textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
                if (reading?.lastUpdated != null)
                  Text(
                    'Updated ${reading!.timeAgo}',
                    style: textTheme.labelSmall?.copyWith(color: Colors.white70),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WearSensorController {
  static const _sensorChannel = EventChannel('wear_companion_app/sensors');
  static const _commandChannel = MethodChannel('wear_companion_app/commands');

  final StreamController<SensorSample> _controller =
      StreamController.broadcast();
  StreamSubscription<dynamic>? _nativeSubscription;

  WearSensorController() {
    _nativeSubscription =
        _sensorChannel.receiveBroadcastStream().listen((event) {
      if (event is Map) {
        _controller.add(SensorSample.fromMap(event.cast<String, dynamic>()));
      }
    }, onError: (error) {
      _controller.addError(error);
    });
  }

  Stream<SensorSample> get sensorStream => _controller.stream;

  Future<bool> requestPermissions() async {
    try {
      final granted =
          await _commandChannel.invokeMethod<bool>('requestPermissions');
      return granted ?? false;
    } on PlatformException catch (e) {
      _controller.addError(e);
      return false;
    }
  }

  void dispose() {
    _commandChannel.invokeMethod('stopSensors');
    _nativeSubscription?.cancel();
    _controller.close();
  }
}

class SensorSample {
  SensorSample({
    required this.sensorType,
    required this.value,
    required this.timestamp,
    required this.accuracy,
  });

  final int sensorType;
  final double value;
  final int timestamp;
  final int accuracy;

  factory SensorSample.fromMap(Map<String, dynamic> data) {
    return SensorSample(
      sensorType: (data['sensorType'] as num).toInt(),
      value: (data['value'] as num).toDouble(),
      timestamp: (data['timestamp'] as num).toInt(),
      accuracy: (data['accuracy'] as num).toInt(),
    );
  }
}

class SensorReading {
  SensorReading({
    required this.sensorType,
    required this.value,
    required this.lastUpdated,
  });

  final int sensorType;
  final double value;
  final DateTime lastUpdated;

  factory SensorReading.fromSample(SensorSample sample) {
    return SensorReading(
      sensorType: sample.sensorType,
      value: sample.value,
      lastUpdated: DateTime.now(),
    );
  }

  String get formattedValue {
    if (sensorType == SensorType.stepCounter) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(1);
  }

  String get timeAgo {
    final delta = DateTime.now().difference(lastUpdated);
    if (delta.inSeconds < 10) return 'just now';
    if (delta.inMinutes < 1) return '${delta.inSeconds}s ago';
    return '${delta.inMinutes}m ago';
  }
}

class SensorConfig {
  const SensorConfig({
    required this.sensorType,
    required this.label,
    required this.icon,
    required this.gradient,
    this.unit,
  });

  final int sensorType;
  final String label;
  final IconData icon;
  final String? unit;
  final List<Color> gradient;
}

abstract class SensorType {
  static const heartRate = 21;
  static const bodyTemperature = 38;
  static const ambientTemperature = 13;
  static const humidity = 12;
  static const stepCounter = 19;
}

const sensorConfigs = <int, SensorConfig>{
  SensorType.heartRate: SensorConfig(
    sensorType: SensorType.heartRate,
    label: 'Heart Rate',
    unit: ' bpm',
    icon: Icons.favorite,
    gradient: [Color(0xFFff5f6d), Color(0xFFffc371)],
  ),
  SensorType.bodyTemperature: SensorConfig(
    sensorType: SensorType.bodyTemperature,
    label: 'Body Temp',
    unit: ' °C',
    icon: Icons.thermostat,
    gradient: [Color(0xFF36d1dc), Color(0xFF5b86e5)],
  ),
  SensorType.ambientTemperature: SensorConfig(
    sensorType: SensorType.ambientTemperature,
    label: 'Ambient Temp',
    unit: ' °C',
    icon: Icons.eco,
    gradient: [Color(0xFF0cebeb), Color(0xFF20e3b2)],
  ),
  SensorType.humidity: SensorConfig(
    sensorType: SensorType.humidity,
    label: 'Humidity',
    unit: ' %',
    icon: Icons.water_drop,
    gradient: [Color(0xFF4facfe), Color(0xFF00f2fe)],
  ),
  SensorType.stepCounter: SensorConfig(
    sensorType: SensorType.stepCounter,
    label: 'Steps',
    unit: '',
    icon: Icons.directions_walk,
    gradient: [Color(0xFFff9966), Color(0xFFff5e62)],
  ),
};
