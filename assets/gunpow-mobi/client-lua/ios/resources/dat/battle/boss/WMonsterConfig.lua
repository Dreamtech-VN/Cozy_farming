--WMonsterConfig.lua
--@brief    WMonsterConfig
--@date     2015/4/8
--@author   莫剑峰
--@note     怪物的配置表 

-- --技能选择目标配置
-- ChooseTargetConfig =
-- {
--     RANDOM = 1, --随机目标
--     NEAREST = 2,
--     FAREST = 3,
--     HP_MAX = 4,
--     HP_MIN = 5,
--     NEAR_BOSS_LIST = 6,
--     NEAR_POSITION_LIST = 7,
--     ALL_HERO = 8,
--     MYSELF = 9, --自身
--     ALL_BOSS = 10,
--     DISTANCE_X = 11, --x距离判断
--     DISTANCE = 12,--距离判断

--     TARGET_IN_RECT = 18,    --目标范围内（18,x,y,w,h）
--     DISTANCE_TEAM_POS = 19, --指定位置范围的目标（19,teamType,distance) -- teamtype：0队友 1敌方；distance：范围
-- }

--AI条件配置
AiConditionConfig =
{
    ACTIVE_ATTACK = 1,      --主动攻击
    PASSIVE_ATTACK = 2,     --被动攻击
    ATTACK_TURN = 3,        --攻击回合
    RANDOM = 4,             --随机
    HP_PERCENT_TARGET = 5,  --血量百分比
    HP_VALUE_TARGET = 6,    --血量值
    ACTIVE_SKILL = 7,       --主动使用技能
    PASSIVE_SKILL = 8,      --被技能击中
    DEAD_TARGET = 9,        --死亡
    DISTANCE_X = 10,        --X方向的距离
    DISTANCE_Y = 11,        --Y方向的距离
    DISTANCE = 12,          --距离
    MONSTER_STATE_IN = 13,  --怪物状态
    MONSTER_STATE_OUT = 14, --怪物状态
    SELF_POSITION_X = 15,        --x位置
    SELF_POSITION_Y = 16,        --y位置


    SUMMON_MAX = 17,        --召唤怪物最大数量
    TARGET_IN_RECT = 18,    --目标在范围内
    LAST_ROUND = 19,        --上一次技能触发
    MONSTER_IN_BATTLE = 20, --战场上存在怪物对应id的怪物
    IN_BUFF_STATE = 21,     --战场上是否有带对应buff类型的敌人
    SUMMON_POS_EMPTY = 22,  --指定位置范围没有怪物
    MONSTER_TYPE_IN_BATTLE = 23, --指定类型怪物
    IN_BUFF_ID = 24,    --指定idbuff存在
    ATTACK_TURN_PRE = 25, --每固定回合（25,n)
    IN_MAX_SP = 26,--满怒气

}

--AI行为配置
AiActionConfig =
{
    SUMMON = 1,             --召唤
    MOVE = 2,               --移动
    FLY = 3,                --飞行
    SKILL = 4,              --技能
    SHOOT = 5,              --普通射击
    CHANGE_PARENT = 6,      --影响父母
    NO = 7,                 --无行动
    SUICIDE = 8,            --自杀
    TALK = 9,               --说话

    MOVE_NEW = 100,         --移动
    SELF_BOOM = 200,        --自爆

    FOLLOW_ACTION_SKILL = 400,     --跟随行动
    MOVE_ACTION_SKILL = 401, --怪物移动（技能同步）
    END_ACTION_SKILL = 402, --行动结束技能
}

--技能类型配置
SkillTypeConfig =
{
    SHOOT = 1,
    SUMMON = 2,
    SHOOT_SUMMON = 3,
    MOVE = 4,
    BEAT = 5,
    BIG_SKILL = 6,
    TRANS = 7,
    SKILL = 8,
    EFFECT = 9,
    HIT_DO_EFFECT = 10,
}

--效果生效类型
TakeEffectType = 
{
    USE = 0,    --使用生效
    HIT = 1,    --击中生效
    TREASURE = 2, --宝箱
    COLLISION = 3, --碰撞生效
}

--效果目标类型
EffectTargetType = 
{
    HIT_ROLE = 0,   --任意(区分命中非命中)
    MYSELF = 1,     --自己
    MYTEAM = 2,     --我方(区分命中非命中)
    ENEMY = 3,      --敌方(区分命中非命中)
    SKLL_TO = 4,     --技能选择对象
}

EffectPosType = {
    MYSELF = 1,
    TARGET = 2,
    SCENE = 3,
    LINE = 4,       ---特色类型 连线
}

--效果配置
EffectTypeConfig =
{
    CHANGE_ATTRIBUTE_VALUE = "1_1",     --改变属性值
    CHANGE_ATTRIBUTE_PERCENT = "1_2",   --改变属性百分比
    CHANGE_ATTRIBUTE_PERCENT_ATTACK = "1_3",   --根据攻击力改变属性百分比
    CHANGE_ATTRIBUTE_PERCENT_HURT = "1_4",   --根据伤害改变属性百分比
    CHANGE_CTB_VALUE = "1_5",
    HURT = "2_1",                       --伤害计算
    RECOVERY = "2_2",                   --回血计算
    CHANGE_RECOVERY_PERCENT = "2_3",    --改变受到治疗效果万分比

    CHANGE_HURT_VALUE = "3_1",          --改变伤害值
    CHANGE_HURT_PERCENT = "3_2",       --改变伤害百分比
    CHANGE_HURT_ADD_VALUE = "3_3",       --改变伤害附加值
    CHANGE_BEHURT_VALUE = "3_4",          --改变被伤害值
    CHANGE_BEHURT_PERCENT = "3_5",       --改变被伤害百分比
    CHANGE_BEHURT_ADD_VALUE = "3_6",       --改变被伤害附加值
    CHANGE_CRIT_HURT_PERCENT = "3_7",       --改变暴击伤害万分比
    CHANGE_BECRIT_HURT_PERCENT = "3_8",    --改变被暴击伤害万分比
    CHANGE_CRIT_HURT_ADD_VALUE = "3_9",       --改变暴击伤害值
    CHANGE_BECRIT_HURT_ADD_VALUE = "3_10",    --改变被暴击伤害值
    CHANGE_HURT_MUL_PERCENT = "3_11",       --改变伤害百分比_乘法

    MOVE = "4_1",                       --移动
    FLY = "4_2",                        --飞行
    REPEL = "4_3",                      --击退
    TRANSFER = "4_4",                   --传送
    REPEL_FLY = "4_5",                   --击飞
    TRANSFER_MOVE = "4_6",               --吸引
    TRANSFER_RANDOM_BORN = "4_7",       --出身点传送
    REPEL_FLY_BOSS = "4_8",                  --boss击飞

    LIMIT_MOVE = "5_1",                 --限制移动
    LIMIT_FLY = "5_2",                  --限制飞行
    LIMIT_REPEL = "5_3",                --限制击退
    LIMIT_TRANSFER = "5_4",             --限制传送
    LIMIT_USE_SKILL = "5_5",            --限制使用技能
    LIMIT_USE_ITEM = "5_6",             --限制使用道具
    LIMIT_ALL_ACTION = "5_7",           --不可行动
    LIMIT_VISIBLE = "5_8",              --限制可视范围
    LIMIT_ONLY_FLY_MOVE = "5_9",         --限制只能飞行和移动
    LIMIT_ONLY_TIMES_SHOOT = "5_10",         --限制只能连击
    LIMIT_ONLY_TIMES_SHOOT_MOVE = "5_11",    --限制只能连击和移动
    LIMIT_ONLY_SCATTER_TIMES_SHOOT = "5_12", --限制只能连击和散射

    SUMMON = "6_1",                     --召唤

    TRANS = "7_1",                      --变身

    ADD_BUFF = "8_1",                   --添加BUFF

    CANCEL_BUFF_ALL = "9_1",            --驱散所有BUFF
    CANCEL_BUFF_TYPE = "9_2",           --驱散某种BUFF(增益 ,损益)
    CANCEL_BUFF_ID = "9_3",             --驱散某个Id的BUFF
    CANCEL_BUFF_ASSIGN = "9_4",         --驱散指定BUFF

    TRACK_SHOOT = "10_1",               --追踪弹
    SCATTER_SHOOT = "11_1",             --散射弹
    TIMES_SHOOT = "12_1",               --连击弹
    NO_HOLE = "13_1",                   --免坑

    CHAIN_OTHER = "14_1",               --与其他人连锁
    INVINCIBLE = "15_1",                --无敌
    HIDE = "16_1",                      --隐身

    ADD_EARNINGS = "17_1",              --增加收益
    REDUCE_EARNINGS = "17_2",           --降低收益

    DEAD = "18_1",                      --死亡
    TALK = "19_1",                      --对白

    MONSTER_CHANGE_STATE = "20_1",     --boss切换状态
   
    CREATE_EFFECT_ME = "21_1",            --创建特效
    CREATE_EFFECT_TARGET = "21_2",            --创建特效
    CREATE_EFFECT_SCENE = "21_3",            --创建特效
    CREATE_EFFECT_LINE = "21_4",            --创建特效

    SPEC_SHOOT  ="22_1",                 --创建指定子弹

    REFLECT = "23_1",                   --反射
    REVERSE = "24_1",                   --颠倒
    -- TORNADO = "25_1",                   --龙卷
    SPATTER = "26_1",                   --溅射

    SUMMON = "27_1",                    --召唤普通怪物
    TREAT_TOTEM = "27_2",               --召唤治疗图腾
    TORNADO = "27_3",
    BOSS_LIGHT = "27_4",                 --召唤聚光灯
    BOSS_GIFT = "27_5",                 --召唤礼物

    BUFF_TOTEM = "27_6",               --召唤攻击图腾

    PET_CRIT = "28_1",                      --宠物暴击
    IMMUNITY_BUFF_ASSIGN = "29_1",      --免疫指定类型BUFF
    IMMUNITY_EFFECT_ASSIGN = "29_2",    --免疫指定类型效果
    
    HURT_OFF_TARGET = "30",      --伤害排除所有人   子类型：0全部  1自己，2友方，3敌方
    PENETRATE_SHOOT = "31_1",       --穿透弹
    CHANGE_WIND = "32_1",       --风向药剂

    TRANSFER_POSITION = "101_1",     --换位效果
    HIDE_VIEW = "102_1",    --反隐身
    ATTRACT_BULLET = "103_1",    --吸引子弹
    POINT_LINE_ADD = "104_1",    --瞄准线加成

    EFFECT_TIPS_IN = "2000_1",           --提示光效in
    EFFECT_TIPS_OUT = "2001_1",          --提示光效out

    DO_NOT = "-1_1"                     --什么也不做
}

