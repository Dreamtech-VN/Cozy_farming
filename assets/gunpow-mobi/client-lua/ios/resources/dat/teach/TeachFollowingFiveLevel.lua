--TeachFollowingFiveLevel.lua
--@brief	5级以下新手教程
--@date		2014/02/17
--@author	林庆凯
--@note		5级以下新手教程（强制引导）

SHIELDING_LAYER = nil    		 	--遮挡层
POP_DIALOG_TEACH = nil   		 	--弹出对话框
LIGHT_IMAGE_ELEMENT = nil   	 	--发光图片
NEWER_FINISH_ANI = nil      	 	--新手教学完成对象
TeachFollowingFiveLevel_START_FLAG = false 
g_nBELOW_FIVE_LEVEL_TEACH_Steps = 0  			--新手教学步骤
g_nTeachFollowingFiveLevel_ids = 0   			--新手教学编号 
g_nTeachFollowingFiveLevel_interfaceId  = 0     --新手教学界面ID
g_nUpdateBoosRoomTime = 0                       --更新房间次数
g_bTeachFollowingFiveLevelFinishFlag = false    --新手完成步骤标记 

TeachFollowingFiveLevelIdDefine = {
	TASK_ISEND = 99,      		    --小岛进入任务按钮 
	REWARD_TASK = 101,     		    --任务领取奖励按钮
	CLOSE_TASK = 102,      		    --任务关闭按钮
	GAMEHALL_ISEND = 103,  		    --小岛游戏大厅按钮
	STARTGAME_TASK = 104,  		    --开始游戏按钮
	SPORT_MODE_GAME_HALL = 105,     --竞技模式按钮
	SURE_MODE = 106,          	    --选择模式确定按钮
	SURE_CREATE_ROOM = 107, 		--创建房间确定按钮
	SURE_HALL = 108,        		--游戏场景开始按钮
	SKILL_TOOL_HALL  = 109, 		--点击技能道具按钮
	CLICK_SKILL_HALL = 110,		    --点击技能
	CLOSE_SKILL_TOOLS = 111,		--技能道具关闭按钮
	READY_GAME_HALL = 112,    	    --准备游戏按钮
	LOOK_FINISH_TASK = 113,   	    --查看完成的任务
	FINISH_REWARD_TASK = 114, 	    --任务完成后领取奖励按钮
	CLOSE_FINIS_TASK = 115,   	    --任务完成后点击关闭按钮
	BAG_ISEND =  116,         	    --小岛背包按钮
	CLICK_WEAPON = 117,       	    --背包物品列表
	CLOSE_BAG = 118,          	    --关闭背包按钮
	CLOSE_BAG_TASK_ISEND = 119,     --小岛任务按钮
	BAG_REWARD_BTN_TASK = 120,	    --邻取换装奖励按钮
	START_BATTLE = 121,	            --一鸣惊人的开始战斗按钮
	BAG_START_GAME = 122,           --准备游戏按钮
	BAG_TASK_ISEND = 123,	        --小岛任务按钮
	HALL_REWARD_BTN_TASK = 124,	    --邻取道具使用奖励按钮
	HALL_CLOSE_BTN_TASK = 125,	    --关闭任务按钮
	LEAD_FINISH = 126,              --强制引导结束
	
	BATTLEONE = 150,                --第一次战斗ID
	BATTLETWO = 151,                --第二次战斗ID
	
	AGAIN_TASK =  160,            --已领取换装任务断线后保存的小岛任务
	
	    
}

TeachFollowingFiveLevel = {}

----------------------------------------Begin-----------------------------------------------------


--@brief	跳过1-4级新手教学
function TeachFollowingFiveLevel:skipUiTeachStart()
	WZLog("TeachFollowingFiveLevel:skipUiTeachStart()")
	GlobalGame.g_bIfInTeaching = false 
	WindowManager:removeTeachShelterLayer()
	g_nBELOW_FIVE_LEVEL_TEACH_Steps  = -1
	--保存新手教学完成步骤
	--ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids,-1)
end 

--@brief	是否进行黑龙教学
function TeachFollowingFiveLevel:blackDragonTeachStart()
	WZLog(debug.traceback())
    --[[
    Teach.DATA.saveStep[1].ids = 1
    Teach.DATA.saveStep[1].step = 0
    CacheCenter:getPlayerInfo().level = 1
    --]]
    --WZLog("TeachFollowingFiveLevel:blackDragonTeachStart", CacheCenter:getPlayerInfo().level, CacheCenter:getPlayerInfo().zsLevel, Teach.DATA.saveStep[1].ids, Teach.DATA.saveStep[1].step)
	if CacheCenter:getPlayerInfo() ~= nil and CacheCenter:getPlayerInfo().level <= 1 and CacheCenter:getPlayerInfo().zsLevel <= 0 and Teach.DATA ~= nil and Teach.DATA.saveStep ~= nil and Teach.DATA.saveStep[1].ids == 1 and Teach.DATA.saveStep[1].step < 5 then
		return true 					
	end 
	return false
end

--@brief	服务器取得完成任务列表数据
function TeachFollowingFiveLevel:getServerData(ids, level, interfaceId, step)
	WZLog("TeachFollowingFiveLevel:getServerData(ids, level, interfaceId, step)")
	--小岛界面发送完成新手教学协议
		if  interfaceId == -1 and step ~= -1 then
			WZLog("interfaceId:get(i) = ",interfaceId)
			WZLog(" step:get(i) = ", step )
			WZLog("************************")
			g_nBELOW_FIVE_LEVEL_TEACH_Steps = step--教学步骤
			g_nTeachFollowingFiveLevel_ids = ids  --教学ID
			g_nTeachFollowingFiveLevel_interfaceId	= interfaceId --界面Id
			WZLog("g_nTeachFollowingFiveLevel_interfaceId = ",g_nTeachFollowingFiveLevel_ids)
			GlobalGame.g_bIfInTeaching  = true 
			
			if step < 99 then
				--黑龙教学
                LoadBattleConfig()
                CheckLuaLoad(LUAFILES_BLOCK_NORMALBATTLE)

                if TeachBattle.TEACH_TYPE == 1 then
                    replaceScene(SceneTeachBattleLoading:createElement())
                elseif TeachBattle.TEACH_TYPE == 2 then
                    TeachBattle:startTeach(Teach.DATA.saveStep[1].step , nil)
                    ProtocolProcessorSceneTeachBattleLoading:regAll()		--注册协议
                    GlobalGame:setIfInBattle(true)
                    WZLog("TeachFollowingFiveLevel:getServerData three", GlobalGame.g_nCurrentUIChannelId)
                    GlobalGame.g_nCurrentUIChannelId = Chat_Channel_Fighting
                    self:loadMap()
                    self:initBoss()
                    ProtocolProcessorSceneTeachBattleLoading:send_PLAYER_GetPlayerInfo(0)
                end
			end
		
		end
end 

--@brief	角色信息获取成功
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function TeachFollowingFiveLevel:receiveGetPlayerInfoOk(playerId, playerName, tickets, maxLevel, playerHp, playerDefend, playerPhysical, playerDefense, playerGold, playerHonor, playerSex, level, attack, exp, guildName, medalNum, critRate, explodeRadius, proficiency, suit_head, suit_face, suit_body, suit_weapon, weapon_type, upgradeexp, vipLevel, suit_wing, player_title, weaponLevel, wbUserId, zsleve, injuryFree, wreckDefense, reduceCrit, reduceBury, force, armor, agility, physique, luck, fighting, vipMark, vipLastDay)
	WZLog("TeachFollowingFiveLevel:receiveGetPlayerInfoOk")
	
	self.m_tPlayerInfo = {playerId=playerId, playerName=playerName, tickets=tickets, maxLevel=maxLevel, playerHp=playerHp, playerDefend=playerDefend, playerPhysical=playerPhysical, playerDefense=playerDefense, playerGold=playerGold, playerHonor=playerHonor, playerSex=playerSex, level=level, attack=attack, exp=exp, guildName=guildName, medalNum=medalNum, critRate=critRate, explodeRadius=explodeRadius, proficiency=proficiency, suit_head=suit_head, suit_face=suit_face, suit_body=suit_body, suit_weapon=suit_weapon, weapon_type=weapon_type, upgradeexp=upgradeexp, vipLevel=vipLevel, suit_wing=suit_wing, player_title=player_title, weaponLevel=weaponLevel, wbUserId=wbUserId, zsleve=zsleve, injuryFree=injuryFree, wreckDefense=wreckDefense, reduceCrit=reduceCrit, reduceBury=reduceBury, force=force, armor=armor, agility=agility, physique=physique, luck=luck, fighting=fighting, vipMark=vipMark, vipLastDay=vipLastDay}

    self:initPlayer()
end

--@brief	初始化玩家
--@return	#1:true:完成,false:未完成
function TeachFollowingFiveLevel:initPlayer()
	WZLog("TeachFollowingFiveLevel:initPlayer", self.m_tPlayerInfo.suit_head, self.m_tPlayerInfo.suit_face, self.m_tPlayerInfo.suit_body, self.m_tPlayerInfo.suit_weapon, self.m_tPlayerInfo.suit_wing)
    
    if TeachBattle.TEACH_TYPE == 2 then
        self.m_tPlayerInfo.suit_head = "bhead = \"bhead8\""
        self.m_tPlayerInfo.suit_face = "bface = \"bface8\""
        self.m_tPlayerInfo.suit_body = "bbody = \"bbody8\""
        self.m_tPlayerInfo.suit_weapon = "weapon = \"weapon15a\""
    end

    local tEquipList = {}
    StringIntsertToTable(tEquipList,self.m_tPlayerInfo.suit_head)
    StringIntsertToTable(tEquipList,self.m_tPlayerInfo.suit_face)
    StringIntsertToTable(tEquipList,self.m_tPlayerInfo.suit_body)
    StringIntsertToTable(tEquipList,self.m_tPlayerInfo.suit_weapon)
    StringIntsertToTable(tEquipList,self.m_tPlayerInfo.suit_wing)

    self.m_tPlayer = TeachHero:buildHero(tEquipList , self.m_tPlayerInfo.playerSex , self.m_tPlayerInfo.weapon_type )
    TeachBattle:setMyHero(self.m_tPlayer)
    TeachBattle:initHero(self.m_tPlayerInfo.playerName)

    self:endLoading()
end


--@brief	初始化怪物
--@return	#1:true:完成,false:未完成
function TeachFollowingFiveLevel:initBoss()
	WZLog("TeachFollowingFiveLevel:initBoss")

	--boss表
	self.m_tBoss = TeachMonster:buildGuai() --TeachBoss:buildGuai()
	WZLog("TeachFollowingFiveLevel:_initBoss build guai",self.m_tBoss)
	TeachBattle:setBoss(self.m_tBoss)
	TeachBattle:initBoss(LocalStrings.TEACH_BOSS_NAME)
	WZLog("TeachFollowingFiveLevel:_initBoss init guai",self.m_tBoss)
end

--@brief	加载地图
function TeachFollowingFiveLevel:loadMap()
	WZLog("TeachFollowingFiveLevel:loadMap")
	BattleMapManager:loadMap("08")
