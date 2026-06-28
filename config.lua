Config = {}

-- ============================================================
-- GENERAL SETTINGS
-- ============================================================
Config.SearchTime   = 6000   -- search duration (ms)
Config.Cooldown     = 1800   -- refill after X seconds (content is SHARED between players)
Config.CutChance    = 8      -- % chance to cut yourself on debris while searching
Config.CutDamage    = 5      -- cut damage (HP)

-- ============================================================
-- SEARCHABLE PROP TYPES
-- One block = one type. Everything is in the same place:
--   icon / action : look of the ox_target option
--   slots / weight: container size (weight in grams)
--   maxItems      : max number of different item types rolled per reset
--   empty         : % chance the container is EMPTY on a reset
--   loot          : { 'item', chance, min_qty, max_qty }
--                   chance = draw weight (higher = more frequent)
--   models        : the prop models for this type
--
-- ADD A PROP -> put it in the right type's "models", 2 ways:
--   * vanilla prop : its name in backticks, e.g. `prop_bin_01a`
--   * custom/streamed prop : its HASH (the number from /lootprop), e.g. -502202673
-- ADD A TYPE : copy a block and change loot + models.
-- /!\ Every "item" must exist in ox_inventory/data/items.lua
-- ============================================================
Config.Types = {

    -- SMALL street bin: little loot, mostly junk
    trash = {
        icon = 'fa-solid fa-trash-can', action = 'Search the trash',
        slots = 4, weight = 8000, maxItems = 2, empty = 10,
        loot = {
            { 'megot', 40, 1, 4 },            { 'chiffon_sale', 35, 1, 2 },
            { 'chips_rassis', 25, 1, 1 },     { 'restes_burger', 22, 1, 1 },
            { 'ferraille_rouillee', 18, 1, 2 }, { 'conserve_perimee', 14, 1, 1 },
            { 'eau_croupie', 12, 1, 1 },      { 'telephone_casse', 3, 1, 1 }, { 'vieille_cle', 2, 1, 1 },
        },
        models = {
            `prop_bin_01a`, `prop_bin_02a`, `prop_bin_03a`, `prop_bin_04a`, `prop_bin_05a`, `prop_bin_06a`,
            `prop_bin_07a`, `prop_bin_07b`, `prop_bin_07c`, `prop_bin_07d`, `prop_bin_08a`, `prop_bin_08open`,
            `prop_bin_09a`, `prop_bin_10a`, `prop_bin_10b`, `prop_bin_11a`, `prop_bin_11b`, `prop_bin_12a`,
            `prop_bin_13a`, `prop_bin_13b`, `prop_bin_14a`, `prop_bin_14b`,
            -- CUSTOM TRASH: paste the /lootprop hash here if it's a SMALL bin
        },
    },

    -- MEDIUM recycling container: materials & crafting
    container = {
        icon = 'fa-solid fa-recycle', action = 'Search the container',
        slots = 8, weight = 18000, maxItems = 3, empty = 5,
        loot = {
            { 'ferraille_rouillee', 40, 1, 3 }, { 'chiffon_sale', 30, 1, 2 }, { 'serflex', 25, 1, 2 },
            { 'planche_pourrie', 22, 1, 2 },    { 'fil_cuivre', 20, 1, 2 },   { 'megot', 20, 1, 3 },
            { 'composants_elec', 16, 1, 2 },    { 'conserve_perimee', 14, 1, 1 },
            { 'telephone_casse', 5, 1, 1 },     { 'bandage_fortune', 4, 1, 1 },
        },
        models = {
            `prop_recyclebin_01a`, `prop_recyclebin_02_c`, `prop_recyclebin_02_d`, `prop_recyclebin_02a`, `prop_recyclebin_02b`,
            `prop_recyclebin_03_a`, `prop_recyclebin_04_a`, `prop_recyclebin_04_b`, `prop_recyclebin_05_a`,
            -- CUSTOM CONTAINER: paste the /lootprop hash here if it's a MEDIUM one
        },
    },

    -- LARGE dumpster: big loot, sometimes vehicle parts
    dumpster = {
        icon = 'fa-solid fa-dumpster', action = 'Search the dumpster',
        slots = 12, weight = 40000, maxItems = 4, empty = 0,
        loot = {
            { 'ferraille_rouillee', 38, 1, 3 }, { 'planche_pourrie', 25, 1, 3 }, { 'chiffon_sale', 25, 1, 2 },
            { 'serflex', 20, 1, 2 },            { 'fil_cuivre', 18, 1, 2 },      { 'composants_elec', 16, 1, 2 },
            { 'conserve_perimee', 14, 1, 2 },   { 'restes_burger', 12, 1, 1 },   { 'outil_rouille', 6, 1, 1 },
            { 'bandage_fortune', 6, 1, 1 },     { 'telephone_casse', 4, 1, 1 },
            { 'veh_pneu', 4, 1, 1 },            { 'veh_portiere', 3, 1, 1 },     { 'veh_phare', 3, 1, 1 },
            { 'veh_batterie', 2, 1, 1 },        { 'carcasse', 0.2, 1, 1 },
        },
        models = {
            `prop_dumpster_01a`, `prop_dumpster_02a`, `prop_dumpster_02b`, `prop_dumpster_3a`, `prop_dumpster_4a`, `prop_dumpster_4b`,
            -- CUSTOM DUMPSTER: paste the /lootprop hash here if it's a LARGE one
        },
    },

    -- Store shelves / fridges / counters: mostly food & drinks
    shelf = {
        icon = 'fa-solid fa-box-open', action = 'Search the shelf',
        slots = 8, weight = 15000, maxItems = 4, empty = 10,
        loot = {
            { 'chips_rassis', 45, 1, 3 },     { 'restes_burger', 35, 1, 2 },
            { 'conserve_perimee', 35, 1, 2 }, { 'eau_croupie', 40, 1, 2 },
            { 'alcool_fortune', 25, 1, 1 },   { 'bandage_fortune', 6, 1, 1 },
        },
        models = {
            `v_ret_247shelf01`, `v_ret_247shelf02`, `v_ret_247shelf03`, `v_ret_247shelf04`, `v_ret_247shelf05`, `v_ret_247shelf06`, `v_ret_247shelf07`,
            `v_ret_247shelves02`, `v_ret_247shelves03`, `v_ret_247shelves04`,
            `v_ret_ml_shelf1`, `v_ret_ml_shelf2`, `v_ret_ml_shelf3`, `v_ret_ml_shelf4`,
            `v_ret_gc_shelf01`, `v_ret_gc_shelf02`, `v_ret_ta_shelf1`, `v_ret_ta_shelf2`, `v_ret_ta_shelf3`,
            `v_ret_fridgesnack01`, `v_ret_fridgesnack02`, `v_ret_csr_fridge01`, `v_ret_csr_sweets01`, `v_ret_csr_sweets02`, `v_ret_csr_juice01`,
            `v_ret_ml_chips`, `v_ret_ml_chocl`, `v_ret_ml_beerfridg`,
            `prop_fooddisp_01`, `prop_fooddisp_02`, `prop_fooddisp_03`,
            `v_ret_247_counter`, `prop_till_01`, `prop_till_02`, `prop_till_03`,
        },
    },

    -- Soda machine (eCola): drinks ONLY, and VERY rare
    soda_machine = {
        icon = 'fa-solid fa-bottle-water', action = 'Search the soda machine',
        slots = 2, weight = 4000, maxItems = 1, empty = 85,
        loot = { { 'eau_croupie', 75, 1, 1 }, { 'alcool_fortune', 25, 1, 1 } },
        models = { `prop_ecola_machine`, `prop_ecola_machine_2`, `prop_fizzy_dispenser` },
    },

    -- Water points: fountains, coolers, water dispensers
    water_point = {
        icon = 'fa-solid fa-faucet-drip', action = 'Fill a bottle',
        slots = 2, weight = 3000, maxItems = 1, empty = 40,
        loot = { { 'eau_croupie', 92, 1, 2 }, { 'alcool_fortune', 8, 1, 1 } },
        models = { `prop_watercooler`, `prop_watercooler_dark`, `p_watercooler_s`, `prop_vend_water_01`, `prop_wall_vending_01` },
    },

    -- Vending machines (soda, snacks, coffee): often empty/broken
    vending = {
        icon = 'fa-solid fa-cookie-bite', action = 'Force the vending machine',
        slots = 4, weight = 6000, maxItems = 2, empty = 55,
        loot = {
            { 'chips_rassis', 30, 1, 2 },     { 'restes_burger', 18, 1, 1 },
            { 'conserve_perimee', 16, 1, 1 }, { 'eau_croupie', 26, 1, 1 }, { 'alcool_fortune', 10, 1, 1 },
        },
        models = { `prop_vend_soda_01`, `prop_vend_soda_02`, `prop_vend_snak_01`, `prop_vend_snak_01_tu`, `prop_vend_coffe_01`, `prop_vend_fridge01` },
    },

    -- Weapon / ammo / military crates
    -- /!\ TODO: replace this loot with YOUR weapon/ammo item IDs
    weapon_crate = {
        icon = 'fa-solid fa-box-archive', action = 'Open the crate',
        slots = 6, weight = 25000, maxItems = 2, empty = 35,
        loot = {
            { 'ferraille_rouillee', 38, 1, 3 }, { 'composants_elec', 26, 1, 2 },
            { 'fil_cuivre', 22, 1, 2 },         { 'outil_rouille', 10, 1, 1 }, { 'kit_medical_militaire', 3, 1, 1 },
        },
        models = { `prop_box_ammo03a`, `prop_box_ammo04a`, `prop_box_ammo05a`, `prop_box_ammo07a`, `prop_box_ammo08a`, `prop_mil_crate_01`, `prop_gun_case_01`, `prop_ld_case_01` },
    },

    -- First-aid kits / medicine cabinets / medical bags
    first_aid = {
        icon = 'fa-solid fa-kit-medical', action = 'Search the first-aid kit',
        slots = 4, weight = 5000, maxItems = 2, empty = 35,
        loot = {
            { 'bandage_fortune', 60, 1, 2 },  { 'kit_medical_militaire', 12, 1, 1 },
            { 'conserve_perimee', 14, 1, 1 }, { 'eau_croupie', 14, 1, 1 },
        },
        models = {
            `prop_ld_health_pack`, `prop_med_first_aid`, `v_med_cor_medvend`, `prop_fa_kit_01`,
            `prop_med_bag_01`, `prop_med_bag_01b`,  -- vanilla medical bags
            -502202673,                             -- custom/streamed medical bag (hash from /lootprop)
        },
    },

    -- Toolboxes / workbenches: tools + vehicle parts (lh_vehiclecraft)
    toolbox = {
        icon = 'fa-solid fa-screwdriver-wrench', action = 'Search the toolbox',
        slots = 10, weight = 40000, maxItems = 3, empty = 25,
        loot = {
            { 'outil_rouille', 30, 1, 1 },      { 'fil_cuivre', 25, 1, 2 },    { 'composants_elec', 20, 1, 2 },
            { 'serflex', 18, 1, 2 },            { 'ferraille_rouillee', 25, 1, 3 }, { 'planche_pourrie', 15, 1, 2 },
            { 'veh_pneu', 6, 1, 1 },            { 'veh_portiere', 4, 1, 1 },   { 'veh_phare', 4, 1, 1 },
            { 'veh_batterie', 3, 1, 1 },        { 'veh_capot', 2, 1, 1 },      { 'veh_radiateur', 2, 1, 1 },
            { 'veh_moteur', 0.5, 1, 1 },        { 'carcasse', 0.2, 1, 1 },
        },
        models = { `prop_toolchest_01`, `prop_toolchest_02`, `prop_toolchest_03`, `prop_toolchest_04`, `prop_toolchest_05`, `prop_tool_box_01`, `prop_tool_box_02`, `prop_tool_box_03`, `prop_tool_box_04` },
    },

    -- Mailboxes
    mailbox = {
        icon = 'fa-solid fa-envelope', action = 'Check the mail',
        slots = 3, weight = 3000, maxItems = 1, empty = 50,
        loot = {
            { 'megot', 30, 1, 2 },        { 'chiffon_sale', 22, 1, 1 }, { 'vieille_cle', 12, 1, 1 },
            { 'telephone_casse', 8, 1, 1 }, { 'composants_elec', 6, 1, 1 },
        },
        models = { `prop_postbox_01a`, `prop_mailbox_01` },
    },

    -- Bags, suitcases, backpacks: mixed survival loot
    bag = {
        icon = 'fa-solid fa-suitcase-rolling', action = 'Search the bag',
        slots = 5, weight = 8000, maxItems = 2, empty = 30,
        loot = {
            { 'chiffon_sale', 30, 1, 2 },     { 'conserve_perimee', 22, 1, 1 }, { 'eau_croupie', 22, 1, 1 },
            { 'bandage_fortune', 18, 1, 1 },  { 'telephone_casse', 10, 1, 1 },  { 'vieille_cle', 10, 1, 1 },
            { 'composants_elec', 10, 1, 1 },  { 'alcool_fortune', 8, 1, 1 },    { 'megot', 12, 1, 2 },
        },
        models = {
            `hei_prop_heist_dufflebag`, `prop_cs_heist_bag_01`, `prop_cs_heist_bag_02`, `prop_big_bag_01`, `prop_ld_bag_01`,
            `prop_suitcase_01`, `prop_suitcase_01b`, `prop_suitcase_02`, `prop_suitcase_03`, `prop_suitcase_poor`,
            `prop_ld_suitcase_01`, `prop_ld_suitcase_02`, `prop_ld_suitcase_03`, `prop_cs_suitcase_01`, `prop_cs_suitcase_03`,
            `p_michael_backpack_s`, `prop_mil_rucksack_01`,
        },
    },

    -- Lockers, cabinets, dressers, drawers: household odds and ends
    locker = {
        icon = 'fa-solid fa-door-closed', action = 'Search the locker',
        slots = 6, weight = 12000, maxItems = 2, empty = 30,
        loot = {
            { 'chiffon_sale', 28, 1, 2 },   { 'bandage_fortune', 18, 1, 1 }, { 'vieille_cle', 12, 1, 1 },
            { 'telephone_casse', 10, 1, 1 }, { 'conserve_perimee', 18, 1, 1 }, { 'fil_cuivre', 16, 1, 2 },
            { 'composants_elec', 14, 1, 1 }, { 'outil_rouille', 10, 1, 1 },   { 'alcool_fortune', 8, 1, 1 },
        },
        models = {
            `prop_ld_locker_01`, `prop_ld_locker_02`, `prop_ld_locker_03`, `prop_ld_locker_04`,
            `gr_prop_gr_locker_01a`, `gr_prop_gr_locker_04a`, `v_ind_cs_lockerunit`,
            `prop_drawer_01`, `prop_drawer_02`, `prop_drawer_03`, `prop_drawer_04`,
        },
    },

    -- Cardboard boxes, packages, wooden crates: materials / misc
    cardboard = {
        icon = 'fa-solid fa-box', action = 'Search the box',
        slots = 6, weight = 15000, maxItems = 2, empty = 25,
        loot = {
            { 'chiffon_sale', 26, 1, 2 },     { 'ferraille_rouillee', 28, 1, 3 }, { 'planche_pourrie', 20, 1, 2 },
            { 'serflex', 18, 1, 2 },          { 'composants_elec', 16, 1, 2 },    { 'conserve_perimee', 16, 1, 1 },
            { 'fil_cuivre', 14, 1, 2 },
        },
        models = {
            `prop_cardbordbox_01a`, `prop_cardbordbox_02a`, `prop_cardbordbox_03a`, `prop_cardbordbox_04a`, `prop_cardbordbox_05a`, `prop_cardbordbox_06a`,
            `prop_boxpile_01a`, `prop_boxpile_02a`, `prop_boxpile_06a`, `prop_boxpile_07d`,
            `prop_box_wood01a`, `prop_box_wood02a`, `prop_box_wood04a`, `prop_box_wood05a`,
        },
    },

    -- Fridges, microwaves, ovens: food / drinks
    fridge = {
        icon = 'fa-solid fa-utensils', action = 'Search the fridge',
        slots = 5, weight = 10000, maxItems = 2, empty = 35,
        loot = {
            { 'chips_rassis', 30, 1, 2 },     { 'restes_burger', 24, 1, 1 }, { 'conserve_perimee', 26, 1, 2 },
            { 'eau_croupie', 28, 1, 2 },      { 'alcool_fortune', 14, 1, 1 },
        },
        models = {
            `prop_fridge_01`, `prop_fridge_02`, `prop_fridge_03`, `prop_fridge_04`,
            `v_res_fridge_de`, `v_res_fh_fridge`, `v_res_mfridgedoor`,
            `prop_micro_01`, `v_res_microwave`, `v_res_mbcooker`,
        },
    },

    -- Barrels, jerry cans, drums: scrap / chemicals / alcohol
    barrel = {
        icon = 'fa-solid fa-oil-can', action = 'Search the barrel',
        slots = 3, weight = 20000, maxItems = 1, empty = 40,
        loot = {
            { 'ferraille_rouillee', 32, 1, 3 }, { 'composants_elec', 18, 1, 1 }, { 'chiffon_sale', 20, 1, 2 },
            { 'fil_cuivre', 16, 1, 2 },         { 'alcool_fortune', 14, 1, 1 },
        },
        models = {
            `prop_barrel_01a`, `prop_barrel_02a`, `prop_barrel_03a`, `prop_barrel_03b`,
            `prop_oil_drum_01`, `prop_oil_barrel`, `prop_jerrycan_01a`, `prop_gas_tank_01a`,
        },
    },
}

-- Fast lookup model -> type name (built once on load)
Config.TypeByModel = {}
for name, t in pairs(Config.Types) do
    for _, model in ipairs(t.models) do
        Config.TypeByModel[model] = name
    end
end
