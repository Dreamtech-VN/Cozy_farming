--WndServersSel.lua
--@brief	WndServersSel的UI模块
--@date		2015-09-15
--@author	binshao
--@note		登陆服务器选择界面

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndServersSel:onEnter(element)
    WZLog("WndServersSel:onEnter")
	self.m_root = element
end

--@brief onEnter函数执行完成回调
function WndServersSel:onEnterTransitionDidFinish(element)
    if not self.m_bIsChange then
        self:resetServerListData()
    end
    local eb_WndServersSel = GetElement(self.m_root, "eb_WndServersSel", WZUIEditBox)
    eb_WndServersSel:setPlaceHolder(LocalStrings.INPUT_KEY_SEARCH)
    if isChannelPC() then
        --eb_WndServersSel:setPlaceHolder(" "..LocalStrings.INPUT_KEY_SEARCH)
        --eb_WndServersSel:setFontSize(20)
        eb_WndServersSel:setScale(0.93)
    end
    PostPlayerEvent:postEvent(PostPlayerEvent.event_openServerList)
end

--@brief    重新刷新列表数据
function WndServersSel:resetServerListData()
    -- body
    if self.m_root == nil then return end 

    if IPDhttpServer.IpdServerInfo then
        self:getIpdHttpServerList()
    else
        self:initServersInfo()
    end
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndServersSel:onExit(element)
    WZLog("WndServersSel:onExit")
	self:_unInit()
end

function WndServersSel:normalClose(  )
	WindowManager:removeWindow(self.m_root , WndServersSel , true)
end

function WndServersSel:onClose( )
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root , WndServersSel , true)
end

function WndServersSel:showWndUI(tag, isChange)
    local wnd = WndServersSel:createElement()
    self.m_bIsChange = isChange
    WindowManager:addWindow( wnd ,WndServersSel)
    self.index = tag
    self:_update()
end

-- 刷新服务器状态
function WndServersSel:onUpdateList()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("-------------------onlist--------------")
    local btn = GetElement(self.m_root,"btnUpdate_WndServersSel",WZUIButton)
    btn:setTouchEnable(false)
    self.btnTime = 5
    btn:enableSchedule("_btnTime",1)
    self:getIpdHttpServerList()
end

--@brief	更新函数
function WndServersSel:_update()
    self:_createLeftList()
    self:_createRightList()
end

-- 修改服务器id
function WndServersSel:_changeServerId(serverId, serverName)
    IPDhttpServer:setCurServer(serverId, serverName)
    WndLoginSelect:setCurServerName()
end

-- 点击右边列表回调
function WndServersSel:onRightCallBack(data)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if data.status == 1 then
        MsgBoxManager:showTipBox(LocalStrings.SERVER_MAINTAINING)
        return
    end
    local bCreated = self:_getAccountState()
    local channelId = ProjConfig:getChannelId()
    if channelId ~= 1100 then
        if not bCreated then    --新账号，不能进老服
            if data.newserver ~= 1 then 
                MsgBoxManager:showConfirmBox(LocalStrings.VIPWEEK_PACKAGE5, nil, nil, nil, nil, true)
                return 
            end 
        end
    end
    PostPlayerEvent:postEvent(PostPlayerEvent.event_chooiceServer)
    WZLog("WndServersSel:onRightCallBack", Serialize(data))
    self:_changeServerId(data.serverId, data.name)
    WindowManager:removeWindow(self.m_root , WndServersSel , true)
end

-- 点击左边列表回调
function WndServersSel:onLeftCallBack(tag)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if tag == 0 then --我的服务器
        if not self.myServer then
           self:_initMyServer()
        end
    elseif tag == 1 then --推荐服务器
        if not self.recommendServer then
            self:_initRemmonderServer()
        end
    elseif tag == 2 then --所有区
        if not self.allServers then
            self:_initAllServers()
        end
    end
    self.index = tag
    self:_createRightList(tag)
    self:_changeLeftSelState(tag)
    WZLog("-------------tag------------------",tag)
end
-------------------------------------公有方法模块End--------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
-- 创建左边列表
function WndServersSel:_createLeftList()
    if not self.allServers or #self.allServers == 0 then 
        return 
    end

    local tab = GetElement(self.m_root,"tabLeftList_WndServersSel",WZUITableContainer)
    tab:cleanTable()
    -- 获取需要显示的服务器表 0 表示我的服务器，1表示推荐服务器 其他的表示具体的区
    self.leftList = {}
    local name = self:_getServerNameList()
    local maxLen = #self.allServers + 2
    for i = 1, maxLen do
        local cell , tcell = CellSelectServer:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:SetInfo(name[i])
        tcell:setCallBackFunc(self,self.onLeftCallBack)
        self:_saveLeftListData(cell,tcell,i-1)
        if i == (self.index + 1) then tcell:setSelState(1)  end
    end
