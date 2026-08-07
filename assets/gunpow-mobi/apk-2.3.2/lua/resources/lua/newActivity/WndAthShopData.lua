--WndAthShopData.lua
--@brief	WndAthShop的数据模块
--@date		2015-6-8
--@author	binshao
--@note		竞技场商店Wnd

WndAthShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAthShop:_init()
	self.m_root = nil	 	    -- 场景根节点
    self.m_sDesc = nil 
    self.m_tRewardIdsData = nil 
    self.m_sTitleName = nil
    self.m_tOtherData = nil           -- 当前选中的cell
    self.m_tClickCell = nil 
    self.m_tSelCell = nil 			  --选中的一个奖励
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAthShop:_unInit()
	self.m_root = nil
    self.m_sDesc = nil 
    self.m_tRewardIdsData = nil 
    self.m_sTitleName = nil
    self.m_tOtherData = nil           -- 当前选中的cell
    self.m_tClickCell = nil 
    self.m_tSelCell = nil 			  --选中的一个奖励
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAthShop:createElement()
	local element = WZUISystem:getInstance():createElement("WndAthShop")
	assert(element, "WndAthShop create element failed!")
	self:_init()
	WZLog("---------------create----WndAthShop------------------------------------")
	return element
end

function WndAthShop:showInterface(desc, reward_ids, title_name, otherData)
	local wndReward = WndAthShop:createElement()
	if wndReward then 
	    WndAthShop:setData(desc, reward_ids, title_name, otherData)
	    WindowManager:addWindow(wndReward, WndAthShop, nil, nil, nil, true)
	end
end

function WndAthShop:setData(desc, reward_ids, title_name, otherData)
	self.m_sDesc = desc or ""
	self.m_tRewardIdsData = reward_ids or {}
	self.m_sTitleName = title_name or LocalStrings.TREASURE_TEXT4
	self.m_tOtherData = otherData or {}
	WZLog("WndAthShop:setData")
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------