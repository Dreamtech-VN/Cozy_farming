--CellFamilyPetHead.lua
--@brief	CellFamilyPetHead的UI模块
--@date		2017/07/26
--@author	Tianxiang_Xu
--@note		家园建筑节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFamilyPetHead:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFamilyPetHead:onExit(element)
	self:_unInit()
end

--@brief    加载
function CellFamilyPetHead:onLoadData(element)
    -- body
    self:_update()
end

--@brief    点击头像回调
function CellFamilyPetHead:onClickHead(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tData.useIndex == 1 then 
        MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT44)
        return 
    end
    
    if self.m_tBackFun then
        self.m_tBackFun[2](self.m_tBackFun[1], self, self.m_tData)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellFamilyPetHead:_update()
    -- body
    local imgBg= WZUI9Image:create()
    local spineFilePath = "ui/common/common_scale9_beibaodi2.png"
    imgBg:setFile(spineFilePath)
    self.m_root:addChild(imgBg)


    local imgIcon = WZUIImage:create()
    imgIcon:setUseOriginSize(true)
    imgIcon:setFile(self.m_tData.icon)
    self.m_root:addChild(imgIcon)

    --品质框
    local qualityPic = {"ui/common/frame_green.png","ui/common/frame_bule.png","ui/common/frame_violet.png","ui/common/frame_orange.png","ui/common/common_scale9_beibaodi1.png"}
    local quality = GDatatab_item["id_".. self.m_tData.itemId].quality
    local imgBg2= WZUI9Image:create() 
    imgBg2:setFile(qualityPic[quality])
    self.m_root:addChild(imgBg2)

    --打工中文字
    if self.m_tData.useIndex == 1 then
        self:setItemStateWord(LocalStrings.FAMILY_TEXT43)
    else
        self:setItemStateWord()
    end


    self:_createBtnBuilding()
end


--@brief    创建建筑物容器节点
function CellFamilyPetHead:_createBtnBuilding()
    -- body
    btnBuilding = WZUIButton:create()
    btnBuilding:setName("btnHead_CellFamilyPetHead")
    btnBuilding:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    btnBuilding:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    btnBuilding:setLuaDoneFunctionName("onClickHead")
    btnBuilding:setZOrder(3)
    btnBuilding:setTag(91)

    local imgNor = WZUIImage:create()
    imgNor:setUseOriginSize(true)
    btnBuilding:setNormalElement(imgNor)

    local imgSel = WZUIImage:create()
    imgSel:setUseOriginSize(true)
    imgSel:setFile("ui/common/common_scale9_beibaodi_sel.png")
    btnBuilding:setSelectElement(imgSel)

    self.m_root:addChild(btnBuilding)
end

--@brief    设置头像状态
--@note     家园打工界面守护兽头像或打工仔打工中
function CellFamilyPetHead:setItemStateWord(text)
    -- body
    if text then
        local txtDayNum = WZUILabelTTF:create()
        txtDayNum:setRelativePosition(ccp(0.5,0.1))
        txtDayNum:setFontSize(16)
        txtDayNum:setText(text)
        txtDayNum:setStrokeColor(ccc3(127,70,26))
        txtDayNum:setStrokeSize(4)
        txtDayNum:setTouchEnable(false)
        txtDayNum:setEnableStroke(true)
        txtDayNum:setColor(ccc3(255,255,255))
        self.m_root:addChild(txtDayNum,198,779)
        if ProjConfig.LANGUAGE == "vn" then
            txtDayNum:setFontSize(13) 
        end
    else
        if self.m_root:getChildByTag(779) then
            self.m_root:removeChildByTag(779, true)
        end
    end
end

--@brief    设置选中状态
--@note     家园打工界面打工仔头像或守护兽头像
function CellFamilyPetHead:setItemSelState(bVisible)
    -- body
    if bVisible then
        local imgState = WZUIImage:create()
        imgState:setAnchorPoint(ccp(0,0))
        imgState:setRelativePosition(ccp(0.6,0.05))
        imgState:setUseOriginSize(true)
        imgState:setTouchEnable(false)
        imgState:setFile("ui/common/common_icon_gou.png")
        self.m_root:addChild(imgState,199,777)
    else
        if self.m_root:getChildByTag(777) then
            self.m_root:removeChildByTag(777, true)
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
