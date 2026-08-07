--WndFourStarSummonReward.lua
--@brief	WndFourStarSummonReward的UI模块
--@date		2021/02/24
--@author	hyx
--@note		获取奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFourStarSummonReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFourStarSummonReward:onExit(element)
	self:_unInit()
end

function WndFourStarSummonReward:showInterface(data, index)
	local wndSummonReward = WndFourStarSummonReward:createElement(data, index)
	if wndSummonReward ~= nil then
	    WindowManager:addWindow(wndSummonReward,WndFourStarSummonReward,nil,false)
	end
end

function WndFourStarSummonReward:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndFourStarSummonReward:actionCallback()
	self:initShow()
end

function WndFourStarSummonReward:closeCallBack(func)
	if func then
		self.m_sSureFunc = func
	end
end

function WndFourStarSummonReward:initShow()
	local goods_container = GetElement(self.m_root,"goods_container",WZUIContainer)
	
	--两个大奖奖励的时候
	local str_big = "" --大奖的描述
	local tab_rewardIds = {}

	if self.m_nCurIndex == 1 then
		tab_rewardIds = self.m_sBigSummonReward.itemIds
		tab_rewardNums = self.m_sBigSummonReward.itemNums
		str_big = string.format(LocalStrings.FOURSTAR_TEXT15, LocalStrings.FOURSTAR_TEXT16[self.m_sBigSummonReward.rewardIndex])
	elseif self.m_nCurIndex == 2 or self.m_nCurIndex == 3 then
		if self.m_sBigSummonReward.bigItemIds and self.m_bIsGetBigReward == nil then
			self.m_bIsGetBigReward = true
			tab_rewardIds = self.m_sBigSummonReward.bigItemIds
			tab_rewardNums = self.m_sBigSummonReward.bigItemNums
			str_big = LocalStrings.FOURSTAR_TEXT27
		end
	end

	for i,item in pairs(self.m_tBigRewardItem) do
		if item then
			item.celElement:setVisible(false)
		end
	end
	if not tab_rewardIds then return end

	local count = #tab_rewardIds
	local space = 20
	local item_width = 90
	local start_x = (400 - count*item_width) * 0.5
	for i=1,count do
		local key = "id_"..tab_rewardIds[i]
		local tabItem = GDatatab_item[key]
		local num = tab_rewardNums[i]
		local itemInfo = {lastTime=num,lastNum=num,basicInfo=CopyTable(GDatatab_item[key])}

		if self.m_tBigRewardItem[i] == nil then
			local celElement,tLuaObj = CellGoodItem:createElement()
			goods_container:addChild(celElement)
			celElement:setUseAbsCoordinate(true)
			celElement:setAnchorPoint(GlobalMethod:ccp(0,0.5))
			local tab = {}
			tab.celElement = celElement
			tab.tLuaObj = tLuaObj
			self.m_tBigRewardItem[i] = tab
		end

		local celElement = self.m_tBigRewardItem[i].celElement
		local tLuaObj = self.m_tBigRewardItem[i].tLuaObj
		celElement:setVisible(true)
		tLuaObj:setCellGoodItem(itemInfo, 17)
		tLuaObj:setItemClickFun(WndFourStarSummonReward,self.onItemClick)
		local _x = start_x + (i - 1) * (item_width + space)
		celElement:setAbsPosition(GlobalMethod:ccp(_x,50))
	end

	local freeTxtGetReward = GetElement(self.m_root,"freeTxtGetReward",WZUIFreeTextBox)
	freeTxtGetReward:setShowText(str_big)
end

function WndFourStarSummonReward:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndFourStarSummonReward.m_root,1,tData,false,nil,true)
end

function WndFourStarSummonReward:onBtnSure()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local status = false
	if self.m_nShowCount == 3 then
		self.m_nShowCount = 2
		status = true
	elseif self.m_nShowCount == 2 then
		if self.m_sBigSummonReward.pieceItemIds then
			self.m_nShowCount = 1
			status = true
		end
	end

	if self.m_nCurIndex >= self.m_nShowCount then
		if status == true then
			MsgBoxManager:showTipBox(string.format(LocalStrings.FOURSTAR_TEXT35, LocalStrings.FOURSTAR_TEXT16[self.m_sBigSummonReward.pieceIndex]),nil,nil,nil,
					nil,nil,nil,nil,nil,{x=0.5,y=0.8})
		end
		WindowManager:removeWindow(self.m_root, self, true)
		return
	end
	self.m_nCurIndex = self.m_nCurIndex + 1
	self:initShow()	
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
