--CellHVBuilding.lua
--@brief	CellHVBuilding的UI模块
--@date		2022/06/04
--@author	XTX
--@note		度假村-建筑、土地块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellHVBuilding:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellHVBuilding:onExit(element)
	self:_unInit()
end

--@brief    点击建筑回调
function CellHVBuilding:onClickBuilding(element)
    -- body
    WZLog("CellHVBuilding:onClickBuilding", Serialize(self.m_tData))
    if self.m_tData.configId >= 20 then 
        if (self.m_tData.configId == 21) and self.m_tLuaTable:isMyHolidayVillage() then 
            SceneHVTree:showInterface()
        elseif (self.m_tData.configId == 26) and self.m_tLuaTable:isMyHolidayVillage() then 
            SceneHolidayVillage:showInterface()
        end
        return 
    end 
    if self.m_tData.fieldStatus == -1 then 
        if self.m_tLuaTable:isMyHolidayVillage() then 
            if self.m_tData.configId == 2 then 
                MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT3[26])
            else
                MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[84])
            end
        end
        self.m_tLuaTable:setOperateType(0)
        return 
    end 

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tData.plantId > 0 and not self.m_tData.bIsWater then --浇水
        if self.m_tLuaTable:isMyHolidayVillage() then 
            self.m_tLuaTable:setOperateType(3)
            self.m_tLuaTable:waterCallBack(self.m_tData)
            return 
        end
    elseif self.m_tData.plantId > 0 and self.m_tData.plantPests > 0 then --捕捉
        self.m_tLuaTable:setOperateType(4)
        self.m_tLuaTable:catchCallBack(self.m_tData)
        return 
    end
    local nOperateType = self.m_tLuaTable:getOperateType()
    if nOperateType == 5 and self.m_bIsChoose then --采摘
        if self.m_tData.plantId > 0 and self.m_tData.plantStatus == PLANT_STATUS.MATURITY then 
            self.m_tLuaTable:collectCallBack(self.m_tData)
        else
            MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[55])
        end
    elseif nOperateType == 6 and self.m_bIsChoose then --偷取
        if self.m_tData.plantId > 0 and self.m_tData.plantStatus == PLANT_STATUS.MATURITY then 
            self.m_tLuaTable:catchCallBack(self.m_tData)
        else
            MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[54])
        end
    else
        self.m_tLuaTable:onClickBuildingCallBack(self.m_root, self, self.m_tData)
    end
end

--@brief    精灵自动操作(挖坑)
function CellHVBuilding:autoOperateBuild1()
    if not self.m_tLuaTable:isMyHolidayVillage() then
        return
    end
    if self.m_tData.configId >= 20 then
        return
    end
    if self.m_tData.fieldStatus ~= 1 then
        return
    end

    if self.m_tData.plantId == 0 and not self.m_tData.bIsDig then  --挖坑
        local tempBuild = self.m_tLuaTable.m_clickInfo
        self.m_tLuaTable.m_clickInfo = {}
        self.m_tLuaTable.m_clickInfo.element = self.m_root
        self.m_tLuaTable.m_clickInfo.tCell = self
        self.m_tLuaTable.m_clickInfo.tData = self.m_tData

        self.m_tLuaTable:setOperateType(8)
        self.m_tLuaTable:digCallBack(self.m_tData)

        self.m_tLuaTable.m_clickInfo = tempBuild
    end
end

--@brief    精灵自动操作(浇水)
function CellHVBuilding:autoOperateBuild2()
    if not self.m_tLuaTable:isMyHolidayVillage() then
        return
    end
    if self.m_tData.configId >= 20 then
        return
    end
    if self.m_tData.fieldStatus ~= 1 then
        return
    end

    if self.m_tData.plantId > 0 and not self.m_tData.bIsWater then --浇水
        self.m_tLuaTable:setOperateType(3)
        self.m_tLuaTable:waterCallBack(self.m_tData)
    end
end

--@brief    触摸点是否在建筑上
function CellHVBuilding:ptInBtnCallBack(element)
    -- body
    WZLog("CellHVBuilding:ptInBtnCallBack")
    self.m_tLuaTable:judgePtInBuilding(self.m_tData)
end

--@brief    设置移动箭头的可见
function CellHVBuilding:setArrowVisible(bVisible)
    -- body
    self:_createBuildingArrow(bVisible)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellHVBuilding:_update()
    -- body
    --设置相应容器大小
    self:_setContainerSize()
--    self:setBuildingBG(1)
    --显示建筑
    self:_drawBuilding()
    --显示作物
    self:_createPlantImageNode()
    --显示害虫
    self:_createPlantPestNode()
    --按钮
    self:_createBtnBuilding()
end

--@brief    设置Cell容器大小
function CellHVBuilding:_setContainerSize()
    -- body
    local tData = self.m_tData.basicData
    local element = WZUIContainer:luaTo(self.m_root)
    --计算容器大小
    local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * HVMAP_SIZEX
    local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * HVMAP_SIZEY

    element:setContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
    element:setRelativeSize(GlobalMethod:CCSize(1,1))
    element:updateRelativeSize()
end

