--CellPrivilegeRankRewardData.lua
--@brief	CellPrivilegeRankReward的数据模块
--@date		2021/04/07
--@author	hyx
--@note		名人榜奖励

CellPrivilegeRankReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellPrivilegeRankReward:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPrivilegeRankReward:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellPrivilegeRankReward:createElement()
	if CellPrivilegeRankReward.m_root ~= nil then
		WindowManager:removeWindow(CellPrivilegeRankReward.m_root, CellPrivilegeRankReward, true)
	end
	local element = WZUISystem:getInstance():createElement("CellPrivilegeRankReward")
	assert(element, "CellPrivilegeRankReward create element failed!")
	self:_init()
	return element
end

function CellPrivilegeRankReward:setRankRewardData( month, day )
	if day >= 16 then
	else
		month = month - 1
		if month <= 0 then
			month = 12
		end
	end
	local data = {}
	local table_insert = table.insert
	local table_sort = table.sort
	if GDatatab_vip_rank_reward then
		for i,v in pairs(GDatatab_vip_rank_reward) do
			if v.month == month then
				table_insert(data,v)
			end
		end
		table_sort( data, function(a,b) return a.id < b.id end)
	end
	return data
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
