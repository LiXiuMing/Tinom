
--  获取插件的插件名和插件表
local addonName, addon = ...
print(addonName,addon)

-- 设置插件的全局名称
--_G[addonName] = addon


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
            print(Tinom.L["Hello Azeroth!"])
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
local list;
local i = 1;
function Test_PlaySound()
    
    if list == nil then
        list = {}
        for _,v in pairs(SOUNDKIT) do
            table.insert(list,v)
        end
        table.sort(list)
    end

    if i < #list then
        PlaySound(list[i])
        print(list[i])
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
MAINPANEL_LABEL = Tinom.L["Tinom插件设置"];
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
--  重置的消息事件处理函数
-------------------------------------------------------------------------]]--
--[[ chatFilters = {};
function ChatFrame_MessageEventHandler(self, event, ...)
    --print(self.name);   --##
    if ( strsub(event, 1, 8) == "CHAT_MSG" ) then
		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 = ...;
		if (arg16) then
			-- hiding sender in letterbox: do NOT even show in chat window (only shows in cinematic frame)
			return true;
		end

		local type = strsub(event, 10);
		local info = ChatTypeInfo[type];

		local filter = false;
		if ( chatFilters[event] ) then
			local newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14;
			for _, filterFunc in next, chatFilters[event] do
				filter, newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14 = filterFunc(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14);
				if ( filter ) then
					return true;
				elseif ( newarg1 ) then
					arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14;
				end
			end
		end

		local coloredName = GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14);

		local channelLength = strlen(arg4);
		local infoType = type;
		if ( (type == "COMMUNITIES_CHANNEL") or ((strsub(type, 1, 7) == "CHANNEL") and (type ~= "CHANNEL_LIST") and ((arg1 ~= "INVITE") or (type ~= "CHANNEL_NOTICE_USER"))) ) then
			if ( arg1 == "WRONG_PASSWORD" ) then
				local staticPopup = _G[StaticPopup_Visible("CHAT_CHANNEL_PASSWORD") or ""];
				if ( staticPopup and strupper(staticPopup.data) == strupper(arg9) ) then
					-- Don't display invalid password messages if we're going to prompt for a password (bug 102312)
					return;
				end
			end

			local found = 0;
            for index, value in pairs(self.channelList) do
                --print(self.name,value)  --##
				if ( channelLength > strlen(value) ) then
					-- arg9 is the channel name without the number in front...
                    if ( ((arg7 > 0) and (self.zoneChannelList[index] == arg7)) or (strupper(value) == strupper(arg9)) ) then
						found = 1;
						infoType = "CHANNEL"..arg8;
						info = ChatTypeInfo[infoType];
						if ( (type == "CHANNEL_NOTICE") and (arg1 == "YOU_LEFT") ) then
							self.channelList[index] = nil;
							self.zoneChannelList[index] = nil;
						end
						break;
					end
				end
			end
			if ( (found == 0) or not info ) then
				return true;
			end
		end

		local chatGroup = Chat_GetChatCategory(type);
		local chatTarget;
		if ( chatGroup == "CHANNEL" ) then
			chatTarget = tostring(arg8);
		elseif ( chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" ) then
			if(not(strsub(arg2, 1, 2) == "|K")) then
				chatTarget = strupper(arg2);
			else
				chatTarget = arg2;
			end
		end

		if ( FCFManager_ShouldSuppressMessage(self, chatGroup, chatTarget) ) then
			return true;
		end

		if ( chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" ) then
			if ( self.privateMessageList and not self.privateMessageList[strlower(arg2)] ) then
				return true;
			elseif ( self.excludePrivateMessageList and self.excludePrivateMessageList[strlower(arg2)]
				and ( (chatGroup == "WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline") or (chatGroup == "BN_WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline") ) ) then
				return true;
			end
		end

		if (self.privateMessageList) then
			-- Dedicated BN whisper windows need online/offline messages for only that player
			if ( (chatGroup == "BN_INLINE_TOAST_ALERT" or chatGroup == "BN_WHISPER_PLAYER_OFFLINE") and not self.privateMessageList[strlower(arg2)] ) then
				return true;
			end

			-- HACK to put certain system messages into dedicated whisper windows
			if ( chatGroup == "SYSTEM") then
				local matchFound = false;
				local message = strlower(arg1);
				for playerName, _ in pairs(self.privateMessageList) do
					local playerNotFoundMsg = strlower(format(ERR_CHAT_PLAYER_NOT_FOUND_S, playerName));
					local charOnlineMsg = strlower(format(ERR_FRIEND_ONLINE_SS, playerName, playerName));
					local charOfflineMsg = strlower(format(ERR_FRIEND_OFFLINE_S, playerName));
					if ( message == playerNotFoundMsg or message == charOnlineMsg or message == charOfflineMsg) then
						matchFound = true;
						break;
					end
				end

				if (not matchFound) then
					return true;
				end
			end
		end

		if ( type == "SYSTEM" or type == "SKILL" or type == "CURRENCY" or type == "MONEY" or
		     type == "OPENING" or type == "TRADESKILLS" or type == "PET_INFO" or type == "TARGETICONS" or type == "BN_WHISPER_PLAYER_OFFLINE") then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id);
		elseif (type == "LOOT") then
			-- Append [Share] hyperlink if this is a valid social item and you are the looter.
			if (C_Social.IsSocialEnabled() and UnitGUID("player") == arg12) then
				-- Because it is being placed inside another hyperlink (the shareitem link created below), we have to strip off the hyperlink markup
				-- The item link markup will be added back in when the shareitem link is clicked (in ItemRef.lua) and then passed to the social panel
				local itemID, strippedItemLink = GetItemInfoFromHyperlink(arg1);
				if (itemID and C_Social.GetLastItem() == itemID) then
					arg1 = arg1 .. " " .. Social_GetShareItemLink(strippedItemLink, true);
				end
			end
			self:AddMessage(arg1, info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,7) == "COMBAT_" ) then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,6) == "SPELL_" ) then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,10) == "BG_SYSTEM_" ) then
			self:AddMessage(arg1, info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,11) == "ACHIEVEMENT" ) then
			-- Append [Share] hyperlink
			if (arg12 == UnitGUID("player") and C_Social.IsSocialEnabled()) then
				local achieveID = GetAchievementInfoFromHyperlink(arg1);
				if (achieveID) then
					arg1 = arg1 .. " " .. Social_GetShareAchievementLink(achieveID, true);
				end
			end
			self:AddMessage(arg1:format(GetPlayerLink(arg2, ("[%s]"):format(coloredName))), info.r, info.g, info.b, info.id);
		elseif ( strsub(type,1,18) == "GUILD_ACHIEVEMENT" ) then
			local message = arg1:format(GetPlayerLink(arg2, ("[%s]"):format(coloredName)));
			if (C_Social.IsSocialEnabled()) then
				local achieveID = GetAchievementInfoFromHyperlink(arg1);
				if (achieveID) then
					local isGuildAchievement = select(12, GetAchievementInfo(achieveID));
					if (isGuildAchievement) then
						message = message .. " " .. Social_GetShareAchievementLink(achieveID, true);
					end
				end
			end
			self:AddMessage(message, info.r, info.g, info.b, info.id);
		elseif ( type == "IGNORED" ) then
			self:AddMessage(format(CHAT_IGNORED, arg2), info.r, info.g, info.b, info.id);
		elseif ( type == "FILTERED" ) then
			self:AddMessage(format(CHAT_FILTERED, arg2), info.r, info.g, info.b, info.id);
		elseif ( type == "RESTRICTED" ) then
			self:AddMessage(CHAT_RESTRICTED_TRIAL, info.r, info.g, info.b, info.id);
		elseif ( type == "CHANNEL_LIST") then
            if(channelLength > 0) then
				self:AddMessage(format(_G["CHAT_"..type.."_GET"]..arg1, tonumber(arg8), arg4), info.r, info.g, info.b, info.id);
			else
				self:AddMessage(arg1, info.r, info.g, info.b, info.id);
			end
		elseif (type == "CHANNEL_NOTICE_USER") then
			local globalstring = _G["CHAT_"..arg1.."_NOTICE_BN"];
			if ( not globalstring ) then
				globalstring = _G["CHAT_"..arg1.."_NOTICE"];
			end
			if not globalstring then
				GMError(("Missing global string for %q"):format("CHAT_"..arg1.."_NOTICE_BN"));
				return;
			end
			if(arg5 ~= "") then
				-- TWO users in this notice (E.G. x kicked y)
				self:AddMessage(format(globalstring, arg8, arg4, arg2, arg5), info.r, info.g, info.b, info.id);
			elseif ( arg1 == "INVITE" ) then
				self:AddMessage(format(globalstring, arg4, arg2), info.r, info.g, info.b, info.id);
			else
				self:AddMessage(format(globalstring, arg8, arg4, arg2), info.r, info.g, info.b, info.id);
			end
			if ( arg1 == "INVITE" and GetCVarBool("blockChannelInvites") ) then
				self:AddMessage(CHAT_MSG_BLOCK_CHAT_CHANNEL_INVITE, info.r, info.g, info.b, info.id);
			end
		elseif (type == "CHANNEL_NOTICE") then
			local globalstring;
			if ( arg1 == "TRIAL_RESTRICTED" ) then
				globalstring = CHAT_TRIAL_RESTRICTED_NOTICE_TRIAL;
			else
				globalstring = _G["CHAT_"..arg1.."_NOTICE_BN"];
				if ( not globalstring ) then
					globalstring = _G["CHAT_"..arg1.."_NOTICE"];
					if not globalstring then
						GMError(("Missing global string for %q"):format("CHAT_"..arg1.."_NOTICE"));
						return;
					end
				end
			end
			local accessID = ChatHistory_GetAccessID(Chat_GetChatCategory(type), arg8);
			local typeID = ChatHistory_GetAccessID(infoType, arg8, arg12);
			self:AddMessage(format(globalstring, arg8, ChatFrame_ResolvePrefixedChannelName(arg4)), info.r, info.g, info.b, info.id, accessID, typeID);
		elseif ( type == "BN_INLINE_TOAST_ALERT" ) then
			local globalstring = _G["BN_INLINE_TOAST_"..arg1];
			if not globalstring then
				GMError(("Missing global string for %q"):format("BN_INLINE_TOAST_"..arg1));
				return;
			end
			local message;
			if ( arg1 == "FRIEND_REQUEST" ) then
				message = globalstring;
			elseif ( arg1 == "FRIEND_PENDING" ) then
				message = format(BN_INLINE_TOAST_FRIEND_PENDING, BNGetNumFriendInvites());
			elseif ( arg1 == "FRIEND_REMOVED" or arg1 == "BATTLETAG_FRIEND_REMOVED" ) then
				message = format(globalstring, arg2);
			elseif ( arg1 == "FRIEND_ONLINE" or arg1 == "FRIEND_OFFLINE") then
				local accountInfo = C_BattleNet.GetAccountInfoByID(arg13);
				if accountInfo and accountInfo.gameAccountInfo.clientProgram ~= "" then
					local characterName = BNet_GetValidatedCharacterNameWithClientEmbeddedTexture(accountInfo.gameAccountInfo.characterName, accountInfo.battleTag, accountInfo.gameAccountInfo.clientProgram, 14);
					local linkDisplayText = ("[%s] (%s)"):format(arg2, characterName);
					local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(type), 0);
					message = format(globalstring, playerLink);
				else
					local linkDisplayText = ("[%s]"):format(arg2);
					local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(type), 0);
					message = format(globalstring, playerLink);
				end
			else
				local linkDisplayText = ("[%s]"):format(arg2);
				local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(type), 0);
				message = format(globalstring, playerLink);
			end
			self:AddMessage(message, info.r, info.g, info.b, info.id);
		elseif ( type == "BN_INLINE_TOAST_BROADCAST" ) then
			if ( arg1 ~= "" ) then
				arg1 = RemoveNewlines(RemoveExtraSpaces(arg1));
				local linkDisplayText = ("[%s]"):format(arg2);
				local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, Chat_GetChatCategory(type), 0);
				self:AddMessage(format(BN_INLINE_TOAST_BROADCAST, playerLink, arg1), info.r, info.g, info.b, info.id);
			end
		elseif ( type == "BN_INLINE_TOAST_BROADCAST_INFORM" ) then
			if ( arg1 ~= "" ) then
				arg1 = RemoveExtraSpaces(arg1);
				self:AddMessage(BN_INLINE_TOAST_BROADCAST_INFORM, info.r, info.g, info.b, info.id);
			end
		else
			local body;

			local _, fontHeight = FCF_GetChatWindowInfo(self:GetID());

			if ( fontHeight == 0 ) then
				--fontHeight will be 0 if it's still at the default (14)
				fontHeight = 14;
			end

			-- Add AFK/DND flags
			local pflag;
			if(arg6 ~= "") then
				if ( arg6 == "GM" ) then
					--If it was a whisper, dispatch it to the GMChat addon.
					if ( type == "WHISPER" ) then
						return;
					end
					--Add Blizzard Icon, this was sent by a GM
					pflag = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ";
				elseif ( arg6 == "DEV" ) then
					--Add Blizzard Icon, this was sent by a Dev
					pflag = "|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t ";
				else
					pflag = _G["CHAT_FLAG_"..arg6];
				end
			else
				pflag = "";
			end
			if ( type == "WHISPER_INFORM" and GMChatFrame_IsGM and GMChatFrame_IsGM(arg2) ) then
				return;
			end

			local showLink = 1;
			if ( strsub(type, 1, 7) == "MONSTER" or strsub(type, 1, 9) == "RAID_BOSS") then
				showLink = nil;
			else
				arg1 = gsub(arg1, "%%", "%%%%");
			end

			-- Search for icon links and replace them with texture links.
			arg1 = C_ChatInfo.ReplaceIconAndGroupExpressions(arg1, arg17, not ChatFrame_CanChatGroupPerformExpressionExpansion(chatGroup)); -- If arg17 is true, don't convert to raid icons

			--Remove groups of many spaces
			arg1 = RemoveExtraSpaces(arg1);

			local playerLink;
			local playerLinkDisplayText = coloredName;
			local relevantDefaultLanguage = self.defaultLanguage;
			if ( (type == "SAY") or (type == "YELL") ) then
				relevantDefaultLanguage = self.alternativeDefaultLanguage;
			end
			local usingDifferentLanguage = (arg3 ~= "") and (arg3 ~= relevantDefaultLanguage);
			local usingEmote = (type == "EMOTE") or (type == "TEXT_EMOTE");

			if ( usingDifferentLanguage or not usingEmote ) then
				playerLinkDisplayText = ("[%s]"):format(coloredName);
			end

			local isCommunityType = type == "COMMUNITIES_CHANNEL";
			local playerName, lineID, bnetIDAccount = arg2, arg11, arg13;
			if ( isCommunityType ) then
				local isBattleNetCommunity = bnetIDAccount ~= nil and bnetIDAccount ~= 0;
				local messageInfo, clubId, streamId, clubType = C_Club.GetInfoFromLastCommunityChatLine();
				if (messageInfo ~= nil) then
					if ( isBattleNetCommunity ) then
						playerLink = GetBNPlayerCommunityLink(playerName, playerLinkDisplayText, bnetIDAccount, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position);
					else
						playerLink = GetPlayerCommunityLink(playerName, playerLinkDisplayText, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position);
					end
				else
					playerLink = playerLinkDisplayText;
				end
			else
				if ( type == "BN_WHISPER" or type == "BN_WHISPER_INFORM" ) then
					playerLink = GetBNPlayerLink(playerName, playerLinkDisplayText, bnetIDAccount, lineID, chatGroup, chatTarget);
				else
					playerLink = GetPlayerLink(playerName, playerLinkDisplayText, lineID, chatGroup, chatTarget);
				end
			end

			local message = arg1;
			if ( arg14 ) then	--isMobile
				message = ChatFrame_GetMobileEmbeddedTexture(info.r, info.g, info.b)..message;
			end

			if ( usingDifferentLanguage ) then
				local languageHeader = "["..arg3.."] ";
				if ( showLink and (arg2 ~= "") ) then
					body = format(_G["CHAT_"..type.."_GET"]..languageHeader..message, pflag..playerLink);
				else
					body = format(_G["CHAT_"..type.."_GET"]..languageHeader..message, pflag..arg2);
				end
			else
				if ( not showLink or arg2 == "" ) then
					if ( type == "TEXT_EMOTE" ) then
						body = message;
					else
						body = format(_G["CHAT_"..type.."_GET"]..message, pflag..arg2, arg2);
					end
				else
					if ( type == "EMOTE" ) then
						body = format(_G["CHAT_"..type.."_GET"]..message, pflag..playerLink);
					elseif ( type == "TEXT_EMOTE") then
						body = string.gsub(message, arg2, pflag..playerLink, 1);
					elseif (type == "GUILD_ITEM_LOOTED") then
						body = string.gsub(message, "$s", GetPlayerLink(arg2, playerLinkDisplayText));
					else
						body = format(_G["CHAT_"..type.."_GET"]..message, pflag..playerLink);
					end
				end
			end

			-- Add Channel
			if (channelLength > 0) then
				body = "|Hchannel:channel:"..arg8.."|h["..ChatFrame_ResolvePrefixedChannelName(arg4).."]|h "..body;
			end

			--Add Timestamps
			if ( CHAT_TIMESTAMP_FORMAT ) then
				body = BetterDate(CHAT_TIMESTAMP_FORMAT, time())..body;
			end

			local accessID = ChatHistory_GetAccessID(chatGroup, chatTarget);
			local typeID = ChatHistory_GetAccessID(infoType, chatTarget, arg12 or arg13);
			self:AddMessage(body, info.r, info.g, info.b, info.id, accessID, typeID);
		end

		if ( type == "WHISPER" or type == "BN_WHISPER" ) then
			--BN_WHISPER FIXME
			ChatEdit_SetLastTellTarget(arg2, type);
			if ( self.tellTimer and (GetTime() > self.tellTimer) ) then
				PlaySound(SOUNDKIT.TELL_MESSAGE);
			end
			self.tellTimer = GetTime() + CHAT_TELL_ALERT_TIME;
			--FCF_FlashTab(self);
			FlashClientIcon();
		end

		if ( not self:IsShown() ) then
			if ( (self == DEFAULT_CHAT_FRAME and info.flashTabOnGeneral) or (self ~= DEFAULT_CHAT_FRAME and info.flashTab) ) then
				if ( not CHAT_OPTIONS.HIDE_FRAME_ALERTS or type == "WHISPER" or type == "BN_WHISPER" ) then	--BN_WHISPER FIXME
					if (not FCFManager_ShouldSuppressMessageFlash(self, chatGroup, chatTarget) ) then
						FCF_StartAlertFlash(self);
					end
				end
			end
		end

		return true;
	end
end ]]