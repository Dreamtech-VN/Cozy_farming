--SceneCommunityCopyData.lua
--@brief	SceneCommunityCopy的数据模块
--@date		2017/02/14
--@author	qixiang
--@note		公会副本主界面

SceneCommunityCopy = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneCommunityCopy:_init()
	self.m_root = nil	 	  			 --场景根节点
	self.m_tCommunityCopyInfo = nil
	self.m_tBossInfo = nil
	self.m_elementCurSelcetCopy = nil
	self.m_nCurSelectIndex = nil
	self.m_nGetRewardSelectIndex = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneCommunityCopy:_unInit()
	self.m_root = nil
	self.m_tCommunityCopyInfo = nil
	self.m_tBossInfo = nil
	self.m_elementCurSelcetCopy = nil
	self.m_nCurSelectIndex = nil
	self.m_nGetRewardSelectIndex = nil
	
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneCommunityCopy:createElement()
	local element = WZUISystem:getInstance():createElement("SceneCommunityCopy")
	assert(element, "SceneCommunityCopy create element failed!")
	self:_init()
	return element
end

function SceneCommunityCopy:show()
	WZLog("SceneCommunityCopy:show")
	replaceScene(self:createElement())
end

--@brief	设置点击返回按钮返回的场景绑定的Lua表引用
--@param	tLuaObj，场景绑定的Lua表引用
--@note		点击返回按钮后切换到设置的场景，如果tLuaObj设置为nil，则禁用返回按钮
function SceneCommunityCopy:setBackSceneLuaObj(tLuaObj)
	self.m_tBackSceneLuaObj = tLuaObj
end

--@brief 创建界面
--@param tData.copyId 副本id
function SceneCommunityCopy:setInfoViewData(tData)
	self.m_tData = tData
	self:initView()
end

--@brief 刷新界面
function SceneCommunityCopy:updateInfoViewData(data)
	WZLog("SceneCommunityCopy:updateInfoViewData ")
	if not self.m_root  then
		return
	end
	
	self:closeLoading()
	if self.m_tCommunityCopyInfo == nil then
		self.m_tCommunityCopyInfo = data
		self:_updateView(data)
	else
		self.m_tCommunityCopyInfo = data
		local txtGetTotal = GetElement(self.m_root,"txtGetTotal_SceneCommunityCopy",WZUILabelTTF)
        txtGetTotal:setText(self.m_tCommunityCopyInfo.todayGain)
	end
end


--@brief   创建加载框
function SceneCommunityCopy:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function SceneCommunityCopy:closeLoading()
	if self.m_nLoadingId then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
		self.m_nLoadingId = nil
	end
end

--@brief  添加顶部导航栏
function SceneCommunityCopy:addTop()
	WZLog("SceneCommunityCopy:addTop")
	local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    self.m_tTopHangle = tcell
    self.m_oTopObject = cell
    tcell:setTopData("ui/community/common_icon_ghfb.png",SceneCommunityCopy,SceneCommunityCopy.onCloseClick,true,true,false,"SceneCommunityCopy")
end

--获取伤害奖励成功
function SceneCommunityCopy:getRewrdSuccess(itemId, itemNum)
	WZLog("SceneCommunityCopy:getRewrdSuccess")
	if not self.m_root  then return end
	self:closeLoading()
	if self.m_nGetRewardSelectIndex then
		local conRightButtom = GetElement(self.m_root,"conRightButtom_SceneCommunityCopy",WZUIContainer)
		local imgBox = GetElement(conRightButtom,"imgBox" .. self.m_nGetRewardSelectIndex .. "_SceneCommunityCopy",WZUIImage)
	    local armBox = GetElement(conRightButtom,"armBox" .. self.m_nGetRewardSelectIndex .. "_SceneCommunityCopy",WZArmature)
	    local imgRedPoint = GetElement(conRightButtom,"imgRedPoint" .. self.m_nGetRewardSelectIndex .. "_SceneCommunityCopy",WZUIImage)
	    armBox:setVisible(false)
	    imgRedPoint:setVisible(false)
	    if self.m_nGetRewardSelectIndex == 1 then
        	imgBox:setFile("ui/common/common_icon_lan3.png")
    	elseif self.m_nGetRewardSelectIndex == 2 then
    		imgBox:setFile("ui/common/common_icon_zi3.png")
    	elseif self.m_nGetRewardSelectIndex == 3 then
    		imgBox:setFile("ui/common/common_icon_huang3.png")
    	end
	end
	self.m_nGetRewardSelectIndex = nil
	WndRewardShow:showById(itemId,itemNum)
	ProtocolProcessorCommunityBossRoom:send_GUILD_GetGuildBossInfo()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
