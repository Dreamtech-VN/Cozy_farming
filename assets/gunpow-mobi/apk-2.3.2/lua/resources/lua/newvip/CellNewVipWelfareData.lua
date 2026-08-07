--CellNewVipWelfareData.lua
--@brief	CellNewVipWelfare的数据模块
--@date		2021/03/22
--@author	hyx
--@note		贵族福利

CellNewVipWelfare = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellNewVipWelfare:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tWelfareTitleView = {}
	self.m_nCurTitleIndex = nil
	self.m_sGiftTabContainer = nil
	self.m_sRebateFreeList = nil
	self.m_sWeekGiftFreeList = nil
	self.loadingId_CellWelfare = nil
	self.loadingId_weekGift_CellWelfare = nil
	self.m_tTitleViewShow = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewVipWelfare:_unInit()
	self.m_root = nil
	self.m_tWelfareTitleView = {}
	self.m_nCurTitleIndex = nil
	self.m_sGiftTabContainer = nil
	self.m_sRebateFreeList = nil
	self.m_sWeekGiftFreeList = nil
	self.loadingId_CellWelfare = nil
	self.loadingId_weekGift_CellWelfare = nil
	self.m_tTitleViewShow = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellNewVipWelfare:createElement(index)
	if CellNewVipWelfare.m_root ~= nil then
		WindowManager:removeWindow(CellNewVipWelfare.m_root, CellNewVipWelfare, true)
	end
	local element = WZUISystem:getInstance():createElement("CellNewVipWelfare")
	assert(element, "CellNewVipWelfare create element failed!")
	self:_init()
	self:setJumpTitleIndex(index)
	return element
end

function CellNewVipWelfare:setJumpTitleIndex(index)
	self.m_nCurTitleIndex = index or 1
	if ProjConfig.LANGUAGE == "vn" then
		self.m_nCurTitleIndex = 2 --越南只有第2个标签
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
