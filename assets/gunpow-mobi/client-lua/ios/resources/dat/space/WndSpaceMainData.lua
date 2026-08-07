--WndSpaceMainData.lua
--@brief	WndSpaceMain的数据模块
--@date		2016/01/06
--@author	zsq
--@note		个人空间主窗口

WndSpaceMain = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSpaceMain:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurIndex = nil
	self.m_bIsHost = nil
	self.m_tData = nil
	self.m_sPath = nil
	self.m_tDownloadFileList = nil		--待下载的文件列表
	self.m_nSize = nil
	self.m_nLoadingId = nil
	self.m_tHeadCell = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSpaceMain:_unInit()
	self.m_root = nil
	self.m_nCurIndex = nil
	self.m_bIsHost = nil
	self.m_nPlayerId = nil
	self.m_tData = nil
	self.m_nFlowerNum = nil
	self.m_nProfit = nil
	self.m_sPath = nil
	self.m_tDownloadFileList = nil		--待下载的文件列表
	self.m_nSize = nil
	self.m_nLoadingId = nil
	self.m_tHeadCell = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSpaceMain:createElement()
	local element = WZUISystem:getInstance():createElement("WndSpaceMain")
	assert(element, "WndSpaceMain create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	保存数据
function WndSpaceMain:setData(playerId , playerName, playerSex, playerLevel, title, headScul, guildName, position, mateName, birthday, playerAge, playerCon, distance, voiceInfo, giftNum, popularity, charmNum, giftPrice, visitorsInfos, locSeting, pahSeting, msgSeting, todayGFNum, beGFLower, serverId)
	self.m_tData = {}
	self.m_tData.playerId = playerId
	self.m_tData.playerName = playerName
	self.m_tData.playerSex = playerSex
	self.m_tData.playerLevel = playerLevel
	self.m_tData.title = title
	self.m_tData.headScul = headScul
	self.m_tData.guildName = guildName
	self.m_tData.position = position
	self.m_tData.mateName = mateName
	self.m_tData.birthday = birthday
	self.m_tData.playerAge = playerAge
	self.m_tData.playerCon = playerCon
	self.m_tData.distance = distance
	self.m_tData.voiceInfo = voiceInfo
	self.m_tData.giftNum = giftNum
	self.m_tData.popularity = popularity
	self.m_tData.charmNum = charmNum
	self.m_tData.giftPrice = giftPrice
	self.m_tData.visitorsInfos = VectorToTable(visitorsInfos)
	self.m_tData.locSeting = locSeting
	self.m_tData.pahSeting = pahSeting
	self.m_tData.msgSeting = msgSeting
	self.m_tData.todayGFNum = todayGFNum
	self.m_tData.beGFLower = beGFLower
	self.m_tData.serverId = serverId

	self:update()
	WndSpaceDetail:update()
end

--@brief	更新个人资料
function WndSpaceMain:sendProtocol()
	ProtocolProcessorWndSpace:send_SPACE_UpdatePlayerInfo(self.m_tData.playerSex, self.m_tData.birthday, self.m_tData.playerAge, self.m_tData.playerCon, self.m_tData.voiceInfo, self.m_tData.locSeting, self.m_tData.pahSeting, self.m_tData.msgSeting)
end

--@brief	公开地理位置信息
function WndSpaceMain:onCheckBox1()

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData == nil then return end
	local checkBox = GetElement(self.m_root,"checkBox1_WndSpaceMain",WZUICheckBox)
	self.m_tData.locSeting = (checkBox:getCheckIndex() + 1) % 2
    WZLog("WndSpaceMain:onCheckBox1", self.m_tData.locSeting)
	self:sendProtocol()

	if self.m_tData.locSeting == 0 then
		--ProtocolProcessorWndLbs:send_NEIGHBOR_SelfPlayerNeighborInfo()
	end
	--checkBox:setCheckIndex(nFalg)
end

--@brief	设置自定义头像
function WndSpaceMain:onCheckBox2()
	WZLog("WndSpaceMain:onCheckBox2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local checkBox = GetElement(self.m_root,"checkBox2_WndSpaceMain",WZUICheckBox)
	self.m_tData.pahSeting = (checkBox:getCheckIndex() + 1) % 2
	self:sendProtocol()
end

--@brief	 设置空间留言
function WndSpaceMain:onCheckBox3()
	WZLog("WndSpaceMain:onCheckBox3")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local checkBox = GetElement(self.m_root,"checkBox3_WndSpaceMain",WZUICheckBox)
	self.m_tData.msgSeting = (checkBox:getCheckIndex() + 1) % 2
	self:sendProtocol()
end

-------------------------------------私有方法模块End----------------------------------------
--@brief   创建加载框
function WndSpaceMain:createLoading()
	if self.m_root == nil then return end
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndSpaceMain:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end



--@brief	英文适配函数
function WndSpaceMain:_adaptLanguage_th()
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"ttfLeftDown1",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtTab21",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtTab22",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtTab31",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtTab32",WZUILabelTTF):setScale(0.7)
end 
