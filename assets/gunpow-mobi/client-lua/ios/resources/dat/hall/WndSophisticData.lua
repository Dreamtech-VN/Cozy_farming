--WndSophisticData.lua
--@brief	WndSophistic的数据模块
--@date		2016/01/07
--@author	zsq
--@note		武器洗练

WndSophistic = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndSophistic:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nLockItemNum = nil 	--拥有的锁的数目
	self.m_nSophisticStoneNum = nil --拥有的洗练石的数目
	self.m_nCostLockNum = nil 	--需要消耗的技能锁数目
	self.m_nCostSophisticStoneNum = nil --需要消耗的洗练石数目
	self.m_tCurSelectedEquip = nil 	--当前选中的武器数据信息
	self.m_tSkillLockStatus = nil 		--當前武器的技能Id表
	self.m_tSkillDataList = nil 	--武器技能数据表
	self.m_cellElementList = nil 		--点击的技能节点
	self.m_nClickSkillIndex = nil 	--点击的技能的索引，用于购买技能锁成功后，锁定该技能
	self.m_tSelectedCell = nil 		--当前选中的武器Cell
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSophistic:_unInit()
	self.m_root = nil
	self.m_nLockItemNum = nil 	--拥有的锁的数目
	self.m_nSophisticStoneNum = nil --拥有的洗练石的数目
	self.m_nCostLockNum = nil 	--需要消耗的技能锁数目
	self.m_nCostSophisticStoneNum = nil --需要消耗的洗练石数目
	self.m_tCurSelectedEquip = nil 	--当前选中的武器数据信息
	self.m_tSkillLockStatus = nil 		--當前武器的技能Id表
	self.m_tSkillDataList = nil 	--武器技能数据表
	self.m_cellElementList = nil 		--点击的技能节点
	self.m_nClickSkillIndex = nil 	--点击的技能的索引，用于购买技能锁成功后，锁定该技能
	self.m_tSelectedCell = nil 		--当前选中的武器Cell
end

function WndSophistic:updatePlayerItemData()
	if self.m_nLockItemNum < getBagItemCount(159) then
		WZLog("******* WndSophistic:updatePlayerItemNum *********", self.m_nClickSkillIndex)
		if self.m_nClickSkillIndex ~= nil then
			self:lockOrUnlockSkill(nil, self.m_nClickSkillIndex)
		end
	end
	self:_setStaticText()
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndSophistic:createElement()
	local element = WZUISystem:getInstance():createElement("WndSophistic")
    assert(element, "WndSophistic create element failed!")
    self:_init()
    return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndSophistic:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------

