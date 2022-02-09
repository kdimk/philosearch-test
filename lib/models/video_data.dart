import 'package:flutter/material.dart';

// Models
import 'package:philosearch/models/video.dart';
import 'package:philosearch/models/tag_type.dart';

// Services
import 'package:philosearch/services/create_full_list_of_tags.dart';
import 'package:philosearch/services/fetch_data.dart';
import 'package:philosearch/services/filter_videos_with_tags.dart';

class VideoData extends ChangeNotifier {
  bool isLoading = true;
  String searchText = '';
  DateTimeRange allowedDateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  DateTimeRange selectedDateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  bool isSelectedDateTimeRange = false;

  // allVideoList includes all videos
  final List<Video> _allVideoList = [];
  final Set<String> _allTagsOfTypes = {};
  final Set<String> _allTagsOfYear = {};
  final Set<String> _allTagsOfMonth = {
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  };
  final Set<String> _allTagsOfCoreMembers = {};
  final Set<String> _allTagsOfGuests = {};
  final Set<String> _allTagsOfThemes = {};
  final Set<String> _allTagsOfTopics = {};
  final Set<String> _allTagsOfPeople = {};
  final Set<String> _allTagsOfWorks = {};
  final Set<String> _allTagsOfLevel = {
    '★☆☆☆☆',
    '★★☆☆☆',
    '★★★☆☆',
    '★★★★☆',
    '★★★★★'
  };
  final Set<String> _allTagsOfOtherTags = {};

  // selectedVideoList includes videos shown in the app
  final List<Video> _selectedVideoList = [];
  final Set<String> _selectedTagsOfTypes = {};
  final Set<String> _selectedTagsOfYear = {};
  final Set<String> _selectedTagsOfMonth = {};
  final Set<String> _selectedTagsOfDateTimeRange = {};
  final Set<String> _selectedTagsOfCoreMembers = {};
  final Set<String> _selectedTagsOfGuests = {};
  final Set<String> _selectedTagsOfThemes = {};
  final Set<String> _selectedTagsOfTopics = {};
  final Set<String> _selectedTagsOfPeople = {};
  final Set<String> _selectedTagsOfWorks = {};
  final Set<String> _selectedTagsOfLevel = {};
  final Set<String> _selectedTagsOfOtherTags = {};

  final List _allSelectedTags = [];

  void initiateData() async {
    // Get video list
    List<Video> createdVideoList = await fetchData();

    // Sort videos by index (descending) and then date (descending)
    createdVideoList.sort((a, b) => b.index.compareTo(a.index));
    createdVideoList.sort((a, b) => b.date.compareTo(a.date));
    _allVideoList.addAll(createdVideoList);
    _selectedVideoList.addAll(createdVideoList);

    // allowed DateTimeRange
    allowedDateTimeRange = DateTimeRange(
        start: DateTime(
            _allVideoList[_allVideoList.length - 1].dateTime.year, 1, 1),
        end: DateTime(DateTime.now().year, 12, 31));
    selectedDateTimeRange = allowedDateTimeRange;

    // Create full lists of tags

    // Create full list of tags of types
    Set<String> createdTypeSet = createFullListOfTags(
        videoList: _allVideoList,
        tagName: 'types',
        tagType: TagType.multipleTags);
    _allTagsOfTypes.addAll(createdTypeSet);

    // Create full list of tags of year
    Set<String> createdYearSet = createFullListOfTags(
        videoList: _allVideoList, tagName: 'year', tagType: TagType.singleTag);
    _allTagsOfYear.addAll(createdYearSet);

    // Create full list of tags of core members
    Set<String> createdCoreMemberSet = createFullListOfTags(
        videoList: _allVideoList,
        tagName: 'coreMembers',
        tagType: TagType.multipleTags);
    _allTagsOfCoreMembers.addAll(createdCoreMemberSet);

    // Create full list of tags of guest
    Set<String> createdGuestSet = createFullListOfTags(
        videoList: _allVideoList,
        tagName: 'guests',
        tagType: TagType.multipleTags);
    _allTagsOfGuests.addAll(createdGuestSet);

    // Create full list of tags of themes
    Set<String> createdThemeSet = createFullListOfTags(
        videoList: _allVideoList,
        tagName: 'themes',
        tagType: TagType.multipleTagsWithTimestamps);
    _allTagsOfThemes.addAll(createdThemeSet);

    // Create full list of tags of topics
    Set<String> createdTopicSet = createFullListOfTags(
        videoList: _allVideoList,
        tagName: 'topics',
        tagType: TagType.multipleTagsWithTimestamps);
    _allTagsOfTopics.addAll(createdTopicSet);

    // Create full list of tags of people
    Set<String> createdPeopleSet = createFullListOfTags(
        videoList: _allVideoList,
        tagName: 'people',
        tagType: TagType.multipleTagsWithTimestamps);
    _allTagsOfPeople.addAll(createdPeopleSet);

    // Create full list of tags of works
    Set<String> createdWorkSet = createFullListOfTags(
        videoList: _allVideoList,
        tagName: 'works',
        tagType: TagType.multipleTagsWithTimestamps);
    _allTagsOfWorks.addAll(createdWorkSet);

    // Create full list of tags of other tags
    Set<String> createdOtherTagSet = createFullListOfTags(
        videoList: _allVideoList,
        tagName: 'otherTags',
        tagType: TagType.multipleTagsWithTimestamps);
    _allTagsOfOtherTags.addAll(createdOtherTagSet);

    // End loading & show video list
    isLoading = false;
    notifyListeners();
  }

