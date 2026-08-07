--WndKidSchoolOperateData.lua
--@brief	WndKidSchoolOperate的数据模块
--@date		2021/05/10
--@author	yrd
--@note		小家学校操作界面

WndKidSchoolOperate = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKidSchoolOperate:_init()
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
function WndKidSchoolOperate:_unInit()
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
function WndKidSchoolOperate:createElement()
	if WndKidSchoolOperate.m_root ~= nil then
		WindowManager:removeWindow(WndKidSchoolOperate.m_root, WndKidSchoolOperate, true)
	end
	local element = WZUISystem:getInstance():createElement("WndKidSchoolOperate")
	assert(element, "WndKidSchoolOperate create element failed!")
	self:_init()
	return element
end


function WndKidSchoolOperate:setData(rank, playerId, serverId, childId, childName, level, headId, faceId, sex)
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

	WZLog("WndKidSchoolOperate:setData", Serialize(self.m_tDataList))

	self:showRank() 
end

--@brief	接收拜访成功
--@note		1成功 | 2不是好友关系 | 3你已经拜访了其他玩家 | 4过多拜访者了 | 5不能拜访自己的家喔
function WndKidSchoolOperate:getVisitFriendOk(result)
	if result == 1 then
        MsgBoxManager:showTipBox(LocalStrings.KID_HOME_TEXT4)
	elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.KID_HOME_TEXT3)
	elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.KID_HOME_TEXT5)
	elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.KID_HOME_TEXT6)
	elseif result == 5 then
        MsgBoxManager:showTipBox(LocalStrings.KID_HOME_TEXT10)
	end

	ProtocolProcessorKid:send_WEDDING_GetHouseInfo(SceneKidHome.m_nPlayerId)
end

--@brief    进入区域结果
function WndKidSchoolOperate:joinAreaOk(result)
    if result == 1 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT224)
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT166)
    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT156)
    elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT167)
    elseif result == 5 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT207)
    elseif result == 6 then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT208)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
