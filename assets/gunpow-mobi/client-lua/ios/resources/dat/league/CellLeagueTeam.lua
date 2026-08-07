--CellLeagueTeam.lua
--@brief	CellLeagueTeam的UI模块
--@date		2016/06/12
--@author	zsq
--@note		战队列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLeagueTeam:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLeagueTeam:onExit(element)
	self:_unInit()
end

function CellLeagueTeam:setData(tData)
    self.m_tData = tData
end

function CellLeagueTeam:onApply(element)
	WZLog("CellLeagueTeam:onApply")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	element:setVisible(false)	
	ProtocolProcessorWndLeague:send_HERO_ApplyHeroTeam(tonumber(self.m_tData.id))
end

function CellLeagueTeam:onCheck(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	SceneLeagueMain.m_nCheckType = 1
	SceneLeagueMain.m_tCheckWnd = WndLeagueTeamList
	SceneLeagueMain.m_tCheckElement = self
	ProtocolProcessorWndLeague:send_HERO_SearchTeam(self.m_tData.id )
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellLeagueTeam:onLoadData(element)
	local cellElement = WZUISystem:getInstance():createElement("CellLeagueTeam")
	assert(cellElement, "CellLeagueTeam cellElement create failed!")
    self.m_root:addChild(cellElement)

	WZLog("战队详情",Serialize(self.m_tData))
	--id
	GetElement(self.m_root,"txtId_CellLeagueTeam",WZUILabelTTF):setText("ID:"..self.m_tData.id)
	--名字
	GetElement(self.m_root,"txtName_CellLeagueTeam",WZUILabelTTF):setText(self.m_tData.name)
	--人数
	GetElement(self.m_root,"txtNumber_CellLeagueTeam",WZUILabelTTF):setText(self.m_tData.memberNumber.."/4")
	--战队图标
	local con = GetElement(self.m_root,"conHead",WZUIContainer)
	con:removeAllChildrenWithCleanup(true)
	if self.m_tData.icon ~= "" then 
		--添加下载图片Cell
		local celElement,tCell = CellDownloadImg:createElement()
		con:addChild(celElement)

		SceneLeagueMain:addDownloadFileList(self.m_tData.icon, tCell, nil, 60)
	end
end




-------------------------------------私有方法模块End----------------------------------------
