local function createHitboxAndSkeleton(player)
    local function adornCharacter(character)
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Create Hitbox
            local hitbox = Instance.new("BoxHandleAdornment")
            hitbox.Size = humanoidRootPart.Size
            hitbox.Color3 = Color3.fromRGB(255, 0, 0)
            hitbox.Transparency = 0.5
            hitbox.Adornee = humanoidRootPart
            hitbox.AlwaysOnTop = true
            hitbox.ZIndex = 5
            hitbox.Parent = humanoidRootPart

            -- Create hitbox attachment for lines
            local hitboxAttachment = Instance.new("Attachment")
            hitboxAttachment.Parent = humanoidRootPart
            
            -- Create skeleton and lines
            local parts = {
                "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg",
                "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm",
                "LeftLowerLeg", "RightLowerLeg", "LeftUpperLeg", "RightUpperLeg"
            }
            
            for _, partName in ipairs(parts) do
                local part = character:FindFirstChild(partName)
                if part then
                    -- Create skeleton part
                    local skeletonPart = Instance.new("BoxHandleAdornment")
                    skeletonPart.Size = part.Size
                    skeletonPart.Color3 = Color3.fromRGB(0, 255, 0)
                    skeletonPart.Transparency = 0.5
                    skeletonPart.Adornee = part
                    skeletonPart.AlwaysOnTop = true
                    skeletonPart.ZIndex = 5
                    skeletonPart.Parent = part
                    
                    -- Create attachment for line
                    local attachment = Instance.new("Attachment")
                    attachment.Parent = part

                    -- Create beam (line) from part to hitbox
                    local beam = Instance.new("Beam")
                    beam.Color = ColorSequence.new(Color3.fromRGB(0, 0, 255))
                    beam.Transparency = NumberSequence.new(0.5)
                    beam.Attachment0 = attachment
                    beam.Attachment1 = hitboxAttachment
                    beam.Width0 = 0.1
                    beam.Width1 = 0.1
                    beam.Parent = part
                end
            end
        end
    end
    
    if player.Character then
        adornCharacter(player.Character)
    end
    
    player.CharacterAdded:Connect(adornCharacter)
end

local Players = game:GetService("Players")

for _, player in ipairs(Players:GetPlayers()) do
    createHitboxAndSkeleton(player)
end

Players.PlayerAdded:Connect(createHitboxAndSkeleton)
