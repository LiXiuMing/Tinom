
--  获取插件的插件名和插件表
local addonName, addon = ...
print(addonName,addon)

-- 设置插件的全局名称
--_G[addonName] = addon

-- 从TOC文件中提取版本信息
addon.version = GetAddOnMetadata(addonName, "Version")
print(addon.version)
if addon.version == "@project-version" or addon.version == "wowi:version" then
    addon.version = "SCM"
end

--  模块化封装
Tinom = {}

--[[-------------------------------------------------------------------------
--  本地化函数
-------------------------------------------------------------------------]]--
Tinom.L = Tinom.L or setmetatable({}, {
    __index = function(table, key)
        rawset(table, key, key)
        return key
    end,
    __newindex = function(table, key, value)
        if v == true then
            rawset(table, key, key)
        else
            rawset(table, key, value)
        end
    end,
})

function Tinom:RegisterLocale(tablelocale)
    if not tablelocale then return end
    for k,v in pairs(tablelocale) do
        if v == true then
            self.L[k] = k
        elseif type(v) == "string" then
            self.L[k] = v
        else
            self.L[k] = k
        end
    end
end

local namea = UnitName("player");
function Tinom.OnLoad(self)
    self:RegisterEvent("ADDON_LOADED")
    self:SetScript("OnEvent", function(self, event, addon)
        if addon == "Tinom" then
            print(format("你好%s,%s插件已加载完成.",namea,addon))
            print(Tinom.L["Hello Azeroth!"])
        end
    end)
end



function Tinom.Test( ... )
    print("呱唧")
    return "O(∩_∩)O"
end
SLASH_MYTEST1 = "/test"
SlashCmdList["MYTEST"] = Tinom.Test;



function Tinom.Login_log( ... )
    --设置保存模块实例
    local myframe = CreateFrame("Frame")
    myframe:RegisterEvent("ADDON_LOADED")
    myframe:RegisterEvent("PLAYER_LOGOUT")

    myframe:SetScript("OnEvent", function(self, event, arg1)
        --print("本次激活的事件是:"..event..",\narg1是"..arg1)
        if (globaldb_Temp == nil ) then
            if ( globaldb == nil ) then
                globaldb = {}
                print("初始化数据库")
            end
            globaldb_Temp = globaldb;
        end

        if event == "ADDON_LOADED" and arg1 == "Tinom" then
            -- 触发事件为插件载入,并且插件名是"Tinom"
            if globaldb_Temp[namea] == nil then
                --如果无此角色记录则初始化一个
                print("创建角色:"..namea);
                --此处需要格式化角色名,不然会导致覆盖而不是添加.
                globaldb_Temp[string.format(namea)] = {times=1;time=0;};
            else
                globaldb_Temp[namea].times = globaldb_Temp[namea].times + 1
                local elapsed = time() - globaldb_Temp[namea].time
                print("你好 "..namea .. " \n这是我们第".. globaldb_Temp[namea].times .."次相见.\n距离你上次登出的时间是" .. SecondsToTime(elapsed))
            end
            globaldb_Temp[namea].time = time();
        elseif event == "PLAYER_LOGOUT" then
                -- 保存角色退出游戏的时间
                globaldb_Temp[namea].time = time();
                globaldb = globaldb_Temp;
        end
    end)

    SLASH_HAVEWEMET1 = "/hwm"
    SlashCmdList["HAVEWEMET"] = function(msg)
        print("这个角色一共登陆过 " .. globaldb_Temp[namea].times .. " 次.")
    end
end

--消息字符串替换函数:类似把大脚世界频道替换为世界,
--此处为把频道序号后的频道名隐藏.
function Tinom.Msg_Replace()
    for i=1,NUM_CHAT_WINDOWS do
        if (i ~= 2) then
            local chatframe = _G["ChatFrame"..i]
            local addmsg = chatframe.AddMessage
            chatframe.AddMessage = function(frame, text,...)
                --_G["ChatFrame3"]:AddMessage(text,...);
                text = text:gsub( "%[(%d)%..-%]", "%[%1%]" )
                return addmsg(frame,text,...)
            end
        end
    end
end

--消息过滤函数
function Tinom.Msg_Show(  )
    local function MsgShow(self,event,arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13,...)
        --text, playerName,... = arg1, arg2,...
        --local arg = {arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13}
        --[[ for i,v in ipairs(arg) do
            print(i,v)
        end ]]
        --print( self , event , msg )
        --return true
        --break
        if arg1:find("buy gold") then
            return true
        end
        if arg2 == "Knownspammer" then    --Knownspammer:Known spammer(已知的垃圾邮件制作者)
            return true
        end
        --DEFAULT_CHAT_FRAME:AddMessage(msg, 0.0, 0.0, 0.0)

        if arg9 == "秋水测试频道1" then
            arg4 = arg4:gsub( "秋水测试频道", "秋水测-------" )
            --arg9 = "秋水测试----"
            return false, arg1,arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13,...
            --ChatFrame1:AddMessage(arg1)
        else
            return false
        end
    end
    ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", MsgShow)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", MsgShow)
    --ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", Msg_Show)
    --ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", Msg_Show)
end
Tinom.Msg_Show()

--小地图显示ping的人
--[[ local addona = CreateFrame('ScrollingMessageFrame', false, Minimap)
　　addona:SetHeight(10)
　　addona:SetWidth(100)
　　addona:SetPoint('BOTTOM', Minimap, 0, 20)
　　addona:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
　　addona:SetJustifyH'CENTER'
　　addona:SetJustifyV'CENTER'
　　addona:SetMaxLines(1)
　　addona:SetFading(true)
　　addona:SetFadeDuration(3)
　　addona:SetTimeVisible(5)
　　addona:RegisterEvent'MINIMAP_PING'
　　addona:SetScript('OnEvent', function(self, event, u)
　　    local c = RAID_CLASS_COLORS[select(2,UnitClass(u))]
　　    local name = UnitName(u)
　　    addona:AddMessage(name, c.r, c.g, c.b)
　　end) ]]

