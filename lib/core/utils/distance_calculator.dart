import 'dart:math';

class DistanceCalculator {
  DistanceCalculator._();

  static double calculateDistanceKm({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const double earthRadiusKm = 6371;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final double a =
        pow(sin(dLat / 2), 2).toDouble() +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            pow(sin(dLon / 2), 2).toDouble();

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
