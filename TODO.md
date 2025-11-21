# TODO List

## discord.go

### Thread Handlers
- [ ] **Line 315**: Implement thread creation handler in `discordNewThreadHandler()`
  - Description: Handle new thread creation events from Discord
  - Suggested: Log thread info, potentially store in database for tracking
  
- [ ] **Line 322**: Implement thread deletion handler in `discordDelThreadHandler()`
  - Description: Handle thread deletion events from Discord
  - Suggested: Clean up thread data, log deletion for audit purposes

### Webhook Logging
- [ ] **Line 336**: Implement webhook logging to configured audit channel in `kickDiscordUser()`
  - Description: Send audit log embed to webhook when users are kicked
  - Dependencies: Config system for webhook URL, embed formatting
  - Related: Lines 359, 379
  
- [ ] **Line 359**: Implement webhook logging to configured audit channel in `banDiscordUser()`
  - Description: Send audit log embed to webhook when users are banned
  - Dependencies: Config system for webhook URL, embed formatting
  - Related: Lines 336, 379
  
- [ ] **Line 379**: Implement webhook logging to configured audit channel in `deleteDiscordMessages()`
  - Description: Send audit log embed to webhook when messages are deleted
  - Dependencies: Config system for webhook URL, embed formatting
  - Related: Lines 336, 359

## Priority Ranking

### Priority 1 (High)
- Thread handlers (improves robustness)

### Priority 2 (Medium)
- Webhook logging for audit trail (improves security/compliance)

## Implementation Notes

All webhook logging TODOs depend on:
1. Config structure supporting webhook URLs per guild
2. Embed helper function for consistent formatting
3. Error handling for failed webhook deliveries
