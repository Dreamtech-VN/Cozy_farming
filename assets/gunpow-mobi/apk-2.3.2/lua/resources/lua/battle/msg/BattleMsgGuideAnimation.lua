--BattleMsgGuideAnimation.lua
--@brief	公会动画消息
--@date		2013/4/9
--@author	Zjh
--@note

--@brief	消息数据表
BattleMsgGuideAnimation = {
    m_sName = "BattleMsgGuideAnimation",
	m_guideContainer = nil,
	m_tAnims = nil,
	TOTAL_STEP = 2,		--总共的步骤数
	m_nStep = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgGuideAnimation:init()
	WZLog("BattleMsgGuideAnimation:init")
	self.m_guideContainer = WZUIContainer:create()
	
	self.m_nStep = 0
	self.m_tAnims = {}
	
	SceneBattle:getTopInfoLayer():addChild(self.m_guideContainer)
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgGuideAnimation:process()
	if self.m_nStep >= BattleMsgGuideAnimation.TOTAL_STEP then
		if self.m_guideContainer then
			self.m_guideContainer:removeFromParentAndCleanup(true)
			self.m_guideContainer = nil
		end
		return true
	end
	if #self.m_tAnims > 0 then
		for i = #self.m_tAnims,1,-1 do
			if self.m_tAnims[i]:isCurrentAnimationDone() then
				self.m_tAnims[i]:getAnimNode():removeFromParentAndCleanup(true)
				table.remove(self.m_tAnims,i)
				self.m_nStep = self.m_nStep + 1
			end
		end
	else
		local step = self.m_nStep + 1
		self:_addStep(step)
	end
	return false
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgGuideAnimation:done()
	WZLog("BattleMsgGuideAnimation:done")
	self.m_tAnims = nil
end

-------------------------------------私有方法模块--------------------------------------
--@brief	创建步骤操作
--@param	nStep,步骤
function BattleMsgGuideAnimation:_addStep(nStep)
	if nStep == 1 then
		
		local anim = BattleAnimation:createAnimation(IWCO_SHOPEFFICIENTS)
		anim:addAnimation("sociaty1",{},0.1,true)
		anim:getAnimNode():setPosition(0.5*SceneBattle:getTopInfoLayer():getContentSize().width,0.5*SceneBattle:getTopInfoLayer():getContentSize().height)
		self.m_guideContainer:addChild(anim:getAnimNode())
		anim:play("sociaty1",false)
		table.insert(self.m_tAnims,anim)
		
	elseif nStep == 2 then
		
		local anim = BattleAnimation:createAnimation(IWCO_SHOPEFFICIENTS)
		anim:addAnimation("sociaty2",{},0.1,true)
		anim:getAnimNode():setPosition(0.5*SceneBattle:getTopInfoLayer():getContentSize().width,0.5*SceneBattle:getTopInfoLayer():getContentSize().height)
		self.m_guideContainer:addChild(anim:getAnimNode())
		anim:play("sociaty2",false)
		table.insert(self.m_tAnims,anim)
		
		local text = WZUIImage:create()
		text:setFile("common/text/community_war_1.png")
		text:setZOrder(2)
		text:setUseOriginSize(true)
		self.m_guideContainer:addChild(text)
	
	end

end