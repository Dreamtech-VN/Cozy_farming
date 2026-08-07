--WndGemMountingStrengthenData.lua
--@brief	WndGemMountingStrengthen的数据模块
--@date		2014/8/16
--@author	zsq
--@note		镶嵌窗口

WndGemMountingStrengthen = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGemMountingStrengthen:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_attackStoneElement = nil		--攻击镶嵌石节点对象
	self.m_attackStoneLuaObj = nil		--攻击镶嵌石lua表对象
	self.m_defenseStoneElement = nil	--防御镶嵌石节点对象
	self.m_defenseStoneLuaObj = nil		--防御镶嵌石lua表对象
	self.m_specialStoneElement = nil	--特殊镶嵌石节点对象
	self.m_specialStoneLuaObj = nil		--特殊镶嵌石lua表对象
	self.m_extremeStoneElement = nil	--共鸣石节点对象
	self.m_extremeStoneLuaObj = nil		--共鸣石lua表对象
	self.m_bIsGemMounting = false  		--是否正在镶嵌
	self.m_nNeedGold = 0				--镶嵌所需金币

    self.m_tCurSelectedEquip = nil      --当前选择的装备
    self.m_tCurSelectedStone = nil      --当前镶嵌的宝石
    self.m_nLoadingId = nil
	self.m_nUpgradeGemId = nil
	self.m_nSelStoneSeat = nil 			--默认选中的槽位
	self.m_tSelStoneCell = nil 			--选中的宝石
	self.m_nSelStoneSubType = nil 		--选中宝石的子类型
	self.m_nOperateType = 0 			--0镶嵌；1升级
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGemMountingStrengthen:_unInit()
	self.m_root = nil	 	  			
	self.m_attackStoneElement = nil		
	self.m_attackStoneLuaObj = nil		
	self.m_defenseStoneElement = nil	
	self.m_defenseStoneLuaObj = nil		
	self.m_specialStoneElement = nil	
	self.m_specialStoneLuaObj = nil		
	self.m_bIsGemMounting = nil
	self.m_nNeedGold = nil

	self.punchType = nil

    self.m_tCurSelectedEquip = nil  --当前选择的装备
    self.m_tCurSelectedStone = nil
    self.m_nLoadingId = nil
	self.m_nUpgradeGemId = nil
	self.m_nSelStoneSeat = nil 			--默认选中的槽位
	self.m_tSelStoneCell = nil 			--选中的宝石
	self.m_nSelStoneSubType = nil 		--选中宝石的子类型
	self.m_nOperateType = nil 			--0镶嵌；1升级
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGemMountingStrengthen:createElement()
	local element = WZUISystem:getInstance():createElement("WndGemMountingStrengthen")
	assert(element, "WndGemMountingStrengthen create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------
--@brief   创建加载框
function WndGemMountingStrengthen:_createLoading()
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndGemMountingStrengthen:_closeLoading()
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end
