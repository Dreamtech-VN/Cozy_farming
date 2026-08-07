--WndAthBuyData.lua
--@brief	WndAthBuy的数据模块
--@date		2015-6-8
--@author	binshao
--@note		竞技场商店Wnd

WndAthBuy = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAthBuy:_init()
	self.m_root = nil	 	    -- 场景根节点
    self.tData = {}
	self.m_nType = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAthBuy:_unInit()
	self.m_root = nil
    self.tData = nil
	self.m_nType = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAthBuy:createElement()
	local element = WZUISystem:getInstance():createElement("WndAthBuy")
	assert(element, "WndAthBuy create element failed!")
	self:_init()
	WZLog("---------------create----WndAthBuy------------------------------------")
	return element
end

--@brief	设置数据
--@param	data:商品数据
--@param	nType:商品类型默认竞技商店，1:公会商店
function WndAthBuy:SetData(data, nType)
	self.m_nType = nType or 0
    self.tData = data
    self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

