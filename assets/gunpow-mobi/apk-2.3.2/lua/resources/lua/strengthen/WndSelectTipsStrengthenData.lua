--WndSelectTipsStrengthenData.lua
--@brief	WndSelectTipsStrengthen的数据模块
--@date		2015/06/09
--@author	zsq
--@note		选择宝石或装备界面

WndSelectTipsStrengthen = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSelectTipsStrengthen:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nTipsTag = 1                 --窗口标志：1宝石窗口，2装备窗口
    self.m_tSelectEquip = nil           --选择的装备
    self.m_tSelectStone = nil           --选择的宝石
    self.m_tListData = {}               --
    self.m_tSelectItem = nil            -- 被选中的cell
    self.m_nInsetCostGold = 0           --镶嵌花费的金币
	self.m_nStoneType = nil				--镶嵌宝石类型
    self.m_nCostId = nil                --消耗的货币Id
    self.m_nGridIndex = nil             --时装铸魂格子索引
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndSelectTipsStrengthen:_unInit()
    self.m_root = nil
    self.m_nTipsTag = nil
    self.m_tSelectEquip = nil
    self.m_tSelectStone = nil
    self.m_tListData = nil
    self.m_tSelectItem = nil
    self.m_nInsetCostGold = nil
    self.m_nStoneType = nil
    self.m_nCostId = nil 
    self.m_nGridIndex = nil 
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSelectTipsStrengthen:createElement()
	local element = WZUISystem:getInstance():createElement("WndSelectTipsStrengthen")
	assert(element, "WndSelectTipsStrengthen create element failed!")
	self:_init()
	return element
end

--@brief    外部调用创建此窗口
--@param    tag:1宝石窗口，2装备窗口,3选择继承前装备,5套装元魂,6度假村源石,7度假村精灵
--@param    type:宝石或装备类别
function WndSelectTipsStrengthen:showSelectTips(tag,tData)
	WZLog("WndSelectTipsStrengthen:showSelectTips",tag,Serialize(tData))
	if self.m_root ~= nil then return end
    local selectTipsWin = WndSelectTipsStrengthen:createElement()
    self.m_nTipsTag = tag
    WindowManager:addWindow(selectTipsWin , WndSelectTipsStrengthen,nil,nil,nil,false)
    if tag == 1 then
        self:_initStoneTips(tData)
    elseif tag == 2 then
        self:_initEquipTips(tData)
    elseif tag == 3 then
        self:_initEquipFrom()
    elseif tag == 4 then
        self:_initMagicGemUp()
    elseif tag == 5 then
        self:_initSoulTips(tData)
    elseif tag == 6 then
        self:_initHVStoneTips(tData)
    elseif tag == 7 then
        self:_initHVSpirit(tData)
    end
end
-------------------------------------公有方法模块End----------------------------------------

