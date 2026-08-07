--WndDesignationMainData.lua
--@brief	WndDesignationMain的数据模块
--@date		2015/03/25
--@author	clc
--@note		成就系统-主界面

WndDesignationMain = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDesignationMain:_init()
	self.m_root = nil	 	  			 --场景根节点
	self.m_nCurrentTypeIndex = 0          --当前界面显示的类型
	self.m_nclickedMainClassicId = -1       --点击的成就面板主分类cell的tag
	self.m_nclickedDesignatin  = -1       --点击的称号面板分类cell的tag
	self.m_tDesignationList    = nil      --称号列表

	self.m_tAchieMentList      = nil       --成就列表
	self.m_tAcSubTable         = nil       --成绩列表保留点击的子分类table

	self.m_nLoadingId          = nil       --加载框ID

	self.m_bHaveNewDesi			= g_bHaveNewDesi 		--用来标记称号选项卡右上角是否显示红点提示有新称号
	self.m_nLeftAchiePoints = nil 	--当前剩余成就点数
	self.m_nTotalAchiePoints = nil  --总成就点
	self.m_nFinishAchiePoints = nil --已完成成就点
	self.m_tBadgeList = nil 	--徽章列表

	self.m_tCurLoadList = nil 	--正在加载的成就
	self.m_leftActiveCell = nil 	--主类点中的cell
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDesignationMain:_unInit()
	self.m_root = nil
	self.m_nCurrentTypeIndex = nil          --当前界面显示的类型
	self.m_nclickedMainClassicId = nil       --点击的成就面板主分类cell的tag
	self.m_nclickedDesignatin  = nil       --点击的称号面板分类cell的tag
	self.m_tDesignationList    = nil      --称号列表

	self.m_tAchieMentList      = nil       --成就列表
	self.m_tAcSubTable         = nil       --成绩列表保留点击的子分类table

	self.m_nLoadingId          = nil       --加载框ID

    self.m_bHaveNewDesi			= nil 		--用来标记称号选项卡右上角是否显示红点提示有新称号
    self.m_nLeftAchiePoints = nil 
    self.m_nTotalAchiePoints = nil  --总成就点
	self.m_nFinishAchiePoints = nil --已完成成就点
	self.m_tBadgeList = nil 	--徽章列表

	self.m_tCurLoadList = nil 	--正在加载的成就
	self.m_leftActiveCell = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDesignationMain:createElement()
	local element = WZUISystem:getInstance():createElement("WndDesignationMain")
	assert(element, "WndDesignationMain create element failed!")
	self:_init()
	return element
end

--@brief 	显示tip信息
function WndDesignationMain:_addTip(tItem,element,pCell)
	if tItem == nil or element == nil or pCell == nil then
		return
	end
	WndItemInfo:showInfo(element,pCell,1,tItem)
end

--@brief 	外部接口
function WndDesignationMain:showWin(index)
	-- body
	local conSubWin = GetElement(WndBagMain.m_root, "conSubWin", WZUIContainer)
	if conSubWin then
		local wndDesignationElement = WndDesignationMain:createElement()
	    if wndDesignationElement then 
	    	self.m_nCurrentTypeIndex = index or 0
	        conSubWin:addChild(wndDesignationElement)
	    end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	返回特殊称号列表中红点的称号的索引
function WndDesignationMain:_getRedDotDesi()
	-- body
	local nIndex = 1 

	for i = 1, #self.m_tDesignationList do
		if self.m_tDesignationList[i].status == 3 then 
			nIndex = i
			break 
		end
	end

	return nIndex 
end

-------------------------------------私有方法模块End----------------------------------------
