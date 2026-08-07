--WndRightMoreMenu.lua
--@brief	WndRightMoreMenu的UI模块
--@date		2014/08/27
--@author	zyx
--@note		右边更多菜单显示


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRightMoreMenu:onEnter(element)
	self.m_root = element
	local tBtnsInfo = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_RIGHT)
    self:setBtnsInfo(tBtnsInfo)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRightMoreMenu:onExit(element)
	self:_unInit()
    Teach:isStartTeach("WndRightMoreMenu:onExit")
end


--@brief	关闭函数
function WndRightMoreMenu:onClose()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	判断是否在点击范围内
function WndRightMoreMenu:checkClick(pos,postion)
	if self.m_root == nil then
		return true
	end
	local tbconBtn = self.m_root:getChildElement("tbconBtn_WndRightMoreMenu")
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

--@brief	点击排行榜按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMoreMenu:onClickRanking(element)
	if self.m_root == nil then
		return
	end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	DataUUtil("OL_Island_Rankings","")
	if self:_checkButtonOpen(ISLAND_LEFT_RANKING) then
		CheckLuaLoad(LUAFILES_BLOCK_COMMON)
		CheckLuaLoad(Chat_Channel_Ranking)
		--打开排行榜窗口界面:
		--local wndRanking = WndRanking:createElement()
		--if wndRanking ~= nil then
		--	WindowManager:addWindow( wndRanking , WndRanking, true )
		--end
        local pWndRankList = WndRankList:createElement()
        if pWndRankList ~= nil then
            WindowManager:addWindow( pWndRankList , WndRankList )
        end
	end
end

--@brief	点击兑换按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMoreMenu:onClickExchange(element)
	WZLog("WndRightMoreMenu:onClickExchange")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self:_checkButtonOpen(ISLAND_RIGHT_EXCHANGE) then
		CheckLuaLoad(LUAFILES_BLOCK_COMMON)
		CheckLuaLoad(Chat_Channel_Exchange)
		--SceneExchange:showExchange()
		WndExChange:ShowExChange()
	end
end

--@brief	点击合成按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMoreMenu:onClickMixture(element)
	WZLog("WndRightMoreMenu:onClickMixture")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self:_checkButtonOpen(ISLAND_RIGHT_COMPOSITE) then
        WndRightMoreMenu:onClose()
		CheckLuaLoad(LUAFILES_BLOCK_COMMON)
		CheckLuaLoad(Chat_Channel_Synthetic)
		WndFurnac:showInterface()
	end
end

--@brief	点击新浪微博按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMoreMenu:onClickSinaWeibo(element)
	WZLog("WndRightMoreMenu:onClickSinaWeibo")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self:_checkButtonOpen(ISLAND_RIGHT_SINAWEIBO) then
		CheckLuaLoad(LUAFILES_BLOCK_COMMON)
		WndWeibo:showInterface()
	end
end

--@brief	点击设置按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMoreMenu:onClickSetting(element)
	WZLog("WndBottomMenu:onClickSetting")
	SoundManager:playEffectSound(SoundDefine.E_S_OPEN_WIN)
	if self:_checkButtonOpen(ISLAND_BOTTOM_SETTING) then
		DataUUtil("OL_Island_Setting","")
		CheckLuaLoad(LUAFILES_BLOCK_COMMON)
		CheckLuaLoad(Chat_Channel_Setting)
		local wndSettingElement = WndSetting:createElement()
		if wndSettingElement == nil then
			return
		end
		WindowManager:addWindow( wndSettingElement , WndSetting )
	end
end

--@brief	点击新浪微博按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMoreMenu:onClickSinaWeibo(element)
	WZLog("WndRightMoreMenu:onClickSinaWeibo")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self:_checkButtonOpen(ISLAND_RIGHT_SINAWEIBO) then
		DataUUtil("OL_Island_SinaWeibo","")
		CheckLuaLoad(LUAFILES_BLOCK_COMMON)
		WndWeibo:showInterface()
	end
end


--@brief	点击转生按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMoreMenu:onClickReincarnation(element)
	WZLog("WndRightMoreMenu:onClickReincarnation")
    DataUUtil("OL_Island_Rebirth","")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self:_checkButtonOpen(ISLAND_RIGHT_REINCARNATION) then
		CheckLuaLoad(LUAFILES_BLOCK_COMMON)
		CheckLuaLoad(Chat_Channel_Reincarnation)
		local wndReincarnationElement = WndReincarnation:createElement()
		if wndReincarnationElement == nil then
			return
		end
		WindowManager:addWindow(wndReincarnationElement , WndReincarnation)
	end
