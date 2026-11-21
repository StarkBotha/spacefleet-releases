# SpaceFleet

Playtest builds of SpaceFleet, a space trading, building and fleet game.

**Current build: `61342d2`**, published 21 Nov 2026 15:15 UTC.

## Download

You only download the launcher once. It downloads the game and keeps it up to date.

| System | Download | How |
|---|---|---|
| Windows | [SpaceFleet-Launcher.msi](https://github.com/StarkBotha/spacefleet-releases/raw/main/SpaceFleet-Launcher.msi) | Double-click it. SpaceFleet appears in the Start menu. Windows may say "Windows protected your PC": click **More info**, then **Run anyway**. |
| Ubuntu / Debian | [spacefleet-launcher.deb](https://github.com/StarkBotha/spacefleet-releases/raw/main/spacefleet-launcher.deb) | Double-click it, or run `sudo apt install ./spacefleet-launcher.deb`. SpaceFleet appears in the app menu. |
| Any Linux | [play-spacefleet.sh](https://github.com/StarkBotha/spacefleet-releases/raw/main/play-spacefleet.sh) | Put it in an empty folder and run `bash play-spacefleet.sh`. |

The two archives in this repository (`SpaceFleet-windows.zip`, `SpaceFleet-linux.tar.gz`) are the game itself. The launchers fetch them for you.

Saves and settings are kept outside the game folder (Windows `%APPDATA%\SpaceFleet`, Linux `~/.config/SpaceFleet`), so updates never touch them.

## Builds

Newest first. Every build includes all the ones below it.

## 21 Nov 2026: the AI no longer links two jump gates at the same station
- An AI faction could end up with two gate ends next to its own capital, linked to each other. Such a pair saves no travel.
- It now waits for a far end before starting a second end at home, and never links two ends that stand at the same station.
- Your own gates are not affected.

## 21 Nov 2026: rename your ships
- Select one of your own ships and press **Rename** in the header of the panel on the right. Type a name, press Enter or OK.
- At most 32 characters. Two of your own ships cannot share a name.
- The new name shows in the lists, the panels and the news, and is saved with the game. Ships have no name on the map.
- Save format 36. Older saves still load.

## 21 Nov 2026: Auto-diplomacy can sign pacts and alliances again
- With Auto-diplomacy on, your faction never built up trust in anyone, so it could share maps but never reach a defensive pact or an alliance. It now builds trust the same way the AI factions do.
- With Auto-diplomacy off nothing changes: you decide, and only their trust in you counts.

## 21 Nov 2026: the station panel's module list shows the right recipe
- On a station's Info tab, "Built modules" said every factory "makes 9 Energy Cells a minute from nothing". Each module now shows its own recipe, as the Build tab already did.
- Only the text changed.

## 21 Nov 2026: a tiny upkeep no longer shows as 0
- A module card used to print "upkeep 0 cr/min" when the upkeep was too small to show. It now prints the small number, for example "0.04", or "under 0.01".
- Only the text changed. What a module costs to run is the same.

## 21 Nov 2026: AI factions weigh territory when they build
- An AI faction choosing a site for an outpost or a defence platform now counts the tiles it would take from factions whose stations it has charted. It is a weight, never a ban.
- Honour-bound and mercantile factions mind taking tiles more; expansionist and militaristic ones mind it less. A warm CEO minds it more, an outward-looking CEO less.
- At war, a militarist takes an enemy's tiles freely. An opportunist may take a weaker neighbour's tiles on purpose.
- Platforms now favour the spot that best shores up the faction's own contested or threatened border.
- A faction that has not charted a neighbour's station can still build into its tiles by accident.

## 21 Nov 2026: territory tiles now carry the rules
- Borders are the territory tiles. The old claim circle and airspace circle are gone and no longer drawn.
- Foreign ships seen on a faction's tiles cause border friction. A faction's airspace rule applies on its tiles. With the Airspace map layer on, an outline gets a red inner line where it is closed to you and a dashed amber line where only civil ships may enter.
- Finishing a station, outpost or platform that takes another faction's tiles is an act of aggression: that faction holds it against the builder once it finds the station. Placing one warns you first: "Act of aggression: this takes N tiles from X".
- A faction's Expansionism no longer changes how much space it claims.
- Save format 35. Older saves still load.

## 21 Nov 2026: fog of war and territory outlines (drawing only)
- The map now dims space that none of your stations, ships or buoys can see. An ally's sensors lift the fog too, and you see what is inside them.
- Every faction you have met gets one outline around its territory, in its colour, fainter inside fog. Another faction's outline is worked out only from its stations and platforms you have charted.
- Territory is counted on small six-sided tiles: guns claim first, then fixed scanners (station and outpost 1, platform one half). A tie is contested and shows as a faint grey edge. F3 shows everything.
- Nothing else changes yet: the old claim and airspace circles still decide the rules and are still drawn. Save format 34.

## 20 Nov 2026: checks only
- No change to the game. One check on the AI's jump gates was brought up to date.

## 20 Nov 2026: a Pace slider on the New game page
- The New game page has a "Pace" slider under Gas clouds. Left is the shipped pace (the slowest); each step right is faster, up to 10 times faster.
- It sets the pace of the whole game, for you and for every AI faction, and is saved with that game.
- Leave it alone and the game plays as before. Save format 34. Older saves still load.

## 20 Nov 2026: the game can pause itself for news
- Settings has a new "Pause for news..." page. Every kind of news has an On / Off switch: when it is On, the game pauses as that news arrives and shows "Paused: ..." with the line.
- Diplomacy news is On to start with (offers, answers, treaties, pacts, a war declared, an ally joining a war). Everything else is Off until you switch it on.
- In a game, every faction you have met has a switch too: Off means news about that faction never pauses.
- Offers still lapse after one minute of game time.

## 20 Nov 2026: peace decisions use what was seen
- An AI faction weighing peace no longer knows the true damage of its enemy's stations. It counts each enemy station as it was when its scanners last saw it.
- Your war score and "their exhaustion" lines do the same and say so: "from what we have seen".
- Save format 33. Older saves still load.

## 20 Nov 2026: factions judge strength from what they have seen
- An AI faction now judges another faction's warships only from ships its own scanners saw in the last ten minutes. It no longer knows the true numbers. Its CEO's ability decides how well it judges.
- Your Diplomacy screen and the war confirmation do the same for you: "From what we have seen, they are about 2.7 times stronger than you", or that you have not seen any of their armed ships.
- Save format 32. Older saves still load.

## 20 Nov 2026: AI factions no longer stall at the start
- An AI ship yard that waits for wares now gets a hauler to fetch them, as your own queued builds do. Some AI factions used to build nothing for 20 minutes.
- A supply trip for a build now brings every ware the build needs, not a hold full of one ware.
- A miner told to wait at a busy rock near a station now waits; it used to drift off to the parking ring.

## 20 Nov 2026: load a save or a scenario from the command line (dev)
- With the dev switch, the game can start straight from a save (--load) or from a pre-rolled scenario (--scenario). Nothing changes in normal play.

## 20 Nov 2026: send a save to the developer
- New "Send to developer" button on every save in the Load and Save lists, and "Send this game to the developer" in the pause menu (Ctrl+F12).
- It needs one line in Settings, under Sending saves, that says how to send a file. It is empty until you set it.

## 19 Nov 2026: Small galaxies get every field type
- On the Small galaxy every field type now gets at least one field, and the shortage warning is gone.

## 19 Nov 2026: waiting research moves on
- When a technology you queued waits for wares, research now works on the next one in your queue that can start. The waiting one keeps its place and starts when your capital can pay.

## 19 Nov 2026: gas clouds blur scanners
- A ship or station inside a gas cloud that still holds gas sees only half its scanner range. The scanner ring shows the short range and says why.
- Nothing else changes: no damage, and a ship inside a cloud is still seen from outside.

## 19 Nov 2026: choose how many gas clouds
- The New game page has a "Gas clouds" setting: None, Few, Normal or Many.

## 19 Nov 2026: the bare start is the default
- The New game page now opens on the Bare base start. The Standard start is still in the list.

## 19 Nov 2026: Propellant is used
- Missile parts now need Propellant (in place of Fuel Rods). The Cruise Drive, Combat Drive, Fusion Drive and Afterburner each need some too.
- Propellant comes from Hydrogen, which comes from gas clouds. You can also buy either.

## 19 Nov 2026: gas clouds
- Gas clouds are on the map, away from the starts. A scanner that reaches one charts it. Clouds run out and do not refill.
- New ships: the Gas Collector and the Small Gas Collector, with a Gas Scoop. No research needed. Right-click a charted cloud to collect.
- Hydrogen is sold and traded like any raw material. The new Propellant Refinery turns it into Propellant.
- Nothing uses Propellant yet; that comes next.
- Old saves no longer load (save format 29).

## 19 Nov 2026: bigger research costs wares
- Technologies of 150 points or more now also cost two wares, taken from your capital when the research starts. Point costs are unchanged.
- A research that waits for wares says which and how many, and the advisor reports it.
- Auto-research never takes a ware below your stock reserve. Research you queue yourself may.
- Old saves no longer load (save format 28).

## 19 Nov 2026: ware tidy-up
- Nickel and Cobalt are gone. Conductors need only Copper, Fuel Rods only Uranium; both ores are twice as common.
- Drone Components have their own recipe: Engine Parts, Scanning Arrays and Microchips.
- Cruisers and the Carrier now need Claytronics.
- Old saves no longer load (save format 27).

## 19 Nov 2026: a leaner tech tree
- The tree shrinks from 93 technologies to 61. Every technology now unlocks something; the old percentage-only ones are folded into those.
- No bonus is lost and total research cost is unchanged. Each doctrine gives its first weapon or ship at once.
- Old saves no longer load (save format 26).

## 19 Nov 2026: ice and water
- Ice is a new raw material. Miners mine it like ore; most of it lies in ice fields away from the starts.
- The new Water Purifier makes Water from Ice. It needs no research.
- Food Farms now need Water. Pharma Labs need Water in place of Light Alloys.
- No start is promised ice nearby. The supply station starts with a little.

## 19 Nov 2026: the AI uses miner focus and collects floating cargo
- AI miners now focus on the ores their faction is short of.
- AI miners and haulers pick up floating cargo their faction can see, and go back for the rest.
- Your own miners do the same only while Auto-command fleet is on. A focus you set yourself is never changed.

## 19 Nov 2026: doctrines no longer lock each other
- Researching a weapons, defence or fleet doctrine no longer closes the others. You can research them all and build a mixed fleet.

## 19 Nov 2026: fleets steered by the advisor and the CEOs
- A faction head can now steer the fleets: send scouts to find a ware, aim raiders at a ware, tilt goals by character, and grow the fighting fleet.
- Four switches on the New game page set what AI CEOs may steer. The Advisor tab has the same four for your advisor.
- Your advisor steers only in Chief of staff mode with Auto-command fleet on. Otherwise it gives the steering as advice.

## 19 Nov 2026: stations pay for what they build
- Warships and research are now paid by the station, like everything else. Research is paid from your capital's account.
- The faction pool pays only for constructors and what constructors build.
- A station that cannot pay says so, with the numbers: "Rook Spire cannot afford it: 310 of 800 credits".

## 19 Nov 2026: no more "short of 0 Steel"
- A manager no longer says a build is "short of 0" of a ware. A ware the build does not use no longer holds the build back.

## 19 Nov 2026: a full ship unloads where you send it
- Right-clicking one of your stations with a ship that carries cargo now makes it dock and unload there, with or without Manual control.
- A ship with cargo never says "nothing to do" any more. It says where it will take the cargo, or why it cannot unload at your stations.
- A miner that sells at another faction's station says why (for example: none of your stations has a dock of its size).

## 19 Nov 2026: "make up to" limits for factories
- Factories no longer stop at a built-in stock cap. With no limit set, a factory makes until the holds are full.
- On the Trade tab, each ware a station makes has "Make up to" with a number, No limit, or Auto (the manager decides). Your number always wins.

## 19 Nov 2026: every ship yard builds its own ship
- A station with several ship yards builds one ship in each at the same time. Each yard shows its own ship and progress.
- A ship that is waiting for materials no longer blocks the ships behind it in the queue.

## 19 Nov 2026: a leaner Standard start
- The Standard start now holds building materials for one Corvette only. Your factories matter from the first minutes.
- Food, medicine and energy are unchanged. Corvettes and Small Miners can be built from the start; a Constructor needs a Medium yard first.

## 19 Nov 2026: reserves stop factories too
- A factory no longer uses an input below the reserve you set for it. Its card says "holding N in reserve (your reserve)" while it waits.

## 19 Nov 2026: managers obey your switches; the advisor reports what is held up
- A manager never builds, buys or orders ships against a switched-off automation switch.
- The advisor now reports ships that cannot dock or unload, full holds and blocked construction sites, each with what would fix it.
- Fixed: a hauler could stand still for half an hour at the edge of closed airspace, so a station never got parts from its sister station.
- Managers stop asking the faction for wares their own faction already makes.

## 19 Nov 2026: miner jettison starts on
- When you give a miner a focus, "Jettison what it is not focusing on" now starts On. Switch it off on the Orders tab if you want the other ore brought home.

## 19 Nov 2026: stock reserves
- On a station's Trade tab every ware has a Reserve number. Managers, the automation and sales never take a ware below it.
- What you order yourself may still use it. Buttons copy your reserves to all stations or make them the default for new ones.

## 19 Nov 2026: say what a cargo hold may hold
- Click a Cargo Hold on your station, then "Holds...": pick the wares it may hold, for example only Iron and Aluminium.
- A hold with no list holds anything. Nothing already in the station is destroyed when you change a list.

## 19 Nov 2026: any ship with a hold collects floating cargo
- Select a ship with a cargo hold and right-click a floating cargo pod to collect it. No tractor beam or research needed.
- Wrecks of destroyed ships still need a tractor beam.

## 19 Nov 2026: cargo holds keep their room without power
- A station short of power no longer loses half its storage. Before, that could trap a station: over its limit, with nothing able to come in.

## 19 Nov 2026: jettison cargo from a station
- Stock tab, "Jettison cargo": pick a ware and an amount. The goods float just outside the station in a cargo pod and stay there.
- A ship with a tractor beam and a hold can collect the pod again.

## 19 Nov 2026: clearer message on a full station
- A station whose holds are full now says so on a waiting build ("no room: the holds are full"), instead of "cannot afford the order".

## 19 Nov 2026: gifts of goods, and asteroid field types
- You can gift wares and ores to another faction: Diplomacy screen, "Gift goods...", or a station's Trade tab. Your own hauler carries them. AI factions can gift goods too.
- Asteroid fields now have types: metal-rich, silicate, carbonaceous or heavy. Where you mine matters.
- The two rocks next to each start no longer hold guaranteed metals. Some starts are poorer than others.

## 19 Nov 2026: miners focus on the ores you choose
- On a miner's Orders tab, pick the ores it should focus on. It can also jettison the ore it is not focusing on.
- Jettisoned ore floats in space in a cargo pod and can be picked up.

## 19 Nov 2026: every module size looks different
- Every station module now has six different footprints and pictures, Tiny to Huge. A bigger size is visibly bigger.
- Stations take up more room on the map.

## 19 Nov 2026: ship yards at any size
- In Buy modules the Ship Yard follows the size buttons like every other module. No smaller yard is needed first.

## 19 Nov 2026: purchase orders
- A hauler now sets out for any amount the seller can spare, not only for a load of 20 or more.
- The order window says plainly how much the seller has and what an order is waiting for.

## 19 Nov 2026: window size
- Picking a window size works when the window is maximized, with the Settings arrows and with F10.
- A maximized window is remembered as maximized, not as a giant window size.
- Alt+Enter toggles borderless fullscreen, as well as F11.
- On Ubuntu, exclusive fullscreen cannot switch the screen's resolution; the Settings row says so.

## 19 Nov 2026: installers
- Windows: SpaceFleet-Launcher.msi installs the launcher with a Start menu entry.
- Ubuntu and Debian: spacefleet-launcher.deb installs the launcher with an app menu entry.

## 19 Nov 2026: Small Miner and the bare start
- New ship: Small Miner, a miner that fits a Small dock and a Small yard.
- The "Bare base" start: a hub, one Small dock, one Small Cargo Hold, a Small ship yard, a Small Miner and a Scout.
- A ship that cannot deliver says why, for example "holds are full" or "no dock large enough".

## 19 Nov 2026: asteroid layout and ore rarity
- New game page, "Rocks and ores...": how much asteroids cluster, and how rare each ore is.

## 19 Nov 2026: the advisor's cut
- You can set the advisor's cut on the Advisor tab, and the AI CEOs' cut on the new game page.

## 19 Nov 2026: the advisor and faction CEOs
- Hire an advisor who points things out, or acts for you as chief of staff. The Advisor tab shows what it did and why.
- Every AI faction has a CEO who hires and fires managers and answers their requests.

## 18 Nov 2026: start kits
- New game page, "Edit kit...": change what every faction starts with: credits, stock, ships, docks, yard, modules.
