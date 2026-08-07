--CellPhantomItem.lua
--@brief	CellPhantomItem的UI模块
--@date		2020/07/22
--@author	XTX
--@note		皮肤列表项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPhantomItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPhantomItem:onExit(element)
	self:_unInit()
end

--@brief	选中皮肤
function CellPhantomItem:onSelect()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if WndPhantom.m_tSelectedCell ~= nil then
		WndPhantom.m_tSelectedCell:setHighLight(false)
	end
	WndPhantom.m_tSelectedCell = self
    WndPhantom.showId = self.m_tData.id
	self:setHighLight(true)

	WndPhantom:onFresh(self.m_tData) 
	WndPhantom:playAttackAni()
end

--@brief    点击幻化按键
function CellPhantomItem:onFighting(element)
    WZLog("---------------------fighting----------------------")
    WndPhantom:onUse(element, self.m_tData)
end

--@brief    点击取消按键
function CellPhantomItem:onDown(element)
    WZLog("---------------------onDown----------------------")
    WndPhantom:onCancel(element, self.m_tData)
end

--@brief 	加载
function CellPhantomItem:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellPhantomItem")
	self.m_root:addChild(celElement)

	self.m_bIsLoaded = true
	self:_update()
	AdaptLanguage(self)
end

-- 设置选中状态
function CellPhantomItem:setHighLight(isSel)
    self.selState = isSel

    if self.m_bIsLoaded == false then return end
    local conSel = GetElement(self.m_root, "conSel_CellPhantomItem", WZUIContainer)
    conSel:setVisible(self.selState)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellPhantomItem:_update()
	-- body
	local tData = self.m_tData
	--拥有和使用状态
	self:setPhantomState()
	--头像
	local imgIcon = GetElement(self.m_root, "imgIcon_CellPhantomItem", WZUIImage)
	if imgIcon then 
		imgIcon:setFile("battle/head/" .. tData.head .. ".png")
	end
	--品质
	local imgQuality = GetElement(self.m_root, "imgQuality_CellPhantomItem", WZUIImage)
	if imgQuality then 
		imgQuality:setFile(g_tQualityRect[tData.quality])
	end
	--名字
	local txtName = GetElement(self.m_root, "txtName_CellPhantomItem", WZUILabelTTF)
	if txtName then 
		txtName:setText(tData.name)
		txtName:setColor(QUALITYCOLOR[tData.quality])
	end
	--选中状态
	self:setHighLight(self.selState)
	--星级
	local starCnt = tData.advancedLevel or 0
    local imgPath = {"ui/common/common_icon_xingxing2.png","ui/common/common_09.png" }
    WZLog("CellPhantomItem:_update", starCnt)
    for i = 1, 10 do
        local index = starCnt >= i and 1 or 2
        local star = GetElement(self.m_root, "imgStar"..i.."_CellPhantomItem", WZUIImage)
        star:setFile(imgPath[index])
    end
end

--@brief	拥有和使用状态
function CellPhantomItem:setPhantomState()
	-- body
	local tData = self.m_tData
	if self.m_bIsLoaded == false then return end 

	GetElement(self.m_root, "conState1_CellPhantomItem", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conState2_CellPhantomItem", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conState3_CellPhantomItem", WZUIContainer):setVisible(false)
	if tData.use == false and tData.own == false then
		GetElement(self.m_root, "conState3_CellPhantomItem", WZUIContainer):setVisible(true)
	elseif tData.use == true then 
		GetElement(self.m_root, "conState1_CellPhantomItem", WZUIContainer):setVisible(true)
	elseif tData.own == true then 
		GetElement(self.m_root, "conState2_CellPhantomItem", WZUIContainer):setVisible(true)
	end
end

function CellPhantomItem:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtName_CellPhantomItem",WZUILabelTTF):setScale(0.8)
end
-------------------------------------私有方法模块End----------------------------------------
