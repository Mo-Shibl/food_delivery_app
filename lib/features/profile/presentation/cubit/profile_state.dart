import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String email;
  final String usercode;

  const ProfileLoaded({required this.email, required this.usercode});

  @override
  List<Object?> get props => [email, usercode];
}

class ProfileLoggedOut extends ProfileState {}

class ChangePasswordSuccess extends ProfileState {}

class DeleteAccountSuccess extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}