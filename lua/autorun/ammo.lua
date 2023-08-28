if CLIENT then
    -- Создание нового шрифта
    surface.CreateFont("Font", {
        font = "Roboto-Bold",
        size = 40,       -- Размер шрифта
        weight = 500,
        antialias = true,
        additive = false,
    })

    local hideAmmo = {
        ["CHudAmmo"] = true,
        ["CHudSecondaryAmmo"] = true,
    }

    hook.Add("HUDShouldDraw", "HideDefaultAmmoHUD", function(name)
        if hideAmmo[name] then return false end
    end)

    hook.Add("HUDPaint", "WeaponAmmoHUD", function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return end

        local weapon = ply:GetActiveWeapon()
        if not IsValid(weapon) then return end

        local ammoClip = weapon:Clip1()
        local ammoReserve = ply:GetAmmoCount(weapon:GetPrimaryAmmoType())


        local ammoText = ammoClip .. " / " .. ammoReserve

        local textWidth, textHeight = surface.GetTextSize(ammoText)

        local x = ScrW() - textWidth - 20
        local y = ScrH() - textHeight - 20

        draw.SimpleText(ammoText, "Font", x + textWidth / 2 - 40, y + textHeight / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end)
end
