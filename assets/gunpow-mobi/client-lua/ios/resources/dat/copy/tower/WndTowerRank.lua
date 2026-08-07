--WndTowerRank.lua
--@brief	WndTowerRank的UI模块
--@date		2015/04/28
--@author	xiaoyu_wu
-- modify   2015-7-3 binshao
--@note		爬塔副本排名窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTowerRank:onEnter(element)
	self.m_root = element
    self.m_bEnterAnimation = true
    AdaptLanguage(self)
end

----@brief onEnter函数执行完成回调
function WndTowerRank:onEnterTransitionDidFinish(element)
    self.m_oRankTableList = GetElement(self.m_root,"tbconList_WndTowerRank",WZUITableContainer)
   
    --WindowManagerAni:createAppearAction(self.m_root, true, "actionCallback", self)
    self:actionCallback()
end

----@brief    弹窗动画完成后的回调
function WndTowerRank:actionCallback(element, data)
	--初始化界面
    ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerRank()
    self.m_bEnterAnimation = false
end

--@brief  查看爬塔排行榜
function WndTowerRank:onTowerRankClick()
     SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_root:isVisible() then
        return
    else
        self.m_root:setVisible(true)
        WindowManager:removeWindow(WndTowerPreview:getRoot(),WndTowerPreview,true)
        --WndTowerPreview:getRoot():setVisible(false)
    end
end

--@brief 查看每日奖励
function WndTowerRank:onDailyReward()
    WZLog("WndTowerRank:onDailyReward")
     SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_root:isVisible() then
        WndTowerPreview:showWindow()
        self.m_root:setVisible(false)
        WindowManager:removeWindow(self.m_root,self,true)
        --WndTowerPreview:getRoot():setVisible(false)
        --WndTowerPreview:getRoot():setVisible(true)
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTowerRank:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndTowerRank:onClose(element)
    WZLog("WndTowerRank:onClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManagerAni:createDisappearAction(self.m_root, "onActionCallBack", self)
end

--@brief	动画播完后的回调
function WndTowerRank:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
    if WndTowerPreview:getRoot() then
        WindowManager:removeWindow(WndTowerPreview:getRoot(), WndTowerPreview, true)
    end
end

--@brief  加载爬塔副本列表
function WndTowerRank:loadRankListItem()
    WZLog("WndTowerRank:loadRankListItem")
    self.m_oRankTableList:cleanTable()
    -- local ttf = WZUILabelTTF:create()
    -- ttf:setText(LocalStrings.UP_TO_LOAD_MORE)
    -- ttf:setFontSize(22)
    -- ttf:setColor(GlobalMethod:ccc3(255,236,193))
    -- ttf:setUseOriginSize(true)
    -- self.m_oRankTableList:setBottomElementFunction("onPageDown")--设置BottomElement的Lua回调函数
    -- self.m_oRankTableList:setBottomNotice(LocalStrings.UP_TO_LOAD_MORE, LocalStrings.RELAX_TO_LOAD)
    -- self.m_oRankTableList:setEnableBottomElement(true)--设置BottomElement是否可用
    -- self.m_oRankTableList:setHideBottomElement(false)--设置bottomElement是否隐藏
    -- self.m_oRankTableList:setBottomElement(ttf)--设置容器的BottomElement对象
    self:createTenListInfo()
end

--@brief  向下拉加载更多数据
function WndTowerRank:onPageDown(element)
    WZLog("WndTowerRank:onPageDown")
    self.m_oRankTableList:setHideBottomElement(false)
    self:createTenListInfo()
end

--@brief    每次创建10个表项
function WndTowerRank:createTenListInfo()
    WZLog("********* WndTowerRank:createTenListInfo **************")
    for i=1,self.m_nRankListCount do
        self.m_nLoadCurIndex = self.m_nLoadCurIndex + 1
        local tempListItem = self.m_tData.playerInfo[i]
        local eCell,tCell = CellTowerRank:createElement()
        eCell:setTag(i-1)
        tCell:setData(tempListItem,self.m_nLoadCurIndex)
        self.m_oRankTableList:setCellElement(eCell)
    end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	初始化界面
function WndTowerRank:_update()
    if self.m_root == nil or self.m_tData == nil or self.m_bEnterAnimation == true then
        return
    end
    
    local txtLevel = GetElement(self.m_root, "txtLevel_WndTowerRank", WZUILabelTTF)
    local sName = self.m_tData.topFloor .. LocalStrings.TOWER_LEVEL2
    
    
    local txtRank = GetElement(self.m_root, "txtRank_WndTowerRank", WZUILabelTTF)
    local sRank = tostring(self.m_tData.myRank)
    if self.m_tData.myRank <= 0 then
        sRank = LocalStrings.NONE
    end
    txtRank:setText(sName)
    txtLevel:setText(sRank)

    if #self.m_tData.playerInfo > 0 then
        self:loadRankListItem()
    else
        local conNoMes= GetElement(self.m_root,"conNoMes_WndTowerRank",WZUIContainer)
        conNoMes:setVisible(true)
        ShowPanelNullTip(conNoMes,nil,nil,nil, 30, nil)
    end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Star--------------------------------------
function WndTowerRank:_adaptLanguage_en()
	GetElement(self.m_root,"txtReward22_WndTowerRank",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtArms22_WndTowerRank",WZUILabelTTF):setFontSize(16)
end

function WndTowerRank:_adaptLanguage_pt()
    GetElement(self.m_root,"txtReward22_WndTowerRank",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtArms22_WndTowerRank",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root, "txtLevel1_WndTowerRank", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.74,0.5))
end

function WndTowerRank:_adaptLanguage_vn()
    GetElement(self.m_root,"txtReward22_WndTowerRank",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtArms22_WndTowerRank",WZUILabelTTF):setFontSize(16)
end

function WndTowerRank:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtArms22_WndTowerRank",WZUILabelTTF):setFontSize(16)
end

function WndTowerRank:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtArms22_WndTowerRank",WZUILabelTTF):setFontSize(20)
end
-------------------------------------语言适配模块End--------------------------------------