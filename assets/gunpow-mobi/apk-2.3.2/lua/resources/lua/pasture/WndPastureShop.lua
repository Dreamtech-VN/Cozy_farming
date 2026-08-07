--WndPastureShop.lua
--@brief	WndPastureShop的UI模块
--@date		2021/04/17
--@author	hyx
--@note		牧场商店


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPastureShop:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPastureShop:onExit(element)
	self:_unInit()
end
--打开界面
function WndPastureShop:showInterface()   
	local wndShop = WndPastureShop:createElement()
	if wndShop ~= nil then
	    WindowManager:addWindow(wndShop,WndPastureShop,nil,false)
	end
end

function WndPastureShop:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndPastureShop:actionCallback()
	self:initShow()
end
function WndPastureShop:initShow()
	local shopTableContainer = GetElement(self.m_root,"shopTableContainer",WZUITableContainer)
	shopTableContainer:cleanTable()
	self:setPastureShopData()
	local num = WndPastureBusiness:getCoinNumber()
	self:setChangeCoin(num)
	local cur_num = WndPastureBusiness:getHasMountNum()
	local level = WndPastureBusiness:getPastureLevel()
	local lev_info = WndPastureBusiness:getPastureLevelExp(level)
	if lev_info then
		self:setChangeMountNum(cur_num, lev_info.num)
	end

	for i=1, #self.m_tShopData do
		local cellElement, itemObj = PastureShopItem:createElement()
		cellElement:setTag(i-1)
		shopTableContainer:setCellElement(cellElement)
		itemObj:setCellShopData(self.m_tShopData[i])
	end
	local min_y = shopTableContainer:getMinPosition().y
	local max_lev = WndPastureBusiness:getCurPastureMountMaxLevel()
	max_lev = max_lev - 3
	if max_lev <= 0 then
		max_lev = 1
	end
	local index = math.ceil(max_lev/3)
	shopTableContainer:getMoveElement():setPositionY(min_y + (245 * (index - 1)))
end
--金币和牧场数量的变化
function WndPastureShop:setChangeCoin(num)
	if not self.m_root then return end
	local txtRemainCoin = GetElement(self.m_root,"txtRemainCoin",WZUIFreeTextBox)
	local tabItem = GDatatab_item["id_97"]
	if tabItem then
		txtRemainCoin:setShowText(string.format([[<I Z="0.5">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]],tabItem.icon,num))
	end
end
function WndPastureShop:setChangeMountNum(cur_num, totle_num)
	if not self.m_root then return end
	local txtMountNum = GetElement(self.m_root,"txtMountNum",WZUIFreeTextBox)
	txtMountNum:setShowText(string.format([[<I Z="0.5">shopitems/horse_0001.png</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d/%d</T>]],cur_num, totle_num))
end

function WndPastureShop:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
