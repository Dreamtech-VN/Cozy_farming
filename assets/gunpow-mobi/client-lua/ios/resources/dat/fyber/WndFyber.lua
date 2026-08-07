--WndFyber.lua
--@brief	WndFyber的UI模块
--@date		2016/12/20
--@author	zhangming
--@note		fyber广告奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFyber:onEnter(element)
	self.m_root = element
	ProtocolProcessorWndTask:regAll()
	
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFyber:onExit(element)
	self:_unInit()
	ProtocolProcessorWndTask:unregAll()
end

--@brief onEnter函数执行完成回调
function WndFyber:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
end

--@brief window的点击事件
function WndFyber:onTouchBegan()
	WndItemInfo:onCloseClick()
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndFyber:setFyberTime()
	local fyberInfo = GDatatab_advertising_reward["id_"..self.n_id]
	local info = {}
	for k,v in pairs(CacheCenter.m_fyberInfo.tData) do
			if v.adId == self.n_id then
				info = v
				break
			end
	end
	GetElement(self.m_root,"txtTimes_WndFyber",WZUILabelTTF):setText(string.format(LocalStrings.FYBER_TIP2,fyberInfo.reward_count-info.rewardCount))
    self.n_fyberTime = GetFyberTime(self.n_id)
    WZLog("WndPractice:setFyberTime:", self.n_fyberTime)
    if self.n_fyberTime > 0 then
        GetElement(self.m_root,"btnFyber_WndFyber",WZUIButton):setTouchEnable(false)
        local conFyber = self.m_root:getChildElement("conFyber_WndFyber")
        conFyber:enableSchedule("updateFyberTime",0.2)
    else
        GetElement(self.m_root,"btnFyber_WndFyber",WZUIButton):setTouchEnable(true)
        GetElement(self.m_root,"txtFyber_WndFyber",WZUILabelTTF):setText(LocalStrings.LOOK_VIDEO)
    end
end

--@brief	更新匹配时间
function WndFyber:updateFyberTime(element,dt)
	self.n_fyberTime = self.n_fyberTime - dt
	WZLog("WndFyber:updateFyberTime:", self.n_fyberTime)  
	local timeTtf = GetElement(self.m_root,"txtFyber_WndFyber",WZUILabelTTF)
	if self.n_fyberTime > 0 then
		local hour,min,sec = WndPetRaffle:numToTime(self.n_fyberTime)
		timeTtf:setText(string.format("cd %0.2d:%0.2d",min,sec))
	else
		timeTtf:setText(LocalStrings.LOOK_VIDEO)
		GetElement(self.m_root,"btnFyber_WndFyber",WZUIButton):setTouchEnable(true)
		local conFyber = self.m_root:getChildElement("conFyber_WndFyber")
		conFyber:disableSchedule()
	end
end

function WndFyber:onFunctionClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local placementId = {"placement_event","placement_benefits","placement_pray","placement_pet","placement_summon","placement_practice"}
	local postData = {}
	postData.funType = "fyber_video"
	postData.value = placementId[self.n_id] or "noId"
	--ProtocolProcessorWndTask:send_TASK_GetADReward(self.n_id)
	PassportSdkManager:Others(postData)
	self.m_nLoadingId = MsgBoxManager:showLoadingBox(60)
end

function WndFyber:finsdhTask(element)
	WZLog("WndFyber:finsdhTask:",self.n_id)
	ProtocolProcessorWndTask:send_TASK_GetADReward(self.n_id)
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

function WndFyber:failTask(element)
	WZLog("WndFyber:failTask:",self.n_id)
	MsgBoxManager:showTipBox(LocalStrings.FYBER_TIP3)
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

function WndFyber:onCloseShow(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFyber:_updateInfo(element)
	WZLog("WndFyber:_updateInfo:", self.n_id)
	self:setFyberTime()
	local fyberInfo = GDatatab_advertising_reward["id_"..self.n_id]
	--清空获得列表
	local tableConLeft = WZUITableContainer:luaTo(self.m_root:getChildElement("tableConReward_WndFyber"))
	tableConLeft:cleanTable()
	WZLog("WndFyber:_updateInfo:", #fyberInfo.reward)
	for i=1,#fyberInfo.reward do
    	local key = "id_"..fyberInfo.reward[i][1]
    	local mNum = fyberInfo.reward[i][2]
    	if GDatatab_item[key] ~= nil then
	        local name = GDatatab_item[key].name
	        local path = GDatatab_item[key].icon
	        local num =  mNum
	        local quality = GDatatab_item[key].quality
	        local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
			local cellElement,tCell = CellGoodItem:createElement()
			tCell:setCellGoodItem(itemInfo,10)
			tCell:setItemClickFun(self,self.onClickCallback2)
			cellElement:setTag(i-1)
			tableConLeft:setCellElement(cellElement)
    	end
	end
end

function WndFyber:onClickCallback2(luaTable,tag,data)
	WZLog("WndFyber:onClickCallback2")
	--local data = self.tData.data
    local other = {interface = 2,tcell = self}
    WndItemInfo:showInfo(luaTable.m_root,WndFyber.m_root,1,data,false,nil,nil,other)
end


-------------------------------------私有方法模块End----------------------------------------