--怪物的配置表
MonsterConfig =
{
    --组队副本boss1
    boss1_1 =
    {
        aniFileId = "monster_0014",
        animSize = {width=290,height=218},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|summon1 = "summon1"|summon2 = "summon2"|command1 = "command1"|command2 = "command2"|skill = "skill"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=150,height=160,x=20,y=15},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-140,y=-30},
        isSpine = true,
    },
    boss1_2 =
    {
        aniFileId = "monster_0001",
        animSize = {width=115,height=133},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=50,height=90,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-19,y=57},
        isSpine = true,
    },
    --普通副本boss
    boss_0002 =
    {
        aniFileId = nil,
        animSize = {width=140,height=185},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=180,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-60,y=60},
        isSpine = true,
    },
    boss_0003 =
    {
        aniFileId = nil,
        animSize = {width=370,height=330},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=100,height=260,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-100,y=120},
        isSpine = true,
    },
    boss_0004 =
    {
        aniFileId = nil,
        animSize = {width=253,height=292},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=90,height=250,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -40,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-140,y=140},
        isSpine = true,
    },

    boss_0005 =
    {
        aniFileId = nil,
        animSize = {width=450,height=326},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=140,height=220,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -40,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-140,y=140},
        isSpine = true,
    },

    boss_0006 =
    {
        aniFileId = nil,
        animSize = {width=450,height=326},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=140,height=220,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -40,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-140,y=140},
        isSpine = true,
    },

    boss_0007 =
    {
        aniFileId = nil,
        animSize = {width=354,height=273},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=140,height=220,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -40,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-140,y=140},
        isSpine = true,
    },

    boss_0008 =
    {
        aniFileId = nil,
        animSize = {width=354,height=273},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=120,height=180,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -40,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-250,y=70},
        isSpine = true,
    },

    boss_0009 =
    {
        aniFileId = nil,
        animSize = {width=354,height=273},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=120,height=230,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -40,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-250,y=70},
        isSpine = true,
    },

    boss_0013 =
    {
        aniFileId = nil,
        animSize = {width=354,height=273},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=120,height=180,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -40,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-50,y=90},
        isSpine = true,
    },

    boss_0014 =
    {
        aniFileId = nil,
        animSize = {width=354,height=273},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=120,height=180,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -40,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-50,y=90},
        isSpine = true,
    },

    boss_0015 =
    {
        aniFileId = nil,
        animSize = {width=354,height=273},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=120,height=180,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -40,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-50,y=90},
        isSpine = true,
    },

    boss_0016 =
    {
        aniFileId = nil,
        animSize = {width=354,height=273},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=120,height=180,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -40,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-50,y=90},
        isSpine = true,
    },

    boss_0017 =
    {
        aniFileId = nil,
        animSize = {width=354,height=273},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=120,height=180,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -40,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-50,y=90},
        isSpine = true,
    },

    boss_0018 =
    {
        aniFileId = nil,
        animSize = {width=354,height=310},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=120,height=250,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -40,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-50,y=90},
        isSpine = true,
    },

    --世界boss
    boss_2001 =
    {
        aniFileId = nil,
        animSize = {width=1420,height=1380},
        animNormal=nil,--[[standby = "wait"|skill1_1 = "skill1_1"|skill1_2 = "skill1_2"|skill2_1 = "skill2_1"|skill2_2 = "skill2_2"|skill3_1 = "skill3_1"|skill3_2 = "skill3_2"|hurt = "wound"|dead = "die"]]
        animViolent=nil,
        animAir=[[standby = "wait"|skill1_1 = "skill1_1"|skill1_2 = "skill1_2"|skill2_1 = "skill2_1"|skill2_2 = "skill2_2"|skill3_1 = "skill3_1"|skill3_2 = "skill3_2"|hurt = "wound"|dead = "die"]],
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = nil,--{[1]={width=150,height=160,x=20,y=-250},},
        rectCollisionAir = {[1]={width=10,height=10,x=300,y=-200},[2]={width=200,height=380,x=-120,y=0},[3]={width=700,height=700,x=300,y=-200},[4]={width=300,height=100,x=350,y=-300},},
        animIsLeftFlip = nil,
        buffAnimOffsetX = 1000,
        buffAnimOffsetY = 150,
        bulletPosOffset = {x=-100,y=60},
        isSpine = true,
    },

    --组队副本boss
    boss_1002 =
    {
        aniFileId = nil,
        animSize = {width=177,height=187},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|summon = "summon"|order = "order"|skill1 = "skill1"|skill2 = "skill2"|skill5_1 = "skill5_1"|skill5_2 = "skill5_2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=130,height=210,x=20,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-100,y=90},
        isSpine = true,
    },

    boss_1002b =
    {
        aniFileId = nil,
        animSize = {width=100,height=100},
        animNormal= nil,
        animViolent=nil,
        animAir=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "skill3"|move = "skill3"|hurt = "wound"|dead = "die"]],
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = nil,
        rectCollisionAir = {[1]={width=90,height=90,x=0,y=-50},},
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-120,y=10},
        isSpine = true,
    },

    boss_1003 =
    {
        aniFileId = nil,
        animSize = {width=438,height=428},
        animNormal= nil,
        animViolent=nil,
        animAir=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|summon = "summon"|skill1 = "skill1"|skill2 = "skill2"|skill3_1 = "skill3_1"|skill3_2 = "skill3_2"|hurt = "wound"|dead = "die"]],
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = nil,
        rectCollisionAir = {[1]={width=140,height=280,x=0,y=0},},
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-150,y=200},
        isSpine = true,
    },

    boss_1003a =
    {
        aniFileId = "monster_0016",
        animSize = {width=138,height=143},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|move = "run"|boom = "die"|sacrifice = "die"|hurt = "wound"|dead = "die"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=50,height=90,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-120,y=10},
        isSpine = true,
    },

    boss_1003b =
    {
        aniFileId = "monster_0016a",
        animSize = {width=138,height=143},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|move = "run"|boom = "die"|sacrifice = "die"|hurt = "wound"|dead = "die"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=50,height=90,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-120,y=10},
        isSpine = true,
    },

    boss_1003c =
    {
        aniFileId = "monster_0016b",
        animSize = {width=138,height=143},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|move = "run"|boom = "die"|sacrifice = "die"|hurt = "wound"|dead = "die"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=50,height=90,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-120,y=10},
        isSpine = true,
    },

    boss_1003d =
    {
        aniFileId = "monster_0016c",
        animSize = {width=138,height=143},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|move = "run"|boom = "die"|sacrifice = "die"|hurt = "wound"|dead = "die"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=50,height=90,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-120,y=10},
        isSpine = true,
    },

    --组队副本4boss
    boss_1004 =
    {
        aniFileId = nil,
        animSize = {width=366,height=270},
        animNormal= nil,
        animViolent=nil,
        animAir=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|summon = "summon"|skill = "cast"|skill1 = "throw1"|skill2 = "throw2"|skill3 = "conjure"|skill4 = "conjure1"|skill5 = "conjure2"|skill6 = "conjure3"|hurt = "wound"|move = "fly"|dead = "die"|fly = "fly"]],
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = nil,
        rectCollisionAir = {[1]={width=90,height=230,x=20,y=0},},
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-150,y=200},
        isSpine = true,
    },

    --组队副本5boss
    boss_1005 =
    {
        aniFileId = nil,
        animSize = {width=300,height=300},
        animNormal= nil,
        animViolent=nil,
        animAir=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|summon1 = "summon1"|summon2 = "summon2"|shoot_3 = "shoot_3"|standby = "wait"|gather = "gather"|conjure1 = "conjure1"|conjure2 = "conjure2"|hurt = "wound"|dead = "die"]],
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = nil,
        rectCollisionAir = {[1]={width=90,height=230,x=20,y=0},},
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-150,y=200},
        isSpine = true,
    },

    --组队副本boss
    boss_1006 =
    {
        aniFileId = nil,
        animSize = {width=300,height=340},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"
        |powAtk_1 = "powAtk_1"|powAtk_2 = "powAtk_2"|carry_1="carry_1"|carry_2="carry_2"
        |reborn_1="reborn_1"|reborn_2="reborn_2"||reborn_3="reborn_3"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=130,height=210,x=20,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-300,y=60},
        isSpine = true,
    },
    --组队副本boss
    boss_1006a =
    {
        aniFileId = "boss_1007",
        animSize = {width=210,height=340},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"
        |quickAtk_1="quickAtk_1"|quickAtk_2="quickAtk_2"|quickAtk_3="quickAtk_3"|quickAtk_4="quickAtk_4"
        |batAtk_1="batAtk_1"|batAtk_2="batAtk_2"|reborn_1="reborn_1"|reborn_2="reborn_2"|reborn_3="reborn_3"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=130,height=250,x=20,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-80,y=180},
        isSpine = true,
    },
    -- wait_1,wait_2,wait_3
    --run_1,run_2,run_3 wound_1,wound_2,wound_3 die_1,die_2,die_3
    --trans_1
    --trans_2
    --shoot_1a,shoot_2a,shoot_3a
    --shoot_1b,shoot_2b,shoot_3b
    --shoot_1c,shoot_2c,shoot_3c
    --flak_1a,flak_2a,flak_3a 引导
    --flak_1b,flak_2b,flak_3b
    --flak_1c,flak_2c,flak_3c
    --laser_1,laser_2,laser_3 激光
    --组队副本boss
    boss_1008 =
    {
        aniFileId = nil,
        animSize = {width=300,height=300},
        animNormal= nil,
        animViolent=nil,
        -- animAir=[[standby = "wait"|standby_1 = "wait_1"]],
        animAir=[[shoot_1a = "shoot_1a"|shoot_2a = "shoot_2a"|shoot_3a = "shoot_3a"
        |shoot_1b = "shoot_1b"|shoot_2b = "shoot_2b"|shoot_3b = "shoot_3b"
        |shoot_1c = "shoot_1c"|shoot_2c = "shoot_2c"|shoot_3c = "shoot_3c"
        |standby_1 = "wait_1"|standby_2 = "wait_2"|standby_3 = "wait_3"
        |run_1 = "run_1"|run_2 = "run_2"|run_3 = "run_3"
        |hurt_1 = "wound_1"|hurt_2 = "wound_2"|hurt_3 = "wound_3"
        |flak_1a = "flak_1a"|flak_2a = "flak_2a"|flak_3a = "flak_3a"
        |flak_1b = "flak_1b"|flak_2b = "flak_2b"|flak_3b = "flak_3b"
        |flak_1c = "flak_1c"|flak_2c = "flak_2c"|flak_3c = "flak_3c"
        |laser_1 = "laser_1"|laser_2 = "laser_2"|laser_3 = "laser_3"
        |dead_1 = "die_1"|dead_2 = "die_2"|dead_3 = "die_3"
        |trans_1 = "trans_1"|trans_2 = "trans_2"]],
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = nil,
        rectCollisionAir = {[1]={width=100,height=200,x=-20,y=70},},
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-200,y=250},
        isSpine = true,
    },

    boss_1008a =
    {
        aniFileId = nil,
        animSize = {width=300,height=340},
        animNormal=[[standby = "wait"|hurt = "wound"|move = "run"|dead = "die"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=180,height=180,x=0,y=-10},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-300,y=60},
        isSpine = true,
    },

    boss_1009 =
    {
        aniFileId = nil,
        animSize = {width=300,height=300},
        animNormal= nil,
        animViolent=nil,
        animAir=[[shoot_1a = "shoot_1a"|shoot_2a = "shoot_2a"|shoot_3a = "shoot_3a"
        |shoot_1b = "shoot_1b"|shoot_2b = "shoot_2b"|shoot_3b = "shoot_3b"
        |standby_1 = "wait_1"|standby_2 = "wait_2""
        |hurt_1 = "wound_1"|hurt_2 = "wound_2"
        |nearAtk_1a = "nearAtk_1a"|nearAtk_2a = "nearAtk_2a"
        |nearAtk_1b = "nearAtk_1b"|nearAtk_2b = "nearAtk_2b"
        |powAtk_1a = "powAtk_1a"|powAtk_2a = "powAtk_2a"
        |powAtk_1b = "powAtk_1b"|powAtk_2b = "powAtk_2b"
        |angAtk_1a = "angAtk_1a"|angAtk_2a = "angAtk_2a"
        |angAtk_1b = "angAtk_1b"|angAtk_2b = "angAtk_2b"
        |summon_1a = "summon_1a"|summon_2a = "summon_2a"
        |summon_1b = "summon_1b"|summon_2b = "summon_2b"
        |dead_1 = "die_1"|dead_2 = "die_2"
        |trans = "trans"]],
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = nil,
        rectCollisionAir = {[1]={width=120,height=250,x=-20,y=20},},
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-200,y=250},
        isSpine = true,
    },

    boss_1009a =
    {
        aniFileId = nil,
        animSize = {width=300,height=340},
        animNormal=[[standby = "wait"|hurt = "wound"|move = "run"|dead = "die"|atk_1 = "atk_1"|atk_2 = "atk_2"]],
        -- animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=120,height=150,x=0,y=-10},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-300,y=60},
        isSpine = true,
    },

    boss_1010 =
    {
        aniFileId = nil,
        animSize = {width=300,height=340},
        animNormal=[[standby_1 = "wait_1"|standby_2 = "wait_2"|hurt_1 = "wound_1"|hurt_2 = "wound_2"
        |dead_1 = "die"|dead_2 = "die"|move = "run"|fly = "wait_2"|hide = "hide"|trans = "trans"
        |attack_1 = "attack_1"|attack_2 = "attack_2"|attack_3 = "attack_3"
        |tread_1 = "tread_1"|tread_2 = "tread_2"|tread_3 = "tread_3"
        |shoot_1a = "shoot_1a"|shoot_2a = "shoot_2a"|shoot_3a = "shoot_3a"
        |shoot_1b = "shoot_1b"|shoot_2b = "shoot_2b"|shoot_3b = "shoot_3b"
        |flak_1 = "shoot_1c"|flak_2 = "shoot_2c"|flak_3 = "shoot_3c"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=180,height=230,x=0,y=-10},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-140,y=200},
        isSpine = true,
    },

    boss_1011 =
    {
        aniFileId = nil,
        animSize = {width=300,height=340},
        animNormal=[[standby_1 = "wait_1"|standby_2 = "wait_2"|hurt_1 = "wound_1"|hurt_2 = "wound_2"
        |dead_1 = "die"|dead_2 = "die"|move_1 = "run"|move_2 = "run2"|fly = "wait_2"|trans = "trans"
        |sign_1 = "sign_1"|sign_2 = "sign_2"
        |pow_1a = "pow_1a"|pow_2a = "pow_2a"|pow_3a = "pow_3a"
        |pow_1b = "pow_1b"|pow_2b = "pow_2b"|pow_3b = "pow_3b"
        |atk_1_1a = "atk_1_1a"|atk_1_2a = "atk_1_2a"|atk_1_3a = "atk_1_3a"
        |atk_1_1b = "atk_1_1b"|atk_1_2b = "atk_1_2b"|atk_1_3b = "atk_1_3b"
        |atk_2_1a = "atk_2_1a"|atk_2_2a = "atk_2_2a"|atk_2_3a = "atk_2_3a"
        |atk_2_1b = "atk_2_1b"|atk_2_2b = "atk_2_2b"|atk_2_3b = "atk_2_3b"
        |summon_1a = "summon_1a"|summon_2a = "summon_2a"
        |summon_1b = "summon_1b"|summon_2b = "summon_2b"
        |tread_1a = "tread_1a"|tread_2a = "tread_2a"|tread_3a = "tread_3a"
        |tread_1b = "tread_1b"|tread_2b = "tread_2b"|tread_3b = "tread_3b"
        |shoot_1a = "shoot_1a"|shoot_2a = "shoot_2a"|shoot_3a = "shoot_3a"
        |shoot_1b = "shoot_1b"|shoot_2b = "shoot_2b"|shoot_3b = "shoot_3b"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=250,height=350,x=0,y=-10},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-140,y=200},
        isSpine = true,
    },

    boss_1011a =
    {
        aniFileId = nil,
        animSize = {width=300,height=340},
        animNormal=[[standby = "wait"|hurt = "wound"|move = "run"|dead = "die"|boom = "die"|sacrifice = "die"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=80,height=100,x=0,y=-10},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-300,y=60},
        isSpine = true,
    },

    --普通怪物
    monster_0001 =
    {
        aniFileId = nil,
        animSize = {width=115,height=133},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=50,height=80,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = 0,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-19,y=57},
        isSpine = true,
    },

    monster_0002 =
    {
        aniFileId = nil,
        animSize = {width=169,height=189},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=140,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-37,y=104},
        isSpine = true,
    },

    monster_0003 =
    {
        aniFileId = nil,
        animSize = {width=147,height=136},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=50,height=90,x=0,y=-0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-49,y=82},
        isSpine = true,
    },

    monster_0004 =
    {
        aniFileId = nil,
        animSize = {width=171,height=158},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=50,height=110,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-25,y=51},
        isSpine = true,
    },

    monster_0005 =
    {
        aniFileId = nil,
        animSize = {width=224,height=195},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=80,height=150,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -10,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-91,y=182},
        isSpine = true,
    },

    monster_0006 =
    {
        aniFileId = nil,
        animSize = {width=189,height=149},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=90,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-92,y=98},
        isSpine = true,
    },

    monster_0007 =
    {
        aniFileId = nil,
        animSize = {width=153,height=142},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = 0.08,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=100,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-59,y=107},
        isSpine = true,
    },

    --宝箱1
    monster_0008 =
    {
        aniFileId = nil,
        animSize = {width=147,height=146},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|hurt = "wound"|move = "walk"|dead = "die"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=110,height=100,x=-30,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = true,
        buffAnimOffsetX = -30,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-120,y=10},
        isSpine = true,
    },

    monster_0009 =
    {
        aniFileId = nil,
        animSize = {width=118,height=136},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=45,height=90,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-65,y=73},
        isSpine = true,
    },
    --宝箱2
    monster_0010 =
    {
        aniFileId = nil,
        animSize = {width=147,height=146},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|hurt = "wound"|move = "walk"|dead = "die"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=110,height=100,x=-30,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = true,
        buffAnimOffsetX = -30,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-120,y=10},
        isSpine = true,
    },
    --宝箱3
    monster_0011 =
    {
        aniFileId = nil,
        animSize = {width=147,height=146},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|hurt = "wound"|move = "walk"|dead = "die"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=110,height=100,x=-30,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = true,
        buffAnimOffsetX = -30,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-120,y=10},
        isSpine = true,
    },

    monster_0012 =
    {
        aniFileId = nil,
        animSize = {width=195,height=173},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=50,height=110,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-121,y=74},
        isSpine = true,
    },

    monster_0013 =
    {
        aniFileId = nil,
        animSize = {width=207,height=156},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=130,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-181,y=51},
        isSpine = true,
    },

    --14 boss1使用
    
    monster_0015 =
    {
        aniFileId = nil,
        animSize = {width=172,height=146},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=55,height=90,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-108,y=100},
        isSpine = true,
    },

    monster_0016 =
    {
        aniFileId = nil,
        animSize = {width=138,height=143},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=50,height=100,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = -10,
        bulletPosOffset = {x=-20,y=104},
        isSpine = true,
    },

    monster_0017 =
    {
        aniFileId = nil,
        animSize = {width=228,height=175},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=70,height=120,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-62,y=135},
        isSpine = true,
    },

    monster_0018 =
    {
        aniFileId = nil,
        animSize = {width=130,height=146},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=50,height=135,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-50,y=100},
        isSpine = true,
    },

    monster_0019 =
    {
        aniFileId = nil,
        animSize = {width=224,height=244},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=80,height=130,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-80,y=69},
        isSpine = true,
    },

    monster_0020 =
    {
        aniFileId = nil,
        animSize = {width=158,height=148},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=80,height=155,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-80,y=86},
        isSpine = true,
    },

    monster_0021 =
    {
        aniFileId = nil,
        animSize = {width=183,height=176},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=170,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-77,y=126},
        isSpine = true,
    },

    monster_0022 =
    {
        aniFileId = nil,
        animSize = {width=193,height=193},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=50,height=155,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-90,y=70},
        isSpine = true,
    },

    monster_0023 =
    {
        aniFileId = nil,
        animSize = {width=190,height=218},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=50,height=140,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-78,y=100},
        isSpine = true,
    },

    monster_0024 =
    {
        aniFileId = nil,
        animSize = {width=273,height=196},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=70,height=190,x=0,y=20},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -30,
        buffAnimOffsetY = 30,
        bulletPosOffset = {x=-78,y=100},
        isSpine = true,
    },

    monster_0025 =
    {
        aniFileId = nil,
        animSize = {width=168,height=179},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=40,height=100,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-40,y=40},
        isSpine = true,
    },

    monster_0026 =
    {
        aniFileId = nil,
        animSize = {width=226,height=254},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=100,height=140,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-40,y=180},
        isSpine = true,
    },

    monster_0027 =
    {
        aniFileId = nil,
        animSize = {width=216,height=281},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=80,height=140,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=40,y=220},
        isSpine = true,
    },


    monster_0028 =
    {
        aniFileId = nil,
        animSize = {width=192,height=197},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=70,height=160,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-40,y=40},
        isSpine = true,
    },

    monster_0029 =
    {
        aniFileId = nil,
        animSize = {width=192,height=197},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=90,height=150,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-40,y=40},
        isSpine = true,
    },

    monster_0030 =
    {
        aniFileId = nil,
        animSize = {width=192,height=197},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=120,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-40,y=40},
        isSpine = true,
    },

    monster_0031 =
    {
        aniFileId = nil,
        animSize = {width=192,height=197},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=120,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-80,y=140},
        isSpine = true,
    },

    monster_0032 =
    {
        aniFileId = nil,
        animSize = {width=192,height=197},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=120,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-80,y=140},
        isSpine = true,
    },

    monster_0033 =
    {
        aniFileId = nil,
        animSize = {width=192,height=197},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=120,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-80,y=140},
        isSpine = true,
    },

    monster_0034 =
    {
        aniFileId = nil,
        animSize = {width=192,height=230},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=80,height=200,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-80,y=140},
        isSpine = true,
    },

    monster_0035 =
    {
        aniFileId = nil,
        animSize = {width=192,height=197},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=120,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-80,y=140},
        isSpine = true,
    },

    monster_0036 =
    {
        aniFileId = nil,
        animSize = {width=192,height=197},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=120,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-80,y=140},
        isSpine = true,
    },

    monster_0037 =
    {
        aniFileId = nil,
        animSize = {width=192,height=197},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=120,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-80,y=140},
        isSpine = true,
    },

    monster_0038 =
    {
        aniFileId = nil,
        animSize = {width=192,height=240},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=150,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-80,y=140},
        isSpine = true,
    },

    monster_0039 =
    {
        aniFileId = nil,
        animSize = {width=192,height=197},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=120,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-80,y=140},
        isSpine = true,
    },

    monster_0040 =
    {
        aniFileId = nil,
        animSize = {width=192,height=260},
        animNormal=[[shoot_1 = "shoot_1"|shoot_2 = "shoot_2"|shoot_3 = "shoot_3"|standby = "wait"|skill1 = "skill1"|skill2 = "skill2"|hurt = "wound"|move = "run"|dead = "die"|fly = "fly"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=60,height=230,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-80,y=140},
        isSpine = true,
    },
    monster_target =
    {
        aniFileId = nil,
        animSize = {width=100,height=30},
        animNormal=[[shoot_1 = "wait"|shoot_2 = "wait"|shoot_3 = "wait"|standby = "wait"|skill1 = "wait"|skill2 = "wait"|hurt = "wait"|move = "wait"|dead = "die"|fly = "wait"]],
        animViolent=nil,
        animAir=nil,
        animAirViolent=nil,
        armatureName = nil,
        armatureOffsetY = nil,
        armatureOffsetYAir = nil,
        rectCollision = {[1]={width=1,height=1,x=0,y=0},},
        rectCollisionAir = nil,
        animIsLeftFlip = nil,
        buffAnimOffsetX = -20,
        buffAnimOffsetY = 0,
        bulletPosOffset = {x=-80,y=140},
        isSpine = true,
    },


}