--@brief    设置建筑底部草地
--@brief    state:默认显示草地；1->显示绿色；2->显示红色
function CellHVBuilding:setBuildingBG(state)
    -- body
    local tData = self.m_tData.basicData

    local conForBG = self:_createOutSideCon()
    conForBG = WZUIContainer:luaTo(conForBG)

    local gapX = HVMAP_SIZEX / 2 
    local gapY = HVMAP_SIZEY / 2 

    if conForBG then
        conForBG:removeAllChildrenWithCleanup(true)
        for i = 1, tData.size[1][1] do
            local startX = 0 + (i - 1) * gapX
            local startY = tData.size[1][1] * 0.5 * HVMAP_SIZEY - (i - 1) * gapY
            for j = 1, tData.size[1][2] do
                local imgMap = WZUIImage:create()
                imgMap:setUseOriginSize(true)
                imgMap:setUseAbsCoordinate(true)
                if state == 1 then 
                    imgMap:setFile("ui/family/other/map/caodi02.png")
                elseif state == 2 then 
                    imgMap:setFile("ui/family/other/map/lvgezi01.png")
                    imgMap:setColor(GlobalMethod:ccc3(255,0,0))
                else
                    imgMap:setFile("ui/family/other/map/caodi01.png")
                end
                imgMap:setAbsPosition(GlobalMethod:ccp(startX + j * gapX, startY + (j - 1) * gapY))
                
                conForBG:addChild(imgMap)
            end
        end
    end
end


--@brief    显示建筑
function CellHVBuilding:_drawBuilding()
    -- body
    local tData = self.m_tData.basicData
    local nSceneState = self.m_tLuaTable:getSceneState()

    local imgBuilding = self:_createBuildingImageNode()
    WZLog("CellHVBuilding:_drawBuilding", tostring(imgBuilding))
    if imgBuilding then
        imgBuilding:setRelativePosition(GlobalMethod:ccp(tData.position[1][1], tData.position[1][2]))
        if self.m_tData.configId >= 20 then 
            local strName = tData.animation
            WZLog("CellHVBuilding:_drawBuilding", self.m_tData.configId, tostring(self.m_DecorationId))
            if self.m_DecorationId and (self.m_tData.configId == 25 or self.m_tData.configId == 22) and self.m_DecorationId > 0 then 
                local basicInfo = GDatatab_item["id_" .. self.m_DecorationId]
                if basicInfo.animation_index_code ~= -1 then 
                    local tConfigPath = SplitStringWithSeparator(basicInfo.animation_index_code, ",")
                    local nStart, nEnd = string.find(tConfigPath[1], ".png")
                    strName = "ui/holidayVillage/" .. tConfigPath[1]
                    imgBuilding:setRelativePosition(GlobalMethod:ccp(tonumber(tConfigPath[4]), tonumber(tConfigPath[5])))
                    imgBuilding:setScale(tonumber(tConfigPath[6]))
                    if not (nStart and nEnd) then 
                        WZLog("CellHVBuilding:_drawBuilding", tConfigPath[3])
                        if nSceneState == 1 then 
                            if imgBuilding:getAnimationName() ~= tConfigPath[3] then
                                imgBuilding:play(tConfigPath[3], true)
                            end
                        else
                            if imgBuilding:getAnimationName() ~= tConfigPath[2] then
                                imgBuilding:play(tConfigPath[2], true)
                            end
                        end
                        if imgBuilding:getFileAtlas() ~= strName..".atlas" and imgBuilding:getFileJson() ~= strName..".json" then
                            imgBuilding:setFileAtlas(strName .. ".atlas")
                            imgBuilding:setFileJson(strName .. ".json")
                        end
                    else
                        if nSceneState == 1 then 
                            strName = string.gsub(strName, ".png", "_1.png")
                        end
                        imgBuilding:setFile(strName)
                    end
                end
            else
                if nSceneState == 1 then 
                    strName = string.gsub(strName, ".png", "_1.png")
                end
                imgBuilding:setFile(strName)
            end
        elseif self.m_tData.configId > 0 and self.m_tData.configId < 20 then 
            local curFieldData = WndHVField:getFieldLevelData(self.m_tData)
            local strName = curFieldData.icon
            if curFieldData.maintype == 2 then 
                local tTmepArray = SplitStringWithSeparator(strName, ",")

                if nSceneState == 1 then
                    if imgBuilding:getAnimationName() ~= tTmepArray[2].."_1" then
                        imgBuilding:play(tTmepArray[2] .. "_1", true)
                    end
                else
                    if imgBuilding:getAnimationName() ~= tTmepArray[2] then
                        imgBuilding:play(tTmepArray[2], true)
                    end
                end
                if imgBuilding:getFileAtlas() ~= tTmepArray[1]..".atlas" and imgBuilding:getFileJson() ~= tTmepArray[1]..".json" then
                    imgBuilding:setFileAtlas(tTmepArray[1] .. ".atlas")
                    imgBuilding:setFileJson(tTmepArray[1] .. ".json")
                end
            else
                if nSceneState == 1 then 
                    strName = string.gsub(strName, ".png", "_1.png")
                end
                imgBuilding:setFile(strName)
            end
        	if self.m_tData.fieldStatus >= 1 then 
	        	self:_createExtendNode(true)
                self:_createStone()
                --提示操作图标
                self:_createOperateIcon()
                WZLog("CellHVBuilding:_drawBuilding 44", self.m_tData.flowerpotId, curFieldData.icon)
                if self.m_tData.flowerpotId and self.m_tData.flowerpotId > 0 then 
                    imgBuilding:setVisible(false)
                    local imgFlowerpot = self:_createFlowerpotImageNode()
                    local flowerpotData = GDatatab_item["id_" .. self.m_tData.flowerpotId]
                    if flowerpotData then
                        local tTmepArray1 = SplitStringWithSeparator(flowerpotData.animation_index_code, ",") 
                        local strFlowerpot
                        if curFieldData.maintype == 2 then 
                            local tTmepArray = SplitStringWithSeparator(strName, ",")
                            strFlowerpot = string.gsub(tTmepArray[1], "ui_djc_shuikeng", tTmepArray1[1])
                            strFlowerpot2 = string.gsub(tTmepArray[2], "wait", "_0")
                            strFlowerpot = strFlowerpot .. strFlowerpot2 .. ".png"
                        else
                            strFlowerpot = string.gsub(curFieldData.icon, "common_djc_tk", tTmepArray1[1])
                        end
                        imgFlowerpot:setFile(strFlowerpot)
                    end
                else
                    imgBuilding:setVisible(true)
                    self:_createFlowerpotImageNode(true)
                end
	        elseif self.m_tData.fieldStatus <= 0 then 
	        	if self.m_tData.fieldStatus == 0 then 
	        		self:_createExtendNode()
	        	end
	        end
        end
    end
