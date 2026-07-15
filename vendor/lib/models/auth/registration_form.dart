/// Registration form model matching FormData from React app
/// This tracks the entire 5-step registration flow
class RegistrationForm {
  // Step 1: Business Type
  String businessType;

  // Step 2: Business Information
  String businessName;
  String businessDescription;
  String businessPhone;
  String businessEmail;
  String region;
  String city;
  String streetAddress;
  String landmark;
  String digitalAddress;
  double? latitude;
  double? longitude;

  // Step 3: Owner Information
  String ownerName;
  String ownerRole;
  String ownerPhone;
  String ownerEmail;
  String NigeriaCardNumber;
  bool identityVerified;

  // Step 4: Documents
  String? businessRegistrationDoc;
  String? taxIdentificationNumber;
  String? ownerIdDocument;
  String? businessPermit;
  bool documentsUploaded;

  // Step 5: Bank Details
  String bankName;
  String accountNumber;
  String accountName;
  String branchName;
  bool bankDetailsVerified;

  RegistrationForm({
    this.businessType = '',
    this.businessName = '',
    this.businessDescription = '',
    this.businessPhone = '',
    this.businessEmail = '',
    this.region = 'Greater Accra',
    this.city = 'Accra',
    this.streetAddress = '',
    this.landmark = '',
    this.digitalAddress = '',
    this.latitude,
    this.longitude,
    this.ownerName = '',
    this.ownerRole = 'Owner',
    this.ownerPhone = '',
    this.ownerEmail = '',
    this.NigeriaCardNumber = '',
    this.identityVerified = false,
    this.businessRegistrationDoc,
    this.taxIdentificationNumber,
    this.ownerIdDocument,
    this.businessPermit,
    this.documentsUploaded = false,
    this.bankName = '',
    this.accountNumber = '',
    this.accountName = '',
    this.branchName = '',
    this.bankDetailsVerified = false,
  });

  /// Create a copy with updated fields
  RegistrationForm copyWith({
    String? businessType,
    String? businessName,
    String? businessDescription,
    String? businessPhone,
    String? businessEmail,
    String? region,
    String? city,
    String? streetAddress,
    String? landmark,
    String? digitalAddress,
    double? latitude,
    double? longitude,
    String? ownerName,
    String? ownerRole,
    String? ownerPhone,
    String? ownerEmail,
    String? NigeriaCardNumber,
    bool? identityVerified,
    String? businessRegistrationDoc,
    String? taxIdentificationNumber,
    String? ownerIdDocument,
    String? businessPermit,
    bool? documentsUploaded,
    String? bankName,
    String? accountNumber,
    String? accountName,
    String? branchName,
    bool? bankDetailsVerified,
  }) {
    return RegistrationForm(
      businessType: businessType ?? this.businessType,
      businessName: businessName ?? this.businessName,
      businessDescription: businessDescription ?? this.businessDescription,
      businessPhone: businessPhone ?? this.businessPhone,
      businessEmail: businessEmail ?? this.businessEmail,
      region: region ?? this.region,
      city: city ?? this.city,
      streetAddress: streetAddress ?? this.streetAddress,
      landmark: landmark ?? this.landmark,
      digitalAddress: digitalAddress ?? this.digitalAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      ownerName: ownerName ?? this.ownerName,
      ownerRole: ownerRole ?? this.ownerRole,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      NigeriaCardNumber: NigeriaCardNumber ?? this.NigeriaCardNumber,
      identityVerified: identityVerified ?? this.identityVerified,
      businessRegistrationDoc: businessRegistrationDoc ?? this.businessRegistrationDoc,
      taxIdentificationNumber: taxIdentificationNumber ?? this.taxIdentificationNumber,
      ownerIdDocument: ownerIdDocument ?? this.ownerIdDocument,
      businessPermit: businessPermit ?? this.businessPermit,
      documentsUploaded: documentsUploaded ?? this.documentsUploaded,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      branchName: branchName ?? this.branchName,
      bankDetailsVerified: bankDetailsVerified ?? this.bankDetailsVerified,
    );
  }

  /// Validate step 1
  bool isStep1Valid() => businessType.isNotEmpty;

  /// Validate step 2
  bool isStep2Valid() => businessName.trim().length >= 3;

  /// Validate step 3
  bool isStep3Valid() =>
      ownerName.isNotEmpty &&
      ownerPhone.isNotEmpty &&
      ownerEmail.isNotEmpty;

  /// Validate step 4
  bool isStep4Valid() => documentsUploaded;

  /// Validate step 5
  bool isStep5Valid() =>
      bankName.isNotEmpty &&
      accountNumber.isNotEmpty &&
      accountName.isNotEmpty;

  /// Check if all steps are complete
  bool isComplete() =>
      isStep1Valid() &&
      isStep2Valid() &&
      isStep3Valid() &&
      isStep4Valid() &&
      isStep5Valid();
}
