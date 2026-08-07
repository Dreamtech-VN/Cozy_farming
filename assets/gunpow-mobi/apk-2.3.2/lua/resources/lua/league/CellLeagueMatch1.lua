--CellLeagueMatch1.lua
--@brief	CellLeagueMatch1的UI模块
--@date		2016/06/12
--@author	zsq
--@note		小组赛匹配


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLeagueMatch1:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLeagueMatch1:onExit(element)
	self:_unInit()
end

function CellLeagueMatch1:setData(tData,round)
    self.m_tData = tData
	self.m_nRound = round

	self:onLoadData()
end

--@brief	查看战队
function CellLeagueMatch1:onCheck(element)
	WZLog("CellLeagueMatch1:onCheck",element:getTag())
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
function CellLeagueMatch1:onLoadData(element)
	--local element = WZUISystem:getInstance():createElement("CellLeagueMatch1")
	--assert(element, "CellLeagueMatch1 element create failed!")
    --self.m_root:addChild(element)

	--WZLog("CellLeagueMatch1:onLoadData",Serialize(self.m_tData))
	--设置代码
	local subTitle = {"A","B","C","D","E","F","G","H"}
	local resultImg = {"ui/hero/hero_icon_vsfu.png","ui/hero/hero_icon_vssheng.png","ui/hero/hero_icon_qiquan.png","ui/hero/hero_icon_jingji.png"}
	for i=1,8 do
		--标题
		GetElement(self.m_root,"ttfNumber"..i.."_CellLeagueMatch1",WZUILabelTTF):setText(subTitle[i])
		--比赛结果
		for j=1,4 do
			local index = j+(i-1)*4
			GetElement(self.m_root,"imgResult"..i..j,WZUI9Image):setVisible(false)
			if self.m_tData[index] ~= nil and self.m_tData[index]["round"..self.m_nRound] ~= "" then
				local result = resultImg[self.m_tData[index]["round"..self.m_nRound]+1]
				if tonumber(self.m_nRound) ~= 4 then
					GetElement(self.m_root,"imgResult"..i..j,WZUI9Image):setFile(result)
					GetElement(self.m_root,"imgResult"..i..j,WZUI9Image):setVisible(true)
				else
					if tonumber(self.m_tData[index]["round"..self.m_nRound]) == 3 then
						GetElement(self.m_root,"imgResult"..i..j,WZUI9Image):setFile(result)
						GetElement(self.m_root,"imgResult"..i..j,WZUI9Image):setVisible(true)
					else
						GetElement(self.m_root,"imgResult"..i..j,WZUI9Image):setVisible(false)
					end
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
			else
				GetElement(self.m_root,"imgResult"..i..j,WZUI9Image):setVisible(false)
			end
			--轮换战队位置
			local teamPosition = {ccp(0.15,0.65),ccp(0.85,0.65),ccp(0.15,0.25),ccp(0.85,0.25)}
			local resultPosition = {ccp(1.4,0.5),ccp(-0.46,0.5),ccp(1.4,0.5),ccp(-0.46,0.5)}
			
			if ProjConfig.LANGUAGE == "vn" then
				--resultPosition = {ccp(0.79,0.27),ccp(0.2,0.27),ccp(0.79,0.27),ccp(0.2,0.27)}
			end

			if tonumber(self.m_nRound) == 2 then
				teamPosition = {ccp(0.15,0.65),ccp(0.15,0.25),ccp(0.85,0.65),ccp(0.85,0.25)}
				resultPosition = {ccp(1.4,0.5),ccp(1.4,0.5),ccp(-0.46,0.5),ccp(-0.46,0.5)}
				if ProjConfig.LANGUAGE == "vn" then
					--resultPosition = {ccp(0.79,0.27),ccp(0.79,0.27),ccp(0.2,0.27),ccp(0.2,0.27)}
				end
			elseif tonumber(self.m_nRound) == 3 then
				teamPosition = {ccp(0.15,0.65),ccp(0.15,0.25),ccp(0.85,0.25),ccp(0.85,0.65)}
				resultPosition = {ccp(1.4,0.5),ccp(1.4,0.5),ccp(-0.46,0.5),ccp(-0.46,0.5)}
				if ProjConfig.LANGUAGE == "vn" then
					--resultPosition = {ccp(0.79,0.27),ccp(0.79,0.27),ccp(0.2,0.27),ccp(0.2,0.27)}
				end
			end
			GetElement(self.m_root,"team"..i..j,WZUIButton):setRelativePosition(teamPosition[j])
			GetElement(self.m_root,"team"..i..j,WZUIButton):setScale(0.9)
			GetElement(self.m_root,"imgResult"..i..j,WZUI9Image):setRelativePosition(resultPosition[j])
			GetElement(self.m_root,"imgResult"..i..j,WZUI9Image):setScale(0.9)
			--GetElement(self.m_root,"imgResult"..i..j,WZUI9Image):setVisible(true)
		end
	end
	--批量设置vs缩放和位置
	for i=1,16 do		
		local vs = GetElement(self.m_root,"vs"..i,WZUILabelTTF)
		vs:setScale(0.9)
		if vs then
			if i % 2 == 0 then
				vs:setRelativePosition(GlobalMethod:ccp(0.5,0.25))
			else
				vs:setRelativePosition(GlobalMethod:ccp(0.5,0.65))
			end
		end
	end
	--最终结果隐藏vs
	if tonumber(self.m_nRound) == 4 then
		for i=1,16 do
			GetElement(self.m_root,"vs"..i,WZUILabelTTF):setVisible(false)
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------
