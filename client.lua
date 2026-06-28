-- ============================================================
-- SEARCH — client side
-- ============================================================

local searching = false

-- Notification (mrz_notify if present, otherwise native GTA feed)
local function notify(msg, kind)
    if GetResourceState('mrz_notify') == 'started' then
        exports['mrz_notify']:Notify(kind == 'error' and 'error' or 'info', 'Search', msg, 4000)
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(false, false)
    end
end

-- Custom progress bar (NUI). Returns true if finished, false if cancelled.
local function searchProgress(duration)
    local ped = PlayerPedId()
    local dict = 'amb@prop_human_bum_bin@idle_b'
    RequestAnimDict(dict)
    local tl = GetGameTimer() + 1000
    while not HasAnimDictLoaded(dict) and GetGameTimer() < tl do Wait(10) end
    if HasAnimDictLoaded(dict) then
        TaskPlayAnim(ped, dict, 'idle_d', 4.0, -4.0, duration, 1, 0, false, false, false)
    end

    SendNUIMessage({ action = 'potionShow', duration = duration, label = 'Searching…' })

    local startPos = GetEntityCoords(ped)
    local start = GetGameTimer()
    local cancelled = false
    while GetGameTimer() - start < duration do
        DisableControlAction(0, 21, true)  -- sprint
        DisableControlAction(0, 30, true)  -- move left/right
        DisableControlAction(0, 31, true)  -- move forward/back
        if IsControlJustPressed(0, 73) then cancelled = true; break end             -- X = cancel
        if #(GetEntityCoords(ped) - startPos) > 3.0 then cancelled = true; break end -- walked away
        Wait(0)
    end

    SendNUIMessage({ action = 'potionHide' })
    ClearPedTasks(ped)
    return not cancelled
end

-- Search an entity OR a coordinate (manually marked shelf) -> opens its stash
local function startSearch(entity, coordsOv, modelOv)
    if searching then return end
    local coords = coordsOv or (entity and entity ~= 0 and GetEntityCoords(entity)) or nil
    if not coords then return end

    -- GetEntityModel crashes on map geometry -> we guard it.
    -- Sentinel model 'prop_fooddisp_01' (= shelf type) for coordinate-based search.
    local model = modelOv
    if not model and entity and entity ~= 0 then
        local ok, m = pcall(GetEntityModel, entity)
        if ok and m and m ~= 0 then model = m end
    end
    model = model or `prop_fooddisp_01`

    searching = true
    if entity and entity ~= 0 then
        TaskTurnPedToFaceEntity(cache.ped, entity, 750)
        Wait(750)
    end

    if searchProgress(Config.SearchTime or 6000) then
        local stashId = lib.callback.await('loot_poubelles:fouiller', false, coords, model)
        if stashId then
            Wait(150)
            if not pcall(function() exports.ox_inventory:openInventory('stash', stashId) end) then
                notify('Could not open the container.', 'error')
            end
        else
            notify('Nothing to search (too far?).', 'error')
        end
    else
        notify('Search interrupted.', 'error')
    end
    searching = false
end

-- Register ALL prop types in ox_target (single pass)
CreateThread(function()
    while GetResourceState('ox_target') ~= 'started' do Wait(200) end
    for name, t in pairs(Config.Types) do
        exports.ox_target:addModel(t.models, {
            {
                name = 'loot_' .. name,
                icon = t.icon,
                label = t.action,
                distance = 2.0,
                onSelect = function(data) startSearch(data.entity) end,
            }
        })
    end
end)

-- ============================================================
-- COORDINATE-BASED SHELVES (map geometry -> marked by hand)
-- /addshelf : aim at a shelf and mark it (admin/staff)
-- /delshelf : remove the nearest marked shelf
-- ============================================================
local shelfZones = {}
local shelfCount = 0

local function createShelfZone(pt)
    if not pt or not pt.x then return end
    shelfCount = shelfCount + 1
    shelfZones[#shelfZones + 1] = exports.ox_target:addBoxZone({
        coords = vec3(pt.x + 0.0, pt.y + 0.0, pt.z + 0.0),
        size = vec3(1.5, 1.5, 1.6),
        rotation = (pt.h or 0.0) + 0.0,
        options = { {
            name = 'loot_shelf_pt_' .. shelfCount,
            icon = 'fa-solid fa-box-open',
            label = 'Search the shelf',
            distance = 2.2,
            onSelect = function() startSearch(nil, vec3(pt.x, pt.y, pt.z), `prop_fooddisp_01`) end,
        } },
    })
end

CreateThread(function()
    while GetResourceState('ox_target') ~= 'started' do Wait(500) end
    for _, pt in ipairs(lib.callback.await('loot_poubelles:getEtageres', false) or {}) do
        createShelfZone(pt)
    end
end)

RegisterNetEvent('loot_poubelles:newEtagere', createShelfZone)

RegisterNetEvent('loot_poubelles:reloadEtageres', function(pts)
    for _, zid in ipairs(shelfZones) do
        if zid then pcall(function() exports.ox_target:removeZone(zid) end) end
    end
    shelfZones = {}
    for _, pt in ipairs(pts or {}) do createShelfZone(pt) end
end)

