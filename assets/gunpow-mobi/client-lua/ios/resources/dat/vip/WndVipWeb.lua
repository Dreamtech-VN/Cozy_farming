--WndVipWeb.lua
--@brief	WndVipWeb的UI模块
--@date		2017-7-19
--@author	mjf
--@note		VIP模块

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndVipWeb:onEnter(element)
    self.m_root = element
end

--@brief	打开加载动画
function WndVipWeb:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
    self:_update()
    AdaptLanguage(self)
end

function WndVipWeb:onTouchBegan()
	WndItemInfo:onCloseClick()
end

--@brief	窗口动画完成回调
function WndVipWeb:actionCallback(elem,data)
    
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndVipWeb:onExit(element)
	self:_unInit()
end

-- 点击领取回调
function WndVipWeb:onBuy(element)
    WZLog("WndVipWeb:onBuy")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    DoWebPayVn()
end 

--@note     设置UI界面数据
function WndVipWeb:_update()
    local curData = self.m_tData

    WZLog("WndVipWeb:_update one", Serialize(curData))
    local txtName =  GetElement(self.m_root, "txtName_WndVipWeb", WZUILabelTTF)

    if curData then
        local str = string.format(LocalStrings.VIP_WEB_REWARD, self.m_nCount)
        txtName:setText(str)
        self:_createReward()
        WZLog("WndVipWeb:_update two", str, LocalStrings.VIP_WEB_REWARD, self.m_nCount)
    else
        txtName:setText(LocalStrings.VIP_WEB_REWARD2)
    end

    
    
end

--@brief    更新vip奖励
function WndVipWeb:_createReward()
    local curData = self.m_tData
    local tab = GetElement(self.m_root,"tabReward_WndVipWeb",WZUITableContainer)
    tab:setVisible(true)
    tab:cleanTable()

    local giftList = {}
    for k,v in pairs(curData.reward) do
        local temp = {}
        temp.id = v[1]
        temp.count = v[2]
        table.insert(giftList,temp)
    end

    if #giftList == 3 then
        tab:setRelativePosition(GlobalMethod:ccp(0.5,0.581863))
    end

    for i = 1, #giftList do
        local curData = giftList[i]
        local key = "id_"..curData.id
        local tData = GDatatab_item[key]
        local name = tData.name
        local icon = tData.icon
        local quality = tData.quality
        local itemInfo = {name=name,icon=icon,lastTime=curData.count,lastNum=curData.count,quality=quality,basicInfo=CopyTable(tData)}

        local cell,tcell = CellGoodItem:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setCellGoodItem(itemInfo, 16)
        tcell:setItemClickFun(self, self.onClickItem)
    end
end

function WndVipWeb:onClickItem(tItem, nTag, tData)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_root == nil then return end
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end
-------------------------------------公有方法模块End----------------------------------------
-- 关闭
function WndVipWeb:onTempClose()
    WZLog("WndVipWeb:onTempClose one")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
end

function WndVipWeb:onClose()
    WZLog("WndVipWeb:onClose one")
    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
end

function WndVipWeb:onCloseActionCallback()
    WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------语言适配Begin------------------------------------------
function WndVipWeb:_adaptLanguage_pt(  )
    GetElement(self.m_root, "txtBtn_WndVipWeb", WZUILabelTTF):setScale(0.6)
end

-------------------------------------语言适配End--------------------------------------------