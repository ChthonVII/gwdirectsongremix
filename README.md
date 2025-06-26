# gwdirectsongremix
Improved Alternate Version of GuildWars.ds

### Substantive Goals
- Restore original tracks where missing. Except in special cases, zones should play their original music, plus bonus tracks, with the original music at high priority.
- Whenever suitable, namesake tracks should play in their associated zones.
- Every track in the collection that's suitable as background music should play somewhere.

### Procedural Goals
- Fully understand the vanilla & DirectSong behavior for a given zone/area before making changes.
- Use git to track changes.

## Status:
- Prophecies: Research in progress
- Sorrow's Furnace: None
- Factions: **Ready for testing!**
- Nightfall: None
- EotN: None

## Usage:
Back up your `GuildWars.ds` and replace it with this one.

## How You Can Help:
1. **Volume Testing**: This is dull but crucial work.
    - First read the notes about volume at the bottom of the "General" section of [observations.md](https://github.com/ChthonVII/gwdirectsongremix/blob/main/observations.md) to undersand why and how some tracks have really wrong volume.
    - Grab `GuildWars.ds` from this repo.
    - Uncomment the line for your guild hall, and copy/paste a song to test there.
        - If the song already appears in `GuildWars.ds`, copy/paste it along with the volume shown.
        - If the song doesn't appear in `GuildWars.ds`, use `[600]` as a starting guess.
    - Start GW, go to your guild hall, and see if the volume seems good. If not, exit GW, edit `GuildWars.ds` and try again. Repeat until you find a good volume.
    - (600-700 seems to be a sane range. Be suspicious of anything outside that.)
    - Open a github issue reporting your results.
2. **Research:** Help elucidate the vanilla and DirectSong behavior.
     - Read the Factions sections of [observations.md](https://github.com/ChthonVII/gwdirectsongremix/blob/main/observations.md) as an example.
     - Download the `robotvoice` directory from this repo, back up your `GuildWars.ds` and replace it with the one from `robotvoice`.
     - Pick a zone/area that doesn't have complete research in [observations.md](https://github.com/ChthonVII/gwdirectsongremix/blob/main/observations.md).
     - To determine which tokens are used for a given zone, visit that zone and take notes as the robot voice announces the tokens. Stick around awhile to make sure you don't miss any.
     - To determine the vanilla soundtrack, edit `GuildWars.ds` to replace one robot voice track with `*` and see what plays in its place. Visit multiple areas to make sure to catch inconsistent use of tokens, like `outrura`. Let the song play all the way through and loop in case it's actually a playlist rather than a single song.
3. **Final Testing**: Did it work?
     - Pick a zone that's supposed to be complete and see if the changes are working in-game as expected.
