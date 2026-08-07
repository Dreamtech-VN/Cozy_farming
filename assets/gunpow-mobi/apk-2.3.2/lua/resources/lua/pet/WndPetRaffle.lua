--WndPetRaffle.lua
--@brief	WndPetRaffle的UI模块
--@date		2015/03/31
--@author	qixiang_xie
--@note		宠物抽取

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPetRaffle:onEnter(element)
	WZLog("WndPetRaffle:onEnter")
	ProtocolProcessorWndRankList:regAll3()
	ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryInfo(2)
	self.m_root = element
	AdaptLanguage(self)
	self.isUseTicket = CacheCenter:getGameParam().isUseTicket
	self.m_nMaxNum = tonumber(CacheCenter:getGameParam()["petNumUpper"])
	self.n_goldNum = tonumber(CacheCenter:getGameParam()["petLotteryGainGold"])
	local data = CacheCenter:getGameParam()["petLotteryPrice"]
	WZLog("WndPetRaffle:onEnter:",data)
	self.m_tPetDate[1],self.m_tPetDate[2] = SplitItemString(data)
	self:_addTop()
	self:_setLocalText()
	self:_getRaffleType()
	--self:_addPetList()
	self:controlViewShow(1)
    ProtocolProcessorScenePets:regAll()
	ProtocolProcessorScenePets:send_PET_GetFreeTime()
	local isEndTeach12, step12 = TeachGroup1:isTeachFinish(12)
    if isEndTeach12 ~= true and step12 < 5 and CacheCenter:getPlayerInfo().level == 11 then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999 )
    end
    self:setFyberTime()
    self:_AdaptationIphoneX()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetRaffle:setFyberTime()
	if NeedFyber(4) then 	
    	local conFyber = self.m_root:getChildElement("conFyber_WndPetRaffle")
    	conFyber:setVisible(true)
    	GetElement(self.m_root,"txtFyber_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.ATH_REWARD_CHECK)
    end 
end

function WndPetRaffle:onFunctionClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	DoFyberReward(4)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetRaffle:onExit(element)
	self:_unInit()
end

function WndPetRaffle:onTouchBegan()
	WndItemInfo:onCloseClick()

    if self.m_topCellLua then
        self.m_topCellLua.goldCellInfo.tcell:removeCreateTips()
    end
end

--@brief	十连抽
--@param	element:表绑定的UI节点引用
--@note     连续抽十次宠物
function WndPetRaffle:onDiaRaffleTClick(element)
	WZLog("WndPetRaffle:onDiaRaffleTClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if  self.m_bISAlter == true then
		return
	end
	self.tag = element:getTag()
	local pets=CacheCenter:getPlayerPetInfo()
	if #pets > (self.m_nMaxNum - 10) then
		MsgBoxManager:showTipBox(LocalStrings.PETMAXNUM)
		return
	end

	if JudgeMoneyIsEnough(tonumber(self.m_tPetDate[1][3]), tonumber(self.m_tPetDate[2][3]),nil,nil,64, nil, nil, nil, nil, self, self.tenRaffleUseDiamond) then
	   self.m_bISAlter = true
	   self.n_type = 2
	   ProtocolProcessorScenePets:send_PET_Lottery(3)
	end
end


--@brief    十连抽用钻石代替
function WndPetRaffle:tenRaffleUseDiamond()
    -- body
    self.m_bISAlter = true
    self.n_type = 2
    ProtocolProcessorScenePets:send_PET_Lottery(3)
end

--@brief	更新匹配时间
function WndPetRaffle:updateWaitTime2(element,dt)  
	self.t_freeTime[2] = self.t_freeTime[2] - dt
	local timeTtf = GetElement(self.m_root,"txtFreeTime2_WndPetRaffle",WZUILabelTTF)
	if self.t_freeTime[2] > 0 then
		--更新UI时间
		local hour,min,sec = self:numToTime(self.t_freeTime[2])
		if timeTtf == nil then
			return
		end
		timeTtf:setText(string.format("%0.2d:%0.2d:%0.2d",hour,min,sec))
	else
		timeTtf:setVisible(false)
		GetElement(self.m_root,"conFreeTime2_WndPetRaffle",WZUIContainer):setVisible(false)
		local con2 = self.m_root:getChildElement("btnFragRaffle2_WndPetRaffle")
		con2:disableSchedule()
    	AddRemark(con2, true)
	end
end

--@brief	更新匹配时间
function WndPetRaffle:updateWaitTime(element,dt)
	self.t_freeTime[1] = self.t_freeTime[1] - dt
	local timeTtf = GetElement(self.m_root,"txtFreeTime1_WndPetRaffle",WZUILabelTTF)
	if self.t_freeTime[1] > 0 then
		--WZLog("--WndPetRaffle:updateWaitTime--1")
		--更新UI时间
		local hour,min,sec = self:numToTime(self.t_freeTime[1])
		if timeTtf == nil then
			return
		end
		timeTtf:setText(string.format("%0.2d:%0.2d:%0.2d",hour,min,sec))
		--WZLog("--WndPetRaffle:updateWaitTime--2",timeTtf:getText())
	else
		--timeTtf:setVisible(false)
		GetElement(self.m_root,"conFreeTime1_WndPetRaffle",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"txtExcGoodsCount1_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.PETFREE2)
		local con1 = self.m_root:getChildElement("btnFragRaffle1_WndPetRaffle")
		con1:disableSchedule()
    	AddRemark(con1, true)
	end
end

--@brief	抽一次
--@param	element:表绑定的UI节点引用
--@note     抽一次宠物
function WndPetRaffle:onDiaRaffleClick(element)
	WZLog("WndPetRaffle:onDiaRaffleClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    TeachGroup1:endTeachStep({12,5})
    local isEndTeach12, step12 = TeachGroup1:isTeachFinish(12)
    if isEndTeach12 ~= true and CacheCenter:getPlayerInfo().level == 11 then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999 )
    end

	if  self.m_bISAlter == true then
		return
	end

	self.tag = element:getTag()

	local petDebris = CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][1])
	local petNum = 1
	if petDebris >= self.m_tPetDate[2][1]*10 then
		petNum = 10
	end

	local pets=CacheCenter:getPlayerPetInfo()
	if #pets > (self.m_nMaxNum - petNum)then
		MsgBoxManager:showTipBox(LocalStrings.PETMAXNUM)
		TeachGroup1:setTeachFinish(12,-1)
		TeachGroup1:removeTeach()
		return
	end

    self.m_nTempPetNum = petNum
	--local petDebris = CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][1])
	if self.isUseTicket == "0" then
		if petDebris >= tonumber(self.m_tPetDate[2][1]) or JudgeMoneyIsEnough(70, tonumber(self.m_tPetDate[2][2]),nil,nil,64, nil, nil, nil, nil, self, self.oneRaffleUseDiamond) then
	   		self:oneRaffleUseDiamond()
		end
	else
		if petDebris >= tonumber(self.m_tPetDate[2][1]) or JudgeMoneyIsEnough(1, tonumber(self.m_tPetDate[2][2]),nil,nil,64, nil, nil, nil, nil, self, self.oneRaffleUseDiamond) then
	   		self:oneRaffleUseDiamond()
		end
	end
end

--@brief    抽一次用钻石代替
function WndPetRaffle:oneRaffleUseDiamond()
    -- body
    self.m_bISAlter = true
    self.n_type = self.m_nTempPetNum > 1 and 2 or 1
    WZLog("--onDiaRaffleClick---",self.n_type)
    ProtocolProcessorScenePets:send_PET_Lottery(2)
end

