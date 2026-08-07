--WndGuest.lua
--@brief	WndGuest的UI模块
--@date		2014/5/14
--@author	林庆凯
--@note     结婚宾客列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGuest:onEnter(element)
	self.m_root = element
	
	if self.m_tBackFun == nil then
		--创建弹出框
		local popupMenu = WndPopupMenu:createElement()
		self.m_root:addChild(popupMenu)	
	end
    self:_setPassWordStatic() -- 设置密码开关
    self:_setpassWordBtnStaic()
    if self.m_bIsHomeowner == false then
    	WZUIContainer:luaTo(self.m_root:getChildElement("conBottom_WndGuest")):setVisible(false)
    end

    self:_udpateJoinList()
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGuest:onExit(element)
	self:_unInit()
end

--@brief	设置确认选定异性好友的回调函数
--@param	fun:函数的变量,obj:表对象
function WndGuest:setSexFriendCallBackFun(fun,obj)
    self.m_sexFriendCallBackFun = fun
    self.m_tCallBackLuaObject = obj
end

--@brief	关闭整个WndFriendImpl窗口的函数
function WndGuest:onClickCloseWindow()
	if self.m_root ~= nil then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

		if self.m_tBackFun then
			self.m_tBackFun[2](self.m_tBackFun[1])
		end
		WindowManager:removeWindow(self.m_root, WndGuest, true)
	end 
end 


--@brief	设置密码的函数
function WndGuest:onSetPasspordBtn(element)
    WZLog("WndGuest:onSetPasspordBtn(element)")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local wndIntoMerry = WndIntoMerry:createElement()
    if self.m_bIsHomeowner then
    	WndIntoMerry:setPass(self.m_sHallPass)
    end
    
    if wndIntoMerry then
       WindowManager:addWindow(wndIntoMerry,WndIntoMerry)
    end

end


--@brief   打开设置密码界面
function WndGuest:openPassWord()
    WZLog("WndGuest:onClickcheckPasspord")
    local wndIntoMerry = WndIntoMerry:createElement()
    if wndIntoMerry then
        WindowManager:addWindow(wndIntoMerry,WndIntoMerry)
    end

end


--@brief	显示消息框窗口的函数
--@param	#1 element,点击cell那个对象本身
--@param	#2 tButtonRoot  点击Button那个对象本身
--@param    #3 sCurCellName     当前点击名字
--@param    #4 nCurCellPlayerId  当前点击选手ID
function WndGuest:onClickCellBtn(element,tButtonRoot,sCurCellName,nCurCellPlayerId)
	if element == nil and self.m_root == nil then 
		return 
	end 
	self.m_sCurCellName = sCurCellName
	self.m_nCurCellPlayerId  = nCurCellPlayerId
	local playerName = sCurCellName
	local playerId = nCurCellPlayerId
	self:onClickWinowIndMarry(element)
    
end 



--@brief	点击结婚礼堂时来宾窗口时函数   
function WndGuest:onClickWinowIndMarry(element)
	WZLog("WndGuest:onClickWinowIndMarry(element)")
	self.m_tPopupMenuItems = {}
	self.m_tPopupMenuItems[1] = POPUPMENU_INFO          --查看资料
	if self.m_bIsHomeowner == true then
		self.m_tPopupMenuItems[2] = POPUPMENU_KICKEDOUT     --房主踢人功能
	end
	--self.m_tPopupMenuItems[1] = POPUPMENU_ADD 			--添加好友
	--self.m_tPopupMenuItems[2] = POPUPMENU_MAIL          --发送邮件
	--self.m_tPopupMenuItems[3] = POPUPMENU_CHAT          --私聊
	--self.m_tPopupMenuItems[4] = POPUPMENU_INFO          --查看资料
    --self.m_tPopupMenuItems[5] = POPUPMENU_KICKEDOUT     --房主踢人功能
	WndPopupMenu:setPopupMenuItem(self.m_tPopupMenuItems)
	WndPopupMenu:setCallBackFunc(self, self.onClickPopupMenuItemByMarry)

	--转换触摸点坐标
	local cell = element:getParentElement()
	local x = cell:getPositionX()
	local y = cell:getPositionY()
	position = cell:convertToWorldSpace(GlobalMethod:ccp(x, y))
	WZLog(position.x, position.y)
	position = self.m_root:convertToNodeSpace(position)
	WZLog(position.x, position.y)
	--wndMessage:setPosition(position)
	if self.m_root ~= nil then 
		WndPopupMenu:popUpAtPoint(self.m_root, position)
	end 
end 



