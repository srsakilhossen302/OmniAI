class StudentProfileModel {
  final String name;
  final String email;
  final String greeting;
  final String avatarUrl;

  StudentProfileModel({
    required this.name,
    required this.email,
    required this.greeting,
    this.avatarUrl = '',
  });
}

class RecentActivityModel {
  final String title;
  final String time;
  final String type;

  RecentActivityModel({
    required this.title,
    required this.time,
    required this.type,
  });
}
