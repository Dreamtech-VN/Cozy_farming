--CellSpaceRecord.lua
--@brief	CellSpaceRecord的UI模块
--@date		2016/01/06
--@author	zsq
--@note		记录cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSpaceRecord:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSpaceRecord:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
local nameTemplate = [[<I Z="1" P="1">%s</I><T C="127,70,26" S="20" P="1">%s</T>]]
--@brief	踩一踩记录
function CellSpaceRecord:setType1(tData,index)
	if self.m_root == nil then return end
	GetElement(self.m_root,"conType1_CellSpaceRecord",WZUIContainer):setVisible(true)
	--等级
	GetElement(self.m_root,"txtLv_CellSpaceRecord",WZUILabelTTF):setText(LocalStrings.LV..tData.playerLevel[index])
	--名字
	local img = ""
	if tData.serverId[index] ~= CacheCenter:getPlayerInfo().serverId then
		img = "ui/common/common_icon_kuafu.png"
	end
	GetElement(self.m_root,"txtName_CellSpaceRecord",WZUIFreeTextBox):setShowText(string.format(nameTemplate,img,tData.playerName[index]))
	--是否获得礼物
	if tData.isAwards[index] then
		GetElement(self.m_root,"imgType1_CellSpaceRecord",WZUIImage):setVisible(true)
		GetElement(self.m_root,"txtType1_CellSpaceRecord",WZUILabelTTF):setText(LocalStrings.SPACE13)
		GetElement(self.m_root,"txtType1_CellSpaceRecord",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.47,0.3))
	else
		GetElement(self.m_root,"imgType1_CellSpaceRecord",WZUIImage):setVisible(false)
		GetElement(self.m_root,"txtType1_CellSpaceRecord",WZUILabelTTF):setText(LocalStrings.SPACE14)
		GetElement(self.m_root,"txtType1_CellSpaceRecord",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.34,0.3))
	end
	--id
	self.m_nPlayerId = tData.playerId[index]
	--level
	self.m_nLevel = tData.playerLevel[index]
	--头像
	local con = GetElement(self.m_root,"conHead_CellSpaceRecord",WZUIContainer)
	con:removeAllChildrenWithCleanup(true)
	if tData.headScul[index] ~= "" then 
		--添加下载图片Cell
		local celElement,tCell = CellDownloadImg:createElement()
		con:addChild(celElement)

		WndSpaceMain:addDownloadFileList(tData.headScul[index], tCell, nil, 60)
	end
end


--@brief	收鲜花记录
function CellSpaceRecord:setType2(tData,index)
	if self.m_root == nil then return end
	if "vn" == ProjConfig.LANGUAGE then
		local type2 = GetElement(self.m_root,"textType2_CellSpaceRecord",WZUIFreeTextBox)
		--type2:setRelativePosition(GlobalMethod:ccp(0.3,0.3))
		type2:setScale(0.6)
	end
	if "th" == ProjConfig.LANGUAGE then
		GetElement(self.m_root,"textType2_CellSpaceRecord",WZUIFreeTextBox):setScale(0.73)
	end
	GetElement(self.m_root,"conType2_CellSpaceRecord",WZUIContainer):setVisible(true)
	--等级
	GetElement(self.m_root,"txtLv_CellSpaceRecord",WZUILabelTTF):setText(LocalStrings.LV..tData.playerLevel[index])
	--名字
	local img = ""
	if tData.serverId[index] ~= CacheCenter:getPlayerInfo().serverId then
		img = "ui/common/common_icon_kuafu.png"
	end
	GetElement(self.m_root,"txtName_CellSpaceRecord",WZUIFreeTextBox):setShowText(string.format(nameTemplate,img,tData.playerName[index]))
	--是否获得礼物
	local string = [[<T C="105,65,46" S="20" P="0">%s</T><T C="158,0,0" S="20" P="0">%s</T>]]
	GetElement(self.m_root,"imgType2_CellSpaceRecord",WZUIImage):setFile("ui/marrige/common_pic_hd1.png")
	for k,v in pairs(GDatatab_flowers) do
		if v.id == tData.flowersId[index] then
			GetElement(self.m_root,"textType2_CellSpaceRecord",WZUIFreeTextBox):setShowText(string.format(string,LocalStrings.SPACE25,"X"..tostring(v.popularity)))
		end
	end
	--id
	self.m_nPlayerId = tData.playerId[index]
	--level
	self.m_nLevel = tData.playerLevel[index]
	--头像
	local con = GetElement(self.m_root,"conHead_CellSpaceRecord",WZUIContainer)
	con:removeAllChildrenWithCleanup(true)
	if tData.headScul[index] ~= "" then 
		--添加下载图片Cell
		local celElement,tCell = CellDownloadImg:createElement()
		con:addChild(celElement)

		WndSpaceMain:addDownloadFileList(tData.headScul[index], tCell, nil, 60)
	end
end

--@brief	访客记录
function CellSpaceRecord:setType3(tData,index)
	if self.m_root == nil then return end
	GetElement(self.m_root,"conType3_CellSpaceRecord",WZUIContainer):setVisible(true)
	--等级
	GetElement(self.m_root,"txtLv_CellSpaceRecord",WZUILabelTTF):setText(LocalStrings.LV..tData.playerLevel[index])
	--名字
	local img = ""
	if tData.serverId[index] ~= CacheCenter:getPlayerInfo().serverId then
		img = "ui/common/common_icon_kuafu.png"
	end
	GetElement(self.m_root,"txtName_CellSpaceRecord",WZUIFreeTextBox):setShowText(string.format(nameTemplate,img,tData.playerName[index]))
	--访问时间
	local string = [[<T C="128,54,13" S="20" P="0">%s %s</T>]]
	local time = tData.interviewTime[index]
	GetElement(self.m_root,"textType3_CellSpaceRecord",WZUIFreeTextBox):setShowText(string.format(string,time,""))
	--id
	self.m_nPlayerId = tData.playerId[index]
	--level
	self.m_nLevel = tData.playerLevel[index]
	--头像
	local con = GetElement(self.m_root,"conHead_CellSpaceRecord",WZUIContainer)
	con:removeAllChildrenWithCleanup(true)
	if tData.headScul[index] ~= "" then 
		--添加下载图片Cell
		local celElement,tCell = CellDownloadImg:createElement()
		con:addChild(celElement)

		WndSpaceMain:addDownloadFileList(tData.headScul[index], tCell, nil, 60)
	end
