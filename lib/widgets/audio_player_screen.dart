import 'dart:io' show Platform;

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter/material.dart';
import 'package:holy_bible/widgets/music_icon_animation.dart';
import 'package:just_audio/just_audio.dart' as ja;

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
  ja.AudioPlayer? _justAudioPlayer;
  ap.AudioPlayer? _audioPlayersLinux;
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
    setState(() {
      _isLoading = true;
      _error = null;
    });

    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      _audioPlayersLinux = ap.AudioPlayer();
      try {
        await _audioPlayersLinux!
            .play(ap.UrlSource(widget.content['resourceUrl']));
        _audioPlayersLinux!.onDurationChanged.listen((d) {
          setState(() {
            _duration = d;
          });
        });
        _audioPlayersLinux!.onPositionChanged.listen((p) {
          setState(() {
            _position = p;
          });
        });
        setState(() {
          isPlay = true;
        });
      } catch (e) {
        _error = "Linux audio failed: $e";
      }
    } else {
      _justAudioPlayer = ja.AudioPlayer();
      try {
        await _justAudioPlayer!.setUrl(widget.content['resourceUrl']);

        _justAudioPlayer!.durationStream.listen((d) {
          if (d != null) {
            setState(() {
              _duration = d;
            });
          }
        });

        _justAudioPlayer!.positionStream.listen((p) {
          setState(() {
            _position = p;
          });
        });
      } catch (e) {
        _error = "Mobile audio failed: $e";
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isLinux) {
      _audioPlayersLinux?.dispose();
    } else {
      _justAudioPlayer?.dispose();
    }
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final twoDigits = (int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return "${twoDigits(minutes)}:${twoDigits(seconds)}";
  }

  void _playPause() {
    setState(() {
      isPlay = !isPlay;
    });

    if (Platform.isLinux) {
      if (isPlay) {
        _audioPlayersLinux?.resume();
      } else {
        _audioPlayersLinux?.pause();
      }
    } else {
      if (isPlay) {
        _justAudioPlayer?.play();
      } else {
        _justAudioPlayer?.pause();
      }
    }
  }

  void _seek(Duration newPos) {
    if (Platform.isLinux) {
      _audioPlayersLinux?.seek(newPos);
    } else {
      _justAudioPlayer?.seek(newPos);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
          child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Controls Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                iconSize: 40,
                onPressed: widget.content['previous'] == null
                    ? null
                    : () async {
                        await widget
                            .onNavigate(widget.content['previous']['id']);
                        await _initAudio();
                      },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MusicIconAnimation(isPlaying: isPlay),
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
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
            onChanged: (value) => _seek(Duration(seconds: value.toInt())),
            activeColor: Colors.purple,
            inactiveColor: Colors.purple[100],
          ),

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

          // Play/Pause Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                iconSize: 32,
                onPressed: () => _seek(_position - const Duration(seconds: 10)),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _playPause,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Icon(
                  isPlay ? Icons.pause : Icons.play_arrow,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.forward_10),
                iconSize: 32,
                onPressed: () => _seek(_position + const Duration(seconds: 10)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
