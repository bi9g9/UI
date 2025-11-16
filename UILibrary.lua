--[[
    UI Library for Lua/Roblox
    Simple and customizable UI library
]]

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Default themes
local Themes = {
    DarkTheme = {
        SchemeColor = Color3.fromRGB(64, 64, 64),
        Background = Color3.fromRGB(0, 0, 0),
        Header = Color3.fromRGB(0, 0, 0),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 20)
    },
    LightTheme = {
        SchemeColor = Color3.fromRGB(150, 150, 150),
        Background = Color3.fromRGB(255, 255, 255),
        Header = Color3.fromRGB(200, 200, 200),
        TextColor = Color3.fromRGB(0, 0, 0),
        ElementColor = Color3.fromRGB(224, 224, 224)
    },
    Ocean = {
        SchemeColor = Color3.fromRGB(86, 76, 251),
        Background = Color3.fromRGB(26, 32, 58),
        Header = Color3.fromRGB(38, 45, 71),
        TextColor = Color3.fromRGB(200, 200, 200),
        ElementColor = Color3.fromRGB(38, 45, 71)
    },
    BloodTheme = {
        SchemeColor = Color3.fromRGB(227, 27, 27),
        Background = Color3.fromRGB(10, 10, 10),
        Header = Color3.fromRGB(5, 5, 5),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 20)
    }
}

-- Utility functions
local function MakeDraggable(frame, dragFrame)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

local function Tween(object, properties, duration)
    TweenService:Create(
        object,
        TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    ):Play()
end

