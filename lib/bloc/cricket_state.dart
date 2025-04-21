import 'package:cricket_score_app/models/cricket_score.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoadInProgress extends UserState {}

class UserLoadSuccess extends UserState {
  final UserDataModel userData;

  const UserLoadSuccess(this.userData);

  @override
  List<Object> get props => [userData];
}

class UserLoadFailure extends UserState {
  final String error;

  const UserLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
