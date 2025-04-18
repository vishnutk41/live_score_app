import 'package:cricket_score_app/bloc/cricket_event.dart';
import 'package:cricket_score_app/models/cricket_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../bloc/cricket_bloc.dart';


class ScoresList extends StatefulWidget {
  final List<CricketScore> scores;

  const ScoresList({super.key, required this.scores});

  @override
  State<ScoresList> createState() => _ScoresListState();
}

class _ScoresListState extends State<ScoresList> {
  @override
  Widget build(BuildContext context) {
    if (widget.scores.isEmpty) {
      return const Center(
        child: Text('No matches currently available'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CricketBloc>().add(FetchCricketScores());
      },
      child: ListView.builder(
        itemCount: widget.scores.length,
        itemBuilder: (context, index) {
          final score = widget.scores[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${score.team1} vs ${score.team2}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    score.score,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        score.status,
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        'Updated: ${_formatTime(score.lastUpdated)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}