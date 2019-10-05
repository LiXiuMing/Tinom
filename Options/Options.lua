Tdebug(self,"log","Options.lua加载开始");
local L = Tinom.L

--[[-------------------------------------------------------------------------
--  字符串:
-------------------------------------------------------------------------]]--
TINOM_OPTION_MAINPANEL_LABEL = L["Tinom聊天过滤"];
TINOM_OPTION_MAINPANEL_TITLE = L["Tinom聊天过滤"];
TINOM_OPTION_MAINPANEL_SUBTEXT = L["去年高三帮好朋友给实验班的男孩子写一封信,只有“山有木兮木有枝”七个字,想让他领会后半句心悦君兮君不知的含义.第二天男孩子主动来班里送信,还是昨天那封,他在后面补充到“心悦君兮君已知,奈何十二寒窗苦,待到金榜题名时.”   后来这段故事无疾而终 愿你们遇到的每段感情都能有处安放"];
TINOM_OPTION_MAINPANEL_CHACKBUTTON_MAINENABLE_TEXT = L["开启过滤"];

--[[-------------------------------------------------------------------------
--  默认配置:开关
-------------------------------------------------------------------------]]--
Tinom.defaultOptionsCheckButtons = {
	Tinom_Switch_MsgFilter_MainEnable = true;
	Tinom_Switch_MsgFilter_WhiteList = false;
	Tinom_Switch_MsgFilter_WhiteListKeyWord = false;
	Tinom_Switch_MsgFilter_WhiteListOnly = false;
	Tinom_Switch_MsgFilter_BlackList = true;
	Tinom_Switch_MsgFilter_BlackListKeyWord = false;
	Tinom_Switch_MsgFilter_ReplaceName = false;
	Tinom_Switch_MsgFilter_ReplaceNameMsg = false;
	Tinom_Switch_MsgFilter_ReplaceKeyWord = false;
	Tinom_Switch_MsgFilter_ReplaceKeyWordMsg = false;
	Tinom_Switch_MsgFilter_CacheMsgRepeat = false;
};
--[[-------------------------------------------------------------------------
--  默认配置:复选按钮文本
-------------------------------------------------------------------------]]--
Tinom.defaultOptionsCheckButtonsName = {
	WhiteList = "白名单",
	WhiteListKeyWord = "白名单关键字",
	BlackList = "黑名单",
	BlackListKeyWord = "黑名单关键字",
	ReplaceName = "替换角色名",
	ReplaceNameMsg = "替换角色的消息",
	ReplaceKeyWord = "替换关键字",
	ReplaceKeyWordMsg = "替换关键字的消息",
	CacheMsgRepeat = "重复消息",
	WhiteListOnly = "只有白名单",
};
--[[-------------------------------------------------------------------------
--  地址索引:标签按钮 = 子设置界面
-------------------------------------------------------------------------]]--
Tinom.optionsTabButtons = {
	TinomOptionsMainPanelBaseSettingTabButton = "TinomOptionsMainPanelBaseSetting",
	TinomOptionsMainPanelWhiteListTabButton = "TinomOptionsMainPanelWhiteListSetting",
	TinomOptionsMainPanelBlackListTabButton = "TinomOptionsMainPanelBlackListSetting",
	TinomOptionsMainPanelReplaceListTabButton = "TinomOptionsMainPanelReplaceListSetting",
};

--[[-------------------------------------------------------------------------
--  初始化:各过滤开关复选框加载其字符串文本
-------------------------------------------------------------------------]]--
function Tinom.OptionsBaseSettingCheckButton_OnLoad(self)
	--TinomOptionsMainPanelBaseSettingCheckButton_
	local buttonName = strsub(self:GetName(), 45);
	for k,v in pairs(Tinom.defaultOptionsCheckButtonsName) do
		if (buttonName == k) then
			_G[self:GetName().."Text"]:SetText(L[v])
			self.tooltipText = L["开启"]..v..L["过滤"];
		end
	end
end

