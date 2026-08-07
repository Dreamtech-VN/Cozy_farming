--WndUnionListData.lua
--@brief	WndUnionList的数据模块
--@date		2024/01/09
--@author	XTX
--@note		联盟列表

WndUnionList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndUnionList:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_root = nil	 	  				  --场景根节点
	self.m_tCommunityList = nil          	  --存储从服务器返回公会列表的数据表
	self.m_tAllCommunityList = {}			  --本地存储全部公会列表
	self.m_nCurrentCellIndex = nil      	  --存储当前表格中容器的索引
	self.m_tCurrentList = nil 				  --存储当前数据的表 
	self.m_nCellCommunityId = nil       	  --用来保存从容器（CellCommunity)点击事件的取得的公会ID	
	self.m_nLoadingCircleId = nil       	  --加载圆圈的ID
	self.b_GetPlayerStoreEquipment = false    --发送玩家物品信息协议标记
	self.m_bSendGetPlayerInfo = false         --发送玩家信息协议  
	self.m_bUpPageShowLastPosition = false 	  --向上翻页，显示上一页底部 
	self.turnPage = "down"    
	self.pageNumber = 1			
	self.totalNumber = nil
	self.m_tShowList = {}					  --显示的公会列表数据
	self.m_nOffsetNum = nil				  	  --容器位置
	self.m_bFirstTurnPage = true			  --是否第一次往下翻页
	self.m_nTab = nil
	self.m_bSwitchTab = nil
	self.m_nEachPageNum = 20
	self.m_sInputContent = nil 
	self.m_tLocalItemList = {{title = LocalStrings.UNION_TEXT1[4], uiId = 310, functionId = 230, mark = "hall"},
							 {title = LocalStrings.UNION_TEXT1[31], uiId = 308, functionId = 230, mark = "rank"},
							}
	self.m_tRealItemList = nil 
	self.m_tCellSel = nil 	--选中显示的内容
	self.m_sSelMark = nil 
	self.m_tCellTop = nil
	self.m_tCellLeft = nil 
	self.m_nFreshCd = 0 	--刷新联盟列表CD
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndUnionList:_unInit()
	self.m_root = nil
	self.m_tCommunityList = nil
	self.m_tAllCommunityList = nil			  --本地存储全部公会列表
	self.m_nCurrentCellIndex = nil  
	self.m_tCurrentList = nil 				  --存储当前数据的表 
	self.m_nCellCommunityId = nil  
	self.m_nLoadingCircleId = nil            --加载圆圈的ID
	self.b_GetPlayerStoreEquipment =  nil    --发送玩家物品信息协议标记
	self.m_bSendGetPlayerInfo = nil         --发送玩家信息协议   
	self.m_bUpPageShowLastPosition = nil
	self.turnPage = nil 
	self.pageNumber = nil			
	self.totalNumber = nil
	self.m_tShowList = nil					  --显示的公会列表数据
	self.m_nOffsetNum = nil				      --容器位置
	self.m_bFirstTurnPage = nil				  --是否第一次往下翻页
	self.m_nTab = nil
	self.m_bSwitchTab = nil
	self.m_nEachPageNum = nil
	self.m_sInputContent = nil 
	self.m_tLocalItemList = nil
	self.m_tRealItemList = nil 
	self.m_tCellSel = nil
	self.m_sSelMark = nil 
	self.m_tCellTop = nil 
	self.m_tCellLeft = nil 
	self.m_nFreshCd = nil 	--刷新联盟列表CD
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndUnionList:createElement()
	if WndUnionList.m_root ~= nil then
		WindowManager:removeWindow(WndUnionList.m_root, WndUnionList, true)
	end
	local element = WZUISystem:getInstance():createElement("WndUnionList")
	assert(element, "WndUnionList create element failed!")
	self:_init()
	return element
end

--@brief	取得自己联盟的名字函数 
--@return 	自己联盟的名字 
function WndUnionList:getMyCommunityName()
	return CacheCenter:getPlayerInfo().unionName
end 

--@brief	取得聯盟列表（客户端接受到服务端发送的好友列表后的数据处理回调方法取得公会列表）
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function WndUnionList:getCommunityListNew(id, name, chairmanName, level, exp, joinLimitLv, joinLimitFight, memberNum, joinLimitVipLv)
	WZLog("WndUnionList:getCommunityListNew")
	self.m_tCommunityList = {}
	for i=1,#id do
		if i ~= 1 and name[i] == self:getMyCommunityName() then
		else
			local tempList = {}
			tempList.communityId = id[i]
			tempList.communityName = name[i]
			tempList.level = level[i]
			tempList.prestige = exp[i]
			tempList.setting = joinLimitLv[i]
			tempList.fighting = joinLimitFight[i]
			tempList.members = memberNum[i]
			tempList.vipLevel = joinLimitVipLv[i]
			tempList.presidentName = chairmanName[i]

			table.insert(self.m_tCommunityList,tempList)
		end
	end

	self.totalNumber = 1    --总页数

	local index = 1
	local startIndex, endIndex
	if self.pageNumber ~= nil then
		if self.pageNumber == 1 then startIndex = 1 else startIndex = (self.pageNumber - 1)*self.m_nEachPageNum + 2 end
		endIndex = self.pageNumber * self.m_nEachPageNum + 1
		for i=startIndex,endIndex do
			self.m_tAllCommunityList[i] = self.m_tCommunityList[index]
			index = index + 1
		end
	end
