--OFFSET MOMENT!!!
local dad = {
    ['SEx'] = {
        x = 0,
        y = 750
    }
}
local bf = {
    ['bf-encore'] = {
		x = 0,
        y = 500
    }
}
local gf = {
    ['Dos'] = {
		x = 0,
        y = 1500
    }
}


function onCreatePost()
    geFlect()
end
function onEvent(n,v1,v2)
    if n == 'Change Character' then
        prepareStuff()
    end
end
function geFlect()
    local gfx, gfy = gf[gfName] and gf[gfName].x, gf[gfName] and gf[gfName].y
    local dadx, dady = dad[dadName] and dad[dadName].x, dad[dadName] and dad[dadName].y
    local bfx, bfy = bf[boyfriendName] and bf[boyfriendName].x, bf[boyfriendName] and bf[boyfriendName].y
    runHaxeCode([[
    reflectBF = new Boyfriend(game.boyfriend.x + ]]..bfx..[[, game.boyfriend.y + ]]..bfy..[[, ']]..boyfriendName..[[');
    game.addBehindBF(reflectBF);

    reflectGF = new Character(game.gf.x + ]]..gfx..[[, game.gf.y + ]]..gfy..[[, ']]..gfName..[[');
    game.addBehindDad(reflectGF);

    reflectDad = new Character(game.dad.x + ]]..dadx..[[, game.dad.y + ]]..dady..[[, ']]..dadName..[[');
    game.addBehindDad(reflectDad);

    reflectDad.alpha = 0.5;
    reflectDad.flipY = true;

    reflectBF.alpha = 0.5;
    reflectBF.flipY = true;

    reflectGF.alpha = 0.5;
    reflectGF.flipY = true;

    reflectBF.visible = game.bf.visible;
    reflectGF.visible = game.reflectGF.visible;
    reflectDad.visible = game.reflectDad.visible;

    ]])
end
function prepareStuff()
    runHaxeCode([[
        game.remove(reflectBF);
        game.remove(reflectGF);
        game.remove(reflectDad);
    ]])
    runTimer('stuffPrepared',0.1)
end
function onTimerCompleted(t)
    if t == 'stuffPrepared' then
        geFlect()
    end
end
function onUpdatePost()
    runHaxeCode([[
        reflectBF.animation.copyFrom(game.boyfriend.animation);
        reflectBF.animation.curAnim.curFrame = game.boyfriend.animation.curAnim.curFrame;
        if (reflectBF.animation.curAnim.name == 'singDOWN')
        {
            reflectBF.offset.set(game.boyfriend.animOffsets.get(game.boyfriend.animation.curAnim.name)[0], game.boyfriend.animOffsets.get(game.boyfriend.animation.curAnim.name)[1] * -0.05);
        }
        else
        {
            reflectBF.offset.set(game.boyfriend.animOffsets.get(game.boyfriend.animation.curAnim.name)[0], game.boyfriend.animOffsets.get(game.boyfriend.animation.curAnim.name)[1] * 0.1);
        }

        reflectDad.animation.copyFrom(game.dad.animation);
        reflectDad.animation.curAnim.curFrame = game.dad.animation.curAnim.curFrame;
        if (reflectDad.animation.curAnim.name == 'singDOWN')
        {
            reflectDad.offset.set(game.dad.animOffsets.get(game.dad.animation.curAnim.name)[0], game.dad.animOffsets.get(game.dad.animation.curAnim.name)[1] * -0.05); 
        }
        else
        {
            reflectDad.offset.set(game.dad.animOffsets.get(game.dad.animation.curAnim.name)[0], game.dad.animOffsets.get(game.dad.animation.curAnim.name)[1] * 0.1);
        }

        reflectGF.animation.copyFrom(game.gf.animation);
        reflectGF.animation.curAnim.curFrame = game.gf.animation.curAnim.curFrame;
        reflectGF.offset.set(game.gf.animOffsets.get(game.gf.animation.curAnim.name)[0], game.gf.animOffsets.get(game.gf.animation.curAnim.name)[1]);
    ]])
end