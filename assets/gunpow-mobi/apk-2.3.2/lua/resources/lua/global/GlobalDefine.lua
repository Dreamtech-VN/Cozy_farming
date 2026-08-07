--GlobalDefine.lua
--@brief	全局变量定义
--@date		2013/12/02
--@author	叶威
--@note     定义项目全局变量和宏常量


--服务器链接结果
--链接成功
CONNECTSERVER_SUCCESS = 1
--链接失败
CONNECTSERVER_FAILED = 2
--链接断开
CONNECTSERVER_DISCONNECT = 3
--重新链接
CONNECTSERVER_RECONNECT = 4

--网络链接状态标识位
--表示策略1（登录游戏的原始流程，会根据网络状况弹出相应提示）
NET_FLAG_1 = 0
--表示策略2（在游戏中非战斗场景断线，会在后台链接游戏服务器，最多5秒）
NET_FLAG_2 = 1
--表示策略3（在策略2链接游戏服务器5秒失败后，会重连IPD）
NET_FLAG_3 = 2
--表示策略7（一些特殊的界面断线，需要立即弹出提示，重连后需要切换到上一级界面）
NET_FLAG_7 = 6
--表示策略4（在网络断开的情况下，只要用户没有重启客户端，就会一直保持NET_FLAG_4的状态，重连时不会再重新检测下载和加载lua文件）
NET_FLAG_4 = 3
--表示策略0（游戏退入后台5分钟，强制重新登陆游戏）
NET_FLAG_0 = -1

-- 标志是否可以强制重启标志
g_canReset = false

--加载资源时候网络是否连接
g_isconnect = false
--LUA等资源是否正在加载
g_bisloadingres = false
--LUA等资源是否加载
g_bisloadres = false
--断线重连时的加载框ID
g_nReconnectLoadingBoxID = -1	

--断线重连定时器ID
g_nReconnectScheduleID = -1

--断线重连服务器状态定时器ID
g_nReconnectServerScheduleID = -1

--断线重连服务器状态开始时间
g_nReconnectServerBeginTime = -1

--断线重连开始时间
g_nReconnectBeginTime = -1
--断线重连时间限制，单位秒
RECONNET_TIME_LIMIT = 15

--从连接服务器成功到登陆成功的定时器ID
g_nLinkokToLoginokScheduleID = -1

--从连接服务器成功到登陆成功的弹窗时间
g_nLinkokToLoginokTimer = -1

--客户端挂入后台的时间
g_TimeToBackground = -1

--用户角色登陆成功的时间
g_TimePlayerLogin = -1

--推送定时器
g_checkPushNeedList = -1

--登录后活动界面弹出提示
--g_checkLoginActivities = false 

--登陆游戏后请求本地推送信息列表
PLAYERLOGIN_TIME_LIMIT = 600

--挂后台时间限制，单位秒
BACKGROUND_TIME_LIMIT = 600

--lua文件全部加载完成标识
g_bLuaFilesAllLoaded = false
--lua文件加载标志
LUALOAD_NO = 0
LUALOAD_LOADED = 1

--lua文件资源加载时，模块的划分大部分与频道ID一致，个别特殊界面自定义
--教学模块
LUAFILES_BLOCK_TEACH = 2001
--会被其他多个模块使用的公共模块
LUAFILES_BLOCK_COMMON = 2002
--普通战斗
LUAFILES_BLOCK_NORMALBATTLE = 2003
--副本战斗
LUAFILES_BLOCK_BOSSBATTLE = 2004

DEFAULT_FPS = 30 --当前游戏的帧数
-- channel subchannel define
-- 频道（0世界，1当前，2公会，3队伍，4私聊, 5系统, 6彩聊）
----------------------------------------------
--频道：世界
CHANNEL_WORLD        = 0
--频道：当前
CHANNEL_CURRENT      = 1
--频道：公会
CHANNEL_GUILD        = 2
--频道：队伍
CHANNEL_TEAM         = 3
--频道：私聊
CHANNEL_WHISPER      = 4
--频道：系统
CHANNEL_SYSTEM       = 5
--频道：彩聊
CHANNEL_COLORCHAT    = 6
--频道：副本
CHANNEL_COPY = 7
--频道：活动-射箭
CHANNEL_SHOOTARROW = 8
--频道：金喇叭
CHANNEL_GOLD        = 11
--频道：联盟
CHANNEL_UNION       = 12
----------------编辑框提示语宏定义start------------
TEDIT_ENUM = 
{
	ALIGNMENTUP = 0,--默认位置在左上
    ALIGNMENTCENTER = 1,--默认位置在左中
    ALIGNMENTDOWN = 2,--默认位置在左下

}
----------------编辑框提示语宏定义end--------------

----------------密码错误窗口状态----------------
g_passportwrongstate = nil
----------------------------------------------
----------------------------------------------
--喇叭层order
SUONA_ZORDER  =   10001
----------------------------------------------
----------------------------------------------
--push成就层order
ARCHIE_ZORDER  =   10002
----------------------------------------------
-- channel define
-- 频道定义
----------------------------------------------

--------------------金币类型-------------------
g_DIAMONDID = "1"
g_GOLDID = "2"

--------------------属性类型-------------------
PRO_HP = 1--生命
PRO_MAXHP = 2 --当前等级最大生命
PRO_ATTACK = 3--攻击
PRO_DEFEND = 4--防御
PRO_CRIT = 5--暴击
PRO_CRITRATE = 6--暴击率
PRO_REDUCECRIT = 7--免爆
PRO_REDUCECRITRATE = 8--免爆率
PRO_PHYSIQUE = 9--体质
PRO_FORCE = 10--力量
PRO_ARMOR = 11--护甲
PRO_AGILITY = 12--敏捷
PRO_LUCK = 13--幸运
PRO_PHYSICAL = 14--体力
PRO_MAXPHYSICAL = 15--体力上限
PRO_ANGER = 16--怒气
PRO_MAXANGER = 17--怒气上限
PRO_RANGE = 18 -- 范围
PRO_WRECKDEFENSE = 19 --破防
PRO_INJURYFREE = 20 --免伤

--------------------坐骑状态-------------------
MOUNTS_LEVEL = 1
MOUNTS_BUY = 2
MOUNTS_GM = 3 
MOUNTS_EX = 4 

--界面ID						界面名称	是否聊天频道
Chat_Channel_Island = 1 --小岛
Chat_Channel_Hall  = 2 --游戏大厅
Chat_Channel_CreateRoom = 3 --创建房间
Chat_Channel_Room  = 4 --战斗房间
Chat_Channel_Loadding = 5--战斗加载
Chat_Channel_GameOver = 6--结算
Chat_Channel_Battle_Reward= 7--竞技奖励
Chat_Channel_Battle_Shop = 8 --竞技商店
Chat_Channel_Find_Room = 9 --查找房间
Chat_Channel_Room_Info = 10 --房间信息
Chat_Channel_Battle_Invite = 11 --竞技邀请
Chat_Channel_Single_Copy_Hall = 12 --单人副本大厅
Chat_Channel_Single_Copy_Sweep = 13 --单人副本扫荡
Chat_Channel_Single_Copy_Reward = 14 --单人副本结算
Chat_Channel_Team_Copy_Hall = 15 --组队副本大厅
Chat_Channel_Team_Copy_Room = 16 --组队副本房间
Chat_Channel_Team_Copy_Settlement = 17 --组队副本结算
Chat_Channel_Team_Copy_Reward = 18 --组队副本翻牌

Chat_Channel_Tower_Copy_Hall = 19 --爬塔副本大厅
Chat_Channel_Tower_Copy_Settlement = 20 --爬塔副本结算
Chat_Channel_Tower_Copy_Sweeping = 21 --爬塔副本扫荡
Chat_Channel_Tower_Copy_Resert = 22 --爬塔副本重置
Chat_Channel_Tower_Copy_Rank = 23 --爬塔副本排行
Chat_Channel_Tower_Copy_Reward = 24 --爬塔副本奖励
Chat_Channel_Daily_Copy_Hall = 25 -- 日常副本大厅
Chat_Channel_Daily_Copy_Settlement = 26 -- 日常副本结算
Chat_Channel_Guild_Rank_N = 27 -- 公会排行(未加入公会)
Chat_Channel_Guild_Create = 28 -- 创建公会
Chat_Channel_Guild_Scene = 29 -- 公会场景
Chat_Channel_Guild_Rank = 30 -- 公会排行(已加入公会)
Chat_Channel_Guild_Hall = 31 -- 公会大厅
Chat_Channel_Guild_Blog = 32 -- 公会日志
Chat_Channel_Guild_Donate = 33 -- 公会捐献
Chat_Channel_Guild_Send_Mail = 35 -- 公会群发邮件
Chat_Channel_Guild_Declaration = 36 -- 公会宣言
Chat_Channel_Guild_Totem = 37 -- 公会图腾
Chat_Channel_Guild_Totem_Explain = 38 -- 公会图腾说明
Chat_Channel_Guild_Shop = 39 --公会商店
Chat_Channel_Guild_Shop_Explain = 40 --公会商店说明
Chat_Channel_Guild_Skill_Hall = 41 -- 公会技能学堂
Chat_Channel_Guild_Skill_Hall_Explain = 42 -- 公会技能学堂说明
Chat_Channel_Shop = 43 --商场
Chat_Channel_Shop_Pay = 44 --商场付款
Chat_Channel_Character_Bag = 45 -- 角色背包
Chat_Channel_Character_Info = 46 -- 角色信息
Chat_Channel_Character_Dress = 47 -- 角色时装
Chat_Channel_Props = 48 --道具
Chat_Channel_Notice = 49 --公告
Chat_Channel_Mail_Send = 50 --邮件-发件箱
Chat_Channel_Mail_Rec = 51 --邮件-收件箱
Chat_Channel_Friends_Social = 52 --好友-社交
Chat_Channel_Friends_F = 53 --好友-好友
Chat_Channel_Friends_Info = 54 --好友-动态
Chat_Channel_Friends_Approval = 55 --好友-审批
Chat_Channel_Friends_Add = 56 --好友-添加
Chat_Channel_Achievement = 57 --成就
Chat_Channel_Title = 58 --称号
Chat_Channel_Pet = 59 --一般宠物
Chat_Channel_Pet_Exp = 60 --经验宠物
Chat_Channel_Pet_Upg = 61 --宠物升级
Chat_Channel_Pet_Evolve = 62 --宠物进化
Chat_Channel_Pet_Skill = 63 --宠物技能
Chat_Channel_Pet_Egg = 64 --宠物砸蛋
Chat_Channel_Pet_Summa = 65 --宠物大全
Chat_Channel_Pet_Rebirth = 66 --宠物重生

Chat_Channel_Mount = 67 --坐骑
Chat_Channel_Mount_Info = 68 --坐骑属性
Chat_Channel_Mount_Evolve = 69 --坐骑进阶
Chat_Channel_Mount_Upg = 70 --坐骑升级

Chat_Channel_Forged_Strengthen = 71 --锻造-强化
Chat_Channel_Forged_Upg = 72 --锻造-升星
Chat_Channel_Forged_Inlay = 73 --锻造-镶嵌
Chat_Channel_Forged_Inherit = 74 --锻造-继承

Chat_Channel_Gold_Tree = 75 --金币树
Chat_Channel_Gold_Tree_Resert = 76 --金币数-重置

Chat_Channel_Add_Strength = 77 --补充体力
Chat_Channel_Active= 78 --活跃活动
Chat_Channel_Signed = 79 --签到
Chat_Channel_Task_Main = 80 --任务 - 主线
Chat_Channel_Task_Sub = 81 --任务 - 支线
Chat_Channel_Task_Daily = 82 --任务 - 日常

Chat_Channel_Marry_N = 83 --结婚 - 未结婚（无任何关系）
Chat_Channel_Marry_Prop = 84 --求婚（求婚界面，选择求婚方式）
Chat_Channel_Marry_Explain = 85 --结婚系统说明
Chat_Channel_WeddingScene = 86  --礼堂（结婚场景）
Chat_Channel_Marry_Couple = 87 --夫妻关系（夫妻关系界面）
Chat_Channel_Marry_Divorce = 88 --夫妻关系-离婚
Chat_Channel_Marry_Loving_Blog = 89 --夫妻关系-恩爱日志
Chat_Channel_Marry_Send_Gift = 90 --夫妻关系-送礼物
Chat_Channel_Fighting = 91 --战斗_组队
Chat_Channel_Fighting_Team_Boss = 91 --战斗_组队
Chat_Channel_BecomeStronger = 92 --我要变强
Chat_Channel_Master_Apprentice = 93 --师徒
Chat_Channel_Wedding_List = 94 --婚礼列表（礼堂婚礼列表）
Chat_Channel_Wedding_Marriage = 95 --订婚关系（选择礼堂和订婚关系）
Chat_Channel_Wedding = 96 --订婚关系 - 选择举办婚礼
Chat_Channel_Wedding_Invitation = 97 --订婚关系 - 选择请柬
Chat_Channel_Wedding_Couple = 98 --夫妻关系（选择礼堂和夫妻关系）
Chat_Channel_Synthesis_Equipment = 99 --合成-装备
Chat_Channel_Synthesis_Props = 100 --合成-道具
Chat_Channel_Synthesis_Material = 101 --合成-材料
Chat_Channel_Sale_All = 102 --出售-全部
Chat_Channel_Sale_Equipment = 103 --出售-装备
Chat_Channel_Sale_Props = 104 --出售-道具
Chat_Channel_Sale_Material = 105 --出售-材料
Chat_Channel_Rank_List = 106 --排行榜
Chat_Channel_World_Boss = 108 --世界boss
Chat_Channel_Fund = 115 --成长基金
Chat_Channel_Vip_Recharge = 116 --VIP充值
Chat_Channel_Pvp_Rank = 154 --排位赛
Chat_Channel_StarSoul = 119 --星魂
Chat_Channel_Forged_Sophistic = 120 -- 锻造-洗练
Chat_Channel_GameActivity = 121 -- 活动
Chat_Channel_Badge = 125    --成就-徽章

Chat_Channel_Space_Send_Flower = 132 --战斗_组队
Chat_Channel_Fighting_Single = 136 --战斗_单人
Chat_Channel_Fighting_World_Boss = 137 --战斗_世界BOSS
Chat_Channel_Fighting_Normal = 138 --战斗_竞技
Chat_Channel_Fighting_Tower = 139 --战斗_爬塔
Chat_Channel_Fighting_Daily = 140 --战斗_日常
Chat_Channel_Fighting_Rank = 141 --战斗_排位
Chat_Channel_Bless = 144        --祈福屋
Chat_Channel_BlessBag = 145        --祈福背包
Chat_Channel_BlessDevour = 146        --祈福吞噬
Chat_Channel_BlessShop = 147        --祈福商店
Chat_Channel_Welfare_Weal = 148     --福利
Chat_Channel_Welfare_Compete = 149  --比赛
Chat_Channel_Library = 150          --图鉴
Chat_Channel_League_Compete = 156  --英雄联赛
Chat_Channel_League_ROOM = 157  --英雄联赛房间
Chat_Channel_League_TEAM = 158  --英雄联赛战队
Chat_Channel_League_HONOUR = 159  --英雄联赛荣誉
Chat_Channel_League_REPLAY = 160  --英雄联赛回放
Chat_Channel_League_REWARD = 161  --英雄联赛奖励
Chat_Channel_League_CHECKVS = 162 --英雄联赛点击查看弹出的界面
Chat_Channel_Fighting_League = 164  --英雄联赛战斗
Chat_Channel_Card = 168  --卡牌
Chat_Channel_OpenCardSet = 169  --开启卡套
Chat_Channel_Community_Progress = 170  --公会战赛程
Chat_Channel_Community_Rank = 171  --公会战排名
Chat_Channel_Community_Reward = 172  --公会战奖励
Chat_Channel_Community_Target = 173  --公会战目标
Chat_Channel_Community_Room = 174    --公会战房间
Chat_Channel_Community_Knockout_Room = 175    --公会战淘汰赛房间

Chat_Channel_WndAscending_Tab1 = 177    --圣光制作
Chat_Channel_WndAscending_Tab2 = 178    --圣光调品
Chat_Channel_WndAscending_Tab3 = 179    --圣光融合
Chat_Channel_Black_Shopper = 180    --黑市商人
Chat_Channel_Ath_Melee = 181 --大乐斗
Chat_Channel_Pvp_Amuse = 191 --娱乐赛
Chat_Channel_Guild_Boss = 192 --公会boss
Chat_Channel_Rune = 195  --符文系统
Chat_Channel_DigGem = 194 --挖宝界面
Chat_Channel_DigGem_Appraise = 196 --挖宝-鉴定界面
Chat_Channel_MainBagRune = 198 --角色-符文界面
Chat_Channel_Taboo_Section = 200 --禁忌之地-章节
Chat_Channel_Family = 218 --家园
Chat_Channel_FootMark = 230 --足迹系统
Chat_Channel_KidHome = 240 --小孩系统
Chat_Channel_Matchmaking = 241 --征婚系统
Chat_Channel_WorldTeam_Boss = 242 --世界组队boss
Chat_Channel_WorldTeam_BossRoom = 244 --世界组队boss房间
Chat_Channel_Fighting_HeroTower = 247 --战斗_英雄塔塔
Chat_Channel_DoubleTower = 252 --噩梦塔
Chat_Channel_DoubleTower_Room = 253 --噩梦塔房间
Chat_Channel_Dress_CastSoul = 258 --时装铸魂
Chat_Channel_Friends_MyCircle = 261 --好友-我的朋友圈
Chat_Channel_AUCTION_HOUSE = 267 --拍卖行
Chat_Channel_Friends_HotCircle = 268 --好友-热点朋友圈
Chat_Channel_Pasture = 269 --牧场
Chat_Channel_Pasture_Exit = 270 --牧场-退出
Chat_Channel_ShootArrow = 288 --活动-射箭
Chat_Channel_HouseInvest = 293 --活动-房产大亨
Chat_Channel_HOLIDAYVILLAGE = 296 --度假村
Chat_Channel_PVP_STRATEGIC = 298 --战略赛大厅
Chat_Channel_TeamConsume = 301 --活动-组团消费
Chat_Channel_ZongZi = 302 --活动-粽有不同
Chat_Channel_Union_Rank_N = 308 -- 联盟排行(未加入联盟)
Chat_Channel_Union_Scene = 312 -- 联盟场景
Chat_Channel_Union_Rank = 309 -- 联盟排行(已加入联盟)
Chat_Channel_Union_Hall = 310 -- 联盟大厅
Chat_Channel_Union_Blog = 311 -- 联盟日志

