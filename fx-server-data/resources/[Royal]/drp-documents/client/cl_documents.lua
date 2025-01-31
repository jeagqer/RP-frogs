--[[
    Functions
]]

function GetClosestPlayers(coords, distance)
    local players = {}
    local currentID = PlayerId()
    for _, playerID in ipairs(GetActivePlayers()) do
        local playerCoords = GetEntityCoords(GetPlayerPed(playerID))
        if #(coords - playerCoords) <= distance and playerID ~= currentID then
            table.insert(players, GetPlayerServerId(playerID))
        end
    end
    return players
end

function CreateNewForm(aDocument)
    aDocument.headerFirstName = exports["isPed"]:isPed("firstname")
    aDocument.headerLastName = exports["isPed"]:isPed("lastname")
    aDocument.headerDateOfBirth = exports["isPed"]:isPed("dob")
    aDocument.headerJobLabel = aDocument.job or exports["isPed"]:isPed("myjob")

    if aDocument.job then
        aDocument.job = nil
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "createNewForm",
        data = aDocument
    })
end

function ViewDocument(aDocument)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "ShowDocument",
        data = aDocument,
    })
end

function ShowDocument(aDocument)
    local players = GetClosestPlayers(GetEntityCoords(PlayerPedId()), 2.0)

    for i, v in ipairs(players) do
        TriggerServerEvent("drp-documents:showDocument", v, aDocument)
    end

    TriggerEvent("DoLongHudText", "Document shown for " .. #players .. " player(s)")
end

function CopyDocument(aDocument)
    local players = GetClosestPlayers(GetEntityCoords(PlayerPedId()), 2.0)

    for i, v in ipairs(players) do
        TriggerServerEvent("drp-documents:copyDocument", v, aDocument)
    end

    TriggerEvent("DoLongHudText", "Document copied to " .. #players .. " player(s)")
end

function DeleteDocument(id)
    if not id then return end

    local deleted = RPC.execute("drp-documents:deleteDocument", id)
    if deleted then
        TriggerEvent("drp-documents:openDocuments")
    end
end

--[[
    Events
]]

RegisterCommand('doctest', function()
 TriggerEvent("drp-documents:openDocuments")
  end)

RegisterNetEvent("drp-documents:openDocuments")
AddEventHandler("drp-documents:openDocuments", function()
    local data = {}

    local publicdocuments = {}
    for i, v in ipairs(Config["Documents"]["public"]) do
        table.insert(publicdocuments, {
            title = v.headerTitle,
            description = "",
            action = "drp-documents:CreateNewForm",
            params = v,
        })
    end

    table.insert(data, {
        title = "Public Documents",
        description = "",
        children = publicdocuments,
    })

    local job = exports["isPed"]:isPed("myjob")
    if Config["Documents"]["Jobs"][job] then
        local jobdocuments = {}
        for i, v in ipairs(Config["Documents"]["Jobs"][job]) do
            table.insert(jobdocuments, {
                title = v.headerTitle,
                description = "",
                action = "drp-documents:CreateNewForm",
                params = v,
            })
        end

        table.insert(data, {
            title = "Job Documents",
            description = "",
            children = jobdocuments,
        })
    end

    local mydocuments = {}
    local _mydocuments = RPC.execute("drp-documents:getDocuments", "cid", exports["isPed"]:isPed("cid"))
    for i, v in ipairs(_mydocuments) do
        local actions = {
            { title = "View", action = "drp-documents:ViewDocument", params = v.data },
            { title = "Show", action = "drp-documents:ShowDocument", params = v.data },
            { title = "Copy", action = "drp-documents:CopyDocument", params = v.data },
            { title = "Delete", children = {
                { title = "Confirm Delete", action = "drp-documents:DeleteDocument", params = v.id },
            } },
        }

        table.insert(mydocuments, {
            title = v.data.headerTitle,
            description = "Date: " .. v.data.headerDateCreated,
            children = actions,
        })
    end

    table.insert(data, {
        title = "Personal Documents",
        description = "",
        children = mydocuments,
    })

    local groups = exports["isPed"]:isPed("passes")
    if #groups > 0 then
        local _groups = {}
        for i, v in ipairs(groups) do
            local groupdocuments = {}
            local _groupdocuments = RPC.execute("drp-documents:getDocuments", "group", v.group)
            for i2, v2 in ipairs(_groupdocuments) do
                local actions = {
                    { title = "View", action = "drp-documents:ViewDocument", params = v2.data },
                    { title = "Show", action = "drp-documents:ShowDocument", params = v2.data },
                    { title = "Copy", action = "drp-documents:CopyDocument", params = v2.data },
                }

              
                    table.insert(actions, {
                        title = "Delete", children = {
                            { title = "Confirm Delete", action = "drp-documents:DeleteDocument", params = v2.id },
                        }
                    })
             

                table.insert(groupdocuments, {
                    title = v2.data.headerTitle,
                    description = "Date: " .. v2.data.headerDateCreated,
                    children = actions,
                })
            end

            table.insert(_groups, {
                title = v.name,
                description = "",
                children = groupdocuments,
            })
        end

        table.insert(data, {
            title = "My Group Documents",
            description = "",
            children = _groups,
        })
    end

    exports["drp-context"]:showContext(data)
end)

RegisterNetEvent("drp-documents:CreateNewForm")
AddEventHandler("drp-documents:CreateNewForm", CreateNewForm)

RegisterNetEvent("drp-documents:ViewDocument")
AddEventHandler("drp-documents:ViewDocument", ViewDocument)

RegisterNetEvent("drp-documents:ShowDocument")
AddEventHandler("drp-documents:ShowDocument", ShowDocument)

RegisterNetEvent("drp-documents:CopyDocument")
AddEventHandler("drp-documents:CopyDocument", CopyDocument)

RegisterNetEvent("drp-documents:DeleteDocument")
AddEventHandler("drp-documents:DeleteDocument", DeleteDocument)

--[[
    NUI
]]

RegisterNUICallback("form_close", function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback("form_submit", function(data, cb)
    SetNuiFocus(false, false)

    local callback = nil
    if data.callback then
        callback = data.callback
        data.callback = nil
    end

    local cid = exports["isPed"]:isPed("cid")
    local group = nil

    if data.group then
        group = data.group
        data.group = nil
    end

    for i, v in ipairs(data.elements) do
        v.can_be_edited = false
    end

    RPC.execute("drp-documents:submitDocument", data, cid, group)

    if callback then
        TriggerEvent(callback.event, callback.params)
    end
end)