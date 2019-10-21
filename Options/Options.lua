--[[-------------------------------------------------------------------------
--
--  Options Setting
--  设置界面
--
--  功能:面向对象...没有发现对象...
--
-- L["去年高三帮好朋友给实验班的男孩子写一封信,只有“山有木兮木有枝”七个字,
-- 想让他领会后半句心悦君兮君不知的含义.第二天男孩子主动来班里送信,还是昨天那封,他在后面补充到“心悦君兮君已知,奈何十二寒窗苦,
-- 待到金榜题名时.”   后来这段故事无疾而终 愿你们遇到的每段感情都能有处安放"];
-------------------------------------------------------------------------]]--
local L = Tinom.L
Tinom.version = GetAddOnMetadata("Tinom", "Version")
--[[-------------------------------------------------------------------------
--  字符串:
-------------------------------------------------------------------------]]--
TINOM_OPTION_MAINPANEL_TITLE = L["Tinom聊天过滤v"]..Tinom.version;
TINOM_OPTION_MAINPANEL_SUBTEXT = L["Beta测试阶段,更新频繁.更新贴:NGA:搜索\"Tinom\".|cffffff00关键字默认支持正则表达式,若关键字中带有符号\( \) \. \% \+ \- \* \\ \? \[ \^ \$,请在符号前加\"\%\".如\"1\-60\"写成\"1\%\-60\"|r"];
TINOM_OPTION_MAINPANEL_CHACKBUTTON_MAINENABLE_TEXT = L["开启过滤"];

--[[-------------------------------------------------------------------------
--  默认配置:开关
-------------------------------------------------------------------------]]--
Tinom.defaultOptionsCheckButtons = {
	Tinom_Switch_MsgFilter_MainEnable = true,
	Tinom_Value_MsgFilter_FiltersList = {};
	Tinom_Switch_MsgFilter_AbbrChannelName = false,
	Tinom_Switch_MsgFilter_AbbrAuthorName = false,
	Tinom_Switch_MsgFilter_AutoBlackList = true,
	Tinom_Switch_MsgFilter_IgnoreGrayItems = false,
	Tinom_Value_MsgFilter_RepeatMsgElapsed = 0,
	Tinom_Value_MsgFilter_IntervalMsgTime = 0,

	Tinom_Switch_MsgFilter_SensitiveListSound = false,
	Tinom_Switch_MsgFilter_SensitiveListSoundID = 12867,
	Tinom_Switch_MsgFilter_SensitiveListHighlight = false,
	
	Tinom_Switch_MsgFilter_SensitiveKeywordSound = false,
	Tinom_Switch_MsgFilter_SensitiveKeywordSoundID = 12867,
	Tinom_Switch_MsgFilter_SensitiveKeywordHighlight = false,
};
--[[-------------------------------------------------------------------------
--  默认配置:复选按钮文本
-------------------------------------------------------------------------]]--
Tinom.defaultCheckButtonsName = {
	WhiteList = "白名单",
	WhiteListKeyword = "白关键字",
	BlackList = "黑名单",
	BlackListKeyword = "黑关键字",
	ReplaceName = "替换角色名",
	ReplaceNameMsg = "替换角色消息",
	ReplaceKeyword = "替换关键字",
	ReplaceKeywordMsg = "替换关键字消息",
	RepeatMsg = "屏蔽重复消息",
	SensitiveList = "敏感名单",
	SensitiveKeyword = "敏感关键字",
	AutoBlackList = "黑名单(自动)",
	WhiteListOnly = "只有白名单",
	AbbrChannelName = "缩写频道名",
	FoldMsg = "折叠复读消息",
	IgnoreGrayItems = "屏蔽灰色物品拾取消息",
	IntervalMsg = "发言间隔限制",
	AbbrAuthorName = "缩写玩家名",
};
Tinom.FilterFramesTitle = {
    WhiteList = 0,
    WhiteListKeyword = 0,
    BlackList = 0,
    BlackListKeyword = 0,
    ReplaceName = 0,
    ReplaceNameMsg = 0,
    ReplaceKeyword = 0,
    ReplaceKeywordMsg = 0,
    RepeatMsg = 0,
    SensitiveList = 0,
    SensitiveKeyword = 0,
    AutoBlackList = 0,
    FoldMsg = 0,
    IntervalMsg = 0,
};
Tinom.defaultCheckButtons = {
	[1] = {1, false, "WhiteList", "MsgFilter_Whitelist",},
	[2] = {2, false, "WhiteListKeyword", "MsgFilter_WhitelistKeyword",},
	[3] = {3, true, "BlackList", "MsgFilter_Blacklist",},
	[4] = {4, false, "BlackListKeyword", "MsgFilter_BlacklistKeyword",},
	[5] = {5, false, "ReplaceName", "MsgFilter_ReplaceName",},
	[6] = {6, false, "ReplaceNameMsg", "MsgFilter_ReplaceNameMsg",},
	[7] = {7, true, "ReplaceKeyword", "MsgFilter_ReplaceKeyword",},
	[8] = {8, false, "ReplaceKeywordMsg", "MsgFilter_ReplaceKeywordMsg",},
	[9] = {9, true, "RepeatMsg", "MsgFilter_RepeatMsg",},
	[10] = {10, false, "SensitiveList", "MsgFilter_SensitiveList",},
	[11] = {11, false, "SensitiveKeyword", "MsgFilter_SensitiveKeyword",},
	[12] = {12, false, "AutoBlackList", "MsgFilter_AutoBlackList",},
	[13] = {13, false, "FoldMsg", "MsgFilter_FoldMsg",},
	[14] = {14, false, "IntervalMsg", "MsgFilter_IntervalMsg",},
};
--[[-------------------------------------------------------------------------
--  地址索引:标签按钮 = 子设置界面
-------------------------------------------------------------------------]]--
Tinom.optionsTabButtons = {
	TinomOptionsMainPanelBaseTabButton = "TinomOptionsMainPanelBase",
	--TinomOptionsMainPanelWhiteListTabButton = "TinomOptionsMainPanelWhiteListSetting",
	--TinomOptionsMainPanelBlackListTabButton = "TinomOptionsMainPanelBlackListSetting",
	--TinomOptionsMainPanelReplaceListTabButton = "TinomOptionsMainPanelReplace",
};

--[[-------------------------------------------------------------------------
--  初始化:主设置面板加载
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_OnLoad( self )
	TinomOptionsMainPanelCheckButton_MainEnableText:SetText(L["开启过滤"]);
	TinomOptionsMainPanelCheckButton_MainEnable.tooltipText = L["开启过滤系统的主开关"];
	--设置面板的Okay响应函数,用于保存设置
	function self.okay(self)
		Tinom.OptionsMainPanel_Updata();
	end

	--设置面板的cancel响应函数,用于撤销修改
	function self.cancel(self)
		Tinom.OptionsMainPanel_LoadOptions();
	end

	--先为框架设置一个名字才能添加到设置面板的列表里
	self.name = L["Tinom聊天过滤"];
	InterfaceOptions_AddCategory(self);

	--可移动设置面板
	Tinom.OptionsPanel_EnableMovale();

	--标签按钮加载
	Tinom.OptionsTabButton_OnLoad();
end

--  初始化:各过滤开关复选框加载其字符串文本
function Tinom.OptionsBaseCheckButton_OnLoad(self)
	local buttonName = string.match(self:GetName(),"_(%S+)$");
	self.Text:SetText(Tinom.defaultCheckButtonsName[buttonName])
	--self.tooltipText = L["开启"]..v..L["过滤"];
end

--  总开关复选框函数:
function Tinom.OptionsMainEnableCheckButton_OnClick(self)
	Tinom.OptionsTabButton_OnLoad();
	if ( self:GetChecked() ) then
		Tinom.MsgFilterOn();
	else
		Tinom.MsgFilterOff();
	end
end

--  初始化:标签初始函数:
function Tinom.OptionsTabButton_OnLoad()
	Tinom.OptionsTabButton_Clear();
	if ( TinomOptionsMainPanelCheckButton_MainEnable:GetChecked() ) then
		PanelTemplates_SelectTab(TinomOptionsMainPanelBaseTabButton);
		TinomOptionsMainPanelBase:Show();
	end
end

--  开关复选框点击事件函数:
function Tinom.OptionsBaseSettingCheckButton_OnClick(self)
	
end

--[[-------------------------------------------------------------------------
--  设置界面框架可移动:
-------------------------------------------------------------------------]]--
function Tinom.OptionsPanel_EnableMovale()
	local InterfaceOptionsFrame = _G["InterfaceOptionsFrame"];
	InterfaceOptionsFrame:SetMovable(true);
	InterfaceOptionsFrame:EnableMouse(true);
	InterfaceOptionsFrame:RegisterForDrag("LeftButton");
	InterfaceOptionsFrame:SetScript("OnDragStart",function( self,event,... )
		if not self.isLocked then
			self:StartMoving();
		end
	end)
	InterfaceOptionsFrame:SetScript("OnDragStop",function( self,event,... )
		self:StopMovingOrSizing();
	end)
end

--[[-------------------------------------------------------------------------
--  入口:初始化:设置界面数据库检查
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_checkOptions()
	if (not TinomDB.Options.Default) then
		Tdebug(self,"log","Options.未发现配置数据库");
		TinomDB.Options.Default = Tinom.defaultOptionsCheckButtons;
		if ( TinomDB.Options.Default ) then
			Tdebug(self,"log","Options.配置数据库已初始化");
			Tinom.OptionsMainPanel_LoadOptions();
			return;
		else
			Tdebug(self,"error","Options.配置数据库初始化失败");
		end
	end
	Tdebug(self,"log","Options.数据库检查完成");
	Tinom.OptionsMainPanel_LoadOptions();
end

--[[-------------------------------------------------------------------------
--  初始化:设置界面加载配置
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_LoadOptions()
	TinomOptionsMainPanelCheckButton_MainEnable:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_MainEnable);
	TinomOptionsMainPanelBaseFilterSettingCheckButton_AbbrChannelName:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_AbbrChannelName);
	TinomOptionsMainPanelBaseFilterSettingCheckButton_IgnoreGrayItems:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_IgnoreGrayItems);
	TinomOptionsMainPanelBaseFilterSettingCheckButton_AbbrAuthorName:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_AbbrAuthorName);
	TinomOptionsMainPanelBaseFilterSetting_AutoBlackListCheckButton:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_AutoBlackList);
	TinomOptionsMainPanelBaseFilterSetting_RepeatMsgSlider:SetValue(TinomDB.Options.Default.Tinom_Value_MsgFilter_RepeatMsgElapsed or 0);
	TinomOptionsMainPanelBaseFilterSetting_IntervalMsgSlider:SetValue(TinomDB.Options.Default.Tinom_Value_MsgFilter_IntervalMsgTime or 0);

	TinomOptionsMainPanelBaseFilterSetting_SensitiveListSound:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_SensitiveListSound );
	--TinomOptionsMainPanelBaseFilterSetting_SensitiveListDropDown:SetValue(TinomDB.Options.Default.Tinom_Value_MsgFilter_SensitiveListSoundID or 12867);
	TinomOptionsMainPanelBaseFilterSetting_SensitiveListHighlight:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_SensitiveListHighlight);

	TinomOptionsMainPanelBaseFilterSetting_SensitiveKeywordSound:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_SensitiveKeywordSound);
	--TinomOptionsMainPanelBaseFilterSetting_SensitiveKeywordDropDown:SetValue(TinomDB.Options.Default.Tinom_Value_MsgFilter_SensitiveKeywordSoundID or 12867);
	TinomOptionsMainPanelBaseFilterSetting_SensitiveKeywordHighlight:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_SensitiveKeywordHighlight);

	Tinom.OptionsPanel_EditBox_LoadOptions();
	Tinom.OptionsTabButton_OnLoad();
	--Tinom.OptionsMainPanel_Replace_ListBrowseButton_LoadData( "Name" )
	--Tinom.OptionsMainPanel_Replace_ListBrowseButton_LoadData( "Keyword" )
	TinomFilterButtonsMixin.OnLoad()
	Tinom.FiltersList_Updata()
	Tdebug(self,"log","OptionsMainPanel_OnLoad.配置加载完成");