--断线重连后，需要切换到上一级界面的界面
T_G_UI_NEEDTOUPLEVEL = {
	Chat_Channel_Loadding,			--战斗加载
	Chat_Channel_Fighting,			--战斗
    Chat_Channel_Fighting_Team_Boss, --战斗_组队
    Chat_Channel_Fighting_Single, --战斗_单人
    Chat_Channel_Fighting_World_Boss, --战斗_世界BOSS
    Chat_Channel_Fighting_Normal, --战斗_竞技
    Chat_Channel_Fighting_Tower, --战斗_爬塔
    Chat_Channel_Fighting_Daily, --战斗_日常
    Chat_Channel_Fighting_Rank, --战斗_排位
	Chat_Channel_Room, 				--战斗房间
	Chat_Channel_Team_Copy_Room,	--副本房间
	Chat_Channel_Challenge,			--弹王
    Chat_Channel_Tower_Copy_Hall, --爬塔副本大厅
    Chat_Channel_Tower_Copy_Settlement, --爬塔副本结算
    Chat_Channel_Tower_Copy_Sweeping, --爬塔副本扫荡
    Chat_Channel_Tower_Copy_Resert, --爬塔副本重置
    Chat_Channel_Tower_Copy_Rank, --爬塔副本排行
    Chat_Channel_Tower_Copy_Reward, --爬塔副本奖励
    Chat_Channel_Daily_Copy_Hall, -- 日常副本大厅
    Chat_Channel_Daily_Copy_Settlement, -- 日常副本结算
    Chat_Channel_Fighting_League,
    Chat_Channel_Fighting_HeroTower, --战斗_英雄塔
}
--断线重连后，特定界面跳转到上一级界面所需记录的战斗模式（普通、副本、弹王等等）
RECONNECT_BATTLE_MODE = -1


---------------------------------------------
--宠物训练经验上限
PETTRAIN_MAX = 632940
--宠物最大数量
PET_MAX_NUM = 200
---------------------------------------------



----------------------------------------------
-- MsgBoxManager define
-- 消息组件管理相关定义
----------------------------------------------
--消息优先级
MSGBOXLEVEL_LOW = 1
MSGBOXLEVEL_NORMAL = 2
MSGBOXLEVEL_HIGH = 3
MSGBOXLEVEL_TIPBOX = 4
--消息种类
MSGBOXTYPE_CONFIRM = 1 --确定
MSGBOXTYPE_CONFIRMCANCEL = 2 --确定取消

MSGBOXTYPE_LOADING = 4 --加载
MSGBOXTYPE_TIPBOX = 5 --提示
MSGBOXTYPE_HAVEBG = 6 --确定／取消
MSGBOXTYPE_FIGHTANI = 7 --战斗力变化
MSGBOXTYPE_POPUPRESULT = 8 --操作结果
MSGBOXTYPE_DESIGNATION = 9 --获得成就
MSGBOXTYPE_EQUIPDRESSUP = 10 --提示穿上装备
MSGBOXTYPE_ANNOUNCEMENT = 11 --公告
MSGBOXTYPE_THANKFULSIGN = 12       --感恩打卡
MSGBOXTYPE_GAMEACTIVITY = 13     --活动
MSGBOXTYPE_WELFARE = 14          --福利
MSGBOXTYPE_NEWACTIVITY = 15    --一周年活动
MSGBOXTYPE_SUMMACTIVITY = 16    --暑假活动
MSGBOXTYPE_RETURNEEACTIVITY = 17    --回归活动
MSGBOXTYPE_RETURNACTIVITY = 18    --回流活动
MSGBOXTYPE_WELCOMEBACK = 19 --欢迎回来活动
MSGBOXTYPE_SEVENYEAR = 20 --七周年签到活动

MSGBOXTYPE_SEVENYEAR = 20 --七周年签到活动

--消息状态
MSGBOXSTATUS_INIT = 1
MSGBOXSTATUS_DOING = 2
MSGBOXSTATUS_DONE = 3
--响应类型
MSGBOXRESTYPE_TIMEOUT = 0
MSGBOXRESTYPE_CONFIRM = 1
MSGBOXRESTYPE_CANCEL = 2
--自定义界面配置
MSGBOXUICFG_CONFIRM = 1 --确认按钮的文本重命名，tCustomUIConfig[MSGBOXUICFG_CONFIRM]
MSGBOXUICFG_CANCEL = 2 --取消按钮的文本重命名
MSGBOXUICFG_USEFREETXT = 3 --使用富文本框(富文本框提供自定义字体大小颜色，文本中夹杂图片等功能)
MSGBOXUICFG_FONTSIZE = 4 --设置内容的字体大小
MSGBOXUICFG_OTHERDATA = 5 --其他数据

----------------------------------------------
-- PopupMenu define
-- 弹出菜单相关定义
----------------------------------------------
--弹出菜单显示的字符串
g_tPopupMenuString = {}
--弹出菜单的可变选项
POPUPMENU_VARIABLE = 999
g_tPopupMenuString[POPUPMENU_VARIABLE] = ""
--弹出菜单的添加好友选项
POPUPMENU_ADD = 1
g_tPopupMenuString[POPUPMENU_ADD] = LocalStrings.POPUPMENUSTRING1
--弹出菜单的移至黑名单选项
POPUPMENU_BLACKLIST = 2
g_tPopupMenuString[POPUPMENU_BLACKLIST] = LocalStrings.POPUPMENUSTRING2
--弹出菜单的私聊选项
POPUPMENU_CHAT = 3
g_tPopupMenuString[POPUPMENU_CHAT] = LocalStrings.POPUPMENUSTRING3
--弹出菜单的删除好友选项
POPUPMENU_DELETEFRIEND = 4
g_tPopupMenuString[POPUPMENU_DELETEFRIEND] = LocalStrings.POPUPMENUSTRING4
--弹出菜单的降职选项
POPUPMENU_DEMOTED = 5
g_tPopupMenuString[POPUPMENU_DEMOTED] = LocalStrings.POPUPMENUSTRING5
--弹出菜单的开除选项
POPUPMENU_FIRED = 6
g_tPopupMenuString[POPUPMENU_FIRED] = LocalStrings.POPUPMENUSTRING6
--弹出菜单的移至好友选项
POPUPMENU_FRIENDLIST = 7
g_tPopupMenuString[POPUPMENU_FRIENDLIST] = LocalStrings.POPUPMENUSTRING7
--弹出菜单的查看资料选项
POPUPMENU_INFO = 8
g_tPopupMenuString[POPUPMENU_INFO] = LocalStrings.POPUPMENUSTRING8
--弹出菜单的发送邮件选项
POPUPMENU_MAIL = 9
g_tPopupMenuString[POPUPMENU_MAIL] = LocalStrings.POPUPMENUSTRING9
--弹出菜单的升职选项
POPUPMENU_PROMOTION = 10
g_tPopupMenuString[POPUPMENU_PROMOTION] = LocalStrings.POPUPMENUSTRING10
--弹出菜单的确定选定选项
POPUPMENU_SURESELECTED = 11
g_tPopupMenuString[POPUPMENU_SURESELECTED] = LocalStrings.POPUPMENUSTRING11
--弹出菜单的踢出房间选项
POPUPMENU_KICKEDOUT = 12
g_tPopupMenuString[POPUPMENU_KICKEDOUT] = LocalStrings.POPUPMENUSTRING12
--弹出菜单的"转让会长"选项
POPUPMENU_TRANSFER = 13
g_tPopupMenuString[POPUPMENU_TRANSFER] = LocalStrings.POPUPMENUSTRING13
--弹出菜单的"入会申请"选项
POPUPMENU_COMMUNITY1 = 14
g_tPopupMenuString[POPUPMENU_COMMUNITY1] = LocalStrings.COMMUNITY1
--弹出菜单的"修改宣言"选项
POPUPMENU_COMMUNITY2 = 15
g_tPopupMenuString[POPUPMENU_COMMUNITY2] = LocalStrings.COMMUNITY2
--弹出菜单的"公会升级"选项
POPUPMENU_COMMUNITY3 = 16
g_tPopupMenuString[POPUPMENU_COMMUNITY3] = LocalStrings.COMMUNITY3
--弹出菜单的"公会设置"选项
POPUPMENU_COMMUNITY4 = 17
g_tPopupMenuString[POPUPMENU_COMMUNITY4] = LocalStrings.COMMUNITY4
--弹出菜单的"群发邮件"选项
POPUPMENU_COMMUNITY5 = 18
g_tPopupMenuString[POPUPMENU_COMMUNITY5] = LocalStrings.COMMUNITY5
--弹出菜单的"退出公会"选项
POPUPMENU_COMMUNITY6 = 19
g_tPopupMenuString[POPUPMENU_COMMUNITY6] = LocalStrings.COMMUNITY6
--弹出菜单的"查看大图"选项
POPUPMENU_SPACE1 = 20
g_tPopupMenuString[POPUPMENU_SPACE1] = LocalStrings.SPACE22
--弹出菜单的"设置头像"选项
POPUPMENU_SPACE2 = 21
g_tPopupMenuString[POPUPMENU_SPACE2] = LocalStrings.SETTING_TITLE..LocalStrings.PHOTO
--弹出菜单的"删除图片"选项
POPUPMENU_SPACE3 = 22
g_tPopupMenuString[POPUPMENU_SPACE3] = LocalStrings.POPUPMENUSTRING4
--弹出菜单的"拍照上传"选项
POPUPMENU_SPACE4 = 23
g_tPopupMenuString[POPUPMENU_SPACE4] = LocalStrings.SPACE23
--弹出菜单的"本地上传"选项
POPUPMENU_SPACE5 = 24
g_tPopupMenuString[POPUPMENU_SPACE5] = LocalStrings.SPACE24
--弹出菜单的"会员贡献"选项
POPUPMENU_COMMUNITY7 = 25
g_tPopupMenuString[POPUPMENU_COMMUNITY7] = LocalStrings.COMMUNITYINFO104
--弹出菜单的"设为参战"选项
POPUPMENU_HERO1 = 26
g_tPopupMenuString[POPUPMENU_HERO1] = LocalStrings.LEAGUE23
--弹出菜单的"设为候选"选项
POPUPMENU_HERO2 = 27
g_tPopupMenuString[POPUPMENU_HERO2] = LocalStrings.LEAGUE24
--弹出菜单的"查看资料"选项
POPUPMENU_HERO3 = 28
g_tPopupMenuString[POPUPMENU_HERO3] = LocalStrings.POPUPMENUSTRING8
--弹出菜单的"邀请进入"选项
POPUPMENU_HERO4 = 29
g_tPopupMenuString[POPUPMENU_HERO4] = LocalStrings.LEAGUE25
--弹出菜单的"踢出队伍"选项
POPUPMENU_HERO5 = 30
g_tPopupMenuString[POPUPMENU_HERO5] = LocalStrings.LEAGUE26
--弹出菜单的"设副队长"选项
POPUPMENU_HERO6 = 31
g_tPopupMenuString[POPUPMENU_HERO6] = LocalStrings.LEAGUE57
--弹出菜单的"设为队员"选项
POPUPMENU_HERO7 = 32
g_tPopupMenuString[POPUPMENU_HERO7] = LocalStrings.LEAGUE58
--弹出菜单的"职位任命"选项
POPUPMENU_COMMUNITY8 = 33
g_tPopupMenuString[POPUPMENU_COMMUNITY8] = LocalStrings.COMMUNITYINFO130
--弹出菜单的"公会邀请"选项
POPUPMENU_COMMUNITY9 = 34
g_tPopupMenuString[POPUPMENU_COMMUNITY9] = LocalStrings.COMMUNITYINFO238
--弹出菜单的"转让盟主"选项
POPUPMENU_UNION1 = 35
g_tPopupMenuString[POPUPMENU_UNION1] = LocalStrings.UNION_TEXT1[27]


--普通房间模式描述
g_tRoomModeDesc = {LocalStrings.HALL_MATCH_1,LocalStrings.ENTERTAINMENT_MATCH_5,LocalStrings.ENTERTAINMENT_MATCH_4,LocalStrings.ENTERTAINMENT_MATCH_2,LocalStrings.ENTERTAINMENT_MATCH_1,LocalStrings.ENTERTAINMENT_MATCH_3,LocalStrings.INN6,LocalStrings.BATTLE_MODEL_RANK,LocalStrings.COMMUNITYWARGIFT_TEXT1,LocalStrings.COMMUNITYWARGIFT_TEXT2,LocalStrings.COMMUNITYWARGIFT_TEXT3,LocalStrings.HALL_MATCH_2,LocalStrings.PVP_STRATEGIC_TEXT1[1]}
g_tRoomModeDesc[32] = LocalStrings.COMMUNITYWARGIFT_TEXT1
g_tRoomModeDesc[33] = LocalStrings.COMMUNITYWARGIFT_TEXT2
----------------------------------------------
-- WndPlayer Equipment define
-- 玩家装备相关定义
----------------------------------------------
--装备类型识别码
g_tEquipmentIndex = {EQUIP_HEAD = 1,EQUIP_FACE = 2,EQUIP_BODY = 3,EQUIP_WEAPON = 4,EQUIP_WING = 5,EQUIP_RING1 = 6,EQUIP_RING2 = 7,EQUIP_NECKLACE = 8}
--装备类型描述
g_tEquipmentDesc = {LocalStrings.HEAD,LocalStrings.FACE,LocalStrings.BODY,LocalStrings.WEAPON,LocalStrings.WING,LocalStrings.RING,LocalStrings.RING,LocalStrings.NECKLACE}
----------------------------------------------
--商城物品类型相关(商品类型：1:推荐 2:武器 3:头饰 4：脸谱 5：衣服 6：其他 7：兑换)
g_tBuyType = {TYPE_TUIJIAN = 1,TYPE_WEAPON = 2,TYPE_HEAD = 3,TYPE_FACE = 4,TYPE_BODY = 5, TYPE_OTHER = 6, DUIHUAN = 7,CUOXIAO = 8,}
----------------------------------------------
--宠物列表相关常量定义
PET_LIST_LENGTH = 20
----------------------------------------------
-- Animation define
-- 动画相关定义
----------------------------------------------
IWCO_BATTLEBOY = "battleBoy"
IWCO_BATTLEGIRL = "battleGirl"
IWCO_BATTLEEFFECT = "battleEffect"
IWCO_BATTLEFACE = "face"
IWCO_BATTLEEFFICIENTS = "battleEfficients"
IWCO_SHOPEFFICIENTS = "shopEfficients"
IWCO_SHOPBOY = "shopBoy"
IWCO_SHOPGIRL ="shopGirl"
IWCO_ISLAND = "island"
IWCO_TEACH = "teach"
IWCO_NEWTEACH = "teach2"
IWCO_EGG = "egg"
IWCO_STRENGTHEN = "strengthen"
IWCO_WING = "Wing"
IWCO_BAPTIZE = "baptize"
IWCO_BOSS = "boss"
IWCO_MONSTER1 = "monster1"
IWCO_MONSTER2 = "monster2"
IWCO_BOSS21 = "boss2-1"
IWCO_BOSS22 = "boss2-2"
IWCO_BOSS31 = "boss3-1"
IWCO_BOSS32 = "boss3-2"
IWCO_BOSS4 = "boss4"
IWCO_BOSS4_TORNADO = "tornado"
IWCO_MONSTER3 = "monster3"
IWCO_MONSTEREFFICIENTS = "monsterEfficient"
IWCO_BOSS5 =  "boss5"
IWCO_MONSTER5 = "monster5"
IWCO_BOSS6 = "boss6"
IWCO_PET1 = "pet1"
IWCO_PET2 = "pet2"
IWCO_PET3 = "pet3"
IWCO_PET4 = "pet4"
IWCO_PET5 = "pet5"
IWCO_PET6 = "pet6"
IWCO_PET7 = "pet7"
IWCO_PET8 = "pet8"
IWCO_PET9 = "pet9"
IWCO_PET10 = "pet10"
IWCO_PET11 = "pet11"
IWCO_PET12 = "pet12"
IWCO_PET13 = "pet13"
IWCO_PET14 = "pet14"
IWCO_PET15 = "pet15"
IWCO_PET16 = "pet16"
IWCO_PET17 = "pet17"
IWCO_PET18 = "pet18"
IWCO_PETEFFECTS = "peteffects"
IWCO_PETUI = "uieffect"
WANI_IWCO_WORLDBOSS1 = "worldboss"
IWCO_FIRST = "first"
IWCO_FIGURE_BOY = "normalBoy"
IWCO_FIGURE_GIRL = "normalGirl"

--按钮类型定义
ISLAND_BTNTYPE_BUILDING = 0 --建筑按钮
ISLAND_BTNTYPE_LEFT = 1 --左菜单按钮
ISLAND_BTNTYPE_UP = 2 --顶部菜单按钮
ISLAND_BTNTYPE_RIGHT = 3 --右菜单按钮
ISLAND_BTNTYPE_BAG = 4 --背包按钮
ISLAND_BTNTYPE_NPC = 5 --NPC按钮
ISLAND_BTNTYPE_RECHARGE = 6 --快捷购买
ISLAND_BTNTYPE_EXTEND = 19 --右菜单扩展按钮

--功能开放表的按钮的id
ISLAND_BUILDING_BOSSMAP = 1     --组队副本
ISLAND_BUILDING_SINGLEMAP = 2   --单人副本
ISLAND_BUILDING_TOWER = 3       --爬塔
ISLAND_BUILDING_RANK = 4        --排行榜
ISLAND_BUILDING_HALL = 5        --竞技场
ISLAND_BUILDING_DAILYMAP = 6    --日常副本
ISLAND_BUILDING_SHOP = 7        --商城
ISLAND_BUILDING_MARRY = 8       --结婚
ISLAND_BUILDING_COMMUNITY = 9   --公会
ISLAND_BUILDING_WORLDBOSSMAP = 10   --世界Boss
ISLAND_BUILDING_EQUIT_LOTTERY = 11  --装备抽奖