BattleMachineConfig =
{
    -- isCollision 是否带地图碰撞
    --炮台
    machine_1001 =
    {
        aniFileId = "pao",
        scale = 1,
        --isMapCollision = true,
        animNormal=[[standby = "wait"|skill = "skill"|skill1 = "skill1"|skill2 = "skill2"|dead = "skill"]],
        rectCollision = {[1]={width=140,height=170,x=-10,y=-85},},
        animIsLeftFlip = false,
        isSpine = true,
        bulletPosOffset = {x=-340,y=-30},
    },
    --治疗图腾
    machine_1002 =
    {
        aniFileId = "skill_fsq",
        scale = 1,
        --isMapCollision = true,
        animSize = {width=60,height=80},
        animNormal=[[standby = "xunhuan1"|skill = "hit1"|hurt = "hit1"|dead = "hit1"]],
        rectCollision = {[1]={width=60,height=80,x=0,y=-40},},
        animIsLeftFlip = false,
        isSpine = true,
        bulletPosOffset = nil,
    },
    --治疗图腾
    machine_1003 =
    {
        aniFileId = "skill_fsq",
        scale = 1,
        --isMapCollision = true,
        animNormal=[[standby = "xunhuan2"|skill = "hit2"|hurt = "hit2"|dead = "hit2"]],
        animSize = {width=60,height=80},
        rectCollision = {[1]={width=60,height=80,x=0,y=-40},},
        animIsLeftFlip = false,
        isSpine = true,
        bulletPosOffset = nil,
    },
    --龙卷风
    machine_1004 =
    {
        aniFileId = "skill_longjuandan_youfang_chixu",
        scale = 1,
        --isMapCollision = true,
        animNormal=[[standby = "chixu"|skill = "chixu"|hurt = "chixu"|dead = "chixu"]],
        animSize = {width=60,height=80},
        rectCollision = {[1]={width=100,height=300,x=0,y=-250},},
        animIsLeftFlip = false,
        isSpine = true,
        bulletPosOffset = nil,
    },
    --龙卷风
    machine_1005 =
    {
        aniFileId = "skill_longjuandan_chixu",
        scale = 1,
        --isMapCollision = true,
        animNormal=[[standby = "chixu"|skill = "chixu"|hurt = "chixu"|dead = "chixu"]],
        animSize = {width=60,height=80},
        rectCollision = {[1]={width=100,height=300,x=0,y=-250},},
        animIsLeftFlip = false,
        isSpine = true,
        bulletPosOffset = nil,
    },
    --礼物
    machine_1006 =
    {
        aniFileId = "boss_1005b",
        scale = 1,
        isMapCollision = true,
        animNormal=[[standby = "wait"|skill = "skill"|hurt = "skill"|dead = "die"]],
        animSize = {width=60,height=80},
        rectCollision = {[1]={width=60,height=80,x=0,y=0},},
        animIsLeftFlip = false,
        isSpine = true,
        bulletPosOffset = nil,
    },

    --聚光灯
    machine_1007 =
    {
        aniFileId = "boss_1005a",
        scale = 1,
        --isMapCollision = true,
        animNormal=[[standby1 = "wait_1"|standby2 = "wait_2"|standby3 = "wait_3"|skill1 = "skill_1"|skill2 = "skill_2"|skill3 = "skill_3"|dead1 = "die_1"|dead2 = "die_2"|dead3 = "die_3"]],
        animSize = {width=60,height=80},
        rectCollision = {[1]={width=80,height=100,x=0,y=-60},},
        animIsLeftFlip = false,
        isSpine = true,
        bulletPosOffset = nil,
    },

    --boss6火焰
    machine_1008=
    {
        aniFileId = "boss_1006b",
        scale = 1,
        -- isMapCollision = true,
        animNormal=[[standby = "wait"|skill = "wait"|hurt = "wait"|dead = "die"]],
        animSize = {width=60,height=80},
        rectCollision = {[1]={width=320,height=180,x=0,y=-50},},
        animIsLeftFlip = false,
        isSpine = true,
        bulletPosOffset = nil,
    },

    --攻击图腾
    machine_1009 =
    {
        aniFileId = "skill_tuteng",
        scale = 1,
        --isMapCollision = true,
        animSize = {width=60,height=80},
        animNormal=[[standby = "xunhuan1"|skill = "hit1"|hurt = "hit1"|dead = "hit1"]],
        rectCollision = {[1]={width=60,height=80,x=0,y=-10},},
        animIsLeftFlip = false,
        isSpine = true,
        bulletPosOffset = nil,
    },
    --攻击图腾
    machine_1010 =
    {
        aniFileId = "skill_tuteng",
        scale = 1,
        --isMapCollision = true,
        animNormal=[[standby = "xunhuan2"|skill = "hit2"|hurt = "hit2"|dead = "hit2"]],
        animSize = {width=60,height=80},
        rectCollision = {[1]={width=60,height=80,x=0,y=-10},},
        animIsLeftFlip = false,
        isSpine = true,
        bulletPosOffset = nil,
    },

    --牢笼
    machine_7001=
    {
        aniFileId = "boss_1008b",
        scale = 1,
        -- isMapCollision = true,
        animNormal=[[standby = "wait"|skill = "wait"|hurt = "wait"|dead = "die"]],
        animSize = {width=60,height=80},
        rectCollision = {[1]={width=320,height=220,x=0,y=-100},},
        animIsLeftFlip = false,
        isSpine = true,
        bulletPosOffset = nil,
    },
    --激光炮
    -- wait_1,wait_2,wait_3，wait_4
    machine_7002=
    {
        aniFileId = "boss_1008c",
        scale = 1,
        -- isMapCollision = true,
        animNormal=[[wait_1 = "wait_1"|wait_2 = "wait_2"|wait_3 = "wait_3"|wait_4 = "wait_4"|ready_1 = "ready_1"|ready_2 = "ready_2"|ready_3 = "ready_3"|ready_4 = "ready_4"|atk_1 = "atk_1"|atk_2 = "atk_2"|atk_3 = "atk_3"|atk_4 = "atk_4"]],
        animSize = {width=60,height=80},
        rectCollision = {[1]={width=300,height=100,x=0,y=-50},},
        animIsLeftFlip = false,
        isSpine = true,
        bulletPosOffset = nil,
    },

    --岩浆
    machine_8001=
    {
        aniFileId = "boss_1009b",
        scale = 1,
        -- isMapCollision = true,
        animNormal=[[standby = "wait"|skill = "wait"|hurt = "wait"|dead = "die"]],
        animSize = {width=60,height=80},
        rectCollision = {[1]={width=2000,height=200,x=0,y=30},},
        animIsLeftFlip = false,
        isSpine = true,
        bulletPosOffset = nil,
    },

     --毒雾
    machine_9001=
    {
        aniFileId = "boss_1011b",
        scale = 1,
        -- isMapCollision = true,
        animNormal=[[standby = "wait"|skill = "wait"|hurt = "wait"|dead = "wait"]],
        animSize = {width=60,height=80},
        rectCollision = {[1]={width=2000,height=200,x=0,y=30},},
        animIsLeftFlip = false,
        isSpine = true,
        bulletPosOffset = nil,
    },
}