end

--@brief	结束loading
--@return	#1:true:完成,false:未完成
function TeachFollowingFiveLevel:endLoading()
	WZLog("TeachFollowingFiveLevel:endLoading")
	local sceneTeachBattle = SceneTeachBattle:createElement()
	SceneTeachBattle:init()

    ProtocolProcessorSceneTeachBattleLoading:unregAll()		--反注册协议
	replaceScene(sceneTeachBattle)
end

--@brief	黑龙教学完成后改变步骤
function TeachFollowingFiveLevel:afterBlackDragon(nStep)
    GlobalGame.g_nCurrentUIChannelId = -1
	--切换到小岛界面
	local sceneIsland = SceneIsland:createElement()
	if sceneIsland ~= nil then 		
        Teach.OPEN_MODULE_MARK = true

        --初始化语音聊天
        VoiceChat:setOpenVoice(soundRoomOpen)
        VoiceChat:setChatWithAll(soundHostile)
        VoiceChat:init()

        local tBtnsInfo = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_BUILDING)
        SceneIsland:setBtnsInfo(tBtnsInfo)
        
        --断线重连
		    if NET_FLAG_4 == IPDConnector.g_nNetConnectFlag or NET_FLAG_2 == IPDConnector.g_nNetConnectFlag or NET_FLAG_3 == IPDConnector.g_nNetConnectFlag or NET_FLAG_7 == IPDConnector.g_nNetConnectFlag then
		    	if GlobalGame.g_nCurrentUIChannelId ~= Chat_Channel_Island then
			    	local bNeedToUpLevel = false
			    	for _,v in pairs(T_G_UI_NEEDTOUPLEVEL) do
			    		if v == GlobalGame.g_nCurrentUIChannelId then
		    				GlobalGame.g_nUIChannelIdBeforeReconnect = GlobalGame.g_nCurrentUIChannelId
		    				bNeedToUpLevel = true
		    				break
			    		end
			    	end

			    	--断线重连后，特定界面跳转到上一级页面
			    	if bNeedToUpLevel then
						TurnToUpLevelAfterReconnect()
                    else
                        replaceScene(sceneIsland)
                        WZLog("replaceScene sceneIsland ")
			    	end

			    	IPDConnector.g_nNetConnectFlag = NET_FLAG_2
                    WZLog("IPDConnector.g_nNetConnectFlag",GlobalGame.g_nCurrentUIChannelId)
			    	return
		    	end
		    end

		replaceScene(sceneIsland)
	end 
end 


--@brief	新手教学添加遮罩层(切换场景后加入)
function TeachFollowingFiveLevel:NewerTeachAddLayerMask()
	WZLog("TeachFollowingFiveLevel:NewerTeachAddLayerMask()")
	WZLog("g_nBELOW_FIVE_LEVEL_TEACH_Steps $$$ = ",g_nBELOW_FIVE_LEVEL_TEACH_Steps)
	if GlobalGame.g_bIfInTeaching  == false then 
		return 
	end 
	--下一步是进入小岛任务
	if GlobalGame.g_bIfInTeaching == true and g_nBELOW_FIVE_LEVEL_TEACH_Steps == 
								TeachFollowingFiveLevelIdDefine.TASK_ISEND then
		SHIELDING_LAYER = WindowManager:addTeachShelterLayer(12001)
	--下一步是小岛点击进入游戏大厅
	elseif GlobalGame.g_bIfInTeaching == true and g_nBELOW_FIVE_LEVEL_TEACH_Steps == 
								TeachFollowingFiveLevelIdDefine.GAMEHALL_ISEND then
		SHIELDING_LAYER = WindowManager:addTeachShelterLayer(12001)
		
	--下一步是查看第一场战斗未完成任务
	elseif GlobalGame.g_bIfInTeaching == true and g_nBELOW_FIVE_LEVEL_TEACH_Steps == 
								TeachFollowingFiveLevelIdDefine.LOOK_FINISH_TASK then
		SHIELDING_LAYER = WindowManager:addTeachShelterLayer(12001)
	--下一步是小岛背包
	elseif GlobalGame.g_bIfInTeaching == true and g_nBELOW_FIVE_LEVEL_TEACH_Steps == 
							TeachFollowingFiveLevelIdDefine.BAG_ISEND then
		SHIELDING_LAYER = WindowManager:addTeachShelterLayer(12001)
	--下一步是领取换装背包
	elseif GlobalGame.g_bIfInTeaching == true and g_nBELOW_FIVE_LEVEL_TEACH_Steps == 
							TeachFollowingFiveLevelIdDefine.CLOSE_BAG_TASK_ISEND then
		SHIELDING_LAYER = WindowManager:addTeachShelterLayer(12001)
	--[[
	--下一步是小岛打完第一场战斗掉线后的小岛任务
	elseif GlobalGame.g_bIfInTeaching == true and g_nBELOW_FIVE_LEVEL_TEACH_Steps == 
							TeachFollowingFiveLevelIdDefine.AGAIN_TASK then
		SHIELDING_LAYER = WindowManager:addTeachShelterLayer(12001)
	--]]
	--下一步是打完第二场战斗
	elseif GlobalGame.g_bIfInTeaching == true and g_nBELOW_FIVE_LEVEL_TEACH_Steps == 
							TeachFollowingFiveLevelIdDefine.BAG_TASK_ISEND then
		SHIELDING_LAYER = WindowManager:addTeachShelterLayer(12001)
	--下一步是开始游戏时
	elseif GlobalGame.g_bIfInTeaching == true and g_nBELOW_FIVE_LEVEL_TEACH_Steps == 
								TeachFollowingFiveLevelIdDefine.STARTGAME_TASK then 
		SHIELDING_LAYER = WindowManager:addTeachShelterLayer(12001)
	--下一步是点击技能道具时
	elseif GlobalGame.g_bIfInTeaching == true and g_nBELOW_FIVE_LEVEL_TEACH_Steps == 							
								TeachFollowingFiveLevelIdDefine.SKILL_TOOL_HALL then
		SHIELDING_LAYER = WindowManager:addTeachShelterLayer(12001)
	--下一步是第二场战斗准备游戏按钮
	elseif GlobalGame.g_bIfInTeaching == true and g_nBELOW_FIVE_LEVEL_TEACH_Steps == 
		TeachFollowingFiveLevelIdDefine.BATTLETWO then
		SHIELDING_LAYER = WindowManager:addTeachShelterLayer(12001)
	--[[
	--新手教学结束
	elseif GlobalGame.g_bIfInTeaching == true and g_nBELOW_FIVE_LEVEL_TEACH_Steps == 
		TeachFollowingFiveLevelIdDefine.LEAD_FINISH then
		SHIELDING_LAYER = WindowManager:addTeachShelterLayer(12001)
	end 
	--]]
	end 
end 

--------------------------------1 - 4 级新手相关 --------------------------------------

--@brief	1-4级新手教学（小岛UI开始）
function TeachFollowingFiveLevel:uiTeachStart()
	WZLog("TeachFollowingFiveLevel:uiTeachStart()")
	WZLog("g_nBELOW_FIVE_LEVEL_TEACH_Steps = ",g_nBELOW_FIVE_LEVEL_TEACH_Steps)
	WZLog("g_nTeachFollowingFiveLevel_interfaceId = ",g_nTeachFollowingFiveLevel_interfaceId)
	if 	GlobalGame.g_bIfInTeaching  == false then 
		return 
	end 
	
	if g_nBELOW_FIVE_LEVEL_TEACH_Steps  > 98 
		and g_nTeachFollowingFiveLevel_interfaceId == -1 then 
		--[[
		--加载手指动画
		local armatureManager = CCArmatureDataManager:sharedArmatureDataManager()
		if armatureManager:getTextureData("teach002") == nil then
			armatureManager:addArmatureFileInfo("teach.png", "teach.plist", "teach.xml")
		end
		--]]
		self:isOrNotStartNewerTeach()			
	end 
end 



--@brief   是否调用新手教程
function TeachFollowingFiveLevel:isOrNotStartNewerTeach()
	WZLog("TeachFollowingFiveLevel:isOrNotStartNewerTeach()")
	WZLog("---------------g_nBELOW_FIVE_LEVEL_TEACH_Steps =   ------------",
			g_nBELOW_FIVE_LEVEL_TEACH_Steps)
	if 	GlobalGame.g_bIfInTeaching  == false then 
		return 
	end 
	--小于5级
	if g_nBELOW_FIVE_LEVEL_TEACH_Steps  ~= nil then
		if GlobalGame.g_tPlayerInfo.nLevel < 5 and  g_nBELOW_FIVE_LEVEL_TEACH_Steps  ~= -1  then 
			--WZUIButton:setGlobalInterval(0)
			local teachFollowingFiveLevel = TeachFollowingFiveLevel:new()
			if teachFollowingFiveLevel ~= nil then 
				teachFollowingFiveLevel:startNewerTeach(g_nBELOW_FIVE_LEVEL_TEACH_Steps)
			end 
		end 
	end 
end 


--@brief	升到4级把教程设为引导完成
--@param   nLevel  等级
function TeachFollowingFiveLevel:isForceTeachFinish(nLevel)
	WZLog("TeachFollowingFiveLevel:isForceTeachFinish(nLevel) ")
	if nLevel == 4 and  g_bTeachFollowingFiveLevelFinishFlag ~= true then 
		--保存新手教学完成步骤
		ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids,
										TeachFollowingFiveLevelIdDefine.LEAD_FINISH)
	end 
	if nLevel == 4 and SceneIsland.m_root == nil then 
		WZLog("SceneIsland.m_root == nil")
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.LEAD_FINISH
		--保存新手教学完成步骤
		ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids,
												TeachFollowingFiveLevelIdDefine.LEAD_FINISH)
	end 
end 



--@brief  是否使用怒槽
--@param  nFlag  是否使用标志
function TeachFollowingFiveLevel:setWhetherUseFuly(nFlag)
	if 	GlobalGame.g_bIfInTeaching  == false then 
		return 
	end
	TeachFollowingFiveLevel_HAS_USE_FULY = nFlag 
	--使用过怒槽
	if TeachFollowingFiveLevel_HAS_USE_FULY ~= nil and TeachFollowingFiveLevel_HAS_USE_FULY == true then 
		if   GlobalGame.g_tPlayerInfo.nLevel < 4 and  g_nBELOW_FIVE_LEVEL_TEACH_Steps   ==
				TeachFollowingFiveLevelIdDefine.BATTLETWO then 
			--保存新手教学完成步骤
			ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids,TeachFollowingFiveLevelIdDefine.BAG_TASK_ISEND)
		end 
	end 
end 



--@brief	判断是否调用新手教程函数
--@param   教程ID
function TeachFollowingFiveLevel:taskReturn()
	WZLog("TeachFollowingFiveLevel:taskReturn()")
	--小于5级
	if g_nBELOW_FIVE_LEVEL_TEACH_Steps  ~= nil then
		if GlobalGame.g_tPlayerInfo.nLevel < 5 and  g_nBELOW_FIVE_LEVEL_TEACH_Steps  ~= -1  then 
			return 
		end 
	end 
	
