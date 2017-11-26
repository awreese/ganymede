# Astrorush: TBD (The Best Defense)
Originally conceived as my University of Washington Games Capstone Project, I've continued working on it after graduation.

# Game Summary
Gather your forces and test your fortitude against a rising threat.  Command your fleets from planet to planet, capturing enemy strongholds, protecting home worlds, and avoiding perilous dangers in the open expanse of inter-planetary space.

# Original Team Members (Contributers)
* [Drew Reese](https://github.com/awreese)
* [Daisy Xu](https://github.com/xdaisy)
* [Rory Soiffer](https://github.com/Weirdbob95)

# Play Online (* demo)
* [newgrounds.com](http://www.newgrounds.com/portal/view/693430 "AstroRush") *
* [gamejolt.com](http://gamejolt.com/games/astrorush/258084 "AstroRush") *
* [itch.io](https://dazeforever.itch.io/astrorush "AstroRush") *
* [kongregate.com](http://www.kongregate.com/games/manydazelater/astrorush "AstroRush") *

# Future Features/In-progress
- Game Play
    - [ ] Game Map Upgrade
        - [ ] Upgraded graph implementation
            - [x] Pre-calculated shortest paths
            - [ ] Ship movements based on stored paths
            - [ ] Possibly allow 'one-way' edges
            - [ ] Possibly allow for different types of edges
        - [ ] Game Levels
            - [ ] Option 1: Stored as JSON files (current way)
            - [ ] Option 2: Stored in Database table (preferred way)
            - [ ] Game map level parser
    - [ ] Ships
        - [ ] Use database to store ship 'blueprints'
        - [ ] Change ship movements
            - [ ] 'Slowish' at object nodes
            - [ ] Align for 'warping' along edges
        - [ ] Better ship graphics
    - [ ] Node Objects
        - [ ] Use database to store object 'blueprints'
        - [ ] Capturables
            - [ ] Planets
                - [ ] Better planet graphics
                - [ ] Planet HUD
            - [ ] Beacons/Power-Ups
        - [ ] Hazards
    - [ ] Different Game Modes
        - [ ] Speed mode (closely resembles current play style)
        - [ ] Campaign/Story mode
- UI/UX
    - [ ] Create game menu HUD
        - [ ] Toggle sound on/off
        - [ ] Control volume
        - [ ] Pause game