--@brief	兑换宠物
--@param	element:表绑定的UI节点引用
--@note     使用宠物碎片兑换宠物
function WndPetRaffle:onFragRaffleClick(element)
	WZLog("WndPetRaffle:onFragRaffleClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    TeachGroup1:endTeachStep({12,4})
    local isEndTeach12, step12 = TeachGroup1:isTeachFinish(12)
    if isEndTeach12 ~= true and CacheCenter:getPlayerInfo().level == 11 then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999 )
    end
    WZLog("WndPetRaffle:onFragRaffleClick", self.m_bISAlter)
    if  self.m_bISAlter == true then
		return
	end

	self.tag = element:getTag()

	local pets=CacheCenter:getPlayerPetInfo()
	local petDebris = CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][4])
	local petNum = 1
	if petDebris >= self.m_tPetDate[2][4]*10 and self.t_freeTime[1] > 0 then
		petNum = 10
	end
	if #pets > (self.m_nMaxNum - petNum) then
		MsgBoxManager:showTipBox(LocalStrings.PETMAXNUM)
		TeachGroup1:setTeachFinish(12,-1)
		TeachGroup1:removeTeach()
		return 
	end
	if petDebris >= tonumber(self.m_tPetDate[2][4])*10 and #pets >= (self.m_nMaxNum -10)then
		MsgBoxManager:showTipBox(LocalStrings.PETMAXNUM)
		TeachGroup1:setTeachFinish(12,-1)
		TeachGroup1:removeTeach()
		return 
	end
	if petDebris >= tonumber(self.m_tPetDate[2][4]) or self.t_freeTime[1] <= 0  then
	   self.m_bISAlter = true
	   self.n_type = petNum > 1 and 2 or 0
	   WZLog("DDDDDD:", self.n_type)
	  -- ProtocolProcessorScenePets:send_PET_GetFreeTime()
	   ProtocolProcessorScenePets:send_PET_Lottery(1)
	else
        MsgBoxManager:showTipBox(LocalStrings.PETNORAFFLEGOODS)
        WndFastGetItems:show(self.m_tPetDate[1][4],tonumber(self.m_tPetDate[2][4]))
	end
end