end 



----------------------------------------其它界面调用新手教程-----------------------------------------------------


--@brief	任务界面判断是否调用新手教程
function TeachFollowingFiveLevel:supplyForTaskTeach( )
	WZLog("TeachFollowingFiveLevel:supplyForTaskTeach( )")
	WZLog("g_nBELOW_FIVE_LEVEL_TEACH_Steps  = ",g_nBELOW_FIVE_LEVEL_TEACH_Steps )
	if 	GlobalGame.g_bIfInTeaching  == false then 
		return 
	end 
	--手指拖动
	if g_nBELOW_FIVE_LEVEL_TEACH_Steps  ==  TeachFollowingFiveLevelIdDefine.REWARD_TASK then 
		WZLog("TeachFollowingFiveLevel:supplyForTaskTeach( ) ------2-------- ")
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.CLOSE_TASK
		TeachFollowingFiveLevel:newerTeachStepTwo()
	--完成第一场战斗后小岛任务
	elseif g_nBELOW_FIVE_LEVEL_TEACH_Steps  ==  TeachFollowingFiveLevelIdDefine.FINISH_REWARD_TASK then 
		WZLog("TeachFollowingFiveLevel:supplyForTaskTeach( ) ------14-------- ")
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  =  TeachFollowingFiveLevelIdDefine.CLOSE_FINIS_TASK
		TeachFollowingFiveLevel:newerTeachStepFourteen()		
	--完成第一场战斗后断线后关闭按钮
	elseif g_nBELOW_FIVE_LEVEL_TEACH_Steps  ==  TeachFollowingFiveLevelIdDefine.CLOSE_FINIS_TASK_AGAIN then 	
		WZLog("TeachFollowingFiveLevel:supplyForTaskTeach( ) ------15-------- ")
		self:removeDialog()
		self:_removeLightImg()
		self:newerTeachStepFifteen()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.BAG_ISEND
	--邻取换装奖励按钮 
	elseif g_nBELOW_FIVE_LEVEL_TEACH_Steps  ==   TeachFollowingFiveLevelIdDefine.BAG_REWARD_BTN_TASK  then
		WZLog("TeachFollowingFiveLevel:supplyForTaskTeach( ) ------20-------- ")
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.START_BATTLE
		TeachFollowingFiveLevel:newerTeachStepTwenty()
	--第二场开始战斗按钮
	elseif g_nBELOW_FIVE_LEVEL_TEACH_Steps  ==  TeachFollowingFiveLevelIdDefine.START_BATTLE then 	
		WZLog("TeachFollowingFiveLevel:supplyForTaskTeach( ) ------21--------")
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.BAG_START_GAME
		TeachFollowingFiveLevel:newerTeachStepTwentyOne()
		g_nUpdateBoosRoomTime = 0 
	--第二场战斗领取任务按钮
	elseif  g_nBELOW_FIVE_LEVEL_TEACH_Steps  ==  TeachFollowingFiveLevelIdDefine.HALL_REWARD_BTN_TASK then 	
		WZLog("TeachFollowingFiveLevel:supplyForTaskTeach( ) ------24--------")
		TeachFollowingFiveLevel:newerTeachStepTwentyFour()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.LEAD_FINISH
		--保存新手教学完成步骤
		--ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids,
		--								TeachFollowingFiveLevelIdDefine.LEAD_FINISH)
	end 
end 
    

--@brief	任务界面禁用掉上下滑动功能
function TeachFollowingFiveLevel:cannotVerticalMove()
	if GlobalGame.g_bIfInTeaching == false then
		return 
	end 
	--滚动页面容器
	local roolElement = GetTeachElementById(TeachIdDefine.TEACH_TASK,TeachIdDefine.TASK_ROLL) 
	if roolElement == nil then 
		return 
	end 
	
	roolElement:setEnableMoveVertical(false)
end 
	
	
	
--@brief	战斗界面判断是否调用新手教程一
function TeachFollowingFiveLevel:IsNewerTeachBattleOne()
	if GlobalGame.g_bIfInTeaching == true then
		if GlobalGame.g_tPlayerInfo.nLevel < 5 and  g_nBELOW_FIVE_LEVEL_TEACH_Steps   ==
			TeachFollowingFiveLevelIdDefine.BATTLEONE then 
			return true 
		end 
	end 
	return false 
end 



--@brief	战斗界面判断是否调用新手教程二
function TeachFollowingFiveLevel:IsNewerTeachBattleTwo()
	if 	GlobalGame.g_bIfInTeaching  == false then 
		return 
	end 
	if GlobalGame.g_bIfInTeaching == true then
		if GlobalGame.g_tPlayerInfo.nLevel < 5 and  g_nBELOW_FIVE_LEVEL_TEACH_Steps   ==
		TeachFollowingFiveLevelIdDefine.BATTLETWO then 
		return true 
		end 
	end 
	return false 
end 


--@brief	战斗完成后发送相关协议保存到下一步
function TeachFollowingFiveLevel:BattleFinishNextStep()
	if 	GlobalGame.g_bIfInTeaching  == false then 
		return 
	end 
	--战斗一结束后
	if GlobalGame.g_tPlayerInfo.nLevel < 4 and  g_nBELOW_FIVE_LEVEL_TEACH_Steps   ==
		TeachFollowingFiveLevelIdDefine.BATTLEONE then 
		--保存新手教学完成步骤
		ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids,TeachFollowingFiveLevelIdDefine.LOOK_FINISH_TASK)
	
	--战斗二结束后
	elseif  GlobalGame.g_tPlayerInfo.nLevel < 4 and  g_nBELOW_FIVE_LEVEL_TEACH_Steps   ==
		TeachFollowingFiveLevelIdDefine.BATTLETWO then 
		--使用过怒槽
		if TeachFollowingFiveLevel_HAS_USE_FULY == nil then 
			return 
		end 
		if TeachFollowingFiveLevel_HAS_USE_FULY == true then 
			--保存新手教学完成步骤
			ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids,TeachFollowingFiveLevelIdDefine.BAG_TASK_ISEND)
		end 
	end 
end 



--@brief	创建房间界面判断是否进行新手教学教程
function TeachFollowingFiveLevel:IsNewerTeachWndCreateRoom()
	WZLog("TeachFollowingFiveLevel:IsNewerTeachWndCreateRoom()")
	if 	GlobalGame.g_bIfInTeaching  == false then 
		return 
	end 
	if GlobalGame.g_bIfInTeaching == true  then 
		if GlobalGame.g_tPlayerInfo.nLevel < 4 and  g_nBELOW_FIVE_LEVEL_TEACH_Steps  ==
		TeachFollowingFiveLevelIdDefine.SPORT_MODE_GAME_HALL then 
			g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.SURE_MODE
			TeachFollowingFiveLevel:startNewerTeach(g_nBELOW_FIVE_LEVEL_TEACH_Steps )
		end 
	end 
end 



--@brief	游戏房间界面判断是否调用新手教程25
function TeachFollowingFiveLevel:IsNewerTeachGameRoom()
	WZLog("TeachFollowingFiveLevel:IsNewerTeachGameRoom()")
	WZLog("g_nBELOW_FIVE_LEVEL_TEACH_Steps  = ",g_nBELOW_FIVE_LEVEL_TEACH_Steps )
	WZLog("TeachFollowingFiveLevelIdDefine.BATTLETWO = ",TeachFollowingFiveLevelIdDefine.BATTLETWO)
	if 	GlobalGame.g_bIfInTeaching  == false then 
		return 
	end 
	if GlobalGame.g_tPlayerInfo.nLevel < 4 and g_nBELOW_FIVE_LEVEL_TEACH_Steps   ==
		TeachFollowingFiveLevelIdDefine.SKILL_TOOL_HALL then 
		TeachFollowingFiveLevel:newerTeachStepNine()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps = TeachFollowingFiveLevelIdDefine.CLICK_SKILL_HALL
	elseif GlobalGame.g_tPlayerInfo.nLevel < 5 and  g_nBELOW_FIVE_LEVEL_TEACH_Steps   == 
			TeachFollowingFiveLevelIdDefine.BATTLETWO and g_nUpdateBoosRoomTime == 0 then 
		g_nUpdateBoosRoomTime = g_nUpdateBoosRoomTime + 1 
		TeachFollowingFiveLevel:newerTeachStepTwentyTwo()
	end 
end 




----@brief  翻牌界面是否调用新手教学
function TeachFollowingFiveLevel:WndFlopIsNewerTeach()
	WZLog("TeachFollowingFiveLevel:WndFlopIsNewerTeach()")
	if 	GlobalGame.g_bIfInTeaching  == false then 
		return 
	end
	--战斗一后
	if GlobalGame.g_tPlayerInfo.nLevel < 4 and  g_nBELOW_FIVE_LEVEL_TEACH_Steps   ==
		TeachFollowingFiveLevelIdDefine.BATTLEONE then 
		WZLog("WndFlopIsNewerTeach()         ................")
		--保存新手教学完成步骤
		g_nBELOW_FIVE_LEVEL_TEACH_Steps   =  TeachFollowingFiveLevelIdDefine.LOOK_FINISH_TASK
		ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids,TeachFollowingFiveLevelIdDefine.LOOK_FINISH_TASK)
		local sceneIsland = SceneIsland:createElement()
		if sceneIsland ~= nil then 
			replaceScene(sceneIsland)
			SHIELDING_LAYER = WindowManager:addTeachShelterLayer(12001)
		end 
		return true 
	--战斗二后
	elseif  GlobalGame.g_tPlayerInfo.nLevel < 4 and  g_nBELOW_FIVE_LEVEL_TEACH_Steps   ==
		TeachFollowingFiveLevelIdDefine.BATTLETWO then 
		--使用过怒槽
		if TeachFollowingFiveLevel_HAS_USE_FULY == true then 
			WZLog(".....TeachFollowingFiveLevelIdDefine.BATTLETWO.......")
			g_nBELOW_FIVE_LEVEL_TEACH_Steps   = TeachFollowingFiveLevelIdDefine.BAG_TASK_ISEND
			--保存新手教学完成步骤
			ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids,TeachFollowingFiveLevelIdDefine.BAG_TASK_ISEND)
			--@brief	强制退出战斗,清除战斗状态
			ProtocolProcessorTeach:send_BATTLE_QuitBattle(WBattleGlobal:getCurrent():getBattleId(), GlobalGame.g_tPlayerInfo.nPlayerId )
			local sceneIsland = SceneIsland:createElement()
			if sceneIsland ~= nil then 
				replaceScene(sceneIsland)
				SHIELDING_LAYER = WindowManager:addTeachShelterLayer(12001)
			end
			return true 
		end 
	end 
	
	return false 
end 


--@brief	物品界面是否调用新手教程
function TeachFollowingFiveLevel:supplyForWndPlayerGoods( )
	WZLog("TeachFollowingFiveLevel:supplyForWndPlayerGoods( )")
	if 	GlobalGame.g_bIfInTeaching  == false then 
		return 
	end 
	
	if SHIELDING_LAYER ~= nil and
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  == TeachFollowingFiveLevelIdDefine.CLOSE_BAG then 
		TeachFollowingFiveLevel:newerTeachStepSevenTeen()
	end 
