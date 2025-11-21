# Changelog

Alle wichtigen Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

## [Unreleased]

### Added
- Go 1.22 LTS upgrade mit modernen Standards
- Erweiterte Fehlerbehandlung in Discord-API-Calls
- Detailliertes Audit-Logging für Moderationsaktionen (Kick, Ban, Delete)
- Standardisierte Code-Formatierung mittels `gofmt`
- Docker Containerisierung mit Multi-Stage Build

### Changed
- Ersetzt `ioutil` durch `os.ReadFile()` (deprecated APIs)
- Verbesserte Error-Logging Statements (statt `Log.Error()` oder `Log.Fatal()`)
- Optimierte Placeholder-Ersetzung in `sendDiscordMessage()` mittels `strings.NewReplacer`
- Refaktoriert Logging in `kickDiscordUser()`, `banDiscordUser()`, `deleteDiscordMessages()` mit strukturierten Logs

### Fixed
- **discord.go Zeile 283**: Operator-Precedence und Indentation Bug in `discordMessageHandler()` mittels `gofmt`
- **discord.go Zeile 305**: Entfernte commented-out code (`//bot, err := dg.User("@me")`)
- **discord.go**: Konsistente Fehlerbehandlung - statt abrupt abzubrechen, wird jetzt geloggt
- **discord.go**: Fehlerhafte Emoji-Reaktionen überspringen statt den gesamten Handler zu unterbrechen

### Removed
- Dead code und veraltete Kommentare

### Security
- HTTP Client Timeouts in Parsing (parsing.go)
- API Request Size Limits
- Strukturierte Error Messages statt verbose output

## Git History

- **76a3ce0**: Implement TODO fixes in discord.go: improve logging, fix indentation, enhance error handling
- **6fe1917**: Update DISCORD_REVIEW.md: Clarify arikawa v3 feature availability  
- **0a656a8**: Enhance discord.go: Fix issues and add modern features documentation
- **7abc83c**: Update to latest Go 1.22 LTS with security improvements
