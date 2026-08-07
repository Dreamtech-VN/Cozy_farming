--CellNewVipPrivilegeData.lua
--@brief	CellNewVipPrivilege的数据模块
--@date		2021/03/22
--@author	hyx
--@note		贵族特权

CellNewVipPrivilege = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellNewVipPrivilege:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurVipIndex = nil
	self.m_tAdvanceReward = {} --进阶奖励
	self.m_sRoleConPlayer = nil
	self.m_sFootRoleSpine = nil
	self.m_sAniMount = nil
	self.m_sWeaponCellItem = nil
	self.m_sConSkinPlayer = nil
	self.m_tVipPrivilegeTxt = {} --文字特权
	self.m_tSpecilEffect = {} --特效
	self.m_bIsJumpToFamous = false 
	self.m_nMaxVipLevel = tonumber(CacheCenter:getGameParam().newMaxVip or 23)
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewVipPrivilege:_unInit()
	self.m_root = nil
	self.m_nCurVipIndex = nil
	self.m_tAdvanceReward = {}
	self.m_sRoleConPlayer = nil
	self.m_sFootRoleSpine = nil
	self.m_sAniMount = nil
	self.m_sWeaponCellItem = nil
	self.m_sConSkinPlayer = nil
	self.m_tVipPrivilegeTxt = {}
	self.m_tSpecilEffect = {}
	self.m_bIsJumpToFamous = nil 
	self.m_nMaxVipLevel = nil 
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellNewVipPrivilege:createElement()
	if CellNewVipPrivilege.m_root ~= nil then
		WindowManager:removeWindow(CellNewVipPrivilege.m_root, CellNewVipPrivilege, true)
	end
	local element = WZUISystem:getInstance():createElement("CellNewVipPrivilege")
	assert(element, "CellNewVipPrivilege create element failed!")
	self:_init()
	return element
end


--===============================
AdvancedRewardItem = {}
function AdvancedRewardItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function AdvancedRewardItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function AdvancedRewardItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(126,286))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function AdvancedRewardItem:setAdvancedRewardData(id, num, status)
	self.m_nId = id
	self.m_nNum = num
	self.m_nStatus = status
end
--@brief 	开始加载
function AdvancedRewardItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("AdvancedRewardItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setAdvanceRewardItem()
end

function AdvancedRewardItem:setAdvanceRewardItem()
	if not self.m_nId then return end

	local reward_com = GetElement(self.m_root,"reward_com",WZUIContainer)
	local tData = GDatatab_item["id_"..self.m_nId]
	if tData then
		local celElement,tLuaObj = CellGoodItem:createElement()
	   	celElement = WZUIContainer:luaTo(celElement)
		reward_com:addChild(celElement)

		local itemInfo = {name=tData.name,icon=tData.icon,lastTime=self.m_nNum,lastNum=self.m_nNum,quality=tData.quality,basicInfo=CopyTable(tData)}
		tLuaObj:setCellGoodItem(itemInfo, 16)
		tLuaObj:setItemClickFun(CellNewVipPrivilege, self.onClickItem)
	
		if self.m_nStatus == 0 then
			local spine = WZUISpine:create()
		   	spine:setTouchEnable(false)
		   	spine:setFileJson("ui/ui_common_JJLQ.json")
		   	spine:setFileAtlas("ui/ui_common_JJLQ.atlas")
		   	spine:setUseOriginSize(true)
		   	spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
			spine:play("wait_1",true)
		   	celElement:addChild(spine,1)
		elseif self.m_nStatus == 1 then
			GetElement(self.m_root, "doneStatus", WZUIImage):setVisible(true)
		end
	end
end
function AdvancedRewardItem:onClickItem(tItem, nTag, tData)
	if self.m_root == nil then return end
	if WndVip.m_tDataList[CellNewVipPrivilege.m_nCurVipIndex] and WndVip.m_tDataList[CellNewVipPrivilege.m_nCurVipIndex].status == 0 then
		ProtocolProcessorWndRankList:send_PLAYER2_ReceiveVipLevelReward(tonumber(CellNewVipPrivilege.m_nCurVipIndex))
		return
	end
	WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

--@return	新建的表实例对象
function AdvancedRewardItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
