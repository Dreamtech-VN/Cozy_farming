--WndTeachJumpTalk.lua
--@brief	WndTeachJumpTalk的UI模块
--@date		2014/09/11
--@author	莫剑峰
--@note		教学窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTeachJumpTalk:onEnter(element)
    WZLog("WndTeachJumpTalk:onEnter")

	self.m_root = element
    self:_moreLanguageForStroke()
    --多语言版本界面适配
    AdaptLanguage(self)
    self:_upDateMoveContainer()
    self:_update()

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTeachJumpTalk:onExit(element)
    WZLog("WndTeachJumpTalk:onExit")
	self:_unInit()
end


--@brief
--@param	element:按钮的引用
function WndTeachJumpTalk:onOkClick(element)
    --self:_update()
end

--@brief	关闭窗口
function WndTeachJumpTalk:removeWindow()
    WZLog("WndTeachJumpTalk:removeWindow", tostring(self.m_root))
    if self.m_root == nil then
        return
    end
    
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    设置人物icon
--@param    icon名字
function WndTeachJumpTalk:setIcon(icon)
    if CacheCenter:getGameParam().gameStatus == "1" and icon == "common_pic_meinv1" then
        icon = "common_pic_meinv1"
    end
    if CacheCenter:getGameParam().gameStatus == "1" and icon == "common_pic_meinv2" then
        icon = "common_pic_meinv4"
    end
    if type(icon) == "string" then
        self.m_sIcon = "ui/combat/"..icon..".png"
    else
        self.m_sIcon = icon
    end
end

--@brief    设置人物icon偏移
--@param    人物icon偏移
function WndTeachJumpTalk:setIconOffset(offset)
    if offset == nil or (offset.x == 0 and offset.y == 0) then
        return
    end
    self.m_tOffset = offset
end

--@brief    设置是否人物在右边
--@param    是否人物在右边
function WndTeachJumpTalk:setImgRight(isImgRight)
    self.m_bIsImgRight = isImgRight
end

--@brief    设置名字
--@param    名字
function WndTeachJumpTalk:setName(name)
    WZLog("WndTeachJumpTalk:setName", name)
    self.m_sName = name
end

--@brief    设置按钮
--@param    按钮列表
function WndTeachJumpTalk:setBtn(tableBtn)
    WZLog("WndTeachJumpTalk:setBtn", tableBtn)
    self.m_tTableBtn = tableBtn
end

--@brief    设置是否跳转场景
--@param    设置是否跳转
function WndTeachJumpTalk:setReplaceScene(isReplace)
    WZLog("WndTeachJumpTalk:setReplaceScene", isReplace)
    self.m_bIsReplaceScene = isReplace
end

--@brief    设置属于的教学步骤
--@param    是名字
function WndTeachJumpTalk:setTeachStep(step)
    WZLog("WndTeachJumpTalk:setstep", step)
    self.m_nStep = step
end



-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新说明
function WndTeachJumpTalk:_update()
    WZLog("WndTeachJumpTalk:update one",tostring(self.m_tDetail and self.m_tDetail[1]))
    if self.m_tDetail and #self.m_tDetail > 0 then
        self:_setText(self.m_tDetail[1])
        table.remove(self.m_tDetail, 1)
    elseif self.m_tDetail then
        self.m_tDetail = nil
        WndTeachJumpTalk:removeWindow()
    end
end

--@brief   设置说明内容
--@paramtxt:说明内容
function WndTeachJumpTalk:_setText(txt)
    local txtDesc = self.m_root:getChildElement("freetxtContent_WndTeachJumpTalk")
    WZUIFreeTextBox:luaTo(txtDesc):setShowText(txt)
end

