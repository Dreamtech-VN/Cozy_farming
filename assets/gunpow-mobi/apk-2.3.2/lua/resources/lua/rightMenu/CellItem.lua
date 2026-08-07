--CellItem.lua
--@brief	CellItem的UI模块
--@date		2017/06/26
--@author	 
--@note		 


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellItem:onEnter(element)
	self.m_root = element
	self.m_sCellItem = nil
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellItem:onExit(element)
	self:_unInit()
	self.m_sCellItem = nil
end

function CellItem:setData(data, index, status)
	self.m_tData = data
	self.m_nCurIndex = index
	self.m_nCurStatus = status
end
--@brief  加载数据
function CellItem:onLoadData(element)
	if self.m_tData then
		local celElement,tCell = CellGoodItem:createElement()
		tCell:setItemClickFun(self,self.onTips)
		self.m_sCellItem = tCell

		local cellData = {}
		if self.m_tData.pokedex[1][1] == 3 then --时装类型
			cellData.basicInfo = self.m_tData
			if self.m_tData.lastTime ~= nil then
				cellData.lastTime = self.m_tData.lastTime
			end
			tCell:setCellGoodItem(cellData,13)
		else
			cellData.basicInfo = self.m_tData
			tCell:setCellGoodItem(cellData,4)
		end
		local id,num
		if self.m_nCurIndex and self.m_nCurIndex >= 5 and self.m_nCurIndex <= 7 then
			id = self.m_tData.pokedex[1][1]
			num = self.m_tData.pokedex[1][2]
		else
			id = self.m_tData.pokedex[1][4]
			num = self.m_tData.pokedex[1][5]
		end
		local txtRichReward = GetElement(self.m_root,"txtRichReward",WZUIFreeTextBox)
		if id and num then
			local itemInfo = GDatatab_item["id_" ..id]
			txtRichReward:setShowText(string.format([[<I Z="0.35">%s</I><T C="127,70,26" S="18" P="1">%d</T>]],itemInfo.icon,num))
		end
		if self.m_tData.owned then
			self:setCellItem()
			txtRichReward:setVisible(false)
		end

		self:setCanGetStatus(self.m_nCurStatus)
		self.m_root:addChild(celElement)
	end
end
--可领取
function CellItem:setCanGetStatus(status)
	if self.m_sCellItem then
		GetElement(self.m_root,"btnGetReward",WZUIButton):setVisible(status == 1)
		if status == 1 then
			self.m_sCellItem:setProtomeSelect("ui/common/common_00.png", ccp(0.5,0.5), ccp(0.5, 0.5),nil,true)
		end
	end
end
--领取之后的变化
function CellItem:setCellItem()
	if self.m_sCellItem then
		self.m_sCellItem:_addSidebarOwn()
		self.m_sCellItem:setRemoveProtomeSelect()
		if self.m_root then
			GetElement(self.m_root,"txtRichReward",WZUIFreeTextBox):setVisible(false)
			GetElement(self.m_root,"btnGetReward",WZUIButton):setVisible(false)
		end
	end
end

--领取
function CellItem:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local rId = nil
	if type(self.m_tData) == "number" then
		rId = self.m_tData
	else
		rId = self.m_tData.id
	end
	ProtocolProcessorRecycling:send_PLAYERITEM_ReceivePokedexReward(rId)
end
function CellItem:onTips(tCell,tag,tData)
	WZLog("CellItem:onTips ")
	local data = tData
	data.tBtnList = {LocalStrings.GET_ACCESS}
	--时装去掉获取途径
	local is_getChannel = true
	if self.m_nCurIndex and (self.m_nCurIndex == 3 or self.m_nCurIndex == 4) then
		is_getChannel = false
	end
	WndItemInfo:showInfo(self.m_root,WndLibrary.m_root,1,data,is_getChannel,nil,true)
	WndItemInfo:setClickButtonCallback(self,self.onClickGetItem)
end

function CellItem:onClickGetItem(element)
	-- body
	WZLog("CellItem:onClickGetItem")
	local id = nil
	if type(self.m_tData) == "number" then
		id = self.m_tData
	else
		id = self.m_tData.id
	end
	WndFastGetItems:show(id)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
