DOTex = DOTex or {}

DOTex.tex = getTexture("media/textures/blast_n.png")
DOTex.alpha = 0.9
DOTex.speed = 0.05
DOTex.screenWidth = getCore():getScreenWidth()
DOTex.screenHeight = getCore():getScreenHeight()

DOTex.Blast = function()
    if not isIngameState() then return end
    if DOTex.alpha == 0 then return end

    local player = getSpecificPlayer(0)
    if player == nil then return end

    -- if not player:isOutside() then return end

    local speed = DOTex.speed * getGameSpeed()
    local zoom = 1
    -- local zoom = getCore():getZoom(player:getPlayerNum())
    -- zoom = PZMath.clampFloat(zoom, 0.0, 1.0)

    local alpha = DOTex.alpha
    if alpha > 1 then alpha = 1 end

    UIManager.DrawTexture(DOTex.tex, 0, 0, DOTex.screenWidth * zoom, DOTex.screenHeight * zoom, alpha)
    
    DOTex.alpha = DOTex.alpha - speed
    if DOTex.alpha < 0 then DOTex.alpha = 0 end
end

DOTex.SizeChange = function (n, n2, x, y)
    DOTex.screenWidth = x
    DOTex.screenHeight = y
end

Events.OnPreUIDraw.Add(DOTex.Blast)
Events.OnResolutionChange.Add(DOTex.SizeChange)
