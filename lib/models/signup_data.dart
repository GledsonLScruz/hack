class SignUpData {
  // Part 1 - Essential Information
  String? name;
  DateTime? birthDate;
  String? postalCode;
  String? city;
  String? state;
  String? country;
  String? gender; // MALE or FEMALE
  String? colorRace;

  // Part 2 - Additional Information
  String? educationLevel;
  List<String> academicInterests;
  String? skills;
  String? financialSituation;
  String? availability; // full-time or part-time
  List<String> goals;
  String? restrictions;
  String? studyWorkPreference;
  String? extracurricularActivities;

  SignUpData({
    this.name,
    this.birthDate,
    this.postalCode,
    this.city,
    this.state,
    this.country,
    this.gender,
    this.colorRace,
    this.educationLevel,
    this.academicInterests = const [],
    this.skills,
    this.financialSituation,
    this.availability,
    this.goals = const [],
    this.restrictions,
    this.studyWorkPreference,
    this.extracurricularActivities,
  });

  bool isPart1Valid() {
    return name != null &&
        name!.isNotEmpty &&
        birthDate != null &&
        postalCode != null &&
        postalCode!.isNotEmpty &&
        gender != null &&
        colorRace != null &&
        colorRace!.isNotEmpty;
  }

  bool isPart2Valid() {
    return educationLevel != null &&
        academicInterests.isNotEmpty &&
        skills != null &&
        skills!.isNotEmpty &&
        financialSituation != null &&
        availability != null &&
        goals.isNotEmpty &&
        studyWorkPreference != null;
  }
}

