--WndPlayer.lua
--@brief	WndPlayer的UI模块
--@date		2014/01/07
--@author	zsq
--@note		玩家物品项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPlayer:onEnter(element)
	WZLog("WndPlayer:onEnter")
	self.m_root = element
end

function WndPlayer:onEnterTransitionDidFinish(element)
	GetElement(self.m_root,"onEquipAttr",WZUIButton):setVisible(true)
	if Wndwardrobe.m_root ~= nil then
		GetElement(self.m_root,"con1_WndPlayer",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"con2_WndPlayer",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"t1",WZUIButton):setVisible(false)
		GetElement(self.m_root,"t2",WZUIButton):setVisible(false)
		GetElement(self.m_root,"t3",WZUIButton):setVisible(false)
		GetElement(self.m_root,"conRoleEquip_WndPlayer",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"onEquipAttr",WZUIButton):setVisible(false)
	end

	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物

	local node = GetElement(self.m_root,"conRoleEquip_WndPlayer",WZUIContainer)
	node:enableSchedule("onEnterFinish",0)
	AdaptLanguage(self)
end

--@brief	延迟一帧执行
function WndPlayer:onEnterFinish(element,t)
	WZLog("WndPlayer:onEnterFinish",self.m_bCheckOther)
	element:disableSchedule()

	self:initEquipGrid()
	self:initDressGrid()
	self:updateDressGrid()

	if WndCheckOther.m_root == nil then 
        self.m_bCheckOther = false
	else
		self.m_bCheckOther = true
	end

	self:setPlayerData(CacheCenter:getPlayerInfo())--玩家基本信息

   	GetElement(self.m_root, "conLevelInfo", WZUIContainer):setVisible(true)

	self:setPlayerBodyData(CacheCenter:getEquipmentList())
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPlayer:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	CacheCenter:unregisterUpatePlayerInfoObserver(self)
	self:_unInit()
end


--@brief	初始化6个装备格子
function WndPlayer:initEquipGrid()
	WZLog("WndPlayer:initEquipGrid")
	if self.equipGridList ~= nil and #self.equipGridList >= 6 then return end
	self.equipGridList = {}
	for i=1,8 do
		local con = self.m_root:getChildElement("conEquip"..i.."_WndPlayer")
		if con ~= nil then
		   local celElement,tLuaObj = CellGoodItem:createElement()
			if celElement ~= nil and tLuaObj ~= nil then
    	    	tLuaObj:setItemClickFun(self,self.onEquipBackFun)
				con:addChild(celElement)
            	celElement:setTag(i)
				table.insert(self.equipGridList,tLuaObj)
			end
		end
	end
end

--@brief	初始化4个时装格子
function WndPlayer:initDressGrid()
	WZLog("WndPlayer:initDressGrid")
	do return end
	if self.gridList ~= nil and #self.gridList > 0 then return end
	self.gridList = {}
	for i=1,4 do
		local con = self.m_root:getChildElement("conDressGrid"..i.."_WndPlayer")
		if con ~= nil then
		   local celElement,tLuaObj = CellGoodItem:createElement()
			if celElement ~= nil and tLuaObj ~= nil then
    	    	tLuaObj:setItemClickFun(self,self.onDressClicked)
				con:addChild(celElement)
            	celElement:setTag(i)
				tLuaObj:setSZBg()
				table.insert(self.gridList,tLuaObj)
			end
		end
	end
end