end

--@brief    创建建筑Image节点
function CellHVBuilding:_createBuildingImageNode()
    -- body
    local conForBuilding = self:_createConForBuilding()
    local imgBuilding = conForBuilding:getChildByTag(98) 
    if not imgBuilding then 
        if self.m_tData.configId == 2 then 
            imgBuilding = WZUISpine:create()
        elseif self.m_DecorationId and (self.m_tData.configId == 25 or self.m_tData.configId == 22) and self.m_DecorationId > 0 then 
            local basicInfo = GDatatab_item["id_" .. self.m_DecorationId]
            if basicInfo.animation_index_code ~= -1 then 
                local tConfigPath = SplitStringWithSeparator(basicInfo.animation_index_code, ",")
                local nStart, nEnd = string.find(tConfigPath[1], ".png")
                if not (nStart and nEnd) then 
                    imgBuilding = WZUISpine:create()
                else
                    imgBuilding = WZUIImage:create()
                end
            end
        else
            imgBuilding = WZUIImage:create()
        end
        imgBuilding:setUseOriginSize(true)
        imgBuilding:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        imgBuilding:setTouchEnable(false)
        imgBuilding:setTag(98)
        imgBuilding:setZOrder(0)

        conForBuilding:addChild(imgBuilding)
        if self.m_tData.configId == 21 then --创建文字
            local txtName = createLabel(LocalStrings.HOLIDAYVILLAGE_TEXT2[17], GlobalMethod:ccp(0.48, 0.68), GlobalMethod:ccp(0.5, 0.5), 16, GlobalMethod:ccc3(255,236,193))
            if txtName then 
                txtName:setEnableStroke(true)
                txtName:setStrokeSize(4)
                txtName:setStrokeColor(GlobalMethod:ccc3(132,66,29))
                txtName:setRotation(-10)
                txtName:setZOrder(1)

                imgBuilding:addChild(txtName)
            end
        elseif self.m_tData.configId == 26 then --创建文字
            imgBuilding:setScaleX(-1)
            local txtName = createLabel(LocalStrings.HOLIDAYVILLAGE_TEXT1[8], GlobalMethod:ccp(0.48, 0.68), GlobalMethod:ccp(0.5, 0.5), 16, GlobalMethod:ccc3(255,236,193))
            if txtName then 
                txtName:setEnableStroke(true)
                txtName:setStrokeSize(4)
                txtName:setStrokeColor(GlobalMethod:ccc3(132,66,29))
                txtName:setRotation(-10)
                txtName:setZOrder(1)
                txtName:setScaleX(-1)

                imgBuilding:addChild(txtName)
            end
        end
    else
        if self.m_tData.configId == 2 then 
            imgBuilding = WZUISpine:luaTo(imgBuilding)
        elseif self.m_DecorationId and (self.m_tData.configId == 25 or self.m_tData.configId == 22) and self.m_DecorationId > 0 then 
            local basicInfo = GDatatab_item["id_" .. self.m_DecorationId]
            if basicInfo.animation_index_code ~= -1 then 
                local tConfigPath = SplitStringWithSeparator(basicInfo.animation_index_code, ",")
                local nStart, nEnd = string.find(tConfigPath[1], ".png")
                if not (nStart and nEnd) then 
                    imgBuilding = WZUISpine:luaTo(imgBuilding)
                else
                    imgBuilding = WZUIImage:luaTo(imgBuilding)
                end
            end
        else
            imgBuilding = WZUIImage:luaTo(imgBuilding)
        end
    end

    return imgBuilding
end

--@brief    创建花盆Image节点
--@param    bRemove:true移除
function CellHVBuilding:_createFlowerpotImageNode(bRemove)
    -- body
    local conForBuilding = self:_createConForBuilding()
    local imgBuilding = conForBuilding:getChildByTag(103) 
    if bRemove then 
        if imgBuilding then 
            imgBuilding:removeFromParentAndCleanup(true)
        end
    else
        if not imgBuilding then 
            imgBuilding = WZUIImage:create()
            imgBuilding:setUseOriginSize(true)
            imgBuilding:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
            imgBuilding:setRelativePosition(GlobalMethod:ccp(0.5, 0.1))
            imgBuilding:setTouchEnable(false)
            imgBuilding:setTag(103)
            imgBuilding:setZOrder(2)

            conForBuilding:addChild(imgBuilding)
        else
            imgBuilding = WZUIImage:luaTo(imgBuilding)
        end

        return imgBuilding
    end
end

