-- Made by m0sc0w | m0sc0w on v3rmillion
-- This shit is no longer maintained and there is some code for healthbar i made that does not work 


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Function to render a player as a circle with name and health bar
local function renderPlayer(player)
    local character = player.Character
    if character then
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Create a circle for the player
        local circle = Drawing.new("Circle")
        circle.Color = Color3.new(1, 0, 0)
        circle.Thickness = 2 
        
        -- Create a text label for the player's name
        local nameLabel = Drawing.new("Text")
        nameLabel.Text = player.Name
        nameLabel.Size = 16 -- Set the font size
        nameLabel.Color = Color3.new(1, 1, 1) 
        nameLabel.Center = true
        nameLabel.Outline = true 
        
        local healthBar = Instance.new("Frame")
        healthBar.Size = UDim2.new(0, 20, 0, 3) -- Set the size of the health bar (adjust as needed)
        healthBar.BackgroundColor3 = Color3.new(0, 1, 0) -- Set the health bar color to green
        healthBar.BorderSizePixel = 0
        
       
        local function updateRender()
            if humanoidRootPart and humanoidRootPart:IsDescendantOf(workspace) then
                local screenPosition, onScreen = workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
                if onScreen then
                    circle.Position = Vector2.new(screenPosition.X, screenPosition.Y)
                    circle.Radius = 10
                    circle.Visible = true
                    
                    local nameOffset = Vector2.new(0, -25) 
                    nameLabel.Position = circle.Position + nameOffset
                    nameLabel.Visible = true
                    
                    local healthBarOffset = Vector2.new(-10, -35)
                    healthBar.Position = UDim2.new(0, circle.Position.X + healthBarOffset.X, 0, circle.Position.Y + healthBarOffset.Y)
                    healthBar.Visible = true
                    
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        local healthRatio = humanoid.Health / humanoid.MaxHealth
                        healthBar.Size = UDim2.new(healthRatio, 0, 1, 0) -- Adjust the health bar width based on the health ratio
                        
                        if healthRatio < 1 then
                            healthBar.BackgroundColor3 = Color3.new(1, 0, 0) -- Set the health bar color to red if the player is damaged
                        else
                            healthBar.BackgroundColor3 = Color3.new(0, 1, 0) -- Set the health bar color to green if the player is at full health
                        end
                    end
                else
                    circle.Visible = false
                    nameLabel.Visible = false
                    healthBar.Visible = false
                end
            else
                circle.Visible = false
                nameLabel.Visible = false
                healthBar.Visible = false
            end
        end
        
        -- Listen for changes in the player's character
        character.ChildAdded:Connect(function(child)
            if child.Name == "HumanoidRootPart" then
                humanoidRootPart = child
                updateRender()
            end
        end)
        character.ChildRemoved:Connect(function(child)
            if child.Name == "HumanoidRootPart" then
                humanoidRootPart = nil
                circle.Visible = false
                nameLabel.Visible = false
                healthBar.Visible = false
            end
        end)
        
        -- Initial update of the render
        updateRender()
        
        -- Update the render on each frame
        game:GetService("RunService").RenderStepped:Connect(updateRender)
        
        -- Parent the health bar frame to the player's character
        healthBar.Parent = character
    end
end

-- Function to render all players
local function renderAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            renderPlayer(player)
        end
    end
end

-- Render all existing players
renderAllPlayers()

-- Listen for new players
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        renderPlayer(player)
    end
end)

-- Render all players when the LocalPlayer's character is added
LocalPlayer.CharacterAdded:Connect(renderAllPlayers)
