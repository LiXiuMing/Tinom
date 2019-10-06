local L = Tinom.L

--[[-------------------------------------------------------------------------
--  字符串:
-------------------------------------------------------------------------]]--
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
	TinomOptionsMainPanelReplaceListTabButton = "TinomOptionsMainPanelReplace",
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
		--Tdebug(self,"log","Options.未发现配置数据库");
		TinomDB.Options.Default = Tinom.defaultOptionsCheckButtons;
		if ( TinomDB.Options.Default ) then
			--Tdebug(self,"log","Options.数据库已初始化");
			Tinom.OptionsMainPanel_LoadOptions();
		else
			Tdebug(self,"error","Options.数据库初始化失败");
		end
	end
	--Tdebug(self,"log","Options.数据库检查完成");
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
	Tinom.OptionsMainPanel_ReplaceName_ListBrowseButton_LoadData();
	--Tdebug(self,"log","OptionsMainPanel_OnLoad.配置加载完成");
end

--[[-------------------------------------------------------------------------
--  初始化:设置界面名单文本框加载配置
-------------------------------------------------------------------------]]--
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
	--Tdebug(self,"log","Options.Tinom配置已保存");
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

	--Tdebug(self,"log","Options.名单已保存");
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
	--Tdebug(self,"log","OptionsPanel_TextToTable.Go");
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
			--Tdebug(self,"log","OptionsPanel_TextToTable.table.insert");
		else
			local str = string.sub(textIn,index);
			if (#str>4) then
				table.insert(tableOut,1,str);
			end
			--Tdebug(self,"log","OptionsPanel_TextToTable.break");
			break;
		end
	end
	--Tdebug(self,"log","OptionsPanel_TextToTable.End"..#tableOut);
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
--  #######################################################################
--	替换名单界面
--	#######################################################################
-------------------------------------------------------------------------]]--
--[[-------------------------------------------------------------------------
--  初始化:设置界面替换名单列表加载配置
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceName_ListBrowseButton_LoadData( ... )
	local index = 1;
	Tinom.tableReplaceNameTemp = {};
	for k,v in pairs(TinomDB.filterDB.replaceName) do
		Tinom.tableReplaceNameTemp[index] = {k,v.newName,v.newMsg};
		index = index + 1;
	end
	Tinom.OptionsMainPanel_ReplaceName_ListBrowseButton_Updata(1);
end
--[[-------------------------------------------------------------------------
--  初始化:设置界面替换名单列表翻页更新
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceName_ListBrowseButton_Updata( index )
	Tinom.OptionsMainPanel_ReplaceName_ListBrowseButton_Clear();
	Tinom.OptionsMainPanel_ReplaceName_ListBrowseButton_ClearHighlight();
	----Tdebug(self,"log","Options.replaceName.ListBrowseButton_Updata."..index);
	for k=1,math.min( (#Tinom.tableReplaceNameTemp - index+1), 10 ) do
		if k == 11 then break; end
		_G["TinomOptionsMainPanelReplaceNameListButton"..k]:Show();
		_G["TinomOptionsMainPanelReplaceNameListButton"..k.."_Name"]:SetText(Tinom.tableReplaceNameTemp[index][1]);
		_G["TinomOptionsMainPanelReplaceNameListButton"..k.."_NewName"]:SetText(Tinom.tableReplaceNameTemp[index][2]);
		_G["TinomOptionsMainPanelReplaceNameListButton"..k.."_NewMsg"]:SetText(Tinom.tableReplaceNameTemp[index][3]);
		index = index + 1;
	end
	Tinom.OptionsMainPanel_ReplaceName_Scroll_Update();
end
--[[-------------------------------------------------------------------------
--  初始化:设置界面替换名单列表清空
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceName_ListBrowseButton_Clear()
	for i=1,10 do
		_G["TinomOptionsMainPanelReplaceNameListButton"..i.."_Name"]:SetText();
		_G["TinomOptionsMainPanelReplaceNameListButton"..i.."_NewName"]:SetText();
		_G["TinomOptionsMainPanelReplaceNameListButton"..i.."_NewMsg"]:SetText();
		_G["TinomOptionsMainPanelReplaceNameListButton"..i]:Hide();
	end
end

--[[-------------------------------------------------------------------------
--  替换名单界面名单列表按钮点击事件函数:清理高亮
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceName_ListBrowseButton_ClearHighlight()
	for i=1,10 do
		_G["TinomOptionsMainPanelReplaceNameListButton"..i]:UnlockHighlight();
	end
end

--[[-------------------------------------------------------------------------
--  替换名单界面文本框改变事件函数:角色名检查与替换新增按钮文本
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceName_EditBoxName_OnTextChanged(self)
	if ( TinomDB.filterDB.replaceName[self:GetText()] ) then
		_G[self:GetParent():GetName().."ButtonAdd"]:SetText("修改");
	  else
		_G[self:GetParent():GetName().."ButtonAdd"]:SetText("新增");
	  end
end

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
	Tinom.OptionsMainPanel_ReplaceName_ListBrowseButton_ClearHighlight();
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
		----Tdebug(self,"log","Options.replaceName.新增条目");
		Tinom.OptionsMainPanel_ReplaceName_ClearEditBox()
		Tinom.OptionsMainPanel_ReplaceName_ListBrowseButton_LoadData();
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
	Tinom.OptionsMainPanel_ReplaceName_ListBrowseButton_LoadData();
end

--[[-------------------------------------------------------------------------
--  滚轮事件函数:更新滚动条高度
-------------------------------------------------------------------------]]--
function Tinom.OptionsMainPanel_ReplaceName_Scroll_Update()
	local scrollHeight = TinomOptionsMainPanelReplaceNameListScrollFrame:GetHeight();
	if (#Tinom.tableReplaceNameTemp>10) then
		Tinom_ScrollFrame_HightFrame:SetHeight(scrollHeight + #Tinom.tableReplaceNameTemp - 9)
	end
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
	Tinom.OptionsMainPanel_ReplaceName_ListBrowseButton_Updata( math.floor(scrollBar:GetValue() + 1.5) )
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

--Tdebug(self,"log","Options.lua加载完成");

