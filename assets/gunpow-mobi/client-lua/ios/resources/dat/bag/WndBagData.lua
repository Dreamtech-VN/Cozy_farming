--WndBagData.lua
--@brief	WndBag的数据模块
--@date		2014/02/17
--@author	zsq
--@note		背包模块

WndBag = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBag:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bFrameIndex = false			--1背包,2时装,3属性
	self.m_nVigor = 0
	self.m_tWndSell = nil				--出售窗口lua表对象
	self.m_tWndSellList = nil			--出售物品列表窗口lua表对象
	self.m_tWndSynthesis = nil				--出售窗口lua表对象
	self.m_tWndSynthesisList = nil			--出售物品列表窗口lua表对象
	self.m_nPutOnTimes = nil			--一键换装装备个数

	self.m_nUseType = nil   			--道具使用标记，用于协议返回显示结果tips内容的标识 1：改名笔，2：公会改名笔，3：甜甜圈
	self.m_bAniRunning = nil
	self.synthesisIndex = nil
	self.synId = nil
	self.m_bOpenStrengthen = false
	self.jumpTag = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBag:_unInit()
	self.m_root = nil
	self.m_bFrameIndex = nil
	self.m_nVigor = nil
	self.m_tWndSell = nil				--出售窗口lua表对象
	self.m_tWndSellList = nil			--出售物品列表窗口lua表对象
	self.m_tWndSynthesis = nil				--出售窗口lua表对象
	self.m_tWndSynthesisList = nil			--出售物品列表窗口lua表对象
	self.m_nPutOnTimes = nil

	self.m_nUseType = nil   			--道具使用标记，用于协议返回显示结果tips内容的标识 1：改名笔，2：公会改名笔，3：甜甜圈
	self.m_bAniRunning = nil
	self.synthesisIndex = nil
	self.synId = nil
	self.m_bOpenStrengthen = nil
	self.jumpTag = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBag:createElement()
    if self.m_root then
        WindowManager:removeWindow(self.m_root,WndBag)
    end

	local element = WZUISystem:getInstance():createElement("WndBag")
	assert(element, "WndBag create element failed!")
    Teach.PreUIChannelId = GlobalGame.g_nCurrentUIChannelId
	self:_init()
	return element
end

--@brief	缓存推送更新玩家基本信息(数据更新)
function WndBag:updatePlayerInfoData()
	WZLog("WndBag:等待更新玩家基本信息(数据更新)",WndBag.m_bOpenStrengthen)
	if WndBag.m_bOpenStrengthen == true then return end
	if self.m_root == nil then return end
	self:setVigor(CacheCenter:getPlayerInfo())
	self:setExchangeExp()
end

--@brief	更新活力值，播放活力动画
function WndBag:setVigor(tData)
	if self.m_root == nil or tData == nil then return end

	--活力值
	local nExp = tData.vigor - self.m_nVigor
	if nExp ~= 0 and self.m_nVigor ~= 0 and tonumber(nExp) > 1 then
		self.m_nVigor = tData.vigor
		local parentNode = GetElement(self.m_root, "conForAct_WndBag", WZUIContainer)
		createActChangeAni(parentNode, "ui/common_num/common_num_yaoqianshuzi.png", "ui/common/common_icon_huoli.png", nExp)
		return
	end
	self.m_nVigor = tData.vigor
end

--@brief 	设置经验兑换按钮是否显示
function WndBag:setExchangeExp()
	-- body
	local btnExchangeExp = GetElement(self.m_root, "btnExchangeExp_WndBag", WZUIButton)
	local tPlayerInfo = CacheCenter:getPlayerInfo()
	local bVisible = false 
	if btnExchangeExp then
		if tPlayerInfo.level == tonumber(CacheCenter:getGameParam()["gameMaxLevel"]) then
			if tPlayerInfo.exp >= tPlayerInfo.maxExp then
				bVisible = true
			end
		end
	end

	btnExchangeExp:setVisible(bVisible)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------
