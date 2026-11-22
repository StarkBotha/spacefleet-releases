# SpaceFleet

Playtest builds of SpaceFleet, a space trading, building and fleet game.

**Current build: `1130a7a`**, published 22 Nov 2026 13:42 UTC.

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

## 22 Nov 2026: materials held for a site or a jump gate stay put
- **Stock the faction's pool bought for a construction site or a jump gate's kit now stays at the station until it is delivered.** Supply runs, station orders, foreign buyers, import runs and the faction's own traders no longer take it.
- **If the pool's record of such stock says more than is really there, it is corrected** at the station's next accounting round, and the faction's head is told once: "The pool's record of Steel at X was 360, but only 165 is there: 195 was taken for other uses".
- A ship or module build that waits on such stock now names it: held for "a jump gate".
- This was the known fault from the last build: an AI faction's second jump gate could stall. The test for it is switched on again and passes.
- Seen on the way: with held stock no longer for sale, traders find less to buy in some places. An AI faction whose pool cannot pay for a gate keeps wanting it and saves for it.
- Older saves still load. A game's first minutes play out exactly as before.

## 22 Nov 2026: managers see what they cannot replace
- **A station manager now sees, ware by ware, whether its stock can be replaced.** Three readings: it can be replaced; it is scarce (less can arrive in the time the manager looks ahead than is already claimed); or "what I have is all there is" (nothing of ours makes it and nobody the manager knows has any to spare).
- **It sees which uses compete for a scarce ware** and feels a higher price for spending it. It still decides by its own character, and says so: "Built a Small Cargo Hold: the holds were 80% full; it takes the Steel a Small Water Purifier needs, and nothing of ours makes it and nobody I know has any to spare: what I have is all there is (to me it costs 989 cr, not 580)".
- **How far a manager sees depends on the manager.** One who plans a single step ahead does not see the builds it cannot pay for yet, so it does not see what its choice takes from them.
- **Your advisor's counsel and the station's "Now" block show the same readings:** "Light Alloys 3: ... what I have is all there is; claimed: a Small Cargo Hold 4", and for food and medicine "it lasts 15 min at the use now".
- **A manager can hold the yard's automatic ship builds** when a ship would take a ware its own wish needs, with the reason shown.
- **A manager whose crew threatens its life now feels it.** The fear grows as the deadline nears, and how much depends on the person. One new number for mods: mind.selfSafetyWeight.
- Seen in two rerun test games: one manager decided exactly as before, with the new readings on show; the other saw the scarce Steel, built her hold anyway, and her people still went hungry at 2:34. The yard hold and the fear were not seen in a game, only in their own tests.
- Older saves still load. A game's first minutes play out exactly as before; later a manager may decide differently where a ware is scarce.

## 22 Nov 2026: dev cheat to spawn a jump gate
- Dev cheats, Stations tab: "Spawn jump gate". It puts a finished jump gate at the cursor for the faction you pick, the same way "Spawn station" does. Console: `gate [gate] [faction]` (also `jumpgate`).
- It costs nothing. Spawn two and link them from a gate's own panel as usual.
- The game's results are exactly the same as before.

## 22 Nov 2026: managers look after their people (fixes from the play tests)
- **A manager that wants to build something and is short of a ware now does something about it.** It orders the ware, or, when nobody it knows sells it, asks the faction: "Asked the faction for Light Alloys: to build a Small Water Purifier, short of 6 Light Alloys and nobody I know sells it". Your advisor as chief of staff can grant that, make it a faction goal and send scouts. The briefing shows it: "Wants ... but is short of 6 Light Alloys - ordered 6 from X".
- **A station no longer sells its own people's food, medicine and power.** What it keeps back from traders and foreign buyers now covers what its people use.
- **A need that reads short now has an answer on offer.** A Food Farm, Pharma Lab or Water Purifier counts as useful as far ahead as the manager's own "people fed and treated" reading looks. Before, they only counted when it was nearly too late.
- **No more false Energy Cell orders.** Idle factories were counted as if running at full speed, so stations with plenty of cells kept ordering more.
- **A faction goal no longer makes a station build the same factory again and again.** A finished factory that has not produced yet, or stands idle, still answers the goal, and the manager says so: "Did not build another Small Water Purifier for the goal of more Water: the one built at 0:05:00 has not produced yet".
- **Clearer words.** A waiting gate or site says "no room in the holds" when that is the cause, not "the pool cannot afford it". The Staff drawer separates "left hungry" from "left unpaid", names every ware that is short and only says "build" for something the station lacks. News about people going without says what ran out. Fading anger says what it was about. The Stock tab's "Used" is what the people actually got.
- Known and being fixed: an AI faction's second jump gate can stall because materials held for it leak to supply and trade runs.
- Older saves still load. The game plays differently from the last build: managers decide differently.

