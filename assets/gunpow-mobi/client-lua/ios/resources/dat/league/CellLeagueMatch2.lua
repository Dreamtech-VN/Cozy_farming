--CellLeagueMatch2.lua
--@brief	CellLeagueMatch2的UI模块
--@date		2016/06/12
--@author	zsq
--@note		十六强匹配


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLeagueMatch2:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLeagueMatch2:onExit(element)
	self:_unInit()
end

function CellLeagueMatch2:setData(tData,round)
    self.m_tData = tData
	self.m_nRound = round

	self:onLoadData()
end

--@brief	查看战队
function CellLeagueMatch2:onCheck(element)
	WZLog("CellLeagueMatch1:onCheck")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData[element:getTag()] ~= nil then
		SceneLeagueMain.m_nCheckType = 1
		SceneLeagueMain.m_tCheckWnd = WndLeagueMatch
		SceneLeagueMain.m_tCheckElement = self
		SceneLeagueMain.m_tCheckPoint = ccp(100,100)
		ProtocolProcessorWndLeague:send_HERO_SearchTeam(self.m_tData[element:getTag()].id )
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellLeagueMatch2:onLoadData(element)
	--local element = WZUISystem:getInstance():createElement("CellLeagueMatch2")
	--assert(element, "CellLeagueMatch1 element create failed!")
    --self.m_root:addChild(element)

	WZLog("CellLeagueMatch1:onLoadData",Serialize(self.m_tData))
	--设置代码
	local resultImg = {"ui/hero/hero_icon_vsfu.png","ui/hero/hero_icon_vssheng.png","ui/hero/hero_icon_qiquan.png","ui/hero/hero_icon_jingji.png"}
	for i=1,8 do
		--比赛结果
		for j=1,2 do
			local index = j+(i-1)*2
			--战队名字
			if self.m_tData[index] ~= nil then
				GetElement(self.m_root,"teamName"..i..j,WZUILabelTTF):setText(self.m_tData[index]["name"])
				GetElement(self.m_root,"teamName"..i..j,WZUILabelTTF):setColor(GlobalMethod:ccc3(255,236,193))
				--自己战队显示绿色
				if self.m_tData[index].id == CacheCenter:getPlayerInfo().teamId then
				--if self.m_tData[index].id == 1000253 then
					GetElement(self.m_root,"teamName"..i..j,WZUILabelTTF):setColor(GlobalMethod:ccc3(99,255,95))
				end

				--战队图标
				local con = GetElement(self.m_root,"conHead"..i..j,WZUIContainer)
				con:removeAllChildrenWithCleanup(true)
				if self.m_tData[index].icon ~= "" then 
					--添加下载图片Cell
					local celElement,tCell = CellDownloadImg:createElement()
					con:addChild(celElement)

					SceneLeagueMain:addDownloadFileList(self.m_tData[index].icon, tCell, nil, 50)
				end
			end
			--比赛结果
			if self.m_tData[index] ~= nil and self.m_tData[index]["round"..self.m_nRound] ~= "" then
				local result = resultImg[self.m_tData[index]["round"..self.m_nRound]+1]
				GetElement(self.m_root,"imgResult"..i..j,WZUI9Image):setFile(result)
				GetElement(self.m_root,"imgResult"..i..j,WZUI9Image):setVisible(true)
			else
				GetElement(self.m_root,"imgResult"..i..j,WZUI9Image):setVisible(false)
			end
			if self.m_tData[index] ~= nil and self.m_tData[index]["round"..self.m_nRound] == 4 then
				if j == 1 then
					GetElement(self.m_root,"imgResult"..i..j,WZUI9Image):setRelativePosition(GlobalMethod:ccp(1,0.7))
				else
					GetElement(self.m_root,"imgResult"..i..j,WZUI9Image):setRelativePosition(GlobalMethod:ccp(0,0.7))
				end
				GetElement(self.m_root,"ttfResult"..i..j,WZUILabelTTF):setText(self.m_tData[index]["winNum"]..LocalStrings.WORD_WIN)
			end
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------