--@brief	更新4个时装格子
function WndPlayer:updateDressGrid()
	do return end
	if self.m_root == nil then return end
	if self.gridList == nil then return end
	local dressType = {[1]=0,[2]=1,[3]=2,[4]=3}
	local equipmentList = CacheCenter:getEquipmentList()
	local imgList = {"ui/bag/common_icon_toubu.png","ui/bag/common_icon_biaoqing.png","ui/bag/common_icon_fuzhaung.png","ui/bag/common_icon_chibang.png"}
	if CacheCenter:getPlayerInfo().sex == 0 then
		imgList = {"ui/bag/common_icon_toubu2.png","ui/bag/common_icon_biaoqing2.png","ui/bag/common_icon_fuzhaung2.png","ui/bag/common_icon_chibang.png"}
	end	

	for i=1,4 do
		local set = false
    	local txt = GetElement(self.m_root, "dressTxt"..i, WZUIImage)
		for j=1,#equipmentList do
			if equipmentList[j].maintype == 5 and equipmentList[j].subtype == dressType[i] then
   				self.gridList[i]:setCellGoodItem(equipmentList[j],14)
    			GetElement(self.gridList[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
				txt:setVisible(false)
				set = true
			end
		end
		if set == false then
			self.gridList[i]:removeAllChild()
			self.gridList[i]:setSZBg()
			txt:setVisible(true)
			txt:setFile(imgList[i])
			txt:setTouchEnable(false)
		end
	end
end

--@brief	查看其他玩家信息:初始化4个时装格子
function WndPlayer:initOtherGrid()
	WZLog("WndPlayer:initOtherGrid")
	do return end
	if WndCheckOther == nil then return end
	self.otherGridList = {}
	for i=1,4 do
		local con = self.m_root:getChildElement("conOtherGrid"..i.."_WndPlayer")
		if con ~= nil then
		   local celElement,tLuaObj = CellGoodItem:createElement()
			if celElement ~= nil and tLuaObj ~= nil then
    	    	tLuaObj:setItemClickFun(WndCheckOther,WndCheckOther.onDressClicked)
				con:addChild(celElement)
            	celElement:setTag(i)
				tLuaObj:setSZBg()
				table.insert(self.otherGridList,tLuaObj)
			end
		end
	end
end

--@brief	查看其他玩家信息:更新4个时装格子
function WndPlayer:updateOtherGrid(tData)
	do return end
	if self.m_root == nil then return end
	local dressType = {[1]=0,[2]=1,[3]=2,[4]=3}
	local equipmentList = tData
	local imgList = {"ui/bag/common_icon_toubu.png","ui/bag/common_icon_biaoqing.png","ui/bag/common_icon_fuzhaung.png","ui/bag/common_icon_chibang.png"}
	if self.m_tRole.sex == 0 then
		imgList = {"ui/bag/common_icon_toubu2.png","ui/bag/common_icon_biaoqing2.png","ui/bag/common_icon_fuzhaung2.png","ui/bag/common_icon_chibang.png"}
	end	

	for i=1,4 do
		local set = false
    	local txt = GetElement(self.m_root, "dressTxt"..(i+4), WZUIImage)
		for j=1,#equipmentList do
			if equipmentList[j].maintype == 5 and equipmentList[j].subtype == dressType[i] then
   				self.otherGridList[i]:setCellGoodItem(equipmentList[j],14)
    			GetElement(self.otherGridList[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
				txt:setVisible(false)
				set = true
			end
		end
		if set == false then
			self.otherGridList[i]:removeAllChild()
			self.otherGridList[i]:setSZBg()
			txt:setVisible(true)
			txt:setFile(imgList[i])
		end
	end
end

--@brief	点击vip等级显示tips
function WndPlayer:onVIP(element)
	WZLog("WndPlayer:onVIP")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then return end
	if WndBagMain.m_root == nil then return end
	local vipLevel = self.m_tRole.vipLevel
	local tData = {vipLevel=vipLevel,other=self.m_bCheckOther,id=self.m_tRole.id}
	local parent = WZUIContainer:luaTo(WndBagMain.m_root:getChildElement("conBg"))
	WndTips:show(GetElement(self.m_root,"conVip",WZUIContainer),self.m_root,20,tData,GlobalMethod:ccp(65,70))
end

function WndPlayer:onEquipAttr(element) 
	WZLog("WndPlayer:onEquipAttr")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--if self.m_bshuxing == true then
	--	self.m_bshuxing = false
	--	WndTips:_onCloseClick()
	--	return
	--end
	local parent = WZUIContainer:luaTo(WndBag.m_root:getChildElement("conLeftA_WndBag"))
	WndTips:show(element,parent,43,{},GlobalMethod:ccp(270,130))
	self.m_bshuxing = true
end

--@brief	角色形象点击响应
function WndPlayer:onClickRole(element)
	WZLog("WndPlayer:onClickRole")
	if self.m_tPlayerAni == nil then return end
	local random = os.time()%2 + 1
	WZLog("随机数是",random)
	if random == 1 then
		self.m_tPlayerAni:play("run",false)
    	self.m_root:enableSchedule("updateRole")
	elseif random == 2 then
		self.m_tPlayerAni:play("win",false)
    	self.m_root:enableSchedule("updateRole")
	elseif random == 3 then
		self.m_tPlayerAni:play("attackstart3-s2",false)
    	self.m_root:enableSchedule("updateRole1")
	end
end

--@brief	角色形象动画完成回调
function WndPlayer:updateRole(element,t)
    --WZLog("WndPlayer:updateRole")

    if not self.m_tPlayerAni:isPlaying() then
        local isEnd = self.m_tPlayerAni:isCurrentAnimationDone()
        if isEnd == true then
            WZLog("WndPlayer:updateRole two")
			self.m_tPlayerAni:play("wait0",true)
            self.m_root:disableSchedule()
        end
    end
end

--@brief	角色形象动画完成回调
function WndPlayer:updateRole1(element,t)
    WZLog("WndPlayer:updateRole1")

    if not self.m_tPlayerAni:isPlaying() then
        local isEnd = self.m_tPlayerAni:isCurrentAnimationDone()
        if isEnd == true then
			self.m_tPlayerAni:play("ttackstart2-s3",false)
            self.m_root:disableSchedule()
    		self.m_root:enableSchedule("updateRole2")
        end
    end
end


--@brief	角色形象动画完成回调
function WndPlayer:updateRole2(element,t)
    WZLog("WndPlayer:updateRole2")

    if not self.m_tPlayerAni:isPlaying() then
        local isEnd = self.m_tPlayerAni:isCurrentAnimationDone()
        if isEnd == true then
			self.m_tPlayerAni:play("attacks1-s",false)
            self.m_root:disableSchedule()
    		self.m_root:enableSchedule("updateRole")
        end
    end
end

--@brief	卸下时装回调
function WndPlayer:onUnderRoyal(wndItemInfo,tData)
	WZLog("WndPlayer:onUnderRoyal",Serialize(tData))
   	local id = WZLuaVector_int_:create()
	id:push(tData.playerItemId)
	ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(id)
end

--@brief	时装格子被点击函数
function WndPlayer:onDressClicked(tLuaObj,tag,tData)
	WZLog("WndPlayer:onDressClicked",tag)
	do return end
	if tData ~= nil and tData.basicInfo ~= nil then
    	local con2 = GetElement(self.m_root, "conDressGrid"..tag.."_WndPlayer", WZUIContainer)
    	local rightCon = GetElement(WndBag.m_root,"conRight_WndBag",WZUIContainer)
		local tOther = {interface = 1}
    	WndItemInfo:showInfo(tLuaObj.m_root,rightCon,1,tData,true,nil,nil,tOther)
		if tData.tBtnList ~= nil then
			self.m_tData = tData
    		WndItemInfo:setClickButtonCallback(self,self.cancelWear)
		end
	else
		local showWord = {LocalStrings.HEAD,LocalStrings.WNDDRESS1,LocalStrings.CLOTHES,LocalStrings.WING}
		local parent = WZUIContainer:luaTo(WndBag.m_root:getChildElement("conLeftA_WndBag"))
		WndItemInfo:showInfo(tLuaObj.m_root,parent,3,showWord[tag],false)
	end
end

--@brief	取消
function WndPlayer:cancelWear()
	WZLog("WndPlayer:cancelWear")
	do return end
	WndItemInfo:onCloseClick()
	--获得当前拥有的时装
	local equipmentList = CacheCenter:getEquipmentList()
	local animation_index_code
	local color = 0

	--取消格子
	if WndPlayer.m_root == nil then return end
	local i = self.m_tData.basicInfo.sub_type + 1
	local set = false
	local txt = GetElement(WndPlayer.m_root, "dressTxt"..i, WZUIImage)
	for j=1,#equipmentList do
		if equipmentList[j].maintype == 5 and equipmentList[j].subtype == self.m_tData.basicInfo.sub_type then
			WndPlayer.gridList[i]:setCellGoodItem(equipmentList[j],14)
			animation_index_code = equipmentList[j].basicInfo.animation_index_code
			color = equipmentList[j].color
			txt:setVisible(false)
			set = true
		end
	end
	if set == false then
		WndPlayer.gridList[i]:removeAllChild()
		WndPlayer.gridList[i]:setSZBg()
		txt:setVisible(true)
		--设置默认显示
		local gameParam = CacheCenter:getGameParam()
		if CacheCenter:getPlayerInfo().sex == 0 then
			if self.m_tData.basicInfo.sub_type == 0 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultManHeadId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 1 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultManFaceId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 2 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultManBodyId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 3 then
				animation_index_code = 0
			end
		else
			if self.m_tData.basicInfo.sub_type == 0 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultWomanHeadId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 1 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultWomanHeadId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 2 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultWomanHeadId].animation_index_code
			elseif self.m_tData.basicInfo.sub_type == 3 then
				animation_index_code = 0
			end
		end
	end

	--取消人物
	local conPlayer = WndPlayer.m_tPlayerAni
	if self.m_tData.basicInfo.sub_type == 0 then
		conPlayer:setHead(animation_index_code)
	elseif self.m_tData.basicInfo.sub_type == 1 then
		conPlayer:setFace(animation_index_code)
	elseif self.m_tData.basicInfo.sub_type == 2 then
		conPlayer:setBody(animation_index_code)
		conPlayer:setBodyRanSe(color)
	elseif self.m_tData.basicInfo.sub_type == 3 then
		conPlayer:setWing(animation_index_code)
	end
	conPlayer:play("wait0",true)
	--取消记录试穿的时装itemId
	if WndDressList.m_tTryWearList == nil then WndDressList.m_tTryWearList = {} end
	WndDressList.m_tTryWearList[self.m_tData.basicInfo.sub_type+1] = nil
end

--@brief	物品项点击回调
--@param	element:按钮绑定的UI节点引用
function WndPlayer:onCellClick(element)
	WZLog("WndPlayer:onCellClick")
	
end

--@brief	点击装备回调
function WndPlayer:onEquipBackFun(luaTable,tag,tData)
	WZLog("点击装备回调:",element,tag,tData)
	if self.m_tItemBack then
		self.m_tItemBack[3](self.m_tItemBack[1],0)
	end
	local parent = WZUIContainer:luaTo(WndBag.m_root:getChildElement("conLeftA_WndBag"))
	--更新背包显示物品类型
	if WndEquip.m_root ~= nil then
		local tagToSubtype = {1,3,2,4,5,6,7,8}
		local tagToId = {1,3,5,2,4,6,7,8}
		local sub_type = tagToSubtype[tag]
		WndEquip.allSub = sub_type
		if CacheCenter:getEquipAllList(sub_type) == nil or #CacheCenter:getEquipAllList(sub_type) == 0 then
			WndFastGetItems:show(7799+tagToId[tag])
		else
			WndEquip:onFinishLoad()
		end
	end

	if tData == nil then
		local pt = nil 
		if ProjConfig.LANGUAGE == "vn" then
			pt = GlobalMethod:ccp(0,20)
		end

		WndItemInfo:showInfo(luaTable.m_root,parent,3,self:_getEmptyItemDesc(tag),false,pt)
		return
	end
	self.m_tPlayer[tag].isUse = true
	local tItem = CopyTable(self.m_tPlayer[tag])
	WZLog("WndPlayer:onEquipBackFun:",CacheCenter:getPlayerInfo().id,self.m_tRole.id)
	if CacheCenter:getPlayerInfo().id == self.m_tRole.id then
		tItem.lock = 2
	else
		tItem.lock = 1
	end
	self:_addTip(tItem,luaTable.m_root,parent)--添加tip信息
end

--@brief	强化回调
function WndPlayer:onStrengthen(luaTable,tData)
	if luaTable and type(luaTable) == "table" then--打开强化研究院
		WndBag:onWearItemClick(5,-1)
	else--关闭强化研究院返回0:没变化
		WndBag:onWearItemClick(5,luaTable or 0)
	end
end

--@brief	过期按回调
function WndPlayer:onItemExpired(luaTable,tData)
	WZLog("续费按回调1",luaTable)
	WndPurchase:showBuyInterface(-1, tData.id, tData.icon, WndEquip, WndEquip.onRenewalFun1)
end

--@brief	使用回调
function WndPlayer:onItemApply(luaTable,tData)
	WZLog("使用回调",luaTable,tData.id)
	if tData.maintype == 10 and (tData.subtype == 12 or tData.subtype == 13) then
		ProtocolProcessorCellEquip:send_SPREE_GetGift(tData.id)
		return --如果是礼包就发协议使用
	end
	local element = WndEditBox:createElement()
	WndEditBox:setOkCallBack(self.onApplyRename, self)
	WndEditBox:setOtherData(tData)
	WndEditBox:setData(LocalStrings.INPUT_NEW_NAME, LocalStrings.CLICK_TO_INPUT_NAME)
	WindowManager:addWindow(element, WndEditBox)
end

--@brief	宠物触摸结束
function WndPlayer:onPetEnd()
	local petMessage = self.m_tRole.petMessage
	WZLog("宠物触摸结束:",petMessage)
	if petMessage ~= nil and petMessage ~= "" then
		if self.m_bCheckOther == true then
			petMessage = json.decode(self.m_tRole.petMessage)
			local conPet = WZUIWindow:luaTo(self.m_root:getChildElement("conPet_WndPlayer"))
			WndTips:show(conPet,WndCheckOther.m_root,13,petMessage,GlobalMethod:ccp(430,-10))
		else
			petMessage = json.decode(self.m_tRole.petMessage)
			local conPet = WZUIWindow:luaTo(self.m_root:getChildElement("conPet_WndPlayer"))
			local parent = WZUIContainer:luaTo(WndBag.m_root:getChildElement("conLeftA_WndBag"))
			WndTips:show(conPet,parent,13,petMessage,GlobalMethod:ccp(430,-10))
		end
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   更新人物标题信息栏和战斗力信息栏
function WndPlayer:_updateFire(tFire)
	WZLog("WndPlayer:_updateFire")
	if self.m_root == nil or tFire == nil then return end
	--设置vip等级
	GetElement(self.m_root,"labelVip_WndPlayer",WZUILabelAtlasFont):setText(self.m_tRole.vipLevel)
	if tonumber(self.m_tRole.vipLevel) >= 10 then
		GetElement(self.m_root,"imgVip_WndPlayer",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.33,0.2))
		GetElement(self.m_root,"labelVip_WndPlayer",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.6,0.2))
	else
		GetElement(self.m_root,"imgVip_WndPlayer",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.42,0.2))
		GetElement(self.m_root,"labelVip_WndPlayer",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.7,0.2))
	end

	--战斗力
	local fight = GetElement(self.m_root,"fight_WndPlayer",WZUILabelTTF)
	fight:setText(LocalStrings.COMBAT..":"..tFire.fighting)

	--设置等级名字经验进度条
	local nameTemplate = [[<T C="255,255,255" S="20" P="0" SC="79,60,48" SE="1" SS="4">%s</T><T C="128,54,13" S="22" P="0">(ID %s)</T>]]
	local name = GetElement(self.m_root,"name_WndPlayer",WZUIFreeTextBox)
	name:setShowText(string.format(nameTemplate, tFire.name, tostring(tFire.id)))
	local exp = tFire.exp
	local maxExp = tFire.maxExp
	local percent = tonumber(exp)*100/tonumber(maxExp)
	GetElement(self.m_root,"progrExpProgress_WndPlayer",WZUIProgress):setPercentage(percent)
	local txt = tostring(exp).."/"..tostring(maxExp)
	GetElement(self.m_root,"expPer_WndPlayer",WZUILabelTTF):setText(txt)

	local sTitleContent = tFire.title
	local conLevelInfo = GetElement(self.m_root, "conLevelInfo", WZUIContainer)
	local txtTitle = GetElement(self.m_root,"title_WndPlayer",WZUILabelTTF)
	if tFire.title == nil or tFire.title == "" then
		sTitleContent = LocalStrings.SHOP_NOCHENGHAO 
	end
	local tempPoint = GlobalMethod:ccp(0.5,1.5)
	CreateDesiSpine(conLevelInfo, txtTitle, sTitleContent, tempPoint, true)
	--设置等级
	GetElement(self.m_root,"lv_WndPlayer",WZUILabelTTF):setText(LocalStrings.LV..tFire.level)
