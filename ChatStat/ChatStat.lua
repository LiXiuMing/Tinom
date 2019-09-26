--Chat Statistics
--聊天统计模块
--功能:统计角色频道发言,重复发言,广告等信息.

--测试开关:测试时处理自己的发言,反之则不处理自己的发言.
local IsTest = true;

--数据库默认结构
--local Chat_Stat_Defaults = {};
--local filterDB_Defaults = {};

--普通发言处理函数
local function auto_chat( channel, authorname, msg_count )
    local write_back = format("==玩家:[%s]已累计发言[%s]次==",authorname,msg_count)
    if ((msg_count / 10) > 0) and ((msg_count % 10) == 0 ) then
        write_back = write_back.."荣获{我想和你聊天}成就";
        DEFAULT_CHAT_FRAME:AddMessage(write_back, 1.0, 1.0, 0.0)
        SendChatMessage(write_back,"CHANNEL",nil,channel);
    else
        DEFAULT_CHAT_FRAME:AddMessage(write_back, 0.5, 0.5, 0.5)
    end
end

--重复发言处理函数,spammer(垃圾邮件制造者)
local function auto_chat_spammer( channel, authorname, msg_repeat_times, elapsed )
    if ((msg_repeat_times / 10) > 0) and ((msg_repeat_times % 10) == 0 ) then
        local write_back = format("==玩家:[%s]已重复发言[%s]次==",authorname,msg_repeat_times)
        write_back = write_back.."荣获{广告入门}成就";
        DEFAULT_CHAT_FRAME:AddMessage(write_back, 1.0, 0.0, 0.0)
        SendChatMessage(write_back,"CHANNEL",nil,channel);
        return true
    else
        local write_back = format("==玩家:[%s]已重复发言[%s]次,距上次发言[%s]==",authorname,msg_repeat_times, elapsed)
        DEFAULT_CHAT_FRAME:AddMessage(write_back, 1.0, 0.0, 0.0)
    end
end

--事件触发处理函数
local function chat_stat_handler(self, event, msg, author,_,_,_,_,_,channelIndex,_,_,lineID, guid,...)
    local authorname, authorserver = author:match( "(.-)%-(.*)" )
    --判断是否是本人,是否非测试模式,如果全部满足则跳出.
    if authorname == UnitName("player") and IsTest == false then
        return
    end

    -- 初始化服务器信息
    if characterDB[authorserver] == nil then
        characterDB[format(authorserver)] = {}
        print("==初始化服务器信息==")
    end

    -- 初始化角色信息
    local authornameDB_read = characterDB[authorserver][authorname]
    local authornameDB_write = characterDB[format(authorserver)][format(authorname)]
    if authornameDB_read == nil then
        --初始化角色信息
        characterDB[format(authorserver)][format(authorname)] = {
            msg_count = 1;          --发言次数
            msg_last_text = msg;    --上次发言内容
            msg_last_time = time(); --上次发言时间
            msg_repeat_times = 0;   --发言重复次数
            author_guid = guid;     --角色唯一标识
        }
        print(format("==初始化角色%s信息==",authorname))
    elseif authornameDB_read.msg_last_text == msg then
        --重复发言判断
        --计算与上次发言的时间差
        local elapsed = time() - authornameDB_read.msg_last_time
        authornameDB_write.msg_repeat_times = authornameDB_write.msg_repeat_times + 1;
        authornameDB_write.msg_count = authornameDB_read.msg_count + 1;
        authornameDB_write.msg_last_time = time();
        --广告发言函数:如果返回值为true则将角色加入过滤列表.
        spammer = auto_chat_spammer( channelIndex, authorname, authornameDB_read.msg_repeat_times, SecondsToTime(elapsed) );
        if spammer then
            filterDB[format(authorname)] = guid;
        end
    else
        --正常发言
        authornameDB_write.msg_last_text = msg;
        authornameDB_write.msg_count = authornameDB_read.msg_count + 1;
        authornameDB_write.msg_last_time = time();
        --嘴炮发言函数
        auto_chat( channelIndex, authorname, authornameDB_read.msg_count );
    end
end

--数据库初始化函数
local function initializer_DB(...)
    if ( characterDB == nil ) then
        characterDB = {};
        print("==未发现角色数据库,已初始化角色数据库==")
    end
    if ( filterDB == nil ) then
        filterDB = {};
        print("==未发现过滤列表,已初始化过滤列表==")
    end
    if ( characterDB ~= nil ) and (filterDB ~= nil ) then
            --注册聊天统计函数触发事件
            local chat_stat_frame = CreateFrame("Frame")
            chat_stat_frame:RegisterEvent("CHAT_MSG_CHANNEL")
            chat_stat_frame:SetScript("OnEvent", chat_stat_handler)
        return true
    else
        print("!!!!数据库初始化失败!!!!!")
    end
end

--  入口,注册初始化触发事件
function chat_start(self)
    self:RegisterEvent("ADDON_LOADED")
    self:SetScript("OnEvent",function(self,event,addon)
        print(self,event,addon)
        if (addon == "Tinom") then
            --因为会有多个插件同时触发,所以要匹配插件名,不然会重复动作.
            --Tinom,Blizzard_TimeManager,Blizzard_CombatLog
            --若加载插件名匹配则启动初始化函数
            initializer_DB();
        end
    end)
end

local function chat_Test( ... )
    local arg = ...
    if arg~="" then
        print(format("呱唧%s",arg))
    else
        print("啥?")
    end
end

SLASH_CHATSTAT1 = "/chatstat"
SLASH_CHATSTAT2 = "/chs"
SlashCmdList["CHATSTAT"] = chat_Test;