end 


--@brief  提供给玩家技能调用的接口（满三个时进行新手教学）
function TeachFollowingFiveLevel:NewerTeachsupplyForSkillProp(count,id)
	WZLog("TeachFollowingFiveLevel:NewerTeachsupplyForSkillProp()")
	if GlobalGame.g_bIfInTeaching == false then
		return 
	end 
	
	if GlobalGame.g_tPlayerInfo.nLevel < 3 and g_nBELOW_FIVE_LEVEL_TEACH_Steps   ==
		TeachFollowingFiveLevelIdDefine.CLOSE_SKILL_TOOLS then 
		local num = 0 
		for var = 1,#id do 
			if id[var] > 0 then  
				num = num + 1 
			end 
			if num >= 3 then 
				g_nBELOW_FIVE_LEVEL_TEACH_Steps = TeachFollowingFiveLevelIdDefine.CLOSE_SKILL_TOOLS
				TeachFollowingFiveLevel:startNewerTeach(TeachFollowingFiveLevelIdDefine.CLOSE_SKILL_TOOLS)
			end 
		end 	
	end 
end 


--@brief  提供给开始游戏按钮的接口函数
function TeachFollowingFiveLevel:IsNewerTeachStartGameBtn()
	WZLog("TeachFollowingFiveLevel:IsNewerTeachStartGameBtn()")
	if GlobalGame.g_bIfInTeaching == false then
		return 
	end 
	
	if GlobalGame.g_tPlayerInfo.nLevel < 4 then 
		if g_nBELOW_FIVE_LEVEL_TEACH_Steps   ==
			TeachFollowingFiveLevelIdDefine.BATTLEONE or 
			 g_nBELOW_FIVE_LEVEL_TEACH_Steps   == 
			TeachFollowingFiveLevelIdDefine.BATTLETWO then  
			--移除对话框和发光星星
			self:removeDialog()
			self:_removeLightImg()
			g_nUpdateBoosRoomTime = 0 
		end 
	end 
end 


--@brief	提供给任务滑动到最底端的接口 
function TeachFollowingFiveLevel:MoveBootomEventNextStep()
	if GlobalGame.g_bIfInTeaching == false then
		return 
	end 

	if GlobalGame.g_tPlayerInfo.nLevel < 4 and g_nBELOW_FIVE_LEVEL_TEACH_Steps ==
		TeachFollowingFiveLevelIdDefine.CLOSE_TASK then 
			self:removeDialog()
			self:_removeFingerAni()
			self:newerTeachStepThree()
			g_nBELOW_FIVE_LEVEL_TEACH_Steps = TeachFollowingFiveLevelIdDefine.GAMEHALL_ISEND
	end 
end 



--@brief	断线重练后清空变量
function TeachFollowingFiveLevel:disConnectionCleanVariable()
	SHIELDING_LAYER = nil    		 	--遮挡层
	POP_DIALOG_TEACH = nil   		 	--弹出对话框
	LIGHT_IMAGE_ELEMENT = nil   	 	--发光图片
	NEWER_FINISH_ANI = nil      	 	--新手教学完成对象
end 


----------------------------------------新手教程步骤--------------------------------------



--@brief	开始新手教程
function TeachFollowingFiveLevel:startNewerTeach(nStep)
	WZLog("----------- TeachFollowingFiveLevel:startNewerTeach-----------------")
	if 	GlobalGame.g_bIfInTeaching  == false then 
		return 
	end 
	
	--小岛点击任务按钮
	if nStep == TeachFollowingFiveLevelIdDefine.TASK_ISEND then    
		WZLog("-------------------11111---------------------")
		WZLog("SHIELDING_LAYER = ",SHIELDING_LAYER)
		self:newerTeachStepOne()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.REWARD_TASK
		
	--滑动任务
	elseif  nStep ==  TeachFollowingFiveLevelIdDefine.REWARD_TASK then          
		WZLog("-------------------22222-------------------")
		self:removeDialog()
		self:_removeLightImg()
	--关闭任务
	elseif  nStep == TeachFollowingFiveLevelIdDefine.CLOSE_TASK  then          
		WZLog("-------------------33333-------------------")
		self:removeDialog()
		self:_removeFingerAni()
		self:newerTeachStepThree()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.GAMEHALL_ISEND
	--小岛点击游戏大厅
	elseif nStep == TeachFollowingFiveLevelIdDefine.GAMEHALL_ISEND then         
		WZLog("-------------------444444-------------------")
		--保存新手教学完成步骤
		ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids, 
												TeachFollowingFiveLevelIdDefine.GAMEHALL_ISEND )										
		WZLog("self.m_nIds = ",self.m_nIds)
		self:removeDialog()
		self:newerTeachStepFour()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.STARTGAME_TASK
	--游戏大厅选择开始游戏
	elseif nStep == TeachFollowingFiveLevelIdDefine.STARTGAME_TASK then   
		WZLog("-------------------555555-------------------")
		--self:removeShieldingImg()
		POP_DIALOG_TEACH = nil 						
		self:newerTeachStepFive()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.SPORT_MODE_GAME_HALL		
	--游戏大厅选择竞技模式
	elseif nStep == TeachFollowingFiveLevelIdDefine.SPORT_MODE_GAME_HALL then
		WZLog("-------------------6666666-------------------")
		self:removeDialog()
		self:_removeLightImg()
		self:newerTeachStepSix()
		--g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.SURE_MODE
	--选择模式确定按钮
	elseif nStep == TeachFollowingFiveLevelIdDefine.SURE_MODE then
		WZLog("7777777777777")
		self:removeDialog()
		self:_removeLightImg()
		self:newerTeachStepSeven()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.SURE_CREATE_ROOM
	--创建房间确定按钮
	elseif nStep == TeachFollowingFiveLevelIdDefine.SURE_CREATE_ROOM then
		WZLog("88888888888888888888")
		self:removeDialog()
		self:_removeLightImg()
		self:newerTeachStepEight()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.SKILL_TOOL_HALL
	--技能道具
	elseif nStep == TeachFollowingFiveLevelIdDefine.SKILL_TOOL_HALL then
		WZLog("999999999999999999999999")
		POP_DIALOG_TEACH = nil 
		WindowManager:removeTeachShelterLayer()
		--self:newerTeachStepNine()
		--g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.CLICK_SKILL_HALL
	--点击技能道具
	elseif nStep == TeachFollowingFiveLevelIdDefine.CLICK_SKILL_HALL then
		WZLog("1010101010101010")
		self:removeDialog()
		self:_removeLightImg()
		self:newerTeachStepTen()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.CLOSE_SKILL_TOOLS
	--技能道具关闭按钮
	elseif nStep == TeachFollowingFiveLevelIdDefine.CLOSE_SKILL_TOOLS then 
		WZLog("1111111111111111")
		self:removeDialog()
		self:_removeLightImg()
		self:newerTeachStepEleven()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.READY_GAME_HALL
	--准备游戏按钮
	elseif nStep == TeachFollowingFiveLevelIdDefine.READY_GAME_HALL then
		WZLog("...............12................")
		self:removeDialog()
		self:newerTeachStepTwelve()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.BATTLEONE
		--跳到战斗界面
		--保存新手教学完成步骤
		ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids,
		TeachFollowingFiveLevelIdDefine.GAMEHALL_ISEND )
	--提示查看完成任务（小岛任务按钮）
	elseif nStep == TeachFollowingFiveLevelIdDefine.LOOK_FINISH_TASK then
		WZLog("...............13................")
		WZLog("SHIELDING_LAYER = ",SHIELDING_LAYER)
		self:newerTeachStepThirteen()	
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.FINISH_REWARD_TASK
		 
		
	--[[
	--断线后要小岛进入领取背包界面
	elseif nStep == TeachFollowingFiveLevelIdDefine.AGAIN_TASK then
		WZLog("......taskBtn   to    Entry WndBagBtn................")
		WindowManager:removeTeachShelterLayer()
		SHIELDING_LAYER = WindowManager:addTeachShelterLayer(12001)
		WZLog("SHIELDING_LAYER = ",SHIELDING_LAYER)
		self:newerTeachStepThirteen()	
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.CLOSE_FINIS_TASK_AGAIN
	--]]
	
	--领取任务按钮(领取奖励按钮)
	elseif nStep == TeachFollowingFiveLevelIdDefine.FINISH_REWARD_TASK then
		WZLog("...............14................")
		self:removeDialog()
		self:_removeLightImg()
	--关闭任务按钮
	elseif nStep == TeachFollowingFiveLevelIdDefine.CLOSE_FINIS_TASK then
		WZLog("...............15................")
		--保存新手教学完成步骤(切换到开始背包小岛任务按钮)
		ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids,
			TeachFollowingFiveLevelIdDefine.BAG_ISEND )
		self:removeDialog()
		self:_removeLightImg()
		self:newerTeachStepFifteen()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.BAG_ISEND
	--小岛背包按钮
	elseif nStep == TeachFollowingFiveLevelIdDefine.BAG_ISEND then
		WZLog("...............16................")
		--保存新手教学完成步骤
		ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids, 
												TeachFollowingFiveLevelIdDefine.BAG_ISEND )
		self:removeDialog()
		self:newerTeachStepSixteen()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.CLICK_WEAPON
	--点击背包武器
	elseif nStep == TeachFollowingFiveLevelIdDefine.CLICK_WEAPON then
		WZLog("...............17................")
		self:removeDialog()
		self:_removeLightImg()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.CLOSE_BAG
		--self:newerTeachStepSevenTeen()
	--点击关闭主角页面
	elseif nStep == TeachFollowingFiveLevelIdDefine.CLOSE_BAG then
		WZLog("...............18................")
		self:removeDialog()
		self:_removeLightImg()
		--保存新手教学完成步骤
		ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids, 
												TeachFollowingFiveLevelIdDefine.CLOSE_BAG_TASK_ISEND )
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.CLOSE_BAG_TASK_ISEND
		self:newerTeachStepEightTeen()
	--你有已完成的任务
	elseif nStep == TeachFollowingFiveLevelIdDefine.CLOSE_BAG_TASK_ISEND then 
		WZLog("...............19................")
		self:removeDialog()
		--保存新手教学完成步骤
		ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids, 
		TeachFollowingFiveLevelIdDefine.CLOSE_BAG_TASK_ISEND )
		--正常情况下
		if GlobalGame.g_tPlayerInfo.nLevel < 3 then 
			WZLog("GlobalGame.g_tPlayerInfo.nLevel = ",GlobalGame.g_tPlayerInfo.nLevel)
			WZLog("11111111111")
			g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.BAG_REWARD_BTN_TASK
		elseif GlobalGame.g_tPlayerInfo.nLevel >= 3 then 
			WZLog("222222222")
			WZLog("GlobalGame.g_tPlayerInfo.nLevel =  ",GlobalGame.g_tPlayerInfo.nLevel)
			g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.START_BATTLE
		end 
		self:newerTeachStepNightTeen()
	--领取换装任务
	elseif nStep == TeachFollowingFiveLevelIdDefine.BAG_REWARD_BTN_TASK  then 
		WZLog("...............20................")
		self:removeDialog()
		self:_removeLightImg()
		--保存新手教学完成步骤
		ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids,
								TeachFollowingFiveLevelIdDefine.CLOSE_BAG_TASK_ISEND)
	--一鸣惊人的开始战斗按钮 
	elseif nStep == TeachFollowingFiveLevelIdDefine.START_BATTLE then 
		WZLog("...............21................")
		self:removeDialog()
		self:_removeLightImg()
		WZLog("g_nBELOW_FIVE_LEVEL_TEACH_Steps  = ",g_nBELOW_FIVE_LEVEL_TEACH_Steps )
		--保存新手教学完成步骤
		--ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids,0)
	--点击‘开始游戏’进入战斗使用怒槽
	elseif nStep == TeachFollowingFiveLevelIdDefine.BAG_START_GAME then 	
		WZLog("...............22................")
		--self:newerTeachStepTwentyTwo()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.BATTLETWO												
	--你有已完成的任务
	elseif nStep == TeachFollowingFiveLevelIdDefine.BAG_TASK_ISEND then 	
		WZLog("...............23................")
		self:newerTeachStepTwentyThree()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.HALL_REWARD_BTN_TASK
	--领取奖励按钮
	elseif nStep == TeachFollowingFiveLevelIdDefine.HALL_REWARD_BTN_TASK then 	
		WZLog("...............24................")
		self:removeDialog()
		self:_removeLightImg()
	--关闭任务按钮
	elseif nStep == TeachFollowingFiveLevelIdDefine.HALL_CLOSE_BTN_TASK then 	
		WZLog("...............25................")
		self:removeDialog()
		self:_removeLightImg()
		self:newerTeachStepTwentyFive()
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.LEAD_FINISH
		WZLog("g_nBELOW_FIVE_LEVEL_TEACH_Steps  = ",g_nBELOW_FIVE_LEVEL_TEACH_Steps  )
	--新手教学结束
	elseif nStep == TeachFollowingFiveLevelIdDefine.LEAD_FINISH and 
		SceneIsland.m_root ~= nil then 	
		WZLog("...............26................")
		local imgOpacity = WZUIImage:create()
		WZLog("imgOpacity = ",imgOpacity)
		WZLog("SceneIsland.m_root = ",SceneIsland.m_root)
		self:removeDialog()
		if imgOpacity == nil or  SceneIsland.m_root == nil then 
			return 
		end 
		imgOpacity:setFile("ui/common/transparent_bg.png")
		imgOpacity:setZOrder(99999999)
		imgOpacity:setName("imgOpacity99999999")
		SceneIsland.m_root:addChild(imgOpacity)
		--增加教学完成动画
		NEWER_FINISH_ANI = CreateCelebrateWithColorBarAnimation("common/text/teach_finish.png",imgOpacity,TeachFollowingFiveLevel,"actionFinishCallBack",nil,true)
		GlobalGame.g_bIfInTeaching = false
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = -1
		--保存新手教学完成步骤
		--WZUIButton:setGlobalInterval(600)
		g_bTeachFollowingFiveLevelFinishFlag = true 
		ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids,-1)
		self:delete()
	end 
		
