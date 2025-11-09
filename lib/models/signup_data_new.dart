class SignUpDataNew {
  // User (Part 1)
  String? email;
  String? name;
  String? password;
  bool? isMentor;

  // Mentee (Part 2 - Mentee branch)
  String? menteeCity;
  String? menteeState;
  String? menteeNeighborhood;
  String? menteeGender;
  String? menteeColorRace;
  bool? menteeIsDisabled;
  String? menteeSchoolName;
  String? menteeSchoolLocation;
  String? menteeStrengths;
  String? menteeAreasOfInterest;

  // Mentor (Part 2 - Mentor branch)
  int? mentorAge;
  String? mentorHometownCity;
  String? mentorHometownState;
  String? mentorGender;
  String? mentorColorRace;
  bool? mentorIsDisabled;
  String? mentorFamilyIncome;
  String? mentorEducationLevel;
  String? mentorHighSchoolName;
  String? mentorHighSchoolLocation;
  String? mentorStrengths;
  String? mentorAreasOfInterest;
  String? mentorExtracurricularActivities;

  // Additional fields for API (optional, can be null)
  String? sobre;
  String? disponibilidade;
  String? objetivos;
  String? cargoAtual;
  String? localPretendeTrabalharOuEstudar1;
  String? localPretendeTrabalharOuEstudar2;
  String? localPretendeTrabalharOuEstudar3;
  String? formacaoAcademica;
  String? nomeFaculdade;
  String? localidadeFaculdade;
  String? nomeMestrado;
  String? localidadeMestrado;
  String? nomeDoutorado;
  String? localidadeDoutorado;
  String? nomePhd;
  String? localidadePhd;
  String? experiencias;
  String? linkedinId;

  SignUpDataNew({
    this.email,
    this.name,
    this.password,
    this.isMentor,
    this.menteeCity,
    this.menteeState,
    this.menteeNeighborhood,
    this.menteeGender,
    this.menteeColorRace,
    this.menteeIsDisabled,
    this.menteeSchoolName,
    this.menteeSchoolLocation,
    this.menteeStrengths,
    this.menteeAreasOfInterest,
    this.mentorAge,
    this.mentorHometownCity,
    this.mentorHometownState,
    this.mentorGender,
    this.mentorColorRace,
    this.mentorIsDisabled,
    this.mentorFamilyIncome,
    this.mentorEducationLevel,
    this.mentorHighSchoolName,
    this.mentorHighSchoolLocation,
    this.mentorStrengths,
    this.mentorAreasOfInterest,
    this.mentorExtracurricularActivities,
    this.sobre,
    this.disponibilidade,
    this.objetivos,
    this.cargoAtual,
    this.localPretendeTrabalharOuEstudar1,
    this.localPretendeTrabalharOuEstudar2,
    this.localPretendeTrabalharOuEstudar3,
    this.formacaoAcademica,
    this.nomeFaculdade,
    this.localidadeFaculdade,
    this.nomeMestrado,
    this.localidadeMestrado,
    this.nomeDoutorado,
    this.localidadeDoutorado,
    this.nomePhd,
    this.localidadePhd,
    this.experiencias,
    this.linkedinId,
  });

  Map<String, dynamic> toJson() {
    return {
      "user": {
        "email": email ?? "",
        "name": name ?? "",
        "password": password ?? "",
        "isMentor": isMentor ?? false,
      },
      "mentee": {
        "city": menteeCity ?? "",
        "state": menteeState ?? "",
        "neighborhood": menteeNeighborhood ?? "",
        "gender": menteeGender ?? "",
        "color_race": menteeColorRace ?? "",
        "is_disabled": menteeIsDisabled,
        "school_name": menteeSchoolName ?? "",
        "school_location": menteeSchoolLocation ?? "",
        "strengths": menteeStrengths ?? "",
        "areas_of_interest": menteeAreasOfInterest ?? "",
      },
      "mentor": {
        "age": mentorAge,
        "hometown_city": mentorHometownCity ?? "",
        "hometown_state": mentorHometownState ?? "",
        "gender": mentorGender ?? "",
        "color_race": mentorColorRace ?? "",
        "is_disabled": mentorIsDisabled,
        "family_income_during_school": mentorFamilyIncome ?? "",
        "education_level": mentorEducationLevel ?? "",
        "high_school_name": mentorHighSchoolName ?? "",
        "high_school_location": mentorHighSchoolLocation ?? "",
        "strengths": mentorStrengths ?? "",
        "areas_of_interest": mentorAreasOfInterest ?? "",
        "extracurricular_activities": mentorExtracurricularActivities ?? "",
      },
    };
  }

  // API format mapping
  Map<String, dynamic> toApiJson() {
    final bool isMentorValue = isMentor ?? false;

    return {
      "email": email ?? "",
      "nome": name ?? "",
      "senha": password ?? "",
      "is_mentor": isMentorValue,

      // Location fields (use mentor or mentee data based on role)
      "cidade": isMentorValue ? (mentorHometownCity ?? "") : (menteeCity ?? ""),
      "estado": isMentorValue
          ? (mentorHometownState ?? "")
          : (menteeState ?? ""),
      "bairro": isMentorValue ? "" : (menteeNeighborhood ?? ""),

      // Identity fields
      "genero": isMentorValue ? (mentorGender ?? "") : (menteeGender ?? ""),
      "cor_raca": isMentorValue
          ? (mentorColorRace ?? "")
          : (menteeColorRace ?? ""),
      "is_pcd": isMentorValue
          ? (mentorIsDisabled ?? false)
          : (menteeIsDisabled ?? false),

      // School/Education fields
      "nome_escola": isMentorValue
          ? (mentorHighSchoolName ?? "")
          : (menteeSchoolName ?? ""),
      "localidade_escola": isMentorValue
          ? (mentorHighSchoolLocation ?? "")
          : (menteeSchoolLocation ?? ""),

      // Strengths and interests
      "pontos_fortes": isMentorValue
          ? (mentorStrengths ?? "")
          : (menteeStrengths ?? ""),
      "areas_interesse": isMentorValue
          ? (mentorAreasOfInterest ?? "")
          : (menteeAreasOfInterest ?? ""),

      // Mentor-specific fields
      "atividades_extracurriculares": mentorExtracurricularActivities ?? "",
      "renda_familiar": mentorFamilyIncome ?? "",
      "formacao_academica": mentorEducationLevel ?? "",

      // Additional optional fields
      "cidade_atual": isMentorValue
          ? (mentorHometownCity ?? "")
          : (menteeCity ?? ""),
      "estado_atual": isMentorValue
          ? (mentorHometownState ?? "")
          : (menteeState ?? ""),
      "sobre": sobre ?? "",
      "disponibilidade": disponibilidade ?? "",
      "objetivos": objetivos ?? "",
      "cargo_atual": cargoAtual ?? "",
      "local_pretende_trabalhar_ou_estudar_1":
          localPretendeTrabalharOuEstudar1 ?? "",
      "local_pretende_trabalhar_ou_estudar_2":
          localPretendeTrabalharOuEstudar2 ?? "",
      "local_pretende_trabalhar_ou_estudar_3":
          localPretendeTrabalharOuEstudar3 ?? "",
      "nome_faculdade": nomeFaculdade ?? "",
      "localidade_faculdade": localidadeFaculdade ?? "",
      "nome_mestrado": nomeMestrado ?? "",
      "localidade_mestrado": localidadeMestrado ?? "",
      "nome_doutorado": nomeDoutorado ?? "",
      "localidade_doutorado": localidadeDoutorado ?? "",
      "nome_phd": nomePhd ?? "",
      "localidade_phd": localidadePhd ?? "",
      "experiencias": experiencias ?? "",
      "linkedin_id": linkedinId ?? "",
    };
  }

  void resetRoleSpecificData() {
    if (isMentor == true) {
      // Reset mentee data
      menteeCity = null;
      menteeState = null;
      menteeNeighborhood = null;
      menteeGender = null;
      menteeColorRace = null;
      menteeIsDisabled = null;
      menteeSchoolName = null;
      menteeSchoolLocation = null;
      menteeStrengths = null;
      menteeAreasOfInterest = null;
    } else {
      // Reset mentor data
      mentorAge = null;
      mentorHometownCity = null;
      mentorHometownState = null;
      mentorGender = null;
      mentorColorRace = null;
      mentorIsDisabled = null;
      mentorFamilyIncome = null;
      mentorEducationLevel = null;
      mentorHighSchoolName = null;
      mentorHighSchoolLocation = null;
      mentorStrengths = null;
      mentorAreasOfInterest = null;
      mentorExtracurricularActivities = null;
    }
  }
}
