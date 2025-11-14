class NoticeModel {
  final int id;
  final String topic;
  final String des;
  final String dept;
  final String image1;
  final String image2;
  final String createdDate;

  NoticeModel({
    required this.id,
    required this.topic,
    required this.des,
    required this.dept,
    required this.image1,
    required this.image2,
    required this.createdDate,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] ?? 0,
      topic: json['topic'] ?? '',
      des: json['des'] ?? '',
      dept: json['dept'] ?? '',
      image1: json['image1'] ?? '',
      image2: json['image2'] ?? '',
      createdDate: json['created_date'] ?? '',
    );
  }
}
