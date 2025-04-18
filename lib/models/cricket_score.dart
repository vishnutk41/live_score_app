class CricketScore {
  final String matchId;
  final String team1;
  final String team2;
  final String score;
  final String status;
  final DateTime lastUpdated;

  CricketScore({
    required this.matchId,
    required this.team1,
    required this.team2,
    required this.score,
    required this.status,
    required this.lastUpdated,
  });

factory CricketScore.fromJson(Map<String, dynamic> json) {
  try {
    return CricketScore(
      matchId: json['matchId']?.toString() ?? 'N/A',
      team1: json['team1']?.toString() ?? 'Team 1',
      team2: json['team2']?.toString() ?? 'Team 2',
      score: json['score']?.toString() ?? '0/0 (0.0)',
      status: json['status']?.toString() ?? 'Match about to begin',
      lastUpdated: _parseDateTime(json['lastUpdated']),
    );
  } catch (e) {
    // Return default values if parsing fails
    return CricketScore(
      matchId: 'N/A',
      team1: 'Team 1',
      team2: 'Team 2',
      score: '0/0 (0.0)',
      status: 'Match data unavailable',
      lastUpdated: DateTime.now(),
    );
  }
}

static DateTime _parseDateTime(dynamic dateTime) {
  if (dateTime == null) return DateTime.now();
  try {
    return DateTime.parse(dateTime.toString());
  } catch (e) {
    return DateTime.now();
  }
}
}