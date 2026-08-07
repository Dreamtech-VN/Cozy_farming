--WndwardrobeData.lua
--@brief	Wndwardrobe的数据模块
--@date		2016/08/17
--@author	zsq
--@note		衣橱

Wndwardrobe = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function Wndwardrobe:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDressGrid = nil
	self.conPlayer = nil
	self.m_tIDList = nil
	self.m_tCellDressSuit = nil 		--多套时装的cell
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function Wndwardrobe:_unInit()
	self.m_root = nil
	self.m_tDressGrid = nil
	self.conPlayer = nil
	self.m_tIDList = nil
	self.m_tCellDressSuit = nil 		--多套时装的cell
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function Wndwardrobe:createElement()
	local element = WZUISystem:getInstance():createElement("Wndwardrobe")
	assert(element, "Wndwardrobe create element failed!")
	self:_init()
	return element
end

--@brief 	更新多套时装数据
function Wndwardrobe:updateDressSuitData(nType)
    -- body
    if self.m_tCellDressSuit == nil then return end 
    if nType == 1 then
    	self.m_tCellDressSuit:changeDressSuitOK()
    else
    	self.m_tCellDressSuit:setSuitData()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	缓存推送更新物品时调用的函数
function Wndwardrobe:updatePlayerItemData()
	WZLog("Wndwardrobe:updatePlayerItemData")
	if self.m_root == nil then return end
	self:update()
end

--@brief   添加人物形象和装备栏
function Wndwardrobe:_addPlayer()
	local conPlayer = self.m_root:getChildElement("conRole_Wndwardrobe")
	if conPlayer:getChildByTag(20) then
		conPlayer:removeChildByTag(20,true)
	end
	local celElement = WndPlayer:createElement()
	celElement:setTag(20)
	conPlayer:addChild(celElement)
end

function Wndwardrobe:onVIP(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then return end
	local tData = CacheCenter:getPlayerInfo()
	local vipLevel = tData.vipLevel
	local tData = {vipLevel=vipLevel,other=self.m_bCheckOther,id=tData.id}
	WndTips:show(element,self.m_root,20,tData,GlobalMethod:ccp(65,70))
	WndTips.m_root:setShowAll(true)
end

-------------------------------------私有方法模块End----------------------------------------
