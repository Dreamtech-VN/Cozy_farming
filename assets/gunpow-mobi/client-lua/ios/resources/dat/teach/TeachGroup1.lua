--TeachGroup1.lua
--@brief	TeachGroup1的模块                  
--@date		2014/9/25
--@author	莫剑峰1
--@note		教学步骤组

TeachGroup1 =
{
    COUNT = 51, --总共有引导组数
    m_tStepList = nil,  --步骤列表
    GROUP = -1, --当前组
    STEP = -1,  --当前步骤
    SCENE = nil,    --当前场景
    ISTEACH = false,    --是否在教学
    ISBATTLE = nil,     --是否在战斗
    ISBATTLE_MYTURN = nil,--是否在战斗,而且是自己回合
    ISTEACHMODE = nil,  --强制教学模式
    ISFIRSTBATTLE = nil,    --是否最初的战斗
    WEAPONGET = nil,    --获得武器
    TASK_ID_1 = 1110000001, --任务ID
    TASK_ID_2 = 1110000020, --任务ID
    TASK_ID_3 = 1110000021, --任务ID
    TASK_ID_4 = 1110000002, --任务ID
    TASK_ID_5 = 1110000022, --任务ID
    TASK_ID_6 = 1110000006, --任务ID
    TASK_ID_7 = 1900000001, --任务ID
    TASK_ID_8 = 1110000003, --任务ID
    TASK_ID_9 = 1110000023, --任务ID
    TASK_ID_10 = 1110000024, --任务ID
    TASK_ID_11 = 1110000025, --任务ID
    TASK_ID_12 = 1110000026, --任务ID
    TASK_ID_13 = 1110000027, --任务ID
    TASK_ID_14 = 1110000028, --任务ID
    TASK_ID_15 = 1120000032, --任务ID
    TASK_ID_16 = 1110000028, --任务ID
    TASK_ID_17 = 1110000029, --任务ID
    TASK_ID_18 = 1110000030, --任务ID

    FIRST_RECHARGE_ID_1 = 20201, --首冲推送用ID
    FIRST_RECHARGE_ID_2 = 20202, --首冲推送用ID
    FIRST_RECHARGE_ID_2 = 20203, --首冲推送用ID

    TASK_GO_ID = 0, --任务ID

    ISHAVEDRESS = nil,--是否有时装
    ISNOTEACH = nil,    --是否不教学
    WIND_OPEN_0 = 1000,--风力引导
    WIND_OPEN_3 = 1003,--风力引导
    WIND_OPEN_4 = 1004,--风力引导
    WIND_OPEN_5 = 1005,--风力引导
    WIND_OPEN_6 = 1006,--风力引导
    ANIME = nil,    --动画
    ANIME_IS_ARMATURE = nil,    --是否骨骼动画
    ANIME_ACTION_NAME = nil,    --动画动作名字
    ANIME_ACTION_END_NAME = nil,    --动画结束动作名字
    ANIME_END = nil,    --是否动画结束
    ANIME_LAYER = nil,  --动画层
    ANIME_MAIN_ID = nil,    --动画ID
    ANIME_EFFECT_ID = nil,  --动画ID
    ANIME_REPEAT = nil, --动画重复
    ANIME_BULLET_INFO = nil, --动画子弹信息
    ANIME_BOOM_NAME = nil,  --爆炸名字
    ANIME_BOOM_SCALE = nil, --爆炸大小
    ANIME_BOOM_ACTION_NAME = nil,--爆炸动作名字
    BULLET_COUNT = 0,   --子弹数目
    BULLET_COUNT_TOTAL = 0, --子弹总共数目
    SKILL_INFO = nil,   --技能信息
    BULLET_ADDTIMES = nil,  --子弹次数
    TRACE_INFO = nil,   --子弹跟踪
    SCHEDULE = nil, --定时器
    LOST_NET = nil, --断网
}

--元素类型
TeachElementType = 
{
    WZUIButton = 1,
    WZUIImage = 2,
    WZUITableContainer = 3,
    WZUIContainer = 4,
    WZUICheckBox = 5,
}

--教学类型
TeachType = 
{
    TALK = 1,
    BUTTON = 2,
    BUILDING = 3,
    AREA = 4,
    AREA_LIMIT = 5,
    SHOW = 6,

}