--@brief    创建扩建节点
function CellHVBuilding:_createExtendNode(bRemove)
    -- body
    --自己的度假村才显示扩建标记
    if self.m_tLuaTable:getHostId() ~= CacheCenter:getPlayerInfo().id then return end 

    local conForBuilding = self:_createConForBuilding()
    local imgBuilding = conForBuilding:getChildByTag(99) 
    if bRemove then 
    	if imgBuilding then 
    		imgBuilding:removeFromParentAndCleanup(true)
    	end
    else
        local hostInfo = self.m_tLuaTable:getHostInfo()
        local fieldConfig = WndHVField:getFieldLevelData(self.m_tData)
	    if not imgBuilding then 
	        imgBuilding = WZUIImage:create()
	        imgBuilding:setUseOriginSize(true)
	        imgBuilding:setAnchorPoint(GlobalMethod:ccp(0.5, 0.3))
            imgBuilding:setRelativePosition(GlobalMethod:ccp(0.5, 0.6))
	        imgBuilding:setTouchEnable(false)
	        imgBuilding:setTag(99)
	        imgBuilding:setZOrder(2)
	        imgBuilding:setFile("ui/holidayVillage/otherImg/common_btn_xdgy.png")
            --文字提示
            local txtAtt = WZUILabelTTF:create()
            local strAtt = LocalStrings.HOLIDAYVILLAGE_TEXT1[65]
            if hostInfo.hvLevel < fieldConfig.need_lv then 
                strAtt = string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[66], fieldConfig.need_lv)
            end
            txtAtt:setText(strAtt)
            txtAtt:setFontSize(18)
            txtAtt:setColor(GlobalMethod:ccc3(255,236,193))
            txtAtt:setStrokeColor(GlobalMethod:ccc3(132,66,29))
            txtAtt:setEnableStroke(true)
            txtAtt:setStrokeSize(4)
            txtAtt:setRelativePosition(GlobalMethod:ccp(0.5, 0.58))
            imgBuilding:addChild(txtAtt, 1, 11)

	        conForBuilding:addChild(imgBuilding)

            if ProjConfig.LANGUAGE == "vn" then
                txtAtt:setFontSize(14)
                txtAtt:setDimensions(GlobalMethod:CCSize(90,0))
            end
	    else
	        imgBuilding = WZUIImage:luaTo(imgBuilding)
            local txtAtt = imgBuilding:getChildByTag(11)
            if txtAtt then 
                txtAtt = WZUILabelTTF:luaTo(txtAtt)
                local strAtt = LocalStrings.HOLIDAYVILLAGE_TEXT1[65]
                if hostInfo.hvLevel < fieldConfig.need_lv then 
                    strAtt = string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[66], fieldConfig.need_lv)
                end
                txtAtt:setText(strAtt)
            end

            if ProjConfig.LANGUAGE == "vn" then
                txtAtt:setFontSize(14)
                txtAtt:setDimensions(GlobalMethod:CCSize(90,0))
            end
	    end
        if fieldConfig.maintype == 2 then 
            self.m_tLuaTable:setExtendFieldCell(nil, self)
        else
            self.m_tLuaTable:setExtendFieldCell(self)
        end

	    return imgBuilding
	end
end

--@brief    创建作物Image节点
function CellHVBuilding:_createPlantImageNode()
    -- body
    local conForBuilding = self:_createConForBuilding()
    local nTag = 100
    local nTag2 = 102  --幼苗和成熟阶段
    local imgPlant = conForBuilding:getChildByTag(nTag) 
    local spinePlant = conForBuilding:getChildByTag(nTag2) 
    if self.m_tData.plantId == 0 then 
        if imgPlant then 
            conForBuilding:removeChildByTag(nTag, true)
        end
        if spinePlant then 
            conForBuilding:removeChildByTag(nTag2, true)
        end
        return 
    end 

    local tData = self.m_tData.basicData

    local extrPoint = {0, 0}
    if self.m_tData.flowerpotId and self.m_tData.flowerpotId > 0 then 
        local flowerpotData = GDatatab_item["id_" .. self.m_tData.flowerpotId]
        if flowerpotData then
            local tTmepArray1 = SplitStringWithSeparator(flowerpotData.animation_index_code, ",") 
            extrPoint[1] = tonumber(tTmepArray1[2])
            extrPoint[2] = tonumber(tTmepArray1[3])
        end
    end
    if not imgPlant then 
        imgPlant = WZUIImage:create()
        imgPlant:setUseOriginSize(true)
        imgPlant:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        imgPlant:setRelativePosition(GlobalMethod:ccp(0.5 + extrPoint[1], 0.4 + extrPoint[2]))
        imgPlant:setTouchEnable(false)
        imgPlant:setTag(nTag)
        imgPlant:setZOrder(3)

        conForBuilding:addChild(imgPlant)
    else
        imgPlant = WZUIImage:luaTo(imgPlant)
        imgPlant:setRelativePosition(GlobalMethod:ccp(0.5 + extrPoint[1], 0.4 + extrPoint[2]))
    end

    local seedData = WndHVLibrary:getSeedDataByItemId(self.m_tData.plantId)
    imgPlant:setScale(1)
    if self.m_tData.plantStatus == 0 then 
        imgPlant:setScale(0.6)
        imgPlant:setRelativePosition(GlobalMethod:ccp(0.5 + extrPoint[1], 0.25 + extrPoint[2]))
        imgPlant:setFile(seedData.icon_zz)
    elseif self.m_tData.plantStatus == 1 then 
        if seedData.icon_ym == -1 then 
            if not spinePlant then 
                spinePlant = WZUISpine:create()
                spinePlant:setUseOriginSize(true)
                spinePlant:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
                spinePlant:setTouchEnable(false)
                spinePlant:setTag(nTag2)
                spinePlant:setZOrder(3)
                spinePlant:setFileAtlas(seedData.icon_cs .. ".atlas")
                spinePlant:setFileJson(seedData.icon_cs .. ".json")

                conForBuilding:addChild(spinePlant)
            else
                spinePlant = WZUISpine:luaTo(spinePlant)
            end
            if seedData.position2 ~= -1 then 
                spinePlant:setRelativePosition(GlobalMethod:ccp(seedData.position2[1][1] + extrPoint[1], seedData.position2[1][2] + extrPoint[2]))
            else
                spinePlant:setRelativePosition(GlobalMethod:ccp(0.5 + extrPoint[1], 0.4 + extrPoint[2]))
            end
            spinePlant:play(seedData.actions1, true)
            imgPlant:setFile("")
        else
            imgPlant:setFile(seedData.icon_ym)
            if seedData.position2 and seedData.position2 ~= -1 then 
                imgPlant:setRelativePosition(GlobalMethod:ccp(seedData.position2[1][1] + extrPoint[1], seedData.position2[1][2] + extrPoint[2]))
            end
        end
    elseif self.m_tData.plantStatus == 2 then 
        if not spinePlant then 
            spinePlant = WZUISpine:create()
            spinePlant:setUseOriginSize(true)
            spinePlant:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
            spinePlant:setTouchEnable(false)
            spinePlant:setTag(nTag2)
            spinePlant:setZOrder(3)
            spinePlant:setFileAtlas(seedData.icon_cs .. ".atlas")
            spinePlant:setFileJson(seedData.icon_cs .. ".json")

            conForBuilding:addChild(spinePlant)
        else
            spinePlant = WZUISpine:luaTo(spinePlant)
        end
        if seedData.position ~= -1 then 
            spinePlant:setRelativePosition(GlobalMethod:ccp(seedData.position[1][1] + extrPoint[1], seedData.position[1][2] + extrPoint[2]))
        else
            spinePlant:setRelativePosition(GlobalMethod:ccp(0.5 + extrPoint[1], 0.4 + extrPoint[2]))
        end
        spinePlant:play(seedData.actions, true)
        imgPlant:setFile("")
    end

    return imgPlant