end

--@brief	点击邀请码按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMoreMenu:onClickInvite(element)
	WZLog("WndRightMoreMenu:onClickInvite")
    DataUUtil("OL_Island_Invite","")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self:_checkButtonOpen(ISLAND_RIGHT_INVITE) then
		CheckLuaLoad(LUAFILES_BLOCK_COMMON)
		CheckLuaLoad(Chat_Channel_YCode)
		local wndInviteElement = WndInvite:createElement()
		if wndInviteElement == nil then
			return
		end
		WindowManager:addWindow( wndInviteElement , WndInvite )
	end
end


--@brief	点击物品回收按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMoreMenu:onClickRecycling(element)
	WZLog("WndRightMoreMenu:onClickRecycling")
    DataUUtil("OL_Island_Recover","")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self:_checkButtonOpen(ISLAND_RIGHT_RECYCLING) then
		CheckLuaLoad(LUAFILES_BLOCK_COMMON)
		CheckLuaLoad(Chat_Channel_Recycling)
		local sceneRecycling = SceneRecycling:createElement()
		if sceneRecycling ~= nil then
			replaceScene(sceneRecycling)
		end
	end
end


--@brief	点击我要变强按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMoreMenu:onClickStrong(element)
	WZLog("WndRightMoreMenu:onClickEvents")
    DataUUtil("OL_Island_HuiYuan","")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	CheckLuaLoad(LUAFILES_BLOCK_COMMON)
    CheckLuaLoad(Chat_Channel_BecomeStronger)
	
	WndStrong:showInterface()
end

--@brief	点击facebook按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMoreMenu:onClickFacebook(element)
    WZLog("WndRightMoreMenu:onClickFacebook")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    CheckLuaLoad(LUAFILES_BLOCK_COMMON)
    WndWeibo:showInterface()
end

--@brief	点击facebookBI按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMoreMenu:onClickFacebookBI(element)
    WZLog("WndRightMoreMenu:onClickFacebookBI")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --兼容之前的BM配置错误
    local isDataWithBm = false
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    if curSdkObj then
        local config = curSdkObj.m_tConfig
        if config.SDKOtherConfig.facebookInvite == "true" then
            isDataWithBm = true
        end
    end

    if isDataWithBm == false then
        for i,v in ipairs(self.m_tBtnsInfo) do
            if v.buttonId == ISLAND_RIGHT_FACEBOOKBI then
                WZLog("WndRightMoreMenu:onClickFacebookBI::",v.buttonTips)
                WZPush:openURL(v.buttonTips)
                return 
            end
        end

    else
        local tFBInviteParams = {}
        tFBInviteParams.funType = "fbInvite"
        tFBInviteParams.othersType = "fbInvite"
        local data = WZDataFile:getInstance():getUserData()
        if nil == data then
            tFBInviteParams.userID = ""
            tFBInviteParams.serverCode = ""
        else
            tFBInviteParams.userID = data:getStringValue("AccountData", "account")
            tFBInviteParams.serverCode = data:getStringValue("IPDParam", "ServerId")
        end
        tFBInviteParams.uid = tostring(GlobalGame.g_tPlayerInfo.nPlayerId)
        tFBInviteParams.playerName = tostring(GlobalGame.g_tPlayerInfo.sPlayerName)
        tFBInviteParams.level = tostring(GlobalGame.g_tPlayerInfo.nLevel)

        local curSdkObj = PassportSdkManager:getCurSdkObj()
        local sJsonArg = json.encode(tFBInviteParams)
        WZLog("WndRightMoreMenu:onClickFacebookInvite sJsonArg", sJsonArg)
        curSdkObj:accountOthers(sJsonArg, nil, NIL)
    end
end

