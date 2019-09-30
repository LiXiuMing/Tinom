--  模块化封装
Tinom = {};

--[[-------------------------------------------------------------------------
--  角色登陆次数统计
-------------------------------------------------------------------------]]--
function Tinom.Login_log( ... )
    --设置保存模块实例
    local namea = UnitName("player");
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

--[[-------------------------------------------------------------------------
--  消息字符串替换函数:类似把大脚世界频道替换为世界,
--  此处为把频道序号后的频道名隐藏.
-------------------------------------------------------------------------]]--
function Tinom.Msg_Replace()
    for i=1,NUM_CHAT_WINDOWS do
        if (i ~= 2) then
            local chatframe = _G["ChatFrame"..i]
            local addmsg = chatframe.AddMessage
            chatframe.AddMessage = function(frame, text,...)
                text = text:gsub( "%[(%d)%..-%]", "%[%1%]" )
                return addmsg(frame,text,...)
            end
        end
    end
end

--[[-------------------------------------------------------------------------
--  消息过滤函数
-------------------------------------------------------------------------]]--
kwordDB_Temp = {"小红"};
function Tinom.MsgFilter( Filter_Switch )
    local function MsgFilterHandler(self,event,...)
        --[[ if ((Filter_Switch == false) or (arg2 == UnitName("player"))) then
            return;
        end ]]

        if ( event ~= "CHAT_MSG_CHANNEL" ) then return end
        local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = ...;
        local authorname, authorserver = arg2:match( "(.-)%-(.*)" )

        if (arg16) then
			-- hiding sender in letterbox: do NOT even show in chat window (only shows in cinematic frame)
			return true;
        end

        --  屏蔽列表过滤
        if ( filterDB_Temp[authorname] ) then            
            return true;
        end

        --  关键字过滤
        for i,v in pairs(kwordDB_Temp) do
            if arg1:find(v) then
                return true;
            end
        end
    end

    if (Filter_Switch == true) then
        filterDB_Temp = filterDB;
        ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", MsgFilterHandler)
        ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", MsgFilterHandler)
        --ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", MsgFilterHandler)
        --ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", MsgFilterHandler)
        print("开启过滤")
    elseif (Filter_Switch == false) then
        filterDB_Temp = {};
        ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", MsgFilterHandler)
        ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SAY", MsgFilterHandler)
        --ChatFrame_RemoveMessageEventFilter("CHAT_MSG_YELL", MsgFilterHandler)
        --ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", MsgFilterHandler)
        print("关闭过滤")
    end

end

