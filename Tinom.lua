--[[-------------------------------------------------------------------------
--
--  Tinom Main Frame
--  主框架
--
--  功能:初始化与索引
--
-------------------------------------------------------------------------]]--
--  获取插件的插件名和插件表
--local addonName, addon = ...

--  模块化封装
Tinom = {};
--  游戏版本
_,_,_,Tinom.gameVersion = GetBuildInfo();

--[[-------------------------------------------------------------------------
--  本地化函数
-------------------------------------------------------------------------]]--
Tinom.newLocale = {}
Tinom.L = setmetatable(TinomLocale, {
    __index = function(_, key)
        Tdebug(self,"log","zhCN.lua.未翻译字符串:"..key);
        Tinom.newLocale[key] = key;
        return key;
    end
})

--[[-------------------------------------------------------------------------
--  初始化数据库:
-------------------------------------------------------------------------]]--
function Tinom.checkTinomDB()
    if ( TinomDB == nil ) then
        Tdebug(self,"error","checkTinomDB.未发现数据库");
        TinomDB = {
            chatStatDB = {},
            playerDB = {},
            accountDB = {},
            Options = {},
            filterDB = {
                whiteList = {},
                whiteListKeyword = {},
                blackList = {},
                autoBlackList = {},
                blackListKeyword = {},
                sensitiveList = {},
                sensitiveKeyword = {},
                replaceName = {},
                replaceNameMsg = {},
                replaceKeyword = {
                    ["%?%?+"] = "?",
                    ["%++"] = "+",
                    ["MM?"] = "M",
                    ["~~?"] = "~",
                    ["··?"] = ".",
                    ["？"] = "?",
                    ["，"] = ",",
                    ["。"] = ".",
                    ["%b{}"] = "_",
                },
                replaceKeywordMsg = {},
            },
        };
        if ( TinomDB.filterDB ) then
            Tdebug(self,"log","checkTinomDB.数据库已初始化");
            return true;
        end
        Tdebug(self,"error","checkTinomDB.数据库初始化失败");
        return false;
    end
    Tdebug(self,"log","checkTinomDB.数据库检查完成");
    return true;
end

--[[-------------------------------------------------------------------------
--  插件加载完成:
-------------------------------------------------------------------------]]--
function Tinom.OnLoaded(self,event,addonName)
    if (event == "ADDON_LOADED") and (addonName == "Tinom") and (Tinom.checkTinomDB()) then
        Tdebug(self,"log","Tinom.OnLoaded");
        Tinom.Check();
        Tinom.classicCheak();
        Tinom.LoginLog(self,event,addonName);
        Tinom.OptionsMainPanel_checkOptions();
        Tinom.MsgFilterOn();
        Tinom.ChatStat_OnLoad();
        Tinom.ReplaceChannelName();
    end
end

--  怀旧服检查:
function Tinom.classicCheak()
    Tinom.Tinom_Switch_MsgFilter_Classic = false;
    if ( Tinom.gameVersion < 80205 ) then
        Tinom.Tinom_Switch_MsgFilter_Classic = true;
        Tdebug(self,"log","检测到怀旧版");
    end
end

function Tinom.Check()
    Tinom.Updata_A();
    --	脏话过滤
    Tinom.profanityFilter = GetCVarInfo("profanityFilter")
    if Tinom.profanityFilter == "1" then
        print("脏话过滤已开")
        SetCVar("profanityFilter",0);
    else
        print("脏话过滤未开")
    end
    --  角色名染色
    Tinom.chatClassColorOverride = GetCVarInfo("chatClassColorOverride")
    if Tinom.chatClassColorOverride == "0" then
        print("角色名染色已开")
    else
        print("角色名染色未开")
        SetCVar("chatClassColorOverride",0);
    end
    
    --  模型河蟹
    Tinom.overrideArchive = GetCVarInfo("overrideArchive")
    if Tinom.overrideArchive == "1" then
        print("模型河蟹已开")
        SetCVar("overrideArchive",0);
    else
        print("模型河蟹未开")
    end
end

function Tinom.Updata_A()
    if TinomDB.UpDataDate and TinomDB.UpDataDate >= 20191022 then
        return;
    end
    if TinomDB.filterDB.replaceKeyword and (not TinomDB.filterDB.replaceKeywordMsg) then
        TinomDB.filterDB.replaceKeywordMsg = {};
        local tableTemp = TinomDB.filterDB.replaceKeyword;
        TinomDB.filterDB.replaceKeyword = {};
        for k,v in pairs(tableTemp) do
            TinomDB.filterDB.replaceKeyword[k] = v.newWord;
            TinomDB.filterDB.replaceKeywordMsg[k] = v.newMsg;
        end
    end
    if TinomDB.filterDB.replaceName and (not TinomDB.filterDB.replaceNameMsg) then
        TinomDB.filterDB.replaceNameMsg = {};
        local tableTemp = TinomDB.filterDB.replaceName;
        TinomDB.filterDB.replaceName = {};
        for k,v in pairs(tableTemp) do
            TinomDB.filterDB.replaceName[k] = v.newName;
            TinomDB.filterDB.replaceName[k] = v.newMsg;
        end
    end
    TinomDB.UpDataDate = 20191022;
end