end

--[[-------------------------------------------------------------------------
--  初始化:设置界面名单文本框加载配置
-------------------------------------------------------------------------]]--
function Tinom.OptionsPanel_EditBox_LoadOptions(self)
	TinomOptionsMainPanelBaseFilterSetting_WhiteListEditBoxScrollFrameEditBox:SetText(table.concat(TinomDB.filterDB.whiteList,"\n"))
	TinomOptionsMainPanelBaseFilterSetting_WhiteListEditBoxTitle:SetText(L["白名单"].."-"..#TinomDB.filterDB.whiteList)
	
	TinomOptionsMainPanelBaseFilterSetting_WhiteListKeywordEditBoxScrollFrameEditBox:SetText(table.concat(TinomDB.filterDB.whiteListKeyword,"\n"))
	TinomOptionsMainPanelBaseFilterSetting_WhiteListKeywordEditBoxTitle:SetText(L["白关键字"].."-"..#TinomDB.filterDB.whiteListKeyword)
	
	TinomOptionsMainPanelBaseFilterSetting_BlackListKeywordEditBoxScrollFrameEditBox:SetText(table.concat(TinomDB.filterDB.blackListKeyword,"\n"))
	TinomOptionsMainPanelBaseFilterSetting_BlackListKeywordEditBoxTitle:SetText(L["黑关键字"].."-"..#TinomDB.filterDB.blackListKeyword)

	local blackListText,blackListNum = Tinom.TableToText(TinomDB.filterDB.blackList);
	TinomOptionsMainPanelBaseFilterSetting_BlackListEditBoxScrollFrameEditBox:SetText(blackListText)
	TinomOptionsMainPanelBaseFilterSetting_BlackListEditBoxTitle:SetText(L["黑名单"].."-"..blackListNum)
	
	local autoBlackListText,autoBlackListNum = Tinom.TableToText(TinomDB.filterDB.autoBlackList);
	TinomOptionsMainPanelBaseFilterSetting_AutoBlackListEditBoxScrollFrameEditBox:SetText(autoBlackListText)
	TinomOptionsMainPanelBaseFilterSetting_AutoBlackListEditBoxTitle:SetText(L["黑名单(自动)"].."-"..autoBlackListNum)

	local sensitiveListText,sensitiveListNum = Tinom.TableToText(TinomDB.filterDB.sensitiveList or {});
	TinomOptionsMainPanelBaseFilterSetting_SensitiveListEditBoxScrollFrameEditBox:SetText(sensitiveListText)
	TinomOptionsMainPanelBaseFilterSetting_SensitiveListEditBoxTitle:SetText(L["敏感单"].."-"..sensitiveListNum)

	TinomOptionsMainPanelBaseFilterSetting_SensitiveKeywordEditBoxScrollFrameEditBox:SetText(table.concat(TinomDB.filterDB.sensitiveKeyword,"\n"))
	TinomOptionsMainPanelBaseFilterSetting_SensitiveKeywordEditBoxTitle:SetText(L["敏感关键字"].."-"..#TinomDB.filterDB.sensitiveKeyword)


	Tdebug(self,"log","Options.名单已加载:");
end


--[[-------------------------------------------------------------------------
--  保存设置:设置界面更新设置数据库函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_Updata(self)
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_MainEnable 					= TinomOptionsMainPanelCheckButton_MainEnable:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_AbbrChannelName 				= TinomOptionsMainPanelBaseFilterSettingCheckButton_AbbrChannelName:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_IgnoreGrayItems 				= TinomOptionsMainPanelBaseFilterSettingCheckButton_IgnoreGrayItems:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_AbbrAuthorName 				= TinomOptionsMainPanelBaseFilterSettingCheckButton_AbbrAuthorName:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_AutoBlackList 				= TinomOptionsMainPanelBaseFilterSetting_AutoBlackListCheckButton:GetChecked();
	TinomDB.Options.Default.Tinom_Value_MsgFilter_RepeatMsgElapsed				= TinomOptionsMainPanelBaseFilterSetting_RepeatMsgSlider:GetValue();
	TinomDB.Options.Default.Tinom_Value_MsgFilter_IntervalMsgTime				= TinomOptionsMainPanelBaseFilterSetting_IntervalMsgSlider:GetValue();

	TinomDB.Options.Default.Tinom_Switch_MsgFilter_SensitiveListSound 		= TinomOptionsMainPanelBaseFilterSetting_SensitiveListSound:GetChecked();
	--TinomDB.Options.Default.Tinom_Value_MsgFilter_SensitiveListSoundID = TinomOptionsMainPanelBaseFilterSetting_SensitiveListDropDown:GetValue();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_SensitiveListHighlight 			= TinomOptionsMainPanelBaseFilterSetting_SensitiveListHighlight:GetChecked();

	TinomDB.Options.Default.Tinom_Switch_MsgFilter_SensitiveKeywordSound 		= TinomOptionsMainPanelBaseFilterSetting_SensitiveKeywordSound:GetChecked();
	--TinomDB.Options.Default.Tinom_Value_MsgFilter_SensitiveKeywordSoundID = TinomOptionsMainPanelBaseFilterSetting_SensitiveKeywordDropDown:GetValue();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_SensitiveKeywordHighlight 			= TinomOptionsMainPanelBaseFilterSetting_SensitiveKeywordHighlight:GetChecked();
	Tdebug(self,"log","Options.Tinom配置已保存");
	Tinom.OptionsPanel_EditBox_Updata();
	Tinom.FiltersList_Updata();
end

--[[-------------------------------------------------------------------------
--  保存设置:名单文本框保存函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsPanel_EditBox_Updata()
	TinomDB.filterDB.whiteList = Tinom.OptionsPanel_TextToTable(TinomOptionsMainPanelBaseFilterSetting_WhiteListEditBoxScrollFrameEditBox:GetText());
	TinomDB.filterDB.whiteListKeyword = Tinom.OptionsPanel_TextToTable(TinomOptionsMainPanelBaseFilterSetting_WhiteListKeywordEditBoxScrollFrameEditBox:GetText());
	TinomDB.filterDB.blackList = Tinom.TextToTable(TinomOptionsMainPanelBaseFilterSetting_BlackListEditBoxScrollFrameEditBox:GetText());
	TinomDB.filterDB.autoBlackList = Tinom.TextToTable(TinomOptionsMainPanelBaseFilterSetting_AutoBlackListEditBoxScrollFrameEditBox:GetText());
	TinomDB.filterDB.blackListKeyword = Tinom.OptionsPanel_TextToTable(TinomOptionsMainPanelBaseFilterSetting_BlackListKeywordEditBoxScrollFrameEditBox:GetText());
	TinomDB.filterDB.sensitiveList = Tinom.TextToTable(TinomOptionsMainPanelBaseFilterSetting_SensitiveListEditBoxScrollFrameEditBox:GetText() or "");
	TinomDB.filterDB.sensitiveKeyword = Tinom.OptionsPanel_TextToTable(TinomOptionsMainPanelBaseFilterSetting_SensitiveKeywordEditBoxScrollFrameEditBox:GetText() or "");
	
	Tinom.OptionsPanel_EditBox_LoadOptions()
	Tdebug(self,"log","Options.名单已保存");
end

--[[-------------------------------------------------------------------------
--  标签与子设置框架隐藏函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsTabButton_Clear()
	for k,v in pairs(Tinom.optionsTabButtons) do
		PanelTemplates_DeselectTab(_G[k]);
		_G[v]:Hide();
	end
end

--[[-------------------------------------------------------------------------
--  标签切换函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsTabButton_OnClick( self )
	Tinom.OptionsTabButton_Clear();
	PanelTemplates_SelectTab(self);
	_G[Tinom.optionsTabButtons[self:GetName()]]:Show();
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
end

--[[-------------------------------------------------------------------------
--  文本转表函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsPanel_TextToTable( textIn )
	local tableOut = {};
	local index = 1;
	while(true)
	do
		local first,last = string.find(textIn,"\n",index)
		if (first and last) then
			local str = string.sub(textIn,index,first-1)
			if (#str>1) then
				table.insert(tableOut,1,str)
			end
			index = last+1;
		else
			local str = string.sub(textIn,index);
			if (#str>1) then
				table.insert(tableOut,1,str);
			end
			break;
		end
	end
	Tdebug(self,"log","OptionsPanel_TextToTable.End"..#tableOut);
	return tableOut;
end

--[[-------------------------------------------------------------------------
--  表KEY转文本函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsPanel_TableToText( tableIn )
	local textOut = "";
	-- textOut = table.concat(tableIn,"\n")	--##--
	for k,v in pairs(tableIn) do
		textOut = k.."\n"..textOut;
	end
	return textOut;
	--self:SetText(str)
end

--[[-------------------------------------------------------------------------
--  文本框编辑时滚动条处理函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsPanel_EditBox_OnCursorChanged(self)

end

--  单声音选择下拉框:
function Tinom.OptionsSensitiveListSoundDropDown_Initialize(self)
	local selectedValue = UIDropDownMenu_GetSelectedValue(self);
	local info = UIDropDownMenu_CreateInfo();
	local table_sounds = {
		[1] = {12867,L["铃声"].."1"},
		[2] = {12889,L["铃声"].."2"},
	};

	for k,v in pairs(table_sounds) do
		info.value = v[1];
		info.text = v[2];
		info.func = Tinom.OptionsSensitiveListSoundDropDown_OnClick;
		if ( info.value == selectedValue ) then
			info.checked = 1;
		else
			info.checked = nil;
		end
		UIDropDownMenu_AddButton(info);
	end
end
function Tinom.OptionsSensitiveListSoundDropDown_OnShow(self,event)
	self.defaultValue = 12867;
	self.value = TinomDB.Options.Default.Tinom_Switch_MsgFilter_SensitiveListSoundID or self.defaultValue;
	self.tooltip = L["选一个你喜欢的提示音"];

	UIDropDownMenu_SetWidth(self, 150);
	UIDropDownMenu_Initialize(self, Tinom.OptionsSensitiveListSoundDropDown_Initialize);
	UIDropDownMenu_SetSelectedValue(self, self.value);

	self.SetValue =
		function (self, value)
			self.value = value;
			UIDropDownMenu_SetSelectedValue(self, value);
		end
	self.GetValue =
		function (self)
			return UIDropDownMenu_GetSelectedValue(self);
		end
	self.RefreshValue =
		function (self)
			UIDropDownMenu_Initialize(self, Tinom.OptionsSensitiveListSoundDropDown_Initialize);
			UIDropDownMenu_SetSelectedValue(self, self.value);
		end
end

function Tinom.OptionsSensitiveListSoundDropDown_OnClick(self)
	TinomOptionsMainPanelBaseFilterSetting_SensitiveListDropDown:SetValue(self.value);
	PlaySound(self.value);
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_SensitiveListSoundID = self.value
	Tdebug(self,"log","OptionsSensitiveListSoundDropDown_OnClick");
end

function Tinom.OptionsSensitiveKeywordSoundDropDown_Initialize(self)
	local selectedValue = UIDropDownMenu_GetSelectedValue(self);
	local info = UIDropDownMenu_CreateInfo();
	local table_sounds = {
		[1] = {12867,L["铃声"].."1"},
		[2] = {12889,L["铃声"].."2"},
	};

	for k,v in pairs(table_sounds) do
		info.value = v[1];
		info.text = v[2];
		info.func = Tinom.OptionsSensitiveKeywordSoundDropDown_OnClick;
		if ( info.value == selectedValue ) then
			info.checked = 1;
		else
			info.checked = nil;
		end
		UIDropDownMenu_AddButton(info);
	end
end
function Tinom.OptionsSensitiveKeywordSoundDropDown_OnShow(self,event)
	self.defaultValue = 12867;
	self.value = TinomDB.Options.Default.Tinom_Switch_MsgFilter_SensitiveKeywordSoundID or self.defaultValue;
	self.tooltip = L["选一个你喜欢的提示音"];

	UIDropDownMenu_SetWidth(self, 150);
	UIDropDownMenu_Initialize(self, Tinom.OptionsSensitiveKeywordSoundDropDown_Initialize);
	UIDropDownMenu_SetSelectedValue(self, self.value);

	self.SetValue =
		function (self, value)
			self.value = value;
			UIDropDownMenu_SetSelectedValue(self, value);
		end
	self.GetValue =
		function (self)
			return UIDropDownMenu_GetSelectedValue(self);
		end
	self.RefreshValue =
		function (self)
			UIDropDownMenu_Initialize(self, Tinom.OptionsSensitiveKeywordSoundDropDown_Initialize);
			UIDropDownMenu_SetSelectedValue(self, self.value);
		end
end

function Tinom.OptionsSensitiveKeywordSoundDropDown_OnClick(self)
	TinomOptionsMainPanelBaseFilterSetting_SensitiveKeywordDropDown:SetValue(self.value);
	PlaySound(self.value);
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_SensitiveKeywordSoundID = self.value
	Tdebug(self,"log","OptionsSensitiveKeywordSoundDropDown_OnClick");
end

--[[-------------------------------------------------------------------------
--  配置界面入口函数:
-------------------------------------------------------------------------]]--


--[[-------------------------------------------------------------------------
--  设置界面快捷命令:
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_Show()
	InterfaceOptionsFrame_OpenToCategory(TinomOptionsMainPanel);
	InterfaceOptionsFrame_OpenToCategory(TinomOptionsMainPanel);
end
SLASH_TINOMOPTIONS1 = "/tinom"
SLASH_TINOMOPTIONS2 = "/ti"
SlashCmdList["TINOMOPTIONS"] = Tinom.OptionsMainPanel_Show;

Tdebug(self,"log","Options.lua.OnLoaded");


--[[-------------------------------------------------------------------------
--  替换 名字&关键字 界面名单列表按钮点击事件函数:清理高亮	(NEW!)
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_Replace_ListBrowseButton_ClearHighlight( listType )
	if listType == "Keyword" then
		for i=1,10 do
			_G["TinomOptionsMainPanelReplaceKeywordListButton"..i]:UnlockHighlight();
		end
	elseif listType == "Name" then
		for i=1,10 do
			_G["TinomOptionsMainPanelReplaceNameListButton"..i]:UnlockHighlight();
		end
	end
end


TinomFilterButtonsMixin = {}
local lastData;
function TinomFilterButtonsMixin:OnDragStat()
	lastData = self:GetInfo();
	self:AlphaAllDown();
	self:SetAlpha(1)
	self:SetScript("OnUpdate", TinomFilterButtonsMixin.OnUpdate);
end

function TinomFilterButtonsMixin:OnUpdate()
	for i,v in ipairs(TinomOptionsMainPanelBase.TinomFilterButtons) do
		local MouseOver = v:IsMouseOver();
		if MouseOver then
			if i == lastData[1] then break; end
			PlaySoundFile("Interface/Addons/Tinom/Media/di.ogg","SFX");
			self:AlphaAllDown();
			v:SetAlpha(1)
			self:SetInfo(lastData[1], v:GetInfo());
			self:SetInfo(i, lastData);
			lastData = v:GetInfo();
		end
	end
end

function TinomFilterButtonsMixin:StopMovingEntry()
	self:AlphaAllUp()
	self:SetScript("OnUpdate", nil);
	--self:UpdateStates();
end

function TinomFilterButtonsMixin:OnLoad()
	for i,v in ipairs(TinomOptionsMainPanelBase.TinomFilterButtons) do
		v:SetInfo( i, TinomDB.Options.Default.Tinom_Value_MsgFilter_FiltersList[i] or Tinom.defaultCheckButtons[i] )
		v.CheckButton.tooltipText = "."
		--v.CheckButton.tooltipRequirement = "."
		v.Button.tooltip = "."
		v.Button.tooltipRequirement = "."
	end
end

function Tinom.FiltersList_Updata()
	msgFilters = {};
	TinomDB.Options.Default.Tinom_Value_MsgFilter_FiltersList = {};

	for i,v in ipairs(TinomOptionsMainPanelBase.TinomFilterButtons) do
		buttonInfo = v:GetInfo()
		tinsert(TinomDB.Options.Default.Tinom_Value_MsgFilter_FiltersList,i,buttonInfo);
		if v.CheckButton:GetChecked() then
			--print(v.filterFunc)
			Tinom.MsgFilter_AddMsgFilter(Tinom[v.filterFunc])
		end
	end
end

function TinomFilterButtonsMixin:AlphaAllDown()
	for i,v in ipairs(TinomOptionsMainPanelBase.TinomFilterButtons) do
		v:SetAlpha(0.5);
	end
end
function TinomFilterButtonsMixin:AlphaAllUp()
	for i,v in ipairs(TinomOptionsMainPanelBase.TinomFilterButtons) do
		v:SetAlpha(1);
	end
end

function TinomFilterButtonsMixin:GetInfo()
	local info = {};
	ID = self:GetID();
	isChecked = self.CheckButton:GetChecked();
	filterName = self.filterName;
	filterFunc = self.filterFunc;
	info = {ID, isChecked, filterName, filterFunc}
	return info;
end

function TinomFilterButtonsMixin:SetInfo( index, data )
	TinomOptionsMainPanelBase.TinomFilterButtons[index].CheckButton:SetChecked(data[2]);
	TinomOptionsMainPanelBase.TinomFilterButtons[index].filterName = data[3]
	TinomOptionsMainPanelBase.TinomFilterButtons[index].filterFunc = data[4]
	TinomOptionsMainPanelBase.TinomFilterButtons[index].CheckButton.Text:SetText(index.."."..Tinom.defaultCheckButtonsName[data[3]]);
	return true;
end

-- 过滤器子设置框架全部隐藏
function Tinom.FilterSettingFramesAllHide()
	for k,v in pairs(TinomOptionsMainPanelBase.TinomFilterSettingFrames) do
		v:Hide();
	end
end

-- 过滤器子设置框架标题
function Tinom.FilterSettingFrames_SetTitle()
	for k,v in pairs(TinomOptionsMainPanelBase.TinomFilterSettingFrames) do
		local frameName = v:GetName():match("_(%S+)$")
		v.Text:SetText(Tinom.defaultCheckButtonsName[frameName]);
	end
end

-- 显示指定过滤器子设置框架
function Tinom.FilterSettingFramesShow(frameName)
	_G["TinomOptionsMainPanelBaseFilterSetting_"..frameName]:Show();
end

-- 过滤器列表设置按钮(齿轮)
function Tinom.FilterButton_OnClick( self )
	Tinom.FilterSettingFramesAllHide();
    Tinom.FilterSettingFramesShow(self:GetParent().filterName);
end

--  过滤器滚轮事件函数:
function Tinom.OptionsMainPanel_Slider_OnMouseWheel(self, delta)
	local value = self.value;
	if ( delta < 0 ) then
		value = value + 1;
	else
		value = value - 1;
	end
	value = Tinom.SliderValueFloor(value);
	if value<0 then
		value = 0;
	elseif value>300 then
		value = 300;
	end
	self.value = value;
	self:SetValue(value);
	self.Text:SetText(self.value.."秒");
end

-- 替换框架清理文本框
function Tinom.OptionsMainPanel_Replace_ClearEditBox(self)
	_G[self:GetParent():GetName().."Key"]:SetText("");
    _G[self:GetParent():GetName().."NewKey"]:SetText("");
end

--  替换框架新增条目按钮:点击事件
function Tinom.OptionsMainPanel_Replace_ButtonAdd_OnClick(self)
	local Key = _G[self:GetParent():GetName().."Key"]:GetText();
	local NewKey = _G[self:GetParent():GetName().."NewKey"]:GetText();
	local frameName = self:GetName():match("_(%S+)Button");
	local replaceType = frameName:match("Replace(%S+)");
	if (#Key < 1) then
		_G[self:GetParent():GetName().."Key"]:SetText(L["你太短啦!"]);
	elseif (#NewKey<1) then
		_G[self:GetParent():GetName().."NewKey"]:SetText(L["你太短了!"]);
	else
		TinomDB.filterDB[Tinom.replaceDBName[frameName]][Key] = NewKey;
		Tinom.OptionsMainPanel_Replace_ClearEditBox(self)
		Tinom.OptionsMainPanel_Replace_OnShow( self:GetParent() )
		Tdebug(self,"log","Options.replaceName.新增条目");
	end
end

--  删除条目按钮:点击事件
function Tinom.OptionsMainPanel_Replace_ButtonDel_OnClick(self)
	local Key = _G[self:GetParent():GetName().."Key"]:GetText();
	local frameName = self:GetName():match("_(%S+)Button");
	if TinomDB.filterDB[Tinom.replaceDBName[frameName]][Key] then
		TinomDB.filterDB[Tinom.replaceDBName[frameName]][Key] = nil;
	end
	Tinom.OptionsMainPanel_Replace_ClearEditBox(self)
	Tinom.OptionsMainPanel_Replace_OnShow( self:GetParent() )
	Tdebug(self,"log","Options.replaceName.删除条目");
end

function Tinom.OptionsMainPanel_Replace_AllHide(listName)
	for i,v in ipairs(listName.ReplaceListButtons) do
		v:Hide();
	end
end

Tinom.replaceDBName={
	["ReplaceName"] = "replaceName",
	["ReplaceNameMsg"] = "replaceNameMsg",
	["ReplaceKeyword"] = "replaceKeyword",
	["ReplaceKeywordMsg"] = "replaceKeywordMsg",
};

function Tinom.OptionsMainPanel_Replace_OnShow( self )
	local frameName = self:GetName():match("_(%S+)$");
	local replaceType = frameName:match("Replace(%S+)");
	local listName = _G[self:GetName().."List"];
	Tinom.OptionsMainPanel_Replace_AllHide(listName)
	self.tableTemp = {};
	for k,v in pairs(TinomDB.filterDB[Tinom.replaceDBName[frameName]]) do
		if v then
			table.insert( self.tableTemp,{k,v})
		end
	end
	if #self.tableTemp > 0 then
		Tinom.OptionsMainPanel_Replace_LoadData( self, listName, 1 )
	end
end
function Tinom.OptionsMainPanel_Replace_LoadData( replaceFrame, listName, index )
	-- Tinom.OptionsMainPanel_Replace_ListBrowseButton_Clear("Keyword");
	-- Tinom.OptionsMainPanel_Replace_ListBrowseButton_ClearHighlight("Keyword");
	local index_B = index;
	for i,v in ipairs(listName.ReplaceListButtons) do
		if i>(#replaceFrame.tableTemp - index_B + 1) then break; end
		local button = listName.ReplaceListButtons[i]
		button:Show();
		_G[button:GetName().."_Key"]:SetText(replaceFrame.tableTemp[index][1]);
		_G[button:GetName().."_NewKey"]:SetText(replaceFrame.tableTemp[index][2]);
		index = index + 1;
	end
	Tinom.OptionsMainPanel_Replace_ScrollUpdate( replaceFrame,listName );
end

function Tinom.OptionsMainPanel_Replace_ScrollUpdate( replaceFrame,listName )
	local scrollHeight = _G[listName:GetName().."Scroll"]:GetHeight();
	if (#replaceFrame.tableTemp>#listName.ReplaceListButtons) then
		_G[listName:GetName().."Scroll_HightFrame"]:SetHeight(scrollHeight + #replaceFrame.tableTemp - #listName.ReplaceListButtons)
	end
end

--  替换框架滚轮事件函数:
function Tinom.OptionsMainPanel_Replace_Scroll_OnMouseWheel(self, delta)
	local scrollBar = self.ScrollBar;
	if ( delta > 0 ) then
		scrollBar:SetValue(scrollBar:GetValue() - 1);
	else
		scrollBar:SetValue(scrollBar:GetValue() + 1);
	end
	Tinom.OptionsMainPanel_Replace_LoadData( self:GetParent():GetParent(), self:GetParent(), math.floor(scrollBar:GetValue()+1.5) )
end

function Tinom.OptionsMainPanel_Replace_OnTextChanged( self )
	local Key = self:GetText();
	local frameName = self:GetName():match("_(%S+)Key$");

	if ( TinomDB.filterDB[Tinom.replaceDBName[frameName]][Key] ) then
		_G[self:GetParent():GetName().."ButtonAdd"]:SetText(L["修改"]);
	else
		_G[self:GetParent():GetName().."ButtonAdd"]:SetText(L["新增"]);
	end
end