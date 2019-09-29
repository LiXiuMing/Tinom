local MessageFilteringFrame = CreateFrame("Frame", "MessageFilteringFrame")
MessageFilteringFrame:SetParent(nil)
MessageFilteringFrame:RegisterEvent("PLAYER_LOGIN") 
MessageFilteringFrame:RegisterEvent("PLAYER_REGEN_ENABLED")  --脱战

MessageFilteringFrame.Filter = {}
MessageFilteringFrame.ShowFilter = {}
MessageFilteringFrame.friend = {} 

MessageFilteringFrame:SetScript("OnEvent", function(self, event, arg1, arg2, ...)
    if event == "PLAYER_REGEN_ENABLED" then
		collectgarbage();
	elseif  event == "PLAYER_LOGIN" then
	
		if  HuaJieInit then
			if HuaJieInit.key then
				PB_KEY:SetChecked(true); 				
				ShowFilterBox:Disable();
				FilterBox:Enable();
			else
				SHOW_KEY:SetChecked(true);
				FilterBox:Disable(); 
				ShowFilterBox:Enable();
			end
			if HuaJieInit.Filter then
				FilterBox:SetText(HuaJieInit.Filter);
				MessageFilteringFrame.Filter = huajie_split(HuaJieInit.Filter,"|");
			end
			if HuaJieInit.ShowFilter then
				ShowFilterBox:SetText(HuaJieInit.ShowFilter);
				MessageFilteringFrame.ShowFilter = huajie_split(HuaJieInit.ShowFilter,"|");
			end
			if HuaJieInit.friend then
				friendFilterBox:SetText(HuaJieInit.friend);
				MessageFilteringFrame.friend = huajie_split(HuaJieInit.friend,"|");
			end
			
		else
			HuaJieInit={};
			HuaJieInit.key = true;
			PB_KEY:SetChecked(true); 
			ShowFilterBox:Disable();
			FilterBox:Enable();
		end
		
	    AutoFollowStatusText:SetScale(3);
		
		SetCVar("ScriptErrors",0);
		
	end 
end)


function cl_command(self,event,msg,author,arg3,arg4,arg5,arg6,arg7,arg8,...) 
	local IsShow = false;
	for k, v in pairs(MessageFilteringFrame.friend) do
		if author == v then
			IsShow = true;
			break
		end
	end
	
	if IsShow then
		return false;
	end
	
	if HuaJieInit.key then
		for k, v in pairs(MessageFilteringFrame.Filter) do
			if  string.find(msg, v, 1, false) then
				IsShow = true;
				break
			end
		end
		
		if IsShow then 
			return true;
		end
		
	else
		for k, v in pairs(MessageFilteringFrame.ShowFilter) do
			if string.find(msg, v, 1, false) then
				IsShow = true;
				break
			end
		end
		
		if not IsShow then
			return true;
		end 
	end
end)

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", cl_command)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", cl_command)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", cl_command)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", cl_command) 

-- Create an options panel and insert it into the interface menu
local OptionsPanel = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
OptionsPanel:Hide()
OptionsPanel:SetAllPoints()
OptionsPanel.name = "消息过滤设置"
OptionsPanel.parent = addonName


local Title = OptionsPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
Title:SetJustifyV('TOP')
Title:SetJustifyH('LEFT')
Title:SetPoint('TOPLEFT', 16, -16)
Title:SetText(OptionsPanel.name)

local SubText = OptionsPanel:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
SubText:SetMaxLines(3)
SubText:SetNonSpaceWrap(true)
SubText:SetJustifyV('TOP')
SubText:SetJustifyH('LEFT')
SubText:SetPoint('TOPLEFT', Title, 'BOTTOMLEFT', 0, -8)
SubText:SetPoint('RIGHT', -32, 0)
SubText:SetText('主要功能就是屏蔽包含关键字的聊天内容\n1.用|分开\n2.不要忘记应用设置')

InterfaceOptions_AddCategory(OptionsPanel)
SLASH_Tinom1 = "/tinom"
function SlashCmdList.Tinom(msg, editbox)
    InterfaceOptionsFrame_OpenToCategory(OptionsPanel)
    InterfaceOptionsFrame_OpenToCategory(OptionsPanel)
end

local HidetxtLable1 = OptionsPanel:CreateFontString(nil,"ARTWORK");  
HidetxtLable1:SetFont(GameFontNormal:GetFont(), 24) 
HidetxtLable1:SetTextColor(0.8,0,0,1)  
HidetxtLable1:SetPoint("TOPLEFT",OptionsPanel,10, -120) 
HidetxtLable1:SetText("屏蔽以下关键词的消息") 

 
local PB_KEY = _G.CreateFrame("CheckButton", "PB_KEY",OptionsPanel,"OptionsCheckButtonTemplate")
PB_KEY:SetWidth(35) 
PB_KEY:SetHeight(35)  
PB_KEY:SetPoint('TOPLEFT', HidetxtLable1, 'BOTTOMRIGHT', 0, 30)
PB_KEY:SetScale(1)
PB_KEY:SetScript("OnClick", function() 
	if PB_KEY:GetChecked() then 
		SHOW_KEY:SetChecked(false); 
		ShowFilterBox:Disable();
		FilterBox:Enable();  
		
	else 
		SHOW_KEY:SetChecked(true); 
		FilterBox:Disable(); 
		ShowFilterBox:Enable(); 
		
	end 
end)			
						

