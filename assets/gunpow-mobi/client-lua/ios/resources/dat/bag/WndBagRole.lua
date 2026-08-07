--WndBagRole.lua
--@brief	WndBagRole的UI模块
--@date		2017/07/07
--@author	zsq
--@note		玩家背包


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBagRole:onEnter(element)
	self.m_root = element
	ProtocolProcessorWndBag:regAll()
	ProtocolProcessorWndMonthCards:regAll()
	CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物
end

--@brief	加载完成
function WndBagRole:onEnterTransitionDidFinish(element)
	self.m_root:setVisible(true)
	--self:_addTop()
	self:_addEquip()
	self.m_nVigor = CacheCenter:getPlayerInfo().vigor
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBagRole:onExit(element)
	self:_unInit()
	ProtocolProcessorWndBag:unregAll()
	ProtocolProcessorWndMonthCards:unregAll()
	CacheCenter:unregisterUpatePlayerInfoObserver(self)
end

function WndBagRole:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/bag/bag_icon_beibao.png",WndBagRole,WndBagRole.onCloseClick,true,false,false,"WndBagRole")
end

--@brief	关闭按钮点击回调
--@param 	element:触发事件的控件引用
function WndBagRole:onCloseClick(element)
    WZLog("WndBagRole:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root == nil then return end
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	背包接口
function WndBagRole:showWin()
	WZLog("WndBagRole:showBag")
	local wnd = WndBagRole:createElement()
	WindowManager:addWindow(wnd, WndBagRole, nil, nil, true)
end

--@brief   添加右侧背包栏
function WndBagRole:_addEquip()
	local conPlayer = self.m_root:getChildElement("conRight_WndBag")
	local celElement = WndEquipNew:createElement()
	if conPlayer:getChildByTag(1) then
		conPlayer:removeChildByTag(1,true)
	end
	celElement:setTag(1)
	WndEquipNew:setItemBackFun(WndBag,WndBag.onItemClick,self.onItem)
	conPlayer:addChild(celElement)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
