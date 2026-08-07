--CellDigGemLog.lua
--@brief	CellDigGemLog的UI模块
--@date		2017/03/13
--@author	Tianxiang_Xu
--@note		挖宝系统-日志表项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDigGemLog:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDigGemLog:onExit(element)
	self:_unInit()
end

--@brief    加载
function CellDigGemLog:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellDigGemLog")
    self.m_root:addChild(celElement)

    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新
function CellDigGemLog:_update()
    -- body
    local tData = self.m_tData
    --时间
    local txtTime = GetElement(self.m_root, "txtTime_CellDigGemLog", WZUILabelTTF)
    if txtTime then
        txtTime:setText(tData.time)
    end
    --内容
    local ftxtContent = GetElement(self.m_root, "ftxtContent_CellDigGemLog", WZUIFreeTextBox)
    local contentFormat = {LocalStrings.DIGGEM_TEXT9, LocalStrings.DIGGEM_TEXT11, LocalStrings.DIGGEM_TEXT12, LocalStrings.DIGGEM_TEXT14, LocalStrings.DIGGEM_TEXT10, LocalStrings.DIGGEM_TEXT13}
    if ftxtContent then
        local sContent
        if tData.type == 1 then
            sContent = string.format(contentFormat[tData.type], tData.name)
        elseif tData.type == 2 then
            sContent = string.format(contentFormat[tData.type])
        elseif tData.type == 3 then
            sContent = string.format(contentFormat[tData.type])
        elseif tData.type == 4 then
            sContent = string.format(contentFormat[tData.type])
        elseif tData.type == 5 then
            sContent = string.format(contentFormat[tData.type], tData.name, tData.addExp)
        elseif tData.type == 6 then
            sContent = string.format(contentFormat[tData.type], tData.level)
        end
        ftxtContent:setShowText(sContent)
    end
    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" 
        or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" then
        GetElement(self.m_root, "txtTime_CellDigGemLog", WZUILabelTTF):setScale(0.8)
        local ftxtContent = GetElement(self.m_root, "ftxtContent_CellDigGemLog", WZUIFreeTextBox)
        ftxtContent:setScale(0.8)
        ftxtContent:setMaxWidth(330)
    elseif ProjConfig.LANGUAGE == "vn" then
        local ftxtContent = GetElement(self.m_root, "ftxtContent_CellDigGemLog", WZUIFreeTextBox)
        ftxtContent:setScale(0.75)
        ftxtContent:setMaxWidth(330)
    end
end




-------------------------------------私有方法模块End----------------------------------------
