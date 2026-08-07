--WndMountStoneData.lua
--@brief	WndMountStone的数据模块
--@date		2021/04/28
--@author	hyx
--@note		坐骑灵石

WndMountStone = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMountStone:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tBagItemTitle = {}
	self.m_n_BagItemIndex = nil
	self.m_nCurTouchStoneIndex = nil --当前点击灵石
	self.m_tMountStoneBaseData = {} --基础数据
	self.m_tOpenView = {}
	self.m_sRightContainer = nil
	self.m_tStoneQualityChip = {} --8块碎片
	self.m_tStonePutOnTypeItem = {} --灵石的副石属性类型
	self.m_tStoneBagData = {} --灵石在背包的数据
	self.m_tStoneSourceBagData = {} --灵石之源在背包的数据
	self.m_sStoneContainer1 = nil
	self.m_StoneContainer2 = nil
	self.m_sTxtFreeStone = nil
	self.m_tSlotCellItem = {} --副槽安装的物品
	self.m_tMainStoneCellWearStatus = {} --是否已装备
	self.m_tMainStoneCellItem = {} --主槽的物品保存
	self.m_nCurFighting = 0
	self.m_tUseAccStoneData = {} --已经使用的副石
	self.m_tCellMainStoneRedPoint = {}
	self.m_tMainStoneRedpointData = {} --主石的红点信息
	self.m_tImgPosStone = {} --是否有镶嵌的小石头
	self.m_tTxtAttrRich = {} --属性的富文本
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMountStone:_unInit()
	self.m_root = nil
	self.m_tBagItemTitle = {}
	self.m_n_BagItemIndex = nil
	self.m_nCurTouchStoneIndex = nil
	self.m_tMountStoneBaseData = {}
	self.m_tOpenView = {}
	self.m_sRightContainer = nil
	self.m_tStoneQualityChip = {}
	self.m_tStonePutOnTypeItem = {}
	self.m_tStoneBagData = {}
	self.m_tStoneSourceBagData = {}
	self.m_sStoneContainer1 = nil
	self.m_StoneContainer2 = nil
	self.m_sTxtFreeStone = nil
	self.m_tSlotCellItem = {}
	self.m_tMainStoneCellWearStatus = {}
	self.m_tMainStoneCellItem = {}
	self.m_nCurFighting = 0
	self.m_tUseAccStoneData = {}
	self.m_tMainStoneRedpoint = {}
	self.m_tImgPosStone = {}
	self.m_tTxtAttrRich = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMountStone:createElement()
	if WZFileUtil:isFileExist("pack/mountstone/pack_mountstone_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/mountstone/pack_mountstone_0.plist")
    end
	if WndMountStone.m_root ~= nil then
		WindowManager:removeWindow(WndMountStone.m_root, WndMountStone, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMountStone")
	assert(element, "WndMountStone create element failed!")
	self:_init()
	return element
end

--已经在使用的灵石之源
function WndMountStone:getUseStoneSourceData()
	return self.m_tUseAccStoneData
end
--获取灵石之源
local table_insert = table.insert
function WndMountStone:getSourceStoneData()
	local data = CacheCenter:getMountStoneSourceList()
	--筛选已经安装的
	local temp_data = {}
	for i, v in pairs(data) do
		if self.m_tUseAccStoneData[v.playerItemId] == nil then
			table_insert(temp_data, v)
		end
	end
	return temp_data
end
function WndMountStone:getMountStoneTips()
	if self.m_tMountStoneBaseData then
		return self.m_tMountStoneBaseData[self.m_nCurTouchStoneIndex]
	end
end
--获取安装灵石的战力
function WndMountStone:getUpMountStone()
	return self.m_tMountStoneBaseData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
