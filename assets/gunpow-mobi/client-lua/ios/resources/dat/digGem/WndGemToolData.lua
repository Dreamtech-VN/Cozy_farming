--WndGemToolData.lua
--@brief	WndGemTool的数据模块
--@date		2017/03/13
--@author	Tianxiang_Xu
--@note		挖宝系统-工具界面

WndGemTool = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGemTool:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tToolList = nil 
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndGemTool:_unInit()
    self.m_root = nil
    self.m_tToolList = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGemTool:createElement()
	local element = WZUISystem:getInstance():createElement("WndGemTool")
	assert(element, "WndGemTool create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
function WndGemTool:showInterface()
    -- body
    local wndGemTool = WndGemTool:createElement()
    if wndGemTool then
        WindowManager:addWindow(wndGemTool, WndGemTool, nil, nil, nil, true)
    end
end

--@brief    设置数据
function WndGemTool:setData(tData)
    -- body
    self.m_tToolList = tData

    self:_update()
end

--@brief    监控矿晶数量变化
function WndGemTool:updateMoneyData()
    WZLog("WndGemTool:updateMoneyData")
    if self.m_root == nil then return end 
    
    self:_showGemCoin()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
