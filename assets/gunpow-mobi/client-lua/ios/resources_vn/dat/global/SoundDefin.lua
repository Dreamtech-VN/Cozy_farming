--SoundDefine.lua
--@brief	音频文件路径定义
--@date		2013/1/26
--@author	叶威
SoundDefine =
{
        -- 背景音乐
        E_MUSIC_ISLAND = "islandbg.mp3", 	    --小岛背景音
        E_MUSIC_HALL = "hallbg.mp3",         	    --公会背景音
        E_MUSIC_COMMUNITY = "gonghui.mp3",         	    --大厅背景音
        E_MUSIC_BATTLE = "battlebg_4.mp3",     	    --战斗背景音乐 
		E_MUSIC_BATTLE_1 = "battlebg_1.mp3",
		E_MUSIC_BATTLE_2 = "battlebg_2.mp3",
		E_MUSIC_BATTLE_3 = "battlebg_3.mp3",
        E_MUSIC_BATTLE_5 = "battlebg_5.mp3",
		E_MUSIC_CREATE_ACTOR = "chuanjuese.mp3",
		E_MUSIC_JIA_ZAI = "jiazai.mp3",
        E_MUSIC_ISUPGRADE = "shengji.mp3",
        E_MUSIC_ADDSTAR = "jinjie.mp3",
        E_MUSIC_WED = "wed.mp3",                    --结婚礼堂背景音乐

        E_MUSIC_GUBAO = "gubao.mp3",                                          --阴森古堡类选关环境音
        E_MUSIC_HAIYANG = "haiyang.mp3",                                --海岸类选关环境音
        E_MUSIC_JIXIE = "jixie.mp3",                                   --机械类选关环境音
        E_MUSIC_MAXI = "maxi.mp3",                                      --马戏团选关环境音
        E_MUSIC_SENLIN = "senlin.mp3",                                 --森林类选关环境音
        E_MUSIC_SHAMO = "shamo.mp3",                                    --沙漠类选关环境音
        E_MUSIC_XUEDI = "xuedi.mp3",                                    --雪地类选关环境音
        E_MUSIC_MEISHI = "meishi.mp3",                                  --美食副本背景音
        E_MUSIC_COPY_PAITA = "shilianta.mp3",                                --试练塔背景音乐
        E_MUSIC_FAMILY = "family_bg.mp3",                       --家园系统背景音乐

        
        
        -- 音效
        E_S_CLICK_BTN = "zhuanniu.mp3",                   --按键点击
        E_S_CLICK_BTN2 = "fuanniu.mp3",                   --按键点击
        E_S_CLOSE_WIN = "quxiao.mp3",                    --取消
        E_S_BUILDING_BTN = "04.mp3",                --界面转换
        E_S_OPEN_WIN = "05.mp3",                    --弹窗
        E_S_PLAYER_ENTER_ROOM = "06.mp3",   	    --房间进入
        E_S_COST = "07.mp3",                        --购买提示,
        E_S_TIMER = "08.mp3",                       --倒计时
        E_S_ROUND = "10.mp3",                       --回合提示
        E_S_USE_ITEM = "11.mp3",                    --技能道具使用
        E_S_BATTLE_TIMER = "12.mp3",                --战斗最后5秒
        E_S_SHOOT = "13a.mp3",                      --武器发射（3个）,目前只用一个
        E_S_EXPLODE = "14c.mp3",                    --炮弹爆炸（7个）,目前只用一个
        E_S_BIGSKILL = "15.mp3",                    --大招效果
        E_S_FIRSTKILL = "16.mp3",                   --首杀提示
        E_S_KILLPLAYER = "17.mp3",                  --击杀玩家
        E_S_PLAYERDIE = "18.mp3",                   --玩家死亡
        E_S_GETBADGE = "19.mp3",                    --获得徽章
        E_S_PLAYERMOVE = "20.mp3",                  --人物移动
        E_S_BATTLE_WIN = "21.mp3",                  --战斗胜利
        E_S_BATTLE_LOSE = "22.mp3",                 --战斗失败
        E_S_BATTLE_WIN_BOY = "BOY_win.mp3",
        E_S_BATTLE_WIN_GIRL = "GIRL_win.mp3",
        E_S_LEVELUP = "23.mp3",                     --玩家升级
        E_S_SETTLEMENT = "24.mp3",                  --结算
        E_S_OPENCARD = "25.mp3",                    --翻牌
        E_S_FLY = "26.mp3",                         --飞行器
        E_S_FIGHTING = "zhandouli.mp3",                         --飞行器
		
        E_S_BIGSKILL_BEGIN			= "BIGSKILL_BEGIN.mp3",
        E_S_BIGSKILL_SHOOTING		= "BIGSKILL_SHOOTING.mp3",
		E_S_CREATE_NAN				= "chuanjuese_nan.mp3",
		E_S_CREATE_NV				= "chuanjuese_nv.mp3",
        E_S_GET_DESIGNATION             = "renwu.mp3",
        E_S_STRENGTHEN_SUCCESS          = "success.mp3",
        E_S_STRENGTHEN_SUCCESS2          = "success1.mp3",     --扫荡成功播放的音效
        E_S_STRENGTHEN_FAILED             = "defeated.mp3",

        E_S_COPPER_DROP = "cion_diaoluo",       --金币掉落

        E_S_BIGSKILL = "big_skill.mp3",                         --大招

        E_S_CHOOSE_SKILL = "xuanzhe_jineng.mp3",
        E_S_CHOOSE_ITEM = "xuanzhe_daoju.mp3",

        E_S_SHOOT_1 = "touzhi_fashe.mp3",
        E_S_SHOOT_2 = "sheji_fashe.mp3",
        E_S_SHOOT_PET = "pet_shoot.mp3",

        E_S_EXPLODE_1 = "touzhi_baopo.mp3",
        E_S_EXPLODE_2 = "sheji_baopo.mp3",

        E_S_SHOOT_1_2 = "touzhi_fashe2.mp3",
        E_S_SHOOT_2_2 = "sheji_fashe2.mp3",
        E_S_EXPLODE_1_2 = "touzhi_baopo2.mp3",
        E_S_EXPLODE_2_2 = "sheji_baopo2.mp3",

        E_S_MONSTER_DEAD = "monster_dead.mp3",

        E_S_PET_ZHADAN = "zhadan.mp3",
        E_S_PET_ZHADAN10 = "zhadan_teshu.mp3",
        E_S_LOVELOTTERY_SHAO = "aixin.mp3",  --爱心许愿抽奖音效
        E_S_SELL = "chushou.mp3",  --出售音效
        E_S_BATTLE_START = "zhandoukaishi.mp3",

        E_S_KILL_EFFECT = "kill.mp3",                --2杀,3杀提示
        E_S_LOTTER_DRAW_EFFECT = "zhuangbeichoujiang.mp3",  --装备抽奖音效

        E_S_BATTLE_VS = "vs.mp3",       --加载界面
        E_S_OVER_STAR = "zaxing.mp3",   --结算星星
        E_S_TABOO_DICE = "touzi.mp3",   --骰子
        E_S_TABOO_MOVE = "touyidong.mp3",       --移动
        E_S_TABOO_RESET = "tudifandong.mp3",    --翻牌

        E_S_MONSTER_SKILL1 = "shalujiguang.mp3",       --怪物技能
        E_S_MONSTER_SKILL2 = "xiaochoulihe.mp3",       --怪物技能
        E_S_MONSTER_SKILL3 = "xiaochouyinyue.mp3",       --怪物技能
        E_S_MONSTER_SKILL4 = "xiaochoucai.mp3",       --怪物技能
        E_S_MONSTER_SKILL5 = "qitishifang.mp3",       --怪物技能
        E_S_MONSTER_SKILL6 = "feilun.mp3",       --怪物技能
        E_S_MONSTER_SKILL7 = "bianshen.mp3",       --怪物技能
        E_S_MONSTER_SKILL8 = "rongyangongji.mp3",       --怪物技能
        E_S_MONSTER_SKILL9 = "dianju.mp3",       --怪物技能
        E_S_MONSTER_SKILL10 = "jifeixing.mp3",       --怪物技能
        E_S_MONSTER_SKILL11 = "jiyidong.mp3",       --怪物技能
        E_S_MONSTER_SKILL12 = "kelinqifei.mp3",       --怪物技能
        E_S_MONSTER_SKILL13 = "zhuajijineng.mp3",       --怪物技能
        E_S_MONSTER_SKILL14 = "mosichuansong.mp3",       --怪物技能
        E_S_MONSTER_SKILL15 = "nisifuhuo.mp3",       --怪物技能
        E_S_MONSTER_SKILL16 = "zhuajijineng.mp3",       --怪物技能

        E_S_KILL_FUWENJIGUAN = "fuwenjiguan.mp3",        --符文机关
        E_S_KILL_GOUMAICHENGGONG = "goumaichenggong.mp3",    --购买成功
        E_S_KILL_LAOHU = "laohu.mp3",          	--老虎机
        E_S_KILL_TOUZHI = "touzhi.mp3",          	--许愿池投掷
        E_S_KILL_XIANGQIAN = "xiangqian.mp3",          --镶嵌

        E_S_KILL_JIANDING = "jianding.mp3",          		--鉴定
       
        E_S_KILL_RANSHAO = "ranshao.mp3",          			--选择燃烧关卡
       
        E_S_KILL_SHIQU = "shiqu.mp3",          				--祈福拾取
        E_S_KILL_WABAO = "wabao.mp3",          				--挖宝

		--娄艺潇语音
		E_S_LOURA1 = "Loura1.mp3",
		E_S_LOURA2 = "Loura2.mp3",
		E_S_LOURA3 = "Loura3.mp3",
}

