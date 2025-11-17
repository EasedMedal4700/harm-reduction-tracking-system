package com.example.wear_companion_app

import android.Manifest
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import android.os.Bundle
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(), SensorEventListener {
    private val sensorChannelName = "wear_companion_app/sensors"
    private val commandChannelName = "wear_companion_app/commands"
    private val sensorPermissionCode = 7001

    private var sensorManager: SensorManager? = null
    private var eventSink: EventChannel.EventSink? = null
    private val activeSensors = mutableListOf<Sensor>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, sensorChannelName)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
                    eventSink = sink
                    startSensorStreaming()
                }

                override fun onCancel(arguments: Any?) {
                    stopSensorStreaming()
                    eventSink = null
                }
            })

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, commandChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "requestPermissions" -> {
                        val granted = ensureSensorPermissions()
                        result.success(granted)
                    }

                    "stopSensors" -> {
                        stopSensorStreaming()
                        result.success(true)
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun ensureSensorPermissions(): Boolean {
        val requiredPermissions = mutableListOf(
            Manifest.permission.BODY_SENSORS,
            Manifest.permission.ACTIVITY_RECOGNITION,
        )

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            requiredPermissions.add(Manifest.permission.BODY_SENSORS_BACKGROUND)
        }

        val missing = requiredPermissions.filter {
            ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
        }

        if (missing.isEmpty()) {
            return true
        }

        ActivityCompat.requestPermissions(this, missing.toTypedArray(), sensorPermissionCode)
        return false
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != sensorPermissionCode) return

        val granted = grantResults.isNotEmpty() && grantResults.all { it == PackageManager.PERMISSION_GRANTED }
        if (granted) {
            startSensorStreaming()
        } else {
            eventSink?.error("permission_denied", "Sensor permissions not granted", null)
        }
    }

    private fun startSensorStreaming() {
        if (!ensureSensorPermissions()) {
            return
        }

        stopSensorStreaming()

        sensorManager?.let { manager ->
            val sensorTypes = listOf(
                Sensor.TYPE_HEART_RATE,
                // Sensor.TYPE_BODY_TEMPERATURE, // Not available on all devices
                Sensor.TYPE_AMBIENT_TEMPERATURE,
                Sensor.TYPE_STEP_COUNTER,
                Sensor.TYPE_RELATIVE_HUMIDITY,
            )

            sensorTypes.forEach { type ->
                val sensor = manager.getDefaultSensor(type)
                if (sensor != null) {
                    manager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_NORMAL)
                    activeSensors.add(sensor)
                }
            }
        }
    }

    private fun stopSensorStreaming() {
        sensorManager?.let { manager ->
            activeSensors.forEach { manager.unregisterListener(this, it) }
            activeSensors.clear()
        }
    }

    override fun onDestroy() {
        stopSensorStreaming()
        super.onDestroy()
    }

    override fun onSensorChanged(event: SensorEvent) {
        val value = event.values.firstOrNull() ?: return
        val payload = mapOf(
            "sensorType" to event.sensor.type,
            "timestamp" to event.timestamp,
            "accuracy" to event.accuracy,
            "value" to value
        )
        eventSink?.success(payload)
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // No-op; propagate accuracy in sensor events instead.
    }
}
