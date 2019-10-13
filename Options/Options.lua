--[[-------------------------------------------------------------------------
--
--  Options Setting
--  设置界面
--
--  功能:面向对象...没有发现对象...
--
-------------------------------------------------------------------------]]--
local L = Tinom.L
Tinom.version = GetAddOnMetadata("Tinom", "Version")
--[[-------------------------------------------------------------------------
--  字符串:
-------------------------------------------------------------------------]]--
TINOM_OPTION_MAINPANEL_TITLE = L["Tinom聊天过滤v"]..Tinom.version;
-- TINOM_OPTION_MAINPANEL_SUBTEXT = L["去年高三帮好朋友给实验班的男孩子写一封信,只有“山有木兮木有枝”七个字,
-- 想让他领会后半句心悦君兮君不知的含义.第二天男孩子主动来班里送信,还是昨天那封,他在后面补充到“心悦君兮君已知,奈何十二寒窗苦,
-- 待到金榜题名时.”   后来这段故事无疾而终 愿你们遇到的每段感情都能有处安放"];
TINOM_OPTION_MAINPANEL_SUBTEXT = L["目前插件处于Beta测试阶段,更新会比较频繁.您可以经常浏览我的更新贴以获取最新版本.NGA:搜索\"Tinom\"进行反馈."];
TINOM_OPTION_MAINPANEL_CHACKBUTTON_MAINENABLE_TEXT = L["开启过滤"];

--[[-------------------------------------------------------------------------
--  默认配置:开关
-------------------------------------------------------------------------]]--
Tinom.defaultOptionsCheckButtons = {
	Tinom_Switch_MsgFilter_MainEnable = true,
	Tinom_Switch_MsgFilter_WhiteList = false,
	Tinom_Switch_MsgFilter_WhiteListKeyWord = false,
	Tinom_Switch_MsgFilter_WhiteListOnly = false,
	Tinom_Switch_MsgFilter_BlackList = true,
	Tinom_Switch_MsgFilter_BlackListKeyWord = false,
	Tinom_Switch_MsgFilter_ReplaceName = false,
	Tinom_Switch_MsgFilter_ReplaceNameMsg = false,
	Tinom_Switch_MsgFilter_ReplaceKeyWord = true,
	Tinom_Switch_MsgFilter_ReplaceKeyWordMsg = false,
	Tinom_Switch_MsgFilter_CacheMsgRepeat = false,
	Tinom_Switch_MsgFilter_AbbrChannelName = false,
	Tinom_Switch_MsgFilter_AbbrAuthorName = false,
	Tinom_Switch_MsgFilter_WhiteListSound = false,
	Tinom_Switch_MsgFilter_WhiteListKeyWordSound = false,
	Tinom_Switch_MsgFilter_AutoBlackList = true,
	Tinom_Switch_MsgFilter_IgnoreGrayItems = false,
	Tinom_Switch_MsgFilter_FoldMsg = false,
	Tinom_Switch_MsgFilter_WhiteListHighlight = false,
	Tinom_Switch_MsgFilter_WhiteListKeyWordHighlight = false,
	Tinom_Switch_MsgFilter_WhiteListSoundID = 12867,
};
--[[-------------------------------------------------------------------------
--  默认配置:复选按钮文本
-------------------------------------------------------------------------]]--
Tinom.defaultCheckButtonsName = {
	WhiteList = "白名单",
	WhiteListKeyWord = "白名单关键字",
	BlackList = "黑名单",
	BlackListKeyWord = "黑名单关键字",
	ReplaceName = "替换角色名",
	ReplaceNameMsg = "替换角色的消息",
	ReplaceKeyWord = "替换关键字",
	ReplaceKeyWordMsg = "替换关键字的消息",
	CacheMsgRepeat = "屏蔽重复消息",
	WhiteListOnly = "只有白名单",
	AbbrChannelName = "缩写频道名",
	FoldMsg = "折叠复读消息",
	IgnoreGrayItems = "屏蔽灰色物品拾取消息",
	AbbrAuthorName = "缩写玩家名(|cffffff00注意!被缩写的角色将导致其右键内交互功能失效!|r)"
};
--[[-------------------------------------------------------------------------
--  地址索引:标签按钮 = 子设置界面
-------------------------------------------------------------------------]]--
Tinom.optionsTabButtons = {
	TinomOptionsMainPanelBaseSettingTabButton = "TinomOptionsMainPanelBaseSetting",
	TinomOptionsMainPanelWhiteListTabButton = "TinomOptionsMainPanelWhiteListSetting",
	TinomOptionsMainPanelBlackListTabButton = "TinomOptionsMainPanelBlackListSetting",
	TinomOptionsMainPanelReplaceListTabButton = "TinomOptionsMainPanelReplace",
};

--[[-------------------------------------------------------------------------
--  初始化:主设置面板加载
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_OnLoad( self )
	TinomOptionsMainPanelCheckButton_MainEnableText:SetText(L["开启过滤"]);
	TinomOptionsMainPanelCheckButton_MainEnable.tooltipText = L["开启过滤系统的主开关"];
	--<!-- 设置面板的Okay响应函数,用于保存设置. -->
	function self.okay(self)
		Tinom.OptionsMainPanel_Updata();
		Tdebug(self,"log","TinomOptionsMainPanel.okay")
	end

	--<!-- 设置面板的cancel响应函数,用于撤销修改. -->
	function self.cancel(self)
		Tinom.OptionsMainPanel_LoadOptions();
		Tdebug(self,"log","TinomOptionsMainPanel.cancel")
	end

	--<!-- 先为框架设置一个名字才能添加到设置面板的列表里 -->
	self.name = Tinom.L["Tinom聊天过滤"];
	InterfaceOptions_AddCategory(self);

	--<!-- 可移动设置面板 -->
	Tinom.OptionsPanel_EnableMovale();

	--<!-- 标签按钮加载 -->
	Tinom.OptionsTabButton_OnLoad();
end

--[[-------------------------------------------------------------------------
--  初始化:各过滤开关复选框加载其字符串文本
-------------------------------------------------------------------------]]--
function Tinom.OptionsBaseSettingCheckButton_OnLoad(self)
	--TinomOptionsMainPanelBaseSettingCheckButton_
	local buttonName = strsub(self:GetName(), 45);
	for k,v in pairs(Tinom.defaultCheckButtonsName) do
		if (buttonName == k) then
			_G[self:GetName().."Text"]:SetText(L[v])
			self.tooltipText = L["开启"]..v..L["过滤"];
		end
	end
end

--[[-------------------------------------------------------------------------
--  总开关复选框函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainEnableCheckButton_OnClick(self)
	Tinom.OptionsTabButton_OnLoad();
	if ( self:GetChecked() ) then
		Tinom.MsgFilterOn();
	else
		Tinom.MsgFilterOff();
	end
end

--[[-------------------------------------------------------------------------
--  开关复选框点击事件函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsBaseSettingCheckButton_OnClick(self)
	--Tinom.OptionsMainPanel_Updata(self);
	if ( self:GetChecked() ) then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
	end
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
	TinomOptionsMainPanelBaseSettingCheckButton_WhiteList:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteList);
	TinomOptionsMainPanelBaseSettingCheckButton_WhiteListKeyWord:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListKeyWord);
	TinomOptionsMainPanelBaseSettingCheckButton_WhiteListOnly:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListOnly);
	TinomOptionsMainPanelBaseSettingCheckButton_BlackList:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_BlackList);
	TinomOptionsMainPanelBaseSettingCheckButton_BlackListKeyWord:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_BlackListKeyWord);
	TinomOptionsMainPanelBaseSettingCheckButton_ReplaceName:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceName);
	TinomOptionsMainPanelBaseSettingCheckButton_ReplaceNameMsg:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceNameMsg);
	TinomOptionsMainPanelBaseSettingCheckButton_ReplaceKeyWord:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceKeyWord);
	TinomOptionsMainPanelBaseSettingCheckButton_ReplaceKeyWordMsg:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceKeyWordMsg);
	TinomOptionsMainPanelBaseSettingCheckButton_CacheMsgRepeat:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_CacheMsgRepeat);
	TinomOptionsMainPanelBaseSettingCheckButton_AbbrChannelName:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_AbbrChannelName);
	TinomOptionsMainPanelBaseSettingCheckButton_FoldMsg:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_FoldMsg);
	TinomOptionsMainPanelBaseSettingCheckButton_IgnoreGrayItems:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_IgnoreGrayItems);
	TinomOptionsMainPanelBaseSettingCheckButton_AbbrAuthorName:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_AbbrAuthorName);
	TinomOptionsMainPanelWhiteListSettingSound_Name:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListSound);
	TinomOptionsMainPanelWhiteListSettingSound_KeyWord:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListKeyWordSound);
	TinomOptionsMainPanelBlackListSettingAutoBlackList:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_AutoBlackList);
	TinomOptionsMainPanelWhiteListSettingWhiteList_Highlight:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListHighlight);
	TinomOptionsMainPanelWhiteListSettingWhiteListKeyWord_Highlight:SetChecked(TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListKeyWordHighlight);

	--TinomOptionsMainPanelWhiteListSettingDropDown:SetValue(TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListSoundID);
	Tinom.OptionsPanel_EditBox_LoadOptions();
	Tinom.OptionsTabButton_OnLoad();
	Tinom.OptionsMainPanel_Replace_ListBrowseButton_LoadData( "Name" )
	Tinom.OptionsMainPanel_Replace_ListBrowseButton_LoadData( "KeyWord" )
	Tdebug(self,"log","OptionsMainPanel_OnLoad.配置加载完成");
