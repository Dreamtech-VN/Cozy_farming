--WndFamilyOperateData.lua
--@brief	WndFamilyOperate的数据模块
--@date		2017/07/25
--@author	Tianxiang_Xu
--@note		家园系统操作窗口

WndFamilyOperate = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFamilyOperate:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tBtnList = {}				--底部功能按钮
	self.m_bIsClickFunc = false 		
	self.m_tOperateData = nil  			--保存操作的建筑数据
	self.m_bIsTeachOnEnter = nil
	self.m_txtRecoverTime = nil 		--展示受伤恢复时间的节点
	self.m_tDataList = nil 
	self.m_nRankState = 0 				--0：收起状态;1：展开状态
	self.m_nTag = nil  
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFamilyOperate:_unInit()
	self.m_root = nil
	self.m_tBtnList = nil
	self.m_bIsClickFunc = nil  
	self.m_tOperateData = nil  
	self.m_bIsTeachOnEnter = nil			
	self.m_txtRecoverTime = nil 		--展示受伤恢复时间的节点
	self.m_tDataList = nil 
	self.m_nRankState = nil
	self.m_nTag = nil  
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFamilyOperate:createElement()
	if WndFamilyOperate.m_root ~= nil then
		WindowManager:removeWindow(WndFamilyOperate.m_root, WndFamilyOperate, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFamilyOperate")
	assert(element, "WndFamilyOperate create element failed!")
	self:_init()
	return element
end


--@brief 	加速疗伤成功
function WndFamilyOperate:speedToRecoverOK()
	-- body
	SceneFamily:_stopLoading()

	SceneFamily.m_nRecoverTime = 0
	self:_showHurtState()
end

--@brief 	设置受伤恢复倒计时
function WndFamilyOperate:setRecoverTimeCaculate()
	-- body
	if self.m_root == nil then return end 

	self:_showHurtState()
	self.m_root:enableSchedule("_recoverTimeCaculate", 1)
end

function WndFamilyOperate:setData(playerId, serverId, name, rank, faceId, headColor, headId, sex, level, vipLevel, homeLevel, homeExp, sheerLuxury, playerRank, canSteal)
	self.m_tDataList = {}
	for i=1,#playerId do
		local temp = {}
		temp.playerId = playerId[i]
		temp.serverId = serverId[i]
		temp.name = name[i]
		temp.rank = rank[i]
		temp.faceId = faceId[i]
		temp.headColor = headColor[i]
		temp.headId = headId[i]
		temp.sex = sex[i]
		temp.level = level[i]
		temp.vipLevel = vipLevel[i]
		temp.homeLevel = homeLevel[i]
		temp.homeExp = homeExp[i]
		temp.sheerLuxury = sheerLuxury[i]
		temp.stealState = canSteal[i]
		table.insert(self.m_tDataList, temp)
	end
	self.playerRank = playerRank
	WZLog("WndFamilyOperate:setData",playerRank,Serialize(self.m_tDataList))

	self:showRank() 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
