--SceneCopyTurnCardData.lua
--@brief	SceneCopyTurnCard的数据模块
--@date		2015/04/20
--@author	xiaoyu_wu
--@note		副本翻牌界面

SceneCopyTurnCard = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneCopyTurnCard:_init()
	self.m_root = nil	 	  			--场景根节点
    
    self.m_tCardObjList = nil           --翻牌lua对象列表
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneCopyTurnCard:_unInit()
	self.m_root = nil
    
    self.m_tCardObjList = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneCopyTurnCard:createElement()
	local element = WZUISystem:getInstance():createElement("SceneCopyTurnCard")
	assert(element, "SceneCopyTurnCard create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
