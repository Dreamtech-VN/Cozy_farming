--WndCollectRewardList.lua
--@brief	WndCollectRewardList的UI模块
--@date		2017/09/27
--@author	Tianxiang_Xu
--@note		众筹获奖名单


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCollectRewardList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCollectRewardList:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndCollectRewardList:onEnterTransitionDidFinish(element)
    -- body
    self:_createLoading()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetGrowdfundingLog( )
end

--@brief    点击关闭按钮回调
function WndCollectRewardList:onCloseClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WindowManager:removeWindow(self.m_root, self, true)
end

function CellCollectRewardLog:setData(tData)
    -- body
    self.m_tLogData = tData 
end

--@brief    加载日志
function CellCollectRewardLog:onLoadData(element)
    -- body
    element = WZUIContainer:luaTo(element)

    local ftxtLog = WZUIFreeTextBox:create()
    ftxtLog:setMaxWidth(700)
    ftxtLog:setAnchorPoint(GlobalMethod:ccp(0, 0.5))
    ftxtLog:setRelativePosition(GlobalMethod:ccp(0.05, 0.5))
    ftxtLog:setShowText(string.format(LocalStrings.MANYCOLLECT_TEXT13, self.m_tLogData.name, self.m_tLogData.date))
    element:addChild(ftxtLog)

    if ProjConfig.LANGUAGE == "vn" then
        ftxtLog:setMaxWidth(1000)
        ftxtLog:setScale(0.8)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    创建日志列表
function WndCollectRewardList:_createLogList()
    -- body
    local tableLogList = GetElement(self.m_root, "tableLogList_WndCollectRewardList", WZUITableContainer)
    tableLogList:cleanTable()

    local conForList = GetElement(self.m_root, "conForList_WndCollectRewardList", WZUIContainer)
    if #self.m_tLogList == 0 then 
        ShowPanelNullTip( conForList, LocalStrings.MANYCOLLECT_TEXT12)
        return 
    end
    removeShowPanelNullTip(conForList)

    for i = 1, #self.m_tLogList do 
        local element, tNewObj = CellCollectRewardLog:createLogElement()
        if element and tNewObj then 
            tNewObj:setData(self.m_tLogList[i])
            element:setTag(i - 1)

            tableLogList:setCellElement(element)
        end
    end
end

-------------------------------------私有方法模块End----------------------------------------
