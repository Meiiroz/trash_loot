--[[ ============================================================
  ITEMS FOR loot_poubelles
  ------------------------------------------------------------
  COPY-PASTE the block below INTO the file:
      ox_inventory/data/items.lua
  ... just before the last closing brace  }  (inside the `return {`).

  Then (optional) add a .png image per item in:
      ox_inventory/web/images/<item_id>.png

  Finally: restart ox_inventory  then  restart loot_poubelles
  and type "loottest" in the server console to verify.

  NB: the 7 consumable items (food/drink/medical) call a script
  function through client.export = 'loot_poubelles.<id>'.
  If you use a hunger/thirst system (ox), you can add a field
  client.status = { hunger = 200000 } for example.
============================================================ ]]

-- ----- MATERIALS / CRAFTING -----
['chiffon_sale'] = {
    label = 'Dirty Rag', weight = 50, stack = true, close = false,
    description = 'A filthy piece of cloth. Always handy.'
},
['ferraille_rouillee'] = {
    label = 'Rusty Scrap', weight = 800, stack = true, close = false,
    description = 'Salvaged metal, eaten by rust.'
},
['serflex'] = {
    label = 'Zip Tie', weight = 20, stack = true, close = false,
    description = 'A plastic cable tie.'
},
['planche_pourrie'] = {
    label = 'Rotten Plank', weight = 600, stack = true, close = false,
    description = 'Damp, worm-eaten wood.'
},
['fil_cuivre'] = {
    label = 'Copper Wire', weight = 100, stack = true, close = false,
    description = 'Stripped copper, great for tinkering.'
},
['composants_elec'] = {
    label = 'Electronic Components', weight = 150, stack = true, close = false,
    description = 'Chips and circuits ripped from a device.'
},
['outil_rouille'] = {
    label = 'Rusty Tool', weight = 700, stack = true, close = false,
    description = 'An old tool that still (sort of) works.'
},
['megot'] = {
    label = 'Cigarette Butt', weight = 5, stack = true, close = false,
    description = 'A leftover smoke. Despair has a taste.'
},
['vieille_cle'] = {
    label = 'Old Key', weight = 30, stack = true, close = false,
    description = 'A rusty key. Opens what? A mystery.'
},
['telephone_casse'] = {
    label = 'Broken Phone', weight = 200, stack = true, close = false,
    description = 'Cracked screen, but salvageable parts.'
},

-- ----- FOOD / DRINK (consumables) -----
['chips_rassis'] = {
    label = 'Stale Chips', weight = 80, stack = true, close = true,
    description = 'Soft, but still edible.',
    client = { export = 'loot_poubelles.chips_rassis' }
},
['restes_burger'] = {
    label = 'Burger Leftovers', weight = 150, stack = true, close = true,
    description = 'Cold and questionable. Eat at your own risk.',
    client = { export = 'loot_poubelles.restes_burger' }
},
['conserve_perimee'] = {
    label = 'Expired Can', weight = 400, stack = true, close = true,
    description = 'The date is... long gone. Fills you up or kills you.',
    client = { export = 'loot_poubelles.conserve_perimee' }
},
['eau_croupie'] = {
    label = 'Stagnant Water', weight = 500, stack = true, close = true,
    description = 'Murky and warm. Better than nothing?',
    client = { export = 'loot_poubelles.eau_croupie' }
},
['alcool_fortune'] = {
    label = 'Moonshine', weight = 600, stack = true, close = true,
    description = 'Homemade liquor. It burns.',
    client = { export = 'loot_poubelles.alcool_fortune' }
},

-- ----- MEDICAL (consumables) -----
['bandage_fortune'] = {
    label = 'Makeshift Bandage', weight = 100, stack = true, close = true,
    description = 'Cloth and hope. (+25 HP)',
    client = { export = 'loot_poubelles.bandage_fortune' }
},
['kit_medical_militaire'] = {
    label = 'Military Medkit', weight = 500, stack = true, close = true,
    description = 'Pre-collapse gear. (+80 HP)',
    client = { export = 'loot_poubelles.kit_medical_militaire' }
},

-- ----- VEHICLE PARTS (lh_vehiclecraft) -----
['veh_pneu'] = {
    label = 'Tire', weight = 8000, stack = true, close = false,
    description = 'A worn but usable tire.'
},
['veh_portiere'] = {
    label = 'Car Door', weight = 12000, stack = true, close = false,
    description = 'A dented car door.'
},
['veh_phare'] = {
    label = 'Headlight', weight = 1500, stack = true, close = false,
    description = 'A salvaged headlight unit.'
},
['veh_batterie'] = {
    label = 'Car Battery', weight = 9000, stack = true, close = false,
    description = 'A half-charged car battery.'
},
['veh_capot'] = {
    label = 'Hood', weight = 15000, stack = true, close = false,
    description = 'A bent hood.'
},
['veh_radiateur'] = {
    label = 'Radiator', weight = 6000, stack = true, close = false,
    description = 'A leaky but repairable radiator.'
},
['veh_moteur'] = {
    label = 'Engine', weight = 30000, stack = false, close = false,
    description = 'A complete engine block. Heavy and rare.'
},
['carcasse'] = {
    label = 'Vehicle Wreck', weight = 50000, stack = false, close = false,
    description = 'A whole wreck. The scrapper jackpot.'
},
