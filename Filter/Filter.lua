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
    ["SensitiveKeyword"]  = {
        switch = "Tinom_Switch_MsgFilter_SensitiveKeywordSound",
        soundID = "Tinom_Switch_MsgFilter_SensitiveKeywordSoundID",
    };
    ["SensitiveList"] = {
        switch = "Tinom_Switch_MsgFilter_SensitiveListSound",
        soundID = "Tinom_Switch_MsgFilter_SensitiveKeywordSoundID",
    };
};

--[[-------------------------------------------------------------------------
--  AddMessage过滤
-------------------------------------------------------------------------]]--
function Tinom.ReplaceChannelName()
    for i=1,NUM_CHAT_WINDOWS do
        if (i ~= 2) then
            local chatFrame = _G["ChatFrame"..i]
            local addmsg = chatFrame.AddMessage
            chatFrame.AddMessage = function(frame, text,...)
                if (Tinom.addMsgFilters) then
                    for _, filterFunc in next, Tinom.addMsgFilters do
                        text = filterFunc(text);
                    end
                end
                Tdebug(self,"log",frame.name..":"..text)
                return addmsg(frame,text,...)
            end
        end
    end
end
function Tinom.AddMessageFilter_AddMsgFilter (filter)
	assert(filter);

	if ( Tinom.addMsgFilters ) then
		-- Only allow a filter to be added once
		for index, filterFunc in next, Tinom.addMsgFilters do
			if ( filterFunc == filter ) then
				return;
			end
		end
	else
		Tinom.addMsgFilters = {};
	end

	tinsert(Tinom.addMsgFilters, filter);
end

