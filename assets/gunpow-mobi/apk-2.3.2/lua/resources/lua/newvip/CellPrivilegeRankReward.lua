--CellPrivilegeRankReward.lua
--@brief	CellPrivilegeRankReward的UI模块
--@date		2021/04/07
--@author	hyx
--@note		名人榜奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPrivilegeRankReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPrivilegeRankReward:onExit(element)
	self:_unInit()
end

function CellPrivilegeRankReward:onEnterTransitionDidFinish(element)
	local rewardRankList = GetElement(self.m_root,"rewardRankList",WZUIFreeListContainer)
	rewardRankList:removeAll()

	local data_info = SystemTime:getTimeTabelByServerTimestamp(SystemTime:getServerTime())
	local data = self:setRankRewardData( data_info.month, data_info.day )

	local rank = CellPrivilegeRank:getMyRank()
	GetElement(self.m_root,"txtMyRank",WZUILabelTTF):setText(rank)
	for i=1,#data do
		local element, tLuaObj = PrivilegeRankItem:createElement()
		rewardRankList:pushBack(WZUIContainer:luaTo(element))
		rewardRankList:getMoveElement():setPositionY(rewardRankList:getMinPosition().y)
		tLuaObj:setRankItemData(2, data[i])
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
