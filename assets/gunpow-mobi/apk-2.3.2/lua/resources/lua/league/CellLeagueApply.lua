--CellLeagueApply.lua
--@brief	CellLeagueApply的UI模块
--@date		2016/06/15
--@author	zsq
--@note		查看申请


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLeagueApply:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLeagueApply:onExit(element)
	self:_unInit()
end

function CellLeagueApply:setData(tData)
    self.m_tData = tData
end

function CellLeagueApply:onClick()
	WZLog("CellLeagueApply:onClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	SceneLeagueMain.m_nCheckType = 1
	SceneLeagueMain.m_tCheckWnd = WndLeagueApply
	SceneLeagueMain.m_tCheckElement = self
	ProtocolProcessorWndLeague:send_HERO_SearchTeam(self.m_tData.id )
	--ProtocolProcessorWndLeague:send_HERO_SearchTeam(1000297 )
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellLeagueApply:onLoadData(element)
	local cellElement = WZUISystem:getInstance():createElement("CellLeagueApply")
	assert(cellElement, "CellLeagueApply cellElement create failed!")
    self.m_root:addChild(cellElement)

	WZLog("报名列表",Serialize(self.m_tData))
	--名字 
	GetElement(self.m_root,"txtName",WZUILabelTTF):setText(self.m_tData.name)
	--积分
	GetElement(self.m_root,"txtScore",WZUILabelTTF):setText(self.m_tData.score)
	--战队图标
	local con = GetElement(self.m_root,"conHead",WZUIContainer)
	con:removeAllChildrenWithCleanup(true)
	if self.m_tData.url ~= "" then 
		--添加下载图片Cell
		local celElement,tCell = CellDownloadImg:createElement()
		con:addChild(celElement)

		SceneLeagueMain:addDownloadFileList(self.m_tData.url, tCell, nil, 50)
	end
	--颜色
	WZLog("战队id和我的id是",self.m_tData.id,CacheCenter:getPlayerInfo().teamId)
	if self.m_tData.id == CacheCenter:getPlayerInfo().teamId then
		self:setGreen()
	end
end

--@brief	把底图设置成绿色
function CellLeagueApply:setGreen()
	GetElement(self.m_root,"txtName",WZUILabelTTF):setColor(GlobalMethod:ccc3(64,128,1))
	GetElement(self.m_root,"txtScore",WZUILabelTTF):setColor(GlobalMethod:ccc3(64,128,1))
	GetElement(self.m_root, "imgBtn1_CellLeagueApply", WZUI9Image):setFile("ui/common/frame_lieb.png")
	GetElement(self.m_root, "imgBtn2_CellLeagueApply", WZUI9Image):setFile("ui/common/frame_lieb_01.png")
	GetElement(self.m_root, "imgBtn3_CellLeagueApply", WZUI9Image):setFile("ui/common/frame_lieb.png")
end



-------------------------------------私有方法模块End----------------------------------------
