# Observations

## General

Here is how control flow seems to work, based on the (sparse) documentation and my experiments on Shing Jea Island. It's possible behavior is different for other chapters.
1. When Gw.exe is about to play a song, it sends 3 tokens to ds_GuildWars.dll.
     - Tokens are probably usually `L***` for the specific zone, `out****` or `****ad*` for outpost or adventuring, and some kind of ambient fallback.
     - The documentation isn't super clear. It's possible it meant "three tokens plus the `L***` token," so maybe there's another token with intermediate generality between outpost/adventuring and ambient. (Prophecies has some token names that suggest this. But they might also just be deprecated cruft. To be revisited.) 
     - The token sent does not always correlate with the song Gw.exe is about to play. For instance, in most cases `outrura` means "I'm about to play the song 'Shing Jea Monastery'," but in a couple cases, it does not.
2. ds_GuildWars.dll scans each line of GuildWars.ds for a match for any token.
     - The first matching line is picked. So the order of lines in GuildWars.ds matters.
     - If no matching line is found, ds_GuildWars.dll defers back to Gw.exe and Gw.exe plays the song it was preparing to play.
3. Assuming there was a match for the token, ds_GuildWars.dll picks an entry from the list.
    - If the list is blank, ds_GuildWars.dll defers back to Gw.exe and Gw.exe plays the song it was preparing to play.
    - If the list is not blank, ds_GuildWars.dll picks the next entry from the playlist. The first time a token's playlist is selected, the first entry is picked; the second time, the second entry; the third time, the third entry; and so on, looping back to the first entry after the last one.
    - There is some persistent memory about the position of each playlist. For instance, if you log in to Tsumei Village, wait for `outrura` to play twice, then map to Ran Musu Gardens and wait for `outrura` again, it will play the third entry in the list. Likewise, if you log in to Tsumei Village, wait for `outrura` to play twice, walk out into Panjiang Peninsula, listen to a few songs, then walk back into Tsumei Village and wait for `outrura` again, it will play the third entry in the list. It's not presently known whether the position of every playlist is always stored, or only the positions for a few recently used playlists.
4. Once an entry is picked:
     - If the entry picked is `*`, then ds_GuildWars.dll defers back to Gw.exe and Gw.exe plays the song it was preparing to play.
     - If the entry picked points to a file, ds_GuildWars.dll tells Gw.exe it has a match, Gw.exe defers, and ds_GuildWars.dll tries to decode the file.
          - If the file won't play (corrupted file, DRM, can't decode wma, etc.), then it skips to the next entry in the playlist. (TODO: Double check that it's not just failing and GW.exe sends another token rather than the next track.) (TODO: What happens if none of the files can be played?)
     - TODO: What happens with malformed entries?
     - TODO: Are those `pathname/*` entries in Nightfall valid?

Volume is indicated after each file in square brackets. The units are negative millibels full scale. So "[0]" means 100% full scale volume. And "[1000]" means 10% full scale volume. **Bigger numbers are softer.** (Note, however, that human hearing is more or less logarithmic, so millibels feel linear.)

Sometimes a person working on GuildWars.ds messed this up. Sometimes a loud, bombastic file was given a large number to make it soft enough to pass as background music. But sometimes a soft file was given a large number in a mistaken attempt to make it louder. Oops! Hence the need for volume testing every file. (GW's mixing is weird, so we can't just predict how loud something's going to sound by calculating LUFS or whatever. (I tried. It didn't work.))


## Login Screen
Following token stream, always:
- `loginen`
- `ambient` (prophecies ambient) 2x or 3x (seems random)
- `loginzb`
- `loginzc`
- `loginzd`
- `loginze`
- (loop back to `loginen`)

## Post-Searing Ascalon
- All outposts
     - Token stream is random picks from `outscrc`, `outscrd`, `outpose`, and `outposf`, seemingly with a higher weight for the first two.
     - No-DirectSong/`*` behavior is:
          - `outscrc`= "The Charr"
          - `outscrd` = "The Great Northern Wall"
          - `outpose` = "Guilds at War" (Needs more testing that this track is the same across all areas. So far tested Ascalon, Northern Shiverpeaks, and Kryta.)
          - `outposf` = [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6).  (Needs more testing that this track is the same across all areas. So far tested Ascalon and Shiverpeaks.)
- All exporables and missions
    - Token stream is random picks from `scorada` and `scoradb`.
    - Somewhat surprisingly, no generic adventuring tracks mixed in.
    - No-DirectSong/`*` behavior is:
        - `scorada` = "The Charr"
        - `scoradb` = "The Great Northern Wall"

## Shiverpeaks (Northern and Southern)
- Granite Citadel
    - Token stream is `outpost` over and over.
    - No-DirectSong/`*` behavior:
        - First play "Tasca's Demise," then random picks from "Tasca's Demise," "Over the Shiverpeaks," and "Droknar's Forge."
        - Not sure if Granite Citadel and Deldrimor War Camp interact via shared playlist. 
