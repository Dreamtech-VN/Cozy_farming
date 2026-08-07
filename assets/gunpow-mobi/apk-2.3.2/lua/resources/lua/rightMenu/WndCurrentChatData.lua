--WndCurrentChatData.lua
--@brief	WndCurrentChat的数据模块
--@date		2014/01/20
--@author	孙珊珊
--@note		当前聊天接口

WndCurrentChat = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCurrentChat:_init()
	WZLog("WndCurrentChat:_init")
	self.m_root = nil	 	  			--场景根节点
	self.m_tChatData = nil
	self.nItemNumber = 0                --计数
	self.fontsize = 18                --文字大小
	self.m_tCurRootScene = nil          --存放当前显示场景
	self.m_nLastSeconds = 0             --存放最后发送信息的时间
	self.m_nMaxCount = 2                --显示最多多少条聊天信息
	self.m_nMaxTxtCount = 24            --底部聊天的文字最多显示多少个字
	--self.m_tChatListCache = {}
	self.m_sSceneName = nil             --当前聊天场景
   	self.m_tColor = 
	{
		ccc3(238, 112, 0),
		ccc3(238, 196, 0),
		ccc3(84, 238, 0),
		ccc3(0, 238, 224),
		ccc3(238, 0, 67),
		ccc3(146, 0, 238),
		ccc3(0, 118, 238)
	}
	self.m_nCount = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCurrentChat:_unInit()
	WZLog("WndCurrentChat:_unInit")
	self.m_root = nil
	self.m_tChatData = nil
	--self.nItemNumber = nil
	--self.fontsize = nil
	--self.m_tCurRootScene = nil
	--self.m_tCurSceneLuaObj = nil
	--self.m_tColor = nil
	--self.m_nLastSeconds = nil
	--self.isHiden= nil
	--self.m_tChatListCache = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCurrentChat:createElement()
	WZLog("WndCurrentChat:createElement")
	local element = WZUISystem:getInstance():createElement("WndCurrentChat")
	assert(element, "WndCurrentChat create element failed!")
	self:_init()
	return element
end



--@brief	调用喇叭接口函数
	-- channel : 频道（0世界，1当前，2公会，3队伍，4私聊，5系统，6彩聊）
	-- sendId : 信息发送人ID
	-- sendName : 信息发送人名称
	-- receiveId : 信息接收人ID
	-- receiveName : 信息接收人名称
	-- message : 聊天内容
	-- time : MM-dd
	--vipLevel发送人vip等级（系统的默认为0）
	--bRecordChat ：是否是语音信息
	--channel, sendId, sendName, receiveId, receiveName, message, rtime,vipLevel ,bRecordChat
function WndCurrentChat:getChatInfo(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,bRecordChat)
    WZLog("self.isHiden",WndChat.isHiden)
    if iMainChannel == CHANNEL_SYSTEM and sSendName ~= LocalStrings.TIP then
    	return
    end
    if self.m_root == nil then
    	return
    end
    if self.m_nCount < 1 then  --显示速度限制
    	return
    end
    self.m_nCount = 0
	self.m_tChatData = self:_createListNode(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,bRecordChat)
	self.m_tChatData.mainChannelName = self:_getChannelTableAndName(iMainChannel) --获取频道的名字
	--[[
	if #self.m_tChatListCache >= 2 then
		table.remove(self.m_tChatListCache,1)
	end
	table.insert(self.m_tChatListCache,self.m_tChatData)
	--]]
	self.m_nLastSeconds = os.time() --获取当前时间
	
	local freeConChat  = GetElement(self.m_root,"freeConChat_WndCurrentChat",WZUIFreeListContainer)
	local conEle =WZUIContainer:luaTo(self.m_root:getChildElement("con_WndCurrentChat"))
	if WndChat.isHiden then
		conEle:setVisible(true)
	end
	freeConChat:update()
	self:_update()
end

--设置显示最多显示多少条聊天信息
function WndCurrentChat:setMaxCount(count)
	-- body
	WZLog("WndCurrentChat:setMaxCount")
	self.m_nMaxCount = count
end

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------回调函数Begin--------------------------------------
--@brief   定时器回调函数(每秒调用一次)
function WndCurrentChat:callBackCheck(element)
	--WZLog("WndCurrentChat:callBackCheck")
	self.m_nCount = self.m_nCount + 1
	local conEle = self.m_root:getChildElement("con_WndCurrentChat")
	local freeConChat = GetElement(self.m_root,"freeConChat_WndCurrentChat",WZUIFreeListContainer)
	self.m_root:setVisible(true)
	if conEle then
		if not conEle:isVisible() then
			self.m_nLastSeconds = os.time()
		end
	end
	
	local curTime = os.time()
	--WZLog("curTime = ",curTime,curTime-self.m_nLastSeconds)
	if curTime-self.m_nLastSeconds > 5 and self.m_nLastSeconds ~= 0 then --如果超过5秒没人说话自动把左下角聊天信息隐藏
		conEle:setVisible(false)
	end
end
-------------------------------------回调函数end--------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
