import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AppInitializer {
  static Future<void> initialize() async {
    // Initialize timezone data for notifications
    tz.initializeTimeZones();

    // Set default timezone (you can change this based on user's location)
    tz.setLocalLocation(tz.getLocation('UTC'));
  }
}