--怪物数据
BossData = GDatatab_monster
--[[
{
    id_1 = { id = 1,name = "章鱼王",script = "我是小章鱼啊啊啊啊啊啊！",scale = 1.2,bullet = -1,suit_weapon_id = 1,penetrate = -1,sex = -1,suit_head = -1,suit_face = -1,suit_body = -1,type = 2,attack_type = 0,level = 17,sp = 0,hp = 2000,defend = 0,attack = 44,physique = 0,fighting = 10000,armor = 0,force = 0,luck = 0,agility = 0,reduce_crit = 24,crit = 24,injury_free = 0,wreck_defense = 0,attackArea = 50,reduce_bury = 0,explode = -1,bigSkillType = -1,guai_ai = 1,mzl = -1,broken = -1,AniFileId = "boss1_1",tili = 100,dialogue = -1},
    id_2 = { id = 2,name = "章鱼王",script = "我是小章鱼啊啊啊啊啊啊！",scale = 1.2,bullet = -1,suit_weapon_id = 1,penetrate = -1,sex = -1,suit_head = -1,suit_face = -1,suit_body = -1,type = 2,attack_type = 0,level = 17,sp = 0,hp = 2000,defend = 0,attack = 44,physique = 0,fighting = 10000,armor = 0,force = 0,luck = 0,agility = 0,reduce_crit = 24,crit = 24,injury_free = 0,wreck_defense = 0,attackArea = 50,reduce_bury = 0,explode = -1,bigSkillType = -1,guai_ai = 1,mzl = -1,broken = -1,AniFileId = "boss1_1",tili = 100,dialogue = -1},
    id_3 = { id = 3,name = "章鱼王",script = "我是小章鱼啊啊啊啊啊啊！",scale = 1.2,bullet = -1,suit_weapon_id = 1,penetrate = -1,sex = -1,suit_head = -1,suit_face = -1,suit_body = -1,type = 2,attack_type = 0,level = 17,sp = 0,hp = 2000,defend = 0,attack = 44,physique = 0,fighting = 10000,armor = 0,force = 0,luck = 0,agility = 0,reduce_crit = 24,crit = 24,injury_free = 0,wreck_defense = 0,attackArea = 50,reduce_bury = 0,explode = -1,bigSkillType = -1,guai_ai = 1,mzl = -1,broken = -1,AniFileId = "boss1_1",tili = 100,dialogue = -1},
    id_4 = { id = 4,name = "校长",script = "",scale = 1,bullet = -1,suit_weapon_id = 1,penetrate = -1,sex = -1,suit_head = -1,suit_face = -1,suit_body = -1,type = 2,attack_type = 2,level = 17,sp = 0,hp = 2000,defend = 0,attack = 44,physique = 0,fighting = 10000,armor = 0,force = 0,luck = 0,agility = 0,reduce_crit = 24,crit = 24,injury_free = 0,wreck_defense = 0,attackArea = 50,reduce_bury = 0,explode = -1,bigSkillType = -1,guai_ai = -1,mzl = -1,broken = -1,AniFileId = "boss1_2",tili = 100,dialogue = -1},
}
--]]

