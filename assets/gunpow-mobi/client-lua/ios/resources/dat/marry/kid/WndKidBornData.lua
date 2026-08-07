--WndKidBornData.lua
--@brief	WndKidBorn的数据模块
--@date		2018/05/09
--@author	Tianxiang_Xu
--@note		生育小孩界面

WndKidBorn = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKidBorn:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nBornLevel = nil 			--生育恩爱等级
	self.m_nBornPercent = nil 			--怀孕概率
	self.m_nBabyAutoSex = 0 				--小孩的默认性别
	self.m_nSexSelIndex = 0 			--当前选中的性别
	self.m_bCanClickBorn = true 		--点击控制
	self.m_nKidId = nil 				--小孩Id
	self.m_nBornState = nil 			--生育或领养的状态0：还没开始;1：领养或生育成功（还未确定性别)
	self.m_tBornConfig = nil 			--系统配置
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKidBorn:_unInit()
	self.m_root = nil
	self.m_nBornLevel = nil 			--生育恩爱等级
	self.m_nBornPercent = nil 			--怀孕概率
	self.m_nBabyAutoSex = nil 				--小孩的默认性别
	self.m_nSexSelIndex = nil 
	self.m_bCanClickBorn = nil 		--点击控制
	self.m_nBornState = nil 			--生育或领养的状态
	self.m_nKidId = nil 				--小孩Id
	self.m_tBornConfig = nil 			--系统配置
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKidBorn:createElement()
	local element = WZUISystem:getInstance():createElement("WndKidBorn")
	assert(element, "WndKidBorn create element failed!")
	self:_init()
	return element
end

--@brief 	生育协议回调
function WndKidBorn:bornKidReturn(result)
	-- body

	if result == 1 then  --成功
	    MsgBoxManager:showTipBox(LocalStrings.PLAYER_RENAME)
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.NAME_HAVED_EXIST)
    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO3)
    elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY)
    elseif result == 5 then
        MsgBoxManager:showTipBox(LocalStrings.DRESSSUIT_TEXT1)
    elseif result == 6 then 
        MsgBoxManager:showTipBox(LocalStrings.NAME_TOO_SHOOT)
    elseif result == 7 then 
        MsgBoxManager:showTipBox(LocalStrings.NAME_CANT_BE_NUMBER)
    end

    WindowManager:removeWindow(self.m_root, self, true)
    self:setTouchLimit(true)
end

--@brief 	设置触摸限制
function WndKidBorn:setTouchLimit(bBool)
	-- body
	if self.m_root == nil then return end 
	
	self.m_bCanClickBorn = bBool
end

--@brief 	获取怀孕状态信息成功
function WndKidBorn:getBornInfoOK(actionType, status, pregantRate, childId, sex)
	-- body
	SceneKidHome:_stopLoading()
	if SceneKidHome.m_root then
		SceneKidHome.m_nBorningKidId = childId 
	end
	if self.m_root == nil then return end 

	if actionType == 3 then
		self.m_nKidId = childId
		WZLog("WndKidBorn:getBornInfoOK", childId)
		if childId > 0 then
			self.m_nBornState = 1
		else
			self.m_nBornState = 0
		end
		self.m_nBornPercent = pregantRate
		self.m_nBabyAutoSex = sex
		self.m_nSexSelIndex = self.m_nBabyAutoSex

		self:_update() 
	elseif actionType == 2 then --领养
		self.m_nKidId = childId
		SceneKidHome.m_nBorningKidId = childId
		self.m_nBornState = 1
		self.m_nBabyAutoSex = sex
		self.m_nSexSelIndex = self.m_nBabyAutoSex
		MsgBoxManager:showTipBox(LocalStrings.KID_TEXT33)
		self:_update()
	elseif actionType == 1 then --生育
		if status == 1 then --成功怀孕
			self.m_nKidId = childId
			SceneKidHome.m_nBorningKidId = childId
			self.m_nBornState = 1
			self.m_nBornPercent = pregantRate
			self.m_nBabyAutoSex = sex
			self.m_nSexSelIndex = self.m_nBabyAutoSex
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT34)

			self:_update()
		else
			self.m_nBornPercent = pregantRate
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT24)
			self:_setBornPercent()
		end
	end
end

--@brief 	孩子名字性别确认成功
function WndKidBorn:setKidNameAndSexOK(leftTime, kidId, result)
	-- body
	WZLog("WndKidBorn:setKidNameAndSexOK", leftTime, result)
	SceneKidHome:_stopLoading()
	self:setTouchLimit(true)
	if result == 1 then
		MsgBoxManager:showTipBox(LocalStrings.KID_TEXT110)
		--创建怀孕或领养倒计时
		SceneKidHome:showBornTime(leftTime, kidId)
		WndKidManager:closeWindow()
	else
		self:displayResult(result)
	end
end

--@brief	领养证或怀孕丹数量变化后，刷新数量
function WndKidBorn:updatePlayerItemData()
	--body
	if WndKidBorn.m_root == nil then return end 

	self:setGoodsNum()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
