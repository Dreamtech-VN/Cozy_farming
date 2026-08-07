--WndOnlineHintFriend.lua
--@brief	WndOnlineHintFriend的UI模块
--@date		2016/04/29
--@author	Tianxiang_Xu
--@note		好友上线提示列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndOnlineHintFriend:onEnter(element)
	self.m_root = element
    CacheCenter:registerFriendListObserver(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndOnlineHintFriend:onExit(element)
    CacheCenter:unregisterFriendListObserver(self)
	self:_unInit()
end

--@brief    加载动画
function WndOnlineHintFriend:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,true,"onActionFinish",self)
end

--@brief    动画完成
function WndOnlineHintFriend:onActionFinish()
end

--@brief   创建加载框
function WndOnlineHintFriend:createLoading()
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndOnlineHintFriend:closeLoading()
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndOnlineHintFriend:onExit(element)
    CacheCenter:unregisterFriendListObserver(self)
    self:_unInit()
end

--@brief    关闭按钮回调事件
function WndOnlineHintFriend:onCloseClick(element)
    WZLog("关闭按钮回调事件")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    
    WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
end

--@brief    关闭按钮回调事件
function WndOnlineHintFriend:onCloseActionCallback(element,data)
    WindowManager:removeWindow(self.m_root, self, true)
end

function WndOnlineHintFriend:onBeginTouch(element,pt)
    
end

--@brief    确定按钮回调
function WndOnlineHintFriend:onSure(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tFriend == nil or #self.m_tFriend == 0 then
        --没有好友时点确定，直接关掉窗口
        WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
        return
    end
    if self.m_nType == 2 then
        if self.m_nLeftNum == 0 then
            MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND10)
            return 
        end

        if #self.m_tNeedRemindFriend == 0 then
            MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_ID)
            return 
        end
    end
    
    local vectorId = WZLuaVector_int_:create()
    for i = 1, #self.m_tNeedRemindFriend do
        WZLog("WndOnlineHintFriend:onSure", i, self.m_tNeedRemindFriend[i].id)
        vectorId:push(self.m_tNeedRemindFriend[i].id)
    end

    if self.m_nType == 1 then
        --发送协议
        self:createLoading()
        ProtocolProcessorWndFriends:send_FRIEND_ChangeNotify(vectorId)
    elseif self.m_nType == 2 then
        if self.m_tCallBack then
            self.m_tCallBack[2](self.m_tCallBack[1], vectorId)
        end
    end
end

--@brief    点击规则按钮回调
function WndOnlineHintFriend:onRule(element)
    --body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.FRIENDS_BESTFRIEND9)    
end

--@brief    设置提醒上线好友成功
function WndOnlineHintFriend:setFriendOnlineOk()
    -- body
    self:closeLoading()
    --维护缓存好友数据同步
    CacheCenter:resetRemindFriends(self.m_tNeedRemindFriend)
    --维护好友界面数据同步
    WndFriends:resetRemindFriends(self.m_tNeedRemindFriend)
    --提示设置成功
    MsgBoxManager:showTipBox(LocalStrings.SET_SUCCESS)
    --关掉设置好友界面
    WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
end

--@brief    点击复选框回调
function WndOnlineHintFriend:onChoose(tData)
    -- body
    WZLog("WndOnlineHintFriend:onChoose")

    if self.m_tNeedRemindFriend == nil then
        self.m_tNeedRemindFriend = {}
    end

    if self.m_nType == 1 then
        if tData.isOnlineRemind == true then
            table.insert(self.m_tNeedRemindFriend, tData)
        else
            for i = 1, #self.m_tNeedRemindFriend do
                if tData.id == self.m_tNeedRemindFriend[i].id then
                    table.remove(self.m_tNeedRemindFriend, i)
                    break
                end
            end
        end
    elseif self.m_nType == 2 then
        if tData.isAddForBest == true then
            table.insert(self.m_tNeedRemindFriend, tData)
        else
            for i = 1, #self.m_tNeedRemindFriend do
                if tData.id == self.m_tNeedRemindFriend[i].id then
                    table.remove(self.m_tNeedRemindFriend, i)
                    break
                end
            end
        end

        self.m_nHaveSelected = #self.m_tNeedRemindFriend
        self:_updateSelectedNum()
    end
end