--技能配置
SkillConfig = GDatatab_moster_skill
--[[
{
    id_1 = { id = 1,name = "章鱼召唤",script = "召唤章鱼小弟。每次最多可召唤3个章鱼小弟，场面最多存在9个章鱼小弟，例如，场面已有9个章鱼小弟",icon = -1,choose = 1,chooseParm = {{-1}},skill_type = 3,trigger_type = 1,target_type = 3,skilldo = 0,effect_id = -1,consume = 4000,caozuo = -1,pengzh = -1,guiji = -1,chuantou = -1,time = -1,xingzh = -1,yuand = -1,chongf = -1,zhaoh = -1,xuanz = -1,shishi = -1,pianli = -1,consume = -1,cooling_time = -1,camera = 1,zhunb = -1,doSkillEffectList = -1,isHurtAdvance = -1,doSkillAnim = "skill",readySkillAnim = -1,doSkillEffects = -1,endSkillEffects = -1,endSkillAnim = -1,readySkillEffects = -1,shihyinxiao = -1,txdh = -1,yinxiao = -1,shiyinxiao = -1,dpsj = -1,dpfd = -1,jndp = -1,jzdp = -1,kdsj = -1},
    id_2 = { id = 2,name = "章鱼毒",script = "在场景中挥舞章鱼触须鞭笞目标玩家，对目标玩家（血量最多的玩家）造成一定伤害，且具有一定击飞效",icon = -1,choose = 4,chooseParm = {{-1}},skill_type = 3,trigger_type = 1,target_type = 3,skilldo = 0,effect_id = 1002,consume = 2000,caozuo = -1,pengzh = -1,guiji = -1,chuantou = -1,time = -1,xingzh = -1,yuand = -1,chongf = -1,zhaoh = -1,xuanz = -1,shishi = -1,pianli = -1,consume = -1,cooling_time = -1,camera = 1,zhunb = -1,doSkillEffectList = -1,isHurtAdvance = 1,doSkillAnim = "skill2",readySkillAnim = -1,doSkillEffects = -1,endSkillEffects = -1,endSkillAnim = "skill2_1",readySkillEffects = -1,shihyinxiao = -1,txdh = -1,yinxiao = -1,shiyinxiao = -1,dpsj = -1,dpfd = -1,jndp = -1,jzdp = -1,kdsj = -1},
    id_3 = { id = 3,name = "章鱼炸弹",script = "章鱼哥对目标玩家（血量最少的玩家）送出的飞吻，会对玩家（在恐吓效果中，玩家对角色不可进行操作",icon = -1,choose = 5,chooseParm = {{-1}},skill_type = 3,trigger_type = 1,target_type = 3,skilldo = 0,effect_id = 1003,consume = 3000,caozuo = -1,pengzh = -1,guiji = -1,chuantou = -1,time = -1,xingzh = -1,yuand = -1,chongf = -1,zhaoh = -1,xuanz = -1,shishi = -1,pianli = -1,consume = -1,cooling_time = -1,camera = 1,zhunb = -1,doSkillEffectList = -1,isHurtAdvance = 1,doSkillAnim = "skill3",readySkillAnim = -1,doSkillEffects = -1,endSkillEffects = -1,endSkillAnim = "skill3_1",readySkillEffects = -1,shihyinxiao = -1,txdh = -1,yinxiao = -1,shiyinxiao = -1,dpsj = -1,dpfd = -1,jndp = -1,jzdp = -1,kdsj = -1},
    id_4 = { id = 4,name = "章鱼之怒",script = "章鱼哥怒了，在船舷上伸出无数触手抽打玩家，持续N秒                                     ",icon = -1,choose = 8,chooseParm = {{-1}},skill_type = 3,trigger_type = 1,target_type = 3,skilldo = 0,effect_id = 1004,consume = 1000,caozuo = -1,pengzh = -1,guiji = -1,chuantou = -1,time = -1,xingzh = -1,yuand = -1,chongf = -1,zhaoh = -1,xuanz = -1,shishi = -1,pianli = -1,consume = -1,cooling_time = -1,camera = 1,zhunb = -1,doSkillEffectList = -1,isHurtAdvance = 1,doSkillAnim = "skill4",readySkillAnim = -1,doSkillEffects = -1,endSkillEffects = -1,endSkillAnim = "skill4_1",readySkillEffects = -1,shihyinxiao = -1,txdh = -1,yinxiao = -1,shiyinxiao = -1,dpsj = -1,dpfd = -1,jndp = -1,jzdp = -1,kdsj = -1},

    id_5 = { id = 5,name = "炮击",script = "发射一颗炮弹打击目标（血量最多的玩家）。",camera = 1,icon = -1,readySkillAnim = -1,doSkillAnim = "skill",endSkillAnim = -1,choose = 4,chooseParm = {{-1}},skill_type = 3,trigger_type = 1,target_type = 3,skilldo = 0,effect_id = 1005,consume = 4000,caozuo = -1,pengzh = -1,guiji = -1,chuantou = -1,time = -1,xingzh = -1,yuand = -1,chongf = -1,zhaoh = -1,xuanz = -1,shishi = -1,pianli = -1,consume = -1,cooling_time = -1,dongzuo = -1,zhunb = -1,shifangd = -1,shifang = -1,stx = -1,ztx = -1,shiyinxiao = -1,shihyinxiao = -1,shtx = -1,yinxiao = -1,jzdp = -1,dpsj = -1,txdh = -1,jndp = -1,dpfd = -1,kdsj = -1},
    id_6 = { id = 6,name = "钢铁手臂：",script = "抡起手臂砸向玩家地面，对所有玩家造成一定伤害",isHurtAdvance = 1,camera = 1,readySkillAnim = -1,doSkillAnim = "skill3",endSkillAnim = "skill3_1",icon = -1,choose = 8,chooseParm = {{-1}},skill_type = 3,trigger_type = 1,target_type = 3,skilldo = 0,effect_id = 1006,consume = 6000,caozuo = -1,pengzh = -1,guiji = -1,chuantou = -1,time = -1,xingzh = -1,yuand = -1,chongf = -1,zhaoh = -1,xuanz = -1,shishi = -1,pianli = -1,consume = -1,cooling_time = -1,dongzuo = -1,zhunb = -1,shifangd = -1,shifang = -1,stx = -1,ztx = -1,shiyinxiao = -1,shihyinxiao = -1,shtx = -1,yinxiao = -1,jzdp = -1,dpsj = -1,txdh = -1,jndp = -1,dpfd = -1,kdsj = -1},
    id_7 = { id = 7,name = "冰冻射线：",script = "对距离BOSS最近的玩家发送激光射线，造成一定伤害，并且冻住目标玩家N秒",isHurtAdvance = 1,camera = 1,readySkillAnim = -1,doSkillAnim = "skill4",endSkillAnim = "skill4_1",icon = -1,choose = 2,chooseParm = {{-1}},skill_type = 3,trigger_type = 1,target_type = 3,skilldo = 0,effect_id = 1007,consume = 2000,caozuo = -1,pengzh = -1,guiji = -1,chuantou = -1,time = -1,xingzh = -1,yuand = -1,chongf = -1,zhaoh = -1,xuanz = -1,shishi = -1,pianli = -1,consume = -1,cooling_time = -1,dongzuo = -1,zhunb = -1,shifangd = -1,shifang = -1,stx = -1,ztx = -1,shiyinxiao = -1,shihyinxiao = -1,shtx = -1,yinxiao = -1,jzdp = -1,dpsj = -1,txdh = -1,jndp = -1,dpfd = -1,kdsj = -1},
    id_8 = { id = 8,name = "碾压",script = "对BOSS身体范围50像素内的玩家进行碾压秒杀",camera = 1,isHurtAdvance = 1,readySkillAnim = -1,doSkillAnim = "skill5",endSkillAnim = "skill5_1",endSkillEffects = 106,icon = -1,choose = 11,chooseParm = {{50,6}},skill_type = 3,trigger_type = 1,target_type = 3,skilldo = 0,effect_id = 1008,consume = 1000,caozuo = -1,pengzh = -1,guiji = -1,chuantou = -1,time = -1,xingzh = -1,yuand = -1,chongf = -1,zhaoh = -1,xuanz = -1,shishi = -1,pianli = -1,consume = -1,cooling_time = -1,dongzuo = -1,zhunb = -1,shifangd = -1,shifang = -1,stx = -1,ztx = -1,shiyinxiao = -1,shihyinxiao = -1,shtx = -1,yinxiao = -1,jzdp = -1,dpsj = -1,txdh = -1,jndp = -1,dpfd = -1,kdsj = -1},
    id_9 = { id = 9,name = "火焰弹",script = "对附近玩家造成伤害",icon = -1,camera = 1,doSkillEffectList = "1009,1009,-1",readySkillAnim = -1,doSkillAnim = "skill2,skill2_1,skill2_2",endSkillAnim = -1,choose = 1,chooseParm = {},skill_type = 3,trigger_type = 1,target_type = 3,skilldo = 0,effect_id = -1,consume = 0,caozuo = -1,pengzh = -1,guiji = -1,chuantou = -1,time = -1,xingzh = -1,yuand = -1,chongf = -1,zhaoh = -1,xuanz = -1,shishi = -1,pianli = -1,consume = -1,cooling_time = -1,dongzuo = -1,zhunb = -1,shifangd = -1,shifang = -1,stx = -1,ztx = -1,shiyinxiao = -1,shihyinxiao = -1,shtx = -1,yinxiao = -1,jzdp = -1,dpsj = -1,txdh = -1,jndp = -1,dpfd = -1,kdsj = -1},
    id_10 = { id = 10,name = "火焰怪",script = "对附近玩家造成伤害",icon = -1,choose = 11,chooseParm = {{100,6}},skill_type = 3,trigger_type = 1,target_type = 3,skilldo = 0,effect_id = 1009,consume = 0,caozuo = -1,pengzh = -1,guiji = -1,chuantou = -1,time = -1,xingzh = -1,yuand = -1,chongf = -1,zhaoh = -1,xuanz = -1,shishi = -1,pianli = -1,consume = -1,cooling_time = -1,dongzuo = -1,zhunb = -1,shifangd = -1,shifang = -1,stx = -1,ztx = -1,shiyinxiao = -1,shihyinxiao = -1,shtx = -1,yinxiao = -1,jzdp = -1,dpsj = -1,txdh = -1,jndp = -1,dpfd = -1,kdsj = -1},
}
--]]