ISLAND_LEFT_MESSAGE = 12        --公告
ISLAND_LEFT_MAIL = 13           --邮件
ISLAND_LEFT_FRIEND = 14         --好友
ISLAND_LEFT_TEACH = 15          --指引
ISLAND_LEFT_LIBRARY = 15        --图鉴
ISLAND_LEFT_SETTING = 16        --设置
ISLAND_UP_RECHARGE = 17         --vip
ISLAND_UP_ATTENDANCE = 18       --签到
ISLAND_UP_FUND = 19             --基金
ISLAND_UP_ACTIVITY = 20         --活跃度
ISLAND_UP_EVENT = 21            --活动
ISLAND_UP_KING = 22             --弹皇
ISLAND_UP_QUALIFYING = 23       --排位赛
ISLAND_UP_BINDING = 55          --绑定
ISLAND_BUILDING_LOTTERY = 61        --爱心
ISLAND_UP_BLESS = 64            --祈福
ISLAND_UP_FIRST_RECHARGE = 65   --首充
ISLAND_UP_MONTHCARD = 66        --月卡
ISLAND_UP_MATCH = 68            --比赛
ISLAND_UP_WELFARE = 69          --福利
ISLAND_UP_LEAGUE = 71           --英雄联赛
ISLAND_UP_CARD_WELFARE = 75     --福利卡
ISLAND_LEFT_HELPER = 85         --助手
ISLAND_LEFT_4399 = 90           --4399
ISLAND_UP_SHOP = 92             --商店
ISLAND_UP_LBS = 95              --LBS
ISLAND_UP_CHARM = 96            --魅力
ISLAND_LEFT_FB = 100            --FB
ISLAND_UP_MTO = 101             --MTO
ISLAND_UP_ELITE_SHOP = 103      --精英商城
ISLAND_LEFT_GROUP = 102            --群
ISLAND_UP_WISHING_WELL = 113    --许愿池
ISLAND_BUILDING_TREASURE = 114        --挖宝
ISLAND_UP_RUNE = 115            --符文抽奖
ISLAND_BUILDING_REVELRY1 = 127        --全民狂欢
ISLAND_LEFT_SURVEY = 129            --问卷
ISLAND_BUILDING_HOME = 131        --家园
ISLAND_BUILDING_REVELRY2 = 132        --全民狂欢
ISLAND_BUILDING_TRADEWOMAN = 136        --神秘女商人
ISLAND_UP_PRAY = 138            --祈愿
ISLAND_BUILDING_ESCAPE = 139        --大逃杀
ISLAND_LEFT_BBS = 140            --BBS
ISLAND_UP_SEVEN_DAY = 143            --七天乐
ISLAND_UP_FOOT_BALL = 147            --世界杯
ISLAND_UP_WORLDTEAM_BOSS = 148            --世界组队boss
ISLAND_UP_BACK_ACTIVITY = 149            --回归活动
ISLAND_BUILDING_DOUBLE_TOWER = 153            --噩梦塔
ISLAND_UP_QUESTION = 154            --问答
ISLAND_UP_ONE_YUAN = 173        --一元充
DOUBLE_SEVEN_CONFREE = 177       --七夕
NATIONAL_FESTIVAL = 183         --国庆签到
NATIONAL_ANSWER = 184           --答题
PEOPLESHOP = 186                --全民购物
TREASURESEARCH = 188                --寻宝
NEWYEARDAY = 189                --元旦
EVERYDAYBUY = 190                --每日必购
FEBRUARYNEWYEAR = 192           --新年活动
FOURSTARS = 195           --四象星宿
BLINDBOX = 196           --盲盒
DOLLMACHINE = 197 --娃娃机
ACTIVITYLIMITLOGIN = 198 --限时登录
ISLAND_BUILDING_ESCAPE = 199            --小屋
ISLAND_BUILDING_HOLIDAYVILLAGE = 221            --度假村
ISLAND_UP_YANGLEGEYANG = 228            --消消乐

ACTIVITYNEWRECHARGE = 199 --新首冲
REBACKACTIVITY = 200 --回归活动
MOUNTSTONE = 201 --坐骑灵石
ISLAND_ASSISTSKILL = 204           --助战技能
BLESS_LUCKY_DRAW = 205          --祈福抽獎
FIGHT_ACTIVITY = 206 --战力飞升
RISE_ACTIVITY = 207 --崛起之路
HORARY_ACTIVITY = 208 --占星
MIDFESTIVAL_ACTIVITY = 209 --中秋活动
FISH_ACTIVITY = 210 --钓鱼活动
PELLET_ACTIVITY = 211 --弹珠活动
HOUSEINVEST_ACTIVITY = 213 --房产投资活动

DECORATIONS_ACTIVITY = 7030 --张灯结彩
WATERCOUNTRY_ACTIVITY = 7031 --水之国度
YEARMONSTER_ACTIVITY = 7035 --年兽大作战
NEWYEARWISH_ACTIVITY = 7033 --新年愿望
BEATENGINEER_ACTIVITY = 7034 --暴揍策划
ALCHEMY_ACTIVITY = 7036 --丹道修真
BEATMICE_ACTIVITY = 7037 --欢乐地鼠
BLUEPRIVILEGE_ACTIVITY = 7038 --蓝钻特权
QQHALLPRIVILEGE_ACTIVITY = 7039 --大厅特权
SETCIECLE_ACTIVITY = 7046 --套圈圈
GARDEN_ACTIVITY = 7047 --小岛果园
CAFFEE_ACTIVITY = 7048 --咖啡大师
BOWLING_ACTIVITY = 7049 --保龄球
YEARPLAYER_ACTIVITY = 7050 --年度玩家
WATERMELON_ACTIVITY = 7051 --夏日西瓜
SECRETTOWER_ACTIVITY = 7052 --秘境闯塔
MONEYTREE_ACTIVITY = 7054 --摇钱树
BILLIARDBALL_ACTIVITY = 7055 --台无止境
DRESSGIVE_ACTIVITY = 7056 --时装惠送
CRAZY_GASHAPON_ACTIVITY = 7057 --疯狂扭蛋
MIDNIGHTDINER_ACTIVITY = 7058 --深夜食堂
GOPHERBALL_ACTIVITY = 7059 --全垒打
NEWCUTELIST_ACTIVITY = 7060 --新萌榜
BEINGIMMORTAL_ACTIVITY = 7061 --修仙传
WORSHIPGOD_ACTIVITY = 7062 --拜财神
CALABASH_ACTIVITY = 7063 --葫芦娃
SPRINGOUTING_ACTIVITY = 7065 --春游踏青
THANKFULSIGN_ACTIVITY = 7067 --感恩打卡
WELCOMEBACK_ACTIVITY = 7068 --欢迎回来
BEATBALLOON_ACTIVITY = 7070 --打气球
DAZZLERANK_ACTIVITY = 7071 --耀眼榜
SEAFARROAD_ACTIVITY = 7072 --航海之路
SUPER_SPECIAL_ACTIVITY = 7073 --超值特惠
TEAMCONSUME_ACTIVITY = 7074 --组团消费
CLIMBTREE_ACTIVITY = 7075 --爬藤比赛
SUMMERSURF_ACTIVITY = 7076 --夏日冲浪
PLANETSEARCH_ACTIVITY = 7077 --行星探索
SEVENYEAR_ACTIVITY = 7078 --七周年签到
ZONGZI_ACTIVITY = 7079 --粽有不同
SPECIFICSALES_ACTIVITY = 7080 --限定活动(特殊售卖)
TRAMPOLINE_ACTIVITY = 7081 --欢乐蹦床
GOLFBALL_ACTIVITY = 7082 --高尔夫球
WISHING_BOTTLE_ACTIVITY = 7083 --许愿瓶
DETECTIVE_ACTIVITY = 7084 --贝克侦探所
GONGANDDRUM_ACTIVITY = 7086 --锣鼓喧天
GOLD_MINER_ACTIVITY = 7087 --黄金矿工
CHESS_ACTIVITY = 7088 --奕仙棋
DEEPSEA_ACTIVITY = 7089 --深海寻宝
AUTUMNCAMP_ACTIVITY = 7090 --秋日露营
HOTBASKETBALL_ACTIVITY = 7091 --热血篮球
FLY_KITES_ACTIVITY = 7092 --放风筝
THROWPOT_ACTIVITY = 7093 --投壶
CATCHFISH_ACTIVITY = 7094 --捕鱼大王
BIKEMATCH_ACTIVITY = 7095 --自行车赛
LASHTOP_ACTIVITY = 7096 --抽陀螺
KICKINGBIRDIE_ACTIVITY = 7097 --踢毽子
MAGICCLASSROOM_ACTIVITY = 7098 --魔法课堂
MAKESNOWMAN_ACTIVITY = 7099 --堆雪人
PIANIST_ACTIVITY = 7100 --钢琴演奏家
CERAMIC_WORKSHOP_ACTIVITY = 7101 --陶艺工坊
WEIGHTLIFTING_ACTIVITY = 7102 --举重比赛
ARCTIC_EXPLORATION_ACTIVITY = 7103 --极地探险
BUILDING_BLOCKS_ACTIVITY = 7104 --拼装积木
SWORD_CASTING_MASTER_ACTIVITY = 7105 --铸剑神匠
BOATING_LAKE_ACTIVITY = 7106 --泛舟游湖
BLOW_BUBBLES_ACTIVITY = 7107 --吹泡泡
PICKTEA_ACTIVITY = 7108 --一起来采茶
AFFORESTATION_ACTIVITY = 7109 --植树造林
POTIONS_REFININ_ACTIVITY = 7110 --魔药炼制
JEWELRY_ACTIVITY = 7111 --首饰大师
HOLY_HAND_ACTIVITY = 7112 --丹青圣手
STRING_LIFE_ACTIVITY = 7113 --人生一串
DRAGON_BALL_ACTIVITY = 7114 --寻找龙珠
CATHOUSE_ACTIVITY = 7115 --猫咪屋
CAROUSEL_AMUSEMENT_ACTIVITY = 7116 --木马游乐园
CRABBER_ACTIVITY = 7117 --捕蟹船
JADE_TOUCH_ACTIVITY = 7118 --点石成翡
LEIZHUZHEN_ACTIVITY = 7119 --颠倒雷竹阵
COLDDRINK_ACTIVITY = 7124 --清凉冰饮
FOOTBALL_SHOOT_ACTIVITY = 7133 --射门大战
GROW_GIFT_ACTIVITY = 7134 --成长礼包
HAPPY_MIDAUTUMN_ACTIVITY = 7137 --欢度中秋
WEEKEND_SPECIAL_ACTIVITY = 7138 --周末特惠
MYSTERIOUS_SHOP_ACTIVITY = 7144 --双11神秘商店
ZOO_SIGHTSEEING_ACTIVITY = 7147 --动物园观光
RABBIT_GIFT_ACTIVITY = 7170 --福兔送礼
WEEKEND_SPECIAL_ACTIVITY2 = 7182 --周末特惠2
LUCKY_FLIP_ACTIVITY = 7183 --幸运翻牌
BRAVING_TOWER_ACTIVITY = 7185 --勇闯高塔
FIGHT_ACTIVITY1 = 7200 --7018复制
FIGHT_ACTIVITY2 = 7201 --7018复制

EIGHTYEAR_ACTIVITY = 900000        --8周年庆典

g_tAloneActivity = {WATERCOUNTRY_ACTIVITY, DECORATIONS_ACTIVITY, YEARMONSTER_ACTIVITY, NEWYEARWISH_ACTIVITY, BEATENGINEER_ACTIVITY, ALCHEMY_ACTIVITY, BEATMICE_ACTIVITY, SETCIECLE_ACTIVITY, GARDEN_ACTIVITY, CAFFEE_ACTIVITY, BOWLING_ACTIVITY, YEARPLAYER_ACTIVITY, WATERMELON_ACTIVITY, SECRETTOWER_ACTIVITY, MONEYTREE_ACTIVITY, BILLIARDBALL_ACTIVITY, DRESSGIVE_ACTIVITY, CRAZY_GASHAPON_ACTIVITY, MIDNIGHTDINER_ACTIVITY, GOPHERBALL_ACTIVITY, NEWCUTELIST_ACTIVITY, BEINGIMMORTAL_ACTIVITY, WORSHIPGOD_ACTIVITY, CALABASH_ACTIVITY, SPRINGOUTING_ACTIVITY, THANKFULSIGN_ACTIVITY, WELCOMEBACK_ACTIVITY, BEATBALLOON_ACTIVITY, DAZZLERANK_ACTIVITY, SEAFARROAD_ACTIVITY, TEAMCONSUME_ACTIVITY, SUPER_SPECIAL_ACTIVITY, CLIMBTREE_ACTIVITY, SUMMERSURF_ACTIVITY, PLANETSEARCH_ACTIVITY, SEVENYEAR_ACTIVITY, ZONGZI_ACTIVITY, SPECIFICSALES_ACTIVITY, TRAMPOLINE_ACTIVITY, GOLFBALL_ACTIVITY, WISHING_BOTTLE_ACTIVITY, DETECTIVE_ACTIVITY, GONGANDDRUM_ACTIVITY, GOLD_MINER_ACTIVITY, DEEPSEA_ACTIVITY, CHESS_ACTIVITY, AUTUMNCAMP_ACTIVITY, HOTBASKETBALL_ACTIVITY, FLY_KITES_ACTIVITY, THROWPOT_ACTIVITY, CATCHFISH_ACTIVITY, BIKEMATCH_ACTIVITY, LASHTOP_ACTIVITY, KICKINGBIRDIE_ACTIVITY, MAGICCLASSROOM_ACTIVITY, MAKESNOWMAN_ACTIVITY, PIANIST_ACTIVITY, CERAMIC_WORKSHOP_ACTIVITY, WEIGHTLIFTING_ACTIVITY, ARCTIC_EXPLORATION_ACTIVITY, BUILDING_BLOCKS_ACTIVITY, SWORD_CASTING_MASTER_ACTIVITY, BOATING_LAKE_ACTIVITY, BLOW_BUBBLES_ACTIVITY, PICKTEA_ACTIVITY, AFFORESTATION_ACTIVITY, POTIONS_REFININ_ACTIVITY, JEWELRY_ACTIVITY, HOLY_HAND_ACTIVITY, STRING_LIFE_ACTIVITY, DRAGON_BALL_ACTIVITY, CATHOUSE_ACTIVITY, CAROUSEL_AMUSEMENT_ACTIVITY, CRABBER_ACTIVITY, JADE_TOUCH_ACTIVITY, LEIZHUZHEN_ACTIVITY, COLDDRINK_ACTIVITY, FOOTBALL_SHOOT_ACTIVITY, GROW_GIFT_ACTIVITY, HAPPY_MIDAUTUMN_ACTIVITY, WEEKEND_SPECIAL_ACTIVITY, MYSTERIOUS_SHOP_ACTIVITY, ZOO_SIGHTSEEING_ACTIVITY, RABBIT_GIFT_ACTIVITY, WEEKEND_SPECIAL_ACTIVITY2, LUCKY_FLIP_ACTIVITY, BRAVING_TOWER_ACTIVITY, FIGHT_ACTIVITY1, FIGHT_ACTIVITY2}

ISLAND_RIGHT_BAG = 24           --背包
ISLAND_RIGHT_ITEM = 25          --道具
ISLAND_RIGHT_STRENGTHEN = 26    --强化
ISLAND_RIGHT_PET = 27           --宠物
ISLAND_RIGHT_MOUNT = 28         --坐骑
ISLAND_RIGHT_TASK = 29          --任务
ISLAND_RIGHT_EXTEND = 73        --扩展
ISLAND_RIGHT_HUISHOU = 29       --回收
ISLAND_RIGHT_RUNE_MAIN = 116    --符文主界面
ISLAND_RIGHT_PHANTOM = 118      --幻化
ISLAND_RIGHT_AWAKEN = 120       --觉醒
ISLAND_RIGHT_SHARE = 125       --推广员
ISLAND_RIGHT_PLAYER = 126       --角色
ISLAND_RIGHT_FOOTMARK = 141       --足迹
ISLAND_BUILDING_KID = 145       --小屋
ISLAND_RIGHT_PROFESSION = 152   -- 职业
ISLAND_UP_MAGIC_STONE = 161     --幻石
ISLAND_UP_INVESTREBATE = 162     --投资返利
ISLAND_UP_DRESS_CASTSOUL = 163     --时装铸魂
ISLAND_UP_HAPPYSHAKE = 164     --全民摇摇乐
ISLAND_UP_CRAZY_DOUBLING = 176     --疯狂翻倍
ISLAND_UP_AUCTION_HOUSE = 178     --拍卖行
ISLAND_UP_OPPO_AMBERPLAYER = 185 --OV琥珀大玩家
ISLAND_RIGHT_COUPLE = 225          --夫妻关系
ISLAND_RIGHT_UNION = 230          --联盟
ISLAND_UP_FLOWER_RANK = 233     --鲜花榜排行

ISLAND_EXTEND_PRACTICE = 72     --修炼
ISLAND_EXTEND_CARD = 76         --卡牌
ISLAND_EXTEND_LBS = 77          --LBS
ISLAND_EXTEND_CHARM = 78        --魅力
ISLAND_EXTEND_WARDROBE = 79     --衣橱
ISLAND_EXTEND_ASCEND = 80       --升阶

ISLAND_NPC_TEACHER = 30         --师徒
ISLAND_NPC_INSTRUCTOR = 53      --教官

BAG_ACHIEV = 31                 --成就
BAG_COMPOSE = 32                --合成
BAG_SELL = 33                   --出售

QUICK_DIAMOND = 34              --钻石
QUICK_GOLD = 35                 --金币
QUICK_POWER = 36                --体力

TASK_FEEDER =   37             --支线任务
TASK_DAILY =   38              --日常任务
TASK_MAIN =   39               --主线任务

STRENGTHEN_STRENGTHEN = 40  --强化
STRENGTHEN_UPSTAR = 41      --升星
STRENGTHEN_TRANSFER = 42    --转移
STRENGTHEN_INLAY = 43       --镶嵌

PET_LEVELUP = 44            --宠物升级
PET_EVOLVE = 45             --宠物进化
PET_EGG = 46                --宠物砸蛋
PET_SKILL = 47              --宠物技能
PET_REVIVAL = 48            --宠物重生

MOUNT_LEVELUP = 49           --坐骑升级
MOUNT_EVOLVE = 50            --坐骑进化

BAG_FASHION = 51             --背包时装
BAG_ATTRIBUTE = 52           --背包属性

ELITE_COPY = 57              --精英副本

DEVIL_COPY = 81              --恶魔副本

TABOO_BATTLE = 117          --禁忌之地
PROFESSION_SECOND = 191     --职业二转
SKILL_ASSISTSKILL = 204     --助战技
MOUNT_LOTTERY = 196         --坐骑抽奖
PHANTOM_LOTTERY = 197       --皮肤抽奖
FOOT_LOTTERY = 198          --足迹抽奖
LOTTERY_SHOP = 206          --召唤商店
FUNC_CHAT_SEND = 200        --发送聊天
ACTIVITY_SHOOT_ARROW = 212          --活动-射箭
PET_EQUIPMENT_LOTTERY = 224          --宠物装备召唤

COUPLE_MARRIAGE = 226               --夫妻姻缘
COUPLE_HEGEMONY = 227               --夫妻争霸

----------------------------------------------
WndBottomBarBtnExtendIndex = 
{
    -- [ISLAND_RIGHT_BAG] = "Bag",
    [ISLAND_EXTEND_CHARM] = "Meili",
    [ISLAND_BUILDING_RANK] = "Paihang",
}