--教学数据表 (弃用的步骤要将它的group=负数)
GDatatab_Teach = 
{
    id_1 = {id=1, group=1, step=1, force = 1, type=TeachType.TALK, param1=101},
    id_2 = {id=2, group=1, step=2, force = 1, type=TeachType.BUILDING, param1=2, text=1, dire=4, textOffset={{25,55}}, btnOffset={{0,0}}, contentSize=-1, touchSize={{100,100}}},
    id_202 = {id=202, group=1, step=3, force = 1, type=TeachType.BUTTON, param1=-1, param2="btn1_WndCopyEntry", text=170, btnOffset={{0,0}}, textOffset={{-20,30}}, textOffset_ug={{-20,130}}, dire=4, elementType=1, contentSize={{250,250}}, touchSize=-1},
    id_3 = {id=3, group=1, step=4, force = 1, type=TeachType.BUTTON, param1=1, param2="btn_CellSingleCoypLevel", text=2, btnOffset={{0,-20}}, textOffset={{-20,10}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{80,80}}},
    id_4 = {id=4, group=1, step=5, force = 1, type=TeachType.BUTTON, param1=-1, param2="btnChallenge_WndSingleCopyInfo", text=3, textOffset={{-20,40}}, textOffset_ug={{-20,140}}, textOffset_tr={{-80,0}}, textOffset_vn={{-100,180}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{150,50}}},
    id_29 = {id=29, group=1, step=6, force = 1, type=TeachType.BUTTON, param1=-1, param2="btnFly_WndBattleHud", text=13, textOffset={{3,70}}, textOffset_ug={{3,170}}, textOffset_en={{3,190}}, dire=4, elementType=1, contentSize={{140,140}}, touchSize={{190,190}}, textLength = 1.6, sound="clickFly"},
    id_30 = {id=30, group=1, step=7, force = 1, type=TeachType.AREA_LIMIT, param1=-1, param2="imgSkill2_WndBattleHud", text=145, dire=4, elementType=2, bgSize={{450,190}}, bgOffset={{0,0}}, contentSize={{140,140}}, btnOffset={{0,0}}, touchSize={{40,40}}, textOffset={{-40,90}}, textOffset_ug={{-40,170}}, textOffset_en={{-40,120}}},
    id_31 = {id=31, group=1, step=8, force = 1, type=TeachType.AREA_LIMIT, param1=-1, param2="imgSkill3_WndBattleHud", text=146, dire=4, elementType=2, bgSize={{450,190}}, bgOffset={{0,0}}, contentSize={{140,140}}, btnOffset={{0,0}}, touchSize={{40,40}}, textOffset={{-40,90}}, textOffset_ug={{-40,170}}, textOffset_en={{-40,120}}},
    id_5 = {id=5, group=1, step=9, force = 1, type=TeachType.BUTTON, param1=-1, param2="imgPowerSkill_WndBattleHud", text=5, textOffset={{20,10}}, dire=3, elementType=2, contentSize={{120,120}}, touchSize={{180,180}}, sound="useSkill"},
    id_32 = {id=32, group=1, step=10, force = 1, type=TeachType.TALK, param1=101},

    id_6 = {id=6, group=3, step=1, force = 2, type=TeachType.TALK, param1=106},
    id_7 = {id=7, group=3, step=2, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, text=7, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_8 = {id=8, group=3, step=3, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_9 = {id=9, group=3, step=4, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnCommit_CellTaskListItem", text=9, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},
    id_10 = {id=10, group=3, step=5, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnUISwitch_CellTaskListItem", text=10, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},
    id_11 = {id=11, group=3, step=6, force = 2, type=TeachType.BUTTON, param1=2, param2="btn_CellSingleCoypLevel", text=11, btnOffset={{0,-20}}, textOffset={{-25,25}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{80,80}}},
    id_12 = {id=12, group=3, step=7, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnChallenge_WndSingleCopyInfo", text=12, textOffset={{-20,40}}, textOffset_ug={{-20,140}}, textOffset_vn={{-100,180}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{150,50}}},
    id_13 = {id=13, group=3, step=8, force = 2, type=TeachType.BUTTON, param1=-1, param2="战斗胜利", text=13, textOffset={{3,30}}, dire=4, elementType=1, contentSize={{140,140}}, touchSize={{190,190}}, textLength = 1.6, sound="clickFly"},
    id_14 = {id=14, group=-4, step=2, force = 2, type=TeachType.BUTTON, param1=-1, param2="imgPowerSkill_WndBattleHud", text=5, textOffset={{20,10}}, dire=3, elementType=2, contentSize={{140,140}}, touchSize={{180,180}}, sound="useSkill"},

    id_15 = {id=15, group=5, step=1, force = 2, type=TeachType.TALK, param1=110},
    id_16 = {id=16, group=5, step=2, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, text=17, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_17 = {id=17, group=5, step=3, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnItem_WndBottomBar", btnTask=2, btnOffset2={{0,-20}}, text=18, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, textOffset_2={{25,0}}},
    id_18 = {id=18, group=5, step=4, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnEdit", text=181, btnOffset={{0,0}}, textOffset={{-150,20}}, dire=4, elementType=1, contentSize={{80,80}}, touchSize={{50,35}}},
    id_24 = {id=24, group=5, step=5, force = 2, type=TeachType.BUTTON, param1=-1, param2="imgTeach_WndSkillProp", text=182, btnOffset={{0,0}}, textOffset={{-20,80}}, dire=4, elementType=2, contentSize={{130,130}}, touchSize={{60,80}}, must=1},   
    id_211 = {id=211, group=5, step=6, force = 2, type=TeachType.BUTTON, param1=-1, param2="checkbox2_WndSkillContainer", text=183, btnOffset={{-25,0}}, textOffset={{0,-30}}, dire=3, elementType=5, contentSize={{130,130}}, touchSize={{60,40}}},
    id_212 = {id=212, group=5, step=7, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnEdit", text=181, btnOffset={{0,0}}, textOffset={{-150,20}}, dire=4, elementType=1, contentSize={{80,80}}, touchSize={{50,35}}},
    id_213 = {id=213, group=5, step=8, force = 2, type=TeachType.BUTTON, param1=-1, param2="imgTeach3_WndSkillProp", text=184, btnOffset={{0,0}}, textOffset={{-20,80}}, dire=4, elementType=2, contentSize={{130,130}}, touchSize={{60,80}}, must=1},   
    id_19 = {id=19, group=5, step=9, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnClose_WndSkillProp", text=20, btnOffset={{0,0}}, textOffset={{30,-40}}, dire=3, elementType=1, contentSize={{140,140}}, touchSize={{80,70}}},
    id_20 = {id=20, group=5, step=10, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_21 = {id=21, group=5, step=11, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnCommit_CellTaskListItem", text=22, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},
    id_22 = {id=22, group=5, step=12, force = 3, type=TeachType.BUTTON, param1=-1, param2="btnUISwitch_CellTaskListItem", text=23, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},
    id_23 = {id=23, group=5, step=13, force = 3, type=TeachType.BUTTON, param1=3, param2="btn_CellSingleCoypLevel", text=24, btnOffset={{0,-20}}, textOffset={{-25,25}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{80,80}}},
    id_103 = {id=103, group=5, step=14, force = 3, type=TeachType.BUTTON, param1=-1, param2="btnChallenge_WndSingleCopyInfo", text=25, textOffset={{-20,40}}, textOffset_ug={{-20,140}}, textOffset_tr={{-80,0}}, textOffset_vn={{-100,180}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{150,50}}},
    id_157 = {id=157, group=5, step=15, force = 3, type=TeachType.BUTTON, param1=-1, param2="战斗胜利", text=13, textOffset={{3,30}}, dire=4, elementType=1, contentSize={{140,140}}, touchSize={{190,190}}, textLength = 1.6, sound="clickFly"},
    
    id_25 = {id=24, group=-6, step=1, force = 2, type=TeachType.BUTTON, param1=-1, param2="imgAngrySkill_WndBattleHud", text=26, textOffset={{20,10}}, dire=3, elementType=2, contentSize={{140,140}}, touchSize={{180,180}}, sound="clickAngryItem"},
    id_26 = {id=25, group=-6, step=2, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnBigSkill_WndBattleHud", text=27, textOffset={{20,-30}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{300,300}}, sound="clickAngrySkill"},
    
    id_27 = {id=27, group=7, step=1, force = 2, type=TeachType.TALK, param1=113},
    id_28 = {id=28, group=7, step=2, force = 2, type=TeachType.BUTTON, param1=-1, param2="conReward1_CellTreasureBox", text=29, btnOffset={{-5,-5}}, textOffset={{30,-35}}, textOffset_en={{57,-45}}, dire=3, elementType=4, contentSize={{250,250}}, touchSize={{70,70}}},
    id_66 = {id=66, group=7, step=3, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, text=7, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_67 = {id=67, group=7, step=4, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_68 = {id=68, group=7, step=5, force = 2, type=TeachType.BUTTON, param1=-1, param2="btnCommit_CellTaskListItem", text=9, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},

    id_33 = {id=33, group=8, step=1, force = 3, type=TeachType.BUTTON, param1=-1, param2="btnClose_WndTask", text=30, btnOffset={{0,0}}, textOffset={{30,-40}}, dire=3, elementType=1, contentSize={{140,140}}, touchSize=-1},
    id_34 = {id=34, group=8, step=2, force = 3, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, text=31, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_35 = {id=35, group=8, step=3, force = 3, type=TeachType.BUTTON, param1=-1, param2="btnPlayer_WndBottomBar", btnTask=2, btnOffset2={{0,-20}}, text=32, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, textOffset_2={{25,0}}},
    id_36 = {id=36, group=8, step=4, force = 3, type=TeachType.BUTTON, param1=11, param2="", text=33, btnOffset={{0,0}}, textOffset={{-25,25}}, dire=4, elementType=-1, contentSize={{200,200}}, touchSize={{80,80}}},
    id_37 = {id=37, group=8, step=5, force = 3, type=TeachType.BUTTON, param1=-1, param2="btn1_WndItemInfo", text=34, btnOffset={{0,0}}, textOffset={{30,-45}}, dire=3, elementType=1, contentSize={{180,180}}, touchSize={{50,25}}},
    id_38 = {id=38, group=8, step=6, force = 3, type=TeachType.BUTTON, param1=-1, param2="imgBack_CellTopHandle", text=35, btnOffset={{0,0}}, textOffset={{-60,30}}, dire=4, elementType=2, contentSize={{140,140}}, touchSize=-1},
    id_69 = {id=69, group=8, step=7, force = 3, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_70 = {id=70, group=8, step=8, force = 3, type=TeachType.BUTTON, param1=-1, param2="btnCommit_CellTaskListItem", text=22, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},
    id_71 = {id=71, group=8, step=9, force = 3, type=TeachType.BUTTON, param1=-1, param2="btnUISwitch_CellTaskListItem", text=23, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,50}}},
    id_84 = {id=84, group=8, step=10, force = 3, type=TeachType.BUTTON, param1=4, param2="btn_CellSingleCoypLevel", text=24, btnOffset={{0,-20}}, textOffset={{15,-30}}, dire=3, elementType=1, contentSize={{180,180}}, touchSize={{80,80}}},
    id_85 = {id=85, group=8, step=11, force = 3, type=TeachType.BUTTON, param1=-1, param2="btnChallenge_WndSingleCopyInfo", text=25, textOffset={{-20,40}}, textOffset_ug={{-20,140}}, textOffset_tr={{-80,0}}, textOffset_vn={{-100,180}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{150,50}}},
    id_169 = {id=169, group=8, step=12, force = 3, type=TeachType.BUTTON, param1=-1, param2="战斗胜利", text=13, textOffset={{3,30}}, dire=4, elementType=1, contentSize={{140,140}}, touchSize={{190,190}}, textLength = 1.6, sound="clickFly"},
    
    id_39 = {id=39, group=9, step=1, force = 4, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, text=36, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_40 = {id=40, group=9, step=2, force = 4, type=TeachType.BUTTON, param1=-1, param2="btnStrong_WndBottomBar", btnTask=2, btnOffset2={{0,-20}}, text=37, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, textOffset_2={{25,0}}},
    id_41 = {id=41, group=9, step=3, force = 4, type=TeachType.BUTTON, param1=-1, param2="imgTeach_WndStrengthen", text=38, btnOffset={{0,0}}, textOffset={{0,0}}, dire=3, elementType=2, contentSize={{140,140}}, touchSize={{80,56}}, must=1},
    id_42 = {id=42, group=9, step=4, force = 4, type=TeachType.AREA, param1=-1, param2="conCurWindow_WndStrengthen", text=39, dire=4, elementType=4, bgSize={{570,570}}, bgOffset={{0,80}}, contentSize={{250,250}}, btnOffset={{200,-100}}, touchSize={{-1,-1}}, textOffset={{-160,320}}},
    id_43 = {id=43, group=9, step=5, force = 4, type=TeachType.BUTTON, param1=-1, param2="btnOneKeyIntensify_WndIntensifyStrengthen", text=40, btnOffset={{0,0}}, textOffset={{-5,100}}, dire=4, elementType=1, contentSize={{200,200}}, touchSize={{80,80}}},
    id_44 = {id=44, group=-9, step=-6, force = 4, type=TeachType.BUTTON, param1=-1, param2="imgBack_CellTopHandle", text=41, btnOffset={{0,0}}, textOffset={{-20,30}}, dire=4, elementType=2, contentSize={{140,140}}, touchSize=-1},
    id_125 = {id=125, group=9, step=6, force = 4, type=TeachType.BUTTON, param1=-1, param2="imgBack_CellTopHandle", text=35, btnOffset={{0,0}}, textOffset={{-20,30}}, dire=4, elementType=2, contentSize={{140,140}}, touchSize=-1},
    id_126 = {id=126, group=9, step=7, force = 4, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_127 = {id=127, group=9, step=8, force = 4, type=TeachType.BUTTON, param1=-1, param2="btnCommit_CellTaskListItem", text=22, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},
    id_128 = {id=128, group=9, step=9, force = 4, type=TeachType.BUTTON, param1=-1, param2="btnUISwitch_CellTaskListItem", text=23, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,50}}},
    id_166 = {id=166, group=9, step=10, force = 4, type=TeachType.BUTTON, param1=5, param2="btn_CellSingleCoypLevel", text=11, btnOffset={{0,-20}}, textOffset={{20,-20}}, dire=3, elementType=1, contentSize={{180,180}}, touchSize={{80,80}}},
    id_167 = {id=167, group=9, step=11, force = 4, type=TeachType.BUTTON, param1=-1, param2="btnChallenge_WndSingleCopyInfo", text=12, textOffset={{-20,40}}, textOffset_ug={{-20,140}}, textOffset_vn={{-100,180}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{150,50}}},
    id_168 = {id=168, group=9, step=12, force = 4, type=TeachType.BUTTON, param1=-1, param2="战斗胜利", text=13, textOffset={{3,30}}, dire=4, elementType=1, contentSize={{140,140}}, touchSize={{190,190}}, textLength = 1.6, sound="clickFly"},
    
    id_45 = {id=45, group=10, step=1, force = 14, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, removeSweep=true, text=42, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_46 = {id=46, group=10, step=2, force = 14, type=TeachType.BUTTON, param1=-1, param2="btnStrong_WndBottomBar", btnTask=2, btnOffset2={{0,-20}}, removeSweep=true, text=43, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, textOffset_2={{25,0}}},
    id_47 = {id=47, group=10, step=3, force = 14, type=TeachType.BUTTON, param1=-1, param2="checkbox2_WndStrengthen", text=44, btnOffset={{0,0}}, textOffset={{5,100}}, dire=4, elementType=5, contentSize={{180,180}}, touchSize={{60,80}}},
    id_48 = {id=48, group=10, step=4, force = 14, type=TeachType.BUTTON, param1=-1, param2="imgTeach_WndStrengthen", text=45, btnOffset={{0,0}}, textOffset={{0,0}}, dire=3, elementType=2, contentSize={{140,140}}, touchSize={{80,80}}, must=1},
    id_49 = {id=49, group=10, step=5, force = 14, type=TeachType.BUTTON, param1=-1, param2="btnImprove_WndImproveStrengthen", text=46, btnOffset={{0,-70}}, textOffset={{5,100}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{80,80}}},
    
    id_50 = {id=50, group=11, step=1, force = 17, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, removeSweep=true, text=47, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_51 = {id=51, group=11, step=2, force = 17, type=TeachType.BUTTON, param1=-1, param2="btnStrong_WndBottomBar", btnTask=2, btnOffset2={{0,-20}}, removeSweep=true, text=48, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, textOffset_2={{25,0}}},
    id_52 = {id=52, group=11, step=3, force = 17, type=TeachType.BUTTON, param1=-1, param2="checkbox3_WndStrengthen", text=49, btnOffset={{0,0}}, textOffset={{5,100}}, dire=4, elementType=5, contentSize={{180,180}}, touchSize={{60,80}}},
    id_53 = {id=53, group=11, step=4, force = 17, type=TeachType.BUTTON, param1=-1, param2="imgTeach_WndStrengthen", text=50, btnOffset={{0,0}}, textOffset={{0,0}}, dire=3, elementType=2, contentSize={{140,140}}, touchSize={{80,80}}, must=1},
    id_54 = {id=54, group=-11, step=-5, force = 17, type=TeachType.BUTTON, param1=-1, param2="conAttackAttr_WndGemmountingStrengthen", text=51, btnOffset={{0,50}}, textOffset={{5,50}}, dire=4, elementType=4, contentSize={{180,180}}, touchSize={{80,80}}},
    id_55 = {id=55, group=-11, step=-6, force = 17, type=TeachType.BUTTON, param1=-1, param2="imgTeach_WndSelectTipsStrengthen", text=53, btnOffset={{0,0}}, textOffset={{0,0}}, dire=4, elementType=2, contentSize={{140,140}}, touchSize={{80,80}}, must=1},
    id_56 = {id=55, group=-11, step=-7, force = 17, type=TeachType.BUTTON, param1=-1, param2="btnInset_WndSelectTipsStrengthen", text=53, btnOffset={{0,0}}, textOffset={{0,50}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{60,60}}},
    
    id_57 = {id=57, group=12, step=1, force = 11, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, removeSweep=true, text=54, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_58 = {id=58, group=12, step=2, force = 11, type=TeachType.BUTTON, param1=-1, param2="btnPet_WndBottomBar", btnTask=2, btnOffset2={{0,-20}}, removeSweep=true, text=214, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, textOffset_2={{25,0}}},
    id_59 = {id=59, group=12, step=3, force = 11, type=TeachType.BUTTON, param1=-1, param2="btnObtainPet_WndPets", text=56, btnOffset={{0,0}}, textOffset={{20,0}}, dire=3, elementType=1, contentSize={{180,180}}, touchSize={{80,80}}},
    id_60 = {id=60, group=12, step=4, force = 11, type=TeachType.BUTTON, param1=-1, param2="btnFragRaffle1_WndPetRaffle", text=57, btnOffset={{0,0}}, textOffset={{5,100}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{80,80}}},
    id_61 = {id=61, group=12, step=5, force = 11, type=TeachType.BUTTON, param1=-1, param2="btnFragRaffle2_WndPetRaffle", text=58, btnOffset={{0,0}}, textOffset={{5,100}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{80,80}}},
    id_101 = {id=101, group=12, step=6, force = 11, type=TeachType.BUTTON, param1=-1, param2="imgBack_CellTopHandle", text=84, btnOffset={{0,0}}, textOffset={{-20,30}}, dire=4, elementType=2, contentSize={{140,140}}, touchSize=-1},
    id_102 = {id=102, group=12, step=7, force = 11, type=TeachType.BUTTON, param1=-1, param2="imgTeach_WndPets", text=85, btnOffset={{0,0}}, textOffset={{0,0}}, dire=3, elementType=2, contentSize={{140,140}}, touchSize={{80,80}}, must=1},
    
    id_62 = {id=62, group=13, step=1, force = 20, type=TeachType.BUILDING, param1="6_1", param1_2="2_1", btnTask=2, text=59, dire=3, btnOffset={{-8,0}}, btnOffset2={{0,20}}, btnOffset3={{-80,20}}, textOffset={{15,-50}}, contentSize={{180,180}}, touchSize={{90,90}}, elementType=2, must=1},
    id_63 = {id=63, group=-13, step=2, force = 20, type=TeachType.BUTTON, param1=-1, param2="btnChallenge_WndDailyCopyInfo", text=60, btnOffset={{0,0}}, textOffset={{30,-30}}, dire=3, elementType=1, contentSize={{180,180}}, touchSize={{60,60}}},
    id_207 = {id=207, group=13, step=2, force = 20, type=TeachType.BUTTON, param1=-1, param2="btn3_WndCopyEntry", text=174, btnOffset={{0,0}}, textOffset={{20,-30}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize=-1},
    
    id_64 = {id=64, group=14, step=1, force = 22, type=TeachType.BUILDING, param1="3_1", text=61, dire=4, btnOffset={{0,0}}, btnOffset3={{-120,0}}, btnOffset3_1={{50,0}}, textOffset={{0,0}}, contentSize={{100,100}}, touchSize=-1, elementType=2, must=1},
    id_65 = {id=65, group=-14, step=2, force = 22, type=TeachType.BUTTON, param1=1, param2="", text=62, btnOffset={{20,-5}}, textOffset={{0,50}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{60,60}}},
    id_208 = {id=208, group=14, step=2, force = 22, type=TeachType.BUTTON, param1=-1, param2="btn1_WndChallengeEntrance", text=175, btnOffset={{0,0}}, textOffset={{0,30}}, dire=4, elementType=1, contentSize={{250,250}}, touchSize=-1},
    
    id_72 = {id=72, group=15, step=1, force = 13, type=TeachType.BUILDING, param1="1_1", param1_2="2_1", btnTask=2, text=63, dire=4, btnOffset={{70,0}}, btnOffset2={{0,20}}, btnOffset3={{-80,20}}, textOffset={{30,120}}, contentSize={{190,190}}, touchSize={{90,90}}, elementType=2, must=1},
    id_205 = {id=205, group=15, step=2, force = 13, type=TeachType.BUTTON, param1=-1, param2="btn2_WndCopyEntry", text=173, btnOffset={{0,0}}, textOffset={{-20,30}}, dire=4, elementType=1, contentSize={{250,250}}, touchSize=-1},
    id_243 = {id=243, group=15, step=3, force = 13, type=TeachType.BUTTON, param1=-1, param2="btnQuickJoin_WndMultiCopy", text=212, btnOffset={{0,0}}, textOffset={{20,-30}}, dire=3, elementType=1, contentSize={{200,200}}, touchSize={{60,60}}},
    id_244 = {id=244, group=15, step=4, force = 13, type=TeachType.BUTTON, param1=-1, param2="btnReadyGame_SceneBossRoom", text=213, btnOffset={{0,0}}, textOffset={{20,0}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{80,80}}},
    id_245 = {id=245, group=15, step=5, force = 13, type=TeachType.BUTTON, param1=-1, param2="战斗胜利", text=13, textOffset={{3,30}}, dire=4, elementType=1, contentSize={{140,140}}, touchSize={{190,190}}, textLength = 1.6, sound="clickFly"},
    
    id_73 = {id=73, group=16, step=1, force = 10, type=TeachType.BUILDING, param1="4_1", paramLevelUp="4_2", text=64, dire=3, btnOffset={{0,0}}, textOffset={{200,-100}}, contentSize={{100,100}}, touchSize=-1, elementType=2, must=1},
    id_225 = {id=225, group=16, step=2, force = 10, type=TeachType.BUTTON, param1=-1, param2="imgTeach_WndRankList", text=192, btnOffset={{0,0}}, textOffset={{-20,-30}}, dire=3, elementType=2, contentSize={{140,140}}, touchSize=-1, must=1},   
    id_226 = {id=226, group=16, step=3, force = 10, type=TeachType.BUTTON, param1=-1, param2="btnWorship", text=193, btnOffset={{0,0}}, textOffset={{20,-30}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{70,34}}},
    
    id_74 = {id=74, group=-17, step=1, force = 11, type=TeachType.BUTTON, param1=-1, param2="conBtnGuide_WndOwnCity", text=65, btnOffset={{-35,30}}, textOffset={{-30,30}}, dire=4, elementType=4, contentSize={{140,140}}, touchSize={{80,80}}},

    id_75 = {id=75, group=19, step=1, force = 26, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, removeSweep=true, text=66, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_86 = {id=86, group=19, step=2, force = 26, type=TeachType.BUTTON, param1=-1, param2="btnPet_WndBottomBar", btnTask=2, btnOffset2={{0,-20}}, btnOffset3_1={{0,-7}}, removeSweep=true, text=214, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, textOffset_2={{25,0}}},
    id_246 = {id=246, group=19, step=3, force = 26, type=TeachType.BUTTON, param1=-1, param2="checkbox2_WndPartner", text=74, btnOffset={{0,0}}, textOffset={{5,100}}, dire=4, elementType=5, contentSize={{180,180}}, touchSize={{60,80}}},
    id_233 = {id=233, group=19, step=4, force = 26, type=TeachType.BUTTON, param1=-1, param2="btnUnlock_WndMounts", text=200, btnOffset={{0,0}}, textOffset={{0,60}}, dire=4, elementType=1, contentSize={{150,150}}, touchSize={{80,80}}},
    id_234 = {id=234, group=19, step=5, force = 26, type=TeachType.BUTTON, param1=-1, param2="btnAniGet_WndMounts", text=200, btnOffset={{0,0}}, textOffset={{0,60}}, dire=4, elementType=1, contentSize={{150,150}}, touchSize={{80,80}}},
    id_235 = {id=235, group=19, step=6, force = 26, type=TeachType.BUTTON, param1=-1, param2="btn1_WndMounts", text=201, btnOffset={{-35,0}}, textOffset={{0,160}}, dire=4, elementType=1, contentSize={{150,150}}, touchSize={{80,80}}},
    id_236 = {id=236, group=19, step=7, force = 26, type=TeachType.BUTTON, param1=-1, param2="btnUpgrade_WndMountsCenter", text=202, btnOffset={{0,0}}, textOffset={{-40,-50}}, dire=1, elementType=1, contentSize={{150,150}}, touchSize={{80,80}}},
    
    id_76 = {id=76, group=-18, step=1, force = 10, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, text=67, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_77 = {id=77, group=-18, step=2, force = 10, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_78 = {id=78, group=-18, step=3, force = 10, type=TeachType.BUTTON, param1=-1, param2="checkBoxBranch_WndTask", text=69, btnOffset={{0,0}}, textOffset={{35,-15}}, dire=3, elementType=5, contentSize={{180,180}}, touchSize={{60,60}}},

    id_79 = {id=79, group=20, step=1, force = 8, type=TeachType.BUILDING, param1="5_1", paramLevelUp="5_2", text=70, dire=3, btnOffset={{0,10}}, btnOffset3={{0,0}}, textOffset={{30,-70}}, contentSize={{180,180}}, elementType=2, must=1, touchSize=-1},
    id_203 = {id=203, group=20, step=2, force = 8, type=TeachType.BUTTON, param1=-1, param2="btn1_ScenePvp", text=171, btnOffset={{0,0}}, textOffset={{-20,30}}, dire=4, elementType=1, contentSize={{250,250}}, touchSize=-1},
    id_80 = {id=80, group=20, step=3, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnCreate_SceneHall", text=71, btnOffset={{0,0}}, textOffset={{30,-20}}, dire=3, elementType=1, contentSize={{180,180}}, touchSize={{60,60}}},
    id_81 = {id=81, group=20, step=4, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnOk_SceneHall", text=72, btnOffset={{0,0}}, textOffset={{30,-20}}, dire=3, elementType=1, contentSize={{180,180}}, touchSize={{60,60}}},
    id_82 = {id=82, group=20, step=5, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnReadyGame_SceneRoom", text=73, btnOffset={{0,0}}, textOffset={{35,5}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{60,60}}},
    id_112 = {id=112, group=20, step=6, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, text=7, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_113 = {id=113, group=20, step=7, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_149 = {id=149, group=20, step=8, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnCommit_CellTaskListItem", text=9, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},
    id_151 = {id=151, group=20, step=9, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnUISwitch_CellTaskListItem", text=10, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},

    id_83 = {id=83, group=21, step=1, force = 3, type=TeachType.BUTTON, param1=-1, param2="imgPowerSkill_WndBattleHud", text=5, textOffset={{20,10}}, dire=3, elementType=2, contentSize={{140,140}}, touchSize={{180,180}}, sound="useSkill"},

    id_87 = {id=87, group=-22, step=-1, force = 24, type=TeachType.BUTTON, param1=-1, param2="btn20_WndOwnCity", text=75, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{180,180}}, touchSize={{50,60}}},
    
    id_88 = {id=88, group=23, step=1, force = 15, type=TeachType.BUILDING, param1="9_1", text=76, dire=3, btnOffset={{0,0}}, btnOffset3={{-290,0}}, btnOffset3_1={{90,0}}, textOffset={{15,-50}}, contentSize={{130,130}}, touchSize=-1, elementType=2, must=1},
    
    id_89 = {id=89, group=24, step=1, force = 21, type=TeachType.BUILDING, param1="8_1", paramLevelUp="8_2", text=77, dire=3, btnOffset={{0,0}}, btnOffset3={{0,0}}, textOffset={{10,-20}}, contentSize={{140,140}}, touchSize=-1, elementType=2, must=1},
    id_227 = {id=227, group=24, step=2, force = 21, type=TeachType.BUTTON, param1=-1, param2="btnWeddingList_WndMarryHoll", text=194, btnOffset={{0,30}}, textOffset={{-40,-40}}, dire=1, elementType=1, contentSize={{350,350}}, touchSize={{200,200}}},
    id_228 = {id=228, group=24, step=3, force = 21, type=TeachType.BUTTON, param1=-1, param2="btnMarryPurpose_WndMarryHoll", text=195, btnOffset={{0,30}}, textOffset={{-40,-40}}, dire=1, elementType=1, contentSize={{350,350}}, touchSize={{200,200}}},
    id_229 = {id=229, group=24, step=4, force = 21, type=TeachType.BUTTON, param1=-1, param2="btnExplain_WndMarry", text=196, btnOffset={{0,0}, btnOffset3={{-260,0}}, btnOffset3={{-260,0}}}, textOffset={{0,50}}, dire=4, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}},


    id_90 = {id=90, group=25, step=1, force = 1, type=TeachType.BUTTON, param1=-1, param2="imgPowerSkill_WndBattleHud", text=5, textOffset={{20,10}}, dire=3, elementType=2, contentSize={{140,140}}, touchSize={{180,180}}, sound="useSkill"},
    id_91 = {id=91, group=25, step=2, force = 99, type=TeachType.AREA_LIMIT, param1=-1, param2="imgSkill1_WndBattleHud", text=144, dire=4, elementType=2, bgSize={{450,190}}, bgOffset={{0,0}}, contentSize={{140,140}}, btnOffset={{0,0}}, touchSize={{40,40}}, textOffset={{-40,90}}, textOffset_en={{-40,120}}, textOffset_ug={{-40,180}}},
    id_92 = {id=92, group=25, step=3, force = 99, type=TeachType.BUTTON, param1=-1, param2="btnBigSkill_WndBattleHud", text=27, btnOffset={{0,10}}, textOffset={{20,0}}, textOffset_ug={{20,100}}, dire=3, elementType=1, contentSize={{150,150}}, touchSize={{200,200}}, sound="clickAngrySkill"},

    id_93 = {id=93, group=26, step=1, force = 10, type=TeachType.TALK, param1=121},
    id_94 = {id=94, group=26, step=2, force = 10, type=TeachType.BUILDING, param1="7_1", text=120, dire=4, btnOffset={{0,0}}, btnOffset3={{0,0}}, textOffset={{15,70}}, contentSize={{140,140}}, touchSize=-1, elementType=2, must=1},
    id_108 = {id=108, group=26, step=3, force = 10, type=TeachType.BUTTON, param1=-1, param2="check2_WndShop", text=121, btnOffset={{0,0}}, textOffset={{0,50}}, dire=4, elementType=5, contentSize={{140,140}}, touchSize={{60,36}}, must=1},
    id_210 = {id=210, group=26, step=4, force = 10, type=TeachType.BUTTON, param1=-1, param2="tab4_WndShop", text=178, btnOffset={{0,30}}, textOffset={{0,0}}, dire=3, elementType=5, contentSize={{100,100}}, touchSize={{60,36}}, must=1},
    id_109 = {id=109, group=26, step=5, force = 10, type=TeachType.BUTTON, param1=-1, param2="imgTeach_WndShop", text=122, btnOffset={{0,0}}, textOffset={{-20,80}}, dire=4, elementType=2, contentSize={{140,140}}, touchSize=-1, must=1},   
    id_110 = {id=110, group=26, step=6, force = 10, type=TeachType.BUTTON, param1=-1, param2="btn3_WndItemInfo", param2_1="btn1_WndItemInfo", text=123, btnOffset={{0,0}}, textOffset={{-20,80}}, dire=4, elementType=1, contentSize={{140,140}}, touchSize={{50,25}}},
    id_99 = {id=99, group=26, step=7, force = 10, type=TeachType.BUTTON, param1=-1, param2="btnBuy_WndPurchase", text=124, btnOffset={{10,0}}, textOffset={{-20,80}}, textOffset_en={{-120,150}}, dire=4, elementType=1, contentSize={{140,140}}, touchSize=-1},
    id_95 = {id=95, group=26, step=8, force = 10, type=TeachType.BUTTON, param1=-1, param2="btnOK1_WndDressUp", text=103, btnOffset={{0,0}}, textOffset={{30,-25}}, dire=3, elementType=4, contentSize={{140,140}}, touchSize={{100,55}}},
    id_96 = {id=96, group=-26, step=-9, force = 10, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, text=125, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_97 = {id=97, group=-26, step=-8, force = 10, type=TeachType.BUTTON, param1=-1, param2="btnBag_WndBottomBar", btnTask=2, btnOffset2={{0,-20}}, text=126, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, textOffset_2={{25,0}}},
    id_98 = {id=98, group=-26, step=-9, force = 10, type=TeachType.BUTTON, param1=-1, param2="btnDress_WndBag", text=127, btnOffset={{0,0}}, textOffset={{-20,80}}, dire=4, elementType=1, contentSize={{140,140}}, touchSize=-1},
    id_111 = {id=111, group=-26, step=-10, force = 10, type=TeachType.BUTTON, param1=-1, param2="imgTeach_WndDressList", text=128, btnOffset={{0,0}}, textOffset={{20,-20}}, dire=3, elementType=2, contentSize={{140,140}}, touchSize={{60,30}}, must=1},
    id_123 = {id=123, group=-26, step=-11, force = 10, type=TeachType.BUTTON, param1=-1, param2="imgBack_CellTopHandle", text=35, btnOffset={{0,0}}, textOffset={{-20,30}}, dire=4, elementType=2, contentSize={{140,140}}, touchSize=-1},
    id_124 = {id=124, group=-26, step=-10, force = 10, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    
    id_100 = {id=100, group=28, step=1, force = 25, type=TeachType.BUILDING, param1="3_1", text=83, dire=4, btnOffset={{0,0}}, btnOffset3={{-120,0}}, btnOffset3_1={{50,0}}, textOffset={{0,0}}, contentSize={{140,140}}, touchSize=-1, elementType=2, must=1},
    id_209 = {id=209, group=28, step=2, force = 25, type=TeachType.BUTTON, param1=-1, param2="btn2_WndChallengeEntrance", text=176, btnOffset={{0,0}}, textOffset={{20,-30}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize=-1},
    
    id_104 = {id=104, group=29, step=1, force = 16, type=TeachType.BUILDING, param1="2_1", btnTask=2, text=100, dire=4, btnOffset={{0,20}}, btnOffset2={{0,20}}, btnOffset3={{-80,20}}, textOffset={{30,120}}, contentSize={{180,180}}, touchSize={{90,90}}, elementType=2, must=1},
    id_206 = {id=206, group=29, step=2, force = 16, type=TeachType.BUTTON, param1=-1, param2="btn1_WndCopyEntry", text=170, btnOffset={{0,0}}, textOffset={{-20,30}}, dire=4, elementType=1, contentSize={{250,250}}, touchSize=-1},
    id_105 = {id=105, group=29, step=3, force = 16, type=TeachType.BUTTON, param1=-1, param2="imgTeach_WndSingleCopy", text=101, btnOffset={{0,0}}, textOffset={{-25,25}}, dire=4, elementType=2, contentSize={{140,140}}, touchSize={{50,50}}, must=1},
    id_106 = {id=106, group=29, step=4, force = 16, type=TeachType.BUTTON, param1=1, param2="btn_CellSingleCoypLevel", text=102, btnOffset={{0,-20}}, textOffset={{-20,10}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{80,80}}},
    
    id_107 = {id=107, group=30, step=1, force = 99, type=TeachType.SHOW, param1="wld_boss_1003,atk_boy,attack_boy", param2="false", param3= "wait,animation,animation", param4= 1, param5= "skill_baozha_hd", param6= "animation", param7= 0.3, param8= "wound", param9= {{"350,250,26,10,630,620,260,1"}}, btnOffset={{-15,25},{-20,-115},{-15,50}}, text=107},
    id_114 = {id=114, group=30, step=2, force = 99, type=TeachType.SHOW, param1="move", param2="true", param3= "0", param4= 1, btnOffset={{0,-85}}, text=104, textOffset={{0,0}}, textOffset_ug={{0,160}}},
    id_115 = {id=115, group=30, step=3, force = 99, type=TeachType.SHOW, param1="wld_boss_1003,wl_boy", param2="false", param3= "wait,animation", param4= 1, param5= "skill_baozha_hd", param6= "animation", param7= 0.3, param8= "wound", param9= {{"360,230,26,16,630,620,310,1"},{"360,230,26,16,630,620,310,1"}}, param10= {{"battleitems/battle_icon_lianshe.png,280,350"}}, param11= 1 , btnOffset={{-15,20},{-15,-90}}, text=108},
    id_116 = {id=116, group=30, step=4, force = 99, type=TeachType.SHOW, param1="wld_boss_1003,wl_boy", param2="false", param3= "wait,animation", param4= 1, param5= "skill_baozha_hd", param6= "animation", param7= 0.3, param8= "wound", param9= {{"360,230,26,18,630,620,340,2,360,230,26,13,630,620,280,2"}}, param10= {{"battleitems/battle_icon_sanshe.png,280,350"}} , btnOffset={{-15,20},{-15,-90}}, text=109},
    id_117 = {id=117, group=30, step=5, force = 99, type=TeachType.SHOW, param1="wld_boss_1003,wl_boy", param2="false", param3= "wait,animation", param4= 1, param5= "skill_weili_hd", param6= "hit", param7= 0.3, param8= "wound", param9= {{"360,230,26,16,630,620,310,1"}}, param10= {{"battleitems/battle_icon_weilitisheng.png,280,350"}} , btnOffset={{-15,20},{-15,-90}}, text=110},
    id_118 = {id=118, group=30, step=6, force = 99, type=TeachType.SHOW, param1="wld_boss_1003,wl_boy", param2="false", param3= "wait,animation", param4= 1, param5= "skill_baozha_hd", param6= "animation", param7= 0.3, param8= "wound", param9= {{"360,230,26,23,630,620,300,1"}}, param10= {{"battleitems/battle_icon_zhuizhongdan.png,280,350"}}, param12 = "490,17,-10,625,345,530" , btnOffset={{-15,20},{-15,-90}}, text=111},
    id_119 = {id=119, group=30, step=7, force = 99, type=TeachType.SHOW, param1="wld_boss_1003,power_boy,skill_power_qiangpao", param2="false", param3= "wait,animation,animation", param4= 1, param13= 3, param5= "skill_power_hd", param6= "hit1", param7= 0.3, param8= "wound", param9= {{"360,210,26,16,630,620,290,1"},{"360,210,26,16,630,620,290,1"},{"360,210,26,16,630,620,290,1"},{"360,210,26,16,630,620,290,1"},{"360,210,26,16,630,620,290,1"},{"360,210,26,16,630,620,290,1"}}, param10= {{"battleitems/battle_icon_dazhao.png,280,350"}}, param11= 1, btnOffset={{-15,15},{-15,-78},{-110,-180}}, text=112},
    id_120 = {id=120, group=30, step=8, force = 99, type=TeachType.SHOW, param1="fly", param2="true", param3= "0", param4= 1, btnOffset={{0,-140}}, text=113},
    id_121 = {id=121, group=30, step=9, force = 99, type=TeachType.SHOW, param1="yindao", param2="false", param3= "yindaol", param4= 1, btnOffset={{0,-70}}, text="", isRepeat=1},
    id_122 = {id=122, group=30, step=10, force = 99, type=TeachType.SHOW, param1="zoom", param2="false", param3= "animation", param4= 1, btnOffset={{-23,-30}}, text=114},

    id_129 = {id=129, group=31, step=1, force = 4, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, text=7, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_130 = {id=130, group=31, step=2, force = 4, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_131 = {id=131, group=31, step=3, force = 4, type=TeachType.BUTTON, param1=-1, param2="btnCommit_CellTaskListItem", text=9, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},

    id_132 = {id=132, group=32, step=1, force = 5, type=TeachType.TALK, param1=8},
    id_133 = {id=133, group=32, step=2, force = 5, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, text=7, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_134 = {id=134, group=32, step=3, force = 5, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_135 = {id=135, group=32, step=4, force = 5, type=TeachType.BUTTON, param1=-1, param2="btnCommit_CellTaskListItem", text=9, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},
    id_136 = {id=136, group=32, step=5, force = 5, type=TeachType.BUTTON, param1=-1, param2="btnOK1_WndDressUp", text=103, btnOffset={{0,0}}, textOffset={{30,-25}}, dire=3, elementType=4, contentSize={{140,140}}, touchSize={{100,55}}},
    id_150 = {id=150, group=32, step=6, force = 5, type=TeachType.BUTTON, param1=-1, param2="btnUISwitch_CellTaskListItem", text=10, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},
    id_164 = {id=164, group=32, step=7, force = 5, type=TeachType.BUTTON, param1=1, param2="btn_CellSingleCoypLevel", text=11, btnOffset={{0,-20}}, textOffset={{-25,25}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{80,80}}},
    id_165 = {id=165, group=32, step=8, force = 5, type=TeachType.BUTTON, param1=-1, param2="btnChallenge_WndSingleCopyInfo", text=12, textOffset={{-20,40}}, textOffset_ug={{-20,140}}, textOffset_vn={{-100,180}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{150,50}}},
    
    id_137 = {id=137, group=33, step=1, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, removeSweep=true, text=7, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_138 = {id=138, group=33, step=2, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_139 = {id=139, group=33, step=3, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnCommit_CellTaskListItem", text=9, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},

    id_140 = {id=140, group=34, step=1, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, removeSweep=true, text=7, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_141 = {id=141, group=34, step=2, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_142 = {id=142, group=34, step=3, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnCommit_CellTaskListItem", text=9, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},

    id_143 = {id=143, group=35, step=1, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, removeSweep=true, text=7, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_144 = {id=144, group=35, step=2, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_145 = {id=145, group=35, step=3, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnCommit_CellTaskListItem", text=9, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},

    id_146 = {id=146, group=36, step=1, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, removeSweep=true, text=7, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_147 = {id=147, group=36, step=2, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_148 = {id=148, group=36, step=3, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnCommit_CellTaskListItem", text=9, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},

    id_152 = {id=152, group=-37, step=-1, force = 12, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, removeSweep=true, text=132, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_153 = {id=153, group=-37, step=-2, force = 12, type=TeachType.BUTTON, param1=-1, param2="btnItem_WndBottomBar", btnTask=2, btnOffset2={{0,-20}}, text=18, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, textOffset_2={{25,0}}},
    id_154 = {id=154, group=-37, step=-3, force = 12, type=TeachType.BUTTON, param1=-1, param2="checkbox2_WndSkillContainer", text=134, btnOffset={{-20,0}}, textOffset={{0,-30}}, dire=3, elementType=5, contentSize={{130,130}}, touchSize={{60,40}}},
    id_155 = {id=155, group=-37, step=-4, force = 12, type=TeachType.BUTTON, param1=-1, param2="imgTeach_WndStrengthen", text=135, btnOffset={{0,0}}, textOffset={{0,0}}, dire=3, elementType=2, contentSize={{140,140}}, touchSize={{80,80}}, must=1},
    id_156 = {id=156, group=-37, step=-5, force = 12, type=TeachType.BUTTON, param1=-1, param2="btnSophistic_WndSophisticStrengthen", text=136, btnOffset={{0,0}}, textOffset={{5,100}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{80,80}}},
    
    id_158 = {id=158, group=-38, step=-1, force = 9, type=TeachType.BUTTON, param1=-1, param2="checkWeapon_WndStrengthen", text=137, btnOffset={{0,0}}, textOffset={{5,100}}, dire=4, elementType=5, contentSize={{180,180}}, touchSize={{80,80}}},
    id_159 = {id=159, group=-38, step=-1, force = 9, type=TeachType.BUTTON, param1=-1, param2="imgTeach_WndStrengthen", text=138, btnOffset={{0,0}}, textOffset={{0,0}}, dire=3, elementType=2, contentSize={{140,140}}, touchSize={{80,80}}, must=1},
    id_160 = {id=160, group=-38, step=-2, force = 9, type=TeachType.BUTTON, param1=-1, param2="conEquipIcon2_WndTransferStrengthen", text=140, btnOffset={{0,0}}, textOffset={{-20,20}}, dire=4, elementType=4, contentSize={{180,180}}, touchSize={{80,80}}},
    id_161 = {id=161, group=-38, step=-3, force = 9, type=TeachType.BUTTON, param1=-1, param2="imgTeach_WndSelectTipsStrengthen", text=141, btnOffset={{0,0}}, textOffset={{-20,0}}, dire=4, elementType=2, contentSize={{140,140}}, touchSize={{80,80}}, must=1},
    id_162 = {id=162, group=-38, step=-4, force = 9, type=TeachType.BUTTON, param1=-1, param2="btnComfirm_WndSelectTipsStrengthen", text=142, btnOffset={{0,0}}, textOffset={{-10,50}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{60,60}}},
    id_163 = {id=163, group=-38, step=-5, force = 9, type=TeachType.BUTTON, param1=-1, param2="btnTransfer_WndTransferStrengthen", text=143, btnOffset={{0,0}}, textOffset={{-10,100}}, dire=4, elementType=1, contentSize={{180,180}}, touchSize={{80,80}}},
    
    id_170 = {id=170, group=39, step=1, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, removeSweep=true, text=7, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_171 = {id=171, group=39, step=2, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_172 = {id=172, group=39, step=3, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnCommit_CellTaskListItem", text=9, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},

    id_173 = {id=173, group=40, step=1, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, removeSweep=true, text=7, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_174 = {id=174, group=40, step=2, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_175 = {id=175, group=40, step=3, force = 8, type=TeachType.BUTTON, param1=-1, param2="btnCommit_CellTaskListItem", text=9, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},

    id_176 = {id=176, group=41, step=1, force = 9, type=TeachType.BUILDING, param1="11_1", paramLevelUp="11_2", dire=4, textOffset={{25,100}}, text=149, btnOffset={{0,0}}, btnOffset3={{0,0}}, contentSize={{140,140}}, touchSize=-1, elementType=2, must=1},
    id_204 = {id=204, group=41, step=2, force = 9, type=TeachType.BUTTON, param1=-1, param2="btn1_WndSummonEntrance", text=172, btnOffset={{0,0}}, textOffset={{-20,30}}, dire=4, elementType=1, contentSize={{250,250}}, touchSize=-1},
    id_177 = {id=177, group=41, step=3, force = 9, type=TeachType.BUTTON, param1=-1, param2="btnExtract_WndEquipmentLottery", text=150, btnOffset={{50,0}}, textOffset={{-20,10}}, dire=4, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_178 = {id=178, group=41, step=4, force = 9, type=TeachType.BUTTON, param1=-1, param2="btnOK1_WndDressUp", text=151, btnOffset={{0,0}}, textOffset={{30,-25}}, dire=3, elementType=4, contentSize={{140,140}}, touchSize={{100,55}}},
    id_179 = {id=179, group=41, step=5, force = 9, type=TeachType.BUTTON, param1=-1, param2="btnDimondRafflt_WndEquipmentLottery", text=152, btnOffset={{45,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_180 = {id=180, group=41, step=6, force = 9, type=TeachType.BUTTON, param1=-1, param2="btnOK1_WndDressUp", text=151, btnOffset={{0,0}}, textOffset={{30,-25}}, dire=3, elementType=4, contentSize={{140,140}}, touchSize={{100,55}}},
    id_181 = {id=181, group=41, step=7, force = 9, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, text=153, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_182 = {id=182, group=41, step=8, force = 9, type=TeachType.BUTTON, param1=-1, param2="btnTask_WndBottomBar", btnTask=2, btnOffset2={{-20,20}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, dire_2=4, textOffset_2={{-20,30}}, removeSweep=true, text=21, btnOffset={{0,0}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_183 = {id=183, group=41, step=9, force = 9, type=TeachType.BUTTON, param1=-1, param2="btnUISwitch_CellTaskListItem", text=156, btnOffset={{0,0}}, textOffset={{60,-110}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize={{110,55}}},
    
    id_184 = {id=184, group=42, step=1, force = 24, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, removeSweep=true, text=7, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_185 = {id=185, group=42, step=2, force = 24, type=TeachType.BUTTON, type_2=TeachType.BUILDING, param1=-1, param1_2="11_1", paramLevelUp="11_2", param2="btnMore_WndBottomBar", btnTask=2, btnOffset2={{0,0}}, btnOffset3={{0,0}}, removeSweep=true, text=163, text_2=177, btnOffset={{0,33}}, textOffset={{25,-10}}, dire=3, dire_2=4, textOffset_2={{25,100}}, elementType=1, elementType_2=2, contentSize={{160,160}}, touchSize={{60,47}}},
    id_186 = {id=186, group=42, step=3, force = 24, type=TeachType.BUTTON, param1=-1, param2="btnBless_ExtendUp_WndBottomBar", param2_2="btn3_WndSummonEntrance", btnTask=2, btnOffset2={{0,0}}, text=157, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_187 = {id=187, group=42, step=4, force = 24, type=TeachType.BUTTON, param1=-1, param2="btnBlessOnce_WndBless", text=158, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_188 = {id=188, group=42, step=5, force = 24, type=TeachType.BUTTON, param1=-1, param2="btnPickAll_WndBless", text=159, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_189 = {id=189, group=42, step=6, force = 24, type=TeachType.BUTTON, param1=-1, param2="btnBlessBag_WndBless", text=160, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_190 = {id=190, group=42, step=7, force = 24, type=TeachType.BUTTON, param1=10, param2="", text=161, btnOffset={{0,0}}, textOffset={{-25,25}}, dire=4, elementType=-1, contentSize={{200,200}}, touchSize={{80,80}}},
    id_194 = {id=194, group=42, step=8, force = 24, type=TeachType.BUTTON, param1=-1, param2="btnOperate2_WndTips", text=162, btnOffset={{0,0}}, textOffset={{30,-45}}, dire=3, elementType=1, contentSize={{150,150}}, touchSize={{110,30}}},
    
    id_191 = {id=191, group=43, step=1, force = 19, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, removeSweep=true, text=7, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_192 = {id=192, group=43, step=2, force = 19, type=TeachType.BUTTON, param1=-1, param2="btnPlayer_WndBottomBar", btnTask=2, btnOffset2={{0,-20}}, btnOffset3_1={{0,-7}}, text=32, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, textOffset_2={{25,0}}},
    id_193 = {id=193, group=43, step=3, force = 19, type=TeachType.BUTTON, param1=-1, param2="checkbox7_WndBagMain", text=164, btnOffset={{-15,30}}, textOffset={{0,-30}}, dire=3, elementType=5, contentSize={{130,130}}, touchSize={{60,40}}},
    id_195 = {id=195, group=43, step=4, force = 19, type=TeachType.BUTTON, param1=-1, param2="btnStar1_WndPractice", text=165, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    
    id_196 = {id=196, group=44, step=1, force = 32, type=TeachType.BUTTON, param1=-1, param2="btnSwitch_WndBottomBar", btnTask=1, removeSweep=true, text=7, btnOffset={{0,0}}, textOffset={{35,-40}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}, textOffset_4={{35,0}}, contentSize_4={{100,100}}, touchSize_4={{40,40}}},
    id_197 = {id=197, group=44, step=-2, force = 32, type=TeachType.BUTTON, param1=-1, param2="btnItem_WndBottomBar", btnTask=1, removeSweep=true, text=163, btnOffset={{0,33}}, textOffset={{25,-10}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    id_198 = {id=198, group=44, step=3, force = 32, type=TeachType.BUTTON, param1=-1, param2="btnKapai_WndBottomBar", param2_2="btnKapai_WndBottomBar", btnTask=2, btnOffset2={{0,-20}}, text=166, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}, contentSize_2={{100,100}}, touchSize_2={{47,47}}, textOffset_2={{25,0}}},
    id_199 = {id=199, group=44, step=4, force = 32, type=TeachType.BUTTON, param1=-1, param2="checkbox2_WndCard", text=167, btnOffset={{0,0}}, textOffset={{0,0}}, dire=4, elementType=5, contentSize={{180,180}}, touchSize={{80,80}}},
    id_200 = {id=200, group=44, step=5, force = 32, type=TeachType.BUTTON, param1=10, param2="", text=168, btnOffset={{0,0}}, textOffset={{-25,25}}, dire=4, elementType=-1, contentSize={{200,200}}, touchSize={{80,80}}},
    id_201 = {id=201, group=44, step=6, force = 32, type=TeachType.BUTTON, param1=-1, param2="btnOpen_WndOpenCardBox", text=169, btnOffset={{0,0}}, textOffset={{25,-25}}, dire=3, elementType=1, contentSize={{160,160}}, touchSize={{60,47}}},
    
    id_214 = {id=214, group=45, step=1, force = 99, type=TeachType.BUTTON, param1=-1, param2="btnMoreButler_WndFamilyOperate", text=186, btnOffset={{65,0}}, textOffset={{-10,40}}, dire=4, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}},
    id_215 = {id=215, group=45, step=2, force = 99, type=TeachType.BUTTON, param1=-1, param2="imgTeach1_WndFamilyShop", text=187, btnOffset={{0,0}}, textOffset={{-20,80}}, dire=4, elementType=2, contentSize={{140,140}}, touchSize=-1, must=1},   
    id_216 = {id=216, group=45, step=3, force = 99, type=TeachType.BUTTON, param1=-1, param2="btnSure_CellFamilyBuilding", text=188, btnOffset={{0,0}}, textOffset={{0,0}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}},
    id_217 = {id=217, group=45, step=4, force = 99, type=TeachType.BUTTON, param1=-1, param2="btnMoreButler_WndFamilyOperate", text=186, btnOffset={{65,0}}, textOffset={{-10,40}}, dire=4, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}},
    id_218 = {id=218, group=45, step=5, force = 99, type=TeachType.BUTTON, param1=-1, param2="imgTeach2_WndFamilyShop", text=189, btnOffset={{0,0}}, textOffset={{-20,80}}, dire=4, elementType=2, contentSize={{140,140}}, touchSize=-1, must=1},   
    id_219 = {id=219, group=45, step=6, force = 99, type=TeachType.BUTTON, param1=-1, param2="btnSure_CellFamilyBuilding", text=188, btnOffset={{0,0}}, textOffset={{0,0}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}},
    id_220 = {id=220, group=45, step=7, force = 99, type=TeachType.BUTTON, param1=-1, param2="btnBuilding_CellFamilyBuilding", text=189, btnOffset={{0,0}}, textOffset={{0,0}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}},
    id_221 = {id=221, group=45, step=8, force = 99, type=TeachType.BUTTON, param1=-1, param2="btnCollect_WndFamilyOperate", text=190, btnOffset={{0,0}}, textOffset={{0,0}}, dire=3, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}},
    id_222 = {id=222, group=45, step=9, force = 99, type=TeachType.TALK, param1=64},

    id_223 = {id=223, group=46, step=1, force = 99, type=TeachType.BUTTON, param1=-1, param2="战斗胜利", text=13, textOffset={{3,30}}, dire=4, elementType=1, contentSize={{140,140}}, touchSize={{190,190}}, textLength = 1.6, sound="clickFly"},
    id_224 = {id=224, group=47, step=1, force = 99, type=TeachType.BUTTON, param1=-1, param2="战斗胜利", text=13, textOffset={{3,30}}, dire=4, elementType=1, contentSize={{140,140}}, touchSize={{190,190}}, textLength = 1.6, sound="clickFly"},
    

    id_230 = {id=230, group=48, step=1, force = 23, type=TeachType.BUILDING, param1="5_1", paramLevelUp="5_2", text=197, dire=3, btnOffset={{0,0}}, btnOffset3={{20,0}}, textOffset={{30,-70}}, contentSize={{180,180}}, elementType=2, must=1, touchSize=-1},
    id_231 = {id=231, group=48, step=2, force = 23, type=TeachType.BUTTON, param1=-1, param2="btn3_ScenePvp", text=198, btnOffset={{0,0}}, textOffset={{-20,30}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize=-1},
    id_232 = {id=232, group=48, step=3, force = 23, type=TeachType.BUTTON, param1=-1, param2="btnPro_ScenePvpRank", text=199, btnOffset={{0,0}}, textOffset={{0,50}}, dire=4, elementType=1, contentSize={{100,100}}, touchSize={{80,80}}},

    id_237 = {id=237, group=49, step=1, force = 28, type=TeachType.BUILDING, param1="3_1", text=203, dire=4, btnOffset={{0,0}}, btnOffset3={{-120,0}}, btnOffset3_1={{50,0}}, textOffset={{0,0}}, contentSize={{140,140}}, touchSize=-1, elementType=2, must=1},
    id_238 = {id=238, group=49, step=2, force = 28, type=TeachType.BUTTON, param1=-1, param2="btn3_WndChallengeEntrance", text=204, btnOffset={{0,0}}, textOffset={{20,-30}}, dire=3, elementType=1, contentSize={{250,250}}, touchSize=-1},
    id_239 = {id=239, group=49, step=3, force = 28, type=TeachType.BUTTON, param1=-1, param2="conBtnSecPos1_SceneTabooMap", text=205, btnOffset={{0,0}}, textOffset={{0,80}}, dire=4, elementType=4, contentSize={{280,280}}, touchSize={{150,150}}},
    id_240 = {id=240, group=49, step=4, force = 28, type=TeachType.BUTTON, param1=-1, param2="btnTaboo_SceneTabooBattle", text=206, btnOffset={{0,0}}, textOffset={{0,0}}, dire=3, elementType=1, contentSize={{180,180}}, touchSize={{80,80}}},

    id_241 = {id=241, group=50, step=1, force = 99, type=TeachType.BUTTON, param1=-1, param2="btnBigSkill_WndBattleHud", text=211, btnOffset={{0,10}}, textOffset={{20,0}}, textOffset_ug={{20,100}}, dire=3, elementType=1, contentSize={{150,150}}, touchSize={{200,200}}, sound="clickAngrySkill"},
    id_242 = {id=242, group=51, step=1, force = 99, type=TeachType.BUTTON, param1=-1, param2="战斗胜利", text=13, textOffset={{3,30}}, dire=4, elementType=1, contentSize={{140,140}}, touchSize={{190,190}}, textLength = 1.6, sound="clickFly"},
    
}
-------------------------------------公有方法模块Begin--------------------------------------
--@brief	是否新手教学
function TeachGroup1:isTeach()
    if ProjConfig.DEBUG == 1 then
        --return false
    end
    if ProjConfig.CloseTeach and ProjConfig.CloseTeach == 1 then
        return false
    end
    if TeachGroup1.ISNOTEACH then
        return false
    end
    return true
end

--@brief 新手战斗
function TeachGroup1:startFirstBattleTeach()
    if ProjConfig.DEBUG == 1 then
        --do return false end
        --[[
        do 
            WndSingleCopy:receiveStartChallengeOk(9999, 1, {-1,-1,-1,-1,-1})
            return true 
        end
        --]]
    end

    if TeachGroup1:isTeach() ~= true then
        do return false end
    end
    local isEnd, step = TeachGroup1:isTeachFinish(25)
    WZLog("TeachGroup1:startFirstBattleTeach",isEnd, step, CacheCenter:getPlayerInfo().level)
    if true and ((not isEnd) and CacheCenter:getPlayerInfo().level <= 1) then
        WndSingleCopy:receiveStartChallengeOk(9999, 1, {-1,-1,-1,-1,-1})
        PostPlayerEvent:postEvent(PostPlayerEvent.event_teachFight)
        return true
    end
    return false
end

--@brief	检查是否能开始新手教学
function TeachGroup1:start(groupId, stepId, scene, areaScene, isBattle, levelUp, isBar, isIgnoreMsgBox, isTrailerAnim)
    if CacheCenter:getPlayerInfo() == nil then
        return
    end
--    isTrailerAnim = true
--    groupId, stepId = 41, 1
--    SceneCity.m_bIsLevelUp = true
    WZLog("TeachGroup1_start_zero-00", tostring(isTrailerAnim), tostring(TeachGroup1:isTeach()), tostring(TeachGroup1.ISBATTLE), tostring(groupId), tostring(stepId), tostring(CacheCenter:getPlayerInfo().level), tostring(TeachGroup1:isTeachFinish(1)))
    local f,s = TeachGroup1:isTeachFinish(1)
    
    local isConfirmActive = WindowManager:ifActiveWindow(WndConfirmBox)
    WZLog("TeachGroup1_start_zero-01", tostring(isConfirmActive))
    if isConfirmActive then
        return false
    end

    local isConfirmActive = WindowManager:ifActiveWindow(WndRewardShow)
    WZLog("TeachGroup1_start_zero-02", tostring(isConfirmActive), tostring(GlobalGame.g_bIsRewardShow), tostring(levelUp))
    if GlobalGame.g_bIsRewardShow and levelUp == nil then
        return false
    end

    WZLog("TeachGroup1_start_zero-03", tostring(WndUpgrade.m_root), tostring(WndUpgrade.m_bIsExit))
    if WndUpgrade.m_root and WndUpgrade.m_bIsExit ~= true then
        return false
    end

    if WndDressUp.m_root then
        local isNeed = false
        local teachstep = {{26,8}, {32,5}, {41,4}, {41,6}}
        for i,info in ipairs(teachstep) do
            if groupId == info[1] and stepId == info[2] then
                isNeed = true
                break
            end
        end

        WZLog("TeachGroup1_start_zero-05", isNeed, groupId, stepId)
        if isNeed == false then
            WndDressUp:onCloseClick()
        end
    end

    local msgCount = (MsgBoxManager.m_tHighLevelMsgList == nil and 0 or #MsgBoxManager.m_tHighLevelMsgList)
    msgCount = msgCount + (MsgBoxManager.m_tNormalLevelMsgLis == nil and 0 or #MsgBoxManager.m_tNormalLevelMsgLis)
    msgCount = msgCount + (MsgBoxManager.m_tLowLevelMsgList == nil and 0 or #MsgBoxManager.m_tLowLevelMsgList)

    WZLog("TeachGroup1_start_zero-04", tostring(isConfirmActive), tostring(GlobalGame.g_bIsRewardShow), tostring(MsgBoxManager:_getCurHighestPriorityMsg()), tostring(isIgnoreMsgBox), tostring(msgCount), tostring(msgCount == 1 and MsgBoxManager:_getCurHighestPriorityMsg().nStatus))
    
    if (MsgBoxManager:_getCurHighestPriorityMsg() ~= nil and (msgCount > 1 or (msgCount == 1 and (MsgBoxManager:_getCurHighestPriorityMsg().nStatus ~= MSGBOXSTATUS_DONE and MsgBoxManager:_getCurHighestPriorityMsg().nStatus ~= 0 and (MsgBoxManager:_getCurHighestPriorityMsg().nType ~= MSGBOXTYPE_LOADING or #MsgBoxManager.m_tAutoLoadingBoxList < 1))))) and isIgnoreMsgBox == nil and (groupId ~= 30 and groupId ~= 48 and (groupId ~= 32 or stepId ~=7)) then
        return false
    end

    if (not TeachGroup1:isTeach()) then
        return false
    end

    local isFinish, finishStep = TeachGroup1:isTeachFinish(groupId)

    if isFinish == false and ((groupId == 11 and finishStep >= 5 and stepId < 5)) then
        TeachGroup1:setTeachFinish(groupId, -1)
        isFinish, finishStep = true, -1
    end
    
    local isBottom = false
    if stepId == 2 and (GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.type == 2 or GlobalGame.g_tWndBottomBarObj == nil and SceneCity.m_tWndBottomBarObj and SceneCity.m_tWndBottomBarObj.type == 2) then
        
        local bottomList = {9,10,11,19,31,33,34,35,36,37,39,40,42,43,44}
        for i,v in pairs(bottomList) do
            if groupId == v then
                isBottom = true
                break
            end
        end
    end
    WZLog("TeachGroup1_start_zero-1", groupId, stepId, tostring(isBottom), tostring(scene), tostring(isFinish), tostring(finishStep))
     
    if (isFinish == true and groupId ~= 25 and isBattle == nil) or (stepId > 1 and finishStep == 0 and isBottom == false and (isBar == nil or isBar == true and levelUp == nil) and groupId ~= 25 and groupId ~= 30) then
        return false
    end

    if self.m_tStepList == nil then
        self.m_tStepList = {}
        for i = 1 ,TeachGroup1.COUNT do
            self:initStep(i)
        end
        --WZLog("TeachGroup1:start one-0", Serialize(self.m_tStepList))
    end

    local isTeach = false
    for id, group in pairs (self.m_tStepList) do
        WZLog("TeachGroup1:start one-1", groupId, group.groupId)
        if groupId == group.groupId then
            local infoGroup = group.info
            
            for index, info in ipairs (infoGroup) do
                local isBtnTask = info.btnTask and info.btnTask == 1 and (GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.type == 2 and GlobalGame.g_tWndBottomBarObj.m_nMoveDirection == 0 or GlobalGame.g_tWndBottomBarObj == nil and SceneCity.m_tWndBottomBarObj and SceneCity.m_tWndBottomBarObj.type == 2 and SceneCity.m_tWndBottomBarObj.m_nMoveDirection == 0)
                local isBtnTask4 = info.btnTask and info.btnTask == 1 and (GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.type == 2 and GlobalGame.g_tWndBottomBarObj.m_nMoveDirection == 1 or GlobalGame.g_tWndBottomBarObj == nil and SceneCity.m_tWndBottomBarObj and SceneCity.m_tWndBottomBarObj.type == 2 and SceneCity.m_tWndBottomBarObj.m_nMoveDirection == 1)
                
                local isBtnTask2 = info.btnTask and info.btnTask == 2 and (GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.type == 2 or GlobalGame.g_tWndBottomBarObj == nil and SceneCity.m_tWndBottomBarObj and SceneCity.m_tWndBottomBarObj.type == 2)
                WZLog("TeachGroup1:start two", stepId, info.step, tostring(isBtnTask), tostring(isBtnTask2), tostring(isBtnTask4), info.type, TeachType.AREA_LIMIT, info.force, CacheCenter:getPlayerInfo().level, info.btnOffset and info.btnOffset[1] and info.btnOffset[1][1])
                --TeachGroup1:start two 1   1   true    false   2   5   11  11  0
                if ((isBtnTask ~= true and info.step == stepId) or (isBtnTask2 == true and info.step == stepId+1) or (isBtnTask2 == true and info.step == stepId+2)) and (info.force >= CacheCenter:getPlayerInfo().level or info.force == -1 or TeachGroup1.ISTEACHMODE) then
                    TeachGroup1:changeTeachState(true)
                    TeachGroup1.GROUP = info.group
                    TeachGroup1.STEP = info.step
                    -- if isBtnTask2 and info.group == 43 and info.step == 3 and WndOwnCity.m_root then
                    --     scene = WndOwnCity.m_root
                    -- end
                    TeachGroup1.SCENE = areaScene or scene

                    local param1 = isBtnTask2 and info.param1_2 or info.param1
                    local param2 = isBtnTask2 and info.param2_2 or info.param2
                    local text = isBtnTask2 and info.text_2 or info.text
                    local type_ = isBtnTask2 and info.type_2 or info.type
                    local elementType = isBtnTask2 and info.elementType_2 or info.elementType
                    local btnOffset = isBtnTask2 and info.btnOffset2 or info.btnOffset
                    --btnOffset = isTrailerAnim and info.btnOffset3 or btnOffset
                    if isTrailerAnim then
                        if info.btnOffset3_1 then
                            local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
                            local screenRate = screenSize.width / screenSize.height
                            local offset = (screenRate - (1024/768)) * info.btnOffset3_1[1][1]
                            local offset2 = (screenRate - (1024/768)) * info.btnOffset3_1[1][2]
                            local btnOffset3 = info.btnOffset3 and CopyTable(info.btnOffset3) or CopyTable(btnOffset)
                            btnOffset3[1][1] = btnOffset3[1][1] + offset
                            btnOffset3[1][2] = btnOffset3[1][2] + offset2
                            btnOffset = btnOffset3
                            WZLog("TeachGroup1:start two_1", screenRate, offset, btnOffset3[1][1], offset2, btnOffset3[1][2])
                        else
                            btnOffset = info.btnOffset3
                        end
                    end
                    local contentSize = isBtnTask2 and info.contentSize_2 or isBtnTask4 and info.contentSize_4 or info.contentSize
                    local touchSize = isBtnTask2 and info.touchSize_2 or isBtnTask4 and info.touchSize_4 or info.touchSize
                    local textOffset = isBtnTask2 and info.textOffset_2 or isBtnTask4 and info.textOffset_4 or info.textOffset
                    local dire = isBtnTask2 and info.dire_2 or info.dire

                    if "en" == ProjConfig.LANGUAGE and info.textOffset_en then
                        textOffset = info.textOffset_en
                    elseif "vn" == ProjConfig.LANGUAGE and info.textOffset_vn then
                        textOffset = info.textOffset_vn
                    end
                    if "vn" == ProjConfig.LANGUAGE and info.btnOffset_vn then
                        btnOffset = info.btnOffset_vn
                    end
                    
                    if "tr" == ProjConfig.LANGUAGE and info.textOffset_tr then
                        textOffset = info.textOffset_tr
                    end
                    if "ug" == ProjConfig.LANGUAGE and info.textOffset_ug then
                        textOffset = info.textOffset_ug
                    end

                    if type_ == TeachType.TALK then
                        isTeach = self:createStoryTalk(param1, info.battle, info.group, info.step, scene)
                    elseif type_ == TeachType.BUILDING then
                        if SceneCity.m_bIsLevelUp then
                            param1 = info.paramLevelUp or param1
                        end
                        isTeach = self:createBuildingInstruct(param1, TeachGroup1:getTeachText(text), dire, info.group, info.step, btnOffset, textOffset, contentSize, touchSize, elementType)
                    elseif type_ == TeachType.BUTTON then
                        isTeach = self:createButtonInstruct(param1, param2, TeachGroup1:getTeachText(text), dire, info.group, info.step, btnOffset, textOffset, scene, elementType, contentSize, touchSize, info.textLength, info.screen, info.sound, info.must, info.param2_1)                            
                    elseif type_ == TeachType.AREA then
                        isTeach = self:createAreaInstruct(param1, param2, TeachGroup1:getTeachText(text), dire, info.group, info.step, btnOffset, textOffset, scene, elementType, contentSize, touchSize, info.textLength, info.bgOffset, info.bgSize)
                    elseif type_ == TeachType.AREA_LIMIT then
                        isTeach = self:createAreaLimitInstruct(param1, param2, TeachGroup1:getTeachText(text), dire, info.group, info.step, btnOffset, textOffset, scene, elementType, contentSize, touchSize, info.textLength, info.bgOffset, info.bgSize)
                    elseif type_ == TeachType.SHOW then
                        isTeach = self:createShow(param1, param2, info.param3, info.param4, info.param13, info.param5, info.param6, info.param7, info.param8, info.param9, info.param10, info.param11, info.param12, info.battle, info.group, info.step, scene, TeachGroup1:getTeachText(text), btnOffset, info.isRepeat)
                    end

                    WZLog("TeachGroup1:start three",tostring(isTeach), TeachGroup1.GROUP, TeachGroup1.STEP, tostring(info.removeSweep), tostring(WndTask.m_root), tostring(WndRewardShow.m_root))
                    if isTeach ~= false and info.removeSweep == true then
                        if WndSweepResult.m_root then
                            WindowManager:removeWindow(WndSweepResult.m_root, WndSweepResult, true)
                        end

                        if WndAthReward.m_root then
                            WindowManager:removeWindow(WndAthReward.m_root, WndAthReward, true)
                        end

                        if WndAthRank.m_root then
                            WindowManager:removeWindow(WndAthRank.m_root, WndAthRank, true)
                        end

                        if WndSingleCopyInfo.m_root then
                            WindowManager:removeWindow(WndSingleCopyInfo.m_root, WndSingleCopyInfo, true)
                        end

                        if WndSummonEntrance.m_root then
                            WindowManager:removeWindow(WndSummonEntrance.m_root, WndSummonEntrance, true)
                        end

                        if WndTask.m_root then
                            WndTask.m_bIsTeach = true
                            WindowManager:removeWindow(WndTask.m_root , WndTask , true)
                        end

                        if WndRewardShow.m_root then
                            WndRewardShow.m_bIsTeach = true
                            WindowManager:removeWindow(WndRewardShow.m_root , WndRewardShow , true)
                        end

                        if WndTrainingCamp.m_root then
                            WindowManager:removeWindow(WndTrainingCamp.m_root, WndTrainingCamp, true)
                        end

                        if WndGangsterInnOwner.m_root then
                            WindowManager:removeWindow(WndGangsterInnOwner.m_root, WndGangsterInnOwner, true)
                        end

                        if WndStore.m_root then
                            WindowManager:removeWindow(WndStore.m_root, WndStore, true)
                        end

                        if GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.m_root  and TeachGroup1.GROUP ~= 44  and TeachGroup1.GROUP ~= 43  and TeachGroup1.GROUP ~= 42  then
                            local con = GetElement(GlobalGame.g_tWndBottomBarObj.m_root,"conAllExtend_WndBottomBar",WZUIContainer)
                            if con then
                                con:setVisible(false)
                            end
                        end
                    end

                    return isTeach
                end
            end
        end
    end

    WZLog("TeachGroup1:start four")
    return false
end

--@brief    结束教学步骤
function TeachGroup1:endTeachStep(...)
    WZLog("TeachGroup1:endTeachStep", Serialize(...))
    TeachGroup1:onTouchEnd(nil, nil, nil, ...)
end

--@brief    在升级的情况开始新手教学
function TeachGroup1:startGroupLevelUp(levelUp , isBar, isIgnoreMsgBox, isTrailerAnim, ...)
    local  teach = false
    if not TeachGroup1:isTeach() then
        return false
    end
    local arg = {...}
    for i,param in ipairs(arg) do
        WZLog("TeachGroup1:startGroupLevelUp", tostring(isTrailerAnim), i,param[1],param[2],tostring(param[3]),tostring(param[4]))
        local isTeach = TeachGroup1:start(param[1],param[2],param[3],param[4], nil, levelUp, isBar, isIgnoreMsgBox, isTrailerAnim)
        if isTeach == nil then
            return
        else

        end
    end

    return false
end

--@brief    开始新手教学
function TeachGroup1:startGroup(...)
    local  teach = false
    if not TeachGroup1:isTeach() then
        return false
    end
    local arg = {...}
    for i,param in ipairs(arg) do
        WZLog("TeachGroup1:startGroup", i,param[1],param[2],tostring(param[3]),tostring(param[4]))
        local isTeach = TeachGroup1:start(param[1],param[2],param[3],param[4])
        if isTeach == nil then
            return
        else

        end
    end

    return false
end

--@brief    清除新手教学
function TeachGroup1:removeTeach()
    WZLog("TeachGroup1:removeTeach")
    TeachGroup1:changeTeachState(false)
    WindowManager:removeTeachShelterLayer()
end

--@brief 教学文本
function TeachGroup1:getTeachText(index)
    return LocalStrings["TEACH_"..index] or LocalStrings[index] or index
end

--@brief 改变教学状态
function TeachGroup1:changeTeachState(isTeach)
    WZLog("TeachGroup1:changeTeachState", tostring(isTeach))
    if not TeachGroup1:isTeach() then
        return
    end
    TeachGroup1.ISTEACH = isTeach
    if isTeach == true then
        if SceneCity.m_root then
            local scene = WZUIScene:luaTo(SceneCity.m_root:getChildElement("conBgLayer_SceneCity"))
            if scene == nil then scene = SceneCity.m_tSceneLayer end
            if scene.setEnableMoveHorizontal then
                scene:setEnableMoveHorizontal(false)
            end
        end

        if WndSevenDayActivity and WndSevenDayActivity.m_root then
            WindowManager:removeWindow(WndSevenDayActivity.m_root, WndSevenDayActivity, true)
        end
        
        if WndActive and WndActive.m_root then
            WindowManager:removeWindow(WndActive.m_root, WndActive, true)
        end

        if WndGameActivity and WndGameActivity.m_root then
            WindowManager:removeWindow(WndGameActivity.m_root, WndGameActivity, true)
        end

        if WndWelfare and WndWelfare.m_root then
            WindowManager:removeWindow(WndWelfare.m_root, WndWelfare, true)
        end

        if WndRedEnvelopesRain and WndRedEnvelopesRain.m_root then
            WindowManager:removeWindow(WndRedEnvelopesRain.m_root, WndRedEnvelopesRain, true)
        end

        if WndSingleCopy.m_root then
            GetElement(WndSingleCopy.m_root, "pgconCopy_WndSingleCopy", WZUIPageContainer):setEnableMoveHorizontal(false)
        end

        if WndTask.m_root then
            GetElement(WndTask.m_root, "flconTaskList_WndTask", WZUITableContainer):setEnableMoveVertical(false)
        end

        if WndSkillProp.m_root then
            GetElement(WndSkillProp.m_root, "tbSkillList_WndSkillProp", WZUITableContainer):setEnableMoveVertical(false)
        end

        if WndEquip.m_root then
            GetElement(WndEquip.m_root, "tableConGoods_WndEquip", WZUITableContainer):setEnableMoveHorizontal(false)
            GetElement(WndEquip.m_root, "tableConGoods_WndEquip", WZUITableContainer):setEnableMoveVertical(false)
        end

        if WndDressList.m_root then
            GetElement(WndDressList.m_root, "tableCon_WndDressList", WZUITableContainer):setEnableMoveHorizontal(false)
            GetElement(WndDressList.m_root, "tableCon_WndDressList", WZUITableContainer):setEnableMoveVertical(false)
        end

        if WndStrengthen.m_root then
            GetElement(WndStrengthen.m_root, "tbMyEquipList_WndStrengthen", WZUIFreeListContainer):setEnableMoveHorizontal(false)
            GetElement(WndStrengthen.m_root, "tbMyEquipList_WndStrengthen", WZUIFreeListContainer):setEnableMoveVertical(false)
        end

        if WndSelectTipsStrengthen.m_root then
            GetElement(WndSelectTipsStrengthen.m_root, "tbTipsCell_WndSelectTipsStrengthen", WZUITableContainer):setEnableMoveHorizontal(false)
            GetElement(WndSelectTipsStrengthen.m_root, "tbTipsCell_WndSelectTipsStrengthen", WZUITableContainer):setEnableMoveVertical(false)
        end

        if WndPets.m_root then
            GetElement(WndPets.m_root, "conPetList_WndPets", WZUIFreeListContainer):setEnableMoveVertical(false)
        end

        if WndShop.m_root then
            --GetElement(WndShop.m_root, "tabProp_WndShop", WZUITableContainer):setEnableMoveVertical(false)
            GetElement(WndShop.m_root, "tabDress_WndShop", WZUITableContainer):setEnableMoveVertical(false)
        end

        if WndTrainingCamp.m_root then
            WindowManager:removeWindow(WndTrainingCamp.m_root, WndTrainingCamp, true)
        end

        if WndFamilyShop.m_root then
            GetElement(WndFamilyShop.m_root, "tableCon_WndFamilyShop", WZUITableContainer):setEnableMoveHorizontal(false)
            GetElement(WndFamilyShop.m_root, "tableCon_WndFamilyShop", WZUITableContainer):setEnableMoveVertical(false)
        end

        if SceneFamily.m_root then
            SceneFamily:setCantMoveAndScale(true)
        end

        if CellRechargePanelActivity and CellRechargePanelActivity.m_root then
            WindowManager:removeWindow(CellRechargePanelActivity.m_root, CellRechargePanelActivity, true)
            TeachGroup1:setFirstRechangePushFinish("1_2", true)
             TeachGroup1:setFirstRechangePushFinish("2_2", true)
        end

        if WndGangsterInnOwner.m_root then
            WindowManager:removeWindow(WndGangsterInnOwner.m_root, WndGangsterInnOwner, true)
        end

        if WndStore.m_root then
            WindowManager:removeWindow(WndStore.m_root, WndStore, true)
        end

        if WndMaster.m_root then
            WindowManager:removeWindow(WndMaster.m_root, WndMaster, true)
        end

        if WndMasterTask.m_root then
            WindowManager:removeWindow(WndMasterTask.m_root, WndMasterTask, true)
        end
    else
        if SceneCity.m_root then
            local scene = WZUIScene:luaTo(SceneCity.m_root:getChildElement("conBgLayer_SceneCity"))
            if scene == nil then scene = SceneCity.m_tSceneLayer end
            if scene.setEnableMoveHorizontal then
                scene:setEnableMoveHorizontal(true)
            end
        end

        if WndSingleCopy.m_root then
            GetElement(WndSingleCopy.m_root, "pgconCopy_WndSingleCopy", WZUIPageContainer):setEnableMoveHorizontal(true)
        end

        if WndTask.m_root then
            GetElement(WndTask.m_root, "flconTaskList_WndTask", WZUITableContainer):setEnableMoveVertical(true)
        end

        if WndSkillProp.m_root then
            GetElement(WndSkillProp.m_root, "tbSkillList_WndSkillProp", WZUITableContainer):setEnableMoveVertical(true)
        end

        if WndEquip.m_root then
            GetElement(WndEquip.m_root, "tableConGoods_WndEquip", WZUITableContainer):setEnableMoveVertical(true)
        end

        if WndDressList.m_root then
            GetElement(WndDressList.m_root, "tableCon_WndDressList", WZUITableContainer):setEnableMoveVertical(true)
        end

        if WndStrengthen.m_root then
            GetElement(WndStrengthen.m_root, "tbMyEquipList_WndStrengthen", WZUIFreeListContainer):setEnableMoveVertical(true)
        end

        if WndSelectTipsStrengthen.m_root then
            GetElement(WndSelectTipsStrengthen.m_root, "tbTipsCell_WndSelectTipsStrengthen", WZUITableContainer):setEnableMoveVertical(true)
        end

        if WndPets.m_root then
            GetElement(WndPets.m_root, "conPetList_WndPets", WZUIFreeListContainer):setEnableMoveVertical(true)
        end

        if WndShop.m_root then
            --GetElement(WndShop.m_root, "tabProp_WndShop", WZUITableContainer):setEnableMoveVertical(true)
            GetElement(WndShop.m_root, "tabDress_WndShop", WZUITableContainer):setEnableMoveVertical(true)
        end

        if WndFamilyShop.m_root then
            GetElement(WndFamilyShop.m_root, "tableCon_WndFamilyShop", WZUITableContainer):setEnableMoveVertical(true)
        end

        if SceneFamily.m_root then
            SceneFamily:setCantMoveAndScale(false)
        end
    end
end

--@brief 结束步骤
function TeachGroup1:finishStep(teachGroupId, teachStepId, scene)
    if not TeachGroup1:isTeach() then
        return
    end
    WZLog("TeachGroup1:finishStep zero", tostring(teachGroupId), tostring(teachStepId))
    if self.m_tStepList == nil or teachGroupId == nil or teachStepId == nil then
        return
    end

    local giftList = {{45,9,ISLAND_BUILDING_HOME}}
    for i,giftStep in pairs(giftList) do
        if TeachGroup1.GROUP == giftStep[1] and TeachGroup1.STEP == giftStep[2] then
            WZLog("TeachGroup1:onTouchEnd six2", giftStep[1], giftStep[2], giftStep[3])
            ProtocolProcessorCommonPush:send_COMMONPUSH_GetDirectionalPush(ProjConfig.CHANNEL_ID, 2, giftStep[3])
            break
        end
    end

    self:setTeachFinish(teachGroupId,teachStepId)
    for id, group in ipairs (self.m_tStepList) do
        WZLog("TeachGroup1:finishStep one", teachGroupId, group.groupId)
        if teachGroupId == group.groupId then
            local infoGroup = group.info
            --WZLog("TeachGroup1:finishStep two", teachStepId, Serialize(infoGroup))
            for index, info in ipairs (infoGroup) do
                if teachStepId + 1 == info.step then
                    if teachGroupId == 5 and teachStepId + 1 == 2 then
                        local elementObj = GlobalGame.g_tWndBottomBarObj or SceneCity.m_tWndBottomBarObj or scene
                        if elementObj.m_nMoveDirection == 0 then
                            TeachGroup1:start(info.group, 3, scene)
                        else
                            TeachGroup1:start(info.group, 2, scene)
                        end
                    else
                        WZLog("TeachGroup1:finishStep three", info.group, info.step)
                        TeachGroup1:start(info.group, info.step, scene)
                    end
                    return
                end
            end
            TeachGroup1:changeTeachState(false)
            self:setTeachFinish(teachGroupId,-1)
        elseif teachGroupId + 1 == group.groupId then
            local info = group.info[1][1]
            if info then
                WZLog("TeachGroup1:finishStep four", info.group, info.step)
                TeachGroup1:start(info.group, info.step, scene)
            end
        end
    end
end

--@brief 创建演示(新手战斗用)
function TeachGroup1:createShow(aniName, isArmature, actionName, mainId, effectId, boomAniName, boomActionName, boomScale, actionEndName, bulletInfo, skillInfo, addtimes, traceInfo, isBattle, teachGroupId, teachStepId, scene, text, btnOffset, isRepeat)
    isRepeat = isRepeat == 1 and true or false
    --WZLog("TeachGroup1:createShow", tostring(effectId), tostring(traceInfo), bulletInfo and Serialize(bulletInfo), tostring(isRepeat),aniName, actionName, isArmature, teachGroupId, teachStepId, isBattle)
    WindowManager:removeTeachShelterLayer()

    local aniNameList = SplitStringWithSeparator(aniName, ",")
    local actionNameList = SplitStringWithSeparator(actionName, ",")
    local bulletInfoList = {}
    skillInfo = skillInfo and SplitStringWithSeparator(skillInfo[1][1], ",")
    traceInfo = traceInfo and SplitStringWithSeparator(traceInfo, ",", nil, true)
    if bulletInfo then
        for i, v in ipairs (bulletInfo) do
            WZLog("TeachGroup1:createShow two",i,v)
            table.insert(bulletInfoList, SplitStringWithSeparator(v[1], ",", nil, true))
        end
    end
    isArmature = isArmature == "true" and true or false
    
    local conShelter = WindowManager:addTeachShelterLayer( 999999 )
    conShelter:setLuaObjectIndex(TeachGroup1)
    TeachGroup1.ANIME, TeachGroup1.ANIME_LAYER = WindowManager:addTeachShow(scene, aniNameList, isArmature, actionNameList, teachGroupId, teachStepId, isBattle, text, btnOffset, mainId)
    TeachGroup1.ANIME_IS_ARMATURE = isArmature
    TeachGroup1.ANIME_ACTION_NAME = actionNameList
    TeachGroup1.ANIME_ACTION_END_NAME = actionEndName
    TeachGroup1.ANIME_BULLET_INFO = bulletInfoList
    TeachGroup1.ANIME_MAIN_ID = mainId
    TeachGroup1.ANIME_EFFECT_ID = effectId
    TeachGroup1.ANIME_REPEAT = isRepeat
    TeachGroup1.ANIME_BOOM_NAME = boomAniName
    TeachGroup1.ANIME_BOOM_SCALE = boomScale
    TeachGroup1.ANIME_BOOM_ACTION_NAME = boomActionName
    TeachGroup1.SKILL_INFO = skillInfo
    TeachGroup1.BULLET_ADDTIMES = addtimes ~= nil and true or nil
    TeachGroup1.TRACE_INFO = traceInfo

    WindowManager:setTeachTouchCallBack( TeachGroup1, "onShowTouchBegan")
    TeachGroup1.ANIME.m_tScene = scene
    TeachGroup1:updateControl()
end

--@brief    定时更新函数(新手战斗用)
function TeachGroup1:updateControl()
    local function TeachGroup1_update(intervalTime)
        if TeachGroup1.ANIME then
            local ani1 = TeachGroup1.ANIME[TeachGroup1.ANIME_MAIN_ID]
            local actionName = TeachGroup1.ANIME_IS_ARMATURE and "0" or (TeachGroup1.ANIME_ACTION_END_NAME or TeachGroup1.ANIME_ACTION_NAME[TeachGroup1.ANIME_MAIN_ID] or "animation")
            
            local bullets = WBattleGlobal:getCurrent().m_tBulletTeachs
            if bullets then
                for i=#bullets,1,-1 do

                    local isExist = bullets[i] and bullets[i]:updatePosition()
                    local pos = bullets[i] and bullets[i].m_mover:getMoverPosition()
                    WZLog("TeachGroup1:updateControl 0", i, pos and pos.x)
                    if TeachGroup1.m_followAnim == nil and TeachGroup1.TRACE_INFO and pos and pos.x > TeachGroup1.TRACE_INFO[1] then
                        TeachGroup1.m_followAnim = BattleAnimation:createAnimation("skills_zzd_sd",true)
                        TeachGroup1.ANIME_LAYER:addChild(TeachGroup1.m_followAnim:getAnimNode())
                        TeachGroup1.m_followAnim:play("0",true)
                        TeachGroup1.m_followAnim:getAnimNode():setScale(0.5)
                        TeachGroup1.m_followAnim:getAnimNode():setPositionX(TeachGroup1.TRACE_INFO[4])
                        TeachGroup1.m_followAnim:getAnimNode():setPositionY(TeachGroup1.TRACE_INFO[5])
                    end

                    if TeachGroup1.TRACE_INFO and pos and pos.x > TeachGroup1.TRACE_INFO[6] then
                        bullets[i].m_mover:setMoverSpeed(Vector2:create(TeachGroup1.TRACE_INFO[2],TeachGroup1.TRACE_INFO[3]))
                    end

                    if pos and pos.x > bullets[i].info[5] then
                        if TeachGroup1.m_followAnim and TeachGroup1.m_followAnim:isRunning() then
                            if TeachGroup1.m_followAnim:getAnimNode():getParent() then
                                TeachGroup1.m_followAnim:getAnimNode():removeFromParentAndCleanup(true)
                            end
                        end
                        TeachGroup1.m_followAnim = nil

                        local bullets = WBattleGlobal:getCurrent().m_tBulletTeachs
                        
                        if TeachGroup1.SKILL_CELL then
                            TeachGroup1.SKILL_CELL:removeFromParentAndCleanup(true)
                            TeachGroup1.SKILL_CELL = nil
                        end

                        local index = bullets[i].index


                        WZLog("TeachGroup1:updateControl 1", i, index, tostring(TeachGroup1.m_tExplodeElement), tostring(TeachGroup1.m_tExplodeElement and TeachGroup1.m_tExplodeElement[index]))
                        if TeachGroup1.m_tExplodeElement and TeachGroup1.m_tExplodeElement[index] then

                            if TeachGroup1.m_tExplodeElement[index] and TeachGroup1.m_tExplodeElement[index]:isRunning() then
                                if TeachGroup1.m_tExplodeElement[index]:getAnimNode():getParent() then
                                    TeachGroup1.m_tExplodeElement[index]:getAnimNode():removeFromParentAndCleanup(true)
                                end
                            end
                            TeachGroup1.m_tExplodeElement[index] = nil
                        end
                        local pos = GlobalMethod:ccp(bullets[i].info[6 + (8 * (bullets[i].scatterIndex-1))] + math.random(-1,1), bullets[i].info[7 + (8 * (bullets[i].scatterIndex-1))] + math.random(-1,1))
                        TeachGroup1.m_tExplodeElement = TeachGroup1.m_tExplodeElement or {}
                        TeachGroup1.m_tExplodeElement[index] = BattleAnimation:createAnimation(TeachGroup1.ANIME_BOOM_NAME,false)
                        TeachGroup1.m_tExplodeElement[index]:getAnimNode():setUseAbsCoordinate(true)
                        TeachGroup1.m_tExplodeElement[index]:getAnimNode():setUseOriginSizeProportion(true)
                        TeachGroup1.m_tExplodeElement[index]:getAnimNode():setTouchEnable(false)
                        TeachGroup1.m_tExplodeElement[index]:getAnimNode():setScale(TeachGroup1.ANIME_BOOM_SCALE)
                        TeachGroup1.m_tExplodeElement[index]:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
                        TeachGroup1.m_tExplodeElement[index]:getAnimNode():setAbsPosition(pos)
                        TeachGroup1.ANIME_LAYER:addChild(TeachGroup1.m_tExplodeElement[index]:getAnimNode())
                        TeachGroup1.m_tExplodeElement[index]:play(TeachGroup1.ANIME_BOOM_ACTION_NAME,false)
                        ani1:play(actionName,false)

                        if bullets then
                            bullets[i]:destroy()
                            table.remove(bullets,i)              
                        end
                    end
                end
            end

            --WZLog("TeachGroup1_update 1", tostring(bullets), tostring(ani1:isPlaying(actionName)), tostring(ani1:isCurrentAnimationDone()))
            if ani1 and ani1:isPlaying(actionName) and ani1:isCurrentAnimationDone() == true and TeachGroup1.ANIME_END == nil then
                WZLog("TeachGroup1_update 2", tostring(TeachGroup1.ANIME_REPEAT))
                TeachGroup1.ANIME_END = true
                if TeachGroup1.ANIME_REPEAT then
                    GetElement(TeachGroup1.ANIME_LAYER, "conTTF_TeachShelterLayer" , WZUIContainer):setVisible(true)
                else
                    for i, ani in ipairs (TeachGroup1.ANIME) do
                        WZLog("TeachGroup1_update 3", i, ani, TeachGroup1.ANIME_ACTION_NAME[i])
                        ani:play(TeachGroup1.ANIME_ACTION_NAME[i], true)
                    end
                    
                    GetElement(TeachGroup1.ANIME_LAYER, "conTTF_TeachShelterLayer" , WZUIContainer):setVisible(true)
                end
            elseif ani1 and ani1:isPlaying(actionName) and ani1:isCurrentAnimationDone() == true and TeachGroup1.ANIME_END == true then
                WZLog("TeachGroup1_update 4")
                ani1:play(TeachGroup1.ANIME_ACTION_NAME[1], true)
            end
        end
    end

    TeachGroup1.SCHEDULE = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(TeachGroup1_update, 0, false)
end

--@brief    事件函数(新手战斗用)
function TeachGroup1:event(animation, name, eventName)
    WZLog("TeachGroup1:event", animation, name, tostring(eventName), tostring(TeachGroup1.ANIME_EFFECT_ID), tostring(TeachGroup1.ANIME_EFFECT_ID and TeachGroup1.ANIME[TeachGroup1.ANIME_EFFECT_ID]))

    if name == "event" and (eventName == "zidan" or (TeachGroup1.BULLET_ADDTIMES == true and ( eventName == "zidan1" or eventName == "zidan2" or eventName == "zidan3" or eventName == "zidan4" or eventName == "zidan5")) ) then
        TeachGroup1.BULLET_COUNT = TeachGroup1.BULLET_COUNT + 1
        TeachGroup1.BULLET_COUNT_TOTAL = TeachGroup1.BULLET_COUNT_TOTAL + 1
        if TeachGroup1.BULLET_COUNT > #TeachGroup1.ANIME_BULLET_INFO then
            TeachGroup1.BULLET_COUNT = 1
        end
        
        if TeachGroup1.ANIME_EFFECT_ID and TeachGroup1.ANIME[TeachGroup1.ANIME_EFFECT_ID] then
            local ani1 = TeachGroup1.ANIME[TeachGroup1.ANIME_EFFECT_ID]
            ani1:play("p2",false)
            WZLog("TeachGroup1:event six")
        end

        --WZLog("TeachGroup1:event one", TeachGroup1.BULLET_COUNT, Serialize(TeachGroup1.TRACE_INFO) , Serialize(TeachGroup1.ANIME_BULLET_INFO))

        local info = TeachGroup1.ANIME_BULLET_INFO[TeachGroup1.BULLET_COUNT]
        for i = 1, info[8] do
            WZLog("TeachGroup1:event two", i, info[1 + (8 * (i-1))], info[2 + (8 * (i-1))], info[3 + (8 * (i-1))], info[4 + (8 * (i-1))])

            local bullet = WBattleGlobal:getCurrent():buildBulletTeach(WBattleGlobal:getCurrent():getCurrentCharacterId(), info[1 + (8 * (i-1))], info[2 + (8 * (i-1))], info[3 + (8 * (i-1))], info[4 + (8 * (i-1))], false)
            bullet.info = info
            bullet.index = info[8] > 1 and i or TeachGroup1.BULLET_COUNT
            bullet.scatterIndex = i
            TeachGroup1.ANIME_LAYER:addChild(bullet:getAnimation():getAnimNode(),3,3)
            if WBattleGlobal:getCurrent().m_tIsHighEndMachine == true then
                TeachGroup1.ANIME_LAYER:addChild(bullet:getBackFire():getParent(),1,1)
                bullet:getBackFire():setScale(0.1)
            end
        end
    elseif name == "event" and eventName == "jineng" and TeachGroup1.SKILL_INFO then
        WZLog("TeachGroup1:event three")
        local info = TeachGroup1.SKILL_INFO
        local cell = TeachGroup1:createCell(info[1])
        cell:setScale(0.5)
        TeachGroup1.ANIME_LAYER:addChild(cell)
        cell:setRelativePositionLuaTo(0.34,0.48)
        if TeachGroup1.SKILL_CELL then
            TeachGroup1.SKILL_CELL:removeFromParentAndCleanup(true)
            TeachGroup1.SKILL_CELL = nil
        end
        TeachGroup1.SKILL_CELL = cell
        TeachGroup1:showImage(cell)
    elseif name == "event" and eventName == "xunhuan" and TeachGroup1.ANIME_EFFECT_ID and TeachGroup1.ANIME[TeachGroup1.ANIME_EFFECT_ID] then
        local ani1 = TeachGroup1.ANIME[TeachGroup1.ANIME_EFFECT_ID]
        ani1:play("loop",true)
        WZLog("TeachGroup1:event five")
    elseif name == "event" and eventName == "xuli" and TeachGroup1.ANIME_EFFECT_ID and TeachGroup1.ANIME[TeachGroup1.ANIME_EFFECT_ID] then
        local ani1 = TeachGroup1.ANIME[TeachGroup1.ANIME_EFFECT_ID]
        ani1:play("loop",true)
        WZLog("TeachGroup1:event four")
    end
end

--@brief    创建一个显示栏Cell(新手战斗用)
function TeachGroup1:createCell(usePng)
    local cell = WZUIContainer:create()
    cell:setUseAbsSize(true)
    cell:setAbsContentSize(GlobalMethod:CCSize(BattleShowHeroUse.CELL_WIDTH,BattleShowHeroUse.CELL_HEIGHT))

    local bg = WZUIImage:create()
    bg:setFile("ui/common/common_icon_jinengkuang.png")
    local img = WZUIImage:create()
    img:setFile(usePng)
    img:setUseOriginSize(true)
    img:setName("imgShowHeroUse_TeachGroup1")
    cell:addChild(bg)
    cell:addChild(img)

    local lvIcon = "battleitems/battle_icon_jnl1.png"
    if TeachGroup1.GROUP == 30 and TeachGroup1.STEP == 7 then
        lvIcon = ""
    end
 
    if lvIcon and lvIcon ~= "" then
        local x,y = 0.7,0.2

        local lv = WZUIImage:create()
        lv:setUseOriginSize(true)
        lv:setFile(lvIcon)
        lv:setRelativePositionLuaTo(x,y)
        cell:addChild(lv,10)
    end

    cell:setTag(1)
    return cell
end

--@brief    道具闪现(新手战斗用)
function TeachGroup1:showImage(sprite)

    local delayTime = 0.04
    local fadeTime = 0.1
    local action = WZUIActionSequence:create()
    action:setIsLoop(false)

    local actionDelay1 = WZUIActionDelayTime:create()
    actionDelay1:setDuration(delayTime)

    local actionFadeTo1 = WZUIActionFadeTo:create()
    actionFadeTo1:setOpacity(0)
    actionFadeTo1:setDuration(fadeTime)

    local actionDelay2 = WZUIActionDelayTime:create()
    actionDelay2:setDuration(delayTime)

    local actionFadeTo2 = WZUIActionFadeTo:create()
    actionFadeTo2:setOpacity(255)
    actionFadeTo2:setDuration(fadeTime)

    local actionDelay3 = WZUIActionDelayTime:create()
    actionDelay3:setDuration(delayTime)

    local actionFadeTo3 = WZUIActionFadeTo:create()
    actionFadeTo3:setOpacity(0)
    actionFadeTo3:setDuration(fadeTime)

    local actionDelay4 = WZUIActionDelayTime:create()
    actionDelay4:setDuration(delayTime)

    local actionFadeTo4 = WZUIActionFadeTo:create()
    actionFadeTo4:setOpacity(255)
    actionFadeTo4:setDuration(fadeTime)

    actionFadeTo4:setFinishLuaFunction("actionEnd")
    actionFadeTo4:setFinishLuaTable(self)

    action:setChildAction(actionDelay1)
    action:setChildAction(actionFadeTo1)
    action:setChildAction(actionDelay2)
    action:setChildAction(actionFadeTo2)
    action:setChildAction(actionDelay3)
    action:setChildAction(actionFadeTo3)
    action:setChildAction(actionDelay4)
    action:setChildAction(actionFadeTo4)

    sprite:runUIAction(action)
end

--@brief    事件函数(新手战斗用)
function TeachGroup1:actionEnd(element)
    WZLog("TeachGroup1:actionEnd")
    if TeachGroup1.SKILL_CELL then
        TeachGroup1.SKILL_CELL:removeFromParentAndCleanup(true)
        TeachGroup1.SKILL_CELL = nil
    end
end

--@brief    开始按下事件函数(新手战斗用)
function TeachGroup1:onShowTouchBegan(element, point)

    local groupId = TeachGroup1.GROUP
    local stepId = TeachGroup1.STEP
    local scene = TeachGroup1.ANIME.m_tScene
    
    WZLog("TeachGroup1:onShowTouchBegan",tostring(element), groupId, stepId)

    if TeachGroup1.ANIME_END then
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(TeachGroup1.SCHEDULE)
        if TeachGroup1.m_tExplodeElement then
            for i, v in pairs (TeachGroup1.m_tExplodeElement) do
                if v and v:isRunning() then
                    if v:getAnimNode():getParent() then
                        v:getAnimNode():removeFromParentAndCleanup(true)
                    end
                end
            end
            TeachGroup1.m_tExplodeElement = nil
        end

        if TeachGroup1.m_followAnim and TeachGroup1.m_followAnim:isRunning() then
            if TeachGroup1.m_followAnim:getAnimNode():getParent() then
                TeachGroup1.m_followAnim:getAnimNode():removeFromParentAndCleanup(true)
            end
        end

        TeachGroup1.m_followAnim = nil

        if TeachGroup1.SKILL_CELL then
            TeachGroup1.SKILL_CELL:removeFromParentAndCleanup(true)
            TeachGroup1.SKILL_CELL = nil
        end

        WBattleGlobal:getCurrent().m_tBulletTeachs = {}
        WindowManager:removeTeachShelterLayer()

        TeachGroup1:removeTeachAnim()
        TeachGroup1:removeTeach()
        --TeachGroup1:finishStep(groupId, stepId, scene)
        if TeachGroup1.ISSHOW == true then
            BattleMsgTeachStep4.teachShow = true
        end
    end
end

--@brief 删除动画(新手战斗用)
function TeachGroup1:removeTeachAnim()
    WZLog("TeachGroup1:removeTeachAnim", tostring(TeachGroup1.ANIME))
    if TeachGroup1.ANIME and TeachGroup1.ANIME[TeachGroup1.ANIME_MAIN_ID] then
        TeachGroup1.ANIME[TeachGroup1.ANIME_MAIN_ID] = nil
    end

    TeachGroup1.SKILL_CELL = nil
    TeachGroup1.m_tExplodeElement = nil
    TeachGroup1.ANIME = nil
    TeachGroup1.ANIME_LAYER = nil
    TeachGroup1.SCHEDULE = nil
    TeachGroup1.ANIME_END = nil
    TeachGroup1.ANIME_MAIN_ID = nil
    TeachGroup1.ANIME_EFFECT_ID = nil
    TeachGroup1.ANIME_REPEAT = nil
    TeachGroup1.ANIME_BOOM_NAME = nil
    TeachGroup1.ANIME_BOOM_ACTION_NAME = nil
    TeachGroup1.BULLET_COUNT = 0
    TeachGroup1.BULLET_COUNT_TOTAL = 0
    TeachGroup1.BULLET_ADDTIMES = nil
    TeachGroup1.TRACE_INFO = nil
end

--@brief 创建剧情对话
function TeachGroup1:createStoryTalk(groupId, isBattle, teachGroupId, teachStepId, scene)
    WZLog("TeachGroup1:createStoryTalk",groupId, isBattle, teachGroupId, teachStepId)
    WindowManager:removeTeachShelterLayer()
    CreateStoryTalkGroup(groupId,isBattle == 1, teachGroupId, teachStepId, scene)
end

--@brief 创建建筑指引
function TeachGroup1:createBuildingInstruct(buildingId, text, dire, teachGroupId, teachStepId, btnOffset, textOffset, contentSize, touchSize, elementType)
    WZLog("TeachGroup1:createBuildingInstruct", buildingId, text, teachGroupId, teachStepId, btnOffset and btnOffset[1] and btnOffset and btnOffset[1][1])

    local isConfirmActive = WindowManager:ifActiveWindow(WndConfirmBox)
    WZLog("TeachGroup1_start_zero-01", tostring(isConfirmActive))
    if isConfirmActive then
        return false
    end

    if SceneCity.m_root == nil then
        return false
    end

    btnOffset = btnOffset and btnOffset[1] or {0,0}
    textOffset = textOffset and textOffset[1] or {0,0}
    WZLog("TeachGroup1:createBuildingInstruct two", btnOffset[1],btnOffset[2])

    if elementType == nil or elementType == 1 then
        elementType = WZUIButton
    elseif elementType == 2 then
        elementType = WZUIImage
    elseif elementType == 3 then
        elementType = WZUITableContainer
    elseif elementType == 4 then
        elementType = WZUIContainer
    elseif elementType == 5 then
        elementType = WZUICheckBox
    elseif elementType == -1 then
        elementType = nil
    end

    local tCell = GetElement(SceneCity.m_root, "building"..buildingId.."_SceneCity", elementType)
    contentSize = type(contentSize) == "table" and GlobalMethod:CCSize(contentSize[1][1],contentSize[1][2]) or tCell:getContentSize()
    touchSize = type(touchSize) == "table" and GlobalMethod:CCSize(touchSize[1][1],touchSize[1][2]) or nil
    WindowManager:removeTeachShelterLayer()
    local conShelter = WindowManager:addTeachShelterLayer( 999999 )
    conShelter:setLuaObjectIndex(TeachGroup1)
    local cell = WindowManager:addTeachTouchLayerForBuilding(tCell, contentSize, touchSize,nil, GlobalMethod:ccp(btnOffset[1],btnOffset[2]))
    WindowManager:setTeachTouchCallBack( TeachGroup1, "onTouchBegan" , "onTouchMove", "onTouchEnd" , "onMoveOut")

    Teach:showDialog( cell , cell , text , dire , GlobalMethod:ccp(textOffset[1],textOffset[2]), 1 )
end

--@brief 创建按钮指引
function TeachGroup1:createButtonInstruct(childId, buttonName, text, dire, teachGroupId, teachStepId, btnOffset, textOffset, scene, elementType, contentSize, touchSize, textLength, screen, sound,must,buttonName2)
    WZLog("TeachGroup1:createButtonInstruct", childId, buttonName, text, teachGroupId, teachStepId, buttonName2)

    local isConfirmActive = WindowManager:ifActiveWindow(WndConfirmBox)
    WZLog("TeachGroup1_start_zero-01", tostring(isConfirmActive))
    if isConfirmActive then
        return false
    end

    btnOffset = btnOffset and btnOffset[1] or {0,0}
    textOffset = textOffset and textOffset[1] or {0,0}
    local tCell = self:getElement(childId, buttonName, elementType, scene, must)
    if tCell == nil then
        if buttonName2 ~= nil then
            tCell = self:getElement(childId, buttonName2, elementType, scene, must)
        end
        if tCell == nil then
            WZLog("TeachGroup1:createButtonInstruct two")
            return false
        end
    end
    contentSize = type(contentSize) == "table" and GlobalMethod:CCSize(contentSize[1][1],contentSize[1][2]) or nil
    touchSize = type(touchSize) == "table" and GlobalMethod:CCSize(touchSize[1][1],touchSize[1][2]) or nil
    WindowManager:removeTeachShelterLayer()
    local conShelter = WindowManager:addTeachShelterLayer( 999999 )
    conShelter:setLuaObjectIndex(TeachGroup1)
    local cell = WindowManager:addTeachTouchLayerForButton(tCell, contentSize, touchSize, GlobalMethod:ccp(btnOffset[1],btnOffset[2]), screen)
    WindowManager:setTeachTouchCallBack( TeachGroup1, "onTouchBegan" , "onTouchMove", "onTouchEnd" , "onMoveOut")

    if dire == 4 then
        textOffset[1] = textOffset[1] + 40
    end
    Teach:showDialog( cell , cell , text , dire , GlobalMethod:ccp(textOffset[1],textOffset[2]), 1, textLength )
    if sound then
        SoundManager:playEffectSound(GetRoleSound() .. "/" .. sound..".mp3")
    end
end

--@brief 创建区域指引
function TeachGroup1:createAreaInstruct(childId, buttonName, text, dire, teachGroupId, teachStepId, btnOffset, textOffset, scene, elementType, contentSize, touchSize, textLength, bgOffset, bgSize)
    WZLog("TeachGroup1:createAreaInstruct", childId, buttonName, text, teachGroupId, teachStepId)

    local isConfirmActive = WindowManager:ifActiveWindow(WndConfirmBox)
    WZLog("TeachGroup1_start_zero-01", tostring(isConfirmActive))
    if isConfirmActive then
        return false
    end

    btnOffset = btnOffset and btnOffset[1] or {0,0}
    textOffset = textOffset and textOffset[1] or {0,0}
    bgOffset = bgOffset and bgOffset[1] or {0,0}
    local tCell = self:getElement(childId, buttonName, elementType, scene)
    if tCell == nil then
        WZLog("TeachGroup1:createAreaInstruct two")
        return false
    end
    contentSize = type(contentSize) == "table" and GlobalMethod:CCSize(contentSize[1][1],contentSize[1][2]) or nil
    touchSize = type(touchSize) == "table" and GlobalMethod:CCSize(touchSize[1][1],touchSize[1][2]) or nil
    bgSize = type(bgSize) == "table" and GlobalMethod:CCSize(bgSize[1][1],bgSize[1][2]) or nil
    WindowManager:removeTeachShelterLayer()
    local conShelter = WindowManager:addTeachShelterLayer( 999999 )
    conShelter:setLuaObjectIndex(TeachGroup1)
    local cell = WindowManager:addTeachTouchLayerForArea(tCell, contentSize, touchSize, GlobalMethod:ccp(btnOffset[1],btnOffset[2]), bgSize, GlobalMethod:ccp(bgOffset[1],bgOffset[2]))
    WindowManager:setTeachTouchCallBack( TeachGroup1, "onTouchBegan" , "onTouchMove", "onTouchEnd" , "onMoveOut")
    --GetElement(WindowManager.m_sceneRoot, "imgBlack_TeachShelterLayer", WZUIImage):setTouchEnable(true)
    Teach:showDialog( cell , cell , text , dire , GlobalMethod:ccp(textOffset[1],textOffset[2]), 1, textLength, true )
end

--@brief 创建区域指引,点击限制
function TeachGroup1:createAreaLimitInstruct(childId, buttonName, text, dire, teachGroupId, teachStepId, btnOffset, textOffset, scene, elementType, contentSize, touchSize, textLength, bgOffset, bgSize)
    WZLog("TeachGroup1:createAreaLimitInstruct", childId, buttonName, text, teachGroupId, teachStepId)

    local isConfirmActive = WindowManager:ifActiveWindow(WndConfirmBox)
    WZLog("createAreaLimitInstruct-01", tostring(isConfirmActive))
    if isConfirmActive then
        return false
    end

    btnOffset = btnOffset and btnOffset[1] or {0,0}
    textOffset = textOffset and textOffset[1] or {0,0}
    bgOffset = bgOffset and bgOffset[1] or {0,0}
    local tCell = self:getElement(childId, buttonName, elementType, scene)
    if tCell == nil then
        WZLog("TeachGroup1:createAreaLimitInstruct two")
        return false
    end
    contentSize = type(contentSize) == "table" and GlobalMethod:CCSize(contentSize[1][1],contentSize[1][2]) or nil
    touchSize = type(touchSize) == "table" and GlobalMethod:CCSize(touchSize[1][1],touchSize[1][2]) or nil
    bgSize = type(bgSize) == "table" and GlobalMethod:CCSize(bgSize[1][1],bgSize[1][2]) or nil
    WindowManager:removeTeachShelterLayer()
    local conShelter = WindowManager:addTeachShelterLayer( 999999 )
    conShelter:setLuaObjectIndex(TeachGroup1)
    local cell = WindowManager:addTeachTouchLayerForArea(tCell, contentSize, touchSize, GlobalMethod:ccp(btnOffset[1],btnOffset[2]), bgSize, GlobalMethod:ccp(bgOffset[1],bgOffset[2]))
    WindowManager:setTeachTouchCallBack( TeachGroup1, "onTouchBegan" , "onTouchMove", "onTouchEnd" , "onMoveOut")
    --GetElement(WindowManager.m_sceneRoot, "imgBlack_TeachShelterLayer", WZUIImage):setTouchEnable(true)
    Teach:showDialog( cell , cell , text , dire , GlobalMethod:ccp(textOffset[1],textOffset[2]), 1, textLength )
end

--@brief 获取元素
function TeachGroup1:getElement(tag, buttonName, elementType, scene,must)
    WZLog("TeachGroup1:getElement one",tag, buttonName, elementType, tostring(scene))
    if elementType == 1 then
        elementType = WZUIButton
    elseif elementType == 2 then
        elementType = WZUIImage
    elseif elementType == 3 then
        elementType = WZUITableContainer
    elseif elementType == 4 then
        elementType = WZUIContainer
    elseif elementType == 5 then
        elementType = WZUICheckBox
    elseif elementType == -1 then
        elementType = nil
    end
    if scene == nil then
        return
    end
    WZLog("TeachGroup1:getElement two", tag, type(tag))
    local element = nil
    if tag ~= -1 then
        if tag < 10 then
            element = scene:getChildByTag(tag)
        elseif tag < 20 and tag >= 10 then
            tag = tag - 10
            element = WZUITableContainer:luaTo(scene):getCellElement(tag)
        end
        if elementType and element then
            elementType:luaTo(element)
            WZLog("TeachGroup1:getElement three",tag, buttonName, elementType, tostring(scene), tostring(element:isVisible()), tostring(element:getParent():isVisible()))
        end
    else
        element = scene
    end
    WZLog("TeachGroup1:getElement four", buttonName)
    if buttonName ~= "" and element.getTag then
        element = GetElement(element, buttonName, elementType)
        WZLog("TeachGroup1:getElement five",tag, buttonName, elementType, tostring(scene), tostring(element), tostring(element and element:isVisible()), tostring(element and element:getParent():isVisible()))
    elseif buttonName ~= "" then
        element = nil
    end
    if must == nil and (element == nil or element:isVisible() ~= true or element:getParent():isVisible() ~= true) then
        return nil
    end
    return element
end
--@brief    移开事件函数
function TeachGroup1:onMoveOut()
    WZLog("TeachGroup1:onMoveOut")
    TeachGroup1.ISMOVE = true
end

--@brief    按下移动回调函数
function TeachGroup1:onTouchMove()
    local isTouch = nil

    WZLog("TeachGroup1:onTouchMove", tostring(isTouch))

    TeachGroup1.ISMOVE = true
end

--@brief    开始按下事件函数
function TeachGroup1:onTouchBegan(element, point)
    
    TeachGroup1.ISMOVE = false
    self.m_tPosTouchBegan = GlobalMethod:ccp(point.x, point.y)

    local groupId = TeachGroup1.GROUP
    local stepId = TeachGroup1.STEP

    WZLog("TeachGroup1:onTouchBegan",tostring(element), tostring(point.x), tostring(point.y), groupId, stepId)

    if groupId == 9 and stepId == 4 then
        --return false
    end
end

--@brief    按下结束事件函数
function TeachGroup1:onTouchEnd(element, point, isOk, ...)
    if not TeachGroup1:isTeach() then
        return
    end
    local endGroupId, endStepId = 0,0
    local arg = {...}
    for i,param in ipairs(arg) do
        WZLog("TeachGroup1:onTouchEnd -1", i,param[1],param[2], TeachGroup1.GROUP, TeachGroup1.STEP)
        if param[1] == TeachGroup1.GROUP and param[2] == TeachGroup1.STEP then
            endGroupId = param[1]
            endStepId = param[2]
            WZLog("TeachGroup1:onTouchEnd -2")
            break
        end
    end

    local isAreaStep
    local areaStepList = {{-1,-1}}
    for i,areaStep in pairs(areaStepList) do
        if TeachGroup1.GROUP == areaStep[1] and TeachGroup1.STEP == areaStep[2] then
            isAreaStep = true
            break
        end
    end

    self.m_tPosTouchEnd = point and GlobalMethod:ccp(point.x, point.y) or nil
    local dis = self.m_tPosTouchEnd and BattleCommon:pointDis(self.m_tPosTouchBegan,self.m_tPosTouchEnd) or -1
    WZLog("TeachGroup1:onTouchEnd zero-1",tostring(element), tostring(point and point.x), tostring(TeachGroup1.ISBATTLE), dis   , tostring( point and point.y), TeachGroup1.GROUP, TeachGroup1.STEP, tostring(TeachGroup1.ISMOVE), tostring(isOk))
    --WZLuaLog:TeachGroup1:onTouchEnd zero-1  userdata: 0x7feee2b4    168.36949157715 nil 0   298.43020629883 5   5   false   nil 
    --WZLuaLog:TeachGroup1:onTouchEnd zero-1    userdata: 0x824bb7a4    549.29534912109 nil 0   340.04962158203 9   4   false   nil 
    if (--[[TeachGroup1.ISMOVE == false or]] (TeachGroup1.ISBATTLE == true ) or isOk == true) or (endGroupId == TeachGroup1.GROUP and endStepId == TeachGroup1.STEP) or (isAreaStep == true) then
        WZLog("TeachGroup1:onTouchEnd zero-2")
        local groupId = TeachGroup1.GROUP
        local stepId = TeachGroup1.STEP
        local scene = TeachGroup1.SCENE

        if self.m_tStepList then
            for id, group in pairs (self.m_tStepList) do
                WZLog("TeachGroup1:onTouchEnd one-1", groupId, group.groupId, TeachGroup1.STEP)
                if TeachGroup1.GROUP == group.groupId then
                    local infoGroup = group.info
                    WZLog("TeachGroup1:onTouchEnd two-2", #infoGroup, group.groupId, Serialize(infoGroup))
                    if #infoGroup == TeachGroup1.STEP then
                        self:changeTeachState(false)
                        TeachGroup1.GROUP = -1
                        TeachGroup1.STEP = -1
                        break
                    end
                end
            end
        end

        local endStepList = {{11,5}}
        for i,areaStep in pairs(endStepList) do
            if TeachGroup1.GROUP == areaStep[1] and TeachGroup1.STEP == areaStep[2] then
                self:changeTeachState(false)
                TeachGroup1.GROUP = -1
                TeachGroup1.STEP = -1
                break
            end
        end

        if isAreaStep then
            WZLog("TeachGroup1:onTouchEnd three", groupId, stepId, scene)
            TeachGroup1:finishStep(groupId, stepId, scene)
            return
        end

        if TeachGroup1.ISSKILL == true then
            BattleMsgTeachStep4.skillUse = true
        end

        if TeachGroup1.ISTALK == true then
            TeachGroup1.ISTALK = nil
            BattleMsgTeachStep4.talk = true
        end
        self:setTeachFinish(groupId,stepId)

        for id, group in pairs (TeachGroup1.m_tStepList) do
            WZLog("TeachGroup1:onTouchEnd four", stepId, groupId, group.groupId, #group.info)
            if groupId == group.groupId then
                local info = group.info[#group.info]
                for i,v in pairs(group.info) do
                    if v.step == #group.info then
                        info = v
                    end
                end
                WZLog("TeachGroup1:onTouchEnd five", stepId, #group.info, Serialize(group.info), "info:", Serialize(info))
                if info.step == stepId and groupId ~= 1 and groupId ~= 2 and groupId ~= 4 and groupId ~= 6  and groupId ~= 21 and groupId ~= 25 then
                    self:setTeachFinish(groupId,-1)
                end
            end
        end

        WindowManager:removeTeachShelterLayer()

    end
    TeachGroup1.ISMOVE = nil

    if endGroupId == 32 and endStepId == 6 then
        GetElement(WndSingleCopy.m_oCurPage:getChildByTag(5), "btn_CellSingleCoypLevel",WZUIButton):setTouchEnable(false)
        WZLog("TeachGroup1:changeTeachState two")
    end

    local giftList = {{41,6,ISLAND_BUILDING_EQUIT_LOTTERY},{12,7,ISLAND_RIGHT_PET},{10,5,STRENGTHEN_UPSTAR},{11,4,STRENGTHEN_INLAY},{42,8,ISLAND_UP_BLESS},{45,9,ISLAND_BUILDING_HOME},{19,7,ISLAND_RIGHT_MOUNT},{44,6,ISLAND_EXTEND_CARD}}
    for i,giftStep in pairs(giftList) do
        if endGroupId == giftStep[1] and endStepId == giftStep[2] then
            WZLog("TeachGroup1:onTouchEnd six", giftStep[1], giftStep[2], giftStep[3])
            ProtocolProcessorCommonPush:send_COMMONPUSH_GetDirectionalPush(ProjConfig.CHANNEL_ID, 2, giftStep[3])
            break
        end
    end
end

--@brief    按下结束事件函数
function TeachGroup1:onTouchEndLimit(element, point, isOk, ...)
    WZLog("TeachGroup1:onTouchEndLimit",tostring(element),tostring(point),tostring(isOk))
end

--@brief 初始化步骤
function TeachGroup1:initStep(groupId)
    WZLog("TeachGroup1:initStep zero",groupId)
    local group = {}
    for i = 1, BattleCommon:tableLen(GDatatab_Teach) do
        local info = GDatatab_Teach["id_"..i]
        --WZLog("TeachGroup1:initStep one", i)
        if info and info.group == groupId then
            table.insert(group, info)
            
        end
    end

    table.sort(group,function(a,b) return a.step<b.step end) 
    table.insert(self.m_tStepList, {groupId = groupId, info = group})
end

--@brief    任务教学
function TeachGroup1:taskTeach(id)
    WZLog("TeachGroup1:taskTeach",id)
    TeachGroup1:setTeachFinish(id,-2)

end

--@brief    风力教学
function TeachGroup1:windTeach(id)
    
    local isEnd,count = TeachGroup1:isWindTeachFinish(id)
    WZLog("TeachGroup1:windTeach",id, tostring(isEnd), count)
    if isEnd ~= true then
        TeachGroup1:setTeachFinish(id,count - 1)
    end

end

--@brief 获取教学完成状态
function TeachGroup1:isWindTeachFinish(groupIndex)

    if self.m_tWindDate == nil then
        self.m_tWindDate = {}
    end

    local isTeachFinish, teachStep = false, -3
    for id, info in pairs (self.m_tWindDate) do
        if groupIndex == info.group then
            if info.step <= -5 then
                isTeachFinish = true
                teachStep = -5
            else
                isTeachFinish = false
                teachStep = info.step
            end
        end
    end

    --WZLog("TeachGroup1:isTaskTeachFinish", tostring(isTeachFinish),teachStep, type(teachStep))
    return isTeachFinish, tonumber(teachStep)
end

--@brief 获取教学完成状态
function TeachGroup1:isTaskTeachFinish(groupIndex, isWind)
    if not TeachGroup1:isTeach() and isWind == nil then
        return true, -1
    end

    if self.m_tTaskDate == nil then
        self.m_tTaskDate = {}
    end

    local isTeachFinish, teachStep = false, 0
    for id, info in pairs (self.m_tTaskDate) do
        if groupIndex == info.group then
            if info.step == -2 then
                isTeachFinish = true
                teachStep = -2
            else
                isTeachFinish = false
                teachStep = info.step
            end
        end
    end

    --WZLog("TeachGroup1:isTaskTeachFinish", tostring(isTeachFinish),teachStep, type(teachStep))
    return isTeachFinish, tonumber(teachStep)
end

--@brief 设置教学完成状态
function TeachGroup1:setTeachFinish(groupIndex, stepIndex, isForce)
    if not TeachGroup1:isTeach() then
        return
    end
  
    if isForce ~= true then
        if stepIndex > -2 then
            TeachGroup1.ISTEACH = nil
            local isFinish, finishStep = TeachGroup1:isTeachFinish(groupIndex)
            WZLog("TeachGroup1_setTeachFinish one-1", tostring(groupIndex), tostring(stepIndex), tostring(isFinish), finishStep)
            if stepIndex == -1 then
                ProtocolProcessorTeach:send_TASK_TiroStep(groupIndex, stepIndex)
            elseif isFinish then
                return
            elseif stepIndex ~= -1 and finishStep >= stepIndex then 
                return
            end
        elseif stepIndex == -2 then
            local isFinish, finishStep = TeachGroup1:isTaskTeachFinish(groupIndex)
            WZLog("TeachGroup1_setTeachFinish one-2", tostring(groupIndex), tostring(stepIndex), tostring(isFinish), finishStep)
            if isFinish then
                return
            end
        elseif stepIndex < -2 then
            local isFinish, finishStep = TeachGroup1:isWindTeachFinish(groupIndex)
            WZLog("TeachGroup1_setTeachFinish one-2", tostring(groupIndex), tostring(stepIndex), tostring(isFinish), finishStep)
            if isFinish then
                return
            end
        end
    end
    if stepIndex > -2 then
        local isExsit = false
        for id, info in pairs (self.m_tDate) do
            if groupIndex == info.group then
                self.m_tDate[id].step = stepIndex
                isExsit = true
            end
        end

        if isExsit == false then
            table.insert(self.m_tDate, {group=groupIndex, step=stepIndex})
        end
    elseif stepIndex == -2 then
        table.insert(self.m_tTaskDate, {group=groupIndex, step=stepIndex})
    elseif stepIndex < -2 then
        table.insert(self.m_tWindDate, {group=groupIndex, step=stepIndex})
    end
    WZLog("TeachGroup1_setTeachFinish two", tostring(groupIndex), tostring(stepIndex), tostring(isFinish), finishStep)
    TeachGroup1:postTeach(groupIndex, stepIndex)
    if isForce ~= true then
        ProtocolProcessorTeach:send_TASK_TiroStep(groupIndex, stepIndex)
    end
end

--@brief 埋点
function TeachGroup1:postTeach( group, step )
    local list = {{1,5}, {3,7}, {5,11}, {7,5}, {8,11}, {31,3}, {9,11}, {32,8}, {33,3}, {34,3}, {35,3}, {36,3}, {20,9}, {39,3}, {40,3}}

    WZLog("TeachGroup1:postTeach1", group, step)
    for i,info in pairs(list) do
        if group == info[1] and step <= info[2] and step > 0 then
            WZLog("TeachGroup1:postTeach2", group, step)
            PostPlayerEvent:postTeach(group .. "-" .. step)
        end
    end
end

--@brief 获取全部教学状态
function TeachGroup1:getAllData( ids, step )
    self.m_tDate = {}
    self.m_tTaskDate = {}
    self.m_tWindDate = {}
    WZLog("Teach:getAllData one", ids:size(), step:size())
    if ids:size() ~= 0 and step:size() ~= 0 then
        for i = 0 , step:size() - 1 do

            WZLog("Teach:getAllData three", i + 1, ids:get(i), step:get(i))
            if ids:get(i) == 0 and step:get(i) == -1 then
                TeachGroup1.ISNOTEACH = true
            end
            if step:get(i) > -2 then
                local groupId,stepId = nil, 1
                if groupId and ids:get(i) == groupId then
                    table.insert(self.m_tDate, {group=groupId, step=stepId})
                else
                    table.insert(self.m_tDate, {group=ids:get(i), step=step:get(i)})
                end
            elseif step:get(i) == -2 then
                table.insert(self.m_tTaskDate, {group=ids:get(i), step=step:get(i)})
            elseif step:get(i) < -2 then
                table.insert(self.m_tWindDate, {group=ids:get(i), step=step:get(i)})
            end
        end
    end

    if TeachGroup1.SCHEDULE then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(TeachGroup1.SCHEDULE)
    end

    TeachGroup1:removeTeachAnim()
end

--@brief 新手战斗结束
function TeachGroup1:endFirstBattleTeach()
    WZLog("TeachGroup1:endFirstBattleTeach")
    TeachGroup1:setTeachFinish(25,-1)
    PassportSdkManager:postGameInfoHK("finshTeachFight_hk")
    --进入小岛界面
    local sceneIsland = SceneCity:createElement()
    if sceneIsland ~= nil then
        WBattleGlobal:getCurrent():destroy()
        Teach.OPEN_MODULE_MARK = true
        SDK_Talk:initSDK(tostring(GlobalGame.g_tPlayerInfo.nPlayerId),WndChat.recRecordCallback,WndChat)
        replaceScene(sceneIsland)
    end
end

--@brief 获取教学完成状态
function TeachGroup1:isTeachFinish(groupIndex)
    if not TeachGroup1:isTeach() then
        return true, -1
    end

    if self.m_tDate == nil then
        self.m_tDate = {}
    end

    local isTeachFinish, teachStep = false, 0
    for id, info in pairs (self.m_tDate) do
        if groupIndex == info.group then
            if info.step == -1 then
                isTeachFinish = true
                teachStep = -1
            else
                isTeachFinish = false
                teachStep = info.step or 0
            end
        end
    end

    WZLog("TeachGroup1:isTeachFinish one", groupIndex, tostring(isTeachFinish),teachStep, type(teachStep))
    return isTeachFinish, tonumber(teachStep)
end

--@brief    新手战斗教学结束
function TeachGroup1:battleTeach()
    WZLog("TeachGroup1:battleTeach()")
    --do return false end
    if TeachGroup1.ISBATTLE ~= true then
        --return false
    end

    local isEndTeach1, step1 = TeachGroup1:isTeachFinish(1)
    WZLog("TeachGroup1:battleTeach one", tostring(isEndTeach1))

    if isEndTeach1 ~= true and step1 > 0 then
        ProtocolProcessorSingleMap:regAll()
        TeachGroup1:setTeachFinish(1,-1)
        TeachGroup1:setTeachFinish(2,-1)
    end

end

--@brief 设置首冲弹框状态
--@param nOpen:是否打开，0:不打开，1：打开
function TeachGroup1:setFirstRechangePushFinish(groupIndex, isOpen)
    WZLog("WndTeachTalk:setFirstRechangePushFinish", tostring(groupIndex), tostring(isOpen))
    --更新状态全局数据
    local data = WZDataFile:getInstance():getUserData()
    if data ~= nil then
        data:setStringValue("FirstRechangePushData", "first_rechange_push"..groupIndex, isOpen == nil and tostring(CacheCenter:getPlayerInfo().id or 1) or 0)
        data:flush()
    end
end

--@brief 获取首冲弹框状态
function TeachGroup1:isFirstRechangePushFinish(groupIndex)

    local data = WZDataFile:getInstance():getUserData()
    if nil == data or CacheCenter:getPlayerInfo() == nil then
        return false
    end
    local isStoryFinish = data:getStringValue("FirstRechangePushData", "first_rechange_push"..groupIndex)
    --WZLog("TeachGroup1:isStoryFinish",isStoryFinish, type(isStoryFinish))
    if isStoryFinish == nil or isStoryFinish == "" or isStoryFinish == "0" or tonumber(isStoryFinish) ~= CacheCenter:getPlayerInfo().id then
        isStoryFinish = false
    elseif tonumber(isStoryFinish) == CacheCenter:getPlayerInfo().id then
        isStoryFinish = true
    end
    return isStoryFinish
end

--@brief 获取教学状态
function TeachGroup1:isInTeach()
    local isInTeach = false
    if WindowManager:getTeachShelterLayer() or WndTeachTalk.m_root then
        isInTeach = true
    end
    return isInTeach
end