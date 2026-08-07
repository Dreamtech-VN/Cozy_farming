--WndActivityMenuData.lua
--@brief	WndActivityMenu的数据模块
--@date		2014/09/01
--@author	周亚茜
--@note		活动菜单

WndActivityMenu = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndActivityMenu:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tBtnsInfo = nil 				--按钮信息表
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndActivityMenu:_unInit()
	self.m_root = nil
	self.m_tBtnsInfo = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndActivityMenu:createElement()
	local element = WZUISystem:getInstance():createElement("WndActivityMenu")
	assert(element, "WndActivityMenu create element failed!")
	self:_init()
	
	local conActivityMenu = element:getChildElement("conActivityMenu_WndActivityMenu")
    if conActivityMenu ~= nil then
        conActivityMenu:removeFromParentAndCleanup(true)
        local clipCon = WZUIClippingContainer:create()
        local subCon = WZUIContainer:create()
        subCon:setUseAbsSize(true)
        subCon:setAbsContentSize(CCSizeMake(500,120))
        local img = WZUIImage:create()
        img:setFile("common/Jigsaw/6.png")
        clipCon:setStencil(subCon)
        subCon:addChild(img)
        clipCon:addChild(conActivityMenu)
        element:addChild(clipCon)
    end
	
	return element
end


--@brief	设置活动菜单按钮信息
--@param	tBtnsInfo，按钮信息表
function WndActivityMenu:setBtnsInfo(tBtnsInfo)
	if tBtnsInfo == nil then 
		return 
	end
    self.m_tBtnsInfo = tBtnsInfo
    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