--@brief    密友限制提示
function WndOnlineHintFriend:bestFriendAtt()
    -- body
    if self.m_nHaveSelected >= self.m_nLeftNum then
        if self.m_nLeftNum == 0 then
            MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND10)
        else
            MsgBoxManager:showTipBox(string.format(LocalStrings.FRIENDS_BESTFRIEND7, self.m_nLeftNum))
        end
        return false
    else
        return true
    end
end

function WndOnlineHintFriend:onShowFriend(element)
    if self.m_root == nil or self.m_tFriend == nil then
        return 
    end
    element = WZUITableContainer:luaTo(element)
    element:cleanTable()

    for i = 1, self.m_nCurNeedLoadNum do
        local celElement, tCell = CellOnlineHintFriend:createElement()
        celElement:setTag(self.m_nCurTag)
        element:setCellElement(celElement)
        tCell:setBackFun(self, self.onChoose, self.onFriendClick)
        tCell:setCellData(self.m_tFriend[self.m_nCurLoadIndex], self.m_nType)

        self.m_nFriendsTableIndex = self.m_nFriendsTableIndex + 1
        self.m_nCurLoadIndex = self.m_nCurLoadIndex + 1
        self.m_nCurTag = self.m_nCurTag + 1
    end
    self:_setLoadMoreVisible()
    element:getMoveElement():setPositionY(element:getMinPosition().y)
end

