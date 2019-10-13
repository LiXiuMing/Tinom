--[[-------------------------------------------------------------------------
--
--  Filter Model
--  聊天过滤模块
--
--  功能:过滤啊!哈哈哈
--
-------------------------------------------------------------------------]]--
--  临时表
TinomDB_filterDB_cacheMsgTemp = {};
TinomDB_filterDB_whiteListTemp = {};
TinomDB_filterDB_blackListTemp = {};
TinomDB_playerDB_classTemp = {};

--  当前玩家名
local playerName = UnitName("player");

--  颜色表
Tinom.classes = {
    ["HUNTER"]      = "ffa9d271",
    ["WARLOCK"]     = "ff8686ec",
    ["PRIEST"]      = "fffefefe",
    ["PALADIN"]     = "fff38bb9",
    ["MAGE"]        = "ff3ec5e9",
    ["ROGUE"]       = "fffef367",
    ["DRUID"]       = "fffe7b09",
    ["SHAMAN"]      = "ff006fdc",
    ["WARRIOR"]     = "ffc59a6c",
    ["DEATHKNIGHT"] = "ffc31d39",
    ["MONK"]        = "ff00fe95",
    ["DEMONHUNTER"] = "ffa22fc8"
};

--[[-------------------------------------------------------------------------
--  聊天频道名替换函数:因上级函数使用频道名字符串长度作为逻辑条件不便更改,
--  故通过接管聊天框的AddMessage函数替换字符串,此处为把频道序号后的频道名隐藏.
-------------------------------------------------------------------------]]--
function Tinom.ReplaceChannelName()
    for i=1,NUM_CHAT_WINDOWS do
        if (i ~= 2) then
            local chatFrame = _G["ChatFrame"..i]
            local addmsg = chatFrame.AddMessage
            chatFrame.AddMessage = function(frame, text,...)
                if ( Tinom.Tinom_Switch_MsgFilter_Classic ) then
                    local name = text:match("|Hplayer.-|h%[(%S-)%]|h")
                    if ( name ) then
                        local playerClass = TinomDB_playerDB_classTemp[name] or "PRIEST";
                        local colorname = "|c"..Tinom.classes[playerClass]..name.."|r"
                        text = string.gsub(text,"%["..name.."%]","%["..colorname.."%]")
                    end
                end
                if (TinomDB.Options.Default.Tinom_Switch_MsgFilter_AbbrChannelName) then
                    text = text:gsub( "%[(%d)%..-%]", "%[%1%]" )
                end
                if (TinomDB.Options.Default.Tinom_Switch_MsgFilter_AbbrAuthorName) then
                    text = text:gsub( "(%|%w-%S-)%-%S-%|", "%1%#%|" );
                end
                return addmsg(frame,text,...)
            end
        end
    end
end

