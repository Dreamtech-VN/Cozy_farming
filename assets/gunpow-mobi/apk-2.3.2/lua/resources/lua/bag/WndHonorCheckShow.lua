--WndHonorCheckShow.lua
--@brief	WndHonorCheckShow的UI模块
--@date		2020/10/31
--@author	hyx
--@note		查看信誉界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHonorCheckShow:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHonorCheckShow:onExit(element)
	self:_unInit()
end

function WndHonorCheckShow:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end

function WndHonorCheckShow:actionCallback()
	self:initShow()
end
function WndHonorCheckShow:initShow()
	local score = CacheCenter:getPlayerInfo().honourPoint or 0
	local title_name = { LocalStrings.OPTIMIZE_TEXT21, LocalStrings.OPTIMIZE_TEXT22, LocalStrings.OPTIMIZE_TEXT23,
						 LocalStrings.OPTIMIZE_TEXT24, LocalStrings.OPTIMIZE_TEXT25, LocalStrings.OPTIMIZE_TEXT26 }
	local curHonorTitle = GetElement(self.m_root,"curHonorTitle",WZUILabelTTF)
	local index = 0
	if score >= 0 and score < 30 then
		index = 1
	elseif score >= 30 and score < 40 then
		index = 2
	elseif score >= 40 and score < 50 then
		index = 3
	elseif score >= 50 and score < 70 then
		index = 4
	elseif score >= 70 and score < 90 then
		index = 5
	elseif score >= 90 then
		index = 6
	end
	if index == 0 then
		curHonorTitle:setText("***")
	else
		curHonorTitle:setText(title_name[index])
	end

	local honorProgree = GetElement(self.m_root,"honorProgree",WZUIProgress)
	honorProgree:setPercentage(score)
	local honorProgreeCount = GetElement(self.m_root,"honorProgreeCount",WZUILabelTTF)
	honorProgreeCount:setText(score.."/100")

	GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox):setShowText(LocalStrings.OPTIMIZE_TEXT19)
	self:_upMoveContainerLayer()
end
--@brief  	更新滚动容器内部布局函数
function WndHonorCheckShow:_upMoveContainerLayer()
	if self.m_root == nil then
		return
	end
	--获取规则说明内容文本的大小
	local txtExplanation = GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox)
	local txtSize = txtExplanation:getContentSize()	
	txtExplanation:setAnchorPoint(ccp(0,1))
	txtExplanation:setPositionY(txtSize.height-5)
	WZLog("富文本框尺寸是",txtSize.width,txtSize.height)

	local rollconExplanation = self.m_root:getChildElement("rollconExplanation_WndHonor")
	if rollconExplanation == nil then 
		return
	end
	rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
	local rollSize = rollconExplanation:getContentSize()
	--更改滚动容器Element的大小
	local moveElement = rollconExplanation:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize(1 , txtSize.height / rollSize.height ) )
	--moveElement:setContentSize(txtSize)
	rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(rollconExplanation:getMinPosition().y)
	WZLog("滚动容器大小",rollSize.width,rollSize.height)
end

function WndHonorCheckShow:showInterface()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local honorCheck = WndHonorCheckShow:createElement()
	if honorCheck ~= nil then
	    WindowManager:addWindow(honorCheck,WndHonorCheckShow,nil,false)
	end
end

function WndHonorCheckShow:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
