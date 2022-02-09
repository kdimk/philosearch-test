import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:philosearch/constants/constants.dart';
import 'package:philosearch/models/video_data.dart';
import 'package:philosearch/widgets/filter_menu_tag_button.dart';

class FilterMenu extends StatefulWidget {
  const FilterMenu({Key? key}) : super(key: key);

  @override
  State<FilterMenu> createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  // Controller for search text box
  final TextEditingController _searchTextBoxController =
      TextEditingController();

  @override
  void dispose() {
    _searchTextBoxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VideoData videoData = Provider.of<VideoData>(context);

    _searchTextBoxController.text = videoData.searchText;
    // Ensure text cursor shows at the end after rebuild
    _searchTextBoxController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchTextBoxController.text.length));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchTextBox(searchTextBoxController: _searchTextBoxController),
          const SizedBox(height: 26.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Row(children: const [
                  Icon(Icons.filter_alt, color: kTagTypeColor),
                  SizedBox(width: 3.0),
                  Text('我要篩⋯⋯', style: kMenuTagTypeTextStyle)
                ]),
              ),
              const ResetButton()
            ],
          ),
          const AllSelectedTagRow(),
          TagExpansionTile(
              title: '類型',
              icon: const Icon(Icons.category, color: kTagTypeColor),
              tileContent: TagRowForExpansionTile(
                  allTags: videoData.allTagsOfType,
                  selectedTags: videoData.selectedTypes)),
          const AuthorSpeakerExpansionTile(),
          TagExpansionTile(
              title: '主題',
              icon: const Icon(Icons.topic, color: kTagTypeColor),
              tileContent: TagRowForExpansionTile(
                  allTags: videoData.allTagsOfThemes,
                  selectedTags: videoData.selectedThemes)),
          TagExpansionTile(
              title: '題目',
              icon: const Icon(Icons.help_outline, color: kTagTypeColor),
              tileContent: TagRowForExpansionTile(
                  allTags: videoData.allTagsOfTopics,
                  selectedTags: videoData.selectedTopics)),
          TagExpansionTile(
              title: '人',
              icon: const Icon(Icons.psychology, color: kTagTypeColor),
              tileContent: TagRowForExpansionTile(
                  allTags: videoData.allTagsOfPeople,
                  selectedTags: videoData.selectedPeople)),
          TagExpansionTile(
              title: '作品',
              icon: const Icon(Icons.sticky_note_2, color: kTagTypeColor),
              tileContent: TagRowForExpansionTile(
                  allTags: videoData.allTagsOfWorks,
                  selectedTags: videoData.selectedWorks)),
          TagExpansionTile(
              title: '難度  (文、Podcast適用)',
              icon: const Icon(Icons.signal_cellular_alt, color: kTagTypeColor),
              tileContent: TagRowForExpansionTile(
                  allTags: videoData.allTagsOfLevel,
                  selectedTags: videoData.selectedLevel)),
          TagExpansionTile(
              title: '其他標籤',
              icon: const Icon(Icons.sell, color: kTagTypeColor),
              tileContent: TagRowForExpansionTile(
                  allTags: videoData.allTagsOfOtherTags,
                  selectedTags: videoData.selectedOtherTags)),
          const DateExpansionTile(),
          const SizedBox(height: 26.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              FilterMenuBottomButton(
                text: '說明書',
                link:
                    'https://docs.google.com/document/d/13X4dZpsA1aXJDQ0xrBNIOtIVJ_bQ8cPCQAaGanp_GLY/edit?usp=sharing',
                icon: Icon(Icons.menu_book_rounded, color: kTagTypeColor),
              ),
              SizedBox(width: 10.0),
              FilterMenuBottomButton(
                text: '報告',
                link:
                    'https://docs.google.com/forms/d/e/1FAIpQLSeFzOMajlcPmCUsKwurh1WijvuOURB8jmRzzq0bcJtACr2bIw/viewform?usp=sf_link',
                icon: Icon(Icons.email_rounded, color: kTagTypeColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SearchTextBox extends StatelessWidget {
  final TextEditingController searchTextBoxController;

  const SearchTextBox({Key? key, required this.searchTextBoxController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoData videoData = Provider.of<VideoData>(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 13.0),
      child: TextField(
        controller: searchTextBoxController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: kTagTypeColor),
          hintText: '我想搵⋯⋯',
          hintStyle: kMenuTagTypeTextStyle,
          focusColor: kTagTypeColor,
        ),
        cursorColor: kTagTypeColor,
        style: kMenuTagTypeTextStyle,
        onChanged: (value) {
          videoData.onChangeSearchText(inputSearchText: value);
        },
      ),
    );
  }
}

class ResetButton extends StatelessWidget {
  const ResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoData videoData = Provider.of<VideoData>(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.center,
      child: OutlinedButton(
          onPressed: () {
            videoData.clearSelectedTags();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.delete, color: kTagTypeColor),
              Text(
                '重設',
                style: kMenuTagTypeTextStyle,
              ),
            ],
          ),
          style: kFilterMenuButtonStyle),
    );
  }
}

// All selected tags shown under "I want to filter..."
class AllSelectedTagRow extends StatelessWidget {
  const AllSelectedTagRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoData videoData = Provider.of<VideoData>(context);

