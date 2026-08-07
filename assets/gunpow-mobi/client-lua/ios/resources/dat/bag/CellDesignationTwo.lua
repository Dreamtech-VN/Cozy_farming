--CellDesignationTwo.lua
--@brief	CellDesignationTwo的UI模块
--@date		2015/03/26
--@author	clc
--@note		成就系统-成就面板-子分类cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDesignationTwo:onEnter(element)
	self.m_root     = element
	self.n_CellType = 2   --此cell类型为2 
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDesignationTwo:onExit(element)
	self:_unInit()
end

--@brief    点击本cell函数回调
function CellDesignationTwo:onClickCell()
	WZLog("CellDesignationTwo:onClickCell*****************************************")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndDesignationMain:acceptPrize(self.n_JobId)
end

--@brief    点击复选框设置称号
function CellDesignationTwo:onClickCheckBox(element)
    -- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local  nTag  = self.m_root:getTag()
    WndDesignationMain:onClickDesignation(nTag, self.n_JobId)
end

--@brief    加载数据信息
function CellDesignationTwo:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellDesignationTwo")
    self.m_root:addChild(cellElement)

    self.m_bIsLoad = true
    if WndDesignationMain.m_nclickedMainClassicId == 13 then
        self:_updateDesi()
    else
        self:_update(self.m_tData.title ,self.m_tData.desc, self.m_tData.status, self.m_tData.reward, self.m_tData.nComplete, self.m_tData.nTarget)
    end
    AdaptLanguage(self)
end

--@brief    设置成就复选框称号使用状态
function CellDesignationTwo:setClicked(bVisible)
    -- body
    self.m_bGouVisible = bVisible
    if bVisible then
        self.m_tData.status = 2
    end
    WZLog("CellDesignationTwo:setClicked", self.m_bIsLoad, bVisible)
    if not self.m_bIsLoad then return end 

    local imgYellowRect = GetElement(self.m_root, "imgYellowRect_CellDesignationTwo", WZUIImage)
    local imgGou = GetElement(self.m_root, "imgGou_CellDesignationTwo", WZUIImage)
    if bVisible == false then
        imgYellowRect:setVisible(false)
        imgGou:setVisible(false)
    else
        imgYellowRect:setVisible(true)
        imgGou:setVisible(true)
    end
end

--@brief  设置子成就的状态
function  CellDesignationTwo:setCellStatus(status)
    -- body
    WZLog("CellDesignationTwo:setCellUI",status)
    if self.m_bIsLoad == false then return end

    if self.m_root == nil then
        return  
    end

    local  btnSetDesi = GetElement(self.m_root, "btnSetDesi_CellDesignationTwo", WZUIButton)
    local  btnAccept = GetElement(self.m_root, "btnAccept_CellDesignationTwo",WZUIButton)
    local   ftxtDesc  = GetElement(self.m_root, "ftxtDesc_CellDesignationTwo", WZUIFreeTextBox)
    local descFormat = [[<T C="79,60,48" S="18" P="1">%s</T><T C="158,0,0" S="18" P="1">%s</T>]]

    if status > 0 then
        if self.m_tData.reward ~= -1 and status ~= 3 then
            if CacheCenter:judgeWhetherDesiUsed(self.n_JobId) then
                btnAccept:setVisible(false)
                btnSetDesi:setVisible(true)
            else
                btnAccept:setVisible(true)
                btnSetDesi:setVisible(false)
            end
        else
            btnSetDesi:setVisible(true)
            btnAccept:setVisible(false)
        end
        
        if self.m_tData.desc ~= nil and self.m_tData.desc ~= -1 then
            ftxtDesc:setShowText(string.format(descFormat, self.m_tData.desc, ""))
        end
    else
        btnSetDesi:setVisible(false)
        btnAccept:setVisible(false)
    end
end

--@brief    获取奖励物品的图标
function CellDesignationTwo:getIconFile(itemId)
    -- body
    local tItemTable = GDatatab_item["id_" .. tostring(itemId)]

    return tItemTable.icon
end

--@brief  设置此子成就的id
--@param  nJobId:子成就id
function CellDesignationTwo:setJobId( nJobId )
	-- body
	self.n_JobId  = nJobId
end

--@brief  返回此子成就id
function  CellDesignationTwo:getJobId( )
	-- body
	return self.n_JobId