end

--@brief    生成害虫
function CellHVBuilding:_createPlantPestNode()
    -- body
    local conForBuilding = self:_createConForBuilding()
    local spinePest = conForBuilding:getChildByTag(101) 
    if self.m_tData.plantId == 0 then 
        if spinePest then 
            conForBuilding:removeChildByTag(101, true)
        end
        return 
    end 

    local tData = self.m_tData
    if tData.plantPests <= 0 then 
        if spinePest then 
            conForBuilding:removeChildByTag(101, true)
        end
        return 
    end
    local extrPoint = {0, 0}
    if self.m_tData.flowerpotId and self.m_tData.flowerpotId > 0 then 
        local flowerpotData = GDatatab_item["id_" .. self.m_tData.flowerpotId]
        if flowerpotData then
            local tTmepArray1 = SplitStringWithSeparator(flowerpotData.animation_index_code, ",") 
            extrPoint[1] = tonumber(tTmepArray1[2])
            extrPoint[2] = tonumber(tTmepArray1[3])
        end
    end
    if not spinePest then 
        spinePest = WZUISpine:create()
        spinePest:setUseOriginSize(true)
        spinePest:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        spinePest:setRelativePosition(GlobalMethod:ccp(0.55 + extrPoint[1], 0.3 + extrPoint[2]))
        spinePest:setTouchEnable(false)
        spinePest:setTag(101)
        spinePest:setZOrder(3)

        conForBuilding:addChild(spinePest)
    else
        spinePest = WZUISpine:luaTo(spinePest)
        spinePest:setRelativePosition(GlobalMethod:ccp(0.55 + extrPoint[1], 0.3 + extrPoint[2]))
    end

    local plantPetsData = GDatatab_holiday_bug["id_" .. tData.plantPests]
    if plantPetsData.type == 2 then 
        spinePest:setFileAtlas("ui/holidayVillage/ui_djc_mifeng.atlas")
        spinePest:setFileJson("ui/holidayVillage/ui_djc_mifeng.json")
    else
        spinePest:setFileAtlas("ui/holidayVillage/ui_djc_daoju1.atlas")
        spinePest:setFileJson("ui/holidayVillage/ui_djc_daoju1.json")
    end

    local aniName = ""
    if self.m_tData.plantPests == 2 then --菜虫
        aniName = "wait_5"
    elseif self.m_tData.plantPests == 1 then --七星瓢虫
        aniName = "wait_6"
    elseif self.m_tData.plantPests == 3 then --蝗虫
        aniName = "wait_7"
    elseif self.m_tData.plantPests == 4 then --蝴蝶
        aniName = "wait2"
    elseif self.m_tData.plantPests == 5 then --蜜蜂
        aniName = "wait1"
    end
    spinePest:play(aniName, true)

    return spinePest
end

--@brief    创建建筑物容器节点
function CellHVBuilding:_createConForBuilding()
    -- body
    local conOutSide = self:_createOutSideCon()

    local conForBuilding = conOutSide:getChildByTag(92)

    if not conForBuilding then 
        local tData = self.m_tData.basicData
        local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * HVMAP_SIZEX
        local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * HVMAP_SIZEY

        conForBuilding = WZUIContainer:create()
        conForBuilding:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conForBuilding:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        conForBuilding:setTouchEnable(false)
        conForBuilding:setUseAbsSize(true)
        conForBuilding:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
        conForBuilding:setZOrder(2)
        conForBuilding:setTag(92)

        conOutSide:addChild(conForBuilding)
    else
        conForBuilding = WZUIContainer:luaTo(conForBuilding)
    end

    return conForBuilding
end

