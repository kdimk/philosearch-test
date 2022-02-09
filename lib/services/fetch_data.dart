import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:philosearch/models/tag_type.dart';
import 'package:philosearch/models/video.dart';

Future<List<Video>> fetchData() async {
  // Get data from spreadsheet
  final response = await http.get(Uri.parse(
      'https://script.google.com/macros/s/AKfycbzWyhRofjXrZZHZMA_r6PRZ-QySJxILLHj8ZJ1if8nLQUfxN45pALqLYNqr6YabFbs1/exec'));

  List dataList = [];

  if (response.statusCode == 200) {
    dataList = jsonDecode(response.body);
  } else {
    throw Exception('Failed to load videos');
  }

  // Create list
  final List<Video> fullVideoList = [];

  // Add each row to videoData

  for (var item in dataList) {
    // Check if any cell of a video is empty
    List<bool> check = [];

    for (var int = 0; int <= 18; int++) {
      check.add(item[int] != '');
    }

    // If no cells are empty, proceed
    if (!check.contains(false)) {
      // Check if the video is ready; 2 means ready
      if (item[0] == '2') {
        Video newVideo = Video(
          index: int.parse(
              createProperties(data: item[1], tagType: TagType.singleTag)),
          link: createProperties(data: item[2], tagType: TagType.singleTag),
          image: createProperties(data: item[3], tagType: TagType.singleTag),
          date: int.parse(
              createProperties(data: item[4], tagType: TagType.singleTag)),
          dateTime: DateTime(
              int.parse(item[5]), int.parse(item[6]), int.parse(item[7])),
          year: createProperties(data: item[5], tagType: TagType.singleTag),
          month: createProperties(data: item[6], tagType: TagType.singleTag),
          day: createProperties(data: item[7], tagType: TagType.singleTag),
          types: createProperties(data: item[8], tagType: TagType.multipleTags),
          title: createProperties(data: item[9], tagType: TagType.singleTag),
          coreMembers:
              createProperties(data: item[10], tagType: TagType.multipleTags),
          guests:
              createProperties(data: item[11], tagType: TagType.multipleTags),
          themes: createProperties(
              data: item[12], tagType: TagType.multipleTagsWithTimestamps),
          topics: createProperties(
              data: item[13], tagType: TagType.multipleTagsWithTimestamps),
          people: createProperties(
              data: item[14], tagType: TagType.multipleTagsWithTimestamps),
          works: createProperties(
              data: item[15], tagType: TagType.multipleTagsWithTimestamps),
          level: createProperties(data: item[16], tagType: TagType.singleTag),
          otherTags: createProperties(
              data: item[17], tagType: TagType.multipleTagsWithTimestamps),
          remarks: createProperties(data: item[18], tagType: TagType.remarks),
        );
        fullVideoList.add(newVideo);
      }
    }
  }

  return fullVideoList;
}

dynamic createProperties({required dynamic data, required TagType tagType}) {
  if (tagType == TagType.singleTag) {
    return data;
  }

  if (tagType == TagType.multipleTags) {
    Set<String> tags = data.split('; ').toSet();
    return tags;
  }

  if (tagType == TagType.multipleTagsWithTimestamps) {
    Set<String> tags = data.split('; ').toSet();
    Set<List<String>> tagsWithTimestamps = {};
    for (String tag in tags) {
      List<String> tagAndTimestamps = tag.split(' [T]');
      tagsWithTimestamps.add(tagAndTimestamps);
    }
    return tagsWithTimestamps;
  }

  if (tagType == TagType.remarks) {
    List<String> tags = data.split(' [NL] ');
    return tags;
  }
}
