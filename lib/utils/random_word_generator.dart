import 'dart:math';

class RandomWordGenerator {
  static final List<String> _sampleTags = [
    'Aggressive',
    'Ambient',
    'Analog',
    'Bass',
    'Beats',
    'Chill',
    'Dark',
    'Deep',
    'Digital',
    'Dreamy',
    'Electronic',
    'Energetic',
    'Epic',
    'Groove',
    'Heavy',
    'Instrumental',
    'Jazzy',
    'Melodic',
    'Minimal',
    'Modern',
    'Organic',
    'Piano',
    'Rhythmic',
    'Smooth',
    'Soft',
    'Spacey',
    'Synth',
    'Upbeat',
    'Vintage',
    'Vocal'
  ];

  static String getRandomWord() {
    return _sampleTags[Random().nextInt(_sampleTags.length)];
  }
}
