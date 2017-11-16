local files = {}

function AddHotfix(path)
    local time, errormsg = love.filesystem.getLastModified(path)

    if errormsg then
        print(errormsg)
    else
        files[#files + 1] = { path = path, time = time }
    end
end

function Hotfixing()
    for k, v in pairs(files) do
        local time, errormsg = love.filesystem.getLastModified(v.path)

        if errormsg then
            print(errormsg)
        else
            if time > v.time then
                v.time = time

                chunk = love.filesystem.load("source/Player.lua")
                chunk()
            end
        end
    end
end