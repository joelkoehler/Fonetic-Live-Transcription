import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  bool _welcome = true;
  // double _confidence = 1.0;
  double _fontsize;
  double _initfontsize;
  bool _darkmode;
  String _font;
  double _welcomeOpacity;
  Timer timer;
  int selected_item;
  PanelController _pc = new PanelController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initfontsize = 3;
    _fontsize = _initfontsize;
    _darkmode = true;
    _font = 'Lato';
    _welcomeOpacity = 1;
    selected_item = 0;
    getFontPref();
    WidgetsBinding.instance.addPostFrameCallback((_) => _changeOpacity());
  }

  Future<bool> getDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool dark = prefs.getBool('dark');

    if (dark != null) {
      _darkmode = dark;
    } else {
      _darkmode = false;
      prefs.setBool('dark', false);
    }
    setState(() {});
    return dark;
  }

  setDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark', value);
    setState(() {
      _darkmode = value;
    });
  }

  Future<String> getFontPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String font = prefs.getString('font');

    if (font != null) {
      _font = font;
    } else {
      _font = 'Lato';
      prefs.setString('font', 'Lato');
    }
    setState(() {});
    return font;
  }

  setFontPref(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('font', name);
    // setState(() {
    //   _font = name;
    // });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _changeOpacity() {
    setState(() => _welcomeOpacity = _welcomeOpacity == 0 ? 1.0 : 0.0);
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return new Scaffold(
      backgroundColor: Color(_darkmode ? 0xff424242 : 0xFFFFFFFF),
      body: SlidingUpPanel(
        controller: _pc,
        backdropEnabled: true,
        color: Color(_darkmode ? 0xff424242 : 0xFFFFFFFF),
        minHeight: 50, // height of collapsed menu
        panel: Center(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 30.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 10.0),
                alignment: Alignment.topLeft,
                child: Text(
                  "Options",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.blue[
                      500], //Colors.blueGrey[300], //Color(_darkmode ? 0xff424242 : 0xFFFFFFFF),
                  child: ListTile(
                    onTap: () {
                      Clipboard.setData(new ClipboardData(text: _text));
                      vibrate();
                    },
                    title: Text(
                      "Tap to copy text",
                      style: TextStyle(
                        color: Colors
                            .white, //Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: Icon(
                      Icons.content_copy,
                      color: Colors
                          .white, //Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                    ),
                  ),
                ),
              ),

              // Container(
              //   padding: const EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 10.0),
              //   alignment: Alignment.topLeft,
              //   child: Text(
              //     "Text",
              //     style: TextStyle(
              //       fontSize: 20.0,
              //       fontWeight: FontWeight.bold,
              //       color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
              //     ),
              //   ),
              // ),
              //
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color:
                      Color(_darkmode ? 0xff424242 : 0xFFFFFFFF), //Colors.grey,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "Font Size",
                          style: TextStyle(
                            color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        leading: Icon(
                          Icons.format_size,
                          color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                        ),
                        trailing: Text(
                          (_fontsize).toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: (18),
                            color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: new Slider(
                          value: _fontsize,
                          activeColor: Colors.blue,
                          inactiveColor: Colors.grey,
                          onChanged: (double s) {
                            setState(() {
                              _fontsize = s;
                              _initfontsize = _fontsize;
                              vibrate();
                            });
                          },
                          divisions: 9,
                          min: 1,
                          max: 10.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: Text(
                            "(or pinch/zoom text)",
                            style: TextStyle(
                              fontSize: (12),
                              color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color:
                      Color(_darkmode ? 0xff424242 : 0xFFFFFFFF), //Colors.grey,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          vibrate();
                          await showModalBottomSheet<int>(
                            context: context,
                            builder: (BuildContext context) {
                              return _buildItemPicker();
                            },
                          );
                        },
                        title: Text(
                          "Typeface",
                          style: TextStyle(
                            color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        leading: Icon(
                          Icons.font_download_outlined,
                          color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                        ),
                        trailing: Text(
                          items[selected_item],
                          style: TextStyle(
                            fontSize: (12),
                            color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color:
                      Color(_darkmode ? 0xff424242 : 0xFFFFFFFF), //Colors.grey,
                  child: ListTile(
                    onTap: () {
                      vibrate();
                      setState(() {
                        if (_darkmode == true) {
                          //_darkmode = false;
                          setDarkMode(false);
                        } else {
                          //_darkmode = true;
                          setDarkMode(true);
                        }
                        print(_darkmode);
                      });
                    },
                    title: Text(
                      //fontFamily: 'Roboto',
                      "Dark theme",
                      style: TextStyle(
                        color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: Icon(
                      Icons.lightbulb_outline,
                      color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                    ),
                    trailing: new Switch(
                      value: _darkmode,
                      onChanged: (value) {
                        setState(() {
                          setDarkMode(value);
                          //_darkmode = value;
                          vibrate();
                        });
                      },
                      activeTrackColor: Colors.lightBlue,
                      activeColor: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
        collapsed: InkWell(
          onTap: () {
            _pc.open();
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.grey, borderRadius: radius),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Shimmer.fromColors(
                  baseColor: Colors.white, //Color(0xFFE3F2FD),
                  highlightColor: Colors.pink[50], //Colors.blue[200],
                  child: Column(
                    children: [
                      Icon(
                        IconData(0xe7ef, fontFamily: 'MaterialIcons'),
                        color: Colors.white,
                      ),
                      Text(
                        'options',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        body: new GestureDetector(
          onScaleStart: (ScaleStartDetails details) {
            setState(() {
              _initfontsize = _fontsize;
            });
          },
          onScaleUpdate: (ScaleUpdateDetails details) {
            setState(() {
              double temp = _initfontsize * details.scale;

              if (temp > 10) {
                _fontsize = 10;
              } else if (temp < 1) {
                _fontsize = 1;
              } else {
                _fontsize = temp;
              }
            });
          },
          onScaleEnd: (ScaleEndDetails details) {
            setState(() {
              _initfontsize = _fontsize;
            });
          },
          child: Stack(
            children: [
              (_welcome && _text.length < 1)
                  ? Center(
                      child: AnimatedOpacity(
                          curve: Curves.decelerate,
                          duration: const Duration(seconds: 3),
                          opacity: _welcomeOpacity,
                          child: Text(
                            //GoogleFonts.tradeWinds()
                            "hi there.",
                            style: TextStyle(
                                color:
                                    Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                                fontWeight: FontWeight.w500,
                                fontSize: 30),
                          )))
                  : Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            reverse: true,
                            child: Container(
                              alignment: Alignment.topLeft,
                              //color: Colors.red,
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 50.0, 20.0, 120.0),
                              child: Text(
                                _text,
                                style: GoogleFonts.getFont(
                                  _font,
                                  textStyle: TextStyle(
                                      color: Color(
                                          _darkmode ? 0xFFFFFFFF : 0xFF000000),
                                      //fontWeight: FontWeight.w500,
                                      fontSize: (10 * _fontsize)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60.0, 60.0, 20.0, 30.0),
                    child: AvatarGlow(
                      animate: _isListening,
                      //glowColor: Theme.of(context).primaryColor,
                      glowColor: Color(_isListening ? 0xFF44336 : 0xFF2196F3),
                      endRadius: 60.0,
                      duration: const Duration(milliseconds: 2000),
                      repeatPauseDuration: const Duration(milliseconds: 100),
                      repeat: true,

                      child: FloatingActionButton.extended(
                        backgroundColor:
                            Color(_isListening ? 0xFFF44336 : 0xFF2196F3),
                        onPressed: () {
                          _listen();
                          vibrate();
                        },
                        label:
                            Text(_isListening ? "Tap to stop" : "Tap to begin"),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        borderRadius: radius,
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );

      if (available) {
        setState(() => _isListening = true);
        oneMinuteListen();
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void oneMinuteListen() {
    if (_isListening) {
      _speech.listen(
        listenFor: Duration(seconds: 55),
        onResult: (val) => setState(() {
          _text = val.recognizedWords;
          if (_text.length > 0) {
            _welcome = false;
          }
          timer =
              Timer.periodic(Duration(seconds: 55), (t) => oneMinuteListen());
        }),
      );
    }
  }

  static Future<void> vibrate() async {
    await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
  }

  List<String> items = [
    "Lato",
    "Oswald",
    "Anton",
  ];

  Widget _buildItemPicker() {
    return Container(
        color: Color(_darkmode ? 0xff424242 : 0xFFFFFFFF),
        height: 250,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "Typeface",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CupertinoPicker(
                  itemExtent: 50.0,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selected_item = index;
                      vibrate();
                      _font = items[selected_item];
                      setFontPref(items[selected_item]);
                    });
                  },
                  children: new List<Widget>.generate(items.length, (index) {
                    return new Center(
                      child: Text(
                        items[index],
                        style: TextStyle(
                          color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ));
  }
}

// TODO:
// preferences
// fony family
