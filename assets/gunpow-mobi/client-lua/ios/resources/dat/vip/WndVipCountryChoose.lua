--WndVipCountryChoose.lua
--@brief	WndVipCountryChoose的UI模块
--@date		2017-7-19
--@author	mjf
--@note		VIP模块

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndVipCountryChoose:onEnter(element)
    self.m_root = element
end

--@brief	打开加载动画
function WndVipCountryChoose:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
    self:_update()
    AdaptLanguage(self)
end

function WndVipCountryChoose:onTouchBegan()
	WndItemInfo:onCloseClick()
end

--@brief	窗口动画完成回调
function WndVipCountryChoose:actionCallback(elem,data)
    
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndVipCountryChoose:onExit(element)
	self:_unInit()
end

--@note     设置UI界面数据
function WndVipCountryChoose:_update()
    local curData = GDatatab_payment_method

    WZLog("WndVipCountryChoose:_update one")

    local tab = GetElement(self.m_root,"tabWay_WndVipCountryChoose",WZUITableContainer)
    tab:setVisible(true)
    tab:cleanTable()
    self.m_tCellList = {}
    for i = 1, BattleCommon:tableLen(curData) do
        local cell,tcell = CellVipCountryChoose:createElement()
        cell:setTag(i-1)
        tcell:setData(curData["id_" .. i], i)
        tab:setCellElement(cell)
        
        table.insert(self.m_tCellList, tcell)
    end

end

-- 是否选择
function WndVipCountryChoose:setSel(way)
    local tab = GetElement(self.m_root,"tabWay_WndVipCountryChoose",WZUITableContainer)

    local curData = self.m_tData
    for i = 1, #curData do
        if i ~= way then
            self.m_tCellList[i]:setSel(false)
        end
    end
    WZLog("WndVipCountryChoose:setSel", way)
    self.m_tCellList[way]:setSel(true)
end

-------------------------------------公有方法模块End----------------------------------------
-- 关闭
function WndVipCountryChoose:onTempClose()
    WZLog("WndVipCountryChoose:onTempClose one")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
end

function WndVipCountryChoose:onClose()
    WZLog("WndVipCountryChoose:onClose one")
    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
end

function WndVipCountryChoose:onCloseActionCallback()
    WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------语言适配Begin------------------------------------------
function WndVipCountryChoose:_adaptLanguage_pt(  )
end

-------------------------------------语言适配End--------------------------------------------