--WndRightMenu.lua
--@brief	WndRightMenu的UI模块
--@date		2013/12/10
--@author	xiaoyu_wu
--@note		右菜单模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRightMenu:onEnter(element)
	self.m_root = element
	--获取右菜单数据
    local tBtnsInfo = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_RIGHT)
	--获取活动数据
	local tBtnMenu = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_EVENTS)
	self:setBtnsInfo(tBtnsInfo,tBtnMenu)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRightMenu:onExit(element)
	self:_unInit()
    Teach:isStartTeach("WndRightMenu:onExit")
end

--@brief	点击我要变强按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMenu:onClickStrong(element)
	WZLog("WndRightMenu:onClickStrong")
    DataUUtil("OL_Island_HuiYuan","")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	CheckLuaLoad(LUAFILES_BLOCK_COMMON)
    CheckLuaLoad(Chat_Channel_BecomeStronger)
	
	WndStrong:showInterface()
end

--@brief	点击活动按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMenu:onClickEvents(element)
	WZLog("WndRightMenu:onClickEvents")
    DataUUtil("OL_Island_HuiYuan","")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
   
   --[[ local tag = element:getParentElement():getTag()
	local posY = 540-tag*120
    local wndActivityMenu = WndActivityMenu:createElement()
    if wndActivityMenu == nil then
        return
    end
	wndActivityMenu = WZUIElementContainer:luaTo(wndActivityMenu)
	
	local num = 0 
	for i,v in ipairs(self.m_tActivitiesMenu) do
        if self:_checkIconButtonOpen(v) then
			num = num +1
		end
	end
	
	local size = num*130
	local posX = 840-num*60
	--设置弹出框位置与大小
	if num == 0 then 	
		wndActivityMenu:setVisible(false)
	elseif num == 4 then 
		size = 490
		posX = 610
	end
	--语言包适配
	if ProjConfig.LANGUAGE == "en" then
		if num == 1 or num == 2 then 
			size = num*160
			posX = 820-num*60
		end
	end
	
	WndActivityMenu:_setImgBack(wndActivityMenu,size,num)
	wndActivityMenu:setAbsContentSize(CCSize(size,120))
	wndActivityMenu:setAbsPosition(CCPoint(posX,posY)) 
    WindowManager:addWindow( wndActivityMenu , WndActivityMenu, true )--]]
	
	local wndActivityElement = wndActivityOnLine:createElement()
    if wndActivityElement ~= nil then
        WindowManager:addWindow(wndActivityElement,wndActivityOnLine,nil,false)
    end
end

--@brief	点击任务按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMenu:onClickTask(element)
	WZLog("WndRightMenu:onClickTask")
	SoundManager:playEffectSound(SoundDefine.E_S_OPEN_WIN)
    CheckLuaLoad(LUAFILES_BLOCK_COMMON)
    CheckLuaLoad(Chat_CHannel_Task)
	--[[local wndTaskElement = WndTask:createElement()
	if wndTaskElement == nil then
        return
    end
	
	WindowManager:addWindow(wndTaskElement, WndTask)]]
    local wndActivityElement = wndActivityOnLine:createElement()
    if wndActivityElement ~= nil then
        WindowManager:addWindow(wndActivityElement,wndActivityOnLine)
    end
end

--@brief	点击更多按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMenu:onClickMoreMenu(element)
	WZLog("WndRightMenu:onClickTask")
	SoundManager:playEffectSound(SoundDefine.E_S_OPEN_WIN)
	
	local tag = element:getParentElement():getTag()
	
	local wndRightMoreMenu = WndRightMoreMenu:createElement()
	if wndRightMoreMenu == nil then 
		return 
	end
	wndRightMoreMenu = WZUIElementContainer:luaTo(wndRightMoreMenu)
	
	local num = 0 
	local posY = 0 
	local posX = 610
	for i,v in ipairs(self.m_tBtnMoreMenu) do
		if v.buttonId ~= ISLAND_RIGHT_ATTENDANCE and v.buttonId ~= ISLAND_RIGHT_REDEMPTIONCODE then 
			if self:_checkIconButtonOpen(v) then
				num = num +1
			end
		end
	end
	--设置弹出框位置
	local size = num*120
	if num >=1 and num <= 3 then
		posX = 840-num*60
		posY = 550-tag*120
		wndRightMoreMenu:setAbsContentSize(CCSize(size,120))
		WndRightMoreMenu:_setTableSize(wndRightMoreMenu,size,num)
	elseif num == 4 then 
		posY = 550-tag*120
		wndRightMoreMenu:setAbsContentSize(CCSize(430,120))
		WndRightMoreMenu:_setTableSize(wndRightMoreMenu,430,num)
	elseif num >= 5 and num <= 8 then 
		posY= 595-tag*120
	elseif num >=9 then 
		posY = 615 - tag*120
	end 
	wndRightMoreMenu:setAbsPosition(CCPoint(posX,posY)) --设置弹出框位置
	WindowManager:addWindow(wndRightMoreMenu, WndRightMoreMenu)
	
	 
