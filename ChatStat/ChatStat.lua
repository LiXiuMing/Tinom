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

ChatStat_FilteredList = {
    WhiteList = {0,},
    WhiteListKeyword = {0,},
    BlackList = {0,},
    BlackListKeyword = {0,},
    ReplaceName = {0,},
    ReplaceNameMsg = {0,},
    ReplaceKeyword = {0,},
    ReplaceKeywordMsg = {0,},
    RepeatMsg = {0,},
    SensitiveList = {0,},
    SensitiveKeyword = {0,},
    AutoBlackList = {0,},
    FoldMsg = {0,},
    IntervalMsg = {0,},
};

--  成就变量
local Achievement_Normal = {
    "侃侃而谈","论今评古","入门问讳","软言细语",
    "谈词如云","谈吐风生","白费口舌","笨嘴笨舌",
    "不言不语","钝口拙腮","娇声娇气","缄口不言",
    "口干舌燥","伶牙俐齿","唠唠叨叨","能言善辩",
};

local Achievement_Spammer = {
    "喃喃自语","半吞半吐","不动声色","不讳之门",
    "沉静寡言","尺水丈波","出口成章","喋喋不休",
    "对牛弹琴","隔墙有耳","拐弯抹角","祸从口出",
    "尖酸刻薄",
};

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
    if true then
        return;
    end
    if ( (Chat_Switch["Normal"] == true) and (attribute == "Normal") ) then
        DEFAULT_CHAT_FRAME:AddMessage(write_msg, 0.5, 0.5, 0.5)
        PlaySound(7994)
    elseif ( (Chat_Switch["Normal_A"] == true) and (attribute == "Normal_A") ) then
        DEFAULT_CHAT_FRAME:AddMessage(write_msg, 1.0, 1.0, 0.0)
    elseif ( (Chat_Switch["Spammer"] == true) and (attribute == "Spammer") ) then
        PlaySound(10590)
        DEFAULT_CHAT_FRAME:AddMessage(write_msg, 1.0, 0.0, 0.0)
    elseif ( (Chat_Switch["Spammer_A"] == true) and (attribute == "Spammer_A") ) then
        DEFAULT_CHAT_FRAME:AddMessage(write_msg, 1.0, 0.5, 0.0)
    end
end

--[[-------------------------------------------------------------------------
--  普通发言处理函数
-------------------------------------------------------------------------]]--
local function chat_normal( channel, authorName, msg_count )
    local write_msg = format("==玩家:[%s]已累计发言[%s]次==",authorName,msg_count)
    local chat_level = msg_count / 10;

    if ( chat_level > 0) and ((msg_count % 10) == 0 ) then
        write_msg = write_msg..chat_Achievement("Normal",chat_level);
        chat_send("Normal_A",write_msg,"CHANNEL",nil,channel);
    else
        chat_send("Normal",write_msg,"CHANNEL",nil,channel);
    end
end

--[[-------------------------------------------------------------------------
--  重复发言处理函数,spammer(垃圾邮件制造者)and (not TinomDB.filterDB.blackList[authorName] )
-------------------------------------------------------------------------]]--
local function chat_spammer( channel, authorName, msg_repeat_times, elapsed )
    elapsed = elapsed:gsub("|4.-%:","")
    local write_msg = format("==玩家:[%s]已重复发言[%s]次,距上次发言[%s]==",authorName,msg_repeat_times, elapsed)
    local chat_level = msg_repeat_times / 10;

    if ( chat_level > 0) and ((msg_repeat_times % 10) == 0 ) then
        write_msg = write_msg..chat_Achievement("Spammer",chat_level);
        chat_send("Spammer_A",write_msg,"CHANNEL",nil,channel);
        if Tinom.CheckNameInTable(TinomDB.filterDB.autoBlackList,authorName) then
            return false;
        end
        return true;
    else
        chat_send("Spammer",write_msg,"CHANNEL",nil,channel);
    end
end

