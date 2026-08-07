--WndMountStoneStongData.lua
--@brief	WndMountStoneStong的数据模块
--@date		2021/04/28
--@author	hyx
--@note		坐骑灵石强化

WndMountStoneStong = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMountStoneStong:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tQuickChooseData = {}
	self.m_nUpgradeID = nil
	self.m_nPlayerItemId = nil
	self.m_tStrongUpgradeData = {}
	self.m_sItemTableContainer = nil
	self.m_tChooseCellItem = {}
	self.m_tChooseCellPos = {}
	self.m_tChooseItemId = {}
	self.m_tChooseItemNum = {}
	self.m_tChooseStrongData = {} --选择强化的物品
	self.m_nCurUpgradeExp = 0
	self.m_nTotleUpgradeExp = 0
	self.m_nMainStoneQuality = 1
	self.m_nCurLevel = 0
	self.m_nInitCurLevel = 0
	self.m_nCurExp = 0
	self.m_nTotleExp = 0
	self.m_nSaveInitExp = 0 -- 保存当前的
	self.m_nMainStoneConfigId = 1 --主石的id
	self.m_tMainStoneData = {} --主石的数据
	self.m_nChooseStoneCount = {} --选择经验石的数量
	self.m_nQualityInitExp = 0 --快速选择的时候
	self.m_nRaiseExpProporte = 0 --吞噬的时候经验提高
	self.m_nIsHasEffect = 0 --没有特效的时候目前定死在10级
	self.m_nHasEffectMaxLevel = nil --拥有特效后变成的最大等级
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMountStoneStong:_unInit()
	self.m_root = nil
	self.m_tQuickChooseData = {}
	self.m_nUpgradeID = nil
	self.m_nPlayerItemId = nil
	self.m_tStrongUpgradeData = {}
	self.m_sItemTableContainer = nil
	self.m_tChooseCellItem = {}
	self.m_tChooseCellPos = {}
	self.m_tChooseItemId = {}
	self.m_tChooseItemNum = {}
	self.m_tChooseStrongData = {}
	self.m_nCurUpgradeExp = 0
	self.m_nTotleUpgradeExp = 0
	self.m_nCurLevel = 0
	self.m_nInitCurLevel = 0
	self.m_nCurExp = 0
	self.m_nTotleExp = 0
	self.m_nSaveInitExp = 0
	self.m_nMainStoneConfigId = 1
	self.m_tMainStoneData = {}
	self.m_nMainStoneQuality = 1
	self.m_nChooseStoneCount = {}
	self.m_nQualityInitExp = 0
	self.m_nRaiseExpProporte = 0
	self.m_nIsHasEffect = 0
	self.m_nHasEffectMaxLevel = nil
end

--快速选择的设置
function WndMountStoneStong:setQuickStatus(data)
	self.m_tQuickChooseData = data
end
function WndMountStoneStong:getQuickStatus()
	return self.m_tQuickChooseData
end

--主石的数据
function WndMountStoneStong:setMainStoneData()
	for i,v in pairs(GDatatab_sprite_stone) do
		if self.m_tMainStoneData[v.quality] == nil then
			self.m_tMainStoneData[v.quality] = {}
		end	
		table.insert(self.m_tMainStoneData[v.quality], v)
	end
	for i=1,#self.m_tMainStoneData do
		table.sort( self.m_tMainStoneData[i], function(a,b) return a.lv < b.lv end)
	end
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMountStoneStong:createElement(id, playerItemId)
	if WndMountStoneStong.m_root ~= nil then
		WindowManager:removeWindow(WndMountStoneStong.m_root, WndMountStoneStong, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMountStoneStong")
	assert(element, "WndMountStoneStong create element failed!")
	self:_init()
	self.m_nUpgradeID = id
	self.m_nPlayerItemId = playerItemId
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
