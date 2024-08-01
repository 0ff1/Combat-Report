# Winsvue Task - Combat Report

## Dependencies
- [Onesync](https://docs.fivem.net/docs/server-manual/server-commands/#onesync-onofflegacy)
- [ox_lib](https://github.com/overextended/ox_lib)

## Documentation
### Events (Server Side)
#### ws-combatreport:server:matchmakingStarted
Must be called when a match is created for the combat report to start monitoring!
```lua
TriggerEvent("ws-combatreport:server:matchmakingStarted", "matchmaking-01", data)
```
- matchmakingId: string;
- data: table (Structure described below)

#### ws-combatreport:server:matchmakingEnd
Must be called when a match is finished for the combat report to stop monitoring.
```lua
TriggerEvent("ws-combatreport:server:matchmakingEnd", "matchmaking-01")
```
- matchmakingId: string;

#### ws-combatreport:server:roundStarted
Must be called when a new round starts!
```lua
TriggerEvent("ws-combatreport:server:roundStarted", "matchmaking-01")
```
- matchmakingId: string;

### Exports (Server Side)
#### getMatchmakingData
Used to get data from an ongoing match.
```lua
exports["ws-combatreport"]:getMatchmakingData(matchmakingId)
```
- matchmakingId: string
- Return: table

## Table structure
- The standard structure of a matchmaking would be this:
- Note: The number of **players** and **rounds** is up to you!
```lua
["matchmaking-01"] = {
    players = {
        data = {
            attackers = {
                [1] = {
                    src = 1,
                    nick = "0ff",
                },
            },
            defenders = {
                [2] = {
                    src = 2,
                    nick = "Han",
                },
            },
        },
    },
    rounds = {
        current = 1,
        data = {
            [1] = {},
        },
    },
}
```

## Functions
- Documented inside the code.