--LocalStrings.lua
--@brief	界面文字字符串定义文件，不同的语言具有相同的键。
LocalStrings =
{	
	LOGIN = "登录",
	PASSWORD = "密码",
	INBOX = "收件箱",
	OUTBOX = "发件箱",
	WRITEBOX = "写邮件",
	SEND = "发送",
	SUCCESS = "成功",
	FAIL = "失败",
	EDIT = "批量删除",
	DELECT = "删 除",
	COMPLETE = "完 成",
	REPLY = "回 复",
	UPPAGE = "上一页",
	DOWNPAGE = "下一页",
	SENDER = "发送者:",
	TIME = "时间:",
	EDITMAILID = "点击选择收件人",
	EDITMAILTHEME = "请输入邮件主题",
	EDITMAILCONTENT = "请输入邮件内容",
	NOTDESIGNAME = "还未获得此称号!",
	MAIL_THEME = "主  题:",
	MAIL_RECV = "收件人:",
	MAIL_SENDER = "发件人:",
	MAIL_GETALL = "一键领取",
	REINC_REINCTXT = "转  生",
	VIP_CURDAYRECV = "当日已领取",
	VIP_RECVSUCCESS = "领取成功",
	VIP_INFOFAIL = "获取VIP信息失败",
	INVITE_RECEIVE = "领取",
	INVITE_SERVER = "服务器",
	NAME = "玩家名称",
	CURSERVER = "当前服务器:",
	BACKGROUND = "背景音乐",
	GAME = "游戏音效",
	MUSIC = "音乐",
	ABOUT = "关于游戏",
	REGISTER = "注册账号",
	SETTING_ACCOUNT = "账号",
	HELP = "帮助",
	INPUTDETAIL = "请输入内容",
	EXCHANGE = "兑 换",
	CURNUM = "当前参战人数:%d",
	URLFAIL = "URL打开失败!" ,
	QUALIFYING_ORDER = "名次",
	QUALIFYING_NAME = "名称",
	INTEGRATION = "积分",
	HURTOUTPUT = "伤害输出",
	MATCHFAIL = "匹配失败",
	TEACH_BOSSMAP = "快带着刚获得的小伙伴进行一场副本探险吧",
	TEACH_BOSSMAP_CHALLENGE = [[点击"挑战关卡"即可进行副本的难度选择]],
	TEACH_BOSSMAP_SIMPLE = "选择难度为简单。通关后将自动解锁下一难度",
	TEACH_BOSSMAP_SURE = "点击创建副本房间",
	TEACH_STRENGTHEN = "想轻松提高战斗力吗？那就来强化装备吧",
	TEACH_STRENGTHENSTART = "开始进行装备强化",
	TEACH_STRENGTHEN_WEAPON = "选择需要强化的武器",
	TEACH_STRENGTHEN_OTHER = "选择强化所需道具",
	TEACH_STRENGTHEN_SELECTSTONE = "选择强化石",
	TEACH_STRENGTHEN_START = "点击强化进行武器提升",
	TEACH_STRENGTHEN_CLOSE = "强化完成，返回大厅",
	--登录界面
	LOGINING = "登录中",
	GET_ROLELIST_SUCCESS = "获取角色成功",
	--创建角色界面
	PLEASE_INPUT_ACTORNAME = "请输入角色名字",
	REGISTER_AGAIN = "重新注册",
	LOGIN_AGAIN = "重新输入",
	--账号界面
	FINDBACK_PSW = "找回密码",
	CHANGE_ACCOUNT = "切换账号",
	CHANGE_PSW = "更改密码",
	FINDBACK_PSW_TIP = "注：输入注册时填写的邮箱即可找回账号与密码",
	EMAIL_SENDED = "邮件已发送",
	OLD_PSW = [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">原始密码:</T>]],
	NEW_PSW = [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">新密码:</T>]],
	PASSWORD_CONFIRM = [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">确认密码:</T>]],
	PLEASE_INPUT_OLD_PSW = "请输入旧密码",
	PLEASE_INPUT_NEW_PSW = "请输入新密码",
	PLEASE_INPUT_PSWCONFIRM = "请输入确认密码",
	CHANGE_PSW_SUCCESS = "修改密码成功",
	VERIFICATION_FAILED = "账号密码不匹配",
	--注册界面
	CLICK_INPUT_ACCOUNT = "点击输入账号",
	CLICK_INPUT_PASSWORD = "点击输入密码",
	CLICK_INPUT_MAIL = "点击输入邮箱",
	CLICK_INPUT_INVITECODE = "点击输入邀请码",
	ACCOUNT	= [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">账号:</T>]],
	PASSWORD1 = [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">密码:</T>]],
	PSW_CONFIRM	= [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">确认密码:</T>]],
	MAIL = [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">邮箱:</T>]],
	INVITE_CODE = [[<T C="80,38,3" S="30" P="0">邀请码:</T>]],
	STAR_MEANS_ESSENTIAL = [[<T C="255,0,0" S="24" P="0">*</T><T C="80,38,3" S="24" P="0">号表示为必填项目</T>]],
	PLEASE_INPUT_ACCOUNT = "请输入账号",
	ONLY_NUM_AND_LETTER = "只能输入数字和字母",
	ACCOUNT_LEN_ILLEGAL = "账号长度不符合要求",
	PLEASE_INPUT_PSW = "请输入密码",
	PSW_LEN_ILLEGAL = "密码长度不符合要求",
	PSWCONFIRM_NOT_THE_SAME = "两次密码输入不一致",
	PLEASE_INPUT_MAIL = "请输入邮箱",
	PLEASE_INPUT_CORRECT_MAIL = "请输入正确的邮箱地址",
	--成长基金界面
	BUY_FUND = "购买基金",
	INTRODUCTION = "说明",
	--每日签到界面
	SIGN = "签 到",
	--物品回收界面
	RECYCLING = "回收",
	WEAPON = "武器",
	CLOTH = "装扮",
	OTHERS = "其他",
	SALE_SUCCESS = "出售成功",
	--强化研究院
	ENTER = "进入",
	--强化界面
	HOLY_STONE = "圣灵石",
	--镶嵌界面
	EQUIPMENT = "装备",
	ATTACK_STONE = "攻",
	DEFENSE_STONE  = "防",
	GEMMOUNTING = "镶嵌",
	PLEASE_ADD_WEAPON_FIRST = "请先放入装备！",
	--升星界面
	IMPROVE = "升星",
	STAR_STONE = "升星石",
	--重铸界面
	FIRE = "淬焰",
	LOCK = "锁",
	--继承界面
	TRANSFER = "继承",
	--合成界面
	MATERIAL = "材料",
	SYNTHESIS = "合成",
	--链接游戏服务器提示
	NETWORK_UNAVAILABLE = "网络连接失败，请稍后重试！(PS:请在良好的网络环境下游戏，以保证良好的游戏体验)",
	SERVER_MAINTAINING = "服务器维护中",
	--好友
	TXT_NOSOCISY_FREND = [[暂时还未加入公会]],
	FRONT_PAGE = "向下滑动翻页",
	NEXT_PAGE = "向上滑动翻页",
	--排行榜
	BATTLE = "战力",
	WIN = "胜利",
	--公会
	CUR_PRESIDENT = "现任会长",
	PRESTIGE = "威望",
	FUNDS = "资金",
	RANK = "排名",
	MY_COMMUNITY = "我的公会",
	CREATE_COMMUNITY = "创建公会",
	COMMUNITY_NAME = "名称:",
	COMMUNITY_LEVEL = "公会等级",
	COMMUNITY_PRESTIGE = "公会威望",
	WIN_RATE = "胜率",
	PLEASE_INPUT_COMMUNITY_ID = "请输入公会ID",
	COMMUNITY_ID_INPUT_MUST_ALL_NUMBER = "公会ID处只能是数字",
	CREATE_COMMUNITY_SUCCESS = "公会建造成功!",
	CLICK_INPUT_NAME = "点击输入名字",
	ALREADAY_APPLAY_FOR_COMMUNITY_MESSAGE = "已提交申请入会信息",
	GOLD_COIN = "金币：",
	DIAMOND = "钻石：",
	ASK_YES_OR_NO_GIVEWAY = "确定转让会长？\n你将与转让目标互换职位哦！",
	MAIL_SEND_SUCCUSS = "邮件发送成功!",
	PRESIDENT = "会长",
	VICE_PRESIDENT = "副会长",
	ELDERS = "长老",
	PICK = "精英",
	NORMAL_COMMUNITY_MEMBER = "会员",
	ENEMY_COMMUNITY = "敌对公会",
	SET_EMEMY_COMMUNITY_SUCCESS = "设置敌对公会成功!",
	FRIEND_ADD_SUCCESS = "好友添加成功",
	SUCCESS_UP_JOB = "成功升职!",
	SUCCESS_DOWN_JOB = "成功降职!",
	ARE_YOU_SURE_DISMISS_THIS_PLAYER = "你确定将%s开除?",
	ALREADY_REMOVE_COMMUNITY = "已被踢出公会!",
	ALREADY_EXIT_COMMUNITY = "已退出公会！",
	COMMUNITY_ALREADY_DISSMISS = "公会已解散!",
	SUCESS_AS_PRESIDENT = "已成功担任会长",
	NOT_REACH_LEVEL_CANNOT_BUILD_GUILD = "等级未达到15级不能建造公会",
	DISMISS_COMMUNITY = "解散公会",
	--密境探险
	YES_OR_NO_SPEND = "是否花费",
	DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE = "亲！钻石不足哦，要来点吗？",
	MEDAL_NOT_ENOUGH_PLEASE_GET_MORE_MEDAL = "徽章不足，请获取更多徽章",
	GAME_HALL = "游戏大厅",
	START = "开始",
	GOLD_COIN_NOT_ENOUGH = "亲！金币不足哦，要来点吗？",
	--副本大厅
	COPY_HALL = "副本大厅",
	FIND_ROOM = "查找房间",
	QUICK_JOIN ="快速加入",
	QUICK_JOIN1 ="快速开始",
	COMMON = "简单",
	DIFFICULTY = "困难",
	HELL = "地狱",
	MODEL = "模式",
	SIMPLE_MODEL_EXPLAIN = "普通的难度，当然奖励也很普通。",
	DIFFICULTY_MODEL_EXPLAIN = "难度有所提高，对应的奖励也有所增强。",
	HELL_MODEL_EXPLAIN = "最好的奖励只属于最勇敢的团队！",
	DIFFICULTY_MODLE_SHOW_ERROR_MEESSAGE = "尚未通过简单模式，无法挑战困难模式。",
	HELL_MODLE_SHOW_ERROR_MESSAGE = "尚未通过困难模式，无法挑战地狱模式。",
	UNABLE_PASS_THIS_CHECKPOINT_ERR_MESSAGE = "你尚未通过上一关，无法挑战该关卡",
	LEVEL_OPEN_THIS_FUNCTION = "级开放此功能",
	QUICKEN = "加速",
	--弹王挑战赛
	EXIT = "退出",
	PLAYER_NAME = "玩家名称",
	PEOPLE_NUM = "人数:",
	WHERE_THE_SERVER = "所在服务器",
	PLAYER_LEVEL = "玩家等级",
	
	--任务，每日签到
	BACK = "返回",
	CONFIRM = "确定",
	SAVE = "保存",
	CANCEL = "取消",
	CALENDAR_WEEK = {
		"日",
		"一",
		"二",
		"三",
		"四",
		"五",
		"六"
	},
	TASK_JUQING = "主线",
	TASK_MEIRI = "日常",
	TASK_TARGET = "任务目标",
	TASK_DESCRIPTION = "任务描述",
	TASK_REWARD = "任务奖励",
	ACTIVE_TIME = "活动时间",
	EXP = "经验：",
	GOLD = "金钱：",
	GET_REWARD = "领取奖励",
	IMMEDIATELY_RECHARGE = "立即充值",
	START_FIGHTING = "开始战斗",
	CONTINUE_GAME = "继续",
	GOODS_INFO = "物品信息",
	RENEWAL = "续期",
	USE = "使用",
	NOLIMIT = "无限期",
	INPUT_NEW_NAME = "请输入新的名称:",
	CLICK_TO_INPUT_NAME = "点击输入新名字",
	USE_RESET_FAIL_NUM = "使用后战斗失败次数清零",
	GIFTBAG_LEVEL_NO = "您的等级还未达到礼包开启条件",
	SPREE_SUCCESS = "恭喜获得以下物品",
	IMPROVE_REWARD = "提升奖励",
	--背包
	COMBAT = "战斗力",
	COMMUNITY = "公会",
	POST = "职位",
	DESIGNATION = "称号",
	LEVEL = "等级",
	HEALTH = "生命",
	DEFENSE = "防御",
	CRIT = "暴击",
	PHYSICAL = "体力",
	ATTACK = "攻击",
	FREESTORM = "免暴",
	ANTIBREAKING = "破防",
	LUCKY = "幸运",
	STRENGTEN = "强化",
	BAG1 = "物品",
	SHOP = "商城",
	NONE = "无",
	HEAD = "头部",
	FACE = "表情",
	BODY = "身体",
	WING = "翅膀",
	RING = "戒指",
	NECKLACE = "项链",
	--游戏大厅
	PRIMARY = "初级频道",
	ADVANCE = "高级频道",
	ROOM_PASSWORD = "密码:",
	ROOM_PEOPLO_NUM = "房间人数",
	MACTH_TYPE = "撮合方式",
	RANDOM = "匹配",
	TEAM = "队伍",
	ROOM_NAME_RANDOM = {"大家来玩吧!",
		"感受刺激的对战!",
		"约吗,敢战否?!",
		"一起来竞技!",
		"战个天昏地暗!"},
	NO_PASSWORD = "无密码",
	INPUT_ROOM_ID = "请输入房间ID",
	ROOM_ID = "房间ID",
	CLICK_TO_INPUT_ID = "点击输入房间ID",
	CLICK_TO_INPUT_PASSWORD = "点击输入房间密码",
	PASSWORD_NOT_MATCH = "密码不正确",
	ROOM_BATTLEING = "别人已经在游戏啦，你就不要插手了~",
	ROOM_FULL = "房间人满为患，凑热闹不是好习惯",
	OPEN_ON_ADVANCED_CHANNEL = "高级频道开启",
	SKILL = "宠物领悟",
	PROP = "道具",
	INVITATION_HAS_BEEN_SENT = "邀请已发送",
	READY_GAME = "准备游戏",
	START_GAME = "开始游戏",
	MATCH_FAILED = "撮合失败",
	TIPS = "小提示",
	ROOM = "房间列表",
	PRIMAY_CHANNEL = "初级频道",
	ADVANCE_CHANNEL = "高级频道",
	TARGET_VIP_LEVEL_OVER_THEN_YOU = "对不起,您的VIP等级不足,无法踢出对方",
	--聊天
	CHAT_SENDMORE = "聊天信息发送过于频繁！",
	CHAT_CONTENTNULL = "请输入聊天内容",
	CHAT_ALL = "全部",
	CHAT_COLORLIAO = "彩聊",
	CHAT_WORLD = "世界",
	CHAT_PRIVATE = "私聊",
	CHAT_CURRENT = "当前",
	CHAT_MSG_CONTENT = "请输入聊天内容！",
	CHAT_MSG_ID = "不可对小助手私聊，请选择好友噢",
	CHAT_SYSTEM = "系统",
	CHAT_RIGHT = "对",
	CHAT_COLORLIAOK = "【彩聊】",
	CHAT_WORLDK = "【世界】",
	CHAT_GONGHUIK = "【公会】",
	CHAT_PRIVATEK = "【私聊】",
	CHAT_CURRENTK = "【当前】",
	CHAT_SYSTEMK = "【系统】",
	CHAT_NOCOLORLABA = "跨服喇叭不足，请先购买该道具！",
	CHAT_NOLABA = "本服喇叭不足，请先购买该道具！",
	--爱心许愿
	REWARD_CURRENTZUAN = "当前累积充值钻石：",
	REWARD_CURRENTLOTTERYTIMES = "当前抽取奖励次数：",
	REWARD_NEXTZUAN = "下阶段奖励需累积充值钻石：",
	REWARD_NEXTLOTTERYTIMES = "下阶段奖励抽取次数：",
	REWARD_MSGCHONGZHI = "无法抽奖，请先充值。",
	REWARD_BTN_FIRSTGET = "领取奖励",
	REWARD_BTN_GET = "充值",
	REWARD_BTN_REWARD = "抽奖",
	REWARD_FIRST_INTORDUCE = "首次充值将获得以下奖励：",
	--商城
	SHOP_LIFT = "生命：",
	SHOP_GONGJI = "攻击：",
	SHOP_BAOJI = "暴击：",
	SHOP_DEFEND = "防御：",
	SHOP_NOCHENGHAO = "<无称号>",
	SHOP_NOGONGHUI = "未加入公会",
	SHOP_GOODSSHEGN = "剩余",
	SHOP_CISHU = "次",
	--活跃度
	ACTIVE_BTN_GET = "领取",
	ACTIVE_BTN_GO = "前往",
	ACTIVE_FINISH = "已完成",
	ACTIVE_GET = "已领取",
	--砸蛋
	THROWINGEGGS_MSG_ZUAN = "本次砸蛋扣除     钻石",
	THROWINGEGGS_MSG_THROWEGG = "正在等待其他玩家砸蛋：",
	--结婚
	MARRY_DREAM_CONTENT = "我走过星光，在神树摘下众神祝福的它，却发现能拥有它的，只有你，世上最美丽的花。",
	MARRY_ROMAN_CONTENT = "一朵是唯一，两朵是你和我……999朵是永远在一起，而你，该拥有漫天玫瑰花雨，所有的幸福合二为一。",
	MARRY_WARM_CONTENT = "银河里最美的星辰，闪烁亿万年的光芒来到我的身旁。我只想用我的名字，将它戴你指上，套牢你一生时光！",
	MARRY_SIMPLE_CONTENT = "我确定它一定适合你，不是因为它的材质，也不是因为它的尺码，而是它带着承诺——你的身边一定有我。",
	AGREE = "同意",
	REJECT = "拒绝",
	MARRY_ITEM_NOT_ENOUGH = "你还没有这个求婚道具哦，是否购买一个？",
	MARRY_OK = "恭喜,%s与你订婚成功！",
	MARRY_FAILD = "求婚失败,%s拒绝了你的求婚！",
	MARRY_END = "解除关系",
	MARRY_END_TIPS = "解除关系将缴纳%d钻石手续费，你是否确定解除订婚关系？",
	MARRY_END_SUCCESS = "%s向我们提交了解除与你的订婚关系申请，并申请成功，你们的订婚关系现已解除。",
	WEDDING_LUXURY = "奢华婚礼",
	WEDDING_RICH = "豪华婚礼",
	WEDDING_ROMAN = "浪漫婚礼",
	WEDDING_ORIGINAL = "普通婚礼",
	WEDDING_ASK_TIPS = "你的伴侣想和你举办一场%s",
	WILLING = "愿意",
	THINK_ABOUT = "考虑一下",
	WEDDING_SUCCUSS = 
[[
恭喜，%s与你结婚成功，
预祝两位百年好合，幸福美满！
]],
	WEDDING_FAILD = "婚礼失败，你的情侣需要更多的时间考虑！",
	WEDDING_DIVORCE = "离婚",
	WEDDING_END_REQUEST = "离婚申请将缴纳%d钻手续费，离婚后婚礼礼服将消失，你是否确定解除结婚关系？",
	WEDDING_END_TIPS = "%s提交了离婚申请，并申请成功，你们的婚姻关系现已解除，结婚礼服也对应消失。",
	GIVE = "赠送",
	GIVE_DIAMOND_TIPS = "%s向你赠送了%d钻石.",
	--战斗
	BATTLE_EXIT_WARNING = "警告:强退会扣除竞技经验!",
	BATTLE_EXIT_WARNING2 = "不要轻易放弃队友噢!",
	BATTLE_EXIT_WARNING3 = "副本通关后即可获得奖励噢!",
	BATTLE_EXIT = "退出",
	BATTLE_EXT_ITEMSKILL_LIMIT = "VIP1开启此功能",
	BATTLE_ANGER_LIMIT = "你的怒气还没满",
	BATTLE_USE_BIGSKILL = "使用大招",
	BATTLE_FAIL_BIGSKILL = "已使用技能，无法继续使用大招",
	--副本房间
	BOSSROOM_SKILLPROP = "技能道具",
	BOSSROOM_INVITATION_HAS_BEEN_SENT = "已发送邀请",
	BOSSROOM_MATCH_FAILED = "撮合失败",
	BOOSROOM_KICKEDOUT= "您被房主踢出房间了",

	BATTLETEAM_PLAYER_ALREADY_ROOM = "该玩家已在房间内",
	--显示炮弹的高度
	BULLET_HEIGHT = "炮弹高度: %d米",
	--新手战斗教学
	SKILL_DIVIDE_THREE = "散射x3",
	SKILL_ATTACKUP_FIVE = "攻击+50%",
	SKILL_ADDTIMES_ONE = "连发+1",
	ITEM_BLOOD = "医疗包",
	START_MY_TURN = "轮到你出手啦",
	START_OTHER_TURN = "轮到对方出手啦",
	TEACH_GUIDE_USEFLY = "点击飞行器，可以让角色下次攻击变为飞行",
	TEACH_GUIDE_FLY = "手指按住人物向飞行的反方向拖动，可使人物飞行到目标区域",
	TEACH_GUIDE_BIGSKILL = "怒气值满后，可点击Power释放必杀技！对敌方造成巨大伤害。",
	REACH_TOP_STRENGTHENLEVEL = "装备已强化到最高等级,不能继续强化！",
	BOSSROOM_SWITCH_DIFFICULTY_TIPS1 = "尚未通过简单模式，无法挑战困难模式",
	BOSSROOM_SWITCH_DIFFICULTY_TIPS2 = "尚未通过困难模式，无法挑战地狱模式",
	BOSSROOM_SWITCH_DIFFICULTY_TIPS3 = "切换失败，房间尚有未满足条件的成员",
	SOUND = "音效",
	DIALOG_GUIDE_FAST_ENTER = "点击这里，可快速进入房间参加战斗!",
	BUY_STARSTONE_MESSAGE = "亲！升星石不足了哦，您是否购买该道具？",
	CANCEL_ENEMY_COMMUNITY_SUCESS = "取消敌对公会成功",
	WND_EXISTACCOUNT_ACCOUNT = "账号:",
	WND_EXISTACCOUNT_PASSWORD = "密码:",
	E_BATTLE_GIFTYES = "有",
	SHOP_PAY = [[<T C="255,255,255" S="30" >]]..[[%d天: ]]..[[</T>]]..[[<I>%s</I><T C="232,223,0" S="30" >]]..[[%d]]..[[</T>]]..[[<T C="255,255,255" S="30" >]]..[[钻]]..[[</T>]],
	LOADING_TIP = "可以通过强化来提升武器、装扮的基础属性哦",
	BATTLE_MODEL_SPORT = "竞技模式",
	BATTLE_MODEL_REVIVE = "复活模式",
	BATTLE_MODEL_MIX = "混战模式",
	BATTLE_MODEL_COMMUNITY = "公会模式",
	ROOM_BEINVITED = "%s 邀请你参加\n%s(%s)",
	BATTLE_NOT_MY_TURN = "还未轮到你的操作回合",
	LEVEL_NOT_ENOUGH_CHALLENGE = "你还没达到%d级,无法挑战该关卡",
	ACCELERATE_SUCCESS = "加速成功",
	ONLY_ROOMOWNER_CAN_SELECT = "只有房主才能选择难度哦！",
	DOWNLOAD_RES_FAIL_TIPS = "对不起，网络连接不可用，请检查网络设置",
	NO_SPACE_TO_DOWNLOAD_TIPS = "对不起，您的设备存储空间不足，请清理后重登游戏",
	ACTIVE_NOLEVEL = [[您的等级不足，需达到%d级才开启此功能]],
	NEED_DOWNLOAD_TIPS = "您好,本次更新需要下载%0.2fMB.(温馨提示:文件较大,建议使用WIFI下载)",
	NEED_DOWNLOAD_TIPS_V16 = "游戏将进行完整更新，请耐心等待。",
	SIGN_REWARD = "获得：",
	SHOP_DAY = [[%d天]],
	RESOURCES_LOADING = "正在玩命加载中",
	DAILYSIGN_REWARD = "每日签到奖励",
	CONTINUALSIGN = "连续签到",
	MONTHLYSIGN = "本月签到",
	DAILYSIGN_MSG = "天可获得",
	STAR_LEVEL = "星级",
	POWER = "力量",
	AGILITY = "速度",
	TIZHI = "体质",
	SHI = "石",
	SUGGESTION_INIT = "点击输入内容，(150个字符)",
	CHECK_VESION = "资源检测中",
	LOADING_TIPS = {
		[[可以通过锻造来提升装备的基础属性哦.]],
		[[战斗中使用两个手指能进行缩小扩大的操作]],
		[[亲,达到15级就能创建属于自己的公会哦~]],
		[[好友之间每日都可互赠活力哦~]],
		[[手指长按角色两边可让角色左右爬行哦!]],
	},
	RECHARGE_FAIL = "充值失败!",
	SELECT_ALL = "全选",
	BATTLE_RECONNECT_FAIL = "重新连接战斗失败,返回大厅",
	RECHARGE_SUCCESS = "充值成功！",
	REWARD_FIRST = "领取首充奖励成功",
	SHOOT_GUIDE_CLOSE = "恭喜你到达%d级！将不再触发【自动引导】功能！努力练习新玩法吧！",
	LOGIN_FAILD = "请使用正确账号登录.",
	ROLEINFO_MATE ="伴侣",
	MARRY_PROPOSE = "我要求婚",
	WEDDING_LIST = "婚礼列表",
	WEDDING = "举办婚礼",
	RECHARGETIP = "充值赢暴击奖励 ",
	TASK_UPEXP_LIMIT = "该任务已达到最高提升等级",
	BRIGE_GROOM_NAME = "新郎:",
	BRIGE_NAME = "新娘:", 
	START_TIME = "开始时间:",
	UPPHOTO = "上传头像:",
	RECHARGEFAIL = "未能获得返利，请再接再厉!",
	RECHARGESUCCESS = "恭喜您获得充值暴击钻石返利!",
	EXIT_WEDDING_SCENE = "是否退出婚礼现场？",
	NOT_WEDDING_LIST = "暂无婚礼举办信息",
	LEO = "狮子座",
	PHOTO = "头像",
	SEX = "性别",
	DISTANCE = "距离",
	SINGLE_MAP_USEVIGOR = "活力消耗:",
	SINGLE_MAP_VIGOR = "活力值：",
	SINGLE_MAP_CHALLENGE = "挑战次数:",
	RECHARGEDESC = "充值钻石即可累计暴击值，达到一定暴击值后将有机会获得多倍返钻奖励！ 充值金额越大，获得返钻倍数越大哦！",
	WEDDING_OVER = "本场婚礼已经结束！",
	NEXT_PAGE_TIP = "向上拖动释放后加载下一页",
	FRONT_PAGE_TIP = "向下拖动释放后加载上一页",
	VOICECHAT = "语音屏蔽",
	SUGGESTTYPE="意见类型:",
	UPPHOTOFAIL = "图片上传失败!",
	SUGGESTTYPE_SUGGEST="建议",
	SUGGESTTYPE_QUESTIONASK="问题咨询",
	SUGGESTTYPE_PAYASK="充值咨询",
	LITLE_MAP = "地图",
	NEED_UPDATE_VERSION = "当前版本较低,请更新新版本.",
	TIP_INPUT_ACCOUNT = "由字母(区分大小写)和数字组成,长度为6-16位",
	TIP_INPUT_PASSWORD = "由字母(区分大小写)和数字特殊符号组成,长度6-12位",
	TIP_INPUT_PASSWORD_CONFIRM = "请再次输入密码",
	TIP_INPUT_MAIL = "请填写个人电子邮箱以作找回密码使用",
	ExchangeGift = "请输入兑换码:",
	INVITECODE = "邀请码",
	PURCHASE = "购买商品",
	CHALLENGE = "挑战关卡",
	WIPE_OUT = "扫荡",
	REFRESH = "刷新",
	ADDFRIEND = "添加好友",
	DELFRIEND = "删除好友",
	MARRY_GUEST = "来宾",
	APPLY_ATTEND_COMMUNITY = "申请入会",
	DAY = "天",
	RECHARGE_ORDER_FAIL = "订单验证失败",
	RECHARGE__IN_PROCESS = "订单正在处理中",
	DOWNROAD_REQUIRE_SD_CARD = "运行此应用必须有SD卡存在",
	SELECTROLE_ENTER_GAME = "进入游戏",
	YES = "是",
	DOWNLOADREWARD_BADGE = "徽章",
	DOWNLOADREWARD_TIP = 
[[
游戏将进行完整更新，更新后可领取以下物品：
(注：奖励只发放一次.)
]],
	NO_BLACKCHAR = "账号或密码不能有空白字符",
	NO_CONTROLCHAR = "密码不能有特殊字符",
	GOTOPROTOCOL = "查看《用户协议》",
	ISBLANKKEY= "输入内容不能为空!",
	PLAYER_RENAME = "角色改名成功",
	COMMUNITY_RENAME = "公会改名成功",
	MULTI_SCRIPT = "组队副本",
	SINGLE_SCRIPT = "探险之地",
	BAG = "背包",
	CARDS = "卡牌",
	PRACTICE = "修炼",
	BSTRONG = "我要变强",
	CLOSE_SCRIPT = "未开启",
	PRACTICE_BLOOD = "血量",
	PRACTICE_ARMOR = "护甲",
	NOSTONE_STRENGTHEN = "未镶嵌宝石",
	AVOIDINJURY= "免伤",
	XH_REDUCEBURY = "免坑",
	ACTIVITY = "活跃度",
	UNLIMITE = "不限",
	CHOISE_CARTON = "选择副本",
	REWARD_CARTON = "副本奖励",
	SWEEP_TIME = "扫荡次数",
	NEED_ACTIVITY = "所需活力",
	LEFT_ACTIVITY = "剩余活力",
	SWEEP_DESC = 
[[
1.只有已通关的关卡才能扫荡.
2.扫荡之前可以选择扫荡次数.
3.扫荡期间不能终止扫荡.
4.扫荡获得奖励会自动添加到背包.
5.扫荡结束后，可以查看所获得的所有奖励.
]],
	OVER_SWEEP_COUNT = "不能超过最大的扫荡次数！",
	SWEEPING_NOT_SHUT = "正在扫荡，不能关闭！",
	SWEEPING_NOW = [[<T C="255,255,255" S="25" P="0">正在进行扫荡......</T>]],
	SWEEPTIME_EXP = [[<T C="255,255,255" S="25" P="0">第</T><T C="0,246,34" S="25" P="0">%d </T><T C="255,255,255" S="25" P="0">次：获得</T><T C="0,246,34" S="25" P="0">%d </T><T C="255,255,255" S="25" P="0">经验，</T>]],
	SWEEP_GET_SWARD = [[<T C="255,255,255" S="25" P="0">获得</T><T C="0,246,34" S="25" P="0"> %s </T>]],
	SWEEP_TIMMING = [[<T C="255,255,255" S="25" P="0">扫荡进行中</T><T C="0,246,34" S="25" P="0">［%s］</T><T C="255,255,255" S="25" P="0">后结束</T>]],
	CHECK_REWARD = "查看奖励",
	NO_LESS_ONE = "扫荡次数不能少于1！",
	SWEEP_ENDIND = [[<T C="255,255,255" S="25" P="1">扫荡结束</T>]],
	SWEEP_MAPNAME = [[<T C="255,255,255" S="25" P="0">本次扫荡关卡：</T><T C="0,246,34" S="25" P="0">%s</T>]],
	SWEEP_TIMES = [[<T C="255,255,255" S="25" P="0">关卡剩余挑战次数：</T><T C="0,246,34" S="25" P="0">%s</T>]],
	SWEEP_USEDACT = [[<T C="255,255,255" S="25" P="0">总共消耗活力值：</T><T C="0,246,34" S="25" P="0">%d</T>]],
	SWEEP_WINEXP = [[<T C="255,255,255" S="25" P="0">总共获得经验：</T><T C="0,246,34" S="25" P="0">%d</T>]],
	--在线奖励
	REWARD_BTN_LOGIN = "登录",
	REWARD_BTN_ONLINE = "在线",
	BUY_UNSUCCESS = "亲！您的购买次数已达今日最大上限了，提升VIP等级便可以提升购买次数上限哦！",
	TASK_QUICKCOMPLETE = "快速完成",
	TASK_DOING = "进行中",
	SPECIAL = "特殊",
	CONTINUOUSATTACKS = "连续攻击",
	MIGHTHIT = "威力一击",
	TRACKPOSITION = "追踪定位",
	UNMOUNTED = "未镶嵌",
	RENEWALS = "续费",
    RANGE  = "范围",
	SKAT = "大招",
    GEM = "宝石",
    WEAR = "穿上",
	UNROYAL = "卸下",
    SELL = "出售",
	TRYWEAR = "试穿",
	VIP = "会员",
	STRENGTENRECV = "强化等级达到%d级可获得",
	PRACTICE_NOLEVEL= "修炼等级已满，请提升等级到%d",
    LAY = "放置",
	DAILY_FRIST_RECHARGE = "每日首次充值将获得以下道具",
	NO_CHALLENGE_TIMES = "挑战次数不够，不能进行扫荡！",
    CANNOT_BUY_VIGOR = "活力已经是最大值，不能继续购买！",
	UPGRADE = "我要升级",
	MAP_EVENT = "特殊事件",
	MAP_EVENT_ON = "开启",
    TEACH_CHICK = "点击确定",
	MAINTASK_UPLEVEL_TITLE = "升级到%d级",
    MAINTASK_UPLEVEL_GOALS = [[<T C="0,246,34" S="24" P="0">升级到%d级</T><T C="255,0,0" S="24" P="0">（%d/%d）</T>]],
    IKNOW = "我知道了",
    DAILY_RECHARGE = "日充",
	TZSX = "套卡属性",
	IMPROVE_REWARD_NEED = "提升奖励需要消耗",
    NOMORETIP = "不再提示",
	MONTH_CARDS_TIP6 = "已过期",
	MONTH_CARDS_DIAMOND = "钻石",
	CONTINUOUS = "连续",
	BUY = "购买",
    COMPLETE_TASK = "完成任务",
	RINGLEFT = "戒指",
    VIP_TIP02 = "当前已经为满级VIP，感谢您的支持！",
    VIP_TIP04 = "您当前为:",
    VIP_TIP06 = " 再充值",
    VIP_TIP08 = [[<T C="255,255,255" S="32" P="0">该礼包需要达到</T><T C="255,255,0" S="32" P="0">VIP%d</T><T C="255,255,255" S="32" P="0">才能领取</T>]],
    VIP_POWER = "特权",
    PRACTICE_DAY_COST_TIP = "你的勋章不足，当前等级每日消耗勋章%d个",
	RINGLEFTEXP = "戒指",
	REWARD_EXPLAIN_MESSAGE = 
[[
1.每日的首次充值可根据额度获得对应次数的奖励.
2.奖励次数最高上限为%d次.
3.%d-%d钻石获得%d次，%d-%d钻石可获得%d次，%d钻以上可获得%d次.
]],
    TEACH_OPEN = "新功能开启",
    PRACTICE_HELP = 
[[
1.35级开启修炼功能.
2.修炼等级共80级.
3.完成日常任务及领取VIP礼包可获得徽章.
4.徽章可用于提升修炼，修炼等级提升后获得对应属性.
]], 
	ATGHLETICS = "竞技",
	QUICK_COMPLETE_NEED = "快速完成该任务需要消耗",
	GIRL = "性别(女)",
	BOY = "性别(男)",
	DEFAULT = "默认",
	TIP_INPUT_OLD_PASSWORD = "输入原始密码",
	ISFRIEND = "该玩家已在好友列表中",
	PRACTICE_ATTRIBUTE_NAME = "修炼属性",
    PRACTICE_NEED_NAME = "修炼需求",
	TIP_WILLBE_OPEN_MULTILPE = "%d级开启组队副本",
	MONEY_UNIT = "元",
	NONE_CHALLENGE_TIMES = "挑战次数不够！",
	ZSLEVEL_NOT_ENOUGH_CHALLENGE = "你还没达到转生%d级,无法挑战该关卡",
	ENERGY = "活力值",
	BUY_VIGORS = "活力值不足，可以吃甜甜圈或者直接购买增加.",
	GETREWARD_GOLDS = [[<T C="0,246,34" S="25" P="0"> %d </T><T C="255,255,255" S="25" P="0">金币，</T>]],
    SWEEP_WINGOLDS = [[<T C="255,255,255" S="25" P="0">总共获得金币：</T><T C="0,246,34" S="25" P="0">%d</T>]],
	MAILMAXLENG = "点击编写邮件内容，最多200个字符",
	MAILTITELENT = "点击输入邮件主题",
	NUM1 = "数量",
	Praticefull = "当前属性修炼等级已满!",
	MONTH_CARDS = "月卡",
	DIALOG_TASK_ISLAND = "当前还有未完成任务，有空多看看噢！",
    CAN_NOT_MATERIALS = "合成材料数量不足!",
    TEACH_BOSS_NAME = "蘑菇团团",
    TEACH_BATTLE_TALK_TEXT_8 = "小蘑菇的攻击虽然不咋地！可是你还是太嫩了点~被爆的感觉还真不是一般好的。。。照着我的指示飞吧~骚年！",
	CONNECTED_SERVER = "与服务器密集沟通中",
    DOWNLOAD_RESOURCE = "资源下载中",
	SETTLMENT_KILL = "击杀", 
	SETTLMENT_DAMAGE = "伤害", 
	SETTLMENT_HIT = "命中", 
	SETTLMENT_GANGFIGHT = "公会战",  
	LOTTERY_OPEN = "开启神秘格子",
	LOTTERY_OPENNING = "正在开奖中",
    duihuan = "兑换",
	USEPASSWORD = "使用密码",
	SetPASSWORD = "设置密码",
    MAINTASK_UPLEVEL_GOALS_NEEDZS = [[<T C="0,246,34" S="24" P="0">转生%d级</T><T C="255,0,0" S="24" P="0">(%s %d/%s %d)</T>]],
    MAINTASK_UPLEVEL_ZS_TITLE = "升级到转生%d级",
	TASK_BRANCH = "支线",
    SINGLEMAP_DESC = 
[[
1.进入探险之地需要消耗活力值，活力值每6分钟恢复一点.
2.关卡不同消耗的活力值也不同.
3.关卡不同每天通关次数也不相同.
4.关卡通关次数每天凌晨重置.
5.关卡开启有等级限制.
6.达到等级限制后需要通关前一个关卡才能挑战下一个关卡.
7.对已通过的探险之地可进行扫荡操作，需消耗扫荡卷.
8.VIP4可享有连续扫荡特权.
]],
    STAR_SOUL_BUTTON_UPDATE = "升级", 
    STAR_SOUL_LIGHT_FAIL = "升级失败",
	ACTIVITY_END_COUNTDOWN = "结束倒计时",
    ACTIVITY_START_COUNTDOWN = "开始倒计时",
    ACTIVITY_EATTING_TXT = "品尝",
    ACTIVITY_TASTEOK_TIPS = "成功添加活力值",
	BATTLE_MODEL_RANK = "排位赛",
    CHESTTITLE = "请选择开启宝箱数量",
	CHEXTTIP = "一次最多开%d个",
    ACITIVITY_RECHARGE_MSG = "该帐号未有充值记录,无法领取奖励",
	SALETIP = "出售物品中拥有强化或升星或镶嵌属性，如果出售，该物品将消失，是否继续操作？",
	CARD_ADVANCE = "进阶",
	PLAYER = "玩家",
    OFFLINE = "不在线.",
	WIPE_OUT_MULTI = "扫荡%d次",
    WIPEOUTNUM = "扫荡卷不足",
	ACTIVITY_TIME_KEY = "活动时间",
    ACTIVITY_TIMELINE_KEY = "%d月%d日-%d月%d日",
    ACTIVITY_COST_KEY = "累计消费",
	ACTIVITY_CURRENT_COMPETILIVE_LEVEL = "当前竞技等级:",
	ACTIVITY_CURRENT_FIGHTING = "当前战力:",
	ACTIVITY_SHOW_LEVEL = "%d级",
	ACTIVITY_BIG_GIFTPACKS = "大礼包",
	ACTIVITY_CUMULATIVE_LOGIN = "已累计登录",
	ACTIVITY_CUMULATIVE_LOGIN_CP = "天",
	ACTIVITY_SUCCESSFUL_STRENGTHEN_ANY = "成功强化任意",
	ACTIVITY_EQUIPMENT_NUMBER = "%d件",
	ACTIVITY_EQUIPMENT_TO = "装备至",
	ACTIVITY_EQUIPMENT_TOTARGET = "+%d",
	ACTIVITY_CURRENT_CONSUMPTION = "当前消费",
	ACTIVITY_PREPAID_PHONE = "当前充值",
	CHESTMAXNUM = "已达最大数量",
	CHESTMINNUM = "已达最小数量",
    CHESTNOKEY = "钥匙不足",
	ROOM_FIND_TIPS = "请输入正确的房间号码",
	EQUIP = "装备",
	BRACELET = "手镯",
	MEDAL = "勋章",
	TREASURE = "宝物",
    CREATE_ROOM = "创建房间",
	CHANGE = "修改",
	BAGBTNTEXT3 = "加好友",
	CLOTHES = "服装",
	HALL = "大厅",
    MASTER_APPRENTICE = "师徒",
	MASTER = "师傅",
	APPRENTICE = "徒弟",
    COMBATTING = "战斗中",
	ROOM_NUMBER = "房号:",
    ROOM_NAME_BATTLE = "房名:",
	EVOLUTION = "进化",
    REBIRTH = "重生",
    MY_PETS = "我的宠物",
    INTELLIGENCE = "资质",
    EXTRACTING_PETS = "获得宠物",
    EXTRACTION = "抽取",
    EXTRACTION_AGAIN = "再来一次",
	PET_REBIRTH = "宠物重生",
	DRESS = "时装",
	ROOM_SETTING = "房间设置",
	INVITE_PLAYER = "邀请玩家",
	PUT_SYNTHESIS_MATERIAL = "请放置想要合成的物品",
    CANNOT_FIND_SYNTHESIS_DATA = "无法合成",
    PLAYER_RANK_SCENEWORLDBOSS = "我的排名：",
    MAYBE_SUCCESS_SCENEWORLDBOSS = "几率成功",
    RANK_TIPS_1 = "第%d名",
    RANK_TIPS_2 = "%d+名",
    RANK_TIPS_3 = "第%d~%d名",
    HURT_RANK_INFO = "伤害排名：",
	COPY_VIGOUR_COST = "消耗活力: ",
    NORMAL = "普通",
    PROBABILITY_DROP = "概率掉落",
    MUST_SUCCESS_SCENEWORLDBOSS = "必然成功",
	HURTTIPS_MSG_1 = "伤害排名前三名的玩家有丰厚奖励",
    HURTTIPS_MSG_2 = "击杀深渊恶犬的玩家会获得额外的击杀奖励",
	CHALLENGE_NOT_ENOUGH = "关卡挑战次数不足",
	SWEEP_INDEX = "第%d战",
	FIRST_PASS = "首次通关",
    PASS_REWARD = "通关奖励",
    BACK_TIME = "%02d秒后自动返回",
    LEVEL_LOCKED = "通关上一个关卡才能挑战该关卡",
    LEVEL_UNREACHED = "%d级开启该关卡",
	ACHIE_TITLE = "成就",
    ACHIE_EFFECT = "称号属性",
    DESIGNATION_NO = "暂无称号",
    DESIGNATION_SHOW = "当前称号",
    DESIGNATION_ASSOCITION = "公会称号",
    DESIGNATION_ACTIVITY = "活动称号",
    DESIGNATION_SPECIAL = "特殊称号",
    DESIGNATION_SHIP = "结婚称号",
	MASTER_DESIGNATION = "师徒称号",
    DESIGNATION_ACHIE = "成就称号",
    PLAYER_LEVEL_UNREACHED = "%d级开启世界聊天",
	WAITING = "等待中",
	CREATE_COPY = "创建副本",
    DIFFICULTY_LEVEL = "难度",
    RESET = "重置",
    RESET_TIPS = [[<T S="24" C="220,211,185">该副本的挑战次数=</T><T S="24" C="220,0,0">%d</T><BR>10</BR><T S="24" C="220,211,185" P="0">消耗</T><I>%s</I><T S="25" C="246,246,0" P="0">%d%s</T><T S="24" C="220,211,185" P="0">可以重置副本继续挑战</T>]],
	WAITING_OTHERS_TURN_CARD = "正在等待其他玩家翻牌:",
    TURN_CARD_COST = [[<T S="26" C="220,211,185" P="0">本次翻牌扣除</T><I P="0">%s</I><T S="24" C="246,246,0" P="0">%d钻石</T>]],
    PLAYER_LEVEL_UNLOCK_COPY = "角色%d级解锁该副本",
    COPY_LOCKED = "通关上一个副本才能挑战该副本",
    PET_REBRITH_EXPLAIN = "宠物重生可以获得相应的宠物升级时消耗的经验宠物和该宠物进阶所需的宠物",
	RESET_NOT_ENOUGH = "重置次数不足",
	CONFORM_CHANGE = "确认更改",
    LEVEL_UNLOCK = "%d级解锁",
    LOCKED = "未解锁",
	RANKLIST_ITEM_MRT = "名人堂",
    RANKLIST_ITEM_RYD = "荣誉殿",
    RANKLIST_ITEM_SJH = "设计汇",
    RANKLIST_ITEM_ZHANLI = "战力榜",
    RANKLIST_ITEM_DENGJI = "等级榜",
    RANKLIST_ITEM_CHONGWU = "宠物榜",
    RANKLIST_ITEM_ZUOQI = "坐骑榜",
    RANKLIST_ITEM_ZHANJI = "战迹榜",
    RANKLIST_ITEM_CHENGJIU = "成就榜",
    RANKLIST_ITEM_GONGHUI = "公会榜",
    RANKLIST_ITEM_MEILI = "魅力榜",
    RANKLIST_ITEM_SHIDE = "师德榜",
    RANKLIST_ITEM_ENAI = "恩爱榜",
    POPUPMENUSTRING1 = "加为好友",
	POPUPMENUSTRING2 = "移至黑名单",
	POPUPMENUSTRING3 = "私聊",
	POPUPMENUSTRING4 = "删除",
	POPUPMENUSTRING5 = "降职",
	POPUPMENUSTRING6 = "开除",
	POPUPMENUSTRING7 = "移至好友",
	POPUPMENUSTRING8 = "查看资料",
	POPUPMENUSTRING9 = "发送邮件",
	POPUPMENUSTRING10 = "升职",
	POPUPMENUSTRING11 = "确认选定",
	POPUPMENUSTRING12 = "踢出房间",
	POPUPMENUSTRING13 = "转让会长",
	DAILYCOPY_NOT_OPEN_TIPS = "该副本%s，今日不可挑战",
    DAILYCOPY_LOCKED_TIPS = "还没有解锁该副本，不可挑战",
    DAILYCOPY_OPEN_DAY = "周%s开放",
    OPEN_EVERYDAY = "每日开放",
	NUMBER_LEVEL = "第%d层",
    PASS_CONDITION = "通关要求:",
    SWEEPING = "扫荡中",
    REMAIN_TIME = "剩余时间:",
    REMAIN_RESET_COUNT = "剩余重置次数: ",
	BELONG_TO_COMMUNITY = "所属公会",
    CURRENT_PET = "当前宠物",
    PET_COMBAT = "宠物战力",
    MOUNT_LEVEL = "坐骑等级",
    MOUNT_GRADE = "坐骑评分",
    KING_COMPETITION = "弹王赛",
    COMPETITION_TIMES = "竞技场次",
    REACH_ACHIEVEMENT = "成就达成",
    COMBAT_IN_ALL = "总战力",
    USERRCP = "魅力值",
    DISCIPLE = "出师徒弟",
    HUSBAND = "丈夫",
    WIFE = "妻子",
    COUPLE_LOVE = "恩爱值",
    SETTING_GAME_SETTING = "游戏设置",
    SETTING_CREATE_ACCOUNT = "创建账号",
    SETTING_INPUT_ACCOUNT = "请你输入账号户名",
    SETTING_INPUT_PASSWORD = "请你输入账号密码",
    SETTING_INPUT_SUREWORD = "再次输入账号密码",
    SETTING_INPUT_MAIL = "请输入绑定邮箱",
    SETTING_SERVERS_STATE_FULL = "火爆",
    SETTING_SERVERS_STATE_CROWD = "拥挤",
    SETTING_SERVERS_STATE_GOOD = "流畅",
    SETTING_SERVER_AREA = "区",
    SETTING_EXCHANGEWORD = "兑换码",
	COMMUNITYLOG1 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62" P="0">加入了公会</T>]], 
    COMMUNITYLOG2 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62">将</T><T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62" P="0">提升为</T><T S="22" C="233,166,62" P="0">%s</T>]], 
    COMMUNITYLOG3 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62">退出了公会</T>]], 
    COMMUNITYLOG4 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62">将</T><T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62" P="0">降职为</T><T S="22" C="233,166,62" P="0">%s</T>]],
	COMMUNITYLOG5 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62">将</T><T S="22" C="233,166,62" P="0">公会</T><T S="22" C="233,166,62" P="0">升级到</T><T S="22" C="233,166,62" P="0">%d级</T>]], 
    COMMUNITYLOG6 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62">将</T><T S="22" C="233,166,62" P="0">公会商店</T><T S="22" C="233,166,62" P="0">升级到</T><T S="22" C="233,166,62" P="0">%d级</T>]], 
    COMMUNITYLOG7 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62">将</T><T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62" P="0">开除出了公会</T>]], 
    COMMUNITYLOG8 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62">捐献</T><T S="22" C="233,166,62" P="0">%d钻石</T><T S="22" C="233,166,62" P="0">获得</T><T S="22" C="233,166,62" P="0">%d点贡献</T>]], 
    COMMUNITYLOG9 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62">捐献</T><T S="22" C="233,166,62" P="0">%d金币</T><T S="22" C="233,166,62" P="0">获得</T><T S="22" C="233,166,62" P="0">%d点贡献</T>]], 
	COMMUNITYLOG10 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62">将</T><T S="22" C="233,166,62" P="0">公会图腾</T><T S="22" C="233,166,62" P="0">升级到</T><T S="22" C="233,166,62" P="0">%d级</T>]], 
	COMMUNITYLOG11 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62">将</T><T S="22" C="233,166,62" P="0">技能学院</T><T S="22" C="233,166,62" P="0">升级到</T><T S="22" C="233,166,62" P="0">%d级</T>]],
	FRIEND = "好友",
	RANKING = "排行",
	FRIENDNUM = "好友数量",
	TODAYRECV = "今日活力领取剩余次数",
	INVITE = "邀请",
	AKEYGIFT = "一键赠送",
	TOWER_MY_RECORD = "我的记录:",
	PET_SUM_EXCEED_ALTER ="最多可以拥有一百个宠物",
	CHAT_ME = "我",	
	SINGLECOPY_LOCKED_TIPS = "通关上一个副本所有关卡才可以查看下一个副本喔",
	HOUR = "时",
	MINUTE = "分",
	SECOND = "秒",
	AGING = "时效",
	APPFRIEND = "申请好友",
	COMMUNITYINFO1 = "暂无公会信息,你可以自己创建公会哦!",
	COMMUNITYINFO2 = "公会名称不能为空",
	COMMUNITYINFO3 = "名称含有敏感字",
	COMMUNITYINFO4 = "该公会名称已存在，请重命名",
	COMMUNITYINFO5 = "名称超过8个汉字",
	COMMUNITYINFO6 = "你输入的公会不存在",
	COMMUNITYINFO9 = "已提交申请，请耐心等待回复",
	COMMUNITYINFO17 = "公会人数已满无法加入公会",
	COMMUNITYINFO22 = "公会信息",
	COMMUNITYINFO23 = "请先转让会长",
	COMMUNITYINFO24 = "是否确定退出公会，\n公会将被解散      ",
	COMMUNITYINFO27 = "公会图腾等级升级成功",
	COMMUNITYINFO29 = "公会图腾已是最高等级",
	COMMUNITYINFO30 = "请先提升公会等级",
	COMMUNITYINFO31 = "公会威望不足",
	COMMUNITYINFO32 = "技能学堂等级升级成功",
	COMMUNITYINFO33 = "技能学堂已是最高等级",
	COMMUNITYINFO34 = "技能学习成功",
	COMMUNITYINFO35 = "公会商店等级升级成功",
	COMMUNITYINFO37 = "个人贡献不足",
	COMMUNITYINFO38 = "公会商店等级不足，无法购买",
	COMMUNITYINFO39 = "公会商店已是最高等级",
    COMMUNITYINFO40 = "会员%s加成:",
	COMMUNITYINFO41 = "请先提升技能学堂等级",
	COMMUNITYINFO42 = "已经达到最高等级",
	COMMUNITYINFO43 = "需达到%d级公会才开放此建筑",
	COMMUNITYINFO44 = "点击输入宣言内容",
	COMMUNITYINFO45 = "公会已是最高等级",
	COMMUNITYINFO46 = "是否花费%d钻石刷新？",
	COMMUNITYINFO47 = "入会成员基本等级设定:",
	COMMUNITYINFO48 = "等级设置只能是数字",
	COMMUNITYINFO49 = "你还未达到该公会设定的招收等级",
	COMMUNITYINFO50 = "今日贡献",
	COMMUNITYINFO51 = "登录时间",
	COMMUNITYINFO53 = "退出公会将清除公会贡献，\n确定退出公会？",
	COMMUNITYINFO54 = "点击输入邮件内容(最多200个字符)",
	COMMUNITYINFO55 = "会长:",
	COMMUNITYINFO56 = "宣言:",
	COMMUNITYINFO57 = "威望:",
	COMMUNITYINFO58 = "公会宣言:",
	COMMUNITYINFO59 = "个人贡献:",
	COMMUNITYINFO60 = [[<T S="20" C="127,70,26" P="0">捐献</T><I Z="0.6">%s</I><T S="20" C="127,70,26" P="0">%d,获得</T><I Z="1">ui/common/common_icon_ghgx.png</I><T S="20" C="127,70,26" P="0">%d和</T><I Z="1">ui/common/common_icon_gzww.png</I><T S="20" C="127,70,26" P="0">%d</T>]],
   	COMMUNITYINFO61 = [[<T S="20" C="127,70,26" P="0">捐献</T><I Z="0.8">ui/common/common_icon_jinbi.png</I><T S="20" C="127,70,26" P="0">%d,获得</T><I Z="1">ui/common/common_icon_ghgx.png</I><T S="20" C="127,70,26" P="0">%d和</T><I Z="1">ui/common/common_icon_gzww.png</I><T S="20" C="127,70,26" P="0">%d</T>]],
	COMMUNITYINFO62 = "图腾加成持续时间",
	COMMUNITYINFO63 = "设置等级数量必须小于等于%s",
	COMMUNITYINFO64 = "（PS：公会战绩排行每一周都会重置！）",
	COMMUNITYINFO65 =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> 每周一到周六将开启公会战</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> 公会战是匹配模式的3V3</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> 公会战只能与其他公会战队进行战斗，自己公会战队将不会被匹配到一起战斗</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> 公会战战斗结束后玩家将会根据自己的战斗表现获取对应的公会战积分</T><BR></BR>
<T C="158,0,0" S="22" P="0">5.</T><T C="62,34,8" S="22" P="0"> 公会战积分将会被统计，将作为公会战公会战绩排名、个人排名的排名依据</T><BR></BR>
<T C="158,0,0" S="22" P="0">6.</T><T C="62,34,8" S="22" P="0"> 个人战绩将一天一重置，战绩排名奖励也是一天一发放</T><BR></BR>
<T C="158,0,0" S="22" P="0">7.</T><T C="62,34,8" S="22" P="0"> 公会战绩将一周一重置，战绩排名奖励将在周日统一发放</T><BR></BR>
<T C="158,0,0" S="22" P="0">8.</T><T C="62,34,8" S="22" P="0"> 战绩排名奖励都将以邮件形式发放，所以请多留意邮件信息</T><BR></BR>
]],
	COMMUNITYINFO66 = "（PS：个人战绩排行每日凌晨重置！）",
	COMMUNITYINFO67 = "%d战%d胜",
	COMMUNITYINFO68 = "周一到周六开启公会战",
	COMMUNITYINFO69 = "公会达到%d级才开启此功能",
	COMMUNITY1 = "会员审批",
	COMMUNITY2 = "修改宣言",
	COMMUNITY3 = "公会升级",
	COMMUNITY4 = "公会设置",
	COMMUNITY5 = "群发邮件",
	COMMUNITY6 = "退出公会",
	CommunityExplain1 =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> 公会图腾可提供给会员攻防血属性加成</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> 公会图腾等级越高，所拥有的属性加成越多</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> 升级公会图腾需消耗公会威望</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> 公会图腾的等级永远≤公会等级</T><BR></BR>
<T C="158,0,0" S="22" P="0">5.</T><T C="62,34,8" S="22" P="0"> 公会成员要获取属性加成，必须瞻仰公会图腾才行</T><BR></BR>
<T C="158,0,0" S="22" P="0">6.</T><T C="62,34,8" S="22" P="0"> 每人每日只能瞻仰一次</T><BR></BR>
<T C="158,0,0" S="22" P="0">7.</T><T C="62,34,8" S="22" P="0"> 瞻仰成功后即可获得图腾的属性加成，加成效果持续到当日的24点</T><BR></BR>
]],
	CommunityExplain2 =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> 可通过技能学堂学习技能增加角色属性</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> 技能学堂等级越高，能学习到的技能等级越高</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> 学习技能将对应消耗玩家个人贡献</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> 公会等级每提升1级，可学公会技能上限增加10级</T><BR></BR>
]],
	CommunityExplain3 =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> 公会商店等级越高公会成员所享受的折扣越大</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> 公会成员可以通过公会副本获取挑战币</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> 只有公会副本BOSS死亡后，公会商店才会拥有对应BOSS掉落的奖励作为商品卖给公会成员</T><BR></BR>
]],
    PASS_ALL_TOWER_TIPS = "恭喜已经通关所有试炼塔",
	SWEEP_RESULT_TIPS = "扫荡第%s层已结束，获得以下奖励:",
	APPROVALFRIEND = "审批好友",
	FRIENDDYNAMIC = "动态",
	NEXT_FLOOR = "下一层",
	ISGIVE = "已赠送",
	EMPTYFRIENDTIP1 = [[暂无好友信息]],
	EMPTYFRIENDTIP2 = [[暂无好友动态信息]],
	EMPTYFRIENDTIP3 = [[暂无好友申请信息]],
	DIITSUCCESS = "赠送成功",
	REBATE = "回赠",
	FRIEND_MAX = "自己好友上限已满",
	FRIEND_EXIST = "该玩家和你已经是好友了",
	FRIEND_WAIT = "已发送好友申请，请耐心等待",
	FRIEND_SUC = "你的加友申请已提交",
	FRIEND_APPSUC = "审批加友成功",
	FRIEND_OTHERMAX = "目标的好友数量已满",
	FRIEND_NOFRIENDVIGOR = "暂无好友赠送活力",
	FRIEND_OVERVIGOR = "今日领取次数已用完",
	FRIEND_REFUSESUC = "拒绝加友成功",
	LOVING_LEVEL = "恩爱等级",
	SEND_GIFT = "送礼物",
	LOVING_BLOG = "恩爱日志",
    ADVANCED_SUCCESS = "进阶成功",
	ADVANCED_ERROR = "进阶失败",
	PET_REBORN_SUCCESS = "宠物重生成功",
	PET_REBORN_ERROR = "宠物重生失败",
	RAFFLE_PET_ERROR = "抽取宠物失败",
	CHANGE_PET_SKILL_ERROR = "宠物技能洗练失败",
	STRENGTHENINFO1 = "相同类型装备才能继承",
	KING_DAYAWARD_TITLE = "每日获得弹王积分奖励",
    KING_NO_MATCH = "囧...没有对手总是寂寞的",
    KING_MATCHING = "正在努力匹配对手中......",
    KING_TODAY_SCORE = "今日积分：",
    KING_WILL_AWARD = "可获得",
    KING_REST_TIMES = "剩余次数:",
    KING_SEASONSCORE = "赛季积分：",
    KING_SEASONRANK = "赛季排名：",
    KING_BATTLE_MATCH_OTHER = "弹王争霸对手匹配",
    KING_BATTLE = "弹王争霸",
    KING_SCORE_RANK = "积分排名",
    KING_STOP = "终止",
    KING_GO_ON_MATCHING = "继续匹配",
    KING_JOIN_BATTLE = "加入战场",
    KING_REST_OPEN_TIME = "距开启时间：",
    KING_REST_CLOSE_TIME = "距结束时间：",
    KING_BATTLE_INTRODUCE = "弹王争霸说明",
    KING_BATTLE_OPENTIME = [[<T C="255,255,255" S="34">周1~周6</T><T C="255,255,0" S="34"> 21:30 </T><T C="255,255,255" S="34">开启</T>]],
    KING_END = "弹王争霸结束",
    KING_END_TODAY = "今天弹王争霸已经结束",
    KING_END_BATTLE_RESULT = "您的战绩为",
    KING_END_HIGHEST_WINNING_STREAK = "最高连胜次数为",
    KING_END_TODAY_SCORE = "今日累计弹王积分",
    KING_END_TODAY_MONEY = "今日累计弹王令",
    NOW_RANK = "当前排名",
    KING_FAMOUS = "弹王名人",
    FIRST_PLACE = "冠军",
    SECOND_PLACE = "亚军",
    THIRD_PLACE = "季军",
    WHAT_SEASON = "第%d季",
    BATTLE_RESULT = "战绩",
    KING_RANK_MY_SCORE = "我的积分：",
    KING_RANK_MY_RANK = "我的排名：",
    KING_RANK_NO_PLAYER = "新赛季的弹王赛还没开启，当前积分榜还没有玩家啦",
    KING_RANK_TITLE = "弹王积分排名",
    KING_RANK_BATTLERESULT = "%d战 %d胜(胜率:%d%s)",
    KING_RANK_SUB_TITLE = [[<T C="255,255,255" S="20">周六 23:00 </T><T C="255,238,144" S="20">进行积分排名结算，根据排名系统发放对应的排名奖励，前五名奖励非常丰富噢！请踊跃参与~</T>]],
    WIN_LOSE = "胜负",
    GET_AWARD = "获得奖励",
	KING_SCORE = "弹王积分",
	KING_AWARD_SUBTITLE = "周六23:00根据玩家的弹王排名发放对应排名奖励",
	KING_AWARD_TITLE = "弹王赛排名奖励",
	KING_AWARD_RANK = "第%s名",
	KING_SHOP = "弹王商店",
	KING_MONEY = "弹王令",
	ITEMNOTSALE = "商品未上架",
	TOWER_SWEEPING = "正在扫荡中...",
	BAGBTNTEXT5 = "删好友",
	RECHALLENGE = "重新挑战",
	GET = "获得",
	MASTERINFO1 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">1：</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">可收取徒弟数量%d名</T><BR>16</BR> <T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">2：</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">属性加成:血</T><T C="99,255,95" S="20" P="1" SC="79,60,48" SS="4" SE="1">+%d%s</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">攻</T><T C="99,255,95" S="20" P="1" SC="79,60,48" SS="4" SE="1">+%d%s</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">防</T><T C="99,255,95" S="20" P="1" SC="79,60,48" SS="4" SE="1">+%d%s</T><BR>16</BR> <T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">3：</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">徒弟属性加成:血</T><T C="99,255,95" S="20" P="1" SC="79,60,48" SS="4" SE="1">+%d%s</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">攻</T><T C="99,255,95" S="20" P="1" SC="79,60,48" SS="4" SE="1">+%d%s</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">防</T><T C="99,255,95" S="20" P="1" SC="79,60,48" SS="4" SE="1">+%d%s</T> ]],
	MASTERINFO2 = 
[[
师德值获取途径
1.徒弟升级师傅可获得师德值，
等级越高升级获得的师德值越高
2.徒弟出师师傅可获得师德值，
拜师时等级越低获得的师德值越高
]],
	MASTERINFO3 = 
[[
<T C="158,0,0" S="20">拜师规则</T><BR></BR>
<T C="158,0,0" S="18">1.</T><T C="62,34,8" S="18">10-24级且没有师徒关系可进行拜师</T><BR></BR>
<T C="158,0,0" S="18">2.</T><T C="62,34,8" S="18">被拜师的玩家等级需≥25级且收徒弟名额未满</T><BR></BR>
<T C="158,0,0" S="20">收徒规则</T><BR></BR>
<T C="158,0,0" S="18">1.</T><T C="62,34,8" S="18">等级25级以上，且徒弟名额未满玩家可进行收徒</T><BR></BR>
<T C="158,0,0" S="18">2.</T><T C="62,34,8" S="18">拜师玩家等级需大于9，小于25级且没有师徒关系</T><BR></BR>
<T C="158,0,0" S="20">出师规则</T><BR></BR>
<T C="62,34,8" S="18">徒弟25级自动出师，出师后师徒双方将获得出师大礼</T><BR></BR>
<T C="158,0,0" S="20">师徒福利</T><BR></BR>
<T C="158,0,0" S="18">1.</T><T C="62,34,8" S="18">徒弟可获得师门BUFF，师傅师德等级越高BUFF效果越好</T><BR></BR>
<T C="158,0,0" S="18">2.</T><T C="62,34,8" S="18">徒弟升级后可获得等级礼</T><BR></BR>
<T C="158,0,0" S="18">3.</T><T C="62,34,8" S="18">师傅可根据师德等级获得属性加成，等级越高属性越高</T><BR></BR>
<T C="158,0,0" S="18">4.</T><T C="62,34,8" S="18">徒弟消耗活力值时师傅可获得一定活力值</T><BR></BR>
<T C="158,0,0" S="20">师德值</T><BR></BR>
<T C="158,0,0" S="18">1.</T><T C="62,34,8" S="18">徒弟升级，师傅可获得师德值</T><BR></BR>
<T C="158,0,0" S="18">2.</T><T C="62,34,8" S="18">徒弟出师，师傅可获得师德值，收徒时徒弟等级越低出师时获得师德值越高</T><BR></BR>
]],
	MASTERINFO4 = 
[[
2015/6/1 6:00 Lv.66
%s
]],
	MASTERINFO6 = "伦家很想和你在一起啦，你就做偶师傅嘛！！！",
	MASTERINFO7 = "我真的很崇拜你噢，做我师傅吧，不准拒绝！！",
	MASTERINFO8 = "我真的真的很崇拜你噢，做我师傅好不好！",
	MASTERINFO9 = "做我师傅带着我吃香喝辣吧，我一定会努力升级的！",
	MASTERINFO10 = "我可是潜力股，你就做我师傅吧。",
	MASTERINFO11 = "我想带着你飞，让我做你师傅，陪伴着你吧",
	MASTERINFO12 = "我想收个徒弟，你愿意吗？",
	MASTERINFO13 = "你可以做我徒弟吗，不要拒绝这天定的缘分",
	MASTERINFO14 = "我是个好师傅，做我徒弟好不好！",
	MASTERINFO15 = "来做我徒弟跟着我吃香喝辣，翅诧风云吧",
	MASTERINFO16 = "请输入玩家ID",
	MASTERINFO17 = [[<T C="151,64,19" S="20">你确定要解除与%s的师徒关系吗?</T><BR></BR><T C="134,113,92" S="20">对方离线小于</T><T C="158,0,0" S="20"> 72 </T><T C="134,113,92" S="20">小时，强制解除师徒关系将在未来</T><T C="158,0,0" S="20"> %d </T><T C="134,113,92" S="20">小时内不能再次%s。</T><T C="158,0,0" S="20">(钻石解除无时间限制)</T> ]],
	MASTERINFO18 = "拜师",
	MASTERINFO19 = "收徒",
	MASTERINFO20 = "解除关系",
	MASTERINFO21 = "师德等级提升",
	MASTERINFO22 = "玩家ID只能是数字",
	MASTERINFO23 = "你有%d名徒弟了，静静的看着他们出师吧",
	MASTERINFO24 = "消息",
	MASTERINFO25 = "换一批",
	MASTERINFO26 = "你已经有师傅了",
	MASTERINFO27 = "已拜师",
	MASTERINFO28 = "已收徒",
	MASTERINFO29 = "来一段真情告白打动你未来的%s吧",
	MASTERINFO30 = "请求",
    SUREDELFRIEND = "删除好友后，你们的好友度将清0，是否继续操作？",
	WEDDING_DIARY_1= [[<T C="236,166,62" S="22">%s</T><T C="255,236,193" S="22">加入了婚礼现场</T><T C="79,49,68" S="20">     %s</T>]],
	WEDDING_DIARY_2= [[<T C="236,166,62" S="22">%s</T><T C="255,236,193" S="22">离开了婚礼现场</T><T C="79,49,68" S="20">     %s</T>]],
	WEDDING_DIARY_3= [[<T C="236,166,62" S="22">%s</T><T C="255,236,193" S="22">派发了红包</T><T C="79,49,68" S="20">     %s</T>]],
	WEDDING_DIARY_4= [[<T C="236,166,62" S="22">%s</T><T C="255,236,193" S="22">抢到了红包，获得</T><T C="255,89,74" S="22">%d</T> <T C="255,236,193" S="22">金币</T><T C="79,49,68" S="20">     %s</T>]],
	WEDDING_DIARY_5= [[<T C="236,166,62" S="22">%s</T><T C="255,236,193" S="22">派发了喜糖</T><T C="79,49,68" S="20">     %s</T>]],
	WEDDING_DIARY_6= [[<T C="236,166,62" S="22">%s</T><T C="255,236,193" S="22">抢到了喜糖，获得</T><T C="255,89,74" S="22">%d</T><T C="255,236,193" S="22">活力值</T><T C="79,49,68" S="20">    %s</T>]],
	WEDDING_DIARY_7= [[<T C="236,166,62" S="22">%s</T><T C="255,236,193" S="22">放了个礼炮，增加</T><T C="255,89,74" S="22">%d</T><T C="255,236,193" S="22">经验值</T><T C="79,49,68" S="20">    %s</T>]],
	WEDDING_DIARY_8= [[<T C="236,166,62" S="22">%s</T><T C="255,236,193" S="22">送了祝福，增加</T><T C="255,89,74" S="22">%d</T><T C="255,236,193" S="22">经验值</T><T C="79,49,68" S="20">     %s</T>]],
	WEDDING_DIARY_9= [[<T C="236,166,62" S="22">%s和%s</T><T C="255,236,193" S="22">增加了</T><T C="255,89,74" S="22">%d</T><T C="255,236,193" S="22">恩爱值</T><T C="79,49,68" S="20">     %s</T>]],
	LOVING_DIARY_1 = [[<T C="255,236,193" S="22">你</T><T C="255,236,193" S="22">送</T><T C="255,227,116" S="22">%s</T><T C="255,236,193" S="22">1个</T><T C="255,227,116" S="22">%s</T><T C="255,236,193" S="22">,增加</T><T C="255,89,74" S="22">%d</T><T C="255,236,193" S="22">恩爱值</T><T C="79,49,68" S="20">     %s</T>]],
	LOVING_DIARY_2 = [[<T C="236,166,62" S="22">%s</T><T C="255,236,193" S="22">送</T><T C="255,236,193" S="22">你</T><T C="255,236,193" S="22">1个</T><T C="255,227,116" S="22">%s</T><T C="255,236,193" S="22">,增加</T><T C="255,89,74" S="22">%d</T><T C="255,236,193" S="22">恩爱值</T><T C="79,49,68" S="20">     %s</T>]],
	LOVING_DIARY_3 = [[<T C="255,236,193" S="22">夫妻共同</T><T C="255,236,193" S="22">完成了一次战斗,</T><T C="255,236,193" S="22">增加</T><T C="255,89,74" S="22">%d</T><T C="255,236,193" S="22">恩爱值</T><T C="79,49,68" S="20">     %s</T>]],
	WEDDING_INVITE_TIPS = "%s邀请你去参加TA的婚礼，你现在想去吗？",
	SEND_BLESSING_1 = "祝新郎与新娘百年好合",
	SEND_BLESSING_2 = "祝新郎与新娘白头到老",
	SEND_BLESSING_3 = "祝新郎与新娘幸福美满",
	ROB_TRUE_RED = "恭喜你抢到1个红包\n获得%d金币",
	ROB_TRUE_CADDIES = "恭喜你抢到1颗喜糖\n获得%d活力",
	CANDIES_FALSE = "下手慢了，喜糖已被抢完",
	ROB_FALSE = "下手慢了，红包已被抢完",
	WEDDING_FILLED = "礼堂爆满",
	WHAT_WORLD_TIPS = "隔15秒才能发哦!!",
	SHOP_RECOMMEND = "推荐",
	SHOP_SAVE_IMG = "保存形象",	
	SHOP_NEW = "新品",	
	SHOP_HOT = "热卖",
	SHOP_DAY_LIMITED = "今日购买次数已达上限",
	SHOP_DAY_LIMIT = "今日限购",
	SHOP_IND = "个",
	SHOP_NO_NEED = "您拥有该物品的无限期，无需购买",
	MATCHES_MODE = "匹配模式",
	FREE_MODE = "组队模式",
	SCUFFLE_MODE = "混战模式",
	HOMEOWNER = "房主",
	READY = "准备",
	CHANGE_MATCH_ERROR = "房间人数过多不可进行匹配模式,切换失败",
	OFFLINESTATE = "离线",
	QUALIFYING_SEASON = "赛季战绩",
    QUALIFYING_REWARDDESC = "奖励说明",
    QUALIFYING_RANK = "排行榜单",
    QUALIFYING_LOG = "战绩日志",
    QUALIFYING_SHOP = "排位商店",
    QUALIFYING_MAKEPAIR = "寻找对手中",
    QUALIFYING_FIGHT = "开战",
    QUALIFYING_CLOSETIPS = "每周一至周六 12:00~21:00开启",
    QUALIFYING_WIN = "胜利 : %d战 %d胜（%d%%）",
    QUALIFYING_WINSTREAK = "最高连胜 : %d场",
    QUALIFYING_CURRENCY = "段位币 : %d",
    QUALIFYING_SCORE = "排位积分 : %d",
    QUALIFYING_TITLE = [[<T C="255,255,255" S="22">段位称号 : </T><T C="%d,%d,%d" S="22">%s</T>]],
	QUALIFYING_DAILY = [[<T C="127,70,26" S="20">今日战绩 : </T><T C="158,0,0" S="20">%d战 %d胜</T>]] ,
	LOVING_DAILY = "没有恩爱日志",
    RELIEVE_RELATT_SUCCESS = "解除关系成功",
    ROOM_NAME = "房间名字",
	ROOM_PASS = "房间密码",
	SELECT_MAP_TIPS = "匹配模式只能使用随机地图",
	ROOM_PASS_ERROR = "房间密码只能为阿拉伯数字和英文，不能有空格",
	ROOM_PASS_ERROR2 = "房间密码最多8位",
	ROOM_NAME_ERROR = "房间名字最多8位",
	ROOM_NAME_ERROR2 = "房间名字不能有空格",
	COST_GOODS_TIPS1 = "需要消耗的物品不足,消耗钻石%d",
	COST_GOODS_TIPS2 = "需要消耗的物品不足,消耗金币%d",
	SEND_WEDDING_GOODS1 = "正在发红包了,晚点再发哦",
	SEND_WEDDING_GOODS2 = "正在发喜糖了,晚点再发哦",
	SEND_WEDDING_GOODS3 = "已有人正在送祝福了,晚点再发哦",
	SEND_WEDDING_GOODS4 = "已有人正在放礼炮了,晚点再发哦",
	SEND_PROPOSAL_LETTER1 = "发送求婚信成功",
    SEND_PROPOSAL_LETTER2 = "道具不足",
    SEND_PROPOSAL_LETTER3 = "对方不在线",
    SEND_PROPOSAL_LETTER4 = "对方等级不足",
    SEND_PROPOSAL_LETTER5 = "对方在战斗中",
    SEND_PROPOSAL_LETTER6 = "已发过求婚",
    SEND_PROPOSAL_LETTER7 = "目标已订婚或者已结婚",
    SEND_PROPOSAL_LETTER8 = "10分钟内只能发一次举行婚礼",
	PROPOSE_TIPS = "不管求婚成功与否，都将消耗求婚道具",
	CHANGE_LOVER= "选择伴侣哦，亲!",
    PROPPSE_LIST_TIPS = "向您发送了%s求婚.",
	MINUTE_BEFORE = "%d分钟前",
    HOUR_BEFORE = "%d小时前",
    DAY_BEFORE = "%d天前",
    QUALIFYING_REFRESHTIME = "自动刷新时间：每日21:00",
    QUALIFYING_MYCOIN = "我的排位币 : ",
	SWEEP_CARD = "扫荡券",
	MULTI_SWEEP = "批量扫荡",
	COPY_ENEMY = "出现敌人",
    COPY_PROBABLE_DROP = "可能获得",
    COPY_GOAL = "副本目标",
    COPY_VIGOUR = [[<T S="21" C="83,56,29" P="1">消耗活力:</T><I>ui/common/015.png</I><T S="21" C="83,56,29" P="1">%d</T>]],
    COPY_GOAL1 = "通关副本",
    COPY_GOAL2 = "剩余%d%%生命通关",
    COPY_GOAL3 = "%d次出手内通关",
	COPY_SWEEP = "副本扫荡",
	COPY_GOAL2_2 = "剩余%d%%生命",
    COPY_GOAL3_2 = "%d次出手",
	MY_EQUIP = "我的装备",
    ON_BODY = "身上",
    REACH_MAX_STRONG_LEVLE = "强化等级已满",
    OWN = "拥有",
    EQUIP_REACHED_MAX_STAR_LEVEL = "装备已经升星到最大等级",
    ATTACK_STONE_1 = "攻击宝石",
    DEFENSE_STONE_1 = "防御宝石",
    HP_STONE = "生命宝石",
    CLICK_TO_REMOVE = "点击拆卸",
    CLICK_TO_ADD = "点击添加",
    TRANSFER_COST = "继承花费",
    BUY_TRANSFERSTONE_MESSAGE = "亲！继承石不足了哦，您是否购买该道具？",
    PLEASE_SELECT_TRANSFER_EQUIP = "选择要继承的装备",
    EQUIPONE_LESS_THAN_EQUIPTWO = "强化和升星等级需大于所继承装备",
    IN_USE = "使用中",
    MY_GEM = "我的宝石",
    TURNCARD_VIP_TIPS = "需要VIP5级才可翻牌",
	ATH_DAILY_REWARD = "竞技等级奖励",
	ATH_REFRESH_LIMIT = "您当前刷新次数已达上限",
	ATH_SHOP = "商店",
	ATH_SHOP_REFRESH = "每日24:00刷新商品",
	ATH_REWARD_CHECK = "奖励",
	ATH_FREE = "组队",
	ATH_MIX = "混战",
	SETTING_EXCHANGEWORD1 = "该兑换码已经兑换过",
    SETTING_EXCHANGEWORD2 = "你已经使用过兑换码了",
    SETTING_EXCHANGEWORD3 = "请输入正确的兑换码",
	WNDPLAYERINFO1 = "我的属性",
	WNDPLAYERINFO2 = "角色信息",
	WNDPLAYERINFO3 = "战斗属性",
	WNDPLAYERINFO4 = "个性签名",
	WNDDRESS1 = "表情",
	WNDDRESS2 = "我的时装",
	OPAN_FOR_LEVEL = "%d级开放",
	SERVER_TIME = "服务器时间:",
	REVIVE_MODES = "复活",
	ATH_SHOP_HAVE_NUM = [[<T C="79,60,48" S="22" P="0">拥有 </T><T C="158,0,0" S="22" P="0">%d</T><T C="79,60,48" S="22" P="0"> 件</T>]],
	ATH_SHOP_COST = "花费",
	ATH_WAIT = "等待",
	SHOP_BUY_DESC = [[<T C="79,60,48" S="20" P="0">共%d件商品，需支付</T><I Z="0.8">ui/common/common_icon_zuanshi.png</I><T C="79,60,48" S="20" P="0">%d</T>]],
	WAITING_MATCHES = "开始战斗匹配",
	ROOM_INFO = "房间信息",
	FRIENDS_SEND_TIP_1 = "向你赠送了",
	FRIENDS_SEND_TIP_2 = "点活力值",
	FRIENDS_SEND_TIP_3 = [[暂无数据]],
    PLEASE_INPUT_ID_FIRST = "请先输入玩家id",
    PLEASE_CHOOSE_PLAYER = "请选择玩家",
    NO_PLAYER_IN_HALL = [[大厅暂时没有其他玩家]],
    NO_VATALITY_CAN_GET = "没有可领取的活力值",
    PLEASE_SEND_AFTER_GETTING = "请先领取后再赠送",
	DAILY_KILL_SMALLM = "击杀小怪",
	DAILY_KILL_BIGM = "击杀精英怪",
	DAILY_KILL_BOSS = "击杀BOSS",
	ATH_JINGJI_DESC = "匹配模式由系统匹配最佳敌人，战斗胜利后可获得竞技积分",
	ATH_SAFE_DESC = "可自由选择队友和对手，敌方被全灭则获胜，此模式不会获得竞技积分",
	ATH_SAFE_DESC2 = "练习赛可以与指定的玩家交战，但不会获得任何奖励，可用于战斗的练习和约战之地",
	ATH_SAFE_DESC3 = "混战模式没有选项噢",
	RESULT_DOWN_TIME = [[<T C="255,227,116" S="24" P="0">%02d</T><T C="255,255,255" S="24" P="0">秒后自动返回</T>]],
	NOT_START_GAME = "两队人数不一致，无法开始",
	CLOSE_SETAT_TIP = "对方该位置已有玩家，无法关闭此座位",
	BATTLE_SKILL = "战斗道具",
	SKILL_TIP = "从道具列表里选择需要的道具，在战斗中使用",
	SKILL_CELL_FULL = "已达携带上限",
	SKILL_OPEN = "开放",
	LOADING_NICKNAME = "昵称",
	EQUIPPED = "已装备",
	UNEQUIPPED = "未装备",
	MAIL_NAME = "邮件",
	HIGHEST_RECORD = "最高纪录:",
	SWEPT_LEAVE_TIEM = "扫荡剩余时间",
	TOWER_LEVEL = "塔层",
	HAVE_NOT_ROOM = "暂无房间",
	TOWER_LEVEL2 = "层",
	CHALLEGE_OVER = "挑战次数已用完",
	SWEEPING_TIP = "扫荡状态不能主动战斗",
	MOVING = "移动中",
	TEAM_MAYBE_GET = "可能\n获得",
	STOP_SWEEPING = "停止扫荡",
	CHANGE_SEAT_TIPS = "已准备游戏，不能换位!",
	NOT_ENABLE = "不足",
	SWEEPING_TIP2 = "最高关卡纪录以下才能扫荡",
	ATHMONEY_NOT_ENOUGH = "竞技币不足，快去完成竞技目标吧",
	SELL_CONFIRM = "本次出售列表中拥有贵重物品\n请确认是否继续出售？",
	NOT_ATTENTION_TODAY = "今日不再提示",
	TODAY_REST_COUNT = "今日剩余次数:",
	CHALLENGE_AGAIN = "再次挑战",
	SHARE = "分享",
	CONTINUE = "继续",
	CURRENT_LEVEL = [[<T C="79,60,48" S="22" P="0">当前所在</T><T C="99,255,95" S="22" P="0">%d</T><T C="79,60,48" S="22" P="0">层</T>]],
	RESERT_TIPS2 = "重置后将返回第1层并恢复挑战次数",
	MAIL_NOLIST = "邮件列表为空，无法编辑",
	MAIL_ISWRITE = "无法编辑正在编写的邮件",
	MAIL_GETANNEX = "请先提取附件",
	MAIL_OUTTHEME = "主题不能超过36个字符!",
	MAIL_OUTTEXT = "邮件内容不能超过200个字符!",
	DAILYCOPY_NOOPEN = "当前副本没有开启",
	DAILYCOPY_OPENLEVEL = "该副本难度%d级开启",
	SWEEP_ENDIND2 = "扫荡结束",
	ROOM_HAVE_NOT_READY = "房间存在未准备玩家",
	BAGINFO1 = "没有过期时装",
	ROOM_BEINVITED_2 = "%s 邀请你参加\n%s组队竞技",
	FAST_SWEEP_TIP = "是否花费%d钻石消除扫荡冷却时间",
	OPEN_SKILL_TAB_TIP = "是否花费50钻石购买道具框",
	SHOP_LIMIT_TITLE = "限购",
	LV = "Lv",
	INTERACTIVE = "互动",
    CONTEXT = "内容",
	TURNCARD_DIAMOND_TIPS = "钻石不足哦，无法翻牌！",
	WHISPER_TO_ME = "对我",
	ME_TO_WHISPER = "我对",
	COST = "花费:",
	TOWER_SEND_DESC = [[<T C="127,70,26" S="20" P="0">每日</T> <T C="255,89,74" S="20" P="0"> %s </T><T C="127,70,26" S="20" P="0">根据试炼塔排名发放奖励</T>]],
	MOUNTS_UP = "乘骑",
	TXT_ONLINEFRIEND_ISNULL = [[暂无在线好友]],
	TXT_ONLINEGUILD_ISNULL = [[暂无在线公会成员]],
	MOUNTS_LEVEL = "等级：%d",
	MOUNTS_PRE_ADD = "坐骑总属性加成",
	HAS_GET = "已获得",
	INHERIT = "继承",
	NO_CHALLENGE_TIMES2 = "挑战次数不够，不能进行挑战！",
	SHOP_MIANBAO = "免爆：",
	MOUNTS_TITLE_STAR = "坐骑进阶",
	MOUNTS_TITLE_UPGRAGE = "坐骑升级",
	DISAPPEAR = "消失",
	MOUNTS_MAX_UPGRADE = "该坐骑已达最大等级",
	MOUNTS_MAX_STAR = "该坐骑已达最大进阶等级",
	MOUNTS_STAR_NOLEVEL = "坐骑需要达到%d级才能进阶",
	DESIGNATION_ATTENTION = "勾选框格装备已有称号，获得强力属性加成！",
	STRENGTHEN_TOP = "强化等级已满!好棒耶!",
	PETHEALTH = "生命:",
	PETDEFENSE = "防御:",
	PETATTACK = "攻击:",
	PETINTELLIGENCE = "资质:",
	PETLOOK = "查看",
	PETEATFORUP = "升级吞噬的宠物",
	PETEATFORADVANCE = "进阶吞噬的宠物",
	PETONECHOICE = "快速选择",
	PETTOUP = "确定升级",
	PETADCANCE = "宠物进化",
	PETUSE = "消耗",
	PETHASNUM = "（拥有%d）",
	PETHAS = "拥有:",
	PETSKILL = "领悟",
	PETOPENEGE = "砸蛋",
	PETTOFREE = "后免费",
	SHOP_NAME_AND_LEVEL = [[<T C="255,227,116" S="22" P="0">Lv%d </T><T C="255,255,255" S="22" P="0">%s</T>]],
	MOUNTS_STAR_MAX = "进阶满级",
	CLICKCONTINUE = "点击继续",
	ACHIE_DISCRIPTION_TITLE = "获取条件：",
	ACTOR_NAME_ERROR = "角色名字不能存在空格",
    ACTOR_MAX_NAME = "角色名字不能超过%d个字符",
	ATH_REFRESH_COST = [[<T S="24" C="127,70,26" P="1">是否消耗%d钻石刷新商店?</T><BR></BR><BL>48</BL><T S="24" C="127,70,26" P="1">(今日已刷新%d次)</T>]], 
	FailToBag = "增加各种属性",
	FailToTak = "完成任务，提升等级",
	FailToEquie = "强化装备，增加各种属性",
	FailToItem = "其它待扩展",
	LOGIN_MY_SERVER = "我的服务器",
	LOGIN_RECOMMEND_SERVER = "推荐服务器",
	SHOP_STONE = "宝箱",
	LOGIN_SERVER_STATE_CLOSE = "维护",
	PET_1 = "宠物资质",
	PET_2 = "宠物属性",
	PET_3 = "宠物战斗",
	PET_4 = "生命、攻击、防御的%d%s加成到角色身上",
	PET_5 = "宠物攻击造成角色普通伤害的%d%s",
	LEVEL1 = "级",
	PETOPENEGE1 = "碎片砸蛋",
	PETOPENEGE2 = "钻石砸蛋",
	PETOPENEGE3 = "十连砸蛋",
	Wedding_CountDown = "婚礼倒计时",
    Wedding_Desc = "举办的婚礼越豪华，每日可以互相赠送礼物的次数就更多，赶紧关心下对方吧!",
    Propose_Desc = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> 每次求婚都将消耗求婚道具，且不管求婚是否成功</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> 每种求婚道具对应一种表白形式，相信总有适合您的表白</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> 求婚对象必须大于等于21级</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> 求婚对象和你的好友度必须大于等于1000</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> 好友度可通过日常赠送礼物、活力、并肩完成战斗来增长</T><BR>20</BR>
]],	
    Engagement_Desc = 
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> 订婚成功后将获得对应称号</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> 婚礼分为3种类型：奢华婚礼、豪华婚礼、浪漫婚礼</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> 婚礼等级越高，所获得的结婚礼服越好</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> 婚礼等级越高，婚礼过程中可使用的派发红包、派发喜糖、放礼炮、送祝福的行为冷却CD越短</T><BR></BR>
<T C="158,0,0" S="22" P="0">5.</T><T C="62,34,8" S="22" P="0"> 婚礼等级越高，婚礼过程中所获得的收益越多</T><BR></BR>
<T C="158,0,0" S="22" P="0">6.</T><T C="62,34,8" S="22" P="0"> 婚礼等级越高，婚后每日夫妻互动的次数越多（可更快速提升恩爱等级激活对应夫妻技能）</T><BR></BR>
<T C="158,0,0" S="22" P="0">7.</T><T C="62,34,8" S="22" P="0"> 选定好举办婚礼的类型和时间后，将可给自己好友以及公会朋友发送请柬</T><BR></BR>
<T C="158,0,0" S="22" P="0">8.</T><T C="62,34,8" S="22" P="0"> 发送请柬成功后，收到请柬的人按时来参加婚礼，发送请柬的人与收柬人都会获得相应金币返利</T><BR></BR>
<T C="158,0,0" S="22" P="0">9.</T><T C="62,34,8" S="22" P="0"> 请柬返利金币多少受发送的请柬的规格决定，单价越贵的请柬所获得的返利金币越多</T><BR></BR>
<T C="158,0,0" S="22" P="0">10.</T><T C="62,34,8" S="22" P="0">婚礼过程中将不能发送请柬</T><BR></BR>
<T C="158,0,0" S="22" P="0">11.</T><T C="62,34,8" S="22" P="0">可单方面解除关系，但需收取发起方333钻石手续费</T><BR></BR>
]],
    Propose_Item1 = "玫瑰花束",
    Propose_Item2 = "水晶鞋",
    Propose_Item3 = "世纪佳缘",
    Propose_Item4 = "钻石戒指",
    My_Love = "亲爱的:",
    Love = "爱你的:",
	MOUNTS_LEVEL_GET = "%d级领取",
	MOUNTS_GM_GET = "活动赠送",
    BUY_ACTIVITY_LIMIT = "今日可购：",
    FULL_RECOVERY = "完全恢复",
    NEXT_RECOVERY = "下点恢复",
    BUY_GOLD_LIMIT = "今日可招：",
    SHAKE_TIMES = "招%d次",
	RANDOM_MAP = "随机地图",
	SEND_INVITATION = "发送邀请",
    RICH_INVITAION = "土豪请柬",
    BEAUTIFUL_INVITAION = "精美请柬",
    COMMON_INVITATION = "普通请柬",
    SELECT_WEDDING_TYPE = "请选择你想举办的婚礼",
    SELECT_WEDDING_INV = "请选择请柬类型",
    MARRY_INV_INFO = "你的光临与祝福会使婚礼更添色彩!",
    INVITATION_CARD = "请柬",
    INVITATION_TIP = "邀请你参加我们的婚礼",
    INVITATION_TIP2 = "举行婚礼",
    WEDDING_TIME = "婚礼时间:",
	SingInDesc = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> 每月累计签到天数，领取对应的签到奖励</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> 在特定日子里，达到对应VIP等级及以上的玩家可以领取双倍奖励</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> 第二份奖励（VIP双倍奖励）可以当日内升VIP等级后补领</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> 每日签到奖励在每天的24:00时算隔天，当天未领取的奖励隔天不可再补领</T><BR>20</BR>
]],
	SingInTitle = "签到奖励",
	SingInDAYS = "第%d天",
	SingInVipTips = "当日签到奖励已领取。升级至VIP%d可领取双倍奖励，是否充值?",
	SingInProgress = [[<T S="22" C="255,236,193" P="0">本月累计签到:</T><T S="22" C="255,227,116" P="0">%d</T><T S="22" C="255,236,193" P="0">天</T>]],
	ACTIVITY_HAVED_FULL = "活力已满",
	HOUR1 = "小时",
	MINUTE1 = "分钟",
	BEFORE = "前",
	VIP_FIRST_DOUBLE = "首充",
	OppositeSexFriend = "异性朋友",
	LevelAndNameFormat = [[<T S="24" C="158,0,0"  P="0">Lv%d</T><BL>10</BL><T S="24" C="79,60,48" P="0">%s</T>]],
	BeStrongBtnNameArrays = {"要变强","要金币","要装备","要升级","要宝石","宠变强","要吃肉"},
	BUY_FIVE_ATTENTION = [[<T C="255,236,193" S="20" P="0">连续招 </T><T C="233,166,62" S="20" P="0">%d 次</T><T C="255,236,193" S="20" P="0">招财猫</T>]],
    BUY_FIVE_NEED_CONSUME = "需消耗",
    BUY_FIVE_CAN_GET = "至少获得",
    BUY_FIVE_AFFIRM = "确认",
	PETREST = "休息",
    PETATWAR = "出战",
    PETNOREBIIRTH = "战斗宠物无法重生",
    PETNOADVANCEGOODS = "进阶丹不足", 
    PETNOENOUGHNUM = "宠物数量不足",
    PETENOUGHNUM = "吞噬栏满了噢，先吃掉它们吧",
    PETNOADVANCELEVEL = "宠物等级不足%s，先去提升吧",
    PETNOGOODS = "消耗材料不足",
    PETSKILL1 = "技能栏1",
    PETSKILL2 = "技能栏2",
    PETNOSKILL = "技能激活后才能洗练噢",
    PETSKILLSUC = "洗练技能成功",
    PETENOUGHEXP = "当前经验已经足够升级",
    PETNOUPEXP = "未添加宠物",
    PETUPTOLEVEL = "宠物等级不能大于角色等级",
    PETMAXNUM = "宠物最多拥有100个",
    PETNORAFFLEGOODS = "宠物碎片不足",
    PETMAXEXP = "当前获得经验:",
    PETFREE2 = "免费",
    PETRAFFLEDESC1 = "有几率获得蓝宠",
    PETRAFFLEDESC2 = "有几率获得紫宠",
    PETRAFFLEDESC3 = "必得紫宠",
	PETFULLADVANCELEVEL = "已达最大进阶等级",
	NO_GIFT = "没有此物品，是否购买?",
	CONJUGAL_RELATION_TIP = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> 夫妻双方每日可通过互赠礼物获取恩爱值，提升恩爱等级</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> 恩爱等级越高，被激活的夫妻技能越好</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> 夫妻技能的属性加成只有在夫妻双方同一战场同阵营时才起效</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> 如果离婚，则需要扣除提出离婚方886钻石的手续费</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> 离婚后夫妻技能取消，如再次结婚，恩爱等级重新开始计算</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="22" P="0"> 离婚后夫妻双方的结婚礼服也会消失</T><BR>20</BR>
]],
		VIP_LEVEL_1 = 
[[	
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">累计充值50钻提升到该VIP等级</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 签到特定天数可获取双倍奖励</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 开启竞技房间防踢功能</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 开启额外的道具使用框</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 开启一键强化功能，强化操作将更便捷</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日可在日常任务领取特权奖励</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 好友人数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 110</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 人</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日赠送活力领取次数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 22</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买金币</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买活力</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 6</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新竞技商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 9</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多重置试炼塔</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多重置组队副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多重置探险之地精英副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新宠物商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 11</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多购买矿晶</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">禁忌之地骰子上限增加1个，每日最多购买骰子</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
]],	
	VIP_LEVEL_2 = 
[[	
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">累计充值500钻提升到该VIP等级</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 包含VIP1所有特权</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 开启探险之地的十连扫荡功能</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 好友人数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 120</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 人</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日赠送活力领取次数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 24</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买金币</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 15</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买活力</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多刷新竞技商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 13</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置试炼塔</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置组队副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多重置探险之地精英副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新宠物商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 12</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多购买矿晶</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 15</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">禁忌之地骰子上限增加2个，每日最多购买骰子</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 6</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
]],	
	VIP_LEVEL_3 = 
[[	
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">累计充值1000钻提升到该VIP等级</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 包含VIP2所有特权</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 开启快速合成功能，合成操作将更便捷</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 好友人数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 130</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 人</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日赠送活力领取次数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 26</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买金币</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 20</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买活力</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 12</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多刷新竞技商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 17</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置试炼塔</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置组队副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多重置探险之地精英副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新宠物商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 13</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多购买矿晶</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 20</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">禁忌之地骰子上限增加3个，每日最多购买骰子</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 8</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
]],	
	VIP_LEVEL_4 = 
[[	
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">累计充值2000钻提升到该VIP等级</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 包含VIP3所有特权</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 开启批量使用"招财猫"功能</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 开启商城赠送特权</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 好友人数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 140</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 人</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日赠送活力领取次数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 28</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买金币</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 25</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买活力</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 14</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多刷新竞技商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 21</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置试炼塔</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多重置组队副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多重置探险之地精英副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新宠物商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 14</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多购买矿晶</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 25</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">禁忌之地骰子上限增加4个，每日最多购买骰子</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
]],	
	VIP_LEVEL_5 = 
[[	
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">累计充值5000钻提升到该VIP等级</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 包含VIP4所有特权</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 开启组队副本结算额外奖励</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 好友人数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 150</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 人</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日赠送活力领取次数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 30</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买金币</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 30</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买活力</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 16</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多刷新竞技商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 23</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置试炼塔</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置组队副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多重置探险之地精英副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新宠物商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 15</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多购买矿晶</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 30</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">禁忌之地骰子上限增加5个，每日最多购买骰子</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 12</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
]],	
	VIP_LEVEL_6 = 
[[	
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">累计充值10000钻提升到该VIP等级</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 包含VIP5所有特权</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 获得VIP尊享坐骑</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 好友人数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 160</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 人</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日赠送活力领取次数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买金币</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 35</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买活力</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 18</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多刷新竞技商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 25</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置试炼塔</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置组队副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多重置探险之地精英副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新宠物商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 16</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多购买矿晶</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 35</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">禁忌之地骰子上限增加6个，每日最多购买骰子</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 14</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
]],	
	VIP_LEVEL_7 = 
[[	
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">累计充值20000钻提升到该VIP等级</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 包含VIP6所有特权</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 好友人数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 170</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 人</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日赠送活力领取次数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 34</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买金币</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 40</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买活力</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 20</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多刷新竞技商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 27</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置试炼塔</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置组队副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置探险之地精英副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 5</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新宠物商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 17</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多购买矿晶</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 40</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">禁忌之地骰子上限增加7个，每日最多购买骰子</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 16</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
]],	
	VIP_LEVEL_8 = 
[[	
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">累计充值50000钻提升到该VIP等级</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 包含VIP7所有特权</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 好友人数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 180</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 人</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日赠送活力领取次数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 36</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买金币</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 45</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买活力</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 22</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多刷新竞技商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 29</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置试炼塔</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置组队副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置探险之地精英副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 5</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新宠物商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 18</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多购买矿晶</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 45</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">禁忌之地骰子上限增加8个，每日最多购买骰子</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 18</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
]],	
	VIP_LEVEL_9 = 
[[	
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">累计充值80000钻提升到该VIP等级</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 包含VIP8所有特权</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 好友人数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 190</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 人</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日赠送活力领取次数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 38</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买金币</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 50</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买活力</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 24</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多刷新竞技商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 31</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置试炼塔</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置组队副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置探险之地精英副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 6</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新宠物商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 19</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多购买矿晶</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 50</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">禁忌之地骰子上限增加9个，每日最多购买骰子</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 20</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
]],	
	VIP_LEVEL_10 = 
[[	
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">累计充值100000钻提升到该VIP等级</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 包含VIP9所有特权</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 获得VIP尊享翅膀</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 好友人数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 200</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 人</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日赠送活力领取次数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 40</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买金币</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 55</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买活力</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 26</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多刷新竞技商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 33</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置试炼塔</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置组队副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多重置探险之地精英副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 7</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新宠物商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 20</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多购买矿晶</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 55</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">禁忌之地骰子上限增加10个，每日最多购买骰子</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 22</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
]],	
	VIP_LEVEL_11 = 
[[	
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">累计充值150000钻提升到该VIP等级</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 包含VIP10所有特权</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 好友人数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 210</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 人</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日赠送活力领取次数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 42</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买金币</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 60</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买活力</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 28</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多刷新竞技商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 35</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置试炼塔</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置组队副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置探险之地精英副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 8</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新宠物商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 21</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多购买矿晶</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 65</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">禁忌之地骰子上限增加12个，每日最多购买骰子</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 26</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
]],	
	VIP_LEVEL_12 = 
[[	
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">累计充值200000钻提升到该VIP等级</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 包含VIP11所有特权</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 好友人数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 220</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 人</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日赠送活力领取次数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 44</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买金币</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 65</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买活力</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 30</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多刷新竞技商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 37</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置试炼塔</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置组队副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置探险之地精英副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 9</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新宠物商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 22</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多购买矿晶</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 65</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">禁忌之地骰子上限增加12个，每日最多购买骰子</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 26</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
]],	
	VIP_LEVEL_13 = 
[[	
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">累计充值300000钻提升到该VIP等级</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 包含VIP12所有特权</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 好友人数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 230</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 人</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日赠送活力领取次数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 46</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买金币</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 70</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买活力</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多刷新竞技商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 39</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置试炼塔</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置组队副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置探险之地精英副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新宠物商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 23</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多购买矿晶</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 70</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">禁忌之地骰子上限增加13个，每日最多购买骰子</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 28</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
]],	
	VIP_LEVEL_14 = 
[[	
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">累计充值400000钻提升到该VIP等级</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 包含VIP13所有特权</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 好友人数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 240</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 人</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日赠送活力领取次数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 48</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买金币</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 75</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买活力</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 34</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多刷新竞技商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 41</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置试炼塔</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置组队副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置探险之地精英副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 11</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新宠物商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 24</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多购买矿晶</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 75</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">禁忌之地骰子上限增加14个，每日最多购买骰子</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 30</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
]],	
	VIP_LEVEL_15 = 
[[	
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">累计充值500000钻提升到该VIP等级</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 包含VIP14所有特权</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 好友人数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 250</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 人</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日赠送活力领取次数上限为</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 50</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买金币</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 80</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多购买活力</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 40</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多刷新竞技商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 41</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置试炼塔</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置组队副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 5</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 每日最多重置探险之地精英副本</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 12</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多刷新宠物商店</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 25</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>	
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">每日最多购买矿晶</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 80</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">禁忌之地骰子上限增加16个，每日最多购买骰子</T><T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 次</T><BR></BR>
]],	
    EQUIP_STRA_LEVEL_UP = "升星等级提升",
    EQUIP_REACHED_MAX_STAR_LEVEL = "已升星到最大星级",
	SEND_GIFT_TIP = "今日赠送礼物次数已用完",
	ATT_ROUND = "出手次数:", 
	MY_GEM = "选择宝石",
	BESTRONG_NAME = "弹弹宝典",
	TASK_UINAME = "任务",
	SETTING_GAME_NAME = "角色名称:",
	SETTING_SERVE_NAME = "服务器:",
	SETTING_SOUND = "游戏音效:",
    SETTING_SHIELD_PLAEYER = "周围玩家:",
    SETTING_SHIELD_INVITE = "好友邀请:",
	SETTING_SHIELD_INVITE2 = "战队邀请:",
    SETTING_EXCHANGE_GIFT = "兑换礼包",
    SETTING_SHARE_GAME = "分享游戏:",
    SETTING_ADVISE_MAIL = "意见邮箱",
	SETTING_EXIT = "游戏公告",
	SETTING_SYSTEM = "系统设置",
	SETTING_GAME = "功能设置",
	SETTING_MUSIC = "游戏音乐:",
	SEND_WEDDING_CARD_TIP = "发送请柬成功",
	APPLY = "申请",
	ATH_REWARD_SEND = [[<T C="79,60,48" S="22" P="0">达到对应的竞技等级后可获得奖励（一次性）</T>]],
	ATH_SHOP_CHANGE = [[<T C="127,70,26" S="22" P="0">自动刷新时间：</T><T C="158,0,0" S="22" P="0">%s</T>]],
	VIP_DESC2 = [[<T C="255,236,193" S="20" P="0">再充值</T><T C="99,255,95" S="22" P="0">%d</T><I Z="0.7">ui/common/common_icon_zuanshi.png</I><T C="255,236,193" S="20" P="0">可以成为</T><T C="99,255,95" S="22" P="0">VIP%d</T>]],
	STRENGTHENTIP = "全套装备%s +%d",
	STRENGTHENTIP1 = "未激活套装属性",
	BAGTIP1 = "这个人很懒,神马都没有留下!",
	SELECT_GIFT_TYPE = "请选择想送的礼物",
	PUPIL_REWARD = "徒弟奖励",
	DAILY_COPY_GOLD_DESC1 = "造成伤害",
	DAILY_COPY_GOLD_DESC2 = "大金币",
	DAILY_COPY_GOLD_DESC3 = "小金币",
	DAILY_COPY_GOLD_DESC4 = "击杀宝箱怪",
	DAILY_COPY_CLICK_CONTINUE = "点击屏幕继续",
	NAME_TOO_SHOOT = "名称太短，请重新输入！",
    NAME_HAVED_EXIST = "存在同名，请重新输入！",
    NAME_CANT_BE_NUMBER = "名称不能为纯数字！",
    SHAKE_TIMES_FINISH = "今日招财次数已用完",
    BUY_ACTIVITY_TIMES_FINISH = "今日购买活力次数已用完！",
	WEDDING_HALL_PASS = "礼堂密码:",
	SETTING_WEDDING_HALL_PASS = "设置礼堂密码成功", 
	YOU_CANT_CHANGE_NAME = "亲！您不是会长，不能修改公会名字哦！",
	WEDDING_NO_GUEST = "暂时没有来宾",
	PRIEST_SAY = {"新人可以派红包送金币哦!",
		"抢红包得金币，拼手气!",
		"每个红包能获得金币数量随机哦!",
		"新人也可以派喜糖送活力哦!",
		"抢喜糖得活力，拼RP!",
		"放礼炮自己可以获得经验哦!",
		"送祝福给新人会增加他们的恩爱值!",
		"送完祝福后自己也会获得少量经验!"},
	GET_OUT_WEDDING_HALL = "被婚礼主人踢了",
	SINGCOPY_FAIL = "胜败乃兵家常事,要向钱看,知道不?",
	LOSE_TIPS = "再试一次吧，万一成功了呢？",
	ENERGY_NOT_SHORTAGE = "亲！活力不足哦，要来点吗？",
	WIPEOUTNUM = "亲！扫荡卷不足了哦,您是否购买该道具?",
	TOWER_DAILY_RANKING = "每日排名",
	TEAM_COPY_COUNTDOWN = "挑战倒计时",
	TEAM_COPY_COUNTDOWN2 = "战斗倒计时",
	REMOVE = "解除",
	COMPETIVITY_LEVEL = "竞技等级",
    COMPETIVITY_DATA  = "竞技数据",
    COMPETIVITY_INTEGRAL = "竞技积分",
    COMPETIVITY_RESULT = "胜%d场\n(胜率:%d%%)",
    ACHIE_NUMBER = "成就数量",
    TEACHER_LEVEL = "师德等级",
    TEACHER_PUPIL_NUMBER = "出徒数量",
    TEACHER_VALUE = "师德值",
	WORLD_BOSS_DESC1 = "挑战世界BOSS，可获得丰富的奖励哦！", 
	JUST_NOW = "刚刚",
    MINITE_AGO = "%d分钟前",
    HOURS_AGO = "%d小时前",
    DAYS_AGO = "%d天前",
    LONG_AGO = "很久前",
    XX_WORSHIP_XX = "膜拜了",
    HAVED_WORSHIP_TODAY = "今日已膜拜过",
    WORSHIP_SUCCESS = "膜拜成功，获得%d点活力",
    CANT_WORSHIP_SELF = "不可自恋噢！",
	OPENCHEST = "开启宝箱",
	OPENCHEST1 = "请选择数量(1次最多10个)",
	DAILY_LOSE_DESC1 = [[<T C="255,223,116" S="26" P="0">最低伤害:  </T><T C="255,236,193" S="26" P="0">%s</T>]],
	DAILY_LOSE_DESC2 = [[<T C="255,223,116" S="26" P="0">逃离怪物:  </T><T C="255,236,193" S="26" P="0">%s</T>]],
	DAILY_LOSE_DESC3 = "金币奖励:  ",
	DAILY_LOSE_DESC4 = [[<T C="255,223,116" S="20" P="0">最低伤害:  </T><T C="255,236,193" S="20" P="0">%s</T>]],
	WORSHIP_WORD = "膜拜",
	CHECK_HUSBAND = "查看丈夫",
	CHECK_WIFE = "查看妻子",
	UPGRADE_TIPS0 = "现在就去了解下新功能吧~",
	UPGRADE_TIPS1 = "你又变强大了， 记得多交些朋友噢",
	UPGRADE_TIPS2 = "变强的道路上总是孤独的，但风景却也最美好",
	UPGRADE_TIPS3 = "不愧是被我选中的勇士，你很强大噢",
	UPGRADE_TIPS4 = "再接再厉，你已经拥有很强的实力了",
	TEACH_1 = "进入副本闯关",
	TEACH_2 = "选择第一关",
	TEACH_3 = "开始挑战吧",
	TEACH_4 = "手指按住人物，朝攻击目标的反方向拉动，瞄准攻击",
	TEACH_5 = "选择技能进行攻击",
	TEACH_6 = "再来复习一遍攻击操作",
	TEACH_7 = "展开导航栏",
	TEACH_8 = "查看任务",
	TEACH_9 = "任务完成了，领取奖励吧",
	TEACH_10 = "有新的任务了，点击前往",
	TEACH_11 = "点击进入关卡",
	TEACH_12 = "开始挑战吧",
	TEACH_13 = "使用飞行道具",
	TEACH_14 = "滑动屏幕，向要飞的方向反向拉动",
	TEACH_15 = "长按屏幕进行移动，会朝指定方向移动",
	TEACH_16 = "攻击敌人",
	TEACH_17 = "展开导航栏",
	TEACH_18 = "查看技能功能",
	TEACH_19 = "选择怒气道具",
	TEACH_20 = "装配完成",
	TEACH_21 = "打开任务",
	TEACH_22 = "点击领取任务奖励",
	TEACH_23 = "前往新的任务吧",
	TEACH_24 = "进入精英副本",
	TEACH_25 = "开始挑战吧",
	TEACH_26 = "使用怒气道具可以更快的释放大招",
	TEACH_27 = "点击使用怒气大招，可以造成巨大杀伤力",
	TEACH_28 = "一口气干掉它",
	TEACH_29 = "点击打开宝箱",
	TEACH_30 = "关闭任务面板",
	TEACH_31 = "点击导航栏",
	TEACH_32 = "点击背包",
	TEACH_33 = "点击装备",
	TEACH_34 = "点击穿上",
	TEACH_35 = "返回",
	TEACH_36 = "展开导航栏",
	TEACH_37 = "点击锻造",
	TEACH_38 = "选择武器",
	TEACH_39 = "这里是强化装备需要消耗的材料",
	TEACH_40 = "点击强化",
	TEACH_41 = "点击返回",
	TEACH_42 = "展开导航栏",
	TEACH_43 = "点击锻造",
	TEACH_44 = "选择升星页签",
	TEACH_45 = "选择武器",
	TEACH_46 = "点击升星",
	TEACH_47 = "展开导航栏",
	TEACH_48 = "点击锻造",
	TEACH_49 = "选择镶嵌页签",
	TEACH_50 = "选择武器",
	TEACH_51 = "镶嵌攻击宝石",
	TEACH_52 = "选择攻击宝石",
	TEACH_53 = "镶嵌",
	TEACH_54 = "展开导航栏",
	TEACH_55 = "点击宠物",
	TEACH_56 = "点击获取宠物",
	TEACH_57 = "点击免费砸蛋",
	TEACH_58 = "点击钻石砸蛋",
	TEACH_59 = "点击冒险",
	TEACH_60 = "开始挑战",
	TEACH_61 = "点击挑战",
	TEACH_62 = "开始挑战",
	TEACH_63 = "点击冒险",
	TEACH_64 = "点击排行榜图标",
	TEACH_65 = "点击指引按钮",
	TEACH_66 = "点击坐骑按钮",
	TEACH_67 = "展开导航栏",
	TEACH_68 = "点击任务按钮",
	TEACH_69 = "点击支线页签",
	TEACH_70 = "进入竞技场",
	TEACH_71 = "点击创建房间按钮",
	TEACH_72 = "点击确定按钮",
	TEACH_73 = "点击开始游戏按钮",
	TEACH_74 = "点击坐骑按钮",
	TEACH_75 = "点击活跃度图标",
	TEACH_76 = "点击公会建筑物",
	TEACH_77 = "点击结婚建筑物",
	TEACH_78 = "点击商城建筑物",
	TEACH_79 = "展开导航栏",
	TEACH_80 = "点击背包",
	TEACH_81 = "点击时装",
	TEACH_82 = "点击穿上",
	TEACH_83 = "点击挑战",
	TEACH_84 = "点击返回",
	TEACH_85 = "点击出战",
	TEACH_86 = "快来开始新的挑战吧！",
	TEACH_87 = "好多好多任务等着你做呢！",
	TEACH_88 = "使用怒气道具可以增加怒气值！",
	TEACH_89 = "记得使用血包增加血量噢！",
	TEACH_90 = "确认使用",
	TEACH_91 = "风力将会影响到抛物线轨迹，需控制好力度才可驾驭风力",
	TEACH_92 = "3级风力较为强劲，请注意把握攻击力度",
	TEACH_93 = "3级风力较为强劲，请注意把握攻击力度",
	TEACH_94 = "刮起了4级强劲风力，请注意把握攻击力度",
	TEACH_95 = "刮起了4级强劲风力，请注意把握攻击力度",
	TEACH_96 = "刮起了5级超强暴风，请注意把握攻击力度",
	TEACH_97 = "刮起了5级超强暴风，请注意把握攻击力度",
	TEACH_98 = "刮起了6级剧烈飓风，请注意把握攻击力度",
	TEACH_99 = "刮起了6级剧烈飓风，请注意把握攻击力度",
	TEACH_100 = "进入冒险",
	TEACH_101 = "选择精英模式",
	TEACH_102 = "选择第一关",
	TEACH_103 = "点击穿上",
	SUIT = "套装",
	NOT_IN_RANKLIST = "未上榜",
	MAIL_FULLBAG = "背包已满，部分奖励未领取",
	DAILY_Fail_MONSTER = "逃离怪物",
	HALL_NO_SEAT = "房间空位不足",
	NOTENOUTH1 = "礼包数量不足",
	NOTENOUTH2 = "宝箱数量不足",
	NOTENOUTH3 = "钥匙数量不足",
	OPENGIFT = "开启礼包",
	CURRENT_LEVEL2 = [[<T C="79,60,48" S="22" P="0">当前所在</T><T C="99,255,95" S="22" P="0">%s</T><T C="79,60,48" S="22" P="0">层</T>]],
	START_LEVEL = "起始",
	ATHLETICS_LIST = "竞技榜",
	RANK_NO_DATA_ATT = "该榜单还没有人上榜噢",
	MUL_RESET_COPY = "是否消耗 %d 钻石重置 %s 副本(今日还可重置 %d 次)",
	PET_MSG1 = "再升%d级解锁",
	WORLD_BOSS_TITLE = "世界 BOSS",
	OPENGIFTLEVEL = "等级未达到无法使用",
	ATTRTIP1 = "角色死亡存活标志",
	ATTRTIP2 = "主要控制伤害输出",
	ATTRTIP3 = "抵御伤害作用",
	ATTRTIP4 = "增加暴击的机率和暴击倍数",
	ATTRTIP5 = "减少被暴击的机率和暴击倍数",
	ATTRTIP6 = "对伤害加成和所受伤害减少",
	ATTRTIP7 = "增加伤害输出",
	ATTRTIP8 = "减少所受的伤害",
	ATTRTIP9 = "战斗中影响先后出手的顺序",
	ATTRTIP10 = "战斗开始影响先后出手顺序",
	ATTRTIP11 = "降低敌人的防御",
	ATTRTIP12 = "减免自身所受伤害",
	ATTRTIP13 = "武器或子弹爆炸后坑的范围",
	IMPROVE_TOP = "升星等级已满!好棒耶!",
	BELONG_PLAYER = "所属玩家",
	RANKLIST_TITLE = "排行榜",
	RANKLIST_LAOGONG = "老公",
	RANKLIST_LAOPO = "老婆",
	STRENGTENTIP2 = "（添加圣灵石可以保护失败不掉级）",
	MASTEROPENTIPS = "%d天后开启此功能",
	HURT_ALL_VALUE = "总伤害值：",
	GET_RANK_REWARD = "获得排名奖励",
	GET_KILL_REWARD = "获得击杀奖励",
	LOGIN_YOUKE = "游客",
	LOGIN_REGIST = "注册",
	LOGIN_SAVE_ACCOUNT = "记住账号",
	FIGHTADD = "战斗力加成:",
	LOGIN_PASSWORD_SURE = "确认密码:",
	LOGIN_MAIL = "邮箱:",
	LOGIN_REGIST_SUCCESS = "注册成功",
	LOGIN_ERROR = "账号或密码错误",
	LOGIN_REGISTED = "账号已被注册",
	LOGIN_REGIST_FAIL = "账号注册失败",
	UP_TO_LOAD_MORE = "上拉加载更多",
	RELAX_TO_LOAD = "松开加载",
	POWER_NOT_ENOUGH = "亲！活力不足哦，要来点吗？",
	WORSHIP_INFO = "膜拜信息",
	ACTIVITY_TARGET_TYPE_1 = {"竞技等级达%s","段"},
	ACTIVITY_TARGET_ARRAYS = {"青铜","白银","黄金","白金","大师"},
	VOICE_CHAT = "按住  说话",
	STOP_SWEEPING2 = "是否确定停止扫荡？",
	SWEEP_RESULT_TIPS2 = "扫荡第%s层未结束，未获得奖励:",
	SEND_RECORDING = "松开 发送",
	RECODRING_ERROR = "录音失败，录音时间最短1秒",
	LOOSEN_YOUR_FINGER_CANCEL = "松开手指,取消发送",
	WORLD_BOSS_KILL = "恭喜！您已经成功击杀了 %s",
	WORLD_BOSS_KILLED = "%s 击杀了 %s",
	WORLD_BOSS_NOTKILL = "BOSS 非你所杀，无法获得击杀奖励！",
	WORLD_BOSS_NOKILL = "弱爆了！居然没有人能打死BOSS。%s 失望的走了！",
	TOWER_DESC = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> 每日00:00系统重置，重置后返回到第一层，恢复挑战次数和重置次数。（扫荡过程中的玩家将停止扫荡，并且回到第一层）</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> 每日00:00根据试炼塔排名发放奖励。</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> 试炼塔有3次挑战机会，挑战失败扣除1次，挑战次数为0则本次挑战结束。</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> 试炼塔需达成当前层的目标，否则将挑战失败。</T><BR>20</BR>
]],
	MULTI_SWEEP_TIP = "VIP%d开启此功能，是否充值?",
	COMMUNITY_HISTORY_FIGHT = [[<T C="62,34,8" S="22" P="0">历史战绩：</T><T C="128,54,13" S="22" P="0">%d 战 %d 胜 (%s)</T>]],
	COMMUNITY_HISTORY_FIRST = [[<T C="62,34,8" S="22" P="0">冠军次数：</T><T C="128,54,13" S="22" P="0">%d 次</T>]],
	COMMUNITY_HISTORY_SECOND = [[<T C="62,34,8" S="22" P="0">亚军次数：</T><T C="128,54,13" S="22" P="0">%d 次</T>]],	
	COMMUNITY_HISTORY_THIRD = [[<T C="62,34,8" S="22" P="0">季军次数：</T><T C="128,54,13" S="22" P="0">%d 次</T>]],
	COMMUNITY_CUR_DATA = [[<T C="62,34,8" S="22" P="0">本周战绩：</T><T C="128,54,13" S="22" P="0">%d 战 %d 胜 (%s)</T>]],
	COMMUNITY_CUR_SCORE = [[<T C="62,34,8" S="22" P="0">当前积分：</T><T C="128,54,13" S="22" P="0">%d 分</T>]],
	COMMUNITY_CUR_RANK = [[<T C="62,34,8" S="22" P="0">当前排名：</T><T C="128,54,13" S="22" P="0">第 %d 名</T>]],
	COMMUNITY_CUR_RESULT = [[<T C="110,89,67" S="20" P="0">(本周公会战剩余%d%s结算)</T>]],
	COMMUNITY_MY_FIGHT = "我的公会战绩",
	WORLD_BOSS_DESC = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> 在特定时间段，玩家可对入侵的BOSS进行阻击</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> 玩家可通过鼓舞进行伤害加成的提升</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> 加成效果只限于对应BOSS当天的所有战斗</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> 金币鼓舞是有概率成功的，钻石鼓舞是必然成功的</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> 伤害加成上限为100%加成</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="22" P="0"> 伤害加成满上限后将不能再被鼓舞</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">7.</T><T C="127,70,26" S="22" P="0"> 每次战斗开始，挑战将会进入挑战CD状态</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">8.</T><T C="127,70,26" S="22" P="0"> 战斗结束后还在挑战CD状态，需等CD完后才可继续挑战，当然等不及的话可通过消耗少量钻石清CD</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">9.</T><T C="127,70,26" S="22" P="0"> 世界BOSS奖励分为击杀奖励和伤害排名奖励，所有奖励都将在本日活动时间结束后邮件统一发放</T><BR>20</BR>
]],
	WORLD_BOSS_END_TITLE = "活动结束",
	WORLD_BOSS_WIN_DESC = [[<T C="255,236,193" S="22" P="0">玩家</T><T C="99,255,95" S="22" P="0"> %s </T><T C="255,236,193" S="22" P="0">已经击杀了BOSS %s !</T>]],
	WORLD_BOSS_FAIL_DESC = [[<T C="255,236,193" S="22" P="0">BOSS %s 已经离开了等它回来再继续打吧！</T>]],
	WORLD_BOSS_TITLE_DEAC = "明日 %s 再来击杀 %s 吧！",
	WORLD_BOSS_OPEN_TIME = [[<T C="255,236,193" S="22" P="0">每日</T><T C="255,89,74" S="22" P="0">%s-%s</T><T C="255,236,193" S="22" P="0">开启</T>]],
	WORLD_BOSS_NOT_OPEN = [[<T C="255,236,193" S="22" P="0">未开启</T>]],
	WORLD_BOSS_OPEN_TIME_DOWN = "开启倒计时: ",
	WORLD_BOSS_TIME_DOWN1 = [[<T C="255,236,193" S="20" P="1"  SC="79,60,48" SS="2" SE="1">冷却中</T><T C="255,89,74" S="20" P="1"  SC="79,60,48" SS="2" SE="1">%s</T>]],
	WORLD_BOSS_INSPIRE = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="22" P="1" SC="128,54,13" SS="4" SE="1">%d 鼓舞</T>]],
	WORLD_BOSS_TIME_DOWN2 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">冷却中</T><T C="255,89,74" S="20" P="1"  SC="79,60,48" SS="4" SE="1">%s</T>]],
	WORLD_BOSS_SUB_TIME = "%d 消除",
	WORLD_INSPIRE_ADD = [[<T C="255,227,116" S="20" P="1" SC="79,60,48" SS="4" SE="1">伤害加成：</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]],
	WORLD_INSPIRE_GOLD_LAST = "金币鼓舞时间处于冷却中...",
	WORLD_INSPIRE_INSPIRE_NO = "世界BOSS未开启,鼓舞无效!",
	WORLD_INSPIRE_ADD_SUCCESS = "鼓舞成功",
	WORLD_INSPIRE_ADD_Fail = "鼓舞失败",
	WORLD_BOSS_DEAD = "世界BOSS已死亡！",
	WORLD_BOSS_DEAD1 = "世界BOSS已逃跑！",
	SHOP_LIMIT = "【剩%d】",
	COMMUNITY_BATTLE = "公会:",
	COMMUNITY_FIGHT_END = "公会战已结束！",
	DOWN_LOADING_PRO = "更新进度：%dKB/%dKB  (%s)",
	APPLY1 = "已申请",
	SEND_RECORD_CHAT_ERROR  = "发送语音失败",
	NPC_NAME_1 = "克雷•米莉亚",
    NPC_NAME_2 = "酷朗",
	ACCOUNT_NOT_EXIST = "账号不存在",
	PASSWORD_ERROR = "密码错误",
	NOTCHOOSEEQUIP = "还没有选择装备噢",
	LOGIN_ALL_SERVER = "所有服务器",
	LOGIN_TIPS_ACCOUNT = "6-16个字符,可使用邮箱,字母,数字,下划线",
	LOGIN_TIPS_PASSWORD = "6-12个字符,区分大小写",
	LOGIN_TIPS_PASSWORD1 = "请再次填写密码",
	EVERYDAY = "每日",
	DANADNDAO_WELCOME = "欢迎来到Bomb Man!让我们一起愉快的玩耍吧!",
	RECHARGE_SUCCESS1 = "恭喜充值成功",
	RECHARGE_SUCCESS2 = [[<T C="62,34,8" S="22" P="0">您当前为</T><I Z="0.6">ui/common/commom_icon_v.png</I><A IMG = "ui/common_num/common_num_vip.png" Z ="0.6" W = "22" H = "40" CHAR = "0">%d</A><T C="62,34,8" S="22" P="0">,获得%d</T><I Z="0.7">ui/common/common_icon_zuanshi.png</I>]],
	RECHARGE_SUCCESS3 = [[<T C="62,34,8" S="22" P="0">再充值</T><T C="158,0,0" S="22" P="0">%d</T><I Z="0.7">ui/common/common_icon_zuanshi.png</I><T C="62,34,8" S="22" P="0">,将成为</T><I Z="0.6">ui/common/commom_icon_v.png</I><A IMG = "ui/common_num/common_num_vip.png" Z ="0.6" W = "22" H = "40" CHAR = "0">%d</A>]],
	ANNOUNCE  = "公告",
	CAN_GET = "可领取",
	WILL_BECOME = "将成为",
	FUNDINFO1 = [[<T C="255,255,255" S="20" P="0">小投入大回报</T><T C="255,89,74" S="20" P="0">%s</T><T C="255,255,255" S="20" P="0">即可购买!</T>]],
	FUNDINFO2 = [[<T C="255,255,255" S="20" P="0">投入</T><T C="255,89,74" S="20" P="0">%s</T><T C="255,255,255" S="20" P="0">,可累计获得</T><T C="255,89,74" S="20" P="0">%s</T><T C="255,255,255" S="20" P="0">返利!</T>]],
	FUNDINFO3 = [[<T C="255,255,255" S="20" P="0">您已购买成长基金,累计已获得</T><T C="255,89,74" S="20" P="0">%s</T><T C="255,255,255" S="20" P="0">!</T>]],
	FUNDINFO4 = "VIP等级不足，无法购买基金，是否提高VIP等级？",
	FUNDINFO5 = "基金返利领取成功",
	FUNDINFO6 = "成长基金",
	LIMETED_LOGIN_REWARD = "%s月%s日登录奖励",
	FORBIT_RECORD_VOICE = "你禁止了录音权限哦！",
	FIRST_RECHARGE_ACTIVITY = "首充额外奖励",
	MONTHCARDINFO1 = "您尚未加入公会，该道具无法使用",
	MONTHCARDINFO2 = "请选择使用目标",
	ACTIVITY_TOTAL_RECHARGE = "累计充值",
	TOO_FULL = "好饱噢",
	EACH_DAY_TO_GET = "每日准时吃脆花干吃面，可增加大量活力值哟！",
	WORD_E = "哦！！",
	TASTE_NEXT_TIME = "期待下一顿更美味吧！",
	LIMITE_TIME_GIFT = "限时特惠礼包:",
	CAN_BUY_GIFT = "礼包可购买",
	BATTLE_PASS = "通关条件:",
	BATTLE_SINGLE_PASS= "通关副本",
	BD_ACCOUNT_OK = "账号绑定成功",
	WOLRD_BOSS_INSPIRE_FULL = "鼓舞伤害加成已满",
	WOLRD_BOSS_DEAD_NOT_INSPIRE = "BOSS已死亡，无法鼓舞",
	CONSUME = "消耗:",
	RECHARGE_TODAY = "今日充值",
	GET_BIG_GIFT = "，即可获超值大礼包！",
	CAN_GET_ONCE = "活动期间只可领取1次",
	RECHARGE_BETWEEN = "活动期间，充值",
	ANY_MONEY = "任意金额",
	CAN_RECEIVE = "即可获得：",
	RANK_DAY_DATA = [[<T C="255,228,108" S="24" P="0">今日战绩：</T><T C="255,89,74" S="24" P="0">%d</T><T C="255,237,192" S="24" P="0">战</T><T C="255,89,74" S="24" P="0">%d</T><T C="255,237,192" S="24" P="0">胜    </T><T C="255,228,108" S="24" P="0">连胜：</T><T C="255,89,74" S="24" P="0">%d</T>]],
	RANK_BOX_DESC1 = "参战%d次",
	RANK_BOX_DESC2 = "胜利%d次",
	ITEM_NOT_ENOUGH = "亲！爱心不足了哦，您是否购买该道具?",
	VIP_NOT_GET = "未到账",
	NO_ANNOUNCE_MES = "暂无公告信息",
	RECHARGE_DESC =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> VIP成长经验值为实际充值的钻石数量</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> 成为VIP成长经验的钻石数量不包含充值额外赠送钻石以及游戏中系统产出或赠送的钻石</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> 月卡、公会月卡商品由一次性购买钻石数量以及连续领取钻石数量组成</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> 月卡商品的一次性购买钻石为420钻石，即购买该类商品后可立即获得420钻石</T><BR></BR>
<T C="158,0,0" S="22" P="0">5.</T><T C="62,34,8" S="22" P="0"> 公会月卡商品的一次性购买钻石为200钻石，即购买该类商品后可立即获得200钻石</T><BR></BR>
<T C="158,0,0" S="22" P="0">6.</T><T C="62,34,8" S="22" P="0"> 月卡、公会月卡商品的连续领取钻石数量将以日常任务奖励的形式领取，购买后可连续登录30天每日领取100钻石</T><BR></BR>
<T C="158,0,0" S="22" P="0">7.</T><T C="62,34,8" S="22" P="0"> 月卡与公会月卡商品的区别在于月卡只能自己使用，公会月卡却可赠送给自己公会的其他成员，当然赠送的是那30日的登录奖励钻石</T><BR></BR>
<T C="158,0,0" S="22" P="0">8.</T><T C="62,34,8" S="22" P="0"> 礼包页签内购买商品不会增加VIP经验</T><BR>30</BR>
]],
	SKILL_COOL_TIME = "技能冷却中",
	RANK_FIGHT_WIN = [[<T C="158,0,0" S="22" P="0">%d</T><T C="62,34,8" S="22" P="0">战</T><T C="158,0,0" S="22" P="0">%d</T><T C="62,34,8" S="22" P="0">胜</T>]],
	RANK_WIN_STREAK = "(%d 连胜)",
	SELECT_VIP_GIFT_ATT = "尊享VIP特权,将有更丰富的奖励等着你哦!马上前往充值？",
	SETTING_TALK = "语音聊天：",
	RANK_SEGMENT = "段位排行",
	RANK_WEEK_REWARD = "段位周奖",
	RANK_SEGMENT_REWARD = "段位奖励",
	RANK_REWARD_SEGMENT = "段位进阶奖励",
	RANK_WEEK_RANK = "排位赛排行榜",
	RANK_REWARD_WEEK = "周排名奖励",
	RANK_REWARD_GET = [[<T C="127,70,26" S="22" P="0"></T><T C="255,89,72" S="22" P="0"></T><T C="127,70,26" S="22" P="0">赛季结束后根据当前排名发放奖励</T>]],
	RANK_LOG = "战绩日志",
	RANK_LOG_FAIL = "%s前, 你被玩家",
	RANK_LOG_WIN = "%s前, 你把玩家",
	RANK_LOG_LV_UP = "排位等级提升,当前等级为 ",
	RANK_LOG_LV_Down = "排位等级下降,当前等级为 ",
	RANK_LOG_DESC1 = [[<T C="255,236,193" S="22" P="0">%s</T><T C="254,167,48" S="22" P="0"> 打败，段位积分</T><T C="0,255,78" S="22" P="0"> %s</T>]],
	RANK_KING_DESC1 = [[<T C="99,255,95" S="22" P="0">%s</T><T C="255,237,192" S="22" P="0">叱咤风云，在排位赛中拿下了第一名，霸气威武！</T>]],
	RANK_KING_DESC2 = "赛季战绩:",
	RANK_KING_DESC3 = "胜率:",
	RANK_KING_DESC4 = "当前连胜:",
	RANK_KING_WORSHIP_CNT = [[<T C="255,228,108" S="22" P="0">被膜拜</T><T C="0,255,78" S="22" P="0"> %d </T><T C="255,228,108" S="22" P="0">次</T>]],
	RANK_KING_GOLD_CNT = [[<T C="255,228,108" S="22" P="0">可领取 </T><I Z="0.6">ui/common/common_icon_jinbi.png</I><T C="0,255,78" S="22" P="0"> %d</T>]],
	ACCOUNT_BD_DESC = "亲爱的游客,您还未绑定账号,若更换设备将会丢失游戏数据",
	ACCOUNT_BD = "账号绑定",
	ACCOUNT_BD1 = "绑定",
	PET_HIGH_QULITY = "高品质宠物无法快速选择",
	TOTAL_COUNT = "累计",
	RANK_KING_WORSHIP = [[<T C="255,236,193" S="22" P="0">%s </T><T C="254,167,48" S="22" P="0">%s前进行了膜拜</T>]],
	RANK_OPEN_DESC1 = [[<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">(%s至%s)</T><T C="255,89,74" S="22" P="0" SC="79,60,48" SE="1" SS="4"> %s-%s</T><T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">开启</T>]],
	RANK_END_DESC1 = "今日战绩",
	RANK_END_DESC2 = "连胜次数",
	RANK_END_DESC3 = "获得积分",
	RANK_END_DESC4 = "获得积分：",
	WEEK_FIGHT_RESULT = "赛季战绩：",
	PVP_RANK_DESC =
[[
<T C="229,105,22" S="22">积分规则</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">勇者积分每积累到一定分数将会自动消耗提升段位1级</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">勇者积分通过排位赛战斗中的连胜加成、MVP加成、杀人成就加成获得</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">段位掉段时将优先扣除勇者积分用来抵消本次掉段（积分不足时直接掉段）</T><BR>20</BR>
<T C="229,105,22" S="22">赛季说明</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">每赛季自然月1号为新赛季开始日，自然月最后一天为赛季结束日</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">新赛季开启时，段位等级将有一定回落</T><BR>20</BR>
<T C="229,105,22" S="22">奖励规则</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">赛季结束后将对排名第一的玩家发放特殊奖励，及主城雕像设立</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">每赛季达到指定段位等级即可获得专属奖励（每赛季重置）</T><BR>10</BR>
]],
	WORD_FIGHTING = "战",
	WORD_WIN = "胜",
	CURRENT_WIN_STREAK = "当前连胜：",
	NICKNAME = "昵称:",
	COMEFROM = "性别:",
	SHARE_SUCCESS = "分享成功",
	DRESSSTATE = "穿戴状态",
	LEVELSTATE1 = "初级",
	LEVELSTATE2 = "普通",
	LEVELSTATE3 = "高级",
	LEVELSTATE4 = "稀有",
	ANDROID_RECORD_ERROR = "麦克风被禁用,请在手机的权限设置中允许Bomb Man访问你的麦克风",
	IOS_RECORD_ERROR = "【设置-隐私-麦克风】,中允许Bomb Man访问你的麦克风",
	NO_GET_WORDS = "未获得",
	TIPSWORD1 = "行动值:",
	TIPSWORD2 = "初始CD:",
	TIPSWORD3 = "效果:",
	TIPSWORD4 = "VIP%d解锁该道具",
	TIPSWORD5 = "%d级解锁该道具",
	TIPSWORD6 = "解锁",
	DIVORCE_WEDDING_NOT_ENOUGH = "申请离婚需要花费%d钻，钻石不足哦亲！要来点吗？",
	ONEKEY_GIFTBACK = "一键回赠",
	ACCOUNT_NOT_MAIL = "当前账号未绑定邮箱！",
	FRIENDS_FULL_ATT = "亲！你的好友上限已满，是否提升VIP等级增加好友上限？",
	RECEIVE_TIMES_OUT = "亲！你的今日领取次数已用完，是否提升VIP等级增加领取上限？",
	ONEKEYSTRENGTEN = "一键强化",
	PASSWORD_FORGET = "忘记密码",
	PASSWORD_CHANGE = "修改密码:",
	PASSWORD_NEW = "新密码:",
	CHALLENGE_ELITE_ERROR = "需通关当前关卡普通模式后开启",
	SETTING_BIND_MAIL = "绑定邮箱:",
	SETTING_BIND_MAIL1 = "绑定邮箱",
	PASSWORD_FORGET_ACCOUNT = "账号信息:",
	PASSWORD_MAIL_ERROR = "邮箱不正确", 
	SETTING_BINDED_MAIL = "当前账号已绑定邮箱！",
	SETTING_INPUT_PASS = "输入密码:",
	SETTING_INPUT_MAIL = "输入邮箱:",
	SETTING_MAIL_DESC = "请填写个人邮箱以便找回密码时使用",
	SETTING_MAIL_BIND_SUCCESS = "邮箱绑定成功",
	SETTING_MAIL_BIND_FAIL = "密码错误,邮箱绑定失败",
	SINGLE_RESERT_TIP = "是否花费%s钻进行重置?(今日已重置%s/%s次)",
	SINGLE_RESERT_TIP2 = "VIP%s拥有更多重置次数,是否前往充值?",
	TODAY_RESERT_NOT_ENOUGH = "今日重置次数已用完",
	HOMEOWNER_TIP = "你已成为房主",
	STRENGTHEN1 = "装备升星必须消耗升星石，不可卸下",
	STRENGTHEN2 = "强化上限不能超过人物等级",
	STRENGTHEN3 = "提升角色等级才能继续强化",
	STRENGTHEN4 = "已达到最高等级上限,无需继续强化",
	STRENGTHEN5 = "强化已达到角色等级上限",
	MAIL_INFO = "邮箱信息:",
	MAIL_ACCOUNT = "请输入绑定账号时填写的邮箱",
	SETTING_BIND_MAIL_AGAIN = "重绑邮箱:",
	UPGRADE_LEVEL_UNREACHED = "%d级开启",
	MOUNT_LIST = "坐骑列表",
	MOUNT_CAN_LOCK = "可获得",
	MOUNT_CANNOT_LOCK = "未获得",
	PASS_COMMON_SECTION_TIP = "通关该章节的普通模式后开启",
	MOUNTS_SUCCESS1 = "成功率: ",
	MOUNTS_LV_LIMIT = "坐骑等级已达到角色等级上限",
	MOUNTS_LV_LIMIT = "提升角色等级才能继续升级坐骑",
	MOUNTS_LV_MAX = "坐骑升级已满！好棒耶！",
	MOUNTS_STAR_MAX = "坐骑进阶已满！好棒耶！",
	MOUNT_LEVEL1 = "等级：",
	MOUNT_Star1 = "进阶：",
	MOUNT_PILL_CNT = "(拥有 %d)",
	MOUNT_BUY_DESC1 = "是否消耗%s%d获得该坐骑",
	GET_ACHIE_POINTS = "成就点：",
	LEFT_ACHIE_POINTS = "当前剩余成就点：",
	TOTAL_PROGRESS = "总进度：",
	BADGE_FULL_LEVEL = "恭喜，徽章已满级！",
	BADGE_UPGRADE_FAILED = "成就点不够噢，快去完成更多成就吧",
	RANK_DAY_DATA = "今日战绩：",
	RANK_WIN_AGAIN = "连胜：",
	RANK_SCORE_RANK = "排名：",
	PETADVANCESHOW = "进化预览",
	PETSHOW = "预览",
	PETSKILL3 = "天赋技能",
	PETSKILLDESC1 = "宠物进化+1开启",
	PETSKILLDESC2 = "宠物进化+3开启",
	PETSKILLDESC3 = "天赋技能获得时随机天赋技能",
	PETSHOWNAME1 = [[<T C="5,180,0" S="22" P="0">+2 </T><T C="79,60,48" S="22" P="0">(成长期)</T>]],
	PETSHOWNAME2 = [[<T C="5,180,0" S="22" P="0">+4 </T><T C="79,60,48" S="22" P="0">(成熟期)</T>]],
	PETSHOWNAME3 = [[<T C="5,180,0" S="22" P="0">+6 </T><T C="79,60,48" S="22" P="0">(完全体)</T>]],
	RECORD_NET_ERROR = "语音君繁忙中，亲晚点再来吐槽呗~",
	PETNOREBIRTH = "升级或进阶过的宠物才能重生噢",
	PETNOSKILL1 = "宠物进化可以解锁技能噢",
	PETNOSKILL2 = "当前还没有解锁任何技能",
	PETCONFIRMREBIRTH = "宠物重生后将失去等级和进阶效果，是否继续？",
	PETSHOWTIP1 = 
--<T C="255,236,193" S="22" P="0">激活宠物技能</T>
--<T C="99,255,96" S="22" P="0">1</T>
[[
<T C="255,227,116" S="22" P="0">进阶</T>
<T C="99,255,95" S="22" P="0">+1</T>
<T C="255,227,116" S="22" P="0">：</T>
<T C="255,236,193" S="22" P="0">解锁宠物</T>
<T C="99,255,95" S="22" P="0">技能1</T>
<T C="255,236,193" S="22" P="0">，增加</T>
<T C="99,255,95" S="22" P="0">7%</T>
<T C="255,236,193" S="22" P="0">所有属性</T>
]],
	PETSHOWTIP2 = 
[[
<T C="255,227,116" S="22" P="0">进阶</T>
<T C="99,255,95" S="22" P="0">+2</T>
<T C="255,227,116" S="22" P="0">：</T>
<T C="255,236,193" S="22" P="0">改变宠物外观</T>
<T C="255,236,193" S="22" P="0">，增加</T>
<T C="99,255,95" S="22" P="0">13%</T>
<T C="255,236,193" S="22" P="0">所有属性</T>
]],
--<T C="255,236,193" S="22" P="0">激活宠物技能</T>
--<T C="99,255,96" S="22" P="0">2</T>
	PETSHOWTIP3 = 
[[
<T C="255,227,116" S="22" P="0">进阶</T>
<T C="99,255,95" S="22" P="0">+3</T>
<T C="255,227,116" S="22" P="0">：</T>
<T C="255,236,193" S="22" P="0">解锁宠物</T>
<T C="99,255,95" S="22" P="0">技能2</T>
<T C="255,236,193" S="22" P="0">，增加</T>
<T C="99,255,95" S="22" P="0">25%</T>
<T C="255,236,193" S="22" P="0">所有属性</T>
]],
	PETSHOWTIP4 = 
[[
<T C="255,227,116" S="22" P="0">进阶</T>
<T C="99,255,95" S="22" P="0">+4</T>
<T C="255,227,116" S="22" P="0">：</T>
<T C="255,236,193" S="22" P="0">改变宠物外观</T>
<T C="255,236,193" S="22" P="0">，增加</T>
<T C="99,255,95" S="22" P="0">50%</T>
<T C="255,236,193" S="22" P="0">所有属性</T>
]],
	PETSHOWTIP5 = 
[[
<T C="255,227,116" S="22" P="0">进阶</T>
<T C="99,255,95" S="22" P="0">+5</T>
<T C="255,227,116" S="22" P="0">：</T>
<T C="255,236,193" S="22" P="0">解锁宠物</T>
<T C="99,255,95" S="22" P="0">技能3</T>
<T C="255,236,193" S="22" P="0">，增加</T>
<T C="99,255,95" S="22" P="0">75%</T>
<T C="255,236,193" S="22" P="0">所有属性</T>
]],
	PETSHOWTIP6 = 
[[
<T C="255,227,116" S="22" P="0">进阶</T>
<T C="99,255,95" S="22" P="0">+6</T>
<T C="255,227,116" S="22" P="0">：</T>
<T C="255,236,193" S="22" P="0">解锁宠物</T>
<T C="99,255,95" S="22" P="0">技能4</T>
<T C="255,236,193" S="22" P="0">，增加</T>
<T C="99,255,95" S="22" P="0">100%</T>
<T C="255,236,193" S="22" P="0">所有属性</T>
]],
	RANK_NO_WIN = "(阻击连胜)",
	ISEXPPET = "经验宠物不可进行此操作",
	GET_WORSHIP_GOLD = "领取膜拜金币成功",
	PVPRANK_LIST_DESC1 = "排行榜数据将实时刷新",
	PVPRANK_LIST_DESC2 = "赛季结束后根据排名发放奖励",
	PVPRANK_LIST_DESC3 = "段位晋级奖励（邮件发放，仅可获得一次）",
	PVPRANK_LIST_DESC4 = "上赛季排行榜数据",
	NO_CHANGE = "不变",
	CAN_GET_DESIGNATION = "获得称号",
	HAVED_SEND = "已发送",
	WHERE_GET_COPY = "通关探险之地可获得更多探险星魂，通关组队副本可获得更多荣誉星魂",
	STAR_SOUL_HAVED_ACTIVE = "已激活",
	STAR_SOUL_NOT_ACTIVE = "未激活",
	STAR_PROPERTY_ADD = "星魂加成",
	TOTAL_FIGHTING_ADD = "总星魂加成",
	STARSOUL_ACTIVITY_SUCCESS = "激活成功",
	STARSOUL_LOCKED_TIPS = "激活上一个星系所有星魂才可以查看下一个星系喔！",
	CHECKOTHER1 = "坐  骑",
	CHECKOTHER2 = "星  魂",
	CHECKOTHER3 = "卡  牌",
	CHECKOTHER4 = "签  名",
	CHECKOTHER5 = "星魂加成",
	CHECKOTHER6 = "勋  章",
	CHECKOTHER7 = "装  备",
	CHECKOTHER8 = "时  装",
	KNOW = "知道了",
	REMOVE_STONE = "拆卸",
	TIPS1 = "圣灵石材料不足，继续升星可能\n会掉级哦！",
	WOLRD_BOSS_LEFT_NOT_INSPIRE = "BOSS已逃跑，无法鼓舞",
	NOT_ATTENTION_THISTIME = "本次游戏不再提示",
	TIPS2 = "幸运值满必定升星成功，幸运值每日清零！",
	SETTING_SERVERS_STATE_FULL1 = "满人",
	SETTING_SERVERS_LIST = "服务器列表",
	CLICK_OPEN = "点击开启",
	SEARCH_STAR_SOUL = "探险星魂",
	HONOUR_STAR_SOUL = "荣誉星魂",
	NEED_STAR = "需要",
	TEACH_104 = "长按屏幕进行移动，会朝指定方向移动",
	TEACH_105 = "显示怒气槽能量值",
	TEACH_106 = "点击屏幕继续",
	TEACH_107 = "手指按住人物，朝攻击目标的反方向拉动，瞄准攻击（上下调整角度）",
	TEACH_108 = "连发弹：将一次发射2颗炮弹对敌人进行连续打击",
	TEACH_109 = "散射弹：将分散发射2颗炮弹对敌人进行范围打击",
	TEACH_110 = "威力弹：攻击强大，可对敌人造成大量伤害",
	TEACH_111 = "追踪弹：将在一定范围内自动追踪敌人，进行攻击（前7级自动享有此效果噢）",
	TEACH_112 = "POWER：可对敌人造成成吨伤害（不同武器，拥有不同的技能和大招噢）",
	TEACH_113 = "手指按住人物向飞行的反方向拖动，可使人物飞行到目标区域",
	TEACH_114 = "两指向外滑动可拉进镜头，向内拉远镜头",
	TEACH_115 = "CTB行动条，行动条满时轮到出手回合",
	TEACH_116 = "显示剩余回合时间和风向标识",
	TEACH_117 = "游戏音乐设置功能及放弃当前回合操作按钮",
	TEACH_118 = "游戏内聊天将在此区域显示",
	TEACH_119 = "战斗道具及技能的操作区域",
	TEACH_120 = "进入商城",
	TEACH_121 = "选择时装页签",
	TEACH_122 = "试穿时装",
	TEACH_123 = "进行购买",
	TEACH_124 = "确定购买",
	TEACH_125 = "展开导航栏",
	TEACH_126 = "打开背包",
	TEACH_127 = "点击时装",
	TEACH_128 = "选择穿上",
	TEACH_129 = "点击返回",
	TEACH_130 = "打开任务",
	TEACH_131 = "1-7级处于新手保护期，攻击带有追踪效果",
	TEACH_132 = "展开导航栏",
	TEACH_133 = "点击锻造",
	TEACH_134 = "点击洗练页签",
	TEACH_135 = "选择武器",
	TEACH_136 = "进行洗练",
	TEACH_137 = "点击继承页签",
	TEACH_138 = "点击武器页签",
	TEACH_139 = "选择要继承的武器",
	TEACH_140 = "选择要被继承的武器",
	TEACH_141 = "选择武器",
	TEACH_142 = "点击确定",
	TEACH_143 = "点击继承按钮",
	TEACH_144 = "使用连发弹进行连续打击",
	TEACH_145 = "使用散射弹进行分散打击",
	TEACH_146 = "使用威力弹进行最后一击",
	TEACH_147 = "在屏幕边缘，请点击放大按钮",
	TEACH_148 = "从光圈边缘开始拉线拥有更大的操作范围哦",
	TEACH_149 = "前往幸运召唤",
	TEACH_150 = "进行召唤试试",
	TEACH_151 = "换上新装备吧",
	TEACH_152 = "进行更高级的召唤吧",
	TEACH_153 = "展开导航栏",
	TEACH_154 = "继续做任务吧",
	TEACH_155 = "先领取任务奖励",
	TEACH_156 = "再去体验下新装备的威力吧",
	TEACH_157 = "打开祈福界面",
	TEACH_158 = "进行祈福吧",
	TEACH_159 = "拾取这个祈福",
	TEACH_160 = "前往背包穿戴祈福",
	TEACH_161 = "选择获得的祈福",
	TEACH_162 = "进行装备吧",
	TEACH_163 = "展开更多内容吧",
	TEACH_164 = "打开修炼界面",
	TEACH_165 = "进行一次修炼吧",
	TEACH_166 = "进入卡牌系统",
	TEACH_167 = "前往开启卡套",
	TEACH_168 = "选择卡套",
	TEACH_169 = "点击开启它吧",
	WORLD_BOSS_NO_OPEN = "时间未到，还不能挑战世界BOSS哦！",
	STAR_PROPERTY_ADD = "加成",
	VIPTIP1 = "充值VIP",
	VIPTIP2 = "查看特权",
	LUCKVALUE = "幸运值",
	HAVE = "已拥有",
	RANK_KING_DESC5 = "战绩:",
	RANK_KING_DESC6 = "属性加成:",
	TIPS3 = [[<T C="138,122,106" S="20" P="0">未参加竞技对战</T>]],
	TIPS4 = [[<T C="138,122,106" S="20" P="0">未参加排位赛</T>]],
	RANK_KING_DESC7 = "职位:",
	TIPS5 = [[<T C="138,122,106" S="20" P="0">未加入公会</T>]],
	TIPS6 = "公会图腾", 
	RANK_KING_DESC8 = "伴侣:",
	RANK_KING_DESC9 = "师傅名称:",
	RANK_KING_DESC10 = "徒弟名称:",
	RANK_KING_DESC11 = [[师德%d级]],
	RANK_KING_DESC12 = [[师徒BUFF]],
	TIPS7 = [[<T C="138,122,106" S="20" P="0">还是单身</T>]], 
	TIPS8 = [[<T C="138,122,106" S="20" P="0">还未拜师</T>]], 
	TIPS9 = [[<T C="138,122,106" S="20" P="0">还未收徒</T>]],
	SERVER_FULL_PERSON = "服务器满人",
	MOREDRESS = "更多时装",
	BATCHBUY = "批量续费",
	TOUCH_TO_INPUT = "点击输入玩家ID",
	WEDDING_HOLD_TIME = "请选择你想举办的婚礼时间",
	WEDDING_HOLE_TIPS = "若所选婚礼时间已开始或已结束，将在明天同一时间举行",
	EDIT_MAIL = "编写邮件",
	ACTIVITY_REWARD_ATT = "玩家在指定日期登录游戏,可领取相应奖励",
	GOTO_RECHARGE = "前往充值",
	FIGHTING_TO = "战力达到",
	CLICK_CLOSE = "点击关闭",
	SPACE1 = "个人空间",
	NOT_RECORD_VOICE = "手指上滑,取消发送",
	EQUIPMENG_SKILL_LIST = "携带栏",
	SOPHISTIC = "洗练",
	SOPHISTIC_LOCK_ATT = "(小提示：洗练时可以锁定技能不被洗练)",
	SOPHISTIC_PUT_WEAPON = "请先放置想要洗练的武器哦",
	SOPHISTIC_STONE_NOT_ENOUGH = "亲！洗练石不足了哦，您是否购买该道具？",
	SOPHISTIC_LOCK_ASK = "你有高级技能未锁定，是否继续洗练？",
	SOPHISTIC_COST = [[<T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >花费:</T><I Z = "0.45">%s</I><T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >%d</T><T C="158,139,121" S="20" P="1" SC="79,60,48" SE="0" SS="4" >(拥有%d)  </T><I Z = "0.45">%s</I><T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >%d</T><T C="158,139,121" S="20" P="1" SC="79,60,48" SE="0" SS="4" >(拥有%d)</T>]],
	SETTING_TITLE = "设置",
	ACTIVATION = "激活",
	SPACE2 = "踩一踩记录",
	SPACE3 = "收鲜花记录",
	GET_ACCESS = "获得途径",
	EXP_PETDESC = "可为升级的宠物提供大量经验（无法出战，升级，进化）",
	WORD_LOCK = "锁定",
	SHOP_NAME_AND_LEVEL1 = [[<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4" >Lv%d </T><T C="255,255,255" S="22" P="0" SC="79,60,48" SE="1" SS="4">%s</T>]],
	PROPOSE_TIPS2 = "你是否愿意接受我的心意，让我执子之手?",
	SKILL_UPGRADE_FULL = "已升到最高级",
	SOPHISTIC_LOCK_NOT_ENOUGH = "亲！技能锁不足了哦，您是否购买该道具？",
	SPACE4 = "份",
	ACTIVE_SKILL_TIPS = "激活道具技能所需物品不足",
	SPACE5 = "最近访客",
	SPACE6 = "总访客量",
	SPACE7 = "今日访客",
	SPACE8 = "人",
	SPACE9 = "人气",
	SPACE10 = "送出礼物",
	SPACE11 = "收鲜花次数",
	SPACE12 = "魅力",
	SERVER_PLAYER_FULL = "服务器人数已达到最大登录数量",
    VERSION_LOW = "有新的更新内容哦，请重新登录更新哦！",
    NETWORK_CONNECTION_FAILURE = "您已离开游戏，请重新登录！",
	SPACE13 = "获得礼物",
	SPACE14 = "踩一踩",
	SPACE15 = [[送你%d朵玫瑰]],
	SPACE16 = [[踩一踩成功,很可惜没有获得礼物噢o~|>_<|~o]],
	SPACE17 = [[你今天已经踩过对方了~]],
	SPACE18 = [[给对方赠送了%d朵玫瑰,活力值+%d]],
	SPACE19 = [[今日送花次数太多了~明天再来呗]],
	SPACE20 = "快给TA留个言吧",
	SPACE21 = "请输入留言",
	SPACE22 = "查看大图",
	SPACE23 = "拍照上传",
	SPACE24 = "本地上传",
	SPACE25 = [[送玫瑰]],
	SPACE26 = [[玫瑰]],
	SPACE27 = [[对方人气]],
	SPACE28 = [[自己]],
	SPACE29 = [[获得空间礼物,快去道个谢吧~]],
	SPACE30 = [[年]],
	SPACE31 = [[月]],
	SPACE32 = [[日]],
	SETTING_CHANGE_SERVER_CONFIRM = "确定切换服务器吗？",
	MOUNTS_LEVEL_GET5 = "竞技等级%s领取",
	MOUNTS_LEVEL_GET6 = "恩爱等级%d级领取",
	MOUNTS_LEVEL_GET7 = "公会等级%d级领取",
	MOUNTS_LEVEL_GET8 = "排位等级%d级领取",
	COMMUNITYINFO70 = "图腾升级",
	COMMUNITYINFO71 = "技能学堂升级",
	COMMUNITYINFO72 = "公会商店升级",
	SHOP_BUY_SUCCESS = "购买成功",
	SHOP_BUY_FAIL = "购买失败",
	SPACE33 = [[你今天已经送过花了]],
	TIME_NOT_UP = "时间未到",
	MOUNT_SPEED = "速度:",
	MOUNT_LUCKY = "幸运:",
	HURDLES_NOT_OPEN = "此关卡未通关",
	ATH_GOAL_RESET_TIME = [[<T C="79,60,48" S="22" P="0">每日</T><T C="158,0,0" S="22" P="0">24:00</T><T C="79,60,48" S="22" P="0">重置</T>]],
	ATH_GOAL = "积分赛每日目标",
	COMMUNITYINFO73 = [[(%d级商店可购买)]],
	COMMUNITYINFO74 = [[公会日志]],
	COMMUNITYINFO75 = [[公会管理]],
	COMMUNITYINFO76 = [[公会捐献]],
	COMMUNITYINFO77 = [[捐献日志]],
	COMMUNITYINFO78 = [[操作日志]],
	COMMUNITYINFO79 = [[捐献]],
	COMMUNITYINFO80 = [[图腾等级:]],
	COMMUNITYINFO81 = [[图腾加成]],
	COMMUNITYINFO82 = [[瞻仰消耗]],
	COMMUNITYINFO83 = [[瞻仰图腾]],
	COMMUNITYINFO84 = [[学堂等级:]],
	COMMUNITYINFO85 = [[学习技能]],
	COMMUNITYINFO86 = [[公会名称]],
	COMMUNITYINFO87 = [[战绩]],
	COMMUNITYINFO88 = [[战绩排名]],
	COMMUNITYINFO89 = [[公会战绩]],
	COMMUNITYINFO90 = [[个人战绩]],
	COMMUNITYINFO91 = [[公会奖励]],
	COMMUNITYINFO92 = [[个人奖励]],
	COMMUNITYINFO93 = [[商店等级:]],
	COMMUNITYINFO94 = [[免费刷新:]],
	COMMUNITYINFO95 = [[自动刷新时间:]],
	DOWN_TO_LOAD_MORE = "下拉加载更多",
	SPACE34 = [[男]],
	SPACE35 = [[女]],
	SPACE36 = [[保密]],
	PETUP = "宠物升级",
	CAN_EQUIPPED_PROPS = "可装备道具",
	STAR_NOT_ENOUGH1 = "探险星数不足，是否立即前往探险之地获取星数？",
	STAR_NOT_ENOUGH2 = "荣誉星数不足，是否立即前往组队副本获取星数？",
	ATH_CNT_NOT_ENOUGH = "次数不足",
	ATH_REWARD_SEND1 = [[<T C="127,70,26" S="20" P="0">每周日</T><T C="158,0,0" S="20" P="0">24:00</T><T C="127,70,26" S="20" P="0">点根据当前积分周排名发放奖励</T>]],
	ATH_DESC_1 = "积分赛周排名",
	ATH_DESC_2 = "积分赛排名奖励",
	ATH_DESC_3 = "历史排名",
	ATH_DESC_4 = "积分赛历史排名",
	ATH_DESC_5 = [[<T C="127,70,26" S="20" P="0">上周积分赛排名数据，每周日</T><T C="158,0,0" S="20" P="0">24:00</T><T C="127,70,26" S="20" P="0">更新</T>]],
	SUGGESTCLICK = "点击设置",
	ATH_DESC_6 = "无",
	ATH_DESC_7 = "%d战%d胜\n(胜率:%d%%)",
	ATH_DESC_8 = [[<T C="127,70,26" S="20" P="0">每周日</T><T C="158,0,0" S="20" P="0">24:00</T><T C="127,70,26" S="20" P="0">重置</T>]],
	ATH_DESC_9 = "世界排名",
	ATH_DESC_10 = "排名奖励",
	BAG2 = "加成属性",
	SEND_MAIL_SUCCESS = "发送邮件成功",
	DEL_MAIL_SUCCESS = "删除邮件成功",
	SELECT_MARRYGIFT_ITEM = "请选择求婚道具",
	ILLEGAL_CHARACTER = "不能有非法字符",
	INTRODUCTION1 = "说 明",
	MAIL_ALL = "全选",
	EAT_SOME_SWEETS = "亲！活力不足哦，要来点甜甜圈吗？",
	USED_TODAY_ACTIVITY = "活力值不足，请提升vip等级或购买甜甜圈补充体力",
	USE_THINGS = "物品使用",
	ROOM1 = "房间",
	INFO = "信息",
	REWARD_DESC = "奖励预览: ",
	BEWORSHIP_TIMES = [[<T C = "255,236,193" S = "20">被膜拜</T><T C = "99,255,95" S = "20">%d</T><T C = "255,236,193" S = "20">次</T>]],
	MOUNT_GET_COST1 = [[<T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">%d</T><I P="1" Z="0.45">%s</I><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">可获得</T>]],
	MOUNT_GET_COST2 = [[<I P="1" Z="0.45">%s</I><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">x%d可获得</T>]],
	GOLD1 = "金币",
	CARD_COUNT = "%s不足,是否提升VIP等级获取?",
	LOGIN_TIPS_ACCOUNT1 = "6-16个字符",
	LOGIN_TIPS_ACCOUNT2 = "用邮箱,字母,数字,下划线",
	HALL_GET_RAEARD = "再打%d场就可以领取奖励了",
	HALL_GET_RAEARD1 = "再胜利%d场就可以领取奖励了",
	PASSWORD_CHANGE1 = "修改密码",
	SETTING_ADVISE_MAIL1 = "意见邮箱",
	HALL_MATCH_1 = "积分赛",
    HALL_MATCH_2 = "练习赛",
    HALL_WAIT = "等",
	HALL_01 = "有竞技目标未完成噢",
	WNDPLAYERINFO5 = "我的背包",
	SPACE37 = [[获取中]],
	MATCHES_TIMEOUT = "当前人数较少，请稍后尝试",
	MATCHES_TIMEOUT2 = "当前人数较少，请耐心等待",
	CANCEL_READY_ERROR = "已准备开始游戏，不能取消",
	COMMUNITYINFO96 = "修改职位成功",
	COMMUNITYINFO97 = "开除成功",
	COMMUNITYINFO98 = "修改公会宣言成功",
	COMMUNITYINFO99 = "发送公会邮件成功",
	COMMUNITYINFO100 = "公会设置成功",
	COMMUNITYINFO101 = "公会捐献成功",
	COMMUNITYINFO102 = "图腾瞻仰成功",
	Entries = "个",
	Expand = "张",
	REWARD_HAVED_GET = "奖励已领取！",
	SELLGET = "出售获得:",
	SIXIN = "私信",
	SENDMAIL = "发邮件",
	PET_MAJOR = "宠物大全",
	BATTLE_LEFT_HP = "%剩余血量:",
	BATTLE_ATT_TIME = "次出手:",
	SHOP_DRESS_FULL = "你已经拥有当前试穿套装",
	FIRST_SOPHISTIC_ATT = "洗练后原有技能将可能被新技能取代，是否继续？",
	FIRST_LOCK_ATT = "(点击技能将其锁定可不被取代)",
	SPACE38 = [[送鲜花]],
	SPACE39 = [[查看角色]],
	SPACE40 = [[是否确定删除这条留言]],
	SPACE41 = [[删除留言成功]],
	SPACE42 = [[空间最多放置不能超过100个礼物,不用再加啦~]],
	SPACE43 = [[请问您要添加放置多少个空间礼物呢?]],
	COMMUNITYINFO103 = "今天已经捐献过了",
	LOGIN_QUEUE = "登录排队",
	LOGIN_QUEUE1 = [[<T C="128,54,13" S="22" P="0">服务器【%s】人数已满</T>]],
	LOGIN_QUEUE2 = [[<T C="105,65,46" S="24" P="0">目前排在</T><T C="1,72,4" S="24" P="0"> 第%s名</T>]],
	LOGIN_QUEUE3 = [[<T C="105,65,46" S="22" P="0">预计等待时间</T><T C="158,0,0" S="22" P="0"> %s...</T>]],
	LOGIN_QUEUE4 = "取消排队成功",
	LOGIN_QUEUE5 = "取消排队失败",
	LOGIN_QUEUE6 = "获取排队列表失败",
	LOGIN_EXIT_QUEUE = "退出排队",
	SUG_FIGHT1 = [[<T C="127,70,26" S="22" P="0">推荐队伍战力：</T><T C="158,0,0" S="22" P="0">%d</T>]],
	SUG_FIGHT2 = [[<T C="127,70,26" S="22" P="0">推荐队伍战力：</T><T C="0,72,3" S="22" P="0">%d</T>]],	
	SPACE44 = [[该照片栏当前处于锁定状态VIP%d级可开启该照片栏]],
	RECHARGE_DESC1 = "(PS:快去日常任务领取月卡返利吧)",
	RECHARGE_DESC2 = "(PS:快去背包使用该卡赠送公会成员吧)",
    ABOUT2 = "关于游戏:",
	SPACE45 = [[删除照片成功]],
	SPACE46 = [[内存不足，不支持拍照]],
	SPACE47 = [[上传录音成功]],
	SPACE48 = [[上传录音失败]],
	SPACE49 = [[删除录音成功]],
	SPACE50 = [[上传照片成功,系统审核通过后,小伙伴们就能看到你的照片啦]],
	SPACE51 = [[上传照片失败]],
	SPACE52 = [[是否确定删除这张图片?]],
	SPACE53 = [[是否确定删除录音?]],
	SPACE54 = [[选择出生日期,系统将会自动转换为年龄和星座]],
	SPACE55 = [[年龄:]],
	SPACE56 = [[星座:]],
	SPACE57 = [[个人信息设置]],
	SPACE58 = [[名字:]],
	SPACE59 = [[称号:]],
	SPACE60 = [[距离:]],
	SPACE61 = [[语音:]],
	SPACE62 = [[伴侣:]],
	SPACE63 = [[未上传]],
	SPACE64 = [[留言]],
	SPACE65 = [[资料]],
	SPACE66 = [[留言板]],
	SPACE67 = [[照片墙]],
	SPACE68 = [[来踩的小伙伴可能会获得你放置的礼物]],
	SPACE69 = [[放置空间礼物]],
	SPACE70 = [[送鲜花]],
	SPACE71 = [[今日剩余:]],
	SPACE72 = [[语音介绍]],
	SPACE73 = [[上传照片]],
	SPACE74 = [[上传照片需通过审核才有效]],
	SPACE75 = [[重新选择]],
	SPACE76 = [[确认上传]],
	SPACE77 = [[上传]],
	SPACE78 = [[网络不给力噢，上传失败了]],
	SPACE79 = [[白羊座]],
	SPACE80 = [[金牛座]],
	SPACE81 = [[双子座]],
	SPACE82 = [[巨蟹座]],
	SPACE83 = [[狮子座]],
	SPACE84 = [[处女座]],
	SPACE85 = [[天秤座]],
	SPACE86 = [[天蝎座]],
	SPACE87 = [[射手座]],
	SPACE88 = [[摩羯座]],
	SPACE89 = [[水瓶座]],
	SPACE90 = [[双鱼座]],
	SPACE91 = [[岁]],
	SPACE92 = [[格式如下]],
	BAGTIP2 = "已订婚",
	MARRY_TIPS = "沉浸在幸福中的我们于",
	SPACE93 = [[公开我的地理位置信息]],
	SPACE94 = [[我的自定义头像只对好友可见]],
	SPACE95 = [[我的空间留言板只允许好友留言]],
	CLOSE_VIP = "暂未开启充值",
	BAGTIP3 = "回收列表",
	BAGTIP4 = "回收列表已满",
	PVP_RANK_1 = "段位",
	PVP_RANK_2 = "规则说明：",
	PVP_RANK_3 = "当前排名：",
	PVP_RANK_4 = "%d 连胜",
	SEND_PROPOSAL_LETTER9 = "你们的好友度还没达到%d，无法求婚",
	DEVOUR_GET = "可获经验：",
	DEVOUR_CHOOSE = "吞噬选择",
	SURE_CHOOSE = "确定选择",
	DEVOUR_WORDS = "吞噬",
	SURE_DEVOUR = "确定吞噬",
	WAIT_FOR_DEVOUR = "待吞噬的祝福",
	BLESS_CALL = "召",
	BLESS_ONCE = "祈福一次",
	BLESS_QUICK = "快速祈福",
	DEVOUR_ALL = "一键吞噬",
	SELL_ALL = "一键出售",
	PICK_ALL = "一键拾取",
	BLESS_BAG = "祈福背包",
	BLESS_SHOP = "祈福商店",
	GOTO_BLESS = "前往祈福",
	BLESS_FIGHTING = "祈福战力：",
	BLESS_BAG_FULL1 = "背包已满，卸下失败",
	DEVOUR_MOST = "每次只可吞噬8个祝福噢",
	BLESS_BAG_FULL2 = "祝福背包挤不下了，整理下再来吧",
	BLESS_BAG_FULL3 = "祝福背包已满",
	DEVOUR_ATT = "%s祝福将吞噬其他祝福，是否继续？",
	BLESS_LEVEL_ATT = "祝福等级不可超过玩家等级",
	BLESS_FAILED_BACK = "祈福失败，返还%d金币",
	BLESS_HOUSE_FULL = "祈福格已满，请拾取后继续祈福",
	BLESSEDMEN_LEVEL_ATT = "当前祈福师已经是%d级，是否继续召唤专家祈福师？",
	PVP_RANK_5 = "积分：",
	PVP_RANK_6 = "排位赛每日奖励",
	PVP_RANK_7 = "排位赛今日战绩 : %d战 %d胜",
	PVP_RANK_8 = "排位赛赛季奖励",
	PVP_RANK_9 = "排位赛赛季排名奖励",
	PVP_RANK_10 = "赛季奖励",
	PVP_RANK_11 = "排名奖励",
	PVP_RANK_12 = "赛季排名",
	PVP_RANK_13 = "历史排名",
	PVP_RANK_14 = "排位赛赛季排行榜",
	PVP_RANK_15 = "排位赛历史排行榜",
	PVP_RANK_16 = "排位赛赛季战绩 : %d战 %d胜",
	CLICK_TO_CHANGE = "点击更换",
	MASTERINFO31 = [[师德%d级福利预览]],
	MASTERINFO32 = [[你还没有师傅噢]],
	MASTERINFO33 = [[你还没有徒弟噢]],
	MASTERINFO34 = [[当前已拜师]],
	MASTERINFO35 = [[当前未拜师]],
	MASTERINFO36 = [[收徒人数]],
	MASTERINFO37 = [[<T C="158,139,121" S="22" >徒弟消耗:</T><I Z="0.7">ui/common/common_icon_huoli.png</I><T C="232,236,193" S="22" >%d</T>]],
	MASTERINFO38 = [[<T C="158,139,121" S="22" >你获得:</T><I Z="0.7">ui/common/common_icon_huoli.png</I><T C="232,236,193" S="22" >%d</T>]],
	MASTERINFO39 = [[<T C="255,236,193" S="22" >收徒人数:</T><T C="99,255,95" S="22" >%s</T>]],
	MASTERINFO40 = [[<T C="236,209,108" S="20">师门BUFF:</T><T C="255,236,195" S="20">生命</T><T C="95,255,99" S="20"> +%s</T><T C="255,236,195" S="20">攻击</T><T C="95,255,99" S="20"> +%s</T><T C="255,236,195" S="20">防御</T><T C="95,255,99" S="20"> +%s</T>]],
	MASTERINFO41 = [[<T C="236,209,108" S="20">徒弟上限:</T><T C="255,236,195" S="20"> %d名</T>]],
	MASTERINFO42 = [[<T C="236,209,108" S="20">获得称号:</T><T C="241,115,30" S="20"> %s</T>]],
	MASTERINFO43 = [[<T C="236,209,108" S="20">属性加成:</T><BR></BR><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T>]],
	MASTERINFO44 = [[<T C="236,209,108" S="20">徒弟BUFF:</T><BR></BR><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T>]],
	TO_YOU = [[<T C="79,60,48" S="22">%s </T><T C="105,65,46" S="22" P="1">向你</T>]],
	YOU_TO = [[<T C="105,65,46" S="22">你向</T><T C="79,60,48" S="22"> %s</T>]],
	VIGOR_ADD_FRIENDLINESS = [[<T C="105,65,46" S="20" P="1">赠送</T><T C="158,0,0" S="20" P="1"> %d</T><T C="105,65,46" S="20" P="1"> 活力值，你们增加</T><T C="158,0,0" S="20" P="1"> %d</T><T C="105,65,46" S="20" P="1"> 好友度。</T>]],
	FRIEND_APPLY = [[<T C="127,70,26" S="20" P="1">发送了好友申请。</T>]],
	GIFT_ADD_FRIENDLINESS = [[<T C="105,65,46" S="20" P="1">赠送了礼物，你们增加</T><T C="158,0,0" S="20" P="1"> %d</T><T C="105,65,46" S="20" P="1"> 好友度</T>]],
	FRIENDLINESS = "好友度：",
	MY_SPACE = "我的空间",
	GIVE_GIFT = "赠送礼物",
	ADD_FRIENDLINESS = [[<T C="105,65,46" S="24" P="1">增加</T><T C="158,0,0" S="24" P="1"> %d</T><T C="105,65,46" S="24" P="1"> 好友度</T>]],
	EMPTY_INFO = "暂无信息",
	WITH_YOU = [[<T C="79,60,48" S="22">%s </T><T C="105,65,46" S="22" P="1">与你</T>]],
	FIGHT_TOGETHER_FRIENDLINESS = [[<T C="105,65,46" S="20" P="1">并肩完成了战斗，你们同时增加</T><T C="158,0,0" S="20" P="1"> %d</T><T C="105,65,46" S="24" P="1"> 好友度。</T>]],
	FRIEND_GIFT_NOT_ENOUGH = "亲！%s不足了哦，您是否购买该礼物？",
	GIVE_GIFT_SUCCESS = "礼物赠送成功，你们同时增加%d好友度。",
	GIVE_VIGOR_SUCCESS = "活力赠送成功，你们同时增加%d好友度。",
	GET_VIGOR_OK = "成功领取了%d点活力值",
	MASTERINFO45 = "已申请收徒",
	MASTERINFO46 = "申请收徒成功",
	MASTERINFO47 = [[还需%d小时，才可以收徒噢]],
	MASTERINFO48 = [[对方还需%d小时，才可以拜师噢]],
	MASTERINFO49 = [[对方已有师傅了噢]],
	MASTERINFO50 = [[已申请拜师]],
	MASTERINFO51 = [[申请拜师成功]],
	MASTERINFO52 = [[还需%d小时，才可以拜师噢]],
	MASTERINFO53 = [[对方还需%d小时，才可以收徒噢]],
	MASTERINFO54 = [[对方徒弟数量已达上限]],
	MASTERINFO55 = [[操作成功]],
	MASTERINFO56 = [[对方已有师博]],
	MASTERINFO57 = [[对方徒弟数已满]],
	MASTERINFO58 = [[已解除师徒关系]],
	MASTERINFO59 = [[<T C="151,64,19" S="20">你确定要解除与%s的师徒关系吗?</T><BR>22</BR><T C="134,113,92" S="20">对方离线大于</T><T C="158,0,0" S="20">72 </T><T C="134,113,92" S="20">小时，解除关系不受惩罚，是否解除</T> ]],
	SPACE96 = "战斗过程中无法访问个人空间",
	CLICK_ME_TOTRY = "点我试试看！",
	BLESS_LEVEL_MAX = "祝福等级已经最高，不可再吞噬",
	BLESS_PICK = "拾取",
	BLESS_CHOOSE_NIL = "请选择待吞噬的祝福",
	DEVOUR_GET_EXP = [[<T C="127,70,26" S="22" P="1">可获得经验：</T><T C="5,180,0" S="22" P="1">%d</T>]],
	BLESS_EQUIP_OPEN_ATT = [[<T C="255,239,193" S="22" P="1" SC="79,60,48" SE="1" SS="4">%d级</T><BR></BR><T C="255,239,193" S="22" P="1" SC="79,60,48" SE="1" SS="4">开启</T>]],
	NO_BLESS_TO_DEVOUR = "暂时没有可以吞噬的祝福哦",
	ENOUGH_TO_DEVOUR = "所选的祝福已足够升到最高级，可不用再选了哦",
	PLAYER_MOVING = "正在行走...",
	NO_USE_EQUIP_RECT = "装备栏已经放不下了",
	WEDDING_PRIVILEGE = "婚礼特权",
	GET_DRESS = "获得时装",
	WEDDING_TYPE_1_TIP =
[[
<T C="233,166,62" S="20" P="0">1.</T><T C="255,236,193" S="20" P="0"> 获得奢华婚礼礼服</T><BR></BR>
<T C="233,166,62" S="20" P="0">2.</T><T C="255,236,193" S="20" P="0"> 婚礼现场派发红包CD为80秒</T><BR></BR>
<T C="233,166,62" S="20" P="0">3.</T><T C="255,236,193" S="20" P="0"> 婚礼现场派发喜糖CD为80秒</T><BR></BR>
<T C="233,166,62" S="20" P="0">4.</T><T C="255,236,193" S="20" P="0"> 婚礼现场放礼炮CD为80秒</T><BR></BR>
<T C="233,166,62" S="20" P="0">5.</T><T C="255,236,193" S="20" P="0"> 婚礼现场发送祝福CD为80秒，且每次自己可增加15点经验，新郎新娘可增加3点恩爱值</T><BR></BR>
<T C="233,166,62" S="20" P="0">6.</T><T C="255,236,193" S="20" P="0"> 结婚后每日夫妻可互赠15次礼物以便增长恩爱值</T><BR></BR>
]],
	WEDDING_TYPE_2_TIP =
[[
<T C="233,166,62" S="20" P="0">1.</T><T C="255,236,193" S="20" P="0"> 获得豪华婚礼礼服</T><BR></BR>
<T C="233,166,62" S="20" P="0">2.</T><T C="255,236,193" S="20" P="0"> 婚礼现场派发红包CD为100秒</T><BR></BR>
<T C="233,166,62" S="20" P="0">3.</T><T C="255,236,193" S="20" P="0"> 婚礼现场派发喜糖CD为100秒</T><BR></BR>
<T C="233,166,62" S="20" P="0">4.</T><T C="255,236,193" S="20" P="0"> 婚礼现场放礼炮CD为100秒</T><BR></BR>
<T C="233,166,62" S="20" P="0">5.</T><T C="255,236,193" S="20" P="0"> 婚礼现场发送祝福CD为100秒，且每次自己可增加10点经验，新郎新娘可增加2点恩爱值</T><BR></BR>
<T C="233,166,62" S="20" P="0">6.</T><T C="255,236,193" S="20" P="0"> 结婚后每日夫妻可互赠10次礼物以便增长恩爱值</T><BR></BR>
]],
	WEDDING_TYPE_3_TIP =
[[
<T C="233,166,62" S="20" P="0">1.</T><T C="255,236,193" S="20" P="0"> 获得浪漫婚礼礼服</T><BR></BR>
<T C="233,166,62" S="20" P="0">2.</T><T C="255,236,193" S="20" P="0"> 婚礼现场派发红包CD为120秒</T><BR></BR>
<T C="233,166,62" S="20" P="0">3.</T><T C="255,236,193" S="20" P="0"> 婚礼现场派发喜糖CD为120秒</T><BR></BR>
<T C="233,166,62" S="20" P="0">4.</T><T C="255,236,193" S="20" P="0"> 婚礼现场放礼炮CD为120秒</T><BR></BR>
<T C="233,166,62" S="20" P="0">5.</T><T C="255,236,193" S="20" P="0"> 婚礼现场发送祝福CD为120秒，且每次自己可增加5点经验，新郎新娘可增加1点恩爱值</T><BR></BR>
<T C="233,166,62" S="20" P="0">6.</T><T C="255,236,193" S="20" P="0"> 结婚后每日夫妻可互赠5次礼物以便增长恩爱值</T><BR></BR>
]],
	PVP_RANK_17 = "每日奖励",
	PVP_RANK_18 = "赛季奖励",
	PVP_RANK_19 = "比赛说明",
	BLESS_HOUSE_NIL = "没有可用的祝福",
	ORDER_HUSBAND = "未婚夫",
	ORDER_WIFE = "未婚妻",
	CANCEL_READY = "请先取消准备",
	NO_BLESS_TOSELL = "没有可出售的祝福哦",
	NO_BLESS_TOPICK = "没有祝福可以拾取哦",
	NO_BLESS_TOP1 = "结婚关系双方无法删除好友",
	NO_BLESS_TOP2 = "师徒关系双方无法删除好友",
	HALL_DESC1 = "匹配中...",
	HALL_DESC2 = 
{
	[[风力大的时候攻击力度也要相应的拉大，防止导弹被风吹不见哟]],
	[[不同的技能消耗的行动力不同，有时候不是威力越大越好噢，争取更快的出手机会占多点便宜也是不错的]],
	[[多人竞技更讲究队友的配合，一个人的蛮力可是发挥不出来的哟，俗话说得好，三个臭皮匠赛过一个诸葛亮]],
	[[合理的使用道具和技能的配合，可以让战斗更有趣，要掌握好使用的时机噢]],
},
	FIGHT_POWER = [[<I Z="1">ui/common/common_icon_zhandouli.png</I><A IMG = "ui/common_num/common_num_zhandouli.png" Z ="1" W = "16" H = "26" CHAR = "0">%d</A>]],
	FIGHT_POWER1 = [[<I Z="1">ui/common/common_icon_zqzl.png</I><A IMG = "ui/common_num/common_num_zhandouli.png" Z ="1" W = "16" H = "26" CHAR = "0">%d</A>]],
	FIGHT_POWER2 = [[<I Z="1">ui/common/common_icon_cwzli.png</I><A IMG = "ui/common_num/common_num_zhandouli.png" Z ="1" W = "16" H = "26" CHAR = "0">%d</A>]],
	SPACE97 = "房间中无法访问个人空间",
	CALL_TIMES_FINISH = "今日召唤次数已用完",
	CALL_UNSUCCESS = "亲！您的召唤次数已达今日最大上限了，提升VIP等级便可以提升购买次数上限哦！",
	CALL_TIMES_COST = "是否消耗%d钻石召唤祈福师?    (今日已召唤 %d 次)",
	CALL_FREE_ATT = "今日首次召唤，免费的噢，是否继续？",
	SHOP_BUY_DESC1 = "索要",
	SHOP_BUY_DESC2 = [[<T C="79,60,48" S="20" P="0">共%d件商品，需支付</T><I Z="0.8">ui/common/common_icon_jinbi.png</I><T C="5,180,0" S="24" P="0">%d</T>]],
	SHOP_DESC1 = "留言：",
	SHOP_DESC2 = [[<T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4">购买商品需支付</T><I Z="0.8">ui/common/common_icon_zuanshi.png</I><T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4">%d</T>]],
	SHOP_DESC3 = "点击编辑留言",
	VIP_DESC3 = "赠",
	SPACE98 = "点击上传",
	SPACE99 = "审核中...",
	NETTIP1 = "网络稳定",
	NETTIP2 = "网络一般",
	NETTIP3 = "网络差，战斗可能掉线",
	FRIEND_ONLINE_ATT = "上线提醒",
	SELECT_ONLINE_HINT= "请勾选想要上线提示的好友：",
	SELECT_ONLINE_TITLE = "好友上线提示",
	SET_SUCCESS = "设置成功",
	COMMUNITYINFO104 = "会员贡献",
	COMMUNITYINFO105 = "总贡献",
	COMMUNITYINFO106 = "本周贡献",
	COMMUNITYINFO107 = "上周贡献",
	COMMUNITYINFO108 = "贡献",
	TIP = "【提示】",
	FRIENG_ONLINE_TIP = "%s上线了！",
	SHOP_DESC4 = "当前物品不能购买",
	SHOP_DESC5 = "请选择好友",
	SHOP_DESC6 = "索要请求发送成功",
	SHOP_DESC7 = "赠送成功",
	SPACE100 = "功能暂未开放",
	HURT = "伤害：",
	MAIL_SHOP = "商务箱",
	MAIL_PAY = "需付款",
	MAIL_DOPAY = "付款",
	BATTLE_LINK_OUT = "网络已恢复即将连接服务器", 
	BATTLE_RELINK_OK = "恢复连接",
	BATTLE_RELINK_FAILURE = "重连超时，将返回大厅", 
	MUL_ID = "ID：",
	MAIL_HASPAY = "已赠送",
	STRENGTENTIP3 = "幸运值满必定成功,每日清零!",
	STRENGTENTIP4 = "继承前",
	STRENGTENTIP5 = "继承后",
	STRENGTENTIP6 = "选择继承前装备",
	SPACE101 = "礼物:",
	SHOP_DESC8 = "当前物品不能索要",
	NO_INBATTLE_TIP = "还没队伍哦",
	PROBABILITY_GET = "有机率获得",
    PURPLE = "紫装",
    TAKE_OUT_AGAIN = "再抽%d次必得",
	CHOOSE_BLESSITEM = "选择祝福",
	CHOOSE_EQUIP_BLESSITEM = "请选择要装备的祝福",
	NO_BLESSITEM_CAN_EQUIP = "没有可以用于装备的祝福噢，赶紧去祈福吧",
	COPY_LIFT = "前往提升战力",
	SHOP_DESC9 = "VIP等级不足，无法赠送好友，是否提高VIP等级？",
	SHOP_DESC10 = "赠送商品",
	SHOP_DESC11 = "索要商品",
	SETTING_SHIELD_ALLINVITE = "陌生人邀请:",
	MAIL_SHOPTIPS = "商城赠送、索要信息列表",
	SHOP_DESC12 = "需好友%d级且VIP%d以上,好友度达到%d",
	SHOP_DESC13 = "需好友度%d以上",
	GOODS_FULL = "物品大全",
	FRAGMENT_BLESS_SHOW = "碎片抽奖预览",
	DIAMONDS_BLESS_SHOW = "钻石抽奖预览",
	HAVED_INVITED = "已邀请",
	BATTLE_OTHER_RELINK_OK = "%s已恢复连接",
	SPACE102 = "点击上边按钮录音",
	SPACE103 = "手指上滑,取消录音",
	REEL_NOT_ENOUGH = "紫装卷轴不足",
	TEN_RAFFLE = "十连召必得",
	CALL = "召唤",
	ISONLINE = "在线中",
	ISOFFLINE = "未在线",
	WEEK_BEFORE = "%d周前",
	MONTH_BEFORE = "%d月前",
	YEAR_BEFORE = "%d年前",
	LASTONLINE = "最近登录：",
	REPLACE_RAFFLE_TIP = "可代替钻石召唤",
	FRAGMENT_NOT_ENOUGH = "碎片不足",
	COMMUNITYINFO109 = "学习技能成功",
	ALL_SERCER_RANK_NAME = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="62,34,8" S="24" P="0">%s</T>]],
	SPACE104 = "跨服玩家不可进行此操作",
	PET_KAPIAN = "可代替钻石砸蛋",
	PETOPENEGE4 = "卡卷砸蛋", 
	ITEM_TYPE1 = "武器", 
	ITEM_TYPE2 = "绿宝套装",
	ITEM_TYPE3 = "黄金套装",
	ITEM_TYPE4 = "蓝宝套装",
	ITEM_TYPE5 = "绿林套装",
	ITEM_TYPE6 = "海澜散装",
	ITEM_TYPE7 = "沙漠套装",
	ITEM_TYPE8 = "雷电套装", 
	ITEM_TYPE9 = "冰原套装",
	ITEM_TYPE10 = "纯白套装",
	ITEM_TYPE11 = "纯黑散装",
	ITEM_TYPE12 = "魔幻套装",
	ITEM_TYPE13 = "黑暗套装",
	ITEM_TYPE14 = "未来套装",
	ITEM_TYPE15 = "恶魔套装",
	ITEM_TYPE16 = "小丑散装",
	NOT_OPEN_CHAN = "渠道未开放", 
	CLICK_CLOSE_CONTAINER = "点击关闭继续",
	COLOR_CHAT_NOT_CROSS_SERVER = "跨服暂时不支持语音聊天",
	NOT_RECORD_VOICE2 = "手指上滑,取消发送,只在本服有效",
	GET_BLESS_COIN = "得到祈福币",
	CHAT_TEAM = "【队伍】",
	ITEM_PRODUCT = "该物品暂无产出",
	ALL_SERCER_RANK_NAME1 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,236,193" S="24" P="0">%s</T>]],
	LUCK_DRAW_AGAIN = "再召一次",
	LUCK_DRAW_AGAIN_TIP = "再召",
	LUACK_DRAW_AGAIN_TIP2 = "次必得",
	LUACK_DRAW_AGAIN_TIP3 = "本次召唤必得",
	MAIL_FULLBAG2 = "背包已满，请清理后再来",
	BLESSCOIN_NOT_ENOUGH = "祈福币不足了哦",
	BATTLE_ACTION_VALUE_NO_ENOUGH = "行动值不足",
	WIFFTP1 = "网络重连中",
	WIFFTP2 = "等待%s响应",
	LOVELOTTERY = "爱心许愿",
	MONTHCARD_LEFTTIME = "月卡剩余时间:",
	BUY_NOW = "立即购买",
	INVITE_FRIENDS = "邀请码好友",
	INVITE_REWARDS = "邀请奖励",
	COPY_SUCCESS = "复制成功",
	SUBMIT_OK = "成功提交邀请码",
	INPUT_INVITE_CODE = "请输入邀请码",
	INVITE_CODE_NOT_EXIST = "你输入的邀请码不存在",
	IS_MY_INVITE_CODE = "不要太自恋哦，不能输入自己的邀请码",
	INVITE_GET_SUCCESS = "领取奖励成功",
	WRITE_INVIDE_CODE = "填写邀请码",
	MY_INVITE_CODE = "我的邀请码：",
	COPY = "复制",
	WRITE_INVITE_CODE_ATT = "填写提交邀请码，就能获得以下奖励",
	INVITE_CODE_ATT1 = "你提交的邀请码为：",
	INVITE_CODE_ATT2 = "你邀请码好友为：",
	INVITE_CODE_ATT3 = "你已获得邀请码奖励：",
	MOUNT_UP_FIVE = "升级%d次",
	MOUNT_UP_LOG1 = "升级记录",
	MOUNT_UP_LOG2 = [[<T C="195,171,148" S="22" P="0">第%d次升级，%d->%d，消耗%d金币，成功率%s,</T><T C="99,255,95" S="22" P="0">成功</T>]],
	MOUNT_UP_LOG3 = [[<T C="195,171,148" S="22" P="0">第%d次升级，%d->%d，消耗%d金币，成功率%s,</T><T C="255,89,74" S="22" P="0">失败</T>]],
	MOUNT_UP_LOG4 = [[<T C="195,171,148" S="22" P="0">升级%d次，坐骑提升了%d级，共消耗%d金币 </T>]],
	LUACK_DRAW_BOX_UNLOCK_TIP_FRONT = "前面章节的宝箱奖励还没领完哦！",
	LUACK_DRAW_BOX_UNLOCK_TIP_BEHINE = "后面章节的宝箱奖励还没领完哦！",
	BATTLE_ACTION_VALUE_NO_ENOUGH_BIG = "行动值不足8点",
	LIBRARY_NAME = "图鉴",
	LOOK_VIDEO = "观看",
	TEAM_FIGHT = "队伍战力：",
	FIGHT_VIDEO = "录像",
	BEST_VIDEO = "最佳通关录像",
	BEST_VIDEO_DIF1 = "简单难度",
	BEST_VIDEO_DIF2 = "困难难度",
	BEST_VIDEO_DIF3 = "地狱难度",
	INVITE_CODE_ATT4 = "暂无邀请码好友",
	LIBRARY_NAME = "图鉴",
	LEAGUE1 = "比 赛",
	LEAGUE2 = "战 队",
	LEAGUE3 = "荣 誉",
	LEAGUE4 = "回 放",
	LEAGUE5 = "海选赛排名",
	LEAGUE6 = "小组赛战况",
	LEAGUE7 = "十六强",
	LEAGUE8 = "八强决赛",
	LEAGUE9 = "规则说明",
	ATH_DAILY_GOAL = "每日目标",
	INVITE_SUBMIT = "提交",
	LEAGUE10 = "英雄联赛",
	LEAGUE11 = 
[[	
<T C="255,227,116" S="22">赛程安排</T><BR></BR>	
<T C="255,236,193" S="18">3月3日-3月9日 海选赛</T><BR></BR>	
<T C="255,236,193" S="18">3月10日-3月12日 报名正赛</T><BR></BR>	
<T C="255,236,193" S="18">3月13日 32强赛（小组赛）</T><BR></BR>	
<T C="255,236,193" S="18">3月14日 16强赛</T><BR></BR>	
<T C="255,236,193" S="18">3月15日 8强赛</T><BR></BR>	
<T C="255,236,193" S="18">3月16日 4强赛</T><BR></BR>	
<T C="255,236,193" S="18">3月17日 冠军赛、季军赛</T><BR>30</BR>	
	
<T C="255,227,116" S="22">海选赛规则：</T><BR></BR>	
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18">创建战队并组好队员，海选赛期间内无需报名即可参赛；</T><BR></BR>	
<T C="255,236,193" S="20">2.</T><T C="255,236,193" S="18">海选赛结束后达到指定积分可以报名正赛，最终选取海选赛积分最高的32支战队进入正赛。</T><BR>30</BR>	
	
<T C="255,227,116" S="22">正赛规则</T><BR></BR>	
<T C="255,227,116" S="18">三十二强小组赛：</T><BR></BR>	
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18">小组赛由报名成功的32支战队划分成8组，每组4支战队；</T><BR></BR>	
<T C="255,236,193" S="20">2.</T><T C="255,236,193" S="18">小组赛一共战斗3轮，每组的每一支战队都需要和另外3个队伍分别战斗一次，最后获得胜利次数最多的2支战队晋级下一阶段比赛；</T><BR></BR>	
<T C="255,236,193" S="20">3.</T><T C="255,236,193" S="18">若同一个小组中的多支战队胜场相同，则选取海选赛积分高的队伍晋级。</T><BR></BR>	
<T C="255,227,116" S="18">十六强赛：</T><BR></BR>	
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18">十六强由三十二强小组赛晋级的16支战队划分成8组，采用三局两胜的规则，胜利的8支队伍晋级下一阶段比赛。</T><BR></BR>	
<T C="255,227,116" S="18">八强赛：</T><BR></BR>	
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18">八强由十六强赛晋级的8支战队划分成4组，采用三局两胜的规则，胜利的4支队伍晋级下一阶段比赛。</T><BR></BR>	
<T C="255,227,116" S="18">四强决赛：</T><BR></BR>	
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18">四强由八强晋级的4支战队划分成2组，采用三局两胜的规则，胜利的2支队伍进行总决赛、失败的两支队伍进行亚军争夺赛；</T><BR></BR>	
<T C="255,236,193" S="20">2.</T><T C="255,236,193" S="18">总决赛和季军赛的比赛采用三局两胜的规则，获得两场胜利的战队为胜方。</T><BR></BR>	
<T C="255,227,116" S="18">冠军赛和季军赛：</T><BR></BR>	
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18">冠军赛由四强获胜的2支战队进行，采用三局两胜的规则，胜利的一方获得本届英雄联赛的冠军，失败的一方获得本届英雄联赛的亚军；</T><BR></BR>	
<T C="255,236,193" S="20">2.</T><T C="255,236,193" S="18">季军赛由四强失败的2支战队进行，采用三局两胜的规则，胜利的一方获得本届英雄联赛的季军；</T>	
<T C="255,236,193" S="20">3.</T><T C="255,236,193" S="18">冠军赛和季军赛将会同时进行，请各位参赛队伍不要错过比赛时间。</T><BR>30</BR>	
	
<T C="255,227,116" S="22">规则说明：</T><BR></BR>	
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18">联赛中的每一轮比赛，每支战队需要在系统指定的时间内开始战斗，超过时间则直接判负；</T><BR></BR>	
<T C="255,236,193" S="20">2.</T><T C="255,236,193" S="18">正赛及海选赛中，角色属性会进行平衡调整，该效果仅在英雄联赛中有效；</T><BR></BR>	
<T C="255,236,193" S="20">3.</T><T C="255,236,193" S="18">联赛每一场比赛的时间为15分钟，超时后按照双方存活人数以及剩余血量选出胜方。</T><BR>30</BR>	
]],	
	LEAGUE12 = "创建战队",
	VIDEO_FIGHT_ONE = "精彩单挑",
	VIDEO_FIGHT_TWO = "精彩双打",
	VIDEO_FIGHT_THREE = "精彩三战",
	VIDEO_FIGHT_MY = "我的录像",
	VIDEO_FIGHT_ONE_LOOK = "精彩单挑回放",
	VIDEO_FIGHT_TWO_LOOK = "精彩双打回放",
	VIDEO_FIGHT_THREE_LOOK = "精彩三战回放",
	VIDEO_FIGHT_MY_LOOK = "我的录像回放",
	SINGLE_FIGHT = "个人战力：",
	LEAGUE13 = 
[[
<T C="255,227,116" S="20" P="0"> 海选赛:</T><T C="195,171,48" S="20" P="0">2015.11.21~2016.12.22</T><BR>10</BR>
<T C="255,227,116" S="20" P="0"> 参赛时间:</T>
<T C="195,171,48" S="20" P="0">12:00-21:00 胜利积分</T>
<T C="99,255,95" S="20" P="0">+10</T>
<T C="195,171,48" S="20" P="0"> 分,失败积分</T>
<T C="99,255,95" S="20" P="0">-5</T>
<T C="195,171,48" S="20" P="0"> 分</T>
]],
	LEAGUE14 = 
[[
<T C="158,0,0" S="22" P="0"></T><T C="62,34,8" S="22" P="0"> 队伍在线:3</T><BR></BR>
]],
	LEAGUE15 = 
[[
<T C="158,0,0" S="22" P="0"></T><T C="127,70,26" S="22" P="0">小组赛</T><BR></BR>
<T C="158,0,0" S="22" P="0"></T><T C="127,70,26" S="22" P="0">(周六)</T><BR></BR>
<T C="158,0,0" S="22" P="0"></T><T C="127,70,26" S="22" P="0">2016.6.6</T><BR></BR>
]],
	LEAGUE16 = 
[[
<T C="79,60,48" S="22" P="0">1.报名后根据积分选出前32只战队，最后会通过邮件收取结果</T><BR>13</BR>
<T C="79,60,48" S="22" P="0">2.参赛的队伍若在比赛期间未能参战则按弃权处理</T><BR>13</BR>
<T C="79,60,48" S="22" P="0">3.报名需要积分达到%d分</T><BR></BR>
]],
	SHARE_GAME = "分享游戏",
	SHARE_FRIEND = "分享好友",
	SHARE_MOMENTS = "分享朋友圈",
	LANGUAGE_CHANGE = "切换语言:",
	LANGUAGE_CHANGE2 = "切换语言",
	LANGUAGE_CHANGE3 = "切换后将重新登录游戏",
	LEAGUE17 = "场",
	LEAGUE18 = "海选赛",
	CITY_SCENE_NOT_SUPPORT_CHAT = "主城当前频道发言需角色等级达到12级哦",
	LEAGUE_HONOUR_TITLE = "第%d届英雄联赛冠军",
	LEAGUE_REPLAY_ITEM1 = "正在进行",
	LEAGUE_REPLAY_ITEM2 = "精彩回放",
	LEAGUE_REPLAY_ITEM3 = "决赛回放",
	LEAGUE_REPLAY_ITEM4 = "我的回放",	
	LEAGUE_REPLAY_TEXT1 = "战队ID:",
	LEAGUE_REPLAY_TEXT2 = "人观看",
	LEAGUE_REPLAY_TEXT3 = "万人观看",
	LEAGUE_REPLAY_TEXT4 = "已观看",
	LEAGUE_REWARD_ITEM1 = "海选赛奖励",
	LEAGUE_REWARD_ITEM2 = "海选排名奖励",
	LEAGUE_REWARD_ITEM3 = "英雄联赛奖励",
	LEAGUE_REWARD_ITEM4 = "击杀奖励",
	LEAGUE_REWARD_TEXT1 = [[<T C="255,227,116" S="22" P="1">今日战绩：</T><T C="255,236,193" S="22" P="1">%d战%d胜</T>]],
	LEAGUE_REWARD_TEXT2 = [[<T C="255,227,116" S="22" P="1">每日</T><T C="255,89,74" S="22" P="1">00:00</T><T C="255,227,116" S="22" P="1">重置</T>]],
	PLAY_AGAIN = "重播",
	BATTLE_SURE_REPLAY_EXIT = "是否退出本场录像?",
	YOU_HAVE_NO_COMMUNITY = "你还没加入公会哦",
	LEAGUE19 = "第一轮",
	LEAGUE20 = "第二轮",
	LEAGUE21 = "第三轮",
	NO_BLESS_NEED_DEVOUR = "没有可以吞噬的祝福",
	LEAGUE_REWARD_TEXT3 = [[<T C="255,227,116" S="22" P="1">海选赛 </T><T C="255,89,74" S="22" P="1">%s</T><T C="255,236,193" S="22" P="1">发放排名奖励</T>]],
	LEAGUE_REWARD_TEXT4 = [[<T C="255,227,116" S="22" P="1">我的战队排名：</T><T C="255,236,193" S="22" P="1">%s</T>]],
	LEAGUE_REWARD_TEXT5 = [[<T C="255,227,116" S="22" P="1">我的击杀数：</T><T C="255,236,193" S="22" P="1">%d</T>]],
	LEAGUE_REPLAY_TEXT5 = "暂无进行中的比赛",
	LEAGUE_REPLAY_TEXT6 = "暂时没有精彩回放噢",
	LEAGUE_LEAVETEAM_TIMES = "退队次数：%d",
	LEAGUE22 = "奖 励",
	ROLESOUND = "人物声音切换",
	ROLESOUND2 = "角色声音:",
	ROLESOUND_1 = "官方配音",
	ROLESOUND_2 = "个性配音",
	ROLESOUND_3 = "萌系配音",
	LEAGUE_PLAYER_KF1 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,255,255" S="22" P="1">%s</T>]],
	LEAGUE_PLAYER_1 = [[<T C="255,255,255" S="22" P="0">%s</T>]],
	LEAGUE_WAIT_PLAYER = "等待对手进入中...",
	LEAGUE_NO_JOIN = "(未进入的队伍算作弃权)",
	LEAGUE_READY_JOIN = "%d秒后进入战斗",
	LEAGUE23 = "设为参战",
	LEAGUE24 = "设为候选",
	LEAGUE25 = "邀请进入",
	LEAGUE26 = "踢出队伍",
	LEAGUE27 = "战队名称不能为空",
	LEAGUE28 = "战队名称最多5个字",
	LEAGUE29 = "请选择战队图标",
	ATH_GOAL_DESC1 = "夫妻组队参战",
	ATH_GOAL_DESC2 = "夫妻组队胜利",
	ATH_GOAL_DESC3 = "公会组队参战",
	ATH_GOAL_DESC4 = "公会组队胜利",
	ATH_GOAL_DESC5 = "好友组队参战",
	ATH_GOAL_DESC6 = "好友组队胜利",
	ATH_DESC_11 = [[<T C="127,70,26" S="20" P="0">每日</T><T C="158,0,0" S="20" P="0">24:00</T><T C="127,70,26" S="20" P="0">重置</T>]],
	COMMUNITYINFO110 = "公会任务",
	COMMUNITYINFO111 = "基金",
	COMMUNITYINFO112 = "%d基金以上",
	COMMUNITYINFO113 = "当前基金:%d",
	COMMUNITYINFO114 = [[每周日24:00结算基金等级,按照公会职位发放邮件奖励]],
	COMMUNITYINFO115 = [[最近10条信息]],
	COMMUNITYINFO116 = [[今日还没有发布公会任务,公会任务能快速提升公会威望,公会成员也能获得丰富的奖励]],
	COMMUNITYINFO117 = [[前往发布]],
	COMMUNITYINFO118 = [[锁定不刷新]],
	COMMUNITYINFO119 = [[个人]],
	COMMUNITYINFO120 = [[发布任务]],
	COMMUNITYINFO121 = [[待发布]],
	COMMUNITYINFO122 = [[任务发布成功]],
	COMMUNITYINFO123 = [[任务锁定成功]],
	COMMUNITYINFO124 = [[任务解锁成功]],
	BLESS_MEDAL_NOT_ENOUGH = "亲！祈福勋章不足哦",
	MARRYSKILL = "夫妻技能",
	WELFARE_COMPETE_TEXT1 = "敬请期待...",
	WELFARE_COMPETE_TEXT2 = "海选赛进行中",
	WELFARE_COMPETE_TEXT3 = "小组赛进行中",
	WELFARE_COMPETE_TEXT4 = "十六强赛进行中",
	WELFARE_COMPETE_TEXT5 = "八强决赛进行中",
	LEAGUE_REWARD_TEXT6 = "未达条件",
	LEAGUE_REWARD_TEXT7 = "已发放",
	LEAGUE_REWARD_TEXT8 = "离开战队重新计算杀人数量，赛季结束后清空",
	LEAGUE_REPLAY_TEXT7 = "海选赛",
	LEAGUE_REPLAY_TEXT8 = "小组赛",
	LEAGUE_REPLAY_TEXT9 = "16强",
	LEAGUE_REPLAY_TEXT10 = "8强",
	LEAGUE_REPLAY_TEXT11 = "半决赛",
	LEAGUE_REPLAY_TEXT12 = "决赛",
	LEAGUE_REPLAY_TEXT13 = "暂无决赛回放噢",
	LEAGUE_REPLAY_TEXT14 = "暂无我的回放记录",
	SHOP_DESC14 = "角色等级没达到%d级无法赠送",
	LEAGUE_HONOUR_TEXT1 = "还没有冠军产生，说不定就是你，努力吧，少年",
	LEAGUE30 = "创建战队",
	LEAGUE31 = "设置战队",
	LEAGUE32 = [[是否解散队伍，解散过程不可逆转，花费不可退还，解散后队员将离开队伍？]],
	LEAGUE33 = [[是否离开%s战队，该队伍超过48小时未进行战斗，退出不受惩罚，是否退出？]],
	LEAGUE34 = [[是否离开%s战队，该队伍在48小时内进行过战斗，退出后在%d分钟内不可加入新的队伍，是否退出？]],
	EXPLAIN1 = "隐身状态发送表情会暴露位置的噢",
	EXPLAIN2 = "坐骑的骑乘状态不影响坐骑战力加成噢",
	COMMUNITYINFO125 = [[任务已发布,结束倒计时]],
	COMMUNITYINFO127 = [[请选择任务]],
	LEAGUE35 = [[战队不存在]],
	LEAGUE_REPLAY_TEXT15 = "观战",
	LEAGUE36 = [[宣言过长]],
	LEAGUE37 = [[战队宣言]],
	LEAGUE38 = [[你被踢出战队]],
	LEAGUE39 = [[玩家离线大于48小时,踢出队伍无惩罚,是否确认踢出?]],
	LEAGUE40 = [[玩家离线低于48小时,踢出后队伍将在%d分钟内不可进行匹配,是否确认踢出?]],
	LEAGUE41 = [[比赛尚未开始]],
	COMMUNITYINFO126 = [[是否确定发布这4条任务?]],
	LEAGUE42 = [[输入不能包含特殊符号]],
	LEAGUE43 = [[你还没有联赛队伍]],
	LEAGUE44 = [[战队人数已满]],
	LEAGUE45 = [[后开始]],
	LEAGUE46 = [[需要积分%d以上的队伍才可报名]],
	LEAGUE47 = [[海选赛结束后才可报名]],
	LEAGUE48 = [[只有队长可进行报名]],
	LEAGUE49 = [[报名成功，最后参赛名单将通过邮件通知为准]],
	LEAGUE50 = [[你已经报名成功]],
	GOTO_ATHLETICS = "前往竞技",
	GOTO_SECRETSCENE = "前往秘境",
	LEAGUE51 = [[联赛期间不可踢出队员]],
	LEAGUE52 = [[联赛期间不可退出]],
	LEAGUE53 = [[你未获取本轮战斗的资格]],
	LEAGUE54 = [[未到比赛时间，不可战斗]],
	LEAGUE55 = [[房间人数不足三人,无法开战]],
	VOICE_CHAT_STOP = "你禁止了语音聊天,可以在设置中开启",
	LEAGUE56 = [[队伍最多4人不能贪心噢]],
	LEAGUE57 = [[设副队长]],
	LEAGUE58 = [[设为队员]],
	LEAGUE59 = [[取消准备]],
	ACTIVITY_WINWORDS = "胜场",
	LEAGUE_TEAM_SEND_MSG = "该界面无法使用队伍聊天",
	BLESS_RULE =
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> 祈福勋章由竞技目标奖励获得，还可通过竞技商店购买</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> 祈福消耗祈福勋章获得祝福，祈福师越高级所需消耗的祈福勋章越多</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> 祈福过程中有几率触发更高一级的祈福师，如果没有触发则恢复成初级祈福师</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> 祈福有几率获得祈福碎片，祈福碎片可用于祈福商店购买高品质祈福</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> 不同的祈福对应不同属性，同时只可装备一种属性效果的祈福</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="22" P="0"> 祈福可通过吞噬其他祈福进行升级，等级越高祈福属性越高</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">7.</T><T C="127,70,26" S="22" P="0"> 祈福有品质之分，祈福品质越高属性越好，升级所需经验也更多</T><BR>20</BR>
]],
	LEAGUE60 = [[松开刷新]],
	WELFARE_COMPETE_TEXT6 = "进行海选赛",
	UNITY = "至",
	LEAGUE61 = [[名字不能包含空白符]],
	WELFARE_COMPETE_TEXT7 = "进行小组赛",
	WELFARE_COMPETE_TEXT8 = "进行十六强比赛",
	WELFARE_COMPETE_TEXT9 = "进行进行八强以及决赛",
	CHECKOTHER9 = "祈  福",
	CommunityExplain4 =
[[	
<T C="229,105,22" S="22">公会大厅</T><BR></BR>	
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">公会日常管理所在地</T><BR></BR>	
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">可进行公会捐献，可获得公会威望和个人贡献</T><BR></BR>	
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">可进行公会成员审批等人事调整</T><BR></BR>	
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">可进行公会等级升级，升级后可招收成员上限增多，同时可开启对应等级的公会建筑</T><BR></BR>	
<T C="229,105,22" S="22">公会任务</T><BR></BR>	
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">公会会长可每日发布公会任务</T><BR></BR>	
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">公会所有成员可一起协同完成任务，然后获取任务奖励</T><BR></BR>	
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">每周还会根据任务所获取的公会基金段位对应公会成员的职位发放基金奖励</T><BR></BR>	
<T C="229,105,22" S="22">公会图腾</T><BR></BR>	
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">公会的图腾信仰所在地</T><BR></BR>	
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">成员可每日进行瞻仰获取图腾BUFF</T><BR></BR>	
<T C="229,105,22" S="22">技能学堂</T><BR></BR>	
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">成员可消耗自己的贡献学习公会技能</T><BR></BR>	
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">技能学堂等级越高，可学习技能等级上限越高</T><BR></BR>	
<T C="229,105,22" S="22">公会商店</T><BR></BR>	
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">公会成员可通过击杀公会副本BOSS获得商店商品</T><BR></BR>	
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">公会成员可通过伤害公会副本BOSS获取挑战币，然后通过挑战币换取商店拥有的商品</T><BR></BR>	
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">商店等级越高，可购买的商品的折扣越大</T><BR></BR>	
<T C="229,105,22" S="22">公会成员组成</T><BR></BR>	
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">1级公会总人数100，会长1名，副会长2名，长老10名，精英20名</T><BR></BR>	
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">2级公会总人数110，会长1名，副会长2名，长老11名，精英22名</T><BR></BR>	
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">3级公会总人数120，会长1名，副会长2名，长老12名，精英24名</T><BR></BR>	
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">4级公会总人数130，会长1名，副会长2名，长老13名，精英26名</T><BR></BR>	
<T C="127,70,26" S="20">5.</T><T C="127,70,26" S="18">5级公会总人数140，会长1名，副会长2名，长老14名，精英28名</T><BR></BR>	
<T C="127,70,26" S="20">6.</T><T C="127,70,26" S="18">6级公会总人数150，会长1名，副会长2名，长老15名，精英30名</T><BR></BR>	
<T C="127,70,26" S="20">7.</T><T C="127,70,26" S="18">7级公会总人数160，会长1名，副会长2名，长老16名，精英32名</T><BR></BR>	
<T C="127,70,26" S="20">8.</T><T C="127,70,26" S="18">8级公会总人数180，会长1名，副会长2名，长老18名，精英36名</T><BR></BR>	
<T C="127,70,26" S="20">9.</T><T C="127,70,26" S="18">9级公会总人数200，会长1名，副会长2名，长老20名，精英40名</T><BR></BR>	
<T C="127,70,26" S="20">10.</T><T C="127,70,26" S="18">10级公会总人数200，会长1名，副会长2名，长老22名，精英44名</T><BR></BR>	
<T C="127,70,26" S="20">11.</T><T C="127,70,26" S="18">11级公会总人数200，会长1名，副会长2名，长老24名，精英48名</T><BR></BR>	
<T C="127,70,26" S="20">12.</T><T C="127,70,26" S="18">12级公会总人数200，会长1名，副会长2名，长老26名，精英52名</T><BR></BR>	
<T C="229,105,22" S="22">职位权限说明</T><BR></BR>	
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">会长可以进行会员审批、职位任命、修改宣言、公会升级（包括公会建筑）、发送公会邮件、公会设置</T><BR></BR>	
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">副会长可以进行会员审批、职位任命（比自己职位低的）、修改宣言、公会升级（包括公会建筑）、发送公会邮件</T><BR></BR>	
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">长老可以进行会员审批、职位任命（比自己职位低的）、发送公会邮件</T><BR></BR>	
<T C="229,105,22" S="22">公会月卡说明</T><BR></BR>	
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">公会成员间可互赠公会月卡</T><BR></BR>	
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">购买公会月卡后，需在背包里使用公会月卡进行赠送操作，当然也可以自己给自己使用</T><BR></BR>	
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">购买成功公会月卡后，立即获得一部分钻石，赠送成功后，被赠送者可连续30天在日常任务领取月卡福利</T><BR></BR>	
<T C="229,105,22" S="22">弹劾说明</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">公会会长离线时间超过5天，会在晚上12点触发弹劾</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">弹劾将持续24小时，当日公会贡献＞2000的成员可投票</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">超过10名成员投票，则弹劾成功，系统指派1名公会成员成为新会长</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">职位高者更容易成为新会长，但是必须要本周贡献＞0</T><BR></BR>
]],	
	SPACE105 = [[赠送成功,获得%d点活力]],
	SPACE106 = [[今日送花次数已达上限]],
	SPACE107 = [[一天只能送他/她一次噢]],
	MARRY_ROOM_FIND = "没有找到此婚礼ID",
	EDIT_MARRY_ID = "点击输入婚礼ID",
	NO_FIND_MARRY_TIP = "请输入婚礼ID",
	LEAGUE62 = "小组赛第%d轮",
	MARRY_ID = "婚礼ID:",
	WEDDING_TIP_STATS1 = "此婚礼未开始",
	WEDDING_TIP_STATS2 = "此婚礼已结束",
	ARE_YOU_SURE_DISMISS_THIS_PLAYER1 = "你确定将%s开除？\n（今天还可以开除%d人）", 	
	ARE_YOU_SURE_DISMISS_THIS_PLAYER2 = "今日开除成员次数已用完",
	STRENGTENTIP7 = "合成升级消耗:",
	STRENGTENTIP8 = "升级消耗:",
	LEAGUE63 = "十六强赛第%d轮",
	LEAGUE64 = "八强赛第%d轮",
	LEAGUE65 = "半决赛赛第%d轮",
	LEAGUE66 = "决赛赛第%d轮",
	LEAGUE67 = "对手放弃当场比赛，我们战队获得当场比赛的胜利",
	PRACTICE_TITLE = "修炼",
	NEEDMOREPRACTICE = "修炼值不足",
	COMMUNITY_COMPETE = "赛程",
	COMMUNITY_TARGET = "目标",
	COMMUNITY_COMPETE_TEXT1 = "入围公会名单",
	COMMUNITY_COMPETE_TEXT2 = "报名规则",
	COMMUNITY_COMPETE_TEXT3 = "上周总贡献",
	COMMUNITY_COMPETE_TEXT4 = "状态",
	COMMUNITY_COMPETE_TEXT5 = "未报名",
	COMMUNITY_COMPETE_TEXT6 = "已报名",
	COMMUNITY_COMPETE_TEXT7 = "报名",
	COMMUNITY_COMPETE_TEXT8 = "周%d",
	COMMUNITY_COMPETE_TEXT9 = "小组",
	COMMUNITY_COMPETE_TEXT10 = "分组",
	COMMUNITY_COMPETE_TEXT11 = [[<T C="195,171,148" S="20" P="1">第</T><T C="99,255,95" S="20" P="1">%d</T><T C="195,171,148" S="20" P="1">名</T>]],
	COMMUNITY_COMPETE_TEXT12 = "小组赛规则",
	COMMUNITY_COMPETE_TEXT13 = "进入房间",
	COMMUNITY_COMPETE_TEXT14 = "%d进%d比赛",
	COMMUNITY_COMPETE_TEXT15 = "未产生",
	COMMUNITY_COMPETE_TEXT16 = "未开始",
	COMMUNITY_COMPETE_TEXT17 = "总决赛",
	COMMUNITY_COMPETE_TEXT18 = "决赛规则",
	COMMUNITY_COMPETE_TEXT19 = "半决赛规则",
	COMMUNITY_COMPETE_TEXT20 = "周五半决赛",
	MOUNT_ALL_ADD = "骑乘状态不影响已获得的坐骑战力加成",
	STRENGTENTIP9 = "该宝石数量不足",
	RANK_OPEN_DESC2 = [[<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">(%s至%s)</T><T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">开启下个赛季</T>]],
	PVP_LAST_TIME = "第%d赛季(%s-%s)",
	CAN_BE_GET_REWARD = "后可领取奖励",
	RANK_KING_WORSHIP1 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,236,193" S="22" P="0">%s </T><T C="254,167,48" S="22" P="0">%s前进行了膜拜</T>]],
	RANK_RESULT_KF = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="99,255,95" S="20" P="0" SC="3,111,8" SE="1" SS="4">%s</T>]],
	RANK_RESULT_NOKF = [[<T C="99,255,95" S="20" P="0" SC="3,111,8" SE="1" SS="4">%s</T>]],
	RANK_FIGHT_PRO = "排位赛战斗属性",
	RANK_FIGHT_PRO_DESC = "*该属性仅在排位赛战斗中有效",
	GOTO_MARRY = "前往结婚",
	MARRY_DISCOUNT = "活动期间内举办婚礼，享折扣优惠",
	MASTERINFO60 = [[师徒授业]],
	MASTERINFO61 = [[开始授业]],
	MASTERINFO62 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">师傅:</T><BR>8</BR><T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">授业后可获得%d点师德值</T><BR>5</BR><T C="99,255,95" S="18" P="1" SC="79,60,48" SS="4" SE="1">(在线徒弟越多,可获得师德越多,当前在线%d/%d)</T>]],
	MASTERINFO63 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">徒弟:</T><BR>8</BR><T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">在线可获得</T><I Z="1">ui/common/common_icon_exp.png</I><T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">%d</T><BR>5</BR><T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">离线可获得</T><I Z="1">ui/common/common_icon_exp.png</I><T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">%d</T><BR>5</BR><T C="99,255,95" S="18" P="1" SC="79,60,48" SS="4" SE="1">(师德等级越高徒弟经验越多,当前师德等级%d级)</T>]],
	MASTERINFO64 = [[<T C="255,89,74" S="20" P="1">%s</T><T C="79,60,48" S="20" P="1">后可以再次授业</T>]],
	POWER2 = "力量:",
	AGILITY2 = "护甲:",
	TIZHI2 = "体质:",
	WNDPRATICE_TIPS_TITLE = "修炼总属性加成:",
	WNDPRATICE_TIPS_TITLE2 = "摇到星星可额外增加经验值",
	PRACTICE_VALUEDESC1  = "生命可以增加你的血量",
	PRACTICE_VALUEDESC2  = "攻击可以加强你的伤害",
	PRACTICE_VALUEDESC3  = "防御可以帮你抵御伤害",
	PRACTICE_VALUEDESC4  = "体质可对伤害加成使所受伤害减少",
	PRACTICE_VALUEDESC5  = "力量可以增加伤害输出",
	PRACTICE_VALUEDESC6  = "护甲可以减少所受伤害",
	MASTERINFO65 = [[完成]],
	SPOUSE_COPY = "夫妻副本",
	PRACTICE_USE = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >今日消耗:</T><I Z ="0.45">ui/common/common_icon_hylqhltb.png</I><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >%d</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >  获得:</T><I P="1">ui/common/common_icon_xl.png</I><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >%d</T>]],
	PRACTICE_USE2 = [[<T C="255,227,116" S="18" P="1" >今日第%d次修炼:</T><I P="1">ui/common/common_icon_xl.png</I><T C="255,236,193" S="18" P="1" >%s(拥有%d)</T>]],
	MASTERINFO66 = [[<T C="127,70,26" S="20" P="1">日常目标每日</T><T C="255,89,74" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1">重置</T>]],
	BAG_FULL = "背包空间不足",
	LEAGUE68 = [[是否设置%s为副队长(队长不在房间时拥有开始战斗的权限,只可设置一位)]],
	LEAGUE69 = [[是否取消%s副队长的职位)]],
	LEAGUE70 = [[战队 ID]],
	LEAGUE71 = [[小组赛(一局定胜败):%s]].."\n"..[[第一轮参战时间:%s]].."\n"..[[第二轮参战时间:%s]].."\n"..[[第三轮参战时间:%s]], 
	LEAGUE72 = [[16强决8(三局定胜败):%s]].."\n"..[[第一局参战时间:%s]].."\n"..[[第二局参战时间:%s]].."\n"..[[第三局参战时间:%s]], 
	LEAGUE73 = [[8强决4(三局定胜败):%s]].."\n"..[[第一局参战时间:%s]].."\n"..[[第二局参战时间:%s]].."\n"..[[第三局参战时间:%s]], 
	LEAGUE74 = [[半决赛(三局定胜败):%s]].."\n"..[[第一局参战时间:%s]].."\n"..[[第二局参战时间:%s]].."\n"..[[第三局参战时间:%s]], 
	LEAGUE75 = [[决赛(三局定胜败):%s]].."\n"..[[第一局参战时间:%s]].."\n"..[[第二局参战时间:%s]].."\n"..[[第三局参战时间:%s]],
	LEAGUE76 = [[创建战队成功]],
	LEAGUE77 = [[分钟后才可申请]],
	LEAGUE78 = [[申请战队成功]],
	LEAGUE79 = [[已审核]],
	LEAGUE80 = [[踢出战队成功]],
	LEAGUE81 = [[进入战队成功]],
	LEAGUE82 = [[退出战队成功]],
	LEAGUE83 = [[邀请你进入战队界面]],
	LEAGUE84 = [[分钟后才能匹配]],
	LEAGUE85 = [[报名联赛]],
	LEAGUE86 = [[确定报名]],
	LEAGUE87 = [[查询报名]],
	LEAGUE88 = [[查询条件]],
	LEAGUE89 = [[战队名称]],
	LEAGUE90 = [[我的战队积分]],
	LEAGUE91 = [[最多输入5个字]],
	LEAGUE92 = [[宣言:]],
	LEAGUE93 = [[需要:]],
	LEAGUE94 = [[(战队名称不可修改)]],
	LEAGUE95 = [[(建议使用150*150尺寸)上传图片需通过审核才有效]],
	LEAGUE96 = [[前往比赛]],
	LEAGUE97 = [[我的战队排名:]],
	LEAGUE98 = [[积分:]],
	LEAGUE99 = [[审批队员]],
	LEAGUE100 = [[成员:]],
	LEAGUE101 = [[海选赛排名:]],
	LEAGUE102 = [[战绩:]],
	LEAGUE103 = [[战队名字]],
	LEAGUE104 = [[战队 ID:]],
	LEAGUE105 = [[比赛赛程说明]],
	LEAGUE106 = [[邀请队员]],
	LEAGUE107 = [[候补状态]],
	LEAGUE108 = [[请输入战队ID]],
	LEAGUE109 = [[图标:]],
	LEAGUE110 = [[准备战斗]],
	LEAGUE111 = [[参战时间]], 
	LEAGUE112 = [[胜利积分]], 
	LEAGUE113 = [[失败积分]],
	ADVISE_FIGHT = "推荐队伍战力: ",
	COMMUNITY_COMPETE_TEXT21 = 
[[
<T C="127,70,26" S="20" P="0">公会战规则汇总</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> 公会战按照两周1届举办.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> 服务器≥2级的公会数量≥10,则可开启公会战（每周一0点进行判断）</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> 公会战开启后,先进行为期1周的资格赛争夺,按照本周内新增威望从高到低进行排序,排名前30的公会可以在下个周期进行报名.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> 第二周进行排名公布（周一）、报名（周二）、筛选入围以及分组（周三）、比赛流程（周四至周六）.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0"> 周三从报名公会中筛选16名上周新增威望排名靠前的公会进行分组并公布.</T><BR></BR>
<T C="229,105,22" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0"> 公会战每个公会每次可出战3个战队,每个战队最多3人,队员需要满足两个条件:角色等级≥25,加入公会时间≥48小时.</T><BR></BR>
<T C="229,105,22" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0"> 若队伍里没设置队员,则会出现轮空,对手直接晋级;若双方队伍均为空,则由系统判断胜负;赛制采取三盘两胜制,两队或以上队伍获胜则晋级.</T><BR></BR>
]],
	CARD_TEXT1 = "已收集卡牌%d张",
	CARD_TEXT2 = "卡套",
	CARD_TEXT3 = "未收集卡牌%d张",
	CARD_TEXT4 = "今天剩余：%d/%d个",
	CARD_TEXT5 = [[<T C="255,89,74" S="22" P="1" SC="158,0,0" SS="4" SE="1">%s </T><T C="195,171,148" S="22" P="1" SC="79,60,48" SS="4" SE="1">后可开启卡套</T>]],
	CARD_TEXT6 = [[<T C="255,227,116" S="22" P="1">获得卡券：</T><I Z="0.8" P="1">ui/common/common_icon_emzz.png</I><T C="255,236,193" S="22" P="1">%d-%d</T>]],
	CARD_TEXT7 = [[<T C="255,227,116" S="22" P="1">获得卡牌：</T><I Z="1" P="1">%s</I><T C="255,236,193" S="22" P="1">%d-%d</T>]],
	CARD_TEXT8 = [[<T C="255,227,116" S="22" P="1">开启消耗CD为：</T><T C="255,236,193" S="22" P="1">%s</T>]],
	CARD_TEXT9 = "有几率获得以下卡片",
	CARD_TEXT10 = "开启卡套",
	CARD_TEXT11 = [[<T C="195,171,148" S="22" P="1" SC="79,60,48" SS="4" SE="1">每日</T><T C="255,89,74" S="22" P="1" SC="158,0,0" SS="4" SE="1">%s </T><T C="195,171,148" S="22" P="1" SC="79,60,48" SS="4" SE="1">刷新商店</T>]],
	CARD_TEXT12 = [[<T C="255,227,116" S="22" P="1">至少包含精英卡：</T><I Z="1" P="1">%s</I><T C="255,236,193" S="22" P="1">%d</T>]],
	CARD_TEXT13 = [[<T C="255,227,116" S="22" P="1">至少包含传奇卡：</T><I Z="1" P="1">%s</I><T C="255,236,193" S="22" P="1">%d</T>]],
	CARD_TEXT14 = [[<T C="255,227,116" S="22" P="1" SC="158,0,0" SS="4" SE="1">%s</T><I Z="1" P="1">%s</I><T C="255,236,193" S="22" P="1" SC="158,0,0" SS="4" SE="1">%d</T>]],
	MARRY_COPY_COST_LIFE = "（需%d  ）",
	MASTERINFO67 = [[孝敬]],
	MASTERINFO68 = [[孝敬成功]],
	MASTERINFO69 = [[师父在线才可孝敬]],
	MASTERINFO70 = [[今日孝敬的够多了，明日再来吧]],
	MASTERINFO71 = [[冷却]],
	CARD_TEXT15 = "品质：",
	CARD_TEXT16 = "卡牌数量不足，无法进行升级",
	CARD_TEXT17 = "卡券数量不足，无法进行升级",
	CARD_TEXT18 = "今日卡套开启数量已达上限",
	CARD_TEXT19 = "卡套开启冷却中，是否花费%d钻石消除冷却",
	CARD_TEXT20 = "卡券数量不足，无法购买", 
	CARD_TEXT21 = "%s卡牌已激活",
	CARD_TEXT22 = "%s卡牌 +%d",
	MASTERINFO72 = [[<T C="79,60,48" S="20" P="1">今日剩余%d次</T>]],
	MASTERINFO73 = [[分钟后才可授业]],
	MASTERINFO74 = [[今日授业次数已用完]],
	MASTERINFO75 = [[授业成功获得%d点师德值]],
	MASTERINFO76 = [[冷却中不可孝敬]],
	MASTERINFO77 = [[当前没有在线的徒弟,不可授业]],
	INV_OBJECT = "邀请对象",
	COMMUNITYINFO128 = [[你的会长今日还没有发布公会任务噢!]],
	COMMUNITYINFO129 = [[点此输入给会长的留言]],
	CARD_TEXT23 = "普通",
	CARD_TEXT24 = "精英",
	CARD_TEXT25 = "传奇",
	RANK_RESULT_KF1 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,236,193" S="20" P="0" SC="105,65,46" SE="1" SS="4">%s</T>]],
	FOREVER_WELFARE_CARD = "永久福利卡",
	CARD_TEXT26 = "未有激活卡牌",
	RANK_RESULT_NOKF1 = [[<T C="255,236,193" S="20" P="0" SC="105,65,46" SE="1" SS="4">%s</T>]],
	CHECKOTHER10 = "修  炼",
	CARD_TEXT27 = "开启卡包",
	CARD_TEXT28 = "卡券 +%d",
	CARD_TEXT29 = "卡套数据异常，请联系客服",
	CARD_TEXT30 = "该卡套来路不明，不能开启",
	CARD_TEXT31 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">可点击开启卡套</T>]],
	CARD_TEXT32 = "你看，冷却完了，快去开卡",
	CARD_TEXT33 = "暂无卡套，快去扫荡副本拿卡套吧。",
	CARD_TEXT34 = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> 通关普通、精英难度关卡以及组队副本可获得卡套。</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> 开启卡套可获得怪物卡牌以及卡券，用于激活、升级卡牌。</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> 卡套开启后会产生CD，需要冷却后才可以再次开启卡套。每日可开启卡套次数有限。</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> 卡牌商店每日凌晨0时刷新，随机刷新不同卡牌。</T><BR></BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> 卡牌分为普通、精英、传说3个级别，分别对应不同难度的副本产出的卡套。</T><BR></BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="22" P="0"> 除了开启卡套以及商店购买，还可以开启卡包，卡包不消耗每日开启次数，打开无CD。</T><BR></BR>
]],
	CARD_COUNT1 = "%s不足",
	LIMITE_BUY_ACTIVITY = "可购买",
	LIMITE_BUY_ORIGINPRICE = "原价", 
	MASTERINFO78 = [[我刚进行了授业,你获得了%d点经验]],
	MASTERINFO79 = [[我刚孝敬了你,你获得了%d点师德值]],
	GOTO_MULTIPLECOPY = "前往组队",
	GOTO_ELITE = "前往精英",
	LIMITE_BUY_CURPRICE = "现价",
	LIMITE_BUY_SOLDOUT = "已卖完",
	PETSKILL1 = "技能1",
	PETSKILL2 = "技能2",
	PETSKILL3 = "技能3",
	PETSKILL4 = "技能4",
	PETSKILLDESC1 = "宠物进阶+1解锁该技能孔",
	PETSKILLDESC2 = "宠物进阶+3解锁该技能孔",
	PETSKILLDESC3 = "宠物进阶+5解锁该技能孔",
	PETSKILLDESC4 = "宠物进阶+6解锁该技能孔",
	PETSKILL_LOCK_ASK = "本次游戏不再提示",
	PETSKILL_LOCK_ASK2 = "宠物有高级技能未锁定，是否继续领悟",
	PETSKILLNUM = "技能:",
	PETNEEDUPADVANCELEVEL = "需要宠物进阶+1以上",
	PRACTICE_QUICK = "跳过动画",
	GOTO_PET = "前往抽取",
	PRACTICE_QUICK_LV = "需要vip2级开启，是否提升vip等级？",
	WARN_DESC1 = [[<T C="255,236,193" S="12" P="0" SC="138,122,106" SE="1" SS="2">抵制不良游戏 拒绝盗版游戏 注意自我保护 谨防受骗上当 适度游戏益脑 沉迷游戏伤身 合理安排时间 享受健康生活</T>]],
	WARN_DESC2 = [[<T C="255,236,193" S="12" P="0" SC="138,122,106" SE="1" SS="2">著作人：珠海网易达电子科技发展有限公司   出版服务单位：上海科学技术文献出版社有限公司   审批文号：新广出审〔2016〕1266号   出版物号：ISBN978-7-7979-0084-3</T>]],
	INPUT_MAX_CHAT = "最多输入24个字符",
	COMMUNITY_COMPETE_TEXT23 = "第一轮比赛",
	COMMUNITY_COMPETE_TEXT24 = "第二轮比赛",
	COMMUNITY_COMPETE_TEXT25 = "已结束",
	COMMONITY_DESC1 = "公会目标",
	COMMONITY_DESC2 = "公会奖励",
	COMMONITY_DESC3 = "累计参与公会战%d场",
	CHARM_SPACE = "魅力空间",
	CHARM_RANK_RELOAD = "随机推荐",
	CHARM_RECOMMEND = "周鲜花榜",
	CHARM_TOTAL_RANK  = "总鲜花榜",
	RANK_REWARD = "排名奖励",
	EVERY_WEEKDAY = "每周日",
	CHARM_TIME= "24:00",
	CHARM_SEND_REWRAD = "点，根据周鲜花榜单排名发放奖励",
	CHARM_PLAYER = "玩家",
	CHARM_ID = "ID",
	CHARM_SERVER = "区服",
	CHARM_FLOWER_NUM = "收花数",
	CHARM_MESSAGE = "信息",
	SPACE = "空间",
	CHARM_ALL = "全",
	CHARM_BOY = "男",
	CHARM_GIRL = "女",
	CHARM_REFRESH = "刷新",
	COMMUNITY_COMPETE_TEXT26 = "房间中没人",
	FRIENDS_LOCALFRIEND = "本服好友",
	FRIENDS_OTHERFRIEND = "跨服好友",
	CHARM_RELOAD = "每周日24点重置（花数需>%d上榜）",
	CHARM_RELOAD2 = "花数需>%d上榜",
	INVITE_LEAGUE = "英雄联赛可以参加了，是否立刻加入？",
	FRIENDS_NO_OTHERFRIEND = [[暂无跨服好友信息]],
	FRIENDS_KUAFU = "跨服",
	ATT_ONLINEFRIEND_NULL = [[暂无跨服在线好友]],
	HAD_ONLINE = "已在线",
	ONLINE_REWRAD = "请领取奖励",
	CONTINUE_ONLINE = "继续在线",
	LEAGUE_REWARD_TEXT9 = "未达成",
	MASTERINFO80 = [[当前等级奖励如下:]],
	COMMONITY_DESC4 = [[<T C="255,236,193" S="18" P="1">%s</T><T C="255,227,116" S="18" P="1"> %s</T>]],
	COMMONITY_DESC5 = [[<T C="255,236,193" S="18" P="1">%s</T><T C="233,166,62" S="18" P="1"> %s</T>]],
	COMMONITY_DESC6 = [[<T C="255,236,193" S="18" P="1">未产生</T>]],
	COMMONITY_DESC7 = "冠军决赛",
	COMMONITY_DESC8 = "季军决赛",
	ATH_DESC12 =
[[
<T C="229,105,22" S="22">竞技等级说明</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">竞技等级根据竞技积分获得成长，竞技等级会有属性加成</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">竞技等级5级以下失败不会扣竞技积分。</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">影响竞技得分主要因素有：竞技参与人数、首杀、人头数</T><BR>10</BR>
]],
	MEMBER_TEAM = "分配队伍",
	COMMUNITY_COMPETE_TEXT27 = "公会房间成员",
	COMMUNITY_COMPETE_TEXT28 = "当前已有%d名公会成员进入公会战系统",
	COMMUNITY_COMPETE_TEXT29 = "取消参赛",
	COMMUNITY_COMPETE_TEXT30 = "查看信息",
	COMMUNITY_COMPETE_TEXT31 = "点击设置队员",
	COMMUNITY_COMPETE_TEXT22 = "组",
	COMMUNITYINFO130 = [[职位任命]],
	COMMONITY_DESC9 = "精彩对决",
	COMMONITY_DESC10 = [[<T C="255,89,74" S="20" P="1">%s</T><T C="127,70,26" S="22" P="1">开始</T>]],
	COMMUNITYINFO131 = [[当前公会等级可任命%s职位数量:]],
	COMMUNITYINFO132 = [[确定任命]],
	COMMONITY_DESC11 = "第%d届",
	COMMUNITYINFO133 = [[该职位上限已满]],
	COMMUNITYINFO134 = [[任命该职位数量超过上限,请重新选择]],
	COMMUNITYINFO135 = [[选择目标中有成员已经职位变动了]],
	COMMUNITYINFO136 = [[选择目标中有成员已经离会]],
	COMMUNITYINFO137 = [[任命成功]],
	CHARM_DES =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> 随机推荐只推荐有照片的玩家</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> 空间上传照片越多推荐率越高</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> 本周收花数越多推荐率越高</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> 空间上传语音后会增加推荐率</T><BR></BR>
]],
	COMMYNITY_COMPETE_TEXT32 = "该队伍已满，请重新设置",
	COMMYNITY_COMPETE_TEXT33 = "未设置",
	COMMYNITY_COMPETE_TEXT34 = "队",
	CHARM_RESULT = "暂无数据",  
	CHARM_SINGLE = "单身",
	CHARM_COMMUNITY = "公会:",
	CHARM_NOT_INTO_SPACE = "跨服空间暂未开放",
	CHARM_NO_PLAYER = "暂无推荐玩家",
	COMMUNITYINFO138 = [[所在公会成员可获得奖励]],
	SPACE108 = [[More>>]],
	SPACE109 = [[可以进入了噢]],
	SUREDELFRIEND1 = "确定删除好友？",
	COMMYNITY_COMPETE_TEXT35 = "取消参战",
	GAME_ACTIVITY_TITLE1 = "首次充值",
	GAME_ACTIVITY_TITLE2 = "每日首充",
	GAME_ACTIVITY_TITLE3 = "限时首充",
	GAME_ACTIVITY_TITLE4 = "累计充值",
	GAME_ACTIVITY_TITLE5 = "充值返利",
	GAME_ACTIVITY_TITLE6 = "累计消费",
	GAME_ACTIVITY_TITLE7 = "限时登录",
	GAME_ACTIVITY_TITLE8 = "累计登录",
	GAME_ACTIVITY_TITLE9 = "强化",
	GAME_ACTIVITY_TITLE10 = "冲级",
	GAME_ACTIVITY_TITLE11 = "战力提升",
	GAME_ACTIVITY_TITLE12 = "VIP等级奖励",
	GAME_ACTIVITY_TITLE13 = "限购礼包",
	GAME_ACTIVITY_TITLE14 = "竞技等级",
	GAME_ACTIVITY_TITLE15 = "每日充值",
	GAME_ACTIVITY_TITLE16 = "吃大餐",
	GAME_ACTIVITY_TITLE17 = "封测预充",
	GAME_ACTIVITY_TITLE18 = "等级冲榜",
	GAME_ACTIVITY_TITLE19 = "竞技冲榜",
	GAME_ACTIVITY_TITLE20 = "战力冲榜",
	GAME_ACTIVITY_TITLE21 = "夫妻同心战",
	GAME_ACTIVITY_TITLE22 = "公会大作战",
	GAME_ACTIVITY_TITLE23 = "秘境宝藏双倍",
	GAME_ACTIVITY_TITLE24 = "竞技场双倍",
	GAME_ACTIVITY_TITLE25 = "幸运抽奖",
	GAME_ACTIVITY_TITLE26 = "新品打折",
	GAME_ACTIVITY_TITLE27 = "折扣限购",
	GAME_ACTIVITY_TITLE28 = "限时兑换",
	GAME_ACTIVITY_TITLE29 = "组队双倍",
	GAME_ACTIVITY_TITLE30 = "精英双倍",
	GAME_ACTIVITY_TITLE31 = "首充大奖",
	GAME_ACTIVITY_TITLE32 = "结婚狂欢Par",
	GAME_ACTIVITY_TITLE33 = "萌宠上线",
	GAME_ACTIVITY_TITLE34 = "在线奖励",
	GAME_ACTIVITY_TITLE35 = "每日充值奖励",
	GAME_ACTIVITY_TITLE36 = "狗二弹",
	ACTOR_NAME_LV = [[<T C="255,227,116" S="22" P="0">Lv%s</T><T C="255,255,255" S="22" P="0"> %s</T>]],
	ACTOR_FIGHT = [[<T C="255,227,116" S="22" P="0">战斗力：</T><T C="255,255,255" S="22" P="0">%s</T>]],
	ATH_DESC13 = "初级榜：%d-%d 级",
	ATH_DESC14 = "中级榜：%d-%d 级",
	ATH_DESC15 = "高级榜：%d-%d 级",
	ATH_DESC16 = "初级榜",
	ATH_DESC17 = "中级榜",
	ATH_DESC18 = "高级榜",
	ATH_DESC19 = [[<T C="127,70,26" S="20" P="1">我的排名：</T><T C="0,72,3" S="20" P="1">无</T>]],
	ATH_DESC20 = [[<T C="127,70,26" S="20" P="1">我的排名：</T><T C="0,72,3" S="20" P="1">%s</T>]],
	ATH_DESC21 = [[<T C="127,70,26" S="20" P="1">你属于初级榜</T>]],
	ATH_DESC22 = [[<T C="127,70,26" S="20" P="1">你属于中级榜</T>]],
	ATH_DESC23 = [[<T C="127,70,26" S="20" P="1">你属于高级榜</T>]],
	COMMYNITY_COMPETE_TEXT36 = "等级未满%d级无法设置出战",
	COMMYNITY_COMPETE_TEXT37 = "加入公会未满%d小时无法设置出战",
	COMMYNITY_COMPETE_TEXT38 = "尚未进入新的赛程",
	COMMYNITY_COMPETE_TEXT39 = "该赛程尚未开启，不可以查看哟",
	ASCENDING1 = "制作",
	ASCENDING2 = "调品",
	ASCENDING3 = "制作前",
	ASCENDING4 = "制作预览",
	ASCENDING5 = "所需材料",
	ASCENDING6 = "升阶",
	ASCENDING7 = "蓝装",
	ASCENDING8 = "制作书",
	ASCENDING9 = "圣光",
	ASCENDING10 = "铁块",
	ASCENDING11 = "布料",
	ASCENDING12 = "保留强化,升星等级",
	ASCENDING13 = "上下品",
	ASCENDING14 = "新品级",
	ASCENDING15 = "原品级",
	ASCENDING16 = "注意：调品后属性变低，是否保留调品前属性？",
	NEARBY = "附近的人",
	MALE = "男生",
	WOMAN = "女生",
	ASCENDING17 = "蓝色装备:\n强化+%d,星级+%d 可制作紫色装备",
	ASCENDING18 = "紫色装备:\n强化+%d,星级+%d 可制作橙色装备",
	COMMYNITY_COMPETE_TEXT40 = "开始准备",
	COMMUNITY_COMPETE_TEXT41 = "退出房间",
	COMMUNITY_COMPETE_TEXT42 = "后自动开始比赛",
	COMMUNITY_COMPETE_TEXT43 = "暂无",
	COMMUNITY_COMPETE_TEXT44 = "无公会",
	ASCENDING19 = "材料不足,前往开启圣光之匣获得",
	ASCENDING20 = "尚未拥有橙色装备，请前往制作",
	COMMONITY_DESC12 = "累计胜利公会战次数%d次",
	COMMONITY_DESC13 = "累计击杀公会战人数%d个",
	COMMUNITY_COMPETE_TEXT45 = 
[[
<T C="255,236,193" S="20" P="1">报名规则：</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1">周贡献排名前30的公会,可由公会会长在周二进行报名.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1">报名消耗200000金币.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1">所有公会报名完毕后,于周三按照报名公会的上周新增威望排行,取前16名公会进行分组.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1">未入围最终分组的公会,报名费用会以邮件形式返还给会长.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1">16个入围公会会进行随机分组,从周四开始进行公会战.</T><BR></BR>
<T C="229,105,22" S="20" P="0">6.</T><T C="255,236,193" S="20" P="1">参加公会战的作战队员，需要满足两个条件：角色等级≥25,加入该公会时间≥48小时.</T><BR></BR>
<T C="229,105,22" S="20" P="0">7.</T><T C="255,236,193" S="20" P="1">公会战队分为3队,队员设置需要由公会会长进行.</T><BR></BR>
]],
	COMMUNITY_COMPETE_TEXT46 = 
[[	
<T C="255,236,193" S="20" P="1">小组赛规则：</T><BR></BR>	
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1">按照已排好的分组,在周四晚上进行对战.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1">各小组按照编号,进行淘汰对战,胜者晋级,败者淘汰.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1">对战规则为各小组按照编号,1公会 VS 2公会,3公会 VS 4公会.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1">公会战房间在周四晚上20:00开启,开启后可进入进行队员设置.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1">周四晚上20:10正式开始对战,此前可随意进行队员设置.</T><BR></BR>	
]],	
	COMMUNITY_COMPETE_TEXT47 = 
[[	
<T C="255,236,193" S="20" P="1">8进4规则：</T><BR></BR>	
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1">在周五晚进行（8进4）比赛.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1">周四晚比赛的获胜者,将再次进行比赛.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1">各小组剩余的2个晋级公会,进行比赛,决出小组出线者.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1">公会战房间在周五晚上20:00开启,开启后可进入进行队员设置.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1">周五晚上20:10正式开始对战,此前可随意进行队员设置.</T><BR></BR>	
]],	
	COMMUNITY_COMPETE_TEXT48 = 
[[	
<T C="255,236,193" S="20" P="1">决赛规则：</T>	
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1">在周六晚进行（4进2）比赛以及冠军赛、季军赛.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1">剩余晋级公会,先进行（4进2）比赛,胜者再进行冠军赛,败者进行季军赛.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1">对战对手为A组出线公会对战B组出线公会,C组出线公会对战D组出线公会.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1">20:00到20:10进行（4进2）比赛的队员设置,20:10到20:25进行战斗.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1">20:30到20:40分进行冠军赛、季军赛的队员设置,20:40到20:55进行战斗.</T><BR></BR>	
]],	
	COMMUNITY_COMPETE_TEXT49 = 
[[	
<T C="255,236,193" S="20" P="1">小组赛房间说明：</T>	
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1">比赛采用单轮决胜制,各战队击杀对方全体成员后,可获得本队胜利.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1">限时内,未通过击杀决出胜负的战队,系统则按照双方剩余成员的血量百分比总和判断胜负.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1">若仍无法判断胜负,则按照双方的周新增威望排行进行判断,排名高者,获得战队的胜利.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1">最后,按照双方3个战队的综合胜负判定,胜场多者获得本轮比赛的胜利,可晋级.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1">20:00至20:10之间可随意进行队员设置,20:10至20:25之间为比赛战斗时间.</T><BR></BR>	
]],	
	COMMUNITY_COMPETE_TEXT50 = 
[[	
<T C="255,236,193" S="20" P="1">（8进4）房间说明：</T>	
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1">比赛采用单轮决胜制,各战队击杀对方全体成员后,可获得本队胜利.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1">限时内,未通过击杀决出胜负的战队,系统则按照双方剩余成员的血量百分比总和判断胜负.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1">若仍无法判断胜负,则按照双方的周新增威望排行进行判断,排名高者,获得战队的胜利.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1">最后,按照双方3个战队的综合胜负判定,胜场多者获得本轮比赛的胜利,可晋级.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1">20:00至20:10之间可随意进行队员设置,20:10至20:25之间为比赛战斗时间.</T><BR></BR>	
]],	
	COMMUNITY_COMPETE_TEXT51 = 
[[	
<T C="255,236,193" S="20" P="1">决赛房间说明：</T>	
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1">比赛采用单轮决胜制,各战队击杀对方全体成员后,可获得本队胜利.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1">限时内,未通过击杀决出胜负的战队,系统则按照双方剩余成员的血量百分比总和判断胜负.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1">若仍无法判断胜负,则按照双方的周新增威望排行进行判断,排名高者,获得战队的胜利.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1">最后,按照双方3个战队的综合胜负判定,胜场多者获得本轮比赛的胜利,可晋级.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1">20:00至20:10为（4进2）比赛队员设置时间,20:10至20:25之间为比赛战斗时间.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">6.</T><T C="255,236,193" S="20" P="1">20:30到20:40为冠军赛、季军赛的比赛队员设置时间,20:40至20:55之间为比赛战斗时间.</T><BR></BR>	
]],	
	COMMUNITY_COMPETE_TEXT52 = [[您已被设置为出战状态，离开房间将取消出战状态，是否继续？]],
	COMMUNITY_COMPETE_TEXT53 = "%s邀请您进入公会战房间一起战斗",
	ASCENDING21 = "亲！圣光药剂不足了哦，您是否要购买该道具？",
	COMMUNITY_COMPETE_TEXT54 = "公会战已开始\n等待公会战配对...",
	COMMUNITY_COMPETE_TEXT55 = "周五开始半决赛",
	COMMUNITY_COMPETE_TEXT56 = "没有对手的日子很寂寞，轻松获胜！",
	COMMUNITY_COMPETE_TEXT57 = "新赛季公会战入围资格争夺中！",
	COMMONITY_DESC14 = "轮空",
	COMMONITY_DESC15 = "16进8",
	COMMONITY_DESC16 = "8进4",
	COMMONITY_DESC17 = "4进2",
	COMMONITY_DESC18 = "季军决赛",
	COMMONITY_DESC19 = "冠军决赛",
	COMMONITY_DESC20 = "周四",
	COMMONITY_DESC21 = "周五",
	COMMONITY_DESC22 = "周六",
	COMMUNITYINFO139 = [[总排名]],
	COMMUNITYINFO140 = [[周排名]],
	COMMUNITYINFO141 = [[公会战历史最佳排名:]],
	COMMUNITYINFO142 = [[上一届公会战排名:]],
	COMMUNITYINFO143 = [[4强]],
	COMMUNITYINFO144 = [[本周威望]],
	COMMUNITYINFO145 = [[上周威望]],
	ASCENDING22 = [[消耗道具不足,不可快速购买]],
	COMMUNITY_COMPETE_TEXT58 = "今日公会战比赛已经结束，将自动退出公会战房间",
	COMMUNITY_COMPETE_TEXT59 = "争夺参赛资格",
	COMMUNITY_COMPETE_TEXT60 = "一起来战！",
	COMMUNITY_COMPETE_TEXT61 = "2级公会不足10个，开启公会战失败",
	COMMUNITY_COMPETE_TEXT62 = "入围公会不足，公会战终止",
	COMMUNITY_COMPETE_TEXT63 = "今报名公会不足，公会战终止",
	COMMONITY_DESC23 = "暂无新目标",
	ASCENDING23 = [[橙装只能与橙装继承]],
	ASCENDINGEXPLAIN = 
[[
<T C="127,70,26" S="20" P="1">圣光系统说明：</T><BR></BR>
<T C="127,70,26" S="20" P="1">　</T><BR></BR>
<T C="229,105,22" S="20" P="1">蓝色装备:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">蓝色装备满足强化等级≥35、升星等级≥10的条件,可以进行制作紫色装备.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">制作后,新获得的紫色装备的强化等级、升星等级会有一定衰减,可在制作前选择消耗少量钻石进行保留.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">蓝色装备制作成紫色装备后,不改变其套装属性.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="1">制作需要消耗装备对应部位的紫色制作书、圣光精华、低级铁块、低级布料,这些材料可通过开启圣光宝匣获得.</T><BR></BR>
<T C="127,70,26" S="20" P="1">　</T><BR></BR>
<T C="229,105,22" S="20" P="1">紫色装备:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">紫色装备满足强化等级≥40、升星等级=12的条件,可以进行制作橙色装备.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">制作后,橙色装备会继承原来紫色装备超出40级的强化等级,升星等级会重置.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">紫装备制作成橙色装备后,不改变其套装属性.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="1">制作需要消耗装备对应部位的橙色制作书、圣光结晶、高级铁块、高级布料,这些材料可通过开启圣光宝匣获得.</T><BR></BR>
<T C="127,70,26" S="20" P="1">　</T><BR></BR>
<T C="229,105,22" S="20" P="1">橙色装备:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">橙色装备拥有品级,可通过圣光系统的【调品】功能改变装备的当前品级.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">【调品】需要消耗装备对应部位的橙色制作书以及圣光药剂.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">橙色装备只可与橙色装备进行继承.</T><BR></BR>
<T C="127,70,26" S="20" P="1">　</T><BR></BR>
]],
	ASCENDING24 = [[精彩推荐]],
	COMMUNITY_COMPETE_TEXT64 = "时间未到，还不能进入房间，请耐心等待",
	MAIL_DOPAY2 = "将代对方支付%s钻石",
	INN1 = "黑市商人出现!!",
	INN2 = "黑市商人携带着大量宝物,遇见可不要放过,尽情买个够吧~!",
	INN3 = "黑市商人已出现,快来购买吧",
	INN4 = "打开商店",
	INN5 = "通关副本后有几率遇见黑市商人",
	INN6 = "组队副本",
	INN7 = "探险之地",
	INN8 = [[<T C="127,70,26" S="16" P="0">黑市商人</T><T C="158,0,0" S="16" P="0">%s</T><T C="127,70,26" S="16" P="0">后离开</T><BR></BR>
	<T C="127,70,26" S="16" P="0">(离开后有机率再次遇见商人)</T>]],
	INN9 = "请离",
	INN10 = "是否请黑市商人离开，离开后将关闭黑市商店",
	INN11 = 
[[
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">探险之地通关后有几率遇见商店</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">探险之地扫荡时有几率遇见商店</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">组队副本通关后有几率遇见商店</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="1">商人存在时不会再次遇见</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="1">商人重新出现时商店会上架一批新的物品</T><BR>10</BR>
]],
	INN12 = "黑市商人已离去",
	PASS_ELITE_SECTION_TIP = "通关该章节的精英模式后开启",
	ASCENDING_FUSE1 = "融合",
	ASCENDING_FUSE2 = [[<T C="255,89,74" S="22" P="1">（选择右侧祈福进行融合）</T>]],
	ASCENDING_FUSE3 = "未融合",
	ASCENDING_FUSE4 = "已融合",
	ASCENDING_FUSE5 = "祈福不满足融合条件",
	ASCENDING_FUSE6 = "祈福",
	ASCENDING_FUSE7 = [[<T C="255,89,74" S="22" P="1">（橙色祝福只可被融合一次）</T>]],
	ASCENDING_FUSE8 = "已经全部融合完成了噢",
	ASCENDING_FUSE9 = "还没有融合完成的祝福噢",
	ASCENDING_FUSE10 = "(未满Lv%d)",
	ASCENDING_FUSE11 = "(缺少)",
	ASCENDING_FUSE12 = "(已拥有)",
	ASCENDING_FUSE13 = [[<T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >%s</T><I Z = "0.45">%s</I><T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >%d</T><T C="158,139,121" S="20" P="1" SC="79,60,48" SE="0" SS="4" >(拥有 %d)  </T><I Z = "0.45">%s</I><T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >%d</T><T C="158,139,121" S="20" P="1" SC="79,60,48" SE="0" SS="4" >(拥有 %d)</T>]],
	ASCENDING_FUSE14 = "材料不足无法完成融合",
	ASCENDING_FUSE15 = "亲！%s不足了哦，您是否购买该道具？",
	ASCENDING_FUSE16 = "祈福融合",
	FIXED_REWARD = "必然获得",
	ASCENDING_FUSE17 = "不可融合",
	ASCENDING_FUSE18 = "可融合",
	PASS_LEVEL = "已通关",
	PASS_LEVEL_STAT = "%d星",
	TEN_DRAW = "%d连抽",
	BLESS_HOUSE_FULL2 = "祈福格已满，请拾取后再召唤",
	GAME_ACTIVITY_TITLE37 = "红线情缘",
	DRAW_AGAIN_TEN = "再抽%d次",
	WELFARE_COMPETE1 = "娱乐赛",
	ACTIVITY_HAVED_ATT = "你已经拥有永久的 %s 了，确定要再次购买么？",
	MELEE_DESC1 = "系统会匹配4个实力相近的敌人进行混战，需要击杀4个玩家才可获得胜利，强退会扣除竞技积分噢",
	MELEE_DESC2 = "今日参与:",
	MELEE_DESC3 = "今日胜利:",
	MELEE_DESC4 = "今日杀敌:",
	MELEE_DESC5 = [[<T C="255,227,116" S="22" P="1">%d(%d/%d)</T>]],
	MELEE_DESC6 = [[<T C="255,227,116" S="22" P="1">%d(</T><T C="99,255,95" S="22" P="1">%d/%d</T><T C="255,227,116" S="22" P="1">)</T>]],
	MELEE_DESC7 = [[<T C="255,227,116" S="22" P="1">%d(已完成)</T>]],
	MELEE_DESC8 = "规则说明：",
	MELEE_DESC9 = "今日奖励",
	MELEE_DESC10 = "击杀%d次",
	MELEE_DESC11 = "大乱斗今日战绩 : %d战 %d胜 %d杀",
	MELEE_DESC12 = [[<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">周日00:00-24:00开启</T>]],
	WELFARE_COMPETE2 = "周日",
	WELFARE_COMPETE3 = "周一",
	WELFARE_COMPETE4 = "周二",
	WELFARE_COMPETE5 = "周三",
	WELFARE_COMPETE6 = "周四",
	WELFARE_COMPETE7 = "周五",
	WELFARE_COMPETE8 = "周六",
	GOTO_CALL = "前往召唤",
	TEN_TAKE_OUT = "十连抽",
	FYBER_TIP1 = "播放视频，可获得以下奖励",
	FYBER_TIP2 = "当天还可以获得%d次奖励",
	FYBER_TIP3 = "视频加载失败，请重试",
	ASCENDING25 = "紫色宠物进阶+%d且等级超过%d时可\n进化为橙宠",
	ASCENDING26 = "幼年期",
	ASCENDING27 = "成长期",
	ASCENDING28 = "成熟期",
	ASCENDING29 = "完全体",
	ASCENDING30 = "选择宠物",
	PET_STORE_COST_NO_ENOUGH = "宠物精华不足,请回收宠物获得",
	PET_STORE_REFRESH_TIMES_LIMIT = "刷新次数不足,请前往提升VIP等级",
	WASHPETGIFT = "洗练资质",
	GAME_ACTIVITY_TITLE38 = "连续充值",
	CONTINUE_RECHARGE_WORD = "今日充值进度",
	CONTINUE_RECHARGE_WORD2 = "完成%d天充值任务(%d/%d)",
	PETMAXGIFT = "宠物已达最高资质",
	ASCENDING31 = "培养宠物",
	BAG3 = "删除密友",
	ASCENDING32 = "暂未开放", 
	ASCENDING33 = "敬请期待",
	ASCENDING34 = "请选择要进化的宠物", 
	ASCENDING35 = "宠物不足",
	PETNOOPEN = "该宠物橙宠未开放，敬请期待",
	PURPLEPET = "紫宠",
	ORANGEPET = "橙宠",
	PETNORECOVER = "暂无可回收宠物",
	PETNOENOUGHITEM = "宠物精华不足,回收宠物可获得",
	LOVE_VALUE = "恩爱值：",
	ZUDUI_ROOM_KF1 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,227,116" S="22" P="0" SC="60,19,12" SE="1" SS="3">%s</T>]],
	ZUDUI_ROOM_NOKF = [[<T C="99,255,95" S="22" P="0" SC="60,19,12" SE="1" SS="3" >%s</T>]],
	ZUDUI_ROOM_NOKF1 = [[<T C="255,227,116" S="22" P="0" SC="60,19,12" SE="1" SS="3" >%s</T>]],
	ASCENDINGEXPLAIN2 = 
[[	
<T C="229,105,22" S="20" P="1">橙色祈福:</T><BR></BR>	
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">橙色祈福需要2个指定紫色属性的10级祈福进行融合，获得2种双属性橙色祈福</T><BR></BR>	
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">融合后祈福等级重置为1，可升等级上限为20</T><BR></BR>	
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">融合需要消耗祈福币</T><BR></BR>	
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="1">不可佩戴重复属性的祈福</T>	
]],	
	ASCENDINGEXPLAIN3 = 
[[	
<T C="127,70,26" S="20" P="1">圣光系统说明：</T><BR></BR>	
<T C="127,70,26" S="20" P="1">　</T><BR></BR>	
<T C="229,105,22" S="20" P="1">橙色宠物:</T><BR></BR>	
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">紫色宠物进阶+4,而且等级≥45时,可以进化成橙宠.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">进化橙宠后,紫宠的资质、进阶等级会继承过去.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">进化橙宠后,宠物等级会有一定衰减.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="1">进化橙宠后,宠物的进阶不再受等级限制（可提前进阶+6）.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="1">进化橙宠需要消耗圣光结晶、4个同样的宠物（未进阶过、未升级过）、宠物进阶丹等材料.</T><BR></BR>	
]],	
	ASCENDING36 = "消耗道具限购剩余数量不足，无法快速购买",
	ASCENDING37 = "升品",
	ASCENDING38 = "紫色",
	ASCENDING39 = "蓝色",
	ASCENDING40 = "绿色",
	ASCENDING41 = "升品前",
	ASCENDING42 = "升品后",
	MAX_MOUTH_CARD = "当前月卡有效%d天以上,无需续费",
	ATTACH_EGG_SCORE = "奖励分:",
	TARGET_HURT_HP = "伤害目标血量:",
	EGG_SCORE = "奖励分：",
	EXCHANGEEXP_TEXT1 = "经验转化",
	EXCHANGEEXP_TEXT2 = "快速转化",
	EXCHANGEEXP_TEXT3 = "转化",
	EXCHANGEEXP_TEXT4 = "当前溢出经验：%d",
	EXCHANGEEXP_TEXT5 = "今日第%d次转化",
	EXCHANGEEXP_TEXT6 = "%s不足，无法转化%s",
	EXCHANGEEXP_TEXT7 = "消耗%d%s，获得%d%s, 确定继续？",
	EXCHANGEEXP_TEXT8 = "经验转化",
	EXCHANGEEXP_TEXT9 = 
[[	
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> 当人物获得经验达到上限时,溢出经验会保存.</T><BR></BR>	
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> 保存的溢出经验,无法再用于升级人物.</T><BR></BR>	
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> 可以用溢出经验转化为修炼值,随兑换次数的递增,转化的消耗递增.</T><BR></BR>	
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> 每日0点重置兑换次数.</T><BR></BR>	
]],	
	ASCENDING43 = "升品石",
	ASCENDING44 = "进阶丹",
	ASCENDING45 = "坐骑",
	ASCENDING46 = "培养坐骑",
	ASCENDING47 = "请选择要升品的坐骑", 
	ASCENDINGEXPLAIN5 = 
[[	
<T C="127,70,26" S="20" P="1">圣光系统说明：</T><BR></BR>	
<T C="127,70,26" S="20" P="1">　</T><BR></BR>	
<T C="229,105,22" S="20" P="1">坐骑:</T><BR></BR>	
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">坐骑可通过升品改变品质.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">升品到橙色后,坐骑强化等级上限+5.</T><BR></BR>	
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">坐骑升品需要消耗坐骑升品丹、圣光材料、坐骑进阶丹.</T><BR></BR>	
]],	
	ASCENDING48 = "绿色坐骑进阶+%d且等级超过%d时可\n升品为蓝色坐骑",
	ASCENDING49 = "蓝色坐骑进阶+%d且等级超过%d时可\n升品为紫色坐骑",
	ASCENDING50 = "紫色坐骑进阶+%d且等级超过%d时可\n升品为橙色坐骑",
	STRENGTHEN6 = "橙装继承只保留品级,随机分配属性,是否继续?",
	PETEXPFULL = "经验已溢出,请手动选择被吞噬宠物",
	
	COPYENTRY_NAME = "克雷·米莉亚",	
	COPYENTRY_DIALOG = "前方,是无尽的征程,祝你好运，勇士~",	
	FAST_CHAT_1 = "大家打开语音聊天！",
	FAST_CHAT_2 = "集火打残血！",
	FAST_CHAT_3 = "一起打最后出手的敌人！",
	FAST_CHAT_4 = "准备配合坑杀！",
	FAST_CHAT_5 = "先开盾保护自己！",
	FAST_CHAT_6 = "注意风向！",
	FAST_CHAT_7 = "位置不好,注意分开！",	
	FAST_CHAT_8 = "帮我加血！",	
	SUMMON_1 = "幸运召唤",	
	SUMMON_2 = "欢乐砸蛋",	
	SUMMON_3 = "神秘祈福",	
		
	PVP_HALL_1 = "训练营",	
	PVP_HALL_2 = "观战",	
	PVP_HALL_3 = "竞技商店",	
	PVP_HALL_4 = "对战赛",	
	PVP_HALL_5 = "娱乐赛",	
	PVP_HALL_6 = "战力竞技 强者为尊",	
	PVP_HALL_7 = "花样玩法 丰富奖励",	
	PVP_HALL_8 = "实力为尊 无上荣耀",	
	PVP_HALL_9 = "竞技场",	
	PVP_HALL_10 = "房间匹配",	
	PVP_HALL_11 = "开黑组队",	
	PVP_HALL_12 = "单人匹配",	
	PVP_HALL_13 = "随机模式",	
	PVP_HALL_14 = "挖坑模式",	
	PVP_HALL_15 = "队长模式",	
	PVP_HALL_16 = "道具模式",	
	PVP_HALL_17 = "乱斗模式",	
	PVP_HALL_18 = "复活模式",	
	PVP_HALL_19 = "无伤害,靠挖坑",	
	PVP_HALL_20 = "队长必须死",	
	PVP_HALL_21 = "抢到就是赚到",	
	PVP_HALL_22 = "活下来的只能是我",	
	PVP_HALL_23 = "还能再战一次",	
	PVP_HALL_24 = "活动开启",	
	PVP_HALL_25 = [[<T C="255,236,193" S="20" P="0" >周一开启</T>]],	
	PVP_HALL_26 = [[<T C="255,236,193" S="20" P="0" >周二开启</T>]],	
	PVP_HALL_27 = [[<T C="255,236,193" S="20" P="0" >周三开启</T>]],	
	PVP_HALL_28 = [[<T C="255,236,193" S="20" P="0" >周四开启</T>]],	
	PVP_HALL_29 = [[<T C="255,236,193" S="20" P="0" >周五开启</T>]],	
	PVP_HALL_30 = "娱乐赛",	
	PVP_HALL_31 = [[<T C="255,236,193" S="20" P="0" SC="127,70,26" SE="1" SS="4">勇者积分：%d/%d</T>]],	
	PVP_HALL_32 = [[<T C="255,236,193" S="18" P="0" SC="127,70,26" SE="1" SS="4">勇者积分(满%d积分=%d颗星)</T>]],	
	PVP_HALL_33 = [[<I Z="1">ui/pvp/event_icon_s1sj_s.png</I><A IMG = "ui/common_num/common_num_jccsz.png" Z ="1" W = "26" H = "44" CHAR = "0">%d</A><I Z="1">ui/pvp/event_icon_s1sj_sj.png</I>]],	
	PVP_HALL_34 = "该模式未到开放时间",	
	PVP_HALL_35 = [[<T C="255,236,193" S="20" P="0" >%d级开启</T>]],	
	PVP_HALL_36 = "自由对战",	
	PVP_HALL_37 = "玩法丰富 娱乐无限",	
	PVP_HALL_38 = "实力排位",	
		
		
	BAGTIP5 = [[<T C="255,89,74" S="20" P="0">%d件套属性加成(</T><T C="255,236,193" S="20" P="0">%d</T><T C="255,89,74" S="20" P="0">/%d)</T>]],	
	BAGTIP6 = [[<T C="255,89,74" S="20" P="0">%d件套属性加成(%d/%d)</T>]],	
	BAGTIP7 = [[使用后可获得以下所有奖励]],	
	BAGTIP8 = [[使用后可随机获得以下一种奖励]],	
	BAGTIP9 = [[玩家信息]],	
	BAGTIP10 = [[玩家 ID:]],	
	BAGTIP11 = [[玩家ID]],	
	BAGTIP12 = [[成功率:]],	
	BAGTIP13 = [[快速合成]],	
	BAGTIP14 = [[(VIP3即可使用快速合成)]],	
	BAGTIP15 = [[合成消耗:]],	
	BAGTIP16 = [[选择配色方案]],	
	BAGTIP17 = [[染色消耗]],	
	BAGTIP18 = [[原色]],	
	BAGTIP19 = [[表情与翅膀不支持染色,过期的时装将还原配色]],	
	BAGTIP20 = [[开始染色]],	
	BAGTIP21 = [[配色预览]],	
	BAGTIP22 = [[当前装扮有未购买时装,是否前往购买?]],	
	BAGTIP23 = [[时装染色]],	
	BAGTIP24 = [[没有时装无法染色]],	
	BAGTIP25 = [[配色]],	
	BAGTIP26 = [[玩家时装信息]],	
	BAGTIP27 = [[当前展示时装]],	
	BAGTIP28 = [[时装最高战力:]],	
	BAGTIP29 = [[当前已收集时装]],	
	BAGTIP30 = [[时装总战力加成:]],	
	BAGTIP31 = [[发型拥有数量:]],	
	BAGTIP32 = [[表情拥有数量:]],	
	BAGTIP33 = [[服装拥有数量:]],	
	BAGTIP34 = [[翅膀拥有数量:]],	
	BAGTIP35 = [[接受私聊]],	
	BAGTIP36 = [[屏蔽成功(本次登录有效)]],	
	BAGTIP37 = [[取消屏蔽]],	
	BAGTIP39 = [[当前部位没有时装,是否前往购买?]],	
	BAGTIP38 = [[选择染色时装]],	
	BAGTIP40 = [[染色成功]],	
	BAGTIP41 = [[后]],	
	BAGTIP42 = [[当前颜色:]],	
	BAGTIP43 = [[展示]],	
	BAGTIP44 = [[当前时装无法染色]],	
	BAGTIP45 = [[不可染色]],	
	BAGTIP46 = [[请先勾选快速合成]],	
	BAGTIP47 = [[回收数量]],	
	BAGTIP48 = [[放入]],	
	BAGTIP49 = "请选择数量",	
		
	CHALLENGEENTRANCE_TITLE = "挑战",	
	CHALLENGEENTRANCE_TEXT1 = "试练塔",	
	CHALLENGEENTRANCE_TEXT2 = "世界BOSS",	
		
	COMMUNITYINFO146 = [[弹劾]],	
	COMMUNITYINFO147 = [[弹劾冷却中,请等候!]],	
	COMMUNITYINFO148 = [[<T C="79,60,48" S="22" P="0">会长</T><T C="1,72,4" S="22" P="0">%s</T><T C="79,60,48" S="22" P="0">已经离线</T><T C="1,72,4" S="22" P="0">%s</T><T C="79,60,48" S="22" P="0">天,是否对其发起弹劾?</T>]],	
	COMMUNITYINFO149 = [[弹劾人数:]],	
	COMMUNITYINFO150 = [[今日贡献≥2000可以弹劾]],	
	COMMUNITYINFO151 = [[已弹劾]],	
	VIP_TIP09 = [[礼包]],	
    VIP_TIP10 = [[每周福利]],		
    VIP_TIP11 = [[(一次性通过邮件发放)]],		
    VIP_TIP12 = [[(每周一通过邮件发放)]],		
	EQUIP_THE_SAME_ATT = "装备的祈福珠与身上的祈福珠有冲突",	
	FYBER_REWARD = "广告奖励";	
	PETSKILL_DES = 	
[[		
<T C="127,70,26" S="20" P="0">领悟规则</T><BR></BR>		
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> 宠物进阶到+1、+3、+5、+6时分别开启1个宠物技能槽.</T><BR></BR>		
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> 通过领悟可以随机改变宠物的技能.</T><BR></BR>		
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> 领悟每次消耗1个领悟之卷.</T><BR></BR>		
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> 若有想保留的技能,可点击技能图标进行锁定操作.</T><BR></BR>		
<T C="229,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0"> 锁定宠物技能时,每次领悟会额外消耗封技石,数量等于锁定的技能数量.</T><BR></BR>		
]],		
	BUYACTIVITY_RETURN = [[<T C="255,255,255" S="22" P="1" SC="105,65,46" SS="4" SE="1">消耗</T><I Z="0.45" P="1">%s</I><T C="255,255,255" S="22" P="1" SC="105,65,46" SS="4" SE="1">%d/%d   返还 %d</T><I Z="0.45" P="1">%s</I>]],
	TEACH_170 = "点击前往单人冒险",	
	TEACH_171 = "点击前往自由对战",	
	TEACH_172 = "点击打开幸运召唤",	
	TEACH_173 = "点击前往组队副本",	
	TEACH_174 = "点击前往秘境冒险",	
	TEACH_175 = "点击进入试练塔",	
	TEACH_176 = "点击挑战世界BOSS",	
	TEACH_177 = "点击打开召唤入口",	
	TEACH_178 = "选择身体页签",	
		
	WORLDBOSS_TITLE = "世界BOSS",	
		
	FRIENDS_TEXT1 = "搜索",	
	FRIENDS_TEXT2 = "本服",	
	FRIENDS_TEXT3 = "好友申请",	
	FRIENDS_TEXT4 = "密友申请",	
	FRIENDS_TEXT5 = "送活力",	
	FRIENDS_TEXT6 = "密友数量",	
	FRIENDS_TEXT6 = "密友数量",	
	FRIENDS_TEXT7 = "一键同意",	
	FRIENDS_TEXT8 = "一键拒绝",	
	FRIENDS_TEXT9 = "好友上线提醒只能设置本服好友",	
	FRIENDS_TEXT10 = "已设置上线提醒数量",	
	FRIENDS_TEXT11 = "作为徒弟",	
	FRIENDS_TEXT12 = "作为师傅",	
		
	FRIENDS_TEXT13 = [[	
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">1.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> 10-24级且没有师徒关系可进行拜师</T><BR></BR>		
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">2.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> 被拜师的玩家等级需≥25级且收徒弟名额未满</T><BR></BR>		
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">3.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> 徒弟25级自动出师，出师后师徒双方将获得出师大礼</T><BR></BR>		
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">4.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> 徒弟可获得师门BUFF，师傅师德等级越高BUFF效果越好</T><BR></BR>		
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">5.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> 作为徒弟后将拥有师徒任务及目标，完成后可获得大量经验</T><BR></BR>		
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">6.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> 作为徒弟后，师傅对其授业可获得大量经验</T><BR></BR>		
]],		
	FRIENDS_TEXT14 = [[	
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">1.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> 等级25级以上，且徒弟名额未满玩家可进行收徒</T><BR></BR>		
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">2.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> 拜师玩家等级需大于9，小于25级且没有师徒关系</T><BR></BR>		
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">3.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> 师傅可根据师德等级获得属性加成，等级越高属性越高</T><BR></BR>		
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">4.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> 徒弟消耗活力值时师傅可获得一定活力值</T><BR></BR>		
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">5.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> 徒弟升级或孝敬师傅，师傅可获得师德值</T><BR></BR>		
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">5.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> 作为师傅后，对徒弟授业可获得大量师德值</T><BR></BR>		
]],		
	FRIENDS_TEXT15 = "已出师",	
	FRIENDS_TEXT16 = "授业",	
	FRIENDS_TEXT17 = "师德福利预览",	
	FRIENDS_TEXT18 = "申请列表",	
	FRIENDS_TEXT19 = "我要收徒",	
	FRIENDS_TEXT20 = "同门",	
	--FRIENDS_TEXT21 = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1">师德%d级 出师人数：%d</T>]],	
	FRIENDS_TEXT22 = "出师列表",	
	FRIENDS_TEXT21 = [[<I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1">师德%d级 出师人数：%d</T>]],	
		
		
	MULTI_WIN_GOAL1 = "简单模式",	
	MULTI_WIN_GOAL2 = "困难模式",	
	MULTI_WIN_GOAL3 = "噩梦模式",	
	UNCOMPLETE =  "未完成",	
	Daily_GOAL1_1 = "伤害达成：%d/%d",	
	Daily_GOAL1_2 = "出手次数：%d/%d",	
	Daily_GOAL1_3 = "击杀数量：%d/%d",	
	Daily_GOAL1_4 = "最终金币奖励：",	
		
	Daily_GOAL2_1 = "击杀数量：%d/%d",	
	Daily_GOAL2_2 = "剩余血量：%d/%d",	
	Daily_GOAL2_3 = "逃离数量：%d/%d",	
	Daily_GOAL2_4 = "最终经验奖励：",	
		
	Daily_GOAL3_1 = "剩余血量：%d/%d",	
	Daily_GOAL3_2 = "击蛋分数：%d/%d",	
	Daily_GOAL3_3 = "击杀数量：%d/%d",	
	Daily_GOAL3_4 = "最终宠物蛋奖励：",	
		
	BATTLE_HURT_TARGET = "伤害目标：",	
	BATTLE_KILL_COPPER_MONSTER = "击杀数量：",	
	BATTLE_KILL_NUM = "击杀数量：",	
	BATTLE_REMAIN_HP_PRE = "剩余血量：",	
	BATTLE_RUN_NUM = "逃离数量：",	
	BATTLE_PET_EGG_NUM = "击蛋分数：",	
	BATTLE_KILL_MONSTER = "击杀数量：",	
	
	COMMUNITYINFO152 = [[申请加入]],	
	COMMUNITYINFO153 = [[大 厅]],	
	COMMUNITYINFO154 = [[升 级]],	
	COMMUNITYINFO155 = [[管 理]],	
	COMMUNITYINFO156 = [[设 置]],	
	COMMUNITYINFO157 = [[今日活力贡献:]],	
	COMMUNITYINFO158 = [[公会广场]],	
	COMMUNITYINFO159 = [[公会副本]],	
	COMMUNITYINFO160 = [[公会战预告]],	
	COMMUNITYINFO161 = [[公会战进行中]],	
	COMMUNITYINFO162 = [[玩家/等级/职位]],	
	COMMUNITYINFO163 = [[公会大厅升级后更壮大，可容纳更多人，带来更多公会福利]],	
	COMMUNITYINFO164 = [[公会图腾升级后瞻仰者可增加更为强大的战斗力]],	
	COMMUNITYINFO165 = [[公会学堂升级后可用贡献提升更高的公会技能等级]],	
	COMMUNITYINFO166 = [[公会商店升级后商店折扣将更高更优惠]],	
	COMMUNITYINFO167 = [[公会大厅]],	
	COMMUNITYINFO168 = [[公会学堂]],	
	COMMUNITYINFO169 = [[%d级公会大厅解锁]],	
	COMMUNITYINFO170 = [[已满级]],	
	COMMUNITYINFO171 = [[公会人数:]],	
	COMMUNITYINFO172 = [[弹劾会长]],	
	COMMUNITYINFO173 = [[移除成员]],	
	COMMUNITYINFO174 = [[查看贡献]],	
	COMMUNITYINFO175 = [[职位任命1]],	
	COMMUNITYINFO176 = [[申请列表1]],	
	COMMUNITYINFO177 = [[发群邮件]],	
	COMMUNITYINFO178 = [[基本设置]],	
	COMMUNITYINFO179 = [[公会名字:]],	
	COMMUNITYINFO180 = [[申请条件:]],	
	COMMUNITYINFO181 = [[段位以上,]],	
	COMMUNITYINFO182 = [[审批]],	
	COMMUNITYINFO183 = [[公会公告(公会公告仅公会内部可见)]],	
	COMMUNITYINFO184 = [[公会宣言(公会宣言公会内外都可见)]],	
	COMMUNITYINFO185 = [[高级钻石捐献]],	
	COMMUNITYINFO186 = [[钻石捐献]],	
	COMMUNITYINFO187 = [[金币捐献]],	
	COMMUNITYINFO188 = [[公会增加%d威望]],	
	COMMUNITYINFO189 = [[个人增加%d贡献]],	
	COMMUNITYINFO190 = [[任 务]],	
	COMMUNITYINFO191 = [[基 金]],	
	COMMUNITYINFO192 = [[本周基金]],	
		
	WNDCHECKOTHER50 = "更换武器",	
	FRIENT_CHAT = "最近联系人",	
	ASSISTANT2 = "小助手",	
		
	WORLD_LEVEL_WEEK = "积分周榜",	
	WORLD_LEVEL = "积分榜",	
	HISTORY_WEEK_RANKG = "历史周榜",	
	RANGK_REWARD = "榜单奖励",	
                           		
	COMMUNITY_UPDATE_TIP = [[%d级公会技能学堂，技能最高可以升到%d级]],	
	SECRETSCENE = "秘境宝藏",	
		
	COMMUNITYINFO193 = [[公会列表]],	
	COMMUNITYINFO194 = [[推荐公会]],	
	COMMUNITYINFO195 = [[等级/公会/ID]],	
	COMMUNITYINFO196 = [[人数]],	
	COMMUNITYINFO197 = [[限制]],	
	COMMUNITYINFO198 = [[公会宣言]],	
		
		
	BAG4 = "时 装",	
	BAG5 = "祈 福",	
	BAG6 = "称 号",	
	BAG7 = "宠物",	
	BAG8 = "坐骑",	
	BAG9 = "更换",	
	BAG10 = "培养",	
	BAG11 = "查看技能",	
	BAG12 = "角色属性",	
	BAG13 = "时装属性",	
	BAG14 = "最高战力时装",	
	BAG15 = "收集时装属性",	
	BAG16 = "时装战力:",	
	BAG17 = "过期",	
	BAG18 = "染色",	
	BAG19 = "礼包",	
		
	COMMUNITYINFO199 = [[申请人数:]],	
	COMMUNITYINFO200 = [[公会人数:]],	
	COMMUNITYINFO201 = [[玩家/等级/战斗力]],	
	COMMUNITYINFO202 = [[竞技等级]],	
	COMMUNITYINFO203 = [[段位]],	
	COMMUNITYINFO204 = [[申请留言]],	
		
		
		
		
	TASK_TEXT1 = "成 长",	
	TASK_TEXT2 = "变 强",	
	TASK_TEXT3 = "资 源",	
	TASK_TEXT4 = "%d级激活任务",	
	TASK_TEXT5 = "成就等级%d级",	
	TASK_TEXT6 = "成就等级属性加成：",	
	TASK_TEXT7 = "全服排名",	
	TASK_TEXT8 = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">今日活跃:</T><T C="99,255,95" S="22" P="1" SC="0,72,3" SS="4" SE="1">%d</T>]],	
	TASK_TEXT9 = "Lv%d 等级奖励",	
	TASK_TEXT10 = "Lv%d 等级任务",	
	TASK_TEXT11 = "Lv%d 解锁功能",	
	TASK_TEXT12 = "每 日",	
	TASK_TEXT13 = "主 线",	
	TASK_TEXT14 = "成 就",	
	TASK_TEXT15 = "该等级没有功能开放",	
	TASK_TEXT16 = "该等级没有等级奖励",	
	TASK_TEXT17 = "该等级没有等级任务",	
		
	STRENGTEN1 = "强 化",	
	STRENGTEN2 = "升 星",	
	STRENGTEN3 = "镶 嵌",	
	STRENGTEN4 = "调 品",	
	STRENGTEN5 = "装备锻造",	
		
	STRENGTEN6 = "强化5次",	
		
	RULE = "规则",	
	COMMUNITY_STORE = "公会商店",	
	PET_STORE = "宠物商店",	
	REFRESH_COUNT = "刷新次数",	
		
	AUTO_REFRESH_COUNT_DOWN = "自动刷新倒计时",	
		
	EVERYDAY_REFRESH_TIME = "（每日%s点自动刷新）",	
		
	EVERYDAY_REFRESH_TIME2 = "（每日%s点、%s点、%s点、%s点自动刷新）",	
		
		
	NEW_SHOP_1 = "随机",	
	NEW_SHOP_2 = "还原",	
	NEW_SHOP_3 = [[<T C="255,236,193" S="26" P="0" SC="79,60,48" SE="1" SS="4">试穿时装：%d件</T>]],	
	NEW_SHOP_4 = "推 荐",	
	NEW_SHOP_5 = "道 具",	
	NEW_SHOP_6 = "限 购",	
	NEW_SHOP_7 = "赠 送",	
	NEW_SHOP_8 = "热卖商品",	
	NEW_SHOP_9 = "新手",	
	NEW_SHOP_10 = [[<I Z="0.5" P="2">%s</I><T C="99,255,96" S="18" P="1" SC="0,72,3" SE="1" SS="4">%d</T>]],	
	NEW_SHOP_11 = "试",	
		
	COST_ITEM_NOTENOUGH = "%s道具不足,刷新失败!",	
	ASSISTANT = "辅助",	
	TACTICS = "战术",	
	WEAPON_LIST = "武器列表",	
	OBTAIN = "获取",	
		
	FINISH_ACHIEVEMENT_TIPS = "完成成就可以获得更多成就技能点数",	
	PETRECOVERNUM = "已选择回收:",	
	PET_REFRESH_COST = [[<T S="24" C="127,70,26" P="1">是否消耗%d宠物精华刷新商店?</T><BR></BR><BL>48</BL><T S="24" C="127,70,26" P="1">(今日已刷新%d次)</T>]],	
	GAME_ACTIVITY_TITLE39 = "黑市商店",	
		
	CALL_TEXT1 = "装 备",	
	CALL_TEXT2 = "宠 物",	
	CALL_TEXT3 = "开始祈福",	
	CALL_TEXT4 = "体验到挥金如土的感觉了吧",	
	CALL_TEXT5 = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">再召唤</T><T C="99,255,95" S="22" P="1" SC="127,70,26" SS="4" SE="1">%d</T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">次必出</T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">紫装</T>]],	
	CALL_TEXT6 = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">本次召唤必得</T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">紫装</T>]],	
	CALL_TEXT7 = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">有几率获得</T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">紫装</T>]],	
	CALL_TEXT8 = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">10连开启必出</T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">紫装</T>]],	
	CALL_TEXT9 = [[<I Z="0.6" P="1">%s</I><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">%s</T>]],	
	CALL_TEXT10 = [[<T C="255,89,74" S="22" P="1" SC="127,70,26" SS="4" SE="1">%s</T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">后免费</T>]],	
	CALL_TEXT11 = "再抽一次",	
	CALL_TEXT12 = "再抽十次",	
		
	NEW_MOUNT1 = "坐骑总战力：%d",	
	BAG19 = "礼包",	
	NEW_MOUNT2 = "属性",	
	NEW_MOUNT3 = "坐骑培养",	
	NEW_MOUNT4 = [[<T C="79,60,48" S="20" P="1">%d</T><I Z="0.65" P="2">ui/common/common_icon_xingxing2.png</I>]],	
	NEW_MOUNT5 = [[<T C="0,72,3" S="20" P="1">%d</T><I Z="0.65" P="2">ui/common/common_icon_xingxing2.png</I>]],	
	PUT_SELL_MATERIAL = "请放置想要回收的物品",	
	WNDEXPIRED1 = "过期时装",	
	WNDEXPIRED2 = "快过期",	
	WNDEXPIRED3 = "全部续费",	
	WNDCHECKOTHER1 = "资 料",	
	WNDCHECKOTHER2 = "明 细",	
	WNDCHECKOTHER3 = "战 绩",	
	WNDCHECKOTHER4 = "关 系",	
	WNDCHECKOTHER5 = "师 徒",	
	WNDCHECKOTHER6 = "空 间",	
	WNDCHECKOTHER7 = "公  会:",	
	WNDCHECKOTHER8 = "伴  侣:",	
	WNDCHECKOTHER9 = "性  别:",	
	WNDCHECKOTHER10 = "年  龄:",	
	WNDCHECKOTHER11 = "星  座:",	
	WNDCHECKOTHER12 = "地  区:",	
	WNDCHECKOTHER13 = "语  音:",	
	WNDCHECKOTHER14 = "编辑",	
	WNDCHECKOTHER15 = "改名",	
	WNDCHECKOTHER16 = [[<T C="255,227,116" S="22" P="1">角色总战力  </T><A IMG = "ui/common_num/common_num_zhandouli.png" Z ="0.9" W = "16" H = "26" CHAR = "0" >%d</A>]],	
	WNDCHECKOTHER17 = "夫妻",	
	WNDCHECKOTHER18 = "基友",	
		
	FIGHT_COPY = "副本",	
	FIGHT_COPY_1 = "单人冒险", 	
	FIGHT_COPY_2 = "组队冒险",	
	FIGHT_COPY_3 = "秘境宝藏",	
	E_DRAW = "噩梦",	
		
	MONSTER = "怪物",	
		
	PASS_LEVEL_TAGET = "通关目标",	
	PREPARE_FOR_WAR = "备战选项",	
	WNDCHECKOTHER19 = "场  次:",	
	WNDCHECKOTHER20 = "首  杀:",	
	WNDCHECKOTHER21 = "双  杀:",	
	WNDCHECKOTHER22 = "三  杀:",	
	WNDCHECKOTHER23 = "胜  率:",	
	WNDCHECKOTHER24 = "击杀率:",	
	WNDCHECKOTHER25 = "坑杀率:",	
	WNDCHECKOTHER26 = "命中率:",	
	WNDCHECKOTHER27 = "死亡率:",	
	WNDCHECKOTHER28 = "全部比赛",	
		
	DROP_OUT = "掉落",	
		
	RESERT_TIP = "挑战次数为0才可重置",	
		
	FANPAI = "翻牌",	
	WNDCHECKOTHER29 = "我的徒弟",	
	WNDCHECKOTHER30 = "师德等级:",	
	WNDCHECKOTHER31 = "师德经验:",	
	WNDCHECKOTHER32 = "师德称号:",	
	WNDCHECKOTHER33 = "等级属性:",	
	WNDCHECKOTHER34 = "幼年期",	
	WNDCHECKOTHER35 = "成长期",	
	WNDCHECKOTHER36 = "成熟期",	
	WNDCHECKOTHER37 = "完全体",	
	WNDCHECKOTHER38 = "暂无夫妻关系",	
	WNDCHECKOTHER39 = "暂无基友关系",	
	WNDCHECKOTHER40 = "%d级恩爱",	
	WNDCHECKOTHER41 = "好友度",	
	WNDCHECKOTHER42 = "我的师傅:",	
	WNDCHECKOTHER43 = "师傅加成属性:",	
	WNDCHECKOTHER44 = "25级之后可收徒",	
	WNDCHECKOTHER45 = "保存成功",	
	WNDCHECKOTHER46 = "暂无",	
	WNDCHECKOTHER47 = "已出师徒弟",	
	WNDCHECKOTHER48 = "更换宠物",	
	WNDCHECKOTHER49 = "更换坐骑",	
	FRIENDS_BESTFRIEND = "添加密友",	
	FRIENDS_BESTFRIEND2 = "需好友度达到",	
	FRIENDS_BESTFRIEND3 = "已选择密友",	
	FRIENDS_BESTFRIEND4 = "密友添加成功",	
	FRIENDS_BESTFRIEND5 = [[<T C="127,70,26" S="20" P="1">发送了密友申请。(你的密友名额还有%d个)</T>]],	
	FRIENDS_BESTFRIEND6 = [[<T C="127,70,26" S="20" P="1">解除了密友关系</T>]],	
	FRIENDS_BESTFRIEND7 = "密友最多有%d名",	
	FRIENDS_BESTFRIEND8 = "申请密友",	
	FRIENDS_BESTFRIEND9 = 	
[[		
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> 最多可添加3名密友，成为密友后将获得展示效果</T><BR></BR>		
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> 密友赠送体力可获得双倍好友度和体力</T><BR></BR>		
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> 密友组队战斗可获得双倍好友度</T><BR></BR>		
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> 成为密友需要双方达到500好友度</T><BR></BR>		
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> 夫妻关系不可成为密友</T><BR></BR>		
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="22" P="0"> 好友度达到一定值后可激活特殊称谓</T><BR></BR>		
<T C="229,105,22" S="22" P="0">7.</T><T C="127,70,26" S="22" P="0"> 30级才可被添加为密友</T><BR></BR>		
]],		
	FRIENDS_BESTFRIEND10 = "密友数量已满",	
	FRIENDS_BESTFRIEND11 = "密友申请成功",	
	FRIENDS_BESTFRIEND12 = "还不是好友哦",	
	FRIENDS_BESTFRIEND13 = "好友度不满足条件",	
	FRIENDS_BESTFRIEND14 = "夫妻关系不能再成为密友了",	
	FRIENDS_BESTFRIEND15 = "添加密友成功",	
	FRIENDS_BESTFRIEND16 = "已拒绝成为密友",	
	FRIENDS_BESTFRIEND17 = "确定解除与%s的密友关系？",	
	FRIENDS_BESTFRIEND18 = "解除密友关系成功",	
		
		
		
		
		
		
		
	BUYACTIVITY_RULE = 	
[[		
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> 在功能中消耗钻石,进度条满时可获得对应钻石返利.</T><BR></BR>		
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> 返利每日不限制返利次数,多买多返.</T><BR></BR>		
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> 每日0时重置消耗进度.</T><BR></BR>		
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> 购买体力、招财猫都有返利优惠,但两个功能的消耗不相关.</T><BR></BR>		
]],		
		
		
	FRIENDS_TEXT23 = [[<T C="255,236,193" S="20" P="1">今日消耗</T><I Z="0.5" P="1">shopitems/activity.png</I><T C="255,236,193" S="20" P="1">%d活力，师傅获得</T><I Z="0.5" P="1">shopitems/activity.png</I><T C="255,236,193" S="20" P="1">%d活力奖励</T>]],	
		
	BeStrongBtnNameArrays1 = {"装备","宠物","坐骑","祈福","卡牌","修炼","要吃肉"},	
	BeStrongBtnNameArrays2 = {"金币","钻石","祈福勋章"},	
		
	FIGHT_TARGET = "竞技目标",	
	COMMUNITYINFO205 = [[玩家/等级/战斗力/职位]],	
	COMMUNITYINFO206 = [[今日贡献/本周贡献]],	
	COMMUNITYINFO207 = [[3天没登录]],	
	COMMUNITYINFO208 = [[3天没贡献]],	
	COMMUNITYINFO209 = [[精英以上除外]],	
	COMMUNITYINFO210 = [[今天已移除:]],	
	COMMUNITYINFO211 = [[移除选择]],	
	COMMUNITYINFO212 = [[入会等级]],	
	COMMUNITYINFO213 = [[排位等级]],	
	COMMUNITYINFO214 = [[是否审批]],	
	COMMUNITYINFO215 = [[否]],	
	COMMUNITYINFO216 = [[不需要]],	
	COMMUNITYINFO217 = [[每周4,5,6晚上8点开启]],	
	COMMUNITYINFO218 = [[没有成员留言]],	
	COMMUNITYINFO219 = [[待会长升级]],	
		
	BAG_TITLE_SHOW = "不显示称号",	
	SKILL_TXT = "技能",	
	NOT_GOODS_TIP = "没有此物品",	
	COMMUNITYINFO228 = [[(最多可输入8个字)]],	
	NOT_GOODS_TIP = "没有此物品",	
	FRIENDS_TEXT24 = "暂无密友申请信息",	
	SETTING_TIPS1 = "礼包码点我",	
	SETTING_TIPS2 = "有意见点我",	
	WORLDBOSS_MYHURT = [[<T C="255,227,116" S="20" P="1" SC="79,60,48" SS="4" SE="1">我的伤害：</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">%d(%d名)</T>]],	
	WEEK_FIGHT_LEVEL = "周积分榜",	
	COPY_TIP = "我是美女NPC",	
		
		
		
	FRIENDS_TEXT25 = [[<T C="255,255,255" S="22" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]],	
	FRIENDS_TEXT26 = [[<T C="127,70,26" S="20" P="1">向你申请密友关系，同意后你们将成为</T><T C="255,89,74" S="20" P="1">%s</T>]],	
	FRIENDS_TEXT27 = [[<T C="127,70,26" S="20" P="1">你的好友向你赠送了</T><T C="5,180,0" S="20" P="1"> %d</T><I Z="0.45" P="1">%s</I><T C="127,70,26" S="20" P="1">，你们的同时增加</T><T C="5,180,0" S="20" P="1"> %d</T><T C="127,70,26" S="20" P="1"> 好友度</T>]],	
	FRIENDS_TEXT28 = [[<T C="127,70,26" S="20" P="1">你的好友向你赠送了礼物，你们的同时增加</T><T C="5,180,0" S="20" P="1"> %d</T><T C="127,70,26" S="20" P="1"> 好友度</T>]],	
	FRIENDS_TEXT29 = [[<T C="127,70,26" S="20" P="1">你向TA赠送了礼物，你们的同时增加</T><T C="5,180,0" S="20" P="1"> %d</T><T C="127,70,26" S="20" P="1"> 好友度</T>]],	
	FRIENDS_TEXT30 = [[<T C="127,70,26" S="20" P="1">你向TA你赠送了</T><T C="5,180,0" S="20" P="1"> %d</T><I Z="0.45" P="1">%s</I><T C="127,70,26" S="20" P="1">，你们的同时增加</T><T C="5,180,0" S="20" P="1"> %d</T><T C="127,70,26" S="20" P="1"> 好友度</T>]],	
	FRIENDS_TEXT31 = [[<T C="127,70,26" S="20" P="1">与你并肩完成了战斗，你们同时增加</T><T C="5,180,0" S="20" P="1"> %d</T><T C="127,70,26" S="20" P="1"> 好友度</T>]],	
		
	CURRENT_CHAT_OPEN_LEVEL = "%d级开启当前聊天频道",	
	COLOR_CHAT_OPEN_LEVEL = "%d级开启彩聊聊天频道",	
	WHISPER_CHAT_OPEN_LEVLE = "%d级开启私聊聊天频道",	
		
	CHALLENGEENTRANCE_TEXT3 = "禁忌之地",	
	CHALLENGEENTRANCE_TEXT4 = "黑暗迷城",	
	CHALLENGEENTRANCE_TEXT5 = "该功能尚未开启",	
		
	MAIL_SHOP1 = "索要箱",	
	MAIL_SHOP2 = "礼物箱",	
	MAIL_SHOP3 = "不接收索要",	
	MAIL_SHOP4 = "赠送记录",	
	MAIL_SHOP5 = [[<T C="79,60,48" S="20" P="1" >%s</T><I Z="0.5">shopitems/diamond.png</I><T C="79,60,48" S="20" P="1" >,赠送给</T><T C="5,180,0" S="20" P="1" >%s</T>]],	
	CURRENT_CHAT_OPEN_LEVEL = "%d级开启当前聊天频道",	
	COLOR_CHAT_OPEN_LEVEL = "%d级开启彩聊聊天频道",	
	WHISPER_CHAT_OPEN_LEVLE = "%d级开启私聊聊天频道",	
	ENTERTAINMENT_MATCH_1 = "挖坑赛",	
	ENTERTAINMENT_MATCH_2 = "队长赛",	
	ENTERTAINMENT_MATCH_3 = "道具赛",	
	ENTERTAINMENT_MATCH_4 = "乱斗赛",	
	ENTERTAINMENT_MATCH_5 = "复活赛",	
		
	ROOM_FIGHT_RULE = 	
[[		
<T C="229,105,22" S="22">对战赛规则</T><BR></BR>		
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">对战赛根据玩家竞技等级进行匹配队友和对手</T><BR>10</BR>		
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">可进行公会捐献，可获得公会威望和个人贡献</T><BR>10</BR>		
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">可进行公会成员审批等人事调整</T><BR>10</BR>		
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">可进行公会等级升级，升级后可招收成员上限增多，同时可开启对应等级的公会建筑</T><BR>10</BR>		
]],		
		
	QUALIFYING_FIGHT_RULE = 	
[[		
<T C="229,105,22" S="22">排位赛规则</T><BR></BR>		
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">排位赛根据玩家段位进行匹配队友和对手</T><BR>10</BR>		
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">排位赛中玩家属性将做天枰调整，调整后的实力相近</T><BR>10</BR>		
]],		
		
	YULE_FIGHT_RULE1 = 	
[[		
<T C="229,105,22" S="22">挖坑赛规则</T><BR></BR>		
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">挖坑模式中对玩家造成的伤害无效，只可通过破坏地形坑杀对手</T><BR>10</BR>		
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">挖坑赛根据玩家竞技等级进行匹配队友和对手</T><BR>10</BR>		
]],		
		
	YULE_FIGHT_RULE2 = 	
[[		
<T C="229,105,22" S="22">队长赛规则</T><BR></BR>		
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">队长模式中己方队长死亡则战斗失败，需要合力保护己方队长，并集火对方队长获胜</T><BR>10</BR>		
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">队长模式中每次随机一名已方队员获得队长身份</T><BR>10</BR>		
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">队长模式中队长属性将会有所增强</T><BR>10</BR>		
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">队长赛根据玩家竞技等级进行匹配队友和对手</T><BR>10</BR>		
]],		
		
		
	YULE_FIGHT_RULE3 = 	
[[		
<T C="229,105,22" S="22">道具赛规则</T><BR></BR>		
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">道具模式中将会刷新3个道具随机分布在战场中，可通过子弹或飞行碰撞获得道具效果</T><BR>10</BR>		
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">道具模式中3个道具被拾取完的下一个行动回合时将重置刷新3个道具</T><BR>10</BR>		
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">道具赛根据玩家竞技等级进行匹配队友和对手</T><BR>10</BR>		
]],		
		
	YULE_FIGHT_RULE5 = 	
[[		
<T C="229,105,22" S="22">复活赛规则</T><BR></BR>		
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">复活赛中先夺得敌队4条生命的队伍获胜</T><BR>10</BR>		
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">复活赛中未决出胜负前，死亡后可复活</T><BR>10</BR>		
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">复活赛根据玩家竞技等级进行匹配队友和对手</T><BR>10</BR>		
]],		
		
	ROOM_RULE = 	
[[		
<T C="229,105,22" S="22">训练营规则</T><BR></BR>		
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">训练营中玩家只能使用指定技能，并且没有CD限制</T><BR>10</BR>		
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">训练营奖励只可获得一次，重复挑战无奖励</T><BR>10</BR>		
]],		
		
	--对战赛邀请说明(好友、公会、大厅)	
	ENTERTAINMENT1_TEXT_1 = "",	
	ENTERTAINMENT1_TEXT_2 = "",	
	ENTERTAINMENT1_TEXT_3 = "",	
		
	--排位赛邀请说明(好友、公会、大厅)	
	ENTERTAINMENT2_TEXT_1 = "",	
	ENTERTAINMENT2_TEXT_2 = "",	
	ENTERTAINMENT2_TEXT_3 = "",	
		
	--挖坑赛邀请说明(好友、公会、大厅)	
	ENTERTAINMENT3_TEXT_1 = "",	
	ENTERTAINMENT3_TEXT_2 = "",	
	ENTERTAINMENT3_TEXT_3 = "",	
		
	--队长赛邀请说明(好友、公会、大厅)	
	ENTERTAINMENT4_TEXT_1 = "",	
	ENTERTAINMENT4_TEXT_2 = "",	
	ENTERTAINMENT4_TEXT_3 = "",	
		
	--道具赛邀请说明(好友、公会、大厅)
	ENTERTAINMENT5_TEXT_1 = "",	
	ENTERTAINMENT5_TEXT_2 = "",	
	ENTERTAINMENT5_TEXT_3 = "",	
		
    --乱斗赛邀请说明（好友、公会、大厅）		
	ENTERTAINMENT6_TEXT_1 = "",	
	ENTERTAINMENT6_TEXT_2 = "乱斗赛公会邀请说明",	
	ENTERTAINMENT6_TEXT_3 = "乱斗赛大厅邀请说明",	
		
    --复活赛邀请说明（好友、公会、大厅）		
	ENTERTAINMENT7_TEXT_1 = "",	
	ENTERTAINMENT7_TEXT_2 = "",	
	ENTERTAINMENT7_TEXT_3 = "",	
		
		
	FRIENDS_TEXT32 = [[不再接收申请]],	
	GAMEACTIVITY_NEWTEXT1 = "活动",	
	GAMEACTIVITY_NEWTEXT2 = [[<T C="255,227,116" S="22" P="1" SC="128,54,13" SS="4" SE="1">当前时间:</T><T C="99,255,95" S="22" P="1" SC="0,72,3" SS="4" SE="1">%d时%d分</T>]],	
	WELFARE_NEWTEXT1 = "福利",	
	WELFARE_NEWTEXT2 = "比赛",	
		
	BATTLE_ROLE_EXP = "角色经验",	
	BATTLE_COPPER = "竞技币",	
	BATTLE_WEEK_AWARD = "本周收益",	
	BATTLE_WEEK_AWARD_FULL = "本周收益已达上限",	
	BATTLE_HERO_SCORE = "勇者积分",	
	BATTLE_RANK_WINS = "%d连胜",	
	BATTLE_GET_MVP = "获得MVP",	
	BATTLE_RANK_KILL_SCORE = "达成%d杀",	
	BATTLE_RANK_SCORE_DES = "积分满100分=1颗星",	
	BATTLE_RANK_UPGRADE_TIPS = "本局上升%d星",	
	BATTLE_RANK_UPGRADE_TIPS_II = "本局上升%d星，并且段位提升",	
	BATTLE_RANK_DnGRADE_TIPS = "本局下降%d星",	
	BATTLE_RANK_DnGRADE_TIPS_II = "本局下降%d星，并且段位掉落",	
	BATTLE_GET_KILL_ACHIEVE = "第%d次获得%d杀",	
	BATTLE_GET_VIP_ACHIEVE = "第%d次获得VIP",	
		
	COMMUNITYINFO220 = "修改公会公告成功",	
	COMMUNITYINFO221 = "加入需要%d级",	
	COMMUNITYINFO222 = "%s段位以上",	
	COMMUNITYINFO223 = "段",	
	COMMUNITYINFO224 = "星",	
	FRIENDS_TEXT33 = [[该玩家拒绝拜师]],	
	FRIENDS_TEXT34 = [[该玩家拒绝收徒]],	
		
	PRACTICE_ALL_FIGHTING = "修炼总战力",	
		
	TOWER_GOAL1_1 = "%d次出手通过：%d",	
	TOWER_GOAL1_2 = "剩余%d%%血量：%d%%",	
	TRY_STRONG_OTHER = "试试以下方法变强吧",	
	WNDCHECKOTHER51 = "资料完成度",	
	WNDCHECKOTHER52 = "暂无宠物",	
	WNDCHECKOTHER53 = "没有已出师徒弟",	
		
	COPY_GOAL1_LOSE = "通关副本",	
	COPY_GOAL2_LOSE = "剩余%d%%生命通关：%d%%",	
	COPY_GOAL3_LOSE = "%d次出手内通关：%d次",	
		
	PVP_RANK_TEXT1 = "段位奖励每赛季重置",	
	PVP_RANK_TEXT2 = [[<T C="79,60,48" S="18" P="1">本赛季于</T><T C="158,0,0" S="18" P="1"> %d-%d %d点</T><T C="79,60,48" S="18" P="1"> 结束</T>]],	
	PVP_RANK_TEXT3 = [[<T C="79,60,48" S="18" P="1">我的段位：</T><T C="0,72,3" S="18" P="1">%s%d段</T>]],	
	PVP_RANK_TEXT5 = [[<T C="79,60,48" S="18" P="1">我的段位：</T><T C="0,72,3" S="18" P="1">%s</T>]],	
	PVP_RANK_TEXT4 = [[<T C="158,0,0" S="22" P="1">(胜率 %d%%)</T>]],	
		
	BLESS_AAT_TITLE = "祝福属性",	
	BLESS_AAT_TITLE = "祈福属性",	
		
	PETGIFT1 = "资质说明:当前资质为",	
	PETGIFT2 = "其",	
	PETGIFT3 = "属性会转换到角色上",	
		
	SETTING_POSITION = "公开地理位置",	
	SETTING_MESSAGE = "允许好友留言",	
	ONLINE_STATS_1 = "忙碌",	
	PET_EXTERIOR_DESC = "进化+%d解锁",	
	PET_EXTERIOR_MAX = "完全体",	
	PET_EXTERIOR_MAX2 = "进化橙宠解锁",	
	ROOM_INVITE_INFO = "组队副本描述",	
	ROOM_INVITE_INFO_1 = "组队副本描述2222",	
	PVP_RANK_TEXT6 = [[<T C="127,70,26" S="20" P="1" SC="127,70,26" SS="4" SE="0">本赛季排名第一 可获得</T><T C="5,180,0" S="20" P="1" SC="0,72,3" SS="4" SE="0">唯一限量的专属武器</T>]],	
	PVP_RANK_TEXT7 = [[<T C="127,70,26" S="20" P="1" SC="127,70,26" SS="4" SE="0">本赛季段位达到</T><T C="5,180,0" S="20" P="1" SC="0,72,3" SS="4" SE="0">%s</T><T C="127,70,26" S="20" P="1" SC="127,70,26" SS="4" SE="0">可获得专属奖励</T><T C="127,70,26" S="18" P="1">（仅一次）</T>]],	
		
	VipRebateDesc = "累计充值%d钻石",	
		
	COMMUNITYINFO225 = "等级不够，不能申请",	
	COMMUNITYINFO226 = "段位不够，不能申请",	
	COMMUNITYINFO227 = "我好想加入噢",	
		
	GIFT_TITLE = "购买礼包",	
	GIFT_ITEM = "礼包包含如下",	
	BUY_GIFT_NO_COUNT = "没有剩余购买次数",	
	BUY_GIFT_NO_VIP = "VIP等级不足",	
	GIFT_PRICE = "%s购买",	
	BUY_GIFT_LIMIT1 = [[<T C="138,122,106" S="20" P="0">今日剩余</T><T C="158,0,0" S="20" P="0">%d</T><T C="138,122,106" S="20" P="0">个</T>]],	
	BUY_GIFT_LIMIT2 = [[<T C="138,122,106" S="20" P="0">剩余</T><T C="158,0,0" S="20" P="0">%d</T><T C="138,122,106" S="20" P="0">个</T>]],	
	BUY_GIFT_LIMIT4 = [[<T C="138,122,106" S="20" P="0">VIP%d可购买,今日剩</T><T C="158,0,0" S="20" P="0">%d</T><T C="138,122,106" S="20" P="0">个</T>]],	
	BUY_GIFT_LIMIT5 = [[<T C="138,122,106" S="20" P="0">VIP%d可买,剩</T><T C="158,0,0" S="20" P="0">%d</T><T C="138,122,106" S="20" P="0">个</T>]],	
	BUY_GIFT_LIMIT6 = [[<T C="138,122,106" S="20" P="0">VIP%d可购买</T>]],	
		
	LAST_COUNT = "剩%d",	
	RANKLIST_HOST = "主人：",	
	BATTLE_FINAL_AWARD = "最终奖励：",	
	MARRY_WEDDING = "我要结婚",	
	MY_WEDDING = "我的婚礼",	
	RELIEVE_WEDDING = "解除订婚",	
	MARRY = "结婚",	
	PLAYAYER_INFO = [[<T C="255,227,116" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s </T><T C="255,255,255" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]],	
	TIPS10 = [[活力已满]],	
	TASKTIP1 = "有奖励可领取",	
	TASKTIP2 = "有任务进行中",	
	TASKTIP3 = "今日已完成",	
	PLAYAYER_INFO2 = [[<T C="99,255,95" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]],	
	REDPACK_ATT = "前往世界频道发口令\n即可领取红包",	
	REDPACK_ATT2 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">今日还可领取红包：</T><T S="20" C="99,255,95" P="1" SC="79,60,48" SS="4" SE="1">%d/%d</T>]],	
	REDPACK_ATT3 = [[<T C="255,255,255" S="20" P="1" SC="158,0,0" SS="4" SE="1">%s</T><T C="255,255,255" S="20" P="1" SC="158,0,0" SS="4" SE="1">后可以再次领取</T>]],
	REDPACK_ATT4 = "前往输入",	
	GUILD_SKILL_OPEN_TIP = "%d级公会才开放哦",	
		
	TEAM_BOSS_SIMPLE = "通关普通难度",	
	TEAM_BOSS_NORMAL = "通关困难难度",	
	TEAM_BOSS_HARD = "通关地狱难度",	
	DYEING = "表情与翅膀不支持染色，过期的时装将还原配色",	
		
	NEEDSTONE = "宝石材料不足",	
	BLOCTIPS = "该功能需要下载安装最新包",	
	CHAT_LATELY_PEOPLE = "最近联系人",	
	ASSISTANT2 = "小助手",	
	LUCKY_GIFT = "幸运礼盒",	
	LUCKYGIFT_HASDRAW = "今日第%d次抽奖",	
	LUCKYGIFT_FREEDRAW = "%d次",	
	LUCKYGIFT_FREE = "今日剩余免费翻牌:",	
	LUCKYGIFT_RESET = "礼盒重置时间:",	
	LUCKYGIFT_BOMB = "您抽到了炸弹，今日无法进行抽奖",	
	LUCKYGIFT_STARTDRAW = "开始翻牌",	
	LUCKYGIFT_DES = 	
[[		
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">幸运礼盒每日24点重置礼盒内容</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">礼盒内容翻牌需要消耗钻石，翻牌次数越多消耗越大</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">礼盒每日有一定免费次数翻牌</T><BR>10</BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">礼盒抽取到倍率卡后，今日翻牌价格将乘以倍率卡的倍数</T><BR>10</BR>
<T C="127,70,26" S="20">5.</T><T C="127,70,26" S="18">礼盒获得的恩赐币可以去商城兑换区购买物品</T><BR>10</BR>
]],		
	LUCKYGIFT_FINISH = "今日已抽完",	
	OnlineReward = "在线奖励",	
	TODAY_CHALLENGE_TOTAL = "今日挑战次数：",	
	TODAY_OBTAIN = "今日获取：",	
	LUCKY_BOMB = "你抽到过炸弹，今天不能再抽奖",	
		
	TRAINCAMP_DEC1 = [[<T C="127,70,26" S="20" P="0">奖励内容:</T><T C="5,180,0" S="20" P="0">%s</T>]],	
	TRAINCAMP_DEC2 = "(已领取)",	
	TRAINCAMP_DEC3 = "已通过",	
	ROOMS = "%s的房间",	
	COMMUNITY_OPEN_TIP = "%d级公会开启",	
    HURT_BUFFER = "伤害+%d",		
    WEEK_TOTAL_HURT = "本周累计伤害：",		
	PASS_RANK ="通关排行",	
	CHALLENGEING = "正在挑战中",	
	QUICK_MATCH = "快速匹配",	
	TRAINCAMP_DEC4 = "训练营",	
	TRAINCAMP_DEC5 = "通过上一个难度才可挑战",	
	TRAINCAMP_DEC6 = "飞到目标点%d次:",	
	TRAINCAMP_DEC7 = "击杀怪物%d只:",	
	TRAINCAMP_DEC8 = "击中目标%d次:",	
	MY_PVPRANK = [[<T C="79,60,48" S="18" P="1">我的排名：</T><T C="0,72,3" S="18" P="1">%s</T>]],	
	VipRebateDesc1 =	
[[		
<T C="105,65,46" S="22">累计充值 </T>		
<T C="255,227,116" S="22" SC="105,65,46" SS="4" SE="1"> %s</T>		
<I Z="0.75">ui/common/common_icon_zuanshi.png</I>		
]],		
VipRebateDesc2 =		
[[		
<T C="79,60,48" S="20">需再充值 </T>		
<T C="3,111,8" S="20"> %s</T>		
<I Z="0.6">ui/common/common_icon_zuanshi.png</I>		
<T C="79,60,48" S="20">升级</T>		
<T C="3,111,8" S="20">%s</T>		
<T C="79,60,48" S="20">喔!</T>		
]],		
	RETURNMONEY = "返利",	
	CARD_SHOP = "卡牌商店",	
	EVERYDAY_AUTO_REFRESH = [[<T C="127,70,26" S="16" P="1">每日：</T><T C="158,0,0" S="16" P="1">%s</T><T C="127,70,26" S="16" P="1">刷新商店</T>]],	
	LOG = "日志",	
	COMMUNITY_STORE_DISCOUNT = [[<T C="127,70,26" S="20" P="1">购买公会商品享</T><T C="158,0,0" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1">折优惠</T>]],	
	COMMUNITY_SHOP_OWN_COUNT = "公会商店拥有该物品为0",	
	HEROBLOC = "英雄俱乐部",	
	PLAYERBACK1 = "不满足活动条件，无法领取",	
	PLAYERBACK2 = "超过%d日未登陆的玩家，活动期间登陆游戏将可获得奖励",	
	PLAYERBACK3 = 	
[[		
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">老玩家回归活动规则</T><BR></BR>		
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 1~20级玩家可获得 金币*15000</T><BR></BR>		
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 21~40级玩家可获得 金币*15000 钻石*100</T><BR></BR>		
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 41~60级玩家可获得 金币*15000 钻石*100 圣光宝匣*10</T><BR></BR>		
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> 61~70级玩家可获得 金币*15000 钻石*100 圣光宝匣*10 顶级升星石*10</T><BR></BR>		
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> VIP5以上玩家可额外获得 钻石*500</T><BR></BR>		
]],		
	PLAYERBACK4 = "领奖",	
	STORAGE_LOG = "存储日志",	
	COMMUNITY_SHOP_LOG = "购买日志",	
	STORAGE_LOG_TIP = [[<T S="18" C="255,236,193" P="1">Boss</T><T S="18" C="233,166,62" P="1" >%s</T><T S="18" C="255,236,193" P="1">死亡,其掉落物品</T><T S="18" C="5,180,0" P="1" >%s</T><T S="18" C="255,236,193" P="1">已存储到公会商店</T>]], 	
	COMMUNITY_SHOP_LOG_TIP = [[<T S="18" C="233,166,62" P="1" >%s</T><T S="18" C="255,236,193" P="1">购买了</T><T S="18" C="5,180,0" P="1" >%s</T>]],	
	GUILD_BOSS_FIGHT_COST = "挑战消耗：%d",	
	GUILD_BOSS_DROP = "BOSS可能掉落如下道具",	
	GUILD_BOSS_FIGHTER = "正在挑战人数：%d",	
	GUILD_BOSS_HURT_PRE = "全体伤害+%d%%",	
	GUILD_BOSS_INSPIRE_TIPS = "(PS：本次伤害效果只对BOSS有效)",	
	GUILD_BOSS_INSPIRE_PLAYERS = "本次鼓舞玩家",	
	GUILD_BOSS_INSPIRE_ALL = "全体鼓舞",	
	GUILD_BOSS_INSPIRE_ADD = "伤害 +%d%%",	
	GUILD_BOSS_INSPIRE = "鼓舞",	
	GUILD_BOSS_INSPIRE_NUM = "鼓舞%d次",	
	GUILD_BOSS_INSPIRE_DES = "(PS.鼓舞成功后，该工会所有成员都得到加成)",	
	GUILD_BOSS_RAND_FIRST = "全服首次通关",	
	GUILD_BOSS_RAND_FAST = "全服最快通关",	
	GUILD_BOSS_PASS_TIME_TITLE = "通关时间",	
	GUILD_BOSS_WIN_DESC = [[<T C="255,236,193" S="22" P="0">玩家</T><T C="99,255,95" S="22" P="0"> %s </T><T C="255,236,193" S="22" P="0">已经击杀了BOSS %s !</T>]],	
	GUILD_BOSS_WIN_TITLE1 = "恭喜！您给了BOSS最后一下\n击杀了BOSS！",	
	GUILD_BOSS_WIN_TITLE2 = "%s给了BOSS最后一下\n击杀了BOSS！",	
	GUILD_BOSS_WIN_TITLE3 = "BOSS未死，再接再厉",	
	GUILD_BOSS_WIN_HURT_TITLE = "伤害详情",	
	GUILD_BOSS_WIN_HURT = "造成伤害",	
	GUILD_BOSS_WIN_HP_PRE = "BOSS剩余",	
	GUILD_BOSS_WIN_HURT_REWARD = "伤害奖励",	
	GUILD_BOSS_WIN_KILL_REWARD = "击杀奖励",	
	PVPRANK_MODIFYING = "排位赛正在改造中",	
	PLAYERBACK5 = "不满足回归条件,无奖励",	
	CURRENT_COPY = "当前副本：",	
	SWEEP_TEAM_COPY_DIFF_TIP = "请选择副本难度：",	
	SWEEP_TEAM_COPY_FIGHTING = "扫荡所需",	
	SURPLUS_SWEEP_COUNT_LESS = "剩余扫荡次数不足",	
	GUILD_BOSS_PASS_TIME = "%02d小时%02d分钟",	
	GUILD_BOSS_INSPIRE_FULL = "鼓舞已满！",	
	SWEEP_COPY_NOT_TIP = "该副本不支持扫荡功能",	
    SWEEP_COPY_LEVEL_OPEN_TIP = "%d级开启该副本扫荡",		
	COMMUNITYWAR_TEXT1 = "出线",	
	COMMUNITYWAR_TEXT2 = "入围",	
	COMMUNITYWAR_TEXT3 = "第%d周",	
	COMMUNITYWAR_TEXT4 = "公会(会长)",	
	COMMUNITYWAR_TEXT5 = "今日赛程",	
	COMMUNITYWAR_TEXT6 = "出线赛排名",	
	COMMUNITYWAR_TEXT7 = "入围赛排名",	
	COMMUNITYWAR_TEXT8 = "出线赛规则",	
	COMMUNITYWAR_TEXT9 = "入围赛规则",	
	COMMUNITYWAR_TEXT10 = [[<T C="255,227,116" S="20" P="1">小组赛总赛程</T><T C="255,227,116" S="20" P="1">(%s)</T><T C="255,227,116" S="20" P="1">比赛</T>]],	
	COMMUNITYWAR_TEXT11 = [[<T C="255,227,116" S="20" P="1">决赛总赛程</T><T C="255,227,116" S="20" P="1">(%s)</T><T C="255,227,116" S="20" P="1">比赛</T>]],	
	COMMUNITYWAR_TEXT12 = 	
[[		
<T C="255,89,74" S="20" P="0">1.</T><T C="255,236,193" S="20" P="0"> 开启时间：每月的1,3,5,7号20点至21点为公会战出线赛匹配时间.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">2.</T><T C="255,236,193" S="20" P="0"> 公会战出线赛对战,同一公会的玩家自发组成3人队伍,与其他公会的队伍进行对战.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">3.</T><T C="255,236,193" S="20" P="0"> 每场对战时间上限为15分钟,超时将直接由系统根据双方剩余人数、剩余血量判断胜者,并结算积分.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">4.</T><T C="255,236,193" S="20" P="0"> 对战中强退、掉线的玩家会被扣积分.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">5.</T><T C="255,236,193" S="20" P="0"> 公会战积分将会被统计,作为公会出线赛的排名主要依据.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">6.</T><T C="255,236,193" S="20" P="0"> 公会战出线赛排名为本服排名,最终排名前4个公会获得出线资格,进入公会战入围赛.</T><BR></BR>		
]],		
	COMMUNITYWAR_TEXT13 = 	
[[		
<T C="255,89,74" S="20" P="0">1.</T><T C="255,236,193" S="20" P="0"> 开启时间：每月的8,10,12,14号20点至21点为公会战入围赛匹配时间.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">2.</T><T C="255,236,193" S="20" P="0"> 公会战入围赛对战,同一公会的玩家自发组成3人队伍,与其他公会的队伍进行对战.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">3.</T><T C="255,236,193" S="20" P="0"> 每场对战时间上限为15分钟,超时将直接由系统根据双方剩余人数、剩余血量判断胜者,并结算积分.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">4.</T><T C="255,236,193" S="20" P="0"> 对战中强退、掉线的玩家会被扣积分.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">5.</T><T C="255,236,193" S="20" P="0"> 公会战积分将会被统计,作为公会入围赛的排名主要依据.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">6.</T><T C="255,236,193" S="20" P="0"> 公会战入围赛排名为全服排名,最终排名前32个公会获得淘汰赛参赛资格,角逐最终冠军.</T><BR></BR>		
]],		
	COMMUNITYWAR_TEXT14 = [[<T C="195,171,148" S="20" P="1">我的公会：第</T><T C="5,180,0" S="20" P="1">%d</T><T C="195,171,148" S="20" P="1">名</T>]],	
	COMMUNITYWAR_TEXT15 = "比赛回顾",	
	COMMUNITYWAR_TEXT16 = "后开启",	
	COMMUNITYWAR_TEXT17 = "尚未开始，请耐心等待",	
	COMMUNITYWAR_TEXT18 = "玩家等级不足",	
	COMMUNITYWAR_TEXT19 = "玩家公会等级不足",	
	COMMUNITYWAR_TEXT20 = "今天的比赛已经结束",	
	COMMUNITYWAR_TEXT21 = "您的公会没有进入入围赛，下次记得努力点噢",	
	COMMUNITYWAR_TEXT22 = "您的公会已经失去资格，下次一定要努力啊",	
	COMMUNITYWAR_TEXT23 = "本轮公会战已经结束",	
	COMMUNITYWAR_TEXT24 = "%s号",	
	COMMUNITYWAR_TEXT25 = "1、3、5、7进行出线赛",	
	COMMUNITYWAR_TEXT26 = "8、10、12、14进行入围赛",	
	COMMUNITYWAR_TEXT27 = "淘汰赛进行中",	
	COMMUNITYWAR_TEXT28 = "决赛进行中",	
	COMMUNITYWAR_TEXT29 = "进入休战期，休养生息...",	
	COMMUNITYWAR_TEXT30 = "开战时间：",	
	COMMUNITYWAR_TEXT31 = "公会(服务器)",	
	COMMUNITYWAR_TEXT32= "名字(等级)",	
	COMMUNITYWAR_TEXT33 = "本服排名",	
	COMMUNITYWAR_TEXT34 = "成员排名",	
	UNIT_PRICE = "单价",	
	PASS_HARD_COPY_TIP = "通关地狱难度才能进行扫荡",	
	WEEK_CARD = "周卡",	
	ENJOY_CARD = "永久至尊卡",	
	SWEEP_COPY_NOT_ITEM_TIP = "%s不足，是否购买？",	
	PVPRANK_INVITE_NO_DATA = "没有符合排位赛要求的数据",	
	KNOCKOUT1 = "A组",	
	KNOCKOUT2 = "B组",	
	KNOCKOUT3 = "C组",	
	KNOCKOUT4 = "当前已有%s名公会成员进入公会战",	
	KNOCKOUT5 = "公会战淘汰赛",	
	KNOCKOUT6 = "淘汰赛规则",	
	KNOCKOUT7 = "自动开始",	
	KNOCKOUT8 = "成员",	
	KNOCKOUT_DESC =	
[[		
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> 淘汰赛规则</T><BR></BR>		
]],		
	KNOCKOUT9 = "房间内",	
	KNOCKOUT10 = "公会会长或代理人可进行设置",	
	SHOUCHONG4 = [[<T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">已充值</T><T C="255,227,116" S="20" P="1" SC="0,0,0" SE="1" SS="4">%s钻石</T><T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">:</T>]],	
	UNIT_PRICE = "单价",	
	PASS_HARD_COPY_TIP = "通关地狱难度才能进行扫荡",	
	WEEK_CARD = "周卡",	
	ENJOY_CARD = "永久至尊卡",	
	COMMUNITYWARGIFT_TEXT1 = "出线赛",	
	COMMUNITYWARGIFT_TEXT2 = "入围赛",	
	COMMUNITYWARGIFT_TEXT3 = "淘汰赛",	
	COMMUNITYWARGIFT_TEXT4 = "奖励",	
	COMMUNITYWARGIFT_TEXT6 = "对应赛程结束后，奖励将通过邮件发放",	
	COMMUNITYWARTASK_TEXT1 = "目标",	
	COMMUNITYWARTASK_TEXT2 = "参赛",	
	COMMUNITYWARTASK_TEXT3 = "决赛结束后，目标记录重置，未领取的奖励将通过邮件发放",	
	COMMUNITYWARTASK_TEXT4 = "领取",	
	COMMUNITYWARTASK_TEXT5 = "胜利",	
	COMMUNITYWARTASK_TEXT6 = "击杀",	
	COMMUNITYWARHISTORY_TEXT2 = "历届",	
	COMMUNITYWARHISTORY_TEXT3 = "第%s届",	
	COMMUNITYWARHISTORY_NUMBER = {	
		"一", "二", "三", "四", "五",
		"六", "七", "八", "九", "十",
	},	
	COMMUNITYWARAGENT_TEXT1 = "设置代理人",	
	COMMUNITYWARAGENT_TEXT2 = "确认",	
	GUILD_WAR_RW_TITLE = "公会战入围赛",	
	GUILD_WAR_CX_TITLE = "公会战出线赛",	
	CANCEL_READY_GAME = "取消准备",	
	CANCEL_PAIR_GAME = "取消匹配",	
	PVPRANK_INVITE_NO_DATA = "没有符合排位赛要求的数据",	
	HAVE_KILL_BOSS = "BOSS已死亡",	
	SHOUCHONG1 = [[<T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">首充任意金额</T><T C="198,130,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">五星紫宠</T><T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">宝宝带回家</T>]],	
	SHOUCHONG2 = [[<T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">再次充值</T><T C="255,227,116" S="20" P="1" SC="0,0,0" SE="1" SS="4">%s钻石</T><T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">即送</T><T C="99,255,95" S="20" P="1" SC="0,0,0" SE="1" SS="4">升星石、抽奖卷、金币</T>]],	
	SHOUCHONG3 = [[<T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">再次充值</T><T C="255,227,116" S="20" P="1" SC="0,0,0" SE="1" SS="4">%s钻石</T><T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">即送</T><T C="99,255,95" S="20" P="1" SC="0,0,0" SE="1" SS="4">装备之宝、金币</T>]],	
	GUILD_WAR_RANK_REWARD_VIEW = "当前排名奖励预览",	
	GUILD_WAR_TEAM_SCORE = "当前队伍总积分：%s",	
	SWEEP_FUNCTION_LAST = "扫荡功能剩余次数:",	
	COMMUNITYWAR_TEXT35 = "32进16",	
	LUCKYGIFT1 = "恩赐兑换",	
	SHOP_BUY_DESC3 = [[<T C="79,60,48" S="20" P="0">共%d件商品，需支付</T><I Z="0.5">%s</I><T C="79,60,48" S="20" P="0">%d</T>]],	
	NOTRECOMMOEND = "兑换区无推荐的商品哟",	
	ARENA_CARD_DES = 	
[[		
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> 竞技积分加成卡分为胜场、天数两种.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> 胜场卡在竞技获胜时可生效,每次生效,持续场数-1,为0时则失效.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> 天数卡在竞技获得积分＞0时生效,持续时间在角色离线时依然计算,为0时则失效.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> 胜场卡和天数卡效果可叠加.</T><BR></BR>		
]],		
	ARENA_CARD_TIME_TITLE = "次卡胜利加成",	
	ARENA_CARD_TIME_LEFT = "剩余场次：%d",	
	ARENA_CARD_ADD_PREC = "任意模式竞技胜利，积分加成%d%%",	
	ARENA_CARD_DAY_TITLE = "日卡胜利加成",	
	ARENA_CARD_DAY_LEFT = "剩余时间：%d天%d小时",	
	ARENA_CARD_DAY_LEFT2 = "剩余时间：%d小时%d分钟",	
	ARENA_CARD_DAY_LEFT3 = "剩余时间：%d分钟",	
	ARENA_CARD_TIME_TIP = "竞技胜利积分+%d%%场次+%d",	
	ARENA_CARD_DAY_TIP = "竞技结算积分+%d%%效果天数+%d",	
	ARENA_CARD_ADD = "竞技积分加成",	
	COMMUNITYWARAGENT_TEXT3 = "点击\"+\"号或头像进行设置",	
	COMMUNITYWARAGENT_TEXT4 = "代理人",	
	DAY1 = "第一日",	
	DAY2 = "第二日",	
	DAY3 = "第三日",	
	DAY4 = "第四日",	
	DAY5 = "第五日",	
	DAY6 = "第六日",	
	DAY7 = "第七日",	
	NOSAVE = "未存入",	
	SEVEN1 = "今日消费",	
	SEVEN2 = "累计消费",	
	SEVEN3 = "明日可领取",	
	SEVEN4 = "第八日可领取",	
	SEVENDESC =	
[[		
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> 该活动从创建角色起，维持一周时间</T><BR></BR>		
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> 第二天可以领取前一天消耗钻石的10%</T><BR></BR>		
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> 第八天可以领取前一周的总消耗的10%钻石</T><BR></BR>		
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> 返利的钻石每天晚上12点整通过邮件发放</T><BR></BR>		
<T C="158,0,0" S="22" P="0">5.</T><T C="62,34,8" S="22" P="0"> 活动只限创建的新角色前一周有效</T><BR></BR>		
]],		
	KNOCKOUT_DESC = 	
[[		
<T C="255,89,74" S="20" P="0">1.</T><T C="255,236,193" S="20" P="0"> 开启时间：每月的15号至20号为淘汰赛赛程,赛程采取3战2胜制度,胜者晋级.期间,每天20：00~20：15为备战时间,可设置队员,队员可自由备战.20：15分准时进行比赛,已设置好队员直接进入战斗场景.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">2.</T><T C="255,236,193" S="20" P="0"> 公会会长可于房间内设置每队参赛成员,亦可在公会场景设置代理人,由代理人进行设置.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">3.</T><T C="255,236,193" S="20" P="0"> 每场对战时间上限为15分钟,超时将直接由系统根据双方剩余人数、剩余血量判断胜者,并结算积分.</T><BR></BR>		
<T C="255,89,74" S="20" P="0">4.</T><T C="255,236,193" S="20" P="0"> 19号进行季军争夺赛,20号为冠军争夺赛.</T><BR></BR>		
]],		
	ROOM_BEINVITED_3 = "%s 邀请你参加\n%s",	
	CANTJOINGUILD1 = "未达到入会等级",	
		
	COUNTDOWN = "活动倒计时:",	
	COMMUNITYWAR_TEXT36 = "你的公会今天没有比赛",	
	COMMUNITYWAR_TEXT37 = "会长才可以设置代理人噢",	
	COMMUNITYWAR_TEXT38 = "更高权限的代理人进来了，你设置的权限被剥夺",	
	SHOP_DRESS_NULL = "当前没有试穿时装",	
	COMMUNITYWARAGENT_TEXT5 = 	
[[		
<T C="229,105,22" S="22">代理人设置公会战队员</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> 代理人可在公会战淘汰赛房间设置参赛成员</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> 最多可以设置4名代理人</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> 在房间内只有一人拥有设置权限,会长在时拥有绝对权限</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> 会长不在房间内,最小编号代理人才能使用设置权限</T><BR>20</BR>
<T C="229,105,22" S="22">代理人刷新发布公会任务</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> 公会会长和代理人均可刷新发布公会任务</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> 同时只有一人拥有刷新发布权限</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> 会长不在线，则最小编号代理人拥有权限</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> 更高优先级玩家上线时，权限会发生改变</T><BR></BR>
]],		
	BATTLE_FIRST_KILL = "首杀",	
	LEAGUE114 = "第一届英雄联赛",
	LEAGUE115 = "战队:",
	TEACH_179 = "点击跳过剧情",
	INVITE_LIST = "邀请列表",
	GAME_ACTIVITY_TITLE40 = "放烟花",
	GAME_ACTIVITY_TITLE41 = "整点红包",
	GAME_ACTIVITY_TITLE42 = "口令红包",
	GAME_ACTIVITY_TITLE43 = "老玩家回归",
	GAME_ACTIVITY_TITLE44 = "新角色返利",
	GAME_ACTIVITY_TITLE45 = "新角色红包",	
	MAX_Week_CARD = "当前周卡有效%d天以上,无需续费",
	LUCKYGIFT2 = "%.1f倍",
	COMMUNITYWARAGENT_TEXT5 = 
	[[
	
	<T C="229,105,22" S="22">代理人设置公会战队员</T><BR>5</BR>
	<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> 代理人可在公会战淘汰赛房间设置参赛成员</T><BR></BR>
	<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> 最多可以设置4名代理人</T><BR></BR>
	<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> 在房间内只有一人拥有设置权限,会长在时拥有绝对权限</T><BR></BR>
	<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> 会长不在房间内,最小编号代理人才能使用设置权限</T><BR>20</BR>
	<T C="229,105,22" S="22">代理人刷新发布公会任务</T><BR>5</BR>
	<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> 公会会长和代理人均可刷新发布公会任务</T><BR></BR>
	<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> 同时只有一人拥有刷新发布权限</T><BR></BR>
	<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> 会长不在线，则最小编号代理人拥有权限</T><BR></BR>
	<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> 更高优先级玩家上线时，权限会发生改变</T><BR></BR>
	]],
	NEWUSER_WEAFARE_RETURN_RULE =
	[[
	<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> 该活动从创建角色起，维持一周时间</T><BR></BR>
	<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> 充值达到指定的额度可以领取相应奖励</T><BR></BR>
	<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> 该活动只持续7天</T><BR></BR>
	<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> 活动只限创建的新角色前一周有效</T><BR></BR>
	<T C="158,0,0" S="22" P="0">5.</T><T C="62,34,8" S="22" P="0"> 活动结束后充值无效</T><BR></BR>
	]],
	DIGGEM_TEXT1 = "宝物背包",
	DIGGEM_TEXT2 = "挖宝日志",
	DIGGEM_TEXT3 = "预计剩余时间:",
	DIGGEM_TEXT4 = "开始挖宝",
	DIGGEM_TEXT5 = "停止挖宝",
	DIGGEM_TEXT6 = "熟练度",
	DIGGEM_TEXT7 = "容量",
	DIGGEM_TEXT8 = "只保留最近3天内的50条记录",
	DIGGEM_TEXT9 = [[<T C="255,236,193" S="20" P="0">选择了</T><T C="233,166,62" S="20" P="0">[%s]</T><T C="255,236,193" S="20" P="0">，挖宝开始</T>]],
	DIGGEM_TEXT10 = [[<T C="255,236,193" S="20" P="0">一分耕耘一分收获，挖到了</T><T C="233,166,62" S="20" P="0">[%s]</T><T C="255,236,193" S="20" P="0">，熟练度</T><T C="5,180,0" S="20" P="0">+%d</T>]],
	DIGGEM_TEXT11 = [[<T C="255,236,193" S="20" P="0">时间已到，挖宝结束</T>]],
	DIGGEM_TEXT12 = [[<T C="255,236,193" S="20" P="0">宝物背包已满，请及时清理背包，停止挖宝</T>]],
	DIGGEM_TEXT13 = [[<T C="255,236,193" S="20" P="0">熟练度升级到</T><T C="5,180,0" S="20" P="0">Lv[%d]</T>]],
	DIGGEM_TEXT14 = [[<T C="255,236,193" S="20" P="0">有点累，休息一会，停止挖宝</T>]],
	DIGGEM_TEXT15 = "挖矿时间：",
	DIGGEM_TEXT16 = "挖矿效率：",
	DIGGEM_TEXT17 = "增加熟练度：%d点",
	DIGGEM_TEXT18 = "价格",
	DIGGEM_TEXT19 = 
	[[
	<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> 工具使用说明1.</T><BR></BR>
	<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> 工具使用说明2.</T><BR></BR>
	<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> 工具使用说明3.</T><BR></BR>
	<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> 工具使用说明4.</T><BR></BR>
	]],
	DIGGEM_TEXT20 = "选择工具",
	DIGGEM_TEXT21 = "暂无日志数据",
	DIGGEM_TEXT22 = "宝物图鉴",
	DIGGEM_TEXT23 = "鉴定费用",
	DIGGEM_TEXT24 = "熟练度有几率挖宝得到",
	DIGGEM_TEXT25 = [[<T C="255,236,193" S="20" P="0">一分耕耘一分收获，</T>]],
	DIGGEM_TEXT26 = [[<T C="255,236,193" S="20" P="0">运气不错，</T>]],
	DIGGEM_TEXT27 = [[<T C="255,236,193" S="20" P="0">人品爆发，</T>]],
	DIGGEM_TEXT28 = [[<T C="255,236,193" S="20" P="0">欧皇血统！</T>]],
	DIGGEM_TEXT29 = [[<T C="255,236,193" S="20" P="0">恭喜你，稀世珍宝出世！</T>]],
	DIGGEM_TEXT30 = [[<T C="255,236,193" S="20" P="0">挖到了</T><T C="233,166,62" S="20" P="0">[%s]</T><T C="255,236,193" S="20" P="0">，熟练度</T><T C="5,180,0" S="20" P="0">+%d</T>]],
	DIGGEM_TEXT31 = "宝物鉴定",
	DIGGEM_TEXT32 = "鉴定",
	DIGGEM_TEXT33 = "请选择需要鉴定的宝物",
	DIGGEM_TEXT34 = "是否消耗%d钻石兑换%d矿晶\n今日还可兑换%d次",
	DIGGEM_TEXT35 = "今天的兑换次数已经用完",
	DIGGEM_TEXT36 = "鉴定数量",
	DIGGEM_TEXT37 = "请选择右边的宝物进行鉴定",
	DIGGEM_TEXT38 = "鉴定单价",
	DIGGEM_TEXT39 = "鉴定总价",
	DIGGEM_TEXT40 = "鉴定栏已满，请先进行鉴定吧",
	DIGGEM_TEXT41 = "暂无未鉴定的宝石噢",
	TRANSACTION1 = "交易行",
	TRANSACTION2 = "红宝石",
	TRANSACTION3 = "绿宝石",
	TRANSACTION4 = "黄宝石",
	TRANSACTION5 = "彩色宝石",
	TRANSACTION6 = "普通",
	TRANSACTION7 = "闪亮",
	TRANSACTION8 = "耀眼",
	TRANSACTION9 = "我要购买",
	TRANSACTION10 = "我要出售",
	TRANSACTION11 = "系统回收",
	TRANSACTION12 = "商品分类",
	TRANSACTION13 = "商品列表",
	TRANSACTION14 = "购买数量",
	TRANSACTION15 = "宝物背包",
	TRANSACTION16 = "我出售中的商品",
	TRANSACTION18 = "已卖出:",
	TRANSACTION19 = "上架数量",
	TRANSACTION20 = "上架",
	TRANSACTION21 = "出售单价",
	TRANSACTION22 = "出售总价",
	TRANSACTION23 = "成功售出则收取10%手续费",
	TRANSACTION24 = "矿晶",
	TRANSACTION25 = "下架",
	TRANSACTION26 = 
	[[
	<T C="127,70,26" S="20" P="0">共%s件商品,可回收</T><I Z="0.6">ui/common/common_icon_kuangjing.png</I><T C="127,70,26" S="20" P="0">%s</T>
	]],
	TRANSACTION27 = "回收数量:",
	TRANSACTION28 = "回收单价",
	TRANSACTION29 = "回收总价",
	TRANSACTION30 = "系统只会记录最近50条交易记录",
	TRANSACTION31 = "记录",
	TRANSACTION32 = "交易记录列表",
	TRANSACTION33 =
	[[
	<T C="255,236,193" S="18" P="0">售出</T><T C="99,255,95" S="18" P="0">【%s】*%s</T>
	<T C="255,227,116" S="18" P="0">,成交价%s矿晶,您获得了%s矿晶</T>
	]],
	TRANSACTION34 =
	[[
	<T C="255,236,193" S="18" P="0">售出</T><T C="93,222,254" S="18" P="0">【%s】*%s</T>
	<T C="255,227,116" S="18" P="0">,成交价%s矿晶,您获得了%s矿晶</T>
	]],
	TRANSACTION35 =
	[[
	<T C="255,236,193" S="18" P="0">售出</T><T C="198,130,255" S="18" P="0">【%s】*%s</T>
	<T C="255,227,116" S="18" P="0">,成交价%s矿晶,您获得了%s矿晶</T>
	]],
	TRANSACTION36 =
	[[
	<T C="255,236,193" S="18" P="0">售出</T><T C="233,166,62" S="18" P="0">【%s】*%s</T>
	<T C="255,227,116" S="18" P="0">,成交价%s矿晶,您获得了%s矿晶</T>
	]],
	TRANSACTION37 =
	[[
	<T C="255,236,193" S="18" P="0">买入</T><T C="99,255,95" S="18" P="0">【%s】*%s</T>
	<T C="255,227,116" S="18" P="0">,成交价%s矿晶</T>
	]],
	TRANSACTION38 =
	[[
	<T C="255,236,193" S="18" P="0">买入</T><T C="93,222,254" S="18" P="0">【%s】*%s</T>
	<T C="255,227,116" S="18" P="0">,成交价%s矿晶</T>
	]],
	TRANSACTION39 =
	[[
	<T C="255,236,193" S="18" P="0">买入</T><T C="198,130,255" S="18" P="0">【%s】*%s</T>
	<T C="255,227,116" S="18" P="0">,成交价%s矿晶</T>
	]],
	TRANSACTION40 =
	[[
	<T C="255,236,193" S="18" P="0">买入</T><T C="233,166,62" S="18" P="0">【%s】*%s</T>
	<T C="255,227,116" S="18" P="0">,成交价%s矿晶</T>
	]],
	TRANSACTION41 = "售出",
	TRANSACTION42 = "买入",
	TRANSACTION43 = "购买单价",
	TRANSACTION44 = "购买总价",
	TRANSACTION45 = "矿晶不足",
	TRANSACTION46 = "商品已售完",
	TRANSACTION47 = "上架成功",
	TRANSACTION48 = "上架栏已满",
	TRANSACTION49 = "物品数量不足",
	TRANSACTION50 = "下架成功",
	TRANSACTION51 = "已经被买走",
	TRANSACTION52 = "每次最多回收十件商品",
	TRANSACTION53 = "已出售%s个",
	TRANSACTION54 = "是否下架%s?",
	TRANSACTION55 = "背包已满，下架失败",
	TRANSACTION56 = "总价",
	TRANSACTION57 = "炫丽",
	TRANSACTION_DESC =
	[[
	<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">上架商品后需由其他玩家进行购买交易成功后才可获得矿晶</T><BR>10</BR>
	<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">交易行出售的商品均由玩家上架出售</T><BR>10</BR>
	<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">商品列表的商品每次随机推荐</T><BR>10</BR>
	<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">上架有一定时间限制，超时后将下架该物品</T><BR>10</BR>
	<T C="127,70,26" S="20">5.</T><T C="127,70,26" S="18">低品质的宝石不可上架</T><BR>20</BR>
	<T C="127,70,26" S="20">6.</T><T C="127,70,26" S="18">成功出售后将被系统扣除成交金额的10%作为手续费</T><BR>20</BR>
	<T C="127,70,26" S="20">7.</T><T C="127,70,26" S="18">回收商品是指将商品出售给系统，出售成功即可获得矿晶</T><BR>10</BR>
	]],
	PROMISE_SHRINE_TEXT1 = "原始奖励",
	PROMISE_SHRINE_TEXT2 = "下次许愿倒计时:",
	PROMISE_SHRINE_TEXT3 = "福利倒计时:",
	PROMISE_SHRINE_TEXT4 = "超值充值",
	PROMISE_SHRINE_TEXT5 = "",
	PROMISE_SHRINE_TEXT6 = "充值",
	PROMISE_SHRINE_TEXT7 = "许愿buff生效中：充值任意金额获得奖励噢！",
	PROMISE_SHRINE_TEXT8 = 
	[[
	<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">许愿不消耗任何货币，每日仅可许愿一次</T><BR>10</BR>
	<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">许愿后福利BUFF仅可享用一次</T><BR>10</BR>
	<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">许愿活动结束后将不在出现</T><BR>10</BR>
	<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">许愿活动每日05：00刷新重置</T><BR>10</BR>
	<T C="127,70,26" S="20">5.</T><T C="127,70,26" S="18">许愿后达成对应的充值后将通过邮件发放许愿奖励</T><BR>10</BR>
	]],
	PROMISE_SHRINE_TEXT9 = "首充翻倍",
	PROMISE_SHRINE_TEXT10 = "许愿",
	PROMISE_SHRINE_TEXT11 = "许愿返利", 
	PROMISE_SHRINE_TEXT12 = "许愿池：",
	PROMISE_SHRINE_TEXT13 = "最终收益",
	TDONATE = "体力贡献:",
	LEAGUE_HONOUR_TITLE1 = "第%s届英雄联赛-弹王杯",
	SUMMON_4 = "抽取符文",
	PETDES = 
	[[
	<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> 当宠物资质小于最大值时，可以通过洗练资质重新随机资质.</T><BR></BR>
	<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> 每次洗练需要消耗1枚宠物晶石，可以通过宠物商店获得宠物晶石.</T><BR></BR>
	<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> 当宠物资质为最大值时，无法继续洗练.</T><BR></BR>
	<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> 资质洗练为随机模式，请慎重选择.</T><BR></BR>
	]],
	DIGGEM_TEXT19 =
	[[
	<T C="229,105,22" S="22">挖宝工具</T><BR></BR>
	<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">使用高级工具进行挖宝，收获速度更快，获得熟练度更多，更容易获得高级宝物.</T><BR></BR>
	<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">高级工具持续时间更长.</T><BR></BR>
	<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">购买工具需要消耗矿晶，矿晶可以通过出售、挂售宝物获得.</T><BR></BR>
	<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">停止挖宝会导致时间消耗，需要持续一定时间才能获得宝物，请勿频繁开启停止挖宝.</T><BR></BR>
	<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">宝物背包满格后会自动停止挖宝，为避免损失，请及时处理背包内的道具.</T><BR></BR>
	]],
	DIGGEM_TEXT42 =
	[[
	<T C="229,105,22" S="22">挖宝玩法说明</T><BR></BR>
	<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">使用工具挖宝，可以每隔一定时间获得宝物.</T><BR></BR>
	<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">挖宝可以获得熟练度，达到一定熟练度后挖宝技能升级，可以挖到更好的宝物.</T><BR></BR>
	<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">通过对宝物进行鉴定，可以获得各种宝石、钻石、矿晶、金币.</T><BR></BR>
	<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">除了鉴定，也可以把宝物直接出售给系统或者挂售卖给其他玩家获得矿晶.</T><BR></BR>
	]],
	RUNE_LOCK_TIP = "请先开启上一个符文槽",
	RUNE_OPEN_BY_DIAMONDS = "是否消耗%d钻石提前开启该槽位？",
	RUNE_STORE = "符文商店",
	RUNE_TOTAL_LEVEL = "符文总等级",
	RUNE_ATTRIBUTE = "附加属性",
	FAST_DISASSEMBLE = "一键拆卸",
	RUNE_BAG = "符文背包",
	RUNE_INFO = "符文信息",
	RUNE_EXTRACT = "抽取符文",
	RUNE_LOAD = "装载符文",
	RUNE_ITEM_ATTRIBUTE1 = [[<T C="255,227,116" S="20" P="0">%s         </T><T C="99,255,95" S="20" P="0">+%s</T>]],
	RUNE_ITEM_ATTRIBUTE2 = [[<T C="255,227,116" S="20" P="0">%s    </T><T C="99,255,95" S="20" P="0">+%s</T>]],
	COMMUNITYINFO228 = "设置等级数量必须大于等于%s",
	COMMUNITYINFO229 = "设置VIP等级必须小于等于%s",
	COMMUNITYINFO230 = "设置VIP等级必须大于等于%s",
	COMMUNITYINFO231 = "目标公会需要玩家等级达到%s",
	COMMUNITYINFO232 = "目标公会需要玩家VIP等级达到%s",
	COMMUNITYINFO233 = "目标公会人数已满，加入失败",
	COMMUNITYINFO234 = "%s邀请你加入%s这个公会",
	REVIEW1 = "人工审核",
	REVIEW2 = "自动审核",
	REVIEW3 = "入会角色等级",
	REVIEW4 = "入会角色VIP等级",
	COMMUNITYINFO195 = [[等级/名称/ID]],
	COMMUNITYINFO235 = "无限制",
	COMMUNITYINFO236 = "角色%s级",
	COMMUNITYINFO237 = "入会限制",
	COMMUNITYINFO238 = "公会邀请",
	LUCK_DRAW_ONE = "抽一次",
	LUCK_DRAW_FIVE = "抽五次",
	TO_RUNE_SYSTEM = "前往装备",
	LUCK_DRAW_TIP = "抽五次 必为2-3级符文",
	LUCK_DRAW_TIP2 = "抽五次 必为4-5级符文",
	LUCK_DRAW_TIP3 = "再抽%d次 必为2-3级符文",
	LUCK_DRAW_TIP4 = "再抽%d次 必为4-5级符文",
	UNLOAD_ALL_RUNE = "确定拆卸全部符文？",
	OPERATION_ERROR = "操作失败",
	DIAMONDS_OPEN_SLOT_ERROR_TIP = "钻石开启槽位失败",
	RUNE_BAG_NULL_TIP = "暂无可装载的符文",
	BIG_RUNE_LEVEL ="圣痕 Lv%d",
	RED_RUNE_LEVEL = "(红色符文总Lv%d激活)",
	GREEN_RUNE_LEVEL = "(绿色符文总Lv%d激活)",
	YELLOW_RUNE_LEVEL = "(黄色符文总Lv%d激活)",
	BIG_RUNE_LEVEL_ACT = "(符文总Lv%d激活)",
	RUNE_LEVEL_MAX = "(当前等级已满)",
	RED_RUNE_UPDATE_LEVEL = "(红色符文总Lv%d升级)",
	GREEN_RUNE_UPDATE_LEVEL = "(绿色符文总Lv%d升级)",
	YELLOW_RUNE_UPDATE_LEVEL = "(黄色符文总Lv%d升级)",
	BIG_UPDATE_LEVEL = "(符文总Lv%d升级)",
	BUY_RUNE_STORE_NOT_ENOUGTH = "%s数量不足%d,可前往出售符文获得",
	NOT_RUNE_TO_UNLOAD = "暂无符文可卸载",
	RUNEBOOK1 = "等级筛选",
	RUNEBOOK2 = "批量出售",
	RUNEBOOK3 = "获得符文",
	RUNEBOOK4 = "出售详情",
	RUNEBOOK5 = "点击勾选",
	RUNEBOOK6 = "不会出售已装载的符文",
	RUNEBOOK7 = "全部1级符文",
	RUNEBOOK8 = "出售符文",
	RUNEBOOK9 = "请选择要出售的物品",
	RUNEBOOK10 = "暂未获得该符文",
	RUNEBOOK11 = "符文已装备,是否出售?",
	RUNEBOOK12 = "是否出售该符文?",
	RUNEBOOK13 = "全部2级符文",
	RUNEBOOK14 = "全部3级符文",
	RUNEBOOK15 = "全部4级符文",
	RUNEBOOK16 = "暂无该类型的符文",
	RUNEBOOK17 = "没有符文可以出售",
	RUNEBOOK18 = "出售失败",
	PVPRANK_PROTECTED_ATT1 = "差%d分开启段位保护",
	PVPRANK_PROTECTED_ATT2 = "段位保护已开启",
	BATTLE_RANK_LOSE_TIPS = "勇者积分不足保护失败",
	BATTLE_RANK_LOSE_TIPS2 = "段位保护开启",
	BATTLE_RANK_LOSE_TIPS3 = "积分升级抵挡扣星",
	BATTLE_RANK_WIN_TIPS = "积分满，额外增加一星",
	BATTLE_RANK_COMMON_TIPS = "积分满%d=1颗星",
	BATTLE_RANK_LOSE_ICON_TIPS1 = "青铜段位保护，段位不变",
	BATTLE_RANK_LOSE_ICON_TIPS2 = "勇者积分奖励，抵消扣星",
	BATTLE_RANK_LOSE_ICON_TIPS3 = "勇者积分保护，段位不变",
	OWNMOUNT = "已拥有该坐骑，是否继续购买？",
	OWN1 = "已拥有%s，是否继续购买？",
	VOICE_CHAT_NOT_SUPPORT = "此版本不支持语音功能，请更新到最新版本",
	LUCKYGIFT3 = "%d折",
	LUCKYGIFT4 = "随机",
	FAKEROOM = "该房间无法加入",
	VOICE_CLICKMORE = "请勿频繁点击语音聊天按钮",
	VOICE_RECORDING_ERROR = "语音聊天场景内无法使用录音功能",
	VOICE_RECORDING_ERROR2 = "使用了实时语聊，暂无法播放语音",
	ACTIVITYCLOSE = "活动未开启",
	VOICE_NOSUPPORT = "该功能需要安装最新游戏包才可使用，请前往下载安装",
	CANTBUY = "对不起,该物品无法购买.",
	VOICE_OPENSTR= "当前语音功能已关闭，确定打开语音功能？",
	CANTOPER = "更高级权限者在线，无法进行公会任务操作",
	INPUT_KEY_SEARCH = "输入关键字搜索",
	INPUTRECT_NULL_ATT = "请输入好友ID或名字中的关键字进行查询",
	SEARCH_NO_RESULT = "没有查询到合适的目标哦",
	LOAD_SLOT_NULL_TIP = "没有空的槽位可装载",
	RANK32 = "32强",
	BUY_FIVEGEM_ATTENTION = [[<T C="255,236,193" S="20" P="0">连续购买 </T><T C="233,166,62" S="20" P="0">%d 次</T><T C="255,236,193" S="20" P="0">矿晶</T>]],
	BUY_TIMES = "买%d次",
	DRAW_RUNE_ERROR = "符文抽奖失败",
	LEAGUE114 = [[三十二强]],
	RUNE_EXPLAIN = 
	[[
	<T C="229,105,22" S="22">符文系统</T><BR>5</BR>
	<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> 随着等级提升，会逐渐开放更多的槽位。</T><BR></BR>
	<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> 可以花费钻石提前开启符文槽位，但不会改变其他槽位的开启等级。</T><BR></BR>
	<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> 对应种类符文达到一定等级，可以激活对应的圣痕，获得额外的属性加成。</T><BR>20</BR>
	<T C="229,105,22" S="22">符文获得</T><BR>5</BR>
	<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> 符文抽奖可以获得符文。</T><BR></BR>
	<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> 符文商店有售卖符文。</T><BR>20</BR>
	<T C="229,105,22" S="22">符文回收</T><BR>5</BR>
	<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> 可以通过出售功能，把多余的符文卖掉，获得符文碎片。</T><BR></BR>
	<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> 符文碎片可以用于符文商店购买。</T><BR></BR>
	]],
	PHANTOM1 = "幻化",
	PHANTOM2 = "幻化宝箱",
	PHANTOM3 = "幻力",
	PHANTOM4 = [[<T C="255,236,193" S="21" SC="79,60,48" SE="1" SS="4">有几率获得</T><T C="99,255,95" S="21" SC="79,60,48" SE="1" SS="4">普通皮肤</T>]],
	PHANTOM5 = [[<T C="255,236,193" S="21" SC="79,60,48" SE="1" SS="4">有几率获得</T><T C="93,222,254" S="21" SC="79,60,48" SE="1" SS="4">勇者皮肤</T>]],
	PHANTOM6 = [[<T C="255,236,193" S="21" SC="79,60,48" SE="1" SS="4">有几率获得</T><T C="198,130,255" S="21" SC="79,60,48" SE="1" SS="4">史诗皮肤</T>]],
	PHANTOM7 = "有几率获得传说皮肤",
	PHANTOM8 = "幻力值",
	PHANTOM9 = "使用体验卡",
	PHANTOM10 = "幻化之力",
	PHANTOM11 = "体验卡",
	PHANTOM12 = "普通",
	PHANTOM13 = "勇者",
	PHANTOM14 = "史诗",
	PHANTOM15 = "传说",
	PHANTOM16 = "幻化皮肤",
	PHANTOM17 = "幻化成功",
	PHANTOM18 = "体验时间%d天",
	PHANTOM19 = "剩余体验时间",
	PHANTOM_DESC =
	[[
	<T C="229,105,22" S="22">幻化</T><BR>5</BR>
	<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> 皮肤激活后，可以进行幻化。</T><BR></BR>
	<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> 幻化后可改变角色外观，并获得皮肤的效果加成。</T><BR></BR>
	<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> 取消勾选展示皮肤，则皮肤外观不会展示出来。</T><BR></BR>
	<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> 只有永久激活的皮肤才能获得幻力值，幻力值用于提升幻化之力等级。</T><BR></BR>
	]],
	PHANTOM20 = "开启宝箱",
	PHANTOM21 = "普通宝箱",
	PHANTOM22 = "稀有宝箱",
	PHANTOM23 = "史诗宝箱",
	PHANTOM_CHEST_DESC =
	[[
	<T C="229,105,22" S="22">幻化宝箱</T><BR>5</BR>
	<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> 消耗一定数量的幻化晶石可以打开幻化宝箱</T><BR></BR>
	<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> 打开幻化宝箱有概率获得永久皮肤</T><BR></BR>
	<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> 重复获得永久皮肤会转化为幻化晶石</T><BR></BR>
	]],
	PHANTOM24 = "已拥有该皮肤,转化为",
	COMMENT1 = "喜欢这个游戏吗？来评价一下你对这游戏的感觉吧！",
	COMMENT2 = "马上评价",
	COMMENT3 = "下次再说",
	COMMENT4 = "残忍拒绝",
	TABOO_BOX_OPEN_NOW = "立即开启",
	TABOO_BOX_OPEN_LOCK = "点击解锁",
	TABOO_BOX_OPEN = "点击开启",
	TABOO_BOX_EMPTY = "空箱位",
	TABOO_BOX_GET_DES = "可能获得以下内容",
	TABOO_BOX_TITLE1 = "解锁宝箱",
	TABOO_BOX_TITLE2 = "开启宝箱",
	TABOO_BOX_TITLE3 = "惊喜宝箱",
	TABOO_BOX_OPEN_START = "开始解锁",
	TABOO_BOX_OPEN_CANCEL = "丢弃",
	TABOO_BOX_OPEN_CANCEL2 = "放弃新宝箱",
	TABOO_BOX_OPEN_CANCEL = "丢弃\n(丢弃就没了)",
	TABOO_BOX_OPEN_COMMON_DES = "运气不错，捡到一个惊喜宝箱噢！",
	TABOO_BOX_DISCARD = "是否丢弃该宝箱？\n（丢弃后不可找回噢）",
	TABOO_DICE_RUSH = "恢复倒计时:",
	TABOO_BOX_OUT = "宝箱位不足，没有得到这个宝箱",
	TABOO_EVENT_1 = "得到了%d个骰子",
	TABOO_EVENT_2 = "前进%d步",
	TABOO_EVENT_3 = "后退%d步",
	TABOO_EVENT_4 = "传送到了其他位置",
	TABOO_EVENT_5 = "清除了宝箱解锁时间",
	TABOO_BOX_OPENING = "只能同时解锁一个宝箱噢",
	TABOO_BOX_OPEN_COMMON_DES_1 = "宝箱栏已满，立即解锁已解锁的宝箱可获得新宝箱",
	TABOO_BOX_OPEN_COMMON_DES_2 = "宝箱栏已满，立即开启解锁中的宝箱可获得新宝箱",
	BUY_FIVETOUZI_ATTENTION = [[<T C="255,236,193" S="20" P="0">连续购买 </T><T C="233,166,62" S="20" P="0">%d 次</T><T C="255,236,193" S="20" P="0">骰子</T>]],
	PHANTOM25 = "未使用",
	TABOO_DIR_FRONT = "前进",
	TABOO_DIR_BACK = "后退",
	PHANTOM26 = "皮肤碎片",
	PHANTOM27 = "皮肤",
	PHANTOM28 = "取消幻化成功",
	TABOO_CELL_END = "终点",
	PHANTOM29 = "被动效果",
	PHANTOM30 = "展示皮肤",
	PHANTOM31 = "请先进行幻化",
	TABOO_BOX_OPEN_ALREADY = "已解锁",
	TABOO_DESC = 
	[[
	<T C="229,105,22" S="22">禁忌之地</T><BR>5</BR>
	<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> 禁忌之地每次消耗1个骰子</T><BR></BR>
	<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> 禁忌之地骰子每隔60分钟恢复1颗，达到上限后不再恢复</T><BR></BR>
	<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> 不同的章节的宝箱产出不同的皮肤。</T><BR></BR>
	<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> 宝箱栏只有3个，所有章节共享栏位，栏位满了后不能获得新的宝箱，除非将已在解锁或已解锁的宝箱立即开启</T><BR></BR>
	<T C="255,89,74" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0"> 每日可购买骰子，不同VIP等级可购买骰子数量上限不同，购买消耗每日24点刷新</T><BR></BR>
	<T C="255,89,74" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0"> 开启宝箱需要一定冷却时间，品质越好的宝箱所需时间越久，内容也更丰富</T><BR></BR>
	]],
	SECTION_WORD = "第%d章",
	WEEK_DAY = "周卡剩余时间",
MULTI_ROOM_EMPTY = "房间不存在",
NOORANGE = "尚未拥有橙色装备",
WAKEUP_TEXT1 = {"觉醒进阶", "觉醒之魂", "觉醒之体", "觉醒之力", "觉醒之技"},
WAKEUP_TEXT2 = {"一阶.魂", "二阶.体", "三阶.力", "四阶.技"},
WAKEUP_TEXT3 = "觉醒条件",
WAKEUP_TEXT4 = "觉醒消耗",
WAKEUP_TEXT5 = "觉醒",
WAKEUP_TEXT6 = {"激活-觉醒之魂", "激活-觉醒之体", "激活-觉醒之力", "激活-觉醒之技"},
WAKEUP_TEXT7 = {"觉醒之魂已激活", "觉醒之体已激活", "觉醒之力已激活", "觉醒之技已激活"},
WAKEUP_TEXT8 = "已达成",
WAKEUP_TEXT9 = {"普通培养", "中级培养", "高级培养", "超级培养"},
WAKEUP_TEXT10 = "升级可获得%d天赋点",
WAKEUP_TEXT11 = "天赋点",
WAKEUP_TEXT12 = "每次培养消耗%d道具",
WAKEUP_TEXT13 = "前往幻化",
WAKEUP_TEXT14 = "完全觉醒 %s 后可领取",
WAKEUP_TEXT15 =
[[
<T C="229,105,22" S="22">觉醒系统</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">通过完成4个阶段的觉醒，可以分别开放4个功能.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">《一阶.魂》完成后开启觉醒之魂功能，觉醒之魂的等级是后续觉醒的条件之一.</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">《二阶.体》完成后，可获得永久觉醒皮肤.</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">后续2个阶段尚未开放，敬请期待.</T><BR></BR>
]],
WAKEUP_TEXT16 = "【条件%d】",
WAKEUP_TEXT17 = "先努力升级吧，少年",
WAKEUP_TEXT18 = "请先完成所有觉醒条件",
WAKEUP_TEXT19 = "经验",
WAKEUP_TEXT20 = 
[[
<T C="229,105,22" S="22">觉醒之魂</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">完成《一阶.魂》后开启觉醒之魂功能.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">觉醒之魂可以通过使用觉醒之晶培养获得经验，从而提升等级.</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">觉醒之魂升级后，可以获得更高属性加成，同时能获得天赋点数.</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">觉醒之魂的等级是后续觉醒条件之一，需要达到一定觉醒之魂等级才能继续觉醒.</T><BR></BR>
]],
WAKEUP_TEXT21 = 
[[
<T C="229,105,22" S="22">觉醒之体</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">完成《二阶.体》后开启觉醒之体功能.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">通过觉醒之体功能，玩家可以获得觉醒永久皮肤一套.</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">觉醒皮肤美观大方，技能实用，实为居家旅行，必备良品.</T><BR></BR>
]],
WAKEUP_TEXT22 = 
[[
<T C="229,105,22" S="22">觉醒之力</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">完成《三阶.力》后开启觉醒之力功能.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">通过觉醒之力功能，可以使用天赋点，学习天赋，获得道具奖励或者属性加成.</T><BR></BR>
]],
WAKEUP_TEXT23 = 
[[
<T C="229,105,22" S="22">觉醒之技</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">完成《四阶.技》后开启觉醒之技功能.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">通过觉醒之技，可以学习各种强力觉醒技能，在战斗中使用.</T><BR></BR>
]],
PROPERTYINFO1 = "属性信息",
EXTRACTION_TEXT1 = "萃取",
EXTRACTION_TEXT2 = "符文",
EXTRACTION_TEXT3 = "祝福",
EXTRACTION_TEXT4 = "自动添加",
EXTRACTION_TEXT5 = "萃取单价",
EXTRACTION_TEXT6 = "萃取总价",
ONE_YEAR_ACTIVITY = "喜庆礼包",
INTEGRAL_VALUE = "积分值",
FIREWORKS_LIST = "烟花榜奖励",
RANK_VALUE = "%d到%d",
NEWYEARTIP10 = "燃放烟花",
NEWYEARTIP6 = "本次登录不看烟花",
NEWYEARTIP1 = "普通烟花",
NEWYEARTIP2 = "大型烟花",
NEWYEARTIP3 = "豪华烟花",
NEWYEARTIP4 = "烟花冷却中:",
NEWYEARTIP5 = "规则:耗费钻石可以播放1次全服烟花特效",
NEWYEARTIP7 =
[[
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">时间:每日</T>
<T C="99,255,95" S="20" P="1" SC="79,60,48" SE="1" SS="4">%s</T>
<T C="99,255,95" S="20" P="1" SC="79,60,48" SE="1" SS="4">%s</T>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">整点，只要在主城即可领取红包，每次红包雨只可领取一个红包，一天可领取</T>
<T C="99,255,95" S="20" P="1" SC="79,60,48" SE="1" SS="4">%s</T>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">个红包，使用红包可随机获得</T>
<I Z="0.8" P="1">ui/common/common_icon_zuanshi.png</I>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">奖励。</T>
]],
NEWCOMMUNITY1 = "等级:",
NEWCOMMUNITY2 = "管理",
EXTRACTION_TEXT7 = {"暂无可萃取的符文", "暂无可萃取的装备", "暂无可萃取的宠物", "暂无可萃取的祝福"},
EXTRACTION_TEXT8 = "萃取费用",
PLAY_FIREWORKS_CLOSE = "烟花活动已结束",
EXTRACTION_TEXT9 = "前往合成",
EXTRACTION_TEXT10 = "前往萃取",
EXTRACTION_TEXT11 = "觉醒之晶解析",
NEWCOMMUNITY3 = "邀请加入",
NEWCOMMUNITY4 = "移除勾选",
RECHARGE_VALUE_TIP = "充值对应金额即可获得该礼包，每个礼包只可购买一次哦！",
LOGIN_COUNT_SEVEN_TIP = "活动累计7天登录即可获得专属称号",
ONE_YEAR_DES =
[[
<T C="229,105,22" S="22">周年登录说明</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">每日登录签到即可获得奖励</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">每个奖励只可获得一次</T><BR>20</BR>
<T C="229,105,22" S="22">喜庆礼包说明</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">周年活动期间可购买超值大礼包</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">每个礼包只可购买一次</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">超值的喜庆礼包不会增加VIP经验</T><BR>20</BR>
<T C="229,105,22" S="22">充值双倍说明</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">周年活动重置了首次充值双倍状态，充值后可获得双倍或三倍的奖励</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">每个档位的充值只可获得一次翻倍状态</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">充值双倍活动于2017年6月16日重置</T><BR>20</BR>
<T C="229,105,22" S="22">口令红包说明</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">可在聊天频道发言输入指定内容即可获得奖励</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">每日可领取5个口令红包，每个口令红包之间有一定冷却时间</T><BR>20</BR>
<T C="229,105,22" S="22">欢乐烟花说明</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">燃放烟花可被其他所有玩家看到</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">燃放烟花可获得积分，根据积分进行排名</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">活动结束前一段时间将停止放烟花功能，活动结束后通过邮件发放排名奖励</T><BR>20</BR>
<T C="229,105,22" S="22">神秘活动说明</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">神秘活动将在指定日期开启，敬请期待</T><BR></BR>
]],
RECHARGE_DOUBLE = "充值翻倍",
RECHARGE_DOUBLE_RULE = "规则：每个档位只可获得1次充值翻倍奖励",
REDPACK_ATT22 = "今日还可领取红包：%d/%d",
GO_TO_WISHING = "前往许愿",
WISHING_COME_BACK = "许愿归来",
WISHING_NOT_OPEN_TITLE = "神秘喜庆",
WISHING_ONE_YEAR_TIP = "欢度一周年，许愿池再次降临",
PASS_OVER = "已领完",
NEWCOMMUNITY5 = "移除",
NEWCOMMUNITY6 = "确定要把勾选的人员移出公会吗？",
NEWCOMMUNITY7 = "公会战尚未开启",
NEWCOMMUNITY8 = "权限不足",
NEWCOMMUNITY9 = "入会设置",
NEWCOMMUNITY10 = "审核类型",
NEWCOMMUNITY11 = "限制条件",
NEWCOMMUNITY12 = "玩家/职务",
ANNIV_END = "周年活动已结束",
ANNIV_END2 = "周年活动6月16日开启噢",
WAKEUP_TEXT24 = 
[[
<T C="229,105,22" S="22">觉醒之魂</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">完成《一阶.魂》后开启觉醒之魂功能.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">觉醒之魂可以通过消耗觉醒之晶培养，提升等级.</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">提升觉醒之魂等级可获得大量属性加成，获得天赋点.</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">觉醒之魂等级也是后续觉醒条件之一.</T><BR></BR>
]],
WAKEUP_TEXT25 = 
[[
<T C="229,105,22" S="22">觉醒之体</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">完成《二阶.体》后开启觉醒之体功能.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">觉醒之体开通后，可领取一套觉醒专属皮肤.</T><BR></BR>
]],
WAKEUP_TEXT26 = 
[[
<T C="229,105,22" S="22">觉醒之力</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">完成《三阶.力》后开启觉醒之力功能.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">开启觉醒之力后，可消耗天赋点学习大量有趣实用的天赋.</T><BR></BR>
]],
WAKEUP_TEXT27 = 
[[
<T C="229,105,22" S="22">觉醒之技</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">完成《四阶.技》后开启觉醒之技功能.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">开启觉醒之技后，可学习超酷炫超强觉醒技能，战斗中可用.</T><BR></BR>
]],
ACTIVITY_START_TITLE = "周年活动预告（活动于6月16日开启）",
ACTIVITY_START_TIP_1 = "1.登录送大礼（海量钻石，金币，周年专属称号）",
ACTIVITY_START_TIP_2 = "2.周年口令祝福（一言不合就送616钻！）",
ACTIVITY_START_TIP_3 = "3.周年大礼包（限量橙色皮肤首发！）",
ACTIVITY_START_TIP_4 = "4.烟花庆典（漫天烟花献大礼）",
ACTIVITY_START_TIP_5 = "更多神秘活动，就在616",
WECHATTIPS1 = "分享可获得以上奖励",
WECHATTIPS2 = "完成每日分享任务可获得奖励",
Promise1 = 
[[
<T C="255,227,116" SC="79,60,48" SS="4" S="22" P="1" SE="1">充值任意金额即可额外获得</T>
<T C="93,222,254" SC="79,60,48" SS="4" S="30" P="1" SE="1">%d</T>
<T C="255,227,116" SC="79,60,48" SS="4" S="22" P="1" SE="1">倍钻石福利噢</T>
]],
WAKEUP_TEXT28 = "请选择需要萃取的物品",
WAKEUP_TEXT29 = "请选择右边的物品进行萃取",
WAKEUP_TEXT30 = "萃取栏已满，请先进行萃取吧",
SEND_FIREWORK_TIP = "正在播放烟花中,晚点再放哦",
CLICK_TO_OPEN_REDBOX = "点击打开红包",
WAKEUP_TEXT31 = "所有物品都已经在萃取栏了",
WAKEUP_TEXT32 = "没有物品可以添加",
WAKEUP_TEXT33 = "高品质物品无法自动添加",
WAKEUP_TEXT34 = "你有高品质的物品将被萃取，是否继续萃取？",
WAKEUP_TEXT35 = "激活奖励属性",
TIPS11 = [[<T C="138,122,106" S="20" P="0">未觉醒</T>]], 
TIPS12 = [[%d阶]], 
TIPS13 = [[觉醒进阶:]],
TIPS14 = [[觉醒之魂:]],
LEAGUE_NOT_SEND = "未发放",
ACTIVITY_YEAR_END = "该活动已结束",
RECHARGE_YEAR_ACTIVITY_BAG = "已进行购买操作，请等待处理",
COMPETE_TASK_NO_DATA = "已经完成了所有的目标",
WAKEUP1 = "使用记录",
WAKEUP2 = "使用5次",
WAKEUP3 = [[<T C="195,171,148" S="22" P="0">第%d次，%d->%d，未暴击，获得经验%d</T>]],
WAKEUP4 = [[<T C="195,171,148" S="22" P="0">第%d次，%d->%d，暴击X%d，获得经验%d</T>]],
WAKEUP5 = [[<T C="195,171,148" S="22" P="0">使用%d次，觉醒之魂提升了%d级，共获得经验%d </T>]],
TICKET_NOT_ENOUGH = "礼钻不足，是否用%d钻石代替？",
ITEM_LIST = "物品列表",
SETTING_COMMENT = "前往评论:",
WAKEUP6 = "觉醒之晶",
ORANGE_COLOR = "橙",
PURPLE_COLOR = "紫",
BLUE_COLOR = "蓝",
GREEN_COLOR = "绿",
FRAGMENT = "碎片",
HANDLE_PRODUCT = "手腕",
ITEM1 = "消耗物",
ITEM2 = "社交道具",
ITEM3 = "脸部",
ITEM4 = "均衡型",
ITEM5 = "攻击型",
ITEM6 = "防御型",
ITEM7 = "生命型",
ITEM8 = "锻造",
ITEM9 = "道具碎片",
ITEM10 = "皮肤碎片",
ITEM11 = "时装碎片",
ITEM12 = "装备碎片",
CURRENT_TYPE = "(当前)",
ONLINE_REWARD_RECEVICED = "今天在线奖励已领完",
FAST_GET_ITEM = "暂无获得途径",
CONSUME_FIRST = "优先消耗%s",
ZHANYANGTIME = "今天已经瞻仰过图腾",
GAME_ACTIVITY_TITLE46 = "累计消费",
GAME_ACTIVITY_TITLE47 = "折扣限购",
GAME_ACTIVITY_TITLE48 = "新品打折",
GAME_ACTIVITY_TITLE49 = "优惠礼包",
NEWBAG1 = "衣橱",
NEWBAG2 = "防具",
NEWBAG3 = "时装背包",
NEWBAG4 = "幻化战力:",
NEWBAG5 = "一键装备",
NEWBAG6 = "装备属性",
NEWBAG7 = "装备战力:",
RUNE_FIGHT = "符文战力",
NEWBAG8 = "耳坠",
NEWBAG9 = "副手",
NEWBAG11 = "衣橱战力:",
DESIGNATION_NO_POINT = "没有成就点",
SUMMER_VACTION_DES =
[[
<T C="229,105,22" S="22">夏日专属</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">夏日专属皮肤购买后可获得额外钻石</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">夏日专属皮肤只可购买一次（订单延迟时请不要重复付款）</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">购买专属皮肤不会增加VIP经验</T><BR>20</BR>
<T C="229,105,22" S="22">夏日盛惠</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">夏日盛惠各礼包每日限购1个（订单延迟时请不要重复付款）</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">夏日盛惠的礼包每日24点重置购买次数</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">超值的盛惠礼包不会增加VIP经验</T><BR>20</BR>
<T C="229,105,22" S="22">夏日赏金</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">赏金通缉怪每日随机刷新出4只（24点重置）</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">击杀指定数量的通缉怪后可完成任务领取奖励（扫荡不记入）</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">通缉的怪物在组队完成的击杀情况下，队员皆算作完成击杀</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">全服赏金值根据个人击杀的赏金值进行累加，达到一定值后需手动领取对应的阶段奖励</T><BR>20</BR>
<T C="229,105,22" S="22">夏日放价</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">夏日放价有限购数量，达到指定数量后不可再购买</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">夏日放价的商品隔一段时间会上架新的物品</T><BR>20</BR>
]],
FULL_SERVICE_SCORE = "全服赏金点",
THE_WANTED = "今日通缉",
BOUGHT = "已购买",
KILL_REWARD_TIP = "击杀通缉犯可获得赏金点，全服赏金点达到%d时可领取奖励",
BUY_SKIN_GET = "购买皮肤赠送",
BOUNTY = "赏金点:",
SUMMER_VACTION_1 = "夏日专属",
SUMMER_VACTION_2 = "夏日盛惠",
SUMMER_VACTION_3 = "夏日赏金",
SUMMER_VACTION_4 = "夏日放价",
SUMMER_VACTION_DES_1 = "夏日皮肤冰爽来袭",
SUMMER_VACTION_DES_2 = "购物盛会实惠多",
SUMMER_VACTION_DES_3 = "齐心协力赢厚礼",
SUMMER_VACTION_DES_4 = "“冰点价”大促销",
SUMMER_VACTION_START_T = "精彩活动%s开启",
SHOPBUY1 = "购物车共%s件%s商品,需支付",
SUMMER_END = "夏日庆典已结束",
COPY_CHAPTER_NOT_OPEN_TIP = "目标章节未开启",
SUMMER_BUY_FASHION_TIP = "夏日狂欢，限时出售",
WARN_DESC1 = [[<T C="255,236,193" S="12" P="0" SC="138,122,106" SE="1" SS="2">抵制不良游戏 拒绝盗版游戏 注意自我保护 谨防受骗上当 适度游戏益脑 沉迷游戏伤身 合理安排时间 享受健康生活</T>]],
WARN_DESC2 = [[<T C="255,236,193" S="12" P="0" SC="138,122,106" SE="1" SS="2">文网游备案：文网游备字[2016]M-CSG 0348号 审批文号：新广出审[2016]1266号</T>]],
WARN_DESC3 = [[<T C="255,236,193" S="12" P="0" SC="138,122,106" SE="1" SS="2">网络游戏出版物号：ISBN 978-7-7979-0084-3 著作权号：2015SR235509 著作人：珠海网易达电子科技发展有限公司 出版单位名称：上海科学技术文献出版社有限公司</T>]],
DECOMPRESSION = "资源解压中，请耐心等待",
ACTIVITY_RECHARGELEVEL = "充值档位",
ACTIVITY_RECHARGE_MONEY = "充值%s",
ACTIVITY_RECHARGELEVEL_DESC = "充值当前档位即可领取当前奖励哦！",
IS_COST_MONEY = "消耗%d钻石，是否继续?",
}