--@brief  结婚礼堂按钮回调函数
--@param #1 element:点击消息框的窗口对象
--@param #2	nId:点击消息框的那个ID，如私聊，发送邮件，查看资料，黑名单，删除等
function WndGuest:onClickPopupMenuItemByMarry(element,nId)
	if element == nil or nId == nil then
		WZLog("WndGuest:onClickPopupMenuItem(element,nId) element,nId == nil ")
		return 
	end
	if nId == POPUPMENU_ADD   then   	    --添加好友
        ProtocolProcessorWndFriend:send_FRIEND_AddFriendNew(self.m_nCurCellPlayerId)
	elseif nId == POPUPMENU_MAIL then 		--发送邮件
		local wndMail = WndMail:createElement()
		WindowManager:addWindow(wndMail, WndMail)
		WndMail:setFriendDataInterface(self.m_sCurCellName, "") 
	elseif nId == POPUPMENU_CHAT then 		--私聊
        WndChat:showChatWindowForPrivateWithIdAndName(self.m_nCurCellPlayerId,self.m_sCurCellName)
	elseif nId == POPUPMENU_INFO then       --查看资料
        WndCheckOther:show(self.m_nCurCellPlayerId)
    elseif  nId == POPUPMENU_KICKEDOUT then --踢出房间
        ProtocolProcessorSceneWeddingChurch:send_WEDDING_PleaseOut(self.m_nCurCellPlayerId, SceneWeddingChurch.m_nWeddingNo )
	end 
	WindowManager:removeWindow(self.m_root, WndGuest, true)
end 



--@brief	设置点击单元格时选中的回调函数
--@param	fun:函数的变量,obj:表对象
function WndGuest:setClickCellCallBackFun(fun,obj)
    self.m_clickCellCallBackFun = fun
    self.m_tCallBackLuaObject = obj
end



--@brief	触摸函数，判断消息是否在消息框显示范围内，如果不是的话，就让消息框不显示，反之，显示
--@param #1	element:表绑定的UI节点引用
--@param #2	point:点击位置
function WndGuest:onTouchBegan(element, point)
	if self.m_root == nil then 
		WZLog("WndFriend:onTouchBegan(element, point) self.m_root is nil ")
	end 

	local bFlag = WndPopupMenu:ifPointInMenu(point)
	if bFlag == false then 
		WndPopupMenu:disappear()
	end 
end

--@brief	逐帧加载tbconContainer每个单元格的定时器回调方法(宾客列表)
--@param	element:定时器绑定的UI节点引用
--@param	delta:定时器回调间隔
--@note		采用定时器逐帧加载tbconContainer的每一项(或几项)，防止在同一帧中加载太多数据导致的卡顿以及瞬间的内存脉冲
function  WndGuest:ScheduleCreateGuestCell(element, delta)
	WZLog("WndGuest:ScheduleCreateGuestCell")
	element:disableSchedule()
	if #self.m_tCurList <= 0 then
		GetElement(self.m_root,"txtTip_WndGuest",WZUILabelTTF):setVisible(true)
	end
	local nCountList = #self.m_tCurList
	--每帧加载5个单元格
	for var = 1,nCountList do
		local celElement,tCell = CellGuestNumList:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement:setTag(var - 1)	
			--设置玩家在线状态
			tCell:setFlagOnLine(true)
			--从服务器取的的等级是整型要转成string型
			tCell:setCellContent(self.m_tCurList[var].level,
								self.m_tCurList[var].sex,
								self.m_tCurList[var].playerName,
								self.m_tCurList[var].haedId,
								self.m_tCurList[var].faceId,
								self.m_tCurList[var].vipLevel,
								self.m_tCurList[var].headColor
								)
			--设置玩家ID
			tCell:setPlayerId(self.m_tCurList[var].playerId)
			element:setCellElement(celElement)
		end 
		self.m_nCurrentCellIndex = self.m_nCurrentCellIndex + 1
	end 
end

--@brief	是否使用密码
--@param	index:checkbax的索引,0为不选中,1为选中
function WndGuest:_getPassWordStatic()
    if self.m_root == nil then
       return
    end
    local selPassWord = self.m_root:getChildElement("checkSelPasspord_WndGuest")
    if selPassWord == nil then
       return
    end
    selPassWord = WZUICheckBox:luaTo(selPassWord)
    local index = selPassWord:getCheckIndex()
    return index
end


--@brief	背景音乐checkbax的点击函数
--@param	element:表绑定的UI节点引用
function WndGuest:onClickcheckPasspord( element )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndSetting:onBackMusicClick:")
    --获取背景音乐checkbax的索引
    local index = self:_getPassWordStatic()
    --选中状态，由于控件的状态是回调后才改变，所以需要取反
    if index == 0  then
       self:openPassWord()
       --SceneWeddingChurch.m_bsetOpenPassWord = 1
       WZUIButton:luaTo(GetElement(self.m_root,"btnSetPasspordBtn_WndGuest")):setTouchEnable(true)
    else
       --SceneWeddingChurch.m_bsetOpenPassWord = 0
       WZUIButton:luaTo(GetElement(self.m_root,"btnSetPasspordBtn_WndGuest")):setTouchEnable(false)
       ProtocolProcessorSceneWeddingChurch:send_WEDDING_SetPassword(false, "", SceneWeddingChurch.m_nWeddingNo)
       self:_setpassWordBtnStaic()
    end

end

