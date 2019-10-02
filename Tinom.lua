--  模块化封装
Tinom = {};

Tinom_Switch_MsgFilter_ReplaceName = false;
Tinom_Switch_MsgFilter_ReplaceKeyWord = false;
Tinom_Switch_MsgFilter_ReplaceNameMsg = false;
Tinom_Switch_MsgFilter_ReplaceKeyWordMsg = false;

Tinom_Switch_MsgFilter_WhiteList = false;
Tinom_Switch_MsgFilter_BlackList = false;
Tinom_Switch_MsgFilter_WhiteListKeyWord = false;
Tinom_Switch_MsgFilter_BlackListKeyWord = false;

Tinom_Switch_MsgFilter_CacheMsgRepeat = false;
Tinom_Switch_MsgFilter_WhiteListOnly = false;

TinomDB_filterDB_cacheMsgTemp = {};
TinomDB_filterDB_whiteListTemp = {};
TinomDB_filterDB_blackListTemp = {};



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
    local authorName, authorServer = name:match( "(.-)(%-.*)" );
    local newName,newMsg = nil, nil;

    for k,v in pairs(TinomDB.filterDB.replaceName) do
        if ( name == k ) then
            newName = v.newName;
            if ( ( Tinom_Switch_MsgFilter_ReplaceNameMsg == true ) and v.newMsg ) then
                newMsg = v.newMsg;
            end
            return newMsg, newName;
        elseif ( authorName == k ) then
            newName = v.newName..authorServer;
            if ( ( Tinom_Switch_MsgFilter_ReplaceNameMsg == true ) and v.newMsg ) then
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
    local newMsg = nil;
    for k,v in pairs(TinomDB.filterDB.replaceKeyWord) do
        if ( msg:find(k) ) then
            if ( ( Tinom_Switch_MsgFilter_ReplaceKeyWordMsg == true ) and v.newMsg ) then
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
function Tinom.CacheMsgRepeat( msg )
    for i=1,20 do
        if ( msg == TinomDB_filterDB_cacheMsgTemp[i] ) then
            return true;
        else
            table.insert( TinomDB_filterDB_cacheMsgTemp, i, msg )
        end
    end
    return false;
end

--[[-------------------------------------------------------------------------
--  消息过滤函数:白名单开关,黑名单开关,白名单,临时白名单,黑名单,临时黑名单,
--              替换角色名开关,替换关键字开关
-------------------------------------------------------------------------]]--
function Tinom.MsgFilter( self,event,... )
    --[[ if ((Filter_Switch == false) or (arg2 == UnitName("player"))) then
        return;
    end ]]

    if ( event ~= "CHAT_MSG_CHANNEL" ) then return end
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = ...;
    local authorName, authorServer = arg2:match( "(.-)%-(.*)" )

    --  统计函数  --
    --统计函数
    
    --  白名单过滤  --
    if ( Tinom_Switch_MsgFilter_WhiteList ) then
        if ( TinomDB.filterDB.whiteList[authorName] or TinomDB_filterDB_whiteListTemp[authorName] ) then
            return false;
        end
    end

    --  关键字白名单  --
    if ( Tinom_Switch_MsgFilter_WhiteListKeyWord ) then
        for _,v in pairs(TinomDB.filterDB.whiteListKeyWord) do
            if arg1:find(v) then
                return false;
            end
        end
    end

    --白名单模式
    if ( Tinom_Switch_MsgFilter_WhiteListOnly ) then
        return true;
    end

    --  历史20条信息内重复,不区分角色  --
    if ( Tinom_Switch_MsgFilter_CacheMsgRepeat ) then
        if ( Tinom.CacheMsgRepeat( arg1 ) ) then
            return true;
        end
    end

    --  黑名单过滤  --
    if ( Tinom_Switch_MsgFilter_BlackList ) then
        if ( TinomDB.filterDB.blackList[authorName] or TinomDB_filterDB_blackListTemp[authorName]) then
            return true;
        end
    end
    
    --  关键字黑名单过滤  --
    if ( Tinom_Switch_MsgFilter_BlackListKeyWord ) then
        for _,v in pairs(TinomDB.filterDB.blackListKeyWord) do
            if arg1:find(v) then
                return true;
            end
        end
    end


    --  替换功能  --也可以使用元表方法setmetatable(table1,table2)
    if ((Tinom_Switch_MsgFilter_ReplaceName) or (Tinom_Switch_MsgFilter_ReplaceKeyWord)) then
        local newArg1, newArg2 = nil, nil;

        if (Tinom_Switch_MsgFilter_ReplaceName) then
            newArg1, newArg2 = Tinom.ReplaceName( arg2 );
        end

        if ((Tinom_Switch_MsgFilter_ReplaceKeyWord) and (newArg1 == nil)) then
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
function Tinom.MsgFilterOn( )
    filterDB_Temp = filterDB;
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", Tinom.MsgFilter)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", Tinom.MsgFilter)
    --ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", Tinom.MsgFilter)
    --ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", Tinom.MsgFilter)
    print("开启过滤")
end

--[[-------------------------------------------------------------------------
--  消息过滤函数:关
-------------------------------------------------------------------------]]--
function Tinom.MsgFilterOff( )
    filterDB_Temp = {};
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", Tinom.MsgFilter)
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SAY", Tinom.MsgFilter)
    --ChatFrame_RemoveMessageEventFilter("CHAT_MSG_YELL", Tinom.MsgFilter)
    --ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", Tinom.MsgFilter)
    print("关闭过滤")
end