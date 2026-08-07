--WndWorldBossRule.lua
--@brief	WndWorldBossRule的UI模块
--@date		2014/02/11
--@author	liangguang_long
--@note		世界BOSS规则说明


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWorldBossRule:onEnter(element)
	--SoundManager:playBgMusic(SoundDefine.E_S_OPEN_WIN)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWorldBossRule:onExit(element)
	self:_unInit()
end

--@brief	创建窗口动画
function WndWorldBossRule:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
end

--@brief	窗口动画完成回调
function WndWorldBossRule:actionCallback(elem,data)

end

--@brief	窗口动画关闭完成回调
function WndWorldBossRule:onCloseActionCallback(elem,data)
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief	关闭按钮回调函数
function WndWorldBossRule:onCloseClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief	外部接口函数
--@param    #1 desc:规则说明内容
--@param    #2 element:表名
--@param    #3 tCallbackFun:回调函数
function WndWorldBossRule:showInterface( )
    local worldBossRuleElement = WndWorldBossRule:createElement()
    WindowManager:addWindow( worldBossRuleElement , WndWorldBossRule,true )
	self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	更新函数
function WndWorldBossRule:_update()
	self:_descUpdate()
end

--@brief  	更新滚动容器内部布局函数
function WndWorldBossRule:_descUpdate()
    local ftb = GetElement(self.m_root,"ftbDesc_WndWorldBossRule",WZUIFreeTextBox)
    local scl = GetElement(self.m_root,"scrollDesc_WndWorldBossRule",WZUIScrollContainer)
    ftb:setShowText(LocalStrings.VIP_LEVEL_15)

    local ftbSize = ftb:getContentSize()
    local SclSize = scl:getContentSize()
    ftb:setPositionY(ftbSize.height)

    --更改滚动容器Element的大小
    local con = scl:getMoveElement()
    local size = con:getRelativeSize()
    con:setRelativeSize( GlobalMethod:CCSize(1 , ftbSize.height/SclSize.height ))
    scl:UpdateInsidePosition()  --更新滚动容器内部布局
    con:setPositionY(scl:getMinPosition().y)
end
-------------------------------------私有方法模块End----------------------------------------