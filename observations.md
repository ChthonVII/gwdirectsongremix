# Observations

## General

Here is how control flow seems to work, based on the (sparse) documentation and my experiments on Shing Jea Island. It's possible behavior is different for other chapters.
1. When Gw.exe is about to play a song, it sends 3 tokens to ds_GuildWars.dll.
     - Tokens are probably usually `L***` for the specific zone, `out****` or `****ad*` for outpost or adventuring, and some kind of ambient fallback.
     - The documentation isn't super clear. It's possible it meant "three tokens plus the `L***` token," so maybe there's another token with intermediate generality between outpost/adventuring and ambient. (Prophecies has some token names that suggest this. But they might also just be deprecated cruft. To be revisited.) 
     - The token sent does not always correlate with the song Gw.exe is about to play. For instance, in most cases `outrura` means "I'm about to play the song 'Shing Jea Monastery'," but in a couple cases, it does not.
     - Problem: L token is still sent for landmarks with special triggers. So the L token will override the special trigger unless it's moved above the L token in GuildWars.ds. Which is not always a feasible solution.
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

## Pre-Searing Ascalon
- All outposts (including new Piken Sq.)
    - Token stream is random picks from `outednc`, `outednd`, `outpose`, and `outposf`, seemingly with a higher weight for the first two.
    - Barradin Estate and Ashford Abbey have special music in default GuildWars.ds via L tokens.
- Catacombs
    - Token stream is `crysada` and `geneadd`
    - Same as Desert.
    - `crysada` is shared with both Desert and Shiverpeaks.
- All other explorables
    - Token stream is `edenada` and `edenadb`
    - Green Hills Country and Wizard's Folly have special music in default GuildWars.ds via L tokens.
    - The small pool in a cave in south Green Hills Country plays `ambient`.
        - If you exit and reenter the cave, it will not rotate songs unless the current song already played and finished once.
        - If an L token is set for this zone (which it is in the default GuildWars.ds), then:
            - Entering the cave still cuts off the current track and plays a new one.
            - But tracks are taken from the L token's list instead of `ambient`.
        - The original intent here is a puzzle.
            - Without DirectSong, it picks from the same two tracks that ordinarily play, so the only effect is to stop and restart the music, switching tracks half the time.
            - With DirectSong and the default GuildWars.ds, due to the L token overriding the special trigger, the result is nearly the same: It picks from the same two tracks that would ordinarily play, so the only effect is to stop and restart the music, switching tracks every time.
            - This feels underwhelming. You'd expect different, special music here. But all you get is a stop and start again with one of the same tracks you've heard for the whole zone.
            - Maybe the point is not the music but rather the silence between tracks coinciding with entering the cave. (Though this is rather undermined by having an aggressive foe positioned at the cave enterance, likely covering over the silence with a fight in many cases.)
        - Options for what to do here:
            - Keep the L token. The case will have a "stop, start and switch tracks" behavior, but use the same tracks as the rest of the zone.
            - Remove the L token (and probably mix these two tracks into the general pre-searing playlists). The case will have a "stop, start and switch tracks" behavior, picking tracks from a different list in GuildWars.ds than the rest of the zone. However, `ambient` is used elsewhere (login screen, possibly other places), so we probably don't want to alter it too much. Which would realistically leave us with the tracks for the cave being a subset of the tracks for the zone.
            - Moving `ambient` above `L160` in GuildWars.ds is probably not workable. I'd expect priority problems here and possibly elsewhere. 
- TODO: Finish pre-searing.
- TODO: match tracks to tokens
- No-DirectSong/`*` behavior is:
    - Outposts
        - `outednc` = "Eye of the Storm"
        - `outednd` = "Gwen's Theme"
        - `outpose` = "Guilds at War"
        - `outposf` = [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6).
    - Explorables/Missions
        - `edenada` = "Eye of the Storm"
        - `edenadb` = "Gwen's Theme"
        - `crysada` = "Ascension Song"
        - `geneadd` = [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6).
- All exporables and missions
        - `ambient` = Randomly plays "Eye of the Storm" or "Gwen's Theme." See above for more details.

        

## Post-Searing Ascalon
- All outposts
     - Token stream is random picks from `outscrc`, `outscrd`, `outpose`, and `outposf`, seemingly with a higher weight for the first two.
     - No-DirectSong/`*` behavior is:
          - `outscrc`= "The Charr"
          - `outscrd` = "The Great Northern Wall"
          - `outpose` = "Guilds at War" (Needs more testing that this track is the same across all areas. So far tested Ascalon, Northern Shiverpeaks, and Kryta.)
          - `outposf` = [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6).
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
        - `crysada` = "Ascension Song" (both in Shiverpeaks and Desert and Catacombs)
        - Having `crysada` play in the mountains is correct insofar as the corresponding non-DS track does play there. The problem is that DirectSong makes it into a multi-song playlist that now has to fit both locations (and Catacombs).
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
          - Has special music in default GuildWars.ds via L token.
- Lion's Arch Keep
    - Token stream: just `villaga`.
- All other outposts
    - Token stream is random picks from `outcosc`, `outcosd`, `outpose`, and `outposf`, seemingly with a higher weight for the first two.
    - Divinity Coast has special music in default GuildWars.ds via L tokens.
    - (No special music for ToA.)
- Explorables/Mission
    - Token stream is `coasada` and `geneadc`
    - If `geneadc` isn't used elsewhere, it's essentially Kryta adventure B track
    - Majesty's Rest uses Kryta music.
    - Divinity Coast has special music in default GuildWars.ds via L tokens.
    - (No special music for Ascalon Settlement.)
    - TODO: Check Kessex Peak
