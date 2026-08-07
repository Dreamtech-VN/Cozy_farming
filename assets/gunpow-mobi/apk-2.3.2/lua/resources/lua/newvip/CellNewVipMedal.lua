--CellNewVipMedal.lua
--@brief	CellNewVipMedal的UI模块
--@date		2021/03/22
--@author	hyx
--@note		贵族勋章


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewVipMedal:onEnter(element)
	self.m_root = element
	self:register()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewVipMedal:onExit(element)
	self:_unInit()
	self:unregister()
end

function CellNewVipMedal:register()
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_MedalInfo,self._onGetMedalInfo,self)
end
function CellNewVipMedal:unregister()
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_MedalInfo,self._onGetMedalInfo,self)
end

function CellNewVipMedal:onEnterTransitionDidFinish(element)
	self:initShow()
end

function CellNewVipMedal:initShow()
	self:setMedalData()
	ProtocolProcessorWndRankList:send_PLAYER2_GetVipMedalInfo( )	
end

function CellNewVipMedal:onBtnLevelGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	ProtocolProcessorWndRankList:send_PLAYER2_ReceiveVipMedalLevelReward(self.m_tCurRewardData.id )
end

function CellNewVipMedal:onBtnClickAllReward()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local reward = CellMedalAllReward:createElement(self.m_tAllRewardData)
	if reward then
		WindowManager:addWindow(reward,CellMedalAllReward,nil,false)
	end
end

function CellNewVipMedal:setMedalLevelData(lev, point)
	if not GDatatab_vip_medal_level then
		return
	end
	local nTempLev = lev 
	for i = 1, lev do
		if self.m_tAllRewardData[i].status == 0 and nTempLev > i then 
			nTempLev = i
		end
	end
	local data = GDatatab_vip_medal_level["id_"..nTempLev]
	self.m_tCurRewardData = data
	local tCurLevelData = GDatatab_vip_medal_level["id_"..lev]
	if not data then return end

	local txtLevReward = GetElement(self.m_root,"txtLevReward",WZUILabelTTF)
	txtLevReward:setText(string.format(LocalStrings.NEWVIP_TEXT24,nTempLev))

	local medalProgressBar = GetElement(self.m_root,"medalProgressBar",WZUIProgress)
	local txtProgressCount = GetElement(self.m_root,"txtProgressCount",WZUILabelTTF)
	txtProgressCount:setText(point.."/"..tCurLevelData.point)
	medalProgressBar:setPercentage(point/tCurLevelData.point * 100)

	GetElement(self.m_root,"txtCurLevel",WZUILabelTTF):setText(lev)

	local imgLevelIcon = GetElement(self.m_root,"imgLevelIcon",WZUIImage)
	local str_icon = tCurLevelData.icon
	local bExist = WZFileUtil:isFileExist(str_icon)
	if not bExist then
		str_icon = "shopitems/icon_xzdj_01.png"
	end
	imgLevelIcon:setFile(str_icon)

	local item_con = GetElement(self.m_root,"item_con",WZUIContainer)
	local key = "id_"..data.reward[1][1]
	if GDatatab_item[key] then
	    local name = GDatatab_item[key].name
	    local path = GDatatab_item[key].icon
	    local quality = GDatatab_item[key].quality
	    local num = data.reward[1][2]
	    local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
	    if self.m_sLevelRewardItem == nil then
	    	local celElement,tLuaObj = CellGoodItem:createElement()
	    	tLuaObj:setItemClickFun(self, self.onClickItem)
	    	item_con:addChild(celElement)
	    	self.m_sLevelRewardItem = tLuaObj
		end
	    self.m_sLevelRewardItem:setCellGoodItem(itemInfo, 17)
	end

	--领取按钮状态
	local btnLevelGet = GetElement(self.m_root,"btnLevelGet",WZUIButton)
	if self.m_tAllRewardData[nTempLev].status == -1 then
		btnLevelGet:setTouchEnable(false)
	elseif self.m_tAllRewardData[nTempLev].status == 0 then
		btnLevelGet:setTouchEnable(true)
	elseif self.m_tAllRewardData[nTempLev].status == 1 then
		btnLevelGet:setTouchEnable(false)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellNewVipMedal:_onGetMedalInfo(medalStages, medalLevel, medalPoint, levelIds, levelRewardStatus)
	local medalItemTabContainer = GetElement(self.m_root,"medalItemTabContainer",WZUITableContainer)
	medalItemTabContainer:cleanTable()
	WZLog("CellNewVipMedal:_onGetMedalInfo", Serialize(medalStages))
	for i=1, #medalStages do
		local element, tNewObj = MedalBadgeItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			medalItemTabContainer:setCellElement(element)
			tNewObj:setMedalItemData(self.m_tMedalData[i],medalStages[i],i)
		end
	end
	self.m_nCurLevel = medalLevel
	self.m_nCurPoint = medalPoint
	self:setAllGetReward(levelIds, levelRewardStatus)
	self:setMedalLevelData(medalLevel, medalPoint)
end

function CellNewVipMedal:onClickItem(tItem, nTag, tData)
    if self.m_root == nil then return end
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end



-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function CellNewVipMedal:_adaptLanguage_vn()
	local txtAllReward1 = GetElement(self.m_root,"txtAllReward1_CellNewVipMedal",WZUILabelTTF)
	txtAllReward1:setFontSize(22)
	local txtAllReward2 = GetElement(self.m_root,"txtAllReward2_CellNewVipMedal",WZUILabelTTF)
	txtAllReward2:setFontSize(22)
	local txtAllReward3 = GetElement(self.m_root,"txtAllReward3_CellNewVipMedal",WZUILabelTTF)
	txtAllReward3:setFontSize(22)
end
-------------------------------------语言适配End----------------------------------------

