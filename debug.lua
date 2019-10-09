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
local Tinom_Switch_Debug = false;
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
    if not Tinom_Switch_Debug then
        return;
    end
    local callFrame, callType, callMsg = ...;
	local timeNow = date("%H:%M:%S");
	local logStr = timeNow.."-["..callType.."]: "..callMsg
    if ( callType == "log" ) then
        table.insert( debugDB_Temp.log, logStr );
        print(logStr);
    elseif ( callType == "error" ) then
        table.insert( debugDB_Temp.error, logStr );
        --print(logStr);
    end
end

function TdebugSwitch()
    if Tinom_Switch_Debug == false then
        Tinom_Switch_Debug = true;
    else
        Tinom_Switch_Debug = false;
    end
end
SLASH_TINOMDEBUG1 = "/tdebug"
SLASH_TINOMDEBUG2 = "/td"
SlashCmdList["TINOMDEBUG"] = TdebugSwitch;