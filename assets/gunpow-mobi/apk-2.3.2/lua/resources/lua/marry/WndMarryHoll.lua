--WndMarryHoll.lua
--@brief	WndMarryHoll的UI模块
--@date		2014/04/21
--@author	LQK
--@modify   qixiang_xie
--@note		结婚礼堂模块

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMarryHoll:onEnter(element)
	self.m_root = element

	-- self:_addTop()

	AdaptLanguage(self)
    
	ProtocolProcessorMarryHoll:regAll()
	self:_update()

	-- local isEndTeach, finishStep = TeachGroup1:isTeachFinish(24)
    -- WZLog("WndMarryHoll:onEnter", isEndTeach, finishStep)
    -- if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 21 then
    --     TeachGroup1:startGroup({24,2,self.m_root})
    -- else
        -- WindowManager:removeTeachShelterLayer()
    -- end
end

--弹窗动画
-- function WndMarryHoll:onEnterTransitionDidFinish(element)
-- 	WindowManagerAni:createAction(self.m_root,false,"actionCallback",self)
-- end


-- --@brief  弹窗动画结束回调
-- function WndMarryHoll:actionCallback(elem,data)
--   self:_update()
-- end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMarryHoll:onExit(element)
	self:_unInit()
	-- WndMarryManager:unInitManager()
end

function WndMarryHoll:onCloseActionCallback(elem,data)
	-- body
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndMarryHoll:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_jh.png",WndMarryHoll,WndMarryHoll.onCloseActionCallback,true,true,true,"WndMarryHoll")
end

--@brief	点击婚礼列表按钮的响应方法
--@param	element:按钮的引用
function WndMarryHoll:onWeddingListBtn(element)
	WZLog(" WndMarryHoll:onWeddingListBtn(element)")
	local isEndTeach, finishStep = TeachGroup1:isTeachFinish(24)
	if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 21 and WindowManager:isHaveTeachTouchLayer() then
		TeachGroup1:endTeachStep({24,2})
		TeachGroup1:startGroup({24,3,self.m_root})
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if CheckButtonOpen(194) then
		WndMarryManager:createLoading()
		--获得婚礼列表（WEDDING_GetWedList = 16）
		ProtocolProcessorMarryHoll:send_WEDDING_GetWedList()
	end
end 
--跳转到结婚礼堂界面
function WndMarryHoll:jumpWeddingAssemblyHall()
	if CheckButtonOpen(194) then
		WndMarryManager:createLoading()
		ProtocolProcessorMarryHoll:send_WEDDING_GetWedList()
	end
end

--@brief	点击求婚按钮的响应方法
--@param	element:按钮的引用
function WndMarryHoll:onMarryPurposeBtn(element)
	WZLog(" WndMarryHoll:onMarryPurposeBtn(element) ---- ")  
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if CheckButtonOpen(193) then
	    local tPlayer = CacheCenter:getPlayerInfo()
	    local maxlevel = GDatatab_button_info["id_8"].open_level
	    
	    maxlevel = tonumber(maxlevel)
	    
	    if tPlayer then
	    	if tPlayer.zsLevel ~= nil and tPlayer.zsLevel == 1 then
	    		WndMarry:showInterface(self.m_nDivorceTime)
	    	elseif tPlayer.level >= maxlevel then
	    		WndMarry:showInterface(self.m_nDivorceTime)
	    	elseif tPlayer.level < maxlevel  then
	    		MsgBoxManager:showTipBox(string.format(LocalStrings.ACTIVE_NOLEVEL,maxlevel))
	    	end
	    else
	    	local maxdesc = maxlevel .. LocalStrings.OPAN_FOR_LEVEL
	    	MsgBoxManager:showTipBox(maxdesc)
	    end
	end
end 

--@brief	点击婚礼详情按钮的响应方法
--@param	element:按钮的引用
function WndMarryHoll:onWeddingSituationBtn(element)
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	-- ProtocolProcessorWndMarry:send_WEDDING_GetMarryInfo()
	-- WndMarryManager:createLoading()
	-- SceneMarryWedding:showInterface()
    local wndMarryBetrothed = WndMarryBetrothed:createElement()
    WindowManager:addWindow(wndMarryBetrothed, WndMarryBetrothed,nil,nil,nil,true)
	