end

--[[-------------------------------------------------------------------------
--  初始化:设置界面名单文本框加载配置
-------------------------------------------------------------------------]]--
function Tinom.OptionsPanel_EditBox_LoadOptions(self)
	TinomOptionsMainPanelWhiteListSettingEditList_WhiteListScrollFrameEditBox:SetText(table.concat(TinomDB.filterDB.whiteList,"\n"))
	TinomOptionsMainPanelWhiteListSettingEditList_WhiteListTitle:SetText(Tinom.L["白名单:玩家"].."-"..#TinomDB.filterDB.whiteList)
	TinomOptionsMainPanelWhiteListSettingEditList_WhiteListKeyWordScrollFrameEditBox:SetText(table.concat(TinomDB.filterDB.whiteListKeyWord,"\n"))
	TinomOptionsMainPanelWhiteListSettingEditList_WhiteListKeyWordTitle:SetText(Tinom.L["白名单:关键字"].."-"..#TinomDB.filterDB.whiteListKeyWord)
	TinomOptionsMainPanelBlackListSettingEditList_BlackListScrollFrameEditBox:SetText(table.concat(TinomDB.filterDB.blackList,"\n"))
	TinomOptionsMainPanelBlackListSettingEditList_BlackListTitle:SetText(Tinom.L["黑名单:玩家"].."-"..#TinomDB.filterDB.blackList)
	TinomOptionsMainPanelBlackListSettingEditList_BlackListKeyWordScrollFrameEditBox:SetText(table.concat(TinomDB.filterDB.blackListKeyWord,"\n"))
	TinomOptionsMainPanelBlackListSettingEditList_BlackListKeyWordTitle:SetText(Tinom.L["黑名单:关键字"].."-"..#TinomDB.filterDB.blackListKeyWord)

	Tdebug(self,"log","Options.名单已加载:");
end

--[[-------------------------------------------------------------------------
--  初始化:标签初始函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsTabButton_OnLoad()
	Tinom.OptionsTabButton_Clear();
	if ( TinomOptionsMainPanelCheckButton_MainEnable:GetChecked() ) then
		PanelTemplates_SelectTab(TinomOptionsMainPanelBaseSettingTabButton);
		TinomOptionsMainPanelBaseSetting:Show();
	end
end

--[[-------------------------------------------------------------------------
--  保存设置:设置界面更新设置数据库函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_Updata(self)
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_MainEnable 					= TinomOptionsMainPanelCheckButton_MainEnable:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteList 					= TinomOptionsMainPanelBaseSettingCheckButton_WhiteList:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListKeyWord 			= TinomOptionsMainPanelBaseSettingCheckButton_WhiteListKeyWord:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListOnly 				= TinomOptionsMainPanelBaseSettingCheckButton_WhiteListOnly:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_BlackList 					= TinomOptionsMainPanelBaseSettingCheckButton_BlackList:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_BlackListKeyWord 			= TinomOptionsMainPanelBaseSettingCheckButton_BlackListKeyWord:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceName 					= TinomOptionsMainPanelBaseSettingCheckButton_ReplaceName:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceNameMsg 				= TinomOptionsMainPanelBaseSettingCheckButton_ReplaceNameMsg:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceKeyWord 				= TinomOptionsMainPanelBaseSettingCheckButton_ReplaceKeyWord:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceKeyWordMsg 			= TinomOptionsMainPanelBaseSettingCheckButton_ReplaceKeyWordMsg:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_CacheMsgRepeat 				= TinomOptionsMainPanelBaseSettingCheckButton_CacheMsgRepeat:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_AbbrChannelName 				= TinomOptionsMainPanelBaseSettingCheckButton_AbbrChannelName:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_FoldMsg 						= TinomOptionsMainPanelBaseSettingCheckButton_FoldMsg:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_IgnoreGrayItems 				= TinomOptionsMainPanelBaseSettingCheckButton_IgnoreGrayItems:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_AbbrAuthorName 				= TinomOptionsMainPanelBaseSettingCheckButton_AbbrAuthorName:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListSound 				= TinomOptionsMainPanelWhiteListSettingSound_Name:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListKeyWordSound 		= TinomOptionsMainPanelWhiteListSettingSound_KeyWord:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_AutoBlackList 				= TinomOptionsMainPanelBlackListSettingAutoBlackList:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListHighlight 			= TinomOptionsMainPanelWhiteListSettingWhiteList_Highlight:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListKeyWordHighlight 	= TinomOptionsMainPanelWhiteListSettingWhiteListKeyWord_Highlight:GetChecked();
	--TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListSoundID = TinomOptionsMainPanelWhiteListSettingDropDown:GetValue();
	Tdebug(self,"log","Options.Tinom配置已保存");
	Tinom.OptionsPanel_EditBox_Updata()
	
end

--[[-------------------------------------------------------------------------
--  保存设置:名单文本框保存函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsPanel_EditBox_Updata()
	TinomDB.filterDB.whiteList = Tinom.OptionsPanel_TextToTable(TinomOptionsMainPanelWhiteListSettingEditList_WhiteListScrollFrameEditBox:GetText());
	TinomDB.filterDB.whiteListKeyWord = Tinom.OptionsPanel_TextToTable(TinomOptionsMainPanelWhiteListSettingEditList_WhiteListKeyWordScrollFrameEditBox:GetText());
	TinomDB.filterDB.blackList = Tinom.OptionsPanel_TextToTable(TinomOptionsMainPanelBlackListSettingEditList_BlackListScrollFrameEditBox:GetText());
	TinomDB.filterDB.blackListKeyWord = Tinom.OptionsPanel_TextToTable(TinomOptionsMainPanelBlackListSettingEditList_BlackListKeyWordScrollFrameEditBox:GetText());
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

--[[-------------------------------------------------------------------------
--  白名单声音选择下拉框:
-------------------------------------------------------------------------]]--
function Tinom.OptionsWhiteListSoundDropDown_Initialize(self)
	local selectedValue = UIDropDownMenu_GetSelectedValue(self);
	local info = UIDropDownMenu_CreateInfo();
	local table_sounds = {
		[1] = {12867,Tinom.L["铃声"].."1"},
		[2] = {12889,Tinom.L["铃声"].."2"},
	};

	for k,v in pairs(table_sounds) do
		info.value = v[1];
		info.text = v[2];
		info.func = Tinom.OptionsWhiteListSoundDropDown_OnClick;
		if ( info.value == selectedValue ) then
			info.checked = 1;
		else
			info.checked = nil;
		end
		UIDropDownMenu_AddButton(info);
	end
end
function Tinom.OptionsWhiteListSoundDropDown_OnShow(self,event)
	self.defaultValue = 12867;
	self.value = TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListSoundID or self.defaultValue;
	self.tooltip = L["选一个你喜欢的提示音"];

	UIDropDownMenu_SetWidth(self, 150);
	UIDropDownMenu_Initialize(self, Tinom.OptionsWhiteListSoundDropDown_Initialize);
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
			UIDropDownMenu_Initialize(self, Tinom.OptionsWhiteListSoundDropDown_Initialize);
			UIDropDownMenu_SetSelectedValue(self, self.value);
		end
end

function Tinom.OptionsWhiteListSoundDropDown_OnClick(self)
	TinomOptionsMainPanelWhiteListSettingDropDown:SetValue(self.value);
	PlaySound(self.value);
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListSoundID = self.value
	Tdebug(self,"log","OptionsWhiteListSoundDropDown_OnClick");
end

--[[-------------------------------------------------------------------------
--  #######################################################################
--	替换名单界面
--	#######################################################################
-------------------------------------------------------------------------]]--

--[[-------------------------------------------------------------------------
--  替换名单界面名单列表按钮点击事件函数:清理文本框
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceName_ClearEditBox()
	_G["TinomOptionsMainPanelReplaceNameListName"]:SetText("");
    _G["TinomOptionsMainPanelReplaceNameListNewName"]:SetText("");
    _G["TinomOptionsMainPanelReplaceNameListNewMsg"]:SetText("");
end

--[[-------------------------------------------------------------------------
--  替换名单界面名单列表按钮点击事件函数:显示于文本框
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceName_ListBrowseButton_OnClick(self)
	Tinom.OptionsMainPanel_Replace_ListBrowseButton_ClearHighlight("Name");
	self:LockHighlight();
	_G[self:GetParent():GetName().."Name"]:SetText(_G[self:GetName().."_Name"]:GetText() or "");
	_G[self:GetParent():GetName().."NewName"]:SetText(_G[self:GetName().."_NewName"]:GetText() or "");
	_G[self:GetParent():GetName().."NewMsg"]:SetText(_G[self:GetName().."_NewMsg"]:GetText() or "");
end

--[[-------------------------------------------------------------------------
--  新增条目按钮:点击事件
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceName_ButtonAdd_OnClick()
	local name = TinomOptionsMainPanelReplaceNameListName:GetText();
    local newNameStr = _G["TinomOptionsMainPanelReplaceNameListNewName"]:GetText();
	local newMsgStr = _G["TinomOptionsMainPanelReplaceNameListNewMsg"]:GetText();
	if (#name < 1) then
		_G["TinomOptionsMainPanelReplaceNameListName"]:SetText(Tinom.L["你太短啦!"]);
		--Tdebug(self,"log","Options.replaceName.新增条目.你太短啦!");
	elseif ((#newNameStr<1) and (#newMsgStr<1)) then
		_G["TinomOptionsMainPanelReplaceNameListName"]:SetText(Tinom.L["你太短了!"]);
		--Tdebug(self,"log","Options.replaceName.新增条目.你太短啦!");
	else
		TinomDB.filterDB.replaceName[name] = {newName=newNameStr,newMsg=newMsgStr}
		Tdebug(self,"log","Options.replaceName.新增条目");
		Tinom.OptionsMainPanel_ReplaceName_ClearEditBox()
		Tinom.OptionsMainPanel_Replace_ListBrowseButton_LoadData( "Name" )
	end
end

--[[-------------------------------------------------------------------------
--  删除条目按钮:点击事件
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceName_ButtonDel_OnClick()
	local name = TinomOptionsMainPanelReplaceNameListName:GetText();
	TinomDB.filterDB.replaceName[name] = nil;
	--Tdebug(self,"log","Options.replaceName.删除条目");
	Tinom.OptionsMainPanel_ReplaceName_ClearEditBox()
	Tinom.OptionsMainPanel_Replace_ListBrowseButton_LoadData( "Name" )
end

--[[-------------------------------------------------------------------------
--  滚轮事件函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceName_Scroll_OnMouseWheel(self, value)
	local scrollBar = self.ScrollBar;
	if ( value > 0 ) then
		scrollBar:SetValue(scrollBar:GetValue() - 1);
	else
		scrollBar:SetValue(scrollBar:GetValue() + 1);
	end
	Tinom.OptionsMainPanel_Replace_ListBrowseButton_Updata( "Name",math.floor(scrollBar:GetValue() + 1.5) )
	----Tdebug(self,"log","Options.replaceName.ScroolFrame."..value..scrollBar:GetValue());
end

--[[-------------------------------------------------------------------------
--  替换单选择下拉框:
-------------------------------------------------------------------------]]--
function Tinom.OptionsReplaceDropDown_Initialize(self)
	local selectedValue = UIDropDownMenu_GetSelectedValue(self);
	local info = UIDropDownMenu_CreateInfo();
	local table_sounds = {
		[1] = {"NameList",Tinom.L["按角色名替换"]},
		[2] = {"KeyWordList",Tinom.L["按关键字替换"]},
	};

	for k,v in pairs(table_sounds) do
		info.value = v[1];
		info.text = v[2];
		info.func = Tinom.OptionsReplaceDropDown_OnClick;
		if ( info.value == selectedValue ) then
			info.checked = 1;
		else
			info.checked = nil;
		end
		UIDropDownMenu_AddButton(info);
	end
end
function Tinom.OptionsReplaceDropDown_OnShow(self,event)
	self.defaultValue = "NameList";
	self.value = self.defaultValue;	--TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceFrameID or 
	self.tooltip = L["替换类型"];

	UIDropDownMenu_SetWidth(self, 160);
	UIDropDownMenu_Initialize(self, Tinom.OptionsReplaceDropDown_Initialize);
	UIDropDownMenu_SetSelectedValue(self, self.value);

	TinomOptionsMainPanelReplaceNameList:Show();
	TinomOptionsMainPanelReplaceKeyWordList:Hide();

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
			UIDropDownMenu_Initialize(self, Tinom.OptionsReplaceDropDown_Initialize);
			UIDropDownMenu_SetSelectedValue(self, self.value);
		end
end

function Tinom.OptionsReplaceDropDown_OnClick(self)
	TinomOptionsMainPanelReplaceDropDown:SetValue(self.value);
	if self.value == "NameList" then
		TinomOptionsMainPanelReplaceNameList:Show();
		TinomOptionsMainPanelReplaceKeyWordList:Hide();
	else
		TinomOptionsMainPanelReplaceNameList:Hide();
		TinomOptionsMainPanelReplaceKeyWordList:Show();
	end
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceFrameID = self.value
	Tdebug(self,"log","OptionsReplaceDropDown_OnClick");
end

--[[-------------------------------------------------------------------------
--  #######################################################################
--	替换关键字界面
--	#######################################################################
-------------------------------------------------------------------------]]--

--[[-------------------------------------------------------------------------
--  替换名单界面名单列表按钮点击事件函数:清理文本框
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceKeyWord_ClearEditBox()
	_G["TinomOptionsMainPanelReplaceKeyWordListKeyWord"]:SetText("");
    _G["TinomOptionsMainPanelReplaceKeyWordListNewWord"]:SetText("");
    _G["TinomOptionsMainPanelReplaceKeyWordListNewMsg"]:SetText("");
end

--[[-------------------------------------------------------------------------
--  替换名单界面名单列表按钮点击事件函数:显示于文本框
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceKeyWord_ListBrowseButton_OnClick(self)
	Tinom.OptionsMainPanel_Replace_ListBrowseButton_ClearHighlight("KeyWord");
	self:LockHighlight();
	_G[self:GetParent():GetName().."KeyWord"]:SetText(_G[self:GetName().."_KeyWord"]:GetText() or "");
	_G[self:GetParent():GetName().."NewWord"]:SetText(_G[self:GetName().."_NewWord"]:GetText() or "");
	_G[self:GetParent():GetName().."NewMsg"]:SetText(_G[self:GetName().."_NewMsg"]:GetText() or "");
end

--[[-------------------------------------------------------------------------
--  新增条目按钮:点击事件
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceKeyWord_ButtonAdd_OnClick()
	local KeyWord = TinomOptionsMainPanelReplaceKeyWordListKeyWord:GetText();
    local newWordStr = TinomOptionsMainPanelReplaceKeyWordListNewWord:GetText();
	local newMsgStr = TinomOptionsMainPanelReplaceKeyWordListNewMsg:GetText();
	if (#KeyWord < 1) then
		_G["TinomOptionsMainPanelReplaceKeyWordListKeyWord"]:SetText(Tinom.L["你太短啦!"]);
	elseif ((#newWordStr<1) and (#newMsgStr<1)) then
		_G["TinomOptionsMainPanelReplaceKeyWordListKeyWord"]:SetText(Tinom.L["你太短了!"]);
	else
		TinomDB.filterDB.replaceKeyWord[KeyWord] = {newWord=newWordStr,newMsg=newMsgStr}
		----Tdebug(self,"log","Options.replaceName.新增条目");
		Tinom.OptionsMainPanel_ReplaceKeyWord_ClearEditBox()
		Tinom.OptionsMainPanel_Replace_ListBrowseButton_LoadData( "KeyWord" )
	end
end

--[[-------------------------------------------------------------------------
--  删除条目按钮:点击事件
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceKeyWord_ButtonDel_OnClick()
	local KeyWord = TinomOptionsMainPanelReplaceKeyWordListKeyWord:GetText();
	TinomDB.filterDB.replaceKeyWord[KeyWord] = nil;
	--Tdebug(self,"log","Options.replaceName.删除条目");
	Tinom.OptionsMainPanel_ReplaceKeyWord_ClearEditBox()
	Tinom.OptionsMainPanel_Replace_ListBrowseButton_LoadData( "KeyWord" )
end



--[[-------------------------------------------------------------------------
--  滚轮事件函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceKeyWord_Scroll_OnMouseWheel(self, value)
	local scrollBar = self.ScrollBar;
	if ( value > 0 ) then
		scrollBar:SetValue(scrollBar:GetValue() - 1);
	else
		scrollBar:SetValue(scrollBar:GetValue() + 1);
	end
	Tinom.OptionsMainPanel_Replace_ListBrowseButton_Updata( "KeyWord",math.floor(scrollBar:GetValue() + 1.5) )
	----Tdebug(self,"log","Options.replaceName.ScroolFrame."..value..scrollBar:GetValue());
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
--  初始化:设置界面替换 名字&关键字 列表加载配置	(NEW!)
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_Replace_ListBrowseButton_LoadData( listType )
	local index = 1;
	if listType == "KeyWord" then
		Tinom.tableReplaceKeyWordTemp = {};
		for k,v in pairs(TinomDB.filterDB.replaceKeyWord) do
			Tinom.tableReplaceKeyWordTemp[index] = {k,v.newWord,v.newMsg};
			index = index + 1;
		end
		Tinom.OptionsMainPanel_Replace_ListBrowseButton_Updata("KeyWord",1);
	elseif listType == "Name" then
		Tinom.tableReplaceNameTemp = {};
		for k,v in pairs(TinomDB.filterDB.replaceName) do
			Tinom.tableReplaceNameTemp[index] = {k,v.newName,v.newMsg};
			index = index + 1;
		end
		Tinom.OptionsMainPanel_Replace_ListBrowseButton_Updata("Name",1);
	end
end

--[[-------------------------------------------------------------------------
--  初始化:设置界面替换 名字&关键字 列表翻页更新	(NEW!)
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_Replace_ListBrowseButton_Updata( listType,index )
	if listType == "KeyWord" then
		Tinom.OptionsMainPanel_Replace_ListBrowseButton_Clear("KeyWord");
		Tinom.OptionsMainPanel_Replace_ListBrowseButton_ClearHighlight("KeyWord");
		for k=1,math.min( (#Tinom.tableReplaceKeyWordTemp - index+1), 10 ) do
			if k == 11 then break; end
			_G["TinomOptionsMainPanelReplaceKeyWordListButton"..k]:Show();
			_G["TinomOptionsMainPanelReplaceKeyWordListButton"..k.."_KeyWord"]:SetText(Tinom.tableReplaceKeyWordTemp[index][1]);
			_G["TinomOptionsMainPanelReplaceKeyWordListButton"..k.."_NewWord"]:SetText(Tinom.tableReplaceKeyWordTemp[index][2]);
			_G["TinomOptionsMainPanelReplaceKeyWordListButton"..k.."_NewMsg"]:SetText(Tinom.tableReplaceKeyWordTemp[index][3]);
			index = index + 1;
	  end
		Tinom.OptionsMainPanel_Replace_Scroll_Update("KeyWord");
	elseif  listType == "Name" then
		Tinom.OptionsMainPanel_Replace_ListBrowseButton_Clear("Name");
		Tinom.OptionsMainPanel_Replace_ListBrowseButton_ClearHighlight("Name");
		for k=1,math.min( (#Tinom.tableReplaceNameTemp - index+1), 10 ) do
			if k == 11 then break; end
			_G["TinomOptionsMainPanelReplaceNameListButton"..k]:Show();
			_G["TinomOptionsMainPanelReplaceNameListButton"..k.."_Name"]:SetText(Tinom.tableReplaceNameTemp[index][1]);
			_G["TinomOptionsMainPanelReplaceNameListButton"..k.."_NewName"]:SetText(Tinom.tableReplaceNameTemp[index][2]);
			_G["TinomOptionsMainPanelReplaceNameListButton"..k.."_NewMsg"]:SetText(Tinom.tableReplaceNameTemp[index][3]);
			index = index + 1;
		end
		Tinom.OptionsMainPanel_Replace_Scroll_Update("Name");
	end
end

  --[[-------------------------------------------------------------------------
--  初始化:设置界面替换 名字&关键字 列表清空	(NEW!)
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_Replace_ListBrowseButton_Clear( listType )
	if listType == "KeyWord" then
		for i=1,10 do
			_G["TinomOptionsMainPanelReplaceKeyWordListButton"..i.."_KeyWord"]:SetText();
			_G["TinomOptionsMainPanelReplaceKeyWordListButton"..i.."_NewWord"]:SetText();
			_G["TinomOptionsMainPanelReplaceKeyWordListButton"..i.."_NewMsg"]:SetText();
			_G["TinomOptionsMainPanelReplaceKeyWordListButton"..i]:Hide();
		end
	elseif listType == "Name" then
		for i=1,10 do
			_G["TinomOptionsMainPanelReplaceNameListButton"..i.."_Name"]:SetText();
			_G["TinomOptionsMainPanelReplaceNameListButton"..i.."_NewName"]:SetText();
			_G["TinomOptionsMainPanelReplaceNameListButton"..i.."_NewMsg"]:SetText();
			_G["TinomOptionsMainPanelReplaceNameListButton"..i]:Hide();
		end
	end
end

--[[-------------------------------------------------------------------------
--  替换 名字&关键字 界面名单列表按钮点击事件函数:清理高亮	(NEW!)
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_Replace_ListBrowseButton_ClearHighlight( listType )
	if listType == "KeyWord" then
		for i=1,10 do
			_G["TinomOptionsMainPanelReplaceKeyWordListButton"..i]:UnlockHighlight();
		end
	elseif listType == "Name" then
		for i=1,10 do
			_G["TinomOptionsMainPanelReplaceNameListButton"..i]:UnlockHighlight();
		end
	end
end

--[[-------------------------------------------------------------------------
--  滚轮事件函数:更新滚动条高度	(NEW!)
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_Replace_Scroll_Update( listType )

	if listType == "KeyWord" then
		local scrollHeight = TinomOptionsMainPanelReplaceKeyWordListScrollFrame:GetHeight();
		if (#Tinom.tableReplaceKeyWordTemp>10) then
			Tinom_ScrollFrame_HightFrame2:SetHeight(scrollHeight + #Tinom.tableReplaceKeyWordTemp - 9)
		end
	elseif listType == "Name" then
		local scrollHeight = TinomOptionsMainPanelReplaceNameListScrollFrame:GetHeight();
		if (#Tinom.tableReplaceNameTemp>10) then
			Tinom_ScrollFrame_HightFrame:SetHeight(scrollHeight + #Tinom.tableReplaceNameTemp - 9)
		end
	end
end

--[[-------------------------------------------------------------------------
--  替换 名字&关键字 界面文本框改变事件函数:角色名检查与替换新增按钮文本	(NEW!)
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_Replace_EditBoxName_OnTextChanged( self, listType )

	if listType == "KeyWord" then
		if ( TinomDB.filterDB.replaceKeyWord[self:GetText()] or TinomDB.filterDB.replaceKeyWord[self:GetText()] ) then
			_G[self:GetParent():GetName().."ButtonAdd"]:SetText(Tinom.L["修改"]);
		else
			_G[self:GetParent():GetName().."ButtonAdd"]:SetText(Tinom.L["新增"]);
		end
	elseif listType == "Name" then
		if ( TinomDB.filterDB.replaceName[self:GetText()] or TinomDB.filterDB.replaceKeyWord[self:GetText()] ) then
			_G[self:GetParent():GetName().."ButtonAdd"]:SetText(Tinom.L["修改"]);
		else
			_G[self:GetParent():GetName().."ButtonAdd"]:SetText(Tinom.L["新增"]);
		end
	end
end