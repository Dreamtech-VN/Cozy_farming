--WndTransferStrengthenData.lua
--@brief	WndTransferStrengthen的数据模块
--@date		2014/8/16
--@author	zsq
--@note		继承窗口

WndTransferStrengthen = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTransferStrengthen:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_weapon1Element = nil			--武器1节点对象
	self.m_weapon1LuaObj = nil			--武器1lua表对象
	self.m_weapon2Element = nil			--武器2节点对象
	self.m_weapon2LuaObj = nil			--武器2lua表对象
	self.m_tWeapon1Table = nil			--装备1对应物品表
	self.m_nWeapon1Tag = nil			--装备1对应物品tag
	self.m_tWeapon2Table = nil			--装备2对应物品表
	self.m_nWeapon2Tag = nil			--装备2对应物品tag
	self.m_bIsTransfering = false		--是否正在转移
	self.m_nNeedGold = 0				--转移所需金币
	self.m_needMaterialsNum = 0       --转移需要的转移石数量
	self.m_needHolyNum = 0       		--转移需要的圣光数量
	self.stone1 = nil
	self.stone2 = nil
	self.stone3 = nil
	self.stone4 = nil

    self.m_tCurSelectedEquip1 = nil  --当前选择的装备1
    self.m_tCurSelectedEquip2 = nil  --当前选择的装备1

end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTransferStrengthen:_unInit()
	self.m_root = nil	 	  			
	self.m_weapon1Element = nil			
	self.m_weapon1LuaObj = nil			
	self.m_weapon2Element = nil			
	self.m_weapon2LuaObj = nil			
	self.m_tWeapon1Table = nil			
	self.m_nWeapon1Tag = nil			
	self.m_tWeapon2Table = nil			
	self.m_nWeapon2Tag = nil		
	self.m_bIsTransfering = nil		
	self.m_nNeedGold = nil
	self.m_needMaterialsNum = nil       --转移需要的转移石数量
	self.m_needHolyNum = 0       		--转移需要的圣光数量
	self.stone1 = nil
	self.stone2 = nil
	self.stone3 = nil
	self.stone4 = nil

    self.m_tCurSelectedEquip1 = nil  --当前选择的装备1
    self.m_tCurSelectedEquip2 = nil  --当前选择的装备2
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTransferStrengthen:createElement()
	local element = WZUISystem:getInstance():createElement("WndTransferStrengthen")
	assert(element, "WndTransferStrengthen create element failed!")
	self:_init()
	return element
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
