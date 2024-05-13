class User {
  final String username;
  final String photoUrl;
  final String time;
  final CallStatus callStatus;

  User({
    required this.username,
    required this.photoUrl,
    required this.time,
    required this.callStatus,
  });

}

enum CallStatus { missed, incoming, outgoing }