--效果配置
EffectConfig = GDatatab_effect
--[[
{
    --[触发时机（0立即，1命中后），效果对象（0目标，1自己，2己方队友，3敌方,4技能目标），效果主id,子id] | [触发特效列表,,,] | [对应特效的父容器,,,(1-自身，2-场景，3-指定pos的场景,4-释放对象,5自身-对象)]
    id_1001 = { id = 1001,effect = -1},
    id_1002 = { id = 1002,effect = {{0,4,22,1,101}}},--改创建子弹
    id_1003 = { id = 1003,effect = {{0,4,22,1,102}}},--改创建子弹
    id_1004 = { id = 1004,effect = {{0,4,21,2,102}}},
    id_1101 = { id = 1101,effect = {{0,4,2,1},{0,1,3,2,100}}},
    id_1102 = { id = 1102,effect = {{0,4,2,1},{0,1,3,2,100}}},

    id_1005 = { id = 1005,effect = {{0,4,21,2,104}}},
    id_1104 = { id = 1104,effect = {{0,4,2,1},{0,1,3,2,100}}},
    
    --id_1006 = { id = 1006,effect = {{0,4,21,2,105}}},调用捶地板特效 （废弃）
    id_1006 = { id = 1006,effect = {{0,4,2,1},{0,1,3,2,100}}},

    id_1007 = { id = 1007,effect = {{0,4,21,4,107,103,108}}},
    id_1008 = { id = 1008,effect = {{0,4,2,1},{0,1,3,2,100}}},--{ id = 1008,effect = {{0,4,18,1}}},

    id_1009 = { id = 1009,effect = {{0,4,22,1,201}}},
    id_1010 = { id = 1010,effect = {{0,4,2,1}}},

}
--]]

