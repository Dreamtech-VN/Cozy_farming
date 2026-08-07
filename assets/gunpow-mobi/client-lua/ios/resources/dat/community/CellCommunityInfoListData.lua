--CellCommunityInfoListData.lua
--@brief	CellCommunityInfoList的数据模块
--@date		2013/12/25
--@author	林庆凯
--@note		创建公会信息的列表

CellCommunityInfoList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCommunityInfoList:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_sTxtName = nil       --名称
	self.m_sTxtContent = nil    --内容文本
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCommunityInfoList:_unInit()
	self.m_root = nil
	self.m_sTxtName = nil       --名称
	self.m_sTxtContent = nil    --内容文本
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCommunityInfoList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCommunityInfoList table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellCommunityInfoList")
	assert(element, "CellCommunityInfoList element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置名称和名称对应内容的函数
--@param # 1 sTxtName 名称
--@param # 1 sTxtContent 内容文本
function CellCommunityInfoList:setTxtContent(sTxtName,sTxtContent)
	self.m_sTxtName = sTxtName       --名称
	self.m_sTxtContent = sTxtContent    --内容文本
	self:_update()
end 


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCommunityInfoList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