- Deldrimor War Camp
    - Token stream is `outpost` over and over.
    - No-DirectSong/`*` behavior:
        - First play "Tasca's Demise," then random picks from "Tasca's Demise," "Over the Shiverpeaks," and "Droknar's Forge."
        - The small cul-de-sac east of the portal is bugged. Walking into or out of that area will cut off the current track. TODO: Check if this affects DirectSong too.
        - Not sure if Granite Citadel and Deldrimor War Camp interact via shared playlist. 
- All other outposts:
    - Token stream is random picks from `outsnwc`, `outsnwd`, `outpose`, and `outposf`, seemingly with a higher weight for the first two.
    - No-DirectSong/`*` behavior:
        - `outsnwc` = "Droknar's Forge"
        - `outsnwd` = "Tasca's Demise"
        - `outpose` = "Guilds at War"
        - `outposf` = [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6).  (Needs more testing that this track is the same across all areas. So far tested Ascalon and Shiverpeaks.)
- Tasca's Demise:
    - Small area outside Granite Citadel (extends about as far as the close edge of the closest big rock)
        - Token stream is `outpost` over and over
        - No-DirectSong/`*` behavior is the same as Granite Citadel
    - Rest of zone is same as other snow zones.
- Grenth's Footprint
    - Token stream is random picks from `snowsaa`, `snowsab`, and `snowsac`
    - No-DirectSong/`*` behavior:
        - `snowsaa` = "Droknar's Forge"
        - `snowsab` = "Ascension Song"
        - `snowsac` = "Tasca's Demise"
- All other explorables/missions
    - Token stream is random picks from `snowada` and `crysada`
    - No-DirectSong/`*` behavior:
        - `snowada` = "Droknar's Forge"
        - `crysada` = "Ascension Song" (both in Shiverpeaks and Desert)
        - Having `crysada` play in the mountains is correct insofar as the corresponding non-DS track does play there. The problem is that DirectSong makes it into a multi-song playlist tha tnow has to fit both locations.
    - TODO: check Dreadnought's Drift