WndBottomBarBtnIndex = 
{
    -- [ISLAND_RIGHT_BAG] = "Bag",
    [ISLAND_EXTEND_CHARM] = "Meili",
    [ISLAND_BUILDING_RANK] = "Paihang",
    
    -- [ISLAND_RIGHT_BAG] = "Bag",
    [ISLAND_RIGHT_TASK] = "Task",
    [ISLAND_UP_BLESS] = "Bless",
    [ISLAND_RIGHT_EXTEND] = "More",
    -- [ISLAND_EXTEND_ASCEND] = "ShengGuang",
    [ISLAND_EXTEND_CARD] = "Kapai",
    [ISLAND_EXTEND_PRACTICE] = "Practice",
    [ISLAND_RIGHT_MOUNT] = "Mount",
    [ISLAND_RIGHT_PET] = "Pet",
    [ISLAND_RIGHT_STRENGTHEN] = "Strong",
    [ISLAND_RIGHT_ITEM] = "Item",
    [ISLAND_LEFT_FRIEND] = "Friend",
    [ISLAND_RIGHT_RUNE_MAIN] = "Rune",
    [ISLAND_RIGHT_PHANTOM] = "Phantom",
    [ISLAND_RIGHT_AWAKEN] = "Awaken",
    [ISLAND_RIGHT_SHARE] = "Share",
    [ISLAND_RIGHT_PLAYER] = "Player",
    [ISLAND_RIGHT_FOOTMARK] = "FootMark",
    [ISLAND_RIGHT_PROFESSION] = "Profession",
    [ISLAND_UP_DRESS_CASTSOUL] = "CastSoul",
    [ISLAND_RIGHT_COUPLE] = "Couple",
    [ISLAND_RIGHT_UNION] = "Union",
}
----------------------------------------------
-- resource path define 
-- 资源位置相关定义
----------------------------------------------
--地图资源位置
RESOURCE_MAP_PATH = "map/"
RESOURCE_MAP_TITLE_PATH = "ui/map/"
--子弹爆炸位置
RESOURCE_BULLET_EXPLODE = "image/battle/explode/"

--怪物路径
MONSTER_IMAGE_PATH = "battle/head/"
----------------------------------------------
-- Task define
-- 任务相关定义
----------------------------------------------
--任务类型
TASKTYPE_MAIN = 1 --主线任务
TASKTYPE_DAILY = 2 --每日任务
--任务状态
TASKSTATUS_DOING = 0 --进行中
TASKSTATUS_TOSUBMIT = 1 --已完成，待提交
TASKSTATUS_COMPLETED = 2 --已提交完成
TASKSTATUS_STALE = 3 --已过期的任务
----------------------------------------------
-- Item define
-- 物品类型定义
----------------------------------------------
ITEM_TYPE_WEAPON_THROW = 0
ITEM_TYPE_WEAPON_SHOOTING = 1
ITEM_TYPE_DRESS_UP = 2
ITEM_TYPE_FACE = 3
ITEM_TYPE_HAIR = 4
ITEM_TYPE_PROP = 5
ITEM_TYPE_SYNTHESIS = 6
ITEM_TYPE_SET = 7
ITEM_TYPE_OTHER = 8
ITEM_TYPE_GIFT_BAG = 10

----------------------------------------------
-- Music define
-- 保存音频开关信息的关键字
----------------------------------------------
MUSIC_DATA = "MusicData"            --保存的关键字
BG_MUSIC_STATE = "bgMusicState"     --背景音乐
EFFECT_STATE = "effectState"        --音效

----------------------------------------------
-- Constants define
-- 常用的常量定义
----------------------------------------------
INT32_MAX = 2147483647

--UDID加密秘钥
ENCRYPT_KEY = "pifnwkjdhn"
--\0

----------------------------------------------
-- JumpTo define
-- 界面跳转相关定义
----------------------------------------------
--参数说名：
-- uiType:界面类型 (1:场景界面，2:窗口界面，3:普通战斗房间界面，4:副本战斗房间界面，5:带标签的窗口界面 6:特殊弹窗 7:特殊处理 8：公会系统)
-- 类型为5（带标签的窗口界面）的界面需要统一实现函数jumpTo(nIndex)
-- uiName:界面lua表名，战斗类型界面填空字符串""即可
-- uiParam:界面参数（例如：1战斗房间界面需要保存所创建的战斗房间的相关参数，2带标签的窗口界面的标签索引。没有填空表{}即可）
-- uiChannelID:界面聊天频道ID，用来判断要跳转的界面是否已经开启
-- uiOpenID:与功能开发表中的ID对应：0时，是没有开启限制
-- JUMP_LIST中元素的key值与界面ID一致，界面ID分为主ID和子ID，如果界面为主界面则界面子ID为0，
JUMP_LIST = {
	id_2  = { uiType = 1, uiName = "SceneHall", uiParam = {},uiChannelID = 2, uiOpenID = 5},  --游戏大厅
    id_8  = { uiType = 6, uiName = "WndStore", func = "WndStore:showStoreByType(1)",uiParam={false},uiChannelID=8, uiOpenID = 5},  --竞技商店
--  id_12 = { uiType = 6, uiName = "SceneCopy", func = "SceneCopy:showScene(1,nil,nil,true)", uiParam={false},uiChanelID=12}, --单人副本大厅
    id_12 = { uiType = 7, uiName = "SceneCopy", uiParam={false},uiChanelID=12, uiOpenID = 2}, --单人副本大厅
    id_15 = { uiType = 6, uiName = "SceneCopy", func = "SceneCopy:showScene(2)", uiParam={false},uiChanelID=15, uiOpenID = 1},
 	id_19 = { uiType = 6, uiName = "SceneCopy", func = "SceneCopy:showScene(4)", uiParam={false},uiChanelID=19, uiOpenID = 3},
    id_25 = { uiType = 6, uiName = "SceneCopy", func = "SceneCopy:showScene(3)", uiParam={false},uiChanelID=25, uiOpenID = 6}, --日常副本大厅
    id_27 = { uiType = 1, uiName = "SceneCommunity", uiParam = {},uiChannelID = 27, uiOpenID = 9}, --公会列表
--    id_29 = { uiType = 2, uiName = "SceneMemberList",uiParam={},uiChannelID = 31}, --公会大厅
    id_29 = { uiType = 6, uiName = "SceneCommunity",func = "SceneCommunity:onJumpToCommunity()", uiParam={},uiChannelID = 27, uiOpenID = 9}, --公会大厅
    id_31 = { uiType = 6, uiName = "SceneCommunity",func = "SceneCommunity:jumpToHall()",uiParam={},uiChannelID = 31, uiOpenID = 9}, --公会大厅
    id_37 = { uiType = 6, uiName = "SceneCommunity",func = "SceneCommunity:onJumpToCommunity()",uiParam={},uiChannelID = 37, uiOpenID = 9},--公会图腾
    id_39 = { uiType = 6, uiName = "WndStore",func = "WndStore:showStoreByType(2)",uiParam={},uiChannelID = 39, uiOpenID = 9}, --公会商店
    id_41 = { uiType = 2, uiName = "SceneCommunitySkill",uiParam={},uiChannelID = 41, uiOpenID = 9},--公会技能学堂
    id_43 = { uiType = 2, uiName = "WndShop", uiParam={false},uiChannelID = 43, uiOpenID = 7},  --商城
    id_45 = { uiType = 6, uiName = "WndBagMain", func="WndBagMain:showBag()", uiParam={false},uiChannelID = 45, uiOpenID = 24},
    id_46 = { uiType = 6, uiName = "WndCheckOther", func="WndCheckOther:show()", uiParam={false},uiChannelID = 46, uiOpenID = 2},
    id_47 = { uiType = 6, uiName = "WndBagMain", func ="WndBagMain:showBagDress()", uiParam={false},uiChannelID=47, uiOpenID = 51},
    id_48 = { uiType = 2, uiName = "WndSkillContainer", func="WndSkillContainer:showById(1)", uiParam={false},uiChanelID=48, uiOpenID = 25},
    id_52 = { uiType = 2, uiName = "WndFriends", uiParam={false},uiChannelID = 52, uiOpenID = 14}, --好友
    id_53 = { uiType = 2, uiName = "WndFriends", uiParam={false},uiChannelID = 53, uiOpenID = 14}, --好友
    id_56 = { uiType = 5, uiName = "WndFriends", uiParam={4},uiChannelID = 56, uiOpenID = 14}, --好友
    id_59 = { uiType = 2, uiName = "WndPets", uiParam={false},uiChannelID = 59, uiOpenID = 27 },
    id_60 = { uiType = 2, uiName = "WndPets", uiParam={false},uiChannelID = 60, uiOpenID = 27 },
    id_61 = { uiType = 6, uiName = "WndPets", func = "WndPets:openPets(3)", uiParam={false},uiChanelID=61, uiOpenID = 44},
    id_62 = { uiType = 6, uiName = "WndPets", func = "WndPets:openPets(4)", uiParam={false},uiChanelID=62, uiOpenID = 45},
    id_63 = { uiType = 6, uiName = "WndPets", func = "WndPets:openPets(6)", uiParam={false},uiChanelID=63, uiOpenID = 47},
    id_64 = { uiType = 2, uiName = "WndSummonEntrance", func = "WndSummonEntrance:showInterface(2)", uiParam={false},uiChannelID = 64, uiOpenID = 46 },
    id_65 = { uiType = 2, uiName = "WndSummonEntrance", func = "WndSummonEntrance:showInterface(2)", uiParam={false},uiChannelID = 65, uiOpenID = 27},
    id_66 = { uiType = 6, uiName = "WndPets", func = "WndPets:openPets(5)", uiParam={false},uiChanelID=66, uiOpenID = 48},
    id_67 = { uiType = 2, uiName = "WndPets", uiParam={false},func ="WndPets:showInterface(2)", uiChannelID = 67, uiOpenID = 28},
    id_68 = { uiType = 2, uiName = "WndMounts", uiParam={false},uiChannelID = 68, uiOpenID = 28},
    id_69 = { uiType = 2, uiName = "WndMounts", uiParam={false},uiChannelID = 69, uiOpenID = 50},
    id_70 = { uiType = 2, uiName = "WndMounts", uiParam={false},uiChannelID = 70, uiOpenID = 49},
    id_71 = { uiType = 6, uiName = "WndStrengthen",func = "WndStrengthen:jumpTo(1)", uiParam={false},uiChannelID = 71, uiOpenID = 40},
    id_72 = { uiType = 6, uiName = "WndStrengthen",func = "WndStrengthen:jumpTo(2)", uiParam={false},uiChannelID = 72, uiOpenID = 41},
    id_73 = { uiType = 6, uiName = "WndStrengthen",func = "WndStrengthen:jumpTo(3)", uiParam={false},uiChannelID = 73, uiOpenID = 43},
    id_74 = { uiType = 6, uiName = "WndStrengthen",func = "WndStrengthen:jumpTo(5)", uiParam={false},uiChannelID = 74, uiOpenID = 42},
    id_75 = { uiType = 6, uiName = "WndBuyActivity", func = "WndBuyActivity:showBuyInterface(26)",uiParam={false},uiChannelID=75, uiOpenID = 35},
    id_79 = { uiType = 6, uiName = "WndWelfare", func = "WndActivityIntegrate:showInterface(1, 79)",uiParam={false},uiChannelID=79, uiOpenID = 18},
    id_80 = { uiType = 2, uiName = "WndTask", uiParam={false},uiChannelID = 80, uiOpenID = 39},
    id_81 = { uiType = 2, uiName = "WndTask", func = "WndTask:showInterface(1)", uiParam={false},uiChannelID = 81, uiOpenID = 37}, --任务-支线
    id_82 = { uiType = 2, uiName = "WndTask", func = "WndTask:showInterface(2)", uiParam={false},uiChannelID = 82, uiOpenID = 38}, --任务-日常
    id_83 = { uiType = 6, uiName = "WndMarryManager", func = "WndMarryManager:showMarryHoll()",uiChannelID = 83, uiOpenID = 8},
    id_92 = { uiType = 2, uiName = "WndStrong", uiParam={false},uiChannelID = 92, uiOpenID = 53}, --弹弹宝典
    id_93 = { uiType = 2, uiName = "WndMaster", func = "WndMaster:showInterface()", uiParam={false},uiChannelID = 93, uiOpenID = 30}, --师徒
    id_99 = { uiType = 6, uiName = "WndBagRole", func ="WndBagRole:showBagSynthesis(1, nil, true)", uiParam={false},uiChannelID=99, uiOpenID = 32},
    id_100 = { uiType = 6, uiName = "WndBagRole", func ="WndBagRole:showBagSynthesis(2, nil, true)", uiParam={false},uiChannelID=100, uiOpenID = 32},
    id_101 = { uiType = 6, uiName = "WndBagRole", func ="WndBagRole:showBagSynthesis(4, nil, true)", uiParam={false},uiChannelID=101, uiOpenID = 32},
    id_106 = { uiType = 6, uiName = "WndRankList", func ="WndRankList:showInterface()", uiParam={},uiChannelID=106, uiOpenID = 4},
    id_107 = { uiType = 2, uiName = "WndChallengeEntrance", func ="WndChallengeEntrance:showInterface()", uiParam={true},uiChannelID = 107, uiOpenID = 14}, --世界BOSS
    id_116 = { uiType = 6, uiName = "WndVip", func = "WndVip:showWndUI(0)",uiParam={false},uiChannelID=116, uiOpenID = 17}, --充值界面
    id_118 = { uiType = 6, uiName = "ScenePvpRank", func ="ScenePvpRank:showInterface()", uiParam={false},uiChannelID=118, uiOpenID = 23}, --排位赛大厅
    id_120 = { uiType = 6, uiName = "WndSkillContainer",func = "WndSkillContainer:showById(2)", uiParam={false},uiChannelID = 120, uiOpenID = 58}, --锻造-洗练
    id_121 = { uiType = 6, uiName = "WndGameActivity",func = "WndActivityIntegrate:showInterface(2, 3015)", uiParam={false},uiChannelID = 121, uiOpenID = 21}, --活动-首冲大奖
    id_125 = { uiType = 6, uiName = "WndBagMain", func = "WndBagMain:showBagDesignation(2)",uiParam={false},uiChannelID=125, uiOpenID = 31}, --成就-徽章
    id_126 = { uiType = 6, uiName = "WndWelfare", func = "WndActivityIntegrate:showInterface(1, 126)",uiParam={false},uiChannelID=126, uiOpenID = 61}, --爱心许愿
    id_127 = { uiType = 6, uiName = "WndSpaceMain",func = "WndSpaceMain:show()", uiParam={false},uiChannelID=127, uiOpenID = 60}, --个人空间
    id_142 = { uiType = 6, uiName = "CellRechargePanelActivity",func = "CellRechargePanelActivity:show()", uiParam={false},uiChannelID = 142, uiOpenID = 65}, --首冲大奖
    id_144 = { uiType = 6, uiName = "WndBless",func = "WndBless:showInterface()", uiParam={false},uiChannelID=144, uiOpenID = 64}, --祈福大厅
    id_145 = { uiType = 6, uiName = "WndBagMain",func = "WndBagMain:showBagBless()", uiParam={false},uiChannelID=145, uiOpenID = 64}, --祈福大厅
    id_147 = { uiType = 6, uiName = "WndStore",func = "WndStore:showStoreByType(4)",uiParam={},uiChannelID = 147, uiOpenID = 64}, --祈福商店
    id_148 = { uiType = 6, uiName = "WndWelfare", func ="WndActivityIntegrate:showInterface(1)", uiParam={false},uiChannelID=148, uiOpenID = 69}, --福利
    id_149 = { uiType = 6, uiName = "WndWelfare", func ="WndActivityIntegrate:showInterface(3)", uiParam={false},uiChannelID=149, uiOpenID = 68}, --比赛
    id_150 = { uiType = 6, uiName = "WndLibrary", func = "WndLibrary:show()", uiParam={}, uiChannelID=149, uiOpenID = 15 }, --图鉴
    id_151 = { uiType = 6, uiName = "WndSummonEntrance", func ="WndSummonEntrance:showInterface(1)", uiParam={false},uiChannelID=151, uiOpenID = 11}, --幸运召唤
    id_154 = { uiType = 6, uiName = "ScenePvpRank", func ="ScenePvpRank:showInterface()", uiParam={false},uiChannelID=154, uiOpenID = 23}, --排位赛大厅
    id_156 = { uiType = 1, uiName = "SceneLeagueMain", func ="SceneLeagueMain:show()", uiParam={false},uiChannelID=156, uiOpenID = 71}, --英雄联赛大厅
    id_157 = { uiType = 1, uiName = "SceneLeagueMain", func ="SceneLeagueMain:show()", uiParam={false},uiChannelID=157, uiOpenID = 71}, --英雄联赛大厅
    id_166 = { uiType = 6, uiName = "WndBagMain", func ="WndBagMain:showPractice()", uiParam={false},uiChannelID=166, uiOpenID = 72}, --修炼
    id_168 = { uiType = 6, uiName = "WndCard", func ="WndCard:showInterface(1)", uiParam={false},uiChannelID=168, uiOpenID = 76}, --卡牌
    id_170 = { uiType = 6, uiName = "SceneCommunityWar", func ="SceneCommunityWar:showInterface()", uiParam={false},uiChannelID=170, uiOpenID = 56}, --公会战
    id_177 = { uiType = 6, uiName = "WndAscending", uiParam={false},func = "WndAscending:jumpTo(1)",uiChannelID = 177, uiOpenID = 80}, --圣光-制作
    id_178 = { uiType = 6, uiName = "WndStrengthen", uiParam={false},func = "WndStrengthen:jumpTo(4)",uiChannelID = 178, uiOpenID = 80}, --锻造-调品
    id_179 = { uiType = 6, uiName = "WndAscending", uiParam={false},func = "WndAscending:jumpTo(3)",uiChannelID = 179, uiOpenID = 82}, --圣光-融合
    id_180 = { uiType = 6, uiName = "WndStore",func = "WndStore:showStoreByType(6)",uiParam={},uiChannelID = 180, uiOpenID = 24}, --黑市商店
    id_181 = { uiType = 2, uiName = "SceneAthMelee", uiParam={false},func ="SceneAthMelee:showInterface()", uiChannelID = 181, uiOpenID = 84},  --大乱斗
    id_182 = { uiType = 2, uiName = "WndShop", uiParam={false},func ="WndShop:jumpTab(4,1)", uiChannelID = 182, uiOpenID = 7},  --商城-限购
    id_183 = { uiType = 2, uiName = "WndShop", uiParam={false},func ="WndShop:jumpTab(3,1)",uiChannelID = 183, uiOpenID = 7},  --商城-锻造
    id_184 = { uiType = 2, uiName = "WndShop", uiParam={false},func ="WndShop:jumpTab(3,2)",uiChannelID = 184, uiOpenID = 131},  --商城-宠物
    id_186 = { uiType = 2, uiName = "WndShop", uiParam={false},func ="WndShop:jumpTab(3,3)",uiChannelID = 186, uiOpenID = 27},  --商城-坐骑
    id_187 = { uiType = 7, uiName = "SceneCopy", uiParam={false},uiChanelID=187, uiOpenID = 2}, --单人副本大厅
    id_188 = { uiType = 6, uiName = "WndAscending", uiParam={false},func = "WndAscending:jumpTo(4)",uiChannelID = 188, uiOpenID = 86}, --圣光-进化
    id_189 = { uiType = 6, uiName = "WndGameGift", uiParam={false},func = "WndGameGift:showInterface()",uiChannelID = 189, uiOpenID = 16}, --设置-兑换
    id_191 = { uiType = 1, uiName = "ScenePvpAmuse", uiParam={},uiChannelID = 191, uiOpenID = 98}, --娱乐赛
    id_192 = { uiType = 6, uiName = "SceneCommunity", uiParam={false},func = "SceneCommunity:jumpToCopy()",uiChannelID = 192, uiOpenID = 99}, --公会副本
    id_193 = { uiType = 1, uiName = "ScenePvp", uiParam={},uiChannelID = 193, uiOpenID = 5}, --竞技场
    id_194 = { uiType = 2, uiName = "WndDigGem", uiParam={false},func ="WndDigGem:showInterface()", uiChannelID = 194, uiOpenID = 114},  --挖宝界面
    id_195 = { uiType = 2, uiName = "WndDigGem", uiParam={false},func ="WndDigGem:showTransactionInterface()", uiChannelID = 195, uiOpenID = 114},  --挖宝-交易行界面
    id_196 = { uiType = 2, uiName = "WndDigGem", uiParam={false},func ="WndDigGem:showAppraiseInterface()", uiChannelID = 196, uiOpenID = 114},  --挖宝-鉴定界面
    id_197 = { uiType = 2, uiName = "SceneRuneLockDraw", uiParam={false},func ="WndCopyEntry:onJumpTo()", uiChannelID = 197, uiOpenID = 115},  --符文-抽取界面
    id_198 = { uiType = 2, uiName = "WndBagMain", uiParam={false},func ="WndBagMain:showRune()", uiChannelID = 198, uiOpenID = 116},  --符文界面 
    id_199 = { uiType = 1, uiName = "SceneTabooMap", uiParam={false},func ="SceneTabooMap:show()", uiChannelID = 199, uiOpenID = 117},  --禁忌之地界面 
    id_200 = { uiType = 1, uiName = "SceneTabooBattle", uiParam={false}, uiChannelID = 200, uiOpenID = 117},  --禁忌之地-章节 
    id_201 = { uiType = 2, uiName = "WndPets", uiParam={false},func ="WndPets:showInterface(4)", uiChannelID = 201, uiOpenID = 118},  --幻化
    id_202 = { uiType = 2, uiName = "WndWakeup", uiParam={false},func ="WndWakeup:showInterface()", uiChannelID = 202, uiOpenID = 120},  --觉醒
    id_203 = { uiType = 2, uiName = "WndWakeup", uiParam={false},func ="WndWakeup:showInterface(1)", uiChannelID = 203, uiOpenID = 120},  --觉醒之魂
    id_204 = { uiType = 2, uiName = "WndWakeup", uiParam={false},func ="WndWakeup:showInterface(2)", uiChannelID = 204, uiOpenID = 120},  --觉醒之体
    id_207 = { uiType = 2, uiName = "WndExtraction", uiParam={false},func ="WndExtraction:showInterface()", uiChannelID = 207, uiOpenID = 120},  --萃取
    id_208 = { uiType = 2, uiName = "WndNewActivity", uiParam={false},func ="WndNewActivity:showInterface(88888, nil)", uiChannelID = 208, uiOpenID = 122},  --周年庆活动
    id_209 = { uiType = 6, uiName = "WndStore",func = "WndStore:showStoreByType(5)",uiParam={},uiChannelID = 209, uiOpenID = 76}, --卡牌商店
    id_211 = { uiType = 6, uiName = "WndStore",func = "WndStore:showStoreByType(3)",uiParam={},uiChannelID = 211, uiOpenID = 88}, --宠物商店
    id_212 = { uiType = 6, uiName = "WndStore",func = "WndStore:showStoreByType(7)",uiParam={},uiChannelID = 212, uiOpenID = 116}, --符文商店
    id_213 = { uiType = 2, uiName = "WndShop", uiParam={false},func ="WndShop:jumpTab(2,1)", uiChannelID = 213, uiOpenID = 7},  --商城-时装-全部
    id_214 = { uiType = 2, uiName = "WndShop", uiParam={false},func ="WndShop:jumpTab(2,2)", uiChannelID = 214, uiOpenID = 7},  --商城-时装-头部
    id_215 = { uiType = 2, uiName = "WndShop", uiParam={false},func ="WndShop:jumpTab(2,3)", uiChannelID = 215, uiOpenID = 7},  --商城-时装-表情
    id_216 = { uiType = 2, uiName = "WndShop", uiParam={false},func ="WndShop:jumpTab(2,4)", uiChannelID = 216, uiOpenID = 7},  --商城-时装-身体
    id_217 = { uiType = 2, uiName = "WndShop", uiParam={false},func ="WndShop:jumpTab(2,5)", uiChannelID = 217, uiOpenID = 7},  --商城-时装-翅膀
    id_218 = { uiType = 6, uiName = "SceneFamily", func = "SceneFamily:showInterface()", uiParam={false},uiChanelID=218, uiOpenID = 131},  --家园
    id_222 = { uiType = 6, uiName = "WndApartmentAct", uiParam={false},func ="WndApartmentAct:showInterface()",uiChannelID = 222, uiOpenID = 132},  --娄艺潇活动
    id_223 = { uiType = 2, uiName = "WndShop", uiParam={false},func ="WndShop:jumpTab(3,4)",uiChannelID = 223, uiOpenID = 80},  --商城-圣光
    id_224 = { uiType = 2, uiName = "WndShop", uiParam={false},func ="WndShop:jumpTab(3,5)",uiChannelID = 224, uiOpenID = 7},  --商城-技能
    id_225 = { uiType = 2, uiName = "WndShop", uiParam={false},func ="WndShop:jumpTab(3,7)",uiChannelID = 225, uiOpenID = 120},  --商城-觉醒
    id_226 = { uiType = 2, uiName = "WndShop", uiParam={false},func ="WndShop:jumpTab(3,6)",uiChannelID = 226, uiOpenID = 7},  --商城-其他
    id_227 = { uiType = 2, uiName = "WndShop", uiParam={false},func ="WndShop:jumpTab(7,2)",uiChannelID = 227, uiOpenID = 7},  --商城-寻宝
    id_228 = { uiType = 2, uiName = "WndStore", uiParam={false},func ="WndStore:showStoreByType(8)",uiChannelID = 227, uiOpenID = 137},  --装备商店
    id_229 = { uiType = 2, uiName = "WndShop", uiParam={false},uiChannelID = 229, uiOpenID = 7},  --商城-装备
    id_230 = { uiType = 2, uiName = "WndPets", uiParam={false},func ="WndPets:showInterface(3)", uiChannelID = 230, uiOpenID = 141},  --足迹系统
    id_233 = { uiType = 2, uiName = "WndTask", func = "WndTask:showInterface(3)", uiParam={false},uiChannelID = 233, uiOpenID = 5}, --任务-竞技
    id_234 = { uiType = 6, uiName = "SceneAthMelee", func = "SceneAthMelee:showInterface(2)", uiParam={false},uiChannelID = 234, uiOpenID = 139}, --绝地冒险
    id_235 = { uiType = 2, uiName = "WndAthRank", uiParam={false},func ="WndAthRank:showAthRank()",uiChannelID = 235, uiOpenID = 5},  --竞技-积分榜
    id_236 = { uiType = 2, uiName = "WndClownTreasure", uiParam={false},func ="WndClownTreasure:showInterface()",uiChannelID = 236, uiOpenID = 142},  --小丑寻宝
    id_238 = { uiType = 6, uiName = "WndStore",func = "WndStore:showStoreByType(9)",uiParam={},uiChannelID = 238, uiOpenID = 139}, --冒险商店
    id_239 = { uiType = 6, uiName = "WndStore",func = "WndStore:showStoreByType(10)",uiParam={},uiChannelID = 239, uiOpenID = 23}, --排位商店
    id_240 = { uiType = 6, uiName = "SceneKidHome",func = "SceneKidHome:showInterface()",uiParam={},uiChannelID = 240, uiOpenID = 145}, --小屋界面
    id_241 = { uiType = 6, uiName = "WndMatchmaking",func = "WndMatchmaking:showInterface()",uiParam={},uiChannelID = 241, uiOpenID = 146}, --征婚中心
    id_242 = { uiType = 6, uiName = "SceneWorldTeamBossRoom",func = "SceneWorldTeamBossRoom:showEnter()",uiParam={},uiChannelID = 242, uiOpenID = 148}, --组队世界Boss
    id_243 = { uiType = 6, uiName = "WndBagRole",func = "WndBagRole:showBagSynthesis(3, nil, true)",uiParam={},uiChannelID = 243, uiOpenID = 32}, --合成-镶嵌
    id_247 =  { uiType = 6, uiName = "SceneCopy", func = "SceneCopy:showScene(5)", uiParam={false}, uiChanelID=247, uiOpenID = 151},    --英雄塔
    id_248 =  { uiType = 6, uiName = "WndCharmSpace", func = "WndCharmSpace:showInterface(1)", uiParam={false}, uiChanelID=248, uiOpenID = 78},    --魅力时装
    id_250 =  { uiType = 6, uiName = "WndCharmSpace", func = "WndCharmSpace:showInterface(0)", uiParam={false}, uiChanelID=250, uiOpenID = 78},    --魅力空间
    id_251 =  { uiType = 6, uiName = "WndProfession", func = "WndProfession:showInterface()", uiParam={false}, uiChanelID=251, uiOpenID = 152},    --职业
    id_252 =  { uiType = 6, uiName = "SceneCopy", func = "SceneCopy:showScene(4, 2)", uiParam={false}, uiChanelID=252, uiOpenID = 153},    --噩梦塔
    id_255 =  { uiType = 6, uiName = "WndCharmSpace", func = "WndCharmSpace:showInterface(2)", uiParam={false}, uiChanelID=255, uiOpenID = 60},    --魅力踩一踩
    id_256 =  { uiType = 6, uiName = "WndMagicStone", func = "WndMagicStone:showInterface(0)", uiParam={false}, uiChanelID=256, uiOpenID = 161},    --幻石
    id_257 =  { uiType = 6, uiName = "WndChat", func = "WndChat:showChatWindowForFightingByOrder(CHANNEL_COPY)", uiParam={false}, uiChanelID=257, uiOpenID = 2},    --聊天-副本（功能Id暂时用单人副本的）
    id_258 =  { uiType = 6, uiName = "WndDressCastSoul", func = "WndDressCastSoul:showInterface()", uiParam={false}, uiChanelID=258, uiOpenID = 163},    --时装注魂
    id_259 =  { uiType = 2, uiName = "WndSummonEntrance", func = "WndSummonEntrance:showInterface()", uiParam={}, uiChanelID = 259, uiOpenID = 11 }, --召唤
    id_260 =  { uiType = 6, uiName = "WndStrong", func = "WndStrong:showInterface(8)", uiParam={}, uiChanelID = 260, uiOpenID = 168 }, --新手答题
    id_261 =  { uiType = 6, uiName = "WndFriends", func = "WndFriends:showInterface(MYCIRCLE_INDEX, true)", uiParam={}, uiChanelID = 261, uiOpenID = 167 }, --发布心情
    id_263 =  { uiType = 6, uiName = "SceneCopy", func = "SceneCopy:showScene(1,nil,nil,nil,nil,nil,3)", uiParam={false}, uiChanelID=252, uiOpenID = 153},    --单人副本---噩梦
    id_264 = {uiType = 6, uiName = "WndAscending", uiParam={false},func = "WndAscending:jumpTo(5)",uiChannelID = 264, uiOpenID = 86} ,--圣光圣品
    id_268 =  { uiType = 6, uiName = "WndFriends", func = "WndFriends:showInterface(HOTCIRCLE_INDEX)", uiParam={}, uiChanelID = 268, uiOpenID = 166 }, --发布心情
    id_269 =  { uiType = 6, uiName = "WndAscending", func = "WndAscending:jumpTo(6)", uiParam={}, uiChanelID = 269, uiOpenID = 175 }, --圣光契约
    id_273 =  { uiType = 6, uiName = "WndPetRecover", func = "WndPetRecover:showInterface()", uiParam={}, uiChanelID = 273, uiOpenID = 27 }, --回收宠物
    id_274 =  { uiType = 6, uiName = "WndMarryHoll", func = "WndMarryHoll:jumpWeddingAssemblyHall()", uiParam={}, uiChanelID = 274, uiOpenID = 8 }, --结婚礼堂界面
    id_275 =  { uiType = 6, uiName = "WndSummonEntrance", func = "WndSummonEntrance:showInterface(5)", uiParam={}, uiChanelID = 275, uiOpenID = 196 }, --坐骑抽奖
    id_276 =  { uiType = 6, uiName = "WndSummonEntrance", func = "WndSummonEntrance:showInterface(6)", uiParam={}, uiChanelID = 276, uiOpenID = 197 }, --皮肤装备抽奖
    id_277 =  { uiType = 6, uiName = "WndSummonEntrance", func = "WndSummonEntrance:showInterface(7)", uiParam={}, uiChanelID = 277, uiOpenID = 198 }, --足迹抽奖
    id_285 =  { uiType = 6, uiName = "WndNewVip", func = "WndNewVip:showInterface(2, nil, true)", uiParam={}, uiChanelID = 285, uiOpenID = ISLAND_UP_RECHARGE }, --充值-特权-名人榜-奖励
    id_287 = { uiType = 2, uiName = "WndStore", uiParam={false},func ="WndStore:showStoreByType(11)",uiChannelID = 287, uiOpenID = 1},  --助战商店
    id_294 = { uiType = 2, uiName = "WndStore", uiParam={},func ="WndStore:showStoreByType(13)",uiChannelID = 294, uiOpenID = 218},  --能源商店
    id_297 =  { uiType = 6, uiName = "WndSummonEntrance", func = "WndSummonEntrance:showInterface(8)", uiParam={}, uiChanelID = 297, uiOpenID = 224 }, --宠物装备抽奖
    id_298 = { uiType = 6, uiName = "ScenePvpStrategic", func ="ScenePvpStrategic:showInterface()", uiParam={},uiChannelID=298, uiOpenID = 229}, --排位赛大厅

    id_300 = { uiType = 6, uiName = "WndBagRole", func = "WndBagRole:showBagSell(2, true)", uiParam = {}, uiChannelID = 300, uiOpenID = 93}, --回收
}

