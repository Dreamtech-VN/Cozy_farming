--SceneTeachBattleData.lua
--@brief	SceneTeachBattle的数据模块
--@date		2013/2/24
--@author	Zjh
--@note		战斗教学界面

SceneTeachBattle = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneTeachBattle:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tBulletCache = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneTeachBattle:_unInit()
	if self.m_root then
		self.m_root:disableSchedule()
	end
	self.m_loop = nil
	self.m_touch = nil
	self.m_pointsLine = nil
	self.m_root = nil
	TeachBattle:endTeach()
	MsgManager:clear()
	BattleMapManager:clear()
	BattleShowHeroUse:removeHeroUse()
	--CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
	CCArmatureDataManager:sharedArmatureDataManager():removeAll()
	GlobalGame:setIfInBattle(false)
    self.m_tBulletCache = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneTeachBattle:createElement()
	local element = WZUISystem:getInstance():createElement("SceneTeachBattle")
	assert(element, "SceneTeachBattle create element failed!")
	self:_init()
	self.m_root = element
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
