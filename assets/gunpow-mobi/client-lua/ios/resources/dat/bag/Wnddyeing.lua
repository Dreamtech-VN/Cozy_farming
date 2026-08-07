--Wnddyeing.lua
--@brief	Wnddyeing的UI模块
--@date		2016/08/17
--@author	zsq
--@note		染色


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function Wnddyeing:onEnter(element)
	self.m_root = element
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
end

--@brief	加载动画
function Wnddyeing:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndBag:regAll()
	self.m_root:setVisible(true)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)

    AdaptLanguage(self)
end

--@brief    弹窗动画完成后的回调
function Wnddyeing:actionCallback(element, data)
	self:initDressGrid()
	self:update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function Wnddyeing:onExit(element)
	self:_unInit()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
end

--@brief	关闭按钮点击回调
function Wnddyeing:onClose(element)
    WZLog("Wnddyeing:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	Wndwardrobe:showPlayer()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	初始化时装格子
function Wnddyeing:initDressGrid()
	WZLog("Wnddyeing:initDressGrid")
	if self.m_root == nil then return end
	self.m_tDressGrid = {}
	local gridName = {"conHead","conBody"}
	self.m_nHeadIndex = 0
	self.m_nBodyIndex = 0
	GetElement(self.m_root,"colorHead",WZUILabelTTF):setText(LocalStrings.BAGTIP18)
	GetElement(self.m_root,"colorBody",WZUILabelTTF):setText(LocalStrings.BAGTIP18)
	for i=1,2 do
		local con = self.m_root:getChildElement(gridName[i])
		if con ~= nil then
		   local celElement,tLuaObj = CellGoodItem:createElement()
			if celElement ~= nil and tLuaObj ~= nil then
    	    	tLuaObj:setItemClickFun(Wnddyeing,Wnddyeing.chooseDress)
				con:addChild(celElement)
            	celElement:setTag(i)
				tLuaObj:setSZBg()
				table.insert(self.m_tDressGrid,tLuaObj)
			end
		end
	end
end

--@brief	开始染色
function Wnddyeing:onSure(element)
	WZLog("Wnddyeing:onSure")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_tempElement = element
	--判断材料是否充足
	if not JudgeMoneyIsEnough(self.m_nCostId, self.m_nCost, nil, nil, nWindowId, nil, nil, nil, nil, self, self.clickSureMoney) then 
		return 
	end

	self:clickSureMoney()
end

--@brief	点击确定充值回调
function Wnddyeing:clickSureMoney()
    local itemId = WZLuaVector_int_:create()
    local color = WZLuaVector_int_:create()
	if self.m_tDress[1] ~= nil and self.m_tDress[1].color ~= self.m_nHeadIndex then
		itemId:push(self.m_tDress[1].playerItemId)
		color:push(self.m_nHeadIndex)
	end
	if self.m_tDress[2] ~= nil and self.m_tDress[2].color ~= self.m_nBodyIndex then
		itemId:push(self.m_tDress[2].playerItemId)
		color:push(self.m_nBodyIndex)
	end
	WZLog("Wnddyeing:onSure1",Serialize(VectorToTable(itemId)),Serialize(VectorToTable(color)))
	ProtocolProcessorWndBag:send_PLAYER_ChangeColour(itemId, color)
	if self.m_tempElement then 
		self.m_tempElement:setTouchEnable(false)
	end
end

--@brief	更换装备动画
function Wnddyeing:ranseAni()
	--新动画
	local spine = GetElement(self.m_root,"ranseAni",WZUISpine)
	spine:setVisible(true)
	spine:play("1",false)	
end

--@brief	染色头 
function Wnddyeing:onAddHead()
	WZLog("Wnddyeing:onAddHead")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tDress[1] == nil then
		local dressList = CacheCenter:getDecorationList()
		for i=1,#dressList do
			if dressList[i].basicInfo.sub_type == 0 and dressList[i].isUse == true then
				MsgBoxManager:showTipBox(LocalStrings.BAGTIP44)
				return 
			end
		end
		MsgBoxManager:showTipBox(LocalStrings.BAGTIP24)
	else
		local head = self.m_tDress[1].basicInfo.animation_index_code
		local colorNum = 3
		for k,v in pairs(GDatatab_fashion_colour) do
			if v.item_id == self.m_tDress[1].basicInfo.id then
				colorNum = #v.colour[1]
			end
		end
		self.m_nHeadIndex = self.m_nHeadIndex + 1
		self.m_nHeadIndex = self.m_nHeadIndex % colorNum
		self.conPlayer:setHead(head,self.m_nHeadIndex)
		if self.m_nHeadIndex == 0 then
			GetElement(self.m_root,"colorHead",WZUILabelTTF):setText(LocalStrings.BAGTIP18)
		else
			GetElement(self.m_root,"colorHead",WZUILabelTTF):setText(LocalStrings.BAGTIP25..self.m_nHeadIndex)
		end
		--当前
		if self.m_nHeadIndex == self.m_tDress[1].color then
			local txt = GetElement(self.m_root,"colorHead",WZUILabelTTF):getText()	
			GetElement(self.m_root,"colorHead",WZUILabelTTF):setText(txt.."("..LocalStrings.LIMITE_BUY_CURPRICE..")")
		end
	end
	self:updateBtn()
	self:updateCost()
end

--@brief	染色头 
function Wnddyeing:onReduceHead()
	WZLog("Wnddyeing:onReduceHead")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tDress[1] == nil then
		local dressList = CacheCenter:getDecorationList()
		for i=1,#dressList do
			if dressList[i].basicInfo.sub_type == 0 and dressList[i].isUse == true then
				MsgBoxManager:showTipBox(LocalStrings.BAGTIP44)
				return 
			end
		end
		MsgBoxManager:showTipBox(LocalStrings.BAGTIP24)
	else
		local head = self.m_tDress[1].basicInfo.animation_index_code
		local colorNum = 3 
		for k,v in pairs(GDatatab_fashion_colour) do
			if v.item_id == self.m_tDress[1].basicInfo.id then
				colorNum = #v.colour[1]
			end
		end
		self.m_nHeadIndex = self.m_nHeadIndex - 1
		self.m_nHeadIndex = self.m_nHeadIndex % colorNum
		self.conPlayer:setHead(head,self.m_nHeadIndex)
		if self.m_nHeadIndex == 0 then
			GetElement(self.m_root,"colorHead",WZUILabelTTF):setText(LocalStrings.BAGTIP18)
		else
			GetElement(self.m_root,"colorHead",WZUILabelTTF):setText(LocalStrings.BAGTIP25..self.m_nHeadIndex)
		end
		--当前
		if self.m_nHeadIndex == self.m_tDress[1].color then
			local txt = GetElement(self.m_root,"colorHead",WZUILabelTTF):getText()	
			GetElement(self.m_root,"colorHead",WZUILabelTTF):setText(txt.."("..LocalStrings.LIMITE_BUY_CURPRICE..")")
		end
	end
	self:updateBtn()
	self:updateCost()
end

--@brief	染色衣服 
function Wnddyeing:onAddBody()
	WZLog("Wnddyeing:onAddBody")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tDress[2] == nil then
		local dressList = CacheCenter:getDecorationList()
		for i=1,#dressList do
			if dressList[i].basicInfo.sub_type == 2 and dressList[i].isUse == true then
				MsgBoxManager:showTipBox(LocalStrings.BAGTIP44)
				return 
			end
		end
		MsgBoxManager:showTipBox(LocalStrings.BAGTIP24)
	else
		local body = self.m_tDress[2].basicInfo.animation_index_code
		local colorNum = 3
		for k,v in pairs(GDatatab_fashion_colour) do
			if v.item_id == self.m_tDress[2].basicInfo.id then
				colorNum = #v.colour[1]
			end
		end
		self.m_nBodyIndex = self.m_nBodyIndex + 1
		self.m_nBodyIndex = self.m_nBodyIndex % colorNum
		self.conPlayer:setBody(body)
		self.conPlayer:setBodyRanSe(self.m_nBodyIndex)
		if self.m_nBodyIndex == 0 then
			GetElement(self.m_root,"colorBody",WZUILabelTTF):setText(LocalStrings.BAGTIP18)
		else
			GetElement(self.m_root,"colorBody",WZUILabelTTF):setText(LocalStrings.BAGTIP25..self.m_nBodyIndex)
		end
		--当前
		if self.m_nBodyIndex == self.m_tDress[2].color then
			local txt = GetElement(self.m_root,"colorBody",WZUILabelTTF):getText()	
			GetElement(self.m_root,"colorBody",WZUILabelTTF):setText(txt.."("..LocalStrings.LIMITE_BUY_CURPRICE..")")
		end
	end
	self:updateBtn()
	self:updateCost()
end

--@brief	染色衣服 
function Wnddyeing:onReduceBody()
	WZLog("Wnddyeing:onReduceBody")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tDress[2] == nil then
		local dressList = CacheCenter:getDecorationList()
		for i=1,#dressList do
			if dressList[i].basicInfo.sub_type == 2 and dressList[i].isUse == true then
				MsgBoxManager:showTipBox(LocalStrings.BAGTIP44)
				return 
			end
		end
		MsgBoxManager:showTipBox(LocalStrings.BAGTIP24)
	else
		local body = self.m_tDress[2].basicInfo.animation_index_code
		local colorNum = 3 
		for k,v in pairs(GDatatab_fashion_colour) do
			if v.item_id == self.m_tDress[2].basicInfo.id then
				colorNum = #v.colour[1]
			end
		end
		self.m_nBodyIndex = self.m_nBodyIndex - 1
		self.m_nBodyIndex = self.m_nBodyIndex % colorNum
		self.conPlayer:setBody(body)
		self.conPlayer:setBodyRanSe(self.m_nBodyIndex)
		if self.m_nBodyIndex == 0 then
			GetElement(self.m_root,"colorBody",WZUILabelTTF):setText(LocalStrings.BAGTIP18)
		else
			GetElement(self.m_root,"colorBody",WZUILabelTTF):setText(LocalStrings.BAGTIP25..self.m_nBodyIndex)
		end
		--当前
		if self.m_nBodyIndex == self.m_tDress[2].color then
			local txt = GetElement(self.m_root,"colorBody",WZUILabelTTF):getText()	
			GetElement(self.m_root,"colorBody",WZUILabelTTF):setText(txt.."("..LocalStrings.LIMITE_BUY_CURPRICE..")")
		end
	end
	self:updateBtn()
	self:updateCost()
end

--@brief	更新染色消耗
function Wnddyeing:updateCost()
	local itemId
	local cost = 0
	local tIndex = {"m_nHeadIndex","m_nBodyIndex"}
	for i=1,2 do
		for k,v in pairs(GDatatab_fashion_colour) do
			if self.m_tDress[i] ~= nil and self.m_tDress[i].basicInfo.id == v.item_id 
				and self[tIndex[i]] ~= self.m_tDress[i].color then
				itemId = v.cost[1][1]
				cost = cost + v.cost[1][2]
			end
		end
	end
	if itemId == nil then itemId = GDatatab_fashion_colour["id_1"].cost[1][1] end
	GetElement(self.m_root,"imgCost",WZUIImage):setFile(GDatatab_item["id_"..itemId].icon)
	GetElement(self.m_root,"cost",WZUILabelTTF):setText(cost)
	GetElement(self.m_root,"has",WZUILabelTTF):setText(string.format(LocalStrings.PETHASNUM, CacheCenter:getPlayerItemCountById(itemId)))
	self.m_nCost = cost
	self.m_nCostId = itemId
end

--@brief	更新按钮状态
function Wnddyeing:updateBtn()
	WZLog("Wnddyeing:updateBtn",self.m_tDress[1] == nil,self.m_tDress[2] == nil)
	if self.m_tDress[1] == nil and self.m_tDress[2] == nil then
		GetElement(self.m_root,"btnSure",WZUIButton):setTouchEnable(false)
		return
	end
	if self.m_tDress[1] == nil and self.m_tDress[2] ~= nil then
		if self.m_nBodyIndex == self.m_tDress[2].color then
			GetElement(self.m_root,"btnSure",WZUIButton):setTouchEnable(false)
		else
			GetElement(self.m_root,"btnSure",WZUIButton):setTouchEnable(true)
		end
		return
	end
	if self.m_tDress[1] ~= nil and self.m_tDress[2] == nil then
		if self.m_nHeadIndex == self.m_tDress[1].color then
			GetElement(self.m_root,"btnSure",WZUIButton):setTouchEnable(false)
		else
			GetElement(self.m_root,"btnSure",WZUIButton):setTouchEnable(true)
		end
		return
	end
	if self.m_tDress[1] ~= nil and self.m_tDress[2] ~= nil then
		if self.m_nHeadIndex == self.m_tDress[1].color and self.m_nBodyIndex == self.m_tDress[2].color then
			GetElement(self.m_root,"btnSure",WZUIButton):setTouchEnable(false)
		else
			GetElement(self.m_root,"btnSure",WZUIButton):setTouchEnable(true)
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function Wnddyeing:update()
	self:showPlayer()
	self:updateDressGrid()
	self:updateCost()
	self:updateBtn()
end

--@brief	显示人物形象
function Wnddyeing:showPlayer()
	WZLog("Wnddyeing:showPlayer")
	if self.m_root == nil then return end
	--删除旧人物
	if self.conPlayer ~= nil then 
		self.conPlayer:getAnimNode():removeFromParentAndCleanup(true) 
		self.conPlayer = nil
	end
	local tEquip = CacheCenter:getEquipmentList()
	local playInfo = CacheCenter:getPlayerInfo()
	local sex = playInfo.sex
    local conP = WZUIContainer:luaTo(self.m_root:getChildElement("conRole"))
    if not self.conPlayer then
		local conPlayer
		local headColor = 0
		local bodyColor = 0
		for i=1,#tEquip do
			if tEquip[i].basicInfo.main_type == 5 and tEquip[i].basicInfo.sub_type == 0 and tEquip[i].isUse == true then
				headColor = tEquip[i].color
			end
			if tEquip[i].basicInfo.main_type == 5 and tEquip[i].basicInfo.sub_type == 2 and tEquip[i].isUse == true then
				bodyColor = tEquip[i].color
			end
		end
       	--conPlayer = CreatePlayerFigure(sex, tEquip, "wait0")
       	conPlayer = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil, nil, nil, nil, nil, nil, headColor, bodyColor, false)
		conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.54,0.15))
		conPlayer:setScale(0.92)
        self.conPlayer = conPlayer
        conP:addChild(conPlayer:getAnimNode(),5)
    end
