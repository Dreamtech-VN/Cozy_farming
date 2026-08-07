--CellCommunityRank.lua
--@brief	CellCommunityRank的UI模块
--@date		2015/10/14
--@author	zsq
--@note		公会战绩排行Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityRank:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityRank:onExit(element)
	self:_unInit()
end

--@brief	点击列表弹出公会信息
function CellCommunityRank:onBtnClick(element)
	WZLog("CellCommunityRank:onBtnClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nType ~= 1 then return end

	if WndCommunityRank.m_nType == 1 then
		--获取并显示公会信息
		ProtocolProcessorSceneCommunity:send_GUILD_GetGuild(tonumber(self.m_tData.id))
	elseif WndCommunityRank.m_nType == 2 then
		--获取并显示人物信息
		WndCheckOther:show(tonumber(self.m_tData.id))
	end
end

--@brief	点击列表弹出人物信息
function CellCommunityRank:onBtnClick1(element)
	WZLog("CellCommunityRank:onBtnClick1")

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置Cell类型
--@param	nType:1排名类型,2奖励类型
function CellCommunityRank:setType(nType)
	WZLog("CellCommunityRank:setType")
	self.m_nType = nType
	if self.m_nType == nil then
		self.m_nType = 1
	end

	if self.m_nType == 1 then
		GetElement(self.m_root,"btnClick_CellCommunityRank",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnClick1_CellCommunityRank",WZUIButton):setVisible(false)
		GetElement(self.m_root,"txtName_CellCommunityRank",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txtRecord_CellCommunityRank",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txtScore_CellCommunityRank",WZUILabelTTF):setVisible(true)
	else
		GetElement(self.m_root,"btnClick_CellCommunityRank",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnClick1_CellCommunityRank",WZUIButton):setVisible(true)
		GetElement(self.m_root,"txtName_CellCommunityRank",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txtRecord_CellCommunityRank",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txtScore_CellCommunityRank",WZUILabelTTF):setVisible(false)
	end
end

--@brief	设置排名信息
function CellCommunityRank:setRank(tData)
	self.m_tData = tData
	GetElement(self.m_root,"txtRanking_CellCommunityRank",WZUILabelTTF):setText(tData.rank)
	GetElement(self.m_root,"txtName_CellCommunityRank",WZUILabelTTF):setText(tData.name)
	GetElement(self.m_root,"txtRecord_CellCommunityRank",WZUILabelTTF):setText(tData.record)
	GetElement(self.m_root,"txtScore_CellCommunityRank",WZUILabelTTF):setText(tData.score)

	self:setRankTitle(tData.rank)
end

--@brief	设置奖励信息
function CellCommunityRank:setReward(tData)
	local count = math.min(#tData.id,4)
	GetElement(self.m_root,"txtRanking_CellCommunityRank",WZUILabelTTF):setText(tData.rank)
	if tData.lastRow then
		GetElement(self.m_root,"txtRanking_CellCommunityRank",WZUILabelTTF):setText(tData.rank.."-")
	end
	for i=1,count do
        local key = "id_"..tData.id[i]
		local tInfo = GDatatab_item[key]
        local itemInfo = {name=tInfo.name,icon=tInfo.icon,lastTime=-1,
			lastNum=tData.num[i],quality=tInfo.quality,basicInfo=CopyTable(tInfo)}
	   	local celElement,tLuaObj = CellGoodItem:createElement()
    	tLuaObj:setCellGoodItem(itemInfo, 4)
    	tLuaObj:setItemClickFun(self, self.onClickItem)

		local con = GetElement(self.m_root,"con"..i.."_CellCommunityRank",WZUIContainer)
		if con:getChildByTag(6) then
			con:removeChildByTag(6,true)
		end
		con:addChild(celElement,6,6)
	end

	self:setRankTitle(tonumber(tData.rank))
end

--@brief	设置排名
function CellCommunityRank:setRankTitle(rank)
	local rank = tonumber(rank)
	if rank == 1 or rank == 2 or rank == 3 then
		local rankFile = {"ui/common/common_icon_1st.png","ui/common/common_icon_2nd.png","ui/common/common_icon_3rd.png"}
		GetElement(self.m_root,"txtRanking_CellCommunityRank",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"imgRanking_CellCommunityRank",WZUIImage):setVisible(true)
		GetElement(self.m_root,"imgRanking_CellCommunityRank",WZUIImage):setFile(rankFile[rank])
	else
		GetElement(self.m_root,"txtRanking_CellCommunityRank",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"imgRanking_CellCommunityRank",WZUIImage):setVisible(false)
	end
end

--@brief	格子点击事件
function CellCommunityRank:onClickItem(tItem, nTag, tData)
	WZLog("CellCommunityRank:onClickItem")

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,GetElement(WndCommunityRank.m_root,"conTable",WZUIContainer),1,tData, false)
end

--@brief	把文字设置成绿色
function CellCommunityRank:setGreen()
	local green = GlobalMethod:ccc3(3,111,8)
	GetElement(self.m_root,"txtRanking_CellCommunityRank",WZUILabelTTF):setColor(green)
	GetElement(self.m_root,"txtName_CellCommunityRank",WZUILabelTTF):setColor(green)
	GetElement(self.m_root,"txtRecord_CellCommunityRank",WZUILabelTTF):setColor(green)
	GetElement(self.m_root,"txtScore_CellCommunityRank",WZUILabelTTF):setColor(green)
end
-------------------------------------私有方法模块End----------------------------------------
