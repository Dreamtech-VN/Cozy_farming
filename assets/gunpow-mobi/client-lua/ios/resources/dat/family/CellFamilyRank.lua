--CellFamilyRank.lua
--@brief	CellFamilyRank的UI模块
--@date		2017/08/01
--@author	zsq
--@note		家园排行榜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFamilyRank:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFamilyRank:onExit(element)
	self:_unInit()
end

function CellFamilyRank:onRole() 
	WZLog("CellFamilyRank:onRole")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData.playerId == nil then return end
	WndCheckOther:show(self.m_tData.playerId)
end

function CellFamilyRank:onFamily() 
	WZLog("CellFamilyRank:onFamily")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData.playerId == nil then return end
	SceneFamily:showInterface(self.m_tData.playerId)
end

function CellFamilyRank:setData(tData) 
	WZLog("CellFamilyRank:setData")
	self.m_tData = tData
	--self:onLoadData()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新公会内容的函数（包括排名，ID，公会名称，公会等级，公会威望）
function CellFamilyRank:onLoadData()
	local element = WZUISystem:getInstance():createElement("CellFamilyRank")
	assert(element, "CellLeagueRank element create failed!")
    self.m_root:addChild(element)
	element:setLuaObjectIndex(self)

	if self.m_root == nil then return end 
	local tData = self.m_tData

	--排名前三显示图片
	local picName = {"ui/common/common_icon_1st.png","ui/common/common_icon_2nd.png","ui/common/common_icon_3rd.png"}
	if tonumber(self.m_tData.rank) ~= nil and tonumber(self.m_tData.rank) >= 1 and tonumber(self.m_tData.rank) <= 3 then
    	GetElement(self.m_root, "imgName_CellCommunityList", WZUIImage):setVisible(true)
    	GetElement(self.m_root, "txtRanking_CellCommunityList", WZUILabelTTF):setVisible(false)
    	GetElement(self.m_root, "imgName_CellCommunityList", WZUIImage):setFile(picName[tonumber(self.m_tData.rank)])
	end
	
	--排名
	local txtRanking = self.m_root:getChildElement("txtRanking_CellCommunityList")
	if txtRanking ~= nil then 
		txtRanking = WZUILabelTTF:luaTo(txtRanking)
		if txtRanking ~= nil then 
			txtRanking:setText(self.m_tData.rank)
		end 
		if self.m_tData.rank == -1 then
			txtRanking:setText("")
			GetElement(WndFamilyRank.m_root,"txtFirst_SceneCommunity",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP9)
			GetElement(WndFamilyRank.m_root,"txtSecond_SceneCommunity",WZUILabelTTF):setText("")
			GetElement(self.m_root,"conHeadInfo",WZUIContainer):setRelativePosition(ccp(0.31, 0.5))
		else
			GetElement(WndFamilyRank.m_root,"txtFirst_SceneCommunity",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP7)
			GetElement(WndFamilyRank.m_root,"txtSecond_SceneCommunity",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP9)
			GetElement(self.m_root,"conHeadInfo",WZUIContainer):setRelativePosition(ccp(0.5, 0.5))
			if ProjConfig.LANGUAGE == "en" then 
				GetElement(WndFamilyRank.m_root,"txtFirst_SceneCommunity",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.1,0.5))
			end
		end
	end 
	
	--名称
	local txtCommunityName = self.m_root:getChildElement("txtCommunityName_CellCommunityList")
	GetElement(self.m_root,"imgKua",WZUIImage):setVisible(false)
	if txtCommunityName ~= nil then 
		txtCommunityName= WZUILabelTTF:luaTo(txtCommunityName)
		if txtCommunityName ~= nil then 
			--txtCommunityName:setText("LV"..self.m_sLevel.." "..self.m_sName)
			--是否不同服
			txtCommunityName:setText(self.m_tData.name)
			if tonumber(self.m_tData.serverId) ~= tonumber(CacheCenter:getPlayerInfo().serverId) then
				GetElement(self.m_root,"imgKua",WZUIImage):setVisible(true)
			end
		end 
	end
	WZLog("显示排行:",self.m_tData.name)

	--主人等级
	GetElement(self.m_root,"txtRoleLv",WZUILabelTTF):setText(LocalStrings.LV..tData.level)
	
	--家园等级
	GetElement(self.m_root,"txtFamilyLv",WZUILabelTTF):setText(LocalStrings.LV..self.m_tData.homeLevel)

	--家园豪华度
	GetElement(self.m_root,"txtSheerLuxury",WZUILabelTTF):setText(self.m_tData.sheerLuxury)

	--主人头像
	local conPlayerAni = GetElement(self.m_root,"conHead_Cell",WZUIContainer)
	local imgHead = CellHead:show(conPlayerAni, tData.headId, tData.faceId, tData.sex, false, GlobalMethod:ccp(0.54,0.29), tData.vipLevel, tData.headColor)

	AdaptLanguage(self)
end 





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function CellFamilyRank:_adaptLanguage_pt(  )
	GetElement(self.m_root,"imgCK_CellFamilyRank",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.88,0.5))
end

function CellFamilyRank:_adaptLanguage_tr(  )
	GetElement(self.m_root,"imgCK_CellFamilyRank",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.9,0.5))
end
--------------------------------------语言适配End-----------------------------------------
