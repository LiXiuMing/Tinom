--[[-------------------------------------------------------------------------
--  角色登陆次数统计
-------------------------------------------------------------------------]]--
local uName = UnitName("player");

function Tinom.LoginLog(self, event, arg1)
    if ( TinomDB.accountDB == nil ) then
        TinomDB.accountDB = {};
        print("初始化账户角色统计数据库");
    end
    local accountDB_Temp = TinomDB.accountDB;

    -- 触发事件为插件载入,并且插件名是"TinomDB"
    if ((event == "ADDON_LOADED") and (arg1 == "Tinom")) then
        if (accountDB_Temp[uName] == nil) then
            --如果无此角色记录则初始化一个
            print("创建角色:"..uName);
            --此处需要格式化角色名,不然会导致覆盖而不是添加.
            accountDB_Temp[format(uName)] = {times=1,time=0,};

			print("你好:"..uName.." 初次见面,请多多关照.(PS.不要问我一个插件需要你关照什么.)");
        else
            accountDB_Temp[uName].times = accountDB_Temp[uName].times + 1
            local elapsed = time() - accountDB_Temp[uName].time
            print("你好 "..uName .. " \n这是我们第".. accountDB_Temp[uName].times .."次相见.\n距离你上次登出的时间是" .. SecondsToTime(elapsed))
        end
        accountDB_Temp[uName].time = time();
    elseif (event == "PLAYER_LEAVING_WORLD")then
        -- 保存角色退出游戏的时间
        accountDB_Temp[uName].time = time();
        TinomDB.accountDB = accountDB_Temp;
        
    end
end

SLASH_HAVEWEMET1 = "/hwm"
SlashCmdList["HAVEWEMET"] = function(arg1)
    if #arg1 == 0 then
        print("这个角色一共登陆过 " .. TinomDB.accountDB[uName].times .. " 次.");
    elseif arg1 == "rm" then
        table.remove( TinomDB.accountDB );
    elseif arg1 == "show" then
        for k,v in pairs(TinomDB.accountDB) do
            print(k,v);
        end
    end
end