--@brief 预载音频列表，需要预载入的音频放在这里
SoundDefine.preloadList = {
        E_S_CLICK_BTN = "zhuanniu.mp3",                   --按键点击
        E_S_CLICK_BTN2 = "fuanniu.mp3",                   --按键点击
        E_S_CLOSE_WIN = "quxiao.mp3",                    --取消
        E_S_BUILDING_BTN = "04.mp3",                --界面转换
        E_S_OPEN_WIN = "05.mp3",                    --弹窗
        E_S_PLAYER_ENTER_ROOM = "06.mp3",   	    --房间进入
        E_S_COST = "07.mp3",                        --购买提示,
        E_S_TIMER = "08.mp3",                       --倒计时
        E_S_ROUND = "10.mp3",                       --回合提示
        E_S_USE_ITEM = "11.mp3",                    --技能道具使用
        E_S_BATTLE_TIMER = "12.mp3",                --战斗最后5秒
        E_S_SHOOT = "13a.mp3",                      --武器发射（3个）,目前只用一个
        E_S_EXPLODE = "14c.mp3",                    --炮弹爆炸（7个）,目前只用一个
        E_S_BIGSKILL = "15.mp3",                    --大招效果
        E_S_FIRSTKILL = "16.mp3",                   --首杀提示
        E_S_KILLPLAYER = "17.mp3",                  --击杀玩家
        E_S_PLAYERDIE = "18.mp3",                   --玩家死亡
        E_S_GETBADGE = "19.mp3",                    --获得徽章
        E_S_PLAYERMOVE = "20.mp3",                  --人物移动
        E_S_BATTLE_WIN = "21.mp3",                  --战斗胜利
        E_S_BATTLE_LOSE = "22.mp3",                 --战斗失败
        E_S_LEVELUP = "23.mp3",                     --玩家升级
        E_S_SETTLEMENT = "24.mp3",                  --结算
        E_S_OPENCARD = "25.mp3",                    --翻牌
        E_S_FLY = "26.mp3",                         --飞行器
        E_S_BOY_USE_SKILL1 			= "BOY_USE_SKILL1.mp3",
        E_S_BOY_USE_SKILL2                       = "BOY_USE_SKILL2.mp3",
        E_S_BOY_USE_SKILL3                       = "BOY_USE_SKILL3.mp3",
        E_S_BOY_USE_SKILL4                       = "BOY_USE_SKILL4.mp3",
        E_S_BOY_USE_SKILL5                       = "BOY_USE_SKILL5.mp3",
        E_S_BOY_USE_SKILL6                       = "BOY_USE_SKILL6.mp3",
        E_S_GIRL_USE_SKILL1			= "GIRL_USE_SKILL1.mp3",
        E_S_GIRL_USE_SKILL2                      = "GIRL_USE_SKILL2.mp3",
        E_S_GIRL_USE_SKILL3                      = "GIRL_USE_SKILL3.mp3",
        E_S_GIRL_USE_SKILL4                      = "GIRL_USE_SKILL4.mp3",
        E_S_GIRL_USE_SKILL5                      = "GIRL_USE_SKILL5.mp3",
        E_S_GIRL_USE_SKILL6                      = "GIRL_USE_SKILL6.mp3",
        E_S_BOY_USE_BIGSKILL1 		= "BOY_USE_BIGSKILL1.mp3",
        E_S_BOY_USE_BIGSKILL2            = "BOY_USE_BIGSKILL2.mp3",
        E_S_GIRL_USE_BIGSKILL1 		= "GIRL_USE_BIGSKILL1.mp3",
        E_S_GIRL_USE_BIGSKILL2           = "GIRL_USE_BIGSKILL2.mp3",
        E_S_BOY_BIGSKILL1 			= "BOY_BIGSKILL1.mp3",
        E_S_BOY_BIGSKILL2                        = "BOY_BIGSKILL2.mp3",
        E_S_GIRL_BIGSKILL1 			= "GIRL_BIGSKILL1.mp3",
        E_S_GIRL_BIGSKILL2                      = "GIRL_BIGSKILL2.mp3",
		                               
        E_S_BOY_HURT1 				= "BOY_HURT1.mp3",
        E_S_BOY_HURT2                            = "BOY_HURT2.mp3",
        E_S_BOY_HURT3                            = "BOY_HURT3.mp3",
        E_S_BOY_HURT4                            = "BOY_HURT4.mp3",
        E_S_BOY_HURT5                            = "BOY_HURT5.mp3",
        E_S_BOY_HURT6                            = "BOY_HURT6.mp3",
        E_S_GIRL_HURT1 				= "GIRL_HURT1.mp3",
        E_S_GIRL_HURT2                           = "GIRL_HURT2.mp3",
        E_S_GIRL_HURT3                           = "GIRL_HURT3.mp3",
        E_S_GIRL_HURT4                           = "GIRL_HURT4.mp3",
        E_S_GIRL_HURT5                           = "GIRL_HURT5.mp3",
        E_S_GIRL_HURT6                           = "GIRL_HURT6.mp3",
        E_S_BOY_DEAD1 				= "BOY_DEAD1.mp3",
        E_S_BOY_DEAD2                            = "BOY_DEAD2.mp3",
        E_S_GIRL_DEAD1				= "GIRL_DEAD1.mp3",
        E_S_GIRL_DEAD2                           = "GIRL_DEAD2.mp3",
		
		
        E_S_BIGSKILL_BEGIN			= "BIGSKILL_BEGIN.mp3",
        E_S_BIGSKILL_SHOOTING		= "BIGSKILL_SHOOTING.mp3",
		E_S_CREATE_NAN				= "chuanjuese_nan.mp3",
		E_S_CREATE_NV				= "chuanjuese_nv.mp3",
        E_S_GET_DESIGNATION             = "renwu.mp3",
        E_S_STRENGTHEN_SUCCESS          = "success.mp3",
        E_S_STRENGTHEN_SUCCESS2          = "success1.mp3",     --扫荡成功播放的音效
        E_S_STRENGTHEN_FAILED             = "defeated.mp3",

        E_S_NPC_TALK_01 = "nv_npc1.mp3",                         --NPC
        E_S_NPC_TALK_02 = "nv_npc2.mp3",                         --NPC
        E_S_NPC_TALK_03 = "nv_npc3.mp3",                         --NPC
        E_S_NPC_TALK_04 = "nv_npc4.mp3",                         --NPC
        E_S_NPC_TALK_05 = "nv_npc5.mp3",                         --NPC
        E_S_NPC_TALK_06 = "nan_npc1.mp3",                         --NPC
        E_S_NPC_TALK_07 = "nan_npc2.mp3",                         --NPC
        E_S_NPC_TALK_08 = "nan_npc3.mp3",                         --NPC

        E_S_COPPER_DROP = "cion_diaoluo",       --金币掉落

        E_S_BIGSKILL = "big_skill.mp3",                         --大招

        E_S_CHOOSE_SKILL = "xuanzhe_jineng.mp3",
        E_S_CHOOSE_ITEM = "xuanzhe_daoju.mp3",

        E_S_SHOOT_1 = "touzhi_fashe.mp3",
        E_S_SHOOT_2 = "sheji_fashe.mp3",
        E_S_SHOOT_PET = "pet_shoot.mp3",

        E_S_EXPLODE_1 = "touzhi_baopo.mp3",
        E_S_EXPLODE_2 = "sheji_baopo.mp3",
        
        E_S_SHOOT_1_2 = "touzhi_fashe2.mp3",
        E_S_SHOOT_2_2 = "sheji_fashe2.mp3",
        E_S_EXPLODE_1_2 = "touzhi_baopo2.mp3",
        E_S_EXPLODE_2_2 = "sheji_baopo2.mp3",

        E_S_MONSTER_DEAD = "monster_dead.mp3",

        E_S_GIRL_WUSHA1= "nv_wusha1.mp3",
        E_S_GIRL_WUSHA2= "nv_wusha2.mp3",
        E_S_BOY_WUSHA1 = "nan_wusha1.mp3",
        E_S_BOY_WUSHA2 = "nan_wusha2.mp3",

        E_S_PET_ZHADAN = "zhadan.mp3",
        E_S_PET_ZHADAN10 = "zhadan_teshu.mp3",
        E_S_LOVELOTTERY_SHAO = "aixin.mp3",

        E_S_KILL_EFFECT = "kill.mp3",                --2杀,3杀提示
        E_S_LOTTER_DRAW_EFFECT = "zhuangbeichoujiang.mp3",

        E_S_BATTLE_VS = "vs.mp3",       --加载界面
        E_S_OVER_STAR = "zaxing.mp3",   --结算星星
        E_S_TABOO_DICE = "touzi.mp3",   --骰子
        E_S_TABOO_MOVE = "touyidong.mp3",       --移动
        E_S_TABOO_RESET = "tudifandong.mp3",    --翻牌

        E_S_MONSTER_SKILL1 = "shalujiguang.mp3",       --怪物技能
        E_S_MONSTER_SKILL2 = "xiaochoulihe.mp3",       --怪物技能
        E_S_MONSTER_SKILL3 = "xiaochouyinyue.mp3",       --怪物技能
        E_S_MONSTER_SKILL4 = "xiaochoucai.mp3",       --怪物技能
        E_S_MONSTER_SKILL5 = "qitishifang.mp3",       --怪物技能
        E_S_MONSTER_SKILL6 = "feilun.mp3",       --怪物技能
        E_S_MONSTER_SKILL7 = "bianshen.mp3",       --怪物技能
        E_S_MONSTER_SKILL8 = "rongyangongji.mp3",       --怪物技能
        E_S_MONSTER_SKILL9 = "dianju.mp3",       --怪物技能
        E_S_MONSTER_SKILL10 = "jifeixing.mp3",       --怪物技能
        E_S_MONSTER_SKILL11 = "jiyidong.mp3",       --怪物技能
        E_S_MONSTER_SKILL12 = "kelinqifei.mp3",       --怪物技能
        E_S_MONSTER_SKILL13 = "zhuajijineng.mp3",       --怪物技能
        E_S_MONSTER_SKILL14 = "mosichuansong.mp3",       --怪物技能
        E_S_MONSTER_SKILL15 = "nisifuhuo.mp3",       --怪物技能
        E_S_MONSTER_SKILL16 = "zhuajijineng.mp3",       --怪物技能

        E_S_KILL_FUWENJIGUAN = "fuwenjiguan.mp3",        	--符文机关
        E_S_KILL_GOUMAICHENGGONG = "goumaichenggong.mp3",   --购买成功
        E_S_KILL_LAOHU = "laohu.mp3",          				--老虎机
        E_S_KILL_TOUZHI = "touzhi.mp3",          			--许愿池投掷
        E_S_KILL_XIANGQIAN = "xiangqian.mp3",          		--镶嵌

       
        E_S_KILL_JIANDING = "jianding.mp3",          		--鉴定

        E_S_KILL_RANSHAO = "ranshao.mp3",          			--选择燃烧关卡

        E_S_KILL_SHIQU = "shiqu.mp3",          				--祈福拾取
        E_S_KILL_WABAO = "wabao.mp3",          				--挖宝
		

		E_S_SELL = "chushou.mp3",  --出售音效
		E_S_FIGHTING = "zhandouli.mp3",                         --飞行器

		E_S_BATTLE_WIN_BOY = "BOY_win.mp3",
		E_S_BATTLE_WIN_GIRL = "GIRL_win.mp3",
		E_S_BATTLE_START = "zhandoukaishi.mp3",
}