end

--@brief	时装是否在配置表中
function Wnddyeing:dressInConfig(id)
	for k,v in pairs(GDatatab_fashion_colour) do
		if v.item_id == id then
			return true
		end
	end
	return false
end

--@brief	更新时装格子
function Wnddyeing:updateDressGrid()
	if self.m_root == nil then return end
	if self.m_tDressGrid == nil then return end
	if CacheCenter:getPlayerInfo() == nil then return end
	local dressType = {[1]=0,[2]=2}
	local equipmentList = CacheCenter:getEquipmentList()
	local imgList = {"ui/bag/common_icon_toubu.png","ui/bag/common_icon_fuzhaung.png"}
	if CacheCenter:getPlayerInfo().sex == 0 then
		imgList = {"ui/bag/common_icon_toubu2.png","ui/bag/common_icon_fuzhaung2.png"}
	end	

	self.m_tDress = {}
	for i=1,2 do
		local set = false
    	local txt = GetElement(self.m_root, "dressTxt"..i, WZUIImage)
		for j=1,#equipmentList do
			if equipmentList[j].maintype == 5 and equipmentList[j].subtype == dressType[i] 
					and self:dressInConfig(equipmentList[j].basicInfo.id) then
   				self.m_tDressGrid[i]:setCellGoodItem(equipmentList[j],14)
    			GetElement(self.m_tDressGrid[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
				txt:setVisible(false)
				set = true
				self.m_tDress[i] = equipmentList[j]
				if i == 1 then self.m_nHeadIndex = equipmentList[j].color elseif i == 2 then self.m_nBodyIndex = equipmentList[j].color end
			end
		end
		if set == false then
			self.m_tDressGrid[i]:removeAllChild()
			self.m_tDressGrid[i]:setSZBg()
			txt:setVisible(true)
			txt:setFile(imgList[i])
			txt:setTouchEnable(false)
		end
	end

		if self.m_nHeadIndex == 0 then
			GetElement(self.m_root,"colorHead",WZUILabelTTF):setText(LocalStrings.BAGTIP18.."("..LocalStrings.LIMITE_BUY_CURPRICE..")")
		else
			GetElement(self.m_root,"colorHead",WZUILabelTTF):setText(LocalStrings.BAGTIP25..self.m_nHeadIndex.."("..LocalStrings.LIMITE_BUY_CURPRICE..")")
		end

		if self.m_nBodyIndex == 0 then
			GetElement(self.m_root,"colorBody",WZUILabelTTF):setText(LocalStrings.BAGTIP18.."("..LocalStrings.LIMITE_BUY_CURPRICE..")")
		else
			GetElement(self.m_root,"colorBody",WZUILabelTTF):setText(LocalStrings.BAGTIP25..self.m_nBodyIndex.."("..LocalStrings.LIMITE_BUY_CURPRICE..")")
		end

		local dressList = CacheCenter:getDecorationList()
		--没有可染色时装显示不可染色
		if self.m_tDress[1] == nil then
			for i=1,#dressList do
				if dressList[i].basicInfo.sub_type == 0 and dressList[i].isUse == true then
					self.m_tDressGrid[1]:setCellGoodItem(dressList[i],14)
   					GetElement(self.m_root, "dressTxt1", WZUIImage):setVisible(false)
					break
				end
			end
			GetElement(self.m_root,"colorHead",WZUILabelTTF):setText(LocalStrings.BAGTIP45)
			if ProjConfig.LANGUAGE == "vn" then
				GetElement(self.m_root,"colorHead",WZUILabelTTF):setFontSize(16)
			end
		end
		if self.m_tDress[2] == nil then
			for i=1,#dressList do
				if dressList[i].basicInfo.sub_type == 2 and dressList[i].isUse == true then
					self.m_tDressGrid[2]:setCellGoodItem(dressList[i],14)
   					GetElement(self.m_root, "dressTxt2", WZUIImage):setVisible(false)
					break
				end
			end
			GetElement(self.m_root,"colorBody",WZUILabelTTF):setText(LocalStrings.BAGTIP45)
			if ProjConfig.LANGUAGE == "vn" then
				GetElement(self.m_root,"colorBody",WZUILabelTTF):setFontSize(16)
			end
		end
end

--@brief	选择染色时装
function Wnddyeing:chooseDress(tCell, tag, tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local con = GetElement(self.m_root,"tableCon_Wnddyeing",WZUITableContainer)
	con:cleanTable()

	local dressList = CacheCenter:getDecorationList()
	local index = 0
	local maxFight = 0
	local maxCell 
	local typeList = {0,2}
	for i=1,#dressList do
		if dressList[i].basicInfo.sub_type == typeList[tag]
			and self:dressInConfig(dressList[i].basicInfo.id)
			and dressList[i].floorPrice == nil and dressList[i].lastTime ~= 0 then
			cellElement,tCell = CellDress:createElement()
			cellElement:setTag(index)
			con:setCellElement(cellElement)
			tCell:update(dressList[i],1)
			if dressList[i].extraInfo.fighting > maxFight then
				maxFight = dressList[i].extraInfo.fighting
				maxCell = tCell
			end
			index = index + 1
		end
	end
	if maxCell ~= nil then
		maxCell.m_tData.maxFight = true
	end

	--没有当前部位时装，弹出提示
	if index == 0 then
        MsgBoxManager:showConfirmBox(LocalStrings.BAGTIP39, self, self.jumpTab, nil, nil)
	else
		GetElement(self.m_root,"con1",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"con2",WZUIContainer):setVisible(true)
	end
end

--@brief	跳转到对应标签
function Wnddyeing:jumpTab()
	WZLog("Wnddyeing:jumpTab")
	self:onClose()
end

--@brief	选择时装完成
function Wnddyeing:finishChoose(tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"con1",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"con2",WZUIContainer):setVisible(false)

	local index 
	if tData.basicInfo.sub_type == 0 then index = 1 elseif tData.basicInfo.sub_type == 2 then index = 2 end

   	GetElement(self.m_root, "dressTxt"..index, WZUIImage):setVisible(false)
	self.m_tDress[index] = tData
 	self.m_tDressGrid[index]:setCellGoodItem(tData, 14)
   	GetElement(self.m_tDressGrid[index].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")

	if index == 1 then
		self.conPlayer:setHead(tData.basicInfo.animation_index_code, tData.color)
		self.m_nHeadIndex = tData.color
		if self.m_nHeadIndex == 0 then
			GetElement(self.m_root,"colorHead",WZUILabelTTF):setText(LocalStrings.BAGTIP18.."("..LocalStrings.LIMITE_BUY_CURPRICE..")")
		else
			GetElement(self.m_root,"colorHead",WZUILabelTTF):setText(LocalStrings.BAGTIP25..self.m_nHeadIndex.."("..LocalStrings.LIMITE_BUY_CURPRICE..")")
		end
	elseif index == 2 then
		self.conPlayer:setBody(tData.basicInfo.animation_index_code)
		self.conPlayer:setBodyRanSe(tData.color)
		self.m_nBodyIndex = tData.color
		if self.m_nBodyIndex == 0 then
			GetElement(self.m_root,"colorBody",WZUILabelTTF):setText(LocalStrings.BAGTIP18.."("..LocalStrings.LIMITE_BUY_CURPRICE..")")
		else
			GetElement(self.m_root,"colorBody",WZUILabelTTF):setText(LocalStrings.BAGTIP25..self.m_nBodyIndex.."("..LocalStrings.LIMITE_BUY_CURPRICE..")")
		end
	end
	self.conPlayer:play("wait0", true)
	self:updateBtn()
	self:updateCost()
end

--@brief	染色成功
function Wnddyeing:onFinish()
	WZLog("Wnddyeing:onFinish")
    SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)
	--设置当前颜色
	if self.m_tDress[1] ~= nil and self.m_tDress[1].color ~= self.m_nHeadIndex then
		self.m_tDress[1].color = self.m_nHeadIndex
		local txt = GetElement(self.m_root,"colorHead",WZUILabelTTF):getText()	
		GetElement(self.m_root,"colorHead",WZUILabelTTF):setText(txt.."("..LocalStrings.LIMITE_BUY_CURPRICE..")")
	end
	if self.m_tDress[2] ~= nil and self.m_tDress[2].color ~= self.m_nBodyIndex then
		self.m_tDress[2].color = self.m_nBodyIndex
		local txt = GetElement(self.m_root,"colorBody",WZUILabelTTF):getText()	
		GetElement(self.m_root,"colorBody",WZUILabelTTF):setText(txt.."("..LocalStrings.LIMITE_BUY_CURPRICE..")")
	end

	self:ranseAni()
end
-------------------------------------私有方法模块End----------------------------------------
--@brief	角色形象点击响应
function Wnddyeing:onClickRole(element)
	WZLog("Wnddyeing:onClickRole")
	if self.conPlayer == nil then return end
	local random = os.time()%2 + 1
	if random == 1 then
		self.conPlayer:play("run",false)
    	self.m_root:enableSchedule("updateRole")
	elseif random == 2 then
		self.conPlayer:play("win",false)
    	self.m_root:enableSchedule("updateRole")
	end
end

--@brief	角色形象动画完成回调
function Wnddyeing:updateRole(element,t)
    if not self.conPlayer:isPlaying() then
        local isEnd = self.conPlayer:isCurrentAnimationDone()
        if isEnd == true then
			self.conPlayer:play("wait0",true)
            self.m_root:disableSchedule()
        end
    end
end

-------------------------------------------语言适配Begin-----------------------
function Wnddyeing:_adaptLanguage_en()
	local colorH = GetElement(self.m_root,"colorHead",WZUILabelTTF)
	colorH:setFontSize(16)
	colorH:setDimensions(GlobalMethod:CCSize(150,0))
	local colorB = GetElement(self.m_root,"colorBody",WZUILabelTTF)
	colorB:setFontSize(16)
	colorB:setDimensions(GlobalMethod:CCSize(150,0))

    local txtCost = GetElement(self.m_root,"txtCost_Wnddyeing",WZUILabelTTF)
    txtCost:setRelativePosition(GlobalMethod:ccp(0.0579487,0.588333))

    local txtNotice = GetElement(self.m_root,"txtNotice_Wnddyeing",WZUILabelTTF)
	txtNotice:setDimensions(GlobalMethod:CCSize(420))

	GetElement(self.m_root,"has",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.62,0.595))
	local imgCost = GetElement(self.m_root,"imgCost",WZUIImage)
	imgCost:setRelativePosition(GlobalMethod:ccp(0.5,0.595))
	local cost = GetElement(self.m_root,"cost",WZUILabelTTF)
	cost:setRelativePosition(GlobalMethod:ccp(0.535,0.595))
end

function Wnddyeing:_adaptLanguage_vn(  )
	GetElement(self.m_root,"imgCost",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.64,0.588333))
	GetElement(self.m_root,"cost",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.69,0.588333))
	GetElement(self.m_root,"has",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.78,0.595))
	for i=1,3 do
		GetElement(self.m_root,"txtSure"..i.."_Wnddyeing",WZUILabelTTF):setScale(0.8)
	end
	local txtNotice = GetElement(self.m_root,"txtNotice_Wnddyeing",WZUILabelTTF)
	txtNotice:setDimensions(GlobalMethod:CCSize(400,0))
