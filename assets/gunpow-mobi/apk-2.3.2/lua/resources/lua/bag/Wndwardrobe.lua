--Wndwardrobe.lua
--@brief	Wndwardrobe的UI模块
--@date		2016/08/17
--@author	zsq
--@note		衣橱


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function Wndwardrobe:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	加载动画
function Wndwardrobe:onEnterTransitionDidFinish(element)
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	CacheCenter:registerUpateDressSuitObserver(self) --注册多套时装
	self.m_root:setVisible(true)
	self:initDressGrid()
	self:showDressList()
	self:setSuitAndWingData()
	self:isShowRandomBtn()
	self:_addPlayer()
	self:update()
	self:_addDressSuit()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function Wndwardrobe:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	CacheCenter:unregisterUpateDressSuitObserver(self)

	self:_unInit()
end

--@brief	打开衣橱方法
function Wndwardrobe:show()
	WZLog("Wndwardrobe:show")

	local wnd = Wndwardrobe:createElement()
	WindowManager:addWindow(wnd, Wndwardrobe, nil, nil, true)
end

function Wndwardrobe:showWin() 
	self:show()
end

--@brief	关闭按钮点击回调
--@param 	element:触发事件的控件引用
function Wndwardrobe:onCloseClick(element)
    WZLog("Wndwardrobe:onCloseClick",type(Wndwardrobe.onCancelBatch))
	--SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if WndDressList.m_tTryWearList ~= nil and GetTableLen(WndDressList.m_tTryWearList) > 0 then
        MsgBoxManager:showConfirmBox(LocalStrings.BAGTIP22, Wndwardrobe, Wndwardrobe.onBatch, nil, {MSGBOXUICFG_CANCEL=LocalStrings.CANCEL}, nil, nil, nil, Wndwardrobe.onCancelBatch)
		return
	end

	WndPlayer:_setPlayer()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	开始按下回调函数
function Wndwardrobe:onTouchBegin(element,pt)
	WZLog("Wndwardrobe:onTouchBegin",pt.x,pt.y)
	if self.m_tCellDressSuit and not self.m_tCellDressSuit:checkPointInBtn(pt) then
        self.m_tCellDressSuit:hideSuitList()
    end
end

--@brief	显示时装列表
function Wndwardrobe:showDressList()
	WZLog("Wndwardrobe:showDressList")
	local conPlayer = self.m_root:getChildElement("conRight_Wndwardrobe")
	local celElement = WndDressList:createElement()
	if conPlayer:getChildByTag(2) then
		conPlayer:removeChildByTag(2,true)
	end
	celElement:setTag(2)
	conPlayer:addChild(celElement)
end

--@brief 	是否显示随机搭配按钮
function Wndwardrobe:isShowRandomBtn()
	-- body
	if #self.m_tSuitList >= 10 then
		GetElement(self.m_root,"btnRandom_Wndwardrobe",WZUIButton):setVisible(true)
	end
end
--@brief	初始化4个时装格子
function Wndwardrobe:initDressGrid()
	WZLog("Wndwardrobe:initDressGrid")
	if self.m_root == nil then return end
	self.m_tDressGrid = {}
	for i=1,4 do
		local con = self.m_root:getChildElement("conGrid"..i.."_Wndwardrobe")
		if con ~= nil then
		   local celElement,tLuaObj = CellGoodItem:createElement()
			if celElement ~= nil and tLuaObj ~= nil then
    	    	tLuaObj:setItemClickFun(Wndwardrobe,Wndwardrobe.onDressClicked)
				con:addChild(celElement)
            	celElement:setTag(i)
				--tLuaObj:setSZBg()
				table.insert(self.m_tDressGrid,tLuaObj)
			end
		end
	end
end

