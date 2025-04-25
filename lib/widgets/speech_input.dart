import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> _requestMicPermission() async {
  var status = await Permission.microphone.status;

  if (!status.isGranted) {
    status = await Permission.microphone.request();
    if (status.isGranted) {
      debugPrint('✅ Mic permission granted');
    } else {
      debugPrint('❌ Mic permission denied');
    }
  } else {
    debugPrint('🎤 Mic permission already granted');
  }
}


class SpeechInput extends StatefulWidget {
  final Function(String) onResult;

  const SpeechInput({Key? key, required this.onResult}) : super(key: key);

  @override
  State<SpeechInput> createState() => SpeechInputState();
}

class SpeechInputState extends State<SpeechInput> {
  SpeechToText speech = SpeechToText();
  bool isListening = false;
  String message = 'Tap the mic to start speaking';

  @override
  void initState() {
    super.initState();
      _requestMicPermission();
    speech = SpeechToText();
  }

  void listen() async {
    if (!isListening) {
      bool available = await speech.initialize(
        onStatus: (status) {
          print('Status: $status');
          if (status == 'notListening') {
            if (mounted) setState(() => isListening = false);
          }
        },
        onError: (error) => print('Error: $error'),
      );

      if (available) {
        if (mounted) setState(() => isListening = true);
        speech.listen(
          onResult: (result) {
            final spokenText = result.recognizedWords;
            widget.onResult(spokenText);
            if (mounted) {
              setState(() {
                message = spokenText;
              });
            }
          },
        );
      }
    }
  }

  void stopListening() {
    if (isListening) {
      speech.stop();
      if (mounted) setState(() => isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        FloatingActionButton(
          onPressed: listen,
          mini: true,
          child: Icon(isListening ? Icons.mic : Icons.mic_none),
        ),
      ],
    );
  }
}
