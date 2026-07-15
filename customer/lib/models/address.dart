/// Represents a saved or entered delivery address.
class Address {
  final String type;                 // 'Home', 'Work', 'School', 'Other'
  final String label;                // custom label (same as type or custom text)
  final String street;               // street/area text description
  final String NigeriaPost;            // NigeriaPostGPS digital address e.g. "GA-123-4567"
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
    this.NigeriaPost = '',
    this.what3words = '',
    this.latitude,
    this.longitude,
    this.areaName = '',
    this.landmark = '',
    this.deliveryInstructions = '',
    this.contactPhone = '',
    this.isSelected = false,
    this.isDefault = false,
  });

  Address copyWith({
    String? type,
    String? label,
    String? street,
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
    return Address(
      type: type ?? this.type,
      label: label ?? this.label,
      street: street ?? this.street,
      NigeriaPost: NigeriaPost ?? this.NigeriaPost,
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
  /// prefer landmark if set, else areaName, else street, else NigeriaPost, else type.
  String get displayLabel {
    if (landmark.isNotEmpty) return landmark;
    if (areaName.isNotEmpty) return areaName;
    if (street.isNotEmpty) return street;
    if (NigeriaPost.isNotEmpty) return NigeriaPost;
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

  @override
  String toString() => displayLabel;
}
