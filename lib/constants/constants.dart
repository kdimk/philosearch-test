import 'package:flutter/material.dart';

const kAppTitle = '哲學係咁Search';

// Colors

const kBackgroundColor = Color(0xaaebebd5);
const kLoadingCircleColor = Colors.black;
const kFloatingButtonColor = Colors.black;
const kTagTypeColor = Colors.black;
const kTagColor = Colors.black;
Color kButtonPrimaryColor = Colors.grey.shade300;
Color kSelectedTagButtonColor = Colors.grey.shade400;
Color kUnselectedTagButtonColor = Colors.grey.shade100;
const MaterialColor kMaterialColorBlack = MaterialColor(
  0xff000000,
  <int, Color>{
    50: Color(0xff000000),
    100: Color(0xff000000),
    200: Color(0xff000000),
    300: Color(0xff000000),
    400: Color(0xff000000),
    500: Color(0xff000000),
    600: Color(0xff000000),
    700: Color(0xff000000),
    800: Color(0xff000000),
    900: Color(0xff000000)
  },
);

// Text Style

// Tag text in filter menu & video grid
const kTagTextStyle = TextStyle(
  fontFamily: 'NotoSansHKRegular',
  fontSize: 14.0,
  color: kTagColor,
);

// Tag type text in filter menu
const kMenuTagTypeTextStyle = TextStyle(
  fontFamily: 'NotoSansHKMedium',
  fontSize: 14.0,
  color: kTagTypeColor,
);

// Tag type text in video grid
const kGridTagTypeTextStyle = TextStyle(
  fontFamily: 'NotoSansHKMedium',
  fontSize: 12.0,
  color: kTagTypeColor,
);

// Title text in video grid
const kGridTitleTextStyle = TextStyle(
  fontFamily: 'NotoSansHKMedium',
  fontSize: 16.0,
  color: Colors.black,
);

// Button Style

// Buttons in filter menu
ButtonStyle kFilterMenuButtonStyle = OutlinedButton.styleFrom(
    side: const BorderSide(color: Colors.transparent),
    primary: kButtonPrimaryColor,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
    ));
