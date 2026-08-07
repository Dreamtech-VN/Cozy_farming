--CellGameSingInItemData.lua
--@brief	CellGameSingInItem的数据模块
--@date		2015/05/05
--@author	weidong_wu
--@note		签到列表

CellGameSingInItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellGameSingInItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.index = nil
	self.b_sign = nil 
	self.b_vipSign = nil 
	self.days = nil 
	self.m_clickItemIndex = 0 
	self.m_nLoadingID = nil 
	self.b_vipTimes = false 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellGameSingInItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.index = nil 
	self.b_sign = nil 
	self.b_vipSign = nil 
	self.days = nil 
	self.m_clickItemIndex = 0 
	self.m_nLoadingID = nil 
	self.b_vipTimes = false 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellGameSingInItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellGameSingInItem table create failed!")
	tNewObj:_init()
	
	 local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setAbsContentSize(GlobalMethod:CCSize(480,120))
    element:setLuaObjectIndex(tNewObj)
	element:setName("__CellGameSingInItem")
	return element,tNewObj
end

--@brief 	设置日期数据表
function CellGameSingInItem:setTabDate(index, m_tData,b_sign,b_vipSign ,days)
	self.m_tData = m_tData
	self.index = index
	self.b_sign = b_sign 
	self.b_vipSign = b_vipSign 
	self.days = days 
end

--@brief 	签到成功
function CellGameSingInItem:GameSignOk(days)
	WZLog("CellGameSingInItem:GameSignOk::"..days)
	CellGameSingInItem.m_current_click:_finishedLoading()
	WndGameSingIn:_setSignDays( days )
	--Add By Tianxiang_Xu 
	local Multiple = 1
	if CellGameSingInItem.m_current_click.b_sign == false then
		Multiple = 1
	else
		Multiple = 0
	end
	--End Add 
	CellGameSingInItem.m_current_click.days = days 
	CellGameSingInItem.m_current_click.b_sign = true 
	local index = CellGameSingInItem.m_current_click.m_clickItemIndex
	local vip_level = CellGameSingInItem.m_current_click.m_tData[index].vip_level 
	
	if vip_level > -1 then 
		local vipLevel =  CacheCenter:getPlayerInfo().vipLevel
		if vipLevel < vip_level then 
		   	CellGameSingInItem.m_current_click.b_vipSign = false  
		   	CellGameSingInItem.m_current_click:_SingIned(index,false,true) 
		   	CacheCenter:setSignCacheData(index,true)
        else 
        	Multiple = Multiple + 1
        	CellGameSingInItem.m_current_click.b_vipSign = true
        	local b_needDraw = CellGameSingInItem.m_current_click.b_vipTimes
        	b_needDraw = (not b_needDraw)
        	CellGameSingInItem.m_current_click:_SingIned(index,true,b_needDraw)
        	--Add By Tianxiang_Xu
        	if g_tTempSignData ~= nil then
        		g_tTempSignData.vipSign = true
        	end
        	--End Add
        end 
    else 
    	CellGameSingInItem.m_current_click.b_vipSign = false
    	CellGameSingInItem.m_current_click:_SingIned(index,true,false)
	end
    --签到后，移除红点
    WndWelfare:removeRedDot(79)
	local id =  CellGameSingInItem.m_current_click.m_tData[index].reward[1][1]
	local Num = CellGameSingInItem.m_current_click.m_tData[index].reward[1][2]*Multiple
	local IdTab = {}
	local NumTab = {}
	table.insert(IdTab,id)
	table.insert(NumTab,Num)
	WndRewardShow:showById(IdTab,NumTab)
    WndRewardShow:closeCallBack(CellGameSingInItem.m_current_click,nil) 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellGameSingInItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellGameSingInItem.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
