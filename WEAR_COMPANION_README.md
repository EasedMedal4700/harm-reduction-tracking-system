# Wear Companion (Galaxy Watch 8)

The `wear_companion_app/` directory contains a dedicated Wear OS build for Galaxy Watch devices (Samsung Watch 8 and newer). It focuses on harvesting as many on-device vitals as possible and streaming them to Flutter for eventual syncing with Supabase.

## Highlights

- **Native sensor bridge:** `android/app/src/main/kotlin/.../MainActivity.kt` registers listeners for heart rate, body temperature, ambient temperature, humidity, and the step counter. Data arrives in Flutter through an `EventChannel` as high-frequency samples.
- **Permission-aware UI:** `lib/main.dart` requests body-sensor + activity-recognition permissions with a single tap and surfaces any failures inline.
- **Vitals dashboard:** A grid-based display shows latest heart rate, temperatures, humidity, and steps with timestamps so you can verify the watch feed even before wiring it into the primary mobile app.
- **Extensible controller:** `WearSensorController` centralizes the method/event channel wiring so future uploads to Supabase or background isolates can reuse the same stream.

## Running the watch app

```bash
cd wear_companion_app
flutter run -d wear_os  # or the device ID reported by `flutter devices`
```

On first launch tap **Enable body sensors** so the runtime permissions are granted. Metrics start streaming immediately after.

## Syncing to Supabase / Mobile App

1. Add a lightweight HTTPS endpoint (Edge Function) that accepts sensor payloads. The watch app can `invokeMethod('uploadSample', sample.toJson())` or call Supabase REST once the anon key is bundled.
2. Use `WearSensorController.sensorStream` to push readings into Supabase using the same auth tokens as the phone app (recommended approach: pair the watch with the phone via shared secure storage + Supabase session token).
3. In the primary app, create a Supabase table such as `wear_samples` with columns for `user_id`, `sensor_type`, `value`, `recorded_at`, and `accuracy`. The watch payload already provides everything needed.

## Next steps

- Enable Foreground Service + `WorkManager` so the sensors keep streaming when the UI is backgrounded.
- If body temperature is unavailable on your watch, swap in additional sensors (ECG availability, blood oxygen, gyroscope, etc.) by adding the right sensor constants in `MainActivity.kt` and the `sensorConfigs` map.
- Hook up secure pairing with the existing mobile app to automatically associate the watch samples with the signed-in Supabase user.