--特效配置
EffectInfoConfig = GDatatab_EffectInfoConfig
--[[
{
    -- [是否程序动画,是否临时特效,是否堵塞消息],[特效资源名, 特效名 ], [触发效果],[偏移ox，oy] , [缩放sx，sy] , [旋转] ,[横向全屏,纵向全屏]
    id_101 = { id = 101,name = "章鱼触手（废弃）",isCode = 0,isTmp = 1,isBlock = 1,source = "boos2_skill1_hit_01",start_actions = 0,actions = 0,actionIndexs = 0,doEffects = 1101,offsetX = 0,offsetY = 0,scaleX = 100,scaleY = 100,rotation = 0,tiledType = -1,isArmature = 1,isLoop = -1},
    id_102 = { id = 102,name = "章鱼之怒（改）",isCode = 0,isTmp = 1,isBlock = 1,source = "boos2_skill1_hit_01",start_actions = 0,actions = 0,actionIndexs = 0,doEffects = 1102,offsetX = 0,offsetY = 0,scaleX = 100,scaleY = 100,rotation = 0,tiledType = -1,isArmature = 1,isLoop = -1},
    id_103 = { id = 103,name = "激光",isCode = 0,isTmp = 1,isBlock = 1,source = "boos2_skill4_laser_01",start_actions = 1,actions = 1,actionIndexs = 0,doEffects = 1104,offsetX = 0,offsetY = 0,scaleX = 100,scaleY = 100,rotation = 0,tiledType = -1,isArmature = 1,isLoop = -1},
    id_104 = { id = 104,name = "炮弹爆炸",isCode = 0,isTmp = 1,isBlock = 1,source = "boos2_skill1_hit_01",start_actions = 0,actions = 0,actionIndexs = 0,doEffects = 1104,offsetX = 0,offsetY = 0,scaleX = 100,scaleY = 100,rotation = 0,tiledType = -1,isArmature = 1,isLoop = -1},
    --id_105 = { id = 105,name = "锤地板爆炸",isCode = 0,isTmp = 1,isBlock = 1,source = "boos2_skill3_hit_01",start_actions = 0,actions = 0,actionIndexs = 0,doEffects = 1105,offsetX = 0,offsetY = 0,scaleX = 100,scaleY = 100,rotation = 0,tiledType = -1,isArmature = 1,isLoop = -1},
    id_106 = { id = 106,name = "碾压特效",isCode = 0,isTmp = 1,isBlock = 1,source = "boos2_skill5_hit_01",start_actions = 0,actions = 0,actionIndexs = 0,doEffects = -1,offsetX = 0,offsetY = 0,scaleX = 100,scaleY = 100,rotation = 0,tiledType = -1,isArmature = 1,isLoop = -1},
    id_107 = { id = 107,name = "激光发射",isCode = 0,isTmp = 1,isBlock = 1,source = "boos2_skill4_laser_01",start_actions = 0,actions = 0,actionIndexs = 0,doEffects = -1,offsetX = 0,offsetY = 0,scaleX = 100,scaleY = 100,rotation = 0,tiledType = -1,isArmature = 1,isLoop = -1},
    id_108 = { id = 108,name = "激光目标",isCode = 0,isTmp = 1,isBlock = 1,source = "boos2_skill4_laser_01",start_actions = 2,actions = 2,actionIndexs = 0,doEffects = -1,offsetX = 0,offsetY = -200,scaleX = 100,scaleY = 100,rotation = 0,tiledType = -1,isArmature = 1,isLoop = -1},
    
    id_201 = { id = 201,name = "冰冻",isCode = 0,isTmp = 1,isBlock = 1,source = "skills_bdd_bd_01",start_actions = 0,actions = 1,actionIndexs = 0,doEffects = -1,offsetX = 20,offsetY = -50,scaleX = 130,scaleY = 130,rotation = 0,tiledType = -1,isArmature = 1,isLoop = 1},
    id_202 = { id = 202,name = "流血",isCode = 0,isTmp = 1,isBlock = 1,source = "skills_bleed_01",start_actions = 0,actions = 0,actionIndexs = 0,doEffects = -1,offsetX = 0,offsetY = 10,scaleX = 110,scaleY = 110,rotation = 0,tiledType = -1,isArmature = 1,isLoop = -1},
    id_203 = { id = 203,name = "魔法盾",isCode = 0,isTmp = 1,isBlock = 1,source = "skills_fhd_01",start_actions = 0,actions = 0,actionIndexs = 0,doEffects = -1,offsetX = 15,offsetY = -40,scaleX = 130,scaleY = 125,rotation = 0,tiledType = -1,isArmature = 1,isLoop = 1},
    id_204 = { id = 204,name = "隐身",isCode = 0,isTmp = 1,isBlock = 1,source = -1,start_actions = 0,actions = 0,actionIndexs = 0,doEffects = -1,offsetX = 0,offsetY = 0,scaleX = 100,scaleY = 100,rotation = 0,tiledType = -1,isArmature = -1,isLoop = -1},
    id_301 = { id = 301,name = "流血",isCode = 0,isTmp = 1,isBlock = 1,source = "skills_lx_02",start_actions = 0,actions = 0,actionIndexs = 0,doEffects = -1,offsetX = 0,offsetY = -50,scaleX = 130,scaleY = 130,rotation = 0,tiledType = -1,isArmature = 1,isLoop = -1},
    id_302 = { id = 302,name = "中毒",isCode = 0,isTmp = 1,isBlock = 1,source = "skills_lx_02",start_actions = 0,actions = 0,actionIndexs = 0,doEffects = -1,offsetX = 0,offsetY = -50,scaleX = 130,scaleY = 130,rotation = 0,tiledType = -1,isArmature = 1,isLoop = -1},
}
--]]

--AI配置
AiConfig = GDatatab_ai_id
--[[
{
    --配置:执行次数max(-1无限，0必定触发),行为,[行为参数],(条件)
    id_11 = {AI_id = 11,name = "机器人",peizhi ="-1,4_1,<8>,(10,300,6,2)|1,4_1,<6>,(5,90,6,1),(5,70,4,1)|1,4_1,<6>,(5,50,6,1),(5,30,4,1)|1,4_1,<6>,(5,10,6,1)|-1,4_1,<7>,(4,15)|-1,4_1,<9>,(4,45)|-1,1,<12,1,2>,(1,201)|0,4_1,<5>"},
    id_14 = {AI_id = 2,peizhi = "-1,8_1,<-1>,(3,2,4) | 1,4,<10>,(10,100,6,3)"},
    id_1 = {AI_id = 1,peizhi = "1,1,<4,1,9,750,850>,(4,100)|-1,4,<1>,(4,100)"},
    id_2 = {AI_id = 2,peizhi = "-1"},
}
--]]

