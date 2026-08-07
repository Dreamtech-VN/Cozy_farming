--WndGuestData.lua
--@brief	WndFriendImpl的数据模块
--@date		2014/5/14
--@author	林庆凯
--@note		结婚宾格窗口 



WndGuest = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndGuest:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nClickFlag = nil       --点击cell时跳转窗口是邮件还是聊天事件的标记，1为聊天
	self.m_sCurCellName = nil 			--用来纪录当前点击单元格的名字
	self.m_nCurCellPlayerId  = nil  	--用来纪录当前点击单元格的ID
    self.m_sexFriendCallBackFun = nil   --确认选定异性好友的回调函数
    self.m_tCallBackLuaObject = nil     --回调函数所在的表对象
	self.m_nCurrentCellIndex = nil      --当前单元格的索引
	self.m_tCurList = {}				--当前存储的数据表
	self.m_clickCellCallBackFun = nil   --点击单元格时的回调函数
	self.m_nLoadingCircleId = nil       --加载圆圈ID
	self.m_tGuestList = {}              --来宾列表数据
	self.m_nTag = nil                   --标记 
	self.m_tBackFun = nil
	self.m_bIsHomeowner = true     
	self.m_sHallPass = nil       
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGuest:_unInit()
	self.m_root = nil
	self.m_nClickFlag = nil 
	self.nFlagWhickCheckBoxSel = nil  
	self.m_sCurCellName = nil 			--用来纪录当前点击单元格的名字
	self.m_nCurCellPlayerId  = nil  	--用来纪录当前点击单元格的ID
    self.m_tCallBackLuaObject = nil
	self.m_nCurrentCellIndex = nil      --当前单元格的索引
	self.m_tCurList = nil 
	self.m_clickCellCallBackFun = nil   --点击单元格时的回调函数
	self.m_nLoadingCircleId = nil       --加载圆圈ID
	self.m_tGuestList = nil             --来宾列表数据
	self.m_tBackFun = nil
	self.m_bIsHomeowner = nil   
	self.m_sHallPass = nil    
end

--@brief	设置点击cell时跳转窗口是邮件还是聊天事件的标记，1为聊天
--@param  	nClickFlag跳转事件的标记，1为聊天
function WndGuest:setClickFlag(nClickFlag)
	self.m_nClickFlag = nClickFlag
	ProtocolProcessorWndFriend:send_FRIEND_GetFriendListNew(1, -1 )
	--加载圆圈
	self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox()
end 

--@brief	取得点击cell时跳转窗口是邮件还是聊天事件的标记，1为聊天，2为房间大厅,3为结婚的异性好友
function WndGuest:getClickFlag()
	return self.m_nClickFlag
end

--@brief	客户端接受到服务端发送的来宾列表（WEDDING_SendJoinList = 27）
--@param #1 playerId : 来宾Id
--@param #2 playerName : 来宾名称
--@param #3 level : 来宾等级
--@param #4 sex : 来宾性别，false是男，true是女
function WndGuest:GetJoinList(playerId, playerName, level, sex,guestHeadId,guestFaceId,hallPass,vipLevel,headColor,bodyColor)
	WZLog("WndGuest:GetJoinList = ",hallPass)
	--取消圆圈的转动效果
	if hallPass ~= nil then
		self.m_sHallPass = hallPass
	end
	self.m_tGuestList = {}
	for i = 1, #playerId do
		local guestInfo = {}
		guestInfo.playerId = playerId[i]
		guestInfo.playerName = playerName[i]
		guestInfo.level = level[i]
		guestInfo.sex = sex[i]
		guestInfo.haedId = guestHeadId[i]
		guestInfo.faceId = guestFaceId[i]
		guestInfo.headColor = headColor[i]
		guestInfo.bodyColor = bodyColor[i]
		guestInfo.vipLevel = vipLevel[i]
		table.insert(self.m_tGuestList,guestInfo)
	end
	
	self:_udpateJoinList()
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGuest:createElement()
	WZLog("function WndFriendImplcreateElement()")
	local element = WZUISystem:getInstance():createElement("WndGuest")
	assert(element, "WndFriend create element failed!")
	self:_init()
	return element
end

--@brief  是否是房主点击来宾列表
function WndGuest:setIsHomeowner(tag)
	self.m_bIsHomeowner = tag
	if self.m_bIsHomeowner == false then
		if self.m_root~=nil then
			WZUIContainer:luaTo(self.m_root:getChildElement("conBottom_WndGuest")):setVisible(false)
		end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	判断是否显示上一页函数
--@note		当前页大于1的时候显示上一页，否则不显示
function WndGuest:_getUpPageNew( )

	local nCurPage = self.m_nPageNumber
	if nCurPage > 1 then
		return true
	else
		return false
	end
end

--@brief	判断是否显示下一页函数
--@note		当前页小于总页数的时候显示下一页，否则不显示
function WndGuest:_getDownPageNew()

	local totalPageNum = self.m_nTotalNumber
	local nCurPage = self.m_nPageNumber
	if nCurPage < totalPageNum then
		return true
	else
		return false
	end
end
-------------------------------------私有方法模块End----------------------------------------
