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

-- --@brief    加载
-- function CellDigGemLog:onLoadData(element)
--     -- body
--     local celElement = WZUISystem:getInstance():createElement("CellDigGemLog")
--     self.m_root:addChild(celElement)

--     self:_update()
-- end
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
    local contentFormat = {LocalStrings.DIGGEM_TEXT9, LocalStrings.DIGGEM_TEXT11, LocalStrings.DIGGEM_TEXT12, LocalStrings.DIGGEM_TEXT14, LocalStrings.DIGGEM_TEXT10, LocalStrings.DIGGEM_TEXT13, LocalStrings.RELIC_TEXT_18}
    if ftxtContent then
        local sContent
        if tData.type == 1 then
            sContent = string.format(contentFormat[tData.type], tData.name)
        elseif tData.type == 2 then
            sContent = string.format(contentFormat[tData.type], tData.name)
        elseif tData.type == 3 then
            sContent = string.format(contentFormat[tData.type])
        elseif tData.type == 4 then
            sContent = string.format(contentFormat[tData.type])
        elseif tData.type == 5 then
            sContent = string.format(contentFormat[tData.type], tData.name, tData.addExp)
        elseif tData.type == 6 then
            sContent = string.format(contentFormat[tData.type], tData.level)
        elseif tData.type == 7 then
            sContent = string.format(contentFormat[tData.type][(tData.seconds%2+1)], tData.name)
        elseif tData.type == 8 then
            sContent = string.format(LocalStrings.DIGGEM_TEXT56, tData.name, tData.param)
        elseif tData.type == 9 then
            sContent = string.format(LocalStrings.DIGGEM_TEXT57, tData.name, tData.param)
        elseif tData.type == 10 then
            sContent = string.format(LocalStrings.DIGGEM_TEXT58, tData.name)
        elseif tData.type == 11 then
            sContent = string.format(LocalStrings.DIGGEM_TEXT59, tData.name)
        elseif tData.type == 12 then
            sContent = string.format(LocalStrings.DIGGEM_TEXT60, tData.name)
        elseif tData.type == 13 then
            sContent = string.format(LocalStrings.DIGGEM_TEXT61, tData.name)
        elseif tData.type == 14 then
            sContent = string.format(LocalStrings.DIGGEM_TEXT62, tData.name, tData.param)
        elseif tData.type == 15 then
            sContent = string.format(LocalStrings.DIGGEM_TEXT63, tData.name, tData.param)
        elseif tData.type == 16 then
            if tData.param == "" then
                sContent = string.format(LocalStrings.DIGGEM_TEXT68, tData.name)
            else
                sContent = string.format(LocalStrings.DIGGEM_TEXT64, tData.name, tData.param)
            end
        end
        ftxtContent:setShowText(sContent)
    end

	--根据文本长度设置整体大小
    local height = ftxtContent:getContentSize().height
    WZUIContainer:luaTo(self.m_root):setAbsContentSize(GlobalMethod:CCSize(350,40+height))
    self.m_root:updateRelativeSize()
    
    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" 
        or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "ug" then
        GetElement(self.m_root, "txtTime_CellDigGemLog", WZUILabelTTF):setScale(0.8)
        local ftxtContent = GetElement(self.m_root, "ftxtContent_CellDigGemLog", WZUIFreeTextBox)
        ftxtContent:setScale(0.8)
        ftxtContent:setMaxWidth(330)
    elseif ProjConfig.LANGUAGE == "vn" then
        local ftxtContent = GetElement(self.m_root, "ftxtContent_CellDigGemLog", WZUIFreeTextBox)
        ftxtContent:setScale(0.75)
        ftxtContent:setMaxWidth(500)
    end
end




-------------------------------------私有方法模块End----------------------------------------
