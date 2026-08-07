--CellMountEvolution.lua
--@brief	CellMountEvolution的UI模块
--@date		2016/12/07
--@author	zsq
--@note		坐骑升品Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMountEvolution:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMountEvolution:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------
-- 加载数据
function CellMountEvolution:setData(tData)
	self.m_tData = tData
    self:_update()
    AdaptLanguage(self)
end

-- 选中坐骑
function CellMountEvolution:onSelect()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = self.m_root:getTag()
    WZLog("----------onSelect--------------",tag)
    WndAscending:showLeftMount(self.m_tData) 
	WndAscending:showRightMount(self.m_tData)
	WndAscending:showMountM()
	
	if WndAscending.m_tSelectedMount ~= nil then WndAscending.m_tSelectedMount:setSelectState(false) end
	self:setSelectState(true)
	WndAscending.m_tSelectedMount = self
end

-- 设置选中状态
function CellMountEvolution:setSelectState(isSel)
	if self.m_root == nil then return end
    self.selState = isSel
    local img = GetElement(self.m_root,"imgSel_CellMountEvolution",WZUI9Image)
    img:setVisible(self.selState)
end
---------------------------------------公有方法模块End----------------------------------------

---------------------------------------私有方法模块Begin--------------------------------------
function CellMountEvolution:_update()
    -- 头像
    self:_createImage()
    -- 信息
    self:_initMountInfo()
end

function CellMountEvolution:_initMountInfo()
	local tData = self.m_tData
    -- 等级和名字
    local txtLv = GetElement(self.m_root,"txtLv_CellMountEvolution",WZUILabelTTF)
    txtLv:setText("Lv"..tData.upgradeLevel)
    txtLv:setColor(QUALITYCOLOR[tData.basicInfo.quality])
    local txtName = GetElement(self.m_root,"txtName_CellMountEvolution",WZUILabelTTF)
    txtName:setText(tData.basicInfo.name)
    txtName:setColor(QUALITYCOLOR[tData.basicInfo.quality])

    -- 星级
    local con = GetElement(self.m_root,"conMountstars_CellMountEvolution",WZUIContainer)
    con:setVisible(true)
    local starCnt = tData.advancedLevel
    local imgPath = {"ui/common/common_icon_xingxing2.png","ui/common/common_icon_xingxing3.png" }
    for i =1, 10 do
        local index = starCnt >= i and 1 or 2
        local star = GetElement(self.m_root,"imgStar"..i.."_CellMountEvolution",WZUIImage)
        star:setFile(imgPath[index])
    end

    -- 是否选中
    local img = GetElement(self.m_root,"imgSel_CellMountEvolution",WZUI9Image)
    img:setVisible(false)
end

-- 创建坐骑头像
function CellMountEvolution:_createImage()
    local conImage = GetElement(self.m_root,"conImage_CellMountEvolution",WZUIContainer)
    local cell,tcell = CellGoodItem:createElement()
    if cell then
        cell = WZUIContainer:luaTo(cell)
        tcell:setCellGoodItem(self.m_tData,10)
        conImage:addChild(cell)
    end
end
-------------------------------------私有方法模块End-----------------------------------------

-------------------------------------语言适配Begin-----------------------------------------
function CellMountEvolution:_adaptLanguage_pt(  )
    local txtLv = GetElement(self.m_root,"txtLv_CellMountEvolution",WZUILabelTTF)
    txtLv:setScale(0.8)
    local txtName = GetElement(self.m_root,"txtName_CellMountEvolution",WZUILabelTTF)
    txtName:setScale(0.8)
    txtName:setRelativePosition(GlobalMethod:ccp(0.28,0.5))
end
function CellMountEvolution:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtLv_CellMountEvolution",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtName_CellMountEvolution",WZUILabelTTF):setFontSize(16)
end

function CellMountEvolution:_adaptLanguage_th(  )
    local txtLv = GetElement(self.m_root,"txtLv_CellMountEvolution",WZUILabelTTF)
    txtLv:setScale(0.7)
    local txtName = GetElement(self.m_root,"txtName_CellMountEvolution",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setRelativePosition(GlobalMethod:ccp(0.27,0.5))
    txtName:setDimensions(GlobalMethod:CCSize(210))
end
------------------------------------语言适配End---------------------------------------------