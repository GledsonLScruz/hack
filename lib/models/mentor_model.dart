/// Mentor model for matched mentors

class Mentor {
  final int id;
  final String nome;
  final String? foto;
  final double matchScore;
  final String descricao;
  final String? cargo;
  final String? empresa;
  final String? formacao;
  final String? areasExpertise;

  Mentor({
    required this.id,
    required this.nome,
    this.foto,
    required this.matchScore,
    required this.descricao,
    this.cargo,
    this.empresa,
    this.formacao,
    this.areasExpertise,
  });

  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
      id: json['id'] as int? ?? 0,
      nome: json['nome'] as String? ?? '',
      foto: json['foto'] as String?,
      matchScore: (json['match_score'] as num?)?.toDouble() ?? 0.0,
      descricao: json['descricao'] as String? ?? '',
      cargo: json['cargo'] as String?,
      empresa: json['empresa'] as String?,
      formacao: json['formacao'] as String?,
      areasExpertise: json['areas_expertise'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'foto': foto,
      'match_score': matchScore,
      'descricao': descricao,
      'cargo': cargo,
      'empresa': empresa,
      'formacao': formacao,
      'areas_expertise': areasExpertise,
    };
  }

  /// Get match percentage as integer
  int get matchPercentage => (matchScore * 100).round();
}

/// Response model for mentors API
class MentorsResponse {
  final List<Mentor> mentors;
  final int total;

  MentorsResponse({
    required this.mentors,
    required this.total,
  });

  factory MentorsResponse.fromJson(Map<String, dynamic> json) {
    return MentorsResponse(
      mentors: (json['mentors'] as List<dynamic>?)
              ?.map((e) => Mentor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mentors': mentors.map((e) => e.toJson()).toList(),
      'total': total,
    };
  }
}

