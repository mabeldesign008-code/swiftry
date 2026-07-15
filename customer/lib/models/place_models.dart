/// Google Places autocomplete suggestion.
/// Contains place ID and human-readable description.
class Suggestion {
  final String? placeId;
  final String? description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() => description ?? '';
}

/// Detailed place information including coordinates.
/// Returned after selecting a suggestion and fetching full details.
class PlaceDetails {
  final String? location;       // Formatted address string
  final double? latitude;
  final double? longitude;
  final String? latitudeStr;    // String version for display
  final String? longitudeStr;

  PlaceDetails({
    this.location,
    this.latitude,
    this.longitude,
    this.latitudeStr,
    this.longitudeStr,
  });

  @override
  String toString() => location ?? '';
}
