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
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;
  double _fontsize;
  double _initfontsize;
  bool _darkmode;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initfontsize = 4;
    _fontsize = _initfontsize;
    _darkmode = true;
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dark Mode",
                      style: TextStyle(
                        fontSize: (18),
                        color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    new Switch(
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Font Size",
                      style: TextStyle(
                        fontSize: (18),
                        color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      (_fontsize).toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: (18),
                        color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                padding: const EdgeInsets.only(bottom: 40),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Copy text to clipboard",
                      style: TextStyle(
                        fontSize: (18),
                        color: Color(_darkmode ? 0xFFFFFFFF : 0xFF000000),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.grey[500],
                      onPressed: () {
                        Clipboard.setData(new ClipboardData(text: _text));
                      },
                      child: Icon(
                        Icons.content_copy,
                        size: 22,
                        //color: Colors.black,
                      ),
                    ),
                  ],
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
                highlightColor: Colors.blue[200],
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Container(
                    //color: Colors.red,
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
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
              Container(
                alignment: Alignment.bottomRight,
                //color: Colors.red,
                height: 140,
                //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked, floatingActionButton:
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 55),
                  child: AvatarGlow(
                    animate: _isListening,
                    //glowColor: Theme.of(context).primaryColor,
                    glowColor: Color(_isListening ? 0xFF44336 : 0xFF2196F3),
                    endRadius: 75.0,
                    duration: const Duration(milliseconds: 2000),
                    repeatPauseDuration: const Duration(milliseconds: 100),
                    repeat: true,
                    child: FloatingActionButton(
                      backgroundColor:
                          Color(_isListening ? 0xFFF44336 : 0xFF2196F3),
                      onPressed: _listen,
                      child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                    ),
                  ),
                ),
              ),
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
