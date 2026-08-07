--CellVipGiftBagList.lua
--@brief	CellVipGiftBagList的UI模块
--@date		2014/04/19
--@author	jiaming_liu
--@modify   binshao 2015-5-8
--@note		会员每日礼包详情列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellVipGiftBagList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellVipGiftBagList:onExit(element)
	self:_unInit()
end

-- 点击领取VIP等级奖励的回调
function CellVipGiftBagList:onGetGiftClicked(element)
	WZLog("CellVipGiftBagList:onGetGiftClicked")
	if self.m_nBtnStauts == 0 or not self.m_root then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--弹窗
	if self.m_nBtnStauts ==2 then 
        WZLog("领取VIP等级礼包222")
		local window = WZUISystem:getInstance():createElement("WndVipChild1_WndVip")
		if not self.m_tWindwos then
			self.m_tWindwos = {
				onEnter = function(owner,element) 
					WZLog("self.m_tWindwos.m_root ",element)
					self.m_tWindwos.m_root = element
                    -- 确定按键txt
                    local txtBtnSure = GetElement(element, "txtOK_WndVipChild1", WZUILabelTTF)
                    if txtBtnSure then txtBtnSure:setText(LocalStrings.CONFIRM) end

                    -- 充值按键txt
                    local txtBtnRecharge = GetElement(element, "txtRecharge_WndVipChild1", WZUILabelTTF)
                    if txtBtnRecharge then txtBtnRecharge:setText(LocalStrings.REWARD_BTN_GET) end

                    -- 当前提示的VIP信息（该礼包需要达到多少级才能领取）
                    local needLv = GetElement(element, "freeText_WndVipChild1", WZUIFreeTextBox)
                    if needLv then needLv:setShowText(string.format(LocalStrings.VIP_TIP08,	self.m_root:getTag()+1)) end

                    -- 当前提示的VIP信息（您当前VIP为多少级）
                    local  curLv = GetElement(element, "txt01_WndVipChild1", WZUILabelTTF)
                    if curLv then curLv:setText(LocalStrings.VIP_TIP04) end

					--处理VIP图标
					local nlv = ""
                    local imgVIP = GetElement(element, "imgVipLevel_WndVipChild1",WZUIImage)
					if WndVip.m_tVipData and WndVip.m_tVipData.vipLv >0 then
						nlv = WndVip.m_tVipList.vipLv
                        if imgVIP then imgVIP:setGrayRender(false) end
                    end
                    if imgVIP then imgVIP:setFile("ui/rightMenu/vip/vip" .. nlv .. ".png") end

                    -- 调整容器位置
                    local con = GetElement(element, "conCenter_WndVipChild1",WZUIContainer)
                    if con then con:setRelativePositionLuaTo(0.5, 0.1) end

					--隐藏标题
                    local imgTitle = GetElement(element, "imgTitle_WndVipChild1",WZUIImage)
                    if imgTitle then imgTitle:setVisible(false) end
				end,
				onExit = function() 
				end,
				onDoneClicked = function(element)
					WZLog("onDoneClicked")
					WindowManager:removeWindow(self.m_tWindwos.m_root,self.m_tWindwos,true)
				end,
				onRechargeClicked = function(element)
					WZLog("onRechargeClicked")
					WindowManager:removeWindow(self.m_tWindwos.m_root,self.m_tWindwos,true)
					if WndVip.m_root then 
						GetElement(WndVip.m_root, "checkBoxGroup_WndVip", WZUICheckBoxGroup):setCheckIndex(0)
						GetElement(WndVip.m_root, "frameconContentList_WndVip", WZUIFrameElement):ShowFrameElement(0)
					end 
				end,
			}
		end
		window:setLuaObjectIndex(self.m_tWindwos)
		WindowManager:addWindow(window, self.m_tWindwos, true)
	--领取
	elseif self.m_nBtnStauts == 3 then  
        WZLog("领取VIP等级礼包333")
	end 
end

