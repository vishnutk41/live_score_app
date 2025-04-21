import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cricket_score_app/bloc/cricket_event.dart';
import 'package:cricket_score_app/bloc/cricket_state.dart';
import 'package:cricket_score_app/models/cricket_score.dart';
import 'package:dio/dio.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final String apiUrl = 'https://mp357760872f36b8d270.free.beeceptor.com/data';
  final Dio _dio = Dio();
  StreamSubscription? _userSubscription;

  UserBloc() : super(UserInitial()) {
    _dio.options.validateStatus = (status) => true;

    on<StartUserStream>(_onStartUserStream);
    add(StartUserStream());
  }

  Future<void> _onStartUserStream(
    StartUserStream event,
    Emitter<UserState> emit,
  ) async {
    _userSubscription?.cancel();

    await _fetchData(emit);

    _userSubscription = Stream.periodic(const Duration(seconds: 5))
        .asyncMap((_) => _fetchData(emit))
        .listen((_) {});
  }

  Future<void> _fetchData(Emitter<UserState> emit) async {
    try {
      final response = await _dio.get(apiUrl);

      if (response.statusCode == 200) {
        final userData = UserDataModel.fromJson(response.data);
        if (!emit.isDone) {
          emit(UserLoadSuccess(userData));
        }
      } else if (response.statusCode == 429) {
        print('Rate limited - will retry shortly');
      } else {
        if (!emit.isDone) {
          emit(UserLoadFailure('Server returned ${response.statusCode}'));
        }
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(UserLoadFailure('Error fetching data: $e'));
      }
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
