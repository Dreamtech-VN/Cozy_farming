--WndVipUp.lua
--@brief	WndVipUp的UI模块
--@date		2015-11-18
--@author	binshao
--@note		VIP等级提升


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndVipUp:onEnter(element)
	self.m_root = element
    WZLog("-----------VIP-----------UP")
end

--弹窗动画
function WndVipUp:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAction(self.m_root,false,"actionCallback",self)
end

--@brief  弹窗动画结束回调
function WndVipUp:actionCallback(elem,data)
    self:_update()
end


function WndVipUp:onTouchBegan()
	if self.canClick then WindowManager:removeWindow(self.m_root,self,true,nil) end
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndVipUp:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief  动画播放完毕
function WndVipUp:playVipUp(element)
    self.canClick = true
	element:disableSchedule()

    local spine = GetElement(self.m_root,"spineVip_WndVipUp",WZUISpine)
    spine:setFileJson("ui/ui_enaiup_effect_01.json")
    spine:setFileAtlas("ui/ui_enaiup_effect_01.atlas")
    spine:play("vipup",false)
end


function WndVipUp:spineVipUpEnd(element,action,val)
    WZLog("spineVipUpEnd",element,action,val)
    if "complete" == action then
        local spine = GetElement(self.m_root,"spineVip_WndVipUp",WZUISpine)
        spine:play("vipup_chixu",true)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndVipUp:_update()
    self.m_root:enableSchedule("playVipUp",1.5)
end
-------------------------------------私有方法模块End----------------------------------------