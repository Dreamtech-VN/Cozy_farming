--CellBlessedMen.lua
--@brief	CellBlessedMen的UI模块
--@date		2016/03/28
--@author	Tianxiang_Xu
--@note		祈福师节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellBlessedMen:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellBlessedMen:onExit(element)
	self:_unInit()
end

--@brief    刷新界面显示信息
function CellBlessedMen:update()
    -- body
    local tData = self.m_tData 
    --祈福师名字
    local txtName = GetElement(self.m_root, "txtName_CellBlessedMen", WZUILabelTTF)
    txtName:setText(tData.name)
    --祈福师头像
    local imgHead = GetElement(self.m_root, "imgHead_CellBlessedMen", WZUIImage)
    imgHead:setFile(tData.icon)
    --是否高亮
    imgHead:setGrayRender(not tData.active)
    --花费
    local txtCost = GetElement(self.m_root, "txtCost_CellBlessedMen", WZUIFreeTextBox)
    local iconFile = GDatatab_item["id_"..tData.cost[1][1]].icon
    local sCostText = [[<I P="1" Z="0.6">%s</I><T C="255,227,116" S="24" P="1" SC="79,60,48" SE="1" SS="4">%d</T>]]

    txtCost:setShowText(string.format(sCostText,iconFile, tData.cost[1][2]))
end

--@brief    点击召唤按钮回调
function CellBlessedMen:onClickCall(element)
    -- body
    self.m_tCallBack[2](self.m_tCallBack[1], element)
end

--@brief    设置头像激活数据
function CellBlessedMen:resetData(bActive)
    -- body
    self.m_tData.active = bActive
    local imgHead = GetElement(self.m_root, "imgHead_CellBlessedMen", WZUIImage)
    imgHead:setGrayRender(not self.m_tData.active)
end

--@brief    点击召唤师回调
function CellBlessedMen:onClickTouch(element)
    -- body
    WZLog("CellBlessedMen:onClickTouch")

    if self.m_bIsCanTouch == false then return end
    self.m_bIsCanTouch = false

    local imgTalkBk = WZUIImage:create()
    imgTalkBk:setFile("ui/common/common_scale9_kk.png")
    imgTalkBk:setUseOriginSize(true)
    imgTalkBk:setAnchorPoint(GlobalMethod:ccp(0.5,0))
    imgTalkBk:setRelativePosition(GlobalMethod:ccp(0.5,1))

    imgTalkBk:setTag(88)
    self.m_root:addChild(imgTalkBk)

    local txtMonologue = SplitStringWithSeparator(self.m_tData.monologue, "|")
    WZLog("CellBlessedMen:onClickTouch", Serialize(txtMonologue))
    local nRandom = 1
    if txtMonologue ~= nil and #txtMonologue > 1 then
        nRandom = #txtMonologue
    end
    local tRandomList = GetRandomNum(1, nRandom)
    local nRandomValue
    if tRandomList ~= nil and tRandomList ~= {} then
        nRandomValue = math.floor(tRandomList[1])
        if nRandomValue <= 0 then 
            nRandomValue = 1 
        end
    end

    local sContentFormat = [[<T C="127,70,26" S="22" P="1">%s</T>]]
    local txtContent = string.format(sContentFormat, txtMonologue[nRandomValue])
    local freeLabel = WZUIFreeTextBox:create()
    freeLabel:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    freeLabel:setRelativePosition(GlobalMethod:ccp(0.5,0.6))
    freeLabel:setMaxWidth(240)
    freeLabel:setShowText(txtContent)
    imgTalkBk:addChild(freeLabel)

    if ProjConfig.LANGUAGE == "en" then
        freeLabel:setMaxWidth(250)
    elseif ProjConfig.LANGUAGE == "pt" then
        freeLabel:setMaxWidth(400)
        freeLabel:setScale(0.6)
    elseif ProjConfig.LANGUAGE == "th" then
        freeLabel:setMaxWidth(300)
        freeLabel:setScale(0.7)
    end

    imgTalkBk:enableSchedule("onDesappear", 0.8)
end

--@brief    定时删除添加的祈福师对话
function CellBlessedMen:onDesappear(element)
    --body
    element:disableSchedule()
    element:removeFromParentAndCleanup(true)
    self.m_bIsCanTouch = true
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
