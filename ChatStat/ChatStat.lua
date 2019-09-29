--[[-------------------------------------------------------------------------
--
--  Chat Statistics
--  聊天统计模块
--
--  功能:统计角色频道发言,重复发言,广告等信息.
--
-------------------------------------------------------------------------]]--

--测试开关:测试时处理自己的发言,反之则不处理自己的发言.
local IsTest = true;

--[[-------------------------------------------------------------------------
--  信息展示开关,
-------------------------------------------------------------------------]]--
Chat_Switch = {
    Normal =        true,
    Normal_A =      true,
    Spammer =       true,
    Spammer_A =     true,
}

--数据库默认结构
--local Chat_Stat_Defaults = {};
--local filterDB_Defaults = {};

--  成就变量
local Achievement_Normal = {"侃侃而谈","论今评古","入门问讳","软言细语","谈词如云","谈吐风生","白费口舌","笨嘴笨舌","不言不语","钝口拙腮","娇声娇气","缄口不言","口干舌燥","伶牙俐齿","唠唠叨叨","能言善辩"};
local Achievement_Spammer = {"喃喃自语","半吞半吐","不动声色","不讳之门","沉静寡言","尺水丈波","出口成章","喋喋不休","对牛弹琴","隔墙有耳","拐弯抹角","祸从口出","尖酸刻薄"};

--[[-------------------------------------------------------------------------
--  成就返回函数
-------------------------------------------------------------------------]]--
local function chat_Achievement(...)
    local attribute, chat_level = ...
    if (attribute == "Normal") then
        --正常发言成就
        if (chat_level > #Achievement_Normal) then
            return ""
        else
            return format(",荣获[%s]成就",Achievement_Normal[chat_level])
        end
    elseif (attribute == "Spammer") then
        --重复发言成就
        if (chat_level > #Achievement_Spammer) then
            return ""
        else
            return format(",荣获[%s]成就",Achievement_Spammer[chat_level])
        end
    else
        return ""
    end
end

--[[-------------------------------------------------------------------------
--  播放声音函数
-------------------------------------------------------------------------]]--
local function playsound( arg )
    PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
end

--[[-------------------------------------------------------------------------
--  重复发言处理函数,spammer(垃圾邮件制造者)
-------------------------------------------------------------------------]]--
local function chat_send( ... )
    local attribute, write_msg, _, _, channel = ...
    --SendChatMessage(write_msg,"CHANNEL",nil,channel);
    --SendChatMessage(write_msg,"PARTY",nil);
    if ( (Chat_Switch["Normal"] == true) and (attribute == "Normal") ) then
        DEFAULT_CHAT_FRAME:AddMessage(write_msg, 0.5, 0.5, 0.5)
        PlaySound(7994)
    elseif ( (Chat_Switch["Normal_A"] == true) and (attribute == "Normal_A") ) then
        DEFAULT_CHAT_FRAME:AddMessage(write_msg, 1.0, 1.0, 0.0)
    elseif ( (Chat_Switch["Spammer"] == true) and (attribute == "Spammer") ) then
        DEFAULT_CHAT_FRAME:AddMessage(write_msg, 1.0, 0.0, 0.0)
    elseif ( (Chat_Switch["Spammer_A"] == true) and (attribute == "Spammer_A") ) then
        DEFAULT_CHAT_FRAME:AddMessage(write_msg, 1.0, 0.5, 0.0)
    end
end

--[[-------------------------------------------------------------------------
--  普通发言处理函数
-------------------------------------------------------------------------]]--
local function chat_normal( channel, authorname, msg_count )
    local write_msg = format("==玩家:[%s]已累计发言[%s]次==",authorname,msg_count)
    local chat_level = msg_count / 10;

    if ( chat_level > 0) and ((msg_count % 10) == 0 ) then
        write_msg = write_msg..chat_Achievement("Normal",chat_level);
        chat_send("Normal_A",write_msg,"CHANNEL",nil,channel);
    else
        chat_send("Normal",write_msg,"CHANNEL",nil,channel);
    end
end

--[[-------------------------------------------------------------------------
--  重复发言处理函数,spammer(垃圾邮件制造者)
-------------------------------------------------------------------------]]--
local function chat_spammer( channel, authorname, msg_repeat_times, elapsed )
    elapsed = elapsed:gsub("|4.-%:","")
    local write_msg = format("==玩家:[%s]已重复发言[%s]次,距上次发言[%s]==",authorname,msg_repeat_times, elapsed)
    local chat_level = msg_repeat_times / 10;

    if ( chat_level > 0) and ((msg_repeat_times % 10) == 0 ) then
        write_msg = write_msg..chat_Achievement("Spammer",chat_level);
        chat_send("Spammer_A",write_msg,"CHANNEL",nil,channel);
        return true
    else
        chat_send("Spammer",write_msg,"CHANNEL",nil,channel);
    end
end

--[[-------------------------------------------------------------------------
--  事件触发处理函数
-------------------------------------------------------------------------]]--
local function chat_stat_handler(self, event, msg, author,_,_,_,_,_,channelIndex,_,_,lineID, guid,...)
    local authorname, authorserver = author:match( "(.-)%-(.*)" )
    local ignore = false
    --判断是否是本人,是否非测试模式,如果全部满足则跳出.
    if authorname == UnitName("player") and IsTest == false then
        return;
    end



    -- 初始化服务器信息
    if characterDB[authorserver] == nil then
        characterDB[format(authorserver)] = {}
        print("==初始化服务器信息==")
    end

    -- 初始化角色信息
    local _, Class, _, Race, Sex  = GetPlayerInfoByGUID(guid)
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
            author_Class = Class;   --角色职业
            author_Race = Race;     --角色种族
            author_Sex = Sex;       --角色性别
        }
        print(format("==初始化角色%s信息==",authorname))
        PlaySound(120)
    elseif authornameDB_read.msg_last_text == msg then
        --重复发言判断
        --计算与上次发言的时间差
        local elapsed = time() - authornameDB_read.msg_last_time
        authornameDB_write.msg_repeat_times = authornameDB_write.msg_repeat_times + 1;
        authornameDB_write.msg_count = authornameDB_read.msg_count + 1;
        authornameDB_write.msg_last_time = time();
        --广告发言函数:如果返回值为true则将角色加入过滤列表.
        PlaySound(10590)
        spammer = chat_spammer( channelIndex, authorname, authornameDB_read.msg_repeat_times, SecondsToTime(elapsed) );
        if spammer then
            filterDB[format(authorname)] = guid;
        end
    else
        --正常发言
        authornameDB_write.msg_last_text = msg;
        authornameDB_write.msg_count = authornameDB_read.msg_count + 1;
        authornameDB_write.msg_last_time = time();
        --嘴炮发言函数
        chat_normal( channelIndex, authorname, authornameDB_read.msg_count );
    end
    --return ignore,msg, author,_,_,_,_,_,channelIndex,_,_,lineID, guid,...
end

--[[-------------------------------------------------------------------------
--  数据库初始化函数
-------------------------------------------------------------------------]]--
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

--[[-------------------------------------------------------------------------
--  入口,注册初始化触发事件
-------------------------------------------------------------------------]]--
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