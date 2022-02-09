import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:philosearch/constants/constants.dart';
import 'package:philosearch/models/video_data.dart';
import 'package:philosearch/widgets/filter_menu.dart';
import 'package:philosearch/widgets/video_grid.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => VideoData()),
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoData videoData = Provider.of<VideoData>(context);

    // Load data when starting app
    if (videoData.isLoading) {
      videoData.initiateData();
    }

    // Show loading screen when loading data & show app when finished
    return MaterialApp(
      title: kAppTitle,
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hant', countryCode: 'HK')
      ],
      // Show loading screen when loading data & show app when finished
      home: videoData.isLoading
          ? Container(
              color: kBackgroundColor,
              child: const Center(
                  child: CircularProgressIndicator(color: kLoadingCircleColor)),
            )
          : Scaffold(body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
              // Show responsive layout based on screen width
              return MediaQuery.of(context).size.width <= 768
                  // Layout for smaller screen
                  ? Scaffold(
                      drawer: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Drawer(
                            child: Container(
                          color: kBackgroundColor,
                          child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: const FilterMenu(),
                          ),
                        )),
                      ),
                      body: const VideoGrid(),
                      floatingActionButton: Builder(builder: (context) {
                        return FloatingActionButton(
                          backgroundColor: kFloatingButtonColor,
                          child: const Icon(Icons.filter_alt),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        );
                      }),
                    )
                  // Layout for larger screen
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          flex:
                              MediaQuery.of(context).size.width <= 1000 ? 5 : 3,
                          child: Scrollbar(
                            isAlwaysShown: true,
                            child: SingleChildScrollView(
                                controller: ScrollController(),
                                child: const FilterMenu()),
                          ),
                        ),
                        Expanded(
                            flex: MediaQuery.of(context).size.width <= 1000
                                ? 5
                                : 7,
                            child: const VideoGrid()),
                      ],
                    );
            })),
    );
  }
}