--属性值对应的中文名称
ATTR_TITLE = {LocalStrings.HEALTH,LocalStrings.HEALTH,LocalStrings.ATTACK,LocalStrings.DEFENSE,LocalStrings.CRIT,LocalStrings.CRIT,
LocalStrings.FREESTORM,LocalStrings.FREESTORM,LocalStrings.TIZHI,LocalStrings.POWER,LocalStrings.PRACTICE_ARMOR,LocalStrings.AGILITY,
LocalStrings.LUCKY,LocalStrings.PHYSICAL,LocalStrings.PHYSICAL,"","",LocalStrings.RANGE,LocalStrings.ANTIBREAKING,LocalStrings.AVOIDINJURY}
ATTR_TITLE[0] = LocalStrings.NEWSTONE4
ATTR_TITLE[-2] = LocalStrings.BREAK_TEXT3[1]
ATTR_TITLE[-3] = LocalStrings.BREAK_TEXT3[2]
--属性值对应的字段名
ATTR_PARAM_NAME = {"hp","hp","attack","defend","critRate","critRate","reduceCrit","reduceCrit","physique","force","armor","agility","luck","physical","physical","","","range","wreckDefense","injuryFree"}

--公会职位宏定义
COMMUNITY_PRESIDENT = 4
COMMUNITY_VICE_PRESIDENT = 3
COMMUNITY_ELDER = 2
COMMUNITY_ELITE = 1
COMMUNITY_MEMBER = 0

COMMUNITY_POSITION = {LocalStrings.NORMAL_COMMUNITY_MEMBER,LocalStrings.PICK,LocalStrings.ELDERS,LocalStrings.VICE_PRESIDENT,LocalStrings.PRESIDENT,}

--公会最高等级
GUILDMAXLEVEL = nil
--公会升级建筑类型
GUILDUPGRADETYPE = -1
--师傅等级
MASTERLEVEL = 25

--收到玩家物品列表时的系统时间戳,单位秒
SETITEMSTIME = -1

--副本类型定义
COPYTYPE_MULTI = 0 --组队副本
COPYTYPE_SINGLE = 1 -- 单人副本
COPYTYPE_DAILY = 2 --日常副本
COPYTYPE_TOWER = 3 --爬塔副本
COPYTYPE_TRAIN = 4 --训练营副本
COPYTYPE_HEROTOWER = 5 --英雄塔副本
COPYTYPE_SINGLEHOST = 7 --单人副本岛主

DAILY_COPY_TYPE = {
    COPPER = 1,
    EXP = 2,
    PET = 3,
}

TRAIN_COPY_TYPE = {
    FLY = 1,
    WIND = 2,
    HOLE = 3,
    THROW = 4,
}

g_bShowWndMsgConfirmBox = {}    --用于标记不再提示
g_bHaveNewDesi = false            --用于标记成就界面称号选项卡右上角的红点提示是否显示
g_bHaveRedPointForAchieEntry = false           --用于标记成就界面入口处是否显示红点提示
g_bIsShowWndDressUp = true      --是否收到协议的时候马上显示装备提示
g_tTempItemForLaterShow = {}   --保存不是马上需要展示的物品信息
g_tTempSignData = nil           --临时保存Vip签名数据
g_nCurVigor = nil               --当前活力值
g_bIsShowFightingLater = true   --标记登录进游戏时，遇到战斗力变化，待进入主城才弹变化效果
g_nLaterShowFighting = nil      --登录时，保存时装过期的战斗力变化
g_tRedPackList = {}             --未领取的红包Id
g_tAchieData = {}             --战斗中收到的成就达成数据

QUALITYCOLOR = {ccc3(99,255,95),ccc3(93,222,254),ccc3(198,130,255),ccc3(233,166,62), ccc3(255,89,74), ccc3(255,255,255)}
QUALITYCOLOR[0] = ccc3(255,255,255)

BATTLE_EVENT_TYPE = {
    PALYER_ATT_ROUND_UPDATE = "playerAttRoundUpdate",--玩家（自己）攻击回合变化
    CHARACTER_HURT = "characterHurt",--角色受伤
    CHARACTER_CHANGE_HP = "characterChangeHp",  --hp改变
    MONSTER_CREATE = "monsterCreate",   --创建怪物
    MONSTER_SUICIDE = "monsterSuicide", --怪物自杀
    MONSTER_DEAD = "monsterDead",       --怪物死亡
    
    CHARACTER_MAX_HURT = "characterMaxHurt",       --角色单次最大伤害
    CHARACTER_HIT_RATE = "characterHitRate",       --角色命中率
    CHARACTER_USEITEM_TIMES = "characterUseItemTimes",       --角色使用道具次数
    CHARACTER_NOTUSE = "characterNotUse",       --角色不使用某道具或技能
    CHARACTER_USE_KILL = "characterUseKill",       --角色使用技能杀死目标

    COPPER_COPY_ADD_COPPER = "CopperCopyAddCopper", --金币副本金币增加
    EXP_COPY_ADD_EXP = "expCopyAddExp", --经验副本经验增加
    PET_COPY_ADD_SCORE = "petCopyAddScore", --宠物副本分数
    TRAIN_COPY_FLY = "trainCopyFly", --训练营飞行
    ROUND_KILL_MONSTERNUM = "roundKillNum",      --同时击杀怪物数
    WIND_CHANGE = "windChange",      --风力改变
    CHARACTER_USEKID_KILL = "kidKill",       --小孩杀死目标
}
g_tAccountData = {accountName = "",passWord = "" ,loginFlag = -1}  -- 记录账号和密码
g_tRoleAnitionName = {"wait0", "win", "run"}       --角色的常用动画名

