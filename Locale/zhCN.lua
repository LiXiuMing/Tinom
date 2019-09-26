--  判断本地语言是否为指定值,否则直接退出,不再进行之后动作.
if(GetLocale() ~= "zhCN") then return end

--  获取传入参数中的插件名
local _, addon = ...

local L = {
    ["Hello Azeroth!"] = "你好艾泽拉斯!"
}

--  执行本地化函数
MyAddon:RegisterLocale(L)

--  释放内存
L = nil