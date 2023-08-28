if CLIENT then
-- Отключение стандартных худов
    local hideHUD = {
        ["CHudHealth"] = true,
        ["CHudBattery"] = true,
        ["DarkRP_Hungermod"] = true,
    }

    surface.CreateFont("Roboto-Bold", {
        font = "Roboto-Bold",
        size = 50,  -- Размер шрифта
        weight = 500,
        antialias = true,
        additive = false,
    })

    surface.CreateFont("LobsterFont", {
        font = "LobsterFont",
        size = 21,  -- Размер шрифта
        weight = 500,
        antialias = true,
        additive = false,
    })

    surface.CreateFont("Roboto-Bold-2", {
        font = "Roboto-Bold",
        size = 30,  -- Размер шрифта
        weight = 500,
        antialias = true,
        additive = false,
    })

    local lastHealth = 100
    local residualHealth = 0
    local damageAlpha = 0
    local damageAlphaDecay = 200
    local damageFadeSpeed = 10


    local hp_icon = Material("materials/health.png")
    local ar_icon = Material("materials/armor.png")
    local hg_icon = Material("materials/hunger.png")

    hook.Add("HUDShouldDraw", "HideDefaultHUD", function(name)
        if hideHUD[name] then return false end
    end)

    local function DrawHealthBar(health, x, y, width, height)
        local maxHealth = 100
        local healthPercentage = math.min(health / maxHealth, 1)
        local healthBarWidth = width * healthPercentage
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawOutlinedRect(x - 1, y - 1, width + 2, height + 2)
        surface.SetDrawColor(0, 0, 0, 150)
        surface.DrawRect(x, y, width, height)
        surface.SetDrawColor(247, 53, 40, 255)
        surface.DrawRect(x, y, healthBarWidth, height)
    end

    local function DrawArmorBar(armor, x, y, width, height)
        local maxArmor = 100
        local armorPercentage = math.min(armor / maxArmor, 1)
        local armorBarWidth = width * armorPercentage
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawOutlinedRect(x - 1, y - 1, width + 2, height + 2)
        surface.SetDrawColor(0, 0, 0, 150)
        surface.DrawRect(x, y, width, height)
        surface.SetDrawColor(46, 144, 144, 255)
        surface.DrawRect(x, y, armorBarWidth, height)
    end
    

    hook.Add("HUDPaint", "MyHUD", function()
        
        local ply = LocalPlayer()
        if not IsValid(ply) then return end

        local health = ply:Health()
        local armor = ply:Armor()

        local hunger = ply:getDarkRPVar("Energy") or 0 
-- Здоровье
        local healthWidth = 300
        local healthHeight = 24
        local healthX = 10
        local healthY = ScrH() - 65
-- Армор
        local armorWidth = 300
        local armorHeight = 24
        local armorX = 10
        local armorY = ScrH() - 89
-- Голод
        local hungerWidth = 300
        local hungerHeight = 24
        local hungerX = 10
        local hungerY = ScrH() - 40

        local moneyX = ScrW() - 200
        local moneyY = ScrH() - 50

        local healthBarWidth = healthWidth * health / 100

        if health < lastHealth then
            residualHealth = lastHealth - health
            damageAlpha = 255
        else
            residualHealth = math.max(residualHealth - FrameTime() * damageFadeSpeed, 0)
            damageAlpha = math.max(damageAlpha - FrameTime() * damageAlphaDecay, 0)
        end
        lastHealth = health

        if damageAlpha > 0 then
            local damageBarWidth = healthWidth * residualHealth / 100

            local damageColor = Color(255, 255, 255, damageAlpha)
            surface.SetDrawColor(damageColor)
            surface.DrawRect(healthX + healthBarWidth, healthY, damageBarWidth, healthHeight)
        end

        DrawHealthBar(health, healthX, healthY, healthWidth, healthHeight)
        DrawArmorBar(armor, armorX, armorY, armorWidth, armorHeight)

        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawOutlinedRect(hungerX - 1, hungerY - 1, hungerWidth + 2, hungerHeight + 2)

        surface.SetDrawColor(0, 0, 0, 150)
        surface.DrawRect(hungerX, hungerY, hungerWidth, hungerHeight)

        local hungerBarWidth = hungerWidth * hunger / 100
        surface.SetDrawColor(0, 153, 0, 255)
        surface.DrawRect(hungerX, hungerY, hungerBarWidth, hungerHeight)

        surface.SetFont("LobsterFont")
        surface.SetTextColor(255, 255, 255, 255)
        surface.SetTextPos(healthX + healthWidth - 40, healthY)
        surface.DrawText(health)

        surface.SetTextPos(healthX + healthWidth - 290, healthY)
        surface.DrawText('Здоровье')

        surface.SetTextPos(armorX + armorWidth - 40, armorY)
        surface.DrawText(armor)

        surface.SetTextPos(armorX + armorWidth - 290, armorY)
        surface.DrawText('Броня')

        surface.SetTextPos(hungerX + hungerWidth - 40, hungerY)
        surface.DrawText(hunger)

        surface.SetTextPos(hungerX + hungerWidth - 290, hungerY)
        surface.DrawText('Сытость')

        surface.SetFont("Roboto-Bold")
        surface.SetTextColor(255, 255, 255, 255)
-- Работа
        local jobX = 1
        local jobY = ScrH() - 150
        local job = ply:getDarkRPVar("job") or "Неизвестный"
        surface.SetTextPos(jobX + 10, jobY)
        surface.DrawText(job)
-- Деньги
        local money = DarkRP.formatMoney(ply:getDarkRPVar("money") or 0)
        surface.SetFont("Roboto-Bold-2")
        surface.SetTextColor(255, 255, 255, 255)
        surface.SetTextPos(moneyX - 1370 , moneyY + 10)
        surface.DrawText(money)

-- Иконка здоровья
        local iconSize = 24
        surface.SetDrawColor(255, 255, 255, 255)  -- Установка цвета для текстуры
        surface.SetMaterial(hp_icon)  -- Установка используемой текстуры
        surface.DrawTexturedRect(healthX - iconSize + 330, healthY, iconSize, iconSize)

-- Иконка армора
        local iconSize = 24
        surface.SetDrawColor(255, 255, 255, 255)  -- Установка цвета для текстуры
        surface.SetMaterial(ar_icon)  -- Установка используемой текстуры
        surface.DrawTexturedRect(armorX - iconSize + 330, armorY, iconSize, iconSize)

-- Иконка голода
        local iconSize = 24
        surface.SetDrawColor(255, 255, 255, 255)  -- Установка цвета для текстуры
        surface.SetMaterial(hg_icon)  -- Установка используемой текстуры
        surface.DrawTexturedRect(hungerX - iconSize + 330, hungerY, iconSize, iconSize)

    end)
end
