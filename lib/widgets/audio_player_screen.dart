import 'package:flutter/material.dart';
import 'package:holy_bible/widgets/music_icon_animation.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerScreen extends StatefulWidget {
  final Map<String, dynamic> content;
  final Function(String chapterId) onNavigate;

  const AudioPlayerScreen({
    super.key,
    required this.content,
    required this.onNavigate,
  });

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool _isLoading = true;
  bool isPlay = false;
  String? _error;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    _audioPlayer = AudioPlayer();
    try {
      await _audioPlayer.setUrl(widget.content['resourceUrl']);

      _audioPlayer.durationStream.listen((d) {
        if (d != null) {
          setState(() {
            _duration = d;
          });
        }
      });

      _audioPlayer.positionStream.listen((p) {
        setState(() {
          _position = p;
        });
      });
    } catch (e) {
      _error = "Failed to load audio: $e";
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final twoDigits = (int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return hours > 0
        ? "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}"
        : "${twoDigits(minutes)}:${twoDigits(seconds)}";
  }

  @override
  void didUpdateWidget(covariant AudioPlayerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content['resourceUrl'] != widget.content['resourceUrl']) {
      _initAudio(); // Re-initialize audio when content changes
      print(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous Button
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.black),
                iconSize: 40,
                onPressed: widget.content['previous'] == null
                    ? null
                    : () async {
                        await widget
                            .onNavigate(widget.content['previous']['id']);
                        await _initAudio();
                      },
              ),

              // Music Icon
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: MusicIconAnimation(isPlaying: isPlay),
              ),

              // Next Button
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.black),
                iconSize: 40,
                onPressed: widget.content['next'] == null
                    ? null
                    : () async {
                        await widget.onNavigate(widget.content['next']['id']);
                        await _initAudio();
                      },
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Slider
          Slider(
            value: _position.inSeconds.toDouble(),
            min: 0,
            max: _duration.inSeconds.toDouble(),
            onChanged: (value) {
              final position = Duration(seconds: value.toInt());
              _audioPlayer.seek(position);
            },
            activeColor: Colors.purple,
            inactiveColor: Colors.purple[100],
          ),

          // Time Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(_position),
                  style: const TextStyle(color: Colors.black54)),
              Text(_formatDuration(_duration),
                  style: const TextStyle(color: Colors.black54)),
            ],
          ),

          const SizedBox(height: 30),

          // Playback Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10, size: 32),
                onPressed: () {
                  final newPosition = _position - const Duration(seconds: 10);
                  _audioPlayer.seek(newPosition >= Duration.zero
                      ? newPosition
                      : Duration.zero);
                },
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  if (isPlay) {
                    _audioPlayer.pause();
                  } else {
                    _audioPlayer.play();
                  }
                  setState(() {
                    isPlay = !isPlay;
                  });
                },
                child: Icon(isPlay ? Icons.pause : Icons.play_arrow,
                    size: 32, color: Colors.white),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.forward_10, size: 32),
                onPressed: () {
                  final newPosition = _position + const Duration(seconds: 10);
                  _audioPlayer
                      .seek(newPosition < _duration ? newPosition : _duration);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