local FilterBox = CreateFrame('editbox',"FilterBox", OptionsPanel, 'InputBoxTemplate')
FilterBox:SetPoint('TOPLEFT', HidetxtLable1, 'BOTTOMLEFT', 0, -5)
FilterBox:SetPoint('RIGHT', OptionsPanel, 'RIGHT', -60, 0)
FilterBox:SetHeight(30)
FilterBox:SetAutoFocus(false)
FilterBox:ClearFocus()


local HidetxtLable2 = OptionsPanel:CreateFontString(nil,"ARTWORK");  
HidetxtLable2:SetFont(GameFontNormal:GetFont(), 24) 
HidetxtLable2:SetTextColor(0.8,0,0,1)  
HidetxtLable2:SetPoint("TOPLEFT",OptionsPanel,10, -200) 
HidetxtLable2:SetText("只显示包含以下关键词的消息") 

local SHOW_KEY = _G.CreateFrame("CheckButton", "SHOW_KEY",OptionsPanel,"OptionsCheckButtonTemplate")
SHOW_KEY:SetWidth(35) 
SHOW_KEY:SetHeight(35)
SHOW_KEY:SetPoint('TOPLEFT', HidetxtLable2, 'BOTTOMRIGHT', 0, 30)  
SHOW_KEY:SetScale(1)
SHOW_KEY:SetScript("OnClick", function() 
	if SHOW_KEY:GetChecked() then
		PB_KEY:SetChecked(false); 
		FilterBox:Disable(); 
		ShowFilterBox:Enable(); 
	else 
		PB_KEY:SetChecked(true);
		ShowFilterBox:Disable(); 
		FilterBox:Enable(); 
	end 
end)		

local ShowFilterBox = CreateFrame('editbox', "ShowFilterBox", OptionsPanel, 'InputBoxTemplate')
ShowFilterBox:SetPoint('TOPLEFT', HidetxtLable2, 'BOTTOMLEFT', 0, -5)
ShowFilterBox:SetPoint('RIGHT', OptionsPanel, 'RIGHT', -60, 0)
ShowFilterBox:SetHeight(30)
ShowFilterBox:SetAutoFocus(false)
ShowFilterBox:ClearFocus()


local HidetxtLable3 = OptionsPanel:CreateFontString(nil,"ARTWORK");  
HidetxtLable3:SetFont(GameFontNormal:GetFont(), 24) 
HidetxtLable3:SetTextColor(0.8,0,0,1)  
HidetxtLable3:SetPoint("TOPLEFT",OptionsPanel,10, -280) 
HidetxtLable3:SetText("友好名单,下列人员触发屏蔽也可以显示出来") 

local friendFilterBox = CreateFrame('editbox', "friendFilterBox", OptionsPanel, 'InputBoxTemplate')
friendFilterBox:SetPoint('TOPLEFT', HidetxtLable3, 'BOTTOMLEFT', 0, -5)
friendFilterBox:SetPoint('RIGHT', OptionsPanel, 'RIGHT', -60, 0)
friendFilterBox:SetHeight(30)
friendFilterBox:SetAutoFocus(false)
friendFilterBox:ClearFocus()

function huajie_split(str, reps)
   local r = {};
   if (str == nil) then return nil; end
   string.gsub(str, "[^"..reps.."]+", function(w) table.insert(r, w) end);
   return r;
end
			
local btn_start = _G.CreateFrame("Button",nil,OptionsPanel,"UIPanelButtonTemplate")
btn_start:SetWidth(100) 
btn_start:SetHeight(35)  
btn_start:SetPoint("BOTTOMRIGHT",OptionsPanel,-50,60) 
btn_start:SetScale(1)
btn_start:SetText("应用设置")
btn_start:SetScript("OnClick", function() 

if PB_KEY:GetChecked() then  
HuaJieInit.key = true;
else
HuaJieInit.key = false;
end

HuaJieInit.Filter = FilterBox:GetText()
HuaJieInit.ShowFilter = ShowFilterBox:GetText()
HuaJieInit.friend = friendFilterBox:GetText()

MessageFilteringFrame.Filter = huajie_split(HuaJieInit.Filter,"|");
MessageFilteringFrame.ShowFilter = huajie_split(HuaJieInit.ShowFilter,"|");
MessageFilteringFrame.friend = huajie_split(HuaJieInit.friend,"|");

FilterBox:ClearFocus()
ShowFilterBox:ClearFocus()
friendFilterBox:ClearFocus()

end)