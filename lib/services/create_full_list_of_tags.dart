import 'dart:collection';

import 'package:philosearch/models/video.dart';
import 'package:philosearch/models/tag_type.dart';

Set<String> createFullListOfTags(
    {required List<Video> videoList,
    required String tagName,
    required TagType tagType}) {
  // Create empty set
  Set<String> fullListOfTags = {};

  // Add each tag

  if (tagType == TagType.singleTag) {
    for (Video video in videoList) {
      if (video.get(tagName) != "--") {
        fullListOfTags.add(video.get(tagName));
      }
    }
  }

  if (tagType == TagType.multipleTags) {
    for (Video video in videoList) {
      for (String tag in video.get(tagName)) {
        if (tag != "--") {
          fullListOfTags.add(tag);
        }
      }
    }
  }

  if (tagType == TagType.multipleTagsWithTimestamps) {
    for (Video video in videoList) {
      for (List<String> tag in video.get(tagName)) {
        if (tag[0] != "--") {
          fullListOfTags.add(tag[0]);
        }
      }
    }
  }

  // Sort tags
  SplayTreeSet<String> sortedFullListOfTags = SplayTreeSet.from(fullListOfTags);

  return sortedFullListOfTags;
}
