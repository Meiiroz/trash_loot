# loot_poubelles — Prop Looting (post-apo / zombie)

Prop looting for FiveM: trash bins, bags, lockers, fridges, vending machines,
crates, barrels, first-aid kits and more. Each prop opens a **shared stash**
(first come, first served) that **randomly refills** after a cooldown. Loot is
**logical**: vehicle parts in toolboxes, food in fridges, meds in first-aid
kits, and so on.

No command needed to play: **aim at a prop → search it**.

## Dependencies
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory)

## Installation
1. Put the folder in `resources/[script]/loot_poubelles`.
2. **Items**: open `ox_inventory_items.lua` (included), copy all of its content
   and paste it into `ox_inventory/data/items.lua` (inside the `return { ... }`).
   *(Optional: add a `.png` image per item in `ox_inventory/web/images/`.)*
3. Add `ensure loot_poubelles` to your `server.cfg`.
4. `restart ox_inventory` then `restart loot_poubelles`.
5. In the server console, type `loottest`: it should print
   `OK: all items exist`. Otherwise it lists the missing items.

## How it works
Everything is configured in **`config.lua`**. One block = one prop type:

```lua
trash = {
    icon = '...', action = 'Search the trash',   -- ox_target option look
    slots = 4, weight = 8000, maxItems = 2, empty = 10, -- size + behaviour
    loot = { { 'chiffon_sale', 40, 1, 2 }, ... },       -- { item, chance, min, max }
    models = { `prop_bin_01a`, ... },                   -- the props
},
```

| Field | Role |
|-------|------|
| `icon` / `action` | look of the ox_target option |
| `slots` / `weight` | container size (weight in grams) |
| `maxItems` | max number of different item types rolled per reset |
| `empty` | % chance the container is **empty** on a reset (0 = never empty) |
| `loot` | `{ 'item', chance, min_qty, max_qty }` — `chance` = draw weight |
| `models` | the list of prop models |

### Add a searchable prop
Put its model in the desired type's `models`, in **2 ways**:
- **Vanilla prop**: its name in backticks → `` `prop_toolchest_01` ``
- **Custom / streamed prop**: its **hash** (the number from `/lootprop`) → `-502202673`

> Tip: in game, aim at the prop and type **`/lootprop`**. It shows the hash and
> whether it is already lootable. If you see `MAP GEOMETRY`, it is non-targetable
> scenery → use `/addshelf` (coordinate-based loot).

### Add a new type
Copy a block, change `loot` and `models`. The client and server adapt
automatically (nothing else to touch).

## General settings (`config.lua`)
```lua
Config.SearchTime = 6000   -- search duration (ms)
Config.Cooldown   = 1800   -- refill after X seconds
Config.CutChance  = 8      -- % chance to cut yourself while searching
Config.CutDamage  = 5      -- cut damage (HP)
```

## Commands (admin / debug — optional)
| Command | Who | Role |
|---------|-----|------|
| `/lootprop` | everyone | identifies the aimed prop (hash + lootable?) |
| `/addshelf` | admin / staff | marks scenery (map geometry) as searchable, by coordinates |
| `/delshelf` | admin / staff | removes the nearest marked shelf |
| `loottest` | server console | checks that all loot items exist |

Shelves marked via `/addshelf` are **saved** (KVP) and shared.

## Items
The **25 items** used by the default loot are ready to use in
**`ox_inventory_items.lua`** (EN labels, weights, descriptions) — just paste
them into `ox_inventory/data/items.lua` (see Installation).

**7 are consumable** (effect handled by the script via `client.export`):
- Medical: `bandage_fortune` (+25 HP), `kit_medical_militaire` (+80 HP)
- Risky food/drink: `conserve_perimee`, `restes_burger`, `eau_croupie`
  (may make you sick)
- Plain food/drink: `chips_rassis`, `alcool_fortune`

> If you use a hunger/thirst system (ox), you can add a
> `client.status = { hunger = 200000 }` (or `thirst`) field to the food/drink items.

## Notes
- A prop's content is **shared**: if a player empties a bin, others find it
  empty until the next reset.
- `loottest` warns you in the console if a loot item is missing from ox_inventory.
- Item IDs and event names are kept in their original form for compatibility.
