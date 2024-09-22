local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Function to create highlights and display health/username
local function createHighlight(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Create BillboardGui to display username and health
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Adornee = character:WaitForChild("Head")
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    
    -- Text label for username and health
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboardGui
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextScaled = true
    
    -- Update text with username and health
    local function updateLabel()
        textLabel.Text = player.Name .. " | HP: " .. math.floor(humanoid.Health)
    end
    
    humanoid:GetPropertyChangedSignal("Health"):Connect(updateLabel)
    updateLabel()
    
    -- Create a highlight for the character
    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    
    -- Set color based on team (or default to white if no team)
    local teamColor = player.Team and player.Team.TeamColor.Color or Color3.new(1, 1, 1)
    highlight.FillColor = teamColor
    highlight.OutlineColor = Color3.new(0, 0, 0)
    
    -- Attach BillboardGui and highlight to character
    billboardGui.Parent = character:WaitForChild("Head")
    highlight.Parent = character
end

-- X-Ray feature (make characters visible through walls)
local function enableXRay()
    RunService.RenderStepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                local character = player.Character
                if character then
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.LocalTransparencyModifier = 0
                        end
                    end
                end
            end
        end
    end)
end

-- Create lines from LocalPlayer to other players
local function drawLines()
    local localCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = localCharacter:WaitForChild("HumanoidRootPart")

    RunService.RenderStepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character then
                    local otherHrp = character:FindFirstChild("HumanoidRootPart")
                    if otherHrp then
                        -- Create a line (Beam) from LocalPlayer to the other player
                        local beam = Instance.new("Beam")
                        local attachment0 = Instance.new("Attachment", hrp)
                        local attachment1 = Instance.new("Attachment", otherHrp)
                        
                        -- Set beam attachments
                        beam.Attachment0 = attachment0
                        beam.Attachment1 = attachment1
                        beam.FaceCamera = true
                        
                        -- Set color based on the player's team
                        local teamColor = player.Team and player.Team.TeamColor.Color or Color3.new(1, 1, 1)
                        beam.Color = ColorSequence.new(teamColor)
                        beam.Width0 = 0.1
                        beam.Width1 = 0.1
                        
                        -- Parent beam to character so it's visible
                        beam.Parent = character
                    end
                end
            end
        end
    end)
end

-- Setup highlights for each player
for _, player in pairs(Players:GetPlayers()) do
    createHighlight(player)
end

-- Ensure new players also get highlighted
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createHighlight(player)
    end)
end)

-- Enable X-Ray and draw lines
enableXRay()
drawLines()
