--WndIphonexTest.lua
--@brief    WndIphonexTest的UI模块
--@date     2017/12/11
--@author   莫剑峰
--@note     iphonex测试窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndIphonexTest:onEnter(element)
    WZLog("WndIphonexTest:onEnter")

	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndIphonexTest:onExit(element)
    WZLog("WndIphonexTest:onExit")
	self:_unInit()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------



-------------------------------------私有方法模块End----------------------------------------
