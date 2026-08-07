--WndChallengeLevelData.lua
--@brief	WndChallengeLevel的数据模块
--@date		2014/01/15
--@author	林庆凯
--@note		挑战关卡窗口

WndChallengeLevel = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndChallengeLevel:_init()
	self.m_root = nil	 	  			 --场景根节点
	self.m_sImgFirstReward = nil   		 --第一个奖励图片路径
	self.m_sImgSecondReward = nil 		 --第二个奖励图片路径
	self.m_sImgThirdReward = nil  		 --第三个奖励图片路径
	self.m_sImgFouthReward = nil  		 --第四个奖励图片路径
	self.m_tRoomList  = nil       	     --从服务器存取副本数据的表
	self.m_nRoomId = nil          	     --房间ID
	self.m_sureBtnCallBackFun = nil      --确认按钮选定的回调函数
    self.m_tCallBackLuaObject = nil      --回调函数所在的表对象
	self.m_nSelModel = 1                 --选择模式，默认简单模式
	self.m_nLoadingCircleId = nil        --加载圆圈ID
	self.m_bTeach = true				 --新手教学
    self.m_rewardId = nil                --掉落物品ID
    self.m_nRemainTime = 0               --建房计时
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndChallengeLevel:_unInit()
	self.m_root = nil
	self.m_sImgFirstReward = nil   	--第一个奖励图片路径
	self.m_sImgSecondReward = nil  	--第二个奖励图片路径
	self.m_sImgThirdReward = nil   	--第三个奖励图片路径
	self.m_sImgFouthReward = nil   	--第四个奖励图片路径
	self.m_tRoomList = nil  
	self.m_sureBtnCallBackFun = nil --确认按钮选定的回调函数
    self.m_tCallBackLuaObject = nil --回调函数所在的表对象
	self.m_nSelModel = nil
	self.m_nLoadingCircleId = nil   --加载圆圈ID
	self.m_bTeach = nil				--新手教学
    self.m_rewardId = nil
    self.m_nRemainTime = 0               --建房计时
end





-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndChallengeLevel:createElement()
	local element = WZUISystem:getInstance():createElement("WndChallengeLevel")
	assert(element, "WndChallengeLevel create element failed!")
	self:_init()
	return element
end



--@brief	设置确认按钮的回调函数
--@param	fun:函数的变量,obj:表对象
function WndChallengeLevel:setSureBtnCallBackFun(fun,obj)
    self.m_sureBtnCallBackFun = fun
    self.m_tCallBackLuaObject = obj
end


--@brief 设置顶部房间标题的函数
--@param sImgRoomName 顶部房间标题
function WndChallengeLevel:setRoomName(sImgRoomName)
	self.m_sImgRoomName = sImgRoomName
	self:_setTopTitle()
end 


--@brief	设置奖励的函数

function WndChallengeLevel:setReWard(reWard)
	self:_setRewardPath(reWard)
end 


--@brief	设置房间ID的函数
--@param #1 nRoomId
function WndChallengeLevel:setRoomId(nRoomId,sRoomName,rewardId)
	self.m_nRoomId = nRoomId
    self.m_rewardId = rewardId
    WndChallengeLevel:getRoomInfo(sRoomName, nil, self.m_rewardId )
end 



--@brief	取得房间房间信息（从服务器返回）（BOSSMAPROOM_SendRoomInfo = 21）
--@param #1 mapShortName : 地图名称缩写
--@param #2 playLevel : 地图开启等级
--@param #4 rewardList : 奖励物品图片路径
--@param #5 needDianomd : 加速冷却需要消耗钻石数数量
function WndChallengeLevel:getRoomInfo(mapShortName, playLevel, rewardList) 
	WZLog("WndChallengeLevel:getRoomInfo(mapShortName, playLevel, rewardList)")	
	--if IfActiveWindow(self)  then 
	--if self.m_nEnterRoomInfoPro == 1 then 
	self.m_tRoomList = {}
    
	self.m_tRoomList.rewardList = {}
    self.m_tRoomList.rewardList = rewardList
    --[[
	for var = 0,rewardList:size()-1 do
		table.insert(self.m_tRoomList.rewardList,rewardList:get(var))
		
	end 
	WZLog(rewardList:get(0),rewardList:get(1),rewardList:get(2),rewardList:get(3))
    ]]
	self:setReWard(rewardList)
	--设置房间标题
	local sNum = string.match(mapShortName,"%d")
	self:setRoomName("common/text/boss_" .. sNum .. "_title.png")
	--取消圆圈的转动效果
	--MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingCircleId)
	--end 
end 







-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
