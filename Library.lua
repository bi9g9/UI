local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Mouse = game.Players.LocalPlayer:GetMouse()

local Blacklist = {
    Enum.KeyCode.Unknown, Enum.KeyCode.CapsLock, Enum.KeyCode.Escape, 
    Enum.KeyCode.Tab, Enum.KeyCode.Return, Enum.KeyCode.Backspace, 
    Enum.KeyCode.Space, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D
}

-- ลบ UI เก่าถ้ามี
if CoreGui:FindFirstChild("Shaman") then
    CoreGui.Shaman:Destroy()
end
if CoreGui:FindFirstChild("Tooltips") then
    CoreGui.Tooltips:Destroy()
end

local TabSelected = nil
local EditOpened = false
local ColorElements = {}

local library = {Flags = {}}

-- ฟังก์ชันสำหรับ Rainbow Effect
task.spawn(function()
    while true do
        if EditOpened and #ColorElements > 0 then
            local hue = tick() % 7 / 7
            local color = Color3.fromHSV(hue, 1, 1)
            for frame, v in pairs(ColorElements) do
                if v.Enabled then
                    if frame.ClassName == "Frame" then
                        frame.BackgroundColor3 = color
                    else
                        frame.ImageColor3 = color
                    end
                end
            end
        end
        wait()
    end
end)

-- ฟังก์ชันช่วยเหลือ
function library:GetXY(GuiObject)
    local Max, May = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
    local Px, Py = math.clamp(Mouse.X - GuiObject.AbsolutePosition.X, 0, Max), 
                   math.clamp(Mouse.Y - GuiObject.AbsolutePosition.Y, 0, May)
    return Px/Max, Py/May
end