end

function Wnddyeing:_adaptLanguage_pt(  )
	local colorH = GetElement(self.m_root,"colorHead",WZUILabelTTF)
	colorH:setFontSize(16)
	colorH:setDimensions(GlobalMethod:CCSize(150,0))
	local colorB = GetElement(self.m_root,"colorBody",WZUILabelTTF)
	colorB:setFontSize(16)
	colorB:setDimensions(GlobalMethod:CCSize(150,0))
	local txtCost = GetElement(self.m_root,"txtCost_Wnddyeing",WZUILabelTTF)
	txtCost:setScale(0.78)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.06,0.588333))

	local txtNotice = GetElement(self.m_root,"txtNotice_Wnddyeing",WZUILabelTTF)
	txtNotice:setDimensions(GlobalMethod:CCSize(420))
end

function Wnddyeing:_adaptLanguage_tr(  )
	local txtCost = GetElement(self.m_root,"txtCost_Wnddyeing",WZUILabelTTF)
	txtCost:setScale(0.8)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.1,0.588333))
	local imgCost = GetElement(self.m_root,"imgCost",WZUIImage)
	imgCost:setRelativePosition(GlobalMethod:ccp(0.5,0.595))
	local cost = GetElement(self.m_root,"cost",WZUILabelTTF)
	cost:setRelativePosition(GlobalMethod:ccp(0.535,0.595))

	local colorH = GetElement(self.m_root,"colorHead",WZUILabelTTF)
	colorH:setFontSize(16)
	colorH:setDimensions(GlobalMethod:CCSize(150,0))
	local colorB = GetElement(self.m_root,"colorBody",WZUILabelTTF)
	colorB:setFontSize(16)
	colorB:setDimensions(GlobalMethod:CCSize(150,0))

	local txtNotice = GetElement(self.m_root,"txtNotice_Wnddyeing",WZUILabelTTF)
	txtNotice:setDimensions(GlobalMethod:CCSize(420))

	for i=1,3 do
		local txtSure = GetElement(self.m_root,"txtSure"..i.."_Wnddyeing",WZUILabelTTF)
		txtSure:setScale(0.8)
		txtSure:setDimensions(GlobalMethod:CCSize(120,0))
	end

	GetElement(self.m_root,"has",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.62,0.595))
end

function Wnddyeing:_adaptLanguage_th(  )
	local txtNotice = GetElement(self.m_root,"txtNotice_Wnddyeing",WZUILabelTTF)
	txtNotice:setRelativePosition(GlobalMethod:ccp(-0.03,0.885))
end

function Wnddyeing:_adaptLanguage_es(  )
	local colorH = GetElement(self.m_root,"colorHead",WZUILabelTTF)
	colorH:setFontSize(16)
	colorH:setDimensions(GlobalMethod:CCSize(150,0))
	local colorB = GetElement(self.m_root,"colorBody",WZUILabelTTF)
	colorB:setFontSize(16)
	colorB:setDimensions(GlobalMethod:CCSize(150,0))
	local txtCost = GetElement(self.m_root,"txtCost_Wnddyeing",WZUILabelTTF)
	txtCost:setScale(0.7)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.06,0.635))

	local txtNotice = GetElement(self.m_root,"txtNotice_Wnddyeing",WZUILabelTTF)
	txtNotice:setDimensions(GlobalMethod:CCSize(460))
end
-----------------------------------语言适配End-----------------------------------------