--@brief    点击上一页触发函数
--@param    element:表绑定的UI节点引用
function WndOnlineHintFriend:onPageUp(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_bUpPageShowLastPosition = true
    local tbconFriend = GetElement(self.m_root, "tableconList_WndOnlineHintFriend", WZUITableContainer)

    if self.m_tFriend and self:_getUpPage() then 
        local nAddNum = self.m_nDisplayedNum
        if nAddNum <= 0 then return end
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

--@brief    好友点击回调
function WndOnlineHintFriend:onFriendClick(tData)
    WZLog("WndOnlineHintFriend:onFriendClick():::", tData.id)
    if self.m_tClickFriendData == nil then
        self.m_tClickFriendData = {}
    end
    self.m_tClickFriendData.id = tData.id
    self.m_tClickFriendData.name = tData.name

end

--@brief    点击下一页触发函数
--@param    element:表绑定的UI节点引用
function WndOnlineHintFriend:onPageDown(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tbconFriend = GetElement(self.m_root, "tableconList_WndOnlineHintFriend", WZUITableContainer)

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

--@brief    删除好友成功
function WndOnlineHintFriend:DelFriendSuccess()
    if self.m_root == nil then 
        return nil
    end
    
    self:closeLoading()
    local idx = self:_getFriendTag(self.m_tFriend, self.m_tClickFriendData)
    
    table.remove(self.m_tFriend,idx)
    local tbcon = WZUITableContainer:luaTo(self.m_root:getChildElement("tableconList_WndOnlineHintFriend"))
    local nCurPositionY = tbcon:getMoveElement():getPositionY()
    local tLastSize = tbcon:getMoveElement():getContentSize()
    --根据id获取tag，删除相应的好友，防止由于下线等引起tag变化后删错相应的好友cell
    local nTag = 0 
    local cellElement = tbcon:getCellElement(nTag)
    while cellElement do
        cellElement = WZUIContainer:luaTo(cellElement)
        local cellItem = cellElement:getChildElement("__CellOnlineHintFriend")
        local cellObj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()
        local nFriendId = cellObj:getFriendId() 
        if self.m_tClickFriendData.id == nFriendId then 
            tbcon:removeCellElementByReset(nTag)
            break 
        end
        nTag = nTag + 1
        cellElement = tbcon:getCellElement(nTag)
    end
    
    -------------------------
    self.m_nFriendsTableIndex = self.m_nFriendsTableIndex - 1
    --删除后，如果还有好友未加载出来，则加载
    if self.m_nFriendsTableIndex > 0 then
        self:_dealWithDelFriend(tbcon, nCurPositionY, tLastSize)
    end

    if self.m_tFriend == nil or #self.m_tFriend == 0 then
        local conForList = GetElement(self.m_root, "conForList_WndOnlineHintFriend", WZUIContainer)
        ShowPanelNullTip( conForList, LocalStrings.EMPTYFRIENDTIP1)
    end

    return self.m_tClickFriendData
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新界面
function WndOnlineHintFriend:_update()
    -- body
    if self.m_root == nil then
        return
    end
    self:_setStaticText()

    local tbcon = GetElement(self.m_root, "tableconList_WndOnlineHintFriend", WZUITableContainer)
    if self.m_tFriend == nil or #self.m_tFriend == 0 then
        local desc = LocalStrings.EMPTYFRIENDTIP1
        ShowPanelNullTip( tbcon, desc)
        return 
    end 
    
    tbcon:cleanTable()
    if #self.m_tFriend < self.m_nDisplayedNum then 
        self.m_nCurNeedLoadNum = #self.m_tFriend
    else
        self.m_nCurNeedLoadNum = self.m_nDisplayedNum
    end               
    self.m_nCurLoadIndex = 1                
    self.m_nCurTag = 0 
    self.m_bIsCaculate = true
    self:onShowFriend(tbcon)
end

--@brief    上拉显示更多是否可见
function WndOnlineHintFriend:_setLoadMoreVisible()
    -- body
    local tbconFriend = GetElement(self.m_root, "tableconList_WndOnlineHintFriend", WZUITableContainer)
    if self:_getUpPage() then
        --Begin:翻页效果2
        WZLog("WndOnlineHintFriend:_setLoadMoreVisible 00000")
        local elementTop = tbconFriend:getTopElement()
        tbconFriend:setEnableDropRefresh(false)
        tbconFriend:setHideTopElement(false)--设置topElement是否隐藏
        tbconFriend:setEnableTopElement(true)--设置TopElement是否可用
        if not elementTop then
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
        WZLog("WndOnlineHintFriend:_setLoadMoreVisible 22222")
        tbconFriend:setEnableDropRefresh(false)
        tbconFriend:setEnableTopElement(false)
        tbconFriend:setHideTopElement(true)
    end
    if self:_getDownPage() then
        --Begin:翻页效果2
        WZLog("WndOnlineHintFriend:_setLoadMoreVisible 33333")
        local elementDown = tbconFriend:getBottomElement()
        tbconFriend:setEnableDagLoading(false)
        tbconFriend:setEnableBottomElement(true) --设置BottomElement是否可用
        tbconFriend:setHideBottomElement(false) --设置bottomElement是否隐藏
        if not elementDown then
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
        WZLog("WndOnlineHintFriend:_setLoadMoreVisible 55555")
        tbconFriend:setEnableDagLoading(false)
        tbconFriend:setEnableBottomElement(false)
        tbconFriend:setHideBottomElement(true)
    end
end

--@brief    判断是否显示上一页函数
--@note     当前页大于1的时候显示上一页，否则不显示
function WndOnlineHintFriend:_getUpPage( )
    WZLog("WndOnlineHintFriend:_getUpPage", self.m_nFriendsTableIndex, self.m_nDisplayedNum)
    local nCurPage = self.m_nFriendsTableIndex - self.m_nDisplayedNum
    if nCurPage > 0 then
        return true
    else
        return false
    end
end

--@brief    判断是否显示下一页函数
--@note     当前页小于总页数的时候显示下一页，否则不显示
function WndOnlineHintFriend:_getDownPage()
    WZLog("WndOnlineHintFriend:_getDownPage", #self.m_tFriend, self.m_nFriendsTableIndex)
    local nCurPage = #self.m_tFriend - self.m_nFriendsTableIndex
    if nCurPage > 0 then
        return true
    else
        return false
    end
end

--@brief    获取节点对应的表
function WndOnlineHintFriend:_getCellElement(tag)
    local tbcon = GetElement(self.m_root, "tableconList_WndOnlineHintFriend", WZUITableContainer)
    local celElement = tbcon:getCellElement(tag)
    if celElement == nil then return nil end
    local childElement = celElement:getChildElement("__CellOnlineHintFriend")
    if not childElement then
        return nil 
    end 
    return childElement:getLuaObjectIndex()
end

--@breif    设置静态文本
function WndOnlineHintFriend:_setStaticText()
    -- body
    local txtTitle = GetElement(self.m_root, "txtTitle_WndOnlineHintFriend", WZUILabelTTF)
    local txtLeftText = GetElement(self.m_root, "txtLeftText_WndOnlineHintFriend", WZUILabelTTF)
    local txtRightText = GetElement(self.m_root, "txtRightText_WndOnlineHintFriend", WZUILabelTTF)
    if self.m_nType == 1 then
        txtTitle:setText(LocalStrings.SELECT_ONLINE_TITLE)
        txtLeftText:setText(LocalStrings.SELECT_ONLINE_HINT)
        txtRightText:setVisible(false)
        if ProjConfig.LANGUAGE == "es" then
            txtLeftText:setFontSize(16)
            txtLeftText:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
        end
    elseif self.m_nType == 2 then
        txtTitle:setText(LocalStrings.FRIENDS_BESTFRIEND8)
        txtLeftText:setText(LocalStrings.FRIENDS_BESTFRIEND2 .. self.m_nNeedFriendness)
        txtRightText:setVisible(true)
        if ProjConfig.LANGUAGE == "en" then
            txtLeftText:setScale(0.8)
            txtRightText:setScale(0.8)
        elseif ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
            txtLeftText:setScale(0.65)
            txtLeftText:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
            txtRightText:setScale(0.65)
            txtRightText:setRelativePosition(GlobalMethod:ccp(0.98,0.5))
        elseif ProjConfig.LANGUAGE == "tr" then
            txtLeftText:setFontSize(18)
            txtRightText:setFontSize(18)
        end
        self:_updateSelectedNum()
    end
end

--@brief    更新已选择的数量
function WndOnlineHintFriend:_updateSelectedNum()
    -- body
    local txtRightText = GetElement(self.m_root, "txtRightText_WndOnlineHintFriend", WZUILabelTTF)
    if txtRightText then
        txtRightText:setText(LocalStrings.FRIENDS_BESTFRIEND3 .. "(" .. self.m_nHaveSelected .. "/" .. self.m_nLeftNum .. ")")
    end
end


--@brief    删除好友成功后列表的处理
function WndOnlineHintFriend:_dealWithDelFriend(tbcon, nCurPositionY, tLastSize)
    -- body
    WZLog("WndOnlineHintFriend:_dealWithDelFriend")
    if self.m_tFriend then
        if self:_getDownPage() then  
            --如果下面还有数据，则加载下一条，顶替删除的项流出的空缺
            --减去已经移除的那个
            local nTagTemp = self.m_nCurTag - 1
            
            WZLog("WndOnlineHintFriend:_dealWithDelFriend 111", self.m_nFriendsTableIndex, nTagTemp)
            local celElement, tCell = CellOnlineHintFriend:createElement()
            celElement:setTag(nTagTemp)
            tbcon:setCellElement(celElement)
            tCell:setBackFun(self,self.onChoose, self.onFriendClick)
            tCell:setCellData(self.m_tFriend[self.m_nFriendsTableIndex + 1], self.m_nType)

            self.m_nFriendsTableIndex = self.m_nFriendsTableIndex + 1
            tbcon:updateContainerSize()
            --重新设置列表的位置
            local tCurSize = tbcon:getMoveElement():getContentSize()
            local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
            if nTempPositionY > tbcon:getMaxPosition().y then
                nTempPositionY = tbcon:getMaxPosition().y
            end
            tbcon:getMoveElement():setPositionY(nTempPositionY)
            WZLog("******* self:_setLoadMoreVisible ******* 33333 ")
            self:_setLoadMoreVisible()
        elseif not self:_getDownPage() and self.m_nCurPageIndex > 1 and self.m_nCurPageIndex > math.ceil(#self.m_tFriend/self.m_nDisplayedNum) then
            --如果当前页是最后一页，且数据已经全部删除，则跳到上一页显示上一页的数据
            self.m_nCurPageIndex = self.m_nCurPageIndex - 1
            self.m_nCurNeedLoadNum = self.m_nDisplayedNum            
            self.m_nCurLoadIndex = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum + 1
            self.m_nCurTag = 0 
            self.m_nFriendsTableIndex = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum     
            self:onShowFriend(tbcon)
        else
            tbcon:updateContainerSize()

            local tCurSize = tbcon:getMoveElement():getContentSize()
            local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
            if nTempPositionY > tbcon:getMaxPosition().y then
                nTempPositionY = tbcon:getMaxPosition().y
            end
            tbcon:getMoveElement():setPositionY(nTempPositionY)
        end
        return
    end
end

--@brief    获取某个好友数据在整个列表中的位置
function WndOnlineHintFriend:_getFriendTag(tFriends, tData)
    -- body
    for i = 1, #tFriends do
        if tFriends[i].id == tData.id then
            return i
        end
    end

    return nil
end

-------------------------------------私有方法模块End----------------------------------------
