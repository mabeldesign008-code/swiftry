import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/auth/registration_form.dart';

/// Registration form state provider
/// Manages the entire 5-step registration flow
class RegistrationNotifier extends Notifier<RegistrationForm> {
  @override
  RegistrationForm build() => RegistrationForm();

  /// Update a single field in the form
  void updateField(String field, dynamic value) {
    switch (field) {
      // Step 1
      case 'businessType':
        state = state.copyWith(businessType: value as String);
        break;

      // Step 2
      case 'businessName':
        state = state.copyWith(businessName: value as String);
        break;
      case 'businessDescription':
        state = state.copyWith(businessDescription: value as String);
        break;
      case 'businessPhone':
        state = state.copyWith(businessPhone: value as String);
        break;
      case 'businessEmail':
        state = state.copyWith(businessEmail: value as String);
        break;
      case 'region':
        state = state.copyWith(region: value as String);
        break;
      case 'city':
        state = state.copyWith(city: value as String);
        break;
      case 'streetAddress':
        state = state.copyWith(streetAddress: value as String);
        break;
      case 'landmark':
        state = state.copyWith(landmark: value as String);
        break;
      case 'digitalAddress':
        state = state.copyWith(digitalAddress: value as String);
        break;
      case 'latitude':
        state = state.copyWith(latitude: value as double?);
        break;
      case 'longitude':
        state = state.copyWith(longitude: value as double?);
        break;

      // Step 3
      case 'ownerName':
        state = state.copyWith(ownerName: value as String);
        break;
      case 'ownerRole':
        state = state.copyWith(ownerRole: value as String);
        break;
      case 'ownerPhone':
        state = state.copyWith(ownerPhone: value as String);
        break;
      case 'ownerEmail':
        state = state.copyWith(ownerEmail: value as String);
        break;
      case 'NigeriaCardNumber':
        state = state.copyWith(NigeriaCardNumber: value as String);
        break;
      case 'identityVerified':
        state = state.copyWith(identityVerified: value as bool);
        break;

      // Step 4
      case 'businessRegistrationDoc':
        state = state.copyWith(businessRegistrationDoc: value as String?);
        break;
      case 'taxIdentificationNumber':
        state = state.copyWith(taxIdentificationNumber: value as String?);
        break;
      case 'ownerIdDocument':
        state = state.copyWith(ownerIdDocument: value as String?);
        break;
      case 'businessPermit':
        state = state.copyWith(businessPermit: value as String?);
        break;
      case 'documentsUploaded':
        state = state.copyWith(documentsUploaded: value as bool);
        break;

      // Step 5
      case 'bankName':
        state = state.copyWith(bankName: value as String);
        break;
      case 'accountNumber':
        state = state.copyWith(accountNumber: value as String);
        break;
      case 'accountName':
        state = state.copyWith(accountName: value as String);
        break;
      case 'branchName':
        state = state.copyWith(branchName: value as String);
        break;
      case 'bankDetailsVerified':
        state = state.copyWith(bankDetailsVerified: value as bool);
        break;
    }
  }

  /// Reset the form
  void reset() {
    state = RegistrationForm();
  }

  /// Submit the registration
  Future<bool> submit() async {
    if (!state.isComplete()) {
      return false;
    }

    // TODO: Implement API call to submit registration
    // For now, just simulate success
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}

/// Provider for registration state
final registrationProvider =
    NotifierProvider<RegistrationNotifier, RegistrationForm>(
  () => RegistrationNotifier(),
);

/// Current step provider
class _StepNotifier extends Notifier<int> {
  @override
  int build() => 1;

  void setStep(int step) => state = step;
  void nextStep() => state++;
  void prevStep() => state = (state > 1) ? state - 1 : 1;
}

final registrationStepProvider =
    NotifierProvider<_StepNotifier, int>(() => _StepNotifier());
