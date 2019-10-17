--[[
--  <姑娘 姑娘> - 郭斯
--  刚刚路上看到一个浑身脏兮兮的男孩，眼睛一直盯着路上一个小女孩手里拿着的牛奶。
--  小女孩喝完了把牛奶随手一丢，那个小男孩赶忙过去蹲下捡起地上的牛奶，并放进嘴里。
--  看到这个画面我鼻子不禁一酸，刚想拉起男孩，就看见他把盒子吹得鼓鼓的放在地上猛地一脚下去“砰!”他马的吓老子一跳!
]]--
--  临时表
TinomDB_ChatStatDB_cacheMsgTemp = {
    TinomChatStatFrameText_ReplaceMsg_Num = 0,
    TinomChatStatFrameText_FoldMsg_Num = 0,
    TinomChatStatFrameText_BlackList_Num = 0,
    TinomChatStatFrameText_BlackKeywordList_Num = 0,
    TinomChatStatFrameText_RepeatMsg_Num = 0,
    TinomChatStatFrameText_IntervalMsg_Num = 0,
};

TinomDB_filterDB_whiteListTemp = {};
TinomDB_filterDB_blackListTemp = {};
TinomDB_playerDB_classTemp = {};

--  当前玩家名
local playerName = UnitName("player");

--  声音提醒  --
Tinom.ReminderType = {
    ["WhitelistKeyword"]  = {
        switch = "Tinom_Switch_MsgFilter_WhiteListKeyWordSound",
        soundID = "Tinom_Switch_MsgFilter_WhiteListSoundID",
    };
    ["Whitelist"] = {
        switch = "Tinom_Switch_MsgFilter_WhiteListSound",
        soundID = "Tinom_Switch_MsgFilter_WhiteListSoundID",
    };
};

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
                    if ( name and TinomDB_playerDB_classTemp[name]) then
                        local playerClass = TinomDB_playerDB_classTemp[name];
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

function Tinom.MsgFilter( self,event,... )
    if ( not TinomDB.Options.Default.Tinom_Switch_MsgFilter_MainEnable )then
        return false;
    end
    --if ( event ~= "CHAT_MSG_CHANNEL" ) then return end
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = ...;
    if (not arg12) or (not arg12:find("Player")) then return; end
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

    --  白名单模式
    local ignore = false;
    local remind = nil;
    if ( msgFilters ) then
        local newArg1, newArg2;
        for _, filterFunc in next, msgFilters do
            ignore, newArg1, newArg2, remind = filterFunc(arg1, authorName, authorServer, remind);
            if ( ignore == true ) then
                return true;
            else
                arg1 = newArg1 or arg1;
                arg2 = newArg2 or arg2;
            end
            if (ignore == "RightNow!") then
                ignore = false;
                break;
            end
        end
        if (remind) then
            Tinom.Reminder(remind)
        end
    end
    return ignore, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14;
end

function Tinom.MsgFilter_AddMsgFilter (filter)
	assert(filter);

	if ( msgFilters ) then
		-- Only allow a filter to be added once
		for index, filterFunc in next, msgFilters do
			if ( filterFunc == filter ) then
				return;
			end
		end
	else
		msgFilters = {};
	end

	tinsert(msgFilters, filter);
end

