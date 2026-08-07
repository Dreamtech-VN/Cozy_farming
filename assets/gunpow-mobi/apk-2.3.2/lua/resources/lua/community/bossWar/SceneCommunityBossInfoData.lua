--SceneCommunityBossInfoData.lua
--@brief	SceneCommunityBossInfo的数据模块
--@date		2017/01/21
--@note		公会boss信息

SceneCommunityBossInfo = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneCommunityBossInfo:_init()
	self.m_root = nil	 	  			 --场景根节点
	self.m_nCopyId = nil
	self.m_tData = nil
	self.m_tMonster = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneCommunityBossInfo:_unInit()
	self.m_root = nil
	self.m_nCopyId = nil
	self.m_tData = nil
	self.m_tMonster = nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneCommunityBossInfo:createElement()
	local element = WZUISystem:getInstance():createElement("SceneCommunityBossInfo")
	assert(element, "SceneCommunityBossInfo create element failed!")
	self:_init()
	return element
end

--@brief	设置点击返回按钮返回的场景绑定的Lua表引用
--@param	tLuaObj，场景绑定的Lua表引用
--@note		点击返回按钮后切换到设置的场景，如果tLuaObj设置为nil，则禁用返回按钮
function SceneCommunityBossInfo:setBackSceneLuaObj(tLuaObj)
	self.m_tBackSceneLuaObj = tLuaObj
end


--@brief 刷新界面
function SceneCommunityBossInfo:updateInfoViewData(data)
	WZLog("SceneCommunityBossInfo:updateInfoViewData",data.sectionId)
	if not self.m_root  then
		return
	end
	if self.m_nCopyId ~= data.bossId then
		self.m_nCopyId = data.bossId
		self:_initView()
	end
	self:_updateView(data)
	self:closeLoading()
end

--@brief  添加顶部导航栏
function SceneCommunityBossInfo:addTop()
	WZLog("SceneCommunityBossInfo:addTop")
	local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    self.m_tTopHangle = tcell
    self.m_oTopObject = cell
    tcell:setTopData("ui/community/common_icon_ghfb.png",SceneCommunityBossInfo,SceneCommunityBossInfo.onCloseClick,true,true,true,"SceneCommunityBossInfo")
end


--@brief   创建加载框
function SceneCommunityBossInfo:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function SceneCommunityBossInfo:closeLoading()
	if self.m_nLoadingId then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
		self.m_nLoadingId = nil
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------
