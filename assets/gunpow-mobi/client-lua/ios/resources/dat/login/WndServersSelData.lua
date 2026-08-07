--WndServersSelData.lua
--@brief	WndServersSel的数据模块
--@date		2015-09-15
--@author	binshao
--@note		登陆服务器选择界面

WndServersSel = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndServersSel:_init()
	self.m_root = nil	 	  			--场景根节点
    self.myServer = {}
    self.recommendServer = {}
    self.allServers = {}
    self.leftList = {}
    self.index = 0
    self.btnTime = 0
    self.m_bIsChange = false
    self.m_nAccountCreateDays = 0
    self.m_nCurTime = nil 
    self.m_bIsHavedNewServer = false     --是否有标记新服
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndServersSel:_unInit()
    WZLog("WndServersSel:_unInit")
    self.m_root = nil
    self.myServer = nil
    self.recommendServer = nil
    self.allServers = nil
    self.leftList = nil
    self.index = nil
    self.btnTime = nil
    self.loadingId = nil
    self.m_bIsChange = nil
    self.m_nAccountCreateDays = nil 
    self.m_nCurTime = nil 
    self.m_bIsHavedNewServer = nil     --是否有标记新服
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndServersSel:createElement()
	local element = WZUISystem:getInstance():createElement("WndServersSel")
	assert(element, "WndServersSel create element failed!")
	self:_init()
	return element
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 初始化服务器信息
function WndServersSel:initServersInfo()
    self:_initMyServer()
    self:_initRemmonderServer()
    self:_initAllServers()
end

-- 初始化我的服务器
function WndServersSel:_initMyServer()
    local serverList = CopyTable(IPDhttpServer:getServerList())
    self.m_nAccountCreateDays = IPDhttpServer.IpdAccountCreateDays
    self.m_nCurTime = IPDhttpServer.IpdCurTime
    WZLog("---------------------init my server-----------------",serverList)
    if not serverList then return end
    local function sort(serversA,serversB)
        return serversA.loginTime > serversB.loginTime
    end
    table.sort(serverList,sort)

    self.myServer = {}
    local localId = IPDhttpServer:getCurServerId()
    for i = 1, #serverList do
        if serverList[i].loginTime > 0 or (localId ~= nil and serverList[i].serverId == tonumber(localId)) then
            table.insert(self.myServer,serverList[i])
        end
        if serverList[i].newserver == 1 then 
            self.m_bIsHavedNewServer = true
        end
    end
    WZLog("---------------------init my server-----------------",#self.myServer)
end

-- 推荐服务器列表
function WndServersSel:_initRemmonderServer()
    -- 根据tips 来确定，优先新服2 > 推荐1 > 火爆3 > 0
    local serverList = CopyTable(IPDhttpServer:getServerList())
    WZLog("---------------------init recomend server-----------------",serverList)
    if not serverList then return end
    local function sort(serversA,serversB)
        if serversA.tips ~= 0 and serversB.tips ~= 0 then
            if serversA.tips ~= serversB.tips then
                if serversA.tips == 2 then return true end
                if serversB.tips == 2 then return false end
                return serversA.tips < serversB.tips
            else
                return serversA.serverId > serversB.serverId
            end
        elseif serversA.tips == 0 and serversB.tips ~= 0 then
            return false
        elseif serversA.tips ~= 0 and serversB.tips == 0 then
            return true
        elseif serversA.tips == 0 and serversB.tips == 0 then
            return serversA.serverId > serversB.serverId
        end
        return serversA.serverId > serversB.serverId
    end
    table.sort(serverList,sort)

    self.recommendServer = {}
    for i = 1,#serverList do
        table.insert(self.recommendServer,serverList[i])
    end

    --越南要求推荐服务器列表只显示tips新服
    if ProjConfig.LANGUAGE == "vn" then
        self.recommendServer = {}
        for i = 1,#serverList do
            if serverList[i].tips == 2 then
                table.insert(self.recommendServer,serverList[i])
            end
        end
    end
    
    WZLog("---------------------init recomend server-----------------",#self.recommendServer)
end

-- 初始化当前的所有服务器列表
function WndServersSel:_initAllServers()
    local serverList = CopyTable(IPDhttpServer:getServerList())
    WZLog("---------------------init all server-----------------",serverList)
    if not serverList then return end
    -- 先进行ID排序，倒序
    local function sort(serversA,serversB)
        return serversA.serverId > serversB.serverId
    end
    table.sort(serverList,sort)

    self.allServers = {}
    local tempTab = {}
    -- 先根据groupid 分组
    for i = 1, #serverList do
        local index = serverList[i].groupid
        if not tempTab[index] then tempTab[index] = {} end
        table.insert(tempTab[index],serverList[i])
    end
    for k,v in pairs(tempTab) do
        table.insert(self.allServers,v)
    end
    
    -- 再根据groupid排序
    local function groupIdSort(v1,v2)
        return v1[1].groupid < v2[1].groupid
    end
    for i = 1, #self.allServers do
        table.sort(self.allServers,groupIdSort)
    end
    WZLog("---------------------init all server-----------------",#self.allServers)
end

-- 获取对应的服务器列表
function WndServersSel:_getNeedServerList(index)
    local list = {}
    if index == 0 then
        list = self.myServer
    elseif index == 1 then
        list = self.recommendServer
    else
        list = self.allServers[index-1]
--        local startI = (index-2)*10 + 1
--        local endI = (index-1)*10
--        for i = startI, endI do
--            if self.allServers[i] then
--                table.insert(list,self.allServers[i])
--            end
--        end
    end
    return list
end

-- 获取左边列表的名字
function WndServersSel:_getServerNameList()
    local name = {}
    table.insert(name,LocalStrings.LOGIN_MY_SERVER)
    table.insert(name,LocalStrings.LOGIN_RECOMMEND_SERVER)
    for i = 1, #self.allServers do
        table.insert(name,self.allServers[i][1].groupname)
    end

--    local maxLen = math.ceil(#self.allServers/10)
--    for i = maxLen , 1,-1 do
--        local startI = (i-1)*10+1
--        local endI = i*10
--        local str = startI..LocalStrings.SETTING_SERVER_AREA.."-"..endI..LocalStrings.SETTING_SERVER_AREA
--        table.insert(name,str)
--    end
    return name
end

-- 保存左边列表的数据
function WndServersSel:_saveLeftListData(cell,tcell,tag)
    self.leftList[tag+1] = {}
    self.leftList[tag+1] = {cell = cell,tcell = tcell}
end

--@brief    获取该账号是否已经创建过角色
--@note     用于判断是否是新账号，新账号只能进新服
function WndServersSel:_getAccountState()
    -- body
    local bCreated = false

    for i = 1, #self.myServer do
        if self.myServer[i].loginTime > 0 then 
            bCreated = true
            return bCreated 
        end
    end

    if self.m_nAccountCreateDays and self.m_nCurTime and self.m_nCurTime - self.m_nAccountCreateDays >= 2 * 24 * 3600 then 
        bCreated = true
    end

    if not bCreated then 
        if not self.m_bIsHavedNewServer then 
            bCreated = true
        end
    end

    return bCreated 
end
-------------------------------------私有方法模块End----------------------------------------