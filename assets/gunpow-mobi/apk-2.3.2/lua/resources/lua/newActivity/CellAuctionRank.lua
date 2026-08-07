--CellAuctionRank.lua
--@brief	CellAuctionRank的UI模块
--@date		2020/08/04
--@author	yrd
--@note		竞拍榜子项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAuctionRank:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAuctionRank:onExit(element)
	self:_unInit()
end

--@brief	更新界面
function CellAuctionRank:updateUI()
	local txtRankNum = GetElement(self.m_root,"txtRankNum_CellAuctionRank",WZUILabelTTF)
	local imgRankIcon = GetElement(self.m_root,"imgRankIcon_CellAuctionRank",WZUIImage)
	txtRankNum:setVisible(false)
	imgRankIcon:setVisible(false)
	if self.m_tData.rank == 1 then
		imgRankIcon:setVisible(true)
		imgRankIcon:setFile("ui/common/common_icon_1st_1.png")
	elseif self.m_tData.rank == 2 then
		imgRankIcon:setVisible(true)
		imgRankIcon:setFile("ui/common/common_icon_2nd_1.png")
	elseif self.m_tData.rank == 3 then
		imgRankIcon:setVisible(true)
		imgRankIcon:setFile("ui/common/common_icon_3rd_1.png")
	else
		txtRankNum:setVisible(true)
		txtRankNum:setText(self.m_tData.rank)
	end

	local txtPlayerName = GetElement(self.m_root,"txtPlayerName_CellAuctionRank",WZUILabelTTF)
	txtPlayerName:setText(self.m_tData.name)
	local txtAuctioPpoints = GetElement(self.m_root,"txtAuctioPpoints_CellAuctionRank",WZUILabelTTF)
	txtAuctioPpoints:setText(self.m_tData.score)

	local head_contianer = GetElement(self.m_root,"head_con",WZUIContainer)
	CellHead:show(head_contianer, self.m_tData.headId, self.m_tData.faceId, 0, false, nil, nil, self.m_tData.headColor)

	local ids, nums = SplitItemString(self.m_tData.reward)
	for i=1,5 do
		local conItem = GetElement(self.m_root,"conitem"..i.."_CellAuctionRank",WZUIContainer)
		if ids[i] and nums[i] then
			local celElement,tLuaObj = CellGoodItem:createElement()
			tLuaObj:setCellGoodLocalId(ids[i], nums[i], 17)
			tLuaObj:setItemClickFun(self,self.onClickItem)
			tLuaObj:setBackImgFile2()
			conItem:addChild(celElement)
			celElement:setScale(0.8)
		end
	end
end

function CellAuctionRank:onClickItem(tItem, nTag, tData)
	-- WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
	WndAuctionRank:addRankTips(tItem, nTag, tData)

end
function CellAuctionRank:onClickRankHead()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tData then return end
	WndCheckOther:show(self.m_tData.playerId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