- No-DirectSong/`*` behavior is:
    - Outposts
        - `villaga` = "Ashford Abbey"
        - `outcosc` = "Sands of Kryta"
        - `outcosd` = "Temple of Tolerance"
        - `outpose` = "Guilds at War"
        - `outposf` = [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6).
    - Explorables/Missions
        - `coasada` = "Temple of Tolerance"
        - `geneadc` = "Guilds at War"

## Magumma Jungle
- All outposts
    - Token stream is random picks from `outovrc`, `outovrd`, `outpose`, and `outposf`, seemingly with a higher weight for the first two.
    - Vanilla music might be a mistake? `outovrc`, `outovrd` are duplicates of `outpose`, and `outposf`, while nothing is shared between outposts and adventuring.
- All explorables/missions
    - Token stream is `geneada` and `geneadb`
- No-DirectSong/`*` behavior is:
    - Outposts
        - `outovrc` = "Guilds at War"
        - `outovrd` = [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6).
        - `outpose` = "Guilds at War"
        - `outposf` = [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6).
    - Explorables/Missions
        - `geneada` = "Hall of Heroes"
        - `geneadb` = "The Rift"
    
    
## Crystal Desert
- All outposts
    - Token stream is random picks from `outcryc`, `outcryd`, `outpose`, and `outposf`, seemingly with a higher weight for the first two.
    - Tombs outpost has a special area around the portal that plays "Devona's Theme" bypassing DirectSong.
    - At one point I had Elona Reach, Thirst River, and Destiny's Gorge playing `outposr` somehow, but I can't reproduce it :(
- All explorables/missions
    - Token stream is `crysada` and `geneadd`
    - No-DirectSong/`*` behavior for `crysada` is "Ascension Song," both in Shiverpeaks and Desert (and Catacombs). So the vanilla track is used in both places. The problem is that DirectSong makes it into a multi-song playlist that now has to fit both locations (and Catacombs).
    - Same as Catacombs in pre-searing.
- Tombs
    - Token stream is `riftgld` over and over. (All 4 levels.)
    - No-DirectSong/`*` behavior is random picks from "Hall of Heroes," "The Rift," "Guilds at War," and [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6). (This presents a small problem, as we cannot get just the untitled song alone via `*`. We will need to extract it from gw.dat and find the correct volume to play it.)
- No-DirectSong/`*` behavior is:
    - Outposts
        - `outcryc` = "Ascension Song"
        - `outcryd` = "Crystal Oasis"
        - `outpose` = "Guilds at War"
        - `outposf` = [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6).
    - Explorables/Missions
        - `crysada` = "Ascension Song"
        - `geneadd` = [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6).
    
## Ring of Fire Islands
- All outposts
    - Token stream is random picks from `outvolc`, `outvold`, `outpose`, and `outposf`, seemingly with a higher weight for the first two.
- All explorables/missions
    - Token stream is `volcada` and `volcadb`
- No-DirectSong/`*` behavior is:
    - Outposts
        - `outvolc` = "Abbadon's Mouth" \[sic\]
        - `outvold` = "The Door of Komalie"
        - `outpose` = "Guilds at War"
        - `outposf` = [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6).
    - Explorables/Missions
        - `volcada` = "Abbadon's Mouth" \[sic\]
        - `volcadb` = "The Door of Komalie"
        
## Epilogue Droknar\'s Forge
- Token stream is `riftgld` over and over.
- No-DirectSong/`*` behavior is random picks from "Hall of Heroes," "The Rift," "Guilds at War," and [untitled song from the Catacombs, missing from the soundtrack CD](https://www.youtube.com/watch?v=86ZM36tFE_s&list=PLwJG4Y29e6d9OWQjQ1jmULd33Gu7mWL6t&index=6).
- The vanilla picks are rather poor, and this is one instance I'm in favor of outright replacing them.
    
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
     
## Battle Isles
- Great Temple of Balthazar
    - Token stream: Random picks from `outposr`, `outposc`. Huge weight for R. Maybe some other stuff. Hard to tell with so much R. 
    - No-DirectSong/`*` behavior:
        - `outposr` = Random picks from "Hall of Heroes" and "The Rift." TODO: check for more.
        - `outposc` = TODO 
- Embark Beach
    - Token stream: Random picks from `enamsca`, `enamscb`, `enamsci`.
    - No-DirectSong/`*` behavior: TODO
- Zaishen Menagerie Outpost
    - Token stream is always `outrura` over and over.
    - No-DirectSong/`*` behavior is random picks from "Assassin's Theme" and "Ritualist's Theme." (Almost, but not quite the as Monestary)
- Zaishen Menagerie Grounds
     - Token stream is random picks from `ruraada`, `ruraadb` and `ruraadc`.
     - No-DirectSong/`*` behavior: TODO
- Codex Arena Outpost
    - Token stream is random picks from `outlowa`, `outlowb`, `outlowc`
    - No-DirectSong/`*` behavior: TODO
- RA outpost
    - Token Stream `outposr`. (Might be like GToB with other stuff mixed in rarely.)
    - No-DirectSong/`*` behavior:
        - `outposr` = Random picks from "Hall of Heroes" and "The Rift." TODO: check for more.
- HA outpost
    - No music?!
- Zaishen Challenge outpost
    - No music?!
- Zaishen Elite outpost
    - Token Stream `outposr`. (Might be like GToB with other stuff mixed in rarely.)
    -- No-DirectSong/`*` behavior:
        - `outposr` = Random picks from "Hall of Heroes" and "The Rift." TODO: check for more.
