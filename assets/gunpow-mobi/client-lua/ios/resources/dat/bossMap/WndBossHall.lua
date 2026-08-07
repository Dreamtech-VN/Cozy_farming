--WndBossHall.lua
--@brief	WndBossHall的UI模块
--@date		2014/01/14
--@author	林庆凯
--@note		副本大厅窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBossHall:onEnter(element)
	self.m_root = element
	--彩色喇叭
	ChangeChatChannel(Chat_Channel_FuHall)
	
	--注册副本相关协议
	--ProtocolProcessorBossMap:regAll()
	--多语言版本界面适配
	AdaptLanguage(self)
end

--@brief onEnter函数执行完成回调
function WndBossHall:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndBossHall:actionCallback(element, data)
    self.m_root:enableSchedule("scheduleLoadUI", 0)
end

--@brief    加载界面元素定时器
function WndBossHall:scheduleLoadUI()
    self.m_root:disableSchedule()
    --设置静态UI文本
	self:_setStaticUiText()
    --获取房间列表（BOSSMAPROOM_GetRoomList = 3）
	ProtocolProcessorBossMap:send_BOSSMAPROOM_GetRoomList( )
	self.m_root:enableSchedule("scheduleGetRoomList",5)
    
    
end
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBossHall:onExit(element)
	self:_unInit()
	
end


--@brief	定时器刷新房间列表的函数
--@param #1	element:表绑定的UI节点引用
--@param #2 ,delta  更新的秒数
function WndBossHall:scheduleGetRoomList(element,delta)
	if element == nil then 
		WZLog("WndBossHall:scheduleGetRoomList(element,delta) element is nil ")
		element:disableSchedule()
		return 
	end 
	WZLog("1111")
	--获取房间列表（BOSSMAPROOM_GetRoomList = 3）
	ProtocolProcessorBossMap:send_BOSSMAPROOM_GetRoomList( )
end 


--@brief	关闭按钮点击时被调用的函数
--@param	element:表绑定的UI节点引用
function WndBossHall:onCloseWindowBtn(element)
	if self.m_root ~= nil then 
		--音效
		SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
        WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
		
	end 
end 
--@brief	退出场景时被调用的函数
function WndBossHall:onCloseActionCallback(elem,data)
    WZLog("WndBossHall:onCloseActionCallback",elem,data)
    WindowManager:removeWindow(self.m_root, self, true)
    
end

--@brief	开始副本按钮点击时被调用的函数
--@param	element:表绑定的UI节点引用
function WndBossHall:onStartCopyBtn(element)
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:onCloseWindowBtn(element)
end 


--@brief	查找房间按钮点击时被调用的函数
--@param	element:表绑定的UI节点引用
function WndBossHall:onFindRoomBtn(element)
	WZLog("WndBossHall:onFindRoomBtn(element)")
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndFindRoom = WndFindRoom:createElement()
	if wndFindRoom ~= nil then 
		WindowManager:addWindow(wndFindRoom,WndFindRoom)
		WndFindRoom:setFindBtnCallBack(self.onFindRoomBtnCallBack,self)
	end 
end 

--@brief	查找房间按钮点击时的回调函数
--@brief    sInPutText  输入的文本
function WndBossHall:onFindRoomBtnCallBack(sInPutText)
	if tonumber(sInPutText) == nil then 
		MsgBoxManager:showTipBox(LocalStrings.INPUT_ROOM_ID)
	else
		ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom(tonumber(sInPutText), -1,0 )
	end 
end 

--@brief	快速加入按钮点击时被调用的函数
--@param	element:表绑定的UI节点引用
function WndBossHall:onQuickJoinBtn(element)
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--发送快速游戏协议
	ProtocolProcessorBossMap:send_BOSSMAPROOM_QuickGame()
end 


