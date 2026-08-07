--WndDollMachineReward.lua
--@brief	WndDollMachineReward的UI模块
--@date		2021/05/13
--@author	hyx
--@note		娃娃机奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDollMachineReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDollMachineReward:onExit(element)
	self:_unInit()
end
function WndDollMachineReward:showInterface(_type,reward_data,index)
	local wndReward = WndDollMachineReward:createElement(_type,reward_data,index)
	if wndReward ~= nil then
	    WindowManager:addWindow(wndReward,WndDollMachineReward,nil,false)
	end
end
function WndDollMachineReward:onEnterTransitionDidFinish(element)
	self:_setBallAni()
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndDollMachineReward:actionCallback()
	self:initShow()
end
function WndDollMachineReward:initShow()
	local reward_com1 = GetElement(self.m_root,"reward_com1",WZUIContainer)
	local reward_com5 = GetElement(self.m_root,"reward_com5",WZUIContainer)
	local reward_id = {}
	local reward_num = {}
	local str = ""
	
	if self.m_nIndex == 1 then
		if next(self.m_tRewardData.fItemIds) ~= nil then
			reward_id = self.m_tRewardData.fItemIds
			reward_num = self.m_tRewardData.fItemNums
			str = LocalStrings.ACTIVITY_TEXT18
		elseif next(self.m_tRewardData.sItemIds) ~= nil then
			reward_id = self.m_tRewardData.sItemIds
			reward_num = self.m_tRewardData.sItemNums
			str = LocalStrings.ACTIVITY_TEXT19
		end
	elseif self.m_nIndex == 2 then
		if self.m_nType == 5 then
			str = LocalStrings.ACTIVITY_TEXT18..LocalStrings.YOUWAN_TEXT3..LocalStrings.ACTIVITY_TEXT19
			reward_id[1] = self.m_tRewardData.fItemIds[1]
			reward_num[1] = self.m_tRewardData.fItemNums[1]

			reward_id[2] = self.m_tRewardData.sItemIds[1]
			reward_num[2] = self.m_tRewardData.sItemNums[1]
		else
			if self.m_nCurIndex == 1 then
				reward_id = self.m_tRewardData.fItemIds
				reward_num = self.m_tRewardData.fItemNums
				str = LocalStrings.ACTIVITY_TEXT18
			elseif self.m_nCurIndex == 2 then
				reward_id = self.m_tRewardData.sItemIds
				reward_num = self.m_tRewardData.sItemNums
				str = LocalStrings.ACTIVITY_TEXT19
			end
		end
	end
	local reward_com = nil
	if self.m_nType == 1 then
		reward_com = reward_com1
		reward_com1:setVisible(true)
		local good_con = GetElement(reward_com1,"good_con1",WZUIContainer)
		local info = GDatatab_item["id_"..reward_id[1]]
		if info then
			local itemInfo = {lastTime=reward_num[1],lastNum=reward_num[1],basicInfo=CopyTable(info)}
			if self.m_sRewardCellItem == nil then
			    local celElement,tLuaObj = CellGoodItem:createElement()
			    self.m_sRewardCellItem = tLuaObj
			    good_con:addChild(celElement)
			end
			if self.m_sRewardCellItem then
			    self.m_sRewardCellItem:setCellGoodItem(itemInfo, 17)
				self.m_sRewardCellItem:setItemClickFun(WndDollMachineReward,self.onItemClick)
			end
		end
	elseif self.m_nType == 5 then
		reward_com = reward_com5
		reward_com5:setVisible(true)
		local common_con = GetElement(reward_com5,"common_con",WZUIContainer)
		local num = #self.m_tRewardData.itemIds
		local space = 5
		local width = (350*0.5) - (85*0.5)*num+(space*num)
		for i=1,num do
			local info = GDatatab_item["id_"..self.m_tRewardData.itemIds[i]]
			local itemInfo = {lastTime=self.m_tRewardData.itemNums[i],lastNum=self.m_tRewardData.itemNums[i],basicInfo=CopyTable(info)}
		    local celElement,tLuaObj = CellGoodItem:createElement()
		    tLuaObj:setCellGoodItem(itemInfo, 17)
			common_con:addChild(celElement)
			celElement:setAnchorPoint(ccp(0,0.5))
			tLuaObj:setItemClickFun(WndDollMachineReward,self.onItemClick)

			celElement:setUseAbsCoordinate(true)
			celElement:setAbsPosition(GlobalMethod:ccp(width+(i-1)*90,40))
		end
		for i=1, self.m_nIndex do
			local good_con = GetElement(reward_com5,"good_con"..i,WZUIContainer)
			if self.m_nIndex == 1 then
				good_con:setRelativePosition(GlobalMethod:ccp(0.5, 0.245))
			end
			good_con:setVisible(true)
			local info = GDatatab_item["id_"..reward_id[i]]
			if info then
				local itemInfo = {lastTime=reward_num[i],lastNum=reward_num[i],basicInfo=CopyTable(info)}
			    local celElement,tLuaObj = CellGoodItem:createElement()
			    good_con:addChild(celElement)
			    tLuaObj:setCellGoodItem(itemInfo, 17)
				tLuaObj:setItemClickFun(WndDollMachineReward,self.onItemClick)
			end
		end
		self.m_nIndex = 1
	end
	local txtDesc = GetElement(reward_com,"txtDesc",WZUIFreeTextBox)
	txtDesc:setShowText(string.format(LocalStrings.ACTIVITY_TEXT17,str))
end

function WndDollMachineReward:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndDollMachineReward.m_root,1,tData,false,nil,true)
end

function WndDollMachineReward:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurIndex == self.m_nIndex then
		pushEquipInList()
		WindowManager:removeWindow(self.m_root, self, true)
	else
		self.m_nCurIndex = self.m_nCurIndex + 1
		self:initShow()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置待机特效
function WndDollMachineReward:_setBallAni()
	local spinePath = "activity/ui_common_wwjts"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineWait1 = GetElement(self.m_root, "spineWait1_WndDollMachineReward", WZUISpine)
		local spineWait2 = GetElement(self.m_root, "spineWait2_WndDollMachineReward", WZUISpine)
		local spineWait3 = GetElement(self.m_root, "spineWait3_WndDollMachineReward", WZUISpine)
		if spineWait1 then 
			spineWait1:setFileJson(spinePath .. ".json")
			spineWait1:setFileAtlas(spinePath .. ".atlas")
			spineWait1:play("wait_1", false)
		end
		if spineWait2 then 
			spineWait2:setFileJson(spinePath .. ".json")
			spineWait2:setFileAtlas(spinePath .. ".atlas")
			spineWait2:play("wait_1", false)
		end
		if spineWait3 then 
			spineWait3:setFileJson(spinePath .. ".json")
			spineWait3:setFileAtlas(spinePath .. ".atlas")
			spineWait3:play("wait_1", false)
		end
	else
		local _sIndex = "ui_common_wwjts"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7010, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndDollMachineReward)
        end
	end
end

function WndDollMachineReward:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndDollMachineReward:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end




-------------------------------------私有方法模块End----------------------------------------