--@brief	点击facebook邀请按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndRightMoreMenu:onClickFacebookInvite(element)
    WZLog("WndRightMoreMenu:onClickFacebookInvite")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local isDataWithBm = false
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    if curSdkObj then
        local config = curSdkObj.m_tConfig
        if config.SDKOtherConfig.facebookInvite == "true" then
            isDataWithBm = true
        end
    end

    if isDataWithBm == true then
        local tFBInviteParams = {}
        tFBInviteParams.funType = "fbInvite"
        tFBInviteParams.othersType = "fbInvite"
        local data = WZDataFile:getInstance():getUserData()
        if nil == data then
            tFBInviteParams.userID = ""
            tFBInviteParams.serverCode = ""
        else
            tFBInviteParams.userID = data:getStringValue("AccountData", "account")
            tFBInviteParams.serverCode = data:getStringValue("IPDParam", "ServerId")
        end
        tFBInviteParams.uid = tostring(GlobalGame.g_tPlayerInfo.nPlayerId)
        tFBInviteParams.playerName = tostring(GlobalGame.g_tPlayerInfo.sPlayerName)
        tFBInviteParams.level = tostring(GlobalGame.g_tPlayerInfo.nLevel)

        local curSdkObj = PassportSdkManager:getCurSdkObj()
        local sJsonArg = json.encode(tFBInviteParams)
        WZLog("WndRightMoreMenu:onClickFacebookInvite sJsonArg", sJsonArg)
        curSdkObj:accountOthers(sJsonArg, nil, NIL)
    end
end

--@brief	人物升级后更新右菜单
function WndRightMoreMenu:updateForUpgrade()
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
function WndRightMoreMenu:_update()

	if self.m_root == nil then 
		return 
	end 

	local tbconBtn = self.m_root:getChildElement("tbconBtn_WndRightMoreMenu")
	if tbconBtn == nil then 
		return 
	end
	tbconBtn = WZUITableContainer:luaTo(tbconBtn)
 
	self:_sortButton()
	local nTag = 0
    Teach.MORE_COUNT = 0
	--针对豌豆荚SDK做特殊处理：屏蔽新浪微博按钮
    if ProjConfig.CHANNEL_ID == USE_WANDOUJIA_SDK then
        for i,v in ipairs(self.m_tBtnsInfo) do
            if self:_checkIconButtonShow(v) then
                if v.buttonId ~= ISLAND_RIGHT_SINAWEIBO then
                    local conBtn = self:_createIconButton(v.buttonId, v.IsHighlight)
                    if conBtn ~= nil then
                        conBtn:setTag(nTag)
                        tbconBtn:setCellElement(conBtn)
                        nTag = nTag + 1

                        if v.buttonId == ISLAND_RIGHT_COMPOSITE then
                            Teach.MIXTURE_TAG = nTag
                        end
                        Teach.MORE_COUNT = Teach.MORE_COUNT + 1
                    end
                end
            end
        end
    else
        for i,v in ipairs(self.m_tBtnsInfo) do
            if self:_checkIconButtonShow(v) then
                local conBtn = self:_createIconButton(v.buttonId, v.IsHighlight)
                if conBtn ~= nil then
                    conBtn:setTag(nTag)
                    tbconBtn:setCellElement(conBtn)
                    nTag = nTag + 1

                    if v.buttonId == ISLAND_RIGHT_COMPOSITE then
                        Teach.MIXTURE_TAG = nTag
                    end
                    Teach.MORE_COUNT = Teach.MORE_COUNT + 1
                end
            end
        end
    end
	
	local moveElement = tbconBtn:getMoveElement()
	local pt = moveElement:getRelativePosition()
	--设置容器大小
	if nTag <= 4 then 
		tbconBtn:setRelativeSize(CCSize(0.93,1))
		tbconBtn:setCellElementHeight(0.32)
		moveElement:setRelativePosition(CCPoint(pt.x,pt.y-0.25))
	elseif nTag >4 and nTag <9 then 
		moveElement:setRelativePosition(CCPoint(pt.x,pt.y-0.03))
	elseif nTag >=9 then 
		self:_setImgBack(1.45)
		tbconBtn:setRelativeSize(CCSize(0.93,1.45))
		tbconBtn:setCellElementHeight(0.32)
		moveElement:setRelativePosition(CCPoint(pt.x,pt.y+0.21))
	end

