local player = game.Players.LocalPlayer
local http = game:GetService("HttpService")
local webhook = "https://discord.com/api/webhooks/1535732398065717370/Zc2JCTOteQMWuyVUeAzcP69lt1g5gWxc0JXMajDCPnlY-wlYifealJAxQRgs_UuL827t"

local data = {
    content = "**ТЕСТ ВЕБХУКА**",
    embeds = {{
        title = player.Name,
        fields = {
            {name = "User ID", value = tostring(player.UserId)},
            {name = "Display Name", value = player.DisplayName},
            {name = "Статус", value = "Вебхук работает!"}
        },
        color = 65280
    }}
}

pcall(function()
    http:PostAsync(webhook, http:JSONEncode(data))
end)

print("Тест отправлен. Проверь Discord.")