end 

--@brief	点击举办婚礼按钮的响应方法
--@param	element:按钮的引用
function WndMarryHoll:onAddWeddingBtn(element)
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
    local wndMarryBetrothed = WndMarryBetrothed:createElement()
    WindowManager:addWindow(wndMarryBetrothed, WndMarryBetrothed,nil,nil,nil,true)
end 

--@brief 	点击小家按钮回调
function WndMarryHoll:onKidSituationBtn(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if CheckButtonOpen(145) then
		SceneKidHome:showInterface(CacheCenter:getPlayerInfo().id)
	end
end

--@brief	点击交友按钮回调
function WndMarryHoll:onMakeFriend(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if CheckButtonOpen(146) then
		WndMatchmaking:showInterface()
	end
end


--@brief	更新结婚开始时间的函数	
--@param  #1  element 结婚开始时间控件对象本身
--@param  #2  delta   秒数
function WndMarryHoll:ScheduleMarryStartTime(element,delta)
	--WZLog("WndMarryHoll:ScheduleMarryStartTime(element,delta)")
	--WZLog("self.m_nMyWeddingTime = ",self.m_nMyWeddingTime)
	if self.m_nMyWeddingTime == nil or self.m_nMyWeddingTime <= 0  and element ~= nil then 
		WZUIContainer:luaTo(GetElement(self.m_root,"conWeddingStart_WndMarryHoll")):setVisible(false)
		element:disableSchedule()
		return 
	end 
	
	delta = delta - delta%1 
	self.m_nMyWeddingTime = self.m_nMyWeddingTime - delta/1 
	--秒数转换成时钟格式的字符串
	local sTxtMyWeddingTime = self:secondConverToHourFormat(self.m_nMyWeddingTime)
	--WZLog("sTxtWeddingTime = ",sTxtMyWeddingTime)
	---时间倒计时
	local txtMarryStartTime = self.m_root:getChildElement("txtMarryStartTime_WndMarryHoll")
	if txtMarryStartTime == nil then 
		WZLog("txtMarryStartTime is nil")
		return 
	end 
	WZUILabelTTF:luaTo(txtMarryStartTime):setText(sTxtMyWeddingTime)	
end 	



--@brief  秒数转换成时钟格式的函数
--@param  秒数 
--@return 时钟格式字符串
--@note   如1548 + 3600* 3 转换成 03:25:48 
function WndMarryHoll:secondConverToHourFormat(nSeconds)
	if nSeconds == 0 then 
		return  
	end 
	
	local nHour = nSeconds/(60*60)
	--取整数
	nHour = nHour - nHour%1 
	if nHour >= 1 then 
		nSeconds = nSeconds - nHour*3600 
	end 
	local nMinutes = nSeconds/60 
	nMinutes = nMinutes - nMinutes%1 
	nSeconds = nSeconds - nMinutes*60 
	if nHour < 10 then 
		nHour = "0" .. nHour
	end 
	if nMinutes < 10 then 
		nMinutes = "0" .. nMinutes 
	end
	if nSeconds < 10 then 
		nSeconds = "0" .. nSeconds 
	end 
	return nHour .. ":" .. nMinutes  .. ":" .. nSeconds
end

--@brief 跳转到本窗口的UI
--@param #1 nTag 结婚显示标记 0为未婚，1为举办婚礼，2为结婚详情
--@param #2 nMyWedTime 我的婚礼开始时间
function WndMarryHoll:onShowItemInfo(nTag,nMyWedTime, divorceTime, divorceCDTime)
	WZLog("WndMarryHoll:onShowItemInfo ",self.m_root)
	if self.m_root == nil then 
		WZLog("WndMarryHoll:onShowItemInfo(nTag,nMyWedTime)")
		return 
	end 

	WZLog("nTag = ",nTag)
	if nTag == 0 then 
		ChangeChatChannel(Chat_Channel_Marry_N)
		WZLog("nTag = ",nTag)
		--没有结婚
		WZUIContainer:luaTo(GetElement(self.m_root,"conMarryPurpose_WndMarryHoll")):setVisible(true)
		WZUIContainer:luaTo(GetElement(self.m_root,"conAddWedding_WndMarryHoll")):setVisible(false)
		WZUIContainer:luaTo(GetElement(self.m_root,"conWeddingSituation_WndMarryHoll")):setVisible(false)
	elseif nTag == 1 or (nTag ==2  and nMyWedTime > 0 or nMyWedTime ==0) then 
		--举办婚礼
		ChangeChatChannel(Chat_Channel_Wedding_Marriage)
		WZUIContainer:luaTo(GetElement(self.m_root,"conAddWedding_WndMarryHoll")):setVisible(true)
		WZUIContainer:luaTo(GetElement(self.m_root,"conMarryPurpose_WndMarryHoll")):setVisible(false)
		WZUIContainer:luaTo(GetElement(self.m_root,"conWeddingSituation_WndMarryHoll")):setVisible(false)
	else
		ChangeChatChannel(Chat_Channel_Wedding_Couple)
		WZUIContainer:luaTo(GetElement(self.m_root,"conAddWedding_WndMarryHoll")):setVisible(false)
		WZUIContainer:luaTo(GetElement(self.m_root,"conMarryPurpose_WndMarryHoll")):setVisible(false)
		--结婚详情
		WZUIContainer:luaTo(GetElement(self.m_root,"conWeddingSituation_WndMarryHoll")):setVisible(true)
		if GlobalGame.g_tRedPointList.marry then
            GetElement(self.m_root,"imgRedPoint_WndMarryHoll",WZUIImage):setVisible(true)
	    else
	        GetElement(self.m_root,"imgRedPoint_WndMarryHoll",WZUIImage):setVisible(false)
	    end 
	end
	self.m_nMyWeddingTime = nMyWedTime
	self.m_nDivorceTime = divorceTime
	self.m_nDivorceCDTime = divorceCDTime
	if self.m_nMyWeddingTime ~= nil and self.m_nMyWeddingTime  > 0 then 
		self:_setMyWeddingStartTimeVisable(true)
	end 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndMarryHoll:_update()
	-- body
end


--@brief 设置婚礼时间是否显示的函数 
--@param bFlag  是否显示
function WndMarryHoll:_setMyWeddingStartTimeVisable(bFlag)
	WZLog("WndMarry:_setMyWeddingStartTimeVisable(bFlag)")
	if self.m_root == nil then 
		WZLog("WndMarry:_setMyWeddingStartTimeVisable()")
		return 
	end 

	WZUIContainer:luaTo(GetElement(self.m_root,"conWeddingStart_WndMarryHoll")):setVisible(bFlag)
	local sTimeText = self:secondConverToHourFormat(self.m_nMyWeddingTime)
	local  txtMarryStartTime = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtMarryStartTime_WndMarryHoll"))
	txtMarryStartTime:setText(sTimeText)
	txtMarryStartTime:enableSchedule("ScheduleMarryStartTime",1)	
end











-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function WndMarryHoll:_adaptLanguage_es(  )
	local txtMarryStartNotice = GetElement(self.m_root,"txtMarryStartNotice_WndMarryHoll",WZUILabelTTF)
	txtMarryStartNotice:setDimensions(GlobalMethod:CCSize(160))
	txtMarryStartNotice:setRelativePosition(GlobalMethod:ccp(-0.268293,0.5))
end

function WndMarryHoll:_adaptLanguage_ug(  )
	GetElement(self.m_root,"txtMarryPurpose1_WndMarryHoll",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtAddWedding1_WndMarryHoll",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtKid2_WndMarryHoll",WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root,"txtMarryStartTime_WndMarryHoll",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.43,0.5))
end

function WndMarryHoll:_adaptLanguage_vn(  )
	local txtFatherTalk = GetElement(self.m_root,"txtFatherTalk_WndMarryHoll",WZUILabelTTF)
	txtFatherTalk:setScale(0.7)
end
---------------------------------------语言适配End------------------------------------------