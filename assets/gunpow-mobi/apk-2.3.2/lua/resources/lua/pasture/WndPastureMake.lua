--WndPastureMake.lua
--@brief	WndPastureMake的UI模块
--@date		2021/04/17
--@author	hyx
--@note		牧场道具制作


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPastureMake:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPastureMake:onExit(element)
	self:_unInit()
end
--打开界面
function WndPastureMake:showInterface(tableid)   
	local wndMake = WndPastureMake:createElement(tableid)
	if wndMake ~= nil then
	    WindowManager:addWindow(wndMake,WndPastureMake,nil,false)
	end
end

function WndPastureMake:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndPastureMake:actionCallback()
	self:initShow()
end
function WndPastureMake:initShow()
	local data = self:setMakeItemData(  )
	local makeTableContainer = GetElement(self.m_root,"makeTableContainer",WZUITableContainer)
	makeTableContainer:cleanTable()
	for i = 1, #data do
        local element, obj = PastureMakeItem:createElement()
        element:setTag(i - 1)
        makeTableContainer:setCellElement(element)
        obj:setCellMakeItemData(self.m_nTableId,data[i])
    end
end

function WndPastureMake:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