end

--@brief	点击合成按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMenu:onClickMixture(element)
	if self.m_root == nil then
		return
	end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    DataUUtil("OL_Island_Rankings","")
	
    CheckLuaLoad(LUAFILES_BLOCK_COMMON)
    CheckLuaLoad(Chat_Channel_Synthetic)
	
	WndFurnac:showInterface()
end

--@brief	人物升级后更新右菜单
function WndRightMenu:updateForUpgrade()
    if self.m_root == nil then
        return
    end
    
    local bUpdateFlag = false --是否更新，仅当有新功能开放时才更新
    if GlobalGame.g_tPlayerInfo.nZsleve == 0 then
        for i,v in ipairs(self.m_tBtnsInfo) do
            if v.buttonStatus3Level == GlobalGame.g_tPlayerInfo.nLevel then
                bUpdateFlag = true
                break
            end
        end
    end
    if bUpdateFlag then
        self:_update()
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新右菜单UI界面
function WndRightMenu:_update()
    WZLog("WndRightMenu:_update")
    if self.m_root == nil then
        return
    end
	
    if self.m_tBtnsInfo == nil then
        self:_setDefaultBtnsInfo()
    end
	
    local tbcon = GetElement(self.m_root, "tbcon_WndRightMenu", WZUITableContainer)
    tbcon:cleanTable()
    tbcon:getMoveElement():stopAllActions()
    
    self:_sortButton()
    local nTag = 0
	
    --针对豌豆荚SDK做特殊处理：屏蔽新浪微博按钮
    if ProjConfig.CHANNEL_ID == USE_WANDOUJIA_SDK then
        for i,v in ipairs(self.m_tBtnsInfo) do
            if self:_checkIconButtonOpen(v) then
                if v.buttonId ~= ISLAND_RIGHT_SINAWEIBO then
                    local conBtn = self:_createIconButton(v.buttonId, v.IsHighlight)
                    if conBtn ~= nil then
                        conBtn:setTag(nTag)
                        tbcon:setCellElement(conBtn)
                        nTag = nTag + 1

                        if v.buttonId == ISLAND_RIGHT_TASK then
                            Teach.TASK_TAG = nTag
                        elseif v.buttonId == ISLAND_RIGHT_MOREMENU then
                            Teach.MORE_TAG = nTag
                        elseif v.buttonId == ISLAND_RIGHT_COMPOSITE then
                            Teach.MIXTURE_RIGHT_TAG = nTag
                        end
                    end
                    end
                end
            end
        else
            for i,v in ipairs(self.m_tBtnsInfo) do
                if self:_checkIconButtonOpen(v) then
                    local conBtn = self:_createIconButton(v.buttonId, v.IsHighlight)
                    if conBtn ~= nil then
                        conBtn:setTag(nTag)
                        tbcon:setCellElement(conBtn)
                        nTag = nTag + 1

                        if v.buttonId == ISLAND_RIGHT_TASK then
                            Teach.TASK_TAG = nTag
                        elseif v.buttonId == ISLAND_RIGHT_MOREMENU then
                            Teach.MORE_TAG = nTag
                        elseif v.buttonId == ISLAND_RIGHT_COMPOSITE then
                            Teach.MIXTURE_RIGHT_TAG = nTag
                    end
                end
            end
        end
    end

   --self:_addAnimation()
