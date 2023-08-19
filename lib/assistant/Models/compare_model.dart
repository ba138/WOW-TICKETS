class Compare {
  final String id;
  final String user;
  final bool status;

  Compare({
    required this.id,
    required this.user,
    required this.status,
  });

  factory Compare.fromMap(Map<String, dynamic> map) {
    return Compare(
      id: map['id'],
      user: map['user'],
      status: map['status'] == 1,
    );
  }
}
