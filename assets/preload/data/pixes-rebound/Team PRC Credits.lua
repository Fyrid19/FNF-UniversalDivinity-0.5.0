--was going to do this in haxe but i forgor how :skull:
--frogb
function onCreatePost()
    makeLuaText('subtitle', 'Chart Part by FyriDev/Aura', 400, 445, 550)
    addLuaText('subtitle')
    setTextSize('subtitle', 30)
    setProperty('subtitle.alpha', 0)
    makeLuaText('subtitle2', 'Chart Part by crustai', 400, 445, 550)
    addLuaText('subtitle2')
    setTextSize('subtitle2', 30)
    setProperty('subtitle2.alpha', 0)
    makeLuaText('subtitle3', 'Chart Part by Lennym920\n(tweaked by FrogB)', 400, 445, 550)
    addLuaText('subtitle3')
    setTextSize('subtitle3', 30)
    setProperty('subtitle3.alpha', 0)
    makeLuaText('subtitle4', 'Chart Part by FrogB', 400, 445, 550)
    addLuaText('subtitle4')
    setTextSize('subtitle4', 30)
    setProperty('subtitle4.alpha', 0)
    if getPropertyFromClass('ClientPrefs', 'downScroll') == true then
        setProperty('subtitle.y', 165)
        setProperty('subtitle2.y', 165)
        setProperty('subtitle4.y', 165)
        setProperty('subtitle3.y', 165)
    end
    setTextFont('subtitle', 'comic.ttf')
    setTextFont('subtitle2', 'comic.ttf')
    setTextFont('subtitle3', 'comic.ttf')
    setTextFont('subtitle4', 'comic.ttf')
end

function onUpdate(elapsed)
    if curBeat == 40 then
        setProperty('subtitle.alpha', 0.01)
        doTweenAlpha('CREDIT 1', 'subtitle', 1, 0.5, 'linear')
    end

    if curBeat == 48 then
        doTweenAlpha('CREDIT 1 GO BYE', 'subtitle', 0, 2, 'linear')
    end

    if curBeat == 112 then
        setProperty('subtitle2.alpha', 0.01)
        doTweenAlpha('CREDIT 2', 'subtitle2', 1, 0.5, 'linear')
    end

    if curBeat == 120 then
        doTweenAlpha('CREDIT 2 GO BYE', 'subtitle2', 0, 2, 'linear')
    end

    if curBeat == 176 then
        setProperty('subtitle3.alpha', 0.01)
        doTweenAlpha('CREDIT 3', 'subtitle3', 1, 0.5, 'linear')
    end

    if curBeat == 184 then
        doTweenAlpha('CREDIT 3 GO BYE', 'subtitle3', 0, 2, 'linear')
    end

    if curBeat == 240 then
        setProperty('subtitle4.alpha', 0.01)
        doTweenAlpha('CREDIT 4', 'subtitle4', 1, 0.5, 'linear')
    end

    if curBeat == 248 then
        doTweenAlpha('CREDIT 4 GO BYE', 'subtitle4', 0, 2, 'linear')
    end
end
    