-- Raycast from the camera (used by /addshelf and /lootprop)
local function aim(distance)
    local ped = PlayerPedId()
    local cam = GetGameplayCamCoord()
    local rot = GetGameplayCamRot(2)
    local rx, rz = math.rad(rot.x), math.rad(rot.z)
    local cosx = math.abs(math.cos(rx))
    local dir = vector3(-math.sin(rz) * cosx, math.cos(rz) * cosx, math.sin(rx))
    local dest = cam + dir * distance
    local ray = StartExpensiveSynchronousShapeTestLosProbe(cam.x, cam.y, cam.z, dest.x, dest.y, dest.z, 1 + 16, ped, 0)
    return GetShapeTestResult(ray) -- retval, hit, endCoords, surfaceNormal, entityHit
end

RegisterCommand('addshelf', function()
    local _, hit, endCoords = aim(9.0)
    if not hit or not endCoords then
        lib.notify({ type = 'error', description = 'Aim at a shelf (get closer).' })
        return
    end
    TriggerServerEvent('loot_poubelles:addEtagere',
        { x = endCoords.x + 0.0, y = endCoords.y + 0.0, z = endCoords.z + 0.0, h = GetEntityHeading(PlayerPedId()) + 0.0 })
    lib.notify({ type = 'success', description = 'Shelf marked (if you have permission).' })
end, false)

RegisterCommand('delshelf', function()
    local c = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('loot_poubelles:delEtagere', { x = c.x + 0.0, y = c.y + 0.0, z = c.z + 0.0 })
end, false)

-- ============================================================
-- DEBUG : /lootprop -> identifies the aimed prop (hash + lootable?)
-- ============================================================
RegisterCommand('lootprop', function()
    local _, hit, _, _, entHit = aim(20.0)

    local isProp, m = false, 0
    if entHit and entHit ~= 0 then
        local okE, exists = pcall(DoesEntityExist, entHit)
        if okE and exists then
            local okO, isObj = pcall(IsEntityAnObject, entHit)
            if okO and isObj then
                local okM, mm = pcall(GetEntityModel, entHit)
                if okM and mm and mm ~= 0 then isProp, m = true, mm end
            end
        end
    end

    if isProp then
        local typ = Config.TypeByModel[m]
        local txt = typ and ('YES -> ' .. typ) or 'NO'
        print(('^3[lootprop] PROP hash = %s | lootable = %s^7'):format(m, txt))
        lib.notify({ title = 'lootprop', description = ('hash: %s\nlootable: %s'):format(m, txt), duration = 9000 })
    elseif hit then
        print('^1[lootprop] MAP GEOMETRY (not a prop) -> use /addshelf (coordinate-based loot)^7')
        lib.notify({ type = 'warning', description = 'Map geometry (not a prop). Use /addshelf.', duration = 9000 })
    else
        lib.notify({ type = 'error', description = 'Nothing aimed at. Aim at the prop, closer.' })
    end
end, false)

-- Small cut on debris (triggered by the server)
RegisterNetEvent('loot_poubelles:coupure', function(damage)
    local ped = cache.ped
    SetEntityHealth(ped, math.max(101, GetEntityHealth(ped) - (damage or 5)))
    lib.notify({ title = 'Ouch!', description = 'You cut yourself on rusty debris...', type = 'error', icon = 'fa-solid fa-droplet' })
end)

-- ============================================================
-- USABLE ITEMS (referenced via client.export = 'loot_poubelles.<id>')
-- ============================================================
local function Heal(amount, message)
    local ped = cache.ped
    SetEntityHealth(ped, math.min(GetEntityMaxHealth(ped), GetEntityHealth(ped) + amount))
    lib.notify({ title = 'Healing', description = message, type = 'success', icon = 'fa-solid fa-kit-medical' })
end

-- Risky consumable: either it's fine, or it makes you sick (damage)
local function RiskyConsume(id, okMsg, sickChance, damage, sickMsg, sickIcon)
    exports(id, function(data)
        exports.ox_inventory:useItem(data, function(d)
            if not d then return end
            if math.random(100) <= sickChance then
                SetEntityHealth(cache.ped, math.max(101, GetEntityHealth(cache.ped) - damage))
                lib.notify({ title = 'Bad idea', description = sickMsg, type = 'error', icon = sickIcon })
            else
                lib.notify({ title = 'Yum', description = okMsg, type = 'inform' })
            end
        end)
    end)
end

exports('bandage_fortune', function(data)
    exports.ox_inventory:useItem(data, function(d) if d then Heal(25, 'The bandage holds... for now. (+25 HP)') end end)
end)
exports('kit_medical_militaire', function(data)
    exports.ox_inventory:useItem(data, function(d) if d then Heal(80, 'Pre-collapse gear. Good as new. (+80 HP)') end end)
end)

RiskyConsume('conserve_perimee', 'Tastes off, but it fills you up.', 15, 10,
    'That can was WAY past its date... (-10 HP)', 'fa-solid fa-skull-crossbones')
RiskyConsume('restes_burger', 'Cold and soggy, but edible. Today.', 25, 12,
    'That burger already had a tiny owner... (-12 HP)', 'fa-solid fa-bacteria')
RiskyConsume('eau_croupie', 'Warm and murky, but it hydrates.', 20, 8,
    'Your stomach violently protests. (-8 HP)', 'fa-solid fa-virus')

-- Safe consumable (basic food/drink)
local function Consume(id, message)
    exports(id, function(data)
        exports.ox_inventory:useItem(data, function(d)
            if d then lib.notify({ title = 'Consumed', description = message, type = 'inform' }) end
        end)
    end)
end

Consume('chips_rassis', 'Pre-collapse chips. Still (almost) crunchy.')
Consume('alcool_fortune', 'Burns your throat, but warms you up.')
