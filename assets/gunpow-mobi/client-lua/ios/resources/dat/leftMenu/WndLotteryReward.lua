--WndLotteryReward.lua
--@brief	WndLotteryReward的UI模块
--@date		2014/09/20
--@author	张盛强
--@note		爱心许愿礼盒奖励框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLotteryReward:onEnter(element)
	self.m_root = element

	--多语言版本界面适配
	AdaptLanguage(self)

	WindowManagerAni:createAction(element,true)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLotteryReward:onExit(element)
	self:_unInit()
end

--@brief	单击关闭按钮时被调用的函数
--@param   element:关闭按钮的节点
--@note		关闭后返回主界面
function WndLotteryReward:onClose(element)  
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then
		return
	end
	--关闭称号窗口
	WindowManager:removeWindow(self.m_root , WndLotteryReward , true)
end

--@brief	领取礼盒
--@param    element:节点
--@note		领取礼盒
function WndLotteryReward:getReward(element)  
	--ProtocolProcessorSceneLottery:send_LOTTERY_ReceiveZflh(self.m_nId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then
		return
	end
    --调用设置的回调函数
	if self.backFunc then
		WZLog("回调函数")
		self.backFunc[2](self.backFunc[1],self)
	end
	--关闭称号窗口
	WindowManager:removeWindow(self.m_root , WndLotteryReward , true)
end

--@brief	窗口显示奖励内容
--@param    tag:礼盒的tag
function WndLotteryReward:showInterface(tag)
	if self.m_root == nil then
		local Wnd = WndLotteryReward:createElement()
	    WindowManager:addWindow(Wnd , WndLotteryReward)
		WndLotteryReward:setReward(tag)	
	end
end

--@brief	窗口显示奖励内容
--@param    tag:礼盒的tag
function WndLotteryReward:showInterface1(id,num,state)
	if self.m_root == nil then
		local Wnd = WndLotteryReward:createElement()
	    WindowManager:addWindow(Wnd , WndLotteryReward)
	    self:setTitle()
		WndLotteryReward:setReward1(id,num,state)	
	end
end

--@设置奖励窗口的标题
function WndLotteryReward:setTitle()
   local imgTitle = self.m_root:getChildElement("imgTitle_WndLotteryReward")
    if imgTitle == nil then 
   	    return 
    end 
    imgTitle = WZUIImage:luaTo(imgTitle)
    imgTitle:setFile("common/text/active_chest_title.png")
end 

--@brief	设置窗口显示的奖励内容
--@param    tag:礼盒的tag
--@note		设置窗口显示的奖励内容
function WndLotteryReward:setReward1(id,num,state)
	local tbLottery = self.m_root:getChildElement("tbconReward_Wnd")
	if tbLottery == nil then
		return
    else
        tbLottery:setVisible(true)
    end
	tbLottery = WZUITableContainer:luaTo(tbLottery)

	local length = #id
	if length < 4 then
		tbLottery:setColumnCount(#id)
		tbLottery:setTouchEnable(false)
	end
	
	--state：领取按钮状态
	--local state = tempTable.state[tag]
	local btn = self.m_root:getChildElement("btngetReward_Wnd")
	if btn == nil then
		return
    end
	btn = WZUIButton:luaTo(btn)
	local label = self.m_root:getChildElement("txtBtnName")
	if label == nil then
		return
    end
	label = WZUILabelTTF:luaTo(label)
	if state == 0 then
		btn:setTouchEnable(false)
		label:setText(LocalStrings.INVITE_RECEIVE)
	end
	if state == 1 then
		btn:setTouchEnable(true)
		label:setText(LocalStrings.INVITE_RECEIVE)
	end
	if state == 2 then
		btn:setTouchEnable(false)
		label:setText(LocalStrings.ACTIVE_GET)
	end

	for i=1,4 do
		if id[i] == nil then
			return
		end

		local key = "id_"..id[i]

		local celElement,tLuaObj = CellGoodItem:createElement()
	    local itemInfo = {name=ShopItems[key].name,icon=ShopItems[key].icon,lastTime=num[i],quality=ShopItems[key].quality} 
        if celElement ~= nil then 
		 	celElement = WZUIContainer:luaTo(celElement)
		 	tLuaObj:setCellGoodItem(itemInfo,4)
            celElement:setTag(i-1)
            tbLottery:setCellElement(celElement)
        end
    end
end

--@brief	设置窗口显示的奖励内容
--@param    tag:礼盒的tag
--@note		设置窗口显示的奖励内容
function WndLotteryReward:setReward(tag)
	WZLog("tag:::::111",tag)
	self.m_nTag = tag
	self.m_nId = 16 + tag
	local tbLottery = self.m_root:getChildElement("tbconReward_Wnd")
	if tbLottery == nil then
		return
    else
        tbLottery:setVisible(true)
    end
	tbLottery = WZUITableContainer:luaTo(tbLottery)
	
	local tempTable = CacheCenter:getZflhItems()
	--state：领取按钮状态
	local state = tempTable.state[tag]
	local btn = self.m_root:getChildElement("btngetReward_Wnd")
	if btn == nil then
		return
    end
	btn = WZUIButton:luaTo(btn)
	local label = self.m_root:getChildElement("txtBtnName")
	if label == nil then
		return
    end
	label = WZUILabelTTF:luaTo(label)
	if state == 0 then
		btn:setTouchEnable(false)
		label:setText(LocalStrings.INVITE_RECEIVE)
	end
	if state == 1 then
		btn:setTouchEnable(true)
		label:setText(LocalStrings.INVITE_RECEIVE)
	end
	if state == 2 then
		btn:setTouchEnable(false)
		label:setText(LocalStrings.ACTIVE_GET)
	end

	for i=1,4 do
		local idArray = tempTable.itemId[tag]
		idArray = string.sub(idArray, 2, -2)
		idArray = self:Split(idArray,",")
		
		--没有物品不添加
		if idArray[i] == nil then
			return
		end

		local key = "id_"..idArray[i]
		local numArray = tempTable.itemNum[tag]
		numArray = string.sub(numArray, 2, -2)
		numArray = self:Split(numArray,",")

		local celElement,tLuaObj = CellGoodItem:createElement()
	    local itemInfo = {name=ShopItems[key].name,icon=ShopItems[key].icon,lastTime=numArray[i],quality=ShopItems[key].quality} 
        if celElement ~= nil then 
		 	celElement = WZUIContainer:luaTo(celElement)
		 	tLuaObj:setCellGoodItem(itemInfo,4)
            celElement:setTag(i-1)
            tbLottery:setCellElement(celElement)
        end
    end
end

--@brief	字符串分割函数
function WndLotteryReward:Split(szFullString, szSeparator)  
	local nFindStartIndex = 1  
	local nSplitIndex = 1  
	local nSplitArray = {}  
	while true do  
	   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
	   if not nFindLastIndex then  
	    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
	    break  
	   end  
	   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
	   nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
	   nSplitIndex = nSplitIndex + 1  
	end  
	return nSplitArray  
end  

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	英文适配函数
function WndLotteryReward:_adaptLanguage_en()
	local txtBtnText = GetElement(self.m_root, "txtBtnName", WZUILabelTTF)
	txtBtnText:setText(LocalStrings.INVITE_RECEIVE)
end

--@brief	葡萄牙语适配函数
function WndLotteryReward:_adaptLanguage_pt()
	local txtBtnText = GetElement(self.m_root, "txtBtnName", WZUILabelTTF)
	txtBtnText:setText(LocalStrings.INVITE_RECEIVE)
	txtBtnText:setScale(0.85)
end
-------------------------------------私有方法模块End----------------------------------------
