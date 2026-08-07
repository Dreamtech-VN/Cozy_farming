--WndLeftMenu.lua
--@brief	WndLeftMenu的UI模块
--@date		2013/12/10
--@author	xiaoyu_wu
--@note		左菜单模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLeftMenu:onEnter(element)
	self.m_root = element
	
    local tBtnsInfo = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_LEFT)
	local tBtnWelInfo = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_WELFARE)
	self:setBtnsInfo(tBtnsInfo,tBtnWelInfo)

    Teach:isStartTeach("WndLeftMenu:onEnter")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLeftMenu:onExit(element)
	self:_unInit()
    Teach:isStartTeach("WndLeftMenu:onExit")
end

--@brief	点击奖励按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndLeftMenu:onClickAwarding(element)
	if self.m_root == nil then
		return
	end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    DataUUtil("OL_Island_Rankings","")
	CheckLuaLoad(LUAFILES_BLOCK_COMMON)
	CheckLuaLoad(Chat_Channel_OnlineReward)
	
	local wndRewardSys =  WndRewardSystem:createElement()
    if wndRewardSys ~= nil then
       WindowManager:addWindow( wndRewardSys , WndRewardSystem)
    end
	
end

--@brief	点击福利按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndLeftMenu:onClickWelfare(element)
	WZLog("WndLeftMenu:onClickMessage")

	if self.m_root == nil then
		return
	end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getParentElement():getTag()
	local posY = 540-tag*120
	
	local num = 0 
	for i,v in ipairs(self.m_tBtnWelInfo) do
        if self:_checkIconButtonOpen(v) then
			num = num +1
		end
	end
	
	local size = num*133
	
    --打开福利弹框
    local wndLeftBox = WndLeftBox:createElement()
	wndLeftBox = WZUIElementContainer:luaTo(wndLeftBox)
	wndLeftBox:setAbsPosition(CCPoint(120,posY)) --设置弹出框位置
	--修改容器大小
	if num <= 3 then 
		wndLeftBox:setAbsContentSize(CCSize(size,120))
		WndLeftBox:_setImgBack(wndLeftBox,size,num)		
	elseif num == 4 then 
		wndLeftBox:setAbsContentSize(CCSize(500,120))
		WndLeftBox:_setImgBack(wndLeftBox,500,num)		
	end
	if wndLeftBox == nil then
		return
	end
	WindowManager:addWindow( wndLeftBox , WndLeftBox )
    
end

--@brief	点击会员按钮后的响应方法
--@param	element:按钮的UI节点引用
--@note		在这里做相应的按钮相应事件
function WndLeftMenu:onClickVip(element)
	WZLog("WndRightMenu:onClickVip")
     DataUUtil("OL_Island_HuiYuan","")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    CheckLuaLoad(LUAFILES_BLOCK_COMMON)
	CheckLuaLoad(Chat_Channel_vip)
    WndVip:showWndUI(0)
end

--@brief	设置奖励数量
--@note	    由协议层回调
function WndLeftMenu:setRewardCount(checkReward)
    -- checkReward : 是否有未领取奖励数量（true表示有，false表示没有）
	-- rewardNum : 未领取奖励数量
	local rewardNum = GlobalGame.g_nSignRewardNum + GlobalGame.g_nLoginRewardNum + GlobalGame.g_nLevelRewardNum +GlobalGame.g_nOnlineRewardNum
	WZLog("设置奖励数量",checkReward,rewardNum)
    if self.m_root == nil then
        return
    end
    local conReward = self.m_root:getChildElement("conRewardCount_WndLeftMenu")
    if conReward == nil then
        return
    end
    if self.m_bIsOpenAward == true then 
		if checkReward and rewardNum > 0 then
			conReward:setVisible(true)
			if rewardNum > 99 then
				rewardNum = 99
			end
			local txtReward = GetElement(self.m_root, "txtRewardCount_WndLeftMenu", WZUILabelTTF)
			txtReward:setText(tostring(rewardNum))
		else
			conReward:setVisible(false)
		end
	else 
		conReward:setVisible(false)
	end
end

--@brief	设置vip物品奖励数量
--@note	    由协议层回调
function WndLeftMenu:setVipCount(checkCount)
    -- checkCount : 是否有未领取奖励数量（true表示有，false表示没有）
	-- vipNum : 未领取奖励数量
	local vipNum = GlobalGame.g_nVipGiftBagNum
	WZLog("设置vip物品奖励数量",vipNum)
    if self.m_root == nil then
        return
    end
    local conVIPCount = self.m_root:getChildElement("conVIPCount_WndLeftMenu")
    if conVIPCount == nil then
        return
    end
    if self.m_bIsOpenVip == true then 
		if checkCount and vipNum > 0 then
			conVIPCount:setVisible(true)
			if vipNum > 99 then
				vipNum = 99
			end
			local txtVIPCount = GetElement(self.m_root, "txtVIPCount_WndLeftMenu", WZUILabelTTF)
			txtVIPCount:setText(tostring(vipNum))
		else
			conVIPCount:setVisible(false)
		end
	else
		conVIPCount:setVisible(false)
	end
end

