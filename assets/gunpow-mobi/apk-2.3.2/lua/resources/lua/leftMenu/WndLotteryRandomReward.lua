--WndLotteryRandomReward.lua
--@brief	WndLotteryRandomReward的UI模块
--@date		2014/09/20
--@author	张盛强
--@note		爱心许愿随机奖励框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLotteryRandomReward:onEnter(element)
	self.m_root = element
	self:_setUIStaticText()
	AdaptLanguage(self)

	local btn = self.m_root:getChildElement("btnClose_Wnd")
	btn = WZUIButton:luaTo(btn)
	btn:setVisible(false)

	local label = self.m_root:getChildElement("labelTips")
	label = WZUILabelTTF:luaTo(label)
	label:setVisible(false)

	--隐藏特效
	local Effects = self.m_root:getChildElement("armaturePro_WndActive")
	Effects = WZArmature:luaTo(Effects)
	Effects:setVisible(false)
	--隐藏环绕特效
	local Effects = self.m_root:getChildElement("armaturePro_Wnd")
	Effects = WZArmature:luaTo(Effects)
	Effects:setVisible(false)
	--隐藏结果
	local Result = self.m_root:getChildElement("conResultShow")
	Result = WZUIContainer:luaTo(Result)
	Result:setVisible(false)

	--添加显示开奖结果的格子
	local con = GetElement(self.m_root, "conResultShow", WZUIContainer)
	local celElement,tLuaObj = CellGoodItem:createElement()
	self.grid = tLuaObj
    if celElement ~= nil then 
		celElement = WZUIContainer:luaTo(celElement)
	    con:addChild(celElement)
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLotteryRandomReward:onExit(element)
	self:_unInit()
end

--@brief	单击开启神秘格子，开始播放动画
--@param    element:关闭按钮的节点
--@note		单击开启神秘格子，开始播放动画
function WndLotteryRandomReward:onAni(element)  
	--隐藏自己
	element:setVisible(false)
    --隐藏初始特效
	local Effects = self.m_root:getChildElement("armaturePro_Wnd1")
	Effects = WZArmature:luaTo(Effects)
	Effects:setVisible(false)
	--显示“正在开奖中”文字
	local label = self.m_root:getChildElement("labelTips")
	label = WZUILabelTTF:luaTo(label)
	label:setVisible(true)
	--显示特效
	--local Effects = self.m_root:getChildElement("armaturePro_WndActive")
	--Effects = WZArmature:luaTo(Effects)
	--Effects:setVisible(true)
	--获得元素
	local img = self.m_root:getChildElement("imgRight_WndActive")
	img = WZUIContainer:luaTo(img)
	img:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	img:setPosition(GlobalMethod:ccp(480,330))
	--播放动画
    --local array = CCArray:create()
	--array:addObject(CCShaky3D:create(1.5,GlobalMethod:CCSize(1, 1),10,false))
	--array:addObject(CCCallFunc:create(function() self:onAni2() end))
	--img:runAction(CCSequence:create(array))
	self:onAni2()

--	local shake = WZUIActionShake:create()
--    shake:setStrengthX(30)
--    shake:setDuration(0.5)
--
--	local subSequence = WZUIActionSequence:create()
--    subSequence:setChildAction(shake)
--	-- 设置回调
--    subSequence:setFinishLuaFunction("onFinish")
--    subSequence:setFinishLuaTable(self)
--    img:runUIAction(subSequence)
end

--@brief	单击关闭按钮时被调用的函数
--@param   element:关闭按钮的节点
--@note		关闭后返回主界面
function WndLotteryRandomReward:onClose(element)  
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then
		return
	end
	--关闭称号窗口
	WindowManager:removeWindow(self.m_root , WndLotteryRandomReward , true)
end

function WndLotteryRandomReward:onAni2()
	--显示特效
	local Effects = self.m_root:getChildElement("armaturePro_WndActive")
	Effects = WZArmature:luaTo(Effects)
	Effects:setVisible(true)
	WZLog("RelativePositionX",Effects:getRelativePosition().x)
	WZLog("RelativePositionY",Effects:getRelativePosition().y)
	WZLog("Position",Effects:getPosition())
	Effects:setRelativePosition(GlobalMethod:ccp(0.55,0.7))
	WZLog("RelativePositionX",Effects:getRelativePosition().x)
	WZLog("RelativePositionY",Effects:getRelativePosition().y)
	WZLog("Position",Effects:getPosition())
	self.m_root:enableSchedule("onFinish", 1.5)
	local img = self.m_root:getChildElement("imgRight_WndActive")
	img = WZUIContainer:luaTo(img)
	
	img:setVisible(false)
