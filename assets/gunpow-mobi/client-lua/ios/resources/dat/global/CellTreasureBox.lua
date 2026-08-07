--CellTreasureBox.lua
--@brief	CellTreasureBox的UI模块
--@date		2015/11/18
--@author	qixiang_xie
--@note		单人副本宝箱


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTreasureBox:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTreasureBox:onExit(element)
	self:_unInit()
end

--@brief  设置获取宝箱回调
function CellTreasureBox:setTreasureChestCallBack(callbackFun,callbackLua)
	self.m_tCallback = callbackLua
	self.m_tCallbackFun = callbackFun
end

--@brief  点击领取宝箱
function CellTreasureBox:onClickReward(element)
	if self.m_tCallback ~= nil then
		self.m_tCallbackFun(self.m_tCallback,element)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
