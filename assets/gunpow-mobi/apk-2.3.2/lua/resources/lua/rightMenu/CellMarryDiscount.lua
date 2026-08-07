--CellMarryDiscount.lua
--@brief	CellMarryDiscount的UI模块
--@date		2016/07/25
--@author	Tianxiang_Xu
--@note		结婚打折活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMarryDiscount:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    --20221121 nijinlin 获取婚姻关系状态
    WndMarryManager:setIsRefreshData(false)
    ProtocolProcessorWndMarry:send_WEDDING_GetMaritalStatus()
    WndMarryManager:createLoading()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMarryDiscount:onExit(element)
	self:_unInit()
end

--@brief    点击前往按钮回调
function CellMarryDiscount:onGotoEvent(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndGameActivity:closeGameActivity()
    
    WndFriends:showInterface(12)
end

--@brief    展示
function CellMarryDiscount:showWindow()
    -- body
    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief     更新界面信息
function CellMarryDiscount:_update()
    local txtTimeWords = GetElement(self.m_root, "txtTimeWords_CellMarryDiscount", WZUILabelTTF)
    if not txtTimeWords then return end

    -- body
    local startDate = os.date("*t", self.m_nStartTime)
    local endDate = os.date("*t", self.m_nEndTime)
    txtTimeWords:setText(LocalStrings.ACTIVE_TIME .. ":")
    local txtTime = GetElement(self.m_root, "txtTime_CellMarryDiscount", WZUILabelTTF)
    txtTime:setText(string.format(LocalStrings.ACTIVITYTIME_FORMAT, startDate.month, startDate.day, startDate.hour, startDate.min, endDate.month, endDate.day, endDate.hour, endDate.min))
end




-------------------------------------私有方法模块End----------------------------------------

--@brief 英文适配函数
--@note  英文适配
function CellMarryDiscount:_adaptLanguage_en()
    local txtBtn = GetElement(self.m_root, "txtBtn_CellMarryDiscount", WZUILabelTTF)
    if txtBtn then
        txtBtn:setScale(0.72)
    end
    
    local txtDis = GetElement(self.m_root,"txtDis_CellMarryDiscount",WZUILabelTTF)
    txtDis:setFontSize(20)

end

function CellMarryDiscount:_adaptLanguage_pt(  )
    local txtBtn = GetElement(self.m_root, "txtBtn_CellMarryDiscount", WZUILabelTTF)
    if txtBtn then
        txtBtn:setScale(0.72)
    end
    
    local txtDis = GetElement(self.m_root,"txtDis_CellMarryDiscount",WZUILabelTTF)
    txtDis:setFontSize(20)

    GetElement(self.m_root,"txtTime_CellMarryDiscount",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.43,0.5))
end

function CellMarryDiscount:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtTime_CellMarryDiscount",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end