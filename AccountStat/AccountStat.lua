--[[-------------------------------------------------------------------------
--
--  Tinom Account Stat
--  账户角色统计模块
--
--  功能:统计角色信息,待开发
--
-------------------------------------------------------------------------]]--

--[[-------------------------------------------------------------------------
--  角色登陆次数统计
-------------------------------------------------------------------------]]--
local playerName = UnitName("player");

function Tinom.LoginLog(self, event, addonName)
    if ( TinomDB.accountDB == nil ) then
        TinomDB.accountDB = {};
        Tdebug(self,"log","LoginLog.accountDB.Initialize");
    end
    local accountDB_Temp = TinomDB.accountDB;

    if ((event == "ADDON_LOADED") and (addonName == "Tinom")) then
        if (accountDB_Temp[playerName] == nil) then
            --此处需要格式化角色名,不然会导致覆盖而不是添加.
            accountDB_Temp[playerName] = {times=1,lastTime=0,}; --##--删掉了format()
			print("你好:"..playerName.." 初次见面,请多多关照.");
            Tdebug(self,"log","LoginLog.CreateCharacter:"..playerName);
        else
            accountDB_Temp[playerName].times = accountDB_Temp[playerName].times + 1;
            local elapsed = time() - accountDB_Temp[playerName].lastTime;
            print("你好 "..playerName .. " \n这是我们第".. accountDB_Temp[playerName].times .."次相见.\n距离你上次登出的时间是" .. SecondsToTime(elapsed));
            Tdebug(self,"log","LoginLog.RecordCharacter:"..playerName);
        end
    elseif (event == "PLAYER_LEAVING_WORLD")then
        accountDB_Temp[playerName].lastTime = time();
        TinomDB.accountDB = accountDB_Temp;
        Tdebug(self,"log","LoginLog.SaveCharacter:"..playerName);

        TinomDB.playerDB = {};--##--统计功能完善前发布版先别保存用户数据,防止无休止增长.
        TinomDB.chatStatDB = {};--##--统计功能完善前发布版先别保存用户数据,防止无休止增长.
        Tdebug(self,"log","ClearDB:chatStatDB;playerDB");
    end
end

Tdebug(self,"log","AccountStat.lua.OnLoaded");

-- SLASH_HAVEWEMET1 = "/hwm"
-- SlashCmdList["HAVEWEMET"] = function(arg1)
--     if #arg1 == 0 then
--         print("这个角色一共登陆过 " .. TinomDB.accountDB[playerName].times .. " 次.");
--     elseif arg1 == "rm" then
--         table.remove( TinomDB.accountDB );
--     elseif arg1 == "show" then
--         for k,v in pairs(TinomDB.accountDB[playerName]) do
--             print(k,v);
--         end
--     end
-- end
