--WndSellRune.lua
--@brief	WndSellRune的UI模块
--@date		2017/03/24
--@author	peiting_mao
--@note		批量出售符文


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSellRune:onEnter(element)
	self.m_root = element
	--ProtocolProcessorSceneRune:regAll()
	WZLog("WndSellRune:onEnter")
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSellRune:onExit(element)
	self:_unInit()
	--ProtocolProcessorSceneRune:unregAll()
end

function WndSellRune:showWindow(itemIds,itemNums,isUseds)
	if self.m_root == nil then
		WZLog("WndSellRune:showWindow")
		local wnd = WndSellRune:createElement()
		WindowManager:addWindow(wnd,WndSellRune,nil,nil,nil,true)
		self.itemIds = itemIds
		self.itemNums = itemNums
		self.isUseds = isUseds
		self:_initRuneItem()
	else
		return
	end
end

--@brief 	重新计算售出总价
function WndSellRune:reCaculateGain()
	-- body
	self:_price()
	GetElement(self.m_root,"txtPrice_WndSellRune",WZUILabelTTF):setText(self.price)
end

--@brief	将拥有的符文进行等级分类
function WndSellRune:_initRuneItem(  )
	local num
	GetElement(self.m_root,"txtPrice_WndSellRune",WZUILabelTTF):setText(0)
	if self.itemIds ~= nil then
		for i=1,#self.itemIds do
			local itemInfo = CopyTable(GDatatab_item["id_"..self.itemIds[i]])

			if itemInfo.value == 1 then
				num = self.itemNums[i] - self.isUseds[i]
				if num > 0 then
					itemInfo.runeNum = num
					itemInfo.bChoose = true
					table.insert(self.firstRune,itemInfo)
				end
			elseif itemInfo.value == 2 then
				num = self.itemNums[i] - self.isUseds[i]
				if num > 0 then
					itemInfo.runeNum = num
					itemInfo.bChoose = true
					table.insert(self.secondRune,itemInfo)
				end
			elseif itemInfo.value == 3 then
				num = self.itemNums[i] - self.isUseds[i]
				if num > 0 then
					itemInfo.runeNum = num
					itemInfo.bChoose = true
					table.insert(self.thirdRune,itemInfo)
				end
			elseif itemInfo.value == 4 then
				num = self.itemNums[i] - self.isUseds[i]
				if num > 0 then
					itemInfo.runeNum = num
					itemInfo.bChoose = true
					table.insert(self.fourRune,itemInfo)
				end
			elseif itemInfo.value == 5 then
				num = self.itemNums[i] - self.isUseds[i]
				if num > 0 then
					itemInfo.runeNum = num
					itemInfo.bChoose = true
					table.insert(self.fiveRune, itemInfo)
				end
			end
		end
	end

	WZLog("WndSellRune:_initRuneItem", Serialize(self.fiveRune), Serialize(self.fourRune))
end

function WndSellRune:onClose( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root,self,true)
	--ProtocolProcessorSceneRune:send_RUNE_GetRuneList( )
end

