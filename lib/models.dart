import 'dart:math';

// ─────────────────────────────────────────
// CARD MODEL
// ─────────────────────────────────────────
class NanaCard {
  final int value;
  bool faceUp;

  NanaCard({required this.value, this.faceUp = false});
}

// ─────────────────────────────────────────
// PLAYER MODEL
// ─────────────────────────────────────────
class NanaPlayer {
  final String name;
  final bool isHuman;
  List<NanaCard> hand;
  List<List<NanaCard>> sets;

  NanaPlayer({
    required this.name,
    required this.isHuman,
  })  : hand = [],
        sets = [];

  int get setCount => sets.length;
  int get handCount => hand.length;

  NanaCard? get highestCard => hand.isEmpty ? null : hand.last;
  NanaCard? get lowestCard  => hand.isEmpty ? null : hand.first;
}

// ─────────────────────────────────────────
// DECK
// ─────────────────────────────────────────
class NanaDeck {
  final List<NanaCard> cards = [];
  final Random _random = Random();

  NanaDeck() {
    _build();
  }

  void _build() {
    cards.clear();
    // 1-12 with 3 copies each = 36 cards
    for (int v = 1; v <= 12; v++) {
      for (int c = 0; c < 3; c++) {
        cards.add(NanaCard(value: v));
      }
    }
    cards.shuffle(_random);
  }

  NanaCard draw() => cards.removeLast();
  bool get isEmpty => cards.isEmpty;
  int get remaining => cards.length;
}

// ─────────────────────────────────────────
// AI MEMORY BANK
// ─────────────────────────────────────────
class CardSighting {
  final NanaCard card;
  final int? ownerIndex; // null = middle pile
  bool collected = false;

  CardSighting({required this.card, this.ownerIndex});
}

class AiMemory {
  final List<CardSighting> _sightings = [];

  void observe(NanaCard card, int? ownerIndex) {
    if (_sightings.any((s) => s.card == card)) return;
    _sightings.add(CardSighting(card: card, ownerIndex: ownerIndex));
  }

  void markCollected(List<NanaCard> cards) {
    for (final s in _sightings) {
      if (cards.contains(s.card)) s.collected = true;
    }
  }

  void clear() => _sightings.clear();

  // Returns sightings of a value that are still face-down and not yet collected
  List<CardSighting> knownLocationsOf(int value) {
    return _sightings
        .where((s) => s.card.value == value && !s.collected && !s.card.faceUp)
        .toList();
  }
}

// ─────────────────────────────────────────
// GAME LOGIC HELPER
// ─────────────────────────────────────────
class NanaGameLogic {
  // Check and remove any sets of 3 from a player's hand
  // Returns true if a set was found
  static bool checkAndRemoveSets(NanaPlayer player) {
    Map<int, List<NanaCard>> groups = {};
    for (var card in player.hand) {
      groups.putIfAbsent(card.value, () => []).add(card);
    }
    bool found = false;
    for (var entry in groups.entries) {
      if (entry.value.length >= 3) {
        final set = entry.value.take(3).toList();
        for (var c in set) {
          player.hand.remove(c);
        }
        player.sets.add(set);
        found = true;
      }
    }
    return found;
  }

  // Check if a player has won (3 sets)
  static bool hasWon(NanaPlayer player) => player.sets.length >= 3;
}