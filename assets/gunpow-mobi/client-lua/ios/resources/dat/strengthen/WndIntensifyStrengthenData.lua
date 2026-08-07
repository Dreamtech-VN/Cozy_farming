--WndIntensifyStrengthenData.lua
--@brief	WndIntensifyStrengthen的数据模块
--@date		2014/8/16
--@author	zsq
--@note		强化窗口

WndIntensifyStrengthen = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndIntensifyStrengthen:_init()
	self.m_root = nil	 	  				--场景根节点
	self.m_weaponLuaObj = nil				--装备lua表对象

	self.m_bIsIntensifing = false			--是否正在强化
	self.m_nNeedGold = 0					--强化所需金币
	--强化公式值相关数据	

	--动画
	self.m_bShowAni = nil					--强化结果

    self.m_tCurSelectedEquip = nil  --当前选择的装备
    self.m_nMaxStrongLevel = 0

	self.m_bStrengthStoneEnough = false		--强化石是否足够
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndIntensifyStrengthen:_unInit()
	self.m_root = nil	 	  				
	self.m_weaponLuaObj = nil				

	self.m_bIsIntensifing = nil	
	self.m_nNeedGold = nil 						
	--强化公式值相关数据	

	self.m_bShowAni = nil

    self.m_tCurSelectedEquip = nil
    self.m_nMaxStrongLevel = nil

	self.m_bStrengthStoneEnough = nil		--强化石是否足够
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndIntensifyStrengthen:createElement()
	local element = WZUISystem:getInstance():createElement("WndIntensifyStrengthen")
	assert(element, "WndIntensifyStrengthen create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   创建加载框
function WndIntensifyStrengthen:_createLoading()
    self.m_nLoadingId = MsgBoxManager:showLoadingBox(nil,nil,nil,nil,nil,true)
end

--@brief   关闭加载框
function WndIntensifyStrengthen:_closeLoading()
    local nId = self.m_nLoadingId
    MsgBoxManager:stopLoadingBoxByMsgId(nId)
end




-------------------------------------私有方法模块End----------------------------------------
