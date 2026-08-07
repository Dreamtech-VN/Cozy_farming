--WndGameGiftData.lua
--@brief	WndGameGift的数据模块
--@date		2015/04/28
--@author	binshao
--@note		设置界面的游戏兑换礼包

WndGameGift = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGameGift:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGameGift:_unInit()
    WZLog("WndGameGift:_unInit")
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGameGift:createElement()
	local element = WZUISystem:getInstance():createElement("WndGameGift")
	assert(element, "WndGameGift create element failed!")
	self:_init()
	return element
end

--@brief    设置外部接口
function WndGameGift:showInterface()
    -- body
    local wndGift = WndGameGift:createElement()
    if wndGift then 
        WindowManager:addWindow( wndGift , WndGameGift ) 
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------
