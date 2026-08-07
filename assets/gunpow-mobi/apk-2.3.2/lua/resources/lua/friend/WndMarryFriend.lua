
--@brief	WndMarryFriend的UI模块
--@date		2014/03/26
--@author	liangguang_long
--@note		附近好友模块

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMarryFriend:onEnter(element)
	self.m_root = element
	CacheCenter:registerFriendListObserver(self)
	self:addMenu()
	WZLog("self.m_nInterface::",self.m_nInterface)
	self:_showMultiLanguage()
	self:showInfaceterType()
	if self.m_nInterface == 5 then 
		ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,1)
	else 
		ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,3)
	end 
    AdaptLanguage(self)
end

function WndMarryFriend:init()
	
end

--@brief	加载动画
function WndMarryFriend:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAction(self.m_root,true,"onActionFinish",self)
    AdaptLanguage(self)
end

--@brief	动画完成
function WndMarryFriend:onActionFinish()
end

--@brief   创建加载框
function WndMarryFriend:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndMarryFriend:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMarryFriend:onExit(element)
	CacheCenter:unregisterFriendListObserver(self)
	self:_unInit()
end

--@brief	关闭按钮回调事件
function WndMarryFriend:onBackClick(element)
	WZLog("关闭按钮回调事件")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	--WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	关闭按钮回调事件
function WndMarryFriend:onCloseActionCallback(element,data)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	规则
function WndMarryFriend:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.Propose_Desc)
end

function WndMarryFriend:onBeginTouch(element,pt)
	local bFlag = WndPopupMenu:ifPointInMenu( pt )--关闭菜单
	if bFlag == false then 
		WndPopupMenu:disappear()
	end 
end

function WndMarryFriend:onShowFriend(element)
	if self.m_root == nil or self.m_tFriend == nil then
		return 
	end

    element = WZUITableContainer:luaTo(element)
    element:cleanTable()
    
	for i = 1, self.m_nCurNeedLoadNum do 
    	local celElement, tCell = CellMarryFriend:createElement()
    	celElement:setTag(self.m_nCurTag)
    	self:getCurFrame():setCellElement(celElement)
    	tCell:setBackFun(self,self.onFriendClick,self.onSelectItemClick)
    	tCell:setCellData(self.m_tFriend[self.m_nCurLoadIndex],self.m_nInterface)

    	self.m_nFriendsTableIndex = self.m_nFriendsTableIndex + 1
    	self.m_nCurLoadIndex = self.m_nCurLoadIndex + 1
    	self.m_nCurTag = self.m_nCurTag + 1
    end

    self:_setLoadMoreVisible()
    self:getCurFrame():getMoveElement():setPositionY(self:getCurFrame():getMinPosition().y)
end

