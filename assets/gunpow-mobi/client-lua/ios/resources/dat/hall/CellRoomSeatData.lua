--CellRoomSeatData.lua
--@brief	CellRoomSeat的数据模块
--@date		2013/12/27
--@author	李光森
--@modify   qixiang_xie
--@note		房间玩家座位

CellRoomSeat = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellRoomSeat:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil			--Cell的数据
	self.m_nBgType = nil		--cell背景的类型
	self.m_sPlayerName = nil	--玩家名字
	self.m_pCallBackFunc = nil	--回调函数
	self.m_tCallBackTable = nil	--回调表
	self.m_pChangeSeatBackFun = nil --点击换位回调函数
	self.m_tChangeSeatTable = nil   --回调表
	self.m_pInvBackFunc = nil       --邀请回调
	self.m_tInvCallBackTable = nil  --回调表
	self.m_pCloseSeatBackFunc = nil --关闭座位回调函数
	self.m_tCloseCallBackTable = nil
	self.m_pOpenSeatBackFunc = nil --打开座位回调函数
	self.m_tOpenCallBackTable = nil
	self.m_player = nil 
	self.m_nIndex = nil

	self.m_tFriendValue = nil --密友信息
    

	self.m_nSpouseValue = nil    --夫妻关系恩爱值
	self.m_nSpuseLevel = nil     --恩爱等级
	self.m_sWifeName = nil       --妻子名字
	self.m_sHusband = nil        --丈夫名字

	self.m_tMasterValue = nil --师徒信息

    self.m_nRoomId = nil
    self.m_parentRoot = nil
    self.m_tPlayerEquipment = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRoomSeat:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_nBgType = nil
	self.m_sPlayerName = nil
	self.m_pCallBackFunc = nil
	self.m_tCallBackTable = nil
	self.m_player = nil
	self.m_nIndex = nil
	self.m_tFriendValue = nil --密友信息
    

	self.m_nSpouseValue = nil    --夫妻关系恩爱值
	self.m_nSpuseLevel = nil     --恩爱等级
	self.m_sWifeName = nil       --妻子名字
	self.m_sHusband = nil        --丈夫名字

	self.m_nMasterValue = nil    --师徒关系信息
	self.m_nRoomId = nil
	self.m_parentRoot = nil
	self.m_tPlayerEquipment = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellRoomSeat:createElement(tag)
	local tNewObj = self:_new()
	assert(tNewObj, "CellRoomSeat table create failed!")
	tNewObj:_init()
	local element = nil
	if tag == 2 then
		element = WZUISystem:getInstance():createElement("CellRoomSeatSe")
	else
		element = WZUISystem:getInstance():createElement("CellRoomSeat")
	end
	assert(element, "CellRoomSeat element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end


--@brief  座位上的玩家信息
--@param wnersId:房主id
--@param seatUsed:该座位是否使用
--@param playerId:房间内玩家id
--@param playerName:房间内玩家昵称
--@param playerLevel:房间内玩家等级
--@param playerReady:玩家是否已准备
--@param playerSex:玩家性别
--@param vipLevel:玩家vip等级0表示非vip
--@param playerTitle:玩家称号
--@param fighting:玩家战斗力
--@param playerNumMode:对战人数模式
--@param index:座位ID(1,2,3,4,5,6)
--@param startMode:撮合方式       
--@param serverid:玩家所在服ID                                                                             
function CellRoomSeat:setData(wnersId, seatUsed, playerId, playerName, playerLevel, playerReady, playerSex, vipLevel, playerTitle, fighting, playerNumMode, index, startMode, battleMode, tournamentLevel, allSeatStatus, serverid, roomChannel, playNum, winNum, tournamentExp, winTimes, joinTimes, continuousWinTimes, matchscore, qualifyingLevel, assist, assistTimesState)
	self.m_tData = {wnersId=wnersId, seatUsed=seatUsed, playerId=playerId, playerName=playerName, playerLevel=playerLevel, playerReady=playerReady, playerSex=playerSex, vipLevel=vipLevel, playerTitle=playerTitle,fighting=fighting,playerNumMode=playerNumMode,index=index,startMode=startMode,battleMode=battleMode,tournamentLevel=tournamentLevel,allSeatStatus=allSeatStatus,serverid=serverid,roomChannel=roomChannel,playNum=playNum,winNum=winNum,tournamentExp=tournamentExp,winTimes=winTimes,joinTimes=joinTimes,continuousWinTimes=continuousWinTimes,matchscore=matchscore,qualifyingLevel=qualifyingLevel,assist=assist, assistTimesState = assistTimesState}
	--WZLog("CellRoomSeat:setData =" ,Serialize(self.m_tData))
	self.m_tFriendValue = nil 
    
	self.m_nSpouseValue = nil    
	self.m_nSpuseLevel = nil    
	self.m_sWifeName = nil       
	self.m_sHusband = nil        

	self.m_nMasterValue = nil   
	self.m_nIndex = index
	--self:_update()
end

--@brief	设置cell背景类型
--@param	bgType:背景类型(-1:锁定,1:红色,2:蓝色)
function CellRoomSeat:setBgType(bgType)
	self.m_nBgType = bgType
end

--@brief	设置玩家名字
--@param	sName:玩家名字
function CellRoomSeat:setPlayerName(sName)
	self.m_sPlayerName = sName
	self:_update()
end

--六个座位的信息
function CellRoomSeat:setSeatInfo(seatInfo)
	self.m_tSeatUseInfo = seatInfo
end

--@brief	设置点击回调函数
--@param	pFunc:回调函数
--@param	tTable:回调表
function CellRoomSeat:setClickCallBack(pFunc,tTable)
	self.m_pCallBackFunc = pFunc
	self.m_tCallBackTable = tTable
end

--@brief  设置点击换位回调函数
function CellRoomSeat:setChangeSeatCallBack(pFunc,tTable)
	self.m_pChangeSeatBackFun = pFunc 
	self.m_tChangeSeatTable = tTable   
end

--@brief  设置点击关闭座位回调函数
function CellRoomSeat:setCloseSeatCallBack(pFunc,tTable)
	self.m_pCloseSeatBackFunc = pFunc 
	self.m_tCloseCallBackTable = tTable
end

--@brief 设置邀请回调函数
function CellRoomSeat:setInvCallBack(pFunc,tTable)
	self.m_pInvBackFunc = pFunc       
	self.m_tInvCallBackTable = tTable  
end

--@brief 设置打开座位回调函数
function CellRoomSeat:setOpenSeatCallBack(pFunc,tTable)
	self.m_pOpenSeatBackFunc = pFunc
	self.m_tOpenCallBackTable = tTable
end


--设置密友度
function CellRoomSeat:setFriendInfo(friendValue)
	WZLog("CellRoomSeat:setFriendInfo =",friendValue)
	self.m_tFriendValue = friendValue
end

--设置师徒关系值
function CellRoomSeat:setMasterInfo(masterInfo)
	WZLog("CellRoomSeat:setMasterInfo")
	self.m_nMasterValue = masterInfo
end

--设置夫妻关系值
function CellRoomSeat:setSpouseInfo(spouseValue,spuseLevel,wifeName,husbandName)
	WZLog("CellRoomSeat:setSpouseInfo")
	self.m_nSpouseValue = spouseValue    
	self.m_nSpuseLevel = spuseLevel     
	self.m_sWifeName = wifeName     
	self.m_sHusband = husbandName
end

function CellRoomSeat:setRoomId(roomId)
	-- body
	WZLog("CellRoomSeat:setRoomId")
	self.m_nRoomId = roomId
end


function CellRoomSeat:setParentRoot(parentRoot)
	-- body
	WZLog("CellRoomSeat:setParentRoot")
	self.m_parentRoot = parentRoot
end

function CellRoomSeat:setPlayerEquipment(equipment)
	-- body
	WZLog("CellRoomSeat:setPlayerEquipment")
	self.m_tPlayerEquipment = equipment
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellRoomSeat:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
