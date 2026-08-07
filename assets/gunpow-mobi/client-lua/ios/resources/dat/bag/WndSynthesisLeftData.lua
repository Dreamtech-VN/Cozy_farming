--WndSynthesisLeftData.lua
--@brief	WndSynthesisLeft的数据模块
--@date		2015/07/17
--@author	zsq
--@note		合成系统左侧窗口

WndSynthesisLeft = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSynthesisLeft:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tPutItem = nil               --已摆放的道具lua对象
    self.m_tResultItem = nil            --合成结果道具lua对象
    self.m_tMergeInfo = nil             --当前道具合成信息表（从LocalData读取）
	--self.m_bQuick = nil
	self.m_nTag = nil
	self.m_tData = nil
	self.m_nMId = nil
	self.m_nMergeNum = nil
	self.m_nMergeMax = nil
	self.m_bHasSkin = nil
	self.m_tItemIdNum = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSynthesisLeft:_unInit()
	self.m_root = nil
    self.m_tPutItem = nil               --已摆放的道具lua对象
    self.m_tResultItem = nil            --合成结果道具lua对象
    self.m_tMergeInfo = nil             --当前道具合成信息表（从LocalData读取）
	--self.m_bQuick = nil
	self.m_nTag = nil
	self.m_tData = nil
	self.m_nMId = nil
	self.m_nMergeNum = nil
	self.m_nMergeMax = nil
	self.m_bHasSkin = nil
	self.m_tItemIdNum = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSynthesisLeft:createElement()
	local element = WZUISystem:getInstance():createElement("WndSynthesisLeft")
	assert(element, "WndSynthesisLeft create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	根据id获取合成信息表
--@param    nId, 材料id
--@note		从LocalData读取合成信息表
function WndSynthesisLeft:_getMergeInfo(nId)
    if GDatatab_itemmerge == nil then
        return
    end
    return GDatatab_itemmerge["id_"..nId]
end

--@brief	根据id获取道具信息表
--@param    nId, 道具id
--@return	#1,道具信息表
--@note     从LocalData读取道具信息表
function WndSynthesisLeft:_getItemInfo(nId)
    if GDatatab_item == nil then
        return
    end
    return GDatatab_item["id_"..nId]
end




-------------------------------------私有方法模块End----------------------------------------
