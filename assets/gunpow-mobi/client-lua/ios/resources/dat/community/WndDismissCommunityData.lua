--WndDismissCommunityData.lua
--@brief	WndDismissCommunity的数据模块
--@date		2013/12/27
--@author	林庆凯
--@note		询问解散公会,会长让位,会员升级的窗口

WndDismissCommunity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDismissCommunity:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nFlagWindow = 0            --窗口标记 
	self.m_nCelPlayerId = 0           --当前点击的单元格ID
	self.m_sCelPlayerName   = nil 	  --当前点击的单元格名字
	self.m_bLimit = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDismissCommunity:_unInit()
	self.m_root = nil
	self.m_nFlagWindow = nil 
	self.m_nCelPlayerId = 0      
	self.m_sCelPlayerName   = nil 
	self.m_bLimit = nil
end


--设置当前点击的单元格ID的函数
--@param  nCelPlayerId 当前点击的单元格ID
function  WndDismissCommunity:setClickCelPlayerId(nCelPlayerId)
	self.m_nCelPlayerId  = nCelPlayerId
end 


--设置当前点击的单元格名字的函数
--@param  sCelPlayerName 当前点击的单元格名字
function  WndDismissCommunity:setClickCelPlayerName(sCelPlayerName)
	self.m_sCelPlayerName  = sCelPlayerName 
end 



--返回公会ID的函数
--return  当前点击的单元格ID
function  WndDismissCommunity:getClickCelPlayerId()
	return 	self.m_nCelPlayerId
end 



--设置当前窗口标记函数
--@param  当前窗口标记，1为开除公会会员窗口 ，2为退出公会,3为解散公会,4为升级公会
function  WndDismissCommunity:setFlagWindow(nFlagWindow)
	self.m_nFlagWindow  = nFlagWindow
end 
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDismissCommunity:createElement()
	local element = WZUISystem:getInstance():createElement("WndDismissCommunity")
	assert(element, "WndDismissCommunity create element failed!")
	self:_init()
	return element
end

--@brief	退出公会成功从服务器返回的函数 
function WndDismissCommunity:exitCommunityOk()
	MsgBoxManager:showTipBox(LocalStrings.ALREADY_EXIT_COMMUNITY)
	--跳回公会主场景
	local sceneCommunity = SceneCommunity:createElement()
	if sceneCommunity ~=nil then 
		replaceScene(sceneCommunity)
	end 
end 

--@brief	解散公会成功从服务器返回的函数 
function WndDismissCommunity:dismissCommunityOk()
	MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_ALREADY_DISSMISS)
	--跳回公会主场景
	local sceneCommunity = SceneCommunity:createElement()
	if sceneCommunity ~=nil then 
		replaceScene(sceneCommunity)
	end 
end 


--@brief	公会让位成功从服务器返回的函数 
function WndDismissCommunity:changePresidentOk()
	MsgBoxManager:showTipBox(self.m_sCelPlayerName .. LocalStrings.SUCESS_AS_PRESIDENT) 
	self:onCloseWindowBtn()
	--获取公会大厅
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()
	SceneCommunityMain:createLoading()
end 


--@brief	公会升级成功（COMMUNITY_UpgradeOk = 46）
function WndDismissCommunity:UpgradeCommunityOk()
	WZLog("WndDismissCommunity:UpgradeCommunityOk()")
	MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_UPGRADE_SUCESS)
	self:onCloseWindowBtn()
end 

--@brief	公会升级（COMMUNITY_Upgrade = 45）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function WndDismissCommunity:upgrade_ErrorProcess(nFlag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
	self:onCloseWindowBtn()
end 



--@brief	会长让位协议 （COMMUNITY_ChangePresidentOk = 24）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function WndDismissCommunity:changePresidentOkErrorProcess(nFlag, sMessage)
	WZLog(" WndDismissCommunity:changePresidentOkErrorProcess(nFlag, sMessage)")

end 

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
