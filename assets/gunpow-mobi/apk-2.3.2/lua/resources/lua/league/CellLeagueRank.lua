--CellLeagueRank.lua
--@brief	CellLeagueRank的UI模块
--@date		2016/06/12
--@author	zsq
--@note		战队排名


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLeagueRank:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLeagueRank:onExit(element)
	self:_unInit()
end

function CellLeagueRank:setData(tData)
    self.m_tData = tData
	WZLog("CellLeagueRank:setData",Serialize(self.m_tData))
end

function CellLeagueRank:onClick(element)
	WZLog("CellLeagueRank:onClick",Serialize(self.m_tData))
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	SceneLeagueMain.m_nCheckType = 1
	SceneLeagueMain.m_tCheckWnd = WndLeagueMatch
	SceneLeagueMain.m_tCheckElement = self
	ProtocolProcessorWndLeague:send_HERO_SearchTeam(self.m_tData.id )
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellLeagueRank:onLoadData(element)
	local element = WZUISystem:getInstance():createElement("CellLeagueRank")
	assert(element, "CellLeagueRank element create failed!")
    self.m_root:addChild(element)
	element:setLuaObjectIndex(self)

	--排名
	GetElement(self.m_root,"img_CellLeagueRank",WZUIImage):setVisible(true)
	if self.m_tData.rank == 1 then
		GetElement(self.m_root,"img_CellLeagueRank",WZUIImage):setFile("ui/common/common_icon_1st_1.png")
	elseif self.m_tData.rank == 2 then
		GetElement(self.m_root,"img_CellLeagueRank",WZUIImage):setFile("ui/common/common_icon_2nd_1.png")
	elseif self.m_tData.rank == 3 then
		GetElement(self.m_root,"img_CellLeagueRank",WZUIImage):setFile("ui/common/common_icon_3rd_1.png")
	else
		GetElement(self.m_root,"img_CellLeagueRank",WZUIImage):setVisible(false)
		GetElement(self.m_root,"txtRank_CellLeagueRank",WZUILabelTTF):setText(self.m_tData.rank)
	end
	--战队名字
	GetElement(self.m_root,"txtName_CellLeagueRank",WZUILabelTTF):setText(self.m_tData.name)
	--积分
	GetElement(self.m_root,"txtScore_CellLeagueRank",WZUILabelTTF):setText(self.m_tData.score)
	--胜场
	GetElement(self.m_root,"txtRecord1_CellLeagueRank",WZUILabelTTF):setText(self.m_tData.winNum..LocalStrings.LEAGUE17)
	--胜率
	GetElement(self.m_root,"txtRecord2_CellLeagueRank",WZUILabelTTF):setText("("..LocalStrings.WIN_RATE..":"..self.m_tData.winRate.."%)")
	--颜色
	WZLog("战队id和我的id是",self.m_tData.id,CacheCenter:getPlayerInfo().teamId)
	if self.m_tData.id == CacheCenter:getPlayerInfo().teamId then
		self:setGreen()
	end
	--战队图标
	local con = GetElement(self.m_root,"conHead",WZUIContainer)
	con:removeAllChildrenWithCleanup(true)
	if self.m_tData.url ~= "" then 
		--添加下载图片Cell
		local celElement,tCell = CellDownloadImg:createElement()
		con:addChild(celElement)

		SceneLeagueMain:addDownloadFileList(self.m_tData.url, tCell, nil, 60)
	end
end

--@brief	把底图设置成绿色
function CellLeagueRank:setGreen()
	GetElement(self.m_root,"txtName_CellLeagueRank",WZUILabelTTF):setColor(GlobalMethod:ccc3(64,128,1))
	GetElement(self.m_root,"txtScore_CellLeagueRank",WZUILabelTTF):setColor(GlobalMethod:ccc3(64,128,1))
	GetElement(self.m_root,"txtRecord1_CellLeagueRank",WZUILabelTTF):setColor(GlobalMethod:ccc3(64,128,1))
	GetElement(self.m_root,"txtRecord2_CellLeagueRank",WZUILabelTTF):setColor(GlobalMethod:ccc3(64,128,1))
	GetElement(self.m_root, "imgBtn1_CellLeagueRank", WZUI9Image):setFile("ui/common/frame_lieb_01.png")
	GetElement(self.m_root, "imgBtn2_CellLeagueRank", WZUI9Image):setFile("ui/common/frame_lieb_01.png")
	GetElement(self.m_root, "imgBtn3_CellLeagueRank", WZUI9Image):setFile("ui/common/frame_lieb_01.png")
end


-------------------------------------私有方法模块End----------------------------------------
