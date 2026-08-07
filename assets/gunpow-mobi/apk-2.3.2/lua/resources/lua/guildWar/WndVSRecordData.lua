--WndVSRecordData.lua
--@brief	WndVSRecord的数据模块
--@date		2017/02/22
--@author	Tianxiang_Xu
--@note		比赛回顾界面

WndVSRecord = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndVSRecord:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tData = nil 
    self.m_nGroupSelIndex = nil         --当前的组
    self.m_nRecordType = nil            --类型：1->小组赛；2->决赛
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndVSRecord:_unInit()
    self.m_root = nil
    self.m_tData = nil 
    self.m_nGroupSelIndex = nil
    self.m_nRecordType = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndVSRecord:createElement()
	local element = WZUISystem:getInstance():createElement("WndVSRecord")
	assert(element, "WndVSRecord create element failed!")
	self:_init()
	return element
end

--@brief    数据
--@param    nGroupIndex : 当前显示那个分组
--@param    nRecordType : 1->小组；2->决赛
function WndVSRecord:setData(tData, nGroupIndex, nRecordType)
    -- body
    self.m_tData = tData
    self.m_nGroupSelIndex = nGroupIndex
    self.m_nRecordType = nRecordType
    self:_update() 
end

--@brief    外部接口
function WndVSRecord:showInterface(tData, nGroupIndex, nRecordType)
    -- body
    local wndTemp = WndVSRecord:createElement()
    if wndTemp then
        WindowManager:addWindow(wndTemp, WndVSRecord, nil, nil, nil, true)
        WndVSRecord:setData(tData, nGroupIndex, nRecordType)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