end

--@brief   设置角色装备
function WndPlayer:_showRoleItem()
	WZLog("WndPlayer:_showRoleItem")
	if self.equipGridList == nil then self:initEquipGrid() end
	local itemSuitNum = CacheCenter:getPlayerInfo().itemSuitNum
	local itemSuitId = CacheCenter:getPlayerInfo().itemSuitId
	for i=1 , 8 do 
		if self.m_tPlayer[i] ~= nil then
			self.equipGridList[i]:setCellGoodItem(self.m_tPlayer[i],1)
			self.equipGridList[i]:_showSuitAni(itemSuitNum, itemSuitId)
    		GetElement(self.equipGridList[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    		GetElement(self.equipGridList[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(true)
		else
			local tCell = self.equipGridList[i]
			tCell:removeAllChild()
    		GetElement(tCell.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi1.png")
    		GetElement(tCell.m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(true)
    		GetElement(tCell.m_root, "btnImg1_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi1.png")
    		GetElement(tCell.m_root, "btnImg2_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi1.png")
		end

		--装备栏位置没有物品时，显示该位置应该放置的物品类型图片
		self:_createBlankText(i)
	end
end

--@brief   设置角色
function WndPlayer:_setPlayer(element, t)
	WZLog("WndPlayer:_setPlayer")
	if self.m_root == nil then return end
	self.m_root:disableSchedule()
	if element ~= nil then
		element:disableSchedule()
	end
	if self.m_tRole == nil or self.m_tPlayer == nil then
		return
	end
	local nSex
	if self.m_tRole.sex == 0 then
		nSex = true
	else
		nSex = false
	end
	local head,face,body,wing
	local headColor = 0
	local bodyColor = 0
	local showIndex = {9,10,11,12}
	for i=1,4 do
		if self.m_tPlayer[showIndex[i]] ~= nil then
			if i == 1 then
				head = self.m_tPlayer[showIndex[i]].basicInfo.animation_index_code
				headColor = self.m_tPlayer[showIndex[i]].color
			elseif i == 2 then
				face = self.m_tPlayer[showIndex[i]].basicInfo.animation_index_code
			elseif i == 3 then
				body = self.m_tPlayer[showIndex[i]].basicInfo.animation_index_code
				bodyColor = self.m_tPlayer[showIndex[i]].color
			elseif i == 4 then
				wing = self.m_tPlayer[showIndex[i]].basicInfo.animation_index_code
			end
			WZLog("设置时装",self.m_tPlayer[showIndex[i]].basicInfo.animation_index_code)
		end
	end
	--设置默认显示
	local gameParam = CacheCenter:getGameParam()
	if nSex == true then
		if head == nil then head = GDatatab_item["id_"..gameParam.defaultManHeadId].animation_index_code end
		if face == nil then face = GDatatab_item["id_"..gameParam.defaultManFaceId].animation_index_code end
		if body == nil then body = GDatatab_item["id_"..gameParam.defaultManBodyId].animation_index_code end
	else
		if head == nil then head = GDatatab_item["id_"..gameParam.defaultWomanHeadId].animation_index_code end
		if face == nil then face = GDatatab_item["id_"..gameParam.defaultWomanFaceId].animation_index_code end
		if body == nil then body = GDatatab_item["id_"..gameParam.defaultWomanBodyId].animation_index_code end
	end

	local conPlayerAni = self.m_root:getChildElement("conPlayerAni_WndPlayer")
	local conPlayer
	local changeDress = false
			if conPlayerAni:getChildByTag(50) then
				conPlayerAni:removeChildByTag(50, true)
				self.m_tPlayerAni = nil
				changeDress = true
			end
	if self.m_tPlayerAni == nil then
		local playerInfo = CacheCenter:getPlayerInfo()
		WZLog("皮肤id",playerInfo.shapeId)
		if playerInfo.shapeId ~= nil and playerInfo.shapeId > 0 and WndPhantom.show == 1 then
    		conPlayer = YDPlayerAnimation:createAnimation(nSex,false,true)
			conPlayer:setMonsterId(playerInfo.shapeId)
			conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))
		else
			conPlayer = YDPlayerAnimation:createAnimation(nSex)
		end
		conPlayer:getAnimNode():setTag(50)
		conPlayerAni:addChild(conPlayer:getAnimNode())
		self.m_tPlayerAni = conPlayer
	else
		conPlayer = self.m_tPlayerAni
		changeDress = true
	end
	self.m_tPlayerAni:getAnimNode():setTouchEnable(false)

	conPlayer:setHead(head, headColor)
	conPlayer:setFace(face)
	conPlayer:setBody(body)
	conPlayer:setBodyRanSe(bodyColor)
	if wing then
		conPlayer:setWing(wing)
	else
		conPlayer:setWing(0)
	end
	WZLog("设置角色",head,face,body,wing)
	local petMessage = CacheCenter:getPlayerInfo().petMessage
	if petMessage ~= nil and petMessage ~= "" then
		conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.45,-0.05))
		GetElement(self.m_root,"imgYY",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.45,0.04))
	else
		conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.34,-0.05))
		GetElement(self.m_root,"imgYY",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.34,0.04))
	end
	--if playerInfo.shapeId ~= nil and playerInfo.shapeId > 0 then
	--	conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.45,0.5))
	--	GetElement(self.m_root,"imgYY",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.45,0.59))
	--end
	--conPlayer:getAnimNode():setScale(1.15)
	conPlayer:play("wait0",true)
	if changeDress and self.m_bChangeDress then
		self.m_tPlayerAni:play("change",false)
    	self.m_root:enableSchedule("updateRole")
	end

	if self.m_bChangeDress then
		self:changeEquipAni()
		self.m_bChangeDress = false
	end
