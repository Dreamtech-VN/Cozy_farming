--WndLotteryHankData.lua
--@brief	WndLotteryHank的数据模块
--@date		2021/04/28
--@author	hyc
--@note		召唤图鉴

WndLotteryHank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLotteryHank:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_type = nil					--2：坐骑，4：足迹，3：幻化
	self.m_data = nil
	self.m_tItemChoice = nil			--当前图鉴选择item
	self.m_footSpine = nil
	self.conPlayer = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLotteryHank:_unInit()
	self.m_root = nil
	self.m_type = nil
	self.m_data = nil
	self.m_tItemChoice = nil
	self.m_footSpine = nil
	self.conPlayer = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLotteryHank:createElement()
	if WndLotteryHank.m_root ~= nil then
		WindowManager:removeWindow(WndLotteryHank.m_root, WndLotteryHank, true)
	end
	local element = WZUISystem:getInstance():createElement("WndLotteryHank")
	assert(element, "WndLotteryHank create element failed!")
	self:_init()
	return element
end

function WndLotteryHank:showInterface(ntype)
	-- body
	WZLog("召唤图鉴",ntype)
	local wndhank = WndLotteryHank:createElement()
	if wndhank then
		self.m_type = ntype
		WindowManager:addWindow(wndhank,WndLotteryHank,false,nil,nil,true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
