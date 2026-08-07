--WndBatchBuyData.lua
--@brief	WndBatchBuy的数据模块
--@date		2021/10/12
--@author	hyc
--@note		批量购买界面

WndBatchBuy = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBatchBuy:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_data = nil 					--
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBatchBuy:_unInit()
	self.m_root = nil
	self.m_data = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBatchBuy:createElement()
	-- if WndBatchBuy.m_root ~= nil then
	-- 	WindowManager:removeWindow(WndBatchBuy.m_root, WndBatchBuy, true)
	-- end
	-- local element = WZUISystem:getInstance():createElement("WndBatchBuy")
	-- assert(element, "WndBatchBuy create element failed!")
	-- self:_init()
	-- return element
	local element = WZUISystem:getInstance():createElement("WndBatchBuy")
	assert(element, "WndCommunityMonthCard create element failed!")
	self:_init()
	return element
end

function WndBatchBuy:setData(mdata)
	-- body
	
	WZLog("WndBatchBuy:setData")
	self.m_data = mdata
	self:updateView()
end

function WndBatchBuy:showInterface(mdata)
	local wndBatchBuy = WndBatchBuy:createElement()
	if wndBatchBuy ~= nil then

	    WindowManager:addWindow(wndBatchBuy,WndBatchBuy,nil,true)
	end
	self.m_data = mdata
	self:updateView()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
