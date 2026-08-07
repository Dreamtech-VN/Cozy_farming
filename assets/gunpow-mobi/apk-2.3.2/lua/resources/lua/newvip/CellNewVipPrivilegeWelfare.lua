--CellNewVipPrivilegeWelfare.lua
--@brief	CellNewVipPrivilegeWelfare的UI模块
--@date		2021/04/06
--@author	hyx
--@note		vip福利描述


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewVipPrivilegeWelfare:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewVipPrivilegeWelfare:onExit(element)
	self:_unInit()
end

function CellNewVipPrivilegeWelfare:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function CellNewVipPrivilegeWelfare:actionCallback()
	self:initShow()
end

function CellNewVipPrivilegeWelfare:initShow()
	self.m_nCurDescIndex = CacheCenter:getPlayerInfo().vipLevel
	if self.m_nCurDescIndex <= 0 then
		self.m_nCurDescIndex = 1
	end
    local str = [[<T C="229,105,22" S="22" P="1">%s</T><T C="127,70,26" S="20" P="1">%s</T>]]
    local txtFreeLevelGift = GetElement(self.m_root,"txtFreeLevelGift",WZUIFreeTextBox)
    txtFreeLevelGift:setShowText(string.format(str,LocalStrings.NEWVIP_TEXT31,LocalStrings.VIP_TIP11))
    local txtFreeWeekGift = GetElement(self.m_root,"txtFreeWeekGift",WZUIFreeTextBox)
    txtFreeWeekGift:setShowText(string.format(str,LocalStrings.NEWVIP_TEXT32,LocalStrings.VIP_TIP12))
	self:setChangeDesc(self.m_nCurDescIndex)
end
function CellNewVipPrivilegeWelfare:onBtnClickLeft()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if (self.m_nCurDescIndex - 1) <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.NEWVIP_TEXT10)
		return
	end
	self.m_nCurDescIndex = self.m_nCurDescIndex - 1
	self:setChangeDesc(self.m_nCurDescIndex)
end

function CellNewVipPrivilegeWelfare:onBtnClickRight()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if (self.m_nCurDescIndex + 1) > WndVip:_getMaxLevel() then
		MsgBoxManager:showTipBox(LocalStrings.NEWVIP_TEXT9)
		return
	end

	self.m_nCurDescIndex = self.m_nCurDescIndex + 1
	self:setChangeDesc(self.m_nCurDescIndex)
end
function CellNewVipPrivilegeWelfare:setChangeDesc(index)
	local txtVipLv = GetElement(self.m_root, "txtCheckVipLevel", WZUILabelTTF)
    txtVipLv:setText("VIP"..index..LocalStrings.VIP_POWER)
    WZLog("CellNewVipPrivilegeWelfare:setChangeDesc", index)
    if GDatatab_vip_privilege then
    	local str = "VIP"..index..": "
    	local id, num, id2, num2 = {}, {}, {}, {}
	    local txtLevelGift = GetElement(self.m_root,"txtLevelGift",WZUILabelTTF)
	    local info = GDatatab_vip_privilege["id_"..index].level_up_gift
	    local str1 = ""
	    if type(info) == "table" then 
		    for i=1, #info do
		    	local data = GDatatab_item["id_"..info[i][1]]
		    	if data.sex == CacheCenter:getPlayerInfo().sex or data.sex == 2 then
			    	table.insert(id, info[i][1])
			    	table.insert(num, info[i][2])
			    end
		    	-- if data then
		    	-- 	str1 = str1.. data.name .."*"..info[i][2].." "
		    	-- end
		    end
	--	    txtLevelGift:setText(str..str1)

		    local txtWeekGift = GetElement(self.m_root,"txtWeekGift",WZUILabelTTF)
		    local info = GDatatab_vip_privilege["id_"..index].weekly_reward
		    local str2 = ""
		    for i=1, #info do
		    	local data = GDatatab_item["id_"..info[i][1]]
		    	-- if data then
		    	-- 	str2 = str2.. data.name .."*"..info[i][2].." "
		    	-- end
		    	if data.sex == CacheCenter:getPlayerInfo().sex or data.sex == 2 then
		    		table.insert(id2, info[i][1])
		    		table.insert(num2, info[i][2])
			    end
		    end
			GetElement(self.m_root, "conPowerDesc_WndVip", WZUIContainer):setVisible(true)
	    	self:_createVipReward(id, num, id2, num2)
		else
			GetElement(self.m_root, "conPowerDesc_WndVip", WZUIContainer):setVisible(false)
		end
--	    txtWeekGift:setText(str..str2)
	end
    local ftb = GetElement(self.m_root,"ftbPowerDesc",WZUIFreeTextBox)
    local scl = GetElement(self.m_root,"scrollPowerDesc",WZUIScrollContainer)
    ftb:setShowText(LocalStrings['VIP_LEVEL_'..index])

    local ftbSize = ftb:getContentSize()
    local SclSize = scl:getContentSize()
    ftb:setPositionY(ftbSize.height)

    --更改滚动容器Element的大小
    local con = scl:getMoveElement()
    local size = con:getRelativeSize()
    con:setRelativeSize( GlobalMethod:CCSize(1 , ftbSize.height/SclSize.height + 0.015))
    scl:UpdateInsidePosition()  --更新滚动容器内部布局
    con:setPositionY(scl:getMinPosition().y)
end
function CellNewVipPrivilegeWelfare:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新vip奖励
function CellNewVipPrivilegeWelfare:_createVipReward(id, num, id2, num2)
	for i=1,4 do
        --WZLog("CellNewVipPrivilegeWelfare:_createVipReward two", Serialize(id), Serialize(num))
		local con = GetElement(self.m_root,"conLeft"..i,WZUIContainer)
		con:removeAllChildrenWithCleanup(true)
		if id[i] ~= nil then
	        local key = "id_"..id[i]
			local tData = GDatatab_item[key]
	        local name = tData.name
	        local icon = tData.icon
	        local num =  num[i]
	        local quality = tData.quality
	        local itemInfo = {name=name,icon=icon,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(tData)}

			local celElement,tLuaObj = CellGoodItem:createElement()
	        if celElement ~= nil then 
			   	celElement = WZUIContainer:luaTo(celElement)
	            tLuaObj:setCellGoodItem(itemInfo, 16)
	            tLuaObj:setItemClickFun(self, self.onClickItem)
				celElement:setScale(0.9)
				con:addChild(celElement)
	        end
		end

		local conRight = GetElement(self.m_root,"conRight"..i,WZUIContainer)
		conRight:removeAllChildrenWithCleanup(true)
		if id2[i] ~= nil then
	        local key = "id_"..id2[i]
			local tData = GDatatab_item[key]
	        local name = tData.name
	        local icon = tData.icon
	        local num =  num2[i]
	        local quality = tData.quality
	        local itemInfo = {name=name,icon=icon,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(tData)}

			local celElement,tLuaObj = CellGoodItem:createElement()
	        if celElement ~= nil then 
			   	celElement = WZUIContainer:luaTo(celElement)
	            tLuaObj:setCellGoodItem(itemInfo, 16)
	            tLuaObj:setItemClickFun(self, self.onClickItem)
				celElement:setScale(0.9)
				conRight:addChild(celElement)
	        end
		end
	end
end

function CellNewVipPrivilegeWelfare:onClickItem(tItem, nTag, tData)
	if self.m_root == nil then return end
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function CellNewVipPrivilegeWelfare:_adaptLanguage_vn()
    GetElement(self.m_root,"txtRightGift2_WndVip",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.35,0.83))
end
-------------------------------------语言适配End----------------------------------------

