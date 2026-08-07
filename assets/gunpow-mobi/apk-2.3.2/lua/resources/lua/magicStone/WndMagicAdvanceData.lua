--WndMagicAdvanceData.lua
--@brief	WndMagicAdvance的数据模块
--@date		2019/10/23
--@author	Tianxiang_Xu
--@note		幻石系统-进阶赠礼界面

WndMagicAdvance = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMagicAdvance:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMagicAdvance:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMagicAdvance:createElement()
	if WndMagicAdvance.m_root ~= nil then
		WindowManager:removeWindow(WndMagicAdvance.m_root, WndMagicAdvance, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMagicAdvance")
	assert(element, "WndMagicAdvance create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndMagicAdvance:showInterface()
	-- body
	local wndStone = WndMagicAdvance:createElement()
	if wndStone then 
		WindowManager:addWindow(wndStone,WndMagicAdvance,nil,nil,nil,true)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	根據季度获取进阶奖励预览
function WndMagicAdvance:getCurAdvanceRewardData()
	-- body
	local sAdvance = CacheCenter:getGameParam().stoneRewardLevel
	local string = string.sub(sAdvance,2,-2) 
	local array = SplitStringWithSeparator(string, "|")
	for i = 1, #array do
		local nStart, nEnd = string.find(array[i], ",reward:") 
		local season = string.sub(array[i], 9, nStart - 1)
		local reward = string.sub(array[i], nEnd + 1, -2) 
		if tonumber(season) == WndMagicStone:getCurSeasonValue() then 
			return reward 
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------
