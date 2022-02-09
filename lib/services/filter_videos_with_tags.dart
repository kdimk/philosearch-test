import 'package:philosearch/models/video.dart';
import 'package:philosearch/models/tag_type.dart';

List<Video> filterVideosWithTags(
    {required List<Video> videoList,
    required Set<String> selectedTags,
    required String tagName,
    required TagType tagType}) {
  if (tagType == TagType.singleTag) {
    if (selectedTags.isNotEmpty) {
      return videoList.where((video) {
        List<bool> isMatchedSelectedTags = [];

        for (String selectedTag in selectedTags) {
          isMatchedSelectedTags.add(video.get(tagName) == selectedTag);
        }
        return isMatchedSelectedTags.contains(true);
      }).toList();
    }
  }

  if (tagType == TagType.multipleTags) {
    if (selectedTags.isNotEmpty) {
      // A video added to the list has to include all selected tags
      return videoList.where((video) {
        List<bool> isMatchedSelectedTags = [];

        for (String selectedTag in selectedTags) {
          isMatchedSelectedTags.add(video.get(tagName).contains(selectedTag));
        }

        // 'false' means some selectedTags are not included in the video
        return !isMatchedSelectedTags.contains(false);
      }).toList();
    }
  }

  if (tagType == TagType.multipleTagsWithTimestamps) {
    if (selectedTags.isNotEmpty) {
      return videoList.where((video) {
        List<bool> isMatchedSelectedTags = [];

        for (String selectedTag in selectedTags) {
          List<bool> isMatchedTag = [];
          // Check whether each tag of a video includes the selectedTag
          for (List tagOfVideo in video.get(tagName)) {
            isMatchedTag.add(tagOfVideo[0].contains(selectedTag));
          }
          // Return true if one of the tags of a video includes the selectedTag
          isMatchedSelectedTags.add(isMatchedTag.contains(true));
        }
        // A video added to the list has to include all selected tags
        // 'false' means some selectedTags are not included in the video
        return !isMatchedSelectedTags.contains(false);
      }).toList();
    }
  }

  return videoList;
}
