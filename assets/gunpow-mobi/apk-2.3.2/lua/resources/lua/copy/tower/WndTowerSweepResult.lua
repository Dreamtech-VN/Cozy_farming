--WndTowerSweepResult.lua
--@brief	WndTowerSweepResult的UI模块
--@date		2015/04/29
--@author	xiaoyu_wu
--@note		爬塔副本扫荡结果窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTowerSweepResult:onEnter(element)
	self.m_root = element
     AdaptLanguage(self)
end

----@brief onEnter函数执行完成回调
function WndTowerSweepResult:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

----@brief    弹窗动画完成后的回调
function WndTowerSweepResult:actionCallback()
	WZLog("WndTowerSweepResult:actionCallback")
	self:_initUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTowerSweepResult:onExit(element)
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndTowerSweepResult:onClose(element)
    WZLog("WndTowerSweepResult:onClose")
    ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(21)
    SceneCity:updateRedDotBuilding("tower", false)
    GlobalGame.g_tRedPointList.tower = nil

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
    pushEquipInList()
    g_bIsShowWndDressUp = true
end

--@brief	开始点击窗口后的回调
--@param	element:窗口绑定的lua表
--@param    pt:坐标点
function WndTowerSweepResult:onTouchBegan(element, pt)
    WndItemInfo:onCloseClick()
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndTowerSweepResult:onClickItem(tItem, nTag, tData)
    WZLog("WndTowerSweepResult:onClickItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	初始化界面
function WndTowerSweepResult:_initUI()
    if self.m_root == nil then
        return
    end
    self:_update()
end

--@brief	更新界面
function WndTowerSweepResult:_update()
    if self.m_root == nil or self.m_tData == nil then
        return
    end
    
    local txtTips = GetElement(self.m_root, "txtTips_WndTowerSweepResult", WZUILabelTTF)
    local sTxt = ""
    if self.m_tData.startFloor == self.m_tData.endFloor then
        sTxt = string.format(LocalStrings.SWEEP_RESULT_TIPS, tostring(self.m_tData.startFloor))
    elseif self.m_tData.startFloor > self.m_tData.endFloor then
        sTxt = string.format(LocalStrings.SWEEP_RESULT_TIPS2,self.m_tData.endFloor .. "-" .. self.m_tData.startFloor )
    else
        sTxt = string.format(LocalStrings.SWEEP_RESULT_TIPS, self.m_tData.startFloor.."-"..self.m_tData.endFloor)
    end
    txtTips:setText(sTxt)
    
    local txtExp = GetElement(self.m_root, "txtExp_WndTowerSweepResult", WZUILabelTTF)
    txtExp:setText("+"..self.m_tData.exp)
    
    local txtGold = GetElement(self.m_root, "txtGold_WndTowerSweepResult", WZUILabelTTF)
    txtGold:setText("+"..self.m_tData.gold)
    
    local tbconList = GetElement(self.m_root, "tbconList_WndTowerSweepResult", WZUITableContainer)
    tbconList:cleanTable()
    for i = 1, #self.m_tData.rewardId do
        if i == 1 then
            self.m_root:setTouchEnable(false)
        end
        DelayCallFunction(function()
            if WndTowerSweepResult.m_root == nil then
                return
            end
            local eCell, tCell = WndTowerSweepResult:_createCellGoodItem(i)
            tbconList:setCellElement(eCell)
            if i == #WndTowerSweepResult.m_tData.rewardId then
                WndTowerSweepResult.m_root:setTouchEnable(true)
            end
        end, nil, i/800)
    end
end

--@brief    创建一个物品格子
--@param    nIndex，序号
function WndTowerSweepResult:_createCellGoodItem(nIndex)
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setScale(0.92)
    eItem:setTag(nIndex-1)
    tItem:setFromTag(nIndex-1)
    tItem:setItemClickFun(self, self.onClickItem)
    local tData = {
        id = self.m_tData.rewardId[nIndex],
        lastNum = self.m_tData.rewardCount[nIndex],
        lastTime = self.m_tData.rewardCount[nIndex],
        isUse = false,
        data = "",
        playerItemId = -1,
        basicInfo = GetItemLocalData(self.m_tData.rewardId[nIndex])
    }
    tItem:setCellGoodItem(tData, 4)
    return eItem, tItem
end

function WndTowerSweepResult:_adaptLanguage_pt()
    WZLog("WndTowerSweepResult:_adaptLanguage_pt")
    GetElement(self.m_root,"txtTips_WndTowerSweepResult",WZUILabelTTF):setFontSize(16)
end

function WndTowerSweepResult:_adaptLanguage_ug()
    GetElement(self.m_root,"txtTips_WndTowerSweepResult",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(440))
    GetElement(self.m_root,"txtConfirm1_WndTowerSweepResult",WZUILabelTTF):setScale(0.6)
    GetElement(self.m_root,"txtConfirm2_WndTowerSweepResult",WZUILabelTTF):setScale(0.6)
end
-------------------------------------私有方法模块End----------------------------------------
