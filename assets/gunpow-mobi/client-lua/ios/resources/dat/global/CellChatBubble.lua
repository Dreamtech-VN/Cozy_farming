--CellChatBubble.lua
--@brief	CellChatBubble的UI模块
--@date		2016/06/23
--@author	qixiang
--@note		聊天冒泡


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellChatBubble:onEnter(element)
	WZLog("CellChatBubble:onEnter")
	self.m_root = element
end

function CellChatBubble:onEnterTransitionDidFinish()
	WZLog("CellChatBubble:onEnterTransitionDidFinish")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellChatBubble:onExit(element)
	self:_unInit()
end

--更新聊天信息
function CellChatBubble:updateMst(msg)
	WZLog("CellChatBubble:updateMst = ",msg)
	if msg ~= nil and msg ~= "" then
		self.m_root:enableSchedule("scheduleUpdateMsg",3)
		local txtMsg = GetElement(self.m_root,"txtMsg_CellChatBubble",WZUIFreeTextBox)
		local txtTemp = GetElement(self.m_root,"txtTemp_CellChatBubble",WZUILabelTTF)
		self:setBgAndArrow()
		txtTemp:setText(msg)
		local tempWidth = txtTemp:getLabelContentSize().width

		msg = ToChangeFreeText(msg,nil,nil,nil,nil,20)
		txtMsg:setShowText(msg)
		local height = 66
		local width = 200
		if tempWidth >= 120 then
			height = math.ceil(tempWidth / 70) * 20 + 10
		elseif tempWidth <= 80 then
			width = 120
		end
	    local sizee = GlobalMethod:CCSize(width,height)
	    WZLog("txtSize = ",height,width,tempWidth)
	    local con = WZUIContainer:luaTo(self.m_root)
	    con:setAbsContentSize(GlobalMethod:CCSize(sizee.width,sizee.height))
	    con:updateRelativeSize()

	    local imgArrow = GetElement(self.m_root,"imgArrow_CellChatBubble",WZUIImage)
	    imgArrow:setAbsPosition(GlobalMethod:ccp(width/2,6.5))
	    self.m_root:setVisible(true)
	end
end

--每隔3秒钟检查是否有新的信息，如果没有则把根节点进行隐藏
function CellChatBubble:scheduleUpdateMsg(element)
	self.m_root:setVisible(false)
end


function CellChatBubble:getBgAndArrow(bubbleId,playerId)
	WZLog("CellChatBubble:setBgAndArrow")
	local bubbId = bubbleId 
	local playerid = playerId
	if bubbId == nil then
		bubbId = self.m_nBubbleId
	end

	if playerid == nil then
		playerid = self.m_nPlayerId
	end
	
	local bgFile = ""
	local bgArrow = ""
	if bubbId ~= nil and bubbId > 0 then
		local bubbleInfo = GDatatab_item["id_" .. bubbId]
		if bubbleInfo.animation_index_code == "talk_01" then
			bgFile = "ui/chat/talk_13.png"
			bgArrow = "ui/chat/talk_25.png"
		elseif bubbleInfo.animation_index_code == "talk_02" then
			bgFile = "ui/chat/talk_14.png"
			bgArrow = "ui/chat/talk_26.png"
		elseif bubbleInfo.animation_index_code == "talk_03" then
			bgFile = "ui/chat/talk_15.png"
			bgArrow = "ui/chat/talk_27.png"
		elseif bubbleInfo.animation_index_code == "talk_04" then
			bgFile = "ui/chat/talk_16.png"
			bgArrow = "ui/chat/talk_28.png"
		elseif bubbleInfo.animation_index_code == "talk_05" then
			bgFile = "ui/chat/talk_17.png"
			bgArrow = "ui/chat/talk_29.png"
		elseif bubbleInfo.animation_index_code == "talk_06" then
			bgFile = "ui/chat/talk_18.png"
			bgArrow = "ui/chat/talk_30.png"
		elseif bubbleInfo.animation_index_code == "talk_07" then
			bgFile = "ui/chat/talk_19.png"
			bgArrow = "ui/chat/talk_31.png"
		elseif bubbleInfo.animation_index_code == "talk_08" then
			bgFile = "ui/chat/talk_20.png"
			bgArrow = "ui/chat/talk_32.png"
		elseif bubbleInfo.animation_index_code == "talk_09" then
			bgFile = "ui/chat/talk_21.png"
			bgArrow = "ui/chat/talk_33.png"
		end
	else
		local playerInfo = CacheCenter:getPlayerInfo()
		if playerInfo.id == playerid then
			bgFile = "ui/chat/talk_11.png"
		    bgArrow = "ui/chat/talk_23.png"
		else
			bgFile = "ui/chat/talk_10.png"
		    bgArrow = "ui/chat/talk_22.png"
		end
	end
	return bgFile,bgArrow
end

function CellChatBubble:setBgAndArrow()
	-- body
	WZLog("CellChatBubble:setBgAndArrow")
	local bgFile,bgArrow = self:getBgAndArrow()
	if bgFile ~= nil and bgFile ~= "" and bgArrow ~= "" then
		local imgBg = GetElement(self.m_root,"imgBg_CellChatBubble",WZUI9Image)
		local imgArrow = GetElement(self.m_root,"imgArrow_CellChatBubble",WZUIImage)
		imgBg:setFile(bgFile)
		imgArrow:setFile(bgArrow)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
