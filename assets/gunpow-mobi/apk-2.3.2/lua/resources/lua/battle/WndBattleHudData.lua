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
		[1]="face10",
		[2]="face20",
		[3]="face30",
		[4]="face40",
		[5]="face50",
		[6]="face60",
		[7]="face70",
		[8]="face80",
		[9]="face90",
		[10]="face100",
		[11]="face110",
		[12]="face120",
		[13]="face130",
		[14]="face140",
		[15]="face150",
		[16]="face160",
		[17]="face170",
		[18]="face180",
		[19]="face190",
		[20]="face200",
		[21]="face210",
		[22]="face220",
		[23]="face230",
		[24]="face240",
		[25]="face250",
		[26]="face260",
		[27]="face270",
		[28]="face280",
		[29]="face290",
		[30]="face300",
		[31]="face310",
		[32]="face320",
		[33]="face330",
		[34]="face340",
		[35]="face350",
		[36]="face360",
		[37]="face370",
		[38]="face380",
		[39]="face390",
		[50]="face500",
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
    self.m_tBuffIconList = {}
    self.m_tDebuffIconList = {}
    self.m_tGoodbuffIconList = {}
    self.m_tBubbleElement = nil
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
    self.m_nBigSkillIndex = 1 			--大招索引：1->武器大招；2->皮肤大招
    self.m_tDialog2 = nil 
    self.m_tWindConfig = nil 
    self.m_tKMSkillTouchMark = {}   		--辅助技能图标是否可以触摸标识
    self.m_tUseKMSkill = {1,1,1,1,1,1} 		--辅助技能使用状态标识
    self.m_sEffectType = nil 			--风向类型  32_1  32_2

    self.m_tBigSkillItemList = {} 			--大招节点列表

    self.m_bCloseSkinSkillSwitch = nil 	--是否关闭可以切换非默认皮肤大招的功能

    self.m_tBrightnessElement = {}   --存放阴影中的高亮元素
    self.m_tBtnEnemyElement = {} 	 --存放阴影中敌人位置按钮
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
    self.m_tBuffIconList = nil
    self.m_tDebuffIconList = nil
    self.m_tGoodbuffIconList = nil
    self.m_tBubbleElement = nil
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
    self.m_nBigSkillIndex = nil 			--大招索引：1->武器大招；2->皮肤大招
    self.m_tDialog2 = nil 
    self.m_tWindConfig = nil 
    self.m_tKMSkillTouchMark = nil 
    self.m_tUseKMSkill = nil 
    self.m_sEffectType = nil 	

    self.m_tBigSkillItemList = nil

    self.m_bCloseSkinSkillSwitch = nil 	--是否关闭可以切换非默认皮肤大招的功能

    self.m_tBrightnessElement = nil
    self.m_tBtnEnemyElement = nil
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

	for id, chara in pairs(WBattleGlobal:getCurrent():getHeroList()) do
		if chara.m_ghostSkillSpineBoxData and chara.m_ghostSkillSpineBoxData.uniqueId == uniqueId then 
			chara.m_ghostSkillSpineBoxData = nil 
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

--@brief 	获取地图中的宝箱
function WndBattleHud:getGhostSkillBoxInMap()
	-- body
	return self.m_tTotalGhostSkill
end

--@brief    设置单人副本风向数据
function WndBattleHud:setWindData(skillId, effectParam)
    -- body
    WZLog("WndBattleHud:setWindData", skillId, effectParam)
    self.m_nWindSkillId = skillId
    self.m_sEffectType = effectParam[3] .. "_" .. effectParam[4]
    self.m_tWindConfig = {effectParam[5], effectParam[6]}
    self.m_nWindSkillBuffTime = effectParam[7]
end

--@brief 	获取风向位置坐标
function WndBattleHud:getWindPos()
	-- body
	local btnWind = GetElement(self.m_root, "btnWind_WndBattleHud", WZUIButton)
	local pos = btnWind:convertToWorldSpace(GlobalMethod:ccp(0,0))
	local targetPos = SceneBattle:getFrontLayer():convertToNodeSpace(pos)

	return targetPos 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------



-------------------------------------私有方法模块End----------------------------------------
