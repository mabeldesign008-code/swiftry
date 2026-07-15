/// Represents a saved or entered delivery address.
/// Updated: GhanaPostGPS is primary (Ghana launch), NigeriaPost kept as deprecated alias
/// for backward compatibility. Backend should store as `ghana_post` / `gps_address`.

class Address {
  final String type;                 // 'Home', 'Work', 'School', 'Other'
  final String label;                // custom label (same as type or custom text)
  final String street;               // street/area text description
  final String ghanaPost;            // GhanaPostGPS digital address e.g. "GA-123-4567"
  final String what3words;           // what3words address
  final double? latitude;
  final double? longitude;
  final String areaName;             // from reverse geocoding e.g. "Osu"
  final String landmark;             // user typed e.g. "Behind MTN mast, near Papaye"
  final String deliveryInstructions; // e.g. "Call when you arrive, blue gate"
  final String contactPhone;         // contact phone for this address
  final bool isSelected;
  final bool isDefault;

  const Address({
    this.type = 'Home',
    this.label = '',
    required this.street,
    this.ghanaPost = '',
    String? NigeriaPost, // deprecated alias - kept for backward compat
    this.what3words = '',
    this.latitude,
    this.longitude,
    this.areaName = '',
    this.landmark = '',
    this.deliveryInstructions = '',
    this.contactPhone = '',
    this.isSelected = false,
    this.isDefault = false,
  }) : _deprecatedNigeriaPost = NigeriaPost;

  final String? _deprecatedNigeriaPost;

  /// Backward compat getter - reads ghanaPost first, then old NigeriaPost if still passed
  String get NigeriaPost => ghanaPost.isNotEmpty ? ghanaPost : (_deprecatedNigeriaPost ?? '');

  Address copyWith({
    String? type,
    String? label,
    String? street,
    String? ghanaPost,
    String? NigeriaPost,
    String? what3words,
    double? latitude,
    double? longitude,
    String? areaName,
    String? landmark,
    String? deliveryInstructions,
    String? contactPhone,
    bool? isSelected,
    bool? isDefault,
  }) {
    final resolvedGhanaPost = ghanaPost ?? NigeriaPost ?? this.ghanaPost;
    return Address(
      type: type ?? this.type,
      label: label ?? this.label,
      street: street ?? this.street,
      ghanaPost: resolvedGhanaPost,
      what3words: what3words ?? this.what3words,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      areaName: areaName ?? this.areaName,
      landmark: landmark ?? this.landmark,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      contactPhone: contactPhone ?? this.contactPhone,
      isSelected: isSelected ?? this.isSelected,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  /// Returns the best available display string:
  /// prefer landmark if set, else areaName, else street, else ghanaPost, else type.
  String get displayLabel {
    if (landmark.isNotEmpty) return landmark;
    if (areaName.isNotEmpty) return areaName;
    if (street.isNotEmpty) return street;
    if (ghanaPost.isNotEmpty) return ghanaPost;
    if ((_deprecatedNigeriaPost ?? '').isNotEmpty) return _deprecatedNigeriaPost!;
    return type;
  }

  /// Short version: prefer areaName, else first 30 chars of street, else type.
  String get shortDisplay {
    if (areaName.isNotEmpty) return areaName;
    if (street.isNotEmpty) {
      return street.length > 30 ? '${street.substring(0, 30)}...' : street;
    }
    return type;
  }

  // --- JSON serialization for backend handover ---

  Map<String, dynamic> toJson() => {
        'type': type,
        'label': label,
        'street': street,
        'ghana_post': ghanaPost,
        'gps_address': ghanaPost, // alias for backend
        'what3words': what3words,
        'latitude': latitude,
        'longitude': longitude,
        'area_name': areaName,
        'landmark': landmark,
        'delivery_instructions': deliveryInstructions,
        'contact_phone': contactPhone,
        'is_selected': isSelected,
        'is_default': isDefault,
      };

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      type: json['type'] as String? ?? 'Home',
      label: json['label'] as String? ?? '',
      street: json['street'] as String? ?? '',
      ghanaPost: (json['ghana_post'] ?? json['gps_address'] ?? json['ghanaPost'] ?? json['NigeriaPost'] ?? '') as String,
      what3words: json['what3words'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      areaName: json['area_name'] as String? ?? json['areaName'] as String? ?? '',
      landmark: json['landmark'] as String? ?? '',
      deliveryInstructions: json['delivery_instructions'] as String? ?? json['deliveryInstructions'] as String? ?? '',
      contactPhone: json['contact_phone'] as String? ?? json['contactPhone'] as String? ?? '',
      isSelected: json['is_selected'] as bool? ?? json['isSelected'] as bool? ?? false,
      isDefault: json['is_default'] as bool? ?? json['isDefault'] as bool? ?? false,
    );
  }

  @override
  String toString() => displayLabel;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          runtimeType == other.runtimeType &&
          street == other.street &&
          ghanaPost == other.ghanaPost &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => Object.hash(street, ghanaPost, latitude, longitude);
}