g_mulCopyIndex = 1          -- 组队副本当前选择的副本下标
g_nLastGetRankListTime = nil     --上一次获取排行榜的时间
g_selectWorldBossId = 1         -- 选择世界boss的id
g_isRegist = false              -- 是否注册过
g_isBindMail = false            -- 是否绑定过邮箱
g_isGlobalProtocolReged = false -- 全局协议是否已经注册
g_isQuitRoom = false
g_pvpRankIndex = 1              -- 排位赛默认标签id
g_gameNotice = false
g_gameNoticeInfo = {}
g_areaIndex = 1                 -- 竞技场默认标签
g_canInvite = false             -- 是否可以被邀请
g_sTitleSpineName = "ui/common_titleframe_%s"
g_tMarryDiscountTime = nil      --结婚打折活动时间
g_copyST = 0  -- 副本开始时间
g_copyET = 0    -- 副本结束时间
g_blessDataGetIndex = 1    -- 祈福大厅获取数据索引
g_bIsPushSpecifyActivity = false    --是否显示推送活动
g_nConfirmCancelBoxId = nil         --粉钻不足用礼钻代替确认框Id
g_selectPlayerId = nil
g_bIsPushSpecifyActivity = false    --是否显示推送活动
g_nUseFootMarkId = nil    --使用的足迹的ID


--列表相关数据
NUMBER_FRIEND_PAGE = 50         --每页最多显示的数量
g_nFIRAST_LOAD_NUM = 50            --首次加载的数量
EACHTIME_LOAD_NUM = 50          --每次加载的数量
g_nMaxVigor = 1000              --最大的活力值

--个人空间播放录音前保存的背景音乐
SAVEDBGMUSIC = nil

g_tGameActivityTypes = {
        ACTIVITY_FIRSTRECHARGE = 1,     --游戏首冲
        ACTIVITY_DAILYFIRSTRECHARGE=2,  --每日首冲
        ACTIVITY_TIMEDFIRSTRECHARGE=3,  --限时首冲
        ACTIVITY_TOTALFIRSTRECHARGE=4,  --累计充值
        ACTIVITY_CUMULATIVECOST=6,      --累计消费
        ACTIVITY_TIMEDLOGIN=7,          --限时登录
        ACTIVITY_CUMULATIVELOGIN=8,     --累计登录
        ACTIVITY_TIMEDSHOPIN=9,         --限时商品上架
        ACTIVITY_TIMEDSHOPDISCOUNT=10,  --限时商品打折
        ACTIVITY_TIMEDBUYGIFTS = 11,    --购买赠送
        ACTIVITY_CLEARCOPY = 12,        --副本通关
        ACTIVITY_TIMEDTOTALPVP=13,      --限时对战统计
        ACTIVITY_TIMEDRANKSCORE=14,     --限时排位积分
        ACIIVITY_TIMEDFINISHTASK=15,    --限时完成指定任务
        ACTIVITY_TIMEDDOUBLEREWARD=16,  --限时奖励翻倍
        ACTIVITY_TIMEDIMPROVECHANCE=17, --限时提示中奖率
        ACTIVITY_STRENGTHEN=18,         --强化
        ACTIVITY_GRADE=19,              --等级
        ACTIVITY_IMPROVEFIGHT = 20,     --战力提升
        ACTIVITY_INVITEFRIENDS = 21,    --邀请好友
        ACTIVITY_VIPGIFBAG = 22,        --VIP等级礼包
        ACTIVITY_DISCOUNTGIFBAG = 24,   --优惠礼包
        ACTIVITY_EASTTHINGS = 27,       --补充活力
        ACTIVITY_FOREVERWELFARECARD = 167,  --永久福利卡
        ACTIVITY_MONTHCARD = 143,       --月卡活动
        ACTIVITY_TARGETREWARD_1 = 261,  --副本关卡
        ACTIVITY_TARGETREWARD_2 = 262,  --竞技积分
        ACTIVITY_TARGETREWARD_3 = 263,  --排位积分
        ACTIVITY_TARGETREWARD_4 = 264,  --弹王积分
        ACTIVITY_WEEKCARD =  265,      --周卡福利
        ACTIVITY_ENJOYCARD = 266,     --永久尊享卡福利
        ACTIVITY_TODAYRECHARGE = 300,    --每日充值奖励
        ACTIVITY_ONLINEREWARD = 301,     --在线奖励
        ACTIVITY_PRERECHARGE = 1000,    --封测预充值
        ACTIVITY_LEVELLIST = 1001,   --等级排行
        ACTIVITY_ATHLETICSLIST = 1002,   --竞技排行
        ACTIVITY_FIGHTINGLIST = 1003,   --战力排行
        ACTIVITY_COUPLEFIGHTING = 1004,   --夫妻同心战
        ACTIVITY_COMMUNITYFIGHTING = 1005,   --公会大作战
        ACTIVITY_CUMULATIVECOST_TICKET = 2001,    --礼券累计消费
        ACTIVITY_GOODSDISCOUNT_TICKET = 2002,    --礼券折扣限购
        ACTIVITY_NEWWEAPON_TICKET = 2003,    --礼券新品打折
        ACTIVITY_DISCOUNTGIFBAG_TICKET = 2004,    --礼券优惠礼包
        ACTIVITY_DISCOUNT_NEW = 2005,    --礼券钻石折扣限购
        ACTIVITY_ATHLETICSHAPPINESS = 3006,    --竞技乐翻天
        ACTIVITY_CHEATSWELFARE = 3007,    --秘境福利
        ACTIVITY_LOTTERY = 7021,    --抽奖(原来是3008)
        ACTIVITY_NEWWEAPON = 3009,  --新武器打折
        ACTIVITY_GOODSDISCOUNT = 3010, --物品折扣
        ACTIVITY_EXCHANGE = 3011,   --物品兑换
        ACTIVITY_MULDOUBLE = 3012,  --组队双倍
        ACTIVITY_ELITEDOUBLE = 3013, --精英双倍
        ACTIVITY_CUTEPET = 3014,    --萌宠上线
        ACTIVITY_FIRSTRECHARGE2 = 3015,     --游戏3首充
        --ACTIVITY_TODAYRECHARGE = 300,    --每日充值奖励
        ACTIVITY_ONLINEREWARD = 301,     --在线奖励
        ACTIVITY_FOREVERWELFARECARD = 167,  --永久福利卡
        ACTIVITY_ZBSHILIAN = 3016,     --装备十连抽
        ACTIVITY_FREEREWARD = 3300,     --免费奖励
        ACTIVITY_INN = 3017,     --黑店
        ACTIVITY_LINECONNECT = 3018,     --红线情缘
        ACTIVITY_GUANGGAO = 3019,     --广告
        ACTIVITY_CONTINUERECHARGE = 3020,     --连续充值
        ACTIVITY_ORDERREDPACK  = 3021, --口令红包
        ACTIVITY_TYPE_SCHEDULE_RED_PACEKET = 3022, --定时红包
        ACTIVITY_TYPE_FIREWORK             = 3023, --烟花
        ACTIVITY_PLAYERBACK = 3024,  --老玩家回归奖励
        ACTIVITY_TYPE_NOVICE_RED_PACKET    = 3025,--新手红包 
        ACTIVITY_TYPE_NOVICE_ACCUMULATIVE  = 3026,--新手累充
        ACTIVITY_CUMULATIVELOGIN2  = 3029,---周年活动累计登录
        ACTIVITY_LOURA3  = 3031,---爱情公寓
        ACTIVITY_SUMMER_REWARD  = 3032,---夏日赏金
        ACTIVITY_EQUIP_STAR = 3034,         --装备升星奖励
        ACTIVITY_TEN_LOTTERY = 3035,    --各种十连抽活动奖励
        ACTIVITY_EIGHTTIMES_DIAMOND = 3036,    --八倍钻石返利
        ACTIVITY_THREETIMES_DIAMOND = 3037,    --三倍钻石返利
        ACTIVITY_MANY_COLLECT = 3039,    --全民众筹
        ACTIVITY_SMALL_RECHARGE = 3040,    --超值礼包
        ACTIVITY_FIVETIMES_DIAMOND = 3042,    --五倍钻石返利
        ACTIVITY_LOURA8  = 3043,
        ACTIVITY_LOURA9  = 3044,
        ACTIVITY_EXCHANGE_ONE = 3100,   --物品兑换0，跟3011一样逻辑
        ACTIVITY_EXCHANGE_TWO = 3101,   --物品兑换1，跟3011一样逻辑
        ACTIVITY_EXCHANGE_THREE = 3102,   --物品兑换2，跟3011一样逻辑
        ACTIVITY_EXCHANGE_FOUR = 3103,   --物品兑换3，跟3011一样逻辑
        ACTIVITY_FINDDOG = 4000,     --寻找狗二弹
        ACTIVITY_RECHARGELEVEL = 3041,  --充值档位
        ACTIVITY_NEW_EXCHANGE = 3038, --新兑换活动
        ACIVIITY_RECHARGERANK = 3045,    --本服充值达人
        ACIVIITY_CROSS_RECHARGERANK = 3046,    --跨服充值达人
        ACIVIITY_CONSUMERANK = 3047,    --本服消费达人
        ACIVIITY_CROSS_CONSUMERANK = 3048,    --跨服消费达人
        ACIVIITY_WEEKCARD_DISCOUNT = 3049,    --周卡买一送一活动
        ACIVIITY_MONTHCARD_DISCOUNT = 3050,    --月卡打折活动
        ACIVIITY_CHRISTMASTREE = 3051,    --圣诞树活动
        ACTIVITY_RANKPVP_REWARD = 3052, --排位赛奖励
        ACTIVITY_TOW_PACKAGE = 3054,      --两个礼包
        ACIVIITY_OLD_EXCHANGE = 2011,    --兑换活动
        ACTIVITY_NEWSERVER_TIMEDISCOUNT  = 5000,  --开服活动-每日折扣
        ACTIVITY_NEWSERVER_DIAMONDROUND  = 5001,  --开服活动-钻石转盘
        ACTIVITY_NEWSERVER_TIMECHALLENGE  = 5002,  --开服活动-限时挑战
        ACTIVITY_NEWSERVER_ATHLETICSUP  = 5003,  --开服活动-竞技升阶
        ACTIVITY_NEWSERVER_TOTALRECHARGE  = 5004,  --开服活动-累积充值
        ACTIVITY_NEWSERVER_SINGLECOPY  = 5005,  --开服活动-累计副本
        ACTIVITY_NEWSERVER_BREAKEGGS  = 5006,  --开服活动-砸金蛋
        ACTIVITY_NEWSERVER_FIGHTINGRANK  = 5007,  --开服活动-战力月榜
        ACTIVITY_NEWSERVER_CARPACKAGE  = 5008,  --开服活动-卡包抽奖
        ACTIVITY_TYPE_5009 = 5009,              --新服在线奖励 
        ACTIVITY_TYPE_5010 = 5010,              --新服累计登录 
        ACTIVITY_COST_ONLYDIAMOND = 5011,    --开服活动-蓝钻累计消费
        ACTIVITY_COST_ONLYTICKET = 5012,    --开服活动-礼券累计消费
        ACTIVITY_MARRYDISCOUNT = 10005,   --结婚打折
        ACTIVITY_FOOTBALL_SHOOT = 5013, --点球大战
        ACTIVITY_FOOTBALL_QUIZ = 5014,  --足球竞猜
        ACTIVITY_FLOP_CARD = 5015,      --翻牌折扣
        ACTIVITY_BACK_LOGIN = 5016,      --回归活动-登陆
        ACTIVITY_BACK_RECHARGE = 5017,      --回归活动-充值
        ACTIVITY_BACK_FIGHT = 5018,      --回归活动-战斗
        ACTIVITY_FLOWER_LIST = 5019,      --鲜花榜
        ACIVIITY_THEMATIC_TASKS = 6000,
        ACTIVITY_ATHLETIC_VICTORY = 6001,   --竞技胜场6001
        ACTIVITY_RANKING_VICTORY = 6002,    --排位胜场6002
        ACTIVITY_PET_UPGRADE = 6003,    --宠物升级6003
        ACTIVITY_MOUNT_UPGRADE = 6004,  --坐骑升级6004
        ACTIVITY_EQUIPMENT_CALL = 6005, --装备召唤6005
        ACTIVITY_PET_QUAIL = 6006,  --宠物砸蛋6006
        ACTIVITY_CONTINUOUS_LOGIN = 6007,   --连续登录6007
        ACTIVITY_CHANNEL_RECHARGE = 6008,   --渠道充值6008
        ACTIVITY_SHOP_LOTTERY = 6100,   --商城抽奖
        ACTIVITY_RECHARGELEVEL3 = 6106,   --充值档位(节日专用)
        ACTIVITY_INVESTREBATE = 6101,   --投资返利
        ACTIVITY_UNIVERSALGROUP = 6102,   --全民团购
        ACTIVITY_RECHARGEHAVEGIFT = 6103,   --充值有礼
        ACTIVITY_RECHARGEHAVEGIFT2 = 6122,   --充值有礼 和6103一样
        ACTIVITY_HAPPYSHAKE = 6104,   --全民摇摇乐

        ACTIVITY_RETURNEE_COUNTERATTACK = 5020,     --归来者的逆袭
        ACTIVITY_RETURNEE_INDUSTRIOUS = 5021,       --勤劳的归来者
        ACTIVITY_RETURNEE_BUSINESSMAN = 5023,       --回归商人
        ACTIVITY_RETURNEE_INVITATION = 5024,        --回归请柬
        ACTIVITY_RETURNEE_INTRODUCE = 5026,         --回归介绍
        ACTIVITY_RETURNEE_BUFF = 5022,              --回归buff
        ACTIVITY_RETURNEE_FRIEND = 5025,            --邀请老朋友

        ACTIVITY_ONE_RECHARGE = 6105,               --幸运一元冲
        ACTIVITY_MONDAY_PLAN_CARD = 3053,               --周一计划卡
        ACTIVITY_QIXI = 6109, --七夕活动
        ACTIVITY_ANSWER = 6111, --趣味答题
        ACTIVITY_DOUBLE_ELEVEN = 6117, --双11活动

        ACTIVITY_CRAZY_DOUBLING = 6107,             --疯狂翻倍
        ACTIVITY_AUCTION_HOUSE = 99999,              --拍卖行
        ACTIVITY_OPPO_BIGVIP_WELFARE = 6112,        --OPPO琥珀大会员专属-大会员福利
        ACTIVITY_OPPO_BIGVIP_SIGNIN = 6113,         --OPPO琥珀大会员专属-大会员签到
        ACTIVITY_OPPO_BIGVIP_RECHARGE = 6114,       --OPPO琥珀大会员专属-大会员充值
        ACTIVITY_WEEKEND_LIMITED = 6115,    --周末限定
        ACTIVITY_INVESTREBATE_NOR = 6121,    --常规活动中的投资返利

        ACTIVITY_MARK_COIN = 7000,   --纪念币
        ACTIVITY_CHRISTMAS_CARNIVAL = 7001,    --圣诞狂欢 世界杯狂欢  愚人节狂欢
        ACTIVITY_CHRISTMAS_CONSUMPTION = 7002, --圣诞消费榜
        ACTIVITY_GROWUPHAS = 7003, --成长必备
        ACTIVITY_SHOOT_ARROW = 7020, --射箭
        ACTIVITY_CHARGE30_REBATE = 7022, --30元充值返利
        ACTIVITY_NEWSERVER_BIGSEND = 7032, --开服大放送

        ACTIVITY_BULEPRIVILEGE_NEWGIFT = 7038, --蓝钻特权-新手礼包
        ACTIVITY_BULEPRIVILEGE_DAYGIFT = 7039, --蓝钻特权-每日礼包
        ACTIVITY_BULEPRIVILEGE_GROWGIFT = 7040, --蓝钻特权-成长礼包

        ACTIVITY_LOBBY_NEWBIE = 7041, --大厅特权-新手礼包
        ACTIVITY_LOBBY_DAILY = 7042, --大厅特权-每日礼包
        ACTIVITY_LOBBY_GROWTH = 7043, --大厅特权-成长礼包

        ACTIVITY_EIGHTY_EIGHT = 7053, --88充值活动
        ACTIVITY_DIAMOND_COST = 7064, --蓝钻累计消费
        ACTIVITY_DIAMOND_COST_TWO = 7069, --蓝钻累计消费

        ACTIVITY_MAKE_WASTE_PROFITABLE = 7066, --变废为宝活动
        ACTIVITY_WEEKEND_LIMITED_NEW = 7085, --周末限定 改版

    }

--通用活动界面
g_ActivityCommon = {
    [7003] = "CellGrowupHave", --成长必备
    [5010] = "CellNewTotalLogin", --新服累计登录
    [6115] = "CellWeekendLimitedPanel", --周末限定
    [6117] = "CellDouble11Activity", --双11活动
    [3025] = "CellActivitySevenRedEnvelope",--新手红包 
    [27]   = "CellEatthingsPanel", --补充体力(吃大餐)
    [7001] = "CellActivityChristmasCarnival", --圣诞狂欢 世界杯狂欢  愚人节狂欢
    [7002] = "CellChristmasConsumptionList", --圣诞消费榜
    [1000] = "CellPreRechargePanel",
    [3007] = "CellPreRechargePanel",
    [3012] = "CellPreRechargePanel",
    [3013] = "CellPreRechargePanel",
    [3018] = "CellPreRechargePanel",
    [5015] = "CellPreRechargePanel",
    [3052] = "CellPreRechargePanel",
    [4000] = "CellPreRechargePanel",
    [6100] = "CellPreRechargePanel",
    [3006] = "CellPreRechargePanel",    --竞技乐翻天
    [6105] = "CellOneRechargeAct", -- 一元充
    [7022] = "CellCommonPanel",
    [7032] = "CellCommonPanel",
    [7085] = "CellWeekendLimitedPanel", --周末限定
}

