function main()
    totalbinds = 0
    binds = {}
    characterASCIICODE = {
        [0] = 48,
        [1] = 49,
        [2] = 50,
        [3] = 51,
        [4] = 52, 
        [5] = 53,
        [6] = 54,
        [7] = 55,
        [8] = 56,
        [9] = 57,
        a = 65, b = 66, c = 67, d = 68, e=69, f=70, g=71, h=72, i=73, j=74, k=75, l=76, m=77, n=78, o=79, p=80, q=81, r=82, s=83, t=84, u = 85, v = 86, w = 87, x= 88, y=89, z=90     
    }
    repeat wait(100) until isSampAvailable()
    sampAddChatMessage("Jerry's Key Binder - Zombie Survival 51.89.188.191:7777", 0x00BBFF)
    sampAddChatMessage("CMD: /setbind [cmd] [key=a-z/0-9]", 0x0099EE)
    loadBinds()
    sampRegisterChatCommand("setbind", setBind)
    sampRegisterChatCommand("clearbinds", clearBinds)
    sampRegisterChatCommand("savebinds", saveBinds)
    sampRegisterChatCommand("showbinds", showBinds)
    sampRegisterChatCommand("loadbinds", loadBinds)
    while true do
        wait(0)
        result = not (sampIsChatInputActive() or sampIsDialogActive() or sampIsCursorActive())
        if result then
            for key, bind in pairs(binds) do
                if isKeyDown(bind[1]) then
                    if not bind[2] then
                        bind[2] = true
                        sampSendChat(string.format(key))
                    end
                end
                if wasKeyReleased(bind[1]) then
                    bind[2] = false
                end
            end
        end

    end
end

function setBind(str)
    if #str < 1 then
        sampAddChatMessage("ERROR: Please use a single letter between {00FF00}A-Z or 0-9.", 0xDD3322)
        sampAddChatMessage("CMD: /setbind [cmd] [key=a-z/0-9]", 0xAAAAAA)
        return
    end
    beginIndex = string.find(str, " ")
    cmd = string.sub(str, 1, beginIndex-1)
    binder = string.sub(str, beginIndex+1)
    if (#binder ~= 1) or (#cmd < 1) then
        sampAddChatMessage("ERROR: Please use a single letter between {00FF00}A-Z or 0-9.", 0xDD3322)
        sampAddChatMessage("CMD: /setbind [cmd] [key=a-z/0-9]", 0xAAAAAA)
        return
    end
    addKeybind(cmd, binder)
end

-- function removeBind(index){

-- }

function addKeybind(cmd, binder)

    -- Setting KeyCode > Checking if its a string or a number.
    if tonumber(binder) == nil then -- its a string
        -- do this
        keyCode = characterASCIICODE[string.lower(binder)]
        if keyCode == nil then
            sampAddChatMessage("ERROR: Keybind {FFFFFF}".. binder .. "{DD3322} does not exist. Please use {FFFFFF}A-Z or 0-9.", 0xDD3322)
            sampAddChatMessage("CMD: /setbind [cmd] [key=a-z/0-9]", 0xAAAAAA)
            return
        end
    else -- its a number

        keyCode = characterASCIICODE[tonumber(binder)]
    end
    if binds[cmd] == nil then
        totalbinds = totalbinds + 1
    end
    binds[cmd] = {tonumber(keyCode), false}
    sampAddChatMessage("Keybinder : CMD {0066AA}".. cmd .. "{FFFFFF} to key {0066AA}" .. binder .. "{FFFFFF}. Keycode: {0066AA}" .. keyCode, 0xFFFFFF)

end

function clearBinds()
    binds = {}
    sampAddChatMessage("{FFFFFF}Keybinder : {00FF00}Binds cleared!", 0x00FF00)
end

function saveBinds()
    local file = io.open("./MoonLoader/saveBinds.txt", "w")
    if not file then
        sampAddChatMessage("ERROR: Could not open file to save binds.", 0xDD3322)
        return
    end
    for key, bind in pairs(binds) do
        file:write(key .. ":" .. bind[1] .. "\n")
    end
    file:close()
    sampAddChatMessage("{FFFFFF}Keybinder : {00FF00}Binds saved!", 0x00FF00)
end

function loadBinds()
    local file = io.open("./MoonLoader/saveBinds.txt", "r")
    if not file then
        sampAddChatMessage("ERROR: Could not open file to load binds.", 0xDD3322)
        return
    end
    local addBind = file:read("*line")
    while not(addBind==nil) do
        local breakIndex = string.find(addBind, ":")
        local key = string.sub(addBind, 1, breakIndex - 1)
        local bind = string.sub(addBind, breakIndex + 1)
        binds[key] = {tonumber(bind), false}
        totalbinds = totalbinds + 1
        addBind = file:read("*line")
    end
    sampAddChatMessage("Loaded your last saved ".. totalbinds .." keybinds!", 0x003377)
    file:close()
end

function showBinds()
    sampAddChatMessage("Command  :  Keybind", 0xFFFFFF)
    local counter = 0;
    for key, bind in pairs(binds) do
        sampAddChatMessage(counter+1 .. ". " .. key .. "  :  " .. bind[1], 0x0066AA)
        counter = counter + 1
    end
    sampAddChatMessage("You have " .. totalbinds .. " binds.", 0x0055FF)

end


