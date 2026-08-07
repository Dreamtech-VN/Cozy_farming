--WndOpenCardBoxData.lua
--@brief	WndOpenCardBox的数据模块
--@date		2016/07/27
--@author	Tianxiang_Xu
--@note		打开卡套界面

WndOpenCardBox = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndOpenCardBox:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tData = nil 
    self.m_nTime = nil 
    self.m_nCaculateTime = 0 
    self.m_nLoadingId = nil 
    self.m_nLeftOpenTimes = nil 
    self.m_nMySimpleCopyId = nil 
    self.m_nTempLocalTime = nil 
    self.m_bIsOpening = false       --是否正在打开
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndOpenCardBox:_unInit()
	self.m_root = nil
    self.m_tData = nil 
    self.m_nTime = nil
    self.m_nCaculateTime = nil 
    self.m_nLoadingId = nil 
    self.m_nLeftOpenTimes = nil 
    self.m_nMySimpleCopyId = nil 
    self.m_nTempLocalTime = nil 
    self.m_bIsOpening = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndOpenCardBox:createElement()
	local element = WZUISystem:getInstance():createElement("WndOpenCardBox")
	assert(element, "WndOpenCardBox create element failed!")
	self:_init()
	return element
end

--@brief    设置数据
--@param    tData:卡套的数据
--@param    nTimes:时间
--@param    leftTimes:剩余购买次数
function WndOpenCardBox:setData(tData, nTimes, leftTimes)
    -- body
    self.m_tData = tData
    self.m_nTime = nTimes
    self.m_nLeftOpenTimes = leftTimes
end

--@brief    外部接口
--@param    leftTimes:剩余购买次数
function WndOpenCardBox:showInterface(tData, nTimes, leftTimes)
    -- body
    if self.m_root then
        self.m_root:removeFromParentAndCleanup(true)
    end

    local wndCardBox = WndOpenCardBox:createElement()
    if wndCardBox then
        self.m_tData = tData
        self.m_nTime = nTimes
        self.m_nLeftOpenTimes = leftTimes
        WindowManager:addWindow(wndCardBox, WndOpenCardBox)
    end
end

--@brief    去掉不让打开限制
function WndOpenCardBox:setOpenTab(bBool)
    -- body
    self.m_bIsOpening = bBool 
end

--@brief    加速成功
function WndOpenCardBox:speedUpOk(cdTime)
    -- body
    self.m_nTime = cdTime
    self:_refreshTime()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    数据加载动画
function WndOpenCardBox:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndOpenCardBox:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end

--@brief    根据item_id 和等级获取卡牌id
function WndOpenCardBox:_getCardId(itemId, level)
    -- body
    for idx, value in pairs(GDatatab_card_property) do
        if value.item_id == itemId and value.level == level then
            return value.id
        end
    end

    return nil 
end


-------------------------------------私有方法模块End----------------------------------------