end

--@brief 获取此cell的类型
function CellDesignationTwo:getCellType( )
	-- body
	return self.n_CellType
end

--@brief    设置红点是否可见
function CellDesignationTwo:setRedDotVisible(bVisible)
    -- body
    self.m_bRedDotVisible = bVisible 
    if self.m_bIsLoad == false then return end 

    local imgRedDot = GetElement(self.m_root, "imgRedDot_CellDesignationTwo", WZUIImage)
    if bVisible then
        imgRedDot:setVisible(true)
    else
        imgRedDot:setVisible(false)
    end
end

--@brief    获取是否有红点
function CellDesignationTwo:getRedDotState()
    -- body
    if self.m_tData.status == 3 then
        return true
    else
        return false
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新节点信息
function CellDesignationTwo:_update(title ,desc, status, reward, nComplete, nTarget)
    -- body
    WZLog("CellDesignationTwo:_update", title ,desc, status, reward, nComplete, nTarget)
    if self.m_root == nil then
        WZLog("00000000000000000")
        return  
    end

    local   ftxtDesc  = GetElement(self.m_root, "ftxtDesc_CellDesignationTwo", WZUIFreeTextBox)
    local   btnSetDesi = GetElement(self.m_root, "btnSetDesi_CellDesignationTwo", WZUIButton)
    local   btnAccept = GetElement(self.m_root, "btnAccept_CellDesignationTwo",WZUIButton)
    local   txtDesName = GetElement(self.m_root, "txtDesName_CellDesignationTwo", WZUILabelTTF)
    local   txtStateWord = GetElement(self.m_root, "txtStateWord_CellDesignation", WZUILabelTTF)

    --描述
    local descFormat = [[<T C="79,60,48" S="18" P="1">%s</T><T C="158,0,0" S="18" P="1">%s</T>]]
    -- if desc ~= nil and desc ~= -1 then
    --     name_Label:setText(desc)
    --     if ProjConfig.LANGUAGE == "en" then
    --         if string.len(desc) > 50 then
    --             name_Label:setFontSize(14)
    --         end
    --     end
    --     if ProjConfig.LANGUAGE == "th" then
    --         if string.len(desc) > 100 then
    --             name_Label:setFontSize(14)
    --         end
    --     end
    -- end
    --称号
    if title ~= nil then
        local conTitle = GetElement(self.m_root, "conTitle_CellDesignationTwo", WZUIContainer)
        local tempPoint = GlobalMethod:ccp(0.5,0.89)

        local sTitleName = SplitStringWithSeparator(title,"&")
        local sNewTitle, nLetterNum = string.gsub(title, "&", ",")

        if sTitleName[2] ~= nil and sTitleName[2] ~= "" then
            if tonumber(sTitleName[2]) == nil or nLetterNum > 2 then

            else
                local bExist = WZFileUtil:isFileExist(string.format(g_sTitleSpineName, sTitleName[2]) .. ".json")
                if bExist then
                    bTitleStroke = true 
                    txtDesName:setColor(GlobalMethod:ccc3(233,166,62))
                    txtDesName:setEnableStroke(true)
                end
            end
        end

        CreateDesiSpine(conTitle, txtDesName, title, tempPoint)
        if ProjConfig.LANGUAGE == "es" then
            txtDesName:setText(LocalStrings.CAN_GET_DESIGNATION .. "[" .. sTitleName[1] .. "]")
        end
    end

    --展示奖励
    if reward ~= -1 then
        for i = 1, #reward do
            local imgIcon_Reward = GetElement(self.m_root, string.format("imgIcon_Reward%d", i), WZUIImage)
            local iconFile = self:getIconFile(reward[i][1])
            if iconFile ~= nil then
                imgIcon_Reward:setFile(iconFile) 
            end
            local txtNumber_Reward = GetElement(self.m_root, string.format("txtNumber_Reward%d", i), WZUILabelTTF)
            txtNumber_Reward:setText(reward[i][2])
        end
    end

    if status ~= nil and status > 0 then
        if reward ~= -1 and status ~= 3 then
            if CacheCenter:judgeWhetherDesiUsed(self.n_JobId) then
                btnAccept:setVisible(false)
                btnSetDesi:setVisible(true)
            else
                btnAccept:setVisible(true)
                btnSetDesi:setVisible(false)
            end
        else
            btnSetDesi:setVisible(true)
            btnAccept:setVisible(false)
        end
        
        if desc ~= nil and desc ~= -1 then
            ftxtDesc:setShowText(string.format(descFormat, desc, ""))
        end
        txtStateWord:setVisible(false)
    else
        txtStateWord:setVisible(true)
        txtStateWord:setText(LocalStrings.UNCOMPLETE)
        btnSetDesi:setVisible(false)
        btnAccept:setVisible(false)
        if nComplete ~= nil and nTarget ~= nil then
            local txtProgress = string.format("(%d/%d)", nComplete, nTarget)
            if desc ~= nil and desc ~= -1 then
                ftxtDesc:setShowText(string.format(descFormat, desc, txtProgress))
            end
        end
    end

    self:setClicked(self.m_bGouVisible)
