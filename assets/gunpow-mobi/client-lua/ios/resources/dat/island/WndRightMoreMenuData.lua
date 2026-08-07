--WndRightMoreMenuData.lua
--@brief	WndRightMoreMenu的数据模块
--@date		2014/08/27
--@author	zyx
--@note		右边更多菜单显示

WndRightMoreMenu = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRightMoreMenu:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tBtnsInfo = nil 				--按钮信息表
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRightMoreMenu:_unInit()
	self.m_root = nil
	self.m_tBtnsInfo = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRightMoreMenu:createElement()
	local element = WZUISystem:getInstance():createElement("WndRightMoreMenu")
	assert(element, "WndRightMoreMenu create element failed!")
	self:_init()
	--遮罩容器
	local conWndRightMenu = element:getChildElement("conWndRightMenu_WndRightMoreMenu")
    if conWndRightMenu ~= nil then
        conWndRightMenu:removeFromParentAndCleanup(true)
        local clipCon = WZUIClippingContainer:create()
        local subCon = WZUIContainer:create()
        subCon:setUseAbsSize(true)
        subCon:setAbsContentSize(CCSizeMake(500,550))
        local img = WZUIImage:create()
        img:setFile("common/Jigsaw/6.png")
        clipCon:setStencil(subCon)
        subCon:addChild(img)
        clipCon:addChild(conWndRightMenu)
        element:addChild(clipCon)
    end
	return element
end

--@brief	设置更多按钮弹出框信息
--@param	tBtnsInfo，按钮信息表
function WndRightMoreMenu:setBtnsInfo(tBtnsInfo)
	self.m_tBtnsInfo = {}
	 for i,data in ipairs(tBtnsInfo) do 
			local temp = {}
			temp.buttonId = data.buttonId
			temp.buttonType = data.buttonType
			temp.IsHighlight = data.IsHighlight
			temp.buttonSort = data.buttonSort
			temp.buttonStatus1Level = data.buttonStatus1Level
			temp.buttonStatus2Level = data.buttonStatus2Level
			temp.buttonStatus3Level = data.buttonStatus3Level
			temp.buttonTips = data.buttonTips
			if temp.buttonId ~= 40 and temp.buttonId ~=46 and temp.buttonId ~=22 and temp.buttonId ~= 44 then
				table.insert(self.m_tBtnsInfo,temp)
			end
	end
	
    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	对按钮按照排序值排序
function WndRightMoreMenu:_sortButton()
    if self.m_tBtnsInfo[1].buttonSort == nil then
        return
    end
    local sortFunc = function(a, b)
        return a.buttonSort < b.buttonSort
    end
    table.sort(self.m_tBtnsInfo, sortFunc)
end




-------------------------------------私有方法模块End----------------------------------------