end
--[[
--菜单按钮的响应方法
local tBtnClickFunc = {
  
	[ISLAND_RIGHT_EVENTS] = "onClickEvents",
	[ISLAND_RIGHT_TASK] = "onClickTask",
	[ISLAND_RIGHT_MOREMENU] = "onClickMoreMenu",		--更多
	[ISLAND_RIGHT_COMPOSITE] = "onClickMixture",		--合成
	[ISLAND_RIGHT_ACTIVITY] = "onClickActivity",		--活跃度
}

--菜单按钮的高亮动画图片文件
local tBtnHighlightAniImg = {
	[ISLAND_RIGHT_ACTIVITY] = "common/animation/icon_activity_an.png",
	[ISLAND_RIGHT_EVENTS] = "common/animation/icon_activities_an.png",
	[ISLAND_RIGHT_TASK] = "common/animation/icon_task_an.png",
	[ISLAND_RIGHT_MOREMENU] = "common/animation/icon_more_an.png",
	[ISLAND_RIGHT_COMPOSITE] = "common/animation/icon_composite_an.png",

}
--]]
--@brief	根据按钮id创建一个按钮
--@param    nButtonId, 按钮id
--@param    bIsHighlight, 是否高亮
--@return   #1, 按钮的节点引用
function WndRightMenu:_createIconButton(nButtonId, bIsHighlight)
    if g_tIslandBtnRes[nButtonId] == nil then
        return
    end
    local bIsFreeRegist = false
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    if curSdkObj then
        local config = curSdkObj.m_tConfig
        if config.SDKOtherConfig.isFreeRegist == "true" and  SceneLogin:isRegistered()==false then
            bIsFreeRegist = true
        end
    end
    
    if bIsFreeRegist == true and (nButtonId == ISLAND_RIGHT_FACEBOOK or nButtonId== ISLAND_RIGHT_FACEBOOKINVITE or nButtonId == ISLAND_RIGHT_FACEBOOKBI) then
        return
    end
    
    local conBtn = WZUISystem:getInstance():createElement("conBtn_WndRightMenu")
    if conBtn == nil then
        return
    end
    conBtn:setVisible(true)
    
    local btn = GetElement(conBtn, "btn_WndRightMenu", WZUIButton)
    btn:setLuaDoneFunctionName(tBtnClickFunc[nButtonId])
    WZLog("WndRightMenu:_createIconButton", tBtnClickFunc[nButtonId])

    local sIconPath = g_tIslandBtnRes.iconPath..g_tIslandBtnRes[nButtonId]..".png"
    local sTextPath = g_tIslandBtnRes.textPath..g_tIslandBtnRes[nButtonId].."1.png"
    if nButtonId == ISLAND_RIGHT_FACEBOOKBI then
        sTextPath = g_tIslandBtnRes.textPath..g_tIslandBtnRes[ISLAND_RIGHT_FACEBOOKINVITE].."1.png"
    end
    local imgIconNormal = GetElement(btn, "imgIconNormal_WndRightMenu", WZUIImage)
    imgIconNormal:setFile(sIconPath)
    local imgTextNormal = GetElement(btn, "imgTextNormal_WndRightMenu", WZUIImage)
    imgTextNormal:setFile(sTextPath)
    local imgIconSel = GetElement(btn, "imgIconSel_WndRightMenu", WZUIImage)
    imgIconSel:setFile(sIconPath)
    local imgTextSel = GetElement(btn, "imgTextSel_WndRightMenu", WZUIImage)
    imgTextSel:setFile(sTextPath)
	
	--点击时显示高清亮图
	local imgBtnHight =  GetElement(btn, "imgBtnHight_WndRightMenu", WZUIImage)
    local sHighlightImg = tBtnHighlightAniImg[nButtonId]
	if sHighlightImg == nil then
        return
    end
	imgBtnHight:setFile(sHighlightImg)
    if bIsHighlight == true then
        local imgCircleAni = WZUISystem:getInstance():createElement("imgCircleAni")
        conBtn:addChild(imgCircleAni,-1)
        local aniHighlight = self:createHighlightAni(nButtonId)
        if aniHighlight then
            conBtn:addChild(aniHighlight, -1)
        end
    end
    return conBtn
end

--@brief	根据按钮id创建一个按钮高亮动画
--@param    nButtonId, 按钮id
--@return   #1, 按钮的高亮动画节点
function WndRightMenu:createHighlightAni(nButtonId)
    local sHighlightImg = tBtnHighlightAniImg[nButtonId]
    if sHighlightImg == nil then
        return
    end
    local imgHighlightAni = WZUISystem:getInstance():createElement("imgHighlightAni")
    if imgHighlightAni == nil then
        return
    end
    imgHighlightAni = WZUIImage:luaTo(imgHighlightAni)
    imgHighlightAni:setFile(sHighlightImg)
    return imgHighlightAni
end

--@brief	检查功能按钮是否开放
--@param    tButtonInfo, 按钮信息表
--@return   #1, 是否开放
function WndRightMenu:_checkIconButtonOpen(tButtonInfo)
    --转生过都开放
    if GlobalGame.g_tPlayerInfo.nZsleve ~= nil and GlobalGame.g_tPlayerInfo.nZsleve > 0 and  GlobalGame.g_tPlayerInfo.nZsleve < 10 then
        return true
    end
    
    if GlobalGame.g_tPlayerInfo.nLevel and tButtonInfo.buttonStatus3Level and 
        GlobalGame.g_tPlayerInfo.nLevel < tButtonInfo.buttonStatus3Level then
        return false
    else
        return true
    end
end

--@brief	增加菜单落下的动画
function WndRightMenu:_addAnimation()
    if self.m_root == nil then
        return
    end
    local tbcon = GetElement(self.m_root, "tbcon_WndRightMenu", WZUITableContainer)
    local tbconSize = tbcon:getContentSize()
    local moveElement = tbcon:getMoveElement()
    local moveSize = moveElement:getContentSize()
    
    local minPos = tbcon:getMinPosition()
    moveElement:setPosition(minPos.x, tbconSize.height+moveSize.height/2)
    local actMoveTo = WZUIActionMoveToPosition:create()
    actMoveTo:setPosition(minPos)
    actMoveTo:setDuration(1.2)
    actMoveTo:setRateType("BounceOut")
    moveElement:runUIAction(actMoveTo)
end

-------------------------------------私有方法模块End----------------------------------------
