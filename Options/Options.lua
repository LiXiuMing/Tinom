local L = Tinom.L

TINOM_OPTION_MAINPANEL_LABEL = L["Tinom设置"];
TINOM_OPTION_MAINPANEL_TITLE = L["Tinom聊天过滤"];
TINOM_OPTION_MAINPANEL_SUBTEXT = L["去年高三帮好朋友给实验班的男孩子写一封信,只有“山有木兮木有枝”七个字,想让他领会后半句心悦君兮君不知的含义.第二天男孩子主动来班里送信,还是昨天那封,他在后面补充到“心悦君兮君已知,奈何十二寒窗苦,待到金榜题名时.”   后来这段故事无疾而终 愿你们遇到的每段感情都能有处安放"];
TINOM_OPTION_MAINPANEL_CHACKBUTTON_MAINENABLE_TEXT = L["开启过滤"];
function Tinom.OptionsMainPanel_OnLoad(self)
	InterfaceOptions_AddCategory(self);
end


--[[-------------------------------------------------------------------------
--  标签初始函数:
-------------------------------------------------------------------------]]--
Tinom.OptionsTabButton = {
	TinomOptionsMainPanelBaseSettingTabButton = "TinomOptionsMainPanelBaseSetting",
	TinomOptionsMainPanelWhiteListTabButton = "TinomOptionsMainPanelWhiteListSetting",
	TinomOptionsMainPanelBlackListTabButton = "TinomOptionsMainPanelBlackListSetting",
	TinomOptionsMainPanelReplaceListTabButton = "TinomOptionsMainPanelReplaceListSetting",
};

function Tinom.TabButton_Close()
	for k,v in pairs(Tinom.OptionsTabButton) do
		PanelTemplates_DeselectTab(_G[k]);
		_G[v]:Hide();
	end
end
--[[-------------------------------------------------------------------------
--  标签切换函数:
-------------------------------------------------------------------------]]--
function Tinom.TabButton_OnClick( self )
	Tinom.TabButton_Close();
	PanelTemplates_SelectTab(self);
	_G[Tinom.OptionsTabButton[self:GetName()]]:Show();
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
end

--[[-------------------------------------------------------------------------
--  标签初始函数:
-------------------------------------------------------------------------]]--
function Tinom.TabButton_OnLoad()
	Tinom.TabButton_Close();
	if ( TinomOptionsMainPanelCheckButton_MainEnable:GetChecked() ) then
		PanelTemplates_SelectTab(TinomOptionsMainPanelBaseSettingTabButton);
		TinomOptionsMainPanelBaseSetting:Show();
	end
end

--[[-------------------------------------------------------------------------
--  总开关复选框函数:
-------------------------------------------------------------------------]]--
function Tinom.MainEnableCheckButton_OnClick(self)
	Tinom.TabButton_Close();
	if ( self:GetChecked() ) then
		Tinom.MsgFilterOn( );
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		PanelTemplates_SelectTab(TinomOptionsMainPanelBaseSettingTabButton);
		
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		Tinom.MsgFilterOff( );
	end
	TinomOptionsMainPanelBaseSetting:Show();
end