## 22 Nov 2026: new setting "Ships decide less often when idle" (faster fast-forward in long games)
- Settings, GAME: "Ships decide less often when idle", on by default. Ships with nothing urgent to do re-think every few moments instead of every step: an idle ship up to two thirds of a second of game time late, a busy one barely. A ship under fire always reacts at once, and a ship you gave an order to or set a behaviour for decides every step as before.
- On the 8-hour test save, x16 in the real game runs at about x13.2 with the setting on and about x11.9 with it off.
- With the setting on a game plays out a little differently from before (not worse); turn it off for the exact, slower simulation. It can be switched in the middle of a game.
- The five numbers behind it are in the settings files (tuning.json, behaviour: idleHotEveryTicks, idleWarmEveryTicks, idleColdEveryTicks, idleScanEveryTicks, idleContactsEveryTicks), so a mod can change them.
- Fixed on the way: switching the slower contact updates on in the middle of a game could crash.

## 22 Nov 2026: a small speed step
- Ships gather a few facts with less work each step (who is armed and hostile, who is sheltering, where to take refuge). A very small gain.
- The game's results are exactly the same as before.

## 22 Nov 2026: the simulation's worker threads start together (speed)
- The simulation's worker threads are now kept ready and woken all at once, instead of waking one another one by one several times a step. They rest when the game is paused, in menus and at normal speed.
- On the 8-hour test save, x16 in the real game went from about x11.9 to about x12.2.
- The game's results are exactly the same as before, on any number of threads.

## 22 Nov 2026: gun towers search far less (speed)
- A gun tower or station gun now checks the few hostile ships that exist directly, instead of searching the map around it every step, and a station with nothing in reach skips its guns altogether.
- On the 8-hour test save one simulation step went from about 1.36 to about 1.29 milliseconds in the test harness. Not yet measured in the game window.
- The game's results are exactly the same as before.

## 22 Nov 2026: crash fixed (advisor as chief of staff fires or replaces a manager)
- The game could crash when your advisor, acting as chief of staff, fired a station manager or replaced a temp with a new hire: later in the same review it still looked at the station of the manager who had just left. Fixed.
- Nothing else changes.

## 22 Nov 2026: groundwork for the next speed steps (no visible change)
- Inside the game, a station's or ship's stock can now only be changed through one small set of functions, and each change leaves a mark. Later speed steps use that mark to skip work when nothing changed.
- Nothing plays differently, and save files are unchanged.

## 22 Nov 2026: two more speed steps
- An explorer choosing where to patrol now scores only the chart cells that can still beat its best pick (about 250 of 11,700), and the check for set-aside wares no longer creates throwaway memory.
- Small gains: the periodic exploration pass costs about 40% less, and throwaway memory per step is halved.
- The game's results are exactly the same as before.

## 22 Nov 2026: x16 runs about a fifth faster in the game (a build setting)
- The game was built with a compiler setting switched off that slows long-running code. It is on now. On the 8-hour test save, x16 speed in the real game went from about x9.5 to about x11.4.
- The first seconds after starting the game may be slightly slower; after that it is faster.
- The game's results are exactly the same.

