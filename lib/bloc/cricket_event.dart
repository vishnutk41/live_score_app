import 'package:equatable/equatable.dart';

abstract class CricketEvent extends Equatable {
  const CricketEvent();

  @override
  List<Object> get props => [];
}

class FetchCricketScores extends CricketEvent {}