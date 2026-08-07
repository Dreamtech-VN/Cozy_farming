--WndFamilyShopData.lua
--@brief	WndFamilyShop的数据模块
--@date		2017/08/01
--@author	zsq
--@note		家园商店

WndFamilyShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFamilyShop:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nTag = nil
	self.m_tDataList = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFamilyShop:_unInit()
	self.m_root = nil
	self.m_nTag = nil
	self.m_tDataList = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFamilyShop:createElement()
	if WndFamilyShop.m_root ~= nil then
		WindowManager:removeWindow(WndFamilyShop.m_root, WndFamilyShop, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFamilyShop")
	assert(element, "WndFamilyShop create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	外部接口
function WndFamilyShop:showInterface()
	-- body
	local wnd = WndFamilyShop:createElement()
	if wnd then
		WindowManager:addWindow(wnd, WndFamilyShop, nil, nil, nil, true)
	end
end

function WndFamilyShop:setData(configId, freeTimes, currentNum, numLimit)
	self.m_tDataList = {}
	for i=1,#configId do
		local temp = {}
		temp.configId = configId[i]
		temp.freeTimes = freeTimes[i]
		temp.currentNum = currentNum[i]
		temp.numLimit = numLimit[i]
		table.insert(self.m_tDataList, temp)
	end
	WZLog("WndFamilyShop:setData",Serialize(self.m_tDataList))

	self:_update()
end


-------------------------------------私有方法模块End----------------------------------------