end

-- 创建右边列表
function WndServersSel:_createRightList()
    if not self.allServers or #self.allServers == 0 then
        return 
    end
    local tab = GetElement(self.m_root,"tabRightList_WndServersSel",WZUITableContainer)
    tab:cleanTable()
    -- 获取需要显示的服务器表 0 表示我的服务器，1表示推荐服务器 其他的表示具体的区
    local list = self:_getNeedServerList(self.index)
    for i = 1, #list do
        local cell , tcell = CellLoginServer:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:SetServerInfo(list[i])
        tcell:setCallBackFunc(self,self.onRightCallBack)
    end
end

-- 改变左边列表的状态
function WndServersSel:_changeLeftSelState(index)
    for i = 1, #self.leftList do
        local state = index == i-1 and 1 or 0
        self.leftList[i].tcell:setSelState(state)
    end
end

function WndServersSel:_btnTime()
    self.btnTime = self.btnTime - 1
    WZLog("----------------btnTime----------------",self.btnTime)
    if self.btnTime == 0 then
        local btn = GetElement(self.m_root,"btnUpdate_WndServersSel",WZUIButton)
        btn:setTouchEnable(true)
        btn:disableSchedule()
    end
end

function WndServersSel:createLoadingBox()
    WZLog("----------self.loading---------------",self.loadingId)
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(10,self,self.closeLoadingBox)
        WZLog("WndServersSel--------createloadingID",self.loadingId)
    end
end

function WndServersSel:closeLoadingBox()
    MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
    WZLog("WndServersSel--------closeloadingID",self.loadingId)
    self.loadingId = nil
end

function WndServersSel:getIpdHttpServerList()
    if IPDhttpServer.IpdServerInfo then
        local testUrl = "http://" .. ProjConfig:getIpdAddr() .. "/serverList?version=" .. IPDhttpServer:getIpdVersion() .. "&channel=" .. ProjConfig:getChannelId() .. "&token=" .. IPDhttpServer:getIpdToken()
        IPDhttpServer:getHttpServerList(testUrl)
    else
        WndLoginSelect:getIpdHttpServerList()
    end
    self:createLoadingBox()
end

function WndServersSel:onEditChange(element)

end
function WndServersSel:onclickSend(element)
    GetElement(self.m_root,"conBtn_WndServersSel",WZUIContainer):setVisible(true)
end
--取消选择的时候
function WndServersSel:onclickResetEd(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    GetElement(self.m_root,"conBtn_WndServersSel",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"eb_WndServersSel",WZUIEditBox):setText("")
    
    local tab = GetElement(self.m_root,"tabRightList_WndServersSel",WZUITableContainer)
    tab:cleanTable()
    -- 获取需要显示的服务器表 0 表示我的服务器，1表示推荐服务器 其他的表示具体的区
    local list = self:_getNeedServerList(self.index)
    for i = 1, #list do
        local cell , tcell = CellLoginServer:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:SetServerInfo(list[i])
        tcell:setCallBackFunc(self,self.onRightCallBack)
    end
end
--模糊查找
function WndServersSel:onClickSearch(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local eb = GetElement(self.m_root,"eb_WndServersSel",WZUIEditBox)
    local tempText = eb:getText()
    tempText = string.gsub(tempText," ","")

    if tempText == "" then
        MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY) 
    else
        local tempT = self:_findByName(tempText) --查找结果
        local tab = GetElement(self.m_root,"tabRightList_WndServersSel",WZUITableContainer)
        tab:cleanTable()
        for i = 1, #tempT do
            local cell , tcell = CellLoginServer:createElement()
            cell:setTag(i-1)
            tab:setCellElement(cell)
            tcell:SetServerInfo(tempT[i])
            tcell:setCallBackFunc(self,self.onRightCallBack)
        end
    end
end
--根据物品查找物品列表
function WndServersSel:_findByName(name)
    if not self.allServers then
        return {}
    end
    local tempT = {}
    local itemName = nil
    local exist = nil
    for m=1,#self.allServers do
        for i,v in pairs(self.allServers[m]) do
            itemName = v.name
            exist = string.find(itemName,name)
            if exist and exist > 0 then
                table.insert(tempT,v)
            end
        end
    end
    return tempT
end
-------------------------------------私有方法模块End----------------------------------------