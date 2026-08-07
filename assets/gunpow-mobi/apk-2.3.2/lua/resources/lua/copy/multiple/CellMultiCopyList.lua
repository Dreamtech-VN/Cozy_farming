--CellMultiCopyList.lua
--@brief	CellMultiCopyList的UI模块
--@date		2015-7-28
--@author	binshao
--@note		组队副本列表单元格


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMultiCopyList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMultiCopyList:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellMultiCopyList:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellMultiCopyList")
    self.m_root:addChild(cellElement)
    self.loadEnd = true
    self:_update()
    AdaptLanguage(self)
end

-- 回调函数
function CellMultiCopyList:onClickCell(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.callBack[2](self.callBack[1],self.m_tData[1].map_num)
end

--@brief    点击镜像头像回调
function CellMultiCopyList:onCheckMirror(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tMultiCopyData = CacheCenter:getMultiCopyData()
    WZLog("CellMultiCopyList:onCheckMirror", tMultiCopyData.awakeMirrorInfo.playerId)
    if tMultiCopyData.awakeMirrorInfo and tMultiCopyData.awakeMirrorInfo.playerId and tMultiCopyData.awakeMirrorInfo.playerId > 0 then 
        WndCheckOther:show(tMultiCopyData.awakeMirrorInfo.playerId)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新界面
function CellMultiCopyList:_update()
    if self.loadEnd == false then return end

    -- 副本名字
    local localData = self.m_tData[1]


    -- 副本图
    local imgIcon = GetElement(self.m_root, "imgIcon_CellMultiCopyList", WZUIImage)
    imgIcon:setFile(localData.mini_map)

    --开启状态
    local openGray = self.m_tData.openState > 2 and true or false
    -- imgIcon:setGrayRender(openGray)
    local conNot = GetElement(self.m_root, "conNotOpen_CellMultiCopyList", WZUIContainer)
    conNot:setVisible(openGray)
    local conLeft = GetElement(self.m_root, "conLeftCnt_CellMultiCopyList", WZUIContainer)
    conLeft:setVisible(not openGray)


    -- 剩余次数
    local nPassTime = self.m_tData.userData.passTime
    local nTotalTime = localData.challenge_num
    -- local txtLeft = GetElement(self.m_root, "txtLeftCnt_CellMultiCopyList", WZUILabelTTF)
    -- txtLeft:setText("("..(nTotalTime-nPassTime).."/"..nTotalTime..")")
    local txtName = GetElement(self.m_root, "txtName_CellMultiCopyList", WZUILabelTTF)
    txtName:setText(localData.map_name.."("..(nTotalTime-nPassTime).."/"..nTotalTime..")")
    -- 星星
    for i = 1,3 do
        local imgStar = GetElement(self.m_root, "imgStar"..i.."_CellMultiCopyList", WZUIImage)
        if i > self.m_tData.userData.starLevel then imgStar:setVisible(false) end
    end

    -- 选中状态
    local imgSel = GetElement(self.m_root, "imgSel_CellMultiCopyList", WZUI9Image)
    imgSel:setVisible(self.selState)
    --显示开启的觉醒提示
    local tMultiCopyData = CacheCenter:getMultiCopyData()
    local configData = GDatatab_team_map["id_" .. tMultiCopyData.awakeMapId]
    if configData.map_num == localData.map_num then 
        self:setWakeupAttVisible(true)
        local nLeftAwakeTimes = (1 - tMultiCopyData.awakeTimes) < 0 and 0 or (1 - tMultiCopyData.awakeTimes)
        -- GetElement(self.m_root, "txtAwakeLeftCnt_CellMultiCopyList", WZUILabelTTF):setText(nLeftAwakeTimes .. "/1")
        local txtAwake = GetElement(self.m_root,"txtAwake_CellMultiCopyList",WZUILabelTTF)
        txtAwake:setText(LocalStrings.MULCOPY_TEXT1 .. nLeftAwakeTimes .. "/1")
        local conAwakeHead = GetElement(self.m_root, "conAwakeHead_CellMultiCopyList", WZUIContainer)
        if tMultiCopyData.awakeMirrorInfo and tMultiCopyData.awakeMirrorInfo.playerId and tMultiCopyData.awakeMirrorInfo.playerId > 0 then 
            conAwakeHead:setVisible(true)
            CellHead:show(conAwakeHead, tMultiCopyData.awakeMirrorInfo.headId, tMultiCopyData.awakeMirrorInfo.faceId, tMultiCopyData.awakeMirrorInfo.sex, nil, nil, nil, tMultiCopyData.awakeMirrorInfo.colour)
        end
    else
        self:setWakeupAttVisible(false)
    end
end

-- 副本选择状态
function CellMultiCopyList:setCellSelState(isSel)
    self.selState = isSel
    if self.loadEnd == false then return end
    local imgSel = GetElement(self.m_root, "imgSel_CellMultiCopyList", WZUI9Image)
    imgSel:setVisible(isSel)
end

--@brief    显示觉醒难度开启提示
function CellMultiCopyList:setWakeupAttVisible(bVisible)
    -- body
    self.m_bIsAwakeOpen = bVisible
    if self.loadEnd == false then return end
    GetElement(self.m_root, "conAwakeOpen_CellMultiCopyList", WZUIContainer):setVisible(bVisible)
    -- GetElement(self.m_root, "conAwakeLeftCnt_CellMultiCopyList", WZUIContainer):setVisible(bVisible)

end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin----------------------------------------
function CellMultiCopyList:_adaptLanguage_en(  )
    local txt = GetElement(self.m_root,"txtName_CellMultiCopyList",WZUILabelTTF)
    txt:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
    txt:setFontSize(20)

    local txtLeftCntT = GetElement(self.m_root, "txtLeftCntT_CellMultiCopyList", WZUILabelTTF)
    txtLeftCntT:setFontSize(18)
    txtLeftCntT:setRelativePosition(GlobalMethod:ccp(0.3,0.5))
    local txtLeftCnt = GetElement(self.m_root, "txtLeftCnt_CellMultiCopyList", WZUILabelTTF)
    txtLeftCnt:setFontSize(18)
    txtLeftCnt:setRelativePosition(GlobalMethod:ccp(0.82,0.5))
end

function CellMultiCopyList:_adaptLanguage_pt(  )
    local txtName = GetElement(self.m_root,"txtName_CellMultiCopyList",WZUILabelTTF)
    txtName:setScale(0.6)
    txtName:setDimensions(GlobalMethod:CCSize(220))
end

function CellMultiCopyList:_adaptLanguage_tr(  )
    local txt = GetElement(self.m_root,"txtName_CellMultiCopyList",WZUILabelTTF)
    txt:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
    txt:setFontSize(20)
    local txtLeftCntT = GetElement(self.m_root,"txtLeftCntT_CellMultiCopyList",WZUILabelTTF)
    txtLeftCntT:setFontSize(16)
    txtLeftCntT:setRelativePosition(GlobalMethod:ccp(0.25,0.472826))
end

function CellMultiCopyList:_adaptLanguage_th(  )
    local txt = GetElement(self.m_root,"txtName_CellMultiCopyList",WZUILabelTTF)
    txt:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
end

function CellMultiCopyList:_adaptLanguage_vn(  )
    local txt = GetElement(self.m_root,"txtName_CellMultiCopyList",WZUILabelTTF)
    txt:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
    txt:setFontSize(20)
end

function CellMultiCopyList:_adaptLanguage_es(  )
    local txtName = GetElement(self.m_root,"txtName_CellMultiCopyList",WZUILabelTTF)
    txtName:setScale(0.6)
    txtName:setDimensions(GlobalMethod:CCSize(220))

    local txtLeftCntT = GetElement(self.m_root, "txtLeftCntT_CellMultiCopyList", WZUILabelTTF)
    txtLeftCntT:setFontSize(18)
    --txtLeftCntT:setRelativePosition(GlobalMethod:ccp(0.3,0.5))

    local txtLeftCnt = GetElement(self.m_root, "txtLeftCnt_CellMultiCopyList", WZUILabelTTF)
    txtLeftCnt:setFontSize(18)
    --txtLeftCnt:setRelativePosition(GlobalMethod:ccp(0.82,0.5))
end

function CellMultiCopyList:_adaptLanguage_ug(  )
    local txtName = GetElement(self.m_root,"txtName_CellMultiCopyList",WZUILabelTTF)
    txtName:setScale(0.6)
    txtName:setDimensions(GlobalMethod:CCSize(220))

    local txtLeftCntT = GetElement(self.m_root, "txtLeftCntT_CellMultiCopyList", WZUILabelTTF)
    txtLeftCntT:setScale(0.8)
    txtLeftCntT:setRelativePosition(GlobalMethod:ccp(0.441373,0.472826))
    local txtLeftCnt = GetElement(self.m_root, "txtLeftCnt_CellMultiCopyList", WZUILabelTTF)
    txtLeftCnt:setScale(0.8)
    txtLeftCnt:setRelativePosition(GlobalMethod:ccp(-0.026049,0.5))
end

-------------------------------------私有方法模块End----------------------------------------