end
--[[
--菜单按钮的响应方法
local tBtnClickFunc = {  
    [ISLAND_LEFT_RANKING] = "onClickRanking",	--排行榜
    [ISLAND_RIGHT_EXCHANGE] = "onClickExchange",	--兑换
    [ISLAND_RIGHT_SINAWEIBO] = "onClickSinaWeibo",	--新浪微博
	[ISLAND_BOTTOM_SETTING] = "onClickSetting",	    --设置
	[ISLAND_RIGHT_RECYCLING] = "onClickRecycling",	--物品回收
	
    [ISLAND_RIGHT_REINCARNATION] = "onClickReincarnation",		--转生
    [ISLAND_RIGHT_DESIGNATION] = "onClickDesignation",			--成就
    [ISLAND_RIGHT_INVITE] = "onClickInvite",
    [ISLAND_RIGHT_FACEBOOK] = "onClickFacebook",
    [ISLAND_RIGHT_FACEBOOKBI] = "onClickFacebookBI",
	[ISLAND_RIGHT_FACEBOOKINVITE] = "onClickFacebookInvite",
	[ISLAND_RIGHT_COMPOSITE] = "onClickMixture",				--合成
	[ISLAND_RIGHT_STRONG] = "onClickStrong",
	
}

--菜单按钮的高亮动画图片文件
local tBtnHighlightAniImg = {
    [ISLAND_RIGHT_RECYCLING] = "common/animation/icon_recover_an.png",			--物品回收
    [ISLAND_RIGHT_REINCARNATION] = "common/animation/icon_reincarnation_an.png",	--转生
    [ISLAND_RIGHT_DESIGNATION] = "common/animation/icon_achievement_an.png",		--成就
    [ISLAND_RIGHT_INVITE] = "common/animation/icon_invite_an.png",					--邀请
	[ISLAND_LEFT_RANKING] = "common/animation/icon_ranking_an.png",					--排行榜
	[ISLAND_RIGHT_COMPOSITE] = "common/animation/icon_composite_an.png",			--合成
	
	[ISLAND_RIGHT_EXCHANGE] ="common/animation/icon_exchange_an.png",			--兑换
	[ISLAND_BOTTOM_SETTING] = "common/animation/icon_setting_an.png",			--设置
	[ISLAND_RIGHT_SINAWEIBO] = "common/animation/icon_weibo_an.png",			

    [ISLAND_RIGHT_FACEBOOK] = "common/animation/icon_facebook_an.png",
    [ISLAND_RIGHT_FACEBOOKBI] = "common/animation/icon_facebook_an.png",
    [ISLAND_RIGHT_FACEBOOKINVITE] = "common/animation/icon_facebook_an.png",
	[ISLAND_RIGHT_STRONG] = "common/animation/icon_strong_an.png",
}
--]]
--@brief	创建按钮图片
--@param    nButtonId, 按钮id
function WndRightMoreMenu:_createIconButton(nButtonId,bIsHighlight)
    WZLog("WndRightMoreMenu:_createIconButton", nButtonId, tostring(g_tIslandBtnRes[nButtonId]))
	 if g_tIslandBtnRes[nButtonId] == nil then		 --小岛左右菜单的图片资源
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
	
	local conBtn =  WZUISystem:getInstance():createElement("conBtn_WndRightMoreMenu")
	if conBtn == nil then 
		return 
	end
	conBtn = WZUIContainer:luaTo(conBtn)
	conBtn:setVisible(true)

	--设置按钮回调
	local btnBtn = GetElement(conBtn, "btnBtn_WndRightMoreMenu", WZUIButton)
    btnBtn:setLuaDoneFunctionName(tBtnClickFunc[nButtonId])
    local imgIconNormal = GetElement(btnBtn, "imgIconNormal_WndRightMoreMenu", WZUIImage)
    imgIconNormal:setFile(g_tIslandBtnRes.iconPath..g_tIslandBtnRes[nButtonId]..".png")
	--设置按钮文字
    local imgTextNormal = GetElement(btnBtn, "imgTextNormal_WndRightMoreMenu", WZUIImage)
    imgTextNormal:setFile(g_tIslandBtnRes.textPath..g_tIslandBtnRes[nButtonId].."1.png")
	--设置点击时按钮图片	
    local imgIconSe = GetElement(btnBtn, "imgIconSel_WndRightMoreMenu", WZUIImage)
    imgIconSe:setFile(g_tIslandBtnRes.iconPath..g_tIslandBtnRes[nButtonId]..".png")
	--设置点击时按钮文字
    local imgTextSel = GetElement(btnBtn, "imgTextSel_WndRightMoreMenu", WZUIImage)
    imgTextSel:setFile(g_tIslandBtnRes.textPath..g_tIslandBtnRes[nButtonId].."1.png") 
	
	--点击时显示高清亮图
	local imgBtnHight =  GetElement(btnBtn, "imgBtnHight_WndRightMoreMenu", WZUIImage)
    local sHighlightImg = tBtnHighlightAniImg[nButtonId]
	if sHighlightImg == nil then
        return
    end
	imgBtnHight:setFile(sHighlightImg)
	--[[
	imgBtnHight:setFile(sHighlightImg)
	local btnSel =  GetElement(btnBtn, "btnSel_WndRightMoreMenu", WZUIContainer)
    local aniHighlight = self:createHighlightAni(nButtonId)
    if aniHighlight then
        btnSel:addChild(aniHighlight, -1)
    end]]
	
	--是否高亮,有动画
	if bIsHighlight == true then
        local imgCircleAni = WZUISystem:getInstance():createElement("imgCircleAni")
        conBtn:addChild(imgCircleAni)
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
function WndRightMoreMenu:createHighlightAni(nButtonId)
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

