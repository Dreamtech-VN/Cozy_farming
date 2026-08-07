--WndKidDressData.lua
--@brief	WndKidDress的数据模块
--@date		2018/05/09
--@author	Tianxiang_Xu
--@note		小孩时装界面

WndKidDress = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKidDress:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurrentIndex = nil 			--当前选中的时装类型索引
	self.m_tDressGrid = nil				--孩子时装格子绑定的表
	self.m_tCurKidData = nil 			--当前展示的小孩的信息
	self.m_bIsOpenList = false 			--是否展开孩子列表
	self.m_nodeKidSel = nil 
	self.m_nKidIndex = 1 				--当前展示的孩子索引
	self.m_tTryWearList = nil 			--试穿格子	
	self.m_tTempList = nil 
	self.m_tDressList = nil 
	self.conPlayer = nil 
	self.m_tTryClothesData = nil 		--试穿的时装的数据
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKidDress:_unInit()
	self.m_root = nil
	self.m_nCurrentIndex = nil
	self.m_tDressGrid = nil	
	self.m_tCurKidData = nil
	self.m_bIsOpenList = nil 
	self.m_nodeKidSel = nil 
	self.m_nKidIndex = nil				--当前展示的孩子索引
	self.m_tTryWearList = nil
	self.m_tTempList = nil 
	self.m_tDressList = nil 
	self.conPlayer = nil 
	self.m_tTryClothesData = nil 		--试穿的时装的数据
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKidDress:createElement()
	if WndKidDress.m_root ~= nil then
		WindowManager:removeWindow(WndKidDress.m_root, WndKidDress, true)
	end
	local element = WZUISystem:getInstance():createElement("WndKidDress")
	assert(element, "WndKidDress create element failed!")
	self:_init()
	return element
end

--@brief	时装数量变化后，刷新数量
function WndKidDress:updatePlayerHomeItemData()
	--body
	if self.m_root == nil then return end 
	WZLog("WndKidDress:updatePlayerHomeItemData")
	--重新刷新列表
	self:updateDressGrid()
	self:updateDress()
end

function WndKidDress:updateKidDressAni()
	--body
	WZLog("WndKidDress:updateKidDressAni")
	if self.m_root == nil then return end 

	self:showKidAni()
	self:showFighting()
	self:updateDressGrid()
	self:updateDress()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
