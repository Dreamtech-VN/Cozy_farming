
--@brief	WndFriendList的UI模块
--@date		2014/03/26
--@author	liangguang_long
--@note		附近好友模块

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFriendList:onEnter(element)
	self.m_root = element
	WZLog("self.m_nInterface::",self.m_nInterface)
	CacheCenter:registerFriendListObserver(self)
	self:createLoading()
    AdaptLanguage(self)
end

function WndFriendList:init()
	
end

--@brief	加载动画
function WndFriendList:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAction(self.m_root,true,"onActionFinish",self)
    AdaptLanguage(self)
end

--@brief	动画完成
function WndFriendList:onActionFinish()
    self:onInitInterface(self.m_nInterface)
    self:_showMultiLanguage()
end

--@brief   创建加载框
function WndFriendList:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox(nil,nil,nil,nil,nil,nil,nil,true)
end

--@brief   关闭加载框
function WndFriendList:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFriendList:onExit(element)
	CacheCenter:unregisterFriendListObserver(self)
	self:_unInit()
end

--@brief	关闭按钮回调事件
function WndFriendList:onBackClick(element)
	WZLog("关闭按钮回调事件")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    
	WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
end

--@brief	关闭按钮回调事件
function WndFriendList:onCloseActionCallback(element,data)
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndFriendList:onBeginTouch(element,pt)
	
end

function WndFriendList:onShowFriend(element)
	if self.m_root == nil or self:getListData() == nil then
		return 
	end
	local maxCount = #self:getListData()
	
	WZLog("self.m_nIndex::",self.m_nIndex,maxCount)

	for i=1,maxCount do    --Modified By Tianxiang_Xu
        local isSelect = false
        local pid = self:getListData()[self.m_nIndex + 1].id--self:getListData()[i].id--Modified By Tianxiang_Xu
        if self.m_tInvitePlayer ~= nil then 
            for i,v in pairs(self.m_tInvitePlayer) do
                WZLog("id====",v,pid)
                if v == pid then
                    isSelect = true
                    break
                end
            end
        end 
        self.m_nIndex = self.m_nIndex + 1
        local celElement , tCell = CellFriendList:createElement()
        celElement:setTag(self.m_nIndex - 1)
        self:getCurFrame():setCellElement(celElement)
        tCell:setBackFun(self,self.onFriendClick)
        tCell:setUIIndex(self.m_nInterface)
        tCell:setCellData(self:getListData()[self.m_nIndex],self.m_nSelect)
        WZLog("========player  =",self:getListData()[self.m_nIndex].id,self:getListData()[self.m_nIndex].name,self:getListData()[self.m_nIndex].level)
        if isSelect == true then
           tCell:showInvateIcon(isSelect)
        end
	end
end

--@brief	好友点击回调
function WndFriendList:onFriendClick(tCell,tag,tData)
    WZLog("WndFriendList:onFriendClick(tCell,tag,tData)")
	if self.m_root == nil or self:getListData() == nil or #self:getListData() == 0 then
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndFriendList:onFriendClick::",tag,self:getListData()[tag+1].id,self:getListData()[tag+1].name)
	if self.m_tBack and self.m_tBack[1] and self.m_tBack[2] then
        local bAssetFight = 1 --是否助战（0为助战）
        if self.m_nSelect == 5 then
            bAssetFight = 0
        end
		self.m_tBack[2](self.m_tBack[1],self:getListData()[tag+1],self.m_nSelect,bAssetFight)
	end
    if self.m_nInterface == 4 or self.m_nInterface == 7 then
        self:onBackClick()
    elseif self.m_nInterface == 3 or self.m_nInterface == 6 or self.m_nInterface==31 or self.m_nInterface == 8 or self.m_nInterface == 9 or self.m_nInterface == 11 or self.m_nInterface == 12 or self.m_nInterface == 13 or self.m_nInterface == 14 or self.m_nInterface == 15 then
    	if self.m_tInviteFriendIds~=nil and #self.m_tInviteFriendIds > 0 then 
    		for i,v in ipairs(self.m_tInviteFriendIds) do
    			WZLog("onFriendClick=====playerId="..v)
    			if v == tData.id then
    	   			return 
    			end
    		end
    	end 

    	tCell:showInvateIcon(true)
        if self.m_tInvitePlayer == nil then
            self.m_tInvitePlayer = {}
        end
        WZLog("playerid===",tData.id)
        table.insert(self.m_tInvitePlayer,tData.id)
        --刷新列表
        --self:_update()
    end 
end

