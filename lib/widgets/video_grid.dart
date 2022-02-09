import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:philosearch/constants/constants.dart';
import 'package:philosearch/models/tag_type.dart';
import 'package:philosearch/models/video_data.dart';
import 'package:philosearch/widgets/video_grid_tag_button.dart';

class VideoGrid extends StatefulWidget {
  const VideoGrid({Key? key}) : super(key: key);

  @override
  State<VideoGrid> createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {
  final ScrollController _videoGridController = ScrollController();

  @override
  void dispose() {
    _videoGridController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VideoData videoData = Provider.of<VideoData>(context);

    // crossAxisCount determines how many videos are shown horizontally
    int crossAxisCount = 6;
    // isMobile is used for adjusting spacing on mobile devices
    bool isMobile = false;

    // Change crossAxisCount & isMobile according to screen size
    if (MediaQuery.of(context).size.width <= 1400 &&
        MediaQuery.of(context).size.width > 1000) {
      crossAxisCount = 4;
    } else if (MediaQuery.of(context).size.width <= 1000) {
      crossAxisCount = 2;
      isMobile = true;
    }

    // Scroll to top after re-rendering (when selected tags change)
    if (_videoGridController.hasClients) {
      _videoGridController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300), // NEW
        curve: Curves.ease,
      );
    }

