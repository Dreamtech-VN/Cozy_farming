--WndDressSuitData.lua
--@brief	WndDressSuit的数据模块
--@date		2018/03/28
--@author	Tianxiang_Xu
--@note		时装套装方案

WndDressSuit = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDressSuit:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nType = nil 					--1->衣橱;2->幻化;3->竞技房间;4->组队房间;5->魅力时装;6->祈福方案;7->符文方案;8->技能/道具/幻技方案
	self.m_tSuitData = nil 				--套装数据
	self.m_bIsOpenList = false 			--套装列表是否打开
	self.m_nMaxSuitNum = nil 				--最大可保存时装的套数
	self.m_tConfigData = nil 			--系统表配置的数据
	self.m_nodeSuitSel = nil 			
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDressSuit:_unInit()
	self.m_root = nil
	self.m_tSuitData = nil 				--套装数据
	self.m_nType = nil 
	self.m_bIsOpenList = nil 
	self.m_nMaxSuitNum = nil
	self.m_tConfigData = nil 			--系统表配置的数据
	self.m_nodeSuitSel = nil 			
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDressSuit:createElement(is_trun)
	local tNewObj = self:_new()
	assert(tNewObj, "WndDressSuit table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("WndDressSuit")
	assert(element, "WndDressSuit element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self.m_bIsTrun = is_trun or nil --是否转向（主要是上下） 默认向下
	return element,tNewObj
end

--@brief 	设置类型
--@param 	nType: 1->衣橱;2->幻化;3->竞技房间;4->组队房间;5->魅力时装;6->祈福方案;7->符文方案;8->技能/道具/幻技方案 9->丑人秀 10->宠物装备
function WndDressSuit:setType(nType)
	-- body
	WZLog("设置套装类型",nType)
	self.m_nType = nType
	self:showWin()
end

--@brief 	设置套装数据
function WndDressSuit:setSuitData(tData)
	-- body
	WZLog("设置套装数据",self.m_nType,Serialize(tData))
	if self.m_nType == 6 or self.m_nType == 7 or self.m_nType == 8 then 
		if tData == nil then 
			ProtocolProcessorRecycling:send_PLAYERITEM_GetSuit(self.m_nType)
		else
			self.m_tSuitData = CopyTable(tData)

			self:_update()
		end
	elseif self.m_nType == 10 then
		local tSuitData = CacheCenter:getPetEquipSchemeData()
		if not tSuitData then
			ProtocolProcessorRecycling:send_PLAYERITEM_PetEquipSchemeList()
			return
		end
		self.m_tSuitData = CopyTable(tSuitData)

		self:_update()
	else
		local tSuitData = CacheCenter:getDressSuitData()
		if not tSuitData then
			ProtocolProcessorRecycling:send_PLAYERITEM_GetDressSuit()
			return 
		end
		self.m_tSuitData = CopyTable(tSuitData)

		self:_update()
	end
end

--@brief 	改名成功
function WndDressSuit:renameResult(result, id, nameNew)
	-- body
	WZLog("WndDressSuit:renameResult", result)
	
	self:displayResult(result)
	--成功更新新名字
	-- if result == 1 then
	-- 	for i = 1, #self.m_tSuitData do
	-- 		if self.m_tSuitData[i].id == id then
	-- 			self.m_tSuitData[i].name = nameNew

	-- 			GetElement(self.m_root, "txtSelSuitName_WndDressSuit", WZUILabelTTF):setText(nameNew)
	-- 			local conSuitList = GetElement(self.m_root, "conSuitList_WndDressSuit", WZUIContainer)
	-- 			local btn = conSuitList:getChildByTag(id)
	-- 			if btn then
	-- 				local txtBtn = btn:getChildByTag(44)
	-- 				if txtBtn then
	-- 					txtBtn = WZUILabelTTF:luaTo(txtBtn)
	-- 					txtBtn:setText(nameNew)
	-- 				end
	-- 			end
	-- 			break 
	-- 		end
	-- 	end
	-- end
end

--@brief 	新增套装OK
function WndDressSuit:addNewDressSuitOK(id, name)
	-- body
	if self.m_tSuitData == nil then
		self.m_tSuitData = {}
	end

	local tItem = {}
	tItem.id = id
	tItem.name = name
	tItem.bIsUsed = false 
	table.insert(self.m_tSuitData, tItem)

	self:_createSuitList()
end

--@brief 	切换时装
function WndDressSuit:changeDressSuitOK()
	-- body
	self:hideSuitList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	获取当前使用的套装
function WndDressSuit:getCurUseSuit()
	-- body
	for i = 1, #self.m_tSuitData do
		if self.m_tSuitData[i].bIsUsed == true then
			return self.m_tSuitData[i]
		end
	end
end


--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndDressSuit:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
