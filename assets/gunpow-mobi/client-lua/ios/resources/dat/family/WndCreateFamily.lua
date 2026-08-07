--WndCreateFamily.lua
--@brief	WndCreateFamily的UI模块
--@date		2017/07/25
--@author	Tianxiang_Xu
--@note		创建家园窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCreateFamily:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCreateFamily:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndCreateFamily:onEnterTransitionDidFinish(element)
    -- body
    ProtocolProcessorFamily:regAll()

    local sCost = CacheCenter:getGameParam()["homeCreateCost"]
    WZLog("WndCreateFamily:onEnterTransitionDidFinish", sCost)
    local ids, nums = SplitItemString(sCost)
    self.m_tCost = {}
    self.m_tCost.id = tonumber(ids[1])
    self.m_tCost.costNum = tonumber(nums[1])

    self:_update()
end

--@brief    点击确定按钮回调
function WndCreateFamily:onCreate(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if not JudgeMoneyIsEnough(self.m_tCost.id, self.m_tCost.costNum, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToCreate) then
        return 
    end

    self:sureToCreate()
end

--@brief    确认创建家园
function WndCreateFamily:sureToCreate()
    -- body
    --发送创建家园的协议创建家园
    ProtocolProcessorFamily:send_HOME_CreateHome()
end

--@brief    点击關閉按钮回调
function WndCreateFamily:onCancel(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    ProtocolProcessorFamily:unregAll()
    WindowManager:removeWindow(self.m_root, self, true)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function WndCreateFamily:_update()
    -- body
    local ftxtCost = GetElement(self.m_root, "ftxtCost_WndCreateFamily", WZUIFreeTextBox)
    local iconPath = GDatatab_item["id_" .. self.m_tCost.id].icon
    if ftxtCost then
        ftxtCost:setShowText(string.format(LocalStrings.FAMILY_TEXT2, iconPath, self.m_tCost.costNum))
    end
end




-------------------------------------私有方法模块End----------------------------------------

function WndCreateFamily:_adaptLanguage_en(  )
    local ftxtCost = GetElement(self.m_root, "ftxtCost_WndCreateFamily", WZUIFreeTextBox)
    ftxtCost:setMaxWidth(320)
end