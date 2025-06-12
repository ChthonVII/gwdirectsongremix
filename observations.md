# Observations

## General

Here is how control flow seems to work, based on the (sparse) documentation and my experiments on Shing Jea Island. It's possible behavior is different for other chapters.
1. When Gw.exe is about to play a song, it sends 3 tokens to ds_GuildWars.dll.
     - Tokens are probably usually `L***` for the specific zone, `out****` or `***ada*` for outpost or adventuring, and some kind of ambient fallback.
     - The documentation isn't super clear. It's possible it meant "three tokens plus the `L***` token," so maybe there's another token with intermediate generality between outpost/adventuring and ambient. (Prophecies has some token names that suggest this. But they might also just be deprecated cruft. To be revisited.) 
     - The token sent does not always correlate with the song Gw.exe is about to play. For instance, in most cases `outrura` means "I'm about to play the song 'Shing Jae Monastery'," but in a couple cases, it does not.
2. ds_GuildWars.dll scans each line of GuildWars.ds for a match for any token.
     - The first matching line is picked. So the order of lines in GuildWars.ds matters.
     - If no matching line is found, ds_GuildWars.dll defers back to Gw.exe and Gw.exe plays the song it was preparing to play.
3. Assuming there was a match, ds_GuildWars.dll plays the next entry from the playlist for that token. The first time a token's playlist is selected, the first entry plays; the second time, the second entry; the third time, the third entry; and so on, looping back to the first entry after the last one.
     - There is some persistent memory about the position of each playlist. For instance, if you log in to Tsumei Village, wait for `outrura` to play twice, then map to Ran Musu Gardens and wait for `outrura` again, it will play the third item in the list. Likewise, if you log in to Tsumei Village, wait for `outrura` to play twice, walk out into Panjiang Peninsula, listen to a few songs, then walk back into Tsumei Village and wait for `outrura` again, it will play the third entry in the list. It's not presently known whether the position of every playlist is always stored, or only the positions for a few recently used playlists.
4. If the entry selected is `*`, then ds_GuildWars.dll defers back to Gw.exe and Gw.exe plays the song it was preparing to play. Same result as no matching token or DirectSong not installed at all.
5. If the entry selected points to a file, ds_GuildWars.dll tells Gw.exe it has a match, Gw.exe defers, and ds_GuildWars.dll tries to decode the file.
6. If the file won't play (corrupted file, DRM, can't decode wma, etc.), then it skips to the next entry in the playlist. (What happens if none of the files can be played?)
7. Volume is indicated after each file in square brackets. The units are negative millibels full scale. So "[0]" means 100% full scale volume. And "[1000]" means 10% full scale volume. **Bigger numbers are softer.** (Note, however, that human hearing is more or less logarithmic, so millibels feel linear.)
     - Sometimes a person working on GuildWars.ds messed this up. Sometimes a loud, bombastic file was given a large number to make it soft enough to pass as background music. But sometimes a soft file was given a large number in a mistaken attempt to make it louder. Oops! Hence the need for volume testing every file. (GW's mixing is weird, so we can't just predict how loud something's going to sound by calculating LUFS or whatever. (I tried. It didn't work.))


## Login Screen
Following token stream, always:
- `loginen`
- `ambient` (prophecies ambient) 2x or 3x (seems random)
- `loginzb`
- `loginzc`
- `loginzd`
- `loginze`
- (loop back to `loginen`)

## Shing Jea Island
- Shing Jea Monestary/Seitung Harbor
     - Token stream is always `outrura` over and over.
     - No-DirectSong/`*` behavior alternates "Assassin's Theme" and "Ritualist's Theme."
- All other outposts
     - Token stream is random picks from `outrura`, `outrurb` and `outrurc`.
     -  No-DirectSong/`*` behavior is:
          -  `outrura` = "Shing Jea Monastery"
          -  `outrurb` = "Harvest Festival"
          -  `outrurc` = "Age of the Dragon"
- All explorables and missions
     - Token stream is random picks from `ruraada`, `ruraadb` and `ruraadc`.
     -  No-DirectSong/`*` behavior is:
          -  `ruraada` = "Shing Jea Monastery"
          -  `ruraadb` = "Harvest Festival"
          -  `ruraadc` = "Age of the Dragon"
- I believe this is sufficient information to make all corrections for Shing Jea Island.

## Kaineng City 
- Kaineng Center
     - Token stream:
          - The first token upon entering the zone is a random pick from `urbaada`, `urbaadb`, or `urbaada`.
          - All other tokens are random picks from `outurba`, `outurbb`, and `outurbc`.
          - This is weird and needs investigation.
- The Marketplace (and presumably most other outposts)
     - Token stream: Random picks from `outurba`, `outurbb`, and `outurbc`.
- Budek Byway (and presumbly most other explorables/missions)
     - Token stream: Random picks from `urbaada`, `urbaadb`, and `urbaada`.

## Istan
- Kamadan
     - Token stream: Random picks from `outdela`, `outdelb`, and `outdelc`.

