--WndRewardShowData.lua
--@brief	WndRewardShow的数据模块
--@date		2014/09/01
--@author	张盛强
--@note		显示获得的奖励物品

WndRewardShow = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRewardShow:_init()
	self.m_root = nil	 	  			--场景根节点
    self.info = {}
	self.backFunc = nil
	self.sendFunc = nil                 --赠送回调函数
	self.explainFunc = nil              --说明回调函数
    self.m_nDisplayType = 4             
    self.m_nSelectItemId = nil          --当前选择的物品ID
    self.m_tSelectCell = nil
    self.m_bIsShowBySendGift = false
    self.m_nTaskId = nil
    self.m_bIsTeach = nil
	self.conversion = nil
	self.m_bIsShowExchangeText = nil 
	self.fashionCount = nil 
	self.m_tGoodElementList = nil 	--奖励的节点列表
	self.m_nodeMoveTo = nil 			--奖励的物品要移动到的节点
	self.m_nAniIndex = 1 
	self.m_bIsClickClose = false 
	self.m_bIsPvpRankDrop = nil 
	self.m_sAttWord = ""
	self.m_type = nil 					--1为爬塔结算页面自动弹出的奖励窗口
	self.m_sRewardEffect = nil
	self.m_tOpenNowBox = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRewardShow:_unInit()
	self.m_root = nil
    self.info = nil
	self.backFunc = nil
	self.sendFunc = nil
	self.explainFunc = nil
    self.m_nDisplayType = nil
    self.m_nSelectItemId = nil
    self.m_bIsShowBySendGift = nil
    self.m_tSelectCell = nil
    self.m_nTaskId = nil
    self.m_bIsTeach = nil
	self.conversion = nil
	self.m_bIsShowExchangeText = nil 
	self.fashionCount = nil
	self.m_tGoodElementList = nil 
	self.m_nodeMoveTo = nil 
	self.m_nAniIndex = nil 
	self.m_bIsClickClose = nil 
	self.m_bIsPvpRankDrop = nil 
	self.m_sAttWord = nil 
	self.m_type = nil
	self.m_sRewardEffect = nil
	self.m_tOpenNowBox = nil 
end

--@brief   设置关闭回调
function WndRewardShow:closeCallBack(tcell,backFunc, tCellGameActivity, backFuncGameActivity)
	-- body
	if tcell and backFunc then
		self.backFunc = {}
		self.backFunc[1] = tcell
		self.backFunc[2] = backFunc
        --专为活动设置的回调，调用显示快捷装备窗口，如果有
        if tCellGameActivity and backFuncGameActivity then
            self.backFunc[3] = tCellGameActivity
            self.backFunc[4] = backFuncGameActivity
        end
	end
end

--@brief  发送按钮回调
function WndRewardShow:setSendGiftCallBack(tcell,backFunc)
	if tcell and backFunc then
		self.sendFunc = {}
		self.sendFunc[1] = tcell
		self.sendFunc[2] = backFunc
	end
end

--@brief  说明回调
function WndRewardShow:setExplainCallBack(tcell,backFunc)
	if tcell and backFunc then
		self.explainFunc = {}
		self.explainFunc[1] = tcell
		self.explainFunc[2] = backFunc
	end
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRewardShow:createElement()
    local element = WZUISystem:getInstance():createElement("WndRewardShow")
    assert(element, "WndRewardShow create element failed!")
    self:_init()
    return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------
