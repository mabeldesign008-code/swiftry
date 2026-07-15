class Rider {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? photoUrl;
  final double rating;
  final int totalDeliveries;
  final bool isOnline;
  final bool isVerified;
  final String? ghanaCardNumber;
  final String vehicleType; // bike, motor, car, foot

  const Rider({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.photoUrl,
    this.rating = 5.0,
    this.totalDeliveries = 0,
    this.isOnline = false,
    this.isVerified = false,
    this.ghanaCardNumber,
    this.vehicleType = 'motor',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'photo_url': photoUrl,
        'rating': rating,
        'total_deliveries': totalDeliveries,
        'is_online': isOnline,
        'is_verified': isVerified,
        'vehicle_type': vehicleType,
      };

  factory Rider.fromJson(Map<String, dynamic> json) => Rider(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
        photoUrl: json['photo_url'] as String?,
        rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
        totalDeliveries: json['total_deliveries'] as int? ?? 0,
        isOnline: json['is_online'] as bool? ?? false,
        isVerified: json['is_verified'] as bool? ?? false,
        vehicleType: json['vehicle_type'] as String? ?? 'motor',
      );
}

class Earnings {
  final double today;
  final double thisWeek;
  final double thisMonth;
  final double balance;
  final int deliveriesToday;

  const Earnings({
    this.today = 0,
    this.thisWeek = 0,
    this.thisMonth = 0,
    this.balance = 0,
    this.deliveriesToday = 0,
  });

  factory Earnings.fromJson(Map<String, dynamic> json) => Earnings(
        today: (json['today'] as num?)?.toDouble() ?? 0,
        thisWeek: (json['this_week'] as num?)?.toDouble() ?? 0,
        thisMonth: (json['this_month'] as num?)?.toDouble() ?? 0,
        balance: (json['balance'] as num?)?.toDouble() ?? 0,
        deliveriesToday: json['deliveries_today'] as int? ?? 0,
      );
}
