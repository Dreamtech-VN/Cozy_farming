--WndActivityLimitLogin.lua
--@brief	WndActivityLimitLogin的UI模块
--@date		2021/04/30
--@author	hyx
--@note		限时登录


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndActivityLimitLogin:onEnter(element)
	self.m_root = element
	self:register()
	ProtocolProcessorFestivalActivity:regAll6()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndActivityLimitLogin:onExit(element)
	self:_unInit()
	self:unregister()
	ProtocolProcessorFestivalActivity:unregAll()
end
function WndActivityLimitLogin:showInterface()
	local wndLogin = WndActivityLimitLogin:createElement()
	if wndLogin ~= nil then
	    WindowManager:addWindow(wndLogin,WndActivityLimitLogin,nil,false)
	end
end
function WndActivityLimitLogin:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetLimitLoginInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetLimitLoginResult,self)
end
function WndActivityLimitLogin:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetLimitLoginInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetLimitLoginResult,self)
end
function WndActivityLimitLogin:onEnterTransitionDidFinish(element)
	self:_setBallAni()
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndActivityLimitLogin:actionCallback()
	self:initShow()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7013, 7013)
end
function WndActivityLimitLogin:initShow()
	
end

function WndActivityLimitLogin:onBtnLeft()
	if next(self.m_tLimitLoginData) == nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if (self.m_nCurIndex-1) < 1 then
		return
	end
	
	self.m_nCurIndex = self.m_nCurIndex - 1
	self:setChangeReward(self.m_nCurIndex)
end
function WndActivityLimitLogin:onBtnRight()
	if next(self.m_tLimitLoginData) == nil then return end

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if (self.m_nCurIndex+1) > #self.m_tLimitLoginData then
		return
	end
	
	self.m_nCurIndex = self.m_nCurIndex + 1
	self:setChangeReward(self.m_nCurIndex)
end

function WndActivityLimitLogin:setChangeReward(index)
	if not self.m_tLimitLoginData[index] then return end
	local btnLeft = GetElement(self.m_root,"btnLeft",WZUIButton)
	local btnRight = GetElement(self.m_root,"btnRight",WZUIButton)
	btnLeft:setVisible(true)
	btnRight:setVisible(true)
	if index <= 1 then
		btnLeft:setVisible(false)
	elseif index >= #self.m_tLimitLoginData then
		btnRight:setVisible(false)
	end
	GetElement(self.m_root,"txtDay",WZUILabelTTF):setText(string.format(LocalStrings.ACTIVITY_TEXT22,LocalStrings.COMMUNITYWARHISTORY_NUMBER[index]))
	for i,v in pairs(self.m_tCellLimitLoginItem) do
		if v and v.item then
			v.item:setVisible(false)
			v.get_icon:setVisible(false)
		end
		if v and v.spine then
			v.spine:setVisible(false)
		end
	end
	local good_con = GetElement(self.m_root,"good_con",WZUIContainer)
	local ids = self.m_tLimitLoginData[index].reward_id
	local nums = self.m_tLimitLoginData[index].reward_num
	for i=1, #ids do
		if self.m_tCellLimitLoginItem[i] == nil then
			local cellElement, tNewObj = CellGoodItem:createElement()
			good_con:addChild(cellElement)

			local spine = WZUISpine:create()
		   	spine:setTouchEnable(false)
		   	spine:setFileJson("ui/ui_common_JJLQ.json")
		   	spine:setFileAtlas("ui/ui_common_JJLQ.atlas")
		   	spine:setUseOriginSize(true)
		   	spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
			spine:play("wait_1",true)
		   	cellElement:addChild(spine,1)
		   	spine:setVisible(false)

		   	local get_icon = WZUIImage:create()
	        get_icon:setAnchorPoint(ccp(0.5,0.5))
	        get_icon:setRelativePosition(ccp(0.5,0.5))
	        get_icon:setUseOriginSize(true)
	        get_icon:setFile("ui/common/commom_text_ylq.png")
	        cellElement:addChild(get_icon, 10)
	        get_icon:setVisible(false)

			local tab = {}
			tab.item = cellElement
			tab.obj = tNewObj
			tab.spine = spine
			tab.get_icon = get_icon
			self.m_tCellLimitLoginItem[i] = tab
		end
		local obj = self.m_tCellLimitLoginItem[i].obj
		if obj then
			local info = GDatatab_item["id_"..ids[i]]
			if info then
			    local itemInfo = {id=ids[i], name=info.name,icon=info.icon,lastNum=nums[i],quality=info.quality,basicInfo=CopyTable(info)}
			    obj:setCellGoodItem(itemInfo,17)
			    obj:setItemClickFun(self,self.onItemClick)
			    if self.m_tLimitLoginData[index].status == 1 then
				    self.m_tCellLimitLoginItem[i].get_icon:setVisible(true)
			    end
			    self.m_tCellLimitLoginItem[i].item:setAbsPosition(GlobalMethod:ccp(50+(90 * (i-1)),45))
			    self.m_tCellLimitLoginItem[i].item:setVisible(true)

			    if self.m_tLimitLoginData[index].status == 0 then
			    	if self.m_tCellLimitLoginItem[i].spine then
					    self.m_tCellLimitLoginItem[i].spine:setVisible(true)
					end
			    else
			    	if self.m_tCellLimitLoginItem[i].spine then
					    self.m_tCellLimitLoginItem[i].spine:setVisible(false)
					end
			    end
		    end	    
		end
	end

