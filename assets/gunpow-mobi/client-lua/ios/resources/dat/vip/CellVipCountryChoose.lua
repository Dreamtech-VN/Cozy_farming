--CellVipCountryChoose.lua
--@brief	CellVipCountryChoose的UI模块
--@date		2017/01/10
--@author	jiaming_liu
--@modify   binshao 2015-5-8
--@note		礼包列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellVipCountryChoose:onEnter(element)
	self.m_root = element
	--多语言版本界面适配
    AdaptLanguage(self)
    WZLog("CellVipCountryChoose:onEnter")
    self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellVipCountryChoose:onExit(element)
	self:_unInit()
end

-- -- 加载数据
-- function CellVipCountryChoose:onLoadData(element)
--     local cellElement = WZUISystem:getInstance():createElement("CellVipCountryChoose")
--     self.m_root:addChild(cellElement)
--     self:_update()
-- end

-- 点击回调
function CellVipCountryChoose:onClick(element)
    WZLog("CellVipCountryChoose:onClick", self.m_nIndex)
    WndVipCountry:setCountry(self.m_nIndex, true)

    WndVipCountryChoose:onTempClose()
end 

-- 是否选择
function CellVipCountryChoose:setSel(isSel)

    self.m_bIsSel = isSel
    local con = GetElement(self.m_root,"conSel_CellVipCountryChoose",WZUIContainer)
    WZLog("CellVipCountryChoose:setSel", con)
    if con then
        con:setVisible(isSel)
    end
end 

--@note		设置UI界面数据
function CellVipCountryChoose:_update()
    local curData = self.data.name
    local path = "ui/vip/country/0" .. self.data.country ..".png"
    GetElement(self.m_root,"img1_CellVipCountryChoose",WZUIImage):setFile(path)
    GetElement(self.m_root,"img2_CellVipCountryChoose",WZUIImage):setFile(path)

    GetElement(self.m_root,"txtName_CellVipCountry",WZUILabelTTF):setText(curData)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------