end

--@brief    更新特殊称号列表信息
function CellDesignationTwo:_updateDesi()
    -- body
    WZLog("CellDesignationTwo:_updateDesi", Serialize(self.m_tData))
    if self.m_root == nil then
        WZLog("00000000000000000")
        return  
    end
    local tData = self.m_tData 

    GetElement(self.m_root, "conForReward_CellDesignationTwo", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "btnAccept_CellDesignationTwo",WZUIButton):setVisible(false)

    local   ftxtDesc  = GetElement(self.m_root, "ftxtDesc_CellDesignationTwo", WZUIFreeTextBox)
    ftxtDesc:setRelativePosition(GlobalMethod:ccp(0.026,0.5))
    local   btnSetDesi = GetElement(self.m_root, "btnSetDesi_CellDesignationTwo", WZUIButton)
    local   txtDesName = GetElement(self.m_root, "txtDesName_CellDesignationTwo", WZUILabelTTF)
    local   txtStateWord = GetElement(self.m_root, "txtStateWord_CellDesignation", WZUILabelTTF)

    --描述
    local descFormat = [[<T C="79,60,48" S="18" P="1">%s</T>]]
    if tData.desc ~= nil and tData.desc ~= -1 then
        ftxtDesc:setShowText(string.format(descFormat, tData.desc))
    end
    --称号类型
    if tData.status == 0 then
        if tData.sort == 1 then
            txtDesName:setText(LocalStrings.DESIGNATION_SPECIAL)
        elseif tData.sort == 2 then
            txtDesName:setText(LocalStrings.DESIGNATION_ACTIVITY)
        elseif tData.sort == 3 then
            txtDesName:setText(LocalStrings.DESIGNATION_ASSOCITION)
        elseif tData.sort == 4 then
            txtDesName:setText(LocalStrings.DESIGNATION_SHIP)
        elseif tData.sort == 5 then
            txtDesName:setText(LocalStrings.DESIGNATION_ACHIE)
        elseif tData.sort == 6 then
            txtDesName:setText(LocalStrings.MASTER_DESIGNATION)
        end
    else
        --称号
        if tData.title ~= nil then
            local conTitle = GetElement(self.m_root, "conTitle_CellDesignationTwo", WZUIContainer)
            local tempPoint = GlobalMethod:ccp(0.5,0.89)

            local sTitleName = SplitStringWithSeparator(tData.title,"&")
            local sNewTitle, nLetterNum = string.gsub(tData.title, "&", ",")

            if sTitleName[2] ~= nil and sTitleName[2] ~= "" then
                if tonumber(sTitleName[2]) == nil or nLetterNum > 2 then

                else
                    local bExist = WZFileUtil:isFileExist(string.format(g_sTitleSpineName, sTitleName[2]) .. ".json")
                    if bExist then
                        bTitleStroke = true 
                        txtDesName:setColor(GlobalMethod:ccc3(233,166,62))
                        txtDesName:setEnableStroke(true)
                    end
                end
            end

            CreateDesiSpine(conTitle, txtDesName, tData.title, tempPoint)
        end
    end


    if tData.status > 0 then
        btnSetDesi:setVisible(true)
        txtStateWord:setVisible(false)
    else
        txtStateWord:setText(LocalStrings.NO_GET_WORDS)
        txtStateWord:setVisible(true)
        btnSetDesi:setVisible(false)
    end

    self:setClicked(self.m_bGouVisible)
    self:setRedDotVisible(self.m_bRedDotVisible)
