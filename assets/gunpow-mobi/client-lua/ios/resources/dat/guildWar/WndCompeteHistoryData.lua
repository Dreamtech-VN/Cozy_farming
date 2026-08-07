-- WndCompeteHistory
-- @brief: 公会战历届 数据模块
-- @date: 2017-02-23 14:30:22
-- @author: zhenwei_jian
-- @note: 公会战历届


local WndCompeteHistory = {}


--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCompeteHistory:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nPageNum = 1 				--标记当前第几页
	self.m_nMaxPage = nil 				--标记最大页数(当前届)
	self.m_tData = nil 					--当前显示的数据
	self.guildId = {-1, -1, -1} 		--公会ID
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCompeteHistory:_unInit()
	self.m_root = nil
	self.m_nPageNum = 1
	self.m_nMaxPage = nil
	self.m_tData = nil
	self.guildId = {-1, -1, -1}					--公会ID
end

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCompeteHistory:createElement()
	local element = WZUISystem:getInstance():createElement("WndCompeteHistory")
	assert(element, "WndCompeteHistory create element failed!")
	self:_init()
	return element
end

local dataKeys = { "guildId", "serverId", "level", "name", "num" }
local function swap(tData, i, k)
	for _, key in ipairs(dataKeys) do
		local tmp = tData[key][i]
		tData[key][i] = tData[key][k]
		tData[key][k] = tmp
	end
end

function WndCompeteHistory:setData(tData)
	self.m_tData = tData
	-- WZLog("self.m_tData::", self.m_tData)
	-- WZLog("self.m_tData.version::", self.m_tData.version)

	--排序 (guildId, serverId, level, name, num)
	local nLen = #tData.num
	for i = 1, nLen do
		for k = i, nLen do
			local a = tData.num[i]
			local b = tData.num[k]
			if b > a then
				swap(tData, i, k)
			end
		end
	end

	self.m_nPageNum = self.m_tData.version
	if nil == self.m_nMaxPage then
		self.m_nMaxPage = self.m_tData.version
	end

	self.guildId = self.m_tData.guildId

	self:_update()
end


--@brief   创建加载框
function WndCompeteHistory:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndCompeteHistory:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end


-------------------------------------私有方法模块End----------------------------------------


-------------------------------------公有方法模块End----------------------------------------



rawset(_G, "WndCompeteHistory", WndCompeteHistory)
