--WndKingShowAward.lua
--@brief	WndKingShowAward的UI模块
--@date		2015/5/12
--@author	Zjh
--@note

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKingShowAward:onEnter(element)
	self.m_root = element

	self:_updateUI_static_txt()
end

----@brief onEnter函数执行完成回调
function WndKingShowAward:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

----@brief    弹窗动画完成后的回调
function WndKingShowAward:actionCallback(element, data)
	--初始化界面
	self:_testInit()
	self:_updateUI_dynamic()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKingShowAward:onExit(element)
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndKingShowAward:onClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)
end

--@brief	动画播完后的回调
function WndKingShowAward:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndKingShowAward:onClickListItem(tItem, nTag, tData)
    WZLog("WndKingShowAward:onClickListItem")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

--@brief	窗口触摸事件回调
function WndKingShowAward:onTouchBegan(element)
	WndItemInfo:onCloseClick()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndKingShowAward:_testInit()
	self.m_tAwardData = {}


	self.m_tAwardData = {}
	for i,v in pairs(GDatatab_king_rank_reward) do
		self.m_tAwardData[v.id] = v
	end

end

function WndKingShowAward:_updateUI_dynamic()
	self:_initTable()
end

function WndKingShowAward:_initTable()
	local tabElement = GetElement(self.m_root,"tabAward_WndKingShowAward",WZUITableContainer)
	for i=1,#self.m_tAwardData do
		local data = self.m_tAwardData[i]
		local startRange = data.rank[1][1]
		local endRange   = data.rank[1][2]
		local reward     = GlobalGame.g_tPlayerInfo.nPlayerSex == 0 and data.reward_boy or data.reward_girl

		local element = WZUISystem:getInstance():createElement("CellKingShowAward")
		element:setTag(i-1)
		tabElement:setCellElement(element)

		local tempElement = GetElement(element,"txtRange_CellKingShowAward",WZUILabelTTF)
		if startRange~=-1 and endRange~=-1 then
			if startRange == endRange then
				tempElement:setText( string.format( LocalStrings.KING_AWARD_RANK , startRange ) )
			else
				tempElement:setText( string.format( LocalStrings.KING_AWARD_RANK , startRange.."~"..endRange ) )
			end
		elseif startRange then
			tempElement:setText( string.format( LocalStrings.KING_AWARD_RANK , startRange.."+" ) )
		end

		--物品列表
		for nIndex=1,#reward do
			tempElement = GetElement(element,"conItem"..nIndex.."_CellKingShowAward")
			local eItem, tItem = CellGoodItem:createElement()
			eItem:setTag(nIndex-1)
			eItem:setScale(0.8)
			tItem:setFromTag(nIndex-1)
			tItem:setItemClickFun(self, self.onClickListItem)
			local nItemId = reward[nIndex][1]
			local nItemNum = reward[nIndex][2]
			if nItemId then
				local tData = {
					id = nItemId,
					lastNum = nItemNum,
					lastTime = nItemNum,
					isUse = false,
					data = "",
					playerItemId = -1,
					basicInfo = GetItemLocalData(nItemId)
				}
				tItem:setCellGoodItem(tData, 4)
			end
			tempElement:addChild(eItem)
			tempElement:setVisible(true)
		end
	end
end

function WndKingShowAward:_updateUI_static_txt()
	local tempElement = nil

	tempElement = GetElement(self.m_root,"txtTitle_WndKingShowAward",WZUILabelTTF)
	tempElement:setText( LocalStrings.KING_AWARD_TITLE )

	tempElement = GetElement(self.m_root,"txtSubTitle_WndKingShowAward",WZUILabelTTF)
	tempElement:setText( LocalStrings.KING_AWARD_SUBTITLE )

end
-------------------------------------私有方法模块End----------------------------------------
