import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cricket_score_app/bloc/cricket_event.dart';
import 'package:cricket_score_app/bloc/cricket_state.dart';
import 'package:cricket_score_app/models/cricket_score.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CricketBloc extends Bloc<CricketEvent, CricketState> {
  final String apiUrl = 'https://mp357760872f36b8d270.free.beeceptor.com/data';
  Timer? _timer;

  CricketBloc() : super(CricketInitial()) {
    on<FetchCricketScores>(_onFetchCricketScores);
    // Start polling immediately when the bloc is created
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
    final response = await http.get(Uri.parse(apiUrl));
    print(response);
    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
          print(data);

      List<CricketScore> scores = [];
      
      if (data is List) {
        // Handle array response
        scores = data.map((json) => CricketScore.fromJson(json)).toList();
      } else if (data is Map<String, dynamic>) {
        // Handle single object response
        scores = [CricketScore.fromJson(data)];
      } 
      
      emit(CricketLoadSuccess(scores));
    } else {
      emit(CricketLoadFailure('Failed to load scores'));
    }
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