--@brief	点击单元格背景时被调用的函数
--@param #1 bRoomStatus   当前房间状态（是否已满)
--@param #2 nImgBattleStat  房间战斗状态
--@param #3 nRoomId  房间ID
function WndBossHall:onClickCellBgBtnInCellCopyHallList(bRoomStatus,nImgBattleStat,nRoomId)
	WZLog("WndBossHall:onClickCellBgBtnInCellCopyHallList()")
	WZLog("bRoomStatus = ",bRoomStatus)
	WZLog("nImgBattleStat = ",nImgBattleStat)
	WZLog("nRoomId = ",nRoomId)
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorBossMap:send_BOSSMAPROOM_EnterRoom(nRoomId,0)
	--[[
	if bRoomStatus == true then  	   --房间已满人
		--弹出“房间已满人”
		--MsgBoxManager:showTipBox(LocalStrings.ROOM_ALREADY_FULL_OF_PEOPLE)
	elseif nImgBattleStat == 0 then    --等待中
		--弹出“该房间已进入战斗”
		MsgBoxManager:showTipBox(LocalStrings.
    elseif nImgBattleStat == 1 then    --战斗中
	
	else 
		--跳到副本房间
	end 
	--]]

end 


--@brief	提供给外部跳转到副本大厅的函数
function WndBossHall:onJumpToWndBossHall()
	local  wndBossHall =  WndBossHall:createElement()
	if wndBossHall ~= nil then 
		WindowManager:addWindow(wndBossHall, WndBossHall)
	end 
end 


--@brief	逐帧加载tbconRoomList每个单元格的定时器回调方法
--@param	element:定时器绑定的UI节点引用
--@param	delta:定时器回调间隔
--@note		采用定时器逐帧加载tbconRoomList的每一项(或几项)，防止在同一帧中加载太多数据导致的卡顿以及瞬间的内存脉冲
function WndBossHall:scheduleCreateCell(element, delta)
	if element == nil or self.m_tRoomList.roomId   == nil  then 
		WZLog("WndBossHall:scheduleCreateCell(element, delta) self.m_root is nil ")
		element:disableSchedule()
		return 
	end 	
	if self.m_nCurrentCellIndex >= #self.m_tRoomList.roomId  or self.m_nCurrentCellIndex < 1 then 
		element:disableSchedule()
		return 
	end 

	local tbconRoomList = self.m_root:getChildElement("tbconRoomList_WndBossHall")
	if tbconRoomList ~= nil then 
		tbconRoomList = WZUITableContainer:luaTo(tbconRoomList)
	end
	
	--每帧加载5个单元格
	for var = 1,5 do 
		if self.m_nCurrentCellIndex > #self.m_tRoomList.roomId   then 
			break
		end 
		local celElement,tCell = CellCopyHallList:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement:setTag(self.m_nCurrentCellIndex  - 1)
			tbconRoomList:setCellElement(celElement)
			local peopleNum = tostring(self.m_tRoomList.playerNum[self.m_nCurrentCellIndex] .. "/" ..
							tostring(self.m_tRoomList.playerCountNum[self.m_nCurrentCellIndex]))
			--设置房间信息
			tCell:setRoomInfo(self.m_tRoomList.roomId[self.m_nCurrentCellIndex],
							self.m_tRoomList.nameAndRoomStar[self.m_nCurrentCellIndex],
							peopleNum,self.m_tRoomList.battleStatus[self.m_nCurrentCellIndex])
			--设置房间状态
			tCell:setRoomStatus(self.m_tRoomList.roomStaus[self.m_nCurrentCellIndex])
			
		end 
		self.m_nCurrentCellIndex = self.m_nCurrentCellIndex + 1 
	end 
end 

-------------------------------------公有方法模块End----------------------------------------




-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新表格内容的函数
function WndBossHall:_update()
	if self.m_root == nil then 
		WZLog("WndBossHall:_update() self.m_root is nil ")
		return 
	end 
	
	--设置表格内容
	local tbconRoomList = self.m_root:getChildElement("tbconRoomList_WndBossHall")
	if tbconRoomList ~= nil then 
		tbconRoomList = WZUITableContainer:luaTo(tbconRoomList)
		if tbconRoomList ~= nil then 
			self.m_nCurrentCellIndex = 1
			--开启定时器
			--tbconRoomList:enableSchedule("scheduleCreateCell")
			self.m_root:enableSchedule("scheduleCreateCell")
		end 
	end 

end 


--@brief 设置静态UI文本
function WndBossHall:_setStaticUiText()
	if self.m_root == nil then 
		WZLog(" WndBossHall:_setStaticUiText() self.m_root is nil ")
		return 
	end 
	
	--描边字
	local txtStartCopy = self.m_root:getChildElement("txtStartCopy_WndBossHall")
	if txtStartCopy ~= nil then 
		WZUILabelTTF:luaTo(txtStartCopy):setText(LocalStrings.CREATE_COPY)
	end 
	local txtFindRoom = self.m_root:getChildElement("txtFindRoom_WndBossHall")
	if txtFindRoom ~= nil then 
		WZUILabelTTF:luaTo(txtFindRoom):setText(LocalStrings.FIND_ROOM)
	end 
	local txtQuickJoin = self.m_root:getChildElement("txtQuickJoin_WndBossHall")
	if txtQuickJoin ~= nil then 
		WZUILabelTTF:luaTo(txtQuickJoin):setText(LocalStrings.QUICK_JOIN)
	end 
end 

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配器模块Begin--------------------------------------
--@brief	葡语适配函数
--@note		葡语适配函数
function WndBossHall:_adaptLanguage_pt()
	local txtStartCopy1 = self.m_root:getChildElement("txtStartCopy_WndBossHall") 
	if txtStartCopy1 ~= nil then 
		WZUILabelTTF:luaTo(txtStartCopy1):setFontSize(29)
	end
	

	local txtQuickJoin = self.m_root:getChildElement("txtQuickJoin_WndBossHall")
	if txtQuickJoin ~= nil then 
		WZUILabelTTF:luaTo(txtQuickJoin):setFontSize(30)
	end 
end 

--@brief  越南语适配函数
--@return 无
--@note   备注
function WndBossHall:_adaptLanguage_vn() 
    local txtStartCopy = self.m_root:getChildElement("txtStartCopy_WndBossHall") 	
		  WZUILabelTTF:luaTo(txtStartCopy):setFontSize(25)
	      
	local txtFindRoom = self.m_root:getChildElement("txtFindRoom_WndBossHall")
		  WZUILabelTTF:luaTo(txtFindRoom):setFontSize(25)

	local txtQuickJoin = self.m_root:getChildElement("txtQuickJoin_WndBossHall")	
		  WZUILabelTTF:luaTo(txtQuickJoin):setFontSize(25)
	
end
-------------------------------------语言适配器模块End----------------------------------------