--@brief	点击上一页触发函数
--@param	element:表绑定的UI节点引用
function WndMarryFriend:onPageUp(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_bUpPageShowLastPosition = true
    local tbconFriend = self:getCurFrame()

    if self.m_tFriend and self:_getUpPage() then 
        local nAddNum = self.m_nDisplayedNum
        if nAddNum > EACHTIME_LOAD_NUM then
            nAddNum = EACHTIME_LOAD_NUM 
        end
        
        --在前面添加的好友
        self.m_nCurPageIndex = self.m_nCurPageIndex - 1
		self.m_nCurNeedLoadNum = nAddNum 			
		self.m_nCurLoadIndex = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum + 1
		self.m_nCurTag = 0 
		self.m_nFriendsTableIndex = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum	
		self:onShowFriend(tbconFriend)
    end
end

--@brief	点击下一页触发函数
--@param	element:表绑定的UI节点引用
function WndMarryFriend:onPageDown(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tbconFriend = self:getCurFrame()

    if self.m_tFriend and self:_getDownPage() then 
        local nAddNum = #self.m_tFriend - self.m_nFriendsTableIndex
        if nAddNum > EACHTIME_LOAD_NUM then
            nAddNum = EACHTIME_LOAD_NUM 
        end
        
        --添加后面几个好友
        self.m_nCurPageIndex = self.m_nCurPageIndex + 1 
		self.m_nCurNeedLoadNum = nAddNum 			
		self.m_nCurLoadIndex = self.m_nFriendsTableIndex + 1 	
        self.m_nCurTag = 0 		
		self:onShowFriend(tbconFriend)
    end
end

--@brief 	上拉显示更多是否可见
function WndMarryFriend:_setLoadMoreVisible()
    -- body
    local tbconFriend = self:getCurFrame()
    if self:_getUpPage() then
        --Begin:翻页效果2
        WZLog("WndMarryFriend:_setLoadMoreVisible 00000")
        local elementTop = tbconFriend:getTopElement()
        tbconFriend:setEnableDropRefresh(false)
        tbconFriend:setHideTopElement(false)--设置topElement是否隐藏
        tbconFriend:setEnableTopElement(true)--设置TopElement是否可用
        if not elementTop then
        	WZLog("WndMarryFriend:_setLoadMoreVisible 11111")
        	local ttf = WZUILabelTTF:create()
	        ttf:setText(LocalStrings.UP_TO_LOAD_MORE)
	        ttf:setFontSize(22)
	        ttf:setUseOriginSize(true)
	        ttf:setColor(GlobalMethod:ccc3(255,236,193))
	        tbconFriend:setTopNotice(LocalStrings.DOWN_TO_LOAD_MORE, LocalStrings.RELAX_TO_LOAD)
        	tbconFriend:setTopElementFunction("onPageUp")--设置TopElement的Lua回调函数
        	tbconFriend:setVisibleHeight(30)
        	tbconFriend:setTopElement(ttf)--设置容器的TopElement对象
        end
        --End
    else
    	WZLog("WndMarryFriend:_setLoadMoreVisible 22222")
        tbconFriend:setEnableDropRefresh(false)
        tbconFriend:setEnableTopElement(false)
        tbconFriend:setHideTopElement(true)
    end
    if self:_getDownPage() then
        --Begin:翻页效果2
        WZLog("WndMarryFriend:_setLoadMoreVisible 33333")
        local elementDown = tbconFriend:getBottomElement()
        tbconFriend:setEnableDagLoading(false)
        tbconFriend:setEnableBottomElement(true) --设置BottomElement是否可用
        tbconFriend:setHideBottomElement(false) --设置bottomElement是否隐藏
        if not elementDown then
        	WZLog("WndMarryFriend:_setLoadMoreVisible 44444")
        	local ttf = WZUILabelTTF:create()
	        ttf:setText(LocalStrings.UP_TO_LOAD_MORE)
	        ttf:setFontSize(22)
	        ttf:setColor(GlobalMethod:ccc3(255,236,193))
	        ttf:setUseOriginSize(true)
	        tbconFriend:setBottomNotice(LocalStrings.UP_TO_LOAD_MORE, LocalStrings.RELAX_TO_LOAD)
	        tbconFriend:setBottomElementFunction("onPageDown")  --设置BottomElement的Lua回调函数
	        tbconFriend:setVisibleHeight(30)
	        tbconFriend:setBottomElement(ttf) --设置容器的BottomElement对象
	    end
        --End
    else 
    	WZLog("WndMarryFriend:_setLoadMoreVisible 55555")
        tbconFriend:setEnableDagLoading(false)
        tbconFriend:setEnableBottomElement(false)
        tbconFriend:setHideBottomElement(true)
    end
end

--@brief	好友点击回调
function WndMarryFriend:onFriendClick(tCell,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nFriendTag = self:_getFriendTag(tData)--tag
	local x , y = tCell.m_root:getPosition()
	local pt = tCell.m_root:convertToWorldSpace( GlobalMethod:ccp(x , y) )
	pt = self.m_root:convertToNodeSpace( pt )
	--设置菜单显示的位置
	WndPopupMenu:popUpAtPoint( self.m_root , pt )
end

--@brief   	
function WndMarryFriend:onSelectItemClick(tCell,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local count = #self:getListData()
	local nIndex = self:_getCellElement(tag):getIndex()
	if self.m_nInterface == 1 then  --发送请柬
		local imgSelected_WndMarryFriend = GetElement(self.m_root,"imgSelected_WndMarryFriend",WZUI9Image)
		if self.m_root == nil or self:getListData() == nil or self:_checkSingle() == false then
			if nIndex == 0 then 
				self.m_nAllSize = self.m_nAllSize - 1
				if imgSelected_WndMarryFriend:isVisible() then 
					imgSelected_WndMarryFriend:setVisible(false)
				end 
			else 
				if self.m_nAllSize < count then 
					self.m_nAllSize = self.m_nAllSize + 1
					if self.m_nAllSize == count then 
						if imgSelected_WndMarryFriend ~= nil then 
							imgSelected_WndMarryFriend:setVisible(true)  
						end
					end 
				end 
			end 
			return
		end
	end 
	for i=0,count-1 do 
		if i ~= tag then
			local tCell = self:_getCellElement(i)
			if tCell and tCell:getIndex() == 1 then 
				tCell:setChoicesItem(nIndex) 
			end 
		end
	end
end

--@brief   	菜单列表回调函数
--@param   	element:菜单列表的节点
--@param   	nId:菜单列表的ID
function WndMarryFriend:onClickMenuItem(element , nId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tFriend = self:getListData()[self.m_nFriendTag]
	if nId == POPUPMENU_INFO then			--查看资料8
		WndCheckOther:show(tFriend.id)
	end
	--关闭菜单
	WndPopupMenu:disappear()
end

--@brief   创建加载弹出菜单
function WndMarryFriend:addMenu()
	if self.m_root == nil then
		return
	end
	local popupMenuElement = WndPopupMenu:createElement()
	self.m_root:addChild( popupMenuElement )
	--默认显示弹出框的内容
	self.m_tPopupMenuItems = {}
	self.m_tPopupMenuItems[1] = POPUPMENU_INFO          --查看资料
	WndPopupMenu:setPopupMenuItem(self.m_tPopupMenuItems)
	WndPopupMenu:setCallBackFunc(self, self.onClickMenuItem) --菜单回调函数
end

function WndMarryFriend:onSure(element)
	WZLog("WndMarryFriend:onSure::")
	local tData = {}
	local tFriend = self:getListData()
	if tFriend==nil or #tFriend == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_CHOOSE_PLAYER)
		return 
	end 
	local count = #tFriend
	for i=1,#tFriend do 
		if tFriend[i].status == 1 then
			WZLog("tData,self.m_tFriend:::",tFriend[i].id,tFriend[i].name)
			table.insert(tData,tFriend[i])
		end
	end
	
	if self.m_tBack and self.m_tBack[1] and self.m_tBack[2] then
		self.m_tBack[2](self.m_tBack[1],tData,self.m_nSelect)
	end
	self:onBackClick()
end

function WndMarryFriend:onFriend(element)
	WZLog("WndMarryFriend:onFriend::")
	--SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.nSelect == 1 then
		return
	end
	self:clearlist()
	self.m_nSelect = 1
	self:_update()
end

function WndMarryFriend:onGuild(element)
	--SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndMarryFriend:onGuild::")
	if self.nSelect == 2 then
		return
	end
	self.m_nSelect = 2
	self:clearlist()
	if self.m_bSendGuild == false then
		self.m_bSendGuild = true
		ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,2)
	end
	self:_update()
end

function WndMarryFriend:onAllClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tFriend = self:getListData()
	if tFriend==nil or #tFriend == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.EMPTYFRIENDTIP1)
		return 
	end
	local count = #self:getListData()
	local imgSelected_WndMarryFriend = GetElement(self.m_root,"imgSelected_WndMarryFriend",WZUI9Image)
	local m_bIshow = imgSelected_WndMarryFriend:isVisible() 
	if imgSelected_WndMarryFriend ~= nil then 
		imgSelected_WndMarryFriend:setVisible(not imgSelected_WndMarryFriend:isVisible())  
	end 

	if imgSelected_WndMarryFriend:isVisible() then 
		self.m_nAllSize = count
		for i = 1, #self.m_tFriend do
			--status:0->标记未选中；1->标记选中
			self.m_tFriend[i].status = 1
			WZLog("WndMarryFriend:onAllClick 0000", i, self.m_tFriend[i].status)
		end
	else 
		self.m_nAllSize = 0 
		for i = 1, #self.m_tFriend do
			--status:0->标记未选中；1->标记选中
			self.m_tFriend[i].status = 0
			WZLog("WndMarryFriend:onAllClick 1111", i, self.m_tFriend[i].status)
		end
	end 

	for i=0,count-1 do 
		WZLog("WndMarryFriend:onAllClick", i, type(tag), count)
		local tCell = self:_getCellElement(i)
		if not tCell then return end 
		tCell:setChoicesItem((m_bIshow and 1) or 0) 
	end
end

function WndMarryFriend:showInfaceterType()
	local txtUITitle_WndMarryFriend = GetElement(self.m_root,"txtUITitle_WndMarryFriend",WZUILabelTTF) 
	if self.m_nInterface == 5 then --显示异性单身好友
		txtUITitle_WndMarryFriend:setText(LocalStrings.OppositeSexFriend)
		self:showMainFrame(1)
		self:showFrameB(1)
	elseif self.m_nInterface == 1 then
		txtUITitle_WndMarryFriend:setText(LocalStrings.FRIEND)
		self:showMainFrame(0)
		self:showFrameA(1)
	elseif self.m_nInterface == 2 then
		txtUITitle_WndMarryFriend:setText(LocalStrings.FRIEND)
		self:showMainFrame(0)
		self:showFrameA(0)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndMarryFriend:getListData()
	return self.m_tFriend
end

function WndMarryFriend:getCurFrame()
	if self.m_nInterface == 5 then 
		return WZUITableContainer:luaTo(self.m_root:getChildElement("tbconB_WndMarryFriend"))
	else 
		return WZUITableContainer:luaTo(self.m_root:getChildElement("tbconA_WndMarryFriend"))
	end
end

function WndMarryFriend:_update()
	if self.m_root == nil then
		return
	elseif self:getListData() == nil or #self:getListData() == 0 then
		local desc = LocalStrings.EMPTYFRIENDTIP1
		if self.m_nSelect == 2 then
			desc = LocalStrings.TXT_NOSOCISY_FREND
		end
		self:_showEmptyTip(0,desc)
		return 
	end	
	local tbcon = self:getCurFrame()
	tbcon:cleanTable()
    if #self:getListData() < self.m_nDisplayedNum then 
        self.m_nCurNeedLoadNum = #self:getListData()
    else
        self.m_nCurNeedLoadNum = self.m_nDisplayedNum
    end		
	self.m_nCurLoadIndex = 1 				
	self.m_nCurTag = 0 
	self:onShowFriend(tbcon)
end

--@note		多语言文本
function WndMarryFriend:_showMultiLanguage()
	for i=1,4 do 
		local sName = string.format("btnOk%d_WndMarryFriend",i)
		local TTF = WZUILabelTTF:luaTo(self.m_root:getChildElement(sName))
		TTF:setText(LocalStrings.CONFIRM)
	end
	for i=1,2 do 
		local sName = string.format("btnAll%d_WndMarryFriend",i)
		local TTF = WZUILabelTTF:luaTo(self.m_root:getChildElement(sName))
		TTF:setText(LocalStrings.SELECT_ALL)
	end
	--self:_showTTFText("txtCheck1_WndMarryFriend",LocalStrings.FRIEND)
	--self:_showTTFText("txtCheck2_WndMarryFriend",LocalStrings.COMMUNITY)
end

--@note		显示文本文字
function WndMarryFriend:_showTTFText(name,desc)
	local element = WZUILabelTTF:luaTo(self.m_root:getChildElement(name))
	element:setText(desc)
	return element
end

--@brief	字体排版
function WndMarryFriend:_showTTFLayout(txtA,txtB)
	local dir = 4
	local sizeB = txtB:getContentSize()
	local rePosB = txtB:getRelativePosition()
	local lpSize = txtB:getParent():getContentSize()
	local x = rePosB.x - (sizeB.width + dir)/lpSize.width
	local y = rePosB.y
	txtA:setRelativePosition(GlobalMethod:ccp(x,y))	
end

function WndMarryFriend:_getCellElement(tag)
	local tbcon = self:getCurFrame()
	local celElement = tbcon:getCellElement(tag)
	if celElement == nil then return nil end
	local childElement = celElement:getChildElement("__CellMarryFriend")
	if not childElement then
		return nil 
	end 
	return childElement:getLuaObjectIndex()
end

function WndMarryFriend:clearlist()
	self:getCurFrame():cleanTable()
end

function WndMarryFriend:_checkSingle()
	if self.m_nInterface == 2 or self.m_nInterface == 5 then 
		return true 
	else
		return false
	end
end

--@brief	判断是否显示上一页函数
--@note		当前页大于1的时候显示上一页，否则不显示
function WndMarryFriend:_getUpPage( )
	local nCurPage = self.m_nFriendsTableIndex - self.m_nDisplayedNum
	if nCurPage > 0 then
		return true
	else
		return false
	end
end

--@brief	判断是否显示下一页函数
--@note		当前页小于总页数的时候显示下一页，否则不显示
function WndMarryFriend:_getDownPage()
	local nCurPage = #self.m_tFriend - self.m_nFriendsTableIndex
	if nCurPage > 0 then
		return true
	else
		return false
	end
end

--@brief 	获取某个好友数据在整个列表中的位置
function WndMarryFriend:_getFriendTag(tData)
	-- body
	for i = 1, #self.m_tFriend do
		if self.m_tFriend[i].id == tData.id then
			return i
		end
	end

	return nil
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndMarryFriend:_adaptLanguage_pt(  )
    GetElement(self.m_root,"btnOk1_WndMarryFriend",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"btnOk2_WndMarryFriend",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"btnOk4_WndMarryFriend",WZUILabelTTF):setScale(0.8)
end

function WndMarryFriend:_adaptLanguage_tr()
    GetElement(self.m_root,"btnAll1_WndMarryFriend",WZUILabelTTF):setFontSize(20)
end

function WndMarryFriend:_adaptLanguage_es()
    local btnAll1 = GetElement(self.m_root,"btnAll1_WndMarryFriend",WZUILabelTTF)
    btnAll1:setFontSize(18)
    btnAll1:setDimensions(GlobalMethod:CCSize(100,0))
    
    GetElement(self.m_root,"btnOk1_WndMarryFriend",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"btnOk2_WndMarryFriend",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"btnOk4_WndMarryFriend",WZUILabelTTF):setScale(0.8)
end

function WndMarryFriend:_adaptLanguage_ug(  )
    GetElement(self.m_root,"btnAll1_WndMarryFriend",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100,0))
    GetElement(self.m_root,"btnAll2_WndMarryFriend",WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"btnOk1_WndMarryFriend",WZUILabelTTF):setScale(0.6)
    GetElement(self.m_root,"btnOk2_WndMarryFriend",WZUILabelTTF):setScale(0.6)
    GetElement(self.m_root,"btnOk3_WndMarryFriend",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"btnOk4_WndMarryFriend",WZUILabelTTF):setScale(0.55)
end
-------------------------------------语言适配End--------------------------------------------

