--WndDressList.lua
--@brief	WndDressList的UI模块
--@date		2015/07/02
--@author	zsq
--@note		背包时装列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDressList:onEnter(element)
	self.m_root = element
end

function WndDressList:onEnterTransitionDidFinish(element)
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	self:_setUIStaticText()
	self.m_nCurrentIndex = 2
	self:updateDress()

	if CacheCenter:hasExpiredDress() and GlobalGame.g_ClickedDress ~= true then
		GetElement(self.m_root,"red_WndDressList",WZUIImage):setVisible(true)
		GetElement(self.m_root,"btnBag_WndDressList",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnExpired_WndDressList",WZUIButton):setVisible(false)
		GetElement(self.m_root,"conCheckBox",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"checkBox",WZUICheckBoxGroup):setVisible(false)
		self.m_nBackTag = self.m_nCurrentIndex
		self:onTab6()
	else
		GetElement(self.m_root,"red_WndDressList",WZUIImage):setVisible(false)
	end
	--语言适配
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDressList:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
end

--@brief	点击全部标签
function WndDressList:onTab1()
	WZLog("WndDressList:onTab1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurrentIndex == 1 then return end
	self.m_nCurrentIndex = 1
	self:updateDress()
end

--@brief	点击头部标签
function WndDressList:onTab2()
	WZLog("WndDressList:onTab2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurrentIndex == 2 then return end
	self.m_nCurrentIndex = 2
	self:updateDress()
end

--@brief	点击表情标签
function WndDressList:onTab3()
	WZLog("WndDressList:onTab3")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurrentIndex == 3 then return end
	self.m_nCurrentIndex = 3
	self:updateDress()
end

--@brief	点击服装标签
function WndDressList:onTab4()
	WZLog("WndDressList:onTab4")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurrentIndex == 4 then return end
	self.m_nCurrentIndex = 4
	self:updateDress()
end

--@brief	点击翅膀标签
function WndDressList:onTab5()
	WZLog("WndDressList:onTab5")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurrentIndex == 5 then return end
	self.m_nCurrentIndex = 5
	self:updateDress()
end

--@brief	点击过期时装标签
function WndDressList:onTab6()
	WZLog("WndDressList:onTab6")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurrentIndex == 6 then return end
	self.m_nCurrentIndex = 6
	self:updateDress()
	GlobalGame.g_ClickedDress = true
	GetElement(self.m_root,"red_WndDressList",WZUIImage):setVisible(false)
	if WndBagMain.m_root ~= nil then
		GetElement(WndBagMain.m_root,"red1_WndDressList",WZUIImage):setVisible(false)
	end
end

--@brief	点击头像框标签
function WndDressList:onTab7()
	WZLog("WndDressList:onTab6")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurrentIndex == 7 then return end
	self.m_nCurrentIndex = 7
	self:updateDress()
end

--@brief	续费按钮点击
function WndDressList:onRenew(data)
	WZLog("WndDressList:onRenew",data.basicInfo.name)
   	WndPurchase:showBuyInterface(data.maintype,data,self,self.onRenewCallBack)
end

function WndDressList:onRenewCallBack()
	WZLog("WndDressList:onRenewCallBack")
	self:updateDressAttr()
end

--@brief	穿戴按钮点击
function WndDressList:onDress(tData)
	WZLog("WndDressList:onDress",tData.basicInfo.name)
	if WndItemInfo.m_root ~= nil then return end

	WndBag:onItemClick(2,tData)

	self:updateDress()
end

--@brief	过期时装
function WndDressList:onExpired(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"btnBag_WndDressList",WZUIButton):setVisible(true)
	GetElement(self.m_root,"btnExpired_WndDressList",WZUIButton):setVisible(false)
	GetElement(self.m_root,"conCheckBox",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"checkBox",WZUICheckBoxGroup):setVisible(false)
	self.m_nBackTag = self.m_nCurrentIndex
	self:onTab6()
end

--@brief	时装背包
function WndDressList:onBag(element)
	WZLog("WndDressList:onBag")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"btnBag_WndDressList",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnExpired_WndDressList",WZUIButton):setVisible(true)
	GetElement(self.m_root,"conCheckBox",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"checkBox",WZUICheckBoxGroup):setVisible(true)
	if self.m_nBackTag == nil then self.m_nBackTag = 2 end
	WZLog("WndDressList:onBag1", self.m_nBackTag)
	self["onTab"..self.m_nBackTag](self)
end

--@brief	时装染色
function WndDressList:onDyeing()
	WZLog("WndDressList:onDyeing")
	if WndItemInfo.m_root ~= nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local wnd = Wnddyeing:createElement()
    WindowManager:addWindow(wnd,Wnddyeing,false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新时装栏
function WndDressList:updateDress()
	self:onDisableSchedule(GetElement(self.m_root,"tableCon_WndDressList",WZUITableContainer))
	--当前部位数量
	local s = {"",LocalStrings.BAGTIP31,LocalStrings.BAGTIP32,LocalStrings.BAGTIP33,LocalStrings.BAGTIP34,"",LocalStrings.HEAD_EFFECT2}
	GetElement(self.m_root,"ttf1",WZUILabelTTF):setText(s[self.m_nCurrentIndex])
	local num = 0
	if self.m_nCurrentIndex == 7 then 
		local tempList = CacheCenter:getPlayerOwnHeadEffect()
		num = #tempList
	else
		local tempList = CacheCenter:getDecorationList()
		for k,v in pairs(tempList) do
			if v.subtype == (self.m_nCurrentIndex-2) and v.lastTime ~= 0 then
				num = num + 1
			end
		end
	end
	GetElement(self.m_root,"ttf2",WZUILabelTTF):setText(num)
	--当前部位附加属性
	GetElement(self.m_root,"ttf4",WZUILabelTTF):setText("0")
	for k,v in pairs(GDatatab_shizhuang) do
		if (v.buwei + 2) == self.m_nCurrentIndex then
			GetElement(self.m_root,"ttf3",WZUILabelTTF):setText(ATTR_TITLE[v.shuxing[1][1]]..":")
			if num == v.number then
				GetElement(self.m_root,"ttf4",WZUILabelTTF):setText(v.shuxing[1][2])
			end
		end
	end
	if self.m_nCurrentIndex == 6 then 
		GetElement(self.m_root,"ttf2",WZUILabelTTF):setText("")
		GetElement(self.m_root,"ttf3",WZUILabelTTF):setText("")
		GetElement(self.m_root,"ttf4",WZUILabelTTF):setText("")
	elseif self.m_nCurrentIndex == 7 then 
		GetElement(self.m_root,"ttf3",WZUILabelTTF):setText("")
		GetElement(self.m_root,"ttf4",WZUILabelTTF):setText("")
	end
	--设置标签字体颜色
	for i=2,6 do
		GetElement(self.m_root,"imgTab"..i.."_WndDressList",WZUI9Image):setVisible(false)
	end
	if self.m_nCurrentIndex == 7 then 
    	GetElement(self.m_root, "checkBox", WZUICheckBoxGroup):setCheckIndex(self.m_nCurrentIndex-3)
		GetElement(self.m_root,"imgTab6_WndDressList",WZUI9Image):setVisible(true)
    else
    	GetElement(self.m_root, "checkBox", WZUICheckBoxGroup):setCheckIndex(self.m_nCurrentIndex-2)
		GetElement(self.m_root,"imgTab"..self.m_nCurrentIndex.."_WndDressList",WZUI9Image):setVisible(true)
    end

	for i=2,6 do
		GetElement(self.m_root,"txtTab"..i.."_WndDressList",WZUILabelTTF):setEnableStroke(false)
		GetElement(self.m_root,"txtTab"..i.."_WndDressList",WZUILabelTTF):setColor(GlobalMethod:ccc3(127,70,26))
	end
	if self.m_nCurrentIndex == 7 then 
		GetElement(self.m_root,"txtTab6_WndDressList",WZUILabelTTF):setEnableStroke(true)
		GetElement(self.m_root,"txtTab6_WndDressList",WZUILabelTTF):setStrokeColor(GlobalMethod:ccc3(132,66,29))
		GetElement(self.m_root,"txtTab6_WndDressList",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,236,193))
	else
		GetElement(self.m_root,"txtTab"..self.m_nCurrentIndex.."_WndDressList",WZUILabelTTF):setEnableStroke(true)
		GetElement(self.m_root,"txtTab"..self.m_nCurrentIndex.."_WndDressList",WZUILabelTTF):setStrokeColor(GlobalMethod:ccc3(132,66,29))
		GetElement(self.m_root,"txtTab"..self.m_nCurrentIndex.."_WndDressList",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,236,193))
	end

	--时装列表及背景图大小
	local con = GetElement(self.m_root,"tableCon_WndDressList",WZUITableContainer)
	con:setLoadCountPerFrame(3)
	--con:setContentSize(GlobalMethod:CCSize(380,352))
	--con:setCellElementHeight(0.275)
	--GetElement(self.m_root,"imgBg11_WndDressList",WZUI9Image):setScaleY(0.85)
	--con:setContentSize(GlobalMethod:CCSize(380,410))
	--con:setCellElementHeight(0.235)

	local node = GetElement(self.m_root,"conBtn_WndDressList",WZUIContainer)
	node:enableSchedule("updateDress2",0)
end

--@brief	更新时装栏
function WndDressList:updateDress2(element, tt)
	element:disableSchedule()
	self.m_nMaxFight = nil

	if self.m_root == nil then return end
	local tempList = {}
	self.m_tTempList = tempList
	local dressType = {[1]=0,[2]=0,[3]=1,[4]=2,[5]=3,[6]=3}
	local equipmentList = CacheCenter:getDecorationList()
	if self.m_nCurrentIndex == 1 then
		for i=1,#equipmentList do
			if equipmentList[i].lastTime ~= 0 then
				equipmentList[i].showType = 1
				table.insert(tempList,equipmentList[i])
			end
		end
	elseif self.m_nCurrentIndex == 6 then
		for i=1,#equipmentList do
			if equipmentList[i].lastTime == 0 then
				equipmentList[i].showType = 1
				table.insert(tempList,equipmentList[i])
			end
		end
	elseif self.m_nCurrentIndex == 7 then
		self.m_tTempList = CacheCenter:getPlayerOwnHeadEffect()
	else
		self.m_nMaxFight = 0
		for i=1,#equipmentList do
			if equipmentList[i].subtype == dressType[self.m_nCurrentIndex] 
				and equipmentList[i].lastTime ~= 0 then
				equipmentList[i].showType = 1
				table.insert(tempList,equipmentList[i])
			end
		end
	end

	table.sort(tempList , sortDressList)
	self.m_tDataList = tempList

	--初始化时装格子列表
	if self.m_tDressList == nil then self.m_tDressList = {} end

	--时装格子索引
	local ownDressIdList = {}

	--记录已经拥有的时装id
	for i=1,#tempList do
		ownDressIdList[tempList[i].basicInfo.id] = true
	end

	--头部、表情、服装、翅膀显示商城时装
	if self.m_nCurrentIndex == 1 then
        WZLog("WndDressList:updateDress two")
		CacheCenter:getShopItems(function(t,shopItemList) 
			local dataList = shopItemList

			if dataList ~= nil then
				for i=1,#dataList do
					if dataList[i].basicInfo.main_type == 5 and dataList[i].isOnSale == true 
						and dataList[i].mainType ~= [[{"5":"1"}]]
						and (dataList[i].basicInfo.sex == CacheCenter:getPlayerInfo().sex or dataList[i].basicInfo.sex == 2)  
						and ownDressIdList[dataList[i].basicInfo.id] ~= true then
						dataList[i].showType = 2
						table.insert(tempList,dataList[i])
					end
				end
			end
		end)
	elseif self.m_nCurrentIndex == 6 then
	elseif self.m_nCurrentIndex == 7 then
		self:showHeadEffectList()
		return 
	else
        WZLog("WndDressList:updateDress two")
		CacheCenter:getShopItems(function(t,shopItemList) 
			local dataList = shopItemList

			if dataList ~= nil then
				for i=1,#dataList do
					if dataList[i].basicInfo.main_type == 5 and dataList[i].isOnSale == true 
						and dataList[i].mainType ~= [[{"5":"1"}]]
						and dataList[i].basicInfo.sub_type == dressType[self.m_nCurrentIndex] 
						and (dataList[i].basicInfo.sex == CacheCenter:getPlayerInfo().sex or dataList[i].basicInfo.sex == 2)  
						and ownDressIdList[dataList[i].basicInfo.id] ~= true then
						dataList[i].showType = 2
						table.insert(tempList,dataList[i])
					end
				end
			end
		end)
	end

	self.m_nStartIndex = 1
	self.m_root:enableSchedule("_addDressCell",0)
end

--@brief	每帧加载时装Cell
function WndDressList:_addDressCell()
--	WZLog("WndDressList:_addDressCell")

	local con = GetElement(self.m_root,"tableCon_WndDressList",WZUITableContainer)
	con:setVisible(true)
	GetElement(self.m_root,"tableCon2_WndDressList",WZUITableContainer):setVisible(false)

	local endIndex = math.min(self.m_nStartIndex+2,#self.m_tTempList)
--	WZLog("WndDressList:_addDressCell two", self.m_nStartIndex, endIndex)
	for i=self.m_nStartIndex,endIndex do
		local cellElement,tCell
		if self.m_tDressList[i] ~= nil then
			--之前有创建时装格子
			self.m_tDressList[i]:updateCell(self.m_tTempList[i],self.m_tTempList[i].showType)
			self.m_tDressList[i]:setFight(false)
			tCell = self.m_tDressList[i]
		else
			cellElement,tCell = CellDress:createElement()
			cellElement:setTag(i-1)
			cellElement:setScale(0.9)
			con:setCellElement(cellElement)
			tCell:update(self.m_tTempList[i],self.m_tTempList[i].showType)
			tCell:onRenewCallBack(self,self.onRenew)
			tCell:onDressCallBack(self,self.onDress)
			self.m_tDressList[i] = tCell
			self.m_tDressList[i]:setFight(false)
		end
		if self.m_nCurrentIndex == 6 then
			self.m_tDressList[i]:setRenew()
		end
		--记录试穿格子
		if WndDressList.m_tTryWearList ~= nil then 
			for k,v in pairs(WndDressList.m_tTryWearList) do
				if self.m_tTempList[i].basicInfo.id == v then
	   				WndDressList.m_tTryWearGrid = tCell
				end
			end
		end
		self.m_nStartIndex = self.m_nStartIndex + 1
		--保存最大战力格子
		if self.m_nMaxFight ~= nil and self.m_tTempList[i].extraInfo ~= nil and 
				self.m_tTempList[i].extraInfo.fighting > self.m_nMaxFight then
			self.m_nMaxFight = self.m_tTempList[i].extraInfo.fighting
			self.m_tMaxFightGrid = tCell
		end
	end
	--加载完成，结束计时器
	if self.m_nStartIndex > #self.m_tTempList then
		self:onDisableSchedule(con)
		if self.m_tMaxFightGrid ~= nil and self.m_nCurrentIndex ~= 6 then
			self.m_tMaxFightGrid:setFight(true)
		end
	end
end

--@brief	时装加载完成后的处理
function WndDressList:onDisableSchedule(con)
	self.m_root:disableSchedule()
	if self.m_nDressNum == nil or self.m_tTempList == nil or self.m_tDressList == nil then return end

	--删除之前创建的多余的格子
	if self.m_nDressNum > (#self.m_tTempList) then
		for i=(#self.m_tTempList),(self.m_nDressNum-1) do
			con:removeCellElement(i)
			self.m_tDressList[i+1] = nil
		end
	end
	self.m_nDressNum = #self.m_tTempList

 	local moveElement = con:getMoveElement()
   	con:UpdateInsidePosition()
 	--moveElement:setPositionY(con:getMinPosition().y)
end

--@brief	设置控件静态文本
function WndDressList:_setUIStaticText()
	local textList = {LocalStrings.CHAT_ALL,LocalStrings.HEAD,LocalStrings.WNDDRESS1,LocalStrings.CLOTHES,LocalStrings.WING,LocalStrings.HEAD_EFFECT}
	for i=2,6 do
		GetElement(self.m_root,"txtTab"..i.."_WndDressList",WZUILabelTTF):setText(textList[i])
	end
end

--@brief  装扮列表排序函数
function sortDressList(a,b)
	local x = WndDressList:_getMaxSort(a.isUse)--穿上
	local y = WndDressList:_getMaxSort(b.isUse)--穿上
	if x ~= y then--是否装备
		return x >= y
	elseif a.basicInfo.quality~=b.basicInfo.quality then--品质排序
		return a.basicInfo.quality >= b.basicInfo.quality
	elseif a.basicInfo.sub_type ~= b.basicInfo.sub_type then--子类型
		return a.basicInfo.sub_type <= b.basicInfo.sub_type
	elseif a.lastTime ~= b.lastTime then 
		return a.lastTime >= b.lastTime
	else 
		return a.id > b.id
	end
end

--@brief  获取两个值的最大
function WndDressList:_getMaxSort(x)
	if x == true then return 1 else return 0 end
end

--@brief 	显示头像框列表
function WndDressList:showHeadEffectList()
	GetElement(self.m_root, "tableCon_WndDressList", WZUITableContainer):setVisible(false)
	local tableCon2 = GetElement(self.m_root, "tableCon2_WndDressList", WZUITableContainer)
	tableCon2:cleanTable()
	tableCon2:setVisible(true)

	for i = 1, #self.m_tTempList do
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			celElement:setTag(i - 1)
			tCell:setCellGoodItem(self.m_tTempList[i], 2)
			tCell:setItemClickFun(self, self.onItemClick)

			tableCon2:setCellElement(celElement)
		end
	end
end

--@brief 	点击物品回调
function WndDressList:onItemClick(tCell,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,nil,nil,true)	
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Began------------------------------------------
function WndDressList:_adaptLanguage_vn(  )
	for i=2,6 do
		GetElement(self.m_root,"txtTab".. i .."_WndDressList",WZUILabelTTF):setScale(0.85)
	end
	for i=1,4 do
		GetElement(self.m_root,"ttf".. i,WZUILabelTTF):setScale(0.8)
	end

	local ttfBatch = GetElement(self.m_root,"ttfBatch_WndDressList",WZUILabelTTF)
	ttfBatch:setScale(0.65)

	local txtBag = GetElement(self.m_root,"txtBag_WndDressList",WZUILabelTTF)
	-- txtBag:setDimensions(GlobalMethod:CCSize(100,0))
	txtBag:setScale(0.65)

	local txtExpired = GetElement(self.m_root,"txtExpired_WndDressList",WZUILabelTTF)
	-- txtExpired:setDimensions(GlobalMethod:CCSize(100,0))
	txtExpired:setScale(0.65)
end

function WndDressList:_adaptLanguage_th(  )
	--GetElement(self.m_root,"txtTab6_WndDressList",WZUILabelTTF):setFontSize(22)
	local ttf1 = GetElement(self.m_root,"ttf1",WZUILabelTTF)
	ttf1:setFontSize(16)
	local txtExpired = GetElement(self.m_root,"txtExpired_WndDressList",WZUILabelTTF)
	txtExpired:setScale(0.8)

	GetElement(self.m_root,"txtExpired_WndDressList",WZUILabelTTF):setScale(0.7)
end

function WndDressList:_adaptLanguage_en()
	WZLog("WndDressList:_adaptLanguage_en")
	local ttfBatch = GetElement(self.m_root,"ttfBatch_WndDressList",WZUILabelTTF)
	ttfBatch:setDimensions(GlobalMethod:CCSize(110,0))
	ttfBatch:setScale(0.8)

	local txtBag = GetElement(self.m_root,"txtBag_WndDressList",WZUILabelTTF)
	txtBag:setDimensions(GlobalMethod:CCSize(100,0))
	txtBag:setScale(0.8)

	local txtExpired = GetElement(self.m_root,"txtExpired_WndDressList",WZUILabelTTF)
	txtExpired:setDimensions(GlobalMethod:CCSize(100,0))
	txtExpired:setScale(0.8)
	GetElement(self.m_root,"txtTab6_WndDressList",WZUILabelTTF):setFontSize(24)
end


function WndDressList:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtTab6_WndDressList",WZUILabelTTF):setFontSize(24)
	GetElement(self.m_root,"txtTab2_WndDressList",WZUILabelTTF):setFontSize(24)
	local ttfBatch = GetElement(self.m_root,"ttfBatch_WndDressList",WZUILabelTTF)
	ttfBatch:setDimensions(GlobalMethod:CCSize(110,0))
	ttfBatch:setScale(0.8)

	local txtBag = GetElement(self.m_root,"txtBag_WndDressList",WZUILabelTTF)
	txtBag:setDimensions(GlobalMethod:CCSize(110,0))
	txtBag:setScale(0.8)

	local txtExpired = GetElement(self.m_root,"txtExpired_WndDressList",WZUILabelTTF)
	txtExpired:setDimensions(GlobalMethod:CCSize(100,0))
	txtExpired:setScale(0.8)
end

function WndDressList:_adaptLanguage_tr(  )
	local txtTab6 = GetElement(self.m_root,"txtTab6_WndDressList",WZUILabelTTF)
	txtTab6:setFontSize(20)
	txtTab6:setDimensions(GlobalMethod:CCSize(100,0))

	local txtExpired = GetElement(self.m_root,"txtExpired_WndDressList",WZUILabelTTF)
	txtExpired:setScale(0.8)

	local ttfBatch = GetElement(self.m_root,"ttfBatch_WndDressList",WZUILabelTTF)
	ttfBatch:setScale(0.8)

	local ttf1 = GetElement(self.m_root,"ttf1",WZUILabelTTF)
	ttf1:setScale(0.8)
	--ttf1:setRelativePosition(GlobalMethod:ccp(0.05,0.86))

	local txtBag = GetElement(self.m_root,"txtBag_WndDressList",WZUILabelTTF)
	txtBag:setScale(0.8)
end

function WndDressList:_adaptLanguage_es(  )
	local ttfBatch = GetElement(self.m_root,"ttfBatch_WndDressList",WZUILabelTTF)
	ttfBatch:setDimensions(GlobalMethod:CCSize(110,0))
	ttfBatch:setScale(0.8)

	local txtBag = GetElement(self.m_root,"txtBag_WndDressList",WZUILabelTTF)
	txtBag:setDimensions(GlobalMethod:CCSize(110,0))
	txtBag:setScale(0.8)

	local txtExpired = GetElement(self.m_root,"txtExpired_WndDressList",WZUILabelTTF)
	txtExpired:setDimensions(GlobalMethod:CCSize(100,0))
	txtExpired:setScale(0.8)

	for i=1,4 do
		GetElement(self.m_root,"ttf".. i,WZUILabelTTF):setScale(0.8)
	end

	local ttf1 = GetElement(self.m_root,"ttf1",WZUILabelTTF)
	ttf1:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	ttf1:setAlignment(kCCTextAlignmentLeft)
	ttf1:setRelativePosition(GlobalMethod:ccp(0.05,0.86))
end

function WndDressList:_adaptLanguage_ug(  )
	local ttfBatch = GetElement(self.m_root,"ttfBatch_WndDressList",WZUILabelTTF)
	ttfBatch:setScale(0.7)
	local txtBag = GetElement(self.m_root,"txtBag_WndDressList",WZUILabelTTF)
	txtBag:setScale(0.7)
	local txtExpired = GetElement(self.m_root,"txtExpired_WndDressList",WZUILabelTTF)
	txtExpired:setDimensions(GlobalMethod:CCSize(200,0))
	txtExpired:setScale(0.6)

	for i=2,5 do
		local txtTab = GetElement(self.m_root,"txtTab"..i.."_WndDressList",WZUILabelTTF)
		txtTab:setScale(0.6)
		txtTab:setDimensions(GlobalMethod:CCSize(120))
	end

	local ttf1 = GetElement(self.m_root,"ttf1",WZUILabelTTF)
	ttf1:setScale(0.7)
	ttf1:setDimensions(GlobalMethod:CCSize(180))
	ttf1:setRelativePosition(GlobalMethod:ccp(0.5,0.86))
	local ttf2 = GetElement(self.m_root,"ttf2",WZUILabelTTF)
	ttf2:setScale(0.7)
	ttf2:setRelativePosition(GlobalMethod:ccp(0.1,0.86))
	local ttf3 = GetElement(self.m_root,"ttf3",WZUILabelTTF)
	ttf3:setScale(0.7)
	ttf3:setDimensions(GlobalMethod:CCSize(140))
	ttf3:setRelativePosition(GlobalMethod:ccp(0.94,0.86))
	local ttf4 = GetElement(self.m_root,"ttf4",WZUILabelTTF)
	ttf4:setScale(0.7)
	ttf4:setRelativePosition(GlobalMethod:ccp(0.66,0.86))
end
-------------------------------------语言适配End--------------------------------------------

