--CellActivityChristmasCarnival.lua
--@brief	CellActivityChristmasCarnival的UI模块
--@date		2020/12/07
--@author	hyc
--@note		圣诞狂欢


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellActivityChristmasCarnival:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellActivityChristmasCarnival:onExit(element)
	self:_unInit()
end

function CellActivityChristmasCarnival:showWindow()
	local hdBg = GetElement(self.m_root,"bg_CellActivityChristmasCarnival",WZUIImage)
	local timeNum = GetElement(self.m_root,"timeNum_cellActivityChristmasCarnival",WZUILabelTTF)
	hdBg:setFile("ui/specialBg/activity_pic_hd_s11.png")
	local DayStartTab = os.date("*t",self.m_startime)
    local DayEndTab = os.date("*t",self.m_endtime)
    local sTimeValue = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    if ProjConfig.LANGUAGE == "vn" then
    	sTimeValue = string.format("%02d:%02d %02d.%02d-%02d:%02d %02d.%02d", DayStartTab.hour, DayStartTab.min, DayStartTab.day, DayStartTab.month, DayEndTab.hour, DayEndTab.min, DayEndTab.day, DayEndTab.month)
    end
 
 	local itemTag = 1
	timeNum:setText(sTimeValue)
	WZLog("CellActivityChristmasCarnival:showWindow", self.m_rewardId[1], self.m_rewardId[2], Serialize(self.m_rewardItem))
	for i = 1, 2 do
		local conSeat = WZUIContainer:luaTo(self.m_root:getChildElement("seat"..i.."_CellActivityChristmasCarnival"))
		conSeat:removeAllChildrenWithCleanup(true)
		local element,tLuaObj = cellChristmasSon:createElement()
		element = WZUIContainer:luaTo(element)
		element:setTag(itemTag)
		conSeat:addChild(element)
		itemTag = itemTag + 1
		local totalTaskNum = 2
		if i == 1 then
			local basicData = GDatatab_item["id_" .. self.m_rewardItem[1]]
			local cellBg = WZUIImage:luaTo(conSeat:getChildElement("cellBg_cellChristmasSon"))
			if cellBg then
				cellBg:setFile("ui/common/common_pic_di_25.png")
			end
			local showImg = WZUIImage:luaTo(conSeat:getChildElement("showImg_cellChristmasSon"))
			local title1 = WZUILabelTTF:luaTo(conSeat:getChildElement("title_cellChristmasSon"))
			title1:setText(LocalStrings.OUT_OF_PRINT_TITLE)
			title1:setStrokeColor(GlobalMethod:ccc3(74,51,198))
			title1:setStrokeSize(4)
			title1:setEnableStroke(true)
			if basicData.main_type == 14 and basicData.sub_type == 16 then 
				showImg:setFile("ui/common_bg/ch_zt_txwm.png")
			else
				showImg:setVisible(false)

				local reward_container = WZUIContainer:luaTo(conSeat:getChildElement("reward_container"))
				reward_container:setVisible(true)
				local rewardBg = WZUIImage:luaTo(conSeat:getChildElement("imgBg_cellChristmasSon"))
				if self.m_rewardItem then
					if basicData then
					    local quality = basicData.quality
						
					    local celElement,tCellLuaObj = CellGoodItem:createElement()
					    tCellLuaObj:setCellGoodLocalId(self.m_rewardItem[i], self.m_rewardCount[i], 17)
					    celElement:setScale(0.8)
						reward_container:addChild(celElement)
						tCellLuaObj:setItemClickFun(CellActivityChristmasCarnival,self.onChristmasRankRewardItemClick)
						rewardBg:setFile(g_tShopItemQuality[quality+1])
						celElement:setUseAbsCoordinate(true)
					end
				end
			end
			local taskNum1 = WZUILabelTTF:luaTo(conSeat:getChildElement("taskNum_cellChristmasSon"))
			taskNum1:setText(string.format("%d/%d",self.m_status[1],totalTaskNum))
			local text1Num1 = WZUILabelTTF:luaTo(conSeat:getChildElement("fristNum_cellChristmasSon"))
			text1Num1:setText(string.format("%d/%d",self.m_target[1],self.m_target[2]))
			local text1Num2 = WZUILabelTTF:luaTo(conSeat:getChildElement("secondNum_cellChristmasSon"))
			text1Num2:setText(string.format("%d/%d",self.m_target[3],self.m_target[4]))
			local text1Num3 = WZUILabelTTF:luaTo(conSeat:getChildElement("thirdNum_cellChristmasSon"))
			text1Num3:setText(string.format("%d/%d",self.m_target[5],self.m_target[6]))
			local text1Num4 = WZUILabelTTF:luaTo(conSeat:getChildElement("fourthNum_cellChristmasSon"))
			text1Num4:setText(string.format("%d/%d",self.m_target[7],self.m_target[8]))

			local btn1 = WZUIButton:luaTo(conSeat:getChildElement("btnGet_cellChristmasSon"))
			local btn1Text = WZUILabelTTF:luaTo(conSeat:getChildElement("btnText_cellChristmasSon"))
			local haveGet1 = WZUIImage:luaTo(conSeat:getChildElement("haveGet_cellChristmasSon"))
			tLuaObj:setMessage(self.m_activityId,self.m_rewardId[1])

			if self.m_status[3] == 0 then
				btn1:setVisible(true)
				btn1:setTouchEnable(true)
				haveGet1:setVisible(false)
		        btn1Text:setStrokeColor(GlobalMethod:ccc3(172,74,20))
		        btn1Text:setColor(GlobalMethod:ccc3(255,250,236))
			elseif self.m_status[3] == -1 then
				btn1:setVisible(true)
				btn1:setTouchEnable(false)
				haveGet1:setVisible(false)
		        btn1Text:setStrokeColor(GlobalMethod:ccc3(80,61,50))
		        btn1Text:setColor(GlobalMethod:ccc3(255,255,255))
			elseif self.m_status[3] == 1 then
				btn1:setVisible(false)
				haveGet1:setVisible(true)
			end
		end

		if i == 2 then
			local cellBg = WZUIImage:luaTo(conSeat:getChildElement("cellBg_cellChristmasSon"))
			if cellBg then
				cellBg:setFile("ui/common/common_pic_di_24.png")
			end
			local showImg2 = WZUIImage:luaTo(conSeat:getChildElement("showImg_cellChristmasSon"))
			showImg2:setVisible(false)
			local reward_container = WZUIContainer:luaTo(conSeat:getChildElement("reward_container"))
			reward_container:setVisible(true)
			local rewardBg = WZUIImage:luaTo(conSeat:getChildElement("imgBg_cellChristmasSon"))
			if self.m_rewardItem then
				local key = "id_"..self.m_rewardItem[2]
				if GDatatab_item[key] then
				    local name = GDatatab_item[key].name
				    local path = GDatatab_item[key].icon
				    local quality = GDatatab_item[key].quality
				    local num = self.m_rewardCount[2]
					local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
				    local celElement,tCellLuaObj = CellGoodItem:createElement()
				    tCellLuaObj:setCellGoodItem(itemInfo, 17)
				    celElement:setScale(0.8)
					reward_container:addChild(celElement)
					tCellLuaObj:setItemClickFun(CellActivityChristmasCarnival,self.onChristmasRankRewardItemClick)
					rewardBg:setFile(g_tShopItemQuality[quality+1])
					celElement:setUseAbsCoordinate(true)
				end
			end

			local title2 = WZUILabelTTF:luaTo(conSeat:getChildElement("title_cellChristmasSon"))
			title2:setStrokeColor(GlobalMethod:ccc3(175,73,70))
			title2:setStrokeSize(4)
			title2:setEnableStroke(true)
			title2:setText(LocalStrings.ACCUMLATED_REBATE)
			local taskNum2 = WZUILabelTTF:luaTo(conSeat:getChildElement("taskNum_cellChristmasSon"))
			taskNum2:setText(string.format("%d/%d",self.m_status[2],totalTaskNum))
			local secondContent = WZUIContainer:luaTo(conSeat:getChildElement("secondContent_cellChristmasSon"))
			secondContent:setVisible(false)
			local fourthContent = WZUIContainer:luaTo(conSeat:getChildElement("fourthContent_cellChristmasSon"))
			fourthContent:setVisible(false)
			local text2Num1 = WZUILabelTTF:luaTo(conSeat:getChildElement("fristNum_cellChristmasSon"))
			text2Num1:setText(string.format("%d/%d",self.m_target[9],self.m_target[10]))
			local text2Num3 = WZUILabelTTF:luaTo(conSeat:getChildElement("thirdNum_cellChristmasSon"))
			text2Num3:setText(string.format("%d/%d",self.m_target[11],self.m_target[12]))

			local btn2 = WZUIButton:luaTo(conSeat:getChildElement("btnGet_cellChristmasSon"))
			local haveGet2 = WZUIImage:luaTo(conSeat:getChildElement("haveGet_cellChristmasSon"))
			local btn2Text = WZUILabelTTF:luaTo(conSeat:getChildElement("btnText_cellChristmasSon"))
			tLuaObj:setMessage(self.m_activityId,self.m_rewardId[2])

			if self.m_status[4] == 0 then
				btn2:setVisible(true)
				btn2:setTouchEnable(true)
				haveGet2:setVisible(false)
		        btn2Text:setStrokeColor(GlobalMethod:ccc3(172,74,20))
		        btn2Text:setColor(GlobalMethod:ccc3(255,250,236))
			elseif self.m_status[4] == -1 then
				btn2:setVisible(true)
				btn2:setTouchEnable(false)
				haveGet2:setVisible(false)
		        btn2Text:setStrokeColor(GlobalMethod:ccc3(80,61,50))
		        btn2Text:setColor(GlobalMethod:ccc3(255,255,255))
			elseif self.m_status[4] == 1 then
				btn2:setVisible(false)
				haveGet2:setVisible(true)
			end
		end
	end
end

function CellActivityChristmasCarnival:onClickRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.CHRISTMAS_CARNIVAL_EXPLAIN)
end

function CellActivityChristmasCarnival:onChristmasRankRewardItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndGameActivity.m_root,1,tData,false,nil,true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellActivityChristmasCarnival:_updateBtn(rewardId)
	-- body
	local item = GetElement(self.m_root,"seat"..rewardId.."_CellActivityChristmasCarnival",WZUIContainer)
	local conSeat = item:getChildByTag(rewardId)
	local btn = WZUIButton:luaTo(conSeat:getChildElement("btnGet_cellChristmasSon"))
	local btnImg = WZUIImage:luaTo(conSeat:getChildElement("haveGet_cellChristmasSon"))
	btn:setVisible(false)
	btnImg:setVisible(true)
end



-------------------------------------私有方法模块End----------------------------------------
