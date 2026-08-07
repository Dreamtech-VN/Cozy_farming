--WndUpgradeGem.lua
--@brief	WndSelectTipsStrengthen的UI模块
--@date		2015/06/09
--@author	zsq
--@note		选择宝石或装备界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndUpgradeGem:onEnter(element)
	self.m_root = element
end

--@brief	加载动画
function WndUpgradeGem:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
    AdaptLanguage(self)
end

--@brief	加载动画完
function WndUpgradeGem:actionCallback()

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndUpgradeGem:onExit(element)
	self:_unInit()
end

--@brief    关闭按钮回调
function WndUpgradeGem:onCancel(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
end

--@brief	关闭整个窗口的动画效果
function WndUpgradeGem:onCloseActionCallback(element,data)
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief	点击开始
function WndUpgradeGem:onTouchBegan()
	for i=1,3 do
		if self["m_tCell"..i] ~= nil then
   			self["m_tCell"..i]:setHighLight(false)
		end
	end
	if self.m_nSelected ~= nil then
   		self["m_tCell"..self.m_nSelected]:setHighLight(true)
	end
end

--@brief	点击结束
function WndUpgradeGem:onTouchEnd()
	WZLog("WndUpgradeGem:onTouchEnd")
	--设置选中方案
	for i=1,3 do
		if self["m_tCell"..i] ~= nil then
   			self["m_tCell"..i]:setHighLight(false)
		end
	end
	if self.m_nSelected ~= nil then
   		self["m_tCell"..self.m_nSelected]:setHighLight(true)
	end
end

--@brief	确定按钮
function WndUpgradeGem:onSure(element)
	WZLog("WndUpgradeGem:onSure")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nSelected == nil then
		MsgBoxManager:showTipBox(LocalStrings.PETNOGOODS)
        return
	end
    --判断金币是否足够
    local playerGold = CacheCenter:getMoneyList().gold
    if tonumber(GetElement(self.m_root,"txtCost",WZUILabelTTF):getText()) > tonumber(playerGold) then
        MsgBoxManager:showConfirmBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil, nil)
        return
    end

	if self.m_nSelected ~= nil then
		WZLog("WndUpgradeGem:onSure",self.m_tData.playerItemId,self.m_tDataList[1].id,self.m_tDataList[self.m_nSelected].id)
		if self.m_tDataList[1].value >= GEMMAXLEVEL then
			MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO42)
			return
		end
    	local id = WZLuaVector_int_:create()
   		id:push(self.m_tDataList[self.m_nSelected].id)
		ProtocolProcessorMerge:send_MERGE_MergeItemFast(self.m_tData.playerItemId, self.m_tDataList[1].id, id )
	end
	for k,v in pairs(GDatatab_itemmerge) do
		if v.id == self.m_tDataList[1].id then
			WndGemMountingStrengthen.m_nUpgradeGemId = v.items[1][1]
			break
		end
	end
    WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
end

--@brief    购买金币框
--@param    nResType:响应类型(超时，确定，取消)
function WndUpgradeGem:buyGold(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(26)
    end
end

--@brief	点击格子
function WndUpgradeGem:onClick(tCell, tag)
	WZLog("WndUpgradeGem:onClick",tag)
	--材料足够就设置选中，否则没有响应
	if self["m_tCell"..tag].isAmple == true then
		self.m_nSelected = tag
	else
		MsgBoxManager:showTipBox(LocalStrings.STRENGTENTIP9)
	end
	self:setCost()
end

--@brief	刷新界面
function WndUpgradeGem:update()
	WZLog("WndUpgradeGem:update")
	local tData = GDatatab_item["id_"..self.m_nTargetStoneId]
	local mergeType = 3
	local len = 3
	local tDataList = {}
	tDataList[1] = tData
	if tData.value == 1 then
		len = 1
		mergeType = 1
	elseif tData.value == 2 then
		len = 2
		mergeType = 2
		local subGemId = self:getSubGem(self.m_nTargetStoneId)
		tDataList[2] = GDatatab_item["id_"..subGemId]
	else
		len = 3
		mergeType = 3
		local subGemId = self:getSubGem(self.m_nTargetStoneId)
		tDataList[2] = GDatatab_item["id_"..subGemId]
		tDataList[3] = GDatatab_item["id_"..self:getSubGem(subGemId)]
	end
	self.m_tDataList = tDataList
	
	for i=1,len do
		local con = GetElement(self.m_root,"conGrid"..i,WZUIContainer)
	    local celElement,tLuaObj = CellGoodItem:createElement()
		local tempData = tDataList[i]
        local itemInfo = {name=tempData.name,icon=tempData.icon,lastNum=4,quality=tempData.quality,basicInfo=CopyTable(tempData)}
		itemInfo.lastNum = CacheCenter:getPlayerItemCountById(itemInfo.basicInfo.id)
        if celElement ~= nil then 
	    	celElement = WZUIContainer:luaTo(celElement)
            tLuaObj:setCellGoodItem(itemInfo, 4)
            tLuaObj:setItemClickFun(self, self.onClick)
            tLuaObj:setItemCount(itemInfo.lastNum.."/"..(4^i-4^(i-1)))
            --if self.m_bIsShowBySendGift == true then
             --  tLuaObj:_hightlight()
              -- tLuaObj:setHightLightVisible(false)
               --if i == 0 then
                --   	tLuaObj:setHightLightVisible(true)
                 --  	self.m_tSelectCell = tLuaObj
                  -- 	self.m_nSelectItemId = self.info[i+1].basicInfo.id
               --end
            --end
            celElement:setTag(i)
			con:addChild(celElement)
			self["m_tCell"..i] = tLuaObj
			--判定数量是否足够
			if itemInfo.lastNum >= (4^i-4^(i-1)) then
				tLuaObj.isAmple = true
				if tLuaObj.m_txtCount ~= nil then
					tLuaObj.m_txtCount:setColor(ccc3(255,255,255))	
				end
				if self.m_nSelected == nil then
					self.m_nSelected = i
					tLuaObj:setHighLight(true)
				end
			else
				tLuaObj.isAmple = false
				tLuaObj:setHightLightVisible(false)
				if tLuaObj.m_txtCount ~= nil then
					tLuaObj.m_txtCount:setColor(ccc3(255,89,74))	
				end
			end
       end
	end 

	--调整容器位置
	if mergeType == 1 then
		GetElement(self.m_root,"conGrid"..1,WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	elseif mergeType == 2 then
		GetElement(self.m_root,"conGrid"..1,WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.33,0.5))
		GetElement(self.m_root,"conGrid"..2,WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.66,0.5))
	elseif mergeType == 3 then
		GetElement(self.m_root,"conGrid"..1,WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.21,0.5))
		GetElement(self.m_root,"conGrid"..2,WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		GetElement(self.m_root,"conGrid"..3,WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.79,0.5))
	end

	self:setCost()
