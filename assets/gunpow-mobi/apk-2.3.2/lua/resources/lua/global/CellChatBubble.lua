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
		local strFontColor = self:setBgAndArrow()
		local strColor = nil 
		if strFontColor then 
			strColor = string.gsub(strFontColor, "|", ",")
			local tColor = SplitStringWithSeparator(strFontColor, "|", nil, true)
			txtTemp:setColor(GlobalMethod:ccc3(tColor[1],tColor[2],tColor[3]))
		end
		txtTemp:setText(msg)
		local tempWidth = txtTemp:getLabelContentSize().width

		msg = ToChangeFreeText(msg, strColor,nil,nil,nil,20)
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
	WZLog("CellChatBubble:getBgAndArrow")
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
	local fontColor = nil 
	if bubbId ~= nil and bubbId > 0 then
		local bubbleInfo = GDatatab_item["id_" .. bubbId]
		local strBubble = SplitStringWithSeparator(bubbleInfo.animation_index_code,",")
		if strBubble[1] == "talk_01" then
			bgFile = "ui/chat/talk_13.png"
			bgArrow = "ui/chat/talk_25.png"
		elseif strBubble[1] == "talk_02" then
			bgFile = "ui/chat/talk_14.png"
			bgArrow = "ui/chat/talk_26.png"
		elseif strBubble[1] == "talk_03" then
			bgFile = "ui/chat/talk_15.png"
			bgArrow = "ui/chat/talk_27.png"
		elseif strBubble[1] == "talk_04" then
			bgFile = "ui/chat/talk_16.png"
			bgArrow = "ui/chat/talk_28.png"
		elseif strBubble[1] == "talk_05" then
			bgFile = "ui/chat/talk_17.png"
			bgArrow = "ui/chat/talk_29.png"
		elseif strBubble[1] == "talk_06" then
			bgFile = "ui/chat/talk_18.png"
			bgArrow = "ui/chat/talk_30.png"
		elseif strBubble[1] == "talk_07" then
			bgFile = "ui/chat/talk_19.png"
			bgArrow = "ui/chat/talk_31.png"
		elseif strBubble[1] == "talk_08" then
			bgFile = "ui/chat/talk_20.png"
			bgArrow = "ui/chat/talk_32.png"
		elseif strBubble[1] == "talk_09" then
			bgFile = "ui/chat/talk_21.png"
			bgArrow = "ui/chat/talk_33.png"
		elseif strBubble[1] == "talk_34" then
			bgFile = "ui/chat/talk_40.png"
			bgArrow = "ui/chat/talk_46.png"
		elseif strBubble[1] == "talk_35" then
			bgFile = "ui/chat/talk_41.png"
			bgArrow = "ui/chat/talk_47.png"
		elseif strBubble[1] == "talk_36" then
			bgFile = "ui/chat/talk_42.png"
			bgArrow = "ui/chat/talk_48.png"
		elseif strBubble[1] == "talk_37" then
			bgFile = "ui/chat/talk_43.png"
			bgArrow = "ui/chat/talk_49.png"
		elseif strBubble[1] == "talk_38" then
			bgFile = "ui/chat/talk_44.png"
			bgArrow = "ui/chat/talk_50.png"
		elseif strBubble[1] == "talk_39" then
			bgFile = "ui/chat/talk_45.png"
			bgArrow = "ui/chat/talk_51.png"
		elseif strBubble[1] == "talk_54" then
			bgFile = "ui/chat/talk_53.png"
			bgArrow = "ui/chat/talk_52.png"
		elseif strBubble[1] == "talk_57" then
			bgFile = "ui/chat/talk_56.png"
			bgArrow = "ui/chat/talk_55.png"
		else
			if #strBubble >= 3 then
				if strBubble[2] ~= "-1" then 
					bgFile = "ui/chat/"..strBubble[2]..".png"
				end
				if strBubble[3] ~= "-1" then 
					bgArrow = "ui/chat/"..strBubble[3]..".png"
				end
			end
		end
		if strBubble[4] and strBubble[4] ~= "-1" then 
			fontColor = strBubble[4]
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
	return bgFile,bgArrow,fontColor
end

function CellChatBubble:setBgAndArrow()
	-- body
	WZLog("CellChatBubble:setBgAndArrow")
	local bgFile,bgArrow,fontColor = self:getBgAndArrow()
	if bgFile ~= nil and bgFile ~= "" and bgArrow ~= "" then
		local imgBg = GetElement(self.m_root,"imgBg_CellChatBubble",WZUI9Image)
		local imgArrow = GetElement(self.m_root,"imgArrow_CellChatBubble",WZUIImage)
		imgBg:setFile(bgFile)
		imgArrow:setFile(bgArrow)
	end
	return fontColor
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