--子弹配置
BulletInfoConfig = GDatatab_bullet
--[[
{
    id_6 = {name = "泥柱",bulletAnimMainName = "boss4",bulletAnimFlyName = "summon2",weaponName = "weapon21a",bulletAnimScale = 1,bulletType = 2,checkCharacterCollisionRadius = 40,isPenetrateMap = 1,attTimes = 1,scatterNum = 1,isIgnoreDef = 0,bulletAnimDefaultDirection = 1,isNeedExplode = 0,isNeedHurt = 1,offsetX = 0, offsetY = 0},
    id_101 = {name = "章鱼毒气弹",bulletAnimMainName = "boos2_skill2_hit_01",bulletAnimFlyName = "0",weaponName = "weapon21a",bulletAnimScale = 1,bulletType = 1,checkCharacterCollisionRadius = 40,isPenetrateMap = 0,attTimes = 1,scatterNum = 1,isIgnoreDef = 0,bulletAnimDefaultDirection = 1,isNeedExplode = 1,isNeedHurt = 1,offsetX = 0, offsetY = 0},
    id_102 = {name = "章鱼炸弹",bulletAnimMainName = "boos2_skill2_hit_01",bulletAnimFlyName = "0",weaponName = "weapon21a",bulletAnimScale = 1,bulletType = 0,checkCharacterCollisionRadius = 40,isPenetrateMap = 0,attTimes = 1,scatterNum = 1,isIgnoreDef = 0,bulletAnimDefaultDirection = 1,isNeedExplode = 1,isNeedHurt = 1,offsetX = 0, offsetY = 0},
    id_201 = {name = "机器人火炮子弹",bulletAnimMainName = "boos2_skill2_hit_01",bulletAnimFlyName = "0",weaponName = "weapon21a",bulletAnimScale = 1,bulletType = 0,checkCharacterCollisionRadius = 40,isPenetrateMap = 0,attTimes = 1,scatterNum = 1,isIgnoreDef = 0,bulletAnimDefaultDirection = 1,isNeedExplode = 1,isNeedHurt = 1,offsetX = 0, offsetY = 0},

    id_1001 = {name = "穿山甲角",bulletAnimMainName = "monster_bullet_0002",bulletAnimFlyName = "0",weaponName = "weapon1a",bulletAnimScale = 1,bulletType = 0,checkCharacterCollisionRadius = 40,isPenetrateMap = 0,attTimes = 1,scatterNum = 1,isIgnoreDef = 0,bulletAnimDefaultDirection = 1,isNeedExplode = 1,isNeedHurt = 1,offsetX = 0, offsetY = 0},
    id_1002 = {name = "花粒",bulletAnimMainName = "monster_bullet_0003",bulletAnimFlyName = "0",weaponName = "weapon1a",bulletAnimScale = 1,bulletType = 0,checkCharacterCollisionRadius = 40,isPenetrateMap = 0,attTimes = 1,scatterNum = 1,isIgnoreDef = 0,bulletAnimDefaultDirection = 1,isNeedExplode = 1,isNeedHurt = 1,offsetX = 0, offsetY = 0},
    id_1003 = {name = "鱼雷",bulletAnimMainName = "monster_bomb_0007",bulletAnimFlyName = "0",weaponName = "weapon1a",bulletAnimScale = 1,bulletType = 1,checkCharacterCollisionRadius = 40,isPenetrateMap = 1,attTimes = 1,scatterNum = 1,isIgnoreDef = 0,bulletAnimDefaultDirection = 1,isNeedExplode = 1,isNeedHurt = 1,offsetX = 0, offsetY = 0},
}
--]]
BossMapConfig = 
{
    id_20101 = { id = 20101,map_num = 1,difficulty = 1,map_name = "章鱼1",map_level = 1,pre_map_id = -1,map_desc = "章鱼1",map_target = "target_content5.png",mini_map = "map22.png",map = "map57",challenge_num = 30,pass_consume = 15,play_consume = 2,recommend_desc = "1~3人组队",monster_data = {{1,1100,650},{2,1100,650},{3,1100,650}},born_position = {{600,850},{600,850},{600,850}},fixed_reward = {{2,2000},{3,3000}},complete_time = 30,reward_boy = {{1,2,3,101,102,103,104,105}},draw_id = "101,101,102",reward_girl = {{1,2,3,101,102,103,104,105}}},
}

SingleMapConfig = 
{
    id_10101 = { id = 10101,map_type = 1,section = 1,section_name = "勇士啟航之旅",level = 1,map_num = 1,parent_id = -1,map_name = "虛晶礦洞",map_desc = "在暴風雨降臨前，平靜異常。",pass_hp = 1,pass_round = 20,pass_consume = 5,play_consume = 1,pass_times = 20,map_icon = "common_icon_xiao1.png",location = "0.426328,0.736451",position = {{450,880}},resources = "map98",fixed_reward = {{2,200},{3,500}},monster = {{101,350,1200}},dwar_girl = {{2,500,2500},{2,1000,500},{108,1,2500},{108,2,500}},dwar_boy = {{2,500,2500},{2,1000,500},{108,1,2500},{108,2,500}},reward_boy = {{2,108}},max_dwar = 1,reward_girl = {{2,108}}},
}
--GDatatab_single_map = SingleMapConfig
--伤害类型配置
HurtTypeConfig = 
{
    CALCULATE = 1,  --计算伤害
    LITERAL = 2,    --字面伤害
    CALCULATE_RESTORE = 3,  --计算回血
    LITERAL_RESTORE = 4,    --字面回血
}

--判断条件配置
OperatorConfig = 
{
    EQUAL = 1,          --等于
    NOT_EQUAL = 2,      --不等于
    GREATER = 3,        --大于
    GREATER_EQUAL = 4,  --大于等于
    LESS = 5,           --小于
    LESS_EQUAL = 6,     --小于等于
}

--方向配置
DistanceConfig = 
{
    NO = 1,
    X = 2,
    Y = 3,
}

--属性配置
AttributeChangeStateTimeType =
{
    TURN = 0,
    CTB = 1,
}

-- /** 道具属性--1生命 **/
--     public static final int HP               = 1;
--     /** 道具属性--2生命上限 **/
--     public static final int HP_MAX           = 2;
--     /** 道具属性—3攻击力 **/
--     public static final int ATTACK           = 3;
--     /** 道具属性--4防御力 **/
--     public static final int DEFEND           = 4;
--     /** 道具属性—5暴击 **/
--     public static final int CRIT             = 5;
--     /** 道具属性—6暴击率 **/
--     public static final int CRIT_RATE        = 6;
--     /** 道具属性--7免爆 **/
--     public static final int REDUCECRIT       = 7;
--     /** 道具属性--8免爆率 **/
--     public static final int REDUCECRIT_RATE  = 8;
--     /** 道具属性—9体质 **/
--     public static final int PHYSIQUE         = 9;
--     /** 道具属性--10力量 **/
--     public static final int POWER            = 10;
--     /** 道具属性—11护甲 **/
--     public static final int ARMOR            = 11;
--     /** 道具属性--12敏捷 **/
--     public static final int AGILITY          = 12;
--     /** 道具属性—13幸运 **/
--     public static final int LUCK             = 13;
--     /** 道具属性—14当前体力 **/
--     public static final int CURRENT_PHYSICAL = 14;
--     /** 道具属性--15体力上限 **/
--     public static final int PHYSICAL_MAX     = 15;
--     /** 道具属性—16当前怒气 **/
--     public static final int CURRENT_ANGER    = 16;
--     /** 道具属性—17怒气增速 **/
--     public static final int ANGER_GROWTH     = 17;
--     /** 道具属性—18范围 **/
--     public static final int RANGE            = 18;
--     /** 道具属性--19破防 **/
--     public static final int WRECKDEFENSE     = 19;
--     /** 道具属性—20免伤 **/
--     public static final int INJURYFREE       = 20;
--属性配置
AttributeConfig =
{
    HP = 1,
    MaxHP = 2,
    Attack = 3,
    Defence = 4,
    
    CriticalhitAttackRate = 5,
    CritProbability = 6,
    ReduceCrit = 7,
    ReduceCritRate = 8,
    Constitution = 9,   --体质
    Power = 10, --力量
    Armor = 11, --护甲
    Agility = 12,   --敏捷
    Lucky = 13, --幸运
    PF = 14,
    MaxPF = 15,
    SP = 16,
    SPChange = 17,
    BrokeRange = 18,
    WreckDefense = 19,  --破防
    InjuryFree = 20,    --免伤
    AttTimes = 21,
    AttScatterNum = 22,
    HideTurn = 23,
    BuffInvincibleRound = 24,
}

--子弹是否老动画配置
BulletConfig =
{
    battleEfficients = true,
    boss = true,
    monster1 = true,
    monster2 = true,
    boss2_1 = true,
    boss2_2 = true,
    boss3_1 = true,
    boss3_2 = true,
    boss4 = true,
    tornado = true,
    monster3 = true,
    boss5 = true,
    monster5 = true,
    boss6 = true,
    worldboss = true,
}

--子弹动画文件位置配置
BulletResFolderConfig =
{
    [1] = "monster_bullet_",
    [2] = "bullet_",
}

--技能表类型配置
SkillTableTypeConfig =
{
    TIMES = 1, --连发
    SCATTER = 2, --散射
    POWER = 3, --威力
    FROZEN = 4, --冰冻
    NBOMB = 5, --核弹
    IMPACT = 6, --冲击
    TRACK = 7, --追踪
    POISION = 8, --毒
    SILENCE = 9, --沉默
    BOUND = 10, --束缚
    TORNADO = 11, --龙卷
    SPATTER = 12, --溅射
    MIST = 13,  --烟雾弹
    CURE = 14,  --治疗弹
    TRANSFER_POSITION = 15,--换位弹
}
