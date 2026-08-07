--CellEatthingsPanelData.lua
--@brief	CellEatthingsPanel的数据模块
--@date		2014/12/02
--@author	wuweidong
--@note		吃大餐面板

CellEatthingsPanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellEatthingsPanel:_init()
	self.m_root = nil  			--Cell的根节点
    self.m_nActivityId = nil    --补充活力活动的Id
    self.m_nActivityType = nil  --活动类型
	self.txtContext=nil 		--描述内容
	self.bState=false			--是否可以点击
	self.nServerTime=0 			--服务器时间
	self.tRewardItemsParamCount=nil	--时间段
	self.nVigor=0 				--提示回复值
	self.nloadingId = 0          --加载loadingId
    self.rewardId = -1           --时间段标记
    self.m_sLanguage = nil      --当前语言
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellEatthingsPanel:_unInit()
	self.m_root = nil
    self.m_nActivityId = nil    --补充活力活动的Id
    self.m_nActivityType = nil  --活动类型
	self.bState=false			--是否可以点击
	self.nServerTime=0 			--服务器时间
	self.tRewardItemsParamCount=nil	--时间段
	self.nVigor=0 				--提示回复值
	self.nloadingId = 0         --加载loadingId
    self.rewardId = nil           --时间段标记
    self.m_sLanguage = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellEatthingsPanel:createElement(activityId, activityType)
	local tNewObj = self:_new()
	assert(tNewObj, "CellEatthingsPanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellEatthingsPanel")
	assert(element, "CellEatthingsPanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
    self.m_nActivityType = activityType 
	return element,tNewObj
end

--@brief 	品尝成功回调
function CellEatthingsPanel:ACTIVITY_TasteOk()
	WZLog("CellEatthingsPanel:ACTIVITY_TasteOk")
	MsgBoxManager:removeMsgById(CellEatthingsPanel.m_current.nloadingId)
    WZLog("************* CellEatthingsPanel:ACTIVITY_TasteOk ************", CellEatthingsPanel.m_current.nVigor)

    createActChangeAni(CellEatthingsPanel.m_current.m_root, "ui/common_num/common_num_yaoqianshuzi.png", "ui/common/common_icon_huoli.png", CellEatthingsPanel.m_current.nVigor)

	local btn_eat_oprator = GetElement(CellEatthingsPanel.m_current.m_root,"btn_eat_oprator",WZUIButton)
    local btn_too_full = GetElement(CellEatthingsPanel.m_current.m_root,"btn_too_full",WZUIButton)
    if btn_eat_oprator == nil or btn_too_full == nil then
        return
    end
    if self.m_sLanguage ~= "cn" then
        local armatureFire = GetElement(CellEatthingsPanel.m_current.m_root, "armatureFire_CellEatthingsPanel", WZArmature)
        local actionFire = WZUIArmatureAnimationById:create()

        actionFire:setAnimationId(1)
        actionFire:setLoop(0)
        armatureFire:runUIAction(actionFire)

        local conArmature = GetElement(CellEatthingsPanel.m_current.m_root, "conArmature_CellEatthingsPanel", WZUIContainer)
        conArmature:enableSchedule("onFinishCallBack", 2.2)
    end

    btn_eat_oprator:setVisible(false) 
    btn_too_full:setVisible(true)
end

--@brief    特效播放回调函数
--@param    element: 特效节点
function CellEatthingsPanel:onFinishCallBack(element,delta)
    -- body
    WZLog("********* CellEatthingsPanel:onFinishCallBack *********")
    if self.m_sLanguage ~= "cn" then
        local conArmature = GetElement(CellEatthingsPanel.m_current.m_root, "conArmature_CellEatthingsPanel", WZUIContainer)
        conArmature:disableSchedule()
        local armatureFire = GetElement(CellEatthingsPanel.m_current.m_root, "armatureFire_CellEatthingsPanel", WZArmature)
        if armatureFire then
            WZLog("********* CellEatthingsPanel:onFinishCallBack *********, 1111")
            local actionFire = WZUIArmatureAnimationById:create()

            actionFire:setAnimationId(0)
            actionFire:setLoop(-1)
            if armatureFire then
                armatureFire:runUIAction(actionFire)
            end
        end
    end
end

--@brief 	品尝失败回调
function CellEatthingsPanel:ACTIVITY_TasteFailure(sMessage)
	WZLog("CellEatthingsPanel:ACTIVITY_TasteFailure")
	--WZLog("2=>"..CellEatthingsPanel.m_root.nloadingId)
	MsgBoxManager:removeMsgById(CellEatthingsPanel.m_current.nloadingId)
	WZLog(CellEatthingsPanel.m_current.nloadingId)
	MsgBoxManager:showTipBox(sMessage, 3)
end

--@brief 	获得loadingId
function CellEatthingsPanel:getloadingId( )
	return self.nloadingId
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellEatthingsPanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellEatthingsPanel.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
