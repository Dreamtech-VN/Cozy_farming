--WndAuctionIdentifyRuleData.lua
--@brief	WndAuctionIdentifyRule的数据模块
--@date		2023/06/01
--@author	yrd
--@note		拍卖行-鉴宝界面规则说明

WndAuctionIdentifyRule = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAuctionIdentifyRule:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sDesc = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAuctionIdentifyRule:_unInit()
	self.m_root = nil
	self.m_sDesc = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAuctionIdentifyRule:createElement()
	if WndAuctionIdentifyRule.m_root ~= nil then
		WindowManager:removeWindow(WndAuctionIdentifyRule.m_root, WndAuctionIdentifyRule, true)
	end
	local element = WZUISystem:getInstance():createElement("WndAuctionIdentifyRule")
	assert(element, "WndAuctionIdentifyRule create element failed!")
	self:_init()
	return element
end

--@brief	外部接口函数
--@param    #1 desc:规则说明内容
function WndAuctionIdentifyRule:showInterface(desc)
	if desc == nil or desc == "" then return end

	local wnd = WndAuctionIdentifyRule:createElement()
	self.m_sDesc = desc
	WindowManager:addWindow( wnd , WndAuctionIdentifyRule ,nil ,nil ,nil ,true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
