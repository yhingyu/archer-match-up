import '../repositories/registration_repository.dart';

class ManageRegistration {
  final RegistrationRepository repository;

  ManageRegistration(this.repository);

  Future<void> acceptRegistration(String registrationId) async {
    await repository.updateRegistrationStatus(registrationId, isAccepted: true);
  }

  Future<void> rejectRegistration(String registrationId) async {
    await repository.updateRegistrationStatus(registrationId, isAccepted: false);
  }

  Future<void> deleteRegistration(String registrationId) async {
    await repository.deleteRegistration(registrationId);
  }
}