--GoodsFullData.lua
--@brief	GoodsFull的数据模块
--@date		2016/05/19
--@author	qixiang_xie
--@note		装备抽奖大全

WndGoodsFull = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGoodsFull:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nType = nil                  --类型，2->砸蛋活动奖励预览；默认物品大全
    self.m_tRewardList = nil 
    self.m_equiitemId = {}              --玩家获得过的装备Id
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndGoodsFull:_unInit()
    self.m_root = nil
    self.m_nType = nil 
    self.m_tRewardList = nil 
    self.m_equiitemId = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGoodsFull:createElement()
	local element = WZUISystem:getInstance():createElement("WndGoodsFull")
	assert(element, "WndGoodsFull create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
function WndGoodsFull:showInterface(nType)
    -- body
    local wndGoodsFull = WndGoodsFull:createElement()
    if wndGoodsFull then 
        self.m_nType = nType 
        WindowManager:addWindow(wndGoodsFull, WndGoodsFull, nil, nil, nil, true)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
