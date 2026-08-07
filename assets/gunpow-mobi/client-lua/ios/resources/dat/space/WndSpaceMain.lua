--WndSpaceMain.lua
--@brief	WndSpaceMain的UI模块
--@date		2016/01/06
--@author	zsq
--@note		个人空间主窗口

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSpaceMain:onEnter(element)
	self.m_root = element
	self.m_nCurIndex = 1

	--ProtocolProcessorWndSpace:regAll()

	--开启下载检测
	self.m_root:enableSchedule("downloadFile",0.1)

	Protocol:reg( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GiveFlowerOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GiveFlowerOk", "t")

end

----@brief onEnter函数执行完成回调
function WndSpaceMain:onEnterTransitionDidFinish(element)
	if self.m_nPlayerId ~= nil then
		ProtocolProcessorWndSpace:send_SPACE_GetSpaceInfo(self.m_nPlayerId)  
	else
		return
	end

	if WndCheckOther.m_root ~= nil then WndCheckOther.m_root:setVisible(false) end
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSpaceMain:onExit(element)

	-- if ProtocolProcessorWndLbs.m_adapter then
	-- 	WydPlAdapterManager:sharedWydPlAdapterManager():destroyAdapter(ProtocolProcessorWndLbs.m_adapter:getId())
 --        ProtocolProcessorWndLbs.m_adapter = nil
	-- end

	self:_unInit()
	--ProtocolProcessorWndSpace:unregAll()
	Protocol:unreg( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GiveFlowerOk, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GiveFlowerOk", "t")
end

--@brief	触摸函数，判断消息是否在消息框显示范围内，如果不是的话，就让消息框不显示，反之，显示
function WndSpaceMain:onTouchBegan(element, point)
	local bFlag = WndPopupMenu:ifPointInMenu(point)
	if bFlag == false then 
		WndPopupMenu:disappear()
	end 
end

--@brief	触摸函数，判断消息是否在消息框显示范围内，如果不是的话，就让消息框不显示，反之，显示
function WndSpaceMain:onTouchEnd(element, point)

end

--@brief	外部调用显示接口
function WndSpaceMain:show(id)
	WZLog("WndSpaceMain:show",id)
	if id == nil then id = CacheCenter:getPlayerInfo().id end
	if SceneRoom.m_root ~= nil or SceneGuildWarRoom.m_root then
		MsgBoxManager:showTipBox(LocalStrings.SPACE97)
		return
	end
	if self.m_root == nil then
		self.m_nPlayerId = id
		local wnd = WndSpaceMain:createElement()
		WindowManager:addWindow(wnd, WndSpaceMain, true, nil, nil, true)
		--self.m_root:setVisible(false)
	end
end

--@brief	打开其他个人空间
function WndSpaceMain:showOther(id)
	WZLog("WndSpaceMain:showOther",id)
	if id == nil then return end
	--如果查看信息界面打开，并且是自己的界面，同步头像
	if WndCheckOther.m_root ~= nil and self.m_tData ~= nil and WndCheckOther.m_tPlayerInfo.id == self.m_tData.playerId then
		--CacheCenter:getPlayerInfo().headScul = self.m_tData.headScul
		--GetElement(WndCheckOther.m_tSpaceCell.m_root,"headSpace",WZUIImage):setFile(GetElement(self.m_root,"imgHead_WndSpaceMain",WZUIImage):getFile())
	end
	if self.m_root ~= nil then
		self.m_nPlayerId = id
		ProtocolProcessorWndSpace:send_SPACE_GetSpaceInfo(self.m_nPlayerId)
	end
end

--@brief	关闭按钮点击回调
function WndSpaceMain:onClose(element)
    WZLog("WndSpaceMain:onClose")  			  
	if WndCheckOther.m_root ~= nil then WndCheckOther.m_root:setVisible(true) end
	--如果查看信息界面打开，并且是自己的界面，同步头像
	if WndCheckOther.m_root ~= nil and self.m_tData ~= nil and WndCheckOther.m_tPlayerInfo.id == self.m_tData.playerId then
		--CacheCenter:getPlayerInfo().headScul = self.m_tData.headScul
		--GetElement(WndCheckOther.m_tSpaceCell.m_root,"headSpace",WZUIImage):setFile(GetElement(self.m_root,"imgHead_WndSpaceMain",WZUIImage):getFile())
	end
	if WndSpaceDetail and WndSpaceDetail.m_bPlaying == true then WndSpaceDetail:resumeBgMusic() WndSpaceDetail.m_bPlaying = false end
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	查看信息
function WndSpaceMain:onClose1(element)
    WZLog("WndSpaceMain:onClose1")  			  
	if WndSpaceDetail and WndSpaceDetail.m_bPlaying == true then WndSpaceDetail:resumeBgMusic() WndSpaceDetail.m_bPlaying = false end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--如果个人信息界面关闭了，重新打开
	if WndCheckOther.m_root ~= nil then 
		WindowManager:removeWindow(WndCheckOther.m_root, WndCheckOther, true)
	end
	if WndCheckOther.m_root == nil then WndCheckOther:show(self.m_nPlayerId) end
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	最近访客列表
function WndSpaceMain:onMore(element)
	WZLog("WndSpaceMain:onMore")
	if WndSpaceDetail and WndSpaceDetail.m_bPlaying == true then WndSpaceDetail:resumeBgMusic() WndSpaceDetail.m_bPlaying = false end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd = WndSpaceRecord:createElement()
	WindowManager:addWindow(wnd, WndSpaceRecord, true, nil, nil, true)
	WndSpaceRecord:setType3()
end

--@brief	访客踩一踩
function WndSpaceMain:onLeft1(element)
	WZLog("WndSpaceMain:onLeft1")
	if WndSpaceDetail and WndSpaceDetail.m_bPlaying == true then WndSpaceDetail:resumeBgMusic() WndSpaceDetail.m_bPlaying = false end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorWndSpace:send_SPACE_JoinPlayer(self.m_nPlayerId)
end

--@brief	访客送鲜花
function WndSpaceMain:onLeft2(element)
	WZLog("WndSpaceMain:onLeft2")
	if WndSpaceDetail and WndSpaceDetail.m_bPlaying == true then WndSpaceDetail:resumeBgMusic() WndSpaceDetail.m_bPlaying = false end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd = WndSpaceSendFlower:createElement()
	WindowManager:addWindow(wnd, WndSpaceSendFlower, true, nil, nil, true)
end

--@brief	放置礼物
function WndSpaceMain:onBtn1(element)
	if WndSpaceDetail and WndSpaceDetail.m_bPlaying == true then WndSpaceDetail:resumeBgMusic() WndSpaceDetail.m_bPlaying = false end
	if self.m_bIsHost ~= true then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd = WndSpacePutGift:createElement()
	WindowManager:addWindow(wnd, WndSpacePutGift, true, nil, nil, true)
end

--@brief	人气记录
function WndSpaceMain:onBtn2(element)
	if WndSpaceDetail and WndSpaceDetail.m_bPlaying == true then WndSpaceDetail:resumeBgMusic() WndSpaceDetail.m_bPlaying = false end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd = WndSpaceRecord:createElement()
	WindowManager:addWindow(wnd, WndSpaceRecord, true, nil, nil, true)
	WndSpaceRecord:setType1()
end

--@brief	魅力
function WndSpaceMain:onBtn3(element)
	if WndSpaceDetail and WndSpaceDetail.m_bPlaying == true then WndSpaceDetail:resumeBgMusic() WndSpaceDetail.m_bPlaying = false end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd = WndSpaceRecord:createElement()
	WindowManager:addWindow(wnd, WndSpaceRecord, true, nil, nil, true)
	WndSpaceRecord:setType2()
end

--@brief	发送留言
function WndSpaceMain:onSendMessage(element)
	WZLog("WndSpaceMain:onSendMessage")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--留言等级限制
	if CheckButtonOpen(62) ~= true then return end

	local editBox = GetElement(self.m_root,"edit_WndSpaceMain",WZUIEditBox)
	local inputText = editBox:getText() 

	if inputText == LocalStrings.SPACE20 or inputText == "" then 
		MsgBoxManager:showTipBox(LocalStrings.SPACE21)
	else
		inputText = inputText.." "
		ProtocolProcessorWndSpace:send_SPACE_SendMessage(self.m_nPlayerId , inputText )
		editBox:setText("")
	end 
end

--@brief	点击头像查看大图
function WndSpaceMain:onCheckHeadPic(element)
    WZLog("WndSpaceMain:onCheckHeadPic")
	if self.m_tData == nil then return end
	local wnd = WndSpaceView:createElement()
	WindowManager:addWindow(wnd, WndSpaceView, true, nil, nil, true)

	--如果已经下载头像
	if self.m_tData.headScul ~= nil and self.m_tData.headScul ~= "" then
		local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..self.m_tData.headScul
	--如果有设置默认头像
	local fileName = self.m_tData.headScul
	if string.find(fileName, [[http]]) ~= nil then
		local photoName = WndAdvertising:getFileName(fileName)
		path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..photoName
	end
		--如果文件存在，不下载，直接使用
		local bExist = WZFileUtil:isFileExist(path)
		if bExist then
			GetElement(wnd,"imgWndSpaceView",WZUIImage):setFile(path)
		else
			GetElement(wnd,"imgWndSpaceView",WZUIImage):setFile("ui/space/common_icon_renxiangnan.png")
		end
	else
		local headImg = GetElement(self.m_root,"imgHead_WndSpaceMain",WZUIImage):getFile()
		GetElement(wnd,"imgWndSpaceView",WZUIImage):setFile(headImg)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	切换子窗口
function WndSpaceMain:switchTab()
	if self.m_root == nil then return end
	if WndSpaceDetail and WndSpaceDetail.m_bPlaying == true then WndSpaceDetail:resumeBgMusic() WndSpaceDetail.m_bPlaying = false end
    --获取各界面的节点
    local conCurWindow = GetElement(self.m_root,"conSubWnd_WndSpaceMain",WZUIContainer)
    local conPlayerInfo = GetElement(self.m_root, "conPlayerInfo_WndSpaceMain", WZUIContainer)
    local conPhoto = GetElement(self.m_root, "conPhoto_WndSpaceMain", WZUIContainer)

	GetElement(self.m_root,"conSetting",WZUIContainer):setVisible(false)
	--玩家性别等信息
	if WndSpaceDetail.m_root ~= nil then
		WndSpaceDetail.m_root:setVisible(true)
		WndSpaceDetail:update()
	else
		local wnd1 = WndSpaceDetail:createElement()
		conPlayerInfo:addChild(wnd1)
	end
	--留言
	if WndSpaceMessage.m_root ~= nil then
		WndSpaceMessage.m_root:setVisible(true)
	else
		local wnd1 = WndSpaceMessage:createElement()
		conCurWindow:addChild(wnd1)
	end
	--从服务端获取数据
	ProtocolProcessorWndSpace:send_SPACE_GetMessageList(WndSpaceMain.m_nPlayerId)
	--照片墙
	if WndSpacePhoto.m_root ~= nil then
		WndSpacePhoto.m_root:setVisible(true)
	else
		local wnd1 = WndSpacePhoto:createElement()
		conPhoto:addChild(wnd1)
	end
	GetElement(self.m_root,"conEdit_WndSpaceMain",WZUIContainer):setVisible(true)
	--从服务端获取数据
	ProtocolProcessorWndSpace:send_SPACE_GetPhotoList(WndSpaceMain.m_nPlayerId)
end

--@brief	更新界面
function WndSpaceMain:update()
	if self.m_root == nil then return end
	self.m_root:setVisible(true)
	self:switchTab()
	--设置是否是自己空间
	if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
		self.m_bIsHost = true
	else
		self.m_bIsHost = false
	end
	--区分主人访客
	GetElement(self.m_root,"conHost1",WZUIContainer):setVisible(self.m_bIsHost)
	GetElement(self.m_root,"conGuest",WZUIContainer):setVisible(not self.m_bIsHost)
	GetElement(self.m_root, "conSetting", WZUIContainer):setVisible(self.m_bIsHost)
	--送过鲜花后不可点击
	if self.m_tData.beGFLower == true then
		GetElement(self.m_root,"btnSendFlower",WZUIButton):setTouchEnable(false)
	else
		GetElement(self.m_root,"btnSendFlower",WZUIButton):setTouchEnable(true)
	end

	local flowerActivityConfig = CacheCenter:getGameParam().flowerActivityConfig
	if flowerActivityConfig and tonumber(flowerActivityConfig) ~= 0 and #SplitStringWithSeparator(flowerActivityConfig,",") > 0 then
		GetElement(self.m_root,"btnSendFlower",WZUIButton):setTouchEnable(true)
	end

	local tData = self.m_tData
	--等级
	GetElement(self.m_root,"userLevel_WndSpaceMain",WZUILabelTTF):setText(LocalStrings.LV..tData.playerLevel)
	--名字
	local nameTemplate = [[<I Z="1" P="1">%s</I><T C="255,255,255" S="22" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]]
	local img = ""
	if tData.serverId ~= CacheCenter:getPlayerInfo().serverId then
		img = "ui/common/common_icon_kuafu.png"
	end
	GetElement(self.m_root,"userName_WndSpaceMain",WZUIFreeTextBox):setShowText(string.format(nameTemplate,img,tData.playerName))
	--性别
	if tData.playerSex == 0 then
		GetElement(self.m_root,"imgSex_WndSpaceMain",WZUIImage):setFile("ui/space/common_icon_hanzi2.png")
		GetElement(self.m_root,"imgSex_WndSpaceMain",WZUIImage):setVisible(true)
	elseif tData.playerSex == 1 then
		GetElement(self.m_root,"imgSex_WndSpaceMain",WZUIImage):setFile("ui/space/common_icon_meizhi2.png")
		GetElement(self.m_root,"imgSex_WndSpaceMain",WZUIImage):setVisible(true)
	else
		GetElement(self.m_root,"imgSex_WndSpaceMain",WZUIImage):setVisible(false)
	end
	--礼物
	GetElement(self.m_root,"ttf1_WndSpaceMain",WZUILabelTTF):setText(tData.giftNum..LocalStrings.SPACE4)
	--人气
	GetElement(self.m_root,"ttf2_WndSpaceMain",WZUILabelTTF):setText(tData.popularity)
	--魅力
	GetElement(self.m_root,"ttf3_WndSpaceMain",WZUILabelTTF):setText(tData.charmNum)
	--设置留言默认内容
	GetElement(self.m_root,"edit_WndSpaceMain",WZUIEditBox):setPlaceHolder(LocalStrings.SPACE20)
	--设置
	GetElement(self.m_root,"checkBox1_WndSpaceMain",WZUICheckBox):setCheckIndex(tData.locSeting)
	GetElement(self.m_root,"checkBox2_WndSpaceMain",WZUICheckBox):setCheckIndex(tData.pahSeting)
	GetElement(self.m_root,"checkBox3_WndSpaceMain",WZUICheckBox):setCheckIndex(tData.msgSeting)
	--下载访客头像
	-- for i=1,6 do
	-- 	GetElement(self.m_root,"defaultHead"..i.."_WndSpaceMain",WZUIImage):setVisible(false)
	-- end
	-- for i=1,#tData.visitorsInfos do
	-- 	local con1 = GetElement(self.m_root,"conGuestHead"..i,WZUIContainer)
	-- 	con1:removeAllChildrenWithCleanup(true)
	-- 	if tData.visitorsInfos[i] ~= "" then
	-- 		--添加下载图片Cell
	-- 		local celElement,tCell = CellDownloadImg:createElement()
	-- 		con1:addChild(celElement)

	-- 		self:addDownloadFileList(tData.visitorsInfos[i], tCell, nil, 63)
	-- 		if GetElement(self.m_root,"default"..i.."_WndSpaceMain",WZUIImage) then
	-- 			GetElement(self.m_root,"default"..i.."_WndSpaceMain",WZUIImage):setVisible(false)
	-- 		end
	-- 	else
	-- 		if GetElement(self.m_root,"default"..i.."_WndSpaceMain",WZUIImage) then
	-- 			GetElement(self.m_root,"default"..i.."_WndSpaceMain",WZUIImage):setVisible(true)
	-- 		end
	-- 		if GetElement(self.m_root,"defaultHead"..i.."_WndSpaceMain",WZUIImage) then
	-- 			GetElement(self.m_root,"defaultHead"..i.."_WndSpaceMain",WZUIImage):setVisible(true)
	-- 		end
	-- 	end
	-- end

	--下载头像
	local con = GetElement(self.m_root,"conImgHead",WZUIContainer)
	con:removeAllChildrenWithCleanup(true)
	if tData.headScul ~= nil and tData.headScul ~= "" then

		--如果有设置默认头像
		local fileName = tData.headScul
		--添加下载图片Cell
		local celElement,tCell = CellDownloadImg:createElement()
		con:addChild(celElement)
		tCell:setFile("ui/space/common_icon_renxiangnan.png")

		if string.find(fileName, [[http]]) ~= nil then
			--tCell:setFile(fileName)
			--GetElement(self.m_root,"imgHead_WndSpaceMain",WZUIImage):setVisible(false)
		local downURL = fileName
		local photoName = WndAdvertising:getFileName(fileName)
		--如果文件存在，不下载，直接使用
		local imgPhoto = GetElement(self.m_root,"imgHead_WndSpaceMain",WZUIImage)
		local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..photoName
		local bExist = WZFileUtil:isFileExist(path)
		local platForm =  WZUISystem:getInstance():getPlatformInfo()
		WZLog("判断baidu文件是否存在",path,photoName,bExist)
		downURL = downURL:gsub("\n","")
		downURL = downURL:gsub("\r","")
		if bExist then

			imgPhoto:setVisible(true)
			imgPhoto:setUseOriginSize(true)
			imgPhoto:setFile(path)
			WZLog("设置百度头像")
			local size = imgPhoto:getContentSize()
			local hh = 180
			local x = hh/size.width 
			local y = hh/size.height
			imgPhoto:setScale(math.min(x,y))
			tCell:setFile(path)
			tCell:setScale(math.min(x,y))
			return
		elseif downURL ~= "" then
			if platForm == 3 then
				path = photoName
			end
			local multiThread = WZUISystem:getInstance():getMultiThreadSystem()
			local downloadTask = WZHTTPFileLuaTask:create(CacheCenter:getPlayerInfo().id, downURL, path, self.httpDownloadFinish, self)
			multiThread:addDownloadTaskInFront(downloadTask)
		end
			return
		end

		self:addDownloadFileList(tData.headScul, tCell,nil,180)
	else
		GetElement(self.m_root,"imgHead_WndSpaceMain",WZUIImage):setVisible(true)
		GetElement(self.m_root,"imgHead_WndSpaceMain",WZUIImage):setScale(1)
		if tData.playerSex == 0 then
			GetElement(self.m_root,"imgHead_WndSpaceMain",WZUIImage):setFile("ui/space/common_icon_renxiangnan.png")
			--如果是修改自己信息，更新查看信息界面的个人空间头像
			if self.m_bIsHost and WndCheckOther.m_tSpaceCell then
				GetElement(WndCheckOther.m_tSpaceCell.m_root,"headSpace",WZUIImage):setFile("ui/space/common_icon_renxiangnan.png")
				GetElement(WndCheckOther.m_tSpaceCell.m_root,"imgSexSpace",WZUIImage):setFile("ui/space/common_icon_hanzi2.png")
			end
		elseif tData.playerSex == 1 then
			GetElement(self.m_root,"imgHead_WndSpaceMain",WZUIImage):setFile("ui/space/common_icon_renxiangnv.png")
			--如果是修改自己信息，更新查看信息界面的个人空间头像
			if self.m_bIsHost and WndCheckOther.m_tSpaceCell then
				GetElement(WndCheckOther.m_tSpaceCell.m_root,"headSpace",WZUIImage):setFile("ui/space/common_icon_renxiangnv.png")
				GetElement(WndCheckOther.m_tSpaceCell.m_root,"imgSexSpace",WZUIImage):setFile("ui/space/common_icon_meizhi2.png")
			end
		else
			--如果是修改自己信息，更新查看信息界面的个人空间头像
			if self.m_bIsHost then
				if WndCheckOther.m_tSpaceCell ~= nil and WndCheckOther.m_tSpaceCell.m_root ~= nil then
					GetElement(WndCheckOther.m_tSpaceCell.m_root,"imgSexSpace",WZUIImage):setVisible(false)
				end
			end
			local headSex = 0
			if WndCheckOther and WndCheckOther.m_tPlayerInfo then
				headSex = WndCheckOther.m_tPlayerInfo.sex
			end
			if headSex == 0 then
				GetElement(self.m_root,"imgHead_WndSpaceMain",WZUIImage):setFile("ui/space/common_icon_renxiangnan.png")
				--如果是修改自己信息，更新查看信息界面的个人空间头像
				if self.m_bIsHost then
					if WndCheckOther.m_tSpaceCell ~= nil and WndCheckOther.m_tSpaceCell.m_root ~= nil then
						GetElement(WndCheckOther.m_tSpaceCell.m_root,"headSpace",WZUIImage):setFile("ui/space/common_icon_renxiangnan.png")
					end
				end
			elseif headSex == 1 then
				GetElement(self.m_root,"imgHead_WndSpaceMain",WZUIImage):setFile("ui/space/common_icon_renxiangnv.png")
				--如果是修改自己信息，更新查看信息界面的个人空间头像
				if self.m_bIsHost then
					GetElement(WndCheckOther.m_tSpaceCell.m_root,"headSpace",WZUIImage):setFile("ui/space/common_icon_renxiangnv.png")
				end
			end
		end
	end
end

--@brief	http下载回调
function WndSpaceMain:httpDownloadFinish(taskId, path, totalSize, nowSize, finish, failed)
	WZLog("WndSpaceMain:httpDownloadFinish",taskId,finish,path,failed)
	if taskId ~= CacheCenter:getPlayerInfo().id then
		return
	end
	if self.m_root == nil then
		return
	elseif finish then
		WZLog("pathxxxxxxxqWWWWWWWWWWWW:::",path)
		local imgPhoto = GetElement(self.m_root,"imgHead_WndSpaceMain",WZUIImage)
		imgPhoto:setVisible(true)
		imgPhoto:setUseOriginSize(true)
		imgPhoto:setFile(path)
		local size = imgPhoto:getContentSize()
		local hh = 180
		local x = hh/size.width 
		local y = hh/size.height
		imgPhoto:setScale(math.min(x,y))
		self.m_tHeadCell:setFile(path)
		self.m_tHeadCell:setScale(math.min(x,y))
	else
		WZLog("taskId:::::::::::::::::::::::::::::::",taskId)
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------下载文件管理Begin----------------------------------------
--@brief 	新增下载文件任务
--@param	fileName文件名,tCell1设置图片的Cell,tCell2设置图片的Cell
function WndSpaceMain:addDownloadFileList(fileName, tCell1, tCell2, size, tCell)
	WZLog("WndSpaceMain:addDownloadFileList",fileName)
	if fileName == nil or fileName == "" then return end
	self.m_nSize = size
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..fileName
	--如果文件存在，不下载，直接使用
	local bExist = WZFileUtil:isFileExist(path)
	if bExist then
		WZLog("文件存在",tCell1,tCell2,tCell ~= nil)
		local fileError = false
		if tCell1 ~= nil then 
			tCell1:setFile(path) 
			if self.m_nSize ~= nil then
				local imgSize = tCell1:getContentSize()
				local x = self.m_nSize/imgSize.width 
				local y = self.m_nSize/imgSize.height
				WZLog("缩放比例",self.m_nSize,imgSize.width,imgSize.height,math.max(x,y))
				tCell1:setScale(math.max(x,y))
				if imgSize.width < 10 or imgSize.width > 1000 then fileError = true end
				if imgSize.height < 10 or imgSize.height > 1000 then fileError = true end
			end
		end
		if tCell2 ~= nil then 
			tCell2:setFile(path) 
			if self.m_nSize ~= nil then
				local imgSize = tCell2:getContentSize()
				local x = self.m_nSize/imgSize.width 
				local y = self.m_nSize/imgSize.height
				tCell2:setScale(math.max(x,y))
			end
		end
		if tCell ~= nil then
			WZLog("隐藏loding",tCell.m_nIndex)
			tCell:setLodingPhoto(false)
			if fileError then tCell:setInvalidPhoto() end
		end
	else
		--在下载列表中新增记录
		if self.m_tDownloadFileList == nil then self.m_tDownloadFileList = {} end
		--检测是否是重复任务
		for i=1,#self.m_tDownloadFileList do
			if fileName == self.m_tDownloadFileList[i].fileName then
				WZLog("重复下载",fileName)
				return
			end
		end
		local tempTable = {fileName=fileName,tCell1=tCell1,tCell2=tCell2,status="init",tCell=tCell}
		table.insert(self.m_tDownloadFileList,tempTable)
	end
end

--@brief	下载文件
function WndSpaceMain:downloadFile(element,t)
	--列表中没有任务，返回
	if self.m_tDownloadFileList == nil or #self.m_tDownloadFileList == 0 then return end
	--有文件正在下载，返回
	for i=1,#self.m_tDownloadFileList do
		if self.m_tDownloadFileList[i].status=="downloading" then return end
	end
	--没有文件正在下载，开始下载第一个任务
	local fileName = self.m_tDownloadFileList[1].fileName
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..fileName
	local s = {}
	s.filePath = path
	s.objName = fileName
	DSSdkManager:downFile(json.encode(s),self.downloadFileFinish, self)
	WZLog("WndSpaceMain 调用sdk下载文件",fileName, path)
	self.m_tDownloadFileList[1].status="downloading"
	--WndSpaceMain:createLoading()
end

--@brief	下载成功回调
function WndSpaceMain:downloadFileFinish(result)
	WZLog("WndSpaceMain:downloadFileFinish",result)
	if self.m_tDownloadFileList == nil or #self.m_tDownloadFileList == 0 then return end
	local result = json.decode(result)
	local fileName = result.objName
	--如果下载失败，把任务清出队列，返回
	WZLog("下载结果",result["return"])
	if result["return"] == "fail" then
		for i=1,#self.m_tDownloadFileList do
			if self.m_tDownloadFileList[i].status == "downloading" then
				table.remove(self.m_tDownloadFileList,i)
				return
			end
		end
	end 
	if fileName == nil then return end
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..result.objName
	--WZLog("下载完成",path,Serialize(self.m_tDownloadFileList))
	WZLog("下载完成",path)

	for i=1,#self.m_tDownloadFileList do
		WZLog(i,self.m_tDownloadFileList[i],self.m_tDownloadFileList[i].fileName,fileName)
		if self.m_tDownloadFileList[i].fileName == fileName and self.m_tDownloadFileList[i].status == "downloading" then
			local x,y
			if self.m_tDownloadFileList[i].tCell ~= nil then
				if self.m_tDownloadFileList[i].tCell.m_root ~= nil then
					if self.m_tDownloadFileList[i].tCell1 ~= nil then
						local imgPhoto = self.m_tDownloadFileList[i].tCell1
						imgPhoto:setFile(path)
						local size = imgPhoto:getContentSize()
						local hh = 236
						if self.m_nSize ~= nil then hh = self.m_nSize end
						x = hh/size.width 
						y = hh/size.height
						imgPhoto:setScale(math.max(x,y))
					end
					if self.m_tDownloadFileList[i].tCell2 ~= nil then
						local imgPhoto = self.m_tDownloadFileList[i].tCell2
						imgPhoto:setFile(path)
						imgPhoto:setScale(math.max(x,y))
					end
				end
				self.m_tDownloadFileList[i].tCell:setLodingPhoto(false)
			else
				if self.m_tDownloadFileList[i].tCell1 ~= nil then
					local imgPhoto = self.m_tDownloadFileList[i].tCell1
					imgPhoto:setFile(path)
					local size = imgPhoto:getContentSize()
					local hh = 236
					if self.m_nSize ~= nil then hh = self.m_nSize end
					x = hh/size.width 
					y = hh/size.height
					imgPhoto:setScale(math.max(x,y))
				end
				if self.m_tDownloadFileList[i].tCell2 ~= nil then
					local imgPhoto = self.m_tDownloadFileList[i].tCell2
					imgPhoto:setFile(path)
					imgPhoto:setScale(math.max(x,y))
				end
			end
			--一次只下载一个文件,从列表中找到即可返回
			table.remove(self.m_tDownloadFileList,i)
			--WndSpaceMain:closeLoading()
			self.m_nSize = nil
			return
		end
	end
end

function WndSpaceMain:_adaptLanguage_vn()
    WZLog("WndSpaceMain:_adaptLanguage_vn ")
    GetElement(self.m_root,"checkBox1_WndSpaceMain",WZUICheckBox):setVisible(false)
	GetElement(self.m_root,"txtOpenLocation_WndSpaceMain",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"txtPhoto_WndSpaceMain",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.12,0.61))
	GetElement(self.m_root,"checkBox2_WndSpaceMain",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.032,0.61))
	GetElement(self.m_root,"txtMessage_WndSpaceMain",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.22,0.5))
	GetElement(self.m_root,"checkBox3_WndSpaceMain",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end

--@brief	英文适配函数
function WndSpaceMain:_adaptLanguage_en()
	 WZLog("WndSpaceMain:_adaptLanguage_en")
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"txtLM_WndSpaceMain",WZUILabelTTF):setScale(0.5)

	GetElement(self.m_root,"txt_WndSpaceMain",WZUI9Label):setFontSize(22)
	GetElement(self.m_root,"checkBox1_WndSpaceMain",WZUICheckBox):setVisible(false)
	GetElement(self.m_root,"txtOpenLocation_WndSpaceMain",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"txtPhoto_WndSpaceMain",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.12,0.61))
	GetElement(self.m_root,"checkBox2_WndSpaceMain",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.032,0.61))
	GetElement(self.m_root,"txtMessage_WndSpaceMain",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.22,0.5))
	GetElement(self.m_root,"checkBox3_WndSpaceMain",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	
	local txtTab21 = GetElement(self.m_root,"txtTab21",WZUILabelTTF)
	txtTab21:setDimensions(GlobalMethod:CCSize(110,0))
	txtTab21:setScale(0.8)
	
	local txtTab22 = GetElement(self.m_root,"txtTab22",WZUILabelTTF)
	txtTab22:setDimensions(GlobalMethod:CCSize(110,0))
	txtTab22:setScale(0.8)
end 

function WndSpaceMain:_adaptLanguage_pt(  )
	if self.m_root == nil then
		return
	end

	local txt = GetElement(self.m_root,"txt_WndSpaceMain",WZUI9Label)
	txt:setFontSize(22)
	txt:setDimensions(GlobalMethod:CCSize(190,0))

end

function WndSpaceMain:_adaptLanguage_th(  )
	GetElement(self.m_root,"checkBox1_WndSpaceMain",WZUICheckBox):setVisible(false)
	GetElement(self.m_root,"txtOpenLocation_WndSpaceMain",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"txtTab21",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtTab22",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtPhoto_WndSpaceMain",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.12,0.61))
	GetElement(self.m_root,"checkBox2_WndSpaceMain",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.032,0.61))
	GetElement(self.m_root,"txtMessage_WndSpaceMain",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.22,0.5))
	GetElement(self.m_root,"checkBox3_WndSpaceMain",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.5))

	GetElement(self.m_root,"ttfLeftDown1",WZUILabelTTF):setScale(0.8)