end

--@brief	动画播放完成后显示获得的奖励，隐藏动画
--@param   element:关闭按钮的节点
--@note		动画播放完成后显示获得的奖励，隐藏动画
function WndLotteryRandomReward:onFinish(element)  
	self.m_root:disableSchedule()
	WZLog("动画结束") 
	--隐藏“正在开奖中”文字
	local label = self.m_root:getChildElement("labelTips")
	label = WZUILabelTTF:luaTo(label)
	label:setVisible(false)
	--显示关闭按钮
	local btn = self.m_root:getChildElement("btnClose_Wnd")
	btn = WZUIButton:luaTo(btn)
	btn:setVisible(true)
	--隐藏特效
	local Effects = self.m_root:getChildElement("armaturePro_WndActive")
	Effects = WZArmature:luaTo(Effects)
	Effects:setVisible(false)
	local img = self.m_root:getChildElement("imgRight_WndActive")
	img = WZUIContainer:luaTo(img)
	img:setVisible(false)
	--显示环绕特效
	local Effects = self.m_root:getChildElement("armaturePro_Wnd")
	Effects = WZArmature:luaTo(Effects)
	Effects:setVisible(false)
	--更换图片
	local img = self.m_root:getChildElement("Reward")
	img = WZUIImage:luaTo(img)
	img:setFile(ShopItems["id_"..self.m_nRewardId].icon)
	img:setVisible(false)
	--显示物品名字
	local label = self.m_root:getChildElement("txtRewardName")
	label = WZUILabelTTF:luaTo(label)
	label:setText(ShopItems["id_"..self.m_nRewardId].name)
	label:setVisible(false)
	--显示物品数量
	local label = self.m_root:getChildElement("txtNum_CellLotteryList")
	label = WZUILabelTTF:luaTo(label)
	label:setText("X"..self.m_nNum)
	label:setVisible(false)
	--显示结果
	local Result = self.m_root:getChildElement("conResultShow")
	Result = WZUIContainer:luaTo(Result)
	Result:setVisible(true)

	local id = self.m_nRewardId
	local name = ShopItems["id_"..id].name
	local icon = ShopItems["id_"..id].icon
	local quality = ShopItems["id_"..id].quality
	local lastTime = self.m_nNum
	local tempTable = {id=id,name=name,icon=icon,quality=quality,lastTime=lastTime}
	self.grid:setCellGoodItem(tempTable,4)
end

--@brief	设置按钮文字
function WndLotteryRandomReward:setBtnText(text)
	local label1 = GetElement(self.m_root, "label1_Wnd", WZUILabelTTF)
	label1:setText(text)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	设置最后获得的奖品的id
function WndLotteryRandomReward:setRewardInfo(id,num)
	self.m_nRewardId = id
	self.m_nNum = num
end

function WndLotteryRandomReward:_setUIStaticText()
	local label1 = GetElement(self.m_root, "label1_Wnd", WZUILabelTTF)
	label1:setText(LocalStrings.LOTTERY_OPEN)

	local label2 = GetElement(self.m_root, "labelTips", WZUILabelTTF)
	label2:setText(LocalStrings.LOTTERY_OPENNING.."......")

	local btnText = GetElement(self.m_root, "btnText", WZUILabelTTF)
	btnText:setText(LocalStrings.CONFIRM)

end

--@brief	英文适配函数
function WndLotteryRandomReward:_adaptLanguage_en()
	local label1 = GetElement(self.m_root, "label1_Wnd", WZUILabelTTF)
	label1:setScaleX(0.6)
end

--@brief	葡萄牙语适配函数
function WndLotteryRandomReward:_adaptLanguage_pt()
	local label1 = GetElement(self.m_root, "label1_Wnd", WZUILabelTTF)
	label1:setScaleY(0.8)
	label1:setScaleX(0.55)

	local btnText = GetElement(self.m_root, "btnText", WZUILabelTTF)
	btnText:setScale(0.8)
end
-------------------------------------私有方法模块End----------------------------------------