end 


--@brief	异常情况下完成新手教学
--@param #1 nResWidth  相对
function TeachFollowingFiveLevel:ErrFinishNewerTeach()
	if GlobalGame.g_bIfInTeaching == true then 
		GlobalGame.g_bIfInTeaching = false
		g_nBELOW_FIVE_LEVEL_TEACH_Steps  = -1
		--保存新手教学完成步骤
		--WZUIButton:setGlobalInterval(600)
		g_bTeachFollowingFiveLevelFinishFlag = true 
		ProtocolProcessorTeach:send_TASK_TiroStep(g_nTeachFollowingFiveLevel_ids,-1)
		WindowManager:removeTeachTouchLayer()
		self:delete()
	end 
end 




--@brief	调整挖空层大小
--@param #1 nResWidth  相对宽度
--@param #2 nResHeight 相对高度
function TeachFollowingFiveLevel:adjustTeachImgAndLayer(element,nResWidth,nResHeight)
	if SHIELDING_LAYER == nil then 
		WZLog("TeachFollowingFiveLevel:adjustTeachImgAndLayer(element,size) SHIELDING_LAYER is nil")
		return 
	end 
		
	local elementSize = element:getContentSize()
	local totalSize = SHIELDING_LAYER:getContentSize()
	local emptyImg = SHIELDING_LAYER:getChildElement("ImgTeachClip")
	emptyImg:setRelativeSize(GlobalMethod:CCSize(elementSize.width/totalSize.width + 0.3,
							elementSize.width/totalSize.height + 0.1))
end


--@brief	调整挖空层位置
--@param #1 nMovePixelX   偏移X轴象素
--@param #2 nMovePnixelY  偏移Y轴象素
function TeachFollowingFiveLevel:adjustEmptyImgPostion(nMovePixelX,nMovePnixelY)
	if SHIELDING_LAYER == nil then 
		WZLog("TeachFollowingFiveLevel:adjustEmptyImgPostion(element,nResWidth,nResHeight) SHIELDING_LAYER is nil")
		return 
	end 
	local emptyElement = SHIELDING_LAYER:getChildElement("ImgTeachClip")
	if emptyElement ~= nil then 
		local resPosX,resPosY = emptyElement:getRelativePosition()
		local totalSize = SHIELDING_LAYER:getContentSize()
		emptyElement:setRelativePosition(GlobalMethod:ccp(resPosX.x + nMovePixelX/1136 ,resPosX.y + nMovePnixelY/720))
	end 
end 


--@brief	新手指引第一步
function TeachFollowingFiveLevel:newerTeachStepOne()
	WZLog("------------TeachFollowingFiveLevel:newerTeachStepOne()----------------------------")
	--任务按钮
	local taskBtnElement = GetTeachElementById(TeachIdDefine.TEACH_ISLAND,TeachIdDefine.ISLAND_TASK)
	WZLog("taskBtnElement = ",taskBtnElement)
	if taskBtnElement == nil then 
		self:getElementError("step 1 taskBtnElement")
		return 
	end 
	--弹出“这里可以查看、领取和完成任务，你不知道做什么的时候就来点任务吧”
	POP_DIALOG_TEACH = CellDialog:addDialog(taskBtnElement,SHIELDING_LAYER,LocalStrings.TEACH_NOT_KNOW_TASK,
											CellDialog.DIR_UP,-1,nil,nil,10,-8,240)
	local conSize = taskBtnElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(taskBtnElement, GlobalMethod:CCSize(conSize.width*0.92,conSize.height*0.92))
	taskBtnElement:setZOrder(500)
	self:addLightImg("common/animation/button_9_an.png",taskBtnElement,0,-0.05)
end 


function TeachFollowingFiveLevel:imgTouchMoved(element,pt)
	WZLog(".....2222222..........")


end 


function TeachFollowingFiveLevel:imgTouchEnded(element,pt)
	WZLog("3333")

end 


--@brief 新手指引2：操作方式：手指按住任务内容向上滑动查看任务
function TeachFollowingFiveLevel:newerTeachStepTwo()
	WZLog("------------TeachFollowingFiveLevel:newerTeachStepTwo()----------------------------")
	--滚动页面
	local roolElement = GetTeachElementById(TeachIdDefine.TEACH_TASK,TeachIdDefine.TASK_ROLL) 
	WZLog("getRewardElement = ",roolElement)
	if roolElement == nil then 
		self:getElementError("step 2 roolElement")
		return 
	end 
	WZLog("POP_DIALOG_TEACH = ",POP_DIALOG_TEACH)
	POP_DIALOG_TEACH = CellDialog:addDialog(roolElement,SHIELDING_LAYER,LocalStrings.TEACH_HOW_TO_LOOK_TASK,
											CellDialog.DIR_CENTER,-1,NULL,NULL,150,-85)
	WindowManager:removeTeachTouchLayer()
	WindowManager:addTeachTouchLayerForElement(roolElement, roolElement:getContentSize())
	self:_setFingerAni( SHIELDING_LAYER )
end 


--@brief 新手指引3：点击关闭任务，返回小岛
function TeachFollowingFiveLevel:newerTeachStepThree()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepThree()()----------------------------")
	--取得关闭按钮
	local closeElement = GetTeachElementById(TeachIdDefine.TEACH_TASK,TeachIdDefine.TASK_CLOSE) 
	if closeElement == nil then 
		self:getElementError("step 3 closeElement")
		return 
	end 
	POP_DIALOG_TEACH = CellDialog:addDialog(closeElement,SHIELDING_LAYER,LocalStrings.TEACH_CLOSE_TASK,
						CellDialog.DIR_DOWN,-1,NULL,NULL,-35,10)
	WindowManager:removeTeachTouchLayer()
	local conSize = closeElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(closeElement, GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))												
	self:addLightImg("common/animation/close_an.png",closeElement,0,-0.06,nil,nil,10)
end 



--@brief 添加发光图片以及动作
--@param sImgPath   发光图片路径
--@param element    控件对象
--@param relX       相对父结点X轴
--@param relY       相对父结点Y轴
--@param picTimes   图片倍数
--@param zOrder     Z轴  
--@param nDuration  延时时间
function TeachFollowingFiveLevel:addLightImg(sImgPath,element,relX,relY,relWidht,relHeight,zOrder,nDuration)
	WZLog("TeachFollowingFiveLevel:addLightImg(sImgPath,element,relX,relY)")
	LIGHT_IMAGE_ELEMENT = WZUIImage:create()
	LIGHT_IMAGE_ELEMENT:setFile(sImgPath)
	local conSize = element:getContentSize()
	local resSize = element:getRelativeSize()
	local parentConSize = element:getParent():getContentSize()
	if relWidht == nil or relHeight == nil then 
		LIGHT_IMAGE_ELEMENT:setUseOriginSize(true)
	else 
		LIGHT_IMAGE_ELEMENT:setRelativeSize(GlobalMethod:CCSize(conSize.width/parentConSize.width+relWidht,
							conSize.height/parentConSize.height+relHeight))
	end 
	if nDuration == nil then 
		nDuration = 0.7
	end 

	local pos,pos1 = element:getRelativePosition()
	if zOrder ~= nil then 
		element:setZOrder(zOrder)
	else 
		zOrder = element:getZOrder()
	end 
	LIGHT_IMAGE_ELEMENT:setRelativePosition(GlobalMethod:ccp(pos.x+relX,pos.y+6/parentConSize.height+relY))
	LIGHT_IMAGE_ELEMENT:setZOrder(zOrder-1)
	self:imgLightAction(LIGHT_IMAGE_ELEMENT,52,255,nDuration)
	element:getParent():addChild(LIGHT_IMAGE_ELEMENT)
	--[[
	--播放动画
	local aniSequence = WZUIActionSequence:create()
	aniSequence:setIsLoop(true)
	local aniFadeTo = WZUIActionFadeTo:create()
	aniFadeTo:setOpacity(52)
	aniFadeTo:setDuration(nDuration)
	aniSequence:setChildAction(aniFadeTo)
	aniFadeTo = WZUIActionFadeTo:create()
	aniFadeTo:setOpacity(255)
	aniFadeTo:setDuration(nDuration)
	aniSequence:setChildAction(aniFadeTo)
	LIGHT_IMAGE_ELEMENT:runUIAction(aniSequence)
	--]]
