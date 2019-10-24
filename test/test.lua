
--  获取插件的插件名和插件表
local addonName, addon = ...

-- 设置插件的全局名称
Test = {};

--  当前玩家名
--local playerName = UnitName("player");

--	界面隐藏/显示
-- /run MinimapCluster:Hide();MainMenuBarArtFrame:Hide();PlayerFrame:Hide();MicroButtonAndBagsBar:Hide();StatusTrackingBarManager:Hide();MainMenuBarOverlayFrame:Hide();
-- /run MinimapCluster:Show();MainMenuBarArtFrame:Show();PlayerFrame:Show();MicroButtonAndBagsBar:Show();StatusTrackingBarManager:Show();

--[[-------------------------------------------------------------------------
--  从TOC文件中提取版本信息
-------------------------------------------------------------------------]]--
addon.version = GetAddOnMetadata(addonName, "Version")
print("当前插件版本:"..addon.version)
if addon.version == "@project-version" or addon.version == "wowi:version" then
    addon.version = "SCM"
end

--[[-------------------------------------------------------------------------
--  问候与测试本地化字符串
-------------------------------------------------------------------------]]--
function Tinom.OnLoad(self)
    self:RegisterEvent("ADDON_LOADED")
    self:SetScript("OnEvent", function(self, event, addon)
        if addon == "Tinom" then
            print(format("你好%s,%s插件已加载完成.",UnitName("player"),addon))
            print("本地化测试:"..Tinom.L["Hello Azeroth!"])
        end
    end)
end

--[[-------------------------------------------------------------------------
--  呱呱叫
-------------------------------------------------------------------------]]--
function Tinom.Test( ... )
    local arg1,arg2 = ...
    if (arg1 == "") then
        print(format("呱唧%s",arg1))
        SendChatMessage("呱唧","PARTY",nil);
    else
        C_FriendList.SendWho(arg1);
        local table = C_FriendList.GetWhoInfo(1)
        for k,v in pairs(table) do
            print(k,v)
        end
        --print( )
    end
    return "O(∩_∩)O"
end
SLASH_MYTEST1 = "/test"
SLASH_MYTEST2 = "/testttt"
SlashCmdList["MYTEST"] = Tinom.Test;

--[[-------------------------------------------------------------------------
--  小地图显示ping的人 !!功能暂未实现!!
-------------------------------------------------------------------------]]--
--[[ local addona = CreateFrame('ScrollingMessageFrame', false, Minimap)
　　addona:SetHeight(10)
　　addona:SetWidth(100)
　　addona:SetPoint('BOTTOM', Minimap, 0, 20)
　　addona:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
　　addona:SetJustifyH'CENTER'
　　addona:SetJustifyV'CENTER'
　　addona:SetMaxLines(1)
　　addona:SetFading(true)
　　addona:SetFadeDuration(3)
　　addona:SetTimeVisible(5)
　　addona:RegisterEvent'MINIMAP_PING'
　　addona:SetScript('OnEvent', function(self, event, u)
　　    local c = RAID_CLASS_COLORS[select(2,UnitClass(u))]
　　    local name = UnitName(u)
　　    addona:AddMessage(name, c.r, c.g, c.b)
　　end) ]]

