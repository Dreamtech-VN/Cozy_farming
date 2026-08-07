--SceneCommunitySkillData.lua
--@brief	SceneCommunitySkill的数据模块
--@date		2013/12/26
--@author	zsq
--@note		公会技能的场景

SceneCommunitySkill = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneCommunitySkill:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tSkillLevels = nil
	self.m_nSkillTag = nil				--选中的技能tag
	self.m_nUpgrade = nil				--升级技能
	self.m_needDonate = nil 			--升级技能需要的个人贡献
	self.m_nNeedGold = nil
	self.m_nLoadingCircleId = nil       	  --加载圆圈的ID
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneCommunitySkill:_unInit()
	self.m_root = nil
	self.m_tSkillLevels = nil
	self.m_nSkillTag = nil				--选中的技能tag
	self.m_nUpgrade = nil				--升级技能
	self.m_needDonate = nil
	self.m_nNeedGold = nil
	self.m_nLoadingCircleId = nil       	  --加载圆圈的ID
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneCommunitySkill:createElement()
	local element = WZUISystem:getInstance():createElement("SceneCommunitySkill")
	assert(element, "SceneCommunitySkill create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	保存公会技能等级列表
function SceneCommunitySkill:setSkillLevel(id, level)
	--如果是升级技能返回，弹出tips,扣除个人贡献
	if self.m_nUpgrade == true then
		self.m_nUpgrade = false

		local guildInfo = CacheCenter:getGuildInfo()
		guildInfo.totalDonate = guildInfo.totalDonate - self.m_needDonate

		--MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO34)
	end

	self.m_tSkillLevels = {}
	local tempList = {}
	for i=1,#id do
		local tempTable = {}
		tempTable.id = id[i]
		tempTable.level = level[i]
		table.insert(tempList,tempTable)
	end

	WZLog("公会技能数据",Serialize(tempList))

	local sortTable = {3,4,1,5,7,19,20}

	for i=1,7 do
		for k,v in pairs(tempList) do
			if v.id == sortTable[i] then
				table.insert(self.m_tSkillLevels,v)
			end
		end
	end

	self:_update()
end

-------------------------------------私有方法模块End----------------------------------------
