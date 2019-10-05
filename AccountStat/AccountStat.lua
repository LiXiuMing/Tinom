Tdebug(self,"log","AccountStat.lua加载开始");
--[[-------------------------------------------------------------------------
--  角色登陆次数统计
-------------------------------------------------------------------------]]--
local playerName = UnitName("player");

function Tinom.LoginLog(self, event, addonName)
    if ( TinomDB.accountDB == nil ) then
        TinomDB.accountDB = {};
        Tdebug(self,"log","6LoginLog初始化账户角色统计数据库");
    end
    local accountDB_Temp = TinomDB.accountDB;

    -- 触发事件为插件载入,并且插件名是"TinomDB"
    if ((event == "ADDON_LOADED") and (addonName == "Tinom")) then
        if (accountDB_Temp[playerName] == nil) then
            --如果无此角色记录则初始化一个
            Tdebug(self,"log","7LoginLog创建角色:"..playerName);
            --此处需要格式化角色名,不然会导致覆盖而不是添加.
            accountDB_Temp[format(playerName)] = {times=1,lastTime=0,};
			print("你好:"..playerName.." 初次见面,请多多关照.");
        else
            Tdebug(self,"log","8LoginLog记录角色:"..playerName);
            accountDB_Temp[playerName].times = accountDB_Temp[playerName].times + 1;
            local elapsed = time() - accountDB_Temp[playerName].lastTime;
            print("你好 "..playerName .. " \n这是我们第".. accountDB_Temp[playerName].times .."次相见.\n距离你上次登出的时间是" .. SecondsToTime(elapsed));
        end
    elseif (event == "PLAYER_LEAVING_WORLD")then
        -- 保存角色退出游戏的时间
        accountDB_Temp[playerName].lastTime = time();
        TinomDB.accountDB = accountDB_Temp;
        Tdebug(self,"log","9LoginLog保存角色:"..playerName);
    end
end

SLASH_HAVEWEMET1 = "/hwm"
SlashCmdList["HAVEWEMET"] = function(arg1)
    if #arg1 == 0 then
        print("这个角色一共登陆过 " .. TinomDB.accountDB[playerName].times .. " 次.");
    elseif arg1 == "rm" then
        table.remove( TinomDB.accountDB );
    elseif arg1 == "show" then
        for k,v in pairs(TinomDB.accountDB[playerName]) do
            print(k,v);
        end
    end
end

Tdebug(self,"log","AccountStat.lua加载完成");