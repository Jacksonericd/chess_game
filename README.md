# Chess App

A self-contained single-player chess app built with Flutter. You play White and the system plays Black. The project is intentionally separate from the existing `egharz_app` project.

## Package

Android application ID and namespace: `com.jed.chess`

## Run

```bash
cd chess_app
flutter pub get
flutter run
```

## Architecture

The app follows a feature-first clean architecture:

```text
lib/
├── core/theme/                     # Shared presentation tokens
├── l10n/                           # ARB translation resources
├── features/chess/
│   ├── data/repositories/          # In-memory implementation
│   ├── domain/entities/            # ChessPiece and ChessMove
│   ├── domain/repositories/        # Repository contract
│   └── presentation/
│       ├── controllers/            # UI-facing state orchestration
│       └── screens/                 # Flutter screens and widgets
└── main.dart
```

The domain depends on abstractions, while the presentation depends on the controller and domain contracts. `InMemoryChessRepository` is the replaceable data implementation, keeping storage and UI concerns separate.

## Features

- Single-player chess board with a system opponent
- Five selectable computer difficulty levels
- Legal movement for all piece types
- Captures and automatic pawn promotion to queen
- Check, checkmate, and stalemate detection
- Castling and en passant
- Undo, reset, and board orientation controls
- Responsive mobile layout
- English strings sourced from `lib/l10n/app_en.arb`

## Verification

```bash
flutter analyze
flutter test
```

## Privacy

The privacy policy is available in [chess_app_privacy_policy.md](chess_app_privacy_policy.md) and as a hostable web page at [`web/chess_app_privacy_policy.html`](web/chess_app_privacy_policy.html). Replace the support-email placeholder before publishing.

The system opponent has five levels: beginner, easy, medium, hard, and expert. Higher levels use deeper board evaluation. Full move legality includes king safety, castling rights, and en passant state.
