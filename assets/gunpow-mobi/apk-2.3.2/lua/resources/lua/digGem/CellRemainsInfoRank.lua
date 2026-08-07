--CellRemainsInfoRank.lua
--@brief	CellRemainsInfoRank的UI模块
--@date		2019/07/10
--@author	yrd
--@note		遗迹之光-副本信息排行格子


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRemainsInfoRank:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRemainsInfoRank:onExit(element)
	self:_unInit()
end

function CellRemainsInfoRank:_update(  )	
	local txtNumRank = GetElement(self.m_root,"txtNumRank_CellRemainsInfoRank",WZUILabelTTF)
	local imgNumRank = GetElement(self.m_root,"imgNumRank_CellRemainsInfoRank",WZUIImage)
	txtNumRank:setVisible(false)
	imgNumRank:setVisible(false)
	if self.m_tData.rank == 1 then
		imgNumRank:setVisible(true)
		imgNumRank:setFile("ui/common/common_icon_1st_1.png")
	elseif self.m_tData.rank == 2 then
		imgNumRank:setVisible(true)
		imgNumRank:setFile("ui/common/common_icon_2nd_1.png")
	elseif self.m_tData.rank == 3 then
		imgNumRank:setVisible(true)
		imgNumRank:setFile("ui/common/common_icon_3rd_1.png")
	else
		txtNumRank:setVisible(true)
		txtNumRank:setText(self.m_tData.rank)
	end

	GetElement(self.m_root,"txtPlayerName_CellRemainsInfoRank",WZUILabelTTF):setText(self.m_tData.rankPlayerName)
	GetElement(self.m_root,"txtHurtNum_CellRemainsInfoRank",WZUILabelTTF):setText(self.m_tData.rankHurt)
	GetElement(self.m_root,"txtHurtRatio_CellRemainsInfoRank",WZUILabelTTF):setText(string.format("%0.2f", self.m_tData.rankHurt/self.m_tData.bossBloodMax*100))

	if self.m_tData.vip > 0 then
		GetElement(self.m_root,"imgVip_CellRemainsInfoRank",WZUIImage):setVisible(true)
		GetElement(self.m_root,"lafVipNum_CellRemainsInfoRank",WZUILabelAtlasFont):setText(self.m_tData.vip)
	end

	for i=1, math.min(#self.m_tData.reward, 5) do
		local conRewardItem = GetElement(self.m_root,"conRewardItem"..i.."_CellRemainsInfoRank",WZUIContainer)
		
    	local celElement,tCell = CellGoodItem:createElement()
    	celElement:setTag(i-1)
    	celElement = WZUIContainer:luaTo(celElement)
    	tCell:setCellGoodLocalId(self.m_tData.reward[i][1], self.m_tData.reward[i][2] , 4)
		tCell:setItemClickFun(self,self._showTip)
		conRewardItem:addChild(celElement)
		celElement:setScale(0.625)
	end
	
end


function CellRemainsInfoRank:_showTip(tItem, nTag, tData)
    WndItemInfo:showInfo(tItem.m_root,WndRemainsInfo.m_root,1,tData, false, nil)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