--@brief	人物升级后更新左菜单
function WndLeftMenu:updateForUpgrade()
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
--@brief	更新左菜单UI界面
function WndLeftMenu:_update()
	
    if self.m_root == nil then
        return
    end
    if self.m_tBtnsInfo == nil then
        self:_setDefaultBtnsInfo()
    end
    local tbcon = GetElement(self.m_root, "tbcon_WndLeftMenu", WZUITableContainer)
    tbcon:cleanTable()
    
	self:_sortButton()
    local nTag = 0
    for i,v in ipairs(self.m_tBtnsInfo) do
        if self:_checkIconButtonOpen(v) then
            local conBtn = self:_createIconButton(v.buttonId, v.IsHighlight)
            if conBtn ~= nil then
				--奖励增加数字提示
				if v.buttonId == ISLAND_LEFT_AWARD then
                    local conReward = WZUISystem:getInstance():createElement("conRewardCount_WndLeftMenu")
                    if conReward ~= nil then
                        conBtn:addChild(conReward)
						self.m_bIsOpenAward = true
                    end
				end
				--VIP增加数字提示
				if v.buttonId == ISLAND_RIGHT_VIP then
                    local conVIPCount = WZUISystem:getInstance():createElement("conVIPCount_WndLeftMenu")
                    if conVIPCount ~= nil then
                        conBtn:addChild(conVIPCount)
						self.m_bIsOpenVip = true
                    end
				end
                conBtn:setTag(nTag)
                tbcon:setCellElement(conBtn)
                nTag = nTag + 1
            end
        end
    end
	self:setRewardCount(true)
	self:setVipCount(true)
end
--[[
--菜单按钮的响应方法
local tBtnClickFunc = {
    [ISLAND_LEFT_AWARD] = "onClickAwarding",
    [ISLAND_LEFT_WELFARE] = "onClickWelfare",
    [ISLAND_RIGHT_VIP] = "onClickVip",
}

--菜单按钮的高亮动画图片文件
local tBtnHighlightAniImg = {
    [ISLAND_LEFT_AWARD] = "common/animation/icon_iconaward_an.png",
    [ISLAND_LEFT_WELFARE] = "common/animation/icon_welfare_an.png",
    [ISLAND_RIGHT_VIP] = "common/animation/icon_vip_an.png",
}
--]]
--@brief	根据按钮id创建一个按钮
--@param    nButtonId, 按钮id
--@param    bIsHighlight, 是否高亮
--@return   #1, 按钮的节点引用
function WndLeftMenu:_createIconButton(nButtonId, bIsHighlight)
   if g_tIslandBtnRes[nButtonId] == nil then
        return
    end
    local conBtn = WZUISystem:getInstance():createElement("conBtn_WndLeftMenu")
    if conBtn == nil then
        return
    end
    conBtn:setVisible(true)

    local btn = GetElement(conBtn, "btn_WndLeftMenu", WZUIButton)
    btn:setLuaDoneFunctionName(tBtnClickFunc[nButtonId])
    local imgIconNormal = GetElement(btn, "imgIconNormal_WndLeftMenu", WZUIImage)
    imgIconNormal:setFile(g_tIslandBtnRes.iconPath..g_tIslandBtnRes[nButtonId]..".png")
    local imgTextNormal = GetElement(btn, "imgTextNormal_WndLeftMenu", WZUIImage)
    imgTextNormal:setFile(g_tIslandBtnRes.textPath..g_tIslandBtnRes[nButtonId].."1.png") 
    local imgIconSe = GetElement(btn, "imgIconSel_WndLeftMenu", WZUIImage)
    imgIconSe:setFile(g_tIslandBtnRes.iconPath..g_tIslandBtnRes[nButtonId]..".png")
    local imgTextSel = GetElement(btn, "imgTextSel_WndLeftMenu", WZUIImage)
    imgTextSel:setFile(g_tIslandBtnRes.textPath..g_tIslandBtnRes[nButtonId].."1.png") 
    
	--点击时显示高清亮图
	local imgHightIcon =  GetElement(btn, "imgHightIcon_WndLeftMenu", WZUIImage)
    local sHighlightImg = tBtnHighlightAniImg[nButtonId]
	if sHighlightImg == nil then
        return
    end
	imgHightIcon:setFile(sHighlightImg)
	
	--判断是否高亮
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
function WndLeftMenu:createHighlightAni(nButtonId)
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
function WndLeftMenu:_checkIconButtonOpen(tButtonInfo)
    --转生过都开放
    WZLog("WndLeftMenu:_checkIconButtonOpen",json.encode(tButtonInfo),tButtonInfo.buttonId)
    if GlobalGame.g_tPlayerInfo.nZsleve ~= nil and GlobalGame.g_tPlayerInfo.nZsleve > 0 and  GlobalGame.g_tPlayerInfo.nZsleve < 10 then
        if tButtonInfo.buttonId == 47 then
            WndVip.b_isOpenMonthlyCard = true
            WZLog("是否开启月卡",WndVip.b_isOpenMonthlyCard)
        end
        return true
    end
    
    if GlobalGame.g_tPlayerInfo.nLevel and tButtonInfo.buttonStatus3Level and 
        GlobalGame.g_tPlayerInfo.nLevel < tButtonInfo.buttonStatus3Level then
        if tButtonInfo.buttonId == 47 then
            WndVip.b_isOpenMonthlyCard = false
            WZLog("是否开启月卡",WndVip.b_isOpenMonthlyCard)
        end
        return false
    else
        if tButtonInfo.buttonId == 47 then
            WndVip.b_isOpenMonthlyCard = true
            WZLog("是否开启月卡",WndVip.b_isOpenMonthlyCard)
        end
        return true
    end
end




-------------------------------------私有方法模块End----------------------------------------
