--WndDressListData.lua
--@brief	WndDressList的数据模块
--@date		2015/07/02
--@author	zsq
--@note		背包时装列表

WndDressList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDressList:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDataList = nil
	self.m_tDressList = nil
	self.m_nDressNum = 0
	self.m_tTryWearList = nil			--试穿列表
	self.m_tTempList = nil
	self.m_nStartIndex = nil
	self.m_tTryWearGrid = nil
	self.m_nMaxFight = nil
	self.m_tMaxFightGrid = nil
	self.m_nBackTag = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDressList:_unInit()
	self.m_root = nil
	self.m_tDataList = nil
	self.m_tDressList = nil
	self.m_nDressNum = nil
	self.m_tTryWearList = nil			--试穿列表
	self.m_tTempList = nil
	self.m_nStartIndex = nil
	self.m_tTryWearGrid = nil
	self.m_nMaxFight = nil
	self.m_tMaxFightGrid = nil
	self.m_nBackTag = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDressList:createElement()
	local element = WZUISystem:getInstance():createElement("WndDressList")
	assert(element, "WndDressList create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	缓存推送更新物品时调用的函数
function WndDressList:updatePlayerItemData()
	WZLog("WndDressList:updatePlayerItemData")
	--self.m_tTryWearList = nil
	if WndBag.m_bOpenStrengthen == true then return end
	if self.m_root ~= nil and Wndwardrobe.m_root ~= nil then
		self:updateDress()
	end
end




-------------------------------------私有方法模块End----------------------------------------