## 22 Nov 2026: station managers decide by their needs, not by fixed rules
- **Fixed rules removed from AI station managers.** Gone: the fixed order in which rules were checked, "farm first" for outposts, "only the hub builds the first producer of a ware", "outposts make only consumables", tiers in a fixed order, "wait and buy before building", the factory cap and per-ware caps, "guns first, then shields", "a hold only when the holds are nearly full", the fixed conditions for habitats and amenities, and the rule that a faction without Honour never joins an alliance. Every module a station can build is now a candidate, and the manager weighs it against its needs, its own character and its faction's culture.
- **A manager now reads things that stand as they are.** Its own guns, shields and hold space, and its money, are read as they are now, not as an average over the last half hour. Flows (food, wares per minute) and the threats it has seen keep the person's averaging. Before, a manager did not notice its own finished guns for half an hour and kept building.
- **Set-aside wares are no longer a station's to build with.** What the faction's shared money bought for a new station or a jump gate belongs to that site or gate, also while a constructor is loading it. Ships, refits, research, repairs and automatic defences leave it alone, and the manager says so: "Did not start a Corvette: the Steel here is held for a jump gate."
- **A station's manager no longer holds a site's own materials back from that same site.** It still keeps its own queue, its factories' inputs and its people's supplies.
- **Jump gates.** A faction that wants a gate and lacks the materials now has the shared money order them, like a new station's bill; before, a gate was only built from stock that happened to lie at the capital. The second gate of a pair costs half, and its materials are now ordered and checked at that price. If the first idle constructor cannot take the job, the next one is tried.
- **A new outpost's kit** is loaded from the station's own spare stock and the shared money pays the station for all of it, as it already does for a station's own goods given to a site.
- **Said, not hidden.** Your advisor lists every ware a gate still waits for, each with its reason ("the pool is buying it, but no seller you know has 20 Hull Parts to spare"). When an AI site is abandoned, the faction head's briefing says why. "Nothing it can build now would help it" now gives the real reason. The Stock tab says what its "per minute" figure counts and what it leaves out (supply runs, trade and building). "Defences: very short (no shield)" no longer shows when shields cannot be built yet.
- Factions still differ by their sliders, with no rule order: in four test games traders built 1 to 2 guns a station and 5 to 7 warships, militarists 4 to 7 guns and 2 to 3 warships. Nobody went hungry or untreated.
- Save format 39. Older saves still load. The game plays differently from the last build: managers decide differently.

## 22 Nov 2026: long games faster again (x16, steps 11 to 13)
- A station's cargo-hold packing is built once and reused for every ware in a row of "is there room?" questions, and a station's chart snapshot is worked out once per scan pass.
- On the 8-hour test save one simulation step is now about 1.37 milliseconds on average and 1.08 on a typical step (8.5 at the start). x16 needs about 0.9; more follows.
- The game's results are exactly the same as before.

## 22 Nov 2026: long games faster again (x16, steps 6 to 10)
- Settings, "Simulation threads: Automatic" now follows your machine (one worker per processor core, leaving two threads free) instead of stopping at 4. The label shows the number really in use.
- Ships no longer plan a whole route to learn that no shortcut exists, miners find their nearest asteroid without walking hundreds of empty chart cells, and sensors update a known station's chart entry in place.
- On the 8-hour test save one simulation step is now about 1.45 milliseconds (1.65 in the last build, 8.5 at the start). x16 needs about 0.9; more follows.
- The game's results are exactly the same as before.

## 22 Nov 2026: long games faster again (x16, steps 3 to 5)
- A station's guns, sensor range and reach are now worked out only when its modules, people or shortages change, not every step. Sensors read a station's for-sale list in one pass, and miners share the answer to "which asteroids are near home".
- On the 8-hour test save one simulation step is now about 1.65 milliseconds (it was 2.25 two builds ago and 8.5 at the start). x16 needs about 0.9; more follows.
- The game's results are exactly the same as before.

## 22 Nov 2026: long games faster again (x16, new approach, steps 1 and 2)
- New approach: the simulation stops re-working answers whose inputs did not change. A station's cargo-hold packing is redone only when its stock changes, and an AI shipyard re-decides what to build only when something it depends on changes.
- On the 8-hour test save one simulation step went from about 2.25 to about 1.88 milliseconds (16% faster). x16 needs about 0.9; more steps of this kind follow.
- The game's results are exactly the same as before.

## 22 Nov 2026: x16 fix, steps 4 and 5
- Station guns now pick their targets on several processor cores at once, and a station's staffing figures are looked up from a table.
- These two are small: on the 8-hour test save they are worth a few percent. Measured in the real game on that save, x16 speed now runs at about x6, where it ran at about x1.5 before this series of fixes.
- The game's results are exactly the same as before.

## 21 Nov 2026: long games run a little faster again (x16 fix, steps 2 and 3)
- An AI shipyard choosing what to build no longer creates throwaway memory every step, and a station's "does it sell anything?" check stops at the first ware it finds.
- On the same 8-hour test save one simulation step went from about 2.6 to about 2.2 milliseconds: x16 speed reaches about x7.4 there. Still not full x16.
- The game's results are exactly the same as before.

