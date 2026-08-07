--CellSingleCopyLevel.lua
--@brief	CellSingleCopyLevel的UI模块
--@date		2015/04/10
--@author	xiaoyu_wu
--@note		单人副本关卡项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSingleCopyLevel:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    self:_initUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSingleCopyLevel:onExit(element)
	self:_unInit()
end

--@brief	点击按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function CellSingleCopyLevel:onClickLevel(element)
    WZLog("CellSingleCopyLevel:onClickLevel")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    TeachGroup1:endTeachStep({1,4},{3,6},{5,13},{8,10},{9,10},{29,4},{32,7})
    if self.m_fClickCallback then
        self.m_fClickCallback(self.m_tCallback,self)
    end
end

--@brief   获取小关卡箭头
function CellSingleCopyLevel:getArromRoot()
    local imgArrow = self.m_root:getChildByTag(12568)
    return imgArrow
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
local tempPt = GlobalMethod:ccp(0,0)
--@brief	初始化界面
function CellSingleCopyLevel:_initUI()
    if self.m_root == nil or self.m_tData == nil then
        WZLog(debug.traceback())
        return
    end
    
    self:_updateForState(self.m_nState)
    
end

--@brief    根据状态更新界面
--@param    nState：状态值，见CellSingleCopyLevel表定义
function CellSingleCopyLevel:_updateForState(nState)
    local sIcon = self:_getIconByState(nState)
   
    local imgLevel1 = GetElement(self.m_root, "imgLevel1_CellSingleCopyLevel", WZUIImage)
    local imgLevel2 = GetElement(self.m_root, "imgLevel2_CellSingleCopyLevel", WZUIImage)
    local txtLevelName = GetElement(self.m_root,"txtLevelName_CellSingleCoypLevel",WZUILabelTTF)
    local txtMonsterName = GetElement(self.m_root,"txtMonsterName_CellSingleCoypLevel",WZUILabelTTF)
    imgLevel1:setFile(sIcon)
    imgLevel2:setFile(sIcon)
    if sIcon == "ui/copy/common_icon_jingyin2.png" then
        txtLevelName:setText(self.m_tData.map_name)
        if ProjConfig.LANGUAGE == "es" then
            txtLevelName:setScale(0.8)
            txtLevelName:setDimensions(GlobalMethod:CCSize(160))
        end
    end

    if sIcon == "ui/copy/common_icon_boss3.png" or sIcon == "ui/copy/common_icon_boss4.png" then
        txtMonsterName:setVisible(true)
        txtMonsterName:setText(self.m_tData.map_name)
        txtMonsterName:setZOrder(999)
    end
    -- local imgArrow = GetElement(self.m_root, "imgArrow_CellSingleCopyLevel")
    -- imgArrow:setZOrder(10000)
    if nState == CellSingleCopyLevel.STATE_UNDERWAY and self.m_nTaskCellId == nil then
        self:addArromAction(self.m_tData.id)
    elseif self.m_nTaskCellId ~= nil then
        local curCopyId = self.m_tData.id
        if WndSingleCopy.m_nCopyType == 3 then
            local temp =  GDatatab_single_map["id_" .. self.m_nTaskCellId ]
            if temp.section == self.m_tData.section and temp.idgroup == self.m_tData.idgroup then
                self:addArromAction(self.m_tData.id)
            else
               self:setArromActionVisibleStatus(false)
            end
        else
            if tonumber(self.m_nTaskCellId) == self.m_tData.id then
                self:addArromAction(self.m_tData.id) 
            else
                self:setArromActionVisibleStatus(false)
            end
        end
        
    else
        self:setArromActionVisibleStatus(false)
        --imgArrow:setVisible(false)
    end
    
    local conStar = GetElement(self.m_root, "conStar_CellSingleCopyLevel")
    local nStar = WndSingleCopy:getStarNumById(self.m_tData.id)
    local conStar = GetElement(self.m_root,"conStar_CellSingleCopyLevel")
    if self.m_nState == CellSingleCopyLevel.STATE_LOCKED then
        conStar:setVisible(false)
    else
        conStar:setVisible(true)
        for i = 1, 3 do
        local img = GetElementWithoutAssert(self.m_root, "imgStar"..i.."_CellSingleCopyLevel", WZUIImage)
            if i <= nStar then
                img:setFile("ui/common/common_icon_xingxing2.png")
                img:setGrayRender(false)
            else
                img:setFile("ui/common/common_icon_xingxing2.png")
                img:setGrayRender(true)
            end
        end
    end
    
    if self.m_bShowArm and (self.m_tData.map_type == 2 or self.m_tData.map_type == 3)  then
        local conArm = GetElement(self.m_root,"conArm_CellSingleCopyLevel",WZUIContainer)
        if not conArm:getChildByTag(1145) then
            local arm = WZArmature:create()
            arm:setTag(1145)
            arm:setTouchEnable(false)
            arm:setArmatureName("ui_danrenfuben_jingyingnandu")
            arm:setUseOriginSize(true)
            arm:setArmatureFile("ui/ui_danrenfuben_jingyingnandu.xml")
            conArm:addChild(arm)
        end
    end
end

--@brief    根据状态获取icon图片路径
--@param    nState：状态值，见CellSingleCopyLevel表定义
--@return   #1,icon图片路径
function CellSingleCopyLevel:_getIconByState(nState)
    return "ui/copy/"..self.m_tData.map_icon
end



-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function CellSingleCopyLevel:_adaptLanguage_pt(  )
    local txtMonsterName = GetElement(self.m_root,"txtMonsterName_CellSingleCoypLevel",WZUILabelTTF)
    txtMonsterName:setDimensions(GlobalMethod:CCSize(220))
    txtMonsterName:setRelativePosition(GlobalMethod:ccp(0.5,1.07))
end

function CellSingleCopyLevel:_adaptLanguage_es(  )
    local txtMonsterName = GetElement(self.m_root,"txtMonsterName_CellSingleCoypLevel",WZUILabelTTF)
    txtMonsterName:setDimensions(GlobalMethod:CCSize(220))
    txtMonsterName:setRelativePosition(GlobalMethod:ccp(0.5,1.07))
end
-------------------------------------语言适配end----------------------------------------
