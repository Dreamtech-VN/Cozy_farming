--WndUnionInfoData.lua
--@brief	WndUnionInfo的数据模块
--@date		2024/01/09
--@author	XTX
--@note		联盟信息界面

WndUnionInfo = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndUnionInfo:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sCommunityName = nil --公会名称
	self.m_sCommunityId = nil   --公会ID
	self.m_sCurrenlyPresident = nil  --现任会长
	self.m_sCommunityLevel = nil    --公会等级
	self.m_sTotalNum  = nil       --人数
	self.m_nTotemLevel  = nil      --图腾等级
	self.m_sEnemyListNameAndId = nil  --敌对公会名称ID
	self.m_sEnemySituationList = nil  --战绩
	self.m_bHaveEnemyComminityInfo = false --是否有敌对公会
	self.m_nFighting = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndUnionInfo:_unInit()
	self.m_root = nil
	self.m_sCommunityName = nil --公会名称
	self.m_sCommunityId = nil   --公会ID
	self.m_sCurrenlyPresident = nil  --现任会长
	self.m_sCommunityLevel = nil    --公会等级
	self.m_sTotalNum  = nil       --人数
	self.m_nTotemLevel  = nil      --威望
	self.m_sEnemyListNameAndId = nil  --敌对公会名称ID
	self.m_sEnemySituationList = nil  --战绩
	self.m_bHaveEnemyComminityInfo = nil --是否有敌对公会
	self.m_nFighting = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndUnionInfo:createElement()
	if WndUnionInfo.m_root ~= nil then
		WindowManager:removeWindow(WndUnionInfo.m_root, WndUnionInfo, true)
	end
	local element = WZUISystem:getInstance():createElement("WndUnionInfo")
	assert(element, "WndUnionInfo create element failed!")
	self:_init()
	return element
end

--@brief	设置公会名称，公会ID，现任会长，公会等级，人数，威望，资金，敌对玩家数据的函数
--@param #1 sCommunityName 公会名称
--@param #2 sCommunityId 公会ID
--@param #3 sCurrenlyPresident  现任会长
--@param #4 sCommunityLevel 公会等级
--@param #5 sTotalNum 人数
--@param #6 totemLevel  图腾等级
--@param #7 sMoney  资金
function WndUnionInfo:setFreeconText(sCommunityName,sCommunityId,sCommunityLevel,sTotalNum,totemLevel)
	WZLog("WndUnionInfo:setFreeconText", sCommunityName)
	self.m_sCommunityName = sCommunityName
	self.m_sCommunityId = sCommunityId
	self.m_sCommunityLevel = sCommunityLevel
	self.m_sTotalNum = sTotalNum
	self.m_nTotemLevel = totemLevel

	self:_setCommunityInfo()
end 

--@brief	设置敌对公会名称ID，战绩的函数
--@param #1  sEnemyListNameAndId 敌对公会名称ID
--@param #2  sEnemySituationList 战绩
function WndUnionInfo:setFreeconEnemyCommunityText(sEnemyListNameAndId,sEnemySituationList)
	self.m_sEnemyListNameAndId = sEnemyListNameAndId
	self.m_sEnemySituationList = sEnemySituationList
end 

--@brief	从服务器返回申请入会成功的函数
function WndUnionInfo:applyJoinCommunityOk()
	WZLog("WndUnionInfo:applyJoinCommunityOk()")
	MsgBoxManager:showTipBox(LocalStrings.UNION_TEXT1[25])
	self:setJoinCommunityBtnEnable(false)
end 

--@brief 	设置成员数据
function WndUnionInfo:setAlliesData(playerId, headId, faceId, colour, headEffectId, playerName, playerLevel, sex, loginTime, isOnline, post, fight, donate, totalDonate, vipLevel)
	self.m_tMemberList = {}

	for i = 1, #playerId do
		local tItem = {}
		tItem.id = playerId[i]
		tItem.headId = headId[i]
		tItem.faceId = faceId[i]
		tItem.headColor = colour[i]
		tItem.headEffectId = headEffectId[i]
		tItem.name = playerName[i]
		tItem.level = playerLevel[i]
		tItem.sex = sex[i]
		tItem.loginTime = loginTime[i]
		tItem.isOnline = isOnline[i]
		tItem.pos = post[i]
		tItem.fight = fight[i]
		tItem.donate = donate[i]
		tItem.totalDonate = totalDonate[i]
		tItem.vipLevel = vipLevel[i]
		if tItem.pos == UNION_PRESIDENT then 
			self.m_sCurrenlyPresident = tItem.name
		end

		table.insert(self.m_tMemberList, tItem)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
CellAlliesItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellAlliesItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellAlliesItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_bIsLoaded = false 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellAlliesItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_bIsLoaded = nil 
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellAlliesItem:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()

    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellAlliesItem")          --用于在表的外面，通过名字获取对应的表结构
    element:setAbsContentSize(GlobalMethod:CCSize(400,84))   --这个容器的大小要和cell的大小一致
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAlliesItem:onEnter(element)
    WZLog("CellAlliesItem:onEnter(element)")
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAlliesItem:onExit(element)
	self:_unInit()
end

--@brief    
function CellAlliesItem:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellAlliesItem")
    celElement:setVisible(true)
    self.m_root:addChild(celElement)
    --更新函数
    self.m_bIsLoaded = true
    self:_update()
end

--@brief	更新函数
function CellAlliesItem:_update()
	if self.m_root == nil then
		return
	end
	
	GetElement(self.m_root, "txtName_CellAlliesItem", WZUILabelTTF):setText(self.m_tData.name)
	GetElement(self.m_root, "txtPos_CellAlliesItem", WZUILabelTTF):setText(UNION_POSITION[self.m_tData.pos + 1])
	GetElement(self.m_root, "atlasFight_CellAlliesItem", WZUILabelAtlasFont):setText(self.m_tData.fight)

	local conHead = GetElement(self.m_root, "conHead_CellAlliesItem", WZUIContainer)
	CellHead:show(conHead, self.m_tData.headId, self.m_tData.faceId, self.m_tData.sex, nil, nil, self.m_tData.vipLevel, self.m_tData.headColor, nil, nil, nil, nil, self.m_tData.headEffectId)
end

--@brief 	设置数据
function CellAlliesItem:setData(tData)
	-- body
	self.m_tData = tData
end

--@brief 	点击切换按钮回调
function CellAlliesItem:onClickHead(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndCheckOther:show(self.m_tData.id)
end