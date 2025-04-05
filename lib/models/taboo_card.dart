class TabooCard {
  final String word;
  final List<String> forbiddenWords;

  TabooCard({
    required this.word,
    required this.forbiddenWords,
  });

  factory TabooCard.fromJson(Map<String, dynamic> json) {
    return TabooCard(
      word: json['word'] as String,
      forbiddenWords: List<String>.from(json['forbidden']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'forbidden': forbiddenWords,
    };
  }
}