end

--@brief	更换装备动画
function WndPlayer:changeEquipAni()
	--新动画
	local spine = GetElement(self.m_root,"changeAni",WZUISpine)
	spine:play("2",false)	
end

--@brief	宠物
function WndPlayer:_showPet()
	WZLog("WndPlayer:_showPet")
    local conPet = GetElement(self.m_root, "conPet1_WndPlayer", WZUIContainer)
	if conPet:getChildByTag(1) then
		conPet:removeChildByTag(1,true)
	end
	local con = WZUIContainer:create()
	conPet:addChild(con)
	con:setTag(1)

	local petMessage = self.m_tRole.petMessage
	if petMessage ~= nil and petMessage ~= "" then
		petMessage = json.decode(self.m_tRole.petMessage)
		local ani, ani1 = CreatePetAni(con, nil, petMessage.animation, petMessage.advancedLevel, petMessage.petSkinItemId)
		ani:getAnimNode():setTouchEnable(false)
        ani:getAnimNode():setScale(0.8)
		if ani1 ~= nil then
        	ani1:setScale(0.8)
		end
	end
end

--@brief	装备栏空白时的说明
function WndPlayer:_createBlankText(tag)
	local sName = "conEquip%d_WndPlayer"
	sName = string.format(sName,tag)
	local con = self.m_root:getChildElement(sName)
	con:removeChildByTag(80+tag,true)

	if self.m_tPlayer[tag] ~= nil then return end

	--tag 1:武器，2：项链，3：戒指，4：手镯，5：宝物，6：勋章
	local iconList = {"ui/bag/common_icon_wuqi.png","ui/bag/common_icon_xianglian.png","ui/bag/common_icon_jiezhi.png",
			"ui/bag/common_icon_shouzhuo.png","ui/bag/common_icon_baowu.png","ui/bag/common_icon_xunzhang.png",
			"ui/bag/common_icon_erhuan.png","ui/bag/common_icon_fushou.png","ui/bag/common_icon_xunzhang.png",}
	local icon = iconList[tag]--"武器"

	local img = WZUIImage:create()
	img:setFile(icon)
	img:setTag(80+tag)
	img:setUseOriginSize(true)
	img:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	img:setTouchEnable(false)
	con:addChild(img)
