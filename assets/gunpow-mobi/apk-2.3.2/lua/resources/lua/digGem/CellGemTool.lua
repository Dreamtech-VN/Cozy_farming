--CellGemTool.lua
--@brief	CellGemTool的UI模块
--@date		2017/03/14
--@author	Tianxiang_Xu
--@note		挖宝系统-工具列表项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGemTool:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGemTool:onExit(element)
	self:_unInit()
end

--@brief    加载
function CellGemTool:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellGemTool")
    self.m_root:addChild(celElement)

    self:_update()

    AdaptLanguage(self)
end

--@brief    点击购买或使用按钮回调
function CellGemTool:onClickBtn(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tData.leftTime < self.m_tData.efficiency*60 then
        --购买
        WndDigGem:onClickBuyTool(self.m_tData)
    else
        --使用
        WndDigGem:onClickUseTool(self.m_tData)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellGemTool:_update()
    -- body
    local tData = self.m_tData
    --工具图标
    local imgIcon = GetElement(self.m_root, "imgIcon_CellGemTool", WZUIImage)
    if imgIcon then
        imgIcon:setFile("ui/digGem/" .. tData.tool_icon)
    end
    --工具名字
    local txtToolName = GetElement(self.m_root, "txtToolName_CellGemTool", WZUILabelTTF)
    if txtToolName then
        txtToolName:setText(tData.tool_name)
    end
    --工具使用时间
    local txtTotalTime = GetElement(self.m_root, "txtTotalTime_CellGemTool", WZUILabelTTF)
    if txtTotalTime then
        txtTotalTime:setText(LocalStrings.DIGGEM_TEXT15 .. tData.time .. LocalStrings.MINUTE1)
    end
    --效率
    local txtEfficiency = GetElement(self.m_root, "txtEfficiency_CellGemTool", WZUILabelTTF)
    if txtEfficiency then
        txtEfficiency:setText(LocalStrings.DIGGEM_TEXT16 .. tData.efficiency .. LocalStrings.MINUTE1)
    end
    --增加熟练度
    local txtAddExp = GetElement(self.m_root, "txtAddExp_CellGemTool", WZUILabelTTF)
    if txtAddExp then
        txtAddExp:setText(string.format(LocalStrings.DIGGEM_TEXT17, tData.add_proficiency))
    end
    --价格和时间
    local ftxtPrice = GetElement(self.m_root, "ftxtPrice_CellGemTool", WZUIFreeTextBox)
    local txtBtnText = GetElement(self.m_root, "txtBtnText_CellGemTool", WZUILabelTTF)
    if ftxtPrice then
        if tData.leftTime < tData.efficiency*60 then
            local sTimeFormat = [[<T C="127,70,26" S="18" P="1">%s</T><I Z="0.5" P="2">%s</I><T C="229,105,22" S="18" P="1">%d</T>]]
            local tItem = GDatatab_item["id_" .. tData.buy_price[1][1]]
            ftxtPrice:setShowText(string.format(sTimeFormat, LocalStrings.DIGGEM_TEXT18, tItem.icon, tData.buy_price[1][2]))

            --按钮字
            txtBtnText:setText(LocalStrings.BUY)
        else
            local sTimeFormat = [[<T C="127,70,26" S="22" P="0">%s</T><T C="229,105,22" S="22" P="0">%d%s</T>]]
            ftxtPrice:setShowText(string.format(sTimeFormat, LocalStrings.REMAIN_TIME, math.floor(tData.leftTime/60), LocalStrings.MINUTE1))

            --按钮字
            txtBtnText:setText(LocalStrings.USE)
        end
    end
end




-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function CellGemTool:_adaptLanguage_en(  )
    local ftxtPrice = GetElement(self.m_root, "ftxtPrice_CellGemTool", WZUIFreeTextBox)
    ftxtPrice:setRelativePosition(GlobalMethod:ccp(0.83,0.75))
end

function CellGemTool:_adaptLanguage_ug(  )
    GetElement(self.m_root, "txtBtnText_CellGemTool", WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root, "ftxtPrice_CellGemTool", WZUIFreeTextBox):setScale(0.8)
end
---------------------------------------语言适配End------------------------------------------