--CellCardMark.lua
--@brief	CellCardMark的UI模块
--@date		2016/07/27
--@author	Tianxiang_Xu
--@note		卡牌标记项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCardMark:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCardMark:onExit(element)
	self:_unInit()
end

--@brief    点击头像回调、
function CellCardMark:onClickHead(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1])
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新界面信息
function CellCardMark:_update()
    -- body
    local txtTitle = GetElement(self.m_root, "txtTitle_CellCardMark", WZUILabelTTF)
    txtTitle:setText(self.m_sTitle)
    --设置左边圆形按钮是否可见
    GetElement(self.m_root, "btnHead_CellCardMark", WZUIButton):setVisible(self.m_bCanTouch)
end




-------------------------------------私有方法模块End----------------------------------------
