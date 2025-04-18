import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cricket_score_app/bloc/cricket_event.dart';
import 'package:cricket_score_app/bloc/cricket_state.dart';
import 'package:cricket_score_app/models/cricket_score.dart';
import 'package:dio/dio.dart';

class CricketBloc extends Bloc<CricketEvent, CricketState> {
  final String apiUrl = 'https://mp357760872f36b8d270.free.beeceptor.com/data';
  final Dio _dio = Dio();
  Timer? _timer;

  CricketBloc() : super(CricketInitial()) {
    on<FetchCricketScores>(_onFetchCricketScores);
    _startPolling();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      add(FetchCricketScores());
    });
  }

  Future<void> _onFetchCricketScores(
    FetchCricketScores event,
    Emitter<CricketState> emit,
  ) async {
    emit(CricketLoadInProgress());
    try {
      final response = await _dio.get(apiUrl);
      print(response.data);

      List<CricketScore> scores = [];

      if (response.data is List) {
        scores = (response.data as List)
            .map((json) => CricketScore.fromJson(json))
            .toList();
      } else if (response.data is Map<String, dynamic>) {
        scores = [CricketScore.fromJson(response.data)];
      }

      emit(CricketLoadSuccess(scores));
    } catch (e) {
      emit(CricketLoadFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}