function Tinom.MsgFilter_RemoveMsgFilter (filter)
	assert(filter);

	if ( msgFilters ) then
		for index, filterFunc in next, msgFilters do
			if ( filterFunc == filter ) then
				tremove(msgFilters, index);
			end
		end

		if ( #msgFilters == 0 ) then
			msgFilters = nil;
		end
	end
end

--  白名单过滤  --
function Tinom.MsgFilter_Whitelist(msg, authorName, authorServer, remind)
    assert(authorName and msg);
    
    for k,v in pairs(TinomDB.filterDB.whiteList) do
        if ( authorName == v ) then
            if (TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListHighlight) then
                newArg1 = "|cffffff00"..msg.."|r"
                remind = "Whitelist";
                ignore = "RightNow!";
                return ignore, newArg1, nil, remind;
            end
        end
    end
end

--  关键字白名单  --
function Tinom.MsgFilter_WhitelistKeyword( msg, authorName, authorServer, remind)
    assert(authorName and msg);
    
    for _,keyword in pairs(TinomDB.filterDB.whiteListKeyWord) do
        if msg:find(keyword) then
            if (TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListKeyWordHighlight) then
                newArg1 = msg:gsub(keyword,"|cffffff00"..keyword.."|r")
            end
            remind = "WhitelistKeyword";
            ignore = "RightNow!";
            return ignore, newArg1, nil, remind;
        end
    end
end

--  黑名单过滤  --
function Tinom.MsgFilter_Blacklist( msg,authorName,authorServer, remind )
    assert(authorName);

    for _,author in pairs(TinomDB.filterDB.blackList) do
        if ( authorName == author ) then
            remind = nil;
            return true, nil, nil, remind;
        end
    end
    return false, nil, nil, remind;
end

--  关键字黑名单过滤  --
function Tinom.MsgFilter_BlacklistKeyword( msg,authorName,authorServer, remind )
    assert(authorName and msg);
    
    for _,keyword in pairs(TinomDB.filterDB.blackListKeyWord) do
        if msg:find(keyword) then
            return true, nil, nil, remind;
        end
    end
    return false, nil, nil, remind;
end
function Tinom.MsgFilter_SensitiveList( msg,authorName,authorServer, remind )
    -- body
end
function Tinom.MsgFilter_SensitiveKeyword( msg,authorName,authorServer, remind )
    -- body
end
function Tinom.MsgFilter_AutoBlackList( msg,authorName,authorServer, remind )
    -- body
end
--  重复消息过滤函数:
function Tinom.MsgFilter_RepeatMsg( msg,authorName,authorServer, remind )
    assert(authorName and msg and authorServer);

    local exist,elapsed = Tinom.MsgFilter_IsAuthorExist( authorName,authorServer );
    if exist and ((elapsed < TinomDB.Options.Default.Tinom_Value_MsgFilter_RepeatMsgElapsed)
        or (TinomDB.Options.Default.Tinom_Value_MsgFilter_RepeatMsgElapsed == 0)) then
        if TinomDB.chatStatDB[authorServer][authorName].msg_last_text == msg then
            return true, nil, nil, remind;
        end
    end
    return false, nil, nil, remind;
end

--  消息间隔过滤函数:
function Tinom.MsgFilter_IntervalMsg( msg,authorName,authorServer, remind )
    assert(authorName and msg and authorServer);

    local exist, elapsed = Tinom.MsgFilter_IsAuthorExist( authorName,authorServer );
    if exist and ((elapsed < TinomDB.Options.Default.Tinom_Value_MsgFilter_IntervalMsgTime)
        or (TinomDB.Options.Default.Tinom_Value_MsgFilter_IntervalMsgTime == 0)) then
        return true, nil, nil, remind;
    end
    return false, nil, nil, remind;
end

--  发言者数据库检查
function Tinom.MsgFilter_IsAuthorExist( authorName,authorServer )
    if TinomDB.chatStatDB[authorServer] then
        if TinomDB.chatStatDB[authorServer][authorName] then
            local elapsed = time() - TinomDB.chatStatDB[authorServer][authorName].msg_last_time;
            return true, elapsed;
        end
    end
    return false;
end

--  折叠复读消息
function Tinom.MsgFilter_FoldMsg( msg,authorName,authorServer, remind )
    if len(msg)<20 then
        return false, msg;
    end
    --msg = msg:gsub("%s+","");--还没决定是否使用,这是一个 增强折叠 and (不破坏结构 or 降低复杂度)的两难选择
    local heatSample = msg:match("^......");
    heatSample = heatSample:gsub("(%p)","%%%1");
    local heatLength = msg:find(heatSample,#heatSample);

    if heatLength then
        local foldMsg = strsub(msg,1,heatLength-1);
        foldMsg = foldMsg:gsub("(%p)","%%%1");
        if msg:find(foldMsg,heatLength) then
            msg, num = msg:gsub(foldMsg,"");
            foldMsg = foldMsg:gsub("%%","");
            newArg1 = foldMsg..msg.." x"..num;
            return false, newArg1;
        end
    end
    return false, msg, nil, remind;
end

--  替换角色名:
function Tinom.MsgFilter_ReplaceName( msg,authorName,authorServer, remind )
    local newMsg,newName;
    local name = authorName.."-"..authorServer;

    for k,v in pairs(TinomDB.filterDB.replaceName) do
        if ( authorName == k ) then
            if (#v.newName > 0) then
                newName = v.newName.."-"..authorServer;
                return false, newMsg, newName, remind;
            end
        elseif ( name == k ) then
            if (#v.newName > 0) then
                newName = v.newName;
                return false, newMsg, newName, remind;
            end
        end
    end
    return false, newMsg, newName, remind;
end

--  替换角色消息:
function Tinom.MsgFilter_ReplaceNameMsg( msg,authorName,authorServer, remind )
    local newMsg,newName;
    local name = authorName.."-"..authorServer;

    for k,v in pairs(TinomDB.filterDB.replaceName) do
        if ( authorName == k ) then
            if (#v.newMsg > 0) then
                newMsg = v.newMsg;
                return false, newMsg, newName, remind;
            end
        elseif ( name == k ) then
            if (#v.newMsg > 0) then
                newMsg = v.newMsg;
                return false, newMsg, newName, remind;
            end
        end
    end
    return false, newMsg, newName, remind;
end

--  关键字替换:
function Tinom.MsgFilter_ReplaceKeyword( msg,authorName,authorServer, remind )
    local newMsg;
    for k,v in pairs(TinomDB.filterDB.replaceKeyWord) do
        if ( msg:find(k) ) then
            if (#v.newWord > 0) then
                newMsg = msg:gsub(k,v.newWord);
                return false, newMsg, nil, remind;
            end
        end
    end
    return false,nil, nil, remind;
end

--  关键字消息替换:
function Tinom.MsgFilter_ReplaceKeywordMsg( msg,authorName,authorServer, remind )
    local newMsg;
    for k,v in pairs(TinomDB.filterDB.replaceKeyWord) do
        if ( msg:find(k) ) then
            if (#v.newMsg > 0) then
                newMsg = v.newMsg;
                return false, newMsg, nil, remind;
            end
        end
    end
    return false, nil, nil, remind;
end

--  声音提醒  --
function Tinom.Reminder( type )
    --assert(type);
    if not type then return; end

    if TinomDB.Options.Default[Tinom.ReminderType[type].switch] then
        PlaySound(TinomDB.Options.Default[Tinom.ReminderType[type].soundID]);
    end
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
    --ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", Tinom.MsgFilter)
    --ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", Tinom.MsgFilter)
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
    --ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SAY", Tinom.MsgFilter)
    --ChatFrame_RemoveMessageEventFilter("CHAT_MSG_YELL", Tinom.MsgFilter)
    --ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", Tinom.MsgFilter)
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", Tinom.MsgFilter_Item)
    print("过滤已关闭")
end


Tdebug(self,"log","Filter.lua加载完成");