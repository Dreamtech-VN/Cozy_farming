--WndPvpSegmentReward.lua
--@brief	WndPvpSegmentReward的UI模块
--@date		2016-3-29
--@author	binshao
--@note		排位赛段位奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPvpSegmentReward:onEnter(element)
	self.m_root = element
end

----@brief onEnter函数执行完成回调
function WndPvpSegmentReward:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

----@brief    弹窗动画完成后的回调
function WndPvpSegmentReward:actionCallback(element, data)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPvpSegmentReward:onExit(element)
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndPvpSegmentReward:OnClose(element)
    WZLog("WndPvpSegmentReward:onClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)
end

--@brief	动画播完后的回调
function WndPvpSegmentReward:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief   弹框TIPS
function WndPvpSegmentReward:OnTouchBegin(element,pt)
    WndItemInfo:onCloseClick()
end

--@brief	点击单元格时的回调
--@param    nTag,被点击单元格的tag值
--@param    tCell,被点击单元格绑定的lua表对象
function WndPvpSegmentReward:onClickCell(nTag, tCell)
end

function WndPvpSegmentReward:onClickRewardItem(luaObject,data)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndItemInfo:showInfo(luaObject.m_root,self.m_root,1,data,false)
end

-- 显示UI
function WndPvpSegmentReward:showWndUI()
    local wnd = WndPvpSegmentReward:createElement()
    WindowManager:addWindow(wnd,WndPvpSegmentReward)
    self:createSegmentReward()
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
-- 创建段位奖励（避免重复创建）
function WndPvpSegmentReward:createSegmentReward()
    if not self.segmentReward then
        self:initSegmentReward()

        local tab = GetElement(self.m_root,"tabSegment_WndPvpRankList",WZUITableContainer)
        tab:cleanTable()
        for i = 1, #self.segmentReward do
            local cell,tcell = CellPvpRankSegment:createElement()
            cell:setTag(i - 1)
            tab:setCellElement(cell)
            tcell:setReward(self.segmentReward[i])
            tcell:setCallFunc(self,self.onClickRewardItem)
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------