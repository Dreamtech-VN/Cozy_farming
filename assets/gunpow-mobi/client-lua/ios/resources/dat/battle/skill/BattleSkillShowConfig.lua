--BattleSkillShowConfig.lua
--@brief    表演配置
--@date     2015/08/19
BattleSkillType = {
    --表现类型
    BEGIN = 1,
    PLAY = 100,       --播放动画
    PLAY_LOOP = 101,  --持续播放
    PLAY_MACHINE = 102,  --机关播放动作
    PLAY_STEP = 103,    --播放动作，不主动回切stand
    PLAY_RESET_STEP = 104,   --设置回切stand
    PLAY_SOUND = 110, --播放音效
    DELAY = 200,      --延迟
    SPRING = 300,     --震屏幕
    CAMERA = 400,     --镜头移动
    FLASH = 500,      --技能特效
    EFFECT = 600,     --技能效果
    EFFECT_IN_SKILL = 601,    --技能效果(读取技能列表的effect_id)
    ADD_BUFF = 602,         --加buff
    REMOVE_BUFF = 603,      --移除buff

    MONSTER_SHOOT = 700,      --怪物射击
    UPDATE_BULLET  =701,    --子弹loop（爆破旋转）
    REPEAT_SHOOT = 702,       --连发（射击自动调用连发的loop）
    FOLLOW_BULLET = 703,      --跟随子弹（射击结束自动调用跟随的loop）
    MONSTER_SHOOT_ANIMA_LOOP = 704, --射击动作loop
    MONSTER_BOSS_GUN_SHOOT = 10000, --boss1炮台攻击
    MONSTER_BOSS_GUN_ROTATION = 10001,--boss1炮台调整角度
    MONSTER_BOSS_GUN_ROTATION_RESET = 10002,--boss1炮台调整角度

    SUMMON = 800,            --召唤怪物(自动调用summonSend loop)
    SUMMON_II = 801,         --召唤怪物（用攻击爆破点作为出生点）(自动调用summonSend loop)
    SUMMON_SEND = 802,       --召唤小怪发送协议
    SUMMON_BUILD = 803,     -- 创建小怪

    CREATE_ASSISTED_MSG = 900,  --创建特殊的表现消息
    UPDATE_FLIPX = 1000,    --根据目标调整方向
    MOVE_DISTANCE = 1100,    --相对位置移动
    REMOVE_GUAI = 2000,     --移除怪物
}
--[[
    warning(警告): 
    PLAY_SOUND , UPDATE_FLIPX PLAY_RESET_STEP 不能单独添加next（除非有其他同步行为会调用reduceWait） 否则不能结束或继续表演
    - 
]]
BattleSkillTargetType = {
    SELF = 1,
    TARGET = 2,
    SCENE = 3,
    OTHER = 4,
}

FlashPosType = {
    MYSELF = 1,
    TARGET = 2,
    SCENE = 3,
    LINE = 4,       ---特色类型 连线
}

