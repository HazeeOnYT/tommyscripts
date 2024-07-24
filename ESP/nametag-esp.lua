local function createBillboardGui(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head")
    local teamColor = player.Team and player.Team.Color or Color3.new(1, 1, 1) -- Default to white if no team

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "NameTag"
    billboardGui.Adornee = head
    billboardGui.Size = UDim2.new(4, 0, 1.5, 0)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextColor3 = Color3.new(1, 1, 1) -- White text color for visibility
    textLabel.TextStrokeTransparency = 0.8
    textLabel.Text = player.Name .. " - " .. tostring(teamColor) .. "\n" .. "v"
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.TextXAlignment = Enum.TextXAlignment.Center

    textLabel.Parent = billboardGui
    billboardGui.Parent = head
end

local function updateNameTags()
    while true do
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                if head:FindFirstChild("NameTag") then
                    head.NameTag:Destroy()
                end
                createBillboardGui(player)
            end
        end
        wait(0) -- Wait for 0 seconds
    end
end

spawn(updateNameTags)
