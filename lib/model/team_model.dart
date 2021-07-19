class TeamModel {
  final String teamId;
  final String teamName;
  final String createdOn;
  final String createdBy;

  TeamModel({this.teamId, this.teamName, this.createdOn, this.createdBy});

  @override
  String toString() {
    return '''
    teamId: $teamId
    teamName: $teamName
    createdOn: $createdOn
    createdBy: $createdBy
    ''';
  }
}
