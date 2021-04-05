import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
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

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initfontsize = 5;
    _fontsize = _initfontsize;
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return new GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            double temp = _initfontsize * (.5 * details.scale);

            if (temp > 10) {
              _fontsize = 10;
            } else if (temp < 1) {
              _fontsize = 1;
            } else {
              _fontsize = temp;
            }

            print(
                "scale=${details.scale} fontsize=$_fontsize ih=$_initfontsize");
          });
        },
        onScaleEnd: (ScaleEndDetails details) {
          setState(() {
            _initfontsize = _fontsize;
          });
        },
        child: new Scaffold(
          backgroundColor: Color(0xff424242),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: AvatarGlow(
            animate: _isListening,
            glowColor: Theme.of(context).primaryColor,
            endRadius: 75.0,
            duration: const Duration(milliseconds: 2000),
            repeatPauseDuration: const Duration(milliseconds: 100),
            repeat: true,
            child: FloatingActionButton(
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
            ),
          ),
          body: SlidingUpPanel(
            minHeight: 75, // height of collapsed menu
            panel: Center(
                child: Expanded(
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
                divisions: 10,
                min: 1,
                max: 10.0,
              ),
            )),
            collapsed: Container(
              decoration:
                  BoxDecoration(color: Colors.grey, borderRadius: radius),
              child: Center(
                child: Text(
                  "Swipe for options",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            body: SingleChildScrollView(
              reverse: true,
              child: Container(
                padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                child: TextHighlight(
                  text: _text,
                  words: _highlights,
                  textStyle: TextStyle(
                    fontSize: (10 * _fontsize),
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            borderRadius: radius,
          ),
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     // appBar: AppBar(
  //     //   title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
  //     // ),
  //     floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
  //     floatingActionButton: AvatarGlow(
  //       animate: _isListening,
  //       glowColor: Theme.of(context).primaryColor,
  //       endRadius: 75.0,
  //       duration: const Duration(milliseconds: 2000),
  //       repeatPauseDuration: const Duration(milliseconds: 100),
  //       repeat: true,
  //       child: FloatingActionButton(
  //         onPressed: _listen,
  //         child: Icon(_isListening ? Icons.mic : Icons.mic_none),
  //       ),
  //     ),
  //     body: Column(
  //       //reverse: true,
  //       children: [
  //         Expanded(
  //           child: Container(
  //             padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
  //             child: TextHighlight(
  //               text: _text,
  //               words: _highlights,
  //               textStyle: TextStyle(
  //                 fontSize: (10 * _fontsize),
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.w400,
  //               ),
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: new Slider(
  //             value: _fontsize,
  //             activeColor: Colors.blue,
  //             inactiveColor: Colors.grey,
  //             onChanged: (double s) {
  //               setState(() {
  //                 _fontsize = s;
  //               });
  //             },
  //             divisions: 10,
  //             min: 0.0,
  //             max: 10.0,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

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