BattleSkillShowConfig = {
    --特殊参数
    --@isResetMachine 属性不为nil或false 可会重置临时的actor，shooter变量
    --目标点移动
    id_1 = {
        name = "目标点移动",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1,nextAct = -1},
    },
    --自爆（附带一个效果）
    id_2 = {
        name = "自爆（附带一个效果）",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 2,nextAct = "3"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 1,isWait = 1,nextAct = "4"},
        [4] = {actType = BattleSkillType.REMOVE_GUAI,nextAct = -1},
    },

    --自爆不带伤害（附带一个效果）
    id_3 = {
        name = "自爆不带伤害（附带一个效果）",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 3,nextAct = "3"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 1,isWait = 1,nextAct = "4"},
        [4] = {actType = BattleSkillType.REMOVE_GUAI,nextAct = -1},
    },
    
    --怪物飞行
    id_4 = {
        name = "怪物飞行",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 4,nextAct = -1},
    },

    --使用技能效果
    id_5 = {
        name = "使用技能效果",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = -10000,nextAct = -1},
    },

    --近身攻击
    id_10 = {
        name = "近身攻击",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 10,nextAct = -1},
    },

    --射击(带1段效果)
    id_101 = {
        name = "废弃",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,3"},
        [2] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill1",param2 = "skill2",nextAct = "4"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 1,isWait = 1,nextAct = -1},
        [4] = {actType = BattleSkillType.MONSTER_SHOOT,param1 = nil,isWait = 1,nextAct = -1},
    },

    --射击(带2段效果)
    id_102 = {
        name = "废弃",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill1",param2 = "skill2",nextAct = "3,4"},
        [3] = {actType = BattleSkillType.MONSTER_SHOOT,param1 = nil,isWait = 1,nextAct = "5"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 1,isWait = 1,nextAct = -1},
        [5] = {actType = BattleSkillType.DELAY,isWait = 1,param1 = 600,nextAct = "6"}, 
        [6] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 2,isWait = 1,nextAct = -1},
    },

    --新手BOSS射击1(普攻)
    id_103 = {
        name = "新手BOSS射击1(普攻)",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "100,101"},
        [2] = {actType = BattleSkillType.PLAY_STEP,isWait = 1,param1 = "shoot_1",nextAct = "4"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 1,isWait = 1,nextAct = -1},
        [4] = {actType = BattleSkillType.MONSTER_SHOOT,isWait = 1,param1 = nil,param2 = "shoot_2",param3 = "shoot_3",nextAct = -1},

        
        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "mly_gj",nextAct = -1},
        [101] = {actType = BattleSkillType.DELAY,isWait = 1,param1 = 1000,nextAct = "2,3"},
    },
    
    --新手BOSS射击2(散射)
    id_104 = {
        name = "新手BOSS射击2(散射)",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "100,101"},
        [2] = {actType = BattleSkillType.PLAY_STEP,isWait = 1,param1 = "shoot_1",nextAct = "4"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 1,isWait = 1,nextAct = -1},
        [4] = {actType = BattleSkillType.MONSTER_SHOOT,isWait = 1,param1 = nil,param2 = "shoot_2",param3 = "shoot_3",nextAct = "5"},
        [5] = {actType = BattleSkillType.DELAY,isWait = 1,param1 = 600,nextAct = "6"}, 
        [6] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 2,isWait = 1,nextAct = -1},
        
        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "mly_speak1",nextAct = -1},
        [101] = {actType = BattleSkillType.DELAY,isWait = 1,param1 = 2000,nextAct = "2,3"},
    },

    
    --新手BOSS射击3(连发)
    id_105 = {
        name = "新手BOSS射击3(连发)",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "100,101"},
        [2] = {actType = BattleSkillType.PLAY_STEP,isWait = 1,param1 = "shoot_1",nextAct = "4"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 1,isWait = 1,nextAct = -1},
        [4] = {actType = BattleSkillType.MONSTER_SHOOT,isWait = 1,param1 = nil,param2 = "shoot_2",param3 = "shoot_3",nextAct = "5"},
        [5] = {actType = BattleSkillType.DELAY,isWait = 1,param1 = 600,nextAct = "6"}, 
        [6] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 2,isWait = 1,nextAct = -1},
        
        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "mly_speak2",nextAct = -1},
        [101] = {actType = BattleSkillType.DELAY,isWait = 1,param1 = 2000,nextAct = "2,3"},
    },


    --射击(带1段效果)
    id_201 = {
        name = "普通射击带一段效果",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,3"},
        [2] = {actType = BattleSkillType.PLAY_STEP,isWait = 1,param1 = "shoot_1",nextAct = "4"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 1,isWait = 1,nextAct = -1},
        [4] = {actType = BattleSkillType.MONSTER_SHOOT,isWait = 1,param1 = nil,param2 = "shoot_2",param3 = "shoot_3",nextAct = -1},
        -- [5] = {actType = BattleSkillType.PLAY_RESET_STEP,param1 = "shoot_3",nextAct = -1},
    },

    --射击(带2段效果)
    id_202 = {
        name = "普通射击带两段效果",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,3"},
        [2] = {actType = BattleSkillType.PLAY_STEP,isWait = 1,param1 = "shoot_1",nextAct = "4"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 1,isWait = 1,nextAct = -1},
        [4] = {actType = BattleSkillType.MONSTER_SHOOT,isWait = 1,param1 = nil,param2 = "shoot_2",param3 = "shoot_3",nextAct = "5"},
        [5] = {actType = BattleSkillType.DELAY,isWait = 1,param1 = 600,nextAct = "6"}, 
        [6] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 2,isWait = 1,nextAct = -1},
    },

    --射击(带2段效果)
    id_203 = {
        name = "普通射击带三段效果",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,3"},
        [2] = {actType = BattleSkillType.PLAY_STEP,isWait = 1,param1 = "shoot_1",nextAct = "4"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 1,isWait = 1,nextAct = -1},
        [4] = {actType = BattleSkillType.MONSTER_SHOOT,isWait = 1,param1 = nil,param2 = "shoot_2",param3 = "shoot_3",nextAct = "5"},
        [5] = {actType = BattleSkillType.DELAY,isWait = 1,param1 = 600,nextAct = "6,7"}, 
        [6] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 2,isWait = 1,nextAct = -1},
        [7] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 3,isWait = 1,nextAct = -1},
    },

    id_204 = {
        name = "群体近身攻击",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.TARGET,nextAct = "3"},
        [3] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 203,nextAct = -1},
    },

    --boss1 炮台直线攻击
    id_1001 = {
        name = "炮台直线(攻击)",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SELF,nextAct = "3,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "command1",nextAct = "4,5"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 0,param1 = "command2",nextAct = -1},
        [5] = {actType = BattleSkillType.MONSTER_BOSS_GUN_ROTATION,isWait = 1,param1 = 2001,nextAct = "6"},
        [6] = {actType = BattleSkillType.PLAY_MACHINE,isWait = 1,param1 = "skill1",nextAct = "7,9"},
        [7] = {actType = BattleSkillType.MONSTER_BOSS_GUN_SHOOT,isWait = 1,nextAct = "8"},
        [8] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "10"},
        [9] = {actType = BattleSkillType.PLAY_MACHINE,isWait = 1,param1 = "skill2",nextAct = -1},
        [10] = {actType = BattleSkillType.MONSTER_BOSS_GUN_ROTATION_RESET,isWait = 1,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss1_gongji",nextAct = -1},
    },
    --boss1 炮台抛物线攻击(带击退)
    id_1002 = {
        name = "炮台抛物线(攻击)",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SELF,nextAct = "3,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "command1",nextAct = "4,5"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 0,param1 = "command2",nextAct = -1},
        [5] = {actType = BattleSkillType.MONSTER_BOSS_GUN_ROTATION,isWait = 1,param1 = 2002,nextAct = "6"},
        [6] = {actType = BattleSkillType.PLAY_MACHINE,isWait = 1,param1 = "skill1",nextAct = "7,9"},
        [7] = {actType = BattleSkillType.MONSTER_BOSS_GUN_SHOOT,isWait = 1,nextAct = "8"},
        [8] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "10"},
        [9] = {actType = BattleSkillType.PLAY_MACHINE,isWait = 1,param1 = "skill2",nextAct = -1},
        [10] = {actType = BattleSkillType.MONSTER_BOSS_GUN_ROTATION_RESET,isWait = 1,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss1_gongji",nextAct = -1},
    },
    --boss1 击飞
    id_1003 = {
        name = "boss1击飞",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SELF,nextAct = "3"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "4,5"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill",nextAct = -1},
        [5] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.TARGET,nextAct = "6"},
        [6] = {actType = BattleSkillType.EFFECT,isWait = 1,param1 = 20001,nextAct = "7"},
        [7] = {actType = BattleSkillType.DELAY,isWait = 1,param1 = 1000,nextAct = "8"},
        [8] = {actType = BattleSkillType.EFFECT,isWait = 1,param1 = 10001,nextAct = -1},
    },
    --boss1 召唤
    id_1004 = {
        name = "boss1召唤",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "3"},
        -- [2] = {actType = BattleSkillType.SUMMON,isWait = 1,nextAct = "3"},
        [3] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SELF,nextAct = "4,100"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "summon1",nextAct = "5,6"},
        [5] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "summon2",nextAct = -1},
        [6] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "7"},
        [7] = {actType = BattleSkillType.SUMMON_BUILD,isWait = 1,param1 = true,param2 = 101,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss1_zhaohuan",nextAct = -1},
    },
     --boss1 炮台抛物线攻击
    id_1005 = {
        name = "炮台抛物线(攻击)",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SELF,nextAct = "3"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "command",nextAct = "4"},
        [4] = {actType = BattleSkillType.MONSTER_BOSS_GUN_ROTATION,isWait = 1,param1 = 2002,nextAct = "5"},
        [5] = {actType = BattleSkillType.PLAY_MACHINE,isWait = 1,param1 = "skill1",nextAct = "6,7"},
        [6] = {actType = BattleSkillType.MONSTER_BOSS_GUN_SHOOT,isWait = 1,nextAct = "8"},
        [7] = {actType = BattleSkillType.PLAY_MACHINE,isWait = 1,param1 = "skill2",nextAct = -1},
        [8] = {actType = BattleSkillType.MONSTER_BOSS_GUN_ROTATION_RESET,isWait = 1,nextAct = -1},
    },

    --boss2 召唤飞轮
    id_2001 = {
        name = "召唤飞轮",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "3"},
        -- [2] = {actType = BattleSkillType.SUMMON,isWait = 1,nextAct = "3"},
        [3] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SELF,nextAct = "4,100"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "summon",nextAct = "5"},
        [5] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "6"},
        [6] = {actType = BattleSkillType.SUMMON_BUILD,isWait = 1,param1 = false,nextAct = "7"},
        [7] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 2001,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss2_fenghuolun",nextAct = -1},
    },
    --boss2 飞轮攻击
    id_2002 = {
        name = "飞轮攻击",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SELF,nextAct = "3"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "order",nextAct = "4,100"},
        [4] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 2002,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss2_gongji",nextAct = -1},
    },

    --boss2 跳跃攻击
    id_2003 = {
        name = "右跳左跃攻击",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SELF,nextAct = "3,4"},
        [3] = {actType = BattleSkillType.UPDATE_FLIPX,param1 = 1,nextAct = -1},
        [4] = {actType = BattleSkillType.PLAY_STEP,isWait = 1,param1 = "skill5_1",nextAct = "5,100"},
        [5] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 201,param2 = {pos = {x = 158,y= 960},speed = 20},nextAct = "6,7"},
        [6] = {actType = BattleSkillType.PLAY_RESET_STEP,nextAct = -1},
        [7] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill5_2",nextAct = "8,9"},
        [8] = {actType = BattleSkillType.SPRING,param1 = BattleSkillTargetType.SELF,nextAct = -1},
        [9] = {actType = BattleSkillType.EFFECT,isWait = 1,param1 = 20007,nextAct = "10"},
        [10] = {actType = BattleSkillType.EFFECT,isWait = 1,param1 = 20001,nextAct = "11,12"},
        [11] = {actType = BattleSkillType.UPDATE_FLIPX,param1 = 0,nextAct = -1},
        [12] = {actType = BattleSkillType.PLAY,param1 = "skill5_3",nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "26",nextAct = -1},
    },

    --boss2 左到右跳跃攻击
    id_2004 = {
        name = "左到右跳跃攻击",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SELF,nextAct = "3,4"},
        [3] = {actType = BattleSkillType.UPDATE_FLIPX,param1 = 0,nextAct = -1},
        [4] = {actType = BattleSkillType.PLAY_STEP,isWait = 1,param1 = "skill5_1",nextAct = "5,100"},
        [5] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 201,param2 = {pos = {x = 158,y= 960},speed = 20},nextAct = "6,7"},
        [6] = {actType = BattleSkillType.PLAY_RESET_STEP,nextAct = -1},
        [7] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill5_2",nextAct = "8,9"},
        [8] = {actType = BattleSkillType.SPRING,param1 = BattleSkillTargetType.SELF,nextAct = -1},
        [9] = {actType = BattleSkillType.EFFECT,isWait = 1,param1 = 20007,nextAct = "10"},
        [10] = {actType = BattleSkillType.EFFECT,isWait = 1,param1 = 20001,nextAct = "11,12"},
        [11] = {actType = BattleSkillType.UPDATE_FLIPX,param1 = 1,nextAct = -1},
        [12] = {actType = BattleSkillType.PLAY,param1 = "skill5_3",nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "26",nextAct = -1},
    },

    --boss3 集体行动
    id_1301 = {
        name = "boss3集体行动",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3"},
        [3] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1301,nextAct = -1},
    },

    --boss3 献祭(治疗)
    id_1302 = {
        name = "献祭(治疗)",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,4,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill3_1",nextAct = "5,6,7,8"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},
        [5] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill3_2",nextAct = -1},
        [6] = {actType = BattleSkillType.FLASH,isWait = 0,param1 = 1008,param2 = FlashPosType.TARGET,nextAct = -1},
        -- [7] = {actType = BattleSkillType.EFFECT,isWait = 1,param1 = 20001,nextAct = "8"},
        [8] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss3_shifa",nextAct = -1},
    },
    --boss3 献祭(爆炸)
    id_1303 = {
        id = 1303,
        name = "献祭(爆炸)",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,4,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill3_1",nextAct = "5,6,7"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},
        [5] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill3_2",nextAct = -1},
        [6] = {actType = BattleSkillType.FLASH,isWait = 0,param1 = 1009,param2 = FlashPosType.TARGET,nextAct = -1},
        [7] = {actType = BattleSkillType.EFFECT,isWait = 1,param1 = 20001,nextAct = "8"},
        [8] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss3_shifa",nextAct = -1},
    },
    --boss3 献祭(中毒)
    id_1304 = {
        name = "献祭(中毒)",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,4,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill3_1",nextAct = "5,6,7"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},
        [5] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill3_2",nextAct = -1},
        [6] = {actType = BattleSkillType.FLASH,isWait = 0,param1 = 1010,param2 = FlashPosType.TARGET,nextAct = -1},
        [7] = {actType = BattleSkillType.EFFECT,isWait = 1,param1 = 20001,nextAct = "8"},
        [8] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss3_shifa",nextAct = -1},
    },
    --boss3 献祭(冰冻)
    id_1305 = {
        name = "献祭(冰冻)",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,4,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill3_1",nextAct = "5,6,7"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},
        [5] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill3_2",nextAct = -1},
        [6] = {actType = BattleSkillType.FLASH,isWait = 0,param1 = 1011,param2 = FlashPosType.TARGET,nextAct = -1},
        [7] = {actType = BattleSkillType.EFFECT,isWait = 1,param1 = 20001,nextAct = "8"},
        [8] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss3_shifa",nextAct = -1},
    },
    

    --boss3 召唤
    id_1306 = {
        name = "召唤",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "3"},
        -- [2] = {actType = BattleSkillType.SUMMON,isWait = 1,nextAct = "3"},
        [3] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "4"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "summon",nextAct = "5,100"},
        [5] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "6"},
        [6] = {actType = BattleSkillType.SUMMON_BUILD,isWait = 1,param1 = true,param2 = 1006,param3 = true,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss1_zhaohuan",nextAct = -1},
    },

    --boss4 冰刺
    id_1401 = {
        name = "冰刺",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.TARGET,nextAct = "200"},
        [3] = {actType = BattleSkillType.FLASH,isWait = 0,param1 = 1005,param2 = FlashPosType.TARGET,nextAct = "4"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill",nextAct = "5"},
        [5] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 10003,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss4_bingci",nextAct = -1},
        [200] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "4,100"},
    },

    --boss4 狂风暴雪
    id_1402 = {
        name = "狂风暴雪",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.TARGET,nextAct = "200"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill4",nextAct = "4,5,7,100"},
        [4] = {actType = BattleSkillType.EFFECT,isWait = 1,param1 = 20001,nextAct = -1},
        [5] = {actType = BattleSkillType.PLAY_LOOP,isWait = 1,param1 = "skill5",param2 = 3000,nextAct = "-1"},
        [6] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill6",nextAct = "-1"},
        [7] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 10004,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss4_baofengxue",nextAct = -1},
        [200] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "3"},
    },

    --boss4 召唤分身
    id_1403 = {
        name = "召唤分身",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "3"},
        -- [2] = {actType = BattleSkillType.SUMMON,isWait = 1,nextAct = "3"},
        [3] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SELF,nextAct = "4,100"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "summon",nextAct = "5"},
        [5] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "6"},
        [6] = {actType = BattleSkillType.SUMMON_BUILD,isWait = 1,param1 = false,nextAct = "7"},
        [7] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 10005,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss4_zhaohuan",nextAct = -1},
    },

    --boss5 随机传送
    id_1501 = {
        name = "boss5普攻",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,3"},
        [2] = {actType = BattleSkillType.PLAY_STEP,isWait = 1,param1 = "shoot_1",nextAct = "4"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 1,isWait = 1,nextAct = -1},
        [4] = {actType = BattleSkillType.MONSTER_SHOOT,isWait = 1,param1 = nil,param2 = "shoot_2",param3 = "shoot_3",nextAct = "5"},
        [5] = {actType = BattleSkillType.DELAY,isWait = 1,param1 = 600,nextAct = "6"}, 
        [6] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 2,isWait = 1,nextAct = "7"},
        [7] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.TARGET,nextAct = -1},
    },

    --boss5 召唤礼物
    id_1502 = {
        name = "召唤礼物",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "summon2",nextAct = "4"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "5"},
        [5] = {actType = BattleSkillType.SUMMON_BUILD,isWait = 1,param1 = false,nextAct = "6"},
        [6] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1501,nextAct = -1},
    },
    --boss5 聚光灯
    id_1503 = {
        name = "聚光灯",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "gather",nextAct = "4,100"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "5"},
        [5] = {actType = BattleSkillType.SUMMON_BUILD,isWait = 1,param1 = false,nextAct = "6"},
        [6] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1502,nextAct = "7"},
        [7] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "xiaochoucai",nextAct = -1},
    },

    --boss5 深情演绎
    id_1504 = {
        name = "深情演绎",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.TARGET,nextAct = "3,4,100"},
        [3] = {actType = BattleSkillType.PLAY_LOOP,isWait = 1,param1 = "conjure1",param2 = 2000,nextAct = "5"},
        [4] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1503,nextAct = -1},
        [5] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "xiaochouyinyue",nextAct = -1},
    },

    --boss5 主角光环
    id_1505 = {
        name = "主角光环",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "conjure2",nextAct = "3"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},
    },

    --boss6 男boss 普通攻击
    id_1601 = {
        name = "男boss6 普通攻击",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,3"},
        [2] = {actType = BattleSkillType.PLAY_STEP,isWait = 1,param1 = "shoot_1",nextAct = "4"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 1,isWait = 1,nextAct = -1},
        [4] = {actType = BattleSkillType.MONSTER_SHOOT,isWait = 1,param1 = nil,param2 = "shoot_2",param3 = "shoot_3",nextAct = "5"},
        [5] = {actType = BattleSkillType.DELAY,isWait = 1,param1 = 600,nextAct = "6"}, 
        [6] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 2,isWait = 1,nextAct = -1},
        -- [6] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1601,nextAct = "7"},
        -- [7] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.TARGET,nextAct = -1},
    },

    --boss6 男boss 怒击
    id_1602 = {
        name = "boss6怒击",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,3,100"},
        [2] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "powAtk_1",nextAct = "4,5,6"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "powAtk_2",nextAct = "7"},
        [5] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},
        [6] = {actType = BattleSkillType.SPRING,param1 = BattleSkillTargetType.TARGET,nextAct = -1},
        [7] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 3,nextAct = -1},
        
        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "mosijineng",nextAct = -1},
    },

    --boss6 男boss 抓取
    id_1603 = {
        name = "boos6抓取",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,100"},
        [2] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "carry_1",nextAct = "3,4,5"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "carry_2",nextAct = -1},
        [5] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "mosichuansong",nextAct = -1},
    },

    --boss6 召唤(复活)
    id_1604 = {
        name = "boss6复活",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "reborn_1",nextAct = "4,5"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "reborn_2",nextAct = -1},
        [5] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "6"},
        [6] = {actType = BattleSkillType.SUMMON_BUILD,isWait = 1,param1 = false,nextAct = "7"},
        [7] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1604,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "nisifuhuo",nextAct = -1},
    },

    --boss6 女boss 普通攻击
    id_1611 = {
        name = "boss6普通攻击2",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,3"},
        [2] = {actType = BattleSkillType.PLAY_STEP,isWait = 1,param1 = "shoot_1",nextAct = "4"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 1,isWait = 1,nextAct = -1},
        [4] = {actType = BattleSkillType.MONSTER_SHOOT,isWait = 1,param1 = nil,param2 = "shoot_2",param3 = "shoot_3",nextAct = "5"},
        [5] = {actType = BattleSkillType.DELAY,isWait = 1,param1 = 600,nextAct = "6"}, 
        [6] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 2,isWait = 1,nextAct = "7"},
        [7] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.TARGET,nextAct = -1},
    },

    --boss6 女boss 快速攻击
    id_1612 = {
        name = "快速攻击",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,3"},
        [2] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "quickAtk_1",nextAct = "4,5"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "quickAtk_2",nextAct = "6,7"},
        [5] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},
        [6] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "quickAtk_3",nextAct = "8,9"},
        [7] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 3,nextAct = -1},
        [8] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "quickAtk_4",nextAct = "10"},
        [9] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 4,nextAct = -1},
        [10] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 5,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "zhuajijineng",nextAct = -1},
    },

    --boss6 群蝠
    id_1613 = {
        name = "群蝠",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "batAtk_1",nextAct = "4,5"},
        [4] = {actType = BattleSkillType.PLAY_LOOP,isWait = 1,param1 = "batAtk_2",param2 = 3000,nextAct = "6"},
        [5] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1613,nextAct = -1},
        [6] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "batAtk_3",nextAct = "7"},
        [7] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "bianfujineng",nextAct = -1},
    },

    --boss7 
    id_1701 = {
        name = "高射炮",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,4"},
        [3] = {actType = BattleSkillType.UPDATE_FLIPX,param1 = 1,nextAct = -1},
        [4] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1701,nextAct = -1},
    },

    id_1702 = {
        name = "boss7移动",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3"},
        [3] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1702,nextAct = -1},
    },

    id_1703 = {
        name = "一段变身",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "trans_1",nextAct = "4"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss4_zhaohuan",nextAct = -1},
    },

    id_1704 = {
        name = "二段变身",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "trans_2",nextAct = "4,5,6"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},
        [5] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},
        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss4_zhaohuan",nextAct = -1},
    },

    id_1705 = {
        name = "激光扫射",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "laser",nextAct = "4"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "5"},
        [5] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "shalujiguang",nextAct = -1},
    },

    --组队副本8
    id_1801 = {
        name = "一段变身",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,101"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "trans",nextAct = "4"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},
        
        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "bianshen",nextAct = -1},
        [101] = {actType = BattleSkillType.UPDATE_FLIPX,param1 = 1,nextAct = -1},
    },

    id_1802 = {
        name = "捶地",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,101"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,4,100"},

        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "nearAtk_1",nextAct = "5,6"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},

        [5] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "nearAtk_2",nextAct = -1},
        [6] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "rongyangongji",nextAct = -1},
        [101] = {actType = BattleSkillType.UPDATE_FLIPX,param1 = 1,nextAct = -1},
    },

    id_1803 = {
        name = "捶飞",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,101"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,4,100"},

        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "powAtk_1",nextAct = "5,6,7,8,9"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},

        [5] = {actType = BattleSkillType.SPRING,param1 = BattleSkillTargetType.TARGET,nextAct = -1},
        [6] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "powAtk_2",nextAct = -1},
        [7] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},
        [8] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 3,nextAct = -1},
        [9] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 4,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "rongyangongji",nextAct = -1},
        [101] = {actType = BattleSkillType.UPDATE_FLIPX,param1 = 1,nextAct = -1},
    },

    id_1804 = {
        name = "熔岩之怒",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,101"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,4,100"},

        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "angAtk_1",nextAct = "5,6,7"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},

        [5] = {actType = BattleSkillType.SPRING,param1 = BattleSkillTargetType.TARGET,nextAct = -1},
        [6] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "angAtk_2",nextAct = -1},
        [7] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1804,nextAct = -1},

        [101] = {actType = BattleSkillType.UPDATE_FLIPX,param1 = 1,nextAct = -1},
        --[7] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},
    },

     id_1805 = {
        name = "boss8召唤",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,101"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "summon_1",nextAct = "4,5"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "summon_2",nextAct = -1},
        [5] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "6"},
        [6] = {actType = BattleSkillType.SUMMON_BUILD,isWait = 1,param1 = false,nextAct = "7"},
        [7] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1805,nextAct = -1},

        [101] = {actType = BattleSkillType.UPDATE_FLIPX,param1 = 1,nextAct = -1},
    },
   
    --boss9
    id_1901 = {
        name = "近身攻击",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,4,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "attack_1",nextAct = "5"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},

        [5] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "attack_2",nextAct = "6,7,8"},

        [6] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},
        [7] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 3,nextAct = -1},
        [8] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "attack_3",nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "dianju",nextAct = -1},
    },

    id_1902 = {
        name = "跳踩攻击",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SELF,nextAct = "3,100"},
        
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "tread_1",nextAct = "4"},
        [4] = {actType = BattleSkillType.PLAY_STEP,isWait = 1,param1 = "tread_2",nextAct = "5,6"},

        [5] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},
        [6] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 202,nextAct = "7,8"},
        
        [7] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "tread_3",nextAct = "9"},
        [8] = {actType = BattleSkillType.SPRING,param1 = BattleSkillTargetType.SELF,nextAct = -1},
        
        [9] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = "10"},

        [10] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 3,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "jifeixing",nextAct = -1},
    },

    id_1903 = {
        name = "一段变身",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "trans",nextAct = "4"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "5"},
        [5] = {actType = BattleSkillType.PLAY_STEP,isWait = 1,param1 = "fly",nextAct = "6"},
        [6] = {actType = BattleSkillType.MOVE_DISTANCE,isWait = 1,param1 = 2,param2 = 300,param3 = 15,nextAct = -1},
        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "kelinqifei",nextAct = -1},
    },

    id_1904 = {
        name = "隐身",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,101"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "hide",nextAct = "4,100"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct ="5"},
        [5] = {actType = BattleSkillType.DELAY,isWait = 1,param1 = 1500,nextAct = "6"}, 
        [6] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1905,nextAct = -1},
        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss4_zhaohuan",nextAct = -1},
    },

    id_1905 = {
        name = "随机换位",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1905,nextAct = -1},
    },

    id_1906 = {
        name = "散弹攻击",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "4"},
        [4] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1906,nextAct = -1},
    },

    id_1907 = {
        name = "移动到最近玩家",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,100"},
        [2] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 5,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "jiyidong",nextAct = -1},
    },

    id_1908 = {
       name = "射击位移",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,3"},
        [2] = {actType = BattleSkillType.PLAY_STEP,isWait = 1,param1 = "shoot_1",nextAct = "4"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 1,isWait = 1,nextAct = -1},
        [4] = {actType = BattleSkillType.MONSTER_SHOOT,isWait = 1,param1 = nil,param2 = "shoot_2",param3 = "shoot_3",nextAct = "5"},
        [5] = {actType = BattleSkillType.DELAY,isWait = 1,param1 = 600,nextAct = "6"}, 
        [6] = {actType = BattleSkillType.EFFECT_IN_SKILL,param1 = 2,isWait = 1,nextAct = "7"},
        [7] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 1905,nextAct = -1},
    },

    --boss10(id2001 boss2 已经占位)
    id_2101 = {
        name = "近身攻击",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,4,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "atk_1_1",nextAct = "5"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},

        [5] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "atk_1_2",nextAct = "6,7"},

        [6] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},
        [7] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "atk_1_3",nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "dianju",nextAct = -1},
    },


    id_2102 = {
        name = "一段变身",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "trans",nextAct = "4"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "kelinqifei",nextAct = -1},
    },

    id_2103 = {
        name = "标记",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,101"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "sign",nextAct = "4,100"},
        [4] = {actType = BattleSkillType.ADD_BUFF,isWait = 1,param1 = 2,param2 = 7016,nextAct =-1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss4_zhaohuan",nextAct = -1},
    },

    id_2104 = {
        name = "全屏攻击 （击飞）",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,100"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,4"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "tread_1",nextAct = "5,6"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},

        [5] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "tread_2",nextAct = "7,8"},
        [6] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},

        [7] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 3,nextAct = -1},
        [8] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "tread_3",nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "jiyidong",nextAct = -1},

    },

    id_2105 = {
        name = "毒雾攻击",
        
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,4,100"},

        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "pow_1",nextAct = "5,6,7"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},

        [5] = {actType = BattleSkillType.PLAY_LOOP,isWait = 1,param1 = "pow_2",param2 = 2000,nextAct = "8"},
        [6] = {actType = BattleSkillType.SPRING,param1 = BattleSkillTargetType.TARGET,nextAct = -1},
        [7] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 2104,nextAct = -1},

        [8] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = "9,10"},

        [9] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "pow_3",nextAct = -1},
        [10] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 2104,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "rongyangongji",nextAct = -1},
        [101] = {actType = BattleSkillType.UPDATE_FLIPX,param1 = 1,nextAct = -1},
    },

    id_2106 = {
        name = "毒雾喷射",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,3"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = -1},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "4"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "shoot_1",nextAct = "5,6"},
        [5] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "shoot_2",nextAct = "7"},
        [6] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 2106,nextAct = -1},
        [7] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "shoot_3",nextAct = -1},
    },

    id_2107 = {
        name = "移动到最近玩家",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,100"},
        [2] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 5,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "jiyidong",nextAct = -1},
    },

    id_2108 = {
        name = "群体移动",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,100"},
        [2] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 2108,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "jiyidong",nextAct = -1},
    },

    id_2109 = {
        name = "boss怒气",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2,3"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},
    },

    id_2110 = {
        name = "boss10召唤",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "summon_1",nextAct = "4,5"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "summon_2",nextAct = -1},
        [5] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "6"},
        [6] = {actType = BattleSkillType.SUMMON_BUILD,isWait = 1,param1 = false,nextAct = "7"},
        [7] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 2110,nextAct = -1},
    },

    id_2111 = {
        name = "近身攻击",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3,4,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "atk_2_1",nextAct = "5"},
        [4] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = -1},

        [5] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "atk_2_2",nextAct = "6,7,8"},

        [6] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 2,nextAct = -1},
        [7] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 3,nextAct = -1},
        [8] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "atk_2_3",nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "dianju",nextAct = -1},
    },

    

    --世界boss1 龙息
    id_10001 = {
        name = "世界boss1 龙息",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.TARGET,nextAct = "3,100"},
        [3] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill1_1",nextAct = "4,5,6"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill1_2",nextAct = -1},
        [5] = {actType = BattleSkillType.EFFECT,isWait = 1,param1 = 20001,nextAct = -1},
        [6] = {actType = BattleSkillType.SPRING,param1 = BattleSkillTargetType.TARGET,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss_shijie_penshe",nextAct = -1},
    },
    --世界boss1 冰球
    id_10002 = {
        name = "世界boss1 冰球",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.TARGET,nextAct = "3,100"},
        [3] = {actType = BattleSkillType.FLASH,isWait = 0,param1 = 1005,param2 = FlashPosType.TARGET,nextAct = "4,5"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill2_1",nextAct = "6"},
        [5] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill2_2",nextAct = -1},
        [6] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 10002,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss_shijie_bingfeng",nextAct = -1},
    },
    --世界boss1 龙炎
    id_10003 = {
        name = "世界boss1 龙炎",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.TARGET,nextAct = "3,100"},
        [3] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "4"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill3_1",nextAct = "5,6,7"},
        [5] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill3_2",nextAct = -1},
        [6] = {actType = BattleSkillType.EFFECT,isWait = 1,param1 = 20001,nextAct = -1},
        [7] = {actType = BattleSkillType.SPRING,param1 = BattleSkillTargetType.TARGET,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss_shijie_gongji",nextAct = -1},
    },

    --日常经验副本 集体行动
    id_20001 = {
        name = "日常经验副本 集体行动",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3"},
        [3] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 20001,nextAct = -1},
    },

    --日常经验副本 召唤
    id_20002 = {
        name = "日常经验副本 召唤",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "3"},
        -- [2] = {actType = BattleSkillType.SUMMON,isWait = 1,nextAct = "3"},
        [3] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "4"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "skill1",nextAct = "5,100"},
        [5] = {actType = BattleSkillType.EFFECT_IN_SKILL,isWait = 1,param1 = 1,nextAct = "6"},
        [6] = {actType = BattleSkillType.SUMMON_BUILD,isWait = 1,param1 = true,param2 = 1006,nextAct = -1},

        [100] = {actType = BattleSkillType.PLAY_SOUND,param1 = "boss1_zhaohuan",nextAct = -1},
    },

    --日常经验副本 召唤
    id_20003 = {
        name = "日常副本 出生点位移",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.PLAY,isWait = 1,param1 = "dead",nextAct = "3"},
        [3] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 20003,nextAct = "4"},
        [4] = {actType = BattleSkillType.PLAY,isWait = 0,param1 = "standby",nextAct = "5"},
        [5] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SELF,param2 = BattleSkillTargetType.SELF,nextAct = -1},
    },

    --夫妻副本 集体行动
    id_30001 = {
        name = "夫妻副本 集体行动",
        [1] = {actType = BattleSkillType.BEGIN,nextAct = "2"},
        [2] = {actType = BattleSkillType.CAMERA,isWait = 1,param1 = BattleSkillTargetType.SCENE,param2 = BattleSkillTargetType.SCENE,nextAct = "3"},
        [3] = {actType = BattleSkillType.CREATE_ASSISTED_MSG,isWait = 1,param1 = 30001,nextAct = -1},
    },
}
