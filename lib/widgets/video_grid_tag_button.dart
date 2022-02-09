import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:philosearch/constants/constants.dart';
import 'package:philosearch/models/video_data.dart';

class VideoGridTagButton extends StatelessWidget {
  final Set selectedTags;
  // tagName is for adding or deleting the tag
  final String tagName;
  // tagStringForDisplay is for display & includes timestamps if available
  final String tagStringForDisplay;

  const VideoGridTagButton(
      {Key? key,
      required this.selectedTags,
      required this.tagName,
      required this.tagStringForDisplay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoData videoData = Provider.of<VideoData>(context);

    bool isTagSelected =
        videoData.isTagSelected(selectedTags: selectedTags, tag: tagName);

    return Theme(
      data: ThemeData().copyWith(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: PopupMenuButton(
          tooltip: '開選單',
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          color: Colors.white,
          offset: const Offset(0, 30),
          child: createTagForPopUpMenu(
              tagString: tagStringForDisplay, isTagSelected: isTagSelected),
          itemBuilder: (context) {
            return isTagSelected
                ? [
                    PopupMenuItem(
                        child: Row(
                          children: [
                            const Text('唔篩  ', style: kGridTagTypeTextStyle),
                            createTagForPopUpMenu(
                                tagString: tagName, isTagSelected: true),
                            const Text('  喇', style: kGridTagTypeTextStyle),
                          ],
                        ),
                        onTap: () {
                          videoData.addOrDeleteOneTag(
                              selectedTags: selectedTags, tag: tagName);
                        }),
                  ]
                : [
                    PopupMenuItem(
                        child: Row(
                          children: [
                            const Text('加埋  ', style: kGridTagTypeTextStyle),
                            createTagForPopUpMenu(
                                tagString: tagName, isTagSelected: false),
                            const Text('  嚟篩', style: kGridTagTypeTextStyle),
                          ],
                        ),
                        onTap: () {
                          videoData.addOrDeleteOneTag(
                              selectedTags: selectedTags, tag: tagName);
                        }),
                    PopupMenuItem(
                        child: Row(
                          children: [
                            const Text('淨係用  ', style: kGridTagTypeTextStyle),
                            createTagForPopUpMenu(
                                tagString: tagName, isTagSelected: false),
                            const Text('  嚟篩', style: kGridTagTypeTextStyle),
                          ],
                        ),
                        onTap: () {
                          videoData.useOneTagOnly(
                              selectedTags: selectedTags, tag: tagName);
                        })
                  ];
          }),
    );
  }
}

Widget createTagForPopUpMenu(
    {required String tagString, required bool isTagSelected}) {
  return ConstrainedBox(
    constraints: const BoxConstraints(minWidth: 35.0, minHeight: 0.0),
    child: Container(
      padding: const EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 4.0),
      decoration: BoxDecoration(
        color:
            isTagSelected ? kSelectedTagButtonColor : kUnselectedTagButtonColor,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Text(
        tagString,
        style: kTagTextStyle,
      ),
    ),
  );
}
