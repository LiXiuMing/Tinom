--  判断本地语言是否为指定值,否则直接退出,不再进行之后动作.
if (TinomLocale and (GetLocale() ~= "zhCN")) then return end

--[[-------------------------------------------------------------------------
--  本地化表
-------------------------------------------------------------------------]]--
TinomLocale = {
    ["白名单设置"] = "白名单设置",
    ["开启过滤"] = "开启过滤",
    ["高亮显示"] = "高亮显示",
    ["黑名单:关键字"] = "黑名单:关键字",
    ["替换关键字"] = "替换关键字",
    ["替换单设置:"] = "替换单设置:",
    ["白名单关键字"] = "白名单关键字",
    ["黑名单设置:每行一个角色名或者关键字"] = "黑名单设置:每行一个角色名或者关键字",
    ["应用"] = "应用",
    ["白名单:关键字"] = "白名单:关键字",
    ["缩写频道名"] = "缩写频道名",
    ["黑名单关键字"] = "黑名单关键字",
    ["新角色名-可选"] = "新角色名-可选",
    ["Tinom聊天过滤"] = "Tinom聊天过滤",
    ["黑名单设置"] = "黑名单设置",
    ["关键字"] = "关键字",
    ["替换角色的消息"] = "替换角色的消息",
    ["缩写玩家名(|cffffff00注意!被缩写的角色将导致其右键内交互功能失效!|r)"] = "缩写玩家名(|cffffff00注意!被缩写的角色将导致其右键内交互功能失效!|r)",
    ["Tinom聊天过滤v"] = "Tinom聊天过滤v",
    ["开启过滤系统的主开关"] = "开启过滤系统的主开关",
    ["替换单设置"] = "替换单设置",
    ["新消息-可选"] = "新消息-可选",
    ["基本设置"] = "基本设置",
    ["屏蔽灰色物品拾取消息"] = "屏蔽灰色物品拾取消息",
    ["白名单设置:每行一个角色名或者关键字"] = "白名单设置:每行一个角色名或者关键字",
    ["黑名单:玩家"] = "黑名单:玩家",
    ["替换关键字的消息"] = "替换关键字的消息",
    ["开启"] = "开启",
    ["新关键字-可选"] = "新关键字-可选",
    ["过滤"] = "过滤",
    ["角色名"] = "角色名",
    ["白名单"] = "白名单",
    ["屏蔽重复消息"] = "屏蔽重复消息",
    ["声音提醒需要开启\n相应的白名单过滤"] = "声音提醒需要开启\n相应的白名单过滤",
    ["折叠复读消息"] = "折叠复读消息",
    ["替换角色名"] = "替换角色名",
    ["黑名单"] = "黑名单",
    ["白名单:玩家"] = "白名单:玩家",
    ["自动添加黑名单"] = "自动添加黑名单",
    ["只有白名单"] = "只有白名单",
    ["目前插件处于Beta测试阶段,更新会比较频繁.您可以经常浏览我的更新贴以获取最新版本.NGA:搜索\"Tinom\"进行反馈."] = "目前插件处于Beta测试阶段,更新会比较频繁.您可以经常浏览我的更新贴以获取最新版本.NGA:搜索\"Tinom\"进行反馈.",
    ["选一个你喜欢的提示音"] = "选一个你喜欢的提示音",
    ["替换类型"] = "替换类型",
    ["按角色名替换"] = "按角色名替换",
    ["按关键字替换"] = "按关键字替换",
    ["过滤优先级从上至下递减"] = "过滤优先级从上至下递减",
    ["铃声"] = "铃声",
    ["新增"] = "新增",
    ["删除"] = "删除",
    ["修改"] = "修改",
    ["你太短了!"] = "你太短了!",
}

Tdebug(self,"log","zhCN.lua加载完成");