end
function WndActivityLimitLogin:onItemClick(tCell,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if tData == nil then
        return
    end
    if self.m_tLimitLoginData[self.m_nCurIndex] and self.m_tLimitLoginData[self.m_nCurIndex].status == 0 then
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(g_cityExtenInfo.activity7013, self.m_tLimitLoginData[self.m_nCurIndex].day)
    else
		WndItemInfo:showInfo(tCell.m_root,WndActivityLimitLogin.m_root,1,tData,false,nil,true)	
	end
end

function WndActivityLimitLogin:onBtnRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.ACTIVITY_TEXT21)
end
function WndActivityLimitLogin:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndActivityLimitLogin:_onGetLimitLoginInfo( activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips )
	if activityId == tonumber(g_cityExtenInfo.activity7013) then
		self.m_tLimitLoginData = CellNewYearSign:setSignData(rewardId,status,rewardItems,rewardItemsParamCount,rewardCounts)
		-- 判断是第几天的
		local index = 1
		local bIsIn = false 
		for i=1,#self.m_tLimitLoginData do
			if self.m_tLimitLoginData[i].status == 0 then
				if self.m_tLimitLoginData[i].day >= index then
					index = self.m_tLimitLoginData[i].day
					bIsIn = true 
				end
			end
		end
		--没有领取的时候
		if not bIsIn then
			for i=1,#self.m_tLimitLoginData do
				if self.m_tLimitLoginData[i].status == -1 then
					index = self.m_tLimitLoginData[i].day
					break
				end
			end
		end
		self.m_nCurIndex = index
		local activity_time = GetElement(self.m_root,"txtActivityTime",WZUILabelTTF)
		local _start = SystemTime:getTimeConverLocal(startTime)
		local _end = SystemTime:getTimeConverLocal3(endTime)
		activity_time:setText(_start.."-".._end)

		self:setChangeReward(self.m_nCurIndex)
	end
end
function WndActivityLimitLogin:_onGetLimitLoginResult(itemsId, count, _type, rewardId)
	WndRewardShow:showById(itemsId, count)
	if self.m_tLimitLoginData then
		self.m_tLimitLoginData[rewardId].status = 1
		self:setChangeReward(rewardId)
	end
end

--@brief 	设置待机特效
function WndActivityLimitLogin:_setBallAni()
	local spinePath = "activity/ui_common_sc"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineWait = GetElement(self.m_root, "spineWait_WndActivityLimitLogin", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath .. ".json")
			spineWait:setFileAtlas(spinePath .. ".atlas")
			spineWait:play("wait_2", true)
		end
	else
		local _sIndex = "ui_common_sc"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7013, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndActivityLimitLogin)
        end
	end
end

function WndActivityLimitLogin:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndActivityLimitLogin:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end
-------------------------------------私有方法模块End----------------------------------------
