/// Mentor model for matched mentors

class Mentor {
  final int mentorId;
  final String mentorName;
  final String mentorEmail;
  final String mentorCidade;
  final String mentorEstado;
  final String mentorFormacao;
  final String mentorCargo;
  final String mentorPontosFortes;
  final String mentorSobre;
  final double score;
  final double geoScore;
  final double interestScore;
  final double semanticScore;
  final double bonusScore;
  final List<String> commonInterests;
  final List<String> matchReasons;

  Mentor({
    required this.mentorId,
    required this.mentorName,
    required this.mentorEmail,
    required this.mentorCidade,
    required this.mentorEstado,
    required this.mentorFormacao,
    required this.mentorCargo,
    required this.mentorPontosFortes,
    required this.mentorSobre,
    required this.score,
    required this.geoScore,
    required this.interestScore,
    required this.semanticScore,
    required this.bonusScore,
    required this.commonInterests,
    required this.matchReasons,
  });

  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
      mentorId: json['mentor_id'] as int? ?? 0,
      mentorName: json['mentor_name'] as String? ?? '',
      mentorEmail: json['mentor_email'] as String? ?? '',
      mentorCidade: json['mentor_cidade'] as String? ?? '',
      mentorEstado: json['mentor_estado'] as String? ?? '',
      mentorFormacao: json['mentor_formacao'] as String? ?? '',
      mentorCargo: json['mentor_cargo'] as String? ?? '',
      mentorPontosFortes: json['mentor_pontos_fortes'] as String? ?? '',
      mentorSobre: json['mentor_sobre'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      geoScore: (json['geo_score'] as num?)?.toDouble() ?? 0.0,
      interestScore: (json['interest_score'] as num?)?.toDouble() ?? 0.0,
      semanticScore: (json['semantic_score'] as num?)?.toDouble() ?? 0.0,
      bonusScore: (json['bonus_score'] as num?)?.toDouble() ?? 0.0,
      commonInterests:
          (json['common_interests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      matchReasons:
          (json['match_reasons'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mentor_id': mentorId,
      'mentor_name': mentorName,
      'mentor_email': mentorEmail,
      'mentor_cidade': mentorCidade,
      'mentor_estado': mentorEstado,
      'mentor_formacao': mentorFormacao,
      'mentor_cargo': mentorCargo,
      'mentor_pontos_fortes': mentorPontosFortes,
      'mentor_sobre': mentorSobre,
      'score': score,
      'geo_score': geoScore,
      'interest_score': interestScore,
      'semantic_score': semanticScore,
      'bonus_score': bonusScore,
      'common_interests': commonInterests,
      'match_reasons': matchReasons,
    };
  }

  /// Get match percentage as integer (score is already 0-100)
  int get matchPercentage => score.round();

  /// Get location string
  String get location => '$mentorCidade, $mentorEstado';

  /// Get strengths as list
  List<String> get strengthsList =>
      mentorPontosFortes.split(',').map((e) => e.trim()).toList();
}

/// Response model for mentors API
class MentorsResponse {
  final int menteeId;
  final int totalMentorsFound;
  final List<Mentor> matches;

  MentorsResponse({
    required this.menteeId,
    required this.totalMentorsFound,
    required this.matches,
  });

  factory MentorsResponse.fromJson(Map<String, dynamic> json) {
    return MentorsResponse(
      menteeId: json['mentee_id'] as int? ?? 0,
      totalMentorsFound: json['total_mentors_found'] as int? ?? 0,
      matches:
          (json['matches'] as List<dynamic>?)
              ?.map((e) => Mentor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mentee_id': menteeId,
      'total_mentors_found': totalMentorsFound,
      'matches': matches.map((e) => e.toJson()).toList(),
    };
  }
}