--[[-------------------------------------------------------------------------
--  事件触发处理函数
-------------------------------------------------------------------------]]--
local function chat_stat_handler(self, event, msg, author,_,_,_,_,_,channelIndex,_,_,lineID, guid,...)
    local authorName, authorServer = author:match( "(.-)%-(.*)" )
    if (not guid) or (not guid:find("Player")) then
        return;
    end

    if not authorServer then
        authorName = author;
        authorServer = "server";
    end

    local ignore = false

    if Tinom.IsMe(authorName) and IsTest == false then
        return;
    end

    if TinomDB.chatStatDB[authorServer] == nil then
        TinomDB.chatStatDB[authorServer] = {}
        Tdebug(self,"log","==初始化服务器信息==")
    end

    -- 初始化角色信息
    local _, Class, _, Race, Sex  = GetPlayerInfoByGUID(guid)
    local authorNameDB_read = TinomDB.chatStatDB[authorServer][authorName]
    local authorNameDB_write = TinomDB.chatStatDB[format(authorServer)][format(authorName)]
    if authorNameDB_read == nil then

        TinomDB.chatStatDB[authorServer][authorName] = {
            msg_count = 1;
            msg_last_text = msg;
            msg_last_time = time();
            msg_repeat_times = 0;
        }

        TinomDB.playerDB[guid] = {
            name = authorName;
            class = Class;
            race = Race;
            sex = Sex;
        };

    elseif authorNameDB_read.msg_last_text == msg then
        --重复发言判断
        local elapsed = time() - authorNameDB_read.msg_last_time
        authorNameDB_write.msg_repeat_times = authorNameDB_write.msg_repeat_times + 1;
        authorNameDB_write.msg_count = authorNameDB_read.msg_count + 1;
        authorNameDB_write.msg_last_time = time();

        spammer = chat_spammer( channelIndex, authorName, authorNameDB_read.msg_repeat_times, SecondsToTime(elapsed) );
        if spammer and TinomDB.Options.Default.Tinom_Switch_MsgFilter_AutoBlackList then
            Tinom.AddAuthorToTable(TinomDB.filterDB.autoBlackList,authorName);
            Tdebug(self,"log","AutoBlackList"..authorName..":"..msg);
        end
    else
        --正常发言
        authorNameDB_write.msg_last_text = msg;
        authorNameDB_write.msg_count = authorNameDB_read.msg_count + 1;
        authorNameDB_write.msg_last_time = time();
        chat_normal( channelIndex, authorName, authorNameDB_read.msg_count );
    end

    -- 统计模块更新数据ChatStat_FilteredList
    if TinomChatStatFrame:IsShown() then
        TinomChatStatFrameMsgNum:SetText(lineID);
        local index = 1;
        for p,v in pairs(TinomDB.Options.Default.Tinom_Value_MsgFilter_FiltersList) do
            local filterName = v[3];
            filterName = Tinom.defaultCheckButtonsName[filterName]
            local number = ":|cffff0000"..ChatStat_FilteredList[v[3]][1].."|r";
            local authorName = (ChatStat_FilteredList[v[3]][2]) or ""
            local str = filterName..number..authorName;
            TinomChatStatFrame.Texts[index]:SetText(str)
            index = index + 1;
        end
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
        --PlaySoundFile("Interface/Addons/Tinom/Media/di.ogg","SFX")
    end
end

--[[-------------------------------------------------------------------------
--  数据库初始化函数
-------------------------------------------------------------------------]]--
local function initializer_DB(...)
    if ( TinomDB.chatStatDB ~= nil ) and (TinomDB.filterDB ~= nil ) then
        local chat_stat_frame = CreateFrame("Frame")
        chat_stat_frame:RegisterEvent("CHAT_MSG_CHANNEL")
        chat_stat_frame:SetScript("OnEvent", chat_stat_handler)
        return true
    else
        Tdebug(self,"error","!!!!数据库初始化失败!!!!!")
    end
end

--[[-------------------------------------------------------------------------
--  过滤器过滤次数统计
-------------------------------------------------------------------------]]--
function Tinom.ChatStat_Filtered(filterName,authorName)
    ChatStat_FilteredList[filterName][1] = ChatStat_FilteredList[filterName][1] + 1;
    ChatStat_FilteredList[filterName][2] = authorName;
end

--[[-------------------------------------------------------------------------
--  入口,注册初始化触发事件
-------------------------------------------------------------------------]]--
function Tinom.ChatStat_OnLoad()
    initializer_DB();
end