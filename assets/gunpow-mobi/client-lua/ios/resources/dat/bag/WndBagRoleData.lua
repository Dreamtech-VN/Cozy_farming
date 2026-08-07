--WndBagRoleData.lua
--@brief	WndBagRole的数据模块
--@date		2017/07/07
--@author	zsq
--@note		玩家背包

WndBagRole = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBagRole:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tWndSynthesis = nil
	self.m_tWndSynthesisList = nil
	self.m_tWndSell = nil
	self.m_tWndSellList = nil
	self.m_nVigor = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBagRole:_unInit()
	self.m_root = nil
	self.m_tWndSynthesis = nil
	self.m_tWndSynthesisList = nil
	self.m_tWndSell = nil
	self.m_tWndSellList = nil
	self.m_nVigor = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBagRole:createElement()
	if WndBagRole.m_root ~= nil then
		WindowManager:removeWindow(WndBagRole.m_root, WndBagRole, true)
	end
	local element = WZUISystem:getInstance():createElement("WndBagRole")
	assert(element, "WndBagRole create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	缓存推送更新玩家基本信息(数据更新)
function WndBagRole:updatePlayerInfoData()
	WZLog("WndBagRole:等待更新玩家基本信息(数据更新)")
	if self.m_root == nil then return end
	self:setVigor(CacheCenter:getPlayerInfo())
end

--@brief	更新活力值，播放活力动画
function WndBagRole:setVigor(tData)
	if self.m_root == nil or tData == nil then return end

	--活力值
	local nExp = tData.vigor - self.m_nVigor
	if nExp ~= 0 and self.m_nVigor ~= 0 and tonumber(nExp) > 1 then
		self.m_nVigor = tData.vigor
		local parentNode = GetElement(self.m_root, "conPlayer_WndBag", WZUIContainer)
		createActChangeAni(parentNode, "ui/common_num/common_num_yaoqianshuzi.png", "ui/common/common_icon_huoli.png", nExp)
		return
	end
	self.m_nVigor = tData.vigor
end

--@brief	进入背包合成
--@brief	tabIndex进入标签
function WndBagRole:showBagSynthesis(tabIndex, synId)
	WZLog("WndBagRole:showBagSynthesis",tabIndex)
	if self.m_root == nil then
		local wndBagElement = WndBagRole:createElement()
		WindowManager:addWindow(wndBagElement, WndBagRole, nil, nil, true)
    	--左右容器移动动画
    	local leftCon = GetElement(self.m_root,"conLeft_WndBag",WZUIContainer)
    	local rightCon = GetElement(self.m_root,"conRight_WndBag",WZUIContainer)
		leftCon:setVisible(false)
		rightCon:setVisible(false)

		if tabIndex == nil then tabIndex = 1 end
		self.synthesisIndex = tabIndex
		self.synId = synId
		leftCon:enableSchedule("showBagSynthesisCall",0.1)
	else
    	local leftCon = GetElement(self.m_root,"conLeft_WndBag",WZUIContainer)
    	local rightCon = GetElement(self.m_root,"conRight_WndBag",WZUIContainer)
		leftCon:setVisible(false)
		rightCon:setVisible(false)

		if tabIndex == nil then tabIndex = 1 end
		self.synthesisIndex = tabIndex
		self.synId = synId
		leftCon:enableSchedule("showBagSynthesisCall",0.1)
	end
end

--@brief	延时进入合成
function WndBagRole:showBagSynthesisCall()
	WZLog("WndBagRole:showBagSynthesisCall")
	if WndItemInfo.m_root ~= nil then return end
   	local leftCon = GetElement(self.m_root,"conLeft_WndBag",WZUIContainer)
	leftCon:disableSchedule()
	WndEquipNew:onSynthesis()

	WndSynthesisRight:_updateWithIndex(self.synthesisIndex)
	leftCon:enableSchedule("showBagSynthesisCall1",0.3)
end

function WndBagRole:showBagSynthesisCall1()
   	local leftCon = GetElement(self.m_root,"conLeft_WndBag",WZUIContainer)
	leftCon:disableSchedule()

	WndSynthesisRight:autoPutItem()
end


-------------------------------------私有方法模块End----------------------------------------
