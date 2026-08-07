--WndFourStarLabraryData.lua
--@brief	WndFourStarLabrary的数据模块
--@date		2021/02/24
--@author	hyx
--@note		图鉴

WndFourStarLabrary = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFourStarLabrary:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tChipContainer = {}
	self.m_tChipData = {}
	self.m_tChipMaskItem = {}
	self.m_tChipLightPos = {} --点亮的碎片
	self.m_nLightUpIndex = 0
	self.m_sLightUpSpine = nil
	self.m_sLightUpResultSpine = nil
	self.m_nLightResultIndex = 1
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFourStarLabrary:_unInit()
	self.m_root = nil
	self.m_tChipContainer = {}
	self.m_tChipData = {}
	self.m_tChipMaskItem = {}
	self.m_tChipLightPos = {}
	self.m_nLightUpIndex = 0
	self.m_sLightUpSpine = nil
	self.m_sLightUpResultSpine = nil
	self.m_nLightResultIndex = 1
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFourStarLabrary:createElement()
	if WndFourStarLabrary.m_root ~= nil then
		WindowManager:removeWindow(WndFourStarLabrary.m_root, WndFourStarLabrary, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFourStarLabrary")
	assert(element, "WndFourStarLabrary create element failed!")
	self:_init()
	return element
end

function WndFourStarLabrary:setChipData( data )
	for i=1,4 do
		local tab = {}
		tab.pieceCount = data.pieceCounts[i]
		tab.pieceTarget = data.pieceTargets[i]
		self:setChipPieceData(i,data['pieces'..i])
		tab.precesNum = #data['pieces'..i]
		self.m_tChipData[i] = tab
	end
end
function WndFourStarLabrary:setChipPieceData(index,data)
	if self.m_tChipLightPos[index] == nil then
		self.m_tChipLightPos[index] = {}
	end
	--位置从0开始所以客户端要加1
	for i,v in pairs(data) do
		self.m_tChipLightPos[index][v+1] = true
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