--[[-------------------------------------------------------------------------
--  初始化:设置界面数据库检查
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_checkOptions()
	if not TinomDB.Options.Default then
		Tdebug(self,"log","Options.未发现配置数据库");
		TinomDB.Options.Default = Tinom.defaultOptionsCheckButtons;
		if ( TinomDB.Options.Default ) then
			Tdebug(self,"log","Options.数据库已初始化");
			Tinom.OptionsMainPanel_LoadOptions();
		else
			Tdebug(self,"error","Options.数据库初始化失败");
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
	Tinom.OptionsPanel_EditBox_LoadOptions();
	TinomOptionsMainPanelCheckButton_MainEnableText:SetText(L["开启过滤"]);
	TinomOptionsMainPanelCheckButton_MainEnable.tooltipText = L["开启过滤系统的主开关"];
	Tinom.OptionsTabButton_OnLoad();
	Tdebug(self,"log","OptionsMainPanel_OnLoad.配置加载完成");
end

--[[-------------------------------------------------------------------------
--  初始化:设置界面名单文本框加载配置
-------------------------------------------------------------------------]]--
-- ReplaceName:SetChecked(TinomDB.filterDB.ReplaceName);
-- ReplaceNameMsg:SetChecked(TinomDB.filterDB.ReplaceNameMsg);
-- ReplaceKeyWord:SetChecked(TinomDB.filterDB.ReplaceKeyWord);
-- ReplaceKeyWordMsg:SetChecked(TinomDB.filterDB.ReplaceKeyWordMsg);

function Tinom.OptionsPanel_EditBox_LoadOptions()
	TinomOptionsMainPanelWhiteListSettingEditList_WhiteListScrollFrameEditBox:SetText(table.concat(TinomDB.filterDB.whiteList,"\n"))
	TinomOptionsMainPanelWhiteListSettingEditList_WhiteListKeyWordScrollFrameEditBox:SetText(table.concat(TinomDB.filterDB.whiteListKeyWord,"\n"))
	TinomOptionsMainPanelBlackListSettingEditList_BlackListScrollFrameEditBox:SetText(table.concat(TinomDB.filterDB.blackList,"\n"))
	TinomOptionsMainPanelBlackListSettingEditList_BlackListKeyWordScrollFrameEditBox:SetText(table.concat(TinomDB.filterDB.blackListKeyWord,"\n"))

	Tdebug(self,"log","Options.名单已加载");
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
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_MainEnable = TinomOptionsMainPanelCheckButton_MainEnable:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteList = TinomOptionsMainPanelBaseSettingCheckButton_WhiteList:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListKeyWord = TinomOptionsMainPanelBaseSettingCheckButton_WhiteListKeyWord:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListOnly = TinomOptionsMainPanelBaseSettingCheckButton_WhiteListOnly:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_BlackList = TinomOptionsMainPanelBaseSettingCheckButton_BlackList:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_BlackListKeyWord = TinomOptionsMainPanelBaseSettingCheckButton_BlackListKeyWord:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceName = TinomOptionsMainPanelBaseSettingCheckButton_ReplaceName:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceNameMsg = TinomOptionsMainPanelBaseSettingCheckButton_ReplaceNameMsg:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceKeyWord = TinomOptionsMainPanelBaseSettingCheckButton_ReplaceKeyWord:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceKeyWordMsg = TinomOptionsMainPanelBaseSettingCheckButton_ReplaceKeyWordMsg:GetChecked();
	TinomDB.Options.Default.Tinom_Switch_MsgFilter_CacheMsgRepeat = TinomOptionsMainPanelBaseSettingCheckButton_CacheMsgRepeat:GetChecked();
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

	Tdebug(self,"log","Options.名单已保存");
end

--[[-------------------------------------------------------------------------
--  配置界面Okay函数:因需要框架载入支持,已转移至XML文件<OnLoad>事件内
-------------------------------------------------------------------------]]--
-- function TinomOptionsMainPanel.okay(self)
-- 	print("Tinom配置已保存")
-- 	Tinom.OptionsMainPanel_Updata();
-- end

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
--  总开关复选框函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainEnableCheckButton_OnClick(self)
	Tinom.OptionsTabButton_OnLoad();
	if ( self:GetChecked() ) then
		Tinom.MsgFilterOn();
	else
		Tinom.MsgFilterOff();
		TinomOptionsMainPanelBaseSettingTabButton:Hide();
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
	InterfaceOptionsFrame:EnableMouse(true)
	InterfaceOptionsFrame:RegisterForDrag("LeftButton")
	InterfaceOptionsFrame:SetScript("OnDragStart",function( self,event,... )
		if not self.isLocked then
			self:StartMoving()
		end
	end)
	InterfaceOptionsFrame:SetScript("OnDragStop",function( self,event,... )
		self:StopMovingOrSizing()
	end)
end

--[[-------------------------------------------------------------------------
--  文本转表函数:
-------------------------------------------------------------------------]]--
function Tinom.OptionsPanel_TextToTable( textIn )
	Tdebug(self,"log","OptionsPanel_TextToTable.Go");
	local tableOut = {};
	local index = 1;
	while(true)
	do
		local first,last = string.find(textIn,"\n",index)
		if (first and last) then
			local str = string.sub(textIn,index,first-1)
			if (#str>4) then
				table.insert(tableOut,1,str)
			end
			index = last+1;
			Tdebug(self,"log","OptionsPanel_TextToTable.table.insert");
		else
			local str = string.sub(textIn,index)
			if (#str>4) then
				table.insert(tableOut,1,str)
			end
			break;
			Tdebug(self,"log","OptionsPanel_TextToTable.break");
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

Tdebug(self,"log","Options.lua加载完成");