class TeamModel {
  final String teamId;
  final String teamName;
  final String createdOn;
  final String createdBy;
  final String groupIcon;

  TeamModel(
      {this.teamId,
      this.teamName,
      this.createdOn,
      this.createdBy,
      this.groupIcon});

  @override
  String toString() {
    return '''
    teamId: $teamId
    teamName: $teamName
    createdOn: $createdOn
    createdBy: $createdBy
    groupIcon: $groupIcon
    ''';
  }
}