  void filterVideos() {
    // Show loading
    isLoading = true;
    notifyListeners();

    // filteredVideoList is used during filtering process
    // Copy all videos to filtered video list for filtering
    List<Video> _filteredVideoList = [];
    _filteredVideoList.addAll(_allVideoList);

    // Filter by tags
    // Filter by type tags if selected
    if (_selectedTagsOfTypes.isNotEmpty) {
      _filteredVideoList = filterVideosWithTags(
          videoList: _filteredVideoList,
          selectedTags: _selectedTagsOfTypes,
          tagName: 'types',
          tagType: TagType.multipleTags);
    }
    // Filter by year tags if selected
    if (_selectedTagsOfYear.isNotEmpty) {
      _filteredVideoList = filterVideosWithTags(
          videoList: _filteredVideoList,
          selectedTags: _selectedTagsOfYear,
          tagName: 'year',
          tagType: TagType.singleTag);
    }
    // Filter by month tags if selected
    if (_selectedTagsOfMonth.isNotEmpty) {
      _filteredVideoList = filterVideosWithTags(
          videoList: _filteredVideoList,
          selectedTags: _selectedTagsOfMonth,
          tagName: 'month',
          tagType: TagType.singleTag);
    }
    // Filter by coreMembers tags if selected
    if (_selectedTagsOfCoreMembers.isNotEmpty) {
      _filteredVideoList = filterVideosWithTags(
          videoList: _filteredVideoList,
          selectedTags: _selectedTagsOfCoreMembers,
          tagName: 'coreMembers',
          tagType: TagType.multipleTags);
    }
    // Filter by guests tags if selected
    if (_selectedTagsOfGuests.isNotEmpty) {
      _filteredVideoList = filterVideosWithTags(
          videoList: _filteredVideoList,
          selectedTags: _selectedTagsOfGuests,
          tagName: 'guests',
          tagType: TagType.multipleTags);
    }
    // Filter by themes tags if selected
    if (_selectedTagsOfThemes.isNotEmpty) {
      _filteredVideoList = filterVideosWithTags(
          videoList: _filteredVideoList,
          selectedTags: _selectedTagsOfThemes,
          tagName: 'themes',
          tagType: TagType.multipleTagsWithTimestamps);
    }
    // Filter by topics tags if selected
    if (_selectedTagsOfTopics.isNotEmpty) {
      _filteredVideoList = filterVideosWithTags(
          videoList: _filteredVideoList,
          selectedTags: _selectedTagsOfTopics,
          tagName: 'topics',
          tagType: TagType.multipleTagsWithTimestamps);
    }
    // Filter by people tags if selected
    if (_selectedTagsOfPeople.isNotEmpty) {
      _filteredVideoList = filterVideosWithTags(
          videoList: _filteredVideoList,
          selectedTags: _selectedTagsOfPeople,
          tagName: 'people',
          tagType: TagType.multipleTagsWithTimestamps);
    }
    // Filter by works tags if selected
    if (_selectedTagsOfWorks.isNotEmpty) {
      _filteredVideoList = filterVideosWithTags(
          videoList: _filteredVideoList,
          selectedTags: _selectedTagsOfWorks,
          tagName: 'works',
          tagType: TagType.multipleTagsWithTimestamps);
    }
    // Filter by level tags if selected
    if (_selectedTagsOfLevel.isNotEmpty) {
      _filteredVideoList = filterVideosWithTags(
          videoList: _filteredVideoList,
          selectedTags: _selectedTagsOfLevel,
          tagName: 'level',
          tagType: TagType.singleTag);
    }
    // Filter by otherTags tags if selected
    if (_selectedTagsOfOtherTags.isNotEmpty) {
      _filteredVideoList = filterVideosWithTags(
          videoList: _filteredVideoList,
          selectedTags: _selectedTagsOfOtherTags,
          tagName: 'otherTags',
          tagType: TagType.multipleTagsWithTimestamps);
    }

    // Filter by text in search text box
    // Check if search text box is empty
    if (searchText != '') {
      // filteredByTextVideoList is used during filtering process by text
      // Filter videos containing the text
      List<Video> filteredByTextVideoList = _filteredVideoList.where((video) {
        // Check if the text included in title, remarks & multipleTags
        if (video.title.toString().toLowerCase().contains(searchText) |
            video.remarks.toString().toLowerCase().contains(searchText) |
            video.types.toString().toLowerCase().contains(searchText) |
            video.coreMembers.toString().toLowerCase().contains(searchText) |
            video.guests.toString().toLowerCase().contains(searchText)) {
          return true;
        }

        // Check if the text included in multipleTagsWithTimestamps
        for (List tagItem in video.themes) {
          if (tagItem[0].toLowerCase().contains(searchText)) {
            return true;
          }
        }

        for (List tagItem in video.topics) {
          if (tagItem[0].toLowerCase().contains(searchText)) {
            return true;
          }
        }

        for (List tagItem in video.people) {
          if (tagItem[0].toLowerCase().contains(searchText)) {
            return true;
          }
        }

        for (List tagItem in video.works) {
          if (tagItem[0].toLowerCase().contains(searchText)) {
            return true;
          }
        }

        for (List tagItem in video.otherTags) {
          if (tagItem[0].toLowerCase().contains(searchText)) {
            return true;
          }
        }

        // Return false if the text not included anywhere
        return false;
      }).toList();

      // Copy filteredByTextVideoList to filteredVideoList
      _filteredVideoList.clear();
      _filteredVideoList.addAll(filteredByTextVideoList);
    }

    // Filter by dateTimeRange
    if (selectedDateTimeRange != allowedDateTimeRange) {
      List<Video> filteredByDateTimeRangeVideoList =
          _filteredVideoList.where((video) {
        if ((video.dateTime == selectedDateTimeRange.start) |
            video.dateTime.isAfter(selectedDateTimeRange.start)) {
          if ((video.dateTime == selectedDateTimeRange.end) |
              video.dateTime.isBefore(selectedDateTimeRange.end)) {
            return true;
          }
        }
        return false;
      }).toList();

      // Copy filteredByDateTimeRangeVideoList to filteredVideoList
      _filteredVideoList.clear();
      _filteredVideoList.addAll(filteredByDateTimeRangeVideoList);
    }

    // Sort the filtered video list by index (descending) and then date (descending)
    _filteredVideoList.sort((a, b) => b.index.compareTo(a.index));
    _filteredVideoList.sort((a, b) => b.date.compareTo(a.date));

    // Copy filtered video list to selected video list for showing
    // If no tags selected & empty search text box, all videos are copied
    _selectedVideoList.clear();
    _selectedVideoList.addAll(_filteredVideoList);

    // End loading
    isLoading = false;
    notifyListeners();
  }

