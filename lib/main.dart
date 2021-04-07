import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';

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
  double _confidence = 1.0;
  double _fontsize;
  double _initfontsize;
  bool _darkmode;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initfontsize = 3;
    _fontsize = _initfontsize;
    _darkmode = true; // grab from prefs
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
                  color:
                      Color(_darkmode ? 0xff424242 : 0xFFFFFFFF), //Colors.grey,
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        if (_darkmode == true) {
                          _darkmode = false;
                        } else {
                          _darkmode = true;
                        }
                        print(_darkmode);
                      });
                    },
                    title: Text(
                      "Dark theme",
                      style: TextStyle(
                        color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: Icon(
                      Icons.lightbulb,
                      color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                    ),
                    trailing: new Switch(
                      value: _darkmode,
                      onChanged: (value) {
                        setState(() {
                          _darkmode = value;
                          print(_darkmode);
                        });
                      },
                      activeTrackColor: Colors.lightBlue,
                      activeColor: Colors.blue,
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
                        onTap: () {
                          //open edit profile
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
                          "_fontfamily" + " >",
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
                  color: Colors.blue[
                      500], //Colors.blueGrey[300], //Color(_darkmode ? 0xff424242 : 0xFFFFFFFF),
                  child: ListTile(
                    onTap: () {
                      Clipboard.setData(new ClipboardData(text: _text));
                    },
                    title: Text(
                      "Tap to copy text",
                      style: TextStyle(
                        color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: Icon(
                      Icons.content_copy,
                      color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
        collapsed: Container(
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
                      //style: TextStyle(color: Colors.white),
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
              (_welcome || _text.length < 1)
                  ? Center(
                      child: Text(
                      "hi.",
                      style: TextStyle(
                          color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                          fontSize: 30),
                    ))
                  : Expanded(
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Container(
                          alignment: Alignment.center,
                          //color: Colors.red,
                          padding: const EdgeInsets.fromLTRB(
                              20.0, 20.0, 20.0, 120.0),
                          child: TextHighlight(
                            text: _text,
                            words: _highlights,
                            textStyle: TextStyle(
                              fontSize: (10 * _fontsize),
                              color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  //alignment: Alignment.bottomRight,
                  //color: Colors.green,
                  //height: 200,
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
                        onPressed: _listen,
                        label:
                            Text(_isListening ? "Tap to stop" : "Tap to begin"),
                      ),

                      // child: FloatingActionButton(
                      //   backgroundColor:
                      //       Color(_isListening ? 0xFFF44336 : 0xFF2196F3),
                      //   onPressed: _listen,
                      //   child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                      // ),
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
    _welcome = false;
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
