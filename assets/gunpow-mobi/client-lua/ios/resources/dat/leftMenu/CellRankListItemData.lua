--CellRankListItemData.lua
--@brief	CellRankListItem的数据模块
--@date		2015/04/22
--@author	hyq
--@note		排行榜标签格子

CellRankListItem = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellRankListItem:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nRankListType = nil          --排行榜类型
    self.m_bIsLoad = false
    self.m_bIsHighLight = nil           --是否高亮

    self.m_tItemName = {}
    self.m_tItemName[111] = LocalStrings.RANKLIST_ITEM_MRT       --名人堂
    self.m_tItemName[222] = LocalStrings.RANKLIST_ITEM_RYD       --荣誉殿
    self.m_tItemName[333] = LocalStrings.RANKLIST_ITEM_SJH       --设计汇
    self.m_tItemName[1]   = LocalStrings.RANKLIST_ITEM_ZHANLI    --战力榜
    self.m_tItemName[2]   = LocalStrings.RANKLIST_ITEM_DENGJI    --等级榜
    self.m_tItemName[3]   = LocalStrings.RANKLIST_ITEM_CHONGWU   --宠物榜
    self.m_tItemName[4]   = LocalStrings.RANKLIST_ITEM_ZUOQI     --坐骑榜
    self.m_tItemName[11]  = LocalStrings.RANKLIST_ITEM_ZHANJI    --战迹榜
    self.m_tItemName[12]  = LocalStrings.ATHLETICS_LIST          --胜绩榜
    self.m_tItemName[13]  = LocalStrings.RANKLIST_ITEM_CHENGJIU  --成就榜
    self.m_tItemName[14]  = LocalStrings.RANKLIST_ITEM_GONGHUI   --公会榜
    self.m_tItemName[21]  = LocalStrings.RANKLIST_ITEM_MEILI     --魅力榜
    self.m_tItemName[22]  = LocalStrings.RANKLIST_ITEM_SHIDE     --师德榜
    self.m_tItemName[23]  = LocalStrings.RANKLIST_ITEM_ENAI      --恩爱榜
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRankListItem:_unInit()
	self.m_root = nil
    self.m_nRankListType = nil
    self.m_tItemName = nil
    self.m_bIsLoad = nil
    self.m_bIsHighLight = nil           --是否高亮
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellRankListItem:createElement()
    local tNewObj = self:_new()
    assert(tNewObj, "CellRankListItem table create failed!")
    tNewObj:_init()
	
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellRankListItem")
    element:setAbsContentSize(GlobalMethod:CCSize(184,76))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end


--@brief    初始化cell数据
function CellRankListItem:initCellData(nType)
    WZLog("CellRankListItem:initCellData",nType)
    if self.m_root == nil then
        WZLog("self.m_root == nil")
        return
    end
    --保存Cell所表示的排行榜类型
    self.m_nRankListType = nType
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@param	新建的表实例对象
function CellRankListItem:_new( )
    local tNewObj = {}
    setmetatable(tNewObj, self)
    self.__index = self
    return tNewObj
end



-------------------------------------私有方法模块End----------------------------------------
