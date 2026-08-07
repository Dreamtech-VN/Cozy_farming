--CellVipCountryWay.lua
--@brief	CellVipCountryWay的UI模块
--@date		2017/01/10
--@author	jiaming_liu
--@modify   binshao 2015-5-8
--@note		礼包列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellVipCountryWay:onEnter(element)
	self.m_root = element
	--多语言版本界面适配
    AdaptLanguage(self)
    WZLog("CellVipCountryWay:onEnter")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellVipCountryWay:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellVipCountryWay:onLoadData(element)
    WZLog("CellVipCountryWay:onLoadData1")
    local cellElement = WZUISystem:getInstance():createElement("CellVipCountryWay")
    WZLog("CellVipCountryWay:onLoadData2", tostring(cellElement), tostring(self.m_root))
    self.m_root:addChild(cellElement)
    self:_update()
end

-- 点击回调
function CellVipCountryWay:onClick(element)
    WZLog("CellVipCountryWay:onClick", self.m_nIndex)
    WndVipCountry:setSel(self.m_nIndex)

    WndVipCountry:setWay(self.m_nIndex)
end 

-- 是否选择
function CellVipCountryWay:setSel(isSel)

    self.m_bIsSel = isSel
    local con = GetElement(self.m_root,"conSel_CellVipCountryWay",WZUIContainer)
    WZLog("CellVipCountryWay:setSel", con)
    if con then
        con:setVisible(isSel)
    end
end 

--@note		设置UI界面数据
function CellVipCountryWay:_update()
    local curData = self.data
    local path = "ui/vip/country/pay_0" .. curData ..".png"
    GetElement(self.m_root,"img1_CellVipCountryWay",WZUIImage):setFile(path)
    GetElement(self.m_root,"img2_CellVipCountryWay",WZUIImage):setFile(path)

    GetElement(self.m_root,"conSel_CellVipCountryWay",WZUIContainer):setVisible(self.m_bIsSel)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------
