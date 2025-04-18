import 'package:cricket_score_app/widgets/score_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cricket_bloc.dart';
import '../bloc/cricket_state.dart';

class CricketScoresScreen extends StatelessWidget {
  const CricketScoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Cricket Scores'),
      ),
      body: BlocBuilder<CricketBloc, CricketState>(
        builder: (context, state) {
          if (state is CricketInitial || state is CricketLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CricketLoadFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is CricketLoadSuccess) {
            return ScoresList(scores: state.scores);
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}