end

function WndSpaceMain:_adaptLanguage_cn(  )
	GetElement(self.m_root,"checkBox1_WndSpaceMain",WZUICheckBox):setVisible(false)
	GetElement(self.m_root,"txtOpenLocation_WndSpaceMain",WZUILabelTTF):setVisible(false)
	GetElement(self.m_root,"txtPhoto_WndSpaceMain",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.12,0.61))
	GetElement(self.m_root,"checkBox2_WndSpaceMain",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.032,0.61))
	GetElement(self.m_root,"txtMessage_WndSpaceMain",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.22,0.5))
	GetElement(self.m_root,"checkBox3_WndSpaceMain",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end
function WndSpaceMain:_adaptLanguage_tr()
	GetElement(self.m_root,"ttfLeftDown1",WZUILabelTTF):setScale(0.75)
	
	local txtLM = GetElement(self.m_root,"txtLM_WndSpaceMain",WZUILabelTTF)
	txtLM:setScale(0.65)
	txtLM:setDimensions(GlobalMethod:CCSize(110,0))

	GetElement(self.m_root,"txt_WndSpaceMain",WZUI9Label):setFontSize(20)

	local txtTab21 = GetElement(self.m_root,"txtTab21",WZUILabelTTF)
	txtTab21:setScale(0.8)
	txtTab21:setDimensions(GlobalMethod:CCSize(110,0))
	local txtTab22 = GetElement(self.m_root,"txtTab22",WZUILabelTTF)
	txtTab22:setScale(0.8)
	txtTab22:setDimensions(GlobalMethod:CCSize(110,0))
end

function WndSpaceMain:_adaptLanguage_es(  )
	GetElement(self.m_root,"txt_WndSpaceMain",WZUI9Label):setFontSize(22)
	GetElement(self.m_root,"userLevel_WndSpaceMain",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"userName_WndSpaceMain",WZUIFreeTextBox):setScale(0.7)
end
-------------------------------------下载文件管理End----------------------------------------
