--WndRecruitData.lua
--@brief	WndRecruit的数据模块
--@date		2013/12/26
--@author	林庆凯
--@note		招收会员的窗口

WndRecruit = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRecruit:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurCelIndex = nil           --当前要加入表格中容器的索引值
	self.m_tPendProList = {}            --存储从服务器取来的等审批数据表
	self.m_SelPlayerIdList = {}         --用来存储当前被选中的要等审批数据的数据表
	self.m_nFlagSelAll = nil          	--用来设置全选的标志 ，0为不选中，1为选中
	self.m_nEndIndex = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRecruit:_unInit()
	self.m_root = nil
	self.m_nCurCelIndex = nil           --当前要加入表格中容器的索引值
	self.m_tPendProList = nil 
	self.m_SelPendProList = nil 
	self.m_nEndIndex = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRecruit:createElement()
	local element = WZUISystem:getInstance():createElement("WndRecruit")
	assert(element, "WndRecruit create element failed!")
	self:_init()
	return element
end


--@brief	取得公会待审批成员列表（客户端接受到服务端发送的好友列表后的数据处理回调方法取得公会待审批成员列表）
--@param #1	playerId : 玩家id
--@param #2	playerName : 玩家姓名
--@param #3 playerLevel : 玩家等级
--@param #4 isAcceptMember : 公会是否接受会员申请
--@param #5 sex : 性别
function WndRecruit:SendApprovingMemberList(id, name, level, vipLevel, headId, faceId, sex, fight, headColor)
	WZLog("WndRecruit:SendApprovingMemberList(playerId, playerName, playerLevel, isAcceptMember, sex)")
	self.m_tPendProList = {}
	for i=1,#id do
		local tempList = {}
		tempList.playerId = id[i]
		tempList.playerName = name[i]
		tempList.playerLevel = level[i]
		tempList.vipLevel = vipLevel[i]
		tempList.headId = headId[i]
		tempList.faceId = faceId[i]
		tempList.sex = sex[i]
		tempList.fight = fight[i] 
		tempList.headColor = headColor[i] 
		table.insert(self.m_tPendProList,tempList)
	end

	self:_update()
end 

-------------------------------------公有方法模块End----------------------------------------

