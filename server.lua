-- ============================================================
-- SEARCH — server side
-- Content is SHARED between players (first come, first served).
-- Random refill every Config.Cooldown seconds.
-- ============================================================

local stashes = {} -- [stashId] = { filledAt = timestamp }

local function CoordKey(c)
    return ('poubelle_%d_%d_%d'):format(
        math.floor(c.x + 0.5), math.floor(c.y + 0.5), math.floor(c.z + 0.5))
end

-- Rolls up to t.maxItems different items, weighted by their "chance" (draw without replacement)
local function RollLoot(t)
    if t.empty and t.empty > 0 and math.random(100) <= t.empty then
        return {} -- empty container this reset
    end

    local pool, total = {}, 0
    for _, l in ipairs(t.loot) do
        pool[#pool + 1] = l
        total = total + l[2]
    end

    local found = {}
    for _ = 1, t.maxItems do
        if #pool == 0 then break end
        local roll, acc = math.random() * total, 0
        for i, l in ipairs(pool) do
            acc = acc + l[2]
            if roll <= acc then
                found[#found + 1] = { item = l[1], count = math.random(l[3], l[4]) }
                total = total - l[2]
                table.remove(pool, i)
                break
            end
        end
    end
    return found
end

lib.callback.register('loot_poubelles:fouiller', function(source, coords, model)
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return false end

    -- Anti-cheat: the player must be close
    if #(GetEntityCoords(ped) - vector3(coords.x, coords.y, coords.z)) > 5.0 then
        return false
    end

    local t = Config.Types[Config.TypeByModel[model] or 'trash'] or Config.Types.trash
    local stashId = CoordKey(coords)

    -- First search: register the stash (mark BEFORE to avoid a double registration)
    if not stashes[stashId] then
        stashes[stashId] = { filledAt = 0 }
        pcall(function()
            exports.ox_inventory:RegisterStash(stashId, t.action, t.slots, t.weight, false, false)
        end)
    end

    -- Small chance to cut yourself
    if math.random(100) <= (Config.CutChance or 0) then
        TriggerClientEvent('loot_poubelles:coupure', source, Config.CutDamage)
    end

    -- Reset: refill if the cooldown has elapsed
    if os.time() - stashes[stashId].filledAt >= (Config.Cooldown or 1800) then
        stashes[stashId].filledAt = os.time()
        pcall(function() exports.ox_inventory:ClearInventory(stashId) end)
        for _, it in ipairs(RollLoot(t)) do
            pcall(function()
                if exports.ox_inventory:Items(it.item) then
                    exports.ox_inventory:AddItem(stashId, it.item, it.count)
                else
                    print(('^1[loot_poubelles] UNKNOWN ITEM: "%s" (add it to ox_inventory/data/items.lua)^0'):format(it.item))
                end
            end)
        end
    end

    pcall(function() TriggerEvent('loot_poubelles:fouillee', source, coords, stashId) end)
    return stashId
end)

-- ============================================================
-- HAND-MARKED SHELVES (map-geometry props that can't be targeted)
-- Saved via KVP, shared with everyone. Commands: /addshelf /delshelf
-- ============================================================
local SHELF_KVP = 'loot_etageres'
local shelfPoints = {}
do
    local raw = GetResourceKvpString(SHELF_KVP)
    if raw then
        local ok, decoded = pcall(json.decode, raw)
        if ok and type(decoded) == 'table' then shelfPoints = decoded end
    end
end

local function saveShelves()
    SetResourceKvp(SHELF_KVP, json.encode(shelfPoints))
end

-- Only admin / staff may mark a shelf
local function canEdit(src)
    if IsPlayerAceAllowed(src, 'command') then return true end
    if GetResourceState('lh_staff') == 'started' then
        local ok, r = pcall(function() return exports.lh_staff:estStaff(src) end)
        if ok and r == true then return true end
    end
    return false
end

lib.callback.register('loot_poubelles:getEtageres', function()
    return shelfPoints
end)

RegisterNetEvent('loot_poubelles:addEtagere', function(pt)
    local src = source
    if not canEdit(src) then return end
    if type(pt) ~= 'table' or type(pt.x) ~= 'number' then return end
    shelfPoints[#shelfPoints + 1] = { x = pt.x, y = pt.y, z = pt.z, h = pt.h or 0.0 }
    saveShelves()
    TriggerClientEvent('loot_poubelles:newEtagere', -1, shelfPoints[#shelfPoints])
end)

RegisterNetEvent('loot_poubelles:delEtagere', function(coords)
    local src = source
    if not canEdit(src) then return end
    if type(coords) ~= 'table' or type(coords.x) ~= 'number' then return end
    local best, dist
    for i, p in ipairs(shelfPoints) do
        local d = #(vector3(coords.x, coords.y, coords.z) - vector3(p.x, p.y, p.z))
        if d < 3.5 and (not dist or d < dist) then best, dist = i, d end
    end
    if best then
        table.remove(shelfPoints, best)
        saveShelves()
        TriggerClientEvent('loot_poubelles:reloadEtageres', -1, shelfPoints)
    end
end)

-- ============================================================
-- DIAGNOSTIC: type "loottest" in the SERVER console
-- Checks that every item of every type exists in ox_inventory.
-- ============================================================
RegisterCommand('loottest', function(source)
    if source ~= 0 then return end
    local missing = 0
    for name, t in pairs(Config.Types) do
        for _, l in ipairs(t.loot) do
            if not exports.ox_inventory:Items(l[1]) then
                print(('^1  MISSING  %-22s  (type: %s)^0'):format(l[1], name))
                missing = missing + 1
            end
        end
    end
    if missing == 0 then
        print('^2[loot_poubelles] OK: all items exist.^0')
    else
        print(('^1[loot_poubelles] %d missing item(s) in ox_inventory/data/items.lua.^0'):format(missing))
    end
end, true)
