--CellChallengeHall.lua
--@brief	CellChallengeHall的UI模块
--@date		2014/02/12
--@author	liangguang_long
--@note		挑战大厅


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellChallengeHall:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellChallengeHall:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置排行榜名次
function CellChallengeHall:_update()
	if self.m_root == nil then
		return
	end
	--	设置排行榜名次
	self:_setRankingRanks( self.m_sRanks )
	--	设置排行榜名称
	self:_setRankingName( self.m_sPlayerName )
	--	设置排行榜伤害输出
	self:_setRankingHurt( self.m_nHurt )
end

--@brief	设置排行榜名次
--@param	desc:显示排名
function CellChallengeHall:_setRankingRanks( desc )
	if self.m_root == nil then
		return
	end
	local txtRanks = self.m_root:getChildElement("txtRanks_CellChallengeHall")
	if txtRanks == nil then
		return
	end
	txtRanks = WZUILabelTTF:luaTo(txtRanks)
	txtRanks:setText( desc )
end

--@brief	设置排行榜名称
--@param	desc:显示文本内容，在这里是显示玩家名称
function CellChallengeHall:_setRankingName( desc )
	if self.m_root == nil then
		return
	end
	local txtPlayerName = self.m_root:getChildElement("txtPlayerName_CellChallengeHall")
	if txtPlayerName == nil then
		return
	end
	txtPlayerName = WZUILabelTTF:luaTo(txtPlayerName)
	txtPlayerName:setText( desc )
end

--@brief	设置排行榜伤害输出(文本转换后)
--@param	desc:显示文本内容，在这里是显示玩家的伤害
function CellChallengeHall:_setRankingHurt( desc )
	if self.m_root == nil then
		return
	end
	local txtPlayerHurt = self.m_root:getChildElement("txtPlayerHurt_CellChallengeHall")
	if txtPlayerHurt == nil then
		return
	end
	txtPlayerHurtll = WZUILabelTTF:luaTo(txtPlayerHurt)
	txtPlayerHurt:setText( desc )
end

-------------------------------------私有方法模块End----------------------------------------