function library:Window(Info)
    Info.Text = Info.Text or "Shaman Library"
    local window = {}
    
    -- สร้าง ScreenGui หลัก
    local shamanScreenGui = Instance.new("ScreenGui")
    shamanScreenGui.Name = "Shaman"
    shamanScreenGui.Parent = CoreGui
    
    local tooltipScreenGui = Instance.new("ScreenGui")
    tooltipScreenGui.Name = "Tooltips"
    tooltipScreenGui.Parent = CoreGui
    
    -- ฟังก์ชัน Tooltip
    local function CreateTooltip(text)
        local tooltip = Instance.new("Frame")
        tooltip.Name = "Tooltip"
        tooltip.AnchorPoint = Vector2.new(0.5, 0)
        tooltip.BackgroundColor3 = Color3.fromRGB(79, 79, 79)
        tooltip.Visible = false
        tooltip.Size = UDim2.new(0, 100, 0, 19)
        tooltip.ZIndex = 5
        tooltip.Parent = tooltipScreenGui
        
        local uICorner = Instance.new("UICorner")
        uICorner.CornerRadius = UDim.new(0, 3)
        uICorner.Parent = tooltip
        
        local uIStroke = Instance.new("UIStroke")
        uIStroke.Color = Color3.fromRGB(98, 98, 98)
        uIStroke.Parent = tooltip
        
        local tooltipText = Instance.new("TextLabel")
        tooltipText.Font = Enum.Font.GothamBold
        tooltipText.Text = text
        tooltipText.TextColor3 = Color3.fromRGB(217, 217, 217)
        tooltipText.TextSize = 11
        tooltipText.BackgroundTransparency = 1
        tooltipText.Size = UDim2.new(1, 0, 1, 0)
        tooltipText.ZIndex = 6
        tooltipText.Parent = tooltip
        
        local TextBounds = tooltipText.TextBounds
        tooltip.Size = UDim2.new(0, TextBounds.X + 10, 0, 19)
        
        return tooltip
    end
    
    local function AddTooltip(element, text)
        local tooltip = CreateTooltip(text)
        local Hovered = false
        
        local function Update()
            local MousePos = UserInputService:GetMouseLocation()
            local Viewport = workspace.CurrentCamera.ViewportSize
            tooltip.Position = UDim2.new(MousePos.X / Viewport.X, 0, MousePos.Y / Viewport.Y, 0) + UDim2.new(0, 0, 0, -43)
        end
        
        element.MouseEnter:Connect(function()
            Hovered = true
            wait(.5)
            if Hovered then
                tooltip.Visible = true
            end
        end)
        
        element.MouseLeave:Connect(function()
            Hovered = false
            tooltip.Visible = false
        end)
        
        element.MouseMoved:Connect(function()
            Update()
        end)
    end
    
    -- สร้าง Main Frame
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Position = UDim2.new(0.361, 0, 0.308, 0)
    main.Size = UDim2.new(0, 450, 0, 321)
    main.Parent = shamanScreenGui
    
    local uICorner = Instance.new("UICorner")
    uICorner.CornerRadius = UDim.new(0, 8)
    uICorner.Parent = main
    
    -- Shadow Effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = 0
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.Parent = main
    
    -- Gradient Overlay
    local gradientFrame = Instance.new("Frame")
    gradientFrame.Name = "GradientOverlay"
    gradientFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    gradientFrame.BackgroundTransparency = 0.95
    gradientFrame.BorderSizePixel = 0
    gradientFrame.Size = UDim2.new(1, 0, 1, 0)
    gradientFrame.ZIndex = 1
    gradientFrame.Parent = main
    
    local gradientCorner = Instance.new("UICorner")
    gradientCorner.CornerRadius = UDim.new(0, 8)
    gradientCorner.Parent = gradientFrame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
    })
    gradient.Rotation = 45
    gradient.Parent = gradientFrame
    
    -- สร้าง Topbar
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    topbar.Size = UDim2.new(0, 450, 0, 35)
    topbar.ZIndex = 2
    topbar.Parent = main
    
    -- Topbar Gradient
    local topbarGradient = Instance.new("UIGradient")
    topbarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 80, 255))
    })
    topbarGradient.Rotation = 90
    topbarGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(1, 0.9)
    })
    topbarGradient.Parent = topbar
    
    -- Dragging System
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    local uICorner1 = Instance.new("UICorner")
    uICorner1.CornerRadius = UDim.new(0, 8)
    uICorner1.Parent = topbar
    
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 0, 0.7, 0)
    frame.Size = UDim2.new(0, 450, 0, 11)
    frame.Parent = topbar
    
    local frame1 = Instance.new("Frame")
    frame1.AnchorPoint = Vector2.new(0.5, 1)
    frame1.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
    frame1.BorderSizePixel = 0
    frame1.Position = UDim2.new(0.5, 0, 1, 0)
    frame1.Size = UDim2.new(0, 450, 0, 2)
    frame1.ZIndex = 3
    frame1.Parent = frame
    
    -- Animated Gradient Line
    local lineGradient = Instance.new("UIGradient")
    lineGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))
    })
    lineGradient.Parent = frame1
    
    -- Animate the gradient
    task.spawn(function()
        while frame1.Parent do
            for i = 0, 360, 2 do
                if not frame1.Parent then break end
                lineGradient.Rotation = i
                wait(0.03)
            end
        end
    end)
    
    -- Title Text with Glow
    local textLabel = Instance.new("TextLabel")
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Text = Info.Text
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0.02, 0, 0, 0)
    textLabel.Size = UDim2.new(0, 200, 0, 35)
    textLabel.ZIndex = 3
    textLabel.Parent = topbar
    
    -- Text Stroke for better visibility
    local textStroke = Instance.new("UIStroke")
    textStroke.Color = Color3.fromRGB(100, 200, 255)
    textStroke.Thickness = 0.5
    textStroke.Transparency = 0.5
    textStroke.Parent = textLabel
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 18
    closeButton.TextColor3 = Color3.fromRGB(237, 237, 237)
    closeButton.BackgroundTransparency = 1
    closeButton.Position = UDim2.new(0.947, 0, 0.194, 0)
    closeButton.Size = UDim2.new(0, 17, 0, 17)
    closeButton.ZIndex = 2
    closeButton.Parent = topbar
    
    closeButton.MouseButton1Click:Once(function()
        shamanScreenGui:Destroy()
        tooltipScreenGui:Destroy()
    end)
    
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(.1), {TextColor3 = Color3.fromRGB(217, 97, 99)}):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(.1), {TextColor3 = Color3.fromRGB(217, 217, 217)}):Play()
    end)
    
    -- Minimize Button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Text = "_"
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 14
    minimizeButton.TextColor3 = Color3.fromRGB(237, 237, 237)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Position = UDim2.new(0.893, 0, 0.194, 0)
    minimizeButton.Size = UDim2.new(0, 17, 0, 17)
    minimizeButton.ZIndex = 2
    minimizeButton.Parent = topbar
    
    minimizeButton.MouseEnter:Connect(function()
        TweenService:Create(minimizeButton, TweenInfo.new(.1), {TextColor3 = Color3.fromRGB(194, 162, 76)}):Play()
    end)
    
    minimizeButton.MouseLeave:Connect(function()
        TweenService:Create(minimizeButton, TweenInfo.new(.1), {TextColor3 = Color3.fromRGB(217, 217, 217)}):Play()
    end)
    
    local Opened = true
    minimizeButton.MouseButton1Click:Connect(function()
        Opened = not Opened
        topbar.Frame.Visible = Opened
        
        task.spawn(function()
            if Opened then wait(.15) end
            for _, v in pairs(main:GetChildren()) do
                if v.Name == "TabContainer" or v.Name == "LeftContainer" or v.Name == "RightContainer" then
                    v.Visible = Opened
                end
            end
        end)
        
        TweenService:Create(main, TweenInfo.new(.2), {Size = Opened and UDim2.new(0, 450, 0, 321) or UDim2.new(0, 450, 0, 30)}):Play()
    end)
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    tabContainer.Position = UDim2.new(0, 0, 0.109, 0)
    tabContainer.Size = UDim2.new(0, 114, 0, 286)
    tabContainer.Parent = main
    
    local uICorner2 = Instance.new("UICorner")
    uICorner2.CornerRadius = UDim.new(0, 8)
    uICorner2.Parent = tabContainer
    
    -- Tab Container Stroke
    local tabStroke = Instance.new("UIStroke")
    tabStroke.Color = Color3.fromRGB(60, 60, 80)
    tabStroke.Thickness = 1
    tabStroke.Transparency = 0.5
    tabStroke.Parent = tabContainer
    
    local fix = Instance.new("Frame")
    fix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    fix.BorderSizePixel = 0
    fix.Position = UDim2.new(0.895, 0, 0, 0)
    fix.Size = UDim2.new(0, 11, 0, 285)
    fix.Parent = tabContainer
    
    local scrollingContainer = Instance.new("ScrollingFrame")
    scrollingContainer.Name = "ScrollingContainer"
    scrollingContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingContainer.CanvasSize = UDim2.new()
    scrollingContainer.ScrollBarImageColor3 = Color3.fromRGB(56, 56, 56)
    scrollingContainer.ScrollBarThickness = 2
    scrollingContainer.BackgroundTransparency = 1
    scrollingContainer.BorderSizePixel = 0
    scrollingContainer.Size = UDim2.new(0, 114, 0, 285)
    scrollingContainer.ZIndex = 2
    scrollingContainer.Parent = tabContainer
    
    local uIListLayout = Instance.new("UIListLayout")
    uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uIListLayout.Parent = scrollingContainer
    
    -- ฟังก์ชัน Tab
    function window:Tab(Info)
        Info.Text = Info.Text or "Tab"
        local tab = {}
        
        local tabButton = Instance.new("Frame")
        tabButton.Name = "TabButton"
        tabButton.BackgroundTransparency = 1
        tabButton.Size = UDim2.new(0, 113, 0, 27)
        tabButton.Parent = scrollingContainer
        
        local tabFrame = Instance.new("Frame")
        tabFrame.Name = "TabFrame"
        tabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        tabFrame.BackgroundTransparency = 0.3
        tabFrame.BorderSizePixel = 0
        tabFrame.Position = UDim2.new(0.067, -5, 0.013, 3)
        tabFrame.Size = UDim2.new(0, 107, 0, 26)
        tabFrame.ZIndex = 2
        tabFrame.Parent = tabButton
        
        local uICorner3 = Instance.new("UICorner")
        uICorner3.CornerRadius = UDim.new(0, 6)
        uICorner3.Parent = tabFrame
        
        local uIStroke = Instance.new("UIStroke")
        uIStroke.Color = Color3.fromRGB(100, 150, 255)
        uIStroke.Thickness = 1
        uIStroke.Transparency = 0.7
        uIStroke.Parent = tabFrame
        
        -- Tab Gradient
        local tabGradient = Instance.new("UIGradient")
        tabGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 80)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 60))
        })
        tabGradient.Rotation = 90
        tabGradient.Parent = tabFrame
        
        local textLabel1 = Instance.new("TextLabel")
        textLabel1.Font = Enum.Font.GothamBold
        textLabel1.Text = Info.Text
        textLabel1.TextColor3 = Color3.fromRGB(237, 237, 237)
        textLabel1.TextSize = 11
        textLabel1.BackgroundTransparency = 1
        textLabel1.Size = UDim2.new(0, 108, 0, 23)
        textLabel1.ZIndex = 2
        textLabel1.Parent = tabFrame
        
        local tabTextButton = Instance.new("TextButton")
        tabTextButton.Text = ""
        tabTextButton.BackgroundTransparency = 1
        tabTextButton.Size = UDim2.new(0, 107, 0, 23)
        tabTextButton.Parent = tabFrame
        
        tabFrame.MouseEnter:Connect(function()
            if TabSelected ~= tabFrame then
                TweenService:Create(tabFrame, TweenInfo.new(.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.1}):Play()
                TweenService:Create(uIStroke, TweenInfo.new(.2, Enum.EasingStyle.Quad), {Transparency = 0.3}):Play()
            end
        end)
        
        tabFrame.MouseLeave:Connect(function()
            if TabSelected ~= tabFrame then
                TweenService:Create(tabFrame, TweenInfo.new(.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.3}):Play()
                TweenService:Create(uIStroke, TweenInfo.new(.2, Enum.EasingStyle.Quad), {Transparency = 0.7}):Play()
            end
        end)
        
        -- Left Container
        local leftContainer = Instance.new("ScrollingFrame")
        leftContainer.Name = "LeftContainer"
        leftContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
        leftContainer.CanvasSize = UDim2.new()
        leftContainer.ScrollBarThickness = 3
        leftContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
        leftContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
        leftContainer.BorderSizePixel = 0
        leftContainer.Position = UDim2.new(0.253, 0, 0.109, 0)
        leftContainer.Size = UDim2.new(0, 168, 0, 286)
        leftContainer.Visible = false
        leftContainer.Parent = main
        
        local leftCorner = Instance.new("UICorner")
        leftCorner.CornerRadius = UDim.new(0, 8)
        leftCorner.Parent = leftContainer
        
        local uIListLayout2 = Instance.new("UIListLayout")
        uIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
        uIListLayout2.Parent = leftContainer
        
        local uIPadding2 = Instance.new("UIPadding")
        uIPadding2.PaddingLeft = UDim.new(0, 4)
        uIPadding2.PaddingTop = UDim.new(0, 3)
        uIPadding2.Parent = leftContainer
        
        -- Right Container
        local rightContainer = Instance.new("ScrollingFrame")
        rightContainer.Name = "RightContainer"
        rightContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
        rightContainer.CanvasSize = UDim2.new()
        rightContainer.ScrollBarThickness = 3
        rightContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
        rightContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
        rightContainer.BorderSizePixel = 0
        rightContainer.Position = UDim2.new(0.627, 0, 0.109, 0)
        rightContainer.Size = UDim2.new(0, 168, 0, 286)
        rightContainer.Visible = false
        rightContainer.Parent = main
        
        local rightCorner = Instance.new("UICorner")
        rightCorner.CornerRadius = UDim.new(0, 8)
        rightCorner.Parent = rightContainer
        
        local uIListLayout3 = Instance.new("UIListLayout")
        uIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
        uIListLayout3.Parent = rightContainer
        
        local uIPadding3 = Instance.new("UIPadding")
        uIPadding3.PaddingLeft = UDim.new(0, 2)
        uIPadding3.PaddingTop = UDim.new(0, 3)
        uIPadding3.Parent = rightContainer
        

        
        -- ฟังก์ชัน Section
        function tab:Section(Info)
            Info.Text = Info.Text or "Section"
            Info.Side = Info.Side or "Left"
            
            local SizeY = 23
            local sectiontable = {}
            local Side = Info.Side == "Left" and leftContainer or rightContainer
            
            local section = Instance.new("Frame")
            section.Name = "Section"
            section.BackgroundTransparency = 1
            section.Size = UDim2.new(0, 162, 0, 27)
            section.Parent = Side
            
            local Closed = Instance.new("BoolValue", section)
            Closed.Value = false
            
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = "SectionFrame"
            sectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            sectionFrame.ClipsDescendants = true
            sectionFrame.Size = UDim2.new(0, 162, 0, 23)
            sectionFrame.Parent = section
            
            -- Section Gradient
            local sectionGradient = Instance.new("UIGradient")
            sectionGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 65)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 45))
            })
            sectionGradient.Rotation = 90
            sectionGradient.Parent = sectionFrame
            
            sectionFrame.ChildAdded:Connect(function(v)
                if v.ClassName == "Frame" then
                    if v.Name == "Slider" then
                        SizeY = SizeY + 40
                    else
                        SizeY = SizeY + 27
                    end
                end
            end)
            
            local uIStroke3 = Instance.new("UIStroke")
            uIStroke3.Color = Color3.fromRGB(80, 120, 200)
            uIStroke3.Thickness = 1
            uIStroke3.Transparency = 0.6
            uIStroke3.Parent = sectionFrame
            
            local uICorner7 = Instance.new("UICorner")
            uICorner7.CornerRadius = UDim.new(0, 6)
            uICorner7.Parent = sectionFrame
            
            local uIListLayout1 = Instance.new("UIListLayout")
            uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
            uIListLayout1.Parent = sectionFrame
            
            local uIPadding1 = Instance.new("UIPadding")
            uIPadding1.PaddingTop = UDim.new(0, 23)
            uIPadding1.Parent = sectionFrame
            
            local sectionName = Instance.new("TextLabel")
            sectionName.Font = Enum.Font.GothamBold
            sectionName.Text = Info.Text
            sectionName.TextColor3 = Color3.fromRGB(217, 217, 217)
            sectionName.TextSize = 11
            sectionName.TextXAlignment = Enum.TextXAlignment.Left
            sectionName.BackgroundTransparency = 1
            sectionName.Position = UDim2.new(0.0488, 0, 0, 0)
            sectionName.Size = UDim2.new(0, 128, 0, 23)
            sectionName.Parent = section
            
            local sectionButton = Instance.new("TextButton")
            sectionButton.Text = ""
            sectionButton.BackgroundTransparency = 1
            sectionButton.Size = UDim2.new(0, 162, 0, 23)
            sectionButton.ZIndex = 2
            sectionButton.Parent = section
            
            local sectionIcon = Instance.new("TextLabel")
            sectionIcon.Text = "+"
            sectionIcon.Font = Enum.Font.GothamBold
            sectionIcon.TextSize = 14
            sectionIcon.TextColor3 = Color3.fromRGB(217, 217, 217)
            sectionIcon.AnchorPoint = Vector2.new(1, 0)
            sectionIcon.BackgroundTransparency = 1
            sectionIcon.Position = UDim2.new(1, -5, 0, 5)
            sectionIcon.Size = UDim2.new(0, 13, 0, 13)
            sectionIcon.ZIndex = 1
            sectionIcon.Parent = section
            
            sectionButton.MouseButton1Click:Connect(function()
                Closed.Value = not Closed.Value
                
                TweenService:Create(section, TweenInfo.new(.1), {Size = Closed.Value and UDim2.new(0, 162, 0, SizeY + 4) or UDim2.new(0, 162, 0, 27)}):Play()
                TweenService:Create(sectionFrame, TweenInfo.new(.1), {Size = Closed.Value and UDim2.new(0, 162, 0, SizeY) or UDim2.new(0, 162, 0, 23)}):Play()
                TweenService:Create(sectionIcon, TweenInfo.new(.1), {TextColor3 = Closed.Value and Color3.fromRGB(217, 97, 99) or Color3.fromRGB(217, 217, 217)}):Play()
                TweenService:Create(sectionIcon, TweenInfo.new(.1), {Rotation = Closed.Value and 45 or 0}):Play()
            end)
            
            -- Toggle Element
            function sectiontable:Toggle(Info)
                Info.Text = Info.Text or "Toggle"
                Info.Flag = Info.Flag or nil
                Info.Default = Info.Default or false
                Info.Callback = Info.Callback or function() end
                Info.Tooltip = Info.Tooltip or ""
                
                if Info.Flag ~= nil then
                    library.Flags[Info.Flag] = false
                end
                
                local insidetoggle = {}
                local Toggled = false
                
                local toggle = Instance.new("Frame")
                toggle.Name = "Toggle"
                toggle.BackgroundTransparency = 1
                toggle.Size = UDim2.new(0, 162, 0, 27)
                toggle.Parent = sectionFrame
                
                if Info.Tooltip ~= "" then
                    AddTooltip(toggle, Info.Tooltip)
                end
                
                local toggleText = Instance.new("TextLabel")
                toggleText.Font = Enum.Font.GothamBold
                toggleText.Text = Info.Text
                toggleText.TextColor3 = Color3.fromRGB(217, 217, 217)
                toggleText.TextSize = 11
                toggleText.TextXAlignment = Enum.TextXAlignment.Left
                toggleText.BackgroundTransparency = 1
                toggleText.Position = UDim2.new(0.0488, 0, 0, 0)
                toggleText.Size = UDim2.new(0, 156, 0, 27)
                toggleText.Parent = toggle
                
                local toggleButton = Instance.new("TextButton")
                toggleButton.Text = ""
                toggleButton.BackgroundTransparency = 1
                toggleButton.Size = UDim2.new(0, 162, 0, 27)
                toggleButton.Parent = toggle
                
                local toggleFrame = Instance.new("Frame")
                toggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                toggleFrame.BorderSizePixel = 0
                toggleFrame.Position = UDim2.new(0.783, 0, 0.222, 0)
                toggleFrame.Size = UDim2.new(0, 32, 0, 16)
                toggleFrame.Parent = toggle
                
                ColorElements[toggleFrame] = {Type = "Toggle", Enabled = false}
                
                local toggleUICorner = Instance.new("UICorner")
                toggleUICorner.CornerRadius = UDim.new(1, 0)
                toggleUICorner.Parent = toggleFrame
                
                -- Toggle Stroke
                local toggleStroke = Instance.new("UIStroke")
                toggleStroke.Color = Color3.fromRGB(80, 80, 100)
                toggleStroke.Thickness = 1
                toggleStroke.Transparency = 0.5
                toggleStroke.Parent = toggleFrame
                
                local circleIcon = Instance.new("Frame")
                circleIcon.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
                circleIcon.BorderSizePixel = 0
                circleIcon.Position = UDim2.new(0, 2, 0.125, 0)
                circleIcon.Size = UDim2.new(0, 12, 0, 12)
                circleIcon.Parent = toggleFrame
                
                local circleCorner = Instance.new("UICorner")
                circleCorner.CornerRadius = UDim.new(1, 0)
                circleCorner.Parent = circleIcon
                
                -- Circle Shadow
                local circleShadow = Instance.new("UIStroke")
                circleShadow.Color = Color3.fromRGB(0, 0, 0)
                circleShadow.Thickness = 2
                circleShadow.Transparency = 0.8
                circleShadow.Parent = circleIcon
                
                function insidetoggle:Set(bool)
                    Toggled = bool
                    if Info.Flag ~= nil then
                        library.Flags[Info.Flag] = Toggled
                    end
                    
                    ColorElements[toggleFrame].Enabled = Toggled
                    
                    TweenService:Create(circleIcon, TweenInfo.new(.2, Enum.EasingStyle.Quad), {Position = Toggled and UDim2.new(0, 18, 0.125, 0) or UDim2.new(0, 2, 0.125, 0)}):Play()
                    
                    if not Toggled then
                        TweenService:Create(toggleFrame, TweenInfo.new(.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}):Play()
                        TweenService:Create(toggleStroke, TweenInfo.new(.2, Enum.EasingStyle.Quad), {Color = Color3.fromRGB(80, 80, 100)}):Play()
                    elseif Toggled and not EditOpened then
                        TweenService:Create(toggleFrame, TweenInfo.new(.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(80, 180, 255)}):Play()
                        TweenService:Create(toggleStroke, TweenInfo.new(.2, Enum.EasingStyle.Quad), {Color = Color3.fromRGB(100, 200, 255)}):Play()
                    end
                    
                    pcall(Info.Callback, Toggled)
                end
                
                if Info.Default then
                    task.spawn(function()
                        insidetoggle:Set(true)
                    end)
                end
                
                toggleButton.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    insidetoggle:Set(Toggled)
                end)
                
                return insidetoggle
            end
            
            -- Button Element
            function sectiontable:Button(Info)
                Info.Text = Info.Text or "Button"
                Info.Callback = Info.Callback or function() end
                Info.Tooltip = Info.Tooltip or ""
                
                local button = Instance.new("Frame")
                button.Name = "Button"
                button.BackgroundTransparency = 1
                button.Size = UDim2.new(0, 162, 0, 27)
                button.Parent = sectionFrame
                
                if Info.Tooltip ~= "" then
                    AddTooltip(button, Info.Tooltip)
                end
                
                local buttonText = Instance.new("TextLabel")
                buttonText.Font = Enum.Font.GothamBold
                buttonText.Text = Info.Text
                buttonText.TextColor3 = Color3.fromRGB(217, 217, 217)
                buttonText.TextSize = 11
                buttonText.TextXAlignment = Enum.TextXAlignment.Left
                buttonText.BackgroundTransparency = 1
                buttonText.Position = UDim2.new(0.0488, 0, 0, 0)
                buttonText.Size = UDim2.new(0, 156, 0, 27)
                buttonText.Parent = button
                
                local textButton = Instance.new("TextButton")
                textButton.Text = ""
                textButton.BackgroundTransparency = 1
                textButton.Size = UDim2.new(0, 162, 0, 27)
                textButton.Parent = button
                
                textButton.MouseButton1Click:Connect(function()
                    task.spawn(function()
                        pcall(Info.Callback)
                    end)
                end)
            end
            
            -- Label Element
            function sectiontable:Label(Info)
                Info.Text = Info.Text or "Label"
                Info.Color = Info.Color or Color3.fromRGB(217, 217, 217)
                Info.Tooltip = Info.Tooltip or ""
                
                local insidelabel = {}
                
                local label = Instance.new("Frame")
                label.Name = "Label"
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(0, 162, 0, 27)
                label.Parent = sectionFrame
                
                if Info.Tooltip ~= "" then
                    AddTooltip(label, Info.Tooltip)
                end
                
                local labelText = Instance.new("TextLabel")
                labelText.Font = Enum.Font.GothamBold
                labelText.TextColor3 = Info.Color
                labelText.Text = Info.Text
                labelText.TextSize = 11
                labelText.TextXAlignment = Enum.TextXAlignment.Left
                labelText.BackgroundTransparency = 1
                labelText.Position = UDim2.new(0.0488, 0, 0, 0)
                labelText.Size = UDim2.new(0, 156, 0, 27)
                labelText.Parent = label
                
                function insidelabel:Set(SetInfo)
                    SetInfo.Text = SetInfo.Text or labelText.Text
                    SetInfo.Color = SetInfo.Color or labelText.TextColor3
                    labelText.Text = SetInfo.Text
                    labelText.TextColor3 = SetInfo.Color
                end
                
                return insidelabel
            end
            
            -- Slider Element
            function sectiontable:Slider(Info)
                Info.Text = Info.Text or "Slider"
                Info.Default = Info.Default or 50
                Info.Minimum = Info.Minimum or 1
                Info.Maximum = Info.Maximum or 100
                Info.Flag = Info.Flag or nil
                Info.Postfix = Info.Postfix or ""
                Info.Callback = Info.Callback or function() end
                Info.Tooltip = Info.Tooltip or ""
                
                if Info.Minimum > Info.Maximum then
                    local ValueBefore = Info.Minimum
                    Info.Minimum, Info.Maximum = Info.Maximum, ValueBefore
                end
                
                Info.Default = math.clamp(Info.Default, Info.Minimum, Info.Maximum)
                local DefaultScale = (Info.Default - Info.Minimum) / (Info.Maximum - Info.Minimum)
                
                local slider = Instance.new("Frame")
                slider.Name = "Slider"
                slider.BackgroundTransparency = 1
                slider.Size = UDim2.new(0, 162, 0, 40)
                slider.Parent = sectionFrame
                
                if Info.Tooltip ~= "" then
                    AddTooltip(slider, Info.Tooltip)
                end
                
                local sliderText = Instance.new("TextLabel")
                sliderText.Font = Enum.Font.GothamBold
                sliderText.Text = Info.Text
                sliderText.TextColor3 = Color3.fromRGB(217, 217, 217)
                sliderText.TextSize = 11
                sliderText.TextXAlignment = Enum.TextXAlignment.Left
                sliderText.BackgroundTransparency = 1
                sliderText.Position = UDim2.new(0.0488, 0, 0, 0)
                sliderText.Size = UDim2.new(0, 156, 0, 27)
                sliderText.Parent = slider
                
                local outerSlider = Instance.new("Frame")
                outerSlider.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
                outerSlider.BorderSizePixel = 0
                outerSlider.Position = UDim2.new(0.049, -1, 0.664, 0)
                outerSlider.Size = UDim2.new(0, 149, 0, 4)
                outerSlider.Parent = slider
                
                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 100)
                sliderCorner.Parent = outerSlider
                
                local innerSlider = Instance.new("Frame")
                innerSlider.BackgroundColor3 = Color3.fromRGB(48, 207, 106)
                innerSlider.BorderSizePixel = 0
                innerSlider.Size = UDim2.new(DefaultScale, 0, 0, 4)
                innerSlider.ZIndex = 2
                innerSlider.Parent = outerSlider
                
                ColorElements[innerSlider] = {Type = "Slider", Enabled = false}
                
                local innerSliderCorner = Instance.new("UICorner")
                innerSliderCorner.CornerRadius = UDim.new(0, 100)
                innerSliderCorner.Parent = innerSlider
                
                local sliderValueText = Instance.new("TextLabel")
                sliderValueText.Font = Enum.Font.GothamBold
                sliderValueText.Text = tostring(Info.Default) .. Info.Postfix
                sliderValueText.TextColor3 = Color3.fromRGB(217, 217, 217)
                sliderValueText.TextSize = 11
                sliderValueText.TextXAlignment = Enum.TextXAlignment.Right
                sliderValueText.BackgroundTransparency = 1
                sliderValueText.Position = UDim2.new(0.0488, 0, 0, 0)
                sliderValueText.Size = UDim2.new(0, 149, 0, 27)
                sliderValueText.Parent = slider
                
                local sliderButton = Instance.new("TextButton")
                sliderButton.Text = ""
                sliderButton.BackgroundTransparency = 1
                sliderButton.Position = UDim2.new(0.049, 0, 0.664, 0)
                sliderButton.Size = UDim2.new(0, 149, 0, 4)
                sliderButton.Parent = slider
                
                task.spawn(function()
                    pcall(Info.Callback, Info.Default)
                    if Info.Flag ~= nil then
                        library.Flags[Info.Flag] = Info.Default
                    end
                end)
                
                sliderButton.MouseButton1Down:Connect(function()
                    local MouseMove, MouseKill
                    MouseMove = Mouse.Move:Connect(function()
                        local Px = library:GetXY(outerSlider)
                        local Value = math.floor(Info.Minimum + ((Info.Maximum - Info.Minimum) * Px))
                        
                        TweenService:Create(innerSlider, TweenInfo.new(0.1), {Size = UDim2.new(Px, 0, 0, 4)}):Play()
                        
                        if Info.Flag ~= nil then
                            library.Flags[Info.Flag] = Value
                        end
                        
                        sliderValueText.Text = tostring(Value) .. Info.Postfix
                        
                        task.spawn(function()
                            pcall(Info.Callback, Value)
                        end)
                    end)
                    
                    MouseKill = UserInputService.InputEnded:Connect(function(UserInput)
                        if UserInput.UserInputType == Enum.UserInputType.MouseButton1 then
                            MouseMove:Disconnect()
                            MouseKill:Disconnect()
                        end
                    end)
                end)
            end
            
            -- Input Element
            function sectiontable:Input(Info)
                Info.Placeholder = Info.Placeholder or "Input"
                Info.Flag = Info.Flag or nil
                Info.Callback = Info.Callback or function() end
                Info.Tooltip = Info.Tooltip or ""
                
                local input = Instance.new("Frame")
                input.Name = "Input"
                input.BackgroundTransparency = 1
                input.Size = UDim2.new(0, 162, 0, 27)
                input.Parent = sectionFrame
                
                if Info.Tooltip ~= "" then
                    AddTooltip(input, Info.Tooltip)
                end
                
                local inputOuter = Instance.new("Frame")
                inputOuter.AnchorPoint = Vector2.new(0.5, 0.5)
                inputOuter.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
                inputOuter.BorderSizePixel = 0
                inputOuter.ClipsDescendants = true
                inputOuter.Position = UDim2.new(0.5, 0, 0.5, 0)
                inputOuter.Size = UDim2.new(0, 154, 0, 21)
                inputOuter.Parent = input
                
                local inputUICorner = Instance.new("UICorner")
                inputUICorner.CornerRadius = UDim.new(0, 3)
                inputUICorner.Parent = inputOuter
                
                local inputUIStroke = Instance.new("UIStroke")
                inputUIStroke.Color = Color3.fromRGB(84, 84, 84)
                inputUIStroke.Parent = inputOuter
                
                local inputTextBox = Instance.new("TextBox")
                inputTextBox.CursorPosition = -1
                inputTextBox.Font = Enum.Font.GothamBold
                inputTextBox.PlaceholderColor3 = Color3.fromRGB(217, 217, 217)
                inputTextBox.PlaceholderText = Info.Placeholder
                inputTextBox.Text = ""
                inputTextBox.TextColor3 = Color3.fromRGB(237, 237, 237)
                inputTextBox.TextSize = 11
                inputTextBox.TextXAlignment = Enum.TextXAlignment.Left
                inputTextBox.BackgroundTransparency = 1
                inputTextBox.Position = UDim2.new(0.0253, 0, 0, 0)
                inputTextBox.Size = UDim2.new(0, 150, 0, 21)
                inputTextBox.Parent = inputOuter
                
                inputTextBox.FocusLost:Connect(function()
                    task.spawn(function()
                        pcall(Info.Callback, inputTextBox.Text)
                        if Info.Flag ~= nil then
                            library.Flags[Info.Flag] = inputTextBox.Text
                        end
                    end)
                end)
            end
            
            -- Keybind Element
            function sectiontable:Keybind(Info)
                Info.Text = Info.Text or "Keybind"
                Info.Default = Info.Default or Enum.KeyCode.F4
                Info.Callback = Info.Callback or function() end
                Info.Tooltip = Info.Tooltip or ""
                
                local PressKey = Info.Default
                
                local keybind = Instance.new("Frame")
                keybind.Name = "Keybind"
                keybind.BackgroundTransparency = 1
                keybind.Size = UDim2.new(0, 162, 0, 27)
                keybind.Parent = sectionFrame
                
                if Info.Tooltip ~= "" then
                    AddTooltip(keybind, Info.Tooltip)
                end
                
                local keybindText = Instance.new("TextLabel")
                keybindText.Font = Enum.Font.GothamBold
                keybindText.Text = Info.Text
                keybindText.TextColor3 = Color3.fromRGB(217, 217, 217)
                keybindText.TextSize = 11
                keybindText.TextXAlignment = Enum.TextXAlignment.Left
                keybindText.BackgroundTransparency = 1
                keybindText.Position = UDim2.new(0.0488, 0, 0, 0)
                keybindText.Size = UDim2.new(0, 156, 0, 27)
                keybindText.Parent = keybind
                
                local keybindFrame = Instance.new("Frame")
                keybindFrame.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
                keybindFrame.AnchorPoint = Vector2.new(1, 0)
                keybindFrame.BorderSizePixel = 0
                keybindFrame.Position = UDim2.new(0, 158, 0.222, 0)
                keybindFrame.Size = UDim2.new(0, 30, 0, 15)
                keybindFrame.Parent = keybind
                
                local keybindUICorner = Instance.new("UICorner")
                keybindUICorner.CornerRadius = UDim.new(0, 3)
                keybindUICorner.Parent = keybindFrame
                
                local keybindFrameText = Instance.new("TextLabel")
                keybindFrameText.Font = Enum.Font.GothamBold
                keybindFrameText.Text = PressKey.Name
                keybindFrameText.TextColor3 = Color3.fromRGB(217, 217, 217)
                keybindFrameText.TextSize = 11
                keybindFrameText.BackgroundTransparency = 1
                keybindFrameText.Size = UDim2.new(1, 0, 0, 15)
                keybindFrameText.Parent = keybindFrame
                
                local keybindButton = Instance.new("TextButton")
                keybindButton.Text = ""
                keybindButton.BackgroundTransparency = 1
                keybindButton.Size = UDim2.new(1, 0, 0, 15)
                keybindButton.Parent = keybindFrame
                
                local keybindUIStroke = Instance.new("UIStroke")
                keybindUIStroke.Color = Color3.fromRGB(84, 84, 84)
                keybindUIStroke.Parent = keybindFrame
                
                local TextBounds = keybindFrameText.TextBounds
                keybindFrame.Size = UDim2.new(0, TextBounds.X + 10, 0, 15)
                
                keybindFrameText:GetPropertyChangedSignal("Text"):Connect(function()
                    TextBounds = keybindFrameText.TextBounds
                    keybindFrame.Size = UDim2.new(0, TextBounds.X + 10, 0, 15)
                end)
                
                local KeybindConnection
                local Changing = false
                
                keybindButton.MouseButton1Click:Connect(function()
                    if KeybindConnection then KeybindConnection:Disconnect() end
                    Changing = true
                    keybindFrameText.Text = "..."
                    
                    KeybindConnection = UserInputService.InputBegan:Connect(function(Key, gameProcessed)
                        if not table.find(Blacklist, Key.KeyCode) and not gameProcessed then
                            KeybindConnection:Disconnect()
                            keybindFrameText.Text = Key.KeyCode.Name
                            PressKey = Key.KeyCode
                            wait(.1)
                            Changing = false
                        end
                    end)
                end)
                
                UserInputService.InputBegan:Connect(function(Key, gameProcessed)
                    if not Changing and Key.KeyCode == PressKey and not gameProcessed then
                        task.spawn(function()
                            pcall(Info.Callback)
                        end)
                    end
                end)
            end
            
            -- Dropdown Element
            function sectiontable:Dropdown(Info)
                Info.Text = Info.Text or "Dropdown"
                Info.List = Info.List or {}
                Info.Flag = Info.Flag or nil
                Info.Callback = Info.Callback or function() end
                Info.Tooltip = Info.Tooltip or ""
                Info.Default = Info.Default or nil
                
                local DropdownYSize = 27
                
                if Info.Default ~= nil then
                    task.spawn(function()
                        pcall(Info.Callback, Info.Default)
                    end)
                    if Info.Flag ~= nil then
                        library.Flags[Info.Flag] = Info.Default
                    end
                end
                
                local insidedropdown = {}
                
                local dropdown = Instance.new("Frame")
                dropdown.Name = "Dropdown"
                dropdown.BackgroundTransparency = 1
                dropdown.Size = UDim2.new(0, 162, 0, 27)
                dropdown.ClipsDescendants = true
                dropdown.Parent = sectionFrame
                
                if Info.Tooltip ~= "" then
                    AddTooltip(dropdown, Info.Tooltip)
                end
                
                local dropdownText = Instance.new("TextLabel")
                dropdownText.Font = Enum.Font.GothamBold
                dropdownText.Text = Info.Text
                dropdownText.TextColor3 = Color3.fromRGB(217, 217, 217)
                dropdownText.TextSize = 11
                dropdownText.TextXAlignment = Enum.TextXAlignment.Left
                dropdownText.BackgroundTransparency = 1
                dropdownText.Position = UDim2.new(0.0488, 0, 0, 0)
                dropdownText.Size = UDim2.new(0, 156, 0, 27)
                dropdownText.Parent = dropdown
                
                local dropdownIcon = Instance.new("TextLabel")
                dropdownIcon.Text = "▼"
                dropdownIcon.Font = Enum.Font.GothamBold
                dropdownIcon.TextSize = 10
                dropdownIcon.TextColor3 = Color3.fromRGB(191, 191, 191)
                dropdownIcon.AnchorPoint = Vector2.new(1, 0)
                dropdownIcon.BackgroundTransparency = 1
                dropdownIcon.Position = UDim2.new(0, 155, 0, 7)
                dropdownIcon.Size = UDim2.new(0, 13, 0, 13)
                dropdownIcon.ZIndex = 2
                dropdownIcon.Parent = dropdown
                
                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Text = ""
                dropdownButton.BackgroundTransparency = 1
                dropdownButton.Size = UDim2.new(0, 162, 0, 27)
                dropdownButton.Parent = dropdown
                
                local dropdownContainer = Instance.new("Frame")
                dropdownContainer.BackgroundTransparency = 1
                dropdownContainer.BorderSizePixel = 0
                dropdownContainer.Size = UDim2.new(0, 162, 0, 27)
                dropdownContainer.Visible = true
                dropdownContainer.Parent = dropdown
                
                local dropdownuIListLayout = Instance.new("UIListLayout")
                dropdownuIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                dropdownuIListLayout.Parent = dropdownContainer
                
                local dropdownuIPadding = Instance.new("UIPadding")
                dropdownuIPadding.PaddingTop = UDim.new(0, 27)
                dropdownuIPadding.Parent = dropdownContainer
                
                local DropdownOpened = false
                
                function insidedropdown:Add(text)
                    DropdownYSize = DropdownYSize + 27
                    
                    local dropdownContainerButton = Instance.new("Frame")
                    dropdownContainerButton.BackgroundTransparency = 1
                    dropdownContainerButton.Size = UDim2.new(0, 162, 0, 27)
                    dropdownContainerButton.Parent = dropdownContainer
                    
                    local dropdownbuttonText = Instance.new("TextLabel")
                    dropdownbuttonText.Font = Enum.Font.GothamBold
                    dropdownbuttonText.Text = text
                    dropdownbuttonText.TextColor3 = Color3.fromRGB(191, 191, 191)
                    dropdownbuttonText.TextSize = 11
                    dropdownbuttonText.TextXAlignment = Enum.TextXAlignment.Left
                    dropdownbuttonText.BackgroundTransparency = 1
                    dropdownbuttonText.Position = UDim2.new(0.0488, 0, 0, 0)
                    dropdownbuttonText.Size = UDim2.new(0, 156, 0, 28)
                    dropdownbuttonText.Parent = dropdownContainerButton
                    
                    local dropdownContainerTextButton = Instance.new("TextButton")
                    dropdownContainerTextButton.Text = ""
                    dropdownContainerTextButton.BackgroundTransparency = 1
                    dropdownContainerTextButton.Size = UDim2.new(0, 162, 0, 27)
                    dropdownContainerTextButton.Parent = dropdownContainerButton
                    
                    dropdownContainerTextButton.MouseEnter:Connect(function()
                        TweenService:Create(dropdownbuttonText, TweenInfo.new(.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                    end)
                    
                    dropdownContainerTextButton.MouseLeave:Connect(function()
                        TweenService:Create(dropdownbuttonText, TweenInfo.new(.15), {TextColor3 = Color3.fromRGB(191, 191, 191)}):Play()
                    end)
                    
                    dropdownContainerTextButton.MouseButton1Click:Connect(function()
                        DropdownOpened = false
                        
                        task.spawn(function()
                            pcall(Info.Callback, dropdownbuttonText.Text)
                        end)
                        
                        if Info.Flag ~= nil then
                            library.Flags[Info.Flag] = dropdownbuttonText.Text
                        end
                        
                        dropdownText.Text = dropdownbuttonText.Text
                        
                        TweenService:Create(dropdownIcon, TweenInfo.new(.15), {Rotation = DropdownOpened and -180 or -90}):Play()
                        TweenService:Create(dropdownIcon, TweenInfo.new(.15), {TextColor3 = DropdownOpened and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(191, 191, 191)}):Play()
                        TweenService:Create(dropdown, TweenInfo.new(.15), {Size = DropdownOpened and UDim2.new(0, 162, 0, DropdownYSize) or UDim2.new(0, 162, 0, 27)}):Play()
                        TweenService:Create(dropdownContainer, TweenInfo.new(.15), {Size = DropdownOpened and UDim2.new(0, 162, 0, DropdownYSize) or UDim2.new(0, 162, 0, 27)}):Play()
                        TweenService:Create(dropdownContainer, TweenInfo.new(.15), {BackgroundTransparency = DropdownOpened and .96 or 1}):Play()
                    end)
                end
                
                function insidedropdown:Refresh(RefreshInfo)
                    RefreshInfo.List = RefreshInfo.List or Info.List
                    
                    for _, v in pairs(dropdownContainer:GetChildren()) do
                        if v.ClassName == "Frame" then
                            DropdownYSize = DropdownYSize - 27
                            v:Destroy()
                        end
                    end
                    
                    DropdownOpened = false
                    
                    for _, v in pairs(RefreshInfo.List) do
                        insidedropdown:Add(v)
                    end
                    
                    TweenService:Create(dropdown, TweenInfo.new(.15), {Size = UDim2.new(0, 162, 0, 27)}):Play()
                end
                
                for _, v in pairs(Info.List) do
                    insidedropdown:Add(v)
                end
                
                dropdownButton.MouseButton1Click:Connect(function()
                    DropdownOpened = not DropdownOpened
                    
                    TweenService:Create(dropdownIcon, TweenInfo.new(.15), {Rotation = DropdownOpened and 180 or 0}):Play()
                    TweenService:Create(dropdownIcon, TweenInfo.new(.15), {TextColor3 = DropdownOpened and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(191, 191, 191)}):Play()
                    TweenService:Create(dropdown, TweenInfo.new(.15), {Size = DropdownOpened and UDim2.new(0, 162, 0, DropdownYSize) or UDim2.new(0, 162, 0, 27)}):Play()
                    TweenService:Create(dropdownContainer, TweenInfo.new(.15), {Size = DropdownOpened and UDim2.new(0, 162, 0, DropdownYSize) or UDim2.new(0, 162, 0, 27)}):Play()
                    TweenService:Create(dropdownContainer, TweenInfo.new(.15), {BackgroundTransparency = DropdownOpened and .96 or 1}):Play()
                end)
                
                return insidedropdown
            end
            
            -- RadioButton Element
            function sectiontable:RadioButton(Info)
                Info.Text = Info.Text or "Radio Button"
                Info.Options = Info.Options or {}
                Info.Flag = Info.Flag or nil
                Info.Callback = Info.Callback or function() end
                Info.Tooltip = Info.Tooltip or ""
                Info.Default = Info.Default or nil
                
                local RadioOpened = false
                local RadioYSize = 27
                
                if Info.Default ~= nil then
                    task.spawn(function()
                        pcall(Info.Callback, Info.Default)
                    end)
                    if Info.Flag ~= nil then
                        library.Flags[Info.Flag] = Info.Default
                    end
                end
                
                local insideradio = {}
                
                local radioButton = Instance.new("Frame")
                radioButton.Name = "RadioButton"
                radioButton.BackgroundTransparency = 1
                radioButton.Size = UDim2.new(0, 162, 0, 27)
                radioButton.Parent = sectionFrame
                
                if Info.Tooltip ~= "" then
                    AddTooltip(radioButton, Info.Tooltip)
                end
                
                local button = Instance.new("Frame")
                button.BackgroundTransparency = 1
                button.Size = UDim2.new(0, 162, 0, 27)
                button.Parent = radioButton
                
                local radioButtonTextButton = Instance.new("TextButton")
                radioButtonTextButton.Text = ""
                radioButtonTextButton.BackgroundTransparency = 1
                radioButtonTextButton.Size = UDim2.new(0, 162, 0, 27)
                radioButtonTextButton.Parent = button
                
                local radioButtonText = Instance.new("TextLabel")
                radioButtonText.Font = Enum.Font.GothamBold
                radioButtonText.Text = Info.Text
                radioButtonText.TextColor3 = Color3.fromRGB(217, 217, 217)
                radioButtonText.TextSize = 11
                radioButtonText.TextXAlignment = Enum.TextXAlignment.Left
                radioButtonText.BackgroundTransparency = 1
                radioButtonText.Position = UDim2.new(0.0488, 0, 0, 0)
                radioButtonText.Size = UDim2.new(0, 156, 0, 27)
                radioButtonText.Parent = button
                
                local radioButtonIcon = Instance.new("TextLabel")
                radioButtonIcon.Text = "▼"
                radioButtonIcon.Font = Enum.Font.GothamBold
                radioButtonIcon.TextSize = 10
                radioButtonIcon.AnchorPoint = Vector2.new(1, 0)
                radioButtonIcon.TextColor3 = Color3.fromRGB(191, 191, 191)
                radioButtonIcon.BackgroundTransparency = 1
                radioButtonIcon.Position = UDim2.new(0, 155, 0, 7)
                radioButtonIcon.Size = UDim2.new(0, 13, 0, 13)
                radioButtonIcon.Parent = button
                
                local radioButtonIcon2 = Instance.new("TextLabel")
                radioButtonIcon2.Text = "○"
                radioButtonIcon2.Font = Enum.Font.GothamBold
                radioButtonIcon2.TextSize = 12
                radioButtonIcon2.AnchorPoint = Vector2.new(1, 0)
                radioButtonIcon2.TextColor3 = Color3.fromRGB(191, 191, 191)
                radioButtonIcon2.BackgroundTransparency = 1
                radioButtonIcon2.Position = UDim2.new(0, 138, 0, 7)
                radioButtonIcon2.Size = UDim2.new(0, 13, 0, 13)
                radioButtonIcon2.Parent = button
                
                local radioContainer = Instance.new("Frame")
                radioContainer.BackgroundTransparency = 1
                radioContainer.Size = UDim2.new(0, 162, 0, 27)
                radioContainer.ClipsDescendants = true
                radioContainer.Parent = radioButton
                
                local radioUILayout = Instance.new("UIListLayout")
                radioUILayout.SortOrder = Enum.SortOrder.LayoutOrder
                radioUILayout.Parent = radioContainer
                
                local radiouIPadding = Instance.new("UIPadding")
                radiouIPadding.PaddingTop = UDim.new(0, 27)
                radiouIPadding.Parent = radioContainer
                
                local RadioSelected = nil
                
                function insideradio:Button(text)
                    RadioYSize = RadioYSize + 27
                    
                    local radio = Instance.new("Frame")
                    radio.Name = "Radio"
                    radio.BackgroundTransparency = 1
                    radio.Size = UDim2.new(0, 162, 0, 27)
                    radio.Parent = radioContainer
                    
                    local radioTextButton = Instance.new("TextButton")
                    radioTextButton.Text = ""
                    radioTextButton.BackgroundTransparency = 1
                    radioTextButton.Size = UDim2.new(0, 162, 0, 27)
                    radioTextButton.Parent = radio
                    
                    local radioOuter = Instance.new("TextLabel")
                    radioOuter.Name = "RadioOuter"
                    radioOuter.Text = "○"
                    radioOuter.Font = Enum.Font.GothamBold
                    radioOuter.TextSize = 14
                    radioOuter.TextColor3 = Color3.fromRGB(191, 191, 191)
                    radioOuter.BackgroundTransparency = 1
                    radioOuter.Position = UDim2.new(0.865, 0, 0.185, 0)
                    radioOuter.Size = UDim2.new(0, 17, 0, 17)
                    radioOuter.Parent = radio
                    
                    local radioInner = Instance.new("TextLabel")
                    radioInner.Name = "RadioInner"
                    radioInner.Text = "●"
                    radioInner.Font = Enum.Font.GothamBold
                    radioInner.TextSize = 8
                    radioInner.TextColor3 = Color3.fromRGB(191, 191, 191)
                    radioInner.AnchorPoint = Vector2.new(0.5, 0.5)
                    radioInner.BackgroundTransparency = 1
                    radioInner.Position = UDim2.new(0.5, 0, 0.5, 0)
                    radioInner.Size = UDim2.new(0, 7, 0, 7)
                    radioInner.Parent = radioOuter
                    
                    ColorElements[radioInner] = {Type = "Toggle", Enabled = false}
                    ColorElements[radioOuter] = {Type = "Toggle", Enabled = false}
                    
                    local radioText = Instance.new("TextLabel")
                    radioText.Name = "RadioText"
                    radioText.Font = Enum.Font.GothamBold
                    radioText.Text = text
                    radioText.TextColor3 = Color3.fromRGB(191, 191, 191)
                    radioText.TextSize = 11
                    radioText.TextXAlignment = Enum.TextXAlignment.Left
                    radioText.BackgroundTransparency = 1
                    radioText.Position = UDim2.new(0.0488, 0, 0, 0)
                    radioText.Size = UDim2.new(0, 156, 0, 27)
                    radioText.Parent = radio
                    
                    radio.MouseEnter:Connect(function()
                        if RadioOpened and RadioSelected ~= radio then
                            TweenService:Create(radioText, TweenInfo.new(.15), {TextColor3 = Color3.fromRGB(217, 217, 217)}):Play()
                            TweenService:Create(radioInner, TweenInfo.new(.15), {TextColor3 = Color3.fromRGB(217, 217, 217)}):Play()
                            TweenService:Create(radioOuter, TweenInfo.new(.15), {TextColor3 = Color3.fromRGB(217, 217, 217)}):Play()
                        end
                    end)
                    
                    radio.MouseLeave:Connect(function()
                        if RadioOpened and RadioSelected ~= radio then
                            TweenService:Create(radioText, TweenInfo.new(.15), {TextColor3 = Color3.fromRGB(191, 191, 191)}):Play()
                            TweenService:Create(radioInner, TweenInfo.new(.15), {TextColor3 = Color3.fromRGB(191, 191, 191)}):Play()
                            TweenService:Create(radioOuter, TweenInfo.new(.15), {TextColor3 = Color3.fromRGB(191, 191, 191)}):Play()
                        end
                    end)
                    
                    radioTextButton.MouseButton1Click:Connect(function()
                        task.spawn(function()
                            pcall(Info.Callback, radioText.Text)
                        end)
                        
                        if Info.Flag ~= nil then
                            library.Flags[Info.Flag] = radioText.Text
                        end
                        
                        ColorElements[radioInner].Enabled = true
                        ColorElements[radioOuter].Enabled = true
                        RadioSelected = radio
                        
                        for _, v in pairs(radioContainer:GetChildren()) do
                            if v.ClassName == "Frame" and v ~= radio then
                                ColorElements[v.RadioOuter].Enabled = false
                                ColorElements[v.RadioOuter.RadioInner].Enabled = false
                                TweenService:Create(v.RadioOuter, TweenInfo.new(.15), {TextColor3 = Color3.fromRGB(191, 191, 191)}):Play()
                                TweenService:Create(v.RadioOuter.RadioInner, TweenInfo.new(.15), {TextColor3 = Color3.fromRGB(191, 191, 191)}):Play()
                                TweenService:Create(v.RadioText, TweenInfo.new(.15), {TextColor3 = Color3.fromRGB(191, 191, 191)}):Play()
                            end
                        end
                        
                        TweenService:Create(radioText, TweenInfo.new(.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                        
                        if not EditOpened then
                            TweenService:Create(radioInner, TweenInfo.new(.15), {TextColor3 = RadioOpened and Color3.fromRGB(48, 207, 106) or Color3.fromRGB(191, 191, 191)}):Play()
                            TweenService:Create(radioOuter, TweenInfo.new(.15), {TextColor3 = RadioOpened and Color3.fromRGB(48, 207, 106) or Color3.fromRGB(191, 191, 191)}):Play()
                        end
                    end)
                end
                
                radioButtonTextButton.MouseButton1Click:Connect(function()
                    RadioOpened = not RadioOpened
                    
                    TweenService:Create(radioButtonIcon, TweenInfo.new(.15), {TextColor3 = RadioOpened and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(191, 191, 191)}):Play()
                    TweenService:Create(radioButtonIcon, TweenInfo.new(.15), {Rotation = RadioOpened and 180 or 0}):Play()
                    TweenService:Create(radioButtonIcon2, TweenInfo.new(.15), {TextColor3 = RadioOpened and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(191, 191, 191)}):Play()
                    TweenService:Create(radioButton, TweenInfo.new(.15), {Size = RadioOpened and UDim2.new(0, 162, 0, RadioYSize) or UDim2.new(0, 162, 0, 27)}):Play()
                    TweenService:Create(radioContainer, TweenInfo.new(.15), {Size = RadioOpened and UDim2.new(0, 162, 0, RadioYSize) or UDim2.new(0, 162, 0, 27)}):Play()
                    TweenService:Create(radioContainer, TweenInfo.new(.15), {BackgroundTransparency = RadioOpened and .96 or 1}):Play()
                end)
                
                for _, v in pairs(Info.Options) do
                    insideradio:Button(v)
                end
                
                return insideradio
            end
            
            return sectiontable
        end
        
        -- Tab Selection
        tabTextButton.MouseButton1Click:Connect(function()
            TabSelected = tabFrame
            
            task.spawn(function()
                for _, v in pairs(main:GetChildren()) do
                    if v.Name == "LeftContainer" or v.Name == "RightContainer" then
                        v.Visible = false
                    end
                end
            end)
            
            for _, v in pairs(scrollingContainer:GetChildren()) do
                if v ~= tabButton and v.Name == "TabButton" then
                    TweenService:Create(v.TabFrame, TweenInfo.new(.15), {BackgroundTransparency = .96}):Play()
                end
            end
            
            TweenService:Create(tabFrame, TweenInfo.new(.15), {BackgroundTransparency = .85}):Play()
            leftContainer.Visible = true
            rightContainer.Visible = true
        end)
        
        function tab:Select()
            TabSelected = tabFrame
            
            task.spawn(function()
                for _, v in pairs(main:GetChildren()) do
                    if v.Name == "LeftContainer" or v.Name == "RightContainer" then
                        v.Visible = false
                    end
                end
            end)
            
            for _, v in pairs(scrollingContainer:GetChildren()) do
                if v ~= tabButton and v.Name == "TabButton" then
                    TweenService:Create(v.TabFrame, TweenInfo.new(.15), {BackgroundTransparency = .96}):Play()
                end
            end
            
            TweenService:Create(tabFrame, TweenInfo.new(.15), {BackgroundTransparency = .85}):Play()
            leftContainer.Visible = true
            rightContainer.Visible = true
        end
        
        return tab
    end
    
    return window
end

return library