--游戏活动标题
g_tGameActivityTitle = {
        [g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE] = LocalStrings.GAME_ACTIVITY_TITLE1,     --游戏首冲
        [g_tGameActivityTypes.ACTIVITY_DAILYFIRSTRECHARGE] = LocalStrings.GAME_ACTIVITY_TITLE2,  --每日首冲
        [g_tGameActivityTypes.ACTIVITY_TIMEDFIRSTRECHARGE] = LocalStrings.GAME_ACTIVITY_TITLE3,  --限时首冲
        [g_tGameActivityTypes.ACTIVITY_TOTALFIRSTRECHARGE] = LocalStrings.GAME_ACTIVITY_TITLE4,  --累计充值
        [g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST] = LocalStrings.GAME_ACTIVITY_TITLE6,      --累计消费
        [g_tGameActivityTypes.ACTIVITY_TIMEDLOGIN] = LocalStrings.GAME_ACTIVITY_TITLE7,          --限时登录
        [g_tGameActivityTypes.ACTIVITY_CUMULATIVELOGIN] = LocalStrings.GAME_ACTIVITY_TITLE8,     --累计登录
        [g_tGameActivityTypes.ACTIVITY_STRENGTHEN] = LocalStrings.GAME_ACTIVITY_TITLE9,         --强化
        [g_tGameActivityTypes.ACTIVITY_GRADE] = LocalStrings.GAME_ACTIVITY_TITLE10,              --等级
        [g_tGameActivityTypes.ACTIVITY_IMPROVEFIGHT] = LocalStrings.GAME_ACTIVITY_TITLE11,     --战力提升
        [g_tGameActivityTypes.ACTIVITY_VIPGIFBAG] = LocalStrings.GAME_ACTIVITY_TITLE12,        --VIP等级礼包
        [g_tGameActivityTypes.ACTIVITY_DISCOUNTGIFBAG] = LocalStrings.GAME_ACTIVITY_TITLE13,   --优惠礼包
        [g_tGameActivityTypes.ACTIVITY_EASTTHINGS] = LocalStrings.GAME_ACTIVITY_TITLE16,       --补充活力
        [g_tGameActivityTypes.ACTIVITY_TARGETREWARD_2] = LocalStrings.GAME_ACTIVITY_TITLE14,       --竞技等级
        [g_tGameActivityTypes.ACTIVITY_PRERECHARGE] = LocalStrings.GAME_ACTIVITY_TITLE17,    --封测预充值
        [g_tGameActivityTypes.ACTIVITY_LEVELLIST] = LocalStrings.GAME_ACTIVITY_TITLE18,   --等级排行
        [g_tGameActivityTypes.ACTIVITY_ATHLETICSLIST] = LocalStrings.GAME_ACTIVITY_TITLE19,   --竞技排行
        [g_tGameActivityTypes.ACTIVITY_FIGHTINGLIST] = LocalStrings.GAME_ACTIVITY_TITLE20,   --战力排行
        [g_tGameActivityTypes.ACTIVITY_COUPLEFIGHTING] = LocalStrings.GAME_ACTIVITY_TITLE21,   --夫妻同心战
        [g_tGameActivityTypes.ACTIVITY_COMMUNITYFIGHTING] = LocalStrings.GAME_ACTIVITY_TITLE22,   --公会大作战
        [g_tGameActivityTypes.ACTIVITY_ATHLETICSHAPPINESS] = LocalStrings.GAME_ACTIVITY_TITLE24,   --竞技乐翻天
        [g_tGameActivityTypes.ACTIVITY_CHEATSWELFARE] = LocalStrings.GAME_ACTIVITY_TITLE23,   --秘境福利
        [g_tGameActivityTypes.ACTIVITY_LOTTERY] = LocalStrings.GAME_ACTIVITY_TITLE25,   --幸运抽奖
        [g_tGameActivityTypes.ACTIVITY_NEWWEAPON] = LocalStrings.GAME_ACTIVITY_TITLE26,   --新品打折
        [g_tGameActivityTypes.ACTIVITY_GOODSDISCOUNT] = LocalStrings.GAME_ACTIVITY_TITLE27,   --限时折扣
        [g_tGameActivityTypes.ACTIVITY_EXCHANGE] = LocalStrings.GAME_ACTIVITY_TITLE28,   --兑换
        [g_tGameActivityTypes.ACTIVITY_MULDOUBLE] = LocalStrings.GAME_ACTIVITY_TITLE29,   --组队双倍
        [g_tGameActivityTypes.ACTIVITY_ELITEDOUBLE] = LocalStrings.GAME_ACTIVITY_TITLE30,   --精英双倍
        [g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE2] = LocalStrings.GAME_ACTIVITY_TITLE31,   --首充大奖
        [g_tGameActivityTypes.ACTIVITY_FINDDOG] = LocalStrings.GAME_ACTIVITY_TITLE36,   --狗二弹
        [g_tGameActivityTypes.ACTIVITY_CUTEPET] = LocalStrings.GAME_ACTIVITY_TITLE33,   --萌宠上线
        [g_tGameActivityTypes.ACTIVITY_ONLINEREWARD] = LocalStrings.GAME_ACTIVITY_TITLE34,   --在线奖励
        [g_tGameActivityTypes.ACTIVITY_TODAYRECHARGE] = LocalStrings.GAME_ACTIVITY_TITLE35,   --每日充值奖励
        [g_tGameActivityTypes.ACTIVITY_MARRYDISCOUNT] = LocalStrings.GAME_ACTIVITY_TITLE32,   --結婚狂歡Par
        [g_tGameActivityTypes.ACTIVITY_ZBSHILIAN] = LocalStrings.TEN_TAKE_OUT,   --装备十连抽
        [g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE] = LocalStrings.GAME_ACTIVITY_TITLE38,   --连续充值
        [g_tGameActivityTypes.ACTIVITY_LINECONNECT] = LocalStrings.GAME_ACTIVITY_TITLE37,   --红线情缘
        [g_tGameActivityTypes.ACTIVITY_TYPE_FIREWORK] = LocalStrings.GAME_ACTIVITY_TITLE40,   --放烟花
        [g_tGameActivityTypes.ACTIVITY_TYPE_SCHEDULE_RED_PACEKET] = LocalStrings.GAME_ACTIVITY_TITLE41,   --整点红包
        [g_tGameActivityTypes.ACTIVITY_ORDERREDPACK] = LocalStrings.GAME_ACTIVITY_TITLE42,   --口令红包
        [g_tGameActivityTypes.ACTIVITY_PLAYERBACK] = LocalStrings.GAME_ACTIVITY_TITLE43,   --老玩家回归
        [g_tGameActivityTypes.ACTIVITY_TYPE_NOVICE_ACCUMULATIVE] = LocalStrings.GAME_ACTIVITY_TITLE44,   --新角色返利
        [g_tGameActivityTypes.ACTIVITY_TYPE_NOVICE_RED_PACKET] = LocalStrings.GAME_ACTIVITY_TITLE45,   --新角色红包
        [g_tGameActivityTypes.ACTIVITY_RECHARGELEVEL] = LocalStrings.ACTIVITY_RECHARGELEVEL,
        [g_tGameActivityTypes.ACTIVITY_NEW_EXCHANGE] = LocalStrings.NEWEXCHANGE_TEXT2,   --新兑换活动
        [g_tGameActivityTypes.ACIVIITY_OLD_EXCHANGE] = LocalStrings.GAME_ACIVIITY_OLD_EXCHANGE,   --兑换
        [g_tGameActivityTypes.ACIVIITY_RECHARGERANK] = LocalStrings.ACIVIITY_RECHARGERANK,  --本服充值排行
        [g_tGameActivityTypes.ACIVIITY_CROSS_RECHARGERANK] = LocalStrings.ACIVIITY_CROSS_RECHARGERANK,  --跨服充值排行
        [g_tGameActivityTypes.ACIVIITY_CONSUMERANK] = LocalStrings.ACIVIITY_CONSUMERANK,    --本服消费排行
        [g_tGameActivityTypes.ACIVIITY_CROSS_CONSUMERANK] = LocalStrings.ACIVIITY_CROSS_CONSUMERANK,    --跨服消费排行
        [g_tGameActivityTypes.ACTIVITY_CUMULATIVELOGIN2] = LocalStrings.GAMEACTIVITY_CUMULATIVELOGIN2,   --周年活动累计登录
        [g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST_TICKET] = LocalStrings.GAME_ACTIVITY_TITLE6,   --礼券消费活动
        [g_tGameActivityTypes.ACTIVITY_GOODSDISCOUNT_TICKET] = LocalStrings.GAME_ACTIVITY_TITLE27,   --礼券折扣活动
        [g_tGameActivityTypes.ACTIVITY_DISCOUNTGIFBAG_TICKET] = LocalStrings.GAME_ACTIVITY_TITLE49,   --礼券优惠活动
        [g_tGameActivityTypes.ACTIVITY_COST_ONLYDIAMOND] = LocalStrings.GAMEACTIVITY_COST_ONLYDIAMOND,                    --开服活动-蓝钻累计消费
        [g_tGameActivityTypes.ACTIVITY_TYPE_5009] = LocalStrings.GAMEACTIVITY_TYPE_5009,                                  --新服在线奖励
        [g_tGameActivityTypes.ACTIVITY_NEWSERVER_CARPACKAGE] = LocalStrings.GAMEACTIVITY_NEWSERVER_CARPACKAGE,            --开服活动-卡包抽奖
        [g_tGameActivityTypes.ACTIVITY_NEWSERVER_BREAKEGGS] = LocalStrings.GAMEACTIVITY_NEWSERVER_BREAKEGGS,              --开服活动-砸金蛋
        [g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMEDISCOUNT] = LocalStrings.GAMEACTIVITY_NEWSERVER_TIMEDISCOUNT,        --开服活动-每日折扣
        [g_tGameActivityTypes.ACTIVITY_NEWSERVER_DIAMONDROUND] = LocalStrings.GAMEACTIVITY_NEWSERVER_DIAMONDROUND,        --开服活动-钻石转盘
        [g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMECHALLENGE] = LocalStrings.GAMEACTIVITY_NEWSERVER_TIMECHALLENGE,      --开服活动-限时挑战
        [g_tGameActivityTypes.ACTIVITY_NEWSERVER_ATHLETICSUP] = LocalStrings.GAMEACTIVITY_NEWSERVER_ATHLETICSUP,          --开服活动-竞技升阶
        [g_tGameActivityTypes.ACTIVITY_NEWSERVER_TOTALRECHARGE] = LocalStrings.GAMEACTIVITY_NEWSERVER_TOTALRECHARGE,      --开服活动-累积充值
        [g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY] = LocalStrings.GAMEACTIVITY_NEWSERVER_SINGLECOPY,            --开服活动-累计副本
        [g_tGameActivityTypes.ACTIVITY_NEWSERVER_FIGHTINGRANK] = LocalStrings.GAMEACTIVITY_NEWSERVER_FIGHTINGRANK,        --开服活动-战力月榜
        [g_tGameActivityTypes.ACTIVITY_DISCOUNT_NEW] = LocalStrings.GAME_ACTIVITY_TITLE47,        --礼券钻石物品西限时折扣
        [g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY] = LocalStrings.GAME_ACTIVITY_TEN_LOTTERY,        --各种十连抽活动奖励
        [g_tGameActivityTypes.ACTIVITY_MANY_COLLECT] = LocalStrings.GAME_ACTIVITY_MANY_COLLECT,        --全民众筹
        [g_tGameActivityTypes.ACTIVITY_EIGHTTIMES_DIAMOND] = LocalStrings.GAME_ACTIVITY_EIGHTTIMES_DIAMOND,     --八倍钻石返利
        [g_tGameActivityTypes.ACTIVITY_TYPE_5010] = LocalStrings.GAME_ACTIVITY_TYPE_5010,
        [g_tGameActivityTypes.ACTIVITY_FOOTBALL_SHOOT] = LocalStrings.FOOTBALL_SHOOT,   --点球大战
        [g_tGameActivityTypes.ACTIVITY_FOOTBALL_QUIZ] = LocalStrings.GAME_ACTIVITY_FOOTBALL_QUIZ,    --足球竞猜
        [g_tGameActivityTypes.ACTIVITY_RANKPVP_REWARD] = LocalStrings.GAME_ACTIVITY_RANKPVP_REWARD,   --排位赛奖励
        [g_tGameActivityTypes.ACTIVITY_FOOTBALL_SHOOT] = LocalStrings.FOOTBALL_SHOOT,   --点球大战
        [g_tGameActivityTypes.ACTIVITY_FOOTBALL_QUIZ] = LocalStrings.GAME_ACTIVITY_FOOTBALL_QUIZ,    --足球竞猜
        [g_tGameActivityTypes.ACTIVITY_FLOP_CARD] = LocalStrings.FLOP_CARD_DISCOUNT,    --翻牌折扣
        [g_tGameActivityTypes.ACTIVITY_BACK_LOGIN] = LocalStrings.ACTIVITY_BACK_TEXT1,    --回归登陆
        [g_tGameActivityTypes.ACTIVITY_BACK_RECHARGE] = LocalStrings.ACTIVITY_BACK_TEXT2,    --回归充值
        [g_tGameActivityTypes.ACTIVITY_BACK_FIGHT] = LocalStrings.ACTIVITY_BACK_TEXT3,    --回归战斗
        [g_tGameActivityTypes.ACTIVITY_ATHLETIC_VICTORY] = LocalStrings.GAME_ACTIVITY_ATHLETIC_VICTORY,    --竞技胜场6001
        [g_tGameActivityTypes.ACTIVITY_RANKING_VICTORY] = LocalStrings.GAME_ACTIVITY_RANKING_VICTORY,    --排位胜场6002
        [g_tGameActivityTypes.ACTIVITY_PET_UPGRADE] = LocalStrings.GAME_ACTIVITY_PET_UPGRADE,    --宠物升级6003
        [g_tGameActivityTypes.ACTIVITY_MOUNT_UPGRADE] = LocalStrings.GAME_ACTIVITY_MOUNT_UPGRADE,    --坐骑升级6004
        [g_tGameActivityTypes.ACTIVITY_EQUIPMENT_CALL] = LocalStrings.GAME_ACTIVITY_EQUIPMENT_CALL,    --装备召唤6005
        [g_tGameActivityTypes.ACTIVITY_PET_QUAIL] = LocalStrings.GAME_ACTIVITY_PET_QUAIL,    --宠物砸蛋6006
        [g_tGameActivityTypes.ACTIVITY_CONTINUOUS_LOGIN] = LocalStrings.GAME_ACTIVITY_CONTINUOUS_LOGIN,    --连续登录6007
        [g_tGameActivityTypes.ACTIVITY_CHANNEL_RECHARGE] = LocalStrings.GAME_ACTIVITY_CHANNEL_RECHARGE,    --渠道充值6008
        [g_tGameActivityTypes.ACTIVITY_FLOWER_LIST] = LocalStrings.GAME_ACTIVITY_FLOWER_LIST,    --鲜花榜
        [g_tGameActivityTypes.ACTIVITY_THREETIMES_DIAMOND] = LocalStrings.GAME_ACTIVITY_TYPE_3037,    --鲜花榜
        [g_tGameActivityTypes.ACIVIITY_WEEKCARD_DISCOUNT] = LocalStrings.GAME_ACTIVITY_TYPE_3049,    --周卡打折
        [g_tGameActivityTypes.ACIVIITY_MONTHCARD_DISCOUNT] = LocalStrings.GAME_ACTIVITY_TYPE_3050,    --月卡打折
        [g_tGameActivityTypes.ACTIVITY_NEWWEAPON_TICKET] = LocalStrings.GAME_ACTIVITY_TITLE26,    --礼券新品打折
        [g_tGameActivityTypes.ACTIVITY_MARK_COIN] = LocalStrings.GAMEACTIVITY_MARK_COIN,    --纪念币
        [g_tGameActivityTypes.ACTIVITY_TOW_PACKAGE] = LocalStrings.GAMEACTIVITY_TOW_PACKAGE,    --两个礼包
        [g_tGameActivityTypes.ACTIVITY_SHOP_LOTTERY] = LocalStrings.GAMEACTIVITY_SHOP_LOTTERY,    --商城抽奖
        [g_tGameActivityTypes.ACTIVITY_RECHARGELEVEL3] = LocalStrings.GAMEACTIVITY_RECHARGELEVEL3,    --充值档位(节日专用)
        [g_tGameActivityTypes.ACTIVITY_INVESTREBATE] = LocalStrings.GAMEACTIVITY_INVESTREBATE,    --投资返利
        [g_tGameActivityTypes.ACTIVITY_UNIVERSALGROUP] = LocalStrings.FOURYEAR_TEXT1,    --全民团购
        [g_tGameActivityTypes.ACTIVITY_HAPPYSHAKE] = LocalStrings.FOURYEAR_TEXT6,    --全民摇摇乐
        [g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT] = LocalStrings.FOURYEAR_TEXT19,    --充值有礼
        [g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT2] = LocalStrings.FOURYEAR_TEXT19_2,    --充值有礼

        [g_tGameActivityTypes.ACTIVITY_RETURNEE_COUNTERATTACK] = LocalStrings.GAME_ACTIVITY_TITLE50,     --归来者的逆袭
        [g_tGameActivityTypes.ACTIVITY_RETURNEE_INDUSTRIOUS] = LocalStrings.GAME_ACTIVITY_TITLE51,       --勤劳的归来者
        [g_tGameActivityTypes.ACTIVITY_RETURNEE_BUSINESSMAN] = LocalStrings.GAME_ACTIVITY_TITLE52,       --回归商人
        [g_tGameActivityTypes.ACTIVITY_RETURNEE_INVITATION] = LocalStrings.GAME_ACTIVITY_TITLE53,        --回归请柬
        [g_tGameActivityTypes.ACTIVITY_RETURNEE_INTRODUCE] = LocalStrings.GAME_ACTIVITY_TITLE54,         --回归介绍
        [g_tGameActivityTypes.ACTIVITY_RETURNEE_BUFF] = LocalStrings.GAME_ACTIVITY_TITLE55,              --回归buff
        [g_tGameActivityTypes.ACTIVITY_RETURNEE_FRIEND] = LocalStrings.GAME_ACTIVITY_TITLE56,            --邀请老朋友

        [g_tGameActivityTypes.ACTIVITY_ONE_RECHARGE] = LocalStrings.GAME_ACTIVITY_TITLE57,            --幸运一元充
        [g_tGameActivityTypes.ACTIVITY_MONDAY_PLAN_CARD] = LocalStrings.ACTIVITY_TEXT_DESC_25,            --周一计划卡
        [g_tGameActivityTypes.ACTIVITY_ANSWER] = LocalStrings.FESTIVAL_TEXT33,
        [g_tGameActivityTypes.ACTIVITY_DOUBLE_ELEVEN] = LocalStrings.OPTIMIZE_TEXT7,

        [g_tGameActivityTypes.ACTIVITY_CRAZY_DOUBLING] = LocalStrings.GAME_ACTIVITY_CRAZY_DOUBLING,      --疯狂翻倍
        [g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_WELFARE] = LocalStrings.GAME_ACTIVITY_OPPO_BIGVIP_WELFARE,     --OPPO琥珀大会员专属-大会员福利
        [g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_SIGNIN] = LocalStrings.GAME_ACTIVITY_OPPO_BIGVIP_SIGNIN,     --OPPO琥珀大会员专属-大会员签到
        [g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_RECHARGE] = LocalStrings.GAME_ACTIVITY_OPPO_BIGVIP_RECHARGE,     --OPPO琥珀大会员专属-大会员充值

        [g_tGameActivityTypes.ACTIVITY_WEEKEND_LIMITED] = LocalStrings.GAME_ACTIVITY_WEEKEND_LIMITED,     --周末限定
        [g_tGameActivityTypes.ACTIVITY_INVESTREBATE_NOR] = LocalStrings.GAMEACTIVITY_INVESTREBATE,    --投资返利
        [g_tGameActivityTypes.ACTIVITY_CHRISTMAS_CARNIVAL] = LocalStrings.GAMEACTIVITY_CHRISTMAS_CARNIVAL, --圣诞狂欢
        [g_tGameActivityTypes.ACTIVITY_CHRISTMAS_CONSUMPTION] = LocalStrings.CONSUME_RANK,   --圣诞消费榜
        [g_tGameActivityTypes.ACTIVITY_GROWUPHAS] = LocalStrings.OPTIMIZE_TEXT28,
        [g_tGameActivityTypes.ACTIVITY_CHARGE30_REBATE] = LocalStrings.OPTIMIZE_TEXT52,
        [g_tGameActivityTypes.ACTIVITY_NEWSERVER_BIGSEND] = LocalStrings.WATERCOUNTRY_TEXT3,

        [g_tGameActivityTypes.ACTIVITY_BULEPRIVILEGE_NEWGIFT] = LocalStrings.LZTQ_TEXT1[3],
        [g_tGameActivityTypes.ACTIVITY_BULEPRIVILEGE_DAYGIFT] = LocalStrings.LZTQ_TEXT1[4],
        [g_tGameActivityTypes.ACTIVITY_BULEPRIVILEGE_GROWGIFT] = LocalStrings.LZTQ_TEXT1[5],
        [g_tGameActivityTypes.ACTIVITY_LOBBY_NEWBIE] = LocalStrings.LZTQ_TEXT1[3],
        [g_tGameActivityTypes.ACTIVITY_LOBBY_DAILY] = LocalStrings.LZTQ_TEXT1[4],
        [g_tGameActivityTypes.ACTIVITY_LOBBY_GROWTH] = LocalStrings.LZTQ_TEXT1[5],

        [g_tGameActivityTypes.ACTIVITY_EIGHTY_EIGHT] = LocalStrings.GAME_ACTIVITY_EIGHTY_EIGHT,
        [g_tGameActivityTypes.ACTIVITY_DIAMOND_COST] = LocalStrings.GAMEACTIVITY_COST_ONLYDIAMOND,                    --蓝钻累计消费
        [g_tGameActivityTypes.ACTIVITY_DIAMOND_COST_TWO] = LocalStrings.GAMEACTIVITY_COST_ONLYDIAMOND,                    --蓝钻累计消费

        [g_tGameActivityTypes.ACTIVITY_MAKE_WASTE_PROFITABLE] = LocalStrings.ACT_MAKE_WASTE_PROFITABLE[1],
        [g_tGameActivityTypes.ACTIVITY_WEEKEND_LIMITED_NEW] = LocalStrings.GAME_ACTIVITY_WEEKEND_LIMITED,     --周末限定
        [g_tGameActivityTypes.ACTIVITY_EXCHANGE_ONE] = LocalStrings.MARRY_END[4],   --兑换
        [g_tGameActivityTypes.ACTIVITY_EXCHANGE_TWO] = LocalStrings.MARRY_END[5],   --兑换
        [g_tGameActivityTypes.ACTIVITY_EXCHANGE_THREE] = LocalStrings.MARRY_END[6],   --兑换
        [g_tGameActivityTypes.ACTIVITY_EXCHANGE_FOUR] = LocalStrings.MARRY_END[7],   --兑换
    }
