--WndCoupleHegemonyInfoViewData.lua
--@brief	WndCoupleHegemonyInfoView的数据模块
--@date		2018/07/20
--@author	Tianxiang_Xu
--@note		世界组队boss战斗信息展示界面

WndCoupleHegemonyInfoView = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCoupleHegemonyInfoView:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nTeamHurt = 0
	self.m_nMyHurt = 0
	self.m_tSysConfig = nil 
	self.m_nCurRound = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCoupleHegemonyInfoView:_unInit()
	self.m_root = nil
	self.m_nTeamHurt = nil
	self.m_nMyHurt = nil
	self.m_tSysConfig = nil 
	self.m_nCurRound = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCoupleHegemonyInfoView:createElement()
	if WndCoupleHegemonyInfoView.m_root ~= nil then
		WindowManager:removeWindow(WndCoupleHegemonyInfoView.m_root, WndCoupleHegemonyInfoView, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCoupleHegemonyInfoView")
	assert(element, "WndCoupleHegemonyInfoView create element failed!")
	self:_init()
	return element
end

--@brief 	设置伤害数据
function WndCoupleHegemonyInfoView:setData(playerId, hurt)
	-- body
	if self.m_root == nil then return end 
	WZLog("WndCoupleHegemonyInfoView:setData", Serialize(playerId), Serialize(hurt))
	local teamHurt = 0 

	for i = 1, #playerId do
		if playerId[i] == CacheCenter:getPlayerInfo().id then
			self.m_nMyHurt = tonumber(hurt[i])
		end

		teamHurt = teamHurt + tonumber(hurt[i])
	end

	self.m_nTeamHurt = teamHurt

	self:_setHurtValue()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
