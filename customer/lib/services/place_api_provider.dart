import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import '../models/place_models.dart';

/// Provides Google Places API autocomplete and place details functionality.
/// Adapted from Houzi's PlaceApiProvider with session token management.
class PlaceApiProvider {
  PlaceApiProvider(this.sessionToken);

  final String sessionToken;

  static final options = CacheOptions(
    store: MemCacheStore(),
    policy: CachePolicy.request,
    hitCacheOnErrorExcept: [401, 403],
    maxStale: const Duration(minutes: 60),
    priority: CachePriority.normal,
    cipher: null,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: false,
  );

  /// Your Google Maps API key - must be configured in app constants
  static const String _apiKey = ''; // TODO: Add your Google Maps API key here

  /// Fetches autocomplete suggestions for a given input string.
  /// Returns list of [Suggestion] objects with placeId and description.
  Future<List<Suggestion>> fetchSuggestions(String input) async {
    if (input.isEmpty) return [];
    
    final request = 'https://maps.googleapis.com/maps/api/place/autocomplete/'
        'json?input=$input&key=$_apiKey&sessiontoken=$sessionToken';

    final dio = Dio()
      ..interceptors.add(DioCacheInterceptor(options: options));

    try {
      final response = await dio.get(request);
      if (response.statusCode == 200 || response.statusCode == 304) {
        final predictions = response.data['predictions'] as List;
        return predictions.map<Suggestion>((p) {
          return Suggestion(p['place_id'], p['description']);
        }).toList();
      } else {
        throw Exception('Failed to fetch suggestions');
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
      return [];
    }
  }

  /// Gets full place details (lat/lng, formatted address) from a place ID.
  /// Returns [PlaceDetails] with location coordinates.
  static Future<PlaceDetails?> getPlaceDetailFromPlaceId(String placeId) async {
    final request = 'https://maps.googleapis.com/maps/api/place/details/'
        'json?place_id=$placeId&key=$_apiKey';

    final dio = Dio()
      ..interceptors.add(DioCacheInterceptor(options: options));

    try {
      final response = await dio.get(request);
      if (response.statusCode == 200 || response.statusCode == 304) {
        final placeInfo = response.data ?? {};

        if (placeInfo.isEmpty || placeInfo.containsKey('error_message')) {
          return null;
        }

        final geometry = placeInfo['result']?['geometry']?['location'];
        if (geometry == null) return null;

        final latitude = geometry['lat'];
        final longitude = geometry['lng'];
        final formattedAddress = placeInfo['result']?['formatted_address'] ?? '';

        return PlaceDetails(
          location: formattedAddress,
          latitude: latitude?.toDouble(),
          longitude: longitude?.toDouble(),
          latitudeStr: latitude?.toString(),
          longitudeStr: longitude?.toString(),
        );
      }
      return null;
    } catch (e) {
      print('Error fetching place details: $e');
      return null;
    }
  }

  /// Reverse geocode: get place details from coordinates (lat,lng string).
  static Future<PlaceDetails?> getPlaceDetailsFromCoordinates(
      String coordinates) async {
    final request = 'https://maps.googleapis.com/maps/api/geocode/'
        'json?latlng=$coordinates&key=$_apiKey';

    final dio = Dio()
      ..interceptors.add(DioCacheInterceptor(options: options));

    try {
      final response = await dio.get(request);
      if (response.statusCode == 200 || response.statusCode == 304) {
        final results = response.data['results'] as List?;
        if (results == null || results.isEmpty) return null;

        final firstResult = results[0];
        final geometry = firstResult['geometry']?['location'];
        final formattedAddress = firstResult['formatted_address'] ?? '';

        return PlaceDetails(
          location: formattedAddress,
          latitude: geometry?['lat']?.toDouble(),
          longitude: geometry?['lng']?.toDouble(),
          latitudeStr: geometry?['lat']?.toString(),
          longitudeStr: geometry?['lng']?.toString(),
        );
      }
      return null;
    } catch (e) {
      print('Error reverse geocoding: $e');
      return null;
    }
  }
}