--@brief    创建建筑物容器节点
function CellHVBuilding:_createBtnBuilding()
    -- body
    local conOutSide = self:_createOutSideCon()

    local btnBuilding = conOutSide:getChildByTag(91)

    if not btnBuilding then 
        local tData = self.m_tData.basicData
        local nConWidth = tData.size[1][2] * HVMAP_REAL_WIDTH
        local nConHeight = tData.size[1][1] * HVMAP_REAL_WIDTH

        btnBuilding = WZUIButton:create()
        btnBuilding:setName("btnBuilding_CellHVBuilding")
        btnBuilding:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        btnBuilding:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        btnBuilding:setUseAbsSize(true)
        btnBuilding:setRotation(-45)
        btnBuilding:setLuaDoneFunctionName("onClickBuilding")
        btnBuilding:setLuaPushFunctionName("ptInBtnCallBack")
        btnBuilding:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
        btnBuilding:setZOrder(3)
        btnBuilding:setTag(91)

        conOutSide:addChild(btnBuilding)
    else
        btnBuilding = WZUIButton:luaTo(btnBuilding)
    end

    return btnBuilding
end

--@brief    创建根容器节点
function CellHVBuilding:_createOutSideCon()
    -- body
    local conOutSide = self.m_root:getChildByTag(90)

    if not conOutSide then 
        local tData = self.m_tData.basicData
        local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * HVMAP_SIZEX
        local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * HVMAP_SIZEY

        conOutSide = WZUIContainer:create()
        conOutSide:setUseAbsSize(true)
        conOutSide:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
        conOutSide:setTag(90)
        conOutSide:setShowAll(true)
    --    BattleAnimation:addRect({x=nConWidth/2, y=nConHeight/2, w=nConWidth, h=nConHeight},{r = 255,g = 255,b = 255,a = 1.0}, conOutSide)
        self.m_root:addChild(conOutSide)
    else
        conOutSide = WZUIContainer:luaTo(conOutSide)
    end

    return conOutSide
end

--@brief    创建建筑的箭头
function CellHVBuilding:_createBuildingArrow(bVisible)
    -- body
    local conForBuilding = self:_createConForBuilding()
    if conForBuilding:getChildByTag(96) then
        conForBuilding:removeChildByTag(96, true)
    end
    WZLog("CellHVBuilding:_createBuildingArrow", bVisible)
    self.m_bIsChoose = bVisible
    if bVisible then
        local tData = self.m_tData.basicData
        local nConWidth = tData.size[1][2] * HVMAP_REAL_WIDTH
        local nConHeight = tData.size[1][1] * HVMAP_REAL_WIDTH

        local conForArrow = WZUIContainer:create()
        conForArrow:setTouchContainerEnable(false)
        conForArrow:setTouchEnable(false)
        conForArrow:setUseAbsSize(true)
        conForArrow:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
        conForArrow:setZOrder(1)
        conForArrow:setTag(96)

        conForBuilding:addChild(conForArrow)

        --右箭头
        local imgRightArrow = WZUIImage:create()
        imgRightArrow:setFile("ui/holidayVillage/otherImg/common_djc_tk_04.png")
        imgRightArrow:setUseOriginSize(true)
        imgRightArrow:setTouchEnable(false)
        imgRightArrow:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        imgRightArrow:setRelativePosition(GlobalMethod:ccp(0.48,0.47))

        conForArrow:addChild(imgRightArrow)
    end
end

--@brief    创建源石
function CellHVBuilding:_createStone()
    if self.m_tData.fieldStatus <= 0 then return end 

    local conForBuilding = self:_createConForBuilding()
    local extraInfo = self.m_tData.extraInfo
    WZLog("CellHVBuilding:_createStone", Serialize(extraInfo))
    --设置解锁等级
    local tData = self.m_tData.basicData
    local nConWidth = tData.size[1][2] * HVMAP_REAL_WIDTH
    local nConHeight = tData.size[1][1] * HVMAP_REAL_WIDTH * 0.8
    local conForStone = conForBuilding:getChildByTag(95)
    if not conForStone then
        conForStone = WZUIContainer:create()
        conForStone:setTouchContainerEnable(false)
        conForStone:setTouchEnable(false)
        conForStone:setUseAbsSize(true)
        conForStone:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
        conForStone:setZOrder(2)
        conForStone:setTag(95)

        conForBuilding:addChild(conForStone)
    else
        conForStone = WZUIContainer:luaTo(conForStone)
    end

    local tPosList = {GlobalMethod:ccp(0.5, 0.9), GlobalMethod:ccp(-0.2, 0.5), GlobalMethod:ccp(1.2, 0.5), GlobalMethod:ccp(0.5, 0)}
    for i = 1, 4 do
        local imgStone = conForStone:getChildByTag(i - 1)
        if extraInfo[tostring(i - 1)] then 
            local basicData = GDatatab_item["id_" .. extraInfo[tostring(i - 1)]]
            if basicData then 
                if not imgStone then 
                    imgStone = WZUIImage:create()
                    imgStone:setScale(0.4)
                    imgStone:setUseOriginSize(true)
                    imgStone:setTag(i - 1)
                    imgStone:setRelativePosition(tPosList[i])
                    conForStone:addChild(imgStone)
                else
                    imgStone = WZUIImage:luaTo(imgStone)
                end
                imgStone:setFile(basicData.icon)
            else
                if imgStone then 
                    conForStone:removeChildByTag(i - 1, true)
                end
            end
        else
            if imgStone then 
                conForStone:removeChildByTag(i - 1, true)
            end
        end
    end
end

