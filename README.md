# Tinom插件说明

## 插件功能:

1. 统计功能:
    - [OK]角色信息: GUID(唯一标识),姓名,服务器,等级,职业,种族,性别,当前地区,历史姓名
    - [OK]发言信息: 上次发言内容,上次发言时间,总发言计数,总重复发言计数,所获成就
    - 聊天排行榜:统计本服最爱唠嗑的前几名显示于设置界面
2. 聊天过滤:
    - [OK]自动添加过滤: 将重复发言到指定值的角色GUID加入到过滤列表.
    - 深度分析: 将发言累计到一定程度(发言频率固定)的角色加入特别审查函数甄别.
    - 特别审查函数: 缓存角色的10条信息,累计重复次数,若其累计到一定值则加入过滤名单.
    - [OK]聊天过滤:角色白名单,角色黑名单,角色临时白名单,角色临时黑名单,关键字黑名单,关键字白名单,20条以内的重复发言.(都要区分聊天频道)白名单模式,关键字提醒,关键字记录,
    - [OK]修改聊天频道名: 例如:把"大脚世界频道"改为"世界"或为空,以节省占用空间.
    - [OK]修改角色名: 将指定的角色名修改为指定值(例如:小狗).
    - [OK]修改角色发言: 将指定角色发言内用修改为指定值(例如:小狗:汪汪汪).
    - 团队模式:暂停一般过滤节省资源,转而过滤像EUI这样的喊话插件.
    - 社区邀请过滤:过滤社区邀请提示框和声音,但仍能在公会界面看到邀请.或是全部过滤.
    - 状态过滤:角色状态时AFK和忙碌的角色发言丢弃
3. 聊天增强:(吃瓜模式,强力吃瓜模式,卖瓜模式)
    - 成语接龙: 密语成语接龙,~~频道成语接龙~~.(也可有相应的[成语接龙成就]).
    - 密语组队: 角色密语指定内容则邀请加入队伍,如果失败则提示框提示并密语反馈.
    - 消息装等显示: 显示聊天信息中的装备装等或其它信息.
    - 消息小尾巴:发送消息末尾加上个"嗝~"啥的,最好做出字数限制,免得滥用,随机小尾巴也是可以的
    - 关闭系统过滤功能.
    - [OK]高亮显示白名单消息和白名单关键字
    - 特别提醒功能:关注的角色名或者消息关键字出现则声音提醒,加框架提醒,加框架显示和保存记录
    - 笔记功能
    - 临时截取功能:截取保存一段消息,
    - 复制功能:弹出新的框架,展示聊天框内的文本,自由复制
    - UI全部隐藏,全新的全屏聊天界面,右下角显示是否暂离等
    - 特定筛选:从聊天框中提取出指定角色或者指定关键词的消息展示到框架上
    - 右键角色名功能
    - 关键字规避提醒:即将发出的消息中是否含有屏蔽关键字,有则提醒,或者选项:自动更改谐音字或夹杂字符
    - LFG:公会浏览功能,公会申请...
    - 社区增强,消息提醒等功能加入社区选择的功能,有人可能加入了多个社区,只想监视某一个社区的化...
    - ~~聊天成就: 角色发言达到一定次数给予相应[聊天成就]并通报,角色重复发言达到一定次数给予相应[广告成就]并通报.~~
    - ~~聊天时段: 每小时统计一次发言次数最多的前几名玩家,给予相应[聊天时段成就]并通报.~~
    - ~~升级鼓励: 角色与上一次等级相差超过指定值并且达到指定值则给予相应鼓励和[升级成就].~~

***

66. 其它功能
    1.  随机团本临时指挥系统: 通过密语团员,回复 1 接受指挥信息,回复 2/不回复 则拒绝.
    2.  我是伸手党: BOSS战完毕展示队友战利品框架,附带伸手按钮,密语对方要不要.

***
## 网友需要的功能:
1. [OK]隐藏灰色物品拾取信息[Idea]:@forever_noyes(CHAT_MSG_LOOT事件是自己拾取的)
   - 示例:`[CHAT_MSG_LOOT]: 你获得了战利品：|cff9d9d9d|Hitem:3175::::::::120:102::::::|h[破损的龙鳞]|h|r。"`
2. 屏蔽社区邀请[Idea]:@zh648990
3. [OK]怀旧服职业颜色[Idea]:@纯情小猪哥 
   1. `|Hchannel:channel:4|h[4. 大脚世界频道]|h |Hplayer:戴育林-怒炉:2956:CHANNEL:4|h[戴育林]|h： 释放他们组个"`
4. 重复发言过滤自定义时间间隔[Idea]:@zhougl2
5. [OK]精简消息:消息内的重复内容缩写[Idea]:@appleboy2016
6. 优先级调整:[Idea]:@powervv
   1. 白名单玩家第一,都不屏蔽,
   2. 黑名单玩家第二,说什么都屏蔽.
   3. 黑白关键字第三,名单应该同时生效.比如我是治疗,白名单关键字设置治疗,但是我不想去血色,那么我关键字黑名单设置血色,这样就显示不包含血色的有治疗关键字的说话.

