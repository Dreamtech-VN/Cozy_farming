--WndRiseGetReward.lua
--@brief	WndRiseGetReward的UI模块
--@date		2021/06/25
--@author	hyx
--@note		崛起之路获得奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRiseGetReward:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRiseGetReward:onExit(element)
	self:_unInit()
end
function WndRiseGetReward:showInterface(id, num)
	local wndReward = WndRiseGetReward:createElement(id, num)
	if wndReward ~= nil then
	    WindowManager:addWindow(wndReward,WndRiseGetReward,nil,false)
	end
end
function WndRiseGetReward:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndRiseGetReward:actionCallback()
	local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
	local width = goods_con:getContentSize().width * 0.5
	local height = 0

	local num = #self.m_tRewardIds
	if num >= 5 then
		num = 4
	end
	width = width - (85 * 0.5 * (num-1))
	if #self.m_tRewardIds < 5 then
		height = goods_con:getContentSize().height * 0.5
	else
		height = goods_con:getContentSize().height - 40
	end
	for i = 1, #self.m_tRewardIds do
		local tabItem = GDatatab_item["id_"..self.m_tRewardIds[i]]
		if tabItem then
			local celElement,tLuaObj = CellGoodItem:createElement()
			local itemInfo = {lastTime=self.m_tRewardNums[i],lastNum=self.m_tRewardNums[i],basicInfo=CopyTable(tabItem)}
			tLuaObj:setCellGoodItem(itemInfo, 17)
			celElement:setScale(0.85)
			celElement:setUseAbsCoordinate(true)
			local _x = width + ((i-1)%4)*85
			local _y = height - (math.floor((i-1)/4)*85)
			celElement:setAbsPosition(GlobalMethod:ccp(_x, _y))
			goods_con:addChild(celElement)
			tLuaObj:setItemClickFun(WndRiseGetReward,self.onItemClick)
	    end
	end
end
function WndRiseGetReward:onItemClick(tCell,tag,tData)
    if tData == nil or tCell == nil then
       return
    end
	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root,WndRiseGetReward.m_root,1,tData,false,nil,true)
end
function WndRiseGetReward:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