--@brief	好友checkbox点击回调
function WndFriendList:onFriend(element)
	WZLog("WndFriendList:onFriend:: ",self.m_nSelect)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nSelect == 1 then 
		return 
	end 
    --切换选项时，停止滑动
    local tbconFriend = GetElement(self.m_root, "tbcon_WndFriendList", WZUITableContainer)
    tbconFriend:stopMoveAction()

	local conInvitedMsg_WndFriendList = GetElement(self.m_root,"conInvitedMsg_WndFriendList",WZUIContainer)
	removeShowPanelNullTip(conInvitedMsg_WndFriendList)
    self.m_nSelect = 1
    self:_setSignWordStrokeColor()
    local pt =  element:getRelativePosition()
	local conImgTheme_WndFriendList = GetElement(self.m_root,"conImgTheme_WndFriendList",WZUIContainer)
	conImgTheme_WndFriendList:setRelativePosition(GlobalMethod:ccp(1.0575,pt.y))
    self:createLoading()

    if self.m_nInterface == 11 then
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,1,self.m_nTopLevel)
    else
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,1)
    end
    self:setAssistTipVisble(false)
end

--@brief	公会checkbox点击回调
function WndFriendList:onGuild(element)
	WZLog("WndFriendList:onGuild::")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nSelect == 2 then 
		return 
	end
    --切换选项时，停止滑动
    local tbconFriend = GetElement(self.m_root, "tbcon_WndFriendList", WZUITableContainer)
    tbconFriend:stopMoveAction()

	local conInvitedMsg_WndFriendList = GetElement(self.m_root,"conInvitedMsg_WndFriendList",WZUIContainer)
	removeShowPanelNullTip(conInvitedMsg_WndFriendList)
    self.m_nSelect = 2
    self:_setSignWordStrokeColor()
	local pt =  element:getRelativePosition()
	local conImgTheme_WndFriendList = GetElement(self.m_root,"conImgTheme_WndFriendList",WZUIContainer)
	conImgTheme_WndFriendList:setRelativePosition(GlobalMethod:ccp(1.0575,pt.y))
   -- self:clearlist()
    self:createLoading()
    if self.m_nInterface == 11 then
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,2,self.m_nTopLevel)
    else
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,2)
    end
    self:setAssistTipVisble(false)
end

--@brief    大厅checkbox点击回调
function WndFriendList:onHall(element)
    WZLog("WndFriendList:onHall::")
    if self.m_nInterface ~= 3 and self.m_nInterface ~= 6 and self.m_nInterface ~= 8 and self.m_nInterface ~= 11 and self.m_nInterface ~= 12 and self.m_nInterface ~= 14 then
        return
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_nSelect == 3 then 
		return 
	end
    --切换选项时，停止滑动
    local tbconFriend = GetElement(self.m_root, "tbcon_WndFriendList", WZUITableContainer)
    tbconFriend:stopMoveAction()

	local conInvitedMsg_WndFriendList = GetElement(self.m_root,"conInvitedMsg_WndFriendList",WZUIContainer)
	removeShowPanelNullTip(conInvitedMsg_WndFriendList)
    self.m_nSelect = 3
    self:_setSignWordStrokeColor()
    local pt =  element:getRelativePosition()
	local conImgTheme_WndFriendList = GetElement(self.m_root,"conImgTheme_WndFriendList",WZUIContainer)
	conImgTheme_WndFriendList:setRelativePosition(GlobalMethod:ccp(1.0575,pt.y))
  --  self:clearlist()
    self:createLoading()
    if self.m_nInterface == 11 then
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,3,self.m_nTopLevel)
    else
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,3)
    end
    self:setAssistTipVisble(false)
end

--助战
function WndFriendList:onAssistInFighting(element)
    -- body
    WZLog("WndFriendList:onAssistInFighting")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_nSelect == 5 then 
        return 
    end
    self.m_nSelect = 5
    self:createLoading()

    local conInvitedMsg_WndFriendList = GetElement(self.m_root,"conInvitedMsg_WndFriendList",WZUIContainer)
    removeShowPanelNullTip(conInvitedMsg_WndFriendList)
    self:_setSignWordStrokeColor()
    local pt =  element:getRelativePosition()
    local conImgTheme_WndFriendList = GetElement(self.m_root,"conImgTheme_WndFriendList",WZUIContainer)
    conImgTheme_WndFriendList:setRelativePosition(GlobalMethod:ccp(1.0575,pt.y))
    self:setAssistTipVisble(true)
    ProtocolProcessorWndFriends:send_FRIEND_GetFriend(6,5)
end

function WndFriendList:setAssistTipVisble(bVisible)
    -- body
    WZLog("WndFriendList:setAssistTipVisble")
    local conInvitedMsg = GetElement(self.m_root,"conInvitedMsg_WndFriendList",WZUIContainer)
    GetElement(conInvitedMsg,"txtAssetInTip_WndFriendsList",WZUILabelTTF):setVisible(bVisible)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndFriendList:getListData()
	if self.m_nSelect == 1 then
		return self.m_tFriend
	elseif self.m_nSelect == 2 then 
		return self.m_tGuild
    elseif self.m_nSelect == 3 then
        return self.m_tHall
    elseif self.m_nSelect == 5 then
        return self.m_tAssistIn
	end
