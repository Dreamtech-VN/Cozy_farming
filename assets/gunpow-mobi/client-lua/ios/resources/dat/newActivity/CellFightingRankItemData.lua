--CellFightingRankItemData.lua
--@brief	CellFightingRankItem的数据模块
--@date		2017/08/23
--@author	Tianxiang_Xu
--@note		战力月榜之王活动-展示子节点cell

CellFightingRankItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellFightingRankItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_bIsLoaded = false 
	self.m_tPlayerAni = nil 
	self.m_nloadingId = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFightingRankItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_bIsLoaded = nil 
	self.m_tPlayerAni = nil 
	self.m_nloadingId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellFightingRankItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellFightingRankItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellFightingRankItem")
	element:setAbsContentSize(GlobalMethod:CCSize(140,290))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
function CellFightingRankItem:setData(tData)
	-- body
	self.m_tData = tData 
end

function CellFightingRankItem:receiveWorshipOK(vigor, result)
    -- body
    MsgBoxManager:stopLoadingBoxByMsgId(CellFightingRankItem.m_current_click.m_nloadingId)
    if result == 1 then
        local sWorshipResult = string.format(LocalStrings.WORSHIP_SUCCESS, vigor)
        MsgBoxManager:showTipBox(sWorshipResult)
        self:updateWorshipTime()
    else
        MsgBoxManager:showTipBox(LocalStrings.HAVED_WORSHIP_TODAY)
        WZLog("******** Worship Failed ! ********")
    end
end

--@brief    更新膜拜次数
function CellFightingRankItem:updateWorshipTime()
    -- body
    CellFightingRankItem.m_current_click.m_tData.worshipNum = CellFightingRankItem.m_current_click.m_tData.worshipNum + 1
    CellFightingRankItem.m_current_click:_showWorshipTimes()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFightingRankItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
