class RoleTitles {
  String headTitle;
  String principalTitle;
  String vicePrincipalTitle;
  String vpAcademicTitle;
  String vpStudentAffairsTitle;
  String registrarTitle;
  String financeOfficerTitle;
  String teacherTitle;

  RoleTitles({
    required this.headTitle,
    required this.principalTitle,
    required this.vicePrincipalTitle,
    required this.vpAcademicTitle,
    required this.vpStudentAffairsTitle,
    required this.registrarTitle,
    required this.financeOfficerTitle,
    required this.teacherTitle,
  });

  factory RoleTitles.defaultTitles() {
    return RoleTitles(
      headTitle: "School Owner",
      principalTitle: "Principal",
      vicePrincipalTitle: "Vice Principal",
      vpAcademicTitle: "VP Academic Affairs",
      vpStudentAffairsTitle: "VP Student Affairs",
      registrarTitle: "Registrar",
      financeOfficerTitle: "Finance Officer",
      teacherTitle: "Teacher",
    );
  }
}