end

--@brief	查找合成需要的宝石
--@param	需要合成的宝石id
function WndUpgradeGem:getSubGem(id)
	for k,v in pairs(GDatatab_itemmerge) do
		if v.items[1][1] == id then
			return v.id
		end
	end
end

--@brief	计算花费金币
function WndUpgradeGem:setCost()
	if self.m_nSelected == nil then return 0 end
	local cost1 = 0
	local cost2 = 0
	local cost3 = 0
	if self.m_nSelected >= 1 then
		for k,v in pairs(GDatatab_itemmerge) do
			if v.id == self.m_tDataList[1].id then
				cost1 = v.cost[1][2]
			end
		end
	end
	if self.m_nSelected >= 2 then
		for k,v in pairs(GDatatab_itemmerge) do
			if v.id == self.m_tDataList[2].id then
				cost2 = v.cost[1][2] * 3
			end
		end
	end
	if self.m_nSelected == 3 then
		for k,v in pairs(GDatatab_itemmerge) do
			if v.id == self.m_tDataList[3].id then
				cost3 = v.cost[1][2] * 12
			end
		end
	end
	GetElement(self.m_root,"txtCost",WZUILabelTTF):setText(cost1+cost2+cost3)
end

--------------------------------------------语言适配Begin----------------------------------
function WndUpgradeGem:_adaptLanguage_en()
    local txtTip = GetElement(self.m_root,"txtTip_WndUpgradeGem",WZUILabelTTF)
    txtTip:setScale(0.8)
end

function WndUpgradeGem:_adaptLanguage_es(  )
	local txtTip1 = GetElement(self.m_root,"txtTip1_WndUpgradeGem",WZUILabelTTF)
	txtTip1:setRelativePosition(GlobalMethod:ccp(0.4,0.765))
	local txtTip = GetElement(self.m_root,"txtTip_WndUpgradeGem",WZUILabelTTF)
	txtTip:setRelativePosition(GlobalMethod:ccp(0.27,0.33))
	local imgGold = GetElement(self.m_root,"imgGold_WndUpgradeGem",WZUIImage)
	imgGold:setRelativePosition(GlobalMethod:ccp(0.555,0.33))
	local txtCost = GetElement(self.m_root,"txtCost",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.61,0.33))

	GetElement(self.m_root,"txtUpgrade_WndUpgradeGem",WZUILabelTTF):setScale(0.7)
end

function WndUpgradeGem:_adaptLanguage_pt(  )
	local imgGold = GetElement(self.m_root,"imgGold_WndUpgradeGem",WZUIImage)
	imgGold:setRelativePosition(GlobalMethod:ccp(0.420633,0.33))
	local txtCost = GetElement(self.m_root,"txtCost",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.470506,0.33))
end

function WndUpgradeGem:_adaptLanguage_tr()
    local txtTip = GetElement(self.m_root,"txtTip_WndUpgradeGem",WZUILabelTTF)
    txtTip:setScale(0.75)
    txtTip:setRelativePosition(GlobalMethod:ccp(0.179747,0.33))
end
--------------------------------------------语言适配End-------------------------------------