--@brief	更新4个时装格子
function Wndwardrobe:updateDressGrid()
	WZLog("Wndwardrobe:updateDressGrid",Serialize(WndDressList.m_tTryWearList))
	if self.m_root == nil then return end
	if self.m_tDressGrid == nil then return end
	if CacheCenter:getPlayerInfo() == nil then return end
	local dressType = {[1]=0,[2]=1,[3]=2,[4]=3}
	local equipmentList = CacheCenter:getEquipmentList()
	local imgList = {"ui/bag/common_icon_toubu.png","ui/bag/common_icon_biaoqing.png","ui/bag/common_icon_fuzhaung.png","ui/bag/common_icon_chibang.png"}
	if CacheCenter:getPlayerInfo().sex == 0 then
		imgList = {"ui/bag/common_icon_toubu2.png","ui/bag/common_icon_biaoqing2.png","ui/bag/common_icon_fuzhaung2.png","ui/bag/common_icon_chibang.png"}
	end	

	for i=1,4 do
		if WndDressList.m_tTryWearList == nil or WndDressList.m_tTryWearList[dressType[i]+1] == nil then

		local set = false
    	local txt = GetElement(self.m_root, "dressTxt"..i, WZUIImage)
		for j=1,#equipmentList do
			if equipmentList[j].maintype == 5 and equipmentList[j].subtype == dressType[i] then
   				self.m_tDressGrid[i]:setCellGoodItem(equipmentList[j],18)
    			GetElement(self.m_tDressGrid[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    			GetElement(self.m_tDressGrid[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(true)
				txt:setVisible(false)
				set = true
			end
		end
		if set == false then
			self.m_tDressGrid[i]:removeAllChild()
			--self.m_tDressGrid[i]:setSZBg()
			txt:setVisible(true)
			txt:setFile(imgList[i])
			txt:setTouchEnable(false)
    		GetElement(self.m_tDressGrid[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi1.png")
    		GetElement(self.m_tDressGrid[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(true)
    		GetElement(self.m_tDressGrid[i].m_root, "btnImg1_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi1.png")
    		GetElement(self.m_tDressGrid[i].m_root, "btnImg2_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi1.png")
		end

		end
	end
end

--@brief	时装格子被点击函数
function Wndwardrobe:onDressClicked(tLuaObj,tag,tData)
	WZLog("Wndwardrobe:onDressClicked",tag)
	if WndDressList.m_root ~= nil then
		WndDressList["onTab"..(tag+1)](WndDressList)
	end

	if tData ~= nil and tData.basicInfo ~= nil then
		local tOther = {interface = 1}
		local con = GetElement(self.m_root,"conPlayer_WndBag",WZUIContainer)
    	WndItemInfo:showInfo(tLuaObj.m_root,con,1,tData,true,nil,nil,tOther)
		if tData.tBtnList ~= nil then
    		WndItemInfo:setClickButtonCallback(self,self.cancelWear)
		end
	else
		local showWord = {LocalStrings.PHOTO,LocalStrings.WNDDRESS1,LocalStrings.CLOTHES,LocalStrings.WING}
		local con = GetElement(self.m_root,"conPlayer_WndBag",WZUIContainer)
		WndItemInfo:showInfo(tLuaObj.m_root,con,3,showWord[tag],false)
	end
end

--@brief	取消
function Wndwardrobe:cancelWear(tag, tData)
	WZLog("Wndwardrobe:cancelWear",tData.basicInfo.name,tData.basicInfo.sub_type)
	WndItemInfo:onCloseClick()
	if tag == 1 then
		local nType = {[0]=2,[1]=3,[2]=4,[3]=5}
		self.m_tIDList = {tData.basicInfo.id}
		WndPurchase:showBuyInterface(nType[tData.basicInfo.sub_type],tData.shopItemId,self,self.buyOK)
		return
	end
	local color = 0

	--获得当前拥有的时装
	local equipmentList = CacheCenter:getEquipmentList()
	local animation_index_code

	--取消格子
	if Wndwardrobe.m_root == nil then return end
	local sub_type = tData.basicInfo.sub_type
	local i = sub_type + 1
	local set = false
	local txt = GetElement(Wndwardrobe.m_root, "dressTxt"..i, WZUIImage)
	for j=1,#equipmentList do
		if equipmentList[j].maintype == 5 and equipmentList[j].subtype == sub_type then
			Wndwardrobe.m_tDressGrid[i]:setCellGoodItem(equipmentList[j],18)
			animation_index_code = equipmentList[j].basicInfo.animation_index_code
			color = equipmentList[j].color
			txt:setVisible(false)
			set = true
		end
	end
	if set == false then
		Wndwardrobe.m_tDressGrid[i]:removeAllChild()
		--Wndwardrobe.m_tDressGrid[i]:setSZBg()
		txt:setVisible(true)
		--设置默认显示
		local gameParam = CacheCenter:getGameParam()
		if CacheCenter:getPlayerInfo().sex == 0 then
			if sub_type == 0 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultManHeadId].animation_index_code
			elseif sub_type == 1 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultManFaceId].animation_index_code
			elseif sub_type == 2 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultManBodyId].animation_index_code
			elseif sub_type == 3 then
				animation_index_code = 0
			end
		else
			if sub_type == 0 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultWomanHeadId].animation_index_code
			elseif sub_type == 1 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultWomanHeadId].animation_index_code
			elseif sub_type == 2 then
				animation_index_code = GDatatab_item["id_"..gameParam.defaultWomanHeadId].animation_index_code
			elseif sub_type == 3 then
				animation_index_code = 0
			end
		end
	end

	--取消人物
	local conPlayer = Wndwardrobe.conPlayer
	if sub_type == 0 then
		conPlayer:setHead(animation_index_code)
	elseif sub_type == 1 then
		conPlayer:setFace(animation_index_code)
	elseif sub_type == 2 then
		conPlayer:setBody(animation_index_code)
		conPlayer:setBodyRanSe(color)
	elseif sub_type == 3 then
		conPlayer:setWing(animation_index_code)
	end
	conPlayer:play("wait0",true)
	--取消记录试穿的时装itemId
	if WndDressList.m_tTryWearList == nil then WndDressList.m_tTryWearList = {} end
	WndDressList.m_tTryWearList[sub_type+1] = nil
end

--@brief	打开时装属性窗口
function Wndwardrobe:onLeft()
	WZLog("Wndwardrobe:onLeft")
	local wnd = WndDressAttr:createElement()
	WindowManager:addWindow(wnd, WndDressAttr, true)
end

--@brief	取消批量续费
function Wndwardrobe:onCancelBatch()
	WZLog("Wndwardrobe:onCancelBatch")
	--MsgBoxManager:showTipBox("取消续费")
	WndDressList.m_tTryWearList = {}
	self:update()
	WndDressList:updateDress()
end

--@brief	批量续费
function Wndwardrobe:onBatch(element)
	if WndDressList.m_tTryWearList == nil or GetTableLen(WndDressList.m_tTryWearList) == 0 then
		MsgBoxManager:showTipBox(LocalStrings.SHOP_DRESS_FULL) 
		return
	end
	local IDList = {}
	for k,v in pairs(WndDressList.m_tTryWearList) do
		--if v.basicInfo.sale_again == 1 then
		--	table.insert(IDList,v.id)
		--end
		if v ~= nil then
			table.insert(IDList,v)
		end
	end
	--WZLog("Wndwardrobe:onBatch",Serialize(self.m_tDataList))
	--WZLog("Wndwardrobe:onBatch",Serialize(IDList))
	self.m_tIDList = IDList 
    if #IDList > 0 then WndBuy:showByID(IDList) end
end

--@brief	购买后自动穿上
function Wndwardrobe:onBatchCall()
	g_tTempItemForLaterShow = {}
	if self.m_tIDList == nil or #self.m_tIDList == 0 then return end
	--一键换装
	local equipList = CacheCenter:getDecorationList()
   	local id = WZLuaVector_int_:create()
	local sell = false
   	local transferState = WZLuaVector_int_:create()
	for k,v in pairs(equipList) do
		for k1,v1 in pairs(self.m_tIDList) do
   			if v.basicInfo.id == v1 and v.isUse ~= true then
           		id:push(v.playerItemId)
           		transferState:push(0)
				sell = true
			end
		end
	end
	--清空试穿列表
	WndDressList.m_tTryWearList = {}

	WZLog("要换上的装备是",Serialize(VectorToTable(id)))
	if sell == true then
		ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(id, transferState)
	end
end

--@brief 	随机换装
function Wndwardrobe:onRandomClick()
	-- body\
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("-------------------onlist--------------")
    local btn = GetElement(self.m_root,"btnRandom_Wndwardrobe",WZUIButton)
    btn:setTouchEnable(false)
    self.btnTime = 2
    btn:enableSchedule("_btnTime",1)
	local tab1,tab2,tab3,tab4,tab5 = self:getAllSuit()
	local id = WZLuaVector_int_:create()
	local t1 = GetRandomNum(1,#tab1,1)
	local t2 = GetRandomNum(1,#tab2,1)
	local t3 = GetRandomNum(1,#tab3,1)
	local t4 = GetRandomNum(1,#tab4,1)
	local transferState = WZLuaVector_int_:create()
	if tab1 ~= {} and tab1[t1[1]] ~= tab5[1] then
		id:push(tab1[t1[1]])
		transferState:push(0)
	end
	if tab2 ~= {} and tab2[t2[1]] ~= tab5[2] then
		id:push(tab2[t2[1]])
		transferState:push(0)
	end
	if tab3 ~= {} and tab3[t3[1]] ~= tab5[3] then
		id:push(tab3[t3[1]])
		transferState:push(0)
	end
	if tab4 ~= {} and next(tab4) and tab4[t4[1]] ~= tab5[4] then
		id:push(tab4[t4[1]])
		transferState:push(0)
	end
	WZLog("随机换装3",tab1[t1[1]],tab5[1],tab2[t2[1]],tab5[2],tab3[t3[1]],tab5[3],tab4[t4[1]],tab5[4])
	WZLog("要随机换上的装备是",Serialize(VectorToTable(id)))

	-- WZLog("随机数",Serialize(t1),Serialize(t2),Serialize(t3),Serialize(t4))
	-- if tab1[t1] ~= tab5[1] then
	-- 	id:push
	ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(id, transferState)
end

function Wndwardrobe:_btnTime()
    self.btnTime = self.btnTime - 1
    WZLog("----------------btnTime----------------",self.btnTime)
    if self.btnTime == 0 then
        local btn = GetElement(self.m_root,"btnRandom_Wndwardrobe",WZUIButton)
        btn:setTouchEnable(true)
        btn:disableSchedule()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	刷新界面
function Wndwardrobe:update()
	self:showPlayer()
	self:_updateFire()
	self:updateDressGrid()
end

--@brief	显示人物形象
function Wndwardrobe:showPlayer()
	WZLog("Wndwardrobe:showPlayer")
	if self.m_root == nil then return end
	--删除旧人物
	if self.conPlayer ~= nil then 
		self.conPlayer:getAnimNode():removeFromParentAndCleanup(true) 
		self.conPlayer = nil
	end
	local tEquip = CopyTable(CacheCenter:getEquipmentList())
	local playInfo = CacheCenter:getPlayerInfo()
	local sex = playInfo.sex
    local conP = WZUIContainer:luaTo(self.m_root:getChildElement("conRole_Wndwardrobe"))
	--有试穿时装，显示试穿
	if WndDressList.m_tTryWearList ~= nil then
		for k,v in pairs(WndDressList.m_tTryWearList) do
			if v ~= nil then
				local set = false
				local tTry = GDatatab_item["id_"..v]
				for k1,v1 in pairs(tEquip) do
					if type(v1) == "number" then
						if v1 == v then
							set = true
						end
					else
						local tDress = GDatatab_item["id_"..v1.id]
						if tDress.main_type == tTry.main_type and tDress.sub_type == tTry.sub_type then
							v1 = v	
							set = true
							--MsgBoxManager:showTipBox("显示试穿时装"..tTry.name)
						end
					end
				end
				if set == false then
					table.insert(tEquip,v)
				end
			end
		end
	end
    if not self.conPlayer then
		local conPlayer
		local headColor = 0
		local bodyColor = 0
		for i=1,#tEquip do
			if type(tEquip[i]) == "table" and tEquip[i].basicInfo.main_type == 5 and tEquip[i].basicInfo.sub_type == 0 and tEquip[i].isUse == true then
				headColor = tEquip[i].color
			end
			if type(tEquip[i]) == "table" and tEquip[i].basicInfo.main_type == 5 and tEquip[i].basicInfo.sub_type == 2 and tEquip[i].isUse == true then
				bodyColor = tEquip[i].color
			end
		end
       	conPlayer = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil, nil, nil, nil, nil, nil, headColor, bodyColor, false)
		conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.485,-0.041))
		--conPlayer:setScale(0.95)
        self.conPlayer = conPlayer
        conP:addChild(conPlayer:getAnimNode(),5)
		--conPlayer:setBodyRanSe(bodyColor)
    end
	WZLog("Wndwardrobe:showPlayer finish")
end

--@brief   更新人物标题信息栏和战斗力信息栏
function Wndwardrobe:_updateFire()
	WZLog("Wndwardrobe:_updateFire")
	local playerInfo = CacheCenter:getPlayerInfo()
	if self.m_root == nil or playerInfo == nil then return end
	--设置vip等级
	GetElement(self.m_root,"labelVip_Wndwardrobe",WZUILabelAtlasFont):setText(playerInfo.vipLevel)
	if tonumber(playerInfo.vipLevel) >= 10 then
		GetElement(self.m_root,"imgVip_Wndwardrobe",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.33,0.28))
		GetElement(self.m_root,"labelVip_Wndwardrobe",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.535385,0.27))
	else
		GetElement(self.m_root,"imgVip_Wndwardrobe",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.421538,0.28))
		GetElement(self.m_root,"labelVip_Wndwardrobe",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.626923,0.27))
	end

	--战斗力
	local labelFire1 = GetElement(self.m_root,"fight_Wndwardrobe",WZUILabelAtlasFont)
	labelFire1:setText(playerInfo.fighting)
	--labelFire1:setText(playerInfo.fashionFighting)

	--设置等级名字经验进度条
	local name = GetElement(self.m_root,"name_Wndwardrobe",WZUILabelTTF)
	name:setText(playerInfo.name)
	local conLevelInfo = GetElement(self.m_root, "conLevelInfo", WZUIContainer)
	local txtTitle = GetElement(self.m_root,"title_Wndwardrobe",WZUILabelTTF)
	local sTitleContent = playerInfo.title
	if playerInfo.title == nil or playerInfo.title == "" then
		sTitleContent = LocalStrings.SHOP_NOCHENGHAO 
	end
	local tempPoint = GlobalMethod:ccp(0.5,1.5)
	CreateDesiSpine(conLevelInfo, txtTitle, sTitleContent, tempPoint, true)
	--设置等级
	GetElement(self.m_root,"lv_Wndwardrobe",WZUILabelTTF):setText(LocalStrings.LV..playerInfo.level)
