local bts = { "PirateBasic", "PirateBrigade", "FishBoat" }  
local p = game:GetService("Players").LocalPlayer  
local sr, se = require(game.ReplicatedStorage.Util.CameraShaker), game.ReplicatedStorage.Modules.Net["RE/ShootGunEvent"]  

local function dist(p1, p2)  
    return (p1 - p2).Magnitude  
end  

local function procparts(obj, rng)  
    local res = {}  
    for _, i in ipairs(obj:GetChildren()) do  
        if table.find(bts, i.Name) and i:FindFirstChild("Body") then  
            for _, j in ipairs(i.Body:GetChildren()) do  
                if dist(p.Character.HumanoidRootPart.Position, j.Position) < rng then  
                    res[#res + 1] = j  
                    break  
                end  
            end  
        end  
    end  
    return res  
end  

local function getheads(obj, rng)  
    local heads = {}  
    for _, i in ipairs(obj:GetChildren()) do  
        local h = i:FindFirstChild("Head")  
        if i:FindFirstChild("Humanoid") and i.Humanoid.Health > 0 and h and dist(p.Character.HumanoidRootPart.Position, h.Position) < rng then  
            heads[#heads + 1] = h  
        end  
    end  
    return heads  
end  

local function gathertargets()  
    local res = procparts(game:GetService("Workspace").Enemies, 100)  
    if #res == 0 then  
        for _, b in ipairs(game:GetService("Workspace").SeaBeasts:GetChildren()) do  
            local r = b:FindFirstChild("RootPart")  
            if r and dist(p.Character.HumanoidRootPart.Position, r.Position) < 500 then  
                res[#res + 1] = r  
            end  
        end  
    end  
    for _, h in ipairs(getheads(game:GetService("Workspace").Enemies, 100)) do  
        res[#res + 1] = h  
    end  
    return res  
end  

local function triggerfire(targets)  
    local tool = p.Character:FindFirstChildOfClass("Tool")  
    if not (tool and tool.ToolTip == "Gun") then return end  

    for _, target in ipairs(targets) do  
        se:FireServer(target.Position, { target })  
        se:FireServer(target.Position, { target })  
        sethiddenproperty(p, "SimulationRadius", math.huge)  
    end  
end  

local function executeloop()  
    while task.wait(math.random(0.01, 0.1)) do  
        triggerfire(gathertargets())  
        sr:Stop()  
    end  
end  

for _ = 1, 20 do  
    task.spawn(executeloop)  
end  
