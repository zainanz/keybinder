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
    showCommands()
    loadBinds()
    sampRegisterChatCommand("setbind", setBind)
    sampRegisterChatCommand("clearbinds", clearBinds)
    sampRegisterChatCommand("savebinds", saveBinds)
    sampRegisterChatCommand("showbinds", showBinds)
    sampRegisterChatCommand("loadbinds", loadBinds)
    sampRegisterChatCommand("removebind", removeBind)
    sampRegisterChatCommand("kbhelp", showCommands)
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

function showCommands()
    sampAddChatMessage("CMD: {0099FF}/setbind [cmd] [key=a-z/0-9] - {DDDDDD}Sets a bind.", 0xDDDDDD)
    sampAddChatMessage("CMD: {0099FF}/removebind {command} or /removebind {index} - {DDDDDD}Removes a specific bind.", 0xDDDDDD)
    sampAddChatMessage("CMD: {0099FF}/clearbinds - {DDDDDD}clears all your binds.", 0xDDDDDD)
    sampAddChatMessage("CMD: {0099FF}/showbinds - {DDDDDD}Shows all binds.", 0xDDDDDD)
    sampAddChatMessage("CMD: {0099FF}/savebinds - {DDDDDD}Saves all your binds.", 0xDDDDDD)
    sampAddChatMessage("CMD: {0099FF}/loadbinds - {DDDDDD}Reloads a saved bind.", 0xDDDDDD)
    sampAddChatMessage("CMD: {0099FF}/kbhelp - {DDDDDD}Shows keybinder commands.", 0xDDDDDD)

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

function removeBind(index_string)
    if binds[index_string] ~= nil then 
        binds[index_string] = nil
        totalbinds = totalbinds - 1
    else
        index = tonumber(index_string)
        if (index == nil or index > totalbinds) then
            sampAddChatMessage("ERROR: Incorrect Index or command.", 0xDD3322)
            sampAddChatMessage("TIP: Use /showbinds to find the index or command", 0xAAAAAA)
            sampAddChatMessage("Example: /removebind /ec or /removebind 1", 0x0099EE)
        else
            local tempCounter = 1
            for key, bind in pairs(binds) do
                if tempCounter == index then 
                    binds[key] = nil
                    totalbinds = totalbinds - 1
                end
                tempCounter = tempCounter + 1
            end 
        end
    end
end

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
    sampAddChatMessage("CMD: {0099FF}".. cmd .. "{FFFFFF} to key {0099FF}" .. binder .. "{FFFFFF}. Keycode: {0099FF}" .. keyCode, 0xFFFFFF)

end

function clearBinds()
    binds = {}
    sampAddChatMessage("{0099FF}INFO: {FFFFFF}Binds cleared!")
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
    sampAddChatMessage("{0099FF}INFO: {FFFFFF}Binds saved!")
end

function loadBinds()
    local file = io.open("./MoonLoader/saveBinds.txt", "r")
    if not file then
        sampAddChatMessage("ERROR: Could not open file to load binds.", 0xDD3322)
        return
    end
    local addBind = file:read("*line")
    totalbinds = 0
    while not(addBind==nil) do
        local breakIndex = string.find(addBind, ":")
        local key = string.sub(addBind, 1, breakIndex - 1)
        local bind = string.sub(addBind, breakIndex + 1)
        binds[key] = {tonumber(bind), false}
        totalbinds = totalbinds + 1
        addBind = file:read("*line")
    end
    sampAddChatMessage("INFO: Loaded {0099FF}".. totalbinds .."{DDDDDD} saved keybinds!", 0xDDDDDD)
    file:close()
end

function showBinds()
    local counter = 0;
    sampAddChatMessage("Index. Command : Key Code", 0x0099FF)

    for key, bind in pairs(binds) do
        sampAddChatMessage("{FFFFFF}" ..counter+1 .. ". {DDDDDD}" .. key .. "  :  " .. bind[1], 0x0066AA)
        counter = counter + 1
    end

end


