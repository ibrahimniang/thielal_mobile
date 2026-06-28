import 'package:flutter/material.dart';
import 'package:record/record.dart';

class VoiceRecorderButton extends StatefulWidget {
  final Function(String path) onSendAudio;

  const VoiceRecorderButton({
    super.key,
    required this.onSendAudio,
  });

  @override
  State<VoiceRecorderButton> createState() =>
      _VoiceRecorderButtonState();
}

class _VoiceRecorderButtonState
    extends State<VoiceRecorderButton> {

  final AudioRecorder _record = AudioRecorder();
  bool isRecording = false;

  Future<void> toggleRecord() async {

    if (isRecording) {
      final path = await _record.stop();
      setState(() => isRecording = false);

      if (path != null) {
        widget.onSendAudio(path);
      }

    } else {
      if (await _record.hasPermission()) {
        await _record.start(
          const RecordConfig(),
          path: "audio_${DateTime.now().millisecondsSinceEpoch}.m4a",
        );

        setState(() => isRecording = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: toggleRecord,
      icon: Icon(
        isRecording ? Icons.stop : Icons.mic,
        color: isRecording ? Colors.red : Colors.grey,
      ),
    );
  }
}