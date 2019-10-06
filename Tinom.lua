Tdebug(self,"log","Tinom.lua加载开始");
--  获取插件的插件名和插件表
--local addonName, addon = ...

--  模块化封装
Tinom = {};

--  当前玩家名
local playerName = UnitName("player");

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
                replaceKeyWord = {},
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
        Tdebug(self,"log","Tinom.OnLoaded.插件加载完成.");
        Tinom.LoginLog(self,event,addonName);
        Tinom.OptionsMainPanel_checkOptions();
        Tinom.MsgFilterOn();
        Tinom.ChatStat_OnLoad();

        --Tinom.OptionsMainPanel_OnLoad(self,...);
    end
end

Tdebug(self,"log","Tinom.lua加载完成");