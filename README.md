# 🎯 Taboo - The Ultimate Word Guessing Party Game
</br>
<div align="center">
  <img src="assets/vectors/title.svg" alt="Taboo Game Logo" width="250"/></br></br>
  
**A thrilling offline party game where players describe words without using forbidden "taboo" words. Test your vocabulary, quick thinking, and teamwork skills!**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![GetX](https://img.shields.io/badge/GetX-9C27B0?style=for-the-badge&logo=flutter&logoColor=white)](https://pub.dev/packages/get)

</div>

## 🌟 Overview

**Taboo** is a fast-paced, offline word-guessing party game built with Flutter for **Android devices**. Players must describe a target word to their teammates without using any of the forbidden "taboo" words listed on the card. It's the perfect game for parties, family gatherings, and friend meetups, offering endless entertainment and hilarious moments.

## ✨ Features

-   🧩 **Pre-Set Panic Mode**: Jump into action with 1000+ pre-loaded word cards across diverse categories
-   🔥 **Custom Craze Mode**: Create personalized card sets using simple JSON format for unlimited creativity
-   ⏱️ **Customizable Timer**: Set round durations from 30 seconds to 5 minutes with visual countdown
-   🏆 **Multi-Team Scoring**: Track scores for multiple teams with detailed round summaries
-   ⏭️ **Strategic Skipping**: Skip challenging words when needed without penalties
-   📱 **Fully Offline**: Play anywhere without internet - no data collection or external connections
-   🎴 **Modern UI**: Beautiful gradient themes with custom SVG icons and Lottie animations
-   📳 **Haptic Feedback**: Vibration responses for all game interactions and events
-   🎯 **Smart Card System**: Never repeat cards in a session with intelligent progress tracking
-   ⚡ **Optimized Performance**: Smooth 60fps animations with efficient battery usage

## 🚀 Getting Started

### 📋 Prerequisites

-   **Flutter SDK**: Version 3.6.1 or higher
-   **Dart SDK**: Compatible with Flutter version
-   **Android Studio/VS Code**: For development
-   **Git**: For version control

### 🛠️ Installation

1. **Clone the Repository**

    ```bash
    git clone https://github.com/mohitooo28/Taboo.git
    cd Taboo
    ```

2. **Install Dependencies**

    ```bash
    flutter pub get
    ```

3. **Run the Application**
    ```bash
    flutter run
    ```

## 📁 Project Structure

```
📦 lib/
├── 🎮 controllers/                        # Game Logic
│   └── 🎯 game_controller.dart            # Main game state management
│
├── 📊 data/                               # Game Data
│   └── 📝 default_words.json              # Pre-loaded word cards (1000+)
│
├── 🏗️ models/                             # Data Models
│   └── 🎴 taboo_card.dart                 # Card data structure
│
├── 🖥️ screens/                            # App Screens
│   ├── 🏠 home_screen.dart                # Main menu
│   ├── 🔧 custom_craze_home.dart          # Custom mode setup
│   ├── 🎲 preset_panic_home.dart          # Pre-set mode setup
│   ├── 📋 rules.dart                      # Game rules explanation
│   ├── 🚧 in_development.dart             # Coming soon features
│   └── 🎮 game/                           # Gameplay Screens
│       ├── 🎯 gameplay_screen.dart        # Main game interface
│       ├── ⏰ get_ready_screen.dart       # Pre-game countdown
│       ├── 🏁 start_game_screen.dart      # Team setup
│       ├── 📊 round_summary_screen.dart   # Round results
│       └── 🏆 game_over_screen.dart       # Final scores
│
├── 🔧 services/                           # Business Logic
│   ├── 🎴 taboo_service.dart              # Card management
│   └── 🎨 custom_taboo_service.dart       # Custom card handling
│
├── 🧩 widgets/                            # Reusable Components
│   ├── ℹ️ about_dialog.dart               # App information
│   ├── ⚙️ compact_game_settings.dart      # Quick settings
│   ├── 📖 custom_instructions_dialog.dart # JSON format guide
│   ├── 🎛️ game_settings.dart              # Full settings panel
│   ├── 🎴 game_type_cards.dart            # Mode selection cards
│   ├── 📜 rules_card.dart                 # Rules summary card
│   └── 👥 team_container.dart             # Team management UI
│
└── 📱 main.dart                           # Application entry point
```

## 🎮 How to Play

### 🎯 **Basic Rules**

1. **Divide into Teams**: Split players into two or more teams
2. **Choose a Clue Giver**: One team member describes the word
3. **Start the Timer**: Begin the countdown (30s - 5min)
4. **Give Clues**: Describe the target word WITHOUT using:
   - The word itself
   - Any of the 5 forbidden "taboo" words
   - Rhyming words or spelling
5. **Teammates Guess**: Team members shout out their guesses
6. **Score Points**: Each correct guess = 1 point
7. **Switch Teams**: Rotate between teams each round

### 🚫 **Taboo Violations**

- **Buzzer Time**: Opponents watch for taboo word usage
- **Penalties**: Using forbidden words ends your turn
- **No Points**: No points awarded for violated cards
- **Keep Playing**: Game continues with the next team

### 🏆 **Winning**

- **Set Target**: Play to a predetermined score (e.g., 15 points)
- **Time Limit**: Or play for a set number of rounds
- **Victory**: First team to reach the target wins!

## 🔧 Custom Cards Setup

### 📝 **JSON Format**

Create your own cards using this simple JSON structure:

```json
[
  {
    "word": "Pizza",
    "forbidden": [
      "Cheese",
      "Italian",
      "Slice",
      "Pepperoni",
      "Dough"
    ]
  },
  {
    "word": "Smartphone",
    "forbidden": [
      "Phone",
      "Mobile",
      "Apps",
      "Touch",
      "Screen"
    ]
  }
]
```

### 📋 **Guidelines for Custom Cards**

- **Target Word**: The word to be guessed
- **5 Forbidden Words**: Related terms that can't be used as clues
- **Balanced Difficulty**: Mix easy and challenging words
- **Clear Restrictions**: Choose obvious related words as taboo
- **Theme Consistency**: Group cards by categories for themed games

### 🤖 **Generate Cards with AI (LLM)**

Easily generate custom cards using an AI language model like ChatGPT by providing your own list of words.
💡 Copyable Prompt:
```
Create Taboo-style cards in JSON format for the following words: <Your Words ex: Sun, Moon> 
For each word, return a JSON object with:
- "word": the main word
- "forbidden": a list of 5 related words that should not be used as clues

Output only valid JSON in an array format.
```

Replace `<Your Words ex: Sun, Moon>` with your own list to instantly generate personalized cards you can plug right into the game.

## 🎨 Design Inspiration

This project takes design inspiration from the official [Taboo app on Google Play Store](https://play.google.com/store/apps/details?id=com.marmalade.taboo&pcampaignid=web_share). We appreciate its intuitive UI and engaging experience, and have reimagined it with our own features and custom touches.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Say everything—except what you’re supposed to!**

[🌟 Star this repo](../../stargazers) • [🐛 Report Bug](../../issues) • [💡 Request Feature](../../issues)

</div>
