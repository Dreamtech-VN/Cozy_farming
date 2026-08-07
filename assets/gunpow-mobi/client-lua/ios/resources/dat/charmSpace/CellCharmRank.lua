--CellCharmRank.lua
--@brief	CellCharmRank的UI模块
--@date		2016/08/24
--@author	mpt
--@note		鲜花榜排名


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCharmRank:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCharmRank:onExit(element)
	self:_unInit()
end

--@brief	点击事件
function CellCharmRank:onClick( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if WndCharmSpace.preCel ~= nil then
		WndCharmSpace.preCel:setHighLight(false)
	end
	WndCharmSpace.preCel = self
	self:setHighLight(true)
	WndCharmSpace:_showDetail(self.tData, self.m_tOtherInfo)
end

--@brief	更新鲜花榜内容
function CellCharmRank:_update(  )
	if self.onLoad == false then return end
	
	local imgBackground = GetElement(self.m_root,"imgBackground_CellCharmRank",WZUI9Image)
	local imgRank = GetElement(self.m_root,"imgRank_CellCharmRank",WZUI9Image)
	local txtRank = GetElement(self.m_root,"txtRank_CellCharmRank",WZUILabelTTF)
	local txtLevel = GetElement(self.m_root,"txtLevel_CellCharmRank",WZUILabelTTF)
	local txtName1 = GetElement(self.m_root,"txtName1_CellCharmRank",WZUILabelTTF)
	local txtName2 = GetElement(self.m_root,"txtName2_CellCharmRank",WZUILabelTTF)
	local txtID = GetElement(self.m_root,"txtID_CellCharmRank",WZUILabelTTF)
	local txtServer = GetElement(self.m_root,"txtServer_CellCharmRank",WZUILabelTTF)
	local txtNum = GetElement(self.m_root,"txtNum_CellCharmRank",WZUILabelTTF)
	local imgKua = GetElement(self.m_root,"imgKua_CellCharmRank",WZUI9Image)
 	
 	if self.rank == nil then return end
	if self.rank == 1 then
		imgRank:setFile("ui/common/common_icon_1st.png")
	elseif self.rank == 2 then
		imgRank:setFile("ui/common/common_icon_2nd.png")
	elseif self.rank == 3 then
		imgRank:setFile("ui/common/common_icon_3rd.png")
	elseif self.rank >= 4 then
		--imgRank:setVisible(false)
		txtRank:setText(self.rank)
	end

	if self.tData.cross == "1" then
		imgKua:setVisible(true)
		txtName1:setText(self.tData.playerName)
	elseif self.tData.cross == "0" then
		imgKua:setVisible(false)
		txtName2:setText(self.tData.playerName)
	end

	txtLevel:setText("Lv"..self.tData.level)
	
	txtID:setText(self.tData.playerId)
	txtServer:setText(self.tData.server)
	txtNum:setText(self.flowerNum)

	if self.tData.playerId == CacheCenter:getPlayerInfo().id then
		imgBackground:setFile("ui/common/common_scale9_di38.png")
	else
		imgBackground:setFile("ui/common/common_scale9_di7.png")
	end
	if self.m_nRankType == 48 or self.m_nRankType == 49 then 
		GetElement(self.m_root, "imgTypeIcon_CellCharmRank", WZUIImage):setFile("ui/charmSpace/charmspace_good_icon.png")
	else
		GetElement(self.m_root, "imgTypeIcon_CellCharmRank", WZUIImage):setFile("ui/space/common_icon_songh.png")
	end

	if self.m_nRankType == 48 then 
		if WndCharmSpace.m_nBeGoodPlayerId then 
			if WndCharmSpace.m_nBeGoodPlayerId == self.tData.playerId then
				self:setHighLight(true)
				WndCharmSpace:_showDetail(self.tData, self.m_tOtherInfo)
			end
		else
			if self.tag == 1 then
				self:setHighLight(true)
				WndCharmSpace:_showDetail(self.tData, self.m_tOtherInfo)
			end
		end
	else
		if self.tag == 1 then
			self:setHighLight(true)
			WndCharmSpace:_showDetail(self.tData, self.m_tOtherInfo)
		end
	end
end

--@brief	设置高亮
function CellCharmRank:setHighLight( bool )
	local img = GetElement(self.m_root,"img_CellCharmRank",WZUI9Image)
	if bool then
		img:setVisible(true)
	else
		img:setVisible(false)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