-- 更新VIP一条等级奖励的UI
function CellVipGiftBagList:updateUI(nVipLevel, tData)
	WZLog("CellVipGiftBagList:updateUI",nVipLevel,#tData)
	if not self.m_root then return end
	self.m_tData = tData
	self.m_nLv = nVipLevel
	--VIP等级图标
    local imgLevel = GetElement(self.m_root, "imgLevel_CellVipGiftBagList", WZUIImage)
    if imgLevel then imgLevel:setFile("ui/rightMenu/vip/vip" .. nVipLevel .. ".png") end
	--VIP等级文字
    local txtLevel = GetElement(self.m_root, "txtLevel_CellVipGiftBagList", WZUILabelTTF)
    if txtLevel then txtLevel:setText(LocalStrings.LEVEL .. nVipLevel) end
	--VIP奖励物品图标
	self.m_root:enableSchedule("_createOneLevelAwardSchedule")
	--VIP领取按钮文字
	self:_setBtnText(nVipLevel, tData)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 动态创建VIP等级礼包里面的一个等级的奖励
function CellVipGiftBagList:_createOneLevelAwardSchedule( element)
	for i=1,5 do
		if self.m_nIndex <= #self.m_tData then 
			self:_createOneAward(self.m_nIndex,self.m_tData[self.m_nIndex])
			self.m_nIndex = self.m_nIndex +1
		else 
			element:disableSchedule()
			break
		end 
	end
end 

-- 点击奖励的弹框介绍
function CellVipGiftBagList:onTouchIcon(cell,tag)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndItemInfo:showInfo(cell.m_root, WndVip.m_root or self.m_root:getParentElement(),1,{id=tag},false,GlobalMethod:ccp(0,-15))
end 

-- 创建一个VIP等级礼包中陈列的一个奖励cell
-- tab是等级礼包中奖励的列表
-- index 奖励的下标，可以用来控制显示位置
function CellVipGiftBagList:_createOneAward(index, tab)
	local conGift = GetElement(self.m_root, "conGiftList_CellVipGiftBagList", WZUIContainer)
	local tempData = {
        id = tab.itemId,
        icon=tab.itemIcon,
        lastTime = tab.days,
        lastNum=tab.count,
        quality=tab.quality,
        basicInfo = ShopItems["id_"..tab.itemId]
    }
    -- TODO:itenType，sJson是否有用
    local itenType =  ShopItems["id_"..tab.itemId].type
    local  sJson = json.encode(tempData)

	-- 创建一个奖励的图标
	local celElement,tLuaObj = CellGoodItem:createElement()
	if celElement then
		celElement = WZUIContainer:luaTo(celElement)
		celElement:setAbsContentSize(GlobalMethod:CCSize(100,100))
		celElement:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		celElement:setUseAbsCoordinate(true)
		celElement:setAbsPosition(GlobalMethod:ccp(104*(index-1),65))
        celElement:setTag(tab.itemId)
        conGift:addChild(celElement)

        tLuaObj:setCellGoodItem(tempData,4)
        tLuaObj:setItemClickFun(self,self.onTouchIcon)
	end
end 

-- 设置领取按键的txt
function CellVipGiftBagList:_setBtnText(nVipLevel, tData)
    local txtBtnDis = GetElement(self.m_root, "txtBtnDis_CellVipGiftBagList", WZUILabelTTF)
    if txtBtnDis then txtBtnDis:setText(LocalStrings.ACTIVE_GET) end

	if tData.isReceiveLvPack == 1 then -- 已领取
		self.m_nBtnStauts = 1
        local Btn = GetElement(self.m_root, "btnHasGet_CellVipGiftBagList", WZUIButton)
        if Btn then Btn:setTouchEnable(false) end
	else
        local Btn = GetElement(self.m_root, "btnHasGet_CellVipGiftBagList", WZUIButton)
        if Btn then Btn:setTouchEnable(true) end

        local txtBtn = ""
		if nVipLevel == 0 or WndVip.m_tVipData.vipLv < nVipLevel then
			self.m_nBtnStauts = 2 --VIP领取
            txtBtn = "VIP" .. nVipLevel .. LocalStrings.INVITE_RECEIVE
		else 
			self.m_nBtnStauts = 3 --领取
            txtBtn = LocalStrings.INVITE_RECEIVE
		end
        local txtBtnNor =  GetElement(self.m_root, "txtBtnNor_CellVipGiftBagList", WZUILabelTTF)
        local txtBtnSel =  GetElement(self.m_root, "txtBtnSel_CellVipGiftBagList", WZUILabelTTF)
        txtBtnNor:setText(txtBtn)
        txtBtnSel:setText(txtBtn)
	end 
end
-------------------------------------私有方法模块End----------------------------------------