end 



--@brief 发光动作
function TeachFollowingFiveLevel:imgLightAction(imgELement,nStartOpacity,nEndOpacity,nDuration)
	local aniSequence = WZUIActionSequence:create()
	aniSequence:setIsLoop(true)
	local aniFadeTo = WZUIActionFadeTo:create()
	aniFadeTo:setOpacity(nStartOpacity)
	aniFadeTo:setDuration(nDuration)
	aniSequence:setChildAction(aniFadeTo)
	aniFadeTo = WZUIActionFadeTo:create()
	aniFadeTo:setOpacity(nEndOpacity)
	aniFadeTo:setDuration(nDuration)
	aniSequence:setChildAction(aniFadeTo)
	imgELement:runUIAction(aniSequence)
end 







--@brief 新手指引4：点这里可以创建和加入各个模式的对战，还有丰厚的奖励。。。
function TeachFollowingFiveLevel:newerTeachStepFour()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepFour()()----------------------------")
	--取得游戏大厅按钮
	local gamesHallElement = GetTeachElementById(TeachIdDefine.TEACH_ISLAND,TeachIdDefine.ISLAND_HALL) 
	WZLog("gamesHallElement = ",gamesHallElement)
	if gamesHallElement == nil then 
		self:getElementError("step 4 gamesHallElement")
		return 
	end 
	POP_DIALOG_TEACH = CellDialog:addDialog(gamesHallElement,SHIELDING_LAYER,LocalStrings.TEACH_CLICK_GAMES_HALL,
											CellDialog.DIR_UP,-1,NULL,NULL,-50,-80)
    WZLog("========================================================",POP_DIALOG_TEACH)
	WindowManager:removeTeachTouchLayer()
	SceneIsland:changeBuildingShining(gamesHallElement)
	gamesHallElement:setZOrder(500)
	local conSize =  gamesHallElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(gamesHallElement, GlobalMethod:CCSize(conSize.width*0.9,conSize.height*0.9))	
    --self:addLightImg("common/animation/hall_create_room_an.png",gamesHallElement,0,0)
	--self:adjustTeachImgAndLayer(gamesHallElement,0.2,0.6)
end 


--@brief 新手指引5：点击‘开始游戏’创建房间
function TeachFollowingFiveLevel:newerTeachStepFive()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepFive()----------------------------")
	--取得开始游戏按钮	
	local startGameElement = GetTeachElementById(TeachIdDefine.TEACH_HALL,TeachIdDefine.HALL_STARTGAME) 
	WZLog("startGameElement = " , startGameElement)
	if  startGameElement == nil then 
		self:getElementError("step 5 startGameElement")
		return 
	end 
	
	POP_DIALOG_TEACH = CellDialog:addDialog(startGameElement,SHIELDING_LAYER,
					LocalStrings.TEACH_CLICK_CREATE_ROOM,CellDialog.DIR_LEFT,-1,NULL,NULL,25,0)
	WindowManager:removeTeachTouchLayer()
	local conSize = startGameElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(startGameElement, GlobalMethod:CCSize(conSize.width*0.98,conSize.height*0.98))		
	self:addLightImg("common/animation/hall_create_room_an.png",startGameElement,0,0)
	self:adjustTeachImgAndLayer(startGameElement,0.2,0.6)
end 


--@brief 新手指引6：这里可以选择各种对战模式，目前先点击‘竞技模式’体验吧
function TeachFollowingFiveLevel:newerTeachStepSix()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepSix()----------------------------")
	--取得竟技模式按钮	
	local sportElement = GetTeachElementById(TeachIdDefine.TEACH_HALL,TeachIdDefine.HALL_SPORTS_MODE) 
	WZLog("sportElement = " , sportElement)
	if sportElement == nil then 
		self:getElementError("step 6 sportElement")
		return 
	end 
	
	local selMode2 = WndCreateRoom.m_root:getChildElement("selMode2_WndCreateRoom")
	WZLog("selMode2 = ",selMode2)
	if selMode2 == nil then
		return 
	end 
	--禁用复活模式
	WZUICheckBox:luaTo(selMode2):setTouchEnable(false)
	
	POP_DIALOG_TEACH = CellDialog:addDialog(sportElement,SHIELDING_LAYER,LocalStrings.TEACH_SEL_BATTLE_MODE,
											CellDialog.DIR_DOWN,-1,NULL,NULL,80,10)
	WindowManager:removeTeachTouchLayer()
	local conSize = sportElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(sportElement, GlobalMethod:CCSize(conSize.width*0.86,conSize.height*0.86))												
	self:addLightImg("common/animation/model_sports_an.png",sportElement,0.132,-0.06,0.05,0.2)
	--0.1295
	self:adjustEmptyImgPostion(0,0)
end 


--@brief 新手指引7：点击‘确定’，完成模式选择
function TeachFollowingFiveLevel:newerTeachStepSeven()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepSeven()----------------------------")
	--取得创建房间确定按钮	
	local sureBtnElement = GetTeachElementById(TeachIdDefine.TEACH_HALL,TeachIdDefine.HALL_SPORTS_SURE) 
	if sureBtnElement == nil then 
		self:getElementError("step 7 sureBtnElement")
		return 
	end 
	POP_DIALOG_TEACH = CellDialog:addDialog(sureBtnElement,SHIELDING_LAYER,LocalStrings.TEACH_CLICK_SURE_SEL_MODE,
											CellDialog.DIR_LEFT,-1,NULL,NULL,0,0)
	WindowManager:removeTeachTouchLayer()
	local conSize = sureBtnElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(sureBtnElement,GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))												
	self:addLightImg("common/animation/button_1_an.png",sureBtnElement,0,-0.08,0.5,0.8)	
	self:adjustTeachImgAndLayer(sureBtnElement,0.2,0.2)
end 


--@brief 新手指引8：这里可以设置房间名字、密码、对战人数、撮合方式，点击‘确定’创建房间
function TeachFollowingFiveLevel:newerTeachStepEight()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepEight()----------------------------")
	--取得创建房间确定按钮	
	local sureBtnElement = GetTeachElementById(TeachIdDefine.TEACH_HALL,TeachIdDefine.HALL_SPORTS_SURE) 
	if sureBtnElement == nil then 
		self:getElementError("step 8 sureBtnElement")
		return 
	end 
	WZLog("sureBtnElement = " , sureBtnElement)
	POP_DIALOG_TEACH = CellDialog:addDialog(sureBtnElement,SHIELDING_LAYER,LocalStrings.TEACH_SET_ROOM_INFO,
											CellDialog.DIR_LEFT,-1,NULL,NULL,0,0)
	WindowManager:removeTeachTouchLayer()
	local conSize = sureBtnElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(sureBtnElement, GlobalMethod:CCSize(conSize.width*0.95,conSize.height*0.95))												
	self:addLightImg("common/animation/button_1_an.png",sureBtnElement,0,-0.08,0.5,0.8)
	self:adjustTeachImgAndLayer(sureBtnElement,0.2,0.2)
	WZLog("*********************************")
end 


--@brief 新手指引9：‘技能道具’装备战斗所需的道具
function TeachFollowingFiveLevel:newerTeachStepNine()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepNine()----------------------------")
	--取得技能道具按钮
	local skillToolBtnElement = GetTeachElementById(TeachIdDefine.TEACH_HALL,TeachIdDefine.HALL_SKILL_TOOL) 
	WZLog("skillToolBtnElement = ",skillToolBtnElement)
	if skillToolBtnElement == nil then 
		self:getElementError("step 7 skillToolBtnElement")
		return 
	end 
	POP_DIALOG_TEACH = CellDialog:addDialog(skillToolBtnElement,SHIELDING_LAYER,LocalStrings.TEACH_SKILL_TOOLS,
											CellDialog.DIR_UP,-1,NULL,NULL,-35,0)
	local conSize = skillToolBtnElement:getContentSize()
	WindowManager:removeTeachTouchLayer()
	local conSize = skillToolBtnElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(skillToolBtnElement,GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))											
	self:addLightImg("common/animation/button_1_an.png",skillToolBtnElement,0,-0.08,0.68,1.1,nil,5)
	self:adjustTeachImgAndLayer(skillToolBtnElement,0.5,0.8)
end 



--@brief 新手指引10：这里有各式各样的战斗技能任你挑选，请挑选3个技能
function TeachFollowingFiveLevel:newerTeachStepTen()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepTen()----------------------------")
	--取得道具列表
	local hallSkillElement = GetTeachElementById(TeachIdDefine.TEACH_HALL,TeachIdDefine.HALL_SKILL_LIST) 
	if hallSkillElement == nil then 
		self:getElementError("step 10 skillToolBtnElement")
		return 
	end 
	POP_DIALOG_TEACH = CellDialog:addDialog(hallSkillElement,SHIELDING_LAYER,LocalStrings.TEACH_SEL_SKILL,
											CellDialog.DIR_RIGHT,-1,NULL,NULL,0,130)
	WindowManager:removeTeachTouchLayer()
	hallSkillElement:setZOrder(500)
	local conSize = hallSkillElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(hallSkillElement,GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))				
	self:addLightImgPic("common/animation/iteam2_bg.png",hallSkillElement,0,-0.01,nil,nil,50,0.7)
end 



--@brief 新手指引11：点击返回房间
function TeachFollowingFiveLevel:newerTeachStepEleven()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepEleven()----------------------------")
	--技能道具关闭按钮
	local closeElement = GetTeachElementById(TeachIdDefine.TEACH_HALL,TeachIdDefine.HALL_SKILL_CLOSE) 
	WZLog("closeElement = " , closeElement)
	if closeElement == nil then 
		self:getElementError("step 11 closeElement")
		return 
	end 
	POP_DIALOG_TEACH = CellDialog:addDialog(closeElement,SHIELDING_LAYER,LocalStrings.TEACH_RETURN_ROOM,
											CellDialog.DIR_DOWN,-1,NULL,NULL,-35,10)
	WindowManager:removeTeachTouchLayer()
	local conSize = closeElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(closeElement, GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))	
	
	self:addLightImg("common/animation/close_an.png",closeElement,0,-0.008,nil,nil,10)
end 


--@brief 新手指引12：点击‘开始游戏’进行激情对战
function TeachFollowingFiveLevel:newerTeachStepTwelve()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepTwelve()----------------------------")
	--准备游戏按钮
	local readyGameElement = GetTeachElementById(TeachIdDefine.TEACH_HALL,TeachIdDefine.HALL_READY_GAME) 
	if readyGameElement == nil then 
		self:getElementError("step 12 readyGameElement")
		return 
	end 
	POP_DIALOG_TEACH = CellDialog:addDialog(readyGameElement,SHIELDING_LAYER,LocalStrings.TEACH_CLICK_GAME,
											CellDialog.DIR_UP,-1,NULL,NULL,-30,0)
	local conSize = readyGameElement:getContentSize()
	WindowManager:removeTeachTouchLayer()
	WindowManager:addTeachTouchLayerForElement(readyGameElement, GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))	
	self:addLightImg("common/animation/button_6_an.png",readyGameElement,0,-0.07,nil,nil)	
	--self:addLightImg("common/animation/button_9_an.png",readyGameElement,0,-0.07,nil,nil)	
	self:adjustTeachImgAndLayer(readyGameElement,0.4,0.5)