--@brief	检查功能是否开放
--@param    nBtnId, 按钮id
--@return   #1, 是否开放
function WndRightMoreMenu:_checkButtonOpen(nBtnId)
    for i,v in ipairs(self.m_tBtnsInfo) do
        WZLog(v.buttonId)
        if v.buttonId == nBtnId then
            WZLog(v.buttonId)
            local bFlag = self:_checkIconButtonOpen(v)
            if bFlag == false then
				local Tips = v.buttonStatus3Level..LocalStrings.LEVEL_OPEN_THIS_FUNCTION
				MsgBoxManager:showTipBox(v.buttonTips, 3)
            end
            return bFlag
        end
    end
end

--@brief	检查功能按钮是否开放
--@param    tButtonInfo, 按钮信息表
--@return   #1, 是否开放
function WndRightMoreMenu:_checkIconButtonOpen(tButtonInfo)
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

--@brief	检查功能按钮是否显示
--@param    tButtonInfo, 按钮信息表
--@return   #1, 是否开放
function WndRightMoreMenu:_checkIconButtonShow(tButtonInfo)
    --转生过都开放
    if GlobalGame.g_tPlayerInfo.nZsleve > 0 and  GlobalGame.g_tPlayerInfo.nZsleve < 10 then
        return true
    end
    
    if GlobalGame.g_tPlayerInfo.nLevel and tButtonInfo.buttonStatus1Level and 
        GlobalGame.g_tPlayerInfo.nLevel < tButtonInfo.buttonStatus1Level then
        return false
    else
        return true
    end
end

--@brief	关闭动画效果
function WndRightMoreMenu:_closeAction()
	 -- 创建动画效果
    local actMoveTo = WZUIActionMoveTo:create()
	if nil == actMoveTo then
		return
	end
	actMoveTo:setDuration(0.1)
	actMoveTo:setMoveX(0.9)
	actMoveTo:setMoveY(0.5)
	actMoveTo:setFinishLuaFunction("onClose")
	--执行动作
	local conWndRightMenu= WZUIContainer:luaTo(self.m_root:getChildElement("conWndRightMenu_WndRightMoreMenu"))
	if conWndRightMenu ~= nil then
		conWndRightMenu:runUIAction(actMoveTo)
	end
end

--@brief	设置背景图
--@param    size, 背景大小
function WndRightMoreMenu:_setImgBack(size)
	local imgBack = self.m_root:getChildElement("imgBack_WndRightMoreMenu")
	if imgBack then 
		imgBack = WZUI9Image:luaTo(imgBack)
		imgBack:setScaleY(size)
	end 
end

--@brief	设置表格容器大小
--@param    element:UI对应节点,size:背景大小,num:容器列数
function WndRightMoreMenu:_setTableSize(element,size,num)
	local tbconBtn = element:getChildElement("tbconBtn_WndRightMoreMenu")
	if tbconBtn then 
		tbconBtn = WZUITableContainer:luaTo(tbconBtn)
		tbconBtn:setAbsContentSize(CCSize(size-20,110))
		tbconBtn:setUseAbsSize(true)
		tbconBtn:setColumnCount(num)
		tbconBtn:setHorizontalInterval(0.01)
	end
end

-------------------------------------私有方法模块End----------------------------------------
