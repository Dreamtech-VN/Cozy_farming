--WndFirstReChargeData.lua
--@brief	WndFirstReCharge的数据模块
--@date		2021/05/06
--@author	hyx
--@note		新版首冲

WndFirstReCharge = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFirstReCharge:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tFirstRechargeData = {}
	self.m_nCurIndex = nil
	self.m_tBtnChangeTitle = {}
	self.m_tTouchView = {} --点击过的界面
	self.m_tGetStatusIds = {} --可以领取的id
	self.m_tChargeNumData = {} --充值的数据
	self.m_nDressGiftId1 = nil 	--时装礼包Id
	self.m_nWingId = nil 		--翅膀Id
	self.m_nDressGiftId = nil --时装礼包Id
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFirstReCharge:_unInit()
	self.m_root = nil
	self.m_tFirstRechargeData = {}
	self.m_nCurIndex = nil
	self.m_tBtnChangeTitle = {}
	self.m_tTouchView = {}
	self.m_tGetStatusIds = {}
	self.m_tChargeNumData = {}
	self.m_nDressGiftId1 = nil
	self.m_nWingId = nil 		--翅膀Id
	self.m_nDressGiftId = nil --时装礼包Id
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFirstReCharge:createElement()
	if WndFirstReCharge.m_root ~= nil then
		WindowManager:removeWindow(WndFirstReCharge.m_root, WndFirstReCharge, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFirstReCharge")
	assert(element, "WndFirstReCharge create element failed!")
	self:_init()
	return element
end

--档次的数据
-- old 老奖励  new 新奖励
function WndFirstReCharge:setRechargeRewardData(_type)
	if GDatatab_reward_first_charge then
		local index = 1
		local table_insert = table.insert
		local sex = CacheCenter:getPlayerInfo().sex
		for i,v in pairs(GDatatab_reward_first_charge) do
			if self.m_tFirstRechargeData[v.grade] == nil then
				self.m_tFirstRechargeData[v.grade] = {}
			end
			local tab = {}
			tab.id = v.id
			tab.day = v.day	
			tab.grade = v.grade	
			local status = -1
			if self.m_tGetStatusIds[v.id] then
				status = self.m_tGetStatusIds[v.id]
			end
			tab.status = status
			if _type == "old" then
				if sex == 0 then
					tab.reward = v.reward_boy_old
				else
					tab.reward = v.reward_girl_old
				end
			else
				if sex == 0 then
					tab.reward = v.reward_boy_new
				else
					tab.reward = v.reward_girl_new
				end
			end
			table_insert(self.m_tFirstRechargeData[v.grade], tab)
			if v.grade == 1 and v.day == 2 then 
				self.m_nDressGiftId1 = tab.reward[1][1]
			elseif v.grade == 2 and v.day == 1 then 
				self.m_nWingId = tab.reward[1][1]
			elseif v.grade == 3 and v.day == 1 then 
				self.m_nDressGiftId = tab.reward[1][1]
			end
		end
	end
end
function WndFirstReCharge:getRechargeRewardData(index)
	return self.m_tFirstRechargeData[index]
end

--=============首冲领取项=================
CellFirstItem = {}
function CellFirstItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFirstItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellFirstItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(154,236))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellFirstItem:setCellItemData(tag, data, rechargeData)
	self.m_nType = tag
	self.m_tCellItemData = data
	self.m_tRechargeData = rechargeData
end
--@brief 	开始加载
function CellFirstItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellFirstItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()

	AdaptLanguage(self)
end

function CellFirstItem:setData()
	if not self.m_tCellItemData then return end

	local data = self.m_tCellItemData

	local txtStatus = GetElement(self.m_root,"txtStatus",WZUILabelTTF)
	if self.m_nType == 1 then
		if self.m_tRechargeData and self.m_tRechargeData.progress ~= 0 then
			txtStatus:setVisible(false)
		else
			txtStatus:setText(LocalStrings.NEWFIRSTCHARGE_TEXT2[data.status+2])		
		end
	elseif self.m_nType == 2 or self.m_nType == 3 then
		if self.m_tRechargeData and self.m_tRechargeData.progress < self.m_tRechargeData.target then
			txtStatus:setText(LocalStrings.NEWFIRSTCHARGE_TEXT4)
		else
			if data.status == -1 then
				txtStatus:setText(LocalStrings.NEWFIRSTCHARGE_TEXT5)
			else
				txtStatus:setText(LocalStrings.NEWFIRSTCHARGE_TEXT2[data.status+2])
			end
		end
	end

	GetElement(self.m_root,"btnGetReward",WZUIButton):setVisible(data.status == 0)
	GetElement(self.m_root,"txtDay",WZUILabelTTF):setText(string.format(LocalStrings.ACTIVITY_TEXT22,data.day))
	
	self:setGetStatus(self.m_root, data.status)
	local nCount = #data.reward
	for i=1, #data.reward do
		local tData = GDatatab_item["id_"..data.reward[i][1]]
		if nCount > 2 then
			local nIndex = math.ceil(i/2)
			local reward_con = GetElement(self.m_root,"reward_con" .. nIndex,WZUIContainer)
			if tData then
				reward_con:setVisible(true)
				local celElement,tLuaObj = CellGoodItem:createElement()
				celElement:setScale(0.8)
				if math.fmod(i, 2) == 1 then 
					celElement:setRelativePosition(GlobalMethod:ccp(-0.05, 0.5))
				else
					celElement:setRelativePosition(GlobalMethod:ccp(1.05, 0.5))
				end
				reward_con:addChild(celElement)

				local num = data.reward[i][2]
				local itemInfo = {name=tData.name,icon=tData.icon,lastTime=num,lastNum=num,quality=tData.quality,basicInfo=CopyTable(tData)}
				tLuaObj:setCellGoodItem(itemInfo, 16)
				tLuaObj:setItemClickFun(WndFirstReCharge, self.onItemClick)
			end
		else
			local reward_con = GetElement(self.m_root,"reward_con"..i,WZUIContainer)
			if tData then
				reward_con:setVisible(true)
				local celElement,tLuaObj = CellGoodItem:createElement()
				celElement:setScale(0.8)
				reward_con:addChild(celElement)

				local num = data.reward[i][2]
				local itemInfo = {name=tData.name,icon=tData.icon,lastTime=num,lastNum=num,quality=tData.quality,basicInfo=CopyTable(tData)}
				tLuaObj:setCellGoodItem(itemInfo, 16)
				tLuaObj:setItemClickFun(WndFirstReCharge, self.onItemClick)
			end
		end 
	end
end
function CellFirstItem:setGetStatus(node, status)
	if status == 0 then
		local spinePath = "activity/ui_common_sc"
		local existSpine = CheckEffectFile(spinePath)
		if existSpine then 
			local spine = WZUISpine:create()
		   	spine:setTouchEnable(false)
		   	spine:setFileJson(spinePath .. ".json")
		   	spine:setFileAtlas(spinePath .. ".atlas")
		   	spine:setUseOriginSize(true)
		   	spine:setRelativePosition(GlobalMethod:ccp(0.533,0.483))
		   	spine:setScaleX(0.88)
		   	spine:setScaleY(1.05)
			spine:play("wait_1",true)
		   	node:addChild(spine,1)
	    end
	elseif status == 1 then
		local get_icon = WZUIImage:create()
        get_icon:setAnchorPoint(ccp(0.5,0.5))
        get_icon:setRelativePosition(ccp(0.5,0.5))
        get_icon:setUseOriginSize(true)
        get_icon:setFile("ui/common/commom_text_ylq.png")
        node:addChild(get_icon, 1)
	end
end
function CellFirstItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndFirstReCharge.m_root,1,tData,false,nil,true)
end
function CellFirstItem:onBtnGetReward()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tCellItemData and self.m_tCellItemData.status == 0 then
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(g_cityExtenInfo.activity7012, self.m_tCellItemData.id)
	end
end

--@return	新建的表实例对象
function CellFirstItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配模块begin--------------------------------------
function CellFirstItem:_adaptLanguage_vn()
	local txtStatus = GetElement(self.m_root,"txtStatus",WZUILabelTTF)
	txtStatus:setScale(0.7)
	txtStatus:setDimensions(GlobalMethod:CCSize(200,0))
end
--------------------------------------语言适配模块end--------------------------------------