--@brief  	更新滚动容器内部布局函数
function WndTeachJumpTalk:_upDateMoveContainer()
	if self.m_root == nil then
		return
	end

    WZLog("WndTeachJumpTalk:_upDateMoveContainer", self.m_sName)

    WZUI9Image:luaTo(GetElement(self.m_root,"imgImg_WndTeachJumpTalk")):setFile(self.m_sIcon)
    WZUI9Image:luaTo(GetElement(self.m_root,"imgImg_WndTeachJumpTalk")):setFlipX(false)
    if self.m_tOffset ~= nil then
        WZUI9Image:luaTo(GetElement(self.m_root,"imgImg_WndTeachJumpTalk")):setRelativePosition(GlobalMethod:ccp(self.m_tOffset.x, self.m_tOffset.y))
    end


    if self.m_bIsImgRight == true then
        GetElement(self.m_root,"conImg_WndTeachJumpTalk"):setRelativePosition(GlobalMethod:ccp(0.82,0.476667))
        WZUI9Image:luaTo(GetElement(self.m_root,"imgImg_WndTeachJumpTalk")):setFlipX(true)

        GetElement(self.m_root,"conBg_WndTeachJumpTalk"):setRelativePosition(GlobalMethod:ccp(0.387839,0.342576))
        GetElement(self.m_root,"txtName_WndTeachJumpTalk"):setRelativePosition(GlobalMethod:ccp(0.114853,0.536356))
        GetElement(self.m_root,"freetxtContent_WndTeachJumpTalk"):setRelativePosition(GlobalMethod:ccp(0.308,0.34))
        GetElement(self.m_root,"imgArrow_WndTeachJumpTalk"):setRelativePosition(GlobalMethod:ccp(0.650257,0.148488))

    end

    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtName_WndTeachJumpTalk")):setText(self.m_sName)
    self.m_tabBattleCtb = GetElement(self.m_root,"tabBtn_WndTeachJumpTalk",WZUITableContainer)

    self.m_nTabCtbNumber = #self.m_tTableBtn
    if self.m_nTabCtbNumber == 2 then
        --GetElement(self.m_root,"conBtn_WndTeachJumpTalk",WZUIContainer):setAbsContentSize(GlobalMethod:CCSize(400,100))
    end

    if self.m_nTabCtbNumber == 2 then
        self.m_tabBattleCtb:setCellElementHeight(0.535)
    elseif self.m_nTabCtbNumber <= 3 then
        self.m_tabBattleCtb:setCellElementHeight(1/self.m_nTabCtbNumber)
    else
        self.m_tabBattleCtb:setCellElementHeight(1/3)
    end
    for i = 1, self.m_nTabCtbNumber do
        local info = self.m_tTableBtn[i]
        local cell,tab = CellJumpButton:createElement()
        WZLog("WndTeachJumpTalk:_upDateMoveContainer two", tostring(cell), tostring(tab))
        cell:setTag(i-1)
        tab.m_tData = info.data
        tab:setDesc(info.desc)

        if self.m_nTabCtbNumber == 3 then
            local w,h = 180, 55
            local con = GetElement(tab.m_root, "conAll_CellJumpButton", WZUIContainer)
            con:setAbsContentSize(GlobalMethod:CCSize(w,h))
            con:setContentSize(GlobalMethod:CCSize(w,h))
            con:setUseAbsSize(true)
        end
        self.m_tabBattleCtb:setCellElement(cell)
    end

    WZLog("WndTeachJumpTalk:_upDateMoveContainer three", self.m_nTabCtbNumber)
end

--@brief    获取说明文本长度
--@return   #1,length :返回说明文本的高度
function WndTeachJumpTalk:_getTxTLength()
	if self.m_root == nil then
		return
	end
	local txtTTF = self.m_root:getChildElement("txtIntro_WndTeachJumpTalk")
	if txtTTF == nil then
		return
	end
	txtTTF = WZUILabelTTF:luaTo(txtTTF)
	local length = txtTTF:getLabelContentSize()
	return length.height
end

-------------------------------------私有方法模块End----------------------------------------
--描边字设置
function WndTeachJumpTalk:_moreLanguageForStroke()
    WZLog("WndTeachJumpTalk:_moreLanguageForStroke")
	--确定
end

--@brief    中文适配函数
--@note     中文适配函数
function WndTeachJumpTalk:_adaptLanguage_cn()
    WZLog("WndTeachJumpTalk:_adaptLanguage_cn")

end

--@brief    中文繁体适配函数
--@note     中文繁体适配函数
function WndTeachJumpTalk:_adaptLanguage_hk()
    WZLog("WndTeachJumpTalk:_adaptLanguage_hk")

end

--@brief    英文适配函数
--@note     英文适配函数
function WndTeachJumpTalk:_adaptLanguage_en()
    WZLog("WndTeachJumpTalk:_adaptLanguage_en")
    local freetxtContent = GetElement(self.m_root,"freetxtContent_WndTeachJumpTalk",WZUIFreeTextBox)
    freetxtContent:setMaxWidth(280)
    freetxtContent:setRelativePosition(GlobalMethod:ccp(0.45,1.09334))
end

--@brief    泰语适配函数
--@note     泰语适配函数
function WndTeachJumpTalk:_adaptLanguage_th()
    WZLog("WndTeachJumpTalk:_adaptLanguage_th")
	GetElement(self.m_root,"txtName_WndTeachJumpTalk",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.311211,1.33))--1.28297))
    local freetxtContent = GetElement(self.m_root,"freetxtContent_WndTeachJumpTalk",WZUIFreeTextBox)
    freetxtContent:setMaxWidth(280)
    freetxtContent:setRelativePosition(GlobalMethod:ccp(0.45,1.09334))
end

--@brief    越南语适配函数
--@note     越南语适配函数
function WndTeachJumpTalk:_adaptLanguage_vn()
    WZLog("WndTeachJumpTalk:_adaptLanguage_vn")

end

--@brief    葡语适配函数
--@note     葡语适配函数
function WndTeachJumpTalk:_adaptLanguage_pt()
    WZLog("WndTeachJumpTalk:_adaptLanguage_pt")
    
end