end

function WndFriendList:getCurFrame()
	return WZUITableContainer:luaTo(self.m_root:getChildElement("tbcon_WndFriendList"))
end

function WndFriendList:_update()
	if self.m_root == nil then
		return
    end
    local t = self:getListData()
	local tbcon = self:getCurFrame()
	tbcon:cleanTable()
    tbcon:setContentOffsetByRowIndex(0)
	

    if t == nil or #t == 0 then
    	local desc = LocalStrings.EMPTYFRIENDTIP1
    	if CacheCenter:getFriendCount()>0 then 
        	desc = LocalStrings.TXT_ONLINEFRIEND_ISNULL
    	end 
        if self.m_nSelect == 2 then
        	local PlayerInfo = CacheCenter:getPlayerInfo()
        	if PlayerInfo.guildId==0 then 
        		desc = LocalStrings.TXT_NOSOCISY_FREND
        	else 
        		desc = LocalStrings.TXT_ONLINEGUILD_ISNULL
        	end  
        elseif self.m_nSelect == 3 then
            desc = self.NO_PLAYER_IN_HALL
        end
        if self.m_nInterface == 11 then
            desc = LocalStrings.PVPRANK_INVITE_NO_DATA
        end
        self:_showEmptyTip(0,desc)
        return
    end

    WZLog("#t===",#t)
    self.m_nIndex = 0
	self:onShowFriend(tbcon)
end

--@note		多语言文本
function WndFriendList:_showMultiLanguage()
	self:_showTTFText("txtCheck1_WndFriendList",LocalStrings.FRIEND)
	self:_showTTFText("txtCheck2_WndFriendList",LocalStrings.COMMUNITY)
    self:_showTTFText("txtCheck3_WndFriendList",LocalStrings.HALL)
    self:_showTTFText("txtCheck5_WndFriendList",LocalStrings.ASSIST_IN_FIGHTING)

    
    if GlobalMethod:crossServiceOpen() == 0 then
        GetElement(self.m_root,"btnTheme5_WndFriendList",WZUIButton):setRelativePosition(GlobalMethod:ccp(1.05,0.41))
        GetElement(self.m_root,"conCheck5_WndFriendList",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,-0.015))
    end
end

--@note		显示文本文字
function WndFriendList:_showTTFText(name,desc)
	local element = WZUILabelTTF:luaTo(self.m_root:getChildElement(name))
	element:setText(desc)
	return element
end

--@brief	字体排版
function WndFriendList:_showTTFLayout(txtA,txtB)
	local dir = 4
	local sizeB = txtB:getContentSize()
	local rePosB = txtB:getRelativePosition()
	local lpSize = txtB:getParent():getContentSize()
	local x = rePosB.x - (sizeB.width + dir)/lpSize.width
	local y = rePosB.y
	txtA:setRelativePosition(GlobalMethod:ccp(x,y))	
end

function WndFriendList:_getCellElement(tag)
	local tbcon = self:getCurFrame()
	return tbcon:getCellElement(tag):getChildElement("__CellMarryFriend"):getLuaObjectIndex()
end

function WndFriendList:clearlist()
	self:getCurFrame():cleanTable()
end

--@brief    设置标签字描边
function WndFriendList:_setSignWordStrokeColor()
    -- body
    for i = 1, 5 do
        local sNodeName = string.format("txtCheck%d_WndFriendList", i)
        local txtCheck =  GetElement(self.m_root, sNodeName, WZUILabelTTF)
        if txtCheck then 
            if i == self.m_nSelect then
                txtCheck:setStrokeColor(GlobalMethod:ccc3(128,54,13))
            else
                txtCheck:setStrokeColor(GlobalMethod:ccc3(105,65,46))
            end
        end
    end
    
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndFriendList:_adaptLanguage_vn(  )
    for i = 1, 5 do 
        local txtCheckName = GetElement(self.m_root,"txtCheck"..i.."_WndFriendList",WZUILabelTTF)
        if txtCheckName then
            txtCheckName:setFontSize(20)
            txtCheckName:setDimensions(GlobalMethod:CCSize(80))
        end
    end
end

function WndFriendList:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtAssetInTip_WndFriendsList",WZUILabelTTF):setScale(0.8)
end

function WndFriendList:_adaptLanguage_tr()
    for i = 1, 5 do 
        local txtCheckName = GetElement(self.m_root,"txtCheck"..i.."_WndFriendList",WZUILabelTTF)
        if txtCheckName then
            txtCheckName:setFontSize(20)
            txtCheckName:setDimensions(GlobalMethod:CCSize(80))
        end
    end
end

function WndFriendList:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtAssetInTip_WndFriendsList",WZUILabelTTF):setScale(0.7)
end

function WndFriendList:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtAssetInTip_WndFriendsList",WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配End--------------------------------------------



