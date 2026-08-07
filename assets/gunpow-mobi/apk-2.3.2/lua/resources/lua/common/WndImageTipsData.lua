--WndImageTipsData.lua
--@brief	WndImageTips的数据模块
--@date		2023/03/11
--@author	nijinlin
--@note		创建一个显示图片的弹框

WndImageTips = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndImageTips:_init()
	self.m_root = nil	 	  			--场景根节点
	self.imagePath = nil 				--图片路径
	self.content = nil 					--描述
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndImageTips:_unInit()
	self.m_root = nil
	self.imagePath = nil 				--图片路径
	self.content = nil 					--描述
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndImageTips:createElement()
	if WndImageTips.m_root ~= nil then
		WindowManager:removeWindow(WndImageTips.m_root, WndImageTips, true)
	end
	local element = WZUISystem:getInstance():createElement("WndImageTips")
	assert(element, "WndImageTips create element failed!")
	self:_init()
	return element
end

function WndImageTips:show(path,content)
    WZLog("WndImageTips:show",path,content)
    local wndImageTips = WndImageTips:createElement()
    self.imagePath = path or self.imagePath
    self.content = content or self.content
    WindowManager:addWindow(wndImageTips , WndImageTips, nil, nil, nil,true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
