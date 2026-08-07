--WndPelletChipData.lua
--@brief	WndPelletChip的数据模块
--@date		2021/09/13
--@author	hyx
--@note		回忆录

WndPelletChip = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPelletChip:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGiftReward = nil --童年礼物
	self.m_tLightData = {} --是否点亮
	self.m_tPhotoIdData = {}
	self.m_tLightChipData = {}
	self.m_nCurLibraryIndex = 1 --当前图鉴
	self.m_tNeedMemPiecesNums = {} --需要开启的碎片数量
	self.m_nChipNumbers = 0--碎片的数量
	self.m_tChipItem = {}
	self.m_nNextCurIndex = nil
	self.m_nCurMaxIndex = 1 --当前解锁到的最高图鉴
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPelletChip:_unInit()
	self.m_root = nil
	self.m_tGiftReward = nil
	self.m_tLightData = {}
	self.m_tPhotoIdData = {}
	self.m_tLightChipData = {}
	self.m_nCurLibraryIndex = 1
	self.m_tNeedMemPiecesNums = {}
	self.m_nChipNumbers = 0
	self.m_tChipItem = {}
	self.m_nNextCurIndex = nil
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPelletChip:createElement()
	if WndPelletChip.m_root ~= nil then
		WindowManager:removeWindow(WndPelletChip.m_root, WndPelletChip, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPelletChip")
	assert(element, "WndPelletChip create element failed!")
	self:_init()
	return element
end

--处理图鉴的数据
function WndPelletChip:setChipData(indexs, data)
	for i=1,#indexs do
		local slot = data[indexs[i]].slot
		local state = data[indexs[i]].state
		self.m_tLightChipData[indexs[i]] = {}
		for m=1,#slot do
			self.m_tLightChipData[indexs[i]][slot[m]] = state[m]
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
