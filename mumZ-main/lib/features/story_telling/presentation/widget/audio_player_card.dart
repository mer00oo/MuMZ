import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerCard extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerCard({super.key, required this.audioUrl});

  @override
  State<AudioPlayerCard> createState() => _AudioPlayerCardState();
}

class _AudioPlayerCardState extends State<AudioPlayerCard> {
  final AudioPlayer _player = AudioPlayer();
  bool isReady = false;

  @override
  void initState() {
    super.initState();
      print("AUDIO URL => ${widget.audioUrl}");

    _initPlayer();
  }

  Future<void> _initPlayer() async {
  try {
    print("حاول تحميل الصوت من URL: ${widget.audioUrl}");
    await _player.setUrl(widget.audioUrl);
    setState(() {
      isReady = true;
    });
  } catch (e) {
    debugPrint('Audio load error: $e');
  }
}

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xffFBDECD)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16
          )
        ]
      ),

      
      child: Column(
        children: [
              IconButton(
            iconSize: 55,
            icon: Icon(
              _player.playing ? Icons.pause_circle : Icons.play_circle,
              color: Color(0xffFFC7AE),
            ),
           onPressed: !isReady
    ? null
    : () async {
        if (_player.playing) {
          await _player.pause();
        } else {
          // 👇 الحل هنا
          if (_player.processingState == ProcessingState.completed) {
            await _player.seek(Duration.zero);
          }
          await _player.play();
        }
        setState(() {});
      },

          ),
        ],
      ),
    );
  }
}