--[[-------------------------------------------------------------------------
--  角色名替换函数:替换角色消息开关,替换名单
-------------------------------------------------------------------------]]--
function Tinom.ReplaceName( name )
    --Tdebug(self,"log","Tinom.ReplaceName.触发");
    local authorName, authorServer = name:match( "(.-)(%-.*)" );
    local newName,newMsg = nil, nil;

    for k,v in pairs(TinomDB.filterDB.replaceName) do
        if ( name == k ) then
            if ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceName == true ) and (#v.newName > 0) then
                newName = v.newName;
            end
            if ( ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceNameMsg == true ) and (#v.newMsg > 0)  ) then
                newMsg = v.newMsg;
            end
            return newMsg, newName;
        elseif ( authorName == k ) then
            if ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceName == true ) and (#v.newName > 0) then
                newName = v.newName..authorServer;
            end
            if ( ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceNameMsg == true ) and (#v.newMsg > 0) ) then
                newMsg = v.newMsg;
            end
            return newMsg, newName;
        end
    end
    return newMsg, newName;
end

--[[-------------------------------------------------------------------------
--  消息替换函数:替换关键字消息开关,替换关键字名单
-------------------------------------------------------------------------]]--
function Tinom.ReplaceMsg( ... )
    --Tdebug(self,"log","Tinom.ReplaceMsg.触发");
    local msg = ...;
    local newMsg = nil;
    for k,v in pairs(TinomDB.filterDB.replaceKeyWord) do
        if ( msg:find(k) ) then
            if ( ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceKeyWordMsg == true ) and #v.newMsg > 0 ) then
                newMsg = v.newMsg;
                --TinomChatStatFrameText_ReplaceMsg_Num:SetText(TinomChatStatFrameText_ReplaceMsg_Num:GetText()+0.1);
                return newMsg;
            end
            if ( ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceKeyWord == true ) and #v.newWord > 0 ) then
                newMsg = msg:gsub(k,v.newWord);
            end
            msg = newMsg or msg;
        end
    end
    -- if msg ~= ... then
    --     TinomChatStatFrameText_ReplaceMsg_Num:SetText(TinomChatStatFrameText_ReplaceMsg_Num:GetText()+0.1);
    -- end
    return msg;
end

--[[-------------------------------------------------------------------------
--  重复信息过滤函数:过滤频道内所有人的重复发言
--                  缓存20条消息进行对比,若重复则丢弃
-------------------------------------------------------------------------]]--
function Tinom.CacheMsgRepeat( self,event,msg )
    local frameName = self:GetName()
    if TinomDB_filterDB_cacheMsgTemp[frameName] == nil then
        TinomDB_filterDB_cacheMsgTemp[frameName] = {};
    end
    
    for k,v in pairs(TinomDB_filterDB_cacheMsgTemp[frameName]) do
        if ( msg == v ) then
            return true;
        end
    end
    table.insert( TinomDB_filterDB_cacheMsgTemp[frameName], 1, msg )
    if ( #TinomDB_filterDB_cacheMsgTemp[frameName] == 21 ) then
        table.remove( TinomDB_filterDB_cacheMsgTemp[frameName], 21)
    end
    return false;
end

--[[-------------------------------------------------------------------------
--  折叠复读消息
-------------------------------------------------------------------------]]--
function Tinom.FoldMsg( newArg1 )
    local theMsg = newArg1;
    local heatSample = theMsg:match("^......")
    if heatSample then
        heatSample = heatSample:gsub("(%p)","%%%1")
        local a = theMsg:find(heatSample,#heatSample);
        if a then
            local msg2 = strsub(theMsg,1,a-1)
            msg2 = msg2:gsub("(%p)","%%%1")
            if theMsg:find(msg2,a+1) then
                theMsg, num = theMsg:gsub(msg2,"")
                msg2 = msg2:gsub("%%","")
                theMsg = msg2..theMsg.." x"..num
                --TinomChatStatFrameText_FoldMsg_Num:SetText(TinomChatStatFrameText_FoldMsg_Num:GetText()+0.1);
            end
        end
        newArg1 = theMsg;
        return newArg1;
    end
end
    
--[[-------------------------------------------------------------------------
--  消息过滤函数:白名单开关,黑名单开关,白名单,临时白名单,黑名单,临时黑名单,
--              替换角色名开关,替换关键字开关 or (authorName == playerName)
-------------------------------------------------------------------------]]--
function Tinom.MsgFilter( self,event,... )
    if ( not TinomDB.Options.Default.Tinom_Switch_MsgFilter_MainEnable )then
        return false;
    end
    --if ( event ~= "CHAT_MSG_CHANNEL" ) then return end
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = ...;
    if not arg12:find("Player") then return; end
    local authorName, authorServer = arg2:match( "(.-)%-(.*)" )
    --local eventType = strsub(event, 10);
    
    --  针对怀旧服--##--
    if not authorServer then
        authorName = arg2;
        authorServer = "server";
    end
    --  怀旧服缓存发言角色职业
    if Tinom.Tinom_Switch_MsgFilter_Classic then
        local _, Class  = GetPlayerInfoByGUID(arg12);
        TinomDB_playerDB_classTemp[authorName] = Class;
    end
    
    --  统计函数  --
    --统计函数
    
    local newArg1, newArg2 = nil, nil;
    local ignoreKey = true;
    
    --  白名单过滤  --
    if ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteList ) then
        for k,v in pairs(TinomDB.filterDB.whiteList) do
            if ( authorName == v ) then
                if (TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListSound) then
                    PlaySound(TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListSoundID);
                end
                if (TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListHighlight) then
                    newArg1 = "|cffffff00"..arg1.."|r"
                end
                ignoreKey = false;
                --return false, newArg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14; 
            end
        end
        -- if ( TinomDB.filterDB.whiteList[authorName] or TinomDB_filterDB_whiteListTemp[authorName] ) then
        --     return false;
        -- end
    end

    --  关键字白名单  --
    if ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListKeyWord ) then
        for _,v in pairs(TinomDB.filterDB.whiteListKeyWord) do
            if arg1:find(v) then
                if TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListKeyWordSound then
                end
                if (TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListKeyWordHighlight) then
                    newArg1 = arg1:gsub(v,"|cffffff00"..v.."|r")
                end
                ignoreKey = false;
                --return false, newArg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14; 
            end
        end
    end

    if not ignoreKey then
        --  历史20条信息内重复,不区分角色  --
        if ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_CacheMsgRepeat ) then
            if ( Tinom.CacheMsgRepeat( self,event,newArg1 ) ) then
                return true;
            end
        end
        --  替换功能  --也可以使用元表方法setmetatable(table1,table2)
        if ((TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceName)
        or (TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceNameMsg)
        ) then
            newArg1, newArg2 = Tinom.ReplaceName( arg2 );
        end
        
        if ((TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceKeyWord
        or (TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceKeyWordMsg)
        )) then
            newArg1 = Tinom.ReplaceMsg( newArg1 or arg1 );
            --TinomChatStatFrameText_ReplaceMsg_Num:SetText(TinomChatStatFrameText_ReplaceMsg_Num:GetText()+0.1);
        end

        if ( newArg1 == nil ) then newArg1 = arg1; end
        if ( newArg2 == nil ) then newArg2 = arg2; end

        --  折叠复读消息
        local strLength = string.len( newArg1 )
        if ((TinomDB.Options.Default.Tinom_Switch_MsgFilter_FoldMsg) and (strLength > 20)) then
            newArg1 = Tinom.FoldMsg( newArg1 ) or newArg1;
        end
        PlaySound(TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListSoundID);
        --TinomChatStatFrameText_FoldMsg_Num:SetText(TinomChatStatFrameText_FoldMsg_Num:GetText()+0.1);
        return false, newArg1, newArg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14;
    end

    --  白名单模式
    if ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListOnly) then
        return true;
    end

    --  黑名单过滤  --
    if ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_BlackList ) then
        for k,v in pairs(TinomDB.filterDB.blackList) do
            if ( authorName == v ) then
                --TinomChatStatFrameText_BlackList_Num:SetText(TinomChatStatFrameText_BlackList_Num:GetText()+0.1);
                return true;
            end
        end
        -- if ( TinomDB.filterDB.blackList[authorName] or TinomDB_filterDB_blackListTemp[authorName]) then
        --     return true;
        -- end
    end
    
    --  关键字黑名单过滤  --
    if ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_BlackListKeyWord ) then
        for _,v in pairs(TinomDB.filterDB.blackListKeyWord) do
            if arg1:find(v) then
                --TinomChatStatFrameText_BlackKeywordList_Num:SetText(TinomChatStatFrameText_BlackKeywordList_Num:GetText()+0.1);
                return true;
            end
        end
    end

    --  历史20条信息内重复,不区分角色  --
    if ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_CacheMsgRepeat ) then
        if ( Tinom.CacheMsgRepeat( self,event,arg1 ) ) then
            --TinomChatStatFrameText_RepeatMsg_Num:SetText(TinomChatStatFrameText_RepeatMsg_Num:GetText()+0.1);
            return true;
        end
    end

    --  替换功能  --也可以使用元表方法setmetatable(table1,table2)
    if ((TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceName)
    or (TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceNameMsg)
    ) then
        newArg1, newArg2 = Tinom.ReplaceName( arg2 );
    end
    
    if ((TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceKeyWord
    or (TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceKeyWordMsg)
    ) and (newArg1 == nil)) then
        newArg1 = Tinom.ReplaceMsg( arg1 );
    end

    if ( newArg1 == nil ) then newArg1 = arg1; end
    if ( newArg2 == nil ) then newArg2 = arg2; end

    --  折叠复读消息
    local strLength = string.len( newArg1 )
    if ((TinomDB.Options.Default.Tinom_Switch_MsgFilter_FoldMsg) and (strLength > 20)) then
        newArg1 = Tinom.FoldMsg( newArg1 ) or newArg1;
    end

    return false, newArg1, newArg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14;
