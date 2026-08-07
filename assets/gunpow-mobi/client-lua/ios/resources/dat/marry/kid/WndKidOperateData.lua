--WndKidOperateData.lua
--@brief	WndKidOperate的数据模块
--@date		2018/05/07
--@author	Tianxiang_Xu
--@note		小家操作界面

WndKidOperate = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKidOperate:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDataList = nil  			--排名数据
	self.m_nRankState = 0 				--0：收起状态;1：展开状态
	self.m_nBabyInfoState = 1 			--1: 展开;0：收起
	self.m_nBabyInfoState2 = 1
	self.m_tBtnList = nil 				--
	self.m_bIsClickFunc = false 	
	self.m_tCellKid = nil 	
	self.m_nTag = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKidOperate:_unInit()
	self.m_root = nil
	self.m_tDataList = nil  			--排名数据
	self.m_nRankState = nil 				--0：收起状态;1：展开状态
	self.m_nBabyInfoState = nil
	self.m_nBabyInfoState2 = nil
	self.m_tBtnList = nil 				--
	self.m_bIsClickFunc = nil 
	self.m_tCellKid = nil 	
	self.m_nTag = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKidOperate:createElement()
	if WndKidOperate.m_root ~= nil then
		WindowManager:removeWindow(WndKidOperate.m_root, WndKidOperate, true)
	end
	local element = WZUISystem:getInstance():createElement("WndKidOperate")
	assert(element, "WndKidOperate create element failed!")
	self:_init()
	return element
end


function WndKidOperate:setData(rank, playerId, serverId, childId, childName, level, headId, faceId, sex)
	self.m_tDataList = {}
	for i=1, #playerId do
		local temp = {}
		temp.playerId = playerId[i]
		temp.serverId = serverId[i]
		temp.name = childName[i]
		temp.rank = rank[i]
		temp.faceId = faceId[i]
		temp.headId = headId[i]
		temp.sex = sex[i]
		temp.level = level[i]

		table.insert(self.m_tDataList, temp)
	end

	WZLog("WndKidOperate:setData", Serialize(self.m_tDataList))

	self:showRank() 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