end 


--@brief 新手指引13：战斗结束后：你有已完成的任务，快点击查看已完成的任务吧
function TeachFollowingFiveLevel:newerTeachStepThirteen()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepThirteen()----------------------------")
	--任务按钮
	local taskBtnElement = GetTeachElementById(TeachIdDefine.TEACH_ISLAND,TeachIdDefine.ISLAND_TASK)
	if taskBtnElement == nil then 
		self:getElementError("step 13 taskBtnElement")
		return 
	end 
	WZLog("taskBtnElement = ",taskBtnElement)
	--弹出“你有已完成的任务快点击查看已完成的任务吧！”
	POP_DIALOG_TEACH = CellDialog:addDialog(taskBtnElement,SHIELDING_LAYER,LocalStrings.TEACH_LOOK_FINISH_TASK,
											CellDialog.DIR_UP,-1,nil,nil,0,-8,240)

	WindowManager:removeTeachTouchLayer()
	local conSize = taskBtnElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(taskBtnElement, GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))	
	--self:addLightImg("common/animation/island_icon_task_an.png",taskBtnElement,0,-0.05)	
    self:addLightImg("common/animation/button_9_an.png",taskBtnElement,0,-0.13)
end 



--@brief 新手指引14：点击‘领取奖励’可获得任务奖品哦
function TeachFollowingFiveLevel:newerTeachStepFourteen()
	WZLog("TeachFollowingFiveLevel:newerTeachStepFourteen()")
	local getRewardElement = GetTeachElementById(TeachIdDefine.TEACH_TASK,TeachIdDefine.TASK_GET_REWARD) 
	WZLog("getRewardElement = ",getRewardElement)
	if getRewardElement == nil then 
		self:getElementError("step 14 getRewardElement")
		return 
	end 
	self:cannotVerticalMove()
	POP_DIALOG_TEACH = CellDialog:addDialog(getRewardElement,SHIELDING_LAYER,LocalStrings.TEACH_CLICK_REWARD,
											CellDialog.DIR_LEFT,-1,NULL,NULL,0,0)
	WindowManager:removeTeachTouchLayer()
	local conSize = getRewardElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(getRewardElement, GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))		
	self:addLightImg("common/animation/button_1_an.png",getRewardElement,0,-0.08,0.52,1)
	self:adjustTeachImgAndLayer(getRewardElement,0.4,0.3)	
end 


--@brief 新手指引15：点击关闭任务，返回小岛
function TeachFollowingFiveLevel:newerTeachStepFifteen()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepFifteen()----------------------------")
	--取得关闭按钮
	local closeElement = GetTeachElementById(TeachIdDefine.TEACH_TASK,TeachIdDefine.TASK_CLOSE) 
	if closeElement == nil then 
		self:getElementError("step 15 closeElement")
		return 
	end 
	POP_DIALOG_TEACH = CellDialog:addDialog(closeElement,SHIELDING_LAYER,LocalStrings.TEACH_CLOSE_TASK,
											CellDialog.DIR_DOWN,-1,NULL,NULL,-35,10)
	WindowManager:removeTeachTouchLayer()
	local conSize = closeElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(closeElement, GlobalMethod:CCSize(conSize.width,conSize.height))		
	self:addLightImg("common/animation/close_an.png",closeElement,0,-0.06,nil,nil,10)
end 


--@brief 新手指引16：点击‘背包’，查你角色的状态
function TeachFollowingFiveLevel:newerTeachStepSixteen()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepSixteen()----------------------------")
	--取得背包按钮
	local bagElement = GetTeachElementById(TeachIdDefine.TEACH_ISLAND,TeachIdDefine.ISLAND_BAG) 
	if bagElement == nil then 
		self:getElementError("step 16 bagElement")
		return 
	end 
	POP_DIALOG_TEACH = CellDialog:addDialog(bagElement,SHIELDING_LAYER,LocalStrings.TEACH_LOOK_PLAYER_INFO,
											CellDialog.DIR_UP,-1,NULL,NULL,-30,-5)
	WindowManager:removeTeachTouchLayer()
	local conSize = bagElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(bagElement, GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))	
	self:addLightImg("common/animation/island_icon_player_an.png",bagElement,0,-0.05)	
end 



--@brief 新手指引17：点击武器,增加攻击力
function TeachFollowingFiveLevel:newerTeachStepSevenTeen()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepSevenTeen()----------------------------")
	--取得背包物品列表
	local goodsListElement = GetTeachElementById(TeachIdDefine.TEACH_BAG,TeachIdDefine.BAG_GOODS_LIST) 
	if goodsListElement == nil then 
		self:getElementError("step 17 goodsListElement")
		return 
	end 

	POP_DIALOG_TEACH = CellDialog:addDialog(goodsListElement,SHIELDING_LAYER,
							LocalStrings.TEACH_CLICK_WEAPON,CellDialog.DIR_UP,-1,NULL,NULL,-20,0)
	WindowManager:removeTeachTouchLayer()
	goodsListElement:setZOrder(500)
	local conSize = goodsListElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(goodsListElement, GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))		
	self:addLightImg("common/animation/iteam_bg_an.png",goodsListElement,0,0.2,2.2,0.78,100)	
end 


--@brief 新手指引18：点击关闭背包
function TeachFollowingFiveLevel:newerTeachStepEightTeen()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepEightTeen()----------------------------")
	--取得背包关闭按钮
	local closeBagElement = GetTeachElementById(TeachIdDefine.TEACH_BAG,TeachIdDefine.BAG_CLOSE) 
	WZLog("************closeBagElement = ******************",closeBagElement)
	if closeBagElement == nil then
		self:getElementError("step 18 closeBagElement")
		return 
	end 
	POP_DIALOG_TEACH = CellDialog:addDialog(closeBagElement,SHIELDING_LAYER,LocalStrings.TEACH_CLICK_BAG,
											CellDialog.DIR_DOWN,-1,NULL,NULL,-35,5)
	WindowManager:removeTeachTouchLayer()
	local conSize = closeBagElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(closeBagElement, GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))		
	self:addLightImg("common/animation/close_an.png",closeBagElement,0,-0.06,nil,nil)
end 


--@brief 新手指引19：你有已完成的任务，快点击查看已完成的任务吧
function TeachFollowingFiveLevel:newerTeachStepNightTeen()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepNightTeen()----------------------------")
	--任务按钮
	local taskBtnElement = GetTeachElementById(TeachIdDefine.TEACH_ISLAND,TeachIdDefine.ISLAND_TASK)
	if taskBtnElement == nil then 
		self:getElementError("step 19 taskBtnElement")
		return 
	end 
	--弹出“你有已完成的任务快点击查看已完成的任务吧！”
	POP_DIALOG_TEACH = CellDialog:addDialog(taskBtnElement,SHIELDING_LAYER,LocalStrings.TEACH_LOOK_FINISH_TASK,
											CellDialog.DIR_UP,-1,NULL,NULL,-5,-5,240)
	WindowManager:removeTeachTouchLayer()
	local conSize = taskBtnElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(taskBtnElement,GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))		
	self:addLightImg("common/animation/button_9_an.png",taskBtnElement,0,-0.05)
end 


--@brief 新手指引20：领取换装奖励
function TeachFollowingFiveLevel:newerTeachStepTwenty()
	WZLog("---1111----------TeachFollowingFiveLevel:newerTeachStepTwenty()----------------------------")
	local getRewardElement = GetTeachElementById(TeachIdDefine.TEACH_TASK,TeachIdDefine.TASK_GET_REWARD) 
	WZLog("getRewardElement 1111 = ",getRewardElement)
	if getRewardElement == nil then
		self:getElementError("step 20 getRewardElement")
		return 
	end 
	self:cannotVerticalMove()
	POP_DIALOG_TEACH = CellDialog:addDialog(getRewardElement,SHIELDING_LAYER,LocalStrings.TEACH_RECIVE_RELOAD_REWARD,
										CellDialog.DIR_LEFT,-1,NULL,NULL,0,0)
	WindowManager:removeTeachTouchLayer()
	local conSize = getRewardElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(getRewardElement, GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))	
	self:addLightImg("common/animation/button_1_an.png",getRewardElement,0,-0.08,0.52,1)		
end 


--@brief 新手指引21：点击‘进行战斗’（）竞技大厅--一鸣惊人任务 id : 81
function TeachFollowingFiveLevel:newerTeachStepTwentyOne()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepTwentyOne()----------------------------")
	--取得开始战斗按钮
	local startBattleElement = GetTeachElementById(TeachIdDefine.TEACH_TASK,TeachIdDefine.TASK_GET_REWARD) 
	if startBattleElement == nil then 
		self:getElementError("step 21 startBattleElement")
		return 
	end 
	self:cannotVerticalMove()
	WZLog("startBattleElement = ",startBattleElement)
	POP_DIALOG_TEACH = CellDialog:addDialog(startBattleElement,SHIELDING_LAYER,LocalStrings.TEACH_START_BATTLE,
											CellDialog.DIR_LEFT,-1,NULL,NULL,0,0)
	WindowManager:removeTeachTouchLayer()
	local conSize = startBattleElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(startBattleElement, GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))		
	self:addLightImg("common/animation/button_1_an.png",startBattleElement,0,-0.08,0.52,1)		
end 


--@brief 新手指引22："点击‘开始游戏’进入战斗使用怒槽"
function TeachFollowingFiveLevel:newerTeachStepTwentyTwo()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepTwentyTwo()----------------------------")
	--开始游戏按钮
	local readyGameElement = GetTeachElementById(TeachIdDefine.TEACH_HALL,TeachIdDefine.HALL_READY_GAME) 
	WZLog("readyGameElement = ",readyGameElement)
	if readyGameElement == nil then 
		self:getElementError("step 22 readyGameElement")
		return 
	end 
	POP_DIALOG_TEACH = CellDialog:addDialog(readyGameElement,SHIELDING_LAYER,
											LocalStrings.TEACH_CLICK_GAME_USE_FURY,
											CellDialog.DIR_UP,-1,NULL,NULL,-30,0)
	local conSize = readyGameElement:getContentSize()
	WindowManager:removeTeachTouchLayer()
	local conSize = readyGameElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(readyGameElement, GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))
	--self:addLightImg("common/animation/button_9_an.png",readyGameElement,0,-0.07,nil,nil)	
	self:addLightImg("common/animation/button_6_an.png",readyGameElement,0,-0.07,nil,nil)	
	self:adjustTeachImgAndLayer(readyGameElement,0.4,0.5)
end 