-- Create main window
function Library.CreateLib(title, themeName)
    local LibraryTable = {}
    
    -- Get theme
    local theme = Themes[themeName] or themeName or Themes.DarkTheme
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary_" .. math.random(1000, 9999)
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.BackgroundColor3 = theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = MainFrame
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.BackgroundColor3 = theme.Header
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 6)
    HeaderCorner.Parent = Header
    
    local HeaderCover = Instance.new("Frame")
    HeaderCover.Size = UDim2.new(1, 0, 0, 10)
    HeaderCover.Position = UDim2.new(0, 0, 1, -10)
    HeaderCover.BackgroundColor3 = theme.Header
    HeaderCover.BorderSizePixel = 0
    HeaderCover.Parent = Header
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = theme.TextColor
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 2.5)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "×"
    CloseButton.TextColor3 = theme.TextColor
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Header
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -35)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundColor3 = theme.Header
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 6)
    SidebarCorner.Parent = Sidebar
    
    local SidebarCover = Instance.new("Frame")
    SidebarCover.Size = UDim2.new(0, 10, 1, 0)
    SidebarCover.Position = UDim2.new(1, -10, 0, 0)
    SidebarCover.BackgroundColor3 = theme.Header
    SidebarCover.BorderSizePixel = 0
    SidebarCover.Parent = Sidebar

    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, -10, 1, -10)
    TabContainer.Position = UDim2.new(0, 5, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 4
    TabContainer.Parent = Sidebar
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabContainer
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -160, 1, -45)
    ContentArea.Position = UDim2.new(0, 155, 0, 40)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame
    
    -- Make draggable
    MakeDraggable(MainFrame, Header)
    
    -- Toggle UI function
    function LibraryTable:ToggleUI()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
    
    -- Create Tab
    function LibraryTable:NewTab(tabName)
        local TabTable = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = theme.ElementColor
        TabButton.BorderSizePixel = 0
        TabButton.Text = tabName
        TabButton.TextColor3 = theme.TextColor
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.Visible = false
        TabContent.Parent = ContentArea
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.Parent = TabContent
        
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, child in pairs(ContentArea:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            
            -- Reset all tab buttons
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    Tween(child, {BackgroundColor3 = theme.ElementColor})
                end
            end
            
            -- Show this tab
            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = theme.SchemeColor})
        end)
        
        -- Auto-select first tab
        if #TabContainer:GetChildren() == 2 then -- Layout + first button
            TabContent.Visible = true
            TabButton.BackgroundColor3 = theme.SchemeColor
        end
        
        -- Create Section
        function TabTable:NewSection(sectionName)
            local SectionTable = {}
            
            -- Section Frame
            local Section = Instance.new("Frame")
            Section.Size = UDim2.new(1, -10, 0, 35)
            Section.BackgroundColor3 = theme.SchemeColor
            Section.BorderSizePixel = 0
            Section.Parent = TabContent
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 4)
            SectionCorner.Parent = Section
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, -10, 1, 0)
            SectionLabel.Position = UDim2.new(0, 10, 0, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = sectionName
            SectionLabel.TextColor3 = theme.TextColor
            SectionLabel.TextSize = 14
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = Section
            
            local ElementContainer = Instance.new("Frame")
            ElementContainer.Size = UDim2.new(1, 0, 0, 0)
            ElementContainer.BackgroundTransparency = 1
            ElementContainer.Parent = TabContent
            
            local ElementLayout = Instance.new("UIListLayout")
            ElementLayout.Padding = UDim.new(0, 5)
            ElementLayout.Parent = ElementContainer
            
            local function UpdateSize()
                ElementContainer.Size = UDim2.new(1, -10, 0, ElementLayout.AbsoluteContentSize.Y)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
            end
            
            ElementLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize)
            
            -- Button
            function SectionTable:NewButton(buttonText, buttonInfo, callback)
                callback = callback or function() end
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.BackgroundColor3 = theme.ElementColor
                Button.BorderSizePixel = 0
                Button.Text = buttonText
                Button.TextColor3 = theme.TextColor
                Button.TextSize = 13
                Button.Font = Enum.Font.Gotham
                Button.Parent = ElementContainer
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = Button
                
                Button.MouseButton1Click:Connect(callback)
                
                Button.MouseEnter:Connect(function()
                    Tween(Button, {BackgroundColor3 = Color3.fromRGB(
                        theme.ElementColor.R * 255 + 10,
                        theme.ElementColor.G * 255 + 10,
                        theme.ElementColor.B * 255 + 10
                    )})
                end)
                
                Button.MouseLeave:Connect(function()
                    Tween(Button, {BackgroundColor3 = theme.ElementColor})
                end)
                
                UpdateSize()
            end
            
            -- Toggle
            function SectionTable:NewToggle(toggleText, toggleInfo, callback)
                callback = callback or function() end
                local toggled = false
                
                local Toggle = Instance.new("TextButton")
                Toggle.Size = UDim2.new(1, 0, 0, 35)
                Toggle.BackgroundColor3 = theme.ElementColor
                Toggle.BorderSizePixel = 0
                Toggle.Text = ""
                Toggle.Parent = ElementContainer
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 4)
                ToggleCorner.Parent = Toggle
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(1, -45, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = toggleText
                ToggleLabel.TextColor3 = theme.TextColor
                ToggleLabel.TextSize = 13
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = Toggle
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Size = UDim2.new(0, 40, 0, 20)
                ToggleFrame.Position = UDim2.new(1, -45, 0.5, -10)
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Parent = Toggle
                
                local ToggleFrameCorner = Instance.new("UICorner")
                ToggleFrameCorner.CornerRadius = UDim.new(1, 0)
                ToggleFrameCorner.Parent = ToggleFrame
                
                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
                ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
                ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleCircle.BorderSizePixel = 0
                ToggleCircle.Parent = ToggleFrame
                
                local CircleCorner = Instance.new("UICorner")
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = ToggleCircle
                
                Toggle.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    
                    if toggled then
                        Tween(ToggleFrame, {BackgroundColor3 = theme.SchemeColor})
                        Tween(ToggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)})
                    else
                        Tween(ToggleFrame, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
                        Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)})
                    end
                    
                    callback(toggled)
                end)
                
                UpdateSize()
            end
            
            -- Slider
            function SectionTable:NewSlider(sliderText, sliderInfo, maxValue, minValue, callback)
                callback = callback or function() end
                maxValue = maxValue or 100
                minValue = minValue or 0
                
                local Slider = Instance.new("Frame")
                Slider.Size = UDim2.new(1, 0, 0, 50)
                Slider.BackgroundColor3 = theme.ElementColor
                Slider.BorderSizePixel = 0
                Slider.Parent = ElementContainer
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 4)
                SliderCorner.Parent = Slider
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
                SliderLabel.Position = UDim2.new(0, 10, 0, 5)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = sliderText
                SliderLabel.TextColor3 = theme.TextColor
                SliderLabel.TextSize = 13
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = Slider
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0.3, -10, 0, 20)
                ValueLabel.Position = UDim2.new(0.7, 0, 0, 5)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(minValue)
                ValueLabel.TextColor3 = theme.SchemeColor
                ValueLabel.TextSize = 13
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = Slider
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Size = UDim2.new(1, -20, 0, 6)
                SliderBar.Position = UDim2.new(0, 10, 1, -15)
                SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                SliderBar.BorderSizePixel = 0
                SliderBar.Parent = Slider
                
                local SliderBarCorner = Instance.new("UICorner")
                SliderBarCorner.CornerRadius = UDim.new(1, 0)
                SliderBarCorner.Parent = SliderBar
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.BackgroundColor3 = theme.SchemeColor
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBar
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(1, 0)
                SliderFillCorner.Parent = SliderFill
                
                local dragging = false
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mouse = UserInputService:GetMouseLocation()
                        local relativeX = math.clamp(mouse.X - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
                        local percentage = relativeX / SliderBar.AbsoluteSize.X
                        local value = math.floor(minValue + (maxValue - minValue) * percentage)
                        
                        ValueLabel.Text = tostring(value)
                        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                        callback(value)
                    end
                end)
                
                UpdateSize()
            end
            
            -- TextBox
            function SectionTable:NewTextBox(textboxText, textboxInfo, callback)
                callback = callback or function() end
                
                local TextBoxFrame = Instance.new("Frame")
                TextBoxFrame.Size = UDim2.new(1, 0, 0, 35)
                TextBoxFrame.BackgroundColor3 = theme.ElementColor
                TextBoxFrame.BorderSizePixel = 0
                TextBoxFrame.Parent = ElementContainer
                
                local TextBoxCorner = Instance.new("UICorner")
                TextBoxCorner.CornerRadius = UDim.new(0, 4)
                TextBoxCorner.Parent = TextBoxFrame
                
                local TextBoxLabel = Instance.new("TextLabel")
                TextBoxLabel.Size = UDim2.new(0.4, 0, 1, 0)
                TextBoxLabel.Position = UDim2.new(0, 10, 0, 0)
                TextBoxLabel.BackgroundTransparency = 1
                TextBoxLabel.Text = textboxText
                TextBoxLabel.TextColor3 = theme.TextColor
                TextBoxLabel.TextSize = 13
                TextBoxLabel.Font = Enum.Font.Gotham
                TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextBoxLabel.Parent = TextBoxFrame
                
                local TextBox = Instance.new("TextBox")
                TextBox.Size = UDim2.new(0.55, -10, 0, 25)
                TextBox.Position = UDim2.new(0.45, 0, 0.5, -12.5)
                TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                TextBox.BorderSizePixel = 0
                TextBox.Text = ""
                TextBox.PlaceholderText = "Enter text..."
                TextBox.TextColor3 = theme.TextColor
                TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
                TextBox.TextSize = 12
                TextBox.Font = Enum.Font.Gotham
                TextBox.Parent = TextBoxFrame
                
                local TextBoxInputCorner = Instance.new("UICorner")
                TextBoxInputCorner.CornerRadius = UDim.new(0, 4)
                TextBoxInputCorner.Parent = TextBox
                
                TextBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        callback(TextBox.Text)
                    end
                end)
                
                UpdateSize()
            end
            
            -- Label
            function SectionTable:NewLabel(labelText)
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 30)
                Label.BackgroundColor3 = theme.SchemeColor
                Label.BorderSizePixel = 0
                Label.Text = "  " .. labelText
                Label.TextColor3 = theme.TextColor
                Label.TextSize = 13
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = ElementContainer
                
                local LabelCorner = Instance.new("UICorner")
                LabelCorner.CornerRadius = UDim.new(0, 4)
                LabelCorner.Parent = Label
                
                UpdateSize()
                
                return {
                    UpdateLabel = function(self, newText)
                        Label.Text = "  " .. newText
                    end
                }
            end
            
            return SectionTable
        end
        
        return TabTable
    end
    
    return LibraryTable
end

return Library
