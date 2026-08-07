--splashStudio.lua
--@brief	splashStudio的UI模块
--@date		2015-8-27
--@author	binshao
--@note		闪屏工作室


-------------------------------------公有方法模块Begin--------------------------------------

-- onEnter
function splashStudio:onEnter(element)
	WZLog("splashStudio:onEnter")
	self.m_root = element
end

function splashStudio:createAni()
    local con = GetElement(self.m_root,"conAni_splashStudio",WZUIContainer)
    local spine = WZUISpine:create()
    spine:setFileJson("role/shanping.json")
    spine:setFileAtlas("role/shanping.atlas")
    spine:play("shan",false)
    con:addChild(spine)
    spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    spine:setUseAbsCoordinate(true)
    self.m_root:disableSchedule()
end

--@brief onEnter函数执行完成回调
function splashStudio:onEnterTransitionDidFinish(element)
--    local img = GetElement(self.m_root,"imgSplashStudio_splashStudio",WZUIImage)
--    self.m_root:enableSchedule("createAni",0.2)

    if WZUIFrame.setTouchAnimInfo ~= nil then 
        WZUIFrame:setTouchAnimInfo("ui_main_touch_01","armatures/role/ui_main_touch_01.xml")
    end 
end

-- 退出
function splashStudio:onExit(element)
	self:_unInit()
end

-- 闪屏完成,进入加载
function splashStudio:onFinish()
    WZLog("-------------------splashFinish-----------------")
--    local WndDownLoad = WndDownLoad:createElement()
--    replaceScene(WndDownLoad)

    SceneLoginMgr:showScene(1)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin----------------------------------------

-------------------------------------私有方法模块End----------------------------------------