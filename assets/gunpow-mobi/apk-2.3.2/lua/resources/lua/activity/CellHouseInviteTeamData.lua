--CellHouseInviteTeamData.lua
--@brief	CellHouseInviteTeam的数据模块
--@date		2021/09/27
--@author	hyx
--@note		房产主界面

CellHouseInviteTeam = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellHouseInviteTeam:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nWinType = 1 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellHouseInviteTeam:_unInit()
	self.m_root = nil
	self.m_nWinType = nil 
end
function CellHouseInviteTeam:setHouseMyTeamData(names, ids, headIds, faceIds, sexs, vipLevels, headColors, levels, times, serverIds, headEffectId)
	local data = {}
	for i=1,#ids do
		local tab = {}
		tab.name = names[i]
		tab.id = ids[i]
		tab.headId = headIds[i]
		tab.faceId = faceIds[i]
		tab.sex = sexs[i]
		tab.vipLevel = vipLevels[i]
		tab.headColor = headColors[i]
		tab.level = levels[i]
		tab.count = times[i]
		tab.serverId = serverIds[i]
		if headEffectId then 
			tab.headEffectId = headEffectId[i]
		else
			tab.headEffectId = 0
		end
		data[i] = tab
	end
	return data
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellHouseInviteTeam:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellHouseInviteTeam")
	assert(element, "CellHouseInviteTeam create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end

--@brief 	设置窗口类型
function CellHouseInviteTeam:setWinType(nWinType)
	self.m_nWinType = nWinType or 1
end

function CellHouseInviteTeam:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--======= 团队 ========
TeamItem = {}
function TeamItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tTeamData = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function TeamItem:_unInit()
	self.m_root = nil
	self.m_tTeamData = nil
end

--@brief	创建控件
function TeamItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,92))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function TeamItem:setTeamData(data)
	self.m_tTeamData = data
end

--@brief 	开始加载
function TeamItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("TeamItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()	
end
function TeamItem:setData()
	if not self.m_tTeamData then return end

	local txtName = GetElement(self.m_root,"txtName",WZUIFreeTextBox)
	if self.m_tTeamData.serverId == CacheCenter:getPlayerInfo().serverId then
		txtName:setShowText(string.format([[<T C="127,70,26" S="20" P="1">%s</T>]],self.m_tTeamData.name))
	else
		txtName:setShowText(string.format([[<I Z="1">ui/common/common_icon_kuafu.png</I><T C="127,70,26" S="20" P="1">%s</T>]],self.m_tTeamData.name))
	end
	GetElement(self.m_root,"txtLevel",WZUILabelTTF):setText(self.m_tTeamData.level)
	GetElement(self.m_root,"txtCount",WZUILabelTTF):setText(self.m_tTeamData.count)
	local head_con = GetElement(self.m_root,"head_con",WZUIContainer)
	CellHead:show(head_con, self.m_tTeamData.headId, self.m_tTeamData.faceId, self.m_tTeamData.sex, false, nil, self.m_tTeamData.vipLevel, self.m_tTeamData.headColor, nil, nil, nil, nil, self.m_tTeamData.headEffectId)
end
function TeamItem:onBtnHead()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tTeamData then return end
	WndCheckOther:show(self.m_tTeamData.id)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@return	新建的表实例对象
function TeamItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