end


-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配模块Start--------------------------------------
--@brief 英文适配函数
--@note  英文适配
function CellDesignationTwo:_adaptLanguage_en()
    WZLog("CellDesignationTwo:_adaptLanguage_en")
    local txtDesName = GetElement(self.m_root, "txtDesName_CellDesignationTwo", WZUILabelTTF)
    if txtDesName then
        txtDesName:setScale(0.8)
        txtDesName:setDimensions(GlobalMethod:CCSize(200,0))
    end

    local txtStateWord = GetElement(self.m_root,"txtStateWord_CellDesignation",WZUILabelTTF)
    txtStateWord:setFontSize(16)
end

function CellDesignationTwo:_adaptLanguage_th()
    WZLog("CellDesignationTwo:_adaptLanguage_th")
    local txtDesName = GetElement(self.m_root, "txtDesName_CellDesignationTwo", WZUILabelTTF)
    if txtDesName then
        txtDesName:setScale(0.8)
        txtDesName:setDimensions(GlobalMethod:CCSize(200,0))
    end

    local ftxtDesc = GetElement(self.m_root,"ftxtDesc_CellDesignationTwo",WZUIFreeTextBox)
    ftxtDesc:setScale(0.8)
    ftxtDesc:setMaxWidth(400)
end

function CellDesignationTwo:_adaptLanguage_cn()
    WZLog("CellDesignationTwo:_adaptLanguage_cn")
    local txtDesName = GetElement(self.m_root, "txtDesName_CellDesignationTwo", WZUILabelTTF)
    if txtDesName then
        txtDesName:setScale(0.8)
        txtDesName:setDimensions(GlobalMethod:CCSize(200,0))
    end
end

function CellDesignationTwo:_adaptLanguage_pt(  )
    local txtDesName = GetElement(self.m_root, "txtDesName_CellDesignationTwo", WZUILabelTTF)
    if txtDesName then
        txtDesName:setScale(0.8)
        txtDesName:setDimensions(GlobalMethod:CCSize(200,0))
    end
    local txtStateWord = GetElement(self.m_root,"txtStateWord_CellDesignation",WZUILabelTTF)
    txtStateWord:setScale(0.7)

    GetElement(self.m_root,"txtAccept_CellDesignationTwo",WZUILabelTTF):setScale(0.8)
end

--@brief    越南语适配
function CellDesignationTwo:_adaptLanguage_vn(  )
    local txtDesName = GetElement(self.m_root, "txtDesName_CellDesignationTwo", WZUILabelTTF)
    if txtDesName then
        txtDesName:setDimensions(GlobalMethod:CCSize(180,0))
    end
    local ftxtDesc = GetElement(self.m_root,"ftxtDesc_CellDesignationTwo",WZUIFreeTextBox)
    ftxtDesc:setScale(0.9)
    ftxtDesc:setRelativePosition(GlobalMethod:ccp(0.1,0.7))
end

function CellDesignationTwo:_adaptLanguage_es(  )
    local txtDesName = GetElement(self.m_root, "txtDesName_CellDesignationTwo", WZUILabelTTF)
    if txtDesName then
        txtDesName:setFontSize(16)
        txtDesName:setDimensions(GlobalMethod:CCSize(190,0))
    end
    local txtStateWord = GetElement(self.m_root,"txtStateWord_CellDesignation",WZUILabelTTF)
    txtStateWord:setFontSize(16)

    GetElement(self.m_root,"txtAccept_CellDesignationTwo",WZUILabelTTF):setScale(0.8)

    local ftxtDesc = GetElement(self.m_root,"ftxtDesc_CellDesignationTwo",WZUIFreeTextBox)
    ftxtDesc:setScale(0.8)
    ftxtDesc:setMaxWidth(400)
end

function CellDesignationTwo:_adaptLanguage_tr(  )
    local txtStateWord = GetElement(self.m_root,"txtStateWord_CellDesignation",WZUILabelTTF)
    txtStateWord:setFontSize(13)

    local txtDesName = GetElement(self.m_root, "txtDesName_CellDesignationTwo", WZUILabelTTF)
    if txtDesName then
        txtDesName:setFontSize(16)
        txtDesName:setDimensions(GlobalMethod:CCSize(190,0))
    end
end
------------------------------------语言适配模块End------------------------------------------
