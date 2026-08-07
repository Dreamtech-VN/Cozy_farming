--CellDesignationThree.lua
--@brief	CellDesignationThree的UI模块
--@date		2015/03/27
--@author	clc
--@note		成就系统-称号面板-称号cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDesignationThree:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDesignationThree:onExit(element)
	self:_unInit()
end

--@brief    点击本cell函数回调
function CellDesignationThree:onClickCell()
	WZLog("CellDesignationThree:onClickCell*****************************************")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndDesignationMain:acceptPrize(self.n_JobId)
end

--@brief    点击复选框设置称号
function CellDesignationThree:onClickCheckBox(element)
    -- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = self.m_root:getTag()
    WndDesignationMain:onClickDesignation(nTag, self.n_JobId)
end

--@brief    加载数据信息
function CellDesignationThree:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellDesignationThree")
    self.m_root:addChild(cellElement)

    self.m_bIsLoad = true
    if WndDesignationMain.m_nclickedMainClassicId == 14 then
        self:_updateDesi()
    else
        self:_update(self.m_tData.title ,self.m_tData.desc, self.m_tData.status, self.m_tData.reward, self.m_tData.nComplete, self.m_tData.nTarget)
    end
    AdaptLanguage(self)
end

--@brief    设置成就复选框称号使用状态
function CellDesignationThree:setClicked(bVisible)
    -- body
    self.m_bGouVisible = bVisible
    if bVisible and self.m_tData.status ~= 1 then
        self.m_tData.status = 2
    end
    WZLog("CellDesignationThree:setClicked", self.m_bIsLoad, bVisible)
    if not self.m_bIsLoad then return end 

    local txtUseWord = GetElement(self.m_root, "txtUseWord_CellDesignationThree", WZUILabelTTF)
    local txtSetDesi = GetElement(self.m_root, "txtSetDesi_CellDesignationThree", WZUILabelTTF)
    if bVisible == false then
        txtUseWord:setVisible(false)
        txtSetDesi:setText(LocalStrings.USE)
    else
        txtUseWord:setVisible(true)
        txtSetDesi:setText(LocalStrings.UNROYAL)
    end
end

--@brief  设置子成就的状态
function  CellDesignationThree:setCellStatus(status)
    -- body
    WZLog("CellDesignationThree:setCellUI",status)
    if self.m_bIsLoad == false then return end

    if self.m_root == nil then
        return  
    end

    local  btnSetDesi = GetElement(self.m_root, "btnSetDesi_CellDesignationThree", WZUIButton)
    local  btnAccept = GetElement(self.m_root, "btnAccept_CellDesignationThree",WZUIButton)
    local  ftxtDesc  = GetElement(self.m_root, "ftxtDesc_CellDesignationThree", WZUIFreeTextBox)
    local  descFormat = [[<T C="127,70,26" S="16" P="1">%s</T><T C="229,105,22" S="16" P="1">%s</T>]]

    if status > 0 then
        if self.m_tData.reward ~= -1 and status ~= 3 then
            if status == 2 and CacheCenter:judgeWhetherDesiUsed(self.n_JobId) then
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
            ftxtDesc:setVisible(false)
        --    ftxtDesc:setShowText(string.format(descFormat, self.m_tData.desc, ""))
        end
    else
        btnSetDesi:setVisible(false)
        btnAccept:setVisible(false)
    end
end

--@brief    获取奖励物品的图标
function CellDesignationThree:getIconFile(itemId)
    -- body
    local tItemTable = GDatatab_item["id_" .. tostring(itemId)]

    return tItemTable.icon
end

--@brief  设置此子成就的id
--@param  nJobId:子成就id
function CellDesignationThree:setJobId( nJobId )
	-- body
	self.n_JobId  = nJobId
end

--@brief  返回此子成就id
function  CellDesignationThree:getJobId( )
	-- body
	return self.n_JobId
end

--@brief 获取此cell的类型
function CellDesignationThree:getCellType( )
	-- body
	return self.n_CellType
end

--@brief    设置红点是否可见
function CellDesignationThree:setRedDotVisible(bVisible)
    -- body
    self.m_bRedDotVisible = bVisible 
    if self.m_bIsLoad == false then return end 

    local imgRedDot = GetElement(self.m_root, "imgRedDot_CellDesignationThree", WZUIImage)
    if bVisible then
        imgRedDot:setVisible(true)
    else
        imgRedDot:setVisible(false)
    end
end

--@brief    获取是否有红点
function CellDesignationThree:getRedDotState()
    -- body
    if self.m_tData.status == 3 then
        return true
    else
        return false
    end
end

--@brief    点击显示描述
function CellDesignationThree:onClickDesc(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local achieData = GDatatab_achievement["id_" .. self.n_JobId]
    local nStart, nEnd = string.find(achieData.script, "*")
    local nStart2, nEnd2 = string.find(achieData.script, "=")
    local itemId = string.sub(achieData.script, nEnd + 1, nStart2 - 1)
    local basicData = GDatatab_item["id_" .. itemId]
    local tData = {}
    tData.txtTitle = self.m_tData.desc
    tData.nType = 2
    if basicData and basicData.property[1] and basicData.property[1][1] ~= 0 then 
        tData.property = basicData.property
    end
    WndTips:show(element, WndDesignationMain.m_root, 52, tData, GlobalMethod:ccp(50,80), false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新节点信息
function CellDesignationThree:_update(title ,desc, status, reward, nComplete, nTarget)
    -- body
    WZLog("CellDesignationThree:_update", title ,desc, status, reward, nComplete, nTarget)
    if self.m_root == nil then
        return  
    end

    local   ftxtDesc  = GetElement(self.m_root, "ftxtDesc_CellDesignationThree", WZUIFreeTextBox)
    local   btnSetDesi = GetElement(self.m_root, "btnSetDesi_CellDesignationThree", WZUIButton)
    local   btnAccept = GetElement(self.m_root, "btnAccept_CellDesignationThree",WZUIButton)
    local   txtDesName = GetElement(self.m_root, "txtDesName_CellDesignationThree", WZUILabelTTF)
    local   conLock = GetElement(self.m_root, "conLock_CellDesignationThree", WZUIContainer)

    --描述
    local descFormat = [[<T C="127,70,26" S="16" P="1">%s</T><T C="229,105,22" S="16" P="1">%s</T>]]
    --称号
    if title ~= nil then
        local conTitle = GetElement(self.m_root, "conTitle_CellDesignationThree", WZUIContainer)
        local tempPoint = GlobalMethod:ccp(0.5,0.85)

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

        CreateDesiSpine(conTitle, txtDesName, title, tempPoint, nil, 0.6)
        if ProjConfig.LANGUAGE == "es" then
            txtDesName:setText(LocalStrings.CAN_GET_DESIGNATION .. "[" .. sTitleName[1] .. "]")
        end
    end

    --展示奖励
    if reward ~= -1 then
        local nRewardCount = #reward 
        if nRewardCount == 1 then 
            GetElement(self.m_root, "conReward1_CellDesignationThree", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.25, 0.444))
        end
        for i = 1, nRewardCount do
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
            if status == 2 and CacheCenter:judgeWhetherDesiUsed(self.n_JobId) then
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
            ftxtDesc:setVisible(false)
        --    ftxtDesc:setShowText(string.format(descFormat, desc, ""))
        end
        conLock:setVisible(false)
    else
        conLock:setVisible(true)
        btnSetDesi:setVisible(false)
        btnAccept:setVisible(false)
        if nComplete ~= nil and nTarget ~= nil then
            local txtProgress = string.format("(%d/%d)", nComplete, nTarget)
            if desc ~= nil and desc ~= -1 then
                ftxtDesc:setVisible(false)
            --    ftxtDesc:setShowText(string.format(descFormat, desc, txtProgress))
            end
        end
    end

    self:setClicked(self.m_bGouVisible)
end

--@brief    更新特殊称号列表信息
function CellDesignationThree:_updateDesi()
    -- body
    WZLog("CellDesignationThree:_updateDesi", Serialize(self.m_tData))
    if self.m_root == nil then
        return  
    end
    local tData = self.m_tData 

    GetElement(self.m_root, "btnAccept_CellDesignationThree",WZUIButton):setVisible(false)

    local   ftxtDesc  = GetElement(self.m_root, "ftxtDesc_CellDesignationThree", WZUIFreeTextBox)
    ftxtDesc:setRelativePosition(GlobalMethod:ccp(0.16,0.5))
    local   btnSetDesi = GetElement(self.m_root, "btnSetDesi_CellDesignationThree", WZUIButton)
    local   txtDesName = GetElement(self.m_root, "txtDesName_CellDesignationThree", WZUILabelTTF)
    local   conLock = GetElement(self.m_root, "conLock_CellDesignationThree", WZUIContainer)

    --描述
    local descFormat = [[<T C="127,70,26" S="16" P="1">%s</T>]]
    if tData.desc ~= nil and tData.desc ~= -1 then
        ftxtDesc:setVisible(false)
    --    ftxtDesc:setShowText(string.format(descFormat, tData.desc))
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
            local conTitle = GetElement(self.m_root, "conTitle_CellDesignationThree", WZUIContainer)
            local tempPoint = GlobalMethod:ccp(0.5,0.85)

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

            CreateDesiSpine(conTitle, txtDesName, tData.title, tempPoint,nil,0.6)
        end
    end


    if tData.status > 0 then
        btnSetDesi:setVisible(true)
        conLock:setVisible(false)
    else
        conLock:setVisible(true)
        btnSetDesi:setVisible(false)
    end

    self:setClicked(self.m_bGouVisible)
    self:setRedDotVisible(self.m_bRedDotVisible)
end



-------------------------------------私有方法模块End----------------------------------------
------------------------------------语言适配Begin---------------------------------------
function CellDesignationThree:_adaptLanguage_pt(  )
	GetElement(self.m_root,"title_Label",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"descrition1_Label",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtFreeDescrition_CellDesignationThree",WZUIFreeTextBox):setMaxWidth(500)
end

function CellDesignationThree:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtFreeDescrition_CellDesignationThree",WZUIFreeTextBox):setMaxWidth(500)
end

function CellDesignationThree:_adaptLanguage_es(  )
	local title = GetElement(self.m_root,"title_Label",WZUILabelTTF)
	title:setFontSize(18)
	title:setDimensions(GlobalMethod:CCSize(180,0))

	local descrition = GetElement(self.m_root,"descrition1_Label",WZUILabelTTF)
	descrition:setFontSize(20)
	descrition:setDimensions(GlobalMethod:CCSize(470,0))

	GetElement(self.m_root,"txtFreeDescrition_CellDesignationThree",WZUIFreeTextBox):setMaxWidth(500)
end

function CellDesignationThree:_adaptLanguage_en(  )
	GetElement(self.m_root,"descrition1_Label",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(520))
end

function CellDesignationThree:_adaptLanguage_tr(  )
	GetElement(self.m_root,"descrition1_Label",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(520))
end

function CellDesignationThree:_adaptLanguage_vn(  )

end
------------------------------------语言适配End----------------------------------------