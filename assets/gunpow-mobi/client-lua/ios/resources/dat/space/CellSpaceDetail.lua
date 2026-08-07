--CellSpaceDetail.lua
--@brief	CellSpaceDetail的UI模块
--@date		2016/01/06
--@author	zsq
--@note		留言cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSpaceDetail:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSpaceDetail:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function CellSpaceDetail:update(tData,index)
	if self.m_root == nil then return end
	if tData.playerLevel[index] == nil then return end
	--添加下载图片Cell
	local con = GetElement(self.m_root,"conHeadImg",WZUIContainer)
	con:removeAllChildrenWithCleanup(true)
	local celElement,tCell = CellDownloadImg:createElement()
	con:addChild(celElement)

	--访客不显示删除按钮
	GetElement(self.m_root,"btnDelete_CellSpaceDetail",WZUIButton):setVisible(WndSpaceMain.m_bIsHost)
	--等级
	GetElement(self.m_root,"txtLv_CellSpaceDetail",WZUILabelTTF):setText(LocalStrings.LV..tData.playerLevel[index])
	--名字
	local nameTemplate = [[<I Z="1" P="1">%s</I><T C="62,34,8" S="22" P="1">%s</T>]]
	local img = ""
	if tData.serverId[index] ~= CacheCenter:getPlayerInfo().serverId then
		img = "ui/common/common_icon_kuafu.png"
	end
	GetElement(self.m_root,"txtName_CellSpaceDetail",WZUIFreeTextBox):setShowText(string.format(nameTemplate,img,tData.playerName[index]))
	--消息
	GetElement(self.m_root,"txtMessage_CellSpaceDetail",WZUILabelTTF):setText(tData.messages[index])
	--时间
	GetElement(self.m_root,"txtTime_CellSpaceDetail",WZUILabelTTF):setText(tData.sendTime[index])
	--头像
	if tData.headScul[index] ~= "" then 
		WndSpaceMain:addDownloadFileList(tData.headScul[index], tCell,nil,63)
	end
	--记录索引
	self.m_nIndex = tData.index[index]
	self.playerId = tData.playerId[index]
end

--@brief	查看信息
function CellSpaceDetail:onCheck(element)
	WZLog("CellSpaceDetail:onCheck",self.playerId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.playerId)
	WndCheckOther.m_nChecFromMsg = true
end

--@brief	删除留言
function CellSpaceDetail:onDelete(element)
	WZLog("CellSpaceDetail:onDelete",self.m_nIndex)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    MsgBoxManager:showConfirmBox(LocalStrings.SPACE40, self, self.onDeleteCall, MSGBOXLEVEL_HIGH)
end

--@brief	删除留言回调
function CellSpaceDetail:onDeleteCall(element)
	ProtocolProcessorWndSpace:send_SPACE_DelMessage(self.m_nIndex)
	MsgBoxManager:showTipBox(LocalStrings.SPACE41)
end
-------------------------------------私有方法模块End----------------------------------------

function CellSpaceDetail:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtName_CellSpaceDetail",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.325,0.7))
end