end

--@brief	显示时装
function Wndwardrobe:showDress()

end

function Wndwardrobe:onRuleClick() 
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local msg = LocalStrings["DRESS_RULE"]
   	WndSingleMapDesc:showInterface(msg)
end

-------------------------------------私有方法模块End----------------------------------------
--@brief	角色形象点击响应
function Wndwardrobe:onClickRole(element)
	WZLog("Wndwardrobe:onClickRole")
	if self.conPlayer == nil then return end
	local random = os.time()%2 + 1
	WZLog("随机数是",random)
	if random == 1 then
		self.conPlayer:play("run",false)
    	self.m_root:enableSchedule("updateRole")
	elseif random == 2 then
		self.conPlayer:play("win",false)
    	self.m_root:enableSchedule("updateRole")
	end
end

--@brief	角色形象动画完成回调
function Wndwardrobe:updateRole(element,t)
    --WZLog("Wndwardrobe:updateRole")

    if not self.conPlayer:isPlaying() then
        local isEnd = self.conPlayer:isCurrentAnimationDone()
        if isEnd == true then
            WZLog("Wndwardrobe:updateRole two")
			self.conPlayer:play("wait0",true)
            self.m_root:disableSchedule()
        end
    end
end

--@brief 	添加时装套装入口
function Wndwardrobe:_addDressSuit()
	-- body
	if CheckButtonOpen(144, false) then
		local conForDressSuit = GetElement(self.m_root, "conForDressSuit_Wndwardrobe", WZUIContainer)
		if conForDressSuit then
			local wndDress, tCell = WndDressSuit:createElement()
			if wndDress and tCell then
				tCell:setType(1)
				self.m_tCellDressSuit = tCell
				conForDressSuit:addChild(wndDress)
			end
		end
	end
end


-------------------------------------语言适配Begin----------------------------------------
function Wndwardrobe:_adaptLanguage_pt( )
	local txtTip = GetElement(self.m_root, "txtTip_Wndwardrobe", WZUILabelTTF)
	txtTip:setScale(0.96)
end

function Wndwardrobe:_adaptLanguage_es( )
	local txtTip = GetElement(self.m_root, "txtTip_Wndwardrobe", WZUILabelTTF)
	txtTip:setScale(0.96)
end

function Wndwardrobe:_adaptLanguage_ug( )
	local txtTip = GetElement(self.m_root, "txtTip_Wndwardrobe", WZUILabelTTF)
	txtTip:setDimensions(GlobalMethod:CCSize(460))
end
-------------------------------------语言适配End----------------------------------------