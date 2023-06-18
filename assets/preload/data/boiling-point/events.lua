--i was going to do this in game but my stupid ass kept deleting the events so i had to do it here for convenience -frogb

local shityourself = false
local krillyourshelf = false

function onBeatHit(elapsed)
    if shityourself then
        if curBeat % 1 == 0 then
            triggerEvent('Add Camera Zoom', '', '')
        end
    end

    if krillyourshelf then
        if curBeat % 2 == 0 then
            triggerEvent('Add Camera Zoom', '', '')
        end
    end

    if curBeat == 288 then
        shityourself = false;
    end
    if curBeat == 292 then
        shityourself = true;
    end
    if curBeat == 552 then
        shityourself = false;
    end
end

function onSongStart()
    shityourself = true;
end