## 21 Nov 2026: long games run faster (first step of the x16 fix)
- In a long game, stations whose cargo holds carry ware lists made every "is there room for this ware?" question re-work the whole packing of that station's holds, hundreds of times a step. The answer is now remembered until something it depends on changes.
- On an 8-hour test save one simulation step went from about 8.5 to about 2.6 milliseconds, so x16 speed now reaches about x6.5 there instead of about x2. Full x16 needs more; the next steps follow.
- The game's results are exactly the same as before.

## 21 Nov 2026: 100 behaviour numbers moved into the settings files
- One hundred numbers that shape what AI factions, station managers, CEOs and your advisor decide were written into the code. They are now in the settings files (tuning.json), with the same values, so a mod can change them. The game plays exactly as before.
- A new check stops such numbers being written into the code again.

## 21 Nov 2026: going without food or medicine now hurts a station
- **Weak:** people who are hungry or untreated work worse. Staffed modules work at down to 60% with no food and down to 80% with no medicine.
- **Angry:** people left without food, without medicine or unpaid grow angry, and angry people work worse too (down to 70%). It fades when the cause is put right. A hungry, angry crew works at about 42%.
- **Leave:** as before, and you now get a news line when the first people leave because of hunger.
- **Die:** after 10 minutes with no food people start to die of hunger; after 20 minutes with no medicine, of disease. Deaths are counted apart from people leaving.
- **The manager:** a crew that stays angry threatens its manager's life. If the cause is not put right, it may carry the threat out; a temp then takes over the station.
- Each of these shows with its cause on the Staff drawer, in the manager's briefing, in your advisor's lines and in the news. Missing power is unchanged.
- Save format 38. Older saves still load.

## 21 Nov 2026: managers and your advisor say what they do, what they do not do, and why
- A manager's briefing now says why a short need got no action, in its own terms: "Did not build a Small Water Purifier: not worth it yet - it would cost 272 cr, more than what it would fill is worth to me now". A line that keeps repeating is folded into one ("Still: ... (since 0:12)").
- Its needs are given in game minutes ("Food Rations lasts about 90 min"), and a decision names the trait that shaped it ("thinks ahead: plans 2 steps ahead; warm: weighs the people's needs higher").
- Your advisor writes an entry at every review, also when it does nothing, with the time of the next review. It keeps listing every station that is short of something for as long as that lasts.
- The Staff drawer shows the real change in population and its cause ("no growth, about 1 leaving every 2 min (hungry)"). Going without food, medicine or power shows in red, also in the Empire list, and there is a news line for it.
- Nothing about what they decide has changed.

## 21 Nov 2026: managers can secure food, medicine and power
- A station manager can now see the way to its first Water: when the people need a Food Farm or Pharma Lab and the station has no Water, a Water Purifier is offered first. Before, neither was ever started from a bare start, even with Ice in the hold.
- A missing shield no longer marks a station's defences as "very short" while shields cannot be built yet. Managers used to answer that by adding gun after gun.
- The Energy Cells that factories burn now count when a manager looks ahead at its stock.
- The Stock tab's "per minute" and "runs out" figures, and "out in N min" in the drawers, were about ten times off at the shipped pace. They now show game minutes.

## 21 Nov 2026: the Research screen is drawn by ELK
- The technology tree is now laid out by the ELK layout engine: one graph, columns by depth, every prerequisite a line with its own lane and arrow. The branch is the colour strip on each box, named in the legend above the tree.
- Each box says how many things it unlocks. Picking a technology brightens its whole chain.
- A technology that nothing requires (Turret Mounts) no longer says "leads to nothing": the side panel lists the technologies it unlocks things together with, and they get a pink outline.

## 21 Nov 2026: gas clouds are back in games started from the New game page
- Games started from the New game page had no gas clouds at all, whatever the Gas clouds setting said, and the line beside it read "This world has no gas clouds." Every map type now gets its clouds again, and the line says how many.

