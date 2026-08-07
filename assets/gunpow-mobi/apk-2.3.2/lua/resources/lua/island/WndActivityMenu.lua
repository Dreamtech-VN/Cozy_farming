--WndActivityMenu.lua
--@brief	WndActivityMenu的UI模块
--@date		2014/09/01
--@author	周亚茜
--@note		活动菜单


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndActivityMenu:onEnter(element)
	self.m_root = element
	local tBtnsInfo = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_EVENTS)
    self:setBtnsInfo(tBtnsInfo)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndActivityMenu:onExit(element)
	self:_unInit()
end


--@brief	关闭函数
function WndActivityMenu:onClose()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	判断是否在点击范围内
function WndActivityMenu:checkClick(pos,postion)
	if self.m_root == nil then
		return true
	end
	local tbconBtn = self.m_root:getChildElement("tbconBtn_WndActivityMenu")
	if tbconBtn == nil or pos == nil then 
		return true
	end
	postion = postion or ccp(0,0)
	tbconBtn = WZUITableContainer:luaTo(tbconBtn)
	local tbconSize = tbconBtn:getContentSize()
    pt = tbconBtn:getParentElement():convertToNodeSpace(pos)
	if pt.x < 0-postion.x or pt.x > postion.x+tbconSize.width then
		return false
	elseif pt.y < 0-postion.y or pt.y > postion.y + tbconSize.height then
		return false
	else
		return true
	end
end

--@brief	点击荣誉殿堂按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndActivityMenu:onClickQualifying(element)
	WZLog("WndActivityMenu:onClickQualifying9999999999999999999999")
	SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
    DataUUtil("OL_Island_Honer","")
        CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_CHannel_GameGroup)
        --打开排位赛界面
        local sceneQualifyingElement = SceneQualifying:createElement()
        if sceneQualifyingElement == nil then
            return
        end
        replaceScene( sceneQualifyingElement )
end

--@brief	点击弹王挑战赛按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndActivityMenu:onClickKing(element)
	WZLog("WndActivityMenu:onClickKing")
    DataUUtil("OL_Island_ChallengeBattle","")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    CheckLuaLoad(LUAFILES_BLOCK_COMMON)
    CheckLuaLoad(Chat_Channel_Challenge)
	replaceScene( SceneKingEntrance:createElement() )
end

--@brief	点击世界boss按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndActivityMenu:onClickWorldBoss(element)
	WZLog("WndActivityMenu:onClickWorldBoss")
    DataUUtil("OL_Island_WorldBossHall","")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    CheckLuaLoad(LUAFILES_BLOCK_COMMON)
	CheckLuaLoad(Chat_Channel_WorldBoss)
    local worldBossElement = SceneWorldBoss:createElement()
	if worldBossElement ~= nil then
		replaceScene( worldBossElement )
	end
end

--@brief	人物升级后更新右菜单
function WndActivityMenu:updateForUpgrade()
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
--@brief	更新函数
function WndActivityMenu:_update()
	if self.m_root == nil then 
		return 
	end 

	local tbconBtn = self.m_root:getChildElement("tbconBtn_WndActivityMenu")
	if tbconBtn == nil then 
		return 
	end
	tbconBtn = WZUITableContainer:luaTo(tbconBtn)
	
	local tbconSize = tbconBtn:getContentSize()
	tbconBtn:cleanTable()
	local nTag = 0 
    for i,v in ipairs(self.m_tBtnsInfo) do
         if self:_checkIconButtonOpen(v) then    
			local conBtn = self:_createIconButton(v.buttonId, v.IsHighlight)
            if conBtn ~= nil then
                conBtn:setTag(nTag)
                tbconBtn:setCellElement(conBtn)
				nTag = nTag +1
            end
		end
    end
	
	local moveElement = tbconBtn:getMoveElement()
	local pt = moveElement:getRelativePosition()
	
	tbconBtn:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionX(tbconBtn:getMaxPosition().x)
	moveElement:setRelativePosition(CCPoint(pt.x,pt.y-0.5))
