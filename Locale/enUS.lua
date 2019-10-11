--  判断本地语言是否为指定值,否则直接退出,不再进行之后动作.
if (TinomLocale and (GetLocale() ~= "enUS")) then return end

--[[-------------------------------------------------------------------------
--  本地化表
-------------------------------------------------------------------------]]--
TinomLocale = {
    ["白名单设置"] = "White List Settings",
    ["开启过滤"] = "Turn on filtering",
    ["高亮显示"] = "highlighted",
    ["黑名单:关键字"] = "blacklist: keyword",
    ["替换关键字"] = "Replace keywords",
    ["替换单设置:"] = "Replacement Order Settings:",
    ["白名单关键字"] = "whitelist keyword",
    ["黑名单设置:每行一个角色名或者关键字"] = "Blacklist setting: one role name or keyword per line",
    ["应用"] = "Apply",
    ["白名单:关键字"] = "White List: Keywords",
    ["缩写频道名"] = "abbreviated channel name",
    ["黑名单关键字"] = "blacklist keyword",
    ["新角色名-可选"] = "new role name - optional",
    ["Tinom聊天过滤"] = "Tinom Chat Filter",
    ["黑名单设置"] = "blacklist setting",
    ["关键字"] = "keyword",
    ["替换角色的消息"] = "Replace role message",
    ["缩写玩家名(|cffffff00注意!被缩写的角色将导致其右键内交互功能失效!|r)"] = "Abbreviation player name(|cffffff00Note! The abbreviated character will cause its right-click interaction function to be invalid!|r)",
    ["Tinom聊天过滤v"] = "Tinom chat filter v",
    ["开启过滤系统的主开关"] = "Turn on the main switch of the filter system",
    ["替换单设置"] = "Replacement Order Settings",
    ["新消息-可选"] = "New Message - Optional",
    ["基本设置"] = "Basic Settings",
    ["屏蔽灰色物品拾取消息"] = "Block gray item picking message",
    ["白名单设置:每行一个角色名或者关键字"] = "Whitelist setting: one role name or keyword per line",
    ["黑名单:玩家"] = "blacklist: player",
    ["替换关键字的消息"] = "Replace keyword message",
    ["开启"] = "on",
    ["新关键字-可选"] = "New Keyword - Optional",
    ["过滤"] = "Filter",
    ["角色名"] = "role name",
    ["白名单"] = "white list",
    ["屏蔽重复消息"] = "Block duplicate messages",
    ["声音提醒需要开启\n相应的白名单过滤"] = "The voice reminder needs to be enabled\n corresponding whitelist filtering",
    ["折叠复读消息"] = "Folding Repeat Message",
    ["替换角色名"] = "Replace Role Name",
    ["黑名单"] = "blacklist",
    ["白名单:玩家"] = "White List: Players",
    ["自动添加黑名单"] = "Automatically add blacklist",
    ["只有白名单"] = "Only whitelist",
    ["目前插件处于Beta测试阶段,更新会比较频繁.您可以经常浏览我的更新贴以获取最新版本.NGA:搜索\"Tinom\"进行反馈."] = "The plugin is currently in beta testing, update It will be more frequent. You can often browse my update post to get the latest version. NGA: Search \"Tinom\" for feedback.",
    ["选一个你喜欢的提示音"] = "Choose a tone you like",
    ["替换类型"] = "Replace Type",
}

Tdebug(self,"log","zhCN.lua加载完成");