## 21 Nov 2026: station guns from the start; more senseless prerequisites removed
- A station's Gun Battery needs no research any more. It costs 120 credits, Hull Parts 6, Engine Parts 1 and Superalloys 2 per size step, all wares you can make without research. Tiny, Small and Medium from the first minute; Large needs Heavy Hulls, bigger needs Capital Hulls.
- The "Gun Batteries" technology is gone. Station Shields now needs Shield Manufacturing and Advanced Electronics; Defence Platforms needs Advanced Electronics. The Laser Tower still needs Point Defence.
- 13 more prerequisite links are removed: Rail Accelerators - Heavy Hulls; Plasma Containment - Reactive Shields; Beam Focusing, Phase Shields and Fusion Drives - Advanced Modules; Drone Control - Guided Missiles; Repair Drones, Salvage Rigs and Advanced Modules - Automated Yards; Battle Jammers - Deep-space Sensors; Jump Gates - Long-range Scanners; Medical Bays - Field Repair; Heavy Torpedoes - Missile Manufacturing.
- AI factions can build station guns from the start too.

## 21 Nov 2026: Research screen: no empty columns, no cut names
- Picking a technology no longer draws lines to other branches (they looped around the boxes). Those prerequisites are outlined where they stand and named on the box and in the side panel.
- Each branch now starts at the left edge; the tree is three columns wide and fits without sideways scrolling.
- A technology's name is always shown whole. The "needs" line shows whole names, then "+N more".
- The lines between direct neighbours are redone: short, one arrow per prerequisite. Other prerequisites are written on the box.

## 21 Nov 2026: the Diplomacy page shows who a faction is at war with
- Select a faction on the Diplomacy page (F1): a line under its name says "At war with: ..." with each enemy's name, or "AT WAR WITH YOU" first if that is so, or "Not at war with anyone you know of". Click an enemy's name to select it.
- The faction list marks every faction that is in a war you know of.
- Only factions you have met are named.

## 21 Nov 2026: research prerequisites that made no sense are removed
- Entertainment Decks and Medical Bays no longer need Hydroponics.
- Mass Driver Doctrine, Directed Energy Doctrine, Guided Missiles, Missile Warfare Doctrine and Point Defence no longer need Turret Mounts. Mass Driver Doctrine had no other prerequisite, so it can now be researched from the start.

## 21 Nov 2026: one list of built modules
- A station's Build tab no longer repeats the list of built modules. They are listed once, under MODULES, grouped ("Cargo Hold (Small) x2") with the docking bays.

## 21 Nov 2026: News settings
- Settings has a **News...** page (it was "Pause for news..."). Every kind of news has three controls: **Show**, **Sound** and **Pause**.
- Show Off keeps that kind out of the News list; it then plays no sound and cannot pause the game.
- Sound: "Usual" (what the game always played), None, or one of seven sounds; picking one plays it once.
- "Salvage recovered" is off to start with. Every other kind behaves as before.

## 21 Nov 2026: the Market shows what a station will sell
- The STOCK column is now FOR SALE: how much a station will actually part with, as your ships last saw it. What it keeps for its own factories and builds is left out.
- A ware it will not sell shows "-" with no price, greyed. The "Sells" sort puts those rows last. A station charted in an older save shows "?" until a ship sees it again.
- The trade route preview uses the same seen amounts and prices, so the list and the route agree. If the station has less when you start the route, the message says so.
- Save format 37. Older saves still load.

## 21 Nov 2026: more ice
- Ordinary rocks hold four times as much Ice as before, so there is Ice near every start (about 12% of the ore there, was 3%).
- An ice field is now about 90% Ice and holds about twice the ore of any other field.
- Where the ice fields lie, and how many there are, is unchanged.

## 21 Nov 2026: the Research screen shows what a technology needs
- The tree runs left to right: everything a technology needs is to its left. Lines no longer run under other boxes and end in an arrow.
- Point at or click a technology: its whole chain of prerequisites stays bright (green = known, amber = missing), what it leads to is outlined blue, the rest dims.
- The side panel starts with NEEDS and LEADS TO; click a line to jump to that technology.
- Hold the right mouse button on the tree and drag to move it. The wheel and the arrow buttons still work.

## 21 Nov 2026: the Advisor tab is tidied
- The advice ("Recommends and waiting on you") comes first. The advisor's cut, the steering switches and the other factions' CEOs fold away; each folded header says the current state in a few words.
- The Show button works now: it selects the station the line is about and centres the map on it. You answer a manager's request there, on the station's Info tab under Manager.
- A request for a ware the asking station makes itself now reads "It is no longer needed: the station makes it itself now", not as a refusal.

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