--	WZLog("所有公会列表",Serialize(self.m_tAllCommunityList))

	self:_update()
end 

--@brief	取得公会信息 
function WndUnionList:getCommunityInfoOk(id, name, level, memberNum, totemLevel, exp, joinLimitLv, joinLimitVipLv, joinLimitFight, examine, schoolLevel, playerId, headId, faceId, colour, headEffectId, playerName, playerLevel, sex, loginTime, isOnline, post, fight, donate, totalDonate, vipLevel)
	WZLog("WndUnionList:getCommunityInfoOk")
	if not g_bIsGetUnionInfo then return end 
	--弹出公会信息窗口
	local wndInfo = WndUnionInfo:createElement()
	WindowManager:addWindow(wndInfo, WndUnionInfo)
	local bHaveEnemyComminityInfo = false
	--设置公会内容
	WndUnionInfo:setAlliesData(playerId, headId, faceId, colour, headEffectId, playerName, playerLevel, sex, loginTime, isOnline, post, fight, donate, totalDonate, vipLevel)
	WndUnionInfo:setFreeconText(name, tostring(id), tostring(level),tostring(memberNum),totemLevel)

	--设置申请入会按钮是否可用
	local unionInfo = CacheCenter:getPlayerInfo().unionInfo
	if unionInfo ~= nil and unionInfo.id and unionInfo.id > 0 then
		WndUnionInfo:setJoinCommunityBtnEnable(false)
	end
	WndUnionInfo.setting = joinLimitLv
	WndUnionInfo.vipLevel = joinLimitVipLv
	WndUnionInfo.m_nFighting = joinLimitFight or 0
	--取消圆圈的转动效果
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingCircleId)

	g_bIsGetUnionInfo = false 
end 

--@brief	取得公会信息错误处理
function WndUnionList:getCommunityInfoError(sMessage)
	WZLog("WndUnionList:getCommunityInfoError")
	MsgBoxManager:showTipBox(sMessage) 

	--取消圆圈的转动效果
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingCircleId)
end

--@brief 	外部接口
function WndUnionList:showInterface(mark)
	--body
	if self.m_root then 
		WindowManager:removeWindow(self.m_root, self, true)
	end
	local wndCommunity = WndUnionList:createElement()
	if wndCommunity then 
		self.m_sSelMark = mark or "rank"
		WindowManager:addWindow(wndCommunity,WndUnionList)
		self:showDefaultList()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	判断是否显示上一页函数
--@note		当前页大于1的时候显示上一页，否则不显示
function WndUnionList:_getUpPage()
	local nCurPage = self.pageNumber
	if nCurPage > 1 then
		return true
	else
		return false
	end
end

--@brief	判断是否显示下一页函数
--@note		当前页小于总页数的时候显示下一页，否则不显示
function WndUnionList:_getDownPage()
	local totalPageNum = self.totalNumber
	local nCurPage = self.pageNumber
	if nCurPage < (totalPageNum) then
		return true
	else
		return false
	end
end

-------------------------------------私有方法模块End----------------------------------------
CellLeftUnionItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellLeftUnionItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellLeftUnionItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_bIsLoaded = false 
	self.m_bSelState = false 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLeftUnionItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_bIsLoaded = nil 
	self.m_bSelState = nil 
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellLeftUnionItem:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()

    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellLeftUnionItem")          --用于在表的外面，通过名字获取对应的表结构
    element:setAbsContentSize(GlobalMethod:CCSize(172,59))   --这个容器的大小要和cell的大小一致
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLeftUnionItem:onEnter(element)
    WZLog("CellLeftUnionItem:onEnter(element)")
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLeftUnionItem:onExit(element)
	self:_unInit()
end

--@brief    
function CellLeftUnionItem:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellLeftUnionItem_WndUnionList")
    celElement:setVisible(true)
    self.m_root:addChild(celElement)
    --更新函数
    self.m_bIsLoaded = true
    self:_update()
end

--@brief	更新函数
function CellLeftUnionItem:_update()
	if self.m_root == nil then
		return
	end
	
	GetElement(self.m_root, "txtBtnName_CellLeftUnionItem", WZUILabelTTF):setText(self.m_tData.title)
	GetElement(self.m_root, "txtBtnNameSel_CellLeftUnionItem", WZUILabelTTF):setText(self.m_tData.title)
	GetElement(self.m_root, "btnItem_CellLeftUnionItem", WZUIButton):setTag(self.m_tData.uiId)

	self:setSelState(self.m_bSelState)
end

--@brief 	设置数据
function CellLeftUnionItem:setData(tData)
	-- body
	self.m_tData = tData
end

--@brief 	设置选中状态
function CellLeftUnionItem:setSelState(bVisible)
	-- body
	self.m_bSelState = bVisible
	if self.m_bIsLoaded == false then return end 

	GetElement(self.m_root, "imgSel_CellLeftUnionItem", WZUIImage):setVisible(bVisible)
end

--@brief 	点击切换按钮回调
function CellLeftUnionItem:onChangeTab(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self:setSelState(true)
	WndUnionList:onClickLeftBtnCallBack(self.m_tData.mark, self)
end