function Tinom.AddMessageFilter_RemoveMsgFilter (filter)
	assert(filter);

	if ( Tinom.addMsgFilters ) then
		for index, filterFunc in next, Tinom.addMsgFilters do
			if ( filterFunc == filter ) then
				tremove(Tinom.addMsgFilters, index);
			end
		end

		if ( #Tinom.addMsgFilters == 0 ) then
			Tinom.addMsgFilters = nil;
		end
	end
end

function Tinom.AddMessageFilter_AbbrChannelName( text )
    --local player, lineID, channelName, channelNum, playerName = string.match( text,"|Hplayer:(.-):(.-):(.-):(.-)|h%[(.-)%]|h")
    if (TinomDB.Options.Default.Tinom_Switch_MsgFilter_AbbrChannelName) then
        text = text:gsub( "%[(%d).-%]", "[%1]", 1 )
    end
    return text;
end

function Tinom.AddMessageFilter_AbbrAuthorName( text )
    --local player, lineID, channelName, channelNum, playerName = string.match( text,"|Hplayer:(.-):(.-):(.-):(.-)|h%[(.-)%]|h")
    if (TinomDB.Options.Default.Tinom_Switch_MsgFilter_AbbrAuthorName) then
        text = text:gsub( "%[|cff(%x%x%x%x%x%x)(.-)(%-%S%S%S).-|r%]", "[|cff%1%2%3|r]", 1 );
    end
    return text;
end

function Tinom.AddMessageFilter_AuthorAliasName( text )
    local fullName, authorName, authorServer = string.match( text,"|Hplayer:((.-)%-(.-)):")
    for k,v in pairs(TinomDB.filterDB.replaceName) do
        if ( authorName and (authorName == k) ) then
            if (v) then
                text = text:gsub(authorName,v,2);
                text = text:gsub(v,authorName,1);
                Tinom.ChatStat_Filtered("ReplaceName",authorName);
                return text;
            end
        elseif ( fullName and (fullName == k) ) then
            if (v) then
                text = text:gsub(authorName,v,2);
                text = text:gsub(v,authorName,1);
                Tinom.ChatStat_Filtered("ReplaceName",authorName);
                return text;
            end
        end
    end
    return text;
end

--[[-------------------------------------------------------------------------
--  频道过滤
-------------------------------------------------------------------------]]--
function Tinom.MsgFilter( self,event,... )
    if ( not TinomDB.Options.Default.Tinom_Switch_MsgFilter_MainEnable )then
        return false;
    end
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = ...;
    if not Tinom.CheckChannelLsit(self,arg9) then
        return false;
    end
    
    --if ( event ~= "CHAT_MSG_CHANNEL" ) then return end
    --local eventType = strsub(event, 10);
    if (not arg12) or (not arg12:find("Player")) then return; end
    local authorName, authorServer = arg2:match( "(.-)%-(.*)" )
    
    if authorName == playerName then
        --return false;
    end
    --  针对怀旧服--##--
    if not authorServer then
        authorName = arg2;
        authorServer = "server";
    end
    
    --  统计函数  --

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

function Tinom.CheckChannelLsit(self,arg9)
    for i,v in ipairs(self.channelList) do
        if arg9 == v then
            return true;
        end
    end
    return false;
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

function Tinom.MsgFilter_Whitelist(msg, authorName, authorServer, remind)
    assert(authorName and msg);
    
    for k,v in pairs(TinomDB.filterDB.whiteList) do
        if ( authorName == v ) then
            return false, nil, nil, remind;
        end
    end
    Tinom.ChatStat_Filtered("WhiteList",authorName);
    return true;
end

function Tinom.MsgFilter_WhitelistKeyword( msg, authorName, authorServer, remind)
    assert(authorName and msg);
    
    for _,keyword in pairs(TinomDB.filterDB.whiteListKeyword) do
        if msg:find(keyword) then
            return false, nil, nil, remind;
        end
    end
    Tinom.ChatStat_Filtered("WhiteListKeyword",authorName);
    return true;
end

function Tinom.MsgFilter_Blacklist( msg,authorName,authorServer, remind )
    assert(authorName);
    
        if (Tinom.CheckNameInTable(TinomDB.filterDB.blackList,authorName)) then
            Tinom.ChatStat_Filtered("BlackList",authorName);
            remind = nil;
            return true, nil, nil, remind;
        end
    return false, nil, nil, remind;
end

function Tinom.MsgFilter_BlacklistKeyword( msg,authorName,authorServer, remind )
    assert(authorName and msg);

    if not TinomDB.Options.Default.Tinom_Switch_MsgFilter_BlackKeywordCaseSensitive then
        msg = string.lower(msg);
    end
    for _,keyword in pairs(TinomDB.filterDB.blackListKeyword) do
        if not TinomDB.Options.Default.Tinom_Switch_MsgFilter_BlackKeywordCaseSensitive then
            keyword = string.lower(keyword);
        end
        if msg:find(keyword) then
            Tinom.ChatStat_Filtered("BlackListKeyword",authorName);
            return true, nil, nil, remind;
        end
    end
    return false, nil, nil, remind;
end

function Tinom.MsgFilter_SensitiveList( msg,authorName,authorServer, remind )
    for k,v in pairs(TinomDB.filterDB.whiteList) do
        if ( authorName == v ) then
            if (TinomDB.Options.Default.Tinom_Switch_MsgFilter_SensitiveListHighlight) then
                newArg1 = "|cffffff00"..msg.."|r"
            else
                newArg1 = msg;
            end
            Tinom.ChatStat_Filtered("SensitiveList",authorName);
            remind = "SensitiveList";
            ignore = "RightNow!";
            return ignore, newArg1, nil, remind;
        end
    end
    return false, nil, nil, remind;
end

function Tinom.MsgFilter_SensitiveKeyword( msg,authorName,authorServer, remind )
    for _,keyword in pairs(TinomDB.filterDB.sensitiveKeyword) do
        if msg:find(keyword) then
            if (TinomDB.Options.Default.Tinom_Switch_MsgFilter_SensitiveKeywordHighlight) then
                newArg1 = msg:gsub(keyword,"|cffffff00"..keyword.."|r")
            else
                newArg1 = msg;
            end
            Tinom.ChatStat_Filtered("SensitiveKeyword",authorName);
            remind = "SensitiveKeyword";
            ignore = "RightNow!";
            return ignore, newArg1, nil, remind;
        end
    end
    return false, nil, nil, remind;
end

function Tinom.MsgFilter_AutoBlackList( msg,authorName,authorServer, remind )
    assert(authorName);

    if (Tinom.CheckNameInTable(TinomDB.filterDB.autoBlackList,authorName)) then
        Tinom.ChatStat_Filtered("AutoBlackList",authorName);
        remind = nil;
        return true, nil, nil, remind;
    end
    return false, nil, nil, remind;
end

function Tinom.MsgFilter_RepeatMsg( msg,authorName,authorServer, remind )
    assert(authorName and msg and authorServer);

    local exist,elapsed = Tinom.MsgFilter_IsAuthorExist( authorName,authorServer );
    if exist and ((elapsed < TinomDB.Options.Default.Tinom_Value_MsgFilter_RepeatMsgElapsed)
        or (TinomDB.Options.Default.Tinom_Value_MsgFilter_RepeatMsgElapsed == 0)) then
        if TinomDB.chatStatDB[authorServer][authorName].msg_last_text == msg then
            Tinom.ChatStat_Filtered("RepeatMsg",authorName);
            return true, nil, nil, remind;
        end
    end
    return false, nil, nil, remind;
end

function Tinom.MsgFilter_IntervalMsg( msg,authorName,authorServer, remind )
    assert(authorName and authorServer);

    local exist, elapsed = Tinom.MsgFilter_IsAuthorExist( authorName,authorServer );
    if exist and ((elapsed < TinomDB.Options.Default.Tinom_Value_MsgFilter_IntervalMsgTime)
        or (TinomDB.Options.Default.Tinom_Value_MsgFilter_IntervalMsgTime == 0)) then
            Tinom.ChatStat_Filtered("IntervalMsg",authorName);
            return true, nil, nil, remind;
    end
    return false, nil, nil, remind;
end

function Tinom.MsgFilter_IsAuthorExist( authorName,authorServer )
    if TinomDB.chatStatDB[authorServer] then
        if TinomDB.chatStatDB[authorServer][authorName] then
            local elapsed = time() - TinomDB.chatStatDB[authorServer][authorName].msg_last_time;
            return true, elapsed;
        end
    end
    return false;
end

function Tinom.MsgFilter_FoldMsg( msg,authorName,authorServer, remind )
    if #msg<20 then
        return false, msg;
    end
    newMsg = msg:gsub("%s+","");
    local heatSample = newMsg:match("^......");
    heatSample = heatSample:gsub("(%p)","%%%1");
    local heatLength = newMsg:find(heatSample,#heatSample);

    if heatLength then
        local foldMsg = strsub(newMsg,1,heatLength-1);
        foldMsg = foldMsg:gsub("(%p)","%%%1");
        if newMsg:find(foldMsg,heatLength) then
            newMsg, num = newMsg:gsub(foldMsg,"");
            foldMsg = foldMsg:gsub("%%","");
            newArg1 = foldMsg..newMsg.." x"..num;
            Tinom.ChatStat_Filtered("FoldMsg",authorName);
            return false, newArg1;
        end
    end
    return false, msg, nil, remind;
end

-- function Tinom.MsgFilter_ReplaceName( msg,authorName,authorServer, remind )
--     local newMsg,newName;
--     local name = authorName.."-"..authorServer;

--     for k,v in pairs(TinomDB.filterDB.replaceName) do
--         if ( authorName == k ) then
--             if (v) then
--                 Tinom.ChatStat_Filtered("ReplaceName",authorName);
--                 newName = v.."-"..authorServer;
--                 return false, newMsg, newName, remind;
--             end
--         elseif ( name == k ) then
--             if (v) then
--                 Tinom.ChatStat_Filtered("ReplaceName",authorName);
--                 newName = v;
--                 return false, newMsg, newName, remind;
--             end
--         end
--     end
--     return false, newMsg, newName, remind;
-- end

function Tinom.MsgFilter_ReplaceNameMsg( msg,authorName,authorServer, remind )
    local newMsg,newName;
    local name = authorName.."-"..authorServer;

    for k,v in pairs(TinomDB.filterDB.replaceNameMsg) do
        if ( authorName == k ) then
            if (v) then
                Tinom.ChatStat_Filtered("ReplaceNameMsg",authorName);
                newMsg = v;
                return false, newMsg, newName, remind;
            end
        elseif ( name == k ) then
            if (v) then
                Tinom.ChatStat_Filtered("ReplaceNameMsg",authorName);
                newMsg = v;
                return false, newMsg, newName, remind;
            end
        end
    end
    return false, newMsg, newName, remind;
end

function Tinom.MsgFilter_ReplaceKeyword( msg,authorName,authorServer, remind )
    local newMsg = msg;
    for i=1,2 do
        for k,v in pairs(TinomDB.filterDB.replaceKeyword) do
            if (v) then
                newMsg = newMsg:gsub(k,v);
            end
        end
    end
    if newMsg~=msg then
        Tinom.ChatStat_Filtered("ReplaceKeyword",authorName);
    end
    return false, newMsg, nil, remind;
end

function Tinom.MsgFilter_ReplaceKeywordMsg( msg,authorName,authorServer, remind )
    local newMsg;
    for k,v in pairs(TinomDB.filterDB.replaceKeywordMsg) do
        if ( msg:find(k) ) then
            if (v) then
                Tinom.ChatStat_Filtered("ReplaceKeywordMsg",authorName);
                newMsg = v;
                return false, newMsg, nil, remind;
            end
        end
    end
    return false, nil, nil, remind;
end

function Tinom.Reminder( type )
    if not type then return; end

    if TinomDB.Options.Default[Tinom.ReminderType[type].switch] then
        PlaySound(TinomDB.Options.Default[Tinom.ReminderType[type].soundID]);
    end
end

--[[-------------------------------------------------------------------------
--  拾取过滤
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