--[[-------------------------------------------------------------------------
--  版本信息
-------------------------------------------------------------------------]]--
local function HelloWow( ... )
    local version_a,version_b,datea,version_c = GetBuildInfo()
    DEFAULT_CHAT_FRAME:AddMessage("Hello World!", 0.0, 0.0, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("当前版本号为:"..version_a, 1.0, 0.0, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("小版本号为:"..version_b, 0.0, 1.0, 0.0)
    DEFAULT_CHAT_FRAME:AddMessage("更新日期为:"..datea, 0.0, 0.0, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage("简写版本号为:"..version_c, 1.0, 1.0, 1.0,nil,2)
    dateb = date("%m/%d/%y %H:%M:%S")
    timea = time()
    timeb = time()-1118722038
    DEFAULT_CHAT_FRAME:AddMessage(dateb, 1.0, 1.0, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage(timea, 1.0, 1.0, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage(timeb, 1.0, 1.0, 1.0)
end

--[[-------------------------------------------------------------------------
--  创建一个框架
-------------------------------------------------------------------------]]--
local function Create_Frame(frame, width, height, offX, offY, name)
	local handle = CreateFrame("Frame", "TinomFrame"..name)
	handle:SetWidth(width)
	handle:SetHeight(height)
	handle:SetParent(frame)
	handle:EnableMouse(true)
	handle:SetMovable(true)
	handle:SetPoint("TOPLEFT", frame ,"TOPLEFT", offX, offY)
end

--[[-------------------------------------------------------------------------
--  在屏幕中间展示部落和联盟的图标
-------------------------------------------------------------------------]]--
function myframea( ... )
    local f = CreateFrame("Frame",nil,UIParent)
    f:SetFrameStrata("BACKGROUND")
    f:SetWidth(128) -- Set these to whatever height/width is needed 
    f:SetHeight(64) -- for your Texture

    local t = f:CreateTexture(nil,"BACKGROUND")
    t:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Factions.blp")
    t:SetAllPoints(f)
    f.texture = t

    f:SetPoint("CENTER",0,0)
    f:Show()
end

--[[-------------------------------------------------------------------------
--  创建一个框架,如果有喊话的事件,打印一条信息.
-------------------------------------------------------------------------]]--
function Dont_Yell( ... )
    local myframeb = CreateFrame("Frame")
    myframeb:RegisterEvent("CHAT_MSG_YELL")
    myframeb:SetScript("OnEvent", function(self, event, ...)
        print("啊啊啊!别叫了!")
        return true
    end)
end

--[[-------------------------------------------------------------------------
--  播放游戏音效
-------------------------------------------------------------------------]]--
local listSounds = {};
local i = 1;
function Test_PlaySound()
	for _,v in pairs(SOUNDKIT) do
		table.insert(listSounds,v)
	end
	table.sort(listSounds)

    if i < #listSounds then
        PlaySound(listSounds[i])
        print("当前播放:"..listSounds[i])
        i = i + 1;
    else
        print("播放完了")
    end
end

--[[-------------------------------------------------------------------------
--  弹出对话框
-------------------------------------------------------------------------]]--
-- StaticPopupDialogs["EXAMPLE_HELLOWORLD"] = {
--     text = "Do you want to greet the world today?",
--     button1 = "Yes",
--     button2 = "No",
--     OnAccept = function()
--         GreetTheWorld()
--     end,
--     timeout = 0,
--     whileDead = true,
--     hideOnEscape = true,
-- }

--[[-------------------------------------------------------------------------
--  设置面板
-------------------------------------------------------------------------]]--
MAINPANEL_LABEL = Tinom.L["TinomTest"];
--MAINPANEL_SUBTEXT = Tinom.L["在这里你可以控制插件主要功能的 开启/关闭 ."];
MAINPANEL_SUBTEXT = "去年高三帮好朋友给实验班的男孩子写一封信,只有“山有木兮木有枝”七个字,想让他领会后半句心悦君兮君不知的含义.第二天男孩子主动来班里送信,还是昨天那封,他在后面补充到“心悦君兮君已知,奈何十二寒窗苦,待到金榜题名时.”   后来这段故事无疾而终 愿你们遇到的每段感情都能有处安放"
MAINPANEL_CONTROLBOUTTON = Tinom.L["开启插件"];
--  主选项卡
function Tinom.InterfaceOptionsMainPanel_OnLoad( self )
    InterfaceOptions_AddCategory(self);
end

--  子选项卡
--[[ Tinom.childpanel = CreateFrame("Frame", "TinomChildpanel", Tinom.panel);
Tinom.childpanel.name = "子选项卡";
Tinom.childpanel.parent = Tinom.panel.name;
InterfaceOptions_AddCategory(Tinom.childpanel); ]]

--[[-------------------------------------------------------------------------
--  设置面板下拉框反应面板
-------------------------------------------------------------------------]]--
function TinomInterfaceOptionsMainPanelDropDown_OnEvent (self, event, ...)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		self.defaultValue = "SHIFT";
		--self.oldValue = GetModifiedClick("AUTOLOOTTOGGLE");
        --self.value = self.oldValue or self.defaultValue;
        self.value = self.defaultValue;
        --self.tooltip = _G["OPTION_TOOLTIP_AUTO_LOOT_"..self.value.."_KEY"];
        self.tooltip = self.value;

        UIDropDownMenu_SetWidth(self, 190);
		UIDropDownMenu_Initialize(self, TinomInterfaceOptionsMainPanelDropDown_Initialize);
		UIDropDownMenu_SetSelectedValue(self, self.value);

		self.SetValue =
			function (self, value)
				self.value = value;
				UIDropDownMenu_SetSelectedValue(self, value);
				--SetModifiedClick("AUTOLOOTTOGGLE", value);
				--SaveBindings(GetCurrentBindingSet());
				self.tooltip = value;
			end
		self.GetValue =
			function (self)
				return UIDropDownMenu_GetSelectedValue(self);
			end
		self.RefreshValue =
			function (self)
				UIDropDownMenu_Initialize(self, TinomInterfaceOptionsMainPanelDropDown_Initialize);
				UIDropDownMenu_SetSelectedValue(self, self.value);
            end
            
		self:UnregisterEvent(event);
	end
end

function TinomInterfaceOptionsMainPanelDropDown_OnClick(self)
	TinomInterfaceOptionsMainPanelDropDown:SetValue(self.value);
end

function TinomInterfaceOptionsMainPanelDropDown_Initialize(self)
	local selectedValue = UIDropDownMenu_GetSelectedValue(self);
	local info = UIDropDownMenu_CreateInfo();

    info.text = "啥啥啥";
	info.func = TinomInterfaceOptionsMainPanelDropDown_OnClick;
	info.value = "SHIFT";
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.tooltipTitle = "标题1";
    info.tooltipText = "内容1";
    info.tooltipOnButton = 1;
    --info.hasArrow = true;
    --info.menuTable = {1,2,3,4,5,6,7,8};
    UIDropDownMenu_AddButton(info);
    
    info.text = "恰恰恰";
	info.func = TinomInterfaceOptionsMainPanelDropDown_OnClick;
	info.value = "ALTy";
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.tooltipTitle = "标题2";
    info.tooltipText = "内容2";
    info.tooltipOnButton = nil;
	UIDropDownMenu_AddButton(info);
end


--[[-------------------------------------------------------------------------
--  设置面板-滑条模块
-------------------------------------------------------------------------]]--
MAINPANEL_SLIDERTEXT = "我是一个愚蠢的滑条";
function TinomInterfaceOptionsMainPanelSlider_OnLoad( self )
    self.type = CONTROLTYPE_SLIDER;
    self.tooltipText = "你好艾泽拉斯";
    --self:SetOrientation("HORIZONTAL");    --水平显示滑条
    --self:SetOrientation("VERTICAL")       --垂直显示滑条
    self:SetMinMaxValues(0,1);
    self:SetValueStep(0.05);
    self:SetValue(0.5);
    
    -- self.SetDisplayValue = self:SetValue; -->

    -- TinomInterfaceOptionsMainPanelSliderText:SetText("密你啊倒萨"); --><!-- 可以设置滑条的标题 -->
    _G[self:GetName().."Low"]:SetText("小小");
    TinomInterfaceOptionsMainPanelSliderHigh:SetText("大大");
end

--[[-------------------------------------------------------------------------
--  设置面板-按钮模块
-------------------------------------------------------------------------]]--
TINOM_BUTTON1 = "我是一个按钮";
Tinom_Button1_OnShow = true;

--[[-------------------------------------------------------------------------
--  设置面板-标签按钮1
-------------------------------------------------------------------------]]--
function TinomInterfaceOptionsMainPanelWhoIsTinomRaidButton_SelectBase()
	PanelTemplates_SelectTab(GraphicsButton);
	Graphics_:Show();
	GraphicsButton:SetFrameLevel( Graphics_:GetFrameLevel() + 1 );

	if ( Display_RaidSettingsEnabledCheckBox:GetChecked() ) then
		PanelTemplates_DeselectTab(RaidButton);
	else
		PanelTemplates_SetDisabledTabState(RaidButton);
	end
	RaidGraphics_:Hide();
	RaidButton:SetFrameLevel( Graphics_:GetFrameLevel() - 1 );
end

--[[-------------------------------------------------------------------------
--  设置面板-颜色滑条模块
-------------------------------------------------------------------------]]--
COLOR_SLIDER_RED = "红色";
COLOR_SLIDER_GREEN = "绿色";
COLOR_SLIDER_BLUE = "蓝色";
COLOR_SLIDER_ALPHA = "透明";
function WhoIsTinomColorSlider_OnLoad(  )
    local color = {"ColorRedSlider","ColorGreenSlider","ColorBlueSlider","ColorAlphaSlider"}
    for i,v in ipairs(color) do
        local frame = format("WhoIsTinom"..v)
        _G[frame].type = CONTROLTYPE_SLIDER;
        _G[frame]:SetMinMaxValues(0,1);
        _G[frame]:SetValueStep(0.05);
        _G[frame]:SetValue(0.5);
        if (v == "ColorAlphaSlider") then
            _G[frame.."Low"]:SetText("");
            _G[frame.."High"]:SetText("");
        else
            _G[frame.."Low"]:SetText("0");
            _G[frame.."High"]:SetText("1");
        end
    end

end

local ColorRedSlider = 0.5;
local ColorGreenSlider = 0.5;
local ColorBlueSlider = 0.5;
local ColorAlphaSlider = 0.5;
function WhoIsTinomColorSlider_OnChange( self,color,value )
    value = math.floor(value * 100 + 0.5) / 100;
    self.value = value;
    self:SetValue(value);
    if (color ~= "alpha") then
        _G[self:GetName().."Text2"]:SetText(self.value);
    end
	ColorRedSlider = WhoIsTinomColorRedSlider:GetValue();
	ColorGreenSlider = WhoIsTinomColorGreenSlider:GetValue();
	ColorBlueSlider = WhoIsTinomColorBlueSlider:GetValue();
	ColorAlphaSlider = WhoIsTinomColorAlphaSlider:GetValue();
    
    WhoIsTinom:SetBackdropBorderColor(ColorRedSlider, ColorGreenSlider, ColorBlueSlider, 1 - ColorAlphaSlider);
    WhoIsTinom:SetBackdropColor(ColorRedSlider, ColorGreenSlider, ColorBlueSlider, 1 - ColorAlphaSlider);
end

--[[-------------------------------------------------------------------------
--  一个带滚动条的编辑框:自动滚动
-------------------------------------------------------------------------]]--
function Test.ScrollFrame_EditBox_OnLoad(self)
	self:SetScript("OnCursorChanged",function (self, arg1, arg2,arg3,arg4)
		-- self:SetID(self:GetID() + 1)
		-- if taunts[self:GetID()] then
		-- self:SetText(taunts[self:GetID()])
		-- else
		-- self:Hide()
		-- end
		--arg1 = math.floor(arg1 + 0.5)
		--arg2 = math.floor(arg2 + 0.5)
		--arg3 = math.floor(arg3 + 0.5)
		--arg4 = math.floor(arg4 + 0.5)

		Test.ScrollFrame_EditBox_OnCursorChanged(self,arg1,arg2,arg3,arg4)
	end)
end

--[[-------------------------------------------------------------------------
--  一个带滚动条的编辑框:自动滚动
-------------------------------------------------------------------------]]--
local arrow = 0
function Test.ScrollFrame_EditBox_OnCursorChanged(self,arg1,arg2,arg3,arg4)
	local vsv = self:GetParent():GetVerticalScroll();
	local vsh  = self:GetParent():GetHeight();
	local ebh  = self:GetHeight();
	--vsv = math.floor(vsv + 0.5)
	--vsh = math.floor(vsh + 0.5)
	--<!-- self:SetCursorPosition(1) -->
	--<!-- self:GetCursorPosition() -->
	print("滚当条值:"..vsv.."滚动条高"..vsh.."光标Y:"..arg2.."行高:"..arg4.."文本框高度:"..ebh)

	-- if (滚动条当前值 + 文本框光标位置Y > 0) then
	-- 	光标在滚动条上方
	-- else (0 > 滚动条当前值 + 光标位置Y - 行高 + 滚动条高度)
	-- if (vs + arg2 > 0) or (0 > vs + arg2 - arg4 + h) then
	--   self:GetParent():SetVerticalScroll((arg2+h-arg4*2)*-1);
	-- end
	local eby = arg2;
	
	-- if ( ebh > vsh ) then
	-- 	if ( (eby+vsh-arg4) < 0) then
	-- 		self:GetParent():SetVerticalScroll((eby+vsh-arg4)*-1);
	-- 	end
	-- 	if ( (eby+vsh-arg4) > 0 ) then
	-- 		self:GetParent():SetVerticalScroll(0);
	-- 	end
	-- end
	if ( eby < arrow)then
		self:GetParent():SetVerticalScroll(eby*-1);
	end

	arrow = arg2;
end

--[[-------------------------------------------------------------------------
--  一个带滚动条的编辑框
-------------------------------------------------------------------------]]--
-- local s = CreateFrame("ScrollFrame", nil, UIParent, "UIPanelScrollFrameTemplate") -- or you actual parent instead
-- s:SetSize(300,200)
-- s:SetPoint("CENTER")
-- local e = CreateFrame("EditBox", nil, s)
-- e:SetMultiLine(true)
-- e:SetFontObject(ChatFontNormal)
-- e:SetWidth(300)
-- s:SetScrollChild(e)
-- --- demo multi line text
-- e:SetText("line 1\nline 2\nline 3\nmore...\n\n\n\n\n\nanother one\n"
-- .."some very long...dsf v asdf a sdf asd df as df asdf a sdfd as ddf as df asd f asd fd asd f asdf LONG LINE\n\n\nsome more.\nlast!")
-- e:HighlightText() -- select all (if to be used for copy paste)
-- -- optional/just to close that frame
-- e:SetScript("OnEscapePressed", function()
--   s:Hide()
-- end)

--[[-------------------------------------------------------------------------
--  隐藏UI所有当前可见元素
-------------------------------------------------------------------------]]--
function TinomhideAll()
	if PlayerFrame:IsShown() then
		MinimapCluster:Hide();
		MainMenuBarArtFrame:Hide();
		PlayerFrame:Hide();
        MicroButtonAndBagsBar:Hide();
        StatusTrackingBarManager:Hide();
	else
		MinimapCluster:Show();
		MainMenuBarArtFrame:Show();
		PlayerFrame:Show();
        MicroButtonAndBagsBar:Show();
        StatusTrackingBarManager:Show();
	end
end
SLASH_TINOMSHOW = "/tinomhide"
SlashCmdList["TINOMSHOW"] = TinomhideAll;
--[[-------------------------------------------------------------------------
--  CVar查询,设置
-------------------------------------------------------------------------]]--
function Tinom.CVar( ... )
    --	脏话过滤
    Tinom.profanityFilter = GetCVarInfo("profanityFilter")
    if Tinom.profanityFilter == "1" then
        print("脏话过滤已开"..Tinom.profanityFilter)
        SetCVar("profanityFilter",0);
    else
        print("脏话过滤未开"..Tinom.profanityFilter)
    end
    --  角色名染色
    Tinom.colorChatNamesByClass = GetCVarInfo("colorChatNamesByClass")
    if Tinom.colorChatNamesByClass == "1" then
        print("角色名染色已开"..Tinom.colorChatNamesByClass)
    else
        print("角色名染色未开"..Tinom.colorChatNamesByClass)
        SetCVar("colorChatNamesByClass",1);
    end
    
    --  模型河蟹overrideArchive
    Tinom.overrideArchive = GetCVarInfo("overrideArchive")
    if Tinom.overrideArchive == "1" then
        print("模型河蟹已开"..Tinom.overrideArchive)
        SetCVar("overrideArchive",0);
    else
        print("模型河蟹未开"..Tinom.overrideArchive)
    end

end