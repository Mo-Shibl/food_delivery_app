import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/networking/api_result.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(ProfileInitial());

  String? currentUsercode;
  String? currentEmail;

  Future<void> loadProfile() async {
    emit(ProfileLoading());

    final emailResult = await _profileRepository.getEmail();
    final usercodeResult = await _profileRepository.getUsercode();

    if (emailResult is ApiSuccess<String?> && usercodeResult is ApiSuccess<String?>) {
      currentEmail = emailResult.data;
      currentUsercode = usercodeResult.data;
      emit(ProfileLoaded(email: currentEmail ?? '', usercode: currentUsercode ?? ''));
    } else {
      String message = 'Failed to load profile data';
      if (emailResult is ApiFailure<String?>) {
        message = emailResult.message;
      } else if (usercodeResult is ApiFailure<String?>) {
        message = usercodeResult.message;
      }
      emit(ProfileError(message));
    }
  }

  Future<void> logout() async {
    emit(ProfileLoading());
    final result = await _profileRepository.logout();
    if (result is ApiSuccess<void>) {
      emit(ProfileLoggedOut());
    } else if (result is ApiFailure<void>) {
      emit(ProfileError(result.message));
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (currentUsercode == null || currentEmail == null) {
      emit(const ProfileError('User session not found. Please log in again.'));
      return;
    }

    emit(ProfileLoading());

    // Step 1: Verify current password by attempting to get the usercode again
    final verifyResult = await _profileRepository.verifyPassword(currentEmail!, currentPassword);

    if (verifyResult is ApiFailure) {
      emit(const ProfileError('The current password you entered is incorrect.'));
      emit(ProfileLoaded(email: currentEmail!, usercode: currentUsercode!));
      return;
    }

    // Step 2: Proceed to update with the new password
    final changeResult = await _profileRepository.changePassword(currentUsercode!, newPassword);

    if (changeResult is ApiSuccess) {
      emit(ChangePasswordSuccess());
      emit(ProfileLoaded(email: currentEmail!, usercode: currentUsercode!));
    } else if (changeResult is ApiFailure) {
      emit(ProfileError(changeResult.message));
      emit(ProfileLoaded(email: currentEmail!, usercode: currentUsercode!));
    }
  }

  Future<void> deleteAccount() async {
    if (currentUsercode == null) {
      emit(const ProfileError('User session not found.'));
      return;
    }

    emit(ProfileLoading());
    final result = await _profileRepository.deleteAccount(currentUsercode!);
    if (result is ApiSuccess<void>) {
      emit(DeleteAccountSuccess());
    } else if (result is ApiFailure<void>) {
      emit(ProfileError(result.message));
      emit(ProfileLoaded(email: currentEmail ?? '', usercode: currentUsercode ?? ''));
    }
  }
}
