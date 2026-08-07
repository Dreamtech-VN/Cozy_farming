--WndCommunityCopyRankData.lua
--@brief	WndCommunityCopyRank的数据模块
--@date		2017/11/22
--@author	zsq
--@note		公会副本伤害排名

WndCommunityCopyRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityCopyRank:_init()
	self.m_root = nil	 	  			--场景根节点
	self.myRank = nil
	self.m_tDataList = nil
	self.m_nCopyId = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityCopyRank:_unInit()
	self.m_root = nil
	self.myRank = nil
	self.m_tDataList = nil
	self.m_nCopyId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityCopyRank:createElement()
	if WndCommunityCopyRank.m_root ~= nil then
		WindowManager:removeWindow(WndCommunityCopyRank.m_root, WndCommunityCopyRank, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCommunityCopyRank")
	assert(element, "WndCommunityCopyRank create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndCommunityCopyRank:setData( myRank, playerId, rank, name, faceId, headId, headColor, sex, level, vipLevel, hurt, percent)
	self.myRank = myRank
	self.m_tDataList = {}

	for i=1,#playerId do
		local tempList = {}
		tempList.playerId = playerId[i]
		tempList.rank = rank[i]
		tempList.name = name[i]
		tempList.faceId = faceId[i]
		tempList.headId = headId[i]
		tempList.headColor = headColor[i]
		tempList.sex = sex[i]
		tempList.level = level[i]
		tempList.vipLevel = vipLevel[i]
		tempList.hurt = hurt[i]
		tempList.percent = percent[i]
		table.insert(self.m_tDataList,tempList)
	end

	function sortData(a, b) 
		return a.rank < b.rank
	end

	table.sort(self.m_tDataList, sortData)
	
	WZLog("公会副本伤害排名",Serialize(self.m_tDataList))
	self:_update()
end




-------------------------------------私有方法模块End----------------------------------------
