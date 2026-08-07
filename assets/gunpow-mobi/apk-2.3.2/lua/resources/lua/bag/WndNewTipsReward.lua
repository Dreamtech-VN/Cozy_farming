--WndNewTipsReward.lua
--@brief	WndNewTipsReward的UI模块
--@date		2021/01/08
--@author	hyx
--@note		tips奖励物品


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndNewTipsReward:onEnter(element)
	self.m_root = element

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndNewTipsReward:onExit(element)
	self:_unInit()
end

function WndNewTipsReward:onEnterTransitionDidFinish(element)
--	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndNewTipsReward:actionCallback()
end
function WndNewTipsReward:showInterface(element, btnElement, data, bShowAll, pt)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tips = WndNewTipsReward:createElement()
	if tips ~= nil then
		tips:setShowAll(bShowAll or false)
		if pt then 
			tips:setRelativePosition(pt)
		end
	    element:addChild(tips)
	    self:setData(btnElement,data)
	end
end

function WndNewTipsReward:setData(btnElement, data)
	if not data then return end
	local reward_container = GetElement(self.m_root,"reward_container",WZUIContainer)
	reward_container:setUseAbsCoordinate(true)

	local cur_str = data.cur_value or 0
	local totle_str = data.totle_value or 0 
	if data.winType and data.winType == 1 then 
		local txtTipTitle = GetElement(self.m_root, "txtTipTitle_WndNewTipsReward", WZUILabelTTF)
		txtTipTitle:setTextKey("")
		txtTipTitle:setText(LocalStrings.DRESSGIVE_TEXT1[2])
	else
		if data.title then 
			local txtTipTitle = GetElement(self.m_root, "txtTipTitle_WndNewTipsReward", WZUILabelTTF)
			if data.titleFontSize then 
				txtTipTitle:setFontSize(data.titleFontSize)
			end
			txtTipTitle:setTextKey("")
			txtTipTitle:setText(data.title)
		else
			GetElement(self.m_root,"curNumText",WZUILabelTTF):setText(cur_str.."/"..totle_str)
		end
	end

	local rewardTableList = GetElement(self.m_root,"rewardTableList",WZUITableContainer)

	local img_icon = data.icon or nil
	local img_scale = data.scale or 1
	local icon = GetElement(self.m_root,"icon",WZUIImage)
	if img_icon then
		local item_info = GDatatab_item["id_" .. img_icon]
		if item_info then
			icon:setFile(item_info.icon)
			icon:setScale(img_scale)
		end
	end

	for i=1, #data.rewardIds do
		local celElement,tCell = CellTipsRewardItem:createElement()
		celElement:setTag(i-1)
		rewardTableList:setCellElement(celElement)
		tCell:setRewardMessage(data.rewardIds[i], data.rewardNums[i])
	end


	local ptA = btnElement:convertToWorldSpace(GlobalMethod:ccp(0,0))
	reward_container:setAbsPosition(GlobalMethod:ccp(ptA.x, ptA.y))
end
function WndNewTipsReward:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root then
		self.m_root:removeFromParentAndCleanup(true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


function WndNewTipsReward:_adaptLanguage_vn()
	local txtTipTitle = GetElement(self.m_root, "txtTipTitle_WndNewTipsReward", WZUILabelTTF)
	txtTipTitle:setScale(0.75)
	txtTipTitle:setDimensions(GlobalMethod:CCSize(340,0))
	txtTipTitle:setRelativePosition(GlobalMethod:ccp(0.05,0.87))
end