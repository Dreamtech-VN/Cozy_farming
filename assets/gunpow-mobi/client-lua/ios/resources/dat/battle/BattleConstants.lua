--BattleConstants.lua
--TaoYinqing
--@战斗场景种的一些常量值

BattleConstants = {
    g_heroScale = 0.52, --玩家缩放比例
    g_fShakeHandsTime = 10,                     --心跳协议时间间隔
    g_nGravity  = {x = 0 , y = -1 * 3 },            --重力加速度(子弹加速度一律用“飞行重力加速度”)
    
    g_nFlySpeed = 9,                            --飞行速度
    g_nShootSpeed = 3,                            --射击速度
	g_nFlyGravity = {x = 0 , y = -0.16 * 3 * 3},       --飞行重力加速度


    g_nE_COLLISION_POINT = 0,                   --点碰撞
    g_nE_COLLISION_CIRCLE = 1,                  --圆碰撞

    g_nBATTLE_TYPE_NORMAL = 0,	                --普通房间类型
    g_nBATTLE_TYPE_BOSS = 1,	                --副本房间类型

    g_fWB_SCATTER_ANGLE = 8,                    --子弹散射角度
    g_fWB_TRACK_DIS = 200,                      --子弹追踪距离
    g_fWB_TRACK_SPEED = 30,                     --子弹追踪速度

    g_fWB_PET_SHOOT_SPEED = 20,                 --宠物子弹射击速度

    --大招类型
    g_fWB_BIGSHKILL_TYPE_REPEAT = 0,            --连续大招
    g_fWB_BIGSHKILL_TYPE_BIG = 1,               --威力大招
    g_fWB_BIGSHKILL_TYPE_FOLLOW = 2,            --追踪大招

    g_fWB_SPATTER_PROTECT_TIME = 5,            --溅射弹保护时间

    --战斗模式识别码  1:竞技,2:复活
    g_tBattleMode = {MODE_SPORTS = 1,MODE_RELIFE = 2},
    --[[
      /** 战斗类型:英雄联赛海选赛频道 */
    public static final int       BATTLE_CHANNEL_HERO                   = 8;
    /** 战斗类型:英雄联赛小组赛频道 */
    public static final int       BATTLE_CHANNEL_HERO_STRONG            = 9;
    /** 战斗类型:英雄联赛小组赛三十二强第一次频道 */
    public static final int       BATTLE_CHANNEL_THIRTYTWO_STRONG_ONE   = 10;
    /** 战斗类型:英雄联赛小组赛三十二强第二次频道 */
    public static final int       BATTLE_CHANNEL_THIRTYTWO_STRONG_TWO   = 11;
    /** 战斗类型:英雄联赛小组赛三十二强第三次频道 */
    public static final int       BATTLE_CHANNEL_THIRTYTWO_STRONG_THREE = 12;
    /** 战斗类型:英雄联赛小组赛十六强第一次频道 */
    public static final int       BATTLE_CHANNEL_SIXTEEM_STRONG_ONE     = 13;
    /** 战斗类型:英雄联赛小组赛十六强第二次频道 */
    public static final int       BATTLE_CHANNEL_SIXTEEM_STRONG_TWO     = 14;
    /** 战斗类型:英雄联赛小组赛十六强第三次频道 */
    public static final int       BATTLE_CHANNEL_SIXTEEM_STRONG_THREE   = 15;
    /** 战斗类型，16、英雄联赛小组赛八强第一次频道 */
    public static final int       BATTLE_CHANNEL_EIGHT_STRONG_ONE       = 16;
    /** 战斗类型，17、英雄联赛小组赛八强第二次频道 */
    public static final int       BATTLE_CHANNEL_EIGHT_STRONG_TWO       = 17;
    /** 战斗类型，18、英雄联赛小组赛八强第三次频道 */
    public static final int       BATTLE_CHANNEL_EIGHT_STRONG_THREE     = 18;
    /** 战斗类型，19、英雄联赛小组赛四强第一次频道 */
    public static final int       BATTLE_CHANNEL_FOUR_STRONG_ONE        = 19;
    /** 战斗类型，20、英雄联赛小组赛四强第二次频道 */
    public static final int       BATTLE_CHANNEL_FOUR_STRONG_TWO        = 20;
    /** 战斗类型，21、英雄联赛小组赛四强第三次频道 */
    public static final int       BATTLE_CHANNEL_FOUR_STRONG_THREE      = 21;
    /** 战斗类型，22、英雄联赛小组赛八强频道 */
    public static final int       BATTLE_CHANNEL_FINAL_ONE              = 22;
    /** 战斗类型，23、英雄联赛小组赛四强频道 */
    public static final int       BATTLE_CHANNEL_FINAL_TWO              = 23;
    /** 战斗类型，24、英雄联赛小组赛终战频道 */
    public static final int       BATTLE_CHANNEL_FINAL_THREE            = 24;
    BATTLE_CHANNEL_GUILD_WAR 25 公会战（淘汰赛）
    BATTLE_CHANNEL_HERO_MELEE_WAR 26 混战
    MODE_TEAM_RM_WAR 27    --三人排位赛
    MODE_ITEM_WAR 28 --道具赛
    MODE_CAPTAIN_WAR 29 队长赛
    MODE_REBORN_WAR 30 复活
    MODE_DIGHOLE_WAR 31 挖坑
    MODE_GUILD_WAR_CX 32 公会战出线赛
    MODE_GUILD_WAR_RW 33 公会战入围赛
    MODE_GUILD_WAR_TT 25 公会战（淘汰赛）
    ]]
        --战斗频道识别码 ,1:积分2:练习赛,5:排位赛,6:公会,7:弹王挑战赛
    g_tBattleChannel = {MODE_POINT_RACE = 1,MODE_EXERCISE = 2,MODE_QULIFYING=5,MODE_GUILD=6,
    MODE_KINGBATTLE=7,MODE_HERO = 8,MODE_HERO_STRONG = 9,MODE_THIRITYTWO_STRONE_ONE = 10,
    MODE_THIRITYTWO_STRONE_TWO = 11,MODE_THIRITYTWO_STRONE_THREE = 12,MODE_SIXTEEM_STRONG_ONE = 13,
    MODE_SIXTEEM_STRONG_TWO = 14,MODE_SIXTEEM_STRONG_THREE = 15,MODE_EIGHT_STRONG_ONE = 16,
    MODE_EIGHT_STRONG_TWO = 17,MODE_EIGHT_STRONG_THREE = 18,MODE_FOUR_STRONG_ONE = 19,
    MODE_FOUR_STRONG_TWO = 20,MODE_FOUR_STRONG_THREE = 21,MODE_FINAL_ONE = 22,
    MODE_FINAL_TWO = 23,MODE_FINAL_THREE = 24,
    BATTLE_CHANNEL_HERO_MELEE_WAR = 26,MODE_TEAM_RM_WAR = 27,MODE_ITEM_WAR = 28,
    MODE_CAPTAIN_WAR = 29,MODE_REBORN_WAR = 30,MODE_DIGHOLE_WAR =31,MODE_GUILD_WAR_CX = 32,
    MODE_GUILD_WAR_RW = 33,MODE_GUILD_WAR_TT = 25,
    },

    --副本战斗模式识别码  0:普通,1:小副本,2:大副本,3:单人地狱副本
    g_tBossBattleMode = {MODE_NORMAL = 0,MODE_BOSSMAP_1 = 1,MODE_BOSSMAP_2 = 2,
    MODE_NORMAL_HARD = 3,MODE_NORMAL_TABOO = 4, MODE_WORLDBOSS=5,MODE_SINGLE_STAGE=7,MODE_DAILY_STAGE=8,
    MODE_TOWER_STAGE=9,MODE_LOVE_STAGE = 10,MODEL_GUILD_STATE = 11,MODE_WORLDTEAMBOSS=12},


    --操作范围增加基数
    g_nTouchDistance = 360,
    --距离边缘值1
    g_nEdgeValue1 = -1000,
    --距离边缘值2
    g_nEdgeValue2 = -2000,
}