--@brief	选中符文事件
function WndSellRune:onClick( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local tag = element:getTag()
	local num = 0
	if #self.tag > 0 then
		for i=1,#self.tag do
			if self.tag[i] == tag then --判断之前是否选中过
				GetElement(self.m_root,"txtTips"..tag.."_WndSellRune",WZUILabelTTF):setVisible(true)
				GetElement(self.m_root,"imgSel"..tag.."_WndSellRune",WZUI9Image):setVisible(false)
				GetElement(self.m_root,"btnSellDes"..tag.."_WndSellRune",WZUIButton):setVisible(false)
				table.remove(self.tag,i)
				break
			else
				num = num + 1
			end
			if num == #self.tag then --之前没有被选中过
				GetElement(self.m_root,"txtTips"..tag.."_WndSellRune",WZUILabelTTF):setVisible(false)
				GetElement(self.m_root,"imgSel"..tag.."_WndSellRune",WZUI9Image):setVisible(true)
				GetElement(self.m_root,"btnSellDes"..tag.."_WndSellRune",WZUIButton):setVisible(true)
				table.insert(self.tag,tag)
			end
		end
	else
		GetElement(self.m_root,"txtTips"..tag.."_WndSellRune",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"imgSel"..tag.."_WndSellRune",WZUI9Image):setVisible(true)
		GetElement(self.m_root,"btnSellDes"..tag.."_WndSellRune",WZUIButton):setVisible(true)
		table.insert(self.tag,tag)
	end

	self:reCaculateGain()
end

function WndSellRune:_price()
	self.price = 0
	if #self.tag > 0 then
		for k = 1, #self.tag do
			if self.tag[k] == 1 then
				for i=1,#self.firstRune do
					if self.firstRune[i].bChoose == true then
						self.price = self.price + self.firstRune[i].recycleMess[1][2]*self.firstRune[i].runeNum
					end
				end
			elseif self.tag[k] == 2 then
				for i=1,#self.secondRune do
					if self.secondRune[i].bChoose == true then
						self.price = self.price + self.secondRune[i].recycleMess[1][2]*self.secondRune[i].runeNum
					end
				end
			elseif self.tag[k] == 3 then
				for i=1,#self.thirdRune do
					if self.thirdRune[i].bChoose == true then
						self.price = self.price + self.thirdRune[i].recycleMess[1][2]*self.thirdRune[i].runeNum
					end
				end
			elseif self.tag[k] == 4 then
				for i=1,#self.fourRune do
					if self.fourRune[i].bChoose == true then
						self.price = self.price + self.fourRune[i].recycleMess[1][2]*self.fourRune[i].runeNum
					end
				end
			elseif self.tag[k] == 5 then
				for i=1,#self.fiveRune do
					if self.fiveRune[i].bChoose == true then
						self.price = self.price + self.fiveRune[i].recycleMess[1][2]*self.fiveRune[i].runeNum
					end
				end
			end
		end
	end
end

--@brief	出售详情事件
function WndSellRune:onSellDes( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local tag = element:getTag()
	if tag == 1 then
		WndSellDes:showWindow(self.firstRune, tag)
	elseif tag == 2 then
		WndSellDes:showWindow(self.secondRune, tag)
	elseif tag == 3 then
		WndSellDes:showWindow(self.thirdRune, tag)
	elseif tag == 4 then
		WndSellDes:showWindow(self.fourRune, tag)
	elseif tag == 5 then
		WndSellDes:showWindow(self.fiveRune, tag)
	end
end

--@brief 	出售点击事件
function WndSellRune:onSell( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local id = WZLuaVector_int_:create()
	local num = WZLuaVector_int_:create()
	local cout = 0
	local nFiveLevelNum = 0 
	if #self.tag <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.RUNEBOOK9)
	else
		for i=1,#self.tag do
			if self.tag[i] == 1 then
				for i=1,#self.firstRune do
					if self.firstRune[i].bChoose == true then
						id:push(self.firstRune[i].id)
						num:push(self.firstRune[i].runeNum)
						cout = cout + 1
					end
				end
			elseif self.tag[i] == 2 then
				for i=1,#self.secondRune do
					if self.secondRune[i].bChoose == true then
						id:push(self.secondRune[i].id)
						num:push(self.secondRune[i].runeNum)
						cout = cout + 1
					end
				end
			elseif self.tag[i] == 3 then
				for i=1,#self.thirdRune do
					if self.thirdRune[i].bChoose == true then
						id:push(self.thirdRune[i].id)
						num:push(self.thirdRune[i].runeNum)
						cout = cout + 1
					end
				end
			elseif self.tag[i] == 4 then
				for i=1,#self.fourRune do
					if self.fourRune[i].bChoose == true then
						id:push(self.fourRune[i].id)
						num:push(self.fourRune[i].runeNum)
						cout = cout + 1
					end
				end
			elseif self.tag[i] == 5 then
				for i = 1, #self.fiveRune do
					if self.fiveRune[i].bChoose == true then
						id:push(self.fiveRune[i].id)
						num:push(self.fiveRune[i].runeNum)
						cout = cout + 1
						nFiveLevelNum = nFiveLevelNum + 1
					end
				end
			end
		end
		if cout > 0 then
			if nFiveLevelNum > 0 then
				MsgBoxManager:showConfirmBox(string.format(LocalStrings.RUNEBOOK20, nFiveLevelNum), self, self.sureToSell)
			else
				ProtocolProcessorSceneRune:send_RUNE_SellRune(id, num)
			end
		else
			MsgBoxManager:showTipBox(LocalStrings.RUNEBOOK17)
		end
	end
end

--@brief 	确认出售5级的符文
function WndSellRune:sureToSell()
	local id = WZLuaVector_int_:create()
	local num = WZLuaVector_int_:create()
	for i=1,#self.tag do
		if self.tag[i] == 1 then
			for i=1,#self.firstRune do
				if self.firstRune[i].bChoose == true then
					id:push(self.firstRune[i].id)
					num:push(self.firstRune[i].runeNum)
				end
			end
		elseif self.tag[i] == 2 then
			for i=1,#self.secondRune do
				if self.secondRune[i].bChoose == true then
					id:push(self.secondRune[i].id)
					num:push(self.secondRune[i].runeNum)
				end
			end
		elseif self.tag[i] == 3 then
			for i=1,#self.thirdRune do
				if self.thirdRune[i].bChoose == true then
					id:push(self.thirdRune[i].id)
					num:push(self.thirdRune[i].runeNum)
				end
			end
		elseif self.tag[i] == 4 then
			for i=1,#self.fourRune do
				if self.fourRune[i].bChoose == true then
					id:push(self.fourRune[i].id)
					num:push(self.fourRune[i].runeNum)
				end
			end
		elseif self.tag[i] == 5 then
			for i = 1, #self.fiveRune do
				if self.fiveRune[i].bChoose == true then
					id:push(self.fiveRune[i].id)
					num:push(self.fiveRune[i].runeNum)
				end
			end
		end
	end
	WZLog("WndSellRune:sureToSell")
	ProtocolProcessorSceneRune:send_RUNE_SellRune(id, num)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndSellRune:_adaptLanguage_pt(  )
	for i=1,5 do
		local txtRuneLv = GetElement(self.m_root,"txtRuneLv"..i.."_WndSellRune",WZUILabelTTF)
		txtRuneLv:setDimensions(GlobalMethod:CCSize(160,0))
		txtRuneLv:setScale(0.7)
		local txtSellDesc = GetElement(self.m_root,"txtSellDes"..i.."_WndSellRune",WZUILabelTTF)
		txtSellDesc:setDimensions(GlobalMethod:CCSize(100,0))
		txtSellDesc:setScale(0.6)
	end
end

function WndSellRune:_adaptLanguage_es(  )
	for i=1,5 do
		local txtRuneLv = GetElement(self.m_root,"txtRuneLv"..i.."_WndSellRune",WZUILabelTTF)
		txtRuneLv:setDimensions(GlobalMethod:CCSize(160,0))
		txtRuneLv:setScale(0.7)
		local txtSellDesc = GetElement(self.m_root,"txtSellDes"..i.."_WndSellRune",WZUILabelTTF)
		txtSellDesc:setDimensions(GlobalMethod:CCSize(100,0))
		txtSellDesc:setScale(0.6)
	end
end

function WndSellRune:_adaptLanguage_en(  )
	for i=1,5 do
		local txtRuneLv = GetElement(self.m_root,"txtRuneLv"..i.."_WndSellRune",WZUILabelTTF)
		txtRuneLv:setDimensions(GlobalMethod:CCSize(160,0))
		txtRuneLv:setScale(0.7)
	end
end

function WndSellRune:_adaptLanguage_tr(  )
	for i=1,5 do
		local txtRuneLv = GetElement(self.m_root,"txtRuneLv"..i.."_WndSellRune",WZUILabelTTF)
		txtRuneLv:setDimensions(GlobalMethod:CCSize(130,0))
		txtRuneLv:setFontSize(18)
		
		local txtSellDesc = GetElement(self.m_root,"txtSellDes"..i.."_WndSellRune",WZUILabelTTF)
		txtSellDesc:setDimensions(GlobalMethod:CCSize(100,0))
		txtSellDesc:setScale(0.6)
	end
end

function WndSellRune:_adaptLanguage_vn(  )
	for i=1,5 do
		local txtRuneLv = GetElement(self.m_root,"txtRuneLv"..i.."_WndSellRune",WZUILabelTTF)
		txtRuneLv:setScale(0.8)
	end
end
-------------------------------------语言适配End--------------------------------------------