--@brief    创建提示图标
function CellHVBuilding:_createOperateIcon()
    if self.m_tData.fieldStatus <= 0 then return end 

    local conForBuilding = self:_createConForBuilding()
    local nTag = 89
    local element = conForBuilding:getChildByTag(nTag)
    if element then 
        conForBuilding:removeChildByTag(nTag, true)
    end
    local nTag2 = 88
    local element = conForBuilding:getChildByTag(nTag2)
    if element then 
        conForBuilding:removeChildByTag(nTag2, true)
    end

    local fieldData = self.m_tData 
    local operateType = 0 
    if self.m_tLuaTable:isMyHolidayVillage() then 
        if fieldData.fieldStatus == 1 then 
            if fieldData.plantId == 0 and not fieldData.bIsDig then  --尚未挖坑
                operateType = 8 
            elseif fieldData.plantId > 0 and not fieldData.bIsWater then --未浇水
                operateType = 3
            elseif fieldData.plantId > 0 and fieldData.plantStatus == PLANT_STATUS.MATURITY then --采摘
                operateType = 5
            end
        end
    end

    if operateType ~= 0 then 
        element = WZUIImage:create()
        element:setUseOriginSize(true)
        element:setVisible(false)
        element:setTouchEnable(false)
        element:setTag(nTag)
        element:setZOrder(4)
        element:setScale(0.6)
        element:setRelativePosition(GlobalMethod:ccp(0.5,0.6))

        conForBuilding:addChild(element)
    end
    local extrPoint = {0, 0}
    if self.m_tData.flowerpotId and self.m_tData.flowerpotId > 0 then 
        local flowerpotData = GDatatab_item["id_" .. self.m_tData.flowerpotId]
        if flowerpotData then
            local tTmepArray1 = SplitStringWithSeparator(flowerpotData.animation_index_code, ",") 
            extrPoint[1] = tonumber(tTmepArray1[2])
            extrPoint[2] = tonumber(tTmepArray1[3])
        end
    end
    if operateType == 3 then --浇水
        element:setRelativePosition(GlobalMethod:ccp(0.5 + extrPoint[1], 0.9 + extrPoint[2]))
        element:setVisible(true)
        element:setFile("ui/holidayVillage/otherImg/djc_ssh.png")
        --创建文字提示
        local conForText = WZUIContainer:create()
        conForText:setUseAbsSize(true)
        conForText:setTag(nTag2)
        conForText:setZOrder(4)
        conForBuilding:addChild(conForText)
        local txtAtt = createLabel(LocalStrings.HOLIDAYVILLAGE_TEXT1[71], nil, GlobalMethod:ccp(0.5, 0.5), 16, GlobalMethod:ccc3(255,236,193))
        txtAtt:setDimensions(GlobalMethod:CCSize(130))
        conForText:addChild(txtAtt, 1)
        local size = txtAtt:getContentSize()
        WZLog("CellHVBuilding:_createOperateIcon 333", size.width, size.height)
        conForText:setAbsContentSize(GlobalMethod:CCSize(size.width + 10, 40))
        conForText:updateRelativeSize()
        conForText:setRelativePosition(GlobalMethod:ccp(0.5 + extrPoint[1], 1.2 + extrPoint[2]))
        local img9Bk = WZUI9Image:create()
        img9Bk:setFile("ui/common/common_scale9_di49.png")
        img9Bk:setTouchEnable(false)
        img9Bk:setOpacity(150)
        conForText:addChild(img9Bk)
        return 
    elseif operateType == 4 then --抓虫
        element:setRelativePosition(GlobalMethod:ccp(0.5 + extrPoint[1], 0.6 + extrPoint[2]))
        element:setVisible(true)
        element:setFile("ui/holidayVillage/otherImg/djc_byw.png")
        return 
    elseif operateType == 5 then --采摘
        --采摘提示
        local conForAtt = WZUIContainer:create()
        conForAtt:setUseAbsSize(true)
        conForAtt:setTag(nTag2)
        conForAtt:setScale(0.9)
        conForAtt:setZOrder(4)
        conForBuilding:addChild(conForAtt)
        local imgStar = createImage("ui/holidayVillage/otherImg/common_icon_djc_cs.png", GlobalMethod:ccp(0, 0.5), nil, true, GlobalMethod:ccp(0, 0.5))
        conForAtt:addChild(imgStar)
        local txtAtt = createLabel(LocalStrings.HOLIDAYVILLAGE_TEXT1[85], GlobalMethod:ccp(1, 0.5), GlobalMethod:ccp(0, 0.5), 16, GlobalMethod:ccc3(99,255,95))
        txtAtt:setStrokeSize(4)
        txtAtt:setStrokeColor(GlobalMethod:ccc3(132,66,29))
        txtAtt:setEnableStroke(true)
        imgStar:addChild(txtAtt, 1)
        local size = txtAtt:getContentSize()
        local sizeImg = imgStar:getContentSize()
        WZLog("CellHVBuilding:_createOperateIcon 55", size.width, size.height, sizeImg.width, sizeImg.height)
        conForAtt:setAbsContentSize(GlobalMethod:CCSize(size.width + sizeImg.width, sizeImg.height))
        conForAtt:updateRelativeSize()
        conForAtt:setRelativePosition(GlobalMethod:ccp(0.5 + extrPoint[1], 1.2 + extrPoint[2]))
        --呼吸效果
        local action = WZUIActionSequence:create()
        action:setIsLoop(true)

        local actionScale = WZUIActionScaleTo:create()
        actionScale:setDuration(0.5)
        actionScale:setScaleX(1.1)
        actionScale:setScaleY(1.1)

        local actionScale1 = WZUIActionScaleTo:create()
        actionScale1:setDuration(0.5)
        actionScale1:setScaleX(0.9)
        actionScale1:setScaleY(0.9)

        action:setChildAction(actionScale)
        action:setChildAction(actionScale1)

        conForAtt:runUIAction(action)
        return 
    elseif operateType == 6 then --偷取
        element:setRelativePosition(GlobalMethod:ccp(0.5 + extrPoint[1], 0.6 + extrPoint[2]))
        element:setVisible(true)
        element:setFile("ui/holidayVillage/otherImg/djc_st.png")
        return 
    elseif operateType == 8 then --挖坑
        element:setRelativePosition(GlobalMethod:ccp(0.5 + extrPoint[1], 0.6 + extrPoint[2]))
        element:setVisible(true)
        element:setFile("ui/holidayVillage/otherImg/djc_ct.png")
        return 
    end
