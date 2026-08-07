--WndVipCountry.lua
--@brief	WndVipCountry的UI模块
--@date		2017-7-19
--@author	mjf
--@note		VIP模块

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndVipCountry:onEnter(element)
    self.m_root = element
end

--@brief	打开加载动画
function WndVipCountry:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
    self:_update(true)
    AdaptLanguage(self)
end

function WndVipCountry:onTouchBegan()
	WndItemInfo:onCloseClick()
end

--@brief	窗口动画完成回调
function WndVipCountry:actionCallback(elem,data)
    
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndVipCountry:onExit(element)
	self:_unInit()
end

-- 点击国家回调
function WndVipCountry:onClickCountry(element)
    WZLog("WndVipCountry:onClickCountry")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local wndVipCountryChoose = WndVipCountryChoose:createElement()
    WndVipCountryChoose:setData(self.m_nCountry)
    WindowManager:addWindow(wndVipCountryChoose,WndVipCountryChoose,nil,false)
end 

-- 点击充值回调
function WndVipCountry:onBuy(element)
    
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self:getCountry() == 0 then
        self:setCountry(self.m_nCountry, false)
    end
    self:setWay(self.m_nWay)
    local code = WndVipCountry:getWayCode()
    if code == "google" then
        WndVip:setCountryNew(true)
    else
        WndVip:setCountryNew(false)
    end
    self:onTempClose()
    MsgBoxManager:showTipBox(LocalStrings.VIP_COUNTRY_CONFIRM_SUCCESSFUL or "")
    WZLog("WndVipCountry:onBuy", code, WndVipCountry:getCountry(), WndVipCountry:getWay())
end 

--@note     设置UI界面数据
function WndVipCountry:_update(isUpdate)
    if self.m_root == nil or isUpdate == false then
        return
    end
    local curData = self.m_tData

    WZLog("WndVipCountry:_update one", Serialize(curData))

    local path = "ui/vip/country/0" .. GDatatab_payment_method["id_" .. self.m_nCountry].country ..".png"
    GetElement(self.m_root,"imgCountry_WndVipCountry",WZUIImage):setFile(path)


    local tab = GetElement(self.m_root,"tabWay_WndVipCountry",WZUITableContainer)
    tab:setVisible(true)
    tab:cleanTable()
    self.m_tCellList = {}
    for i = 1, #curData do
        local cell,tcell = CellVipCountryWay:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setData(curData[i], i)
        table.insert(self.m_tCellList, tcell)
    end


    self:setSel(self.m_nWay)
end

-- 是否选择
function WndVipCountry:setSel(way)
    local tab = GetElement(self.m_root,"tabWay_WndVipCountry",WZUITableContainer)

    local curData = self.m_tData
    for i = 1, #curData do
        if i ~= way then
            self.m_tCellList[i]:setSel(false)
        end
    end
    WZLog("WndVipCountry:setSel", way)
    self.m_tCellList[way]:setSel(true)
    self.m_nWay = way
end

--@brief 设置国家
function WndVipCountry:setCountry(country, isUpdate)
    --更新状态全局数据
    local data = WZDataFile:getInstance():getUserData()
    if data ~= nil then
        data:setStringValue("VipCountryData", "Country", tostring(country))
        data:flush()
    end

    self:setData(country, isUpdate and 1 or WndVipCountry:getWay())
    self:_update(isUpdate)
end

--@brief 获取国家
function WndVipCountry:getCountry()
    local data = WZDataFile:getInstance():getUserData()
    if nil == data then
        return 0
    end
    local country = data:getStringValue("VipCountryData", "Country")
    if country == nil or country == "" or country == "0" then
        country = 0
    else
        country = tonumber(country)
    end

    WZLog("WndVipCountry:getCountry one", country)

    return country
end

--@brief 设置支付方式
function WndVipCountry:setWay(way)
    --更新状态全局数据
    local data = WZDataFile:getInstance():getUserData()
    if data ~= nil then
        data:setStringValue("VipCountryData", "Way", tostring(way))
        data:flush()
    end
    
end

--@brief 获取支付方式
function WndVipCountry:getWay()
    local data = WZDataFile:getInstance():getUserData()
    if nil == data then
        return 0
    end
    local way = data:getStringValue("VipCountryData", "Way")
    if way == nil or way == "" or way == "0" then
        way = 0
    else
        way = tonumber(way)
    end

    WZLog("WndVipCountry:getWay one", way)

    return way
end

--@brief 获取支付方式
function WndVipCountry:getWayCode()
    local country, way = WndVipCountry:getCountry(), WndVipCountry:getWay()

    local data
    local code = "google"
    if country ~= 0 and way ~= 0 then
        data = GDatatab_payment_method["id_" .. country].payment[1]
        code = GDatatab_pm_id["id_" .. data[way]].pmid
    end

    WZLog("WndVipCountry:getWayCode", tostring(data and data[way]), tostring(code))

    return code
end
-------------------------------------公有方法模块End----------------------------------------
-- 关闭
function WndVipCountry:onTempClose()
    WZLog("WndVipCountry:onTempClose one")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
end

function WndVipCountry:onClose()
    WZLog("WndVipCountry:onClose one")
    WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback",self)
end

function WndVipCountry:onCloseActionCallback()
    WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------语言适配Begin------------------------------------------
function WndVipCountry:_adaptLanguage_pt(  )
    GetElement(self.m_root, "txtBtn_WndVipCountry", WZUILabelTTF):setScale(0.6)
end

-------------------------------------语言适配End--------------------------------------------