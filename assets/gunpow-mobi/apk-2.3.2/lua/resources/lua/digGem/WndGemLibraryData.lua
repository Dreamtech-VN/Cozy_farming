--WndGemLibraryData.lua
--@brief	WndGemLibrary的数据模块
--@date		2017/03/13
--@author	Tianxiang_Xu
--@note		挖宝系统-图鉴界面

WndGemLibrary = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGemLibrary:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tGemLibraryList = nil 
    self.m_tCellList = nil 
    self.m_nSelItemTag = 0 
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndGemLibrary:_unInit()
    self.m_root = nil
    self.m_tGemLibraryList = nil 
    self.m_tCellList = nil 
    self.m_nSelItemTag = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGemLibrary:createElement()
	local element = WZUISystem:getInstance():createElement("WndGemLibrary")
	assert(element, "WndGemLibrary create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
function WndGemLibrary:showInterface()
    -- body
    local wndGemLibrary = WndGemLibrary:createElement()
    if wndGemLibrary then
        WindowManager:addWindow(wndGemLibrary, WndGemLibrary, nil, nil, nil, true)
    end
end

--@brief    设置数据
function WndGemLibrary:setData()
    -- body
    self.m_tGemLibraryList = {}
    self.m_tCellList = {}
    local nMaxLevel = self:getMaxLevel()

    for i, value in pairs(GDatatab_treasure) do
        local tItem = {}
        local basicInfo = GDatatab_item["id_" .. value.id]
        tItem.id = value.id
        tItem.appraisal_price = value.appraisal_price
        tItem.sLevel = value.activation_pro_level
        if value.end_pro_level > nMaxLevel then
            tItem.eLevel = nMaxLevel
        else
            tItem.eLevel = value.end_pro_level
        end
        tItem.basicInfo = CopyTable(basicInfo)

        table.insert(self.m_tGemLibraryList, tItem)
    end
    table.sort( self.m_tGemLibraryList, function (a, b)
        -- body
        if a.basicInfo.quality ~= b.basicInfo.quality then
            return a.basicInfo.quality < b.basicInfo.quality
        else
            return a.id < b.id
        end
    end )
    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    获取最大熟练度等级
function WndGemLibrary:getMaxLevel()
    -- body
    local nMaxLevel = 0 

    for i, value in pairs(GDatatab_proficiency) do
        if value.level > nMaxLevel then
            nMaxLevel = value.level
        end
    end

    return nMaxLevel 
end




-------------------------------------私有方法模块End----------------------------------------