end

--@brief    创建收获后，获得的奖励
function CellHVBuilding:createReward(itemIds, itemNums)
    local conForBuilding = self:_createConForBuilding()
    local nTag = 87
    local conForReward = conForBuilding:getChildByTag(nTag)
    if not conForReward then 
        local tData = self.m_tData.basicData
        local nConWidth = tData.size[1][2] * HVMAP_REAL_WIDTH
        local nConHeight = tData.size[1][1] * HVMAP_REAL_WIDTH

        conForReward = WZUIContainer:create()
        conForReward:setTouchContainerEnable(false)
        conForReward:setTouchEnable(false)
        conForReward:setUseAbsSize(true)
        conForReward:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
        conForReward:setZOrder(4)
        conForReward:setTag(nTag)

        conForBuilding:addChild(conForReward)
    else
        conForReward = WZUIContainer:luaTo(conForReward)
    end

    conForReward:removeAllChildrenWithCleanup(true)
    local posList = {GlobalMethod:ccp(0.5, 0.2), GlobalMethod:ccp(0, 0.5), GlobalMethod:ccp(1, 0.5), GlobalMethod:ccp(0.5, 0.8), GlobalMethod:ccp(0.5, 0.5),
    GlobalMethod:ccp(0, 0.8), GlobalMethod:ccp(1, 0.8)}
    local nCount = #itemIds
    local randomList = GetRandomNum(nCount, 18, 8)
    local nIndex = 0  
    local nMaxTime = 0  
    for i = 1, #randomList do
        if randomList[i] > nMaxTime then 
            nMaxTime = randomList[i]
            nIndex = i 
        end
    end
    for i = 1, #itemIds do
        local conTemp = WZUIContainer:create()
        conTemp:setTouchContainerEnable(false)
        conTemp:setTouchEnable(false)
        conTemp:setUseAbsSize(true)
        conTemp:setAbsContentSize(GlobalMethod:CCSize(66, 66))
        conTemp:setRelativePosition(posList[i])
        conForReward:addChild(conTemp)

        local imgBg = createImage("ui/holidayVillage/otherImg/commom_qipao_5.png", nil, nil,true, GlobalMethod:ccp(0.5, 0.5))
        imgBg:setTouchEnable(false)
        conTemp:addChild(imgBg)

        local strName = ""
        if itemIds[i] > 0 then 
            local basicData = GDatatab_item["id_" .. itemIds[i]]
            if basicData then 
                strName = basicData.name
            end
        else
            if itemIds[i] == -1 then 
                strName = LocalStrings.HOLIDAYVILLAGE_TEXT1[70]
            elseif itemIds[i] == -2 then 
                strName = LocalStrings.HOLIDAYVILLAGE_TEXT1[89]
            elseif itemIds[i] == -3 then 
                strName = LocalStrings.HOLIDAYVILLAGE_TEXT1[90]
            end
        end
        local txtName = createLabel(strName, GlobalMethod:ccp(0.5, 0.66), GlobalMethod:ccp(0.5, 0.5), 16, GlobalMethod:ccc3(255,227,116))
        txtName:setStrokeSize(4)
        txtName:setStrokeColor(GlobalMethod:ccc3(132,66,29))
        txtName:setEnableStroke(true)
        conTemp:addChild(txtName)
        --数量
        local txtNum = createLabel("+" .. itemNums[i], GlobalMethod:ccp(0.5, 0.34), GlobalMethod:ccp(0.5, 0.5), 16, GlobalMethod:ccc3(255,236,193))
        txtNum:setStrokeSize(4)
        txtNum:setStrokeColor(GlobalMethod:ccc3(132,66,29))
        txtNum:setEnableStroke(true)
        conTemp:addChild(txtNum)

        local action = WZUIActionSequence:create()

        local actionDelay1 = WZUIActionDelayTime:create()
        actionDelay1:setDuration(randomList[i]/10)

        local actionScale = WZUIActionScaleTo:create()
        actionScale:setDuration(0.3)
        actionScale:setScaleX(0)
        actionScale:setScaleY(0)

        local actionMove = WZUIActionMoveBy:create()
        actionMove:setDuration(0.8)
        actionMove:setMoveX(0)
        actionMove:setMoveY(50)


        local actionFadeTo1 = WZUIActionFadeTo:create()
        actionFadeTo1:setOpacity(0)
        actionFadeTo1:setDuration(0.05)

        action:setChildAction(actionDelay1)
        action:setChildAction(actionMove)
        action:setChildAction(actionScale)
        action:setChildAction(actionFadeTo1)

        if i == nIndex then 
            actionFadeTo1:setFinishLuaFunction("cleanAllReward")       
        end
        conTemp:runUIAction(action) 
    end
end

--@brief    道具出现回调
function CellHVBuilding:cleanAllReward(element)
    local conForBuilding = self:_createConForBuilding()
    local nTag = 87
    local conForReward = conForBuilding:getChildByTag(nTag)
    if conForReward then 
        conForReward:removeAllChildrenWithCleanup(true)
    end
end
-------------------------------------私有方法模块End----------------------------------------