    if (videoData.allSelectedTags.isNotEmpty) {
      List<Widget> selectedTags = [];

      for (Map video in videoData.allSelectedTags) {
        selectedTags.add(FilterMenuTagButton(
          selectedTags: video['selectedTags'],
          tagName: video['tag'],
          isAllSelectedTagRow: true,
        ));
      }
      return Container(
        padding: const EdgeInsets.fromLTRB(18.0, 5.0, 5.0, 15.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.start,
          children: selectedTags,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

class TagExpansionTile extends StatelessWidget {
  final Icon icon;
  final String title;
  final Widget tileContent;

  const TagExpansionTile(
      {Key? key,
      required this.icon,
      required this.title,
      required this.tileContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Theme(
        data: ThemeData().copyWith(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 10.0),
                Flexible(
                  child: Text(
                    title,
                    style: kMenuTagTypeTextStyle,
                  ),
                ),
              ],
            ),
            textColor: kTagTypeColor,
            iconColor: kTagTypeColor,
            collapsedIconColor: kTagTypeColor,
            initiallyExpanded: title == '主題',
            childrenPadding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
            children: <Widget>[
              tileContent,
            ]),
      ),
    );
  }
}

class TagRowForExpansionTile extends StatelessWidget {
  final Set allTags;
  final Set selectedTags;

  const TagRowForExpansionTile(
      {Key? key, required this.allTags, required this.selectedTags})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> tagButtons = [];

    for (String tag in allTags) {
      tagButtons.add(FilterMenuTagButton(
        selectedTags: selectedTags,
        tagName: tag,
        isAllSelectedTagRow: false,
      ));
    }

    return Container(
      alignment: Alignment.topLeft,
      child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.start,
          children: tagButtons),
    );
  }
}

class AuthorSpeakerExpansionTile extends StatelessWidget {
  const AuthorSpeakerExpansionTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoData videoData = Provider.of<VideoData>(context);

    return TagExpansionTile(
        title: '作者  講者',
        icon: const Icon(Icons.self_improvement, color: kTagTypeColor),
        tileContent: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '太保  (荼毒室主要成員)',
              style: kMenuTagTypeTextStyle,
            ),
            const SizedBox(height: 12.0),
            TagRowForExpansionTile(
                allTags: videoData.allTagsOfCoreMembers,
                selectedTags: videoData.selectedCoreMembers),
            const SizedBox(height: 18.0),
            const Text(
              '嘉賓  拍檔',
              style: kMenuTagTypeTextStyle,
            ),
            const SizedBox(height: 12.0),
            TagRowForExpansionTile(
                allTags: videoData.allTagsOfGuests,
                selectedTags: videoData.selectedGuests),
          ],
        ));
  }
}

class DateExpansionTile extends StatelessWidget {
  const DateExpansionTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoData videoData = Provider.of<VideoData>(context);

    return TagExpansionTile(
        title: '日期',
        icon: const Icon(Icons.schedule, color: kTagTypeColor),
        tileContent: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '揀日期範圍',
              style: kMenuTagTypeTextStyle,
            ),
            const SizedBox(height: 12.0),
            SizedBox(
              width: 208.0,
              child: OutlinedButton(
                onPressed: () async {
                  final inputDateTimeRange = await showDateRangePicker(
                      context: context,
                      initialDateRange: videoData.isSelectedDateTimeRange
                          ? videoData.selectedDateTimeRange
                          : null,
                      firstDate: videoData.allowedDateTimeRange.start,
                      lastDate: videoData.allowedDateTimeRange.end,
                      locale: const Locale.fromSubtags(
                          languageCode: 'zh',
                          scriptCode: 'Hant',
                          countryCode: 'HK'),
                      builder: (BuildContext context, Widget? child) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Theme(
                              data: ThemeData(
                                  fontFamily: 'NotoSansHKMedium',
                                  primarySwatch: kMaterialColorBlack),
                              child: child!,
                            ),
                          ),
                        );
                      });
                  if (inputDateTimeRange != null) {
                    videoData.onChangeInputDateTimeRange(
                        inputDateTimeRange: inputDateTimeRange);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${videoData.selectedDateTimeRange.start.year}/${videoData.selectedDateTimeRange.start.month}/${videoData.selectedDateTimeRange.start.day} - ${videoData.selectedDateTimeRange.end.year}/${videoData.selectedDateTimeRange.end.month}/${videoData.selectedDateTimeRange.end.day}',
                      style: kTagTextStyle,
                    ),
                    const SizedBox(width: 5.0),
                    const Icon(Icons.edit, color: kTagColor, size: 18.0),
                  ],
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(10.0, 12, 10.0, 13.0),
                  backgroundColor: videoData.isSelectedDateTimeRange
                      ? kSelectedTagButtonColor
                      : kUnselectedTagButtonColor,
                  primary: kButtonPrimaryColor,
                  side: const BorderSide(color: Colors.transparent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18.0),
            const Text(
              '揀指定年份',
              style: kMenuTagTypeTextStyle,
            ),
            const SizedBox(height: 12.0),
            TagRowForExpansionTile(
              allTags: videoData.allTagsOfYear,
              selectedTags: videoData.selectedYear,
            ),
            const SizedBox(height: 18.0),
            const Text(
              '揀指定月份',
              style: kMenuTagTypeTextStyle,
            ),
            const SizedBox(height: 12.0),
            TagRowForExpansionTile(
              allTags: videoData.allTagsOfMonth,
              selectedTags: videoData.selectedMonth,
            ),
          ],
        ));
  }
}

class FilterMenuBottomButton extends StatelessWidget {
  final String text;
  final String link;
  final Icon icon;

  const FilterMenuBottomButton(
      {Key? key, required this.text, required this.link, required this.icon})
      : super(key: key);

  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 130.0,
        height: 40.0,
        child: OutlinedButton(
            onPressed: () {
              _launchURL(link);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 10.0),
                Text(
                  text,
                  style: kMenuTagTypeTextStyle,
                ),
              ],
            ),
            style: kFilterMenuButtonStyle),
      ),
    );
  }
}
