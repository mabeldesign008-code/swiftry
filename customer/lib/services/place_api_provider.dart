import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import '../models/place_models.dart';
import '../core/config/env.dart';
import '../core/network/api_client.dart';

/// Provides Google Places API autocomplete and place details.
/// Updated to use Env.googleMapsApiKey with --dart-define injection.
/// Also prepares for backend proxy (ApiEndpoints.placesAutocomplete) to avoid exposing key.

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

  /// API key sourced from Env - injected via --dart-define=GOOGLE_MAPS_API_KEY=xxx
  /// Fallback empty for dev, but logs warning.
  static String get _apiKey => Env.googleMapsApiKey;

  static bool get isConfigured => _apiKey.isNotEmpty;

  /// Fetches autocomplete suggestions.
  /// TODO Backend Option 1 (Recommended): Proxy through backend POST /places/autocomplete
  /// to hide API key. Then replace direct Google call with ApiClient().dio.post(ApiEndpoints.placesAutocomplete)
  /// TODO Option 2: Keep client-side but ensure key is restricted to app bundle ID in Google Cloud Console.
  Future<List<Suggestion>> fetchSuggestions(String input) async {
    if (input.isEmpty) return [];
    
    if (!isConfigured) {
      // ignore: avoid_print
      print('⚠️ GOOGLE_MAPS_API_KEY not configured. Run with --dart-define=GOOGLE_MAPS_API_KEY=YOUR_KEY. Returning empty suggestions.');
      // For dev without key, try backend proxy first?
      // return _fetchViaBackendProxy(input);
      return [];
    }

    final request = 'https://maps.googleapis.com/maps/api/place/autocomplete/'
        'json?input=$input&key=$_apiKey&sessiontoken=$sessionToken&components=country:gh';

    final dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));

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
      // ignore: avoid_print
      print('Error fetching suggestions: $e');
      return [];
    }
  }

  /// Alternative: fetch via backend proxy (no API key exposure)
  Future<List<Suggestion>> _fetchViaBackendProxy(String input) async {
    try {
      final dio = ApiClient().dio;
      final response = await dio.get(
        '/places/autocomplete',
        queryParameters: {'input': input, 'session_token': sessionToken},
      );
      final predictions = response.data['predictions'] as List? ?? [];
      return predictions.map<Suggestion>((p) {
        return Suggestion(p['place_id'], p['description']);
      }).toList();
    } catch (e) {
      // ignore: avoid_print
      print('Backend proxy autocomplete failed: $e');
      return [];
    }
  }

  static Future<PlaceDetails?> getPlaceDetailFromPlaceId(String placeId) async {
    if (!isConfigured) {
      // ignore: avoid_print
      print('⚠️ GOOGLE_MAPS_API_KEY not configured for place details.');
      return null;
    }

    final request = 'https://maps.googleapis.com/maps/api/place/details/'
        'json?place_id=$placeId&key=$_apiKey&fields=geometry,formatted_address';

    final dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));

    try {
      final response = await dio.get(request);
      if (response.statusCode == 200 || response.statusCode == 304) {
        final placeInfo = response.data ?? {};
        if (placeInfo.isEmpty || placeInfo.containsKey('error_message')) {
          // ignore: avoid_print
          print('Place details error: ${placeInfo['error_message']}');
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
      // ignore: avoid_print
      print('Error fetching place details: $e');
      return null;
    }
  }

  static Future<PlaceDetails?> getPlaceDetailsFromCoordinates(String coordinates) async {
    if (!isConfigured) {
      // ignore: avoid_print
      print('⚠️ GOOGLE_MAPS_API_KEY not configured for reverse geocode.');
      return null;
    }

    final request = 'https://maps.googleapis.com/maps/api/geocode/'
        'json?latlng=$coordinates&key=$_apiKey';

    final dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));

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
      // ignore: avoid_print
      print('Error reverse geocoding: $e');
      return null;
    }
  }
}