***
## 备注:
2019/09/30:因为升级到8.2.5后频道自动发言的API被禁用了,所以删去了一部分待实现的功能.

***

## 变量命名:
**局部变量**: 小写开头,第二个单词开始首字母大写,  
**全局变量**: Tinom.功能组 变量名, 小写开头,第二个单词开始首字母大写  
**布尔变量**: Tinom_Switch_   功能组   _   变量名  
**函数名**: Tinom.   功能组   _   函数名, 所有单词首字母大写,酌情_下划线_  
**框架名**: Tinom  功能组  框架名, 所有单词首字母大写  
**框架用字符串**: TINOM_功能组_框架名_字符串名, 所有字母大写,酌情_下划线_

开关:
    替换角色名开关:         Tinom_Switch_MsgFilter_ReplaceName
    替换关键字开关:         Tinom_Switch_MsgFilter_ReplaceKeyWord
    替换角色消息开关:       Tinom_Switch_MsgFilter_ReplaceNameMsg
    替换关键字消息开关:     Tinom_Switch_MsgFilter_ReplaceKeyWordMsg

    白名单开关:             Tinom_Switch_MsgFilter_WhiteList
    黑名单开关:             Tinom_Switch_MsgFilter_BlackList
    白名单关键字开关:       Tinom_Switch_MsgFilter_WhiteListKeyWord
    黑名单关键字开关:       Tinom_Switch_MsgFilter_BlackListKeyWord

    重复发言开关:           Tinom_Switch_MsgFilter_Repeat
    只显示白名单开关:       Tinom_Switch_MsgFilter_WhiteListOnly

数据库:
    白名单地址:             TinomDB.filterDB.whiteList
    黑名单地址:             TinomDB.filterDB.blackList
    白名单关键字地址:       TinomDB.filterDB.whiteListKeyWord
    黑名单关键字地址:       TinomDB.filterDB.blackListKeyWord

    替换角色名地址:         TinomDB.filterDB.replaceName[].newName
    替换关键字地址:         TinomDB.filterDB.replaceKeyWord[].newWord
    替换角色消息地址:       TinomDB.filterDB.replaceName[].newMsg
    替换关键字消息地址:     TinomDB.filterDB.replaceKeyWord[].newMsg

    20条信息缓存表:         TinomDB_filterDB_cacheMsgTemp
    临时白名单:             TinomDB_filterDB_whiteListTemp
    临时黑名单:             TinomDB_filterDB_blackListTemp

## 数据库结构:

TinomDB={
    Options = {
        Default = {
            Tinom_Switch_MsgFilter_ReplaceName = false;
            Tinom_Switch_MsgFilter_ReplaceKeyWord = false;
            Tinom_Switch_MsgFilter_ReplaceNameMsg = false;
            Tinom_Switch_MsgFilter_ReplaceKeyWordMsg = false;
            Tinom_Switch_MsgFilter_WhiteList = false;
            Tinom_Switch_MsgFilter_BlackList = false;
            Tinom_Switch_MsgFilter_WhiteListKeyWord = false;
            Tinom_Switch_MsgFilter_BlackListKeyWord = false;
            Tinom_Switch_MsgFilter_CacheMsgRepeat = false;
            Tinom_Switch_MsgFilter_WhiteListOnly = false;
        },
    },

    playerDB = {
        GUID = {
            name = "string",
            class = "string",
            sex = number,
            race = "string",
        },
    },

    accountDB = {
        character = {
            class = "string",
            guid = "string",
            sex = number,
            race = "string",
        },
    },

    chatStatDB = {
        servername = {
            authorName = {
                msgCount = number,
                msgRepeatTimes = number,
                msgLastText = "string",
                msgLastTime = number,
                authorClass = "string",
                authorGUID = "string",
                authorSex = number,
                authorRace = "string",
            }
        }
    },

    filterDB = {
        whiteList = {"name","name","name"},
        blackList = {"name","name","name"},

        whiteListKeyWord = {"keyWord","keyWord","keyWord"},
        blackListKeyWord = {"keyWord","keyWord","keyWord"},

        replaceName = {
            name = {
                newName = "NewName",
                newMsg = "NewMsg",
            },
            name = {
                newName = "NewName",
                newMsg = "NewMsg",
            },
            name = {
                newName = "NewName",
                newMsg = "NewMsg",
            },
        },
        
        replaceKeyWord = {
            keyWord = {
                newWord = "NewWord",
                newMsg = "NewMsg",   
            },
            keyWord = {
                newWord = "NewWord",
                newMsg = "NewMsg",   
            },
            keyWord = {
                newWord = "NewWord",
                newMsg = "NewMsg",   
            },
        },
    }
