--WndNewYearSignReward.lua
--@brief	WndNewYearSignReward的UI模块
--@date		2020/12/14
--@author	hyx
--@note		求签获取的奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndNewYearSignReward:onEnter(element)
	self.m_root = element

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndNewYearSignReward:onExit(element)
	self:_unInit()
end
function WndNewYearSignReward:showInterface(result, itemId, itemNum)
	local wndReward = WndNewYearSignReward:createElement()
    WindowManager:addWindow(wndReward,WndNewYearSignReward,nil,false)

    self:setResultData(result, itemId, itemNum)
end
	
function WndNewYearSignReward:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndNewYearSignReward:actionCallback()
	local txtSignResult1 = GetElement(self.m_root,"txtSignResult1",WZUILabelTTF)
	local txtSignResult2 = GetElement(self.m_root,"txtSignResult2",WZUILabelTTF)
	local str = {"m o","xiao","zhong","d a"}
	self.m_nSignResult = tonumber(self.m_nSignResult)
	txtSignResult1:setText(str[self.m_nSignResult+1])
	txtSignResult2:setText(LocalStrings.EVERYDAYBUY_TEXT31[self.m_nSignResult+1])

	local function GetRandomNumList(len)
		local rsList = {}
		for i = 1,len do
			table.insert(rsList,i)
		end
		local num,tmp
		for i = 1,len do
			num = math.random(1,len)
			tmp = rsList[i]
			rsList[i] = rsList[num]
			rsList[num] = tmp    
		end
		return rsList
	end
	local str = LocalStrings["NEWYEARSIGN_TEXT"..self.m_nSignResult]
	local num = GetRandomNumList(#str)
	for i=1, 2 do
		local txtRewardTips = GetElement(self.m_root,"txtRewardTips"..i,WZUILabelTTF)
		txtRewardTips:setText(str[num[i]])
	end
	
	local count = #self.m_tSignItemId
	if count >= 2 then
		count = 2
	end
	for i = 1, count do
		local itemNode = GetElement(self.m_root,"itemNode"..i,WZUIContainer)
		local celElement,tLuaObj = CellGoodItem:createElement()
		itemNode:addChild(celElement)
		celElement:setScale(0.85)
		local key = "id_"..self.m_tSignItemId[i]
		local tabItem = GDatatab_item[key]
		local num = self.m_tItemNum[i]
		local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		tLuaObj:setCellGoodItem(itemInfo, 17)
		tLuaObj:setItemClickFun(WndNewYearSignReward,self.onItemClick)
	end
end

--@brief	点击物品弹出对应的tips
function WndNewYearSignReward:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndNewYearSignReward.m_root,1,tData,false,nil,true)
end

function WndNewYearSignReward:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


function WndNewYearSignReward:_adaptLanguage_vn()
	GetElement(self.m_root, "itemNode1", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.32,0.27))
	GetElement(self.m_root, "itemNode2", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.68,0.27))

	local txtRewardTips1 = GetElement(self.m_root, "txtRewardTips1", WZUILabelTTF)
	txtRewardTips1:setRotation(0)
	txtRewardTips1:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	txtRewardTips1:setRelativePosition(GlobalMethod:ccp(0.18,0.525))
	local txtRewardTips2 = GetElement(self.m_root, "txtRewardTips2", WZUILabelTTF)
	txtRewardTips2:setRotation(0)
	txtRewardTips2:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	txtRewardTips2:setRelativePosition(GlobalMethod:ccp(0.18,0.415))
end
