--WndMarryHollData.lua
--@brief	WndMarryHoll的数据模块
--@date		2014/LQK/23
--@author	lqk
--@note		结婚礼堂模块

WndMarryHoll = {
	--请不要在这里定义变量
}



--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMarryHoll:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nMarryType = 0               --求婚类型
    self.m_tMarryStatus = nil           --保存婚姻状况的表
	self.m_tData = nil                  --存储数据的表
	self.m_nMyWeddingTime = nil         --我的婚礼开始时间
	self.m_nLoadingId = nil             --加载圆圈ID
	self.m_nDivorceTime = nil 			--离婚冷却时间戳
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMarryHoll:_unInit()
	self.m_root = nil
    self.m_nMarryType = 0
    self.m_tMarryStatus = nil
	self.m_nCurWeddingStartTime = nil   --当前婚礼开始时间
	self.m_nMyWeddingTime = nil         --我的婚礼开始时间
	self.m_nLoadingId = nil              --加载圆圈ID
	self.m_nDivorceTime = nil 			--离婚冷却时间戳
end


--@brief   创建加载框
function WndMarryHoll:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndMarryHoll:closeLoading()
	local nId = self.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId(nId)
end



-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMarryHoll:createElement()
	local element = WZUISystem:getInstance():createElement("WndMarryHoll")
	assert(element, "WndMarryHoll create element failed!")
	self:_init()
	return element
end



--@brief	设置我的结婚时间
function WndMarryHoll:setMyWeddingTime(nMyWeddingTime)
	self.m_nMyWeddingTime = nMyWeddingTime
end 




--@brief	返回可举办婚礼时间（WEDDING_SendCanWedTime = 21)(服务器返回)
function WndMarryHoll:getCanWedTime(timeId, startTime, endTime)
	WZLog("WndMarryHoll:getCanWedTime(timeId, startTime, endTime)")
	self.m_tData = {}
	self.m_tData.timeId = {}
	self.m_tData.startTime = {}
	self.m_tData.endTime = {}
	WZLog("timeId:size()  = ",timeId:size() )
	for var = 0,timeId:size() - 1 do 
		WZLog("timeId:get(i) = ",timeId:get(var))
		WZLog("startTime:get(i) = ",startTime:get(var))
		WZLog("endTime:get(i) = ",endTime:get(var))
		table.insert(self.m_tData.timeId  ,timeId:get(var))
		table.insert(self.m_tData.startTime,startTime:get(var))
		table.insert(self.m_tData.endTime,endTime:get(var))
	end 
	local wndMarryBetrothed = WndMarryBetrothed:createElement()
    WindowManager:addWindow(wndMarryBetrothed, WndMarryBetrothed,nil,nil,nil,false)
	WndMarryBetrothed:setCanWedTime3(self.m_tData.timeId[1],self.m_tData.timeId[2],self.m_tData.timeId[3],
									self.m_tData.startTime[1],self.m_tData.startTime[2],self.m_tData.startTime[3],
									self.m_tData.endTime[1],self.m_tData.endTime[2],self.m_tData.endTime[3])
end 



-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
