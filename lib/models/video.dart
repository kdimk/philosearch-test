class Video {
  int index;
  String link;
  String image;
  int date;
  DateTime dateTime;
  String year;
  String month;
  String day;
  Set<String> types;
  String title;
  Set<String> coreMembers;
  Set<String> guests;
  Set<List<String>> themes;
  Set<List<String>> topics;
  Set<List<String>> people;
  Set<List<String>> works;
  String level;
  Set<List<String>> otherTags;
  List<String> remarks;

  Video({
    required this.index,
    required this.link,
    required this.image,
    required this.date,
    required this.dateTime,
    required this.year,
    required this.month,
    required this.day,
    required this.types,
    required this.title,
    required this.coreMembers,
    required this.guests,
    required this.themes,
    required this.topics,
    required this.people,
    required this.works,
    required this.level,
    required this.otherTags,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      "index": index,
      "link": link,
      "image": image,
      "date": date,
      "year": year,
      "month": month,
      "day": day,
      "types": types,
      "title": title,
      "coreMembers": coreMembers,
      "guests": guests,
      "themes": themes,
      "topics": topics,
      "people": people,
      "works": works,
      "level": level,
      "otherTags": otherTags,
      "remarks": remarks,
    };
  }

  dynamic get(String propertyName) {
    var videoMap = toMap();
    if (videoMap.containsKey(propertyName)) {
      return videoMap[propertyName];
    }
    throw ArgumentError('Property not found');
  }
}