end
--[[
--菜单按钮的响应方法
local tBtnClickFunc = {  
    [ISLAND_BUILDING_QUALIFYING] = "onClickQualifying",	--排位赛
    [ISLAND_RIGHT_KING] = "onClickKing",				--弹王
    [ISLAND_RIGHT_WORLDBOSS] = "onClickWorldBoss",		--世界BOSS
    [ISLAND_RIGHT_ACTIVITY] = "onClickActivity",		--活跃度
}

--菜单按钮的高亮动画图片文件
local tBtnHighlightAniImg = {
	[ISLAND_BUILDING_QUALIFYING] = "common/animation/icon_qualifying_an.png",
    [ISLAND_RIGHT_WORLDBOSS] = "common/animation/icon_world_boss_an.png",
    [ISLAND_RIGHT_KING] = "common/animation/icon_king_an.png",
    [ISLAND_RIGHT_ACTIVITY] = "common/animation/icon_activity_an.png",
}
--]]
--@brief	创建按钮图片
--@param    nButtonId, 按钮id
function WndActivityMenu:_createIconButton(nButtonId,bIsHighlight)
	
	 if g_tIslandBtnRes[nButtonId] == nil then   --小岛左右菜单的图片资源
        return
    end
	
	local conBtn =  WZUISystem:getInstance():createElement("conBtn_WndActivityMenu")
	if conBtn == nil then 
		return 
	end
	conBtn = WZUIContainer:luaTo(conBtn)
	conBtn:setVisible(true)

	--设置按钮回调
	local btnBtn = GetElement(conBtn, "btnBtn_WndActivityMenu", WZUIButton)
    btnBtn:setLuaDoneFunctionName(tBtnClickFunc[nButtonId])
    local imgIconNormal = GetElement(btnBtn, "imgIconNormal_WndActivityMenu", WZUIImage)
    imgIconNormal:setFile(g_tIslandBtnRes.iconPath..g_tIslandBtnRes[nButtonId]..".png")
	--设置按钮文字
    local imgTextNormal = GetElement(btnBtn, "imgTextNormal_WndActivityMenu", WZUIImage)
    imgTextNormal:setFile(g_tIslandBtnRes.textPath..g_tIslandBtnRes[nButtonId].."1.png")
	--设置点击时按钮图片	
    local imgIconSe = GetElement(btnBtn, "imgIconSel_WndActivityMenu", WZUIImage)
    imgIconSe:setFile(g_tIslandBtnRes.iconPath..g_tIslandBtnRes[nButtonId]..".png")
	--设置点击时按钮文字
    local imgTextSel = GetElement(btnBtn, "imgTextSel_WndActivityMenu", WZUIImage)
    imgTextSel:setFile(g_tIslandBtnRes.textPath..g_tIslandBtnRes[nButtonId].."1.png") 

	--点击时显示高清亮图
	local imgBtnHight =  GetElement(btnBtn, "imgBtnHight_WndActivityMenu", WZUIImage)
    local sHighlightImg = tBtnHighlightAniImg[nButtonId]
	if sHighlightImg == nil then
        return
    end
	imgBtnHight:setFile(sHighlightImg)
	
	--[[local btnSel =  GetElement(btnBtn, "btnSel_WndActivityMenu", WZUIContainer)
    local aniHighlight = self:createHighlightAni(nButtonId)
    if aniHighlight then
		btnSel:addChild(aniHighlight, -1)
    end]]
	
	--是否高亮,有动画
	if bIsHighlight == true then
        local imgCircleAni = WZUISystem:getInstance():createElement("imgCircleAni")
        conBtn:addChild(imgCircleAni,-1)
        local aniHighlight = self:createHighlightAni(nButtonId)
        if aniHighlight then
            conBtn:addChild(aniHighlight, -2)
        end
    end
    return conBtn
end


--@brief	根据按钮id创建一个按钮高亮动画
--@param    nButtonId, 按钮id
--@return   #1, 按钮的高亮动画节点
function WndActivityMenu:createHighlightAni(nButtonId)
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
function WndActivityMenu:_checkIconButtonOpen(tButtonInfo)
    --转生过都开放
    if GlobalGame.g_tPlayerInfo.nZsleve > 0 and  GlobalGame.g_tPlayerInfo.nZsleve < 10 then
        return true
    end
    
    if GlobalGame.g_tPlayerInfo.nLevel and tButtonInfo.buttonStatus3Level and 
        GlobalGame.g_tPlayerInfo.nLevel < tButtonInfo.buttonStatus3Level then
        return false
    else
        return true
    end
end

--@brief	关闭动画效果
function WndActivityMenu:_closeAction()
	 -- 创建动画效果
    local actMoveTo = WZUIActionMoveTo:create()
	if nil == actMoveTo then
		return
	end
	actMoveTo:setDuration(0.1)
	actMoveTo:setMoveX(0.8)
	actMoveTo:setMoveY(0.52)
	actMoveTo:setFinishLuaFunction("onClose")
	--执行动作
	local conActivityMenu= WZUIContainer:luaTo(self.m_root:getChildElement("conActivityMenu_WndActivityMenu"))
	if conActivityMenu ~= nil then
		conActivityMenu:runUIAction(actMoveTo)
	end
end

--@brief	设置表格容器大小
--@param    element:UI对应节点,size:背景大小,num:容器列数
function WndActivityMenu:_setImgBack(element,size,num)
	local tbconBtn = element:getChildElement("tbconBtn_WndActivityMenu")
	if tbconBtn then 
		tbconBtn = WZUITableContainer:luaTo(tbconBtn)
		tbconBtn:setAbsContentSize(CCSize(size-20,110))
		tbconBtn:setUseAbsSize(true)
		tbconBtn:setColumnCount(num)
		tbconBtn:setHorizontalInterval(0.01)
	end
end



-------------------------------------私有方法模块End----------------------------------------
