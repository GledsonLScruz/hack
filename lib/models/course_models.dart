/// Model classes for different course types returned by the API

/// Recommended Course model (Curso Recomendado)
class CursoRecomendado {
  final String nome;
  final String instituicao;
  final String tipo;
  final int duracaoMeses;
  final int matchScore;
  final String localizacao;
  final double rating;
  final String descricao;
  final String link;

  CursoRecomendado({
    required this.nome,
    required this.instituicao,
    required this.tipo,
    required this.duracaoMeses,
    required this.matchScore,
    required this.localizacao,
    required this.rating,
    required this.descricao,
    required this.link,
  });

  factory CursoRecomendado.fromJson(Map<String, dynamic> json) {
    return CursoRecomendado(
      nome: json['name'] as String? ?? '',
      instituicao: json['institution'] as String? ?? '',
      tipo: json['type'] as String? ?? '',
      duracaoMeses: json['duration_months'] as int? ?? 0,
      matchScore: json['match_score'] as int? ?? 0,
      localizacao: json['location'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      descricao: json['description'] as String? ?? '',
      link: json['link'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'instituicao': instituicao,
      'tipo': tipo,
      'duracao_meses': duracaoMeses,
      'match_score': matchScore,
      'localizacao': localizacao,
      'rating': rating,
      'descricao': descricao,
      'link': link,
    };
  }
}

/// Online Course model (Curso Online)
class CursoOnline {
  final String nome;
  final String plataforma;
  final String tipo;
  final int duracaoHoras;
  final bool certificado;
  final String descricao;
  final String link;
  final String nivel;

  CursoOnline({
    required this.nome,
    required this.plataforma,
    required this.tipo,
    required this.duracaoHoras,
    required this.certificado,
    required this.descricao,
    required this.link,
    required this.nivel,
  });

  factory CursoOnline.fromJson(Map<String, dynamic> json) {
    return CursoOnline(
      nome: json['name'] as String? ?? '',
      plataforma: json['platform'] as String? ?? '',
      tipo: json['type'] as String? ?? '',
      duracaoHoras: json['duration_hours'] as int? ?? 0,
      certificado: json['certificate'] as bool? ?? false,
      descricao: json['description'] as String? ?? '',
      link: json['link'] as String? ?? '',
      nivel: json['level'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'plataforma': plataforma,
      'tipo': tipo,
      'duracao_horas': duracaoHoras,
      'certificado': certificado,
      'descricao': descricao,
      'link': link,
      'nivel': nivel,
    };
  }
}

/// Technical Course model (Curso Técnico)
class CursoTecnico {
  final String nome;
  final String instituicao;
  final int duracaoMeses;
  final String localizacao;
  final String descricao;
  final String link;

  CursoTecnico({
    required this.nome,
    required this.instituicao,
    required this.duracaoMeses,
    required this.localizacao,
    required this.descricao,
    required this.link,
  });

  factory CursoTecnico.fromJson(Map<String, dynamic> json) {
    return CursoTecnico(
      nome: json['name'] as String? ?? '',
      instituicao: json['institution'] as String? ?? '',
      duracaoMeses: json['duration_months'] as int? ?? 0,
      localizacao: json['location'] as String? ?? '',
      descricao: json['description'] as String? ?? '',
      link: json['link'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'instituicao': instituicao,
      'duracao_meses': duracaoMeses,
      'localizacao': localizacao,
      'descricao': descricao,
      'link': link,
    };
  }
}

/// Scholarship Opportunity model
class ScholarshipOpportunity {
  final String nome;
  final String tipo;
  final String porcentagem;
  final String prazo;
  final List<String> instituicoesAplicaveis;
  final String link;
  final List<String> requisitos;

  ScholarshipOpportunity({
    required this.nome,
    required this.tipo,
    required this.porcentagem,
    required this.prazo,
    required this.instituicoesAplicaveis,
    required this.link,
    required this.requisitos,
  });

  factory ScholarshipOpportunity.fromJson(Map<String, dynamic> json) {
    return ScholarshipOpportunity(
      nome: json['name'] as String? ?? '',
      tipo: json['type'] as String? ?? '',
      porcentagem: json['percentage'] as String? ?? '',
      prazo: json['deadline'] as String? ?? '',
      instituicoesAplicaveis:
          (json['applicable_institutions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      link: json['link'] as String? ?? '',
      requisitos:
          (json['requirements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'tipo': tipo,
      'porcentagem': porcentagem,
      'prazo': prazo,
      'instituicoesAplicaveis': instituicoesAplicaveis,
      'link': link,
      'requisitos': requisitos,
    };
  }
}

/// Entry Opportunity model
class EntryOpportunity {
  final String titulo;
  final String tipoEmpresa;
  final String localizacao;
  final String modalidade;
  final List<String> requisitos;
  final String link;

  EntryOpportunity({
    required this.titulo,
    required this.tipoEmpresa,
    required this.localizacao,
    required this.modalidade,
    required this.requisitos,
    required this.link,
  });

  factory EntryOpportunity.fromJson(Map<String, dynamic> json) {
    return EntryOpportunity(
      titulo: json['title'] as String? ?? '',
      tipoEmpresa: json['company_type'] as String? ?? '',
      localizacao: json['location'] as String? ?? '',
      modalidade: json['modality'] as String? ?? '',
      requisitos:
          (json['requirements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      link: json['link'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'tipoEmpresa': tipoEmpresa,
      'localizacao': localizacao,
      'modalidade': modalidade,
      'requisitos': requisitos,
      'link': link,
    };
  }
}

/// Networking Event model
class NetworkingEvent {
  final String nome;
  final String tipo;
  final String data;
  final String localizacao;
  final String descricao;
  final String link;

  NetworkingEvent({
    required this.nome,
    required this.tipo,
    required this.data,
    required this.localizacao,
    required this.descricao,
    required this.link,
  });

  factory NetworkingEvent.fromJson(Map<String, dynamic> json) {
    return NetworkingEvent(
      nome: json['name'] as String? ?? '',
      tipo: json['type'] as String? ?? '',
      data: json['date'] as String? ?? '',
      localizacao: json['location'] as String? ?? '',
      descricao: json['description'] as String? ?? '',
      link: json['link'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'tipo': tipo,
      'data': data,
      'localizacao': localizacao,
      'descricao': descricao,
      'link': link,
    };
  }
}

/// Skill to Develop model
class SkillToDevelop {
  final String nome;
  final String categoria;
  final String prioridade;
  final List<String> ondeAprender;

  SkillToDevelop({
    required this.nome,
    required this.categoria,
    required this.prioridade,
    required this.ondeAprender,
  });

  factory SkillToDevelop.fromJson(Map<String, dynamic> json) {
    return SkillToDevelop(
      nome: json['name'] as String? ?? '',
      categoria: json['category'] as String? ?? '',
      prioridade: json['priority'] as String? ?? '',
      ondeAprender:
          (json['where_to_learn'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'categoria': categoria,
      'prioridade': prioridade,
      'ondeAprender': ondeAprender,
    };
  }
}

/// Job Market model
class JobMarket {
  final List<String> areasTendencia;
  final String salarioInicial;
  final String salarioExperiente;
  final List<String> tendencias;
  final List<String> principaisEmpregadores;

  JobMarket({
    required this.areasTendencia,
    required this.salarioInicial,
    required this.salarioExperiente,
    required this.tendencias,
    required this.principaisEmpregadores,
  });

  factory JobMarket.fromJson(Map<String, dynamic> json) {
    return JobMarket(
      areasTendencia:
          (json['trending_areas'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      salarioInicial: json['starting_salary'] as String? ?? '',
      salarioExperiente: json['experienced_salary'] as String? ?? '',
      tendencias:
          (json['trends'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      principaisEmpregadores:
          (json['main_employers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'areasTendencia': areasTendencia,
      'salarioInicial': salarioInicial,
      'salarioExperiente': salarioExperiente,
      'tendencias': tendencias,
      'principaisEmpregadores': principaisEmpregadores,
    };
  }
}

/// Roadmap Response model
class RoadmapResponse {
  final int id;
  final RoadmapData roadmap;

  RoadmapResponse({required this.id, required this.roadmap});

  factory RoadmapResponse.fromJson(Map<String, dynamic> json) {
    return RoadmapResponse(
      id: json['id'] as int? ?? 0,
      roadmap: RoadmapData.fromJson(
        json['roadmap'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'roadmap': roadmap.toJson()};
  }
}

/// Roadmap Data model
class RoadmapData {
  final List<CursoRecomendado> cursosRecomendados;
  final List<CursoOnline> cursosOnline;
  final List<CursoTecnico> cursosTecnicos;
  final List<ScholarshipOpportunity> bolsasEstudo;
  final List<EntryOpportunity> oportunidadesEntrada;
  final List<NetworkingEvent> eventosNetworking;
  final List<SkillToDevelop> habilidadesDesenvolver;
  final JobMarket? mercadoTrabalho;

  RoadmapData({
    required this.cursosRecomendados,
    required this.cursosOnline,
    required this.cursosTecnicos,
    required this.bolsasEstudo,
    required this.oportunidadesEntrada,
    required this.eventosNetworking,
    required this.habilidadesDesenvolver,
    this.mercadoTrabalho,
  });

  factory RoadmapData.fromJson(Map<String, dynamic> json) {
    return RoadmapData(
      cursosRecomendados:
          (json['recommended_courses'] as List<dynamic>?)
              ?.map((e) => CursoRecomendado.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cursosOnline:
          (json['online_courses'] as List<dynamic>?)
              ?.map((e) => CursoOnline.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cursosTecnicos:
          (json['technical_courses'] as List<dynamic>?)
              ?.map((e) => CursoTecnico.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      bolsasEstudo:
          (json['scholarship_opportunities'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ScholarshipOpportunity.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      oportunidadesEntrada:
          (json['entry_opportunities'] as List<dynamic>?)
              ?.map((e) => EntryOpportunity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      eventosNetworking:
          (json['networking_events'] as List<dynamic>?)
              ?.map((e) => NetworkingEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      habilidadesDesenvolver:
          (json['skills_to_develop'] as List<dynamic>?)
              ?.map((e) => SkillToDevelop.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      mercadoTrabalho: json['job_market'] != null
          ? JobMarket.fromJson(json['job_market'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cursosRecomendados': cursosRecomendados.map((e) => e.toJson()).toList(),
      'cursosOnline': cursosOnline.map((e) => e.toJson()).toList(),
      'cursosTecnicos': cursosTecnicos.map((e) => e.toJson()).toList(),
      'bolsasEstudo': bolsasEstudo.map((e) => e.toJson()).toList(),
      'oportunidadesEntrada': oportunidadesEntrada
          .map((e) => e.toJson())
          .toList(),
      'eventosNetworking': eventosNetworking.map((e) => e.toJson()).toList(),
      'habilidadesDesenvolver': habilidadesDesenvolver
          .map((e) => e.toJson())
          .toList(),
      if (mercadoTrabalho != null) 'mercadoTrabalho': mercadoTrabalho!.toJson(),
    };
  }
}

/// Legacy response model for backwards compatibility
@Deprecated('Use RoadmapResponse instead')
class CoursesResponse {
  final List<CursoRecomendado> cursosRecomendados;
  final List<CursoOnline> cursosOnline;
  final List<CursoTecnico> cursosTecnicos;

  CoursesResponse({
    required this.cursosRecomendados,
    required this.cursosOnline,
    required this.cursosTecnicos,
  });

  factory CoursesResponse.fromJson(Map<String, dynamic> json) {
    return CoursesResponse(
      cursosRecomendados:
          (json['cursos_recomendados'] as List<dynamic>?)
              ?.map((e) => CursoRecomendado.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cursosOnline:
          (json['cursos_online'] as List<dynamic>?)
              ?.map((e) => CursoOnline.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cursosTecnicos:
          (json['cursos_tecnicos'] as List<dynamic>?)
              ?.map((e) => CursoTecnico.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cursos_recomendados': cursosRecomendados.map((e) => e.toJson()).toList(),
      'cursos_online': cursosOnline.map((e) => e.toJson()).toList(),
      'cursos_tecnicos': cursosTecnicos.map((e) => e.toJson()).toList(),
    };
  }
}