- Sorrow's Furnace
    - Token stream is `snowdaa`, `snowdab`, `snowdac`
    - No-DirectSong/`*` behavior:
        - `snowdaa` = "Cynn's Theme"
        - `snowdab` = "Devona's Theme"
        - `snowdac` = [Untitled track missing from soundtrack CD](https://www.youtube.com/watch?v=U6R2xuOTCoE&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=3) (does not seem to play anywhere else)
    - TODO: check boss music 

## Kryta
- Lion's Arch
     - Token stream:
          - The first token is always `villaga`, and always cuts off after a few seconds.
          - After that, random picks from `outcosc`, `outcosd`, `outpose`, and `outposf`, seemingly with a higher weight for the first two.
- Lion's Arch Keep
    - Token stream: just `villaga`.
- All other outposts
    - Token stream is random picks from `outcosc`, `outcosd`, `outpose`, and `outposf`, seemingly with a higher weight for the first two.
    - (No special music for ToA.)
- Explorables/Mission
    - Token stream is `coasada` and `geneadc`
    - If `geneadc` isn't used elsewhere, it's essentially Kryta adventure B track
    - Majesty's Rest uses Kryta music.
    - (No special music for Ascalon Settlement.)
    - TODO: Check Kessex Peak
- No-DirectSong/`*` behavior is:
    - `villaga` = "Ashford Abbey"
    - `outcosc` = "Sands of Kryta"
    - `outcosd` = "Temple of Tolerance"
    - `outpose` = "Guilds at War"
    - `outposf` = [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6).
    - `coasada` = "Temple of Tolerance"
    - `geneadc` = "Guilds at War"

## Magumma Jungle
- All outposts
    - Token stream is random picks from `outovrc`, `outovrd`, `outpose`, and `outposf`, seemingly with a higher weight for the first two.
    - Vanilla music might be a mistake? `outovrc`, `outovrd` are duplicates of `outpose`, and `outposf`, while nothing is shared between outposts and adventuring.
- All explorables/missions
    - Token stream is `geneada` and `geneadb`
- No-DirectSong/`*` behavior is:
    - `outovrc` = "Guilds at War"
    - `outovrd` = [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6).
    - `outpose` = "Guilds at War"
    - `outposf` = [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6).
    - `geneada` = "Hall of Heroes"
    - `geneadb` = "The Rift"
    
    
## Crystal Desert
- Explorables quick check: `crysada` and `geneadd`
    - TODO: check throroughly
    - If `geneadd` isn't used elsewhere, it's essentially crsytal desert adventure B track
    - No-DirectSong/`*` behavior for `crysada` is "Ascension Song," both in Shiverpeaks and Desert
        - So the vanilla track is used in both places. The problem is addition of desert stuff to it.
- Tombs has a special area around the portal that plays "Devona's Theme" bypassing DirectSong.
    
## Shing Jea Island
- Shing Jea Monestary/Seitung Harbor
     - Token stream is always `outrura` over and over.
     - No-DirectSong/`*` behavior alternates "Assassin's Theme" and "Ritualist's Theme."
- All other outposts
     - Token stream is random picks from `outrura`, `outrurb` and `outrurc`.
     - No-DirectSong/`*` behavior is:
          -  `outrura` = "Shing Jea Monastery"
          -  `outrurb` = "Harvest Festival"
          -  `outrurc` = "Age of the Dragon"
- All explorables and missions
     - Token stream is random picks from `ruraada`, `ruraadb` and `ruraadc`.
     -  No-DirectSong/`*` behavior is:
          -  `ruraada` = "Shing Jea Monastery"
          -  `ruraadb` = "Harvest Festival"
          -  `ruraadc` = "Age of the Dragon"
- Rollerbeetle Racing does not send any known tokens. The lobby alternates "Assassin's Theme" and "Ritualist's Theme." The race plays "Assassin's Theme" or "Ritualist's Theme" until the starting gun, then switches to a PvP/battle playlist. Probably best not to mess with this at all.
- I believe this is sufficient information to make all corrections for Shing Jea Island.

## Kaineng City 
- Kaineng Center
     - Token stream:
          - The first token upon entering the zone is a random pick from `urbaada`, `urbaadb`, or `urbaadc`.
               - This is weird. My best guess is it's a bug. Maybe a leftover from some kind of intro fanfare that got dropped? Copy/paste from LA?
               - The game does not wait for the track to finish before advancing to the next song. So you get a couple seconds of the first song, then it cuts off and plays the second.
               - It doesn't do it if the entire playlist is just `*`. That's probably what it's going to have to be.
               - Using a two-entry playlist where the first one is a split-second silence sort of works. If it plays first, there's nothing to get cut off. And its brevity makes it unlikely to be the song you leave during, so it should always be the next song when you come back. But... it doubles up the delay between tracks, creating really awkward long silence.
               - If DirectSong dll is removed, it just plays the default track normally.
          - All other tokens are random picks from `outurba`, `outurbb`, and `outurbc`.
- All other outposts
     - Token stream: Random picks from `outurba`, `outurbb`, and `outurbc`.
     - It seems like the L token isn't sent the first time you visit Dragon's Throat in a session. But it works correctly if you leave and come back. I don't see any fix for this.
- No-DirectSong/`*` outpost behavior: `outurba` = `outurbb` = `outurbc` = [iconic city ambient track missing from soundtrack CD](https://www.youtube.com/watch?v=rVe99xBqDrg&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=8)
- Raisu Palace explorable, Raisu Palace mission, Raisu Pavillion, and Divine Path
     - Token stream: Always `canadab`
- All other explorables and missions
     - Token stream: Random picks from `urbaada`, `urbaadb`, and `urbaadc`.
- No-DirectSong/`*` explorable/mission behavior:
     - `urbaada` = `urbaadb` = `urbaadc` = [iconic city ambient track missing from soundtrack CD](https://www.youtube.com/watch?v=rVe99xBqDrg&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=8)
     - `canadab` = "Kaineng City"
- The default GuildWars.ds accomplishes different tracks for the sewers, for final 2 missions, and for Divine Path via `L***` tokens.
- It seems this is all these is to learn about the urban soundtrack.

## Echovald Forest
- Tanglewood Copse
     - Token stream: random picks from `outurba`, `outurbb`, and `outurbc`.
     - If given `*` does indeed play default urban track.
- Jade Flats and Jade Quarry
     - Token stream: random picks from `outseaa`, `outseab`, and `outseac`
- Unwaking Waters
     - Token stream: random picks from `outseaa`, `outseab`, and `outseac`
- All other outposts:
     - Token stream: random picks from `outpeta` and `outpetb`
- All explorables and missions
     - token stream: random picks from `petrada` and `petradb`
     - didn't test Fort Aspenwood for lack of players
- Todo: Test Urgoz
- No-DirectSong/`*` behavior:
     - `outpeta` = "Echovald Forest"
     - `outpetb` = "Kurzick Theme"
     - `petrada` = "Echovald Forest"
     - `petrada` = "Kurzick Theme"
     
## Jade Sea
- Aspenwood Gate and Fort Aspenwood
     - Token stream: random picks from `outpeta` and `outpetb`
- All other outposts:
     - Includes Harvest Temple
     - Token stream: random picks from `outseaa`, `outseab`, and `outseac`
- All explorables and missions
     - Includes Unwaking Waters mission and explorable
     - token stream: random picks from `seabada`, `seabadb` and `seabadc`
     - didn't test Jade Quarry for lack of players
- Todo: Test Deep -- Deep outpost not using known tokens. Testing will take awhile... ugg...
- Todo: Test which L tockens really control what in Unwaking Waters
- No-DirectSong/`*` behavior:
     - `outseaa` = "Coastline"
     - `outseab` = "Jade Sea"
     - `outseac` = "Luxon Theme"
     - `seabada` = "Coastline"
     - `seabadb` = "Jade Sea"
     - `seabadc` = "Luxon Theme"
     

## Istan
- Kamadan
     - Token stream: Random picks from `outdela`, `outdelb`, and `outdelc`.
     
## Core
- Great Temple of Balthazar
    - Token stream is `outposr`, `outposc` Huge weight for R. Maybe some other stuff. Hard to tell with so much R. 