end

--@brief	套装tips
function WndPlayer:onTip1(element)
	if WndItemInfo.m_root ~= nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = self.m_tRole.strongSuitId
	--local id = CacheCenter:getPlayerInfo().strongSuitId
	WZLog("WndPlayer:onTip1",id)
	if id == 0 then id = -1 end
	local tData = {id=id}

	WndTips:show(element,WndBag.m_root,9,tData,GlobalMethod:ccp(250,0))
	WndTips.m_root:setShowAll(true)
end

--@brief	套装tips
function WndPlayer:onTip2(element)
	if WndItemInfo.m_root ~= nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = self.m_tRole.starSuitId
	WZLog("WndPlayer:onTip2",id)
	if id == 0 then id = -2 end
	local tData = {id=id}

	WndTips:show(element,WndBag.m_root,9,tData,GlobalMethod:ccp(250,0))
	WndTips.m_root:setShowAll(true)
end

--@brief	套装tips
function WndPlayer:onTip3(element)
	if WndItemInfo.m_root ~= nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = self.m_tRole.mosaicSuitId
	WZLog("WndPlayer:onTip3",id)
	if id == 0 then id = -3 end
	local tData = {id=id}
    
	WndTips:show(element,WndBag.m_root,9,tData,GlobalMethod:ccp(250,0))
	WndTips.m_root:setShowAll(true)