  // Used when selected a tag from filter menu or 'add/delete tag' from video grid
  void addOrDeleteOneTag({required Set selectedTags, required String tag}) {
    if (!selectedTags.contains(tag)) {
      selectedTags.add(tag);
      // _allSelectedTags are the selected tags shown below search text box
      _allSelectedTags.add({'selectedTags': selectedTags, 'tag': tag});
    } else {
      _allSelectedTags.removeWhere((selectedTag) =>
          selectedTag['selectedTags'] == selectedTags &&
          selectedTag['tag'] == tag);
      selectedTags.remove(tag);

      // Reset selectedDateTimeRange if DateTimeRange is deleted
      if (selectedTags == _selectedTagsOfDateTimeRange) {
        selectedDateTimeRange = allowedDateTimeRange;
        isSelectedDateTimeRange = false;
      }
    }
    notifyListeners();
    filterVideos();
  }

  // Used when selected 'use one tag only' from video grid
  // Add the selected tag and remove all other tags
  void useOneTagOnly({required Set selectedTags, required String tag}) {
    clearSelectedTags();
    addOrDeleteOneTag(selectedTags: selectedTags, tag: tag);
  }

  void onChangeSearchText({required String inputSearchText}) {
    searchText = inputSearchText.toLowerCase();
    filterVideos();
  }

