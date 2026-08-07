--WndBattleHudData.lua
--@brief	WndBattleHud的数据模块
--@date		2013/1/16
--@author	Zjh
--@note		战斗Hud界面

WndBattleHud = {
	--请不要在这里定义变量
	
	SKILL_ITEM_LOCK_PATH = "ui/common/common_icon_suo.png",
	
	FACE_INDEX =
	{
		--[[
		"biaoqing_daxiao",
		"biaoqing_tiaopi",
		"biaoqing_liuhan",
		"biaoqing_touxiao",
		"biaoqing_baibai",
		"biaoqing_qiaoda",
		"biaoqing_chahan",
		"biaoqing_daku",
		"biaoqing_sese",
		"biaoqing_haixiu",
		"biaoqing_deyi",
		"biaoqing_weixiao",
		"biaoqing_nuhuo",
		"biaoqing_kongju",
		"biaoqing_yiwen",
		"biaoqing_qinqin",
		"biaoqing_yinxiao",
		"biaoqing_fadai",
		"biaoqing_bishi",
		"biaoqing_yun",
		"biaoqing_kelian",
		"biaoqing_koubi",
		"biaoqing_guzhang",
		"biaoqing_jingxia",
		]]
		"face10",
		"face20",
		"face30",
		"face40",
		"face50",
		"face60",
		"face70",
		"face80",
		"face90",
		"face100",
		"face110",
		"face120",
		"face130",
		"face140",
		"face150",
		"face160",
		"face170",
		"face180",
		"face190",
		"face200",
		"face210",
		"face220",
		"face230",
		"face240",
		
	}
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBattleHud:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nTurnTime = 0
	self.m_nTurnTime_Encrypt = nil
	self.m_bMyHudShow = false
	self.m_tMyHero = nil
	self.m_tUseItem = {1,1,1,1,1,1}
	self.m_angerAnim = nil
	self.m_angerAnim2 = nil
	self.m_faceAnim = nil
	
	self.m_bShowMedalAnim = false
	self.m_tMedalAnimTarget = nil
	self.m_tGuideDialog = nil
	self.m_bPreviousHudStatus = nil
	self.m_setHudOpacityTimes = 0
	self.m_tSkillGuide = {}
    self.m_nStartTime = 0
	
	self.m_bStopTime = false
    self.m_nShowBigCtb = nil
    self.m_tMedalList = {}
    self.m_tButtonTipsAnim1 = nil
    self.m_tButtonTipsDialog1 = nil
    self.m_tButtonTipsAnim2 = nil
    self.m_tButtonTipsDialog2 = nil
    self.m_tButtonTipsAnim3 = nil
    self.m_tButtonTipsDialog3 = nil
    self.m_nUsePoint = 0
    self.m_bStopTimeTtf = nil
    self.m_nCanUsePlayer = 0

    self.m_nSpeakerState = 0
    self.m_nMicState = 0
    self.m_nVoiceTimer = 0
    self.m_bIsVoiceState = false
    self.m_bIsVoice = false
    self.m_tForbidMembers = {}
    self.m_nCanUsePlayer = 0
    self.m_tLine = nil 
    self.m_nAwakeSkillLevel = 1
    self.m_bIsUseInShootOrFly = false 	--是否在飞行或发射过程中使用觉醒技能

    self.m_tJumpTeachList = {}
    self.m_nTouchBeginTime = nil 		--触摸开始时间
    self.m_nTouchIndex = nil 			--触摸的技能或道具索引
    self.m_tSkillTouchMark = {}   		--武器技能图标是否可以触摸标识
    self.m_tItemTouchMark = {}   		--道具技能图标是否可以触摸标识
    self.m_tUseGhostSkill = {1,1,1}
    self.m_nGhostTargetId = nil 		--幽灵技能作用的玩家Id
    self.m_tTotalGhostSkill = nil 		-- 生成的幽灵技能
    self.m_tGhostSkillTouchMark = {}   	--幽灵技能图标是否可以触摸标识
    self.m_nWindSkillId = 0 			--当前使用的风向药剂Id
    self.m_nWindSkillBuffTime = 0 		--只针对单人副本
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBattleHud:_unInit()
	self.m_root = nil
	self.m_nTurnTime = 0
	self.m_nTurnTime_Encrypt = nil
	self.m_bMyHudShow = false
	self.m_tMyHero = nil
	self.m_tUseItem = nil
	self.m_angerAnim = nil
	self.m_angerAnim2 = nil
	self.m_faceAnim = nil
	
	self.m_bShowMedalAnim = false
	self.m_tMedalAnimTarget = nil
	self.m_tGuideDialog = nil
	self.m_bPreviousHudStatus = nil
	self.m_setHudOpacityTimes = 0
	
	self.m_tSkillGuide = nil
    self.m_nStartTime = 0
	
	self.m_bStopTime = false
    self.m_nShowBigCtb = nil
    self.m_tMedalList = nil

    self.m_tButtonTipsAnim1 = nil
    self.m_tButtonTipsDialog1 = nil
    self.m_tButtonTipsAnim2 = nil
    self.m_tButtonTipsDialog2 = nil
    self.m_tButtonTipsAnim3 = nil
    self.m_tButtonTipsDialog3 = nil
    self.m_nUsePoint = 0
    self.m_bStopTimeTtf = nil
    self.m_nCanUsePlayer = 0

    self.m_nSpeakerState = 0
    self.m_nMicState = 0
    self.m_nVoiceTimer = 0
    self.m_bIsVoiceState = false
    self.m_bIsVoice = false
    self.m_tForbidMembers = {}
    self.m_nCanUsePlayer = 0
    self.m_tLine = nil
    self.m_nAwakeSkillLevel = nil 
    self.m_bIsUseInShootOrFly = nil 

    self.m_tJumpTeachList = {}
    self.m_nTouchBeginTime = nil 		--触摸开始时间
    self.m_nTouchIndex = nil
    self.m_tSkillTouchMark = nil   		--武器技能图标是否可以触摸标识
    self.m_tItemTouchMark = nil   		--道具技能图标是否可以触摸标识
    self.m_tUseGhostSkill = nil
    self.m_nGhostTargetId = nil 
    self.m_tTotalGhostSkill = nil 		-- 生成的幽灵技能
    self.m_tGhostSkillTouchMark = nil 
    self.m_nWindSkillId = nil 
    self.m_nWindSkillBuffTime = nil 	--风向药剂剩余行动值
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBattleHud:createElement()
	local element = WZUISystem:getInstance():createElement("WndBattleHud")
	assert(element, "WndBattleHud create element failed!")
	self:_init()
	return element
end

--@brief 	获取使用觉醒技能的状态
function WndBattleHud:getUseAwakeSkillState()
	-- body
	return self.m_bIsUseInShootOrFly
end

--@brief 	设置使用觉醒技能的状态
function WndBattleHud:setUseAwakeSkillState(bValue)
	-- body
	if self.m_root == nil then return end 
	self.m_bIsUseInShootOrFly = bValue
end

--@brief 	设置地图幽灵技能数据
function WndBattleHud:setGhostSkillData(x, y, skillId, uniqueId, spineBox)
	-- body
	if self.m_tTotalGhostSkill == nil then 
		self.m_tTotalGhostSkill = {}
	end

	local tItem = {}
	tItem.x = x
	tItem.y = y
	tItem.skillId = skillId
	tItem.uniqueId = uniqueId
	tItem.spineBox = spineBox
	tItem.pickMark = false 		--标记未被拾取处理

	table.insert(self.m_tTotalGhostSkill, tItem)
end

--@brief 	移除地图幽灵技能数据
--@param 	uniqueId : 幽灵技能唯一Id
function WndBattleHud:removeGhostSkillData(uniqueId)
	-- body
	if self.m_root == nil then return end 
	if self.m_tTotalGhostSkill == nil or #self.m_tTotalGhostSkill == 0 then 
		return 
	end

	for i = 1, #self.m_tTotalGhostSkill do
		if self.m_tTotalGhostSkill[i].uniqueId == uniqueId then 
			table.remove(self.m_tTotalGhostSkill, i)
			break 
		end
	end
end

--@brief 	设置宝箱透明度
--@note 	玩家未死时候，宝箱半透明，死后设置为不透明
function WndBattleHud:setGhostBoxOpacity()
	-- body
	if self.m_root == nil then return end 
	if self.m_tTotalGhostSkill == nil or #self.m_tTotalGhostSkill == 0 then 
		return 
	end

	for i = 1, #self.m_tTotalGhostSkill do
		if self.m_tTotalGhostSkill[i].spineBox then 
			self.m_tTotalGhostSkill[i].spineBox:setOpacity(255)
		end
	end
end

--@brief 	设置幽灵标记
function WndBattleHud:setGhostSkillSign(nIndex, value)
	-- body
	if self.m_root == nil then return end 

	self.m_tUseGhostSkill[nIndex] = value
end

--@brief 	玩家死后，设置一个默认的选中的目标
function WndBattleHud:chooseOnePlayer()
	-- body
	if self.m_root == nil then return end 

	for i,hero in pairs(WBattleGlobal:getCurrent():getHeroList()) do
		if self.m_nGhostTargetId == nil and not hero.m_bIsDead then 
			self.m_nGhostTargetId = hero:getId()
			hero:setTargetMark(true)
			self:_setGhostTargetName(hero)
			break 
		end
	end
end

--@brief 	丢弃幽灵技能
function WndBattleHud:dropGhostSkillSuccess(playerId, uniqueId)
	-- body
	WZLog("WndBattleHud:dropGhostSkillSuccess", uniqueId)
	for i = 1, 3 do
        if WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.id[i] ~= nil and WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.skillUniqueId[i] == uniqueId then
            WBattleGlobal:getCurrent().m_tMyGhostSkill_Beginning.id[i] = 0
            break 
        end
    end
	WndBattleHud:resetGhostSkill()
end

--@brief	定时更新函数
--@param	dt:距离上一次调用的时间（秒）
--@note		由定时器调用
function WndBattleHud:pickGhostSkillUpdate(dt)
    --WZLog("WndBattleHud:pickGhostSkillUpdate zero")
    if self.m_root == nil then return end 
    local myHero = WBattleGlobal:getCurrent():getMyHero()
    if myHero and myHero:isDead() then
        local isCollision, uniqueId = self:checkCollision()
        if isCollision == true and uniqueId > 0 then
            ProtocolProcessorSceneBattle:send_BATTLE_GetGhostSkill(WBattleGlobal:getCurrent():getBattleId(), WBattleGlobal:getCurrent():getMyBattleId(), uniqueId)
        end
    end
end

--@brief	检测碰撞
--@param	hero:英雄
--@return	#1:true:撞了,false:没撞
--@return	#2:英雄
function WndBattleHud:checkCollision()
    --WZLog("WndBattleHud:checkCollision")
	local isCollision = false
	local uniqueId = 0
	if self.m_tTotalGhostSkill and #self.m_tTotalGhostSkill > 0 then 
		for i = 1, #self.m_tTotalGhostSkill do
			if self.m_tTotalGhostSkill[i] and not self.m_tTotalGhostSkill[i].pickMark then 
			    local x,y = self.m_tTotalGhostSkill[i].spineBox:getPosition()

			    local posV2 = Vector2:create(x,y)
			    local nScale = self.m_tTotalGhostSkill[i].spineBox:getScale()
			    local raduis = self.m_tTotalGhostSkill[i].spineBox:getContentSize().width * nScale * 2 / 5
		--	    WZLog("WndBattleHud:checkCollision", raduis, self.m_tTotalGhostSkill[i].spineBox:getContentSize().width, nScale)
			            
				local isCollisionInList = self:checkCollisionWithCharacterList(posV2, raduis)        
		        
				if not isCollision then
					isCollision = isCollisionInList
				end

				if isCollision then 
					uniqueId = self.m_tTotalGhostSkill[i].uniqueId
					self.m_tTotalGhostSkill[i].pickMark = true --防止一个宝箱多次请求拾取
					break 
				end
			end
		end
	end
    
	return isCollision,uniqueId
end

--@brief	检查碰撞
--@param	pos:位置
--@param	raduis:半径
--@param	charaList:列表
--@return	#1:true:撞了,false:没撞
--@return	#2:碰撞的人物列表
function WndBattleHud:checkCollisionWithCharacterList(pos,raduis)
	--WZLog("WndBattleHud:checkCollisionWithCharacterList")
	local isCollision = false
    local chara = WBattleGlobal:getCurrent():getMyHero()
    --检测与人物的碰撞
	if chara:isDead() then
		local charaPos = chara:getCenterPos()
		local charaRaidus = chara:getRadiusForBulletCollision()
		local collisionRang = chara:getCollisionRang()
        
		if  BattleCommon:checkCircleCollosion(pos,raduis,charaPos,charaRaidus) then
		--	WZLog("hero chara collosion")
			isCollision = true
		end
	end
    
	return isCollision
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