end

--@brief	装备套装
function WndPlayer:onTip4(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = self.m_tRole.itemSuitId
	local suitNum = self.m_tRole.itemSuitNum
	WZLog("WndPlayer:onTip4",id)
	if id == 0 then id = 0 end
	local tData = {id=id,suitNum=suitNum}
    
	if self.m_bCheckOther == true then
		WndTips:show(element,WndCheckOther.m_root,11,tData,GlobalMethod:ccp(260,0))
		WndTips.m_root:setShowAll(true)
	else
		WndTips:show(element,WndBag.m_root,11,tData,GlobalMethod:ccp(260,0))
		WndTips.m_root:setShowAll(true)
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------


function WndPlayer:_adaptLanguage_en()
    WZLog("WndPlayer:_adaptLanguage_en ")
    local title = GetElement(self.m_root,"title_WndPlayer",WZUILabelTTF)
	title:setRelativePosition(GlobalMethod:ccp(0.5,0.81))
	title:setScale(0.7)
    title:setDimensions(GlobalMethod:CCSize(260))
    title:setAlignment(kCCTextAlignmentCenter)
end

function WndPlayer:_adaptLanguage_pt(  )
	local title = GetElement(self.m_root,"title_WndPlayer",WZUILabelTTF)
    title:setRelativePosition(GlobalMethod:ccp(0.5,0.81))
    title:setScale(0.7)
    title:setDimensions(GlobalMethod:CCSize(260))
    title:setAlignment(kCCTextAlignmentCenter)

    GetElement(self.m_root,"lv_WndPlayer",WZUILabelTTF):setScale(0.8)
    -- local name = GetElement(self.m_root,"name_WndPlayer",WZUILabelTTF)
    -- name:setScale(0.8)
    -- name:setRelativePosition(GlobalMethod:ccp(0.405,0.3))
end

function WndPlayer:_adaptLanguage_es(  )
    GetElement(self.m_root,"lv_WndPlayer",WZUILabelTTF):setScale(0.8)
    -- local name = GetElement(self.m_root,"name_WndPlayer",WZUILabelTTF)
    -- name:setScale(0.8)
    -- name:setRelativePosition(GlobalMethod:ccp(0.405,0.3))
    -- title:setAlignment(kCCTextAlignmentCenter)
end

-------------------------------------语言适配模块End----------------------------------------
