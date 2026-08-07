--CellCommunityListData.lua
--@brief	CellCommunityList的数据模块
--@date		2013/12/24
--@author	林庆凯
--@note		创建公会列表的容器

CellCommunityList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCommunityList:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_sRanking = nil       --排名
	self.m_sId = nil 			--ID 
	self.m_sName = nil 			--名称 
	self.m_sLevel = nil 		--等级
	self.m_sPrestige = nil 		--威望      
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCommunityList:_unInit()
	self.m_root = nil
	self.m_sRanking = nil       
	self.m_sId = nil 			
	self.m_sName = nil 			
	self.m_sLevel = nil 		
	self.m_sPrestige = nil 		 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCommunityList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCommunityList table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellCommunityList")
	assert(element, "CellCommunityList element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置排名，ID，名称，等级，威望
--@param #1  sRanking   排名
--@param #2  sId        ID
--@param #3  sName      名称 
--@param #4  sLevel     等级
--@param #5  sPrestige  威望
function CellCommunityList:setCommunity1Context(sRanking, sId, sName, sLevel, sPrestige, setting, vipLevel, members)
	self.m_sRanking = sRanking        
	self.m_sId = sId 			
	self.m_sName = sName 	
	self.m_sLevel = sLevel 		
	self.m_sPrestige = sPrestige
	self.setting = setting
	self.vipLevel = vipLevel
	self.members = members
	self:_update()
end 




-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCommunityList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
