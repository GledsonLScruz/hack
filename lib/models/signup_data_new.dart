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
