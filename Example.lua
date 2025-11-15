-- ตัวอย่างการใช้งาน Library UI
-- ถ้าโหลดจาก URL ใช้:
-- local Library = loadstring(game:HttpGet('YOUR_URL_HERE'))()

-- ถ้าโหลดจากไฟล์ local ใช้:
-- local Library = loadstring(readfile("Library.lua"))()

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/bi9g9/UI/refs/heads/main/Library.lua'))()
local Flags = Library.Flags

-- สร้าง Window (กด RightShift เพื่อปิด/เปิดเมนู)
local Window = Library:Window({
    Text = "My Script UI",
    ToggleKey = Enum.KeyCode.RightShift -- เปลี่ยนได้: RightShift, RightControl, Insert, Delete, etc.
})

-- สร้าง Tabs
local Tab = Window:Tab({Text = "Aiming"})
local Tab2 = Window:Tab({Text = "Visual"})

-- สร้าง Sections
local ChamsSection = Tab2:Section({Text = "Chams"})
local Section = Tab:Section({Text = "Aimbot"})
local Section2 = Tab:Section({Text = "FOV"})
local Section3 = Tab:Section({Text = "Misc", Side = "Right"})

-- เพิ่ม Elements ใน Chams Section
ChamsSection:Toggle({Text = "Enabled"})
ChamsSection:Toggle({Text = "Color"})
ChamsSection:Toggle({Text = "Filled"})
ChamsSection:Toggle({Text = "Team Check"})

-- เพิ่ม Elements ใน Aimbot Section
Section:Toggle({Text = "Enabled"})
Section:Toggle({Text = "Wall Check"})
Section:Toggle({Text = "Smooth Aimbot"})

-- เพิ่ม Elements ใน FOV Section
Section2:Toggle({Text = "Enabled"})
Section2:Toggle({Text = "Filled FOV"})
Section2:Toggle({
    Text = "FOV Transparency",
    Tooltip = "Changes your fov transparency."
})
Section2:Button({
    Text = "Reset FOV",
    Tooltip = "This resets your aimbot fov."
})

-- เพิ่ม Elements ใน Misc Section
Section3:Toggle({Text = "Infinite Ammo"})
Section3:Toggle({Text = "No Spread"})
Section3:Toggle({
    Text = "No Bullet Drop",
    Default = true
})
Section3:Toggle({Text = "Full Auto"})

local a = Section3:Toggle({Text = "No Recoil"})

local label = Section3:Label({
    Text = "This is a label.",
    Color = Color3.fromRGB(217, 97, 99),
    Tooltip = "This is a label."
})

-- Dropdown
local dropdown = Section:Dropdown({
    Text = "Dropdown",
    List = {"Head", "Torso", "Random"},
    Flag = "Choosen",
    Callback = function(v)
        warn(v)
    end
})

-- RadioButton
Section:RadioButton({
    Text = "RadioButton",
    Options = {"Legit", "Blatant"},
    Callback = function(v)
        warn(v)
    end
})

-- Toggle
Section:Toggle({Text = "Silent Aimbot"})

-- Input
Section:Input({
    Placeholder = "Webhook URL",
    Flag = "URL"
})

-- Keybind
Section:Keybind({
    Default = Enum.KeyCode.E,
    Text = "Aimbot Key",
    Callback = function()
        warn("Pressed")
    end
})

-- Slider
Section:Slider({
    Text = "Slider Test",
    Default = 5,
    Minimum = 0,
    Maximum = 50,
    Flag = "SliderFlag",
    Callback = function(v)
        warn(v)
    end
})

-- เลือก Tab แรก
Tab:Select()

-- ตัวอย่างการใช้งาน
wait(5)

-- อัพเดท Label
label:Set({Text = "This is a red label."})

-- เปิด Toggle
a:Set(true)

-- Refresh Dropdown (ถ้าต้องการ)
-- dropdown:Refresh({List = {"Head", "Feet"}})