function WndGuest:_setPassWordStatic()
	-- body
    WZLog("WndGuest:_setPassWordStatic() = ",self.m_sHallPass)
    if self.m_sHallPass  ~= nil and string.len(self.m_sHallPass) > 0 then
        WZUICheckBox:luaTo(GetElement(self.m_root,"checkSelPasspord_WndGuest")):setCheckIndex(1)
    else
    	WZUICheckBox:luaTo(GetElement(self.m_root,"checkSelPasspord_WndGuest")):setCheckIndex(0)
    end
end


function WndGuest:_setpassWordBtnStaic() 
    if self.m_sHallPass  ~= nil and string.len(self.m_sHallPass) > 0 then 
       WZUIButton:luaTo(GetElement(self.m_root,"btnSetPasspordBtn_WndGuest")):setTouchEnable(true)
    else
       WZUIButton:luaTo(GetElement(self.m_root,"btnSetPasspordBtn_WndGuest")):setTouchEnable(false)
    end

end

-------------------------------------公有方法模块End----------------------------------------





-------------------------------------私有方法模块Begin--------------------------------------
--@brief 更新来宾列表的函数
function WndGuest:_udpateJoinList()
	WZLog("WndGuest:_udpateJoinList")
	if self.m_root == nil then
		WZLog("WndGuest:_udpateJoinList() self.m_root is nil")
		return 
	end 
	WZLog("self.m_root not nil")
	self.m_nCurrentCellIndex = 1
	self.m_tCurList = self.m_tGuestList

    GetElement(self.m_root,"conTxtContent_WndGuest",WZUIContainer):setVisible(true)
    GetElement(self.m_root,"tbconContent_WndGuest",WZUITableContainer):enableSchedule("ScheduleCreateGuestCell")
   
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------

function WndGuest:_adaptLanguage_en()
    WZLog("WndGuest:_adaptLanguage_en")
    local btnSetPasspordBtn = GetElement(self.m_root,"btnSetPasspordBtn_WndGuest",WZUIButton)
    btnSetPasspordBtn:setAbsContentSize(GlobalMethod:CCSize(156,62))
    btnSetPasspordBtn:updateRelativeSize()
    btnSetPasspordBtn:setRelativePosition(GlobalMethod:ccp(0.363454,0.548984))

    GetElement(self.m_root,"txtSetPasspord1_WndGuest",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtSetPasspord2_WndGuest",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtSetPasspord3_WndGuest",WZUILabelTTF):setScale(0.75)
end

function WndGuest:_adaptLanguage_pt(  )
	local btnSetPasspordBtn = GetElement(self.m_root,"btnSetPasspordBtn_WndGuest",WZUIButton)
    btnSetPasspordBtn:setAbsContentSize(GlobalMethod:CCSize(156,62))
    btnSetPasspordBtn:updateRelativeSize()
    btnSetPasspordBtn:setRelativePosition(GlobalMethod:ccp(0.363454,0.548984))
end


function WndGuest:_adaptLanguage_vn()
    WZLog("WndGuest:_adaptLanguage_vn")
    local btnSetPasspordBtn = GetElement(self.m_root,"btnSetPasspordBtn_WndGuest",WZUIButton)
    btnSetPasspordBtn:setAbsContentSize(GlobalMethod:CCSize(136,62))
    btnSetPasspordBtn:updateRelativeSize()
    btnSetPasspordBtn:setRelativePosition(GlobalMethod:ccp(0.393454,0.548984))

    for i = 1, 3 do
        local txtSetPasspordName = string.format("txtSetPasspord%d_WndGuest",i)
        local txtSetPasspord = GetElement(self.m_root,txtSetPasspordName,WZUILabelTTF)
        txtSetPasspord:setScale(0.82)
    end
end

function WndGuest:_adaptLanguage_th()
    GetElement(self.m_root,"txtSetPasspord1_WndGuest",WZUILabelTTF):setScale(0.85)
    GetElement(self.m_root,"txtSetPasspord2_WndGuest",WZUILabelTTF):setScale(0.85)
    GetElement(self.m_root,"txtSetPasspord3_WndGuest",WZUILabelTTF):setScale(0.8)
end
    
function WndGuest:_adaptLanguage_tr()
    GetElement(self.m_root,"txtUsePasspord_WndGuest",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtSetPasspord1_WndGuest",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtSetPasspord2_WndGuest",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtSetPasspord3_WndGuest",WZUILabelTTF):setScale(0.8)
end

function WndGuest:_adaptLanguage_es(  )
	local txtUsePassport = GetElement(self.m_root,"txtUsePasspord_WndGuest",WZUILabelTTF)
	txtUsePassport:setDimensions(GlobalMethod:CCSize(100,0))
	txtUsePassport:setFontSize(16)
	txtUsePassport:setRelativePosition(GlobalMethod:ccp(0.85,0.531925))

	for i=1,3 do
		local txtSend = GetElement(self.m_root,"txtSetPasspord"..i.."_WndGuest",WZUILabelTTF)
		txtSend:setDimensions(GlobalMethod:CCSize(130,0))
		txtSend:setScale(0.8)
	end
end
-------------------------------------语言适配模块End----------------------------------------