--@brief 新手指引23：你有已完成的任务，快点击查看已完成的任务吧
function TeachFollowingFiveLevel:newerTeachStepTwentyThree()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepTwentyThree()----------------------------")
	--任务按钮
	local taskBtnElement = GetTeachElementById(TeachIdDefine.TEACH_ISLAND,TeachIdDefine.ISLAND_TASK)
	--弹出“你有已完成的任务快点击查看已完成的任务吧！”
	if taskBtnElement == nil then 
		self:getElementError("step 23 taskBtnElement")
		return
	end 
	POP_DIALOG_TEACH = CellDialog:addDialog(taskBtnElement,SHIELDING_LAYER,LocalStrings.TEACH_LOOK_FINISH_TASK,
											CellDialog.DIR_UP,-1,NULL,NULL,-30,-5)
	WindowManager:removeTeachTouchLayer()
	local conSize = taskBtnElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(taskBtnElement,GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))		
	self:addLightImg("common/animation/button_9_an.png",taskBtnElement,0,-0.05)
end 



--@brief 新手指引24：领取使用特技奖励
function TeachFollowingFiveLevel:newerTeachStepTwentyFour()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepTwentyFour()----------------------------")
	local getRewardElement = GetTeachElementById(TeachIdDefine.TEACH_TASK,TeachIdDefine.TASK_GET_REWARD) 
	WZLog("getRewardElement = ",getRewardElement)
	if getRewardElement == nil then 
		self:getElementError("step 24 getRewardElement")
		return 
	end 
	self:cannotVerticalMove()
	POP_DIALOG_TEACH = CellDialog:addDialog(getRewardElement,SHIELDING_LAYER,LocalStrings.TEACH_REWARD_SPC_AWARD,
											CellDialog.DIR_LEFT,-1,NULL,NULL,0,0)
	WindowManager:removeTeachTouchLayer()
	local conSize = getRewardElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(getRewardElement, GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))		
	self:addLightImg("common/animation/button_1_an.png",getRewardElement,0,-0.08,0.52,1)	
end 


--@brief 新手指引25：点击关闭任务，返回小岛
function TeachFollowingFiveLevel:newerTeachStepTwentyFive()
	WZLog("-------------TeachFollowingFiveLevel:newerTeachStepTwentyFive()--------------------------")
	--取得关闭按钮
	local closeElement = GetTeachElementById(TeachIdDefine.TEACH_TASK,TeachIdDefine.TASK_CLOSE) 
	if closeElement == nil then 
		--self:getElementError("step 25 closeElement")
		return 
	end 
	POP_DIALOG_TEACH = CellDialog:addDialog(closeElement,SHIELDING_LAYER,LocalStrings.TEACH_CLOSE_TASK,
											CellDialog.DIR_DOWN,-1,NULL,NULL,-35,5)
	WindowManager:removeTeachTouchLayer()
	local conSize = closeElement:getContentSize()
	WindowManager:addTeachTouchLayerForElement(closeElement, GlobalMethod:CCSize(conSize.width*0.96,conSize.height*0.96))	
	self:addLightImg("common/animation/close_an.png",closeElement,0,-0.06,nil,nil,10)
end 





--@brief	删除对话框的函数
function TeachFollowingFiveLevel:removeDialog()
    WZLog("gyq=========")
	if POP_DIALOG_TEACH ~= nil then 
         WZLog("gyq=========")
		POP_DIALOG_TEACH:removeFromParentAndCleanup(true)
        POP_DIALOG_TEACH = nil
	end 
end 



--@brief  手指拖动动画
function TeachFollowingFiveLevel:_setFingerAni( parentElement )
	if parentElement == nil then 
		WZLog("TeachFollowingFiveLevel:_setFingerAni( parentElement ) parentElement is nil")
		return 
	end 
	

	local armatureManager = CCArmatureDataManager:sharedArmatureDataManager()
	if armatureManager:getTextureData("teach002") == nil then
		armatureManager:addArmatureFileInfo("teach.png", "teach.plist", "teach.xml")
	end

	
	local fingerArmature = WZArmature:create()
	if fingerArmature ~= nil then 
		fingerArmature:setArmatureName("teach001")
		fingerArmature:setRelativePosition( GlobalMethod:ccp(0.45,0.22))
		fingerArmature:setUseOriginSize(true)
		parentElement:addChild(fingerArmature , 100000 )
		fingerArmature:play( 0 )
		self.m_fingerAni = fingerArmature
	end 

end


--@brief  删除手指拖动动画
function TeachFollowingFiveLevel:_removeFingerAni()
	if self.m_fingerAni ~= nil then 
		self.m_fingerAni:removeFromParentAndCleanup(true)
        self.m_fingerAni = nil
	end 
end 

--@brief  删除发光图片
function TeachFollowingFiveLevel:_removeLightImg()
	if LIGHT_IMAGE_ELEMENT ~= nil then 
		LIGHT_IMAGE_ELEMENT:removeFromParentAndCleanup(true)
        LIGHT_IMAGE_ELEMENT = nil
	end 
end 



--@brief	结束新手教程函数
function TeachFollowingFiveLevel:endNewerTeach(nStep)
	WindowManager:removeTeachShelterImg()
	self.m_root = nil 
end 



--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function TeachFollowingFiveLevel:new()
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	self.m_nFinishStep = g_nBELOW_FIVE_LEVEL_TEACH_Steps     --新手教学完成步骤
	self.m_root = nil 
	self.m_fingerAni = nil 
	self.pt = nil 
	self.m_nIds = nil 
	self.m_TouchFlag = false 
	return tNewObj
end


--@brief	删除本表的函数
function TeachFollowingFiveLevel:delete()
	self.m_nFinishStep = nil 
	self.m_root = nil 
	self.m_fingerAni = nil 
	self.pt = nil 
	self.m_nIds = nil 
	self.m_TouchFlag = nil
	--反注册协议组所有协议
	ProtocolProcessorTeach:unregAll()
	GlobalGame.g_bIfInTeaching = false
	g_nUpdateBoosRoomTime = nil 
end



--@brief 添加发光图片以及动作
--@param sImgPath   发光图片路径
--@param element    控件对象
--@param relX       相对父结点X轴
--@param relY       相对父结点Y轴
--@param picTimes   图片倍数
--@param zOrder     Z轴  
--@param nDuration  延时时间
function TeachFollowingFiveLevel:addLightImgPic(sImgPath,element,relX,relY,relWidht,relHeight,zOrder,nDuration)
	WZLog("TeachFollowingFiveLevel:addLightImg(sImgPath,element,relX,relY)")
	LIGHT_IMAGE_ELEMENT = WZUIImage:create()
	LIGHT_IMAGE_ELEMENT:setFile(sImgPath)
	local conSize = element:getContentSize()
	local resSize = element:getRelativeSize()
	local parentConSize = element:getParent():getContentSize()
	if relWidht == nil or relHeight == nil then 
		LIGHT_IMAGE_ELEMENT:setUseOriginSize(true)
	else 
		LIGHT_IMAGE_ELEMENT:setRelativeSize(GlobalMethod:CCSize(conSize.width/parentConSize.width+relWidht,
							conSize.height/parentConSize.height+relHeight))

	end 
	if nDuration == nil then 
		nDuration = 0.7
	end 

	local pos,pos1 = element:getRelativePosition()
	if zOrder ~= nil then 
		element:setZOrder(zOrder)
	else 
		zOrder = element:getZOrder()
	end 
	LIGHT_IMAGE_ELEMENT:setRelativePosition(GlobalMethod:ccp(pos.x+relX,pos.y+6/parentConSize.height+relY))
	LIGHT_IMAGE_ELEMENT:setZOrder(zOrder-1)
	element:getParent():addChild(LIGHT_IMAGE_ELEMENT)
	
	self:imgLightAction(LIGHT_IMAGE_ELEMENT,200,255,nDuration)
end 


--@brief	可触摸区域的触摸开始的函数
function TeachFollowingFiveLevel:imgTouchBeganFunction(element,pt)
	WZLog("TeachFollowingFiveLevel:touchBeganFunction()")
	self.pt = pt
end 


--@brief	可触摸区域的触摸移动的函数
function TeachFollowingFiveLevel:imgTouchMovedFunction(element,pt)
	WZLog("TeachFollowingFiveLevel:imgTouchMovedFunction()")
	--滚动容器
	local roolElement = GetTeachElementById(TeachIdDefine.TEACH_TASK,TeachIdDefine.TASK_ROLL) 
	if roolElement == nil then 
		return 
	end 
	local maxPt = roolElement:getMaxPosition()
	local moveElement = roolElement:getMoveElement()
	moveElement = WZUIMoveContainer:luaTo(moveElement)
	WZLog("moveElement = ",moveElement)
	local movePtX,movePtY = moveElement:getPosition()
	WZLog("movePtY = ",movePtY)
	WZLog("maxPt = ",maxPt.y)
	WZLog("movePtY = ",movePtY)

	if movePtY ~= nil then 
		if g_nBELOW_FIVE_LEVEL_TEACH_Steps  == TeachFollowingFiveLevelIdDefine.CLOSE_TASK 
			and math.abs(movePtY) >= 0.85*maxPt.y then 
			self:removeDialog()
			self:_removeFingerAni()
			self:newerTeachStepThree()
			g_nBELOW_FIVE_LEVEL_TEACH_Steps  = TeachFollowingFiveLevelIdDefine.GAMEHALL_ISEND
		end 
	end 

end 




--@brief	教学完成后删除掉教学完成画面（默认5秒）
function TeachFollowingFiveLevel:actionFinishCallBack(element)
	if NEWER_FINISH_ANI ~= nil then
		NEWER_FINISH_ANI:removeFromParentAndCleanup(true)
		WindowManager:removeTeachShelterLayer()
		SHIELDING_LAYER = nil    		 --遮挡层
		POP_DIALOG_TEACH = nil   		 --弹出对话框
		LIGHT_IMAGE_ELEMENT = nil   	 --发光图片
		NEWER_FINISH_ANI = nil      	 --新手教学完成对象
		TeachFollowingFiveLevel_MODEL_SEL_NUM = nil 
		REWARD_CLOTHES_BTN_FLAG = nil  --邻取换装奖励按钮标记
		g_bTeachFollowingFiveLevelFinishFlag = nil 
		if SceneIsland.m_root ~= nil then 
			local imgELement = SceneIsland.m_root:getChildElement("imgOpacity99999999")
			if imgELement ~= nil then 
				imgELement:removeFromParentAndCleanup(true)
			end 
		end 
		GlobalGame.g_bIfInTeaching = false 
	end 
end 


--@brief	获取教学控件失败时函数
function TeachFollowingFiveLevel:getElementError(sString)
	if sString == nil then 
		return 
	end 
	if g_nBELOW_FIVE_LEVEL_TEACH_Steps == nil then 
		g_nBELOW_FIVE_LEVEL_TEACH_Steps = 100000
	end 
	MsgBoxManager:showTipBox(g_nBELOW_FIVE_LEVEL_TEACH_Steps .. " : " .. sString)
	WindowManager:removeTeachShelterLayer()
	SHIELDING_LAYER = nil    		 --遮挡层
	GlobalGame.g_bIfInTeaching = false 
end 


--------------------------------------------End--------------------------------------------------