  void onChangeInputDateTimeRange({required DateTimeRange inputDateTimeRange}) {
    isSelectedDateTimeRange = true;
    selectedDateTimeRange = inputDateTimeRange;
    addOrDeleteOneTag(
        selectedTags: _selectedTagsOfDateTimeRange,
        tag:
            '日期範圍  ${selectedDateTimeRange.start.year}/${selectedDateTimeRange.start.month}/${selectedDateTimeRange.start.day} - ${selectedDateTimeRange.end.year}/${selectedDateTimeRange.end.month}/${selectedDateTimeRange.end.day}');
    notifyListeners();
    filterVideos();
  }

  void clearSelectedTags() {
    // Clear all selected tags
    _selectedTagsOfTypes.clear();
    _selectedTagsOfYear.clear();
    _selectedTagsOfMonth.clear();
    _selectedTagsOfCoreMembers.clear();
    _selectedTagsOfGuests.clear();
    _selectedTagsOfThemes.clear();
    _selectedTagsOfTopics.clear();
    _selectedTagsOfPeople.clear();
    _selectedTagsOfWorks.clear();
    _selectedTagsOfLevel.clear();
    _selectedTagsOfOtherTags.clear();
    selectedDateTimeRange = allowedDateTimeRange;
    isSelectedDateTimeRange = false;

    _allSelectedTags.clear();

    // Filter videos to show all video
    filterVideos();
  }

  // Check if the tag is in selectedTags
  bool isTagSelected({required Set selectedTags, required String tag}) {
    return selectedTags.contains(tag);
  }

  // getters

  List<Video> get videoList {
    return _selectedVideoList;
  }

  Set<String> get allTagsOfType {
    return _allTagsOfTypes;
  }

  Set<String> get allTagsOfYear {
    return _allTagsOfYear;
  }

  Set<String> get allTagsOfMonth {
    return _allTagsOfMonth;
  }

  Set<String> get allTagsOfCoreMembers {
    return _allTagsOfCoreMembers;
  }

  Set<String> get allTagsOfGuests {
    return _allTagsOfGuests;
  }

  Set<String> get allTagsOfThemes {
    return _allTagsOfThemes;
  }

  Set<String> get allTagsOfTopics {
    return _allTagsOfTopics;
  }

  Set<String> get allTagsOfPeople {
    return _allTagsOfPeople;
  }

  Set<String> get allTagsOfWorks {
    return _allTagsOfWorks;
  }

  Set<String> get allTagsOfLevel {
    return _allTagsOfLevel;
  }

  Set<String> get allTagsOfOtherTags {
    return _allTagsOfOtherTags;
  }

  Set<String> get selectedTypes {
    return _selectedTagsOfTypes;
  }

  Set<String> get selectedYear {
    return _selectedTagsOfYear;
  }

  Set<String> get selectedMonth {
    return _selectedTagsOfMonth;
  }

  Set<String> get selectedCoreMembers {
    return _selectedTagsOfCoreMembers;
  }

  Set<String> get selectedGuests {
    return _selectedTagsOfGuests;
  }

  Set<String> get selectedThemes {
    return _selectedTagsOfThemes;
  }

  Set<String> get selectedTopics {
    return _selectedTagsOfTopics;
  }

  Set<String> get selectedPeople {
    return _selectedTagsOfPeople;
  }

  Set<String> get selectedWorks {
    return _selectedTagsOfWorks;
  }

  Set<String> get selectedLevel {
    return _selectedTagsOfLevel;
  }

  Set<String> get selectedOtherTags {
    return _selectedTagsOfOtherTags;
  }

  List get allSelectedTags {
    return _allSelectedTags;
  }
}
