import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:philosearch/constants/constants.dart';
import 'package:philosearch/models/video_data.dart';

class FilterMenuTagButton extends StatelessWidget {
  final Set selectedTags;
  final String tagName;
  // isAllSelectedTagRow depends on whether the button is shown in allSelectedTagRow
  final bool isAllSelectedTagRow;

  const FilterMenuTagButton(
      {Key? key,
      required this.selectedTags,
      required this.tagName,
      required this.isAllSelectedTagRow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoData videoData = Provider.of<VideoData>(context);

    bool isTagSelected =
        videoData.isTagSelected(selectedTags: selectedTags, tag: tagName);

    return OutlinedButton(
      onPressed: (() {
        videoData.addOrDeleteOneTag(selectedTags: selectedTags, tag: tagName);
      }),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              tagName,
              style: kTagTextStyle,
            ),
          ),
          // Add cross icon if the button is shown in allSelectedTagRow
          isAllSelectedTagRow
              ? const Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Icon(
                    Icons.clear,
                    size: 13.0,
                    color: kTagColor,
                  ),
                )
              : const SizedBox()
        ],
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(10.0, 12, 10.0, 13.0),
        minimumSize: const Size(45.0, 0.0),
        backgroundColor:
            isTagSelected ? kSelectedTagButtonColor : kUnselectedTagButtonColor,
        primary: kButtonPrimaryColor,
        side: const BorderSide(color: Colors.transparent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
