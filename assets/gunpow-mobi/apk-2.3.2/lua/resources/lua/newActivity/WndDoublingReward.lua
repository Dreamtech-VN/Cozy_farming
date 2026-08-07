--WndDoublingReward.lua
--@brief	WndDoublingReward的UI模块
--@date		2020/07/31
--@author	yrd
--@note		翻倍活动奖励显示


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDoublingReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDoublingReward:onExit(element)
	self:_unInit()
end


--@brief 	界面加载完成回调
function WndDoublingReward:onEnterTransitionDidFinish(element)
	
end

function WndDoublingReward:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(WndDoublingReward.m_root, WndDoublingReward, true)
end

function WndDoublingReward:updateUI()
	GetElement(self.m_root,"txtTitle_WndDoublingReward",WZUILabelTTF):setText(LocalStrings.ATH_REWARD_CHECK)

	local txtDesc = GetElement(self.m_root,"txtDesc_WndDoublingReward",WZUIFreeTextBox)
	if self.m_nNum == 1 then
		local strFormat = [[<T C="127,70,26" S="20">%s</T>]]
		txtDesc:setShowText(string.format(strFormat,LocalStrings.CRAZY_DOUBLING_TEXT8))
	else
		txtDesc:setShowText(string.format(LocalStrings.CRAZY_DOUBLING_TEXT5,self.m_nNum))
	end
	
	local tconReward = GetElement(self.m_root,"tconReward_WndDoublingReward",WZUITableContainer)
	tconReward:cleanTable()
    for i = 1, #self.m_tRewardItems do
		local celElement, tLuaObj = CellGoodItem:createElement()
        celElement = WZUIContainer:luaTo(celElement)
        celElement:setTag(i-1)
        tLuaObj:setCellGoodLocalId(self.m_tRewardItems[i],self.m_tRewardCount[i],4)
        tLuaObj:setItemClickFun(self,self.onClickItem)

        tconReward:setCellElement(celElement)
    end

    if #self.m_tRewardItems == 1 then
    	tconReward:setRelativePosition(GlobalMethod:ccp(0.67,0.5))
    elseif #self.m_tRewardItems == 2 then
    	tconReward:setRelativePosition(GlobalMethod:ccp(0.585,0.5))
    elseif #self.m_tRewardItems == 3 then
    	tconReward:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	end

end


function WndDoublingReward:onClickItem(luaTable,tag,tData)
	WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData, false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
