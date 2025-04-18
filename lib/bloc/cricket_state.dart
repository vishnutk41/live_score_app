import 'package:equatable/equatable.dart';
import '../models/cricket_score.dart';

abstract class CricketState extends Equatable {
  const CricketState();

  @override
  List<Object> get props => [];
}

class CricketInitial extends CricketState {}

class CricketLoadInProgress extends CricketState {}

class CricketLoadSuccess extends CricketState {
  final List<CricketScore> scores;

  const CricketLoadSuccess(this.scores);

  @override
  List<Object> get props => [scores];
}

class CricketLoadFailure extends CricketState {
  final String error;

  const CricketLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}