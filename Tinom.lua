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
                whiteListKeyWord = {},
                blackList = {},
                blackListKeyWord = {},
                replaceName = {},
                replaceKeyWord = {
                    ["?+"] = {
                        newWord = "?",
                        newMsg = "",
                    },
                    ["++"] = {
                        newWord = "+",
                        newMsg = "",
                    },
                    ["M+"] = {
                        newWord = "M",
                        newMsg = "",
                    },
                    ["~+"] = {
                        newWord = "~",
                        newMsg = "",
                    },
                    ["？+"] = {
                        newWord = "_",
                        newMsg = "",
                    },
                    ["，+"] = {
                        newWord = "_",
                        newMsg = "",
                    },
                    ["。+"] = {
                        newWord = "_",
                        newMsg = "",
                    },
                    ["%b{}"] = {
                        newWord = "_",
                        newMsg = "这是大饼星星之类的图标,用不上可以删除.",
                    },
                },
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
        Tinom.classicCheak();
        Tinom.LoginLog(self,event,addonName);
        Tinom.OptionsMainPanel_checkOptions();
        Tinom.MsgFilterOn();
        Tinom.ChatStat_OnLoad();
        Tinom.ReplaceChannelName();

    end
end

--[[-------------------------------------------------------------------------
--  怀旧服检查:
-------------------------------------------------------------------------]]--
function Tinom.classicCheak()
    --  游戏版本
    local _,_,_,gameVersion = GetBuildInfo();
    
    --  角色名染色开关
    Tinom.Tinom_Switch_MsgFilter_ColorName = false;
    if ( gameVersion < 80205 ) then
        Tinom.Tinom_Switch_MsgFilter_Classic = true;
        Tdebug(self,"log","检测到怀旧版");
    end
    -- --	脏话过滤
    -- Tinom.profanityFilter = GetCVarInfo("profanityFilter")
    -- if Tinom.profanityFilter == "1" then
    --     print("脏话过滤已开")
    --     SetCVar("profanityFilter",0);
    -- else
    --     print("脏话过滤未开")
    -- end
    -- --  角色名染色
    -- Tinom.colorChatNamesByClass = GetCVarInfo("colorChatNamesByClass")
    -- if Tinom.colorChatNamesByClass == "1" then
    --     print("角色名染色已开")
    -- else
    --     print("角色名染色未开")
    --     SetCVar("colorChatNamesByClass",1);
    -- end
    
    -- --  模型河蟹
    -- Tinom.overrideArchive = GetCVarInfo("overrideArchive")
    -- if Tinom.overrideArchive == "1" then
    --     print("模型河蟹已开")
    --     SetCVar("overrideArchive",0);
    -- else
    --     print("模型河蟹未开")
    -- end
end
Tdebug(self,"log","Tinom.lua.OnLoaded");