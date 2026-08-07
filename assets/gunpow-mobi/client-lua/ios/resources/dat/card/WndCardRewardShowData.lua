--WndCardRewardShowData.lua
--@brief	WndCardRewardShow的数据模块
--@date		2016/08/01
--@author	Tianxiang_Xu
--@note		卡牌奖励界面

WndCardRewardShow = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCardRewardShow:_init()
	self.m_root = nil                  --场景根节点
    self.info = {}
    self.backFunc = nil
    self.sendFunc = nil                 --赠送回调函数
    self.explainFunc = nil              --说明回调函数
    self.m_nDisplayType = 4             
    self.m_nSelectItemId = nil          --当前选择的物品ID
    self.m_tSelectCell = nil
    self.m_bIsShowBySendGift = false
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCardRewardShow:_unInit()
	self.m_root = nil
    self.info = nil
    self.backFunc = nil
    self.sendFunc = nil
    self.explainFunc = nil
    self.m_nDisplayType = nil
    self.m_nSelectItemId = nil
    self.m_bIsShowBySendGift = nil
    self.m_tSelectCell = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCardRewardShow:createElement()
	local element = WZUISystem:getInstance():createElement("WndCardRewardShow")
	assert(element, "WndCardRewardShow create element failed!")
	self:_init()
	return element
end


--@brief   设置关闭回调
function WndCardRewardShow:closeCallBack(tcell,backFunc)
    -- body
    if tcell and backFunc then
        self.backFunc = {}
        self.backFunc[1] = tcell
        self.backFunc[2] = backFunc
    end
end

--@brief  发送按钮回调
function WndCardRewardShow:setSendGiftCallBack(tcell,backFunc)
    if tcell and backFunc then
        self.sendFunc = {}
        self.sendFunc[1] = tcell
        self.sendFunc[2] = backFunc
    end
end

--@brief  说明回调
function WndCardRewardShow:setExplainCallBack(tcell,backFunc)
    if tcell and backFunc then
        self.explainFunc = {}
        self.explainFunc[1] = tcell
        self.explainFunc[2] = backFunc
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