end

--[[-------------------------------------------------------------------------
--  消息过滤函数:过滤物品消息,屏蔽灰色物品
-------------------------------------------------------------------------]]--
function Tinom.MsgFilter_Item( self, event, ... )
    if not TinomDB.Options.Default.Tinom_Switch_MsgFilter_IgnoreGrayItems then return; end
    local arg1 = ...;
    local itemID = GetItemInfoFromHyperlink(arg1);
    local itemName,_,itemRarity = GetItemInfo(itemID);
    Tdebug(self,"log","MsgFilter_Item:"..itemName..itemID.."品质:"..itemRarity);
    if itemRarity == 0 then
        return true;
    end
    return false;
end

--[[-------------------------------------------------------------------------
--  消息过滤函数:开
-------------------------------------------------------------------------]]--
function Tinom.MsgFilterOn()
    filterDB_Temp = TinomDB.filterDB;
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", Tinom.MsgFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", Tinom.MsgFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", Tinom.MsgFilter)
    --ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", Tinom.MsgFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", Tinom.MsgFilter_Item)
    print("过滤已开启")
end

--[[-------------------------------------------------------------------------
--  消息过滤函数:关
-------------------------------------------------------------------------]]--
function Tinom.MsgFilterOff()
    filterDB_Temp = {};
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", Tinom.MsgFilter)
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SAY", Tinom.MsgFilter)
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_YELL", Tinom.MsgFilter)
    --ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", Tinom.MsgFilter)
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", Tinom.MsgFilter_Item)
    print("过滤已关闭")
end


Tdebug(self,"log","Filter.lua加载完成");