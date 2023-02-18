// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:hanzi_trainer/configs/constants.dart';

import '../models/word.dart';

class TTSButton extends StatefulWidget {
  const TTSButton({
    super.key,
    required this.word,
    this.iconSize = 50,
  });

  final Word word;
  final double iconSize;

  @override
  State<TTSButton> createState() => _TTSButtonState();
}

class _TTSButtonState extends State<TTSButton> {
  bool _isTapped = false;
  FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
      _setUpTTS();
    });

    super.initState();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        onPressed: () {
          _runTTS(text: widget.word.character);
          setState(() {
            _isTapped = true;
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                _isTapped = false;
              });
            });
          });
        },
        icon: Icon(
          Icons.audiotrack,
          size: widget.iconSize,
          color: _isTapped ? kYellow : Colors.white,
        ),
      ),
    );
  }

  _setUpTTS() async {
    await _tts.setLanguage('zh-Cn');
    await _tts.setSpeechRate(0.4);
  }

  _runTTS({required String text}) async {
    await _tts.speak(text);
  }
}