    return Scrollbar(
      isAlwaysShown: true,
      controller: _videoGridController,
      child: SingleChildScrollView(
        controller: _videoGridController,
        child: StaggeredGridView.countBuilder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          crossAxisCount: crossAxisCount,
          key: ObjectKey(crossAxisCount),
          staggeredTileBuilder: (int index) => const StaggeredTile.fit(2),
          itemCount: videoData.videoList.length,
          itemBuilder: (BuildContext context, int index) {
            return VideoCard(
                videoData: videoData, isMobile: isMobile, index: index);
          },
        ),
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  const VideoCard({
    Key? key,
    required this.videoData,
    required this.isMobile,
    required this.index,
  }) : super(key: key);

  final VideoData videoData;
  final bool isMobile;
  final int index;

  @override
  Widget build(BuildContext context) {
    VideoData videoData = Provider.of<VideoData>(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(9.0, 0, 9.0, 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InkWell(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              onTap: () {
                _launchURL(videoData.videoList[index].link);
              },
              child: Container(
                alignment: Alignment.topRight,
                constraints:
                    const BoxConstraints(minWidth: 320.0, minHeight: 180.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(videoData.videoList[index].image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 10.0, 0),
                  child: Icon(Icons.link,
                      size: 30.0, color: Colors.white.withOpacity(0.5)),
                ),
              ),
            ),
            Padding(
              padding: !isMobile
                  ? const EdgeInsets.fromLTRB(16, 0, 16, 16)
                  : const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10.0),
                    Text(videoData.videoList[index].title,
                        style: kGridTitleTextStyle),
                    SizedBox(height: !isMobile ? 12.0 : 10.0),
                    TagRowForVideoCard(
                      isMobile: isMobile,
                      tagNameForDisplay:
                          videoData.videoList[index].types.contains('文')
                              ? '作者'
                              : '太保',
                      tagsOfVideo: videoData.videoList[index].coreMembers,
                      selectedTags: videoData.selectedCoreMembers,
                      tagType: TagType.multipleTags,
                    ),
                    TagRowForVideoCard(
                      isMobile: isMobile,
                      tagNameForDisplay:
                          videoData.videoList[index].types.contains('文')
                              ? '作者'
                              : '嘉賓 拍檔',
                      tagsOfVideo: videoData.videoList[index].guests,
                      selectedTags: videoData.selectedGuests,
                      tagType: TagType.multipleTags,
                    ),
                    TagRowForVideoCard(
                      isMobile: isMobile,
                      tagNameForDisplay: '主題',
                      tagsOfVideo: videoData.videoList[index].themes,
                      selectedTags: videoData.selectedThemes,
                      tagType: TagType.multipleTagsWithTimestamps,
                    ),
                    TagRowForVideoCard(
                      isMobile: isMobile,
                      tagNameForDisplay: '題目',
                      tagsOfVideo: videoData.videoList[index].topics,
                      selectedTags: videoData.selectedTopics,
                      tagType: TagType.multipleTagsWithTimestamps,
                    ),
                    TagRowForVideoCard(
                      isMobile: isMobile,
                      tagNameForDisplay: '人',
                      tagsOfVideo: videoData.videoList[index].people,
                      selectedTags: videoData.selectedPeople,
                      tagType: TagType.multipleTagsWithTimestamps,
                    ),
                    TagRowForVideoCard(
                      isMobile: isMobile,
                      tagNameForDisplay: '作品',
                      tagsOfVideo: videoData.videoList[index].works,
                      selectedTags: videoData.selectedWorks,
                      tagType: TagType.multipleTagsWithTimestamps,
                    ),
                    TagRowForVideoCard(
                      isMobile: isMobile,
                      tagNameForDisplay: '難度',
                      tagsOfVideo: videoData.videoList[index].level,
                      selectedTags: videoData.selectedLevel,
                      tagType: TagType.singleTag,
                    ),
                    TagRowForVideoCard(
                      isMobile: isMobile,
                      tagNameForDisplay: '其他標籤',
                      tagsOfVideo: videoData.videoList[index].otherTags,
                      selectedTags: videoData.selectedOtherTags,
                      tagType: TagType.multipleTagsWithTimestamps,
                    ),
                    VideoGridRemarksColumn(
                        remarksText: videoData.videoList[index].remarks),
                    SizedBox(height: !isMobile ? 14.0 : 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TagRowForVideoCard(
                            isMobile: isMobile,
                            tagNameForDisplay: '類型',
                            tagsOfVideo: videoData.videoList[index].types,
                            selectedTags: videoData.selectedTypes,
                            tagType: TagType.multipleTags,
                          ),
                        ),
                        Text(
                            "${videoData.videoList[index].get('year')}/${videoData.videoList[index].get('month')}/${videoData.videoList[index].get('day')}  #${videoData.videoList[index].get('index')} ",
                            style: kTagTextStyle),
                      ],
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}

class TagRowForVideoCard extends StatelessWidget {
  final bool isMobile;
  final String tagNameForDisplay;
  final dynamic tagsOfVideo;
  final Set selectedTags;
  final TagType tagType;

  const TagRowForVideoCard(
      {Key? key,
      required this.isMobile,
      required this.tagNameForDisplay,
      required this.tagsOfVideo,
      required this.selectedTags,
      required this.tagType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];

    // Add heading except the row of 'type'
    if (tagNameForDisplay != '類型') {
      widgetList.add(Text('$tagNameForDisplay ', style: kGridTagTypeTextStyle));
    }

    if (tagType == TagType.singleTag) {
      if (tagsOfVideo.contains("--")) {
        return const SizedBox();
      }
      widgetList.add(
        VideoGridTagButton(
            selectedTags: selectedTags,
            tagName: tagsOfVideo,
            // 'singleTag' has no timestamps
            tagStringForDisplay: tagsOfVideo),
      );
    }

    if (tagType == TagType.multipleTags) {
      if (tagsOfVideo.contains("--")) {
        return const SizedBox();
      }

      for (String tag in tagsOfVideo) {
        widgetList.add(
          VideoGridTagButton(
              selectedTags: selectedTags,
              tagName: tag,
              // 'multipleTags' has no timestamps
              tagStringForDisplay: tag),
        );
      }
    }

    if (tagType == TagType.multipleTagsWithTimestamps) {
      for (List<String> tagItem in tagsOfVideo) {
        if (tagItem[0].contains("--")) {
          return const SizedBox();
        }

        String tagNameWithTimestamps = tagItem[0];

        // Check if there are timestamps
        if (tagItem.length > 1) {
          tagNameWithTimestamps = tagNameWithTimestamps + " (";

          for (int i = 1; i < tagItem.length; i++) {
            tagNameWithTimestamps = tagNameWithTimestamps + tagItem[i];
            if (i < tagItem.length - 1) {
              tagNameWithTimestamps = tagNameWithTimestamps + ', ';
            }
          }
          tagNameWithTimestamps = tagNameWithTimestamps + ')';
        }

        widgetList.add(VideoGridTagButton(
          selectedTags: selectedTags,
          tagName: tagItem[0],
          tagStringForDisplay: tagNameWithTimestamps,
        ));
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (tagNameForDisplay != '類型') ? 8.0 : 0.0,
        vertical: (tagNameForDisplay != '類型' && isMobile == false) ? 2.0 : 1.0,
      ),
      child: Wrap(
        spacing: 4.0,
        runSpacing: 4.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: widgetList,
      ),
    );
  }
}

class VideoGridRemarksColumn extends StatelessWidget {
  final List<String> remarksText;

  const VideoGridRemarksColumn({Key? key, required this.remarksText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if there are remarks
    if (remarksText[0] == "--") {
      return const SizedBox();
    } else {
      List<Widget> remarksList = [];

      // Add heading
      remarksList.add(const Text('備註', style: kGridTagTypeTextStyle));

      // Add text in remarks
      for (String remark in remarksText) {
        remarksList.add(Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(remark),
        ));
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: remarksList,
        ),
      );
    }
  }
}

void _launchURL(String _url) async {
  if (!await launch(_url)) throw 'Could not launch $_url';
}
