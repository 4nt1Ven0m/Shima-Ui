
local Ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/4nt1Ven0m/Shima-Ui/main/UI.lua"))()
local Ui = Library

local LoadTime = tick()

local Loader = Library.CreateLoader(
    "Shima", 
    Vector2.new(300, 300)
)

local Window = Library.Window(
    "Shima", 
    Vector2.new(500, 620)
)

Window.SendNotification(
    "Normal", -- Normal, Warning, Error 
    "Press RightShift to open menu and close menu!", 
    10
)

Window.Watermark(
    "Text Here"
)
-- Window:Visible = true

-- // UI Main \\ --
local Tab1 = Window:Tab("Tab1")
local Section1 = Tab1:Section(
    "Section1", 
    "Left"
)


local players = {}
local Players = game:GetService("Players")
local Player = game:GetService("Players").LocalPlayer

local enabled = false
fillcolor = Color3.fromRGB(255,255,255)
outlinecolor = Color3.fromRGB(255,255,255)

--Functions
function createHighlight(adornee)
    local hightlight = Instance.new("Highlight")
    hightlight.OutlineTransparency = 0.5
    hightlight.FillTransparency = 0.05
    hightlight.Name = "E"
    hightlight.Adornee = adornee
    hightlight.FillColor = fillcolor
    hightlight.OutlineColor = outlinecolor
    hightlight.Parent = game:GetService("CoreGui")
end; function GetEnemyPlayers()
    players = {}
    if #game:GetService("Teams"):GetTeams() > 0 then
        local friendly = Player.Team.Name
        for i,v in pairs(game:GetService("Teams"):GetTeams()) do
            if v.Name ~= friendly and v.Name ~= (game.Teams:FindFirstChild("Spectators") and game.Teams.Spectators.Name) then
                local enemyPlayers = v:GetPlayers()
                for _,p in pairs(enemyPlayers) do
                    table.insert(players, p)
                end
            end
        end
        return players
    end
end; function InsertHightlightToPlayers()
    for i,v in pairs(game:GetService("CoreGui"):GetChildren()) do if v.Name == "E" then v:Destroy() end end
    local otherTeamR
    if Player.Team ~= nil then
        if tostring(Player.TeamColor) == "Bright blue" then
            otherTeamR = "Bright orange"
        elseif tostring(Player.TeamColor) == "Bright orange" then
            otherTeamR = "Bright blue"
        end
    end
    local otherteam = game.Workspace:FindFirstChild("Players"):FindFirstChild(otherTeamR)
    for _,v in pairs(otherteam:GetChildren()) do
        createHighlight(v)
    end
end

--Update

task.spawn(function()
    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Wait()
        players = GetEnemyPlayers()
        if enabled then
            InsertHightlightToPlayers()
        else
            for i,v in pairs(game:GetService("CoreGui"):GetChildren()) do if v.Name == "E" then v:Destroy() end end
        end
    end)
    game.Players.PlayerRemoving:Connect(function(plr)
        plr.CharacterRemoving:Wait()
        players = GetEnemyPlayers()
        if enabled then
            InsertHightlightToPlayers()
        else
            for i,v in pairs(game:GetService("CoreGui"):GetChildren()) do if v.Name == "E" then v:Destroy() end end
        end
    end)
    game:GetService('RunService').Stepped:Connect(function()
        if enabled then
            InsertHightlightToPlayers()
        else
            for i,v in pairs(game:GetService("CoreGui"):GetChildren()) do if v.Name == "E" then v:Destroy() end end
        end
    end)
end)

--mopsfl#4864
Section1:Toggle({
    Title = "Glow", 
    Flag = "",
    Type = "Make the EnemyPlayers Glow",
    Callback = function(v)
        enabled = v
    end
})





--Tab1:AddPlayerlist()
Window:AddSettingsTab()
Window:SwitchTab(Tab1)
Window.ToggleAnime(false)
LoadTime = math.floor((tick() - LoadTime) * 1000)
