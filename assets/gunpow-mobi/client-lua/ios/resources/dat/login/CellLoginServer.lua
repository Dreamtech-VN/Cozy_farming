--CellLoginServer.lua
--@brief	CellLoginServer的UI模块
--@date		2015-6-16
--@author	binshao
--@note		单个服务器模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLoginServer:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLoginServer:onExit(element)
	self:_unInit()
end

--@brief 弹出服务器选择确认框
function CellLoginServer:onBtnSelectEnter(element)
	local tag = self.m_root:getTag()
	if self.m_tCallbackFunc and self.m_tCallbackFunc[1] and self.m_tCallbackFunc[2] then
		self.m_tCallbackFunc[2](self.m_tCallbackFunc[1],self.tData)
    end
end

--@brief    开始加载
function CellLoginServer:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellLoginServer")
    self.m_root:addChild(celElement)
    self.m_bIsLoaded = true
    --更新界面数据
    self:_update() 
    AdaptLanguage(self)
end
--------------------------------公有方法模块End----------------------------------------

---------------------------------私有方法模块Begin--------------------------------------

-- 服务器tips
-- tips  1推荐 2 新服  3火爆
local tipsPath = {"ui/common/common_icon_tuijian2.png","ui/common/common_icon_new2.png","ui/common/common_icon_hot2.png"}

-- 服务器状态
-- 1维护3畅通4火爆5拥挤6满人
local statePath = {
    "ui/common/common_icon_xfwf.png",   -- 维护
    nil,
    "ui/common/common_icon_xflc.png",   -- 畅通
    "ui/common/common_icon_xfzc.png",   -- 火爆
    "ui/common/common_icon_xfhb.png",   -- 拥挤
    "ui/common/common_icon_xfhb.png"}   -- 满人

local strState = {
    LocalStrings.LOGIN_SERVER_STATE_CLOSE,
    nil,
    LocalStrings.SETTING_SERVERS_STATE_GOOD,
    LocalStrings.SETTING_SERVERS_STATE_FULL,
    LocalStrings.SETTING_SERVERS_STATE_CROWD,
    LocalStrings.SETTING_SERVERS_STATE_FULL1}

--@brief	更新函数
function CellLoginServer:_update()
--    WZLog("----------------cellLoginServer--------------",self.tData.name,self.tData.status,self.tData.tips)

    -- 服务器名字
    local txtName = GetElement(self.m_root,"txtName_CellLoginServer",WZUILabelTTF)
    txtName:setText(self.tData.name)

    -- 服务器ID
    local txtId = GetElement(self.m_root,"txtId_CellLoginServer",WZUILabelTTF)
    --txtId:setText(self.tData.serverId.." "..LocalStrings.SETTING_SERVER_AREA)
    txtId:setText(self.tData.serverId)

    -- 服务器状态图片
    local imgState = GetElement(self.m_root,"imgState_CellLoginServer",WZUIImage)
    imgState:setFile(statePath[self.tData.status])

    -- 服务器状态文字
    local txtState = GetElement(self.m_root,"txtState_CellLoginServer",WZUILabelTTF)
    txtState:setText(strState[self.tData.status])

    -- 服务器标示
    local imgTip = GetElement(self.m_root,"imgTips_CellLoginServer",WZUIImage)
    if tipsPath[self.tData.tips] then
        imgTip:setVisible(true)
        imgTip:setFile(tipsPath[self.tData.tips])
    else
        imgTip:setVisible(false)
    end


    -- 选中状态
    WZLog("999999999", Serialize(self.tData), IPDhttpServer:getCurServer().name)
    local visible = (self.tData.serverId == IPDhttpServer:getCurServer().serverId and self.tData.name == IPDhttpServer:getCurServer().name)
    local imgSel = GetElement(self.m_root,"imgSel_CellLoginServer",WZUI9Image)
    imgSel:setVisible(visible)
end

-------------------------------------私有方法模块End----------------------------------------

function CellLoginServer:_adaptLanguage_pt( )
    GetElement(self.m_root,"txtName_CellLoginServer",WZUILabelTTF):setFontSize(17)
end

function CellLoginServer:_adaptLanguage_es( )
    GetElement(self.m_root,"txtName_CellLoginServer",WZUILabelTTF):setScale(0.7)
end