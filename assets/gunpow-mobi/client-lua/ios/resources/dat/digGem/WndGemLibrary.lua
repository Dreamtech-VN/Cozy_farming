--WndGemLibrary.lua
--@brief	WndGemLibrary的UI模块
--@date		2017/03/13
--@author	Tianxiang_Xu
--@note		挖宝系统-图鉴界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGemLibrary:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGemLibrary:onExit(element)
	self:_unInit()
end

--@brief    加载界面完成回调
function WndGemLibrary:onEnterTransitionDidFinish(element)
    -- body
    self:setData()
    AdaptLanguage(self)
end

--@brief    关闭按钮回调
function WndGemLibrary:onCloseClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击物品回调
function WndGemLibrary:onItemClick(tItem, nTag, tData)
    -- body
    if self.m_tCellList[self.m_nSelItemTag + 1] then
        self.m_tCellList[self.m_nSelItemTag + 1]:setHighLight(false)
    end
    self:_updateDetail(nTag)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新
function WndGemLibrary:_update()
    -- body
    local tableItemList = GetElement(self.m_root, "tableItemList_WndGemLibrary", WZUITableContainer)
    tableItemList:cleanTable()
    tableItemList:setLoadCountPerFrame(5)

    for i = 1, #self.m_tGemLibraryList do
        local celElement, tNewObj = CellGoodItem:createElement()
        if celElement and tNewObj then
            celElement:setTag(i - 1)
            tNewObj:setCellGoodLocalId(self.m_tGemLibraryList[i].basicInfo.id, 0, 4)
            tNewObj:_setItemVisible(false)
            tNewObj:setItemClickFun(self,self.onItemClick)
            tableItemList:setCellElement(celElement)

            table.insert(self.m_tCellList, tNewObj)
        end
    end

    --更新右边详细信息栏信息
    self:_updateDetail(0)
end

--更新右边详细信息栏信息
function WndGemLibrary:_updateDetail(nTag)
    --body
    self.m_nSelItemTag = nTag
    self.m_tCellList[self.m_nSelItemTag + 1]:setHighLight(true)
    local tData = self.m_tGemLibraryList[nTag + 1]
    local conGemDetail = GetElement(self.m_root, "conGemDetail_WndGemLibrary", WZUIContainer)

    if tData == nil then 
        ShowPanelNullTip(conGemDetail)
        GetElement(self.m_root, "conForDetail_WndGemLibrary", WZUIContainer):setVisible(false)
        return 
    end
    removeShowPanelNullTip(conGemDetail)
    GetElement(self.m_root, "conForDetail_WndGemLibrary", WZUIContainer):setVisible(true)

    local txtName = GetElement(self.m_root, "txtName_WndGemLibrary", WZUILabelTTF)
    if txtName then
        txtName:setText(tData.basicInfo.name)
        txtName:setColor(QUALITYCOLOR[tData.basicInfo.quality])
    end
    --品质框
    local tQUALITY_RECT = {"ui/common/common_scale9_lv.png", "ui/common/common_scale9_lan.png", "ui/common/common_scale9_zi.png", "ui/common/common_scale9_cheng.png", "ui/common/common_scale9_wuse.png"}
    local imgQuality = GetElement(self.m_root, "imgQuality_WndGemLibrary", WZUIImage)
    if imgQuality then
        imgQuality:setFile(tQUALITY_RECT[tData.basicInfo.quality])
    end
    --物品图标
    local imgIcon = GetElement(self.m_root, "imgIcon_WndGemLibrary", WZUIImage)
    if imgIcon then
        imgIcon:setFile(tData.basicInfo.icon)
    end
    --描述
    local ftxtDesc1 = GetElement(self.m_root, "ftxtDesc1_WndGemLibrary", WZUIFreeTextBox)
    if ftxtDesc1 then
        local sFormat = [[<T C="127,70,26" S="18" P="1" SC="127,70,26" SS="4" SE="0">%s: </T><T C="127,70,26" S="18" P="1" SC="127,70,26" SS="4" SE="0">%s</T>]]
        ftxtDesc1:setShowText(string.format(sFormat, LocalStrings.INTRODUCTION, tData.basicInfo.desc))
    end
    local ftxtDesc2 = GetElement(self.m_root, "ftxtDesc2_WndGemLibrary", WZUIFreeTextBox)
    if ftxtDesc2 then
        local sFormat = [[<T C="127,70,26" S="18" P="1" SC="127,70,26" SS="4" SE="0">%s: </T><I Z="0.5" P="1">%s</I><T C="127,70,26" S="18" P="1" SC="127,70,26" SS="4" SE="0">%d</T>]]
        local priceIcon = GDatatab_item["id_" .. tData.appraisal_price[1][1]].icon
        ftxtDesc2:setShowText(string.format(sFormat, LocalStrings.DIGGEM_TEXT23, priceIcon, tData.appraisal_price[1][2]))
    end
    local ftxtDesc3 = GetElement(self.m_root, "ftxtDesc3_WndGemLibrary", WZUIFreeTextBox)
    if ftxtDesc3 then
        local sFormat = [[<T C="79,60,48" S="18" P="1">%s: </T><T C="79,60,48" S="18" P="1">Lv%d-%d%s</T>]]
        if tData.sLevel == tData.eLevel then
            sFormat = [[<T C="79,60,48" S="18" P="1">%s: </T><T C="79,60,48" S="18" P="1">Lv%d%s</T>]]
            ftxtDesc3:setShowText(string.format(sFormat, LocalStrings.GET_ACCESS, tData.sLevel, LocalStrings.DIGGEM_TEXT24))
        else
            ftxtDesc3:setShowText(string.format(sFormat, LocalStrings.GET_ACCESS, tData.sLevel, tData.eLevel, LocalStrings.DIGGEM_TEXT24))
        end
    end
end

-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function WndGemLibrary:_adaptLanguage_en(  )
    local ftxtDesc1 = GetElement(self.m_root, "ftxtDesc1_WndGemLibrary", WZUIFreeTextBox)
    ftxtDesc1:setScale(0.8)
    ftxtDesc1:setMaxWidth(280)
    ftxtDesc1:setRelativePosition(GlobalMethod:ccp(0.05,0.55))
    local ftxtDesc2 = GetElement(self.m_root, "ftxtDesc2_WndGemLibrary", WZUIFreeTextBox)
    ftxtDesc2:setScale(0.8)
    ftxtDesc2:setMaxWidth(280)
    ftxtDesc2:setRelativePosition(GlobalMethod:ccp(0.05,0.4))
    local ftxtDesc3 = GetElement(self.m_root, "ftxtDesc3_WndGemLibrary", WZUIFreeTextBox)
    ftxtDesc3:setScale(0.8)
    ftxtDesc3:setMaxWidth(280)
    ftxtDesc3:setRelativePosition(GlobalMethod:ccp(0.05,0.25))
end

function WndGemLibrary:_adaptLanguage_th(  )
    GetElement(self.m_root, "ftxtDesc2_WndGemLibrary", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.05,0.4))
    GetElement(self.m_root, "ftxtDesc3_WndGemLibrary", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.05,0.25))
end

function WndGemLibrary:_adaptLanguage_vn(  )
    GetElement(self.m_root, "ftxtDesc2_WndGemLibrary", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.05,0.4))
    GetElement(self.m_root, "ftxtDesc3_WndGemLibrary", WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.05,0.25))
end

function WndGemLibrary:_adaptLanguage_pt(  )
    local ftxtDesc1 = GetElement(self.m_root, "ftxtDesc1_WndGemLibrary", WZUIFreeTextBox)
    ftxtDesc1:setScale(0.8)
    ftxtDesc1:setMaxWidth(280)
    ftxtDesc1:setRelativePosition(GlobalMethod:ccp(0.05,0.55))
    local ftxtDesc2 = GetElement(self.m_root, "ftxtDesc2_WndGemLibrary", WZUIFreeTextBox)
    ftxtDesc2:setScale(0.8)
    ftxtDesc2:setMaxWidth(280)
    ftxtDesc2:setRelativePosition(GlobalMethod:ccp(0.05,0.4))
    local ftxtDesc3 = GetElement(self.m_root, "ftxtDesc3_WndGemLibrary", WZUIFreeTextBox)
    ftxtDesc3:setScale(0.8)
    ftxtDesc3:setMaxWidth(280)
    ftxtDesc3:setRelativePosition(GlobalMethod:ccp(0.05,0.25))
end


function WndGemLibrary:_adaptLanguage_es(  )
    local ftxtDesc1 = GetElement(self.m_root, "ftxtDesc1_WndGemLibrary", WZUIFreeTextBox)
    ftxtDesc1:setScale(0.8)
    ftxtDesc1:setMaxWidth(280)
    ftxtDesc1:setRelativePosition(GlobalMethod:ccp(0.05,0.55))
    local ftxtDesc2 = GetElement(self.m_root, "ftxtDesc2_WndGemLibrary", WZUIFreeTextBox)
    ftxtDesc2:setScale(0.8)
    ftxtDesc2:setMaxWidth(280)
    ftxtDesc2:setRelativePosition(GlobalMethod:ccp(0.05,0.4))
    local ftxtDesc3 = GetElement(self.m_root, "ftxtDesc3_WndGemLibrary", WZUIFreeTextBox)
    ftxtDesc3:setScale(0.8)
    ftxtDesc3:setMaxWidth(280)
    ftxtDesc3:setRelativePosition(GlobalMethod:ccp(0.05,0.25))
end

function WndGemLibrary:_adaptLanguage_tr(  )
    local ftxtDesc1 = GetElement(self.m_root, "ftxtDesc1_WndGemLibrary", WZUIFreeTextBox)
    ftxtDesc1:setScale(0.8)
    ftxtDesc1:setMaxWidth(280)
    ftxtDesc1:setRelativePosition(GlobalMethod:ccp(0.05,0.55))
    local ftxtDesc2 = GetElement(self.m_root, "ftxtDesc2_WndGemLibrary", WZUIFreeTextBox)
    ftxtDesc2:setScale(0.8)
    ftxtDesc2:setMaxWidth(280)
    ftxtDesc2:setRelativePosition(GlobalMethod:ccp(0.05,0.4))
    local ftxtDesc3 = GetElement(self.m_root, "ftxtDesc3_WndGemLibrary", WZUIFreeTextBox)
    ftxtDesc3:setScale(0.8)
    ftxtDesc3:setMaxWidth(280)
    ftxtDesc3:setRelativePosition(GlobalMethod:ccp(0.05,0.25))
end
---------------------------------------语言适配End------------------------------------------