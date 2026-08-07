--WndVipGiftData.lua
--@brief	WndVipGift的数据模块
--@date		2017-1-13
--@author	mjf
--@note		VIP模块

WndVipGift = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndVipGift:_init()
	self.m_root = nil	 	  	 --场景根节点
    self.m_tData = nil
    self.sdkData = nil
    self.m_sPushInfo = nil      --新手定推的ID数据
    self.m_Count = nil          --礼包的数量
    self.m_nType = 0            --类型：默认充值界面；2：新手定推礼包
    self.m_nLoadingId = nil 
    self.m_sOriginPrice = nil 
    self.m_nFuncId = nil 
    self.m_nEndTime = nil 
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndVipGift:_unInit()
    self.m_root = nil
    self.m_tData = nil
    self.sdkData = nil
    self.m_sPushInfo = nil 
    self.m_Count = nil 
    self.m_nType = nil 
    self.m_nLoadingId = nil 
    self.m_sOriginPrice = nil 
    self.m_nFuncId = nil 
    self.m_nEndTime = nil 
end

function WndVipGift:setData(data, sdkData)
    -- reward = "[165,10]&[110,5]&[165,10]"
    WZLog("WndVipGift:setData")
    self.m_tData = data
    self.sdkData = sdkData
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndVipGift:createElement()
	local element = WZUISystem:getInstance():createElement("WndVipGift")
	assert(element, "WndVipGift create element failed!")
    Teach.PreUIChannelId = GlobalGame.g_nCurrentUIChannelId
	self:_init()
	return element
end

--@brief    外部接口
function WndVipGift:showInterface(pushInfo, count, nType, originPrice, funcId, endTime)
    -- body
    WZLog("WndVipGift:showInterface", Serialize(pushInfo), nType)
    if pushInfo == nil or #pushInfo == 0 then return end 
    local wndVipGift = WndVipGift:createElement()
    if wndVipGift then 
        self.m_sPushInfo = pushInfo 
        self.m_Count = count 
        self.m_nType = nType or 0
        self.m_sOriginPrice = originPrice 
        self.m_nFuncId = funcId 
        self.m_nEndTime = endTime 
        WindowManager:addWindow(wndVipGift, WndVipGift, false)
    end
end

--@brief    购买礼包成功、
function WndVipGift:buyResult(itemId, count)
    -- body
    self:_stopLoading()
    WZLog("WndVipGift:buyResult")
    if self.m_tData then 
        --更新剩余次数
        if self.m_tData.giftType == 1 then 
            local tTempData = GDatatab_recharge["id_" .. self.m_tData.id]
            if tTempData and tTempData.item_id == itemId then
                if self.m_tData.leftTimes ~= -1 and self.m_tData.leftTimes >= count then 
                    self.m_tData.leftTimes = self.m_tData.leftTimes - count
                    WZLog("WndVipGift:buyResult 111111")
                    local str = string.format(LocalStrings.BUY_GIFT_LIMIT1, self.m_tData.leftTimes)
                    local txtMoney = GetElement(self.m_root, "txtRemain_WndVipGift", WZUIFreeTextBox)
                    txtMoney:setShowText(str)

                    --更新缓存中礼包的数量
                    local tCount = {}
                    table.insert(tCount, self.m_tData.leftTimes)
                    CacheCenter:updateNewUserPackageList(self.m_nFuncId, nil, tCount, nil, nil)
                end
            end
        else
            if self.m_tData.leftTimes ~= -1 and self.m_tData.leftTimes >= 1 then 
                self.m_tData.leftTimes = self.m_tData.leftTimes - 1

                local str = string.format(LocalStrings.BUY_GIFT_LIMIT1, self.m_tData.leftTimes)
                local txtMoney = GetElement(self.m_root, "txtRemain_WndVipGift", WZUIFreeTextBox)
                txtMoney:setShowText(str)

                --更新缓存中礼包的数量
                local tCount = {}
                table.insert(tCount, self.m_tData.leftTimes)
                CacheCenter:updateNewUserPackageList(self.m_nFuncId, nil, tCount, nil, nil)
            end
        end
    end
end

--@brief    数据加载动画
function WndVipGift:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndVipGift:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end
---------------------------------------------------------------------------------------------------------------------------