end

--@brief	鲜花榜记录
function CellSpaceRecord:setFlowerRecord(tData)
	if self.m_root == nil then return end
	--是否获得礼物
	local conType2 = GetElement(self.m_root,"conType2_CellSpaceRecord",WZUIContainer)
	conType2:setVisible(true)
	local imgType2 = GetElement(self.m_root,"imgType2_CellSpaceRecord",WZUIImage)
	imgType2:setFile("shopitems/meilixianhua.png")
	imgType2:setScale(0.5)
	local string = [[<T C="105,65,46" S="20" P="0">%s</T><T C="158,0,0" S="20" P="0">%s</T>]]
	local textType2 = GetElement(self.m_root,"textType2_CellSpaceRecord",WZUIFreeTextBox)
	textType2:setShowText(string.format(string,LocalStrings.SPACE70,"X"..tData.num))
	--等级
	GetElement(self.m_root,"txtLv_CellSpaceRecord",WZUILabelTTF):setText(LocalStrings.LV..tData.level)
	--名字
	local img = ""
	if tData.serverId == 1 then
		img = "ui/common/common_icon_kuafu.png"
	end
	GetElement(self.m_root,"txtName_CellSpaceRecord",WZUIFreeTextBox):setShowText(string.format(nameTemplate,img,tData.name))
	--访问时间
	-- local string = [[<T C="128,54,13" S="20" P="0">%s %s</T>]]
	-- local time = tData.interviewTime[index]
	-- GetElement(self.m_root,"textType3_CellSpaceRecord",WZUIFreeTextBox):setShowText(string.format(string,time,""))
	--id
	-- self.m_nPlayerId = tData.playerId[index]
	--level
	-- self.m_nLevel = tData.playerLevel[index]

	--头像
	local con = GetElement(self.m_root,"conHead_CellSpaceRecord",WZUIContainer)
	con:removeAllChildrenWithCleanup(true)
	if tData.headScul ~= "" then 
		--添加下载图片Cell
		local celElement,tCell = CellDownloadImg:createElement()
		con:addChild(celElement)

		WndSpaceMain:addDownloadFileList(tData.headScul, tCell, nil, 60)
	end

	if ProjConfig.LANGUAGE == "vn" then
		imgType2:setScale(0.35)
		textType2:setScale(0.6)
		textType2:setRelativePosition(GlobalMethod:ccp(0.45,0.3))
	end
end

--@brief	打开个人空间
function CellSpaceRecord:onSpace(element)
	WZLog("CellSpaceRecord:onSpace")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--if self.m_nLevel < 25 then
	--	MsgBoxManager:showTipBox(string.format(LocalStrings.PLAYER_LEVEL_UNREACHED,25))
	--	return
	--end
	if WndSpaceMain.m_root ~= nil then
		WndSpaceMain:showOther(self.m_nPlayerId)
	else
		WndSpaceMain:show(self.m_nPlayerId)
	end
	WindowManager:removeWindow(WndSpaceRecord.m_root, WndSpaceRecord, true)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellSpaceRecord:_adaptLanguage_pt(  )
	local type2 = GetElement(self.m_root,"textType2_CellSpaceRecord",WZUIFreeTextBox)
	type2:setScale(0.7)
	local type1 = GetElement(self.m_root,"txtType1_CellSpaceRecord",WZUILabelTTF)
	type1:setDimensions(GlobalMethod:CCSize(100))
	local type3 = GetElement(self.m_root,"textType3_CellSpaceRecord",WZUIFreeTextBox)
	type3:setScale(0.7)
end

function CellSpaceRecord:_adaptLanguage_tr(  )
	local type2 = GetElement(self.m_root,"textType2_CellSpaceRecord",WZUIFreeTextBox)
	type2:setScale(0.7)
	local type1 = GetElement(self.m_root,"txtType1_CellSpaceRecord",WZUILabelTTF)
	type1:setFontSize(14)
	local type3 = GetElement(self.m_root,"textType3_CellSpaceRecord",WZUIFreeTextBox)
	type3:setScale(0.7)
end

function CellSpaceRecord:_adaptLanguage_en(  )
	local txtType1 = GetElement(self.m_root,"txtType1_CellSpaceRecord",WZUILabelTTF)
	txtType1:setScale(0.74)
	local textType2 = GetElement(self.m_root,"textType2_CellSpaceRecord",WZUIFreeTextBox)
	textType2:setScale(0.65)
end

function CellSpaceRecord:_adaptLanguage_es(  )
	local type2 = GetElement(self.m_root,"textType2_CellSpaceRecord",WZUIFreeTextBox)
	type2:setScale(0.6)
	local type1 = GetElement(self.m_root,"txtType1_CellSpaceRecord",WZUILabelTTF)
	type1:setDimensions(GlobalMethod:CCSize(100))
	local type3 = GetElement(self.m_root,"textType3_CellSpaceRecord",WZUIFreeTextBox)
	type3:setScale(0.7)

	GetElement(self.m_root,"txtName_CellSpaceRecord",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.58,0.726))
end
--------------------------------------语言适配End--------------------------------------