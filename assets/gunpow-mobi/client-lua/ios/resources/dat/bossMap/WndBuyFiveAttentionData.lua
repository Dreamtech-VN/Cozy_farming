--WndBuyFiveAttentionData.lua
--@brief	WndBuyFiveAttention的数据模块
--@date		2015/08/24
--@author	Tianxiang_Xu
--@note		购买五次金币提示

WndBuyFiveAttention = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBuyFiveAttention:_init()
	self.m_root = nil	 	  			--场景根节点

    self.m_nCostValue = nil             --每次需要消耗的货币
    self.m_nShakeTimes = nil            --连续摇的次数
    self.m_nGainValue = nil             --没摇一次获得的金币
    self.m_nCostId = nil                --消耗的物品ID
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndBuyFiveAttention:_unInit()
    self.m_root = nil

    self.m_nCostValue = nil             --每次需要消耗的货币
    self.m_nShakeTimes = nil            --连续摇的次数
    self.m_nGainValue = nil             --没摇一次获得的金币
    self.m_nCostId = nil                --消耗的物品ID
    self.m_tCallBack = nil  
    self.m_sMsgBody = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBuyFiveAttention:createElement()
	local element = WZUISystem:getInstance():createElement("WndBuyFiveAttention")
	assert(element, "WndBuyFiveAttention create element failed!")
	self:_init()
	return element
end

--@brief    设置点击确定回调
function WndBuyFiveAttention:setCallBack(tCell, backFunc, backFunc2)
    -- body
    self.m_tCallBack = {}

    self.m_tCallBack[1] = tCell
    self.m_tCallBack[2] = backFunc
end

function WndBuyFiveAttention:showBuyFiveAtt(sMsgBody, tCallbackLuaObj, fCallbackFunc)
    if sMsgBody == nil then
        WZLog("MsgBoxManager:showConfirmBox: sMsgBody is nil")
        return
    end

    self.m_tCallBack = {}

    self.m_tCallBack[1] = tCallbackLuaObj
    self.m_tCallBack[2] = fCallbackFunc
    self.m_sMsgBody = sMsgBody 

    if g_bShowWndMsgConfirmBox ~= nil then
        for k,v in pairs(g_bShowWndMsgConfirmBox) do
            --如果有保存这次提示的句子，直接返回
            WZLog("MsgBoxManager:showConfirmBoxWithBg",v)
            if v == sMsgBody then
                WZLog("已保存不弹出确认框")
                fCallbackFunc(tCallbackLuaObj)
                return 
            end
        end
    end

    local wndBuyFive = WndBuyFiveAttention:createElement()
    WindowManager:addWindow(wndBuyFive, WndBuyFiveAttention, false)
end

--@brief    将提示语加到不再提示列表中
function WndBuyFiveAttention:addAttToList()
    -- body
    local text = self.m_sMsgBody 
    if g_bShowWndMsgConfirmBox == nil then g_bShowWndMsgConfirmBox = {} end
    local bIsExist = false 
    for k,v in pairs(g_bShowWndMsgConfirmBox) do
        if v == text then 
            bIsExist = true
            break 
        end
    end
    --没有保存这次提示的句子，加入这句
    if not bIsExist then 
        table.insert(g_bShowWndMsgConfirmBox,text)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
