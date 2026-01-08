# gwdirectsongremix
Improved Alternate Version of GuildWars.ds

### Substantive Goals
Fix the rather numerous shortcomings of the default GuildWars.ds.
- Restore vanilla music tracks that are entirely missing from the default GuildWars.ds.
- Restore vanilla track/zone associations, except in special cases. For most zones, the goal is "vanilla music, plus bonus tracks."
- Generally organize bonus tracks to match the theme and tempo of the vanilla tracks to which they are the "b side."
- Pare down overlong playlists that dilute the play time of iconic (usually vanilla) tracks.
- Eliminate duplicates and remove some appearances of overused tracks.
- Generally restrict tracks to the geographic area implied by their title. (Both additions and removals.)
- Whenever suitable, namesake tracks should play in their associated zones.
- Every track in the collection that's suitable as background music should play somewhere.

### Procedural Goals
- Fully understand the vanilla & DirectSong behavior for a given zone/area before making changes.
- Use git to track changes.

## Status:
- Login Screen: **Done**
- Prophecies: **Done**
- Factions: **Done**
- Nightfall: Not started
- EotN: Not started
- Underworld & Fissure of Woe: **Done**
- Battle Isles outposts: Research >50% complete.
- PvP: Not started. Won't be attempted without help.

## Usage:
1. Back up your `GuildWars.ds` and replace it with this one.
2. Pick which login screen playlist you prefer and edit `GuildWars.ds` accordingly.
Look at line 36.
Remove the `#` marks at the start of the lines for the login screen playlist that you want,
and put `#` marks at the start of the lines for the other four. You may choose from (slightly modified versions of) the playlists originally used for each chapter's login screen, or a combined playlist with theme songs from all four chapters.
3. Copy/paste the GWDirectSongRemix folder inside your DirectSong folder.


## How You Can Help:
1. **Volume Testing**: This is dull but crucial work.
    - First read the notes about volume at the bottom of the "General" section of [observations.md](https://github.com/ChthonVII/gwdirectsongremix/blob/main/observations.md) to undersand why and how some tracks have really wrong volume.
    - Grab `GuildWars.ds` from this repo.
    - Uncomment the line for your guild hall, and copy/paste a song to test there.
        - If the song already appears in `GuildWars.ds`, copy/paste it along with the volume shown.
        - If the song doesn't appear in `GuildWars.ds`, use `[600]` as a starting guess.
    - Start GW, go to your guild hall, and see if the volume seems good. If not, exit GW, edit `GuildWars.ds`, and try again. Repeat until you find a good volume.
    - (600-700 seems to be a sane range. Be suspicious of anything outside that.)
    - Open a github issue reporting your results.
2. **Research:** Help elucidate the vanilla and DirectSong behavior.
     - Read the Factions sections of [observations.md](https://github.com/ChthonVII/gwdirectsongremix/blob/main/observations.md) as an example.
     - Download the `robotvoice` directory from this repo, back up your `GuildWars.ds` and replace it with the one from `robotvoice`.
     - Pick a zone/area that doesn't have complete research in [observations.md](https://github.com/ChthonVII/gwdirectsongremix/blob/main/observations.md).
     - To determine which tokens are used for a given zone, visit that zone and take notes as the robot voice announces the tokens. Stick around awhile to make sure you don't miss any.
     - To determine the vanilla soundtrack, edit `GuildWars.ds` to replace one robot voice track with `*` and see what plays in its place. Visit multiple areas to make sure to catch inconsistent use of tokens, like `outrura`. Let the song play all the way through and loop in case it's actually a playlist rather than a single song.
     - Open a github issue reporting your results. Or make a pull request editing [observations.md](https://github.com/ChthonVII/gwdirectsongremix/blob/main/observations.md).
     - Some areas where help would really be appreciated:
         - PvP zones. A lot of PvP arenas have no activity and will require coordinated syncing by multiple people to gather data. I'm not even going to try to research PvP music without help.
         - Explorables with no town access. Hiking out to zones like Dreadnaught's Drift to be totally *sure* it doesn't have a custom soundtrack is time consuming.
         - Elite areas. It's a long, time-consuming slog to check if there is some special behavior around Dhuum/Urgoz/Mallyx/Duncan/etc., and then make a second trip to see what the vanilla music for it is.
3. **Final Testing**: Did it work?
     - Pick a zone that's supposed to be complete and see if the changes are working in-game as expected.
