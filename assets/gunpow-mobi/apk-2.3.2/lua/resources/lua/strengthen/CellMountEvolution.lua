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
    if self.m_nType == 1 then 
        WndAscending:showLeftPhantom(self.m_tData) 
        WndAscending:showRightPhantom(self.m_tData)
        WndAscending:showPhantomM()
        
        if WndAscending.m_tSelectedPhantom ~= nil then WndAscending.m_tSelectedPhantom:setSelectState(false) end
        self:setSelectState(true)
    	WndAscending.m_tSelectedPhantom = self
    else
        WndAscending:showLeftMount(self.m_tData) 
        WndAscending:showRightMount(self.m_tData)
        WndAscending:showMountM()
        
        if WndAscending.m_tSelectedMount ~= nil then WndAscending.m_tSelectedMount:setSelectState(false) end
        self:setSelectState(true)
        WndAscending.m_tSelectedMount = self
    end
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
    local imgQualityRect = GetElement(self.m_root, "imgQualityRect_CellMountEvolution", WZUI9Image)
    local imgNameBg = GetElement(self.m_root, "imgNameBg_CellMountEvolution", WZUI9Image)
    local quality = 1 
    if self.m_nType == 1 then 
        local txtName = GetElement(self.m_root,"txtName_CellMountEvolution",WZUILabelTTF)
        txtName:setText(tData.name)

        quality = tData.quality
    else
        local txtLv = GetElement(self.m_root,"txtLv_CellMountEvolution",WZUILabelTTF)
        txtLv:setText("Lv"..tData.upgradeLevel)

        quality = tData.basicInfo.quality
        local txtName = GetElement(self.m_root,"txtName_CellMountEvolution",WZUILabelTTF)
        txtName:setText(tData.basicInfo.name)
    end
    imgQualityRect:setFile(g_tQualityBG[quality])
    imgNameBg:setFile(g_tQualityNameBG[quality])

    -- 星级
    local txtStarNum = GetElement(self.m_root, "txtStarNum_CellMountEvolution", WZUILabelTTF)
    local starCnt = tData.advancedLevel
    txtStarNum:setText(starCnt)

    -- 是否选中
    local img = GetElement(self.m_root,"imgSel_CellMountEvolution",WZUI9Image)
    img:setVisible(false)
end

-- 创建坐骑头像
function CellMountEvolution:_createImage()
    local imgIcon = GetElement(self.m_root, "imgIcon_CellMountEvolution", WZUIImage)

    if self.m_nType == 1 then 
        GetElement(self.m_root, "conImage_CellMountEvolution", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5, 0.56))
        imgIcon:setFile(self.m_tData.bust)
    else
        local icon = string.gsub(self.m_tData.basicInfo.icon, ".png", "_1.png")
        imgIcon:setFile(icon)
    end
end
-------------------------------------私有方法模块End-----------------------------------------

-------------------------------------语言适配Begin-----------------------------------------
function CellMountEvolution:_adaptLanguage_vn()
    local txtName = GetElement(self.m_root,"txtName_CellMountEvolution",WZUILabelTTF)
    txtName:setScale(0.6)
    txtName:setDimensions(GlobalMethod:CCSize(230))
    txtName:setAlignment(kCCTextAlignmentCenter)
end

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