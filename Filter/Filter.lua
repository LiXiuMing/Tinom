--  临时表
TinomDB_filterDB_cacheMsgTemp = {};
TinomDB_filterDB_whiteListTemp = {};
TinomDB_filterDB_blackListTemp = {};

--  当前玩家名
local playerName = UnitName("player");

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
                text = text:gsub( "%[(%d)%..-%]", "%[%1%]" )
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
            if ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceName == true ) then
                newName = v.newName;
            end
            if ( ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceNameMsg == true ) and v.newMsg ) then
                newMsg = v.newMsg;
            end
            return newMsg, newName;
        elseif ( authorName == k ) then
            if ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceName == true ) then
                newName = v.newName..authorServer;
            end
            if ( ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceNameMsg == true ) and v.newMsg ) then
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
function Tinom.ReplaceMsg( msg )
    --Tdebug(self,"log","Tinom.ReplaceMsg.触发");
    local newMsg = nil;
    for k,v in pairs(TinomDB.filterDB.replaceKeyWord) do
        if ( msg:find(k) ) then
            if ( ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceKeyWordMsg == true ) and v.newMsg ) then
                newMsg = v.newMsg;
            else
                newMsg = msg:gsub(k,v.newWord);
            end
            return newMsg;
        end
    end
    return newMsg;
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
--  消息过滤函数:白名单开关,黑名单开关,白名单,临时白名单,黑名单,临时黑名单,
--              替换角色名开关,替换关键字开关 or (authorName == playerName)
-------------------------------------------------------------------------]]--
function Tinom.MsgFilter( self,event,... )
    --if ( event ~= "CHAT_MSG_CHANNEL" ) then return end
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = ...;
    local authorName, authorServer = arg2:match( "(.-)%-(.*)" )
    
    if ((TinomDB.Options.Default.Tinom_Switch_MsgFilter_MainEnable == false) )then
        --Tdebug(self,"log","Tinom.MsgFilter.Tinom_Switch_MsgFilter_MainEnable.触发");
        return false;
    end
    
    --  统计函数  --
    --统计函数
    
    --  白名单过滤  --
    if ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteList ) then
        for k,v in pairs(TinomDB.filterDB.whiteList) do
            if ( authorName == v ) then
                return false;
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
                return false;
            end
        end
    end

    --  白名单模式
    if ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_WhiteListOnly ) then
        return true;
    end

    --  黑名单过滤  --
    if ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_BlackList ) then
        for k,v in pairs(TinomDB.filterDB.blackList) do
            if ( authorName == v ) then
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
                return true;
            end
        end
    end

    --  历史20条信息内重复,不区分角色  --
    if ( TinomDB.Options.Default.Tinom_Switch_MsgFilter_CacheMsgRepeat ) then
        if ( Tinom.CacheMsgRepeat( self,event,arg1 ) ) then
            return true;
        end
    end

    --  替换功能  --也可以使用元表方法setmetatable(table1,table2)
    if ((TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceName) 
        or (TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceKeyWord)
        or (TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceNameMsg)
        or (TinomDB.Options.Default.Tinom_Switch_MsgFilter_ReplaceKeyWordMsg)
        ) then

        local newArg1, newArg2 = nil, nil;
        --Tdebug(self,"log","Tinom.MsgFilter.替换.触发");
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

        return false, newArg1, newArg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14; 
    else
        return false;
    end

end

--[[-------------------------------------------------------------------------
--  消息过滤函数:开
-------------------------------------------------------------------------]]--
function Tinom.MsgFilterOn()
    filterDB_Temp = TinomDB.filterDB;
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", Tinom.MsgFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", Tinom.MsgFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", Tinom.MsgFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", Tinom.MsgFilter)
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
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", Tinom.MsgFilter)
    print("过滤已关闭")
end


Tdebug(self,"log","Filter.lua加载完成");