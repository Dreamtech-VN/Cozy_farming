--WndSettingData.lua
--@brief	WndSetting的数据模块
--@date		2015/04/22
--@author	liangguang_long/binshao
--@note		设置模块

G_Friend_BeInvite = 0
G_Talk_AutoPlay = 1
G_Other_Player = 0
G_Stranger_BeInvite = 0
G_Corps_INVITE = 0
G_Task_Quick = 0
WndSetting = {
	--请不要在这里定义变量
}
--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSetting:_init()
	self.m_root = nil	 	    -- 场景根节点
	self.n_open = 0  --开启的功能设置，如果没有，就隐藏功能文字

	self.m_nMusicState,self.m_nSoundState  = SoundManager:getState()	         -- 声音状态
	WZLog("WndSetting:_init",self.m_nMusicState,self.m_nSoundState)
	--TODO:
	self.m_nShieldState = FigureSceneManager:isOtherVisible()    -- 屏蔽周围玩家的状态
	self.m_nInviteState = G_Friend_BeInvite		                 -- 拒绝好友请求状态
	self.m_nAllInviteState = G_Stranger_BeInvite                 -- 陌生人邀请状态
	self.m_nCorpsState = G_Corps_INVITE                          -- 战队邀请
	self.m_nTalkState =  G_Talk_AutoPlay                         -- 自动播放语音
	self.m_addVolume = 0                                         -- 增加的音量
	self.m_initMusicVolume = 0                                   -- 音乐的初始音量
	self.m_initSoundVolume = 0                                   -- 音乐的初始音量
	self.m_VolumeTag = 1
	self.m_nTaskQuick = 0 										 -- 任务快捷栏状态

	
	--角色的音效
	self.m_soundType = GetRoleSound()
	--自动播放预言
	self.m_playTalk = GetPlayTalk()
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSetting:_unInit()
	self.m_root = nil
	self.n_open = nil
	self.m_nSoundState = nil
	self.m_nShieldState = nil
	self.m_nInviteState = nil
	self.m_nAllInviteState = nil
	self.m_addVolume = nil                                       
	self.m_initMusicVolume = nil                                  
	self.m_initSoundVolume = nil
	self.m_VolumeTag = nil
	self.m_soundType = nil
	self.m_playTalk = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSetting:createElement()
	local element = WZUISystem:getInstance():createElement("WndSetting")
	assert(element, "WndSetting create element failed!")
	self:_init()
	WZLog("---------------create----WndSetting------------------------------------")
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- function WndSetting:getAcountData()
-- 	local tData = SettingManager:getAcountData()
-- 	if tData then
-- 		for i , data in pairs(tData) do 
-- 			for i , v in pairs(data) do 
-- 				if tostring(i) == "bAcount" then
-- 					return v
-- 				end
-- 			end
-- 		end
-- 	end
-- end

-- function WndSetting:_getSDKData()
-- 	local index = 0
-- 	local tData = SettingManager:openFile()
-- 	WZLog("WndSetting:_getSDKData:::::::::",tData)
-- 	self.m_tData = {}
-- 	self.m_tData.tCell = {}
-- 	self.m_tData.backFun = {}
-- 	self.m_tData.norIcon = {}
-- 	self.m_tData.selIcon = {}
-- 	self.m_tData.label = {}
-- 	if tData then
-- 		for i , data in pairs(tData) do 
-- 			for i , v in pairs(data) do 
-- 				if tostring(i) == "tCell" then
-- 					local tCell = LoadConfigByString("return " .. v)
-- 					table.insert(self.m_tData.tCell , tCell)
-- 				elseif tostring(i) == "backFun" then
-- 					index = index + 1
-- 					self:_getAccount(v , index)
-- 					local backFun = SettingManager[v]
-- 					table.insert(self.m_tData.backFun , backFun)
-- 				elseif tostring(i) == "norIcon" then
-- 					table.insert(self.m_tData.norIcon , v)
-- 				elseif tostring(i) == "selIcon" then
-- 					table.insert(self.m_tData.selIcon , v)
-- 				elseif tostring(i) == "label" then
-- 					table.insert(self.m_tData.label , v)
-- 				end
-- 			end
-- 		end
-- 	end
	
	
-- 	self:_setAccountPos()
-- 	self:_showBtn()--显示按钮
-- end

-- --@brief	获取账号按钮的位置
-- --@param	sName:账号按钮的回调名称
-- --@param	index:账号按钮的位置
-- function WndSetting:_getAccount(sName,index)
-- 	if sName == "onRegisterClick" then
-- 		self.m_nIndex = index
-- 	end
-- end

-- --@brief	获取账号按钮的名称
-- --@return	sName:返回账号按钮的名称
-- function WndSetting:_getAccountName()
-- 	if self.m_tData and self.m_tData.label and self.m_nIndex then
-- 		local sName = "conBtnA%d_WndSetting"
-- 		local maxCount = #self.m_tData.label
-- 		if maxCount > 6 then
-- 			sName = "conBtnB%d_WndSetting"
-- 		end
-- 		local index = self:_getAccountNameIndex(maxCount , self.m_nIndex)
-- 		sName = string.format(sName , index)
-- 		return sName
-- 	end
-- end

-- --@brief	数据列表
-- --@param	tData[1]:回调节点
-- --@param	tData[2]:回调函数名
-- --@param	tData[3]:正常状体图片
-- --@param	tData[4]:选中状态图片
-- --@param	tData[5]:按钮文字图片
-- function WndSetting:_getCurData(index)
-- 	if self.m_tData then
-- 		self.m_tCurData = {}
-- 		table.insert(self.m_tCurData , self.m_tData.tCell[index])
-- 		table.insert(self.m_tCurData , self.m_tData.backFun[index])
-- 		table.insert(self.m_tCurData , self.m_tData.norIcon[index])
-- 		table.insert(self.m_tCurData , self.m_tData.selIcon[index])
-- 		table.insert(self.m_tCurData , self.m_tData.label[index])
-- 		return self.m_tCurData
-- 	end
-- end

-- --@brief	通过按钮数量获取按钮名称
-- --@param	maxCount：按钮数量
-- function WndSetting:_getBtnByCount(maxCount)
-- 	local sName = "conBtnA%d_WndSetting"
-- 	if maxCount > 0 and maxCount <= 6 then
-- 		sName = "conBtnA%d_WndSetting"
-- 	elseif maxCount > 6 and maxCount < 10 then
-- 		sName = "conBtnB%d_WndSetting"
-- 	end
-- 	return sName
-- end

-- --@brief	根据按钮数量排版按钮
-- function WndSetting:_getBtnNameByindex(maxCount , sNameType , index)
-- 	if maxCount == 4 then
-- 		if index > 1 and index < 4 then
-- 			index = index + 1
-- 		elseif index == 4 then
-- 			index = index + 2
-- 		end
-- 	elseif maxCount == 7 and index == 7 then
-- 		index = index + 1
-- 	end
-- 	return string.format(sNameType , index)
-- end

-- --@brief	获取账号按钮的索引
-- function WndSetting:_getAccountNameIndex(maxCount , index)
-- 	if maxCount == 4 then
-- 		if index > 1 and index < 4 then
-- 			index = index + 1
-- 		elseif index == 4 then
-- 			index = index + 2
-- 		end
-- 	elseif maxCount == 7 and index == 7 then
-- 		index = index + 1
-- 	end
-- 	return index
-- end


-------------------------------------私有方法模块End----------------------------------------

