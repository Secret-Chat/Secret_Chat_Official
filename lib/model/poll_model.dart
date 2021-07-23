class PollOption {
  String pollText; //option text
  int pollIndex; //to keep the order intact for every user

  //constructor

  PollOption({this.pollIndex, this.pollText});

  @override
  toString() {
    return '''
    pollText:  $pollText
    pollIndex: $pollIndex
    ''';
  }

  Map<String, String> toMap() {
    return {
      "pollText": pollText,
      "pollIndex": pollIndex.toString(),
    };
  }
}
