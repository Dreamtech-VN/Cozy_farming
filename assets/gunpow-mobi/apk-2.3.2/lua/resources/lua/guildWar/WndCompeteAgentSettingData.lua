-- WndCompeteAgentSetting 数据部分
-- @brief: 设置代理人设置界面
-- @date: 2017-03-02 11:17:31
-- @author: zhenwei_jian
-- @note:设置代理人设置界面




local WndCompeteAgentSetting = {}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCompeteAgentSetting:_init()
	self.m_root 		= nil	 	  	--场景根节点  
	self.m_tData 		= nil 			--服务端数据
	self.m_tPlayerState = {}			--保存代理人用户状态

	--公会职称 Map 表
	self._mJobNameMap = {
		[COMMUNITY_PRESIDENT 		] = LocalStrings.PRESIDENT,						--会长
		[COMMUNITY_VICE_PRESIDENT 	] = LocalStrings.VICE_PRESIDENT,				--副会长
		[COMMUNITY_ELDER 			] = LocalStrings.ELDERS,						--长老
		[COMMUNITY_ELITE 			] = LocalStrings.PICK,							--精英
		[COMMUNITY_MEMBER 			] = LocalStrings.NORMAL_COMMUNITY_MEMBER,		--普通会员
	}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCompeteAgentSetting:_unInit()
	self.m_root 		= nil
	self.m_tData 		= nil 			--服务端数据
	self._mJobNameMap  	= nil
	self.m_tPlayerState = {}
end


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCompeteAgentSetting:createElement()
	local element = WZUISystem:getInstance():createElement("WndCompeteAgentSetting")
	assert(element, "WndCompeteAgentSetting create element failed!")
	self:_init()
	return element
end

--是否允许设置代理人
function WndCompeteAgentSetting:allowSetAgent()
	WZLog("CacheCenter:getPlayerInfo().position::::::::", CacheCenter:getPlayerInfo().position, COMMUNITY_PRESIDENT)
	if tonumber(CacheCenter:getPlayerInfo().position) == COMMUNITY_PRESIDENT then
		return true
	end
	return false
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndCompeteAgentSetting:setData(tData)
	self.m_tData = tData
	self:_update()
end
 
-------------------------------------私有方法模块End--------------------------------------



rawset(_G, "WndCompeteAgentSetting", WndCompeteAgentSetting)