--@brief 判断是否能10连抽奖
function WndPetRaffle:canTenFrag()
	local petDebris = CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][4])
	if petDebris >= self.m_tPetDate[2][4]*10 and self.t_freeTime[1] > 0 then
		GetElement(self.m_root,"txtExcGoodsCount1_WndPetRaffle",WZUILabelTTF):setText(self.m_tPetDate[2][4]*10)
		GetElement(self.m_root,"txtExcGoods_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.PETOPENEGE3)
		if ProjConfig.LANGUAGE == "th" then
			GetElement(self.m_root,"txtExcGoods_WndPetRaffle",WZUILabelTTF):setFontSize(20)
		end
	else
		GetElement(self.m_root,"txtExcGoodsCount1_WndPetRaffle",WZUILabelTTF):setText(self.m_tPetDate[2][4])
		GetElement(self.m_root,"txtExcGoods_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.PETOPENEGE1)
	end
end

--@brief	点击图鉴按钮执行的函数
--@param	element:表绑定的UI节点引用
function WndPetRaffle:onShowMore(element)
	WZLog("WndPetRaffle:图鉴")
	if self.b_hasAddList == false then
		self.b_hasAddList = true
		self:_addPetList()
	end
    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 12 and TeachGroup1.STEP == 6
    if isTeach ~= true then
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
        self:controlViewShow(4)
    end
end

--@brief	点击返回按钮执行的函数
--@param	element:表绑定的UI节点引用
function WndPetRaffle:onReturnClick(element)
	WZLog("WndPetRaffle:onReturnClick")
	if self.m_root == nil then return end 
	
	if element then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
		local tag = element:getTag()
		if tag == 4 then
			local con = GetElement(self.m_root,"conPetRaffle4_WndPetRaffle",WZUIContainer)
				local blackImg = WZUIImage:luaTo(con:getChildByTag(9876))
				blackImg:removeFromParentAndCleanup(true)
				con:setVisible(false)
			return
		end
	end
	if self.n_type ~= 2 then
		GetElement(self.m_root,"imgLightBg_WndPetRaffle",WZUIImage):setVisible(false)
		GetElement(self.m_root,"imgLightBg2_WndPetRaffle",WZUIImage):setVisible(false)
    	GetElement(self.m_root,"conOnePet_WndPetRaffle",WZUIContainer):setVisible(false)
  	else
    	GetElement(self.m_root,"conTenPet_WndPetRaffle",WZUIContainer):setVisible(false)
    	GetElement(self.m_root,"conTenButton_WndPetRaffle",WZUIContainer):setVisible(false)
    	GetElement(self.m_root,"conTen_WndPetRaffle",WZUIContainer):setVisible(false)
  	end
	self:controlViewShow(1)

	if element then 
	    local isEndTeach12, teachStep12 = TeachGroup1:isTeachFinish(12)
	    if isEndTeach12 ~= true and teachStep12 < 5 then
	        TeachGroup1:startGroup({12,5,WndPetRaffle.m_root})
	    elseif isEndTeach12 ~= true and teachStep12 >= 5 then
	        TeachGroup1:startGroup({12,6,WndPetRaffle.m_root})
	    end
	end

end

--@brief    控制view显示
function WndPetRaffle:controlViewShow(tag)
	WZLog("WndPetRaffle:controlViewShow:",tag)
	if tag == 2 then
		for i=1,10 do
      		local con = GetElement(self.m_root,"conTenPet"..i.."_WndPetRaffle",WZUIContainer)
      		con:removeAllChildrenWithCleanup(true)
		end
	end

	local con = {}
	con1 = self.m_root:getChildElement("conPetRaffle1_WndPetRaffle")
    con1 = WZUIContainer:luaTo(con1)
    con2 = self.m_root:getChildElement("conPetRaffle2_WndPetRaffle")
    con2 = WZUIContainer:luaTo(con2)
    con3 = self.m_root:getChildElement("conPetRaffle3_WndPetRaffle")
    con3 = WZUIContainer:luaTo(con3)
    local con5 = self.m_root:getChildElement("conHideBg_WndPetRaffle")
    con5 = WZUIContainer:luaTo(con5)
  	con4 = self.m_root:getChildElement("conPetRaffle4_WndPetRaffle")
    con4 = WZUIContainer:luaTo(con4)
    table.insert(con, con1)
    table.insert(con, con2)
    table.insert(con, con3)
    table.insert(con, con4)
    WZLog("sssss:",#con)
    local bool = (tag == 1)
    con5:setVisible(not bool)	
    for i = 2, 4 do
 		con[i]:setVisible(i == tag)	
    end
    if tag == 4 then
       con5:setVisible(false)
  	   WindowManagerAni:createAction(con4,true)
    end

    if tag == 1 then
	    local spineEgg = GetElement(self.m_root,"spineEgg_WndPetRaffle",WZUISpine)
	    spineEgg:setVisible(true)
	    local myAni = GetElement(self.m_root,"armOpenEgg_WndPetRaffle",WZArmature)
	    myAni:setVisible(false)
	end
end

--@brief    关闭按钮点击被调用的函数
--@param	element:表绑定的UI节点引用
--@note		退出当前场景
function WndPetRaffle:onCloseClick(element)
	WZLog("WndPetRaffle:onCloseClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if WndPets.m_root then
    	WndPets.m_root:setVisible(true)
    end
    local bRefresh = true
    if WndPetsUpgrade.m_root ~= nil then
    	WZLog("WndPetRaffle:onCloseClick22")
    	WndPetsUpgrade:setPetList()
    	bRefresh = false
    end
    if  WndPetsEvolution.m_root ~= nil then
    	WndPetsEvolution:initChoiceList()
    	WZLog("WndPetRaffle:onCloseClick33")
    	bRefresh = false
    end
    if bRefresh then
    	WZLog("WndPetRaffle:onCloseClick44")
    	WndPets:doRefresh()
    end

    -- WindowManager:removeWindow(self.m_root, self, true)
    WndSummonEntrance:closeWin()
end

--@brief	返回上一个场景
function WndPetRaffle:goBack()
	WZLog("WndPetRaffle:goBack")
	local scene = self.m_tBackSceneLuaObj:createElement()
	replaceScene(scene)
end

--@brief   抽取宠物失败
function WndPetRaffle:raffleError()
	if self.m_bISAlter == true then
	   self.m_bISAlter = false 
	   MsgBoxManager:showTipBox(LocalStrings.RAFFLE_PET_ERROR)
	end
end

--@brief   获取抽奖宠物时间成功
function WndPetRaffle:getTime(type,time)
    if self.m_root == nil then
        return
    end
	WZLog("qqqq:",type[1], type[2], time[1], time[2])
	self.t_freeTime = {time[1],time[2]}
	WZLog("WndPetRaffle:getTime:",self.t_freeTime[1],self.t_freeTime[2])
	local con1 = self.m_root:getChildElement("btnFragRaffle1_WndPetRaffle")
    local con2 = self.m_root:getChildElement("btnFragRaffle2_WndPetRaffle")
	if self.t_freeTime[1] > 0 then
		WZLog("--WndPetRaffle:getTime--1")
		AddRemark(con1, false)
		con1:enableSchedule("updateWaitTime",0.2)
		GetElement(self.m_root,"conFreeTime1_WndPetRaffle",WZUIContainer):setVisible(true)
		--GetElement(self.m_root,"txtExcGoodsCount1_WndPetRaffle",WZUILabelTTF):setText(self.m_tPetDate[2][4])
		self:canTenFrag()
		WZLog("--WndPetRaffle:getTime--2")
	else
		AddRemark(con1, true)
		local txtExcGoodsCount1 = GetElement(self.m_root,"txtExcGoodsCount1_WndPetRaffle",WZUILabelTTF)
		-- if ProjConfig.LANGUAGE == "vn" then
		-- 	txtExcGoodsCount1:setFontSize(15.8)
		-- 	txtExcGoodsCount1:setRelativePosition(GlobalMethod:ccp(0.465,0.5))
		-- end
		txtExcGoodsCount1:setText(LocalStrings.PETFREE2)
		GetElement(self.m_root,"txtExcGoods_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.PETOPENEGE1)
		GetElement(self.m_root,"conFreeTime1_WndPetRaffle",WZUIContainer):setVisible(false)
	end

	local red1, red2 = self:isShowPetRed(self.t_freeTime[1])
	AddRemark(con1, red1)
	AddRemark(con2, red2)


	local isEndTeach12, teachStep12 = TeachGroup1:isTeachFinish(12)
	if isEndTeach12 ~= true then
	    if self.t_freeTime[1] <= 0 then
	        TeachGroup1:startGroup({12,4,WndPetRaffle.m_root})
	    else
	        if self.m_bIsTeach == true then
	            TeachGroup1:startGroup({12,5,WndPetRaffle.m_root})
	        end
	    end
	end
	
	self.m_bIsTeach = false
end

--是否有小红点显示
function WndPetRaffle:isShowPetRed(time)
    local red1, red2 = false, false
    if time <= 0 then
        red1 = true
    end

    local petLotteryPrice =  CacheCenter:getGameParam().petLotteryPrice
    local tIds,tNums = SplitItemString(petLotteryPrice)
    local fragmentCount =  CacheCenter:getPlayerItemCountById(tIds[4])
    if fragmentCount >= tonumber(tNums[4]) * 10 then
        red1 = true
    end

    local fragmentCount =  CacheCenter:getPlayerItemCountById(tIds[1])
    if fragmentCount >= tonumber(tNums[1]) * 10 then
        red2 = true
    end
    WZLog("WndPetRaffle:isShowPetRed", time, red1, red2)
    return red1, red2
end

--@brief   将数字改为时间格式
function WndPetRaffle:numToTime(nNum)
	local hour = math.floor(nNum/3600)
	local min = math.floor((nNum%3600)/60)
	local sec = math.floor(nNum%60)
	return hour, min, sec
	--return self:numToDoubleTime(hour), self:numToDoubleTime(min), self:numToDoubleTime(sec)
end

--@brief   将数字改为时间格式
function WndPetRaffle:numToDoubleTime(nNum)
	local s = ""
	if nNum > 9 then
		s = ""..nNum
	else
		s = "0"..nNum
	end
	return s
end

--@brief   更新装备
function WndPetRaffle:_setPetItem()
	if self.m_root == nil or self.m_tItem == nil then
		return
	end
	local tableConGoods = self.m_root:getChildElement("tableConGoods_WndPetRaffle")
	tableConGoods = WZUITableContainer:luaTo(tableConGoods)
	tableConGoods:cleanTable()
	for i,data in pairs(self.m_tItem) do 
		WZLog("WndPetRaffle:_setPetItem:",Serialize(data))
		local celElement,tCell = CellGrid:createElement()
		if celElement and tCell then
			celElement:setScale(0.86)
			celElement:setTag(i - 1)
			tableConGoods:setCellElement(celElement)
			tCell:setCellGoodItem(data,2)
			tCell:setItemClickFun(self,self.onItemClick)
			if self.m_tItemChoice == nil then
				self.m_tItemChoice = tCell
			end
		end
	end
	self:_createEmptyItem(tableConGoods,#self.m_tItem)--创建空白Item
	--self:_setTableconPostion()
end

--@param	创建空白Item
function WndPetRaffle:_createEmptyItem(tableConGoods,num)
	local maxCount = 20
	if num > 20 then
		if num % 4 == 0 then
			maxCount = 0
		else
			maxCount = 4 - num %4
		end
	else
		maxCount = 20-num
	end
	if tableConGoods == nil or maxCount == 0 then
		return 
	end
	for i=1,maxCount do
		local celElement,tCell = CellGrid:createElement()
		if celElement and tCell then
			celElement:setScale(0.86)
			celElement:setTag(num+i-1)
			tableConGoods:setCellElement(celElement)
			--tCell:removeAllChild()
			tCell:setItemClickFun(self,self.onItemClick)
		end
	end
end

--@brief	Item点击回调
function WndPetRaffle:onItemClick(element,tag,tData)
	WZLog("WndPetRaffle:onItemClick:",tag)
	tag = tag + 1
	if element ~= nil then
		self.m_tItemChoice:setHighLight(false)
		self.m_tItemChoice = element
	end 
	self.m_tItemChoice:setHighLight(true)
	self.n_showPetId = self.m_tItem[tag].id
	local name = self.m_tItem[tag].name --
	local animation_index_code = self.m_tItem[tag].animation_index_code
	local quality = self.m_tItem[tag].quality
	local ap = self.m_tItem[tag].property[2][2]
	local dp = self.m_tItem[tag].property[3][2]
	local hp = self.m_tItem[tag].property[1][2]
	local sp = self.m_tItem[tag].sp
	local sp2 = self.m_tItem[tag].sp2
	 -- --星星品质
  -- 	for i =1 ,5 do
  --     GetElement(self.m_root,"imgPetAptitude"..i.."_WndPetRaffle",WZUIImage):setVisible(i <= (quality+1))
  -- 	end
  -- 	WndPets:setAptitudePost(self.m_root, "conPetAptitude4_WndPetRaffle",quality)
  	--名字
  	local nameText = GetElement(self.m_root,"txtAllName_WndPetRaffle",WZUIFreeTextBox)
  	local txtColor = g_sFtxtQualityColor
    local color = txtColor[quality]
    local s0 = WndPets:getTypeById(self.m_tItem[tag].id)
    local sLevel = string.format([[<I>%s</I><T C=%s S="24" P="1" SE="1" SS="4" SC="132,66,29">%s</T>]],s0, color, name)
  	nameText:setShowText(sLevel)
  	nameText:setVisible(true)
  	--self:setTextColor(quality, nameText)
 
  	GetElement(self.m_root,"txtPetHPD_WndPetRaffle",WZUILabelTTF):setText(hp)
  	GetElement(self.m_root,"txtPetAPD_WndPetRaffle",WZUILabelTTF):setText(ap)
  	GetElement(self.m_root,"txtPetDPD_WndPetRaffle",WZUILabelTTF):setText(dp)
  	GetElement(self.m_root,"txtPetSPD_WndPetRaffle",WZUILabelTTF):setText(""..sp.."-"..sp2)

  	--动物动画

  	local petImage = GetElement(self.m_root,"conPetImage_WndPetRaffle",WZUIContainer)
  	petImage:removeAllChildrenWithCleanup(true)
  	local petAni = CreatePetAni(petImage, nil, animation_index_code)
 	--petAni:getAnimNode():setScale(1.5)
end

--打开宠物预览界面
function WndPetRaffle:onClickShow(element)
  SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
  WZLog("WndPetRaffle:onClickShow")
  if WndPets:isExpPet(self.n_showPetId) then
    MsgBoxManager:showTipBox(LocalStrings.ISEXPPET)
    return
  end
  WndPetShow:show(self.n_showPetId)
end

--@brief   根据不同宠物的品质设置不同的字体颜色
function WndPetRaffle:setTextColor(nNum,txtObj)
  WZLog("WndPetRaffle:setTextColor")
  local color = QUALITYCOLOR[nNum]
   txtObj:setColor(color)
end

--@brief 	点击前往宠物按钮回调
function WndPetRaffle:onClickGotoPet(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if WndPets.m_root == nil then
    	OpenPartner()
    else
    	WndPets:onClose()
    	OpenPartner()
    end
    self:onCloseClick2()
end

function WndPetRaffle:onCloseClick2()
	WZLog("WndPetRaffle:onCloseClick2")
    if WndPets.m_root then
    	WndPets.m_root:setVisible(true)
    end
    local bRefresh = true
    if WndPetsUpgrade.m_root ~= nil then
    	WZLog("WndPetRaffle:onCloseClick22")
    	WndPetsUpgrade:setPetList()
    	bRefresh = false
    end
    if  WndPetsEvolution.m_root ~= nil then
    	WndPetsEvolution:initChoiceList()
    	WZLog("WndPetRaffle:onCloseClick33")
    	bRefresh = false
    end
    if bRefresh then
    	WZLog("WndPetRaffle:onCloseClick44")
    	WndPets:doRefresh()
    end
    -- WindowManager:removeWindow(self.m_root, self, true)
    -- WndSummonEntrance:closeWin()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 调整星级位置
function WndPetRaffle:_setAptitudePost(element,nNum)
  if nNum % 2 == 1 then
    element:setRelativePosition(GlobalMethod:ccp(0.5,1.05))
  else
    element:setRelativePosition(GlobalMethod:ccp(0.56,1.05))
  end
end

--@brief	设置本地界面文本
function WndPetRaffle:_setLocalText()
	WZLog("WndPetRaffle:_setLocalText")
	local desc = {LocalStrings.PETRAFFLEDESC1,LocalStrings.PETRAFFLEDESC2,LocalStrings.PETRAFFLEDESC3}
	for i =1, 3 do
		GetElement(self.m_root,"ftbDesc"..i.."_WndPetRaffle",WZUIFreeTextBox):setShowText(desc[i])
	end
	GetElement(self.m_root, "txtFreeTime2_WndPetRaffle", WZUILabelTTF):setText(self.m_tPetDate[2][1])
	GetElement(self.m_root,"txtExcGoodsCount1_WndPetRaffle",WZUILabelTTF):setText(self.m_tPetDate[2][4])
	GetElement(self.m_root,"txtExcGoodsCount3_WndPetRaffle",WZUILabelTTF):setText(self.m_tPetDate[2][3])
    local imgExchangeGoods3 = GetElement(self.m_root, "imgExchangeGoods3_WndPetRaffle", WZUIImage)
    imgExchangeGoods3:setFile(GDatatab_item["id_" .. self.m_tPetDate[1][3]].icon)
    imgExchangeGoods3:setScale(0.5)
    GetElement(self.m_root,"txtBuy3_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.PET_BUY_GOLD1..self.n_goldNum*10)
    GetElement(self.m_root,"txtBuy4_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.PET_BUY_GOLD1..self.n_goldNum*10)

    GetElement(self.m_root,"ftbBuyCount2_WndPetRaffle",WZUIFreeTextBox):setShowText(LocalStrings.PET_BUY_GOLDDESC1)
    GetElement(self.m_root,"ftbBuyCount3_WndPetRaffle",WZUIFreeTextBox):setShowText(LocalStrings.PET_BUY_GOLDDESC2)

    if ProjConfig.LANGUAGE == "vn" then
		imgExchangeGoods3:setScale(0.4)
	end
    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "ug" then
		GetElement(self.m_root,"txtBuy4_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.PET_BUY_GOLD1.." "..self.n_goldNum*10)		
		imgExchangeGoods3:setScale(0.4)
	end
end

--@brief  添加金币图标动画
function WndPetRaffle:_addTop()
  local cell, tcell = CellTopHandle:createElement()
  self.m_root:addChild(cell)
  tcell:setTopData("ui/pet/common_icon_cw.png", WndPetRaffle, self.onCloseClick,true,nil,nil,nil,{goldType = 2})
  self.m_topCellLua = tcell
end

--@brief 宠物抽奖的方式
function WndPetRaffle:_getRaffleType()
	local money = CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][1])
	if money >= tonumber(self.m_tPetDate[2][1]*10) then --如果要是碎片充足，则碎片抽奖
		local elemet = GetElement(self.m_root, "imgExchangeGoods2_WndPetRaffle", WZUIImage)
		elemet:setFile("shopitems/chongwujiang_1.png")
		elemet:setScale(0.5)
		GetElement(self.m_root, "txtExcGoodsCount2_WndPetRaffle", WZUILabelTTF):setText(self.m_tPetDate[2][1]*10)
		GetElement(self.m_root, "txtExcGoods2_WndPetRaffle", WZUILabelTTF):setText(LocalStrings.PETOPENEGE3)
		GetElement(self.m_root,"imgBuy2_WndPetRaffle",WZUIImage):setFile("shopitems/chongwujiang_1.png")
		GetElement(self.m_root,"conBuyGold3_WndPetRaffle",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"txtBuy2_WndPetRaffle",WZUILabelTTF):setText("")
	elseif money >= tonumber(self.m_tPetDate[2][1]) and money < tonumber(self.m_tPetDate[2][1]*10) then
		local elemet = GetElement(self.m_root, "imgExchangeGoods2_WndPetRaffle", WZUIImage)
		elemet:setFile("shopitems/chongwujiang_1.png")
		elemet:setScale(0.5)
		GetElement(self.m_root, "txtExcGoodsCount2_WndPetRaffle", WZUILabelTTF):setText(self.m_tPetDate[2][1])
		GetElement(self.m_root, "txtExcGoods2_WndPetRaffle", WZUILabelTTF):setText(LocalStrings.PETOPENEGE4)
		GetElement(self.m_root,"imgBuy2_WndPetRaffle",WZUIImage):setFile("shopitems/chongwujiang_1.png")
		GetElement(self.m_root,"conBuyGold3_WndPetRaffle",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"txtBuy2_WndPetRaffle",WZUILabelTTF):setText("")
	else
		local elemet = GetElement(self.m_root, "imgExchangeGoods2_WndPetRaffle", WZUIImage)
		elemet:setFile(GDatatab_item["id_" .. self.m_tPetDate[1][2]].icon)
		elemet:setScale(0.5)
		GetElement(self.m_root, "txtExcGoodsCount2_WndPetRaffle", WZUILabelTTF):setText("")
		GetElement(self.m_root, "txtExcGoodsCount22_WndPetRaffle", WZUILabelTTF):setText(self.m_tPetDate[2][2])
		GetElement(self.m_root, "txtExcGoods2_WndPetRaffle", WZUILabelTTF):setText(LocalStrings.PETOPENEGE2)
		GetElement(self.m_root,"imgBuy2_WndPetRaffle",WZUIImage):setFile("shopitems/gold.png")
		GetElement(self.m_root,"conBuyGold3_WndPetRaffle",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"txtBuy1_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.PET_BUY_GOLD1..self.n_goldNum)
		GetElement(self.m_root,"txtBuy2_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.PET_BUY_GOLD1..self.n_goldNum)
		-- GetElement(self.m_root,"txtBuyCount_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.PET_BUY_GOLDDESC1)

		if ProjConfig.LANGUAGE == "vn" then
			GetElement(self.m_root, "imgExchangeGoods2_WndPetRaffle", WZUIImage):setScale(0.4)
		end
		if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "ug" then
			GetElement(self.m_root,"txtBuy2_WndPetRaffle",WZUILabelTTF):setText(LocalStrings.PET_BUY_GOLD1.." "..self.n_goldNum)
			GetElement(self.m_root, "imgExchangeGoods2_WndPetRaffle", WZUIImage):setScale(0.4)
		end
	end
end

--@brief  添加所有宠物信息
function WndPetRaffle:_addPetList()
	for k,v in pairs(GDatatab_pet) do
	  if v.yc ~= 1 then 
		  local t = GDatatab_item["id_"..v.item_id]
		  t.sp = v.gift[1][1]
		  t.sp2 = v.gift[1][2]
		  t.id = v.item_id
		  table.insert(self.m_tItem, t)
	   end
    end
    function petSort(a,b)
    	if a.sub_type == b.sub_type then
    		return a.quality < b.quality
    	else
    		return a.sub_type > b.sub_type
    	end
    end
    table.sort(self.m_tItem, petSort)
    self:_setPetItem()
    if #self.m_tItem > 0 then
    	self:onItemClick(nil,0)
    end
end

--@brief	十连抽再抽一次
function WndPetRaffle:onRafAgain( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.note == 2 then
		local pets=CacheCenter:getPlayerPetInfo()
		if #pets >= (self.m_nMaxNum - 10)then
			MsgBoxManager:showTipBox(LocalStrings.PETMAXNUM)
			return
		end
		if self.tag == 1 then
			if CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][4]) >= tonumber(self.m_tPetDate[2][4]*10) then
				self.n_type = 2
				GetElement(self.m_root,"conTenButton_WndPetRaffle",WZUIContainer):setVisible(false)
      			GetElement(self.m_root,"conTen_WndPetRaffle",WZUIContainer):setVisible(false)
				ProtocolProcessorScenePets:send_PET_Lottery(1)
			else
				MsgBoxManager:showTipBox(LocalStrings.PETNORAFFLEGOODS)
			end
		elseif self.tag == 2 then
			if CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][1]) >= tonumber(self.m_tPetDate[2][1]*10) then
				--self.n_type = 2
				GetElement(self.m_root,"conTenButton_WndPetRaffle",WZUIContainer):setVisible(false)
      			GetElement(self.m_root,"conTen_WndPetRaffle",WZUIContainer):setVisible(false)
				ProtocolProcessorScenePets:send_PET_Lottery(2)
			end
		elseif self.tag == 3 then
			if self.isUseTicket == "0" then
				if JudgeMoneyIsEnough(70, tonumber(self.m_tPetDate[2][3]), nil, nil, 64, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
				    --self.n_type = 2
					self:sureUseDiamondInstead()
				end
			else
				if JudgeMoneyIsEnough(1, tonumber(self.m_tPetDate[2][3]), nil, nil, 64, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
				    --self.n_type = 2
					self:sureUseDiamondInstead()
				end
			end
		end
	elseif self.note == 1 then
		local pets=CacheCenter:getPlayerPetInfo()
		if #pets >= (self.m_nMaxNum - 1)then
			MsgBoxManager:showTipBox(LocalStrings.PETMAXNUM)
			return
		end
		if self.tag == 1 then
			if CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][4]) >= tonumber(self.m_tPetDate[2][4]) then
				self.n_type = 0
				ProtocolProcessorScenePets:send_PET_Lottery(1)
			else
				MsgBoxManager:showTipBox(LocalStrings.PETNORAFFLEGOODS)
			end
		elseif self.tag == 2 then
			WZLog("--self.m_tPetDate[1][1]--1") 
			if self.isUseTicket == "0" then
				if CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][1]) >= tonumber(self.m_tPetDate[2][1]) 
					or JudgeMoneyIsEnough(70, tonumber(self.m_tPetDate[2][2]),nil,nil,64, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
					WZLog("--self.m_tPetDate[1][1]--2")
					self:sureUseDiamondInstead()
				end
			else
				if CacheCenter:getPlayerItemCountById(self.m_tPetDate[1][1]) >= tonumber(self.m_tPetDate[2][1]) 
					or JudgeMoneyIsEnough(1, tonumber(self.m_tPetDate[2][2]),nil,nil,64, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
					WZLog("--self.m_tPetDate[1][1]--2")
					self:sureUseDiamondInstead()
				end
			end
		end
	end
end

--@Brief    再抽一次礼券不足时候，确定用钻石代替
function WndPetRaffle:sureUseDiamondInstead()
    -- body
    WZLog("WndPetRaffle:sureUseDiamondInstead", self.tag)
    if self.tag == 2 then
        self.n_type = 1
        ProtocolProcessorScenePets:send_PET_Lottery(self.tag)
    elseif self.tag == 3 then 
        GetElement(self.m_root,"conTenButton_WndPetRaffle",WZUIContainer):setVisible(false)
        GetElement(self.m_root,"conTen_WndPetRaffle",WZUIContainer):setVisible(false)
        ProtocolProcessorScenePets:send_PET_Lottery(self.tag)
    end
end


--适配iphoneX
function WndPetRaffle:_AdaptationIphoneX()
    -- body
    WZLog("WndPetRaffle:_AdaptationIphoneX")
    if IsIphoneX() then
		local btnGotoPet = GetElement(self.m_root,"btnGotoPet_WndPetRaffle",WZUIButton)
		btnGotoPet:setRelativePosition(GlobalMethod:ccp(0.9,0.828))
		local btnShowMore = GetElement(self.m_root,"btnShowMore_WndPetRaffle",WZUIButton)
		btnShowMore:setRelativePosition(GlobalMethod:ccp(0.9,0.696))
	end
end

-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配模块Begin--------------------------------------
function WndPetRaffle:_adaptLanguage_en()
	GetElement(self.m_root,"txtPetSPD_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.65,0.5))
	
	GetElement(self.m_root,"txtExcGoods_WndPetRaffle",WZUILabelTTF):setFontSize(18)
	local txtExcGoods2 = GetElement(self.m_root,"txtExcGoods2_WndPetRaffle",WZUILabelTTF)
    txtExcGoods2:setScale(0.7)
    txtExcGoods2:setDimensions(GlobalMethod:CCSize(80))
    txtExcGoods2:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
    local txtExcGoods3 = GetElement(self.m_root,"txtExcGoods3_WndPetRaffle",WZUILabelTTF)
    txtExcGoods3:setScale(0.7)
    txtExcGoods3:setDimensions(GlobalMethod:CCSize(80))
    txtExcGoods3:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
	local txt = GetElement(self.m_root,"txt_WndPetRaffle",WZUILabelTTF)
	txt:setFontSize(20)

	GetElement(self.m_root,"conFreeTime1_WndPetRaffle",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.3,0.0867184))
	GetElement(self.m_root,"conFreeTime2_WndPetRaffle",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.075))

	local txtDrawCouponExplain2 = GetElement(self.m_root,"txtDrawCouponExplain2_WndPetRaffle",WZUILabelTTF)
	txtDrawCouponExplain2:setDimensions(GlobalMethod:CCSize(160))

	GetElement(self.m_root,"txtPetAPD_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.423333,0.5))
	GetElement(self.m_root,"txtPetDPD_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.416667,0.5))
	GetElement(self.m_root,"txtPetHPD_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.35,0.5))
	GetElement(self.m_root,"txtPetSPD_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.683333,0.5))

	local txtExcGoodsCount22 = GetElement(self.m_root, "txtExcGoodsCount22_WndPetRaffle", WZUILabelTTF)
	txtExcGoodsCount22:setScale(0.8)
	txtExcGoodsCount22:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
	GetElement(self.m_root, "imgExchangeGoods2_WndPetRaffle", WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.1,0.5))
	local txtBuy1 = GetElement(self.m_root,"txtBuy1_WndPetRaffle",WZUILabelTTF)
	txtBuy1:setScale(0.8)
	txtBuy1:setRelativePosition(GlobalMethod:ccp(0.521818,0.5))

	local txtExcGoodsCount3 = GetElement(self.m_root,"txtExcGoodsCount3_WndPetRaffle",WZUILabelTTF)
	txtExcGoodsCount3:setScale(0.8)
	txtExcGoodsCount3:setRelativePosition(GlobalMethod:ccp(0.08,0.5))
	GetElement(self.m_root, "imgExchangeGoods3_WndPetRaffle", WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.4,0.5))
	local txtBuy3 = GetElement(self.m_root,"txtBuy3_WndPetRaffle",WZUILabelTTF)
	txtBuy3:setScale(0.8)
	txtBuy3:setRelativePosition(GlobalMethod:ccp(0.753636,0.5))

	local txtBuy2 = GetElement(self.m_root,"txtBuy2_WndPetRaffle",WZUILabelTTF)
    txtBuy2:setScale(0.8)
    txtBuy2:setDimensions(GlobalMethod:CCSize(80))
	local txtBuy4 = GetElement(self.m_root,"txtBuy4_WndPetRaffle",WZUILabelTTF)
	txtBuy4:setScale(0.8)
	txtBuy4:setDimensions(GlobalMethod:CCSize(80))
	
	local txtOneRafAgain = GetElement(self.m_root,"txtOneRafAgain_WndPetRaffle",WZUILabelTTF)
	txtOneRafAgain:setScale(0.8)
	txtOneRafAgain:setDimensions(GlobalMethod:CCSize(140))

	GetElement(self.m_root,"txtGoto_WndPetRaffle",WZUILabelTTF):setScale(0.9)
end

function WndPetRaffle:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtPetSPD_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.76,0.5))
	GetElement(self.m_root,"conFreeTime1_WndPetRaffle",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.4,0.0867184))
	GetElement(self.m_root,"txt_WndPetRaffle",WZUILabelTTF):setFontSize(14)
	GetElement(self.m_root,"txtExcGoods3_WndPetRaffle",WZUILabelTTF):setFontSize(22)

    GetElement(self.m_root,"txtDrawCouponExplain2_WndPetRaffle",WZUILabelTTF):setFontSize(14)

    local txtExcGoods = GetElement(self.m_root,"txtExcGoods_WndPetRaffle",WZUILabelTTF)
    txtExcGoods:setFontSize(18)
    txtExcGoods:setDimensions(GlobalMethod:CCSize(110))

    GetElement(self.m_root,"txtExcGoodsCount1_WndPetRaffle",WZUILabelTTF):setFontSize(18)
    -- GetElement(self.m_root,"txtExcGoodsCount1_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.5))

    local txtExcGoods2 = GetElement(self.m_root,"txtExcGoods2_WndPetRaffle",WZUILabelTTF)
    txtExcGoods2:setFontSize(20)
    txtExcGoods2:setDimensions(GlobalMethod:CCSize(120))
    
    local txtTenRafAgain = GetElement(self.m_root,"txtTenRafAgain_WndPetRaffle",WZUILabelTTF)
    txtTenRafAgain:setScale(0.7)
    txtTenRafAgain:setDimensions(GlobalMethod:CCSize(180))

    local txtBuy2 = GetElement(self.m_root,"txtBuy2_WndPetRaffle",WZUILabelTTF)
    txtBuy2:setScale(0.8)
    txtBuy2:setDimensions(GlobalMethod:CCSize(80))
	local txtBuy4 = GetElement(self.m_root,"txtBuy4_WndPetRaffle",WZUILabelTTF)
	txtBuy4:setScale(0.8)
	txtBuy4:setDimensions(GlobalMethod:CCSize(80))

	local txtExcGoodsCount22 = GetElement(self.m_root, "txtExcGoodsCount22_WndPetRaffle", WZUILabelTTF)
	txtExcGoodsCount22:setScale(0.8)
	txtExcGoodsCount22:setRelativePosition(GlobalMethod:ccp(0.176364,0.5))
	GetElement(self.m_root, "imgExchangeGoods2_WndPetRaffle", WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.1,0.5))
	local txtBuy1 = GetElement(self.m_root,"txtBuy1_WndPetRaffle",WZUILabelTTF)
	txtBuy1:setScale(0.8)
	txtBuy1:setRelativePosition(GlobalMethod:ccp(0.521818,0.5))

	local txtExcGoodsCount3 = GetElement(self.m_root,"txtExcGoodsCount3_WndPetRaffle",WZUILabelTTF)
	txtExcGoodsCount3:setScale(0.8)
	txtExcGoodsCount3:setRelativePosition(GlobalMethod:ccp(0.176364,0.5))
	GetElement(self.m_root, "imgExchangeGoods3_WndPetRaffle", WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.1,0.5))
	local txtBuy3 = GetElement(self.m_root,"txtBuy3_WndPetRaffle",WZUILabelTTF)
	txtBuy3:setScale(0.8)
	txtBuy3:setRelativePosition(GlobalMethod:ccp(0.753636,0.5))
end

function WndPetRaffle:_adaptLanguage_th()
	GetElement(self.m_root,"txtExcGoods2_WndPetRaffle",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtExcGoods3_WndPetRaffle",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtAllName_WndPetRaffle",WZUIFreeTextBox):setMaxWidth(500)

	GetElement(self.m_root,"txtPetAPD_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.423333,0.5))
	GetElement(self.m_root,"txtPetDPD_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.416667,0.5))
	GetElement(self.m_root,"txtPetHPD_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.35,0.5))
	GetElement(self.m_root,"txtPetSPD_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.53,0.5))

	GetElement(self.m_root,"txtTenRafAgain_WndPetRaffle",WZUILabelTTF):setScale(0.9)

	GetElement(self.m_root, "txtExcGoodsCount22_WndPetRaffle", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.267273,0.5))
	GetElement(self.m_root, "imgExchangeGoods2_WndPetRaffle", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.433333,0.5))

	GetElement(self.m_root,"txtExcGoodsCount3_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.221819,0.5))
	GetElement(self.m_root, "imgExchangeGoods3_WndPetRaffle", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.211111,0.5))

	GetElement(self.m_root,"txtBuy4_WndPetRaffle",WZUILabelTTF):setScale(0.9)
	
	GetElement(self.m_root,"txtGoto_WndPetRaffle",WZUILabelTTF):setScale(0.7)

end

function WndPetRaffle:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtExcGoods_WndPetRaffle",WZUILabelTTF):setFontSize(22)
	GetElement(self.m_root,"txtExcGoods2_WndPetRaffle",WZUILabelTTF):setFontSize(20)

	GetElement(self.m_root,"txtPetAPD_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.63,0.5))
	GetElement(self.m_root,"txtPetHPD_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.53,0.5))
	GetElement(self.m_root,"txtPetDPD_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.66,0.5))
	GetElement(self.m_root,"txtPetSPD_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.52,0.5))


    local txtExcGoodsCount1 = GetElement(self.m_root,"txtExcGoodsCount1_WndPetRaffle",WZUILabelTTF)
	txtExcGoodsCount1:setFontSize(18)
	txtExcGoodsCount1:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	txtExcGoodsCount1:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
	GetElement(self.m_root,"imgExchangeGoods1_WndPetRaffle",WZUIImage):setScale(0.7)
	
	GetElement(self.m_root, "txtExcGoodsCount22_WndPetRaffle", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.25,0.5))
	GetElement(self.m_root, "imgExchangeGoods2_WndPetRaffle", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.3,0.5))
	GetElement(self.m_root,"txtBuy1_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.57,0.5))

	GetElement(self.m_root,"txtBuy2_WndPetRaffle",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBuy4_WndPetRaffle",WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root,"txtExcGoodsCount3_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.208182,0.5))
	GetElement(self.m_root, "imgExchangeGoods3_WndPetRaffle", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.0555556,0.5))
end

function WndPetRaffle:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtPetSPD_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.76,0.5))
	GetElement(self.m_root,"conFreeTime1_WndPetRaffle",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.4,0.0867184))
	local txt_WndPetRaffle = GetElement(self.m_root,"txt_WndPetRaffle",WZUILabelTTF)
	txt_WndPetRaffle:setDimensions(GlobalMethod:CCSize(160))
	txt_WndPetRaffle:setFontSize(14)

    GetElement(self.m_root,"txtDrawCouponExplain2_WndPetRaffle",WZUILabelTTF):setFontSize(14)

    local txtExcGoodsCount1 = GetElement(self.m_root,"txtExcGoodsCount1_WndPetRaffle",WZUILabelTTF)
    txtExcGoodsCount1:setScale(0.7)
    txtExcGoodsCount1:setRelativePosition(GlobalMethod:ccp(0.358182,0.5))
	GetElement(self.m_root,"imgExchangeGoods1_WndPetRaffle",WZUIImage):setRelativePosition(GlobalMethod:ccp(1.222222,0.5))
	GetElement(self.m_root,"imgVertical1_WndPetRaffle",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.62091,0.5))
	local txtExcGoods = GetElement(self.m_root,"txtExcGoods_WndPetRaffle",WZUILabelTTF)
    txtExcGoods:setScale(0.7)
    txtExcGoods:setDimensions(GlobalMethod:CCSize(80))
    txtExcGoods:setRelativePosition(GlobalMethod:ccp(0.677272,0.5))

    local txtExcGoods2 = GetElement(self.m_root,"txtExcGoods2_WndPetRaffle",WZUILabelTTF)
    txtExcGoods2:setScale(0.7)
    txtExcGoods2:setDimensions(GlobalMethod:CCSize(80))
    txtExcGoods2:setRelativePosition(GlobalMethod:ccp(0.52,0.5))
    local txtExcGoods3 = GetElement(self.m_root,"txtExcGoods3_WndPetRaffle",WZUILabelTTF)
    txtExcGoods3:setScale(0.7)
    txtExcGoods3:setDimensions(GlobalMethod:CCSize(80))
    txtExcGoods3:setRelativePosition(GlobalMethod:ccp(0.52,0.5))
    
    local txtTenRafAgain = GetElement(self.m_root,"txtTenRafAgain_WndPetRaffle",WZUILabelTTF)
    txtTenRafAgain:setScale(0.7)
    txtTenRafAgain:setDimensions(GlobalMethod:CCSize(180))

    local txtBuy2 = GetElement(self.m_root,"txtBuy2_WndPetRaffle",WZUILabelTTF)
    txtBuy2:setScale(0.8)
    txtBuy2:setDimensions(GlobalMethod:CCSize(80))
	local txtBuy4 = GetElement(self.m_root,"txtBuy4_WndPetRaffle",WZUILabelTTF)
	txtBuy4:setScale(0.8)
	txtBuy4:setDimensions(GlobalMethod:CCSize(80))

	local txtExcGoodsCount22 = GetElement(self.m_root, "txtExcGoodsCount22_WndPetRaffle", WZUILabelTTF)
	txtExcGoodsCount22:setScale(0.8)
	txtExcGoodsCount22:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
	GetElement(self.m_root, "imgExchangeGoods2_WndPetRaffle", WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.1,0.5))
	local txtBuy1 = GetElement(self.m_root,"txtBuy1_WndPetRaffle",WZUILabelTTF)
	txtBuy1:setScale(0.8)
	txtBuy1:setRelativePosition(GlobalMethod:ccp(0.521818,0.5))

	local txtExcGoodsCount3 = GetElement(self.m_root,"txtExcGoodsCount3_WndPetRaffle",WZUILabelTTF)
	txtExcGoodsCount3:setScale(0.8)
	txtExcGoodsCount3:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
	GetElement(self.m_root, "imgExchangeGoods3_WndPetRaffle", WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.1,0.5))
	local txtBuy3 = GetElement(self.m_root,"txtBuy3_WndPetRaffle",WZUILabelTTF)
	txtBuy3:setScale(0.8)
	txtBuy3:setRelativePosition(GlobalMethod:ccp(0.753636,0.5))

	GetElement(self.m_root,"txtOneRafAgain_WndPetRaffle",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"txtGoto_WndPetRaffle",WZUILabelTTF):setScale(0.8)
end

function WndPetRaffle:_adaptLanguage_es(  )
	local txtExcGoods = GetElement(self.m_root,"txtExcGoods_WndPetRaffle",WZUILabelTTF)
	txtExcGoods:setDimensions(GlobalMethod:CCSize(190,0))
	txtExcGoods:setScale(0.55)
	local txtExcGoods3 = GetElement(self.m_root,"txtExcGoods3_WndPetRaffle",WZUILabelTTF)
	txtExcGoods3:setDimensions(GlobalMethod:CCSize(190,0))
	txtExcGoods3:setScale(0.55)
	local txtExcGoods2 = GetElement(self.m_root,"txtExcGoods2_WndPetRaffle",WZUILabelTTF)
	txtExcGoods2:setDimensions(GlobalMethod:CCSize(190,0))
	txtExcGoods2:setScale(0.55)

	local txtDrawCouponExplain2 = GetElement(self.m_root,"txtDrawCouponExplain2_WndPetRaffle",WZUILabelTTF)
    txtDrawCouponExplain2:setScale(0.6)
    txtDrawCouponExplain2:setDimensions(GlobalMethod:CCSize(340,0))

    GetElement(self.m_root,"txtExcGoodsCount1_WndPetRaffle",WZUILabelTTF):setFontSize(18)

    local txtPetAPD = GetElement(self.m_root,"txtPetAPD_WndPetRaffle",WZUILabelTTF)
    txtPetAPD:setRelativePosition(GlobalMethod:ccp(0.56,0.5))

    local txtPetDPD = GetElement(self.m_root,"txtPetDPD_WndPetRaffle",WZUILabelTTF)
    txtPetDPD:setRelativePosition(GlobalMethod:ccp(0.64,0.5))

    local txtPetSPD = GetElement(self.m_root,"txtPetSPD_WndPetRaffle",WZUILabelTTF)
    txtPetSPD:setRelativePosition(GlobalMethod:ccp(0.82,0.5))

    local txtOneRafAgain = GetElement(self.m_root,"txtOneRafAgain_WndPetRaffle",WZUILabelTTF)
	txtOneRafAgain:setDimensions(GlobalMethod:CCSize(190,0))
	txtOneRafAgain:setScale(0.6)
    
    GetElement(self.m_root,"txt_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.216667,0.46))
    GetElement(self.m_root,"txtFreeTime1_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.822222,0.46))

    local txtTenRafAgain = GetElement(self.m_root,"txtTenRafAgain_WndPetRaffle",WZUILabelTTF)
    txtTenRafAgain:setScale(0.7)
    txtTenRafAgain:setDimensions(GlobalMethod:CCSize(180))

    -- GetElement(self.m_root,"txtPetShow1_WndPetRaffle",WZUILabelTTF):setScale(0.8)
    -- GetElement(self.m_root,"txtPetShow2_WndPetRaffle",WZUILabelTTF):setScale(0.8)
    -- GetElement(self.m_root,"txtPetShow3_WndPetRaffle",WZUILabelTTF):setScale(0.8)

    local txtBuy2 = GetElement(self.m_root,"txtBuy2_WndPetRaffle",WZUILabelTTF)
    txtBuy2:setScale(0.8)
    txtBuy2:setDimensions(GlobalMethod:CCSize(80))
	local txtBuy4 = GetElement(self.m_root,"txtBuy4_WndPetRaffle",WZUILabelTTF)
	txtBuy4:setScale(0.8)
	txtBuy4:setDimensions(GlobalMethod:CCSize(80))

	local txtExcGoodsCount22 = GetElement(self.m_root, "txtExcGoodsCount22_WndPetRaffle", WZUILabelTTF)
	txtExcGoodsCount22:setScale(0.8)
	txtExcGoodsCount22:setRelativePosition(GlobalMethod:ccp(0.176364,0.5))
	GetElement(self.m_root, "imgExchangeGoods2_WndPetRaffle", WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.1,0.5))
	local txtBuy1 = GetElement(self.m_root,"txtBuy1_WndPetRaffle",WZUILabelTTF)
	txtBuy1:setScale(0.8)
	txtBuy1:setRelativePosition(GlobalMethod:ccp(0.521818,0.5))

	local txtExcGoodsCount3 = GetElement(self.m_root,"txtExcGoodsCount3_WndPetRaffle",WZUILabelTTF)
	txtExcGoodsCount3:setScale(0.8)
	txtExcGoodsCount3:setRelativePosition(GlobalMethod:ccp(0.149091,0.5))
	GetElement(self.m_root, "imgExchangeGoods3_WndPetRaffle", WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.211111,0.5))
	local txtBuy3 = GetElement(self.m_root,"txtBuy3_WndPetRaffle",WZUILabelTTF)
	txtBuy3:setScale(0.8)
	txtBuy3:setRelativePosition(GlobalMethod:ccp(0.753636,0.5))
end

function WndPetRaffle:_adaptLanguage_ug(  )
	local txtGoto = GetElement(self.m_root,"txtGoto_WndPetRaffle",WZUILabelTTF)
	txtGoto:setScale(0.55)
	txtGoto:setDimensions(GlobalMethod:CCSize(190))

	for i =1, 3 do
		local txtDesc = GetElement(self.m_root,"txtDesc"..i.."_WndPetRaffle",WZUILabelTTF)
		txtDesc:setScale(0.5)
		txtDesc:setDimensions(GlobalMethod:CCSize(460))
		txtDesc:setRelativePosition(GlobalMethod:ccp(0.5,0.58))
	end

	GetElement(self.m_root,"txtExcGoodsCount22_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.927273,0.5))
	GetElement(self.m_root,"conExchangeGoods2_WndPetRaffle",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.751819,0.5))
	GetElement(self.m_root,"txtBuy1_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.353636,0.5))
	GetElement(self.m_root,"conImgBuyGold2_WndPetRaffle",WZUIContainer):setRelativePosition(GlobalMethod:ccp(-0.0527267,0.5))

	GetElement(self.m_root,"txtExcGoodsCount3_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.01728,0.5))
	GetElement(self.m_root,"conExchangeGoods3_WndPetRaffle",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.788182,0.5))
	GetElement(self.m_root,"txtBuy3_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.717272,0.5))
	GetElement(self.m_root,"conImgBuyGold3_WndPetRaffle",WZUIContainer):setRelativePosition(GlobalMethod:ccp(-0.0663635,0.5))

	GetElement(self.m_root,"txtExcGoodsCount1_WndPetRaffle",WZUILabelTTF):setScale(0.6)
	local txtExcGoods = GetElement(self.m_root,"txtExcGoods_WndPetRaffle",WZUILabelTTF)
	txtExcGoods:setDimensions(GlobalMethod:CCSize(210,0))
	txtExcGoods:setScale(0.5)
    GetElement(self.m_root,"txt_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.244444,0.46))
    GetElement(self.m_root,"txtFreeTime1_WndPetRaffle",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.783334,0.46))

    local txtBuy2 = GetElement(self.m_root,"txtBuy2_WndPetRaffle",WZUILabelTTF)
    txtBuy2:setScale(0.6)
    txtBuy2:setDimensions(GlobalMethod:CCSize(110))
	local txtExcGoods2 = GetElement(self.m_root,"txtExcGoods2_WndPetRaffle",WZUILabelTTF)
	txtExcGoods2:setDimensions(GlobalMethod:CCSize(230,0))
	txtExcGoods2:setScale(0.45)
	local txtDrawCouponExplain2 = GetElement(self.m_root,"txtDrawCouponExplain2_WndPetRaffle",WZUILabelTTF)
	txtDrawCouponExplain2:setScale(0.5)
	txtDrawCouponExplain2:setDimensions(GlobalMethod:CCSize(320))

	local txtBuy4 = GetElement(self.m_root,"txtBuy4_WndPetRaffle",WZUILabelTTF)
	txtBuy4:setScale(0.6)
	txtBuy4:setDimensions(GlobalMethod:CCSize(110))
	local txtExcGoods3 = GetElement(self.m_root,"txtExcGoods3_WndPetRaffle",WZUILabelTTF)
	txtExcGoods3:setDimensions(GlobalMethod:CCSize(200,0))
	txtExcGoods3:setScale(0.5)
	txtExcGoods3:setRelativePosition(GlobalMethod:ccp(0.51,0.5))

    local txtTenRafAgain = GetElement(self.m_root,"txtTenRafAgain_WndPetRaffle",WZUILabelTTF)
    txtTenRafAgain:setScale(0.55)
    txtTenRafAgain:setDimensions(GlobalMethod:CCSize(240))
    GetElement(self.m_root,"txtTenReturn1_WndPetRaffle",WZUILabelTTF):setScale(0.65)
    GetElement(self.m_root,"txtTenReturn2_WndPetRaffle",WZUILabelTTF):setScale(0.65)
    GetElement(self.m_root,"txtTenReturn3_WndPetRaffle",WZUILabelTTF):setScale(0.65)
    local txtOneRafAgain = GetElement(self.m_root,"txtOneRafAgain_WndPetRaffle",WZUILabelTTF)
    txtOneRafAgain:setScale(0.55)
    txtOneRafAgain:setDimensions(GlobalMethod:CCSize(240))
    GetElement(self.m_root,"txtReturn2_WndPetRaffle",WZUILabelTTF):setScale(0.65)

    GetElement(self.m_root,"txtShowBtn1_WndPetRaffle",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtShowBtn2_WndPetRaffle",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtShowBtn3_WndPetRaffle",WZUILabelTTF):setScale(0.7)

	local txtPetAP = GetElement(self.m_root,"txtPetAP_WndPetRaffle",WZUILabelTTF)
	txtPetAP:setScale(0.8)
	txtPetAP:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtPetAP:setRelativePosition(GlobalMethod:ccp(1,0.5))
	local txtPetDP = GetElement(self.m_root,"txtPetDP_WndPetRaffle",WZUILabelTTF)
	txtPetDP:setScale(0.8)
	txtPetDP:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtPetDP:setRelativePosition(GlobalMethod:ccp(1,0.5))
	local txtPetHP = GetElement(self.m_root,"txtPetHP_WndPetRaffle",WZUILabelTTF)
	txtPetHP:setScale(0.8)
	txtPetHP:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtPetHP:setRelativePosition(GlobalMethod:ccp(1,0.5))
	local txtPetSP = GetElement(self.m_root,"txtPetSP_WndPetRaffle",WZUILabelTTF)
	txtPetSP:setScale(0.8)
	txtPetSP:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtPetSP:setRelativePosition(GlobalMethod:ccp(1,0.5))
	local txtPetAPD = GetElement(self.m_root,"txtPetAPD_WndPetRaffle",WZUILabelTTF)
	txtPetAPD:setScale(0.8)
	txtPetAPD:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtPetAPD:setRelativePosition(GlobalMethod:ccp(0.636666,0.5))
	local txtPetDPD = GetElement(self.m_root,"txtPetDPD_WndPetRaffle",WZUILabelTTF)
	txtPetDPD:setScale(0.8)
	txtPetDPD:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtPetDPD:setRelativePosition(GlobalMethod:ccp(0.44,0.5))
	local txtPetHPD = GetElement(self.m_root,"txtPetHPD_WndPetRaffle",WZUILabelTTF)
	txtPetHPD:setScale(0.8)
	txtPetHPD:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtPetHPD:setRelativePosition(GlobalMethod:ccp(0.44,0.5))
	local txtPetSPD = GetElement(self.m_root,"txtPetSPD_WndPetRaffle",WZUILabelTTF)
	txtPetSPD:setScale(0.8)
	txtPetSPD:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtPetSPD:setRelativePosition(GlobalMethod:ccp(0.376666,0.5))

end

--适配iphoneX
function WndPetRaffle:_AdaptationIphoneX()
    -- body
    WZLog("WndPetRaffle:_AdaptationIphoneX")
    if IsIphoneX() then
		local imgMidBG = GetElement(self.m_root,"imgMidBG_WndPetRaffle",WZUI9Image)
		imgMidBG:setScaleX(1.25)
	end
end
-------------------------------------语言适配模块End--------------------------------------
