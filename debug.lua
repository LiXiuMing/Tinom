--[[-------------------------------------------------------------------------
--
--  Debug
--  排错模块
--
--  功能:记录操作,统一输出,方便关闭
--
-------------------------------------------------------------------------]]--
--  初始化排错记录库
local debugDB_Temp = {
    log = {};
    error = {};
};
--[[-------------------------------------------------------------------------
--  排错函数:
--  Tdebug(self,"error,log","__");
-------------------------------------------------------------------------]]--
local TinomDebugFrame = CreateFrame("Frame")
TinomDebugFrame:RegisterEvent("PLAYER_LOGOUT")
TinomDebugFrame:SetScript("OnEvent", function(self, event, ...)
    debugDB = debugDB_Temp;
end)

function Tdebug( ... )
    if true then
        return;
    end
    local callFrame, callType, callMsg = ...;
	local timeNow = date("%H:%M:%S");
	local logStr = timeNow.."-["..callType.."]: "..callMsg
	--print(self);
    if ( callType == "log" ) then
        table.insert( debugDB_Temp.log, logStr );
        print(logStr);
    elseif ( callType == "error" ) then
        table.insert( debugDB_Temp.error, logStr );
        --print(logStr);
    end
end
