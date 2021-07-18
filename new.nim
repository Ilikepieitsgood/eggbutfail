import dimscord, asyncdispatch, times, options, os, parseutils, strutils

let discord = newDiscordClient(getEnv("NEW_BOT_TOKEN"))
var new = 0

if fileExists("new.txt"):
  discard readFile("new.txt").parseInt(new)

proc onReady(s: Shard, r: Ready) {.event(discord).} =
  echo "Ready as " & $r.user
  await s.updateStatus(activity = ActivityStatus(
    name: $new & " 👀",
    kind: atPlaying
  ).some, status = "online")

proc messageCreate(s: Shard, m: Message) {.event(discord).} =
  if not m.author.bot and m.content.toLowerAscii.contains("egg"):
    eggs.inc

    try:
      await discord.api.addMessageReaction(m.channelId, m.id, "🥚")
      await s.updateStatus(activity = ActivityStatus(
        name: $new & " 👀",
        kind: atPlaying
      ).some, status = "online")
      writeFile("new.txt", $new)
    except:
      discard #I don't care

waitFor discord.startSession()