FACE_ANIM =
    {
        "<AR A=\"face10\" AF=\"chat/face10.xml\" AP=\"chat/face10.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face20\" AF=\"chat/face20.xml\" AP=\"chat/face20.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face30\" AF=\"chat/face30.xml\" AP=\"chat/face30.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face40\" AF=\"chat/face40.xml\" AP=\"chat/face40.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face50\" AF=\"chat/face50.xml\" AP=\"chat/face50.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face60\" AF=\"chat/face60.xml\" AP=\"chat/face60.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face70\" AF=\"chat/face70.xml\" AP=\"chat/face70.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face80\" AF=\"chat/face80.xml\" AP=\"chat/face80.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face90\" AF=\"chat/face90.xml\" AP=\"chat/face90.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face100\" AF=\"chat/face100.xml\" AP=\"chat/face100.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face110\" AF=\"chat/face110.xml\" AP=\"chat/face110.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face120\" AF=\"chat/face120.xml\" AP=\"chat/face120.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face130\" AF=\"chat/face130.xml\" AP=\"chat/face130.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face140\" AF=\"chat/face140.xml\" AP=\"chat/face140.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face150\" AF=\"chat/face150.xml\" AP=\"chat/face150.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face160\" AF=\"chat/face160.xml\" AP=\"chat/face160.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face170\" AF=\"chat/face170.xml\" AP=\"chat/face170.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face180\" AF=\"chat/face180.xml\" AP=\"chat/face180.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face190\" AF=\"chat/face190.xml\" AP=\"chat/face190.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face200\" AF=\"chat/face200.xml\" AP=\"chat/face200.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face210\" AF=\"chat/face210.xml\" AP=\"chat/face210.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face220\" AF=\"chat/face220.xml\" AP=\"chat/face220.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face230\" AF=\"chat/face230.xml\" AP=\"chat/face230.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face240\" AF=\"chat/face240.xml\" AP=\"chat/face240.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face250\" AF=\"chat/face250.xml\" AP=\"chat/face250.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face260\" AF=\"chat/face260.xml\" AP=\"chat/face260.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face270\" AF=\"chat/face270.xml\" AP=\"chat/face270.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face280\" AF=\"chat/face280.xml\" AP=\"chat/face280.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face290\" AF=\"chat/face290.xml\" AP=\"chat/face290.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face300\" AF=\"chat/face300.xml\" AP=\"chat/face300.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face310\" AF=\"chat/face310.xml\" AP=\"chat/face310.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face320\" AF=\"chat/face320.xml\" AP=\"chat/face320.plist\" II=\"0\"  Z=\"0.44\" ></AR>",
        "<AR A=\"face330\" AF=\"chat/face330.xml\" AP=\"chat/face330.plist\" II=\"0\"  Z=\"0.45\" ></AR>",
        "<AR A=\"face340\" AF=\"chat/face340.xml\" AP=\"chat/face340.plist\" II=\"0\"  Z=\"0.45\" ></AR>",
        "<AR A=\"face350\" AF=\"chat/face350.xml\" AP=\"chat/face350.plist\" II=\"0\"  Z=\"0.45\" ></AR>",
        "<AR A=\"face360\" AF=\"chat/face360.xml\" AP=\"chat/face360.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face370\" AF=\"chat/face370.xml\" AP=\"chat/face370.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face380\" AF=\"chat/face380.xml\" AP=\"chat/face380.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face390\" AF=\"chat/face390.xml\" AP=\"chat/face390.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face400\" AF=\"chat/face400.xml\" AP=\"chat/face400.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
        "<AR A=\"face410\" AF=\"chat/face410.xml\" AP=\"chat/face410.plist\" II=\"0\"  Z=\"0.4\" ></AR>",
        "<AR A=\"face420\" AF=\"chat/face420.xml\" AP=\"chat/face420.plist\" II=\"0\"  Z=\"0.35\" ></AR>",
        "<AR A=\"face430\" AF=\"chat/face430.xml\" AP=\"chat/face430.plist\" II=\"0\"  Z=\"0.26\" ></AR>",
        "<AR A=\"face440\" AF=\"chat/face440.xml\" AP=\"chat/face440.plist\" II=\"0\"  Z=\"0.5\" ></AR>",
        "<AR A=\"face450\" AF=\"chat/face450.xml\" AP=\"chat/face450.plist\" II=\"0\"  Z=\"0.5\" ></AR>",
        "<AR A=\"face460\" AF=\"chat/face460.xml\" AP=\"chat/face460.plist\" II=\"0\"  Z=\"0.5\" ></AR>",
        "<AR A=\"face470\" AF=\"chat/face470.xml\" AP=\"chat/face470.plist\" II=\"0\"  Z=\"0.5\" ></AR>",
        "<AR A=\"face480\" AF=\"chat/face480.xml\" AP=\"chat/face480.plist\" II=\"0\"  Z=\"0.5\" ></AR>",
        "<AR A=\"face490\" AF=\"chat/face490.xml\" AP=\"chat/face490.plist\" II=\"0\"  Z=\"0.5\" ></AR>",
        "<AR A=\"face500\" AF=\"chat/face500.xml\" AP=\"chat/face500.plist\" II=\"0\"  Z=\"0.2\" ></AR>",
    }

--屏蔽私聊的玩家id
BANCHAT = {}

--宝石最高等级
GEMMAXLEVEL = 12

--蓝装升阶强化等级限制
LANASCENDINGSTRONG = 35
--蓝装升阶升星等级限制
LANASCENDINGSTAR = 10
--紫装升阶强化等级限制
ZIASCENDINGSTRONG = 40
--紫装升阶升星等级限制
ZIASCENDINGSTAR = 12
--橙装图纸
DRAWINGPURPLEWEAPON	  = 300
DRAWINGPURPLENECKLACE =	301
DRAWINGPURPLERING	  = 302
DRAWINGPURPLEWRISTER  =	303
DRAWINGPURPLEBADGE	  = 304
DRAWINGPURPLETREASURE =	305	
DRAWINGPURPLE7 		  =	381
DRAWINGPURPLE8        =	382	
--橙装调品箱子
ORANGECHANGEGRADEMATERIAL = 193

--广告已经显示到的序号
ADINDEX = 999999

g_fastGetItemId = nil  --记录快速获取那个物品ID

--需要下载的文件列表
tDownloadFileList = {}

--定时红包id列表
ENVELOPES = {}

--待播放烟花列表
FIREWORKS = {}

--烟花剩余次数
FIREWORKTIME = 0

--烟花间隔时间（秒）
FIREWORKINTERVAL = 1

--是否显示烟花
SETSHOWFIREWORK = 1

--烟花排行榜是否打开了
ISFIREWORKRANK = false

--购买等级提示是否不再显示提示
ISSHOW_USELEVEL = false

--保存已点击充值的礼包id
RECHARGE_YEAR_ACTIVITY = {} 

--当前进行充值的礼包ID
RECHARGE_CURRENT_ID = nil  

--是否在使用技能书
USESKILLBOOK = false

--回收资源的时装id列表
NOTRECYCLEIDS = {}
NOTRECYCLESKINIDS = {}
COPYSKINDATA = {}
NOTRECYCLEIDS_COPY = {}

--最高层
TOP_LAYER_ZORDER = 99999999
IS_FOOTBALL_RANK = false    --是否在世界杯的排行榜界面

RANK_OVER_REWARD_ID = nil   --掉落
RANK_OVER_REWARD_COUNT = nil --掉落次数

g_isFirstGangsterInnShow = true --登录时定向推送第一次显示
g_MasterMessage_Mark = "*h~`4Z"
g_nOperatePlayerId = nil        --处理收徒或拜师信息时候，操作的玩家ID

IS_FOOTBALL_RANK = false    --是否在世界杯的排行榜界面
g_UsingPhantomData = nil      --使用的皮肤体验卡数据
g_singleCopyStartTime = 0   --单人副本战斗开始时间
g_singleCopyEndTime = 0   --单人副本战斗结束时间
g_myHeroTowerBuffId = nil --英雄塔我的buffId(英雄塔配置表的ID)
g_SpatterScheduleId = nil 
g_PvpRankAddPercent = 0     --排位积分加成

g_REMAINSMessage_Mark = [[*y~`0F({"mapId":".+","text":".+","desc":".+"})!~=]]    --聊天信息匹配遗迹按钮
IS_BATTLEOVER_JUMP_REMAINS = false      --战斗结束是否调回挖宝界面
g_nMyAssistState = 0    --我的赏金状态，用于翻牌界面显示标记
g_sAssistMessage = nil    --增加赏金点数的时候，被踢出房间的提示语
g_professionIcon = {"ui/profession/zhiye_zhanshi.png", "ui/profession/zhiye_cike.png", "ui/profession/zhiye_fashi.png"} --职业一转图标
g_professionIcon2 = {"ui/profession/zhiye_zhanshi_2.png", "ui/profession/zhiye_cike_2.png", "ui/profession/zhiye_fashi_2.png"} --职业二转图标
g_nRoomOwnerId = nil  --房主Id
g_tCloseRechargeChannel = {"8888", "53", "75", "275", "68", "35", "401", "355", "179", "159", "324", "1013", "39", "90", "1352", "28", "6"}    --需要关闭的充值渠道
g_tCloseLoginInChannel = {"35", "39"}    --需要关闭登陆的渠道
g_tCloseCreateRoleChannel = {}    --需要关闭创角的渠道
g_nLastChannelId = -1 --进入双人爬塔房间时候的界面Id
g_tShopItemQuality = {"ui/common/common_icon_lg.png", "ui/common/common_icon_lg.png", "ui/common/common_icon_ng.png", "ui/common/common_icon_zg.png", "ui/common/common_icon_hg.png", "ui/common/common_icon_hog.png"} --商店物品品质
g_cityExtenInfo = nil   --主城所需的额外信息
g_tWhisperChatPlayerId = {}    --本次登陆私聊的玩家Id
g_nAdditionCoolTime = 8000      --挖坑飞行冷却时间额外增量
g_tQualityRect = {[0]="ui/common/common_scale9_bai.png","ui/common/common_scale9_lv.png","ui/common/common_scale9_lan.png","ui/common/common_scale9_zi.png","ui/common/common_scale9_cheng.png","ui/common/common_scale9_hong.png","ui/common/common_scale9_cai.png"}
g_tShapeBigSkillConfig = nil    --皮肤大招相关配置
g_FriendCircleMessage_Mark = "*y~`1F" --好友发布新心情助手信息头
g_HonourMessage_Mark = "u##" --信誉积分的
g_MasterMsgPrivate = "*$^" --师徒请求
g_tCellTopHandleObj = {}    --存放所有CellTopHandle对象 用于刷新任务
g_nSuperCritHappenMark = -1    --回合触发超暴击标记
g_TOWER_TAG = false             --false默认值，true为点击进入下一关卡
g_nLastChannelId_ShootArrow = -1 --进入射箭活动时候的界面Id

g_SingleOrTeamMap = 1   -- 1.单人副本，2.组队副本
g_SingleOrTeamMapDegree = 1 -- 1.简单 2.困难 3.地狱 4.觉醒
g_tQualityBG = {"ui/common/common_hb_di_lv.png","ui/common/common_hb_di_lan.png","ui/common/common_hb_di_zi.png","ui/common/common_hb_di_cheng.png","ui/common/common_hb_di_hong.png"}
g_tQualityNameBG = {"ui/common/common_hbbt_di_lv.png","ui/common/common_hbbt_di_lan.png","ui/common/common_hbbt_di_zi.png","ui/common/common_hbbt_di_cheng.png","ui/common/common_hbbt_di_hong.png"}
g_nQuickChatDefaultIndex = nil  --战斗中快捷聊天默认选中上一次的标签
g_tBusinessCode = nil       --商业埋点
BUSINESSCODE_FILENAME = "ddd2_BUSINESS_%d.db" --商业埋点保存文件
BUSINESSCODE_STATICVALUE = 100000 --商业埋点固定值 + 活动类型
g_CityTopBtnState = true    --主城上方按钮收缩状态
g_OfflineMessage = {} --离线消息
g_OpenOfflineMessage = true --本次登录是否第一次打开公会聊天 true:是的，false：不是
g_QuickRedPackState = false --快捷领取红包按钮(世界红包)
g_QuickRedPackState2 = false --快捷领取红包按钮(公会红包)
g_RedPackChannel = 0 --用来区分红包频道 0-世界，1-公会 
g_nMagicStoneSeason = 1     --战令季
HVATTR_TITLE = {LocalStrings.HOLIDAYVILLAGE_TEXT1[26],LocalStrings.QUICKEN,LocalStrings.WAKEUP_TEXT19,LocalStrings.HOLIDAYVILLAGE_TEXT1[27]}
g_QQPriceDiscount = 0.8
g_nFootStarMapIndex = 1 --保存足迹星辰位置
g_tHideBuffIdList = {1021, 1022, 1023, 1024, 1025, 1026, 1027, 1031, 1032, 1033, 1034, 1035, 1036, 1037, 1271, 1281, 1291, 1301, 1311, 1321, 1331, 9012, 9013, 10001, 10002, 10003, 10004, 10005, 10006, 10007, 10008, 10009, 10010, 30001} --用于免疫隐身外挂逻辑处理
g_sFtxtQualityColor = {[["99,255,95"]],[["93,222,254"]],[["198,130,255"]],[["233,166,62"]],[["255,89,74"]]}
g_FightOne_Login_Mark = "dymsxl~"
g_RechargeOne_Login_Mark = "mrbdysxl~"
WORSHIPGOD_ENVELOPES = {} --拜财神-红包雨
--是否显示拜财神红包雨
SETSHOWREDPACKRAIN = 0
g_bIsDelayCheckAutoActivity = false     --是否延迟到返回独立活动入口协议返回的时候才检查登录弹窗
GDatatab_item = {}                      --物品表
g_nShopCachePage = nil              --数据页数 用来判断下发的商品数据是否完整
g_tShopCacheCount = {}              --每页情况 用来判断下发的商品数据是否完整
g_bIsDelayCheckAutoAct7068 = false     --是否延迟到返回独立活动入口协议返回的时候才检查登录弹窗
g_nEnemyTalkLimit = nil            --战斗敌方发言屏蔽状态
g_nTeamTalkLimit = nil            --战斗队友发言屏蔽状态
--联盟职位宏定义
UNION_PRESIDENT = 4
UNION_VICE_PRESIDENT = 3
UNION_ELDER = 2
UNION_ELITE = 1
UNION_MEMBER = 0
UNION_POSITION = {LocalStrings.UNION_TEXT2[8],LocalStrings.PICK,LocalStrings.ELDERS,LocalStrings.UNION_TEXT1[13],LocalStrings.UNION_TEXT1[12]}
g_bIsGetUnionInfo = false       --用于标记是获取联盟信息还是获取自己联盟的大厅数据 
g_OpenUnionOfflineMessage = true --本次登录是否第一次打开联盟聊天 true:是的，false：不是
g_nCreateRoleNum = 0        --账号已创建的角色数量-用于越南埋点首次创角
g_tKidDressSuitData = nil   --孩子套装配置数据
GDatatab_activity_medal = {}                      --勋章表