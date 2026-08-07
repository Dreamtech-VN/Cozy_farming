--CellCheckOther3Data.lua
--@brief	CellCheckOther3的数据模块
--@date		2015/07/06
--@author	zsq
--@note		玩家信息栏3

CellCheckOther3 = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCheckOther3:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_sHeadPath = nil
	self.m_nYear = nil 
	self.m_nMonth = nil 
	self.m_nDay = nil 
	self.m_nCityId = nil 
	self.m_nCityIndex = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCheckOther3:_unInit()
	self.m_root = nil
	self.m_sHeadPath = nil
	self.m_nYear = nil 
	self.m_nMonth = nil 
	self.m_nDay = nil 
	self.m_nCityId = nil 
	self.m_nCityIndex = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCheckOther3:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCheckOther3 table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellCheckOther3")
	assert(element, "CellCheckOther3 element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	刷新
function CellCheckOther3:updateInfo(nType, value)
	local txtContent = GetElement(self.m_root, "txtContent" .. nType .. "_CellCheckOther3", WZUILabelTTF)
	if nType == 1 then
		self.m_nYear = value
		txtContent:setText(value .. LocalStrings.SPACE30)
	elseif nType == 2 then  
		self.m_nMonth = value
		txtContent:setText(value .. LocalStrings.SPACE31)
	elseif nType == 3 then  
		self.m_nDay = value
		txtContent:setText(value .. LocalStrings.SPACE32)
	elseif nType == 4 then  
		if (self.m_nCityId and value ~= self.m_nCityId) or self.m_nCityId == nil then 
			self.m_nCityId = value
			self.m_nCityIndex = nil 
			local configData = GDatatab_city["id_" .. value]
			txtContent:setText(configData.province)
			GetElement(self.m_root, "txtContent5_CellCheckOther3", WZUILabelTTF):setText(LocalStrings.SPACE_CITY2)
			if configData.city == 0 then 
				GetElement(self.m_root, "btnSet5_CellCheckOther3", WZUIButton):setVisible(false)
			else
				GetElement(self.m_root, "btnSet5_CellCheckOther3", WZUIButton):setVisible(true)
			end
		end
	elseif nType == 5 then  
		if self.m_nCityId == nil then 
			MsgBoxManager:shoeTipBox(LocalStrings.SPACE_CITY3)
			return 
		end 
		local configData = GDatatab_city["id_" .. self.m_nCityId]
		local cityList = SplitStringWithSeparator(configData.city, "|")
		self.m_nCityIndex = value
		if cityList[value] then 
			txtContent:setText(cityList[value])
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCheckOther3:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
