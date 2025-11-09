/// Mentorship Request models

/// User info in mentorship request
class MentorshipUser {
  final int id;
  final String nome;
  final String email;
  final String cidade;
  final String estado;
  final String sobre;
  final String cargoAtual;
  final String formacaoAcademica;
  final String areasInteresse;
  final String pontosFortes;
  final bool isMentor;

  MentorshipUser({
    required this.id,
    required this.nome,
    required this.email,
    required this.cidade,
    required this.estado,
    required this.sobre,
    required this.cargoAtual,
    required this.formacaoAcademica,
    required this.areasInteresse,
    required this.pontosFortes,
    required this.isMentor,
  });

  factory MentorshipUser.fromJson(Map<String, dynamic> json) {
    return MentorshipUser(
      id: json['id'] as int? ?? 0,
      nome: json['nome'] as String? ?? '',
      email: json['email'] as String? ?? '',
      cidade: json['cidade'] as String? ?? '',
      estado: json['estado'] as String? ?? '',
      sobre: json['sobre'] as String? ?? '',
      cargoAtual: json['cargo_atual'] as String? ?? '',
      formacaoAcademica: json['formacao_academica'] as String? ?? '',
      areasInteresse: json['areas_interesse'] as String? ?? '',
      pontosFortes: json['pontos_fortes'] as String? ?? '',
      isMentor: json['is_mentor'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'cidade': cidade,
      'estado': estado,
      'sobre': sobre,
      'cargo_atual': cargoAtual,
      'formacao_academica': formacaoAcademica,
      'areas_interesse': areasInteresse,
      'pontos_fortes': pontosFortes,
      'is_mentor': isMentor,
    };
  }

  /// Get location string
  String get location => cidade.isNotEmpty && estado.isNotEmpty
      ? '$cidade, $estado'
      : cidade.isNotEmpty
          ? cidade
          : estado;

  /// Get areas of interest as list
  List<String> get areasInteresseList => areasInteresse
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  /// Get strengths as list
  List<String> get pontosFortesList => pontosFortes
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

/// Mentorship Request model
class MentorshipRequest {
  final int id;
  final int menteeId;
  final int mentorId;
  final String status;
  final String message;
  final String responseMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? respondedAt;
  final MentorshipUser mentee;
  final MentorshipUser mentor;

  MentorshipRequest({
    required this.id,
    required this.menteeId,
    required this.mentorId,
    required this.status,
    required this.message,
    required this.responseMessage,
    required this.createdAt,
    required this.updatedAt,
    this.respondedAt,
    required this.mentee,
    required this.mentor,
  });

  factory MentorshipRequest.fromJson(Map<String, dynamic> json) {
    return MentorshipRequest(
      id: json['id'] as int? ?? 0,
      menteeId: json['mentee_id'] as int? ?? 0,
      mentorId: json['mentor_id'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      message: json['message'] as String? ?? '',
      responseMessage: json['response_message'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      respondedAt: json['responded_at'] != null
          ? DateTime.parse(json['responded_at'] as String)
          : null,
      mentee: MentorshipUser.fromJson(
        json['mentee'] as Map<String, dynamic>? ?? {},
      ),
      mentor: MentorshipUser.fromJson(
        json['mentor'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mentee_id': menteeId,
      'mentor_id': mentorId,
      'status': status,
      'message': message,
      'response_message': responseMessage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (respondedAt != null) 'responded_at': respondedAt!.toIso8601String(),
      'mentee': mentee.toJson(),
      'mentor': mentor.toJson(),
    };
  }

  /// Check if request is pending
  bool get isPending => status.toLowerCase() == 'pending';

  /// Check if request is accepted
  bool get isAccepted => status.toLowerCase() == 'accepted';

  /// Check if request is rejected
  bool get isRejected => status.toLowerCase() == 'rejected';

  /// Get status color
  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pendente';
      case 'accepted':
        return 'Aceito';
      case 'rejected':
        return 'Rejeitado';
      default:
        return status;
    }
  }
}

/// Response model for received mentorship requests
class ReceivedRequestsResponse {
  final int total;
  final List<MentorshipRequest> requests;

  ReceivedRequestsResponse({
    required this.total,
    required this.requests,
  });

  factory ReceivedRequestsResponse.fromJson(Map<String, dynamic> json) {
    return ReceivedRequestsResponse(
      total: json['total'] as int? ?? 0,
      requests: (json['requests'] as List<dynamic>?)
              ?.map((e) =>
                  MentorshipRequest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'requests': requests.map((e) => e.toJson()).toList(),
    };
  }
}

