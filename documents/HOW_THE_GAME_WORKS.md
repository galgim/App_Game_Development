# Triple Seven — How the Game Works

## Overview

Triple Seven is a 3-player card game where you compete against two AI opponents to
collect three matching sets of cards before they do. The special prize is collecting
three 7s — the "Triple Seven" — which wins the game instantly.

---

## The Deck

- 36 cards total: values 1 through 12, with **3 copies of each value**
- All cards start face-down

---

## Setup

Each of the 3 players is dealt **9 cards** face-down (sorted by value in hand).
The remaining **9 cards** go face-down into the **middle pile**.

---

## Goal

Be the first player to collect **3 sets**. A set is 3 cards of the same value.
Collecting three 7s wins immediately, regardless of other sets.

---

## Turn Structure

On your turn you reveal **up to 2 cards** from any combination of:

| Source        | How                                          |
|---------------|----------------------------------------------|
| Middle pile   | Tap any face-down card in the grid           |
| Opponent hand | Tap Hi (highest) or Lo (lowest) on an opponent |
| Your own hand | Tap one of your own face-down cards          |

### If the 2 cards DON'T match
Both cards flip back face-down and the turn passes to the next player.

### If the 2 cards DO match (Bonus Turn!)
You earn a **third reveal** to find the matching third card anywhere on the table.
- If you find it → all 3 cards are collected as a set and removed from play
- If you don't → all 3 cards flip back face-down and your turn ends

---

## Winning

- Collect 3 sets of any values → you win
- Collect three 7s (Triple Seven) → instant win, even with fewer sets

---

## AI Opponents

The two AI players take turns automatically after yours. They use a **memory bank**
system — every card they witness being revealed (on any player's turn) is stored in
memory. On their own turns, they consult that memory to make smarter picks.

### AI Memory Bank

The AI observes every card flip during the entire game. It records:
- The card's value
- Who had it (or whether it was in the middle pile)
- Whether it has since been collected into a set (and is therefore gone)

**How the AI uses its memory:**

1. **Pick 1 (first card of the turn):**
   The AI checks its own hand for values it already holds 2 of. If it has a pair and
   the memory bank shows where a third copy is, it goes straight there.

2. **Pick 2 (second card of the turn):**
   The AI now knows the value of its first card. It searches memory for a known
   location of that same value before making a random guess.

3. **Bonus pick (after a match, hunting for the 3rd):**
   The AI searches memory first for any known location of the target value, then
   falls back to checking the extremes of opponent hands and the middle pile.

**What the AI cannot do:**
- It only knows cards it has actually seen revealed — it cannot see through face-down
  cards it has never witnessed
- It cannot predict what unobserved cards are (it guesses randomly for those)
- Memory resets at the start of each new game

---

## Tips

- Track which values have already formed sets — those cards are permanently gone
- High-value reveals (opponent's "Hi" card) can expose dangerous pairs they hold
- The AI remembers everything it sees, so revealing a card and not collecting it
  teaches the AI exactly where to look next turn
