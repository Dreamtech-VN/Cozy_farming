--WndBlindReward.lua
--@brief	WndBlindReward的UI模块
--@date		2021/03/30
--@author	hyx
--@note		盲盒获取奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBlindReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBlindReward:onExit(element)
	self:_unInit()
end

function WndBlindReward:onEnterTransitionDidFinish(element)
	if self.m_nType == 1 then 
		GetElement(self.m_root, "imgBg_WndBlindReward", WZUIImage):setFile("ui/newActivity/hd_pic_sj_jl.png")
		GetElement(self.m_root, "imgTitle_WndBlindReward", WZUIImage):setFile("ui/newActivity/bt_text_gxhd_2.png")
	end
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndBlindReward:actionCallback()
	local reward_con = GetElement(self.m_root,"reward_con",WZUIContainer)
	local width = reward_con:getContentSize().width * 0.5
	local height = reward_con:getContentSize().height * 0.5
	local start_pos = width-(50 * #self.m_tRewardData)
	local nRewardCount = #self.m_tRewardData
	local start_posTop = nil 
	local heightTop = nil 
	if nRewardCount > 2 then 
		height = reward_con:getContentSize().height * 0.05
		heightTop = reward_con:getContentSize().height * 0.95
		start_posTop = width-(50 * (nRewardCount - 2))
		start_pos = width-(50 * 2)
	end
	for i = 1, nRewardCount do
		local key = "id_"..self.m_tRewardData[i].id
		if GDatatab_item[key] then
		    local name = GDatatab_item[key].name
		    local path = GDatatab_item[key].icon
		    local quality = GDatatab_item[key].quality
		    local num = self.m_tRewardData[i].num
			local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		    local celElement,tLuaObj = CellGoodItem:createElement()
		    tLuaObj:setCellGoodItem(itemInfo, 17)
			reward_con:addChild(celElement)
			tLuaObj:setItemClickFun(WndBlindReward,self.onItemClick)
			celElement:setAnchorPoint(GlobalMethod:ccp(0,0.5))
			celElement:setUseAbsCoordinate(true)
			if nRewardCount <= 2 then 
				celElement:setAbsPosition(GlobalMethod:ccp(start_pos + (90*(i-1)),height))
			else
				if i <= 2 then 
					celElement:setAbsPosition(GlobalMethod:ccp(start_pos + (90*(i-1)),height))
				else
					celElement:setAbsPosition(GlobalMethod:ccp(start_posTop + (90*(i - 2 - 1)), heightTop))
				end
			end
		end
	end
	local data = {
		path = "ui/otherUI/ui_common_Manghe",
		play = "wait_4",
		loop = true,
		ccp = GlobalMethod:ccp(0.5,0.2)
	}
	if self.m_nType == 0 then 
		local existSpine = CheckEffectFile(data.path)
		if existSpine then 
			createEffectSpine(self.m_root,data)
		else
			local _sIndex = "ui_common_Manghe"
	        local downloadInfo = GetDownloadInfo(_sIndex, "uiEffect")
	        if downloadInfo then 
	        	DownloadManager:addDownloadTask(14100,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
	        end
		end
	end
	self:showOtherData()
end

function WndBlindReward:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndBlindReward.m_root,1,tData,false,nil,true)
end

function WndBlindReward:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		if self.m_tCallBackFun then 
			self.m_tCallBackFun[2](self.m_tCallBackFun[1])
		end
	elseif nTag == 2 then 
		local tab = {}
		tab.openIndex = self.m_tOtherData.openIndex
		tab.times = 1

		local strTab = json.encode(tab)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7009, 2, strTab)
	elseif nTag == 3 then 
		local tab = {}
		tab.openIndex = self.m_tOtherData.openIndex
		local nTimes = self.m_tOtherData.openTime >= self.m_tOtherData.maxTimes and self.m_tOtherData.maxTimes or self.m_tOtherData.openTime
		tab.times = nTimes

		local strTab = json.encode(tab)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7009, 2, strTab)
	end
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	盲盒
function WndBlindReward:showOtherData()
	if not self.m_tOtherData then return end 

	local btnRecv = GetElement(self.m_root, "btnRecv_WndBlindReward", WZUIButton)
	local btnOpenOne = GetElement(self.m_root, "btnOpenOne_WndBlindReward", WZUIButton)
	local btnOpenFive = GetElement(self.m_root, "btnOpenFive_WndBlindReward", WZUIButton)

	local txtOpenOne = GetElement(self.m_root, "txtOpenOne_WndBlindReward", WZUILabelTTF)
	local txtOpenFive = GetElement(self.m_root, "txtOpenFive_WndBlindReward", WZUILabelTTF)
	local ftxtLeftOpenTimes = GetElement(self.m_root, "ftxtLeftOpenTimes_WndBlindReward", WZUIFreeTextBox)
	local strTemp = string.gsub(LocalStrings.BLIND_TEXT6, "127,70,26", "255,236,193")
	ftxtLeftOpenTimes:setShowText(string.format(strTemp, self.m_tOtherData.openTime, self.m_tOtherData.activeCount))
	ftxtLeftOpenTimes:setVisible(true)
	if self.m_tOtherData.openTime > 0 then 
		btnOpenOne:setVisible(true)
		btnOpenFive:setVisible(true)
		btnRecv:setRelativePosition(GlobalMethod:ccp(0.9, -0.1))

		txtOpenOne:setText(string.format(LocalStrings.BLIND_TEXT2[3], 1))
		local tmpTime = math.min(self.m_tOtherData.openTime, self.m_tOtherData.maxTimes)
		txtOpenFive:setText(string.format(LocalStrings.BLIND_TEXT2[3], tmpTime))
	else
		btnOpenOne:setVisible(false)
		btnOpenFive:setVisible(false)
		btnRecv:setRelativePosition(GlobalMethod:ccp(0.505, -0.1))
	end 
end


-------------------------------------私有方法模块End----------------------------------------
