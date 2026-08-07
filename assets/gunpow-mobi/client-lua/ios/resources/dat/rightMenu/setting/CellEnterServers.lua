--CellEnterServers.lua
--@brief	CellEnterServers的UI模块
--@date		2015/04/29
--@author	binshao
--@note		单个服务器模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellEnterServers:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellEnterServers:onExit(element)
	self:_unInit()
end

--@brief 弹出服务器选择确认框
function CellEnterServers:onBtnSelectEnter(element)
    if self.tData.status == 0 then
        MsgBoxManager:showTipBox("服务器未开启", nil, nil, nil, nil)
        return
    end

	element = WZUIButton:luaTo(element)
	local txt = self:_getSelectServerName()
	MsgBoxManager:showConfirmCancelBox( txt , self , self.onMessageBackFun )

	local tag = self.m_root:getTag()
	if self.m_tCallbackFunc and self.m_tCallbackFunc[1] and self.m_tCallbackFunc[2] then
		self.m_tCallbackFunc[2](self.m_tCallbackFunc[1],tag,self,self.tData)
    end
end

--@brief	选中服务器消息回调函数
--@param	nId:消息ID
--@param	nType:消息回调类型，1为确定，2为取消(关闭)
function CellEnterServers:onMessageBackFun( nId , nType )
	if not self.m_root or nType == 2 then
		return
	end
    --IPDhttpServer:replaceServer(self.tData.serverId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function CellEnterServers:_update()
	--设置服务器名称
	self:_setServerName()
	--设置选中的服务器（改变颜色）
	self:SetSeverColor( )
end

--@brief	设置服务器名称
--@param	sText:设置文本内容,在这里是服务器名称
function CellEnterServers:_setServerName( )
	local txtServerName = GetElement(self.m_root,"txtServerName_CellEnterServers",WZUILabelTTF)
    local name = self.tData.name
    local state = self:getServerState()
	txtServerName:setText( state.." "..name )
end

--@brief	获取选中的服务器名称
--@param	txt:返回选中的文本内容,在这里是服务器名称
function CellEnterServers:_getSelectServerName( )
	local txtServerName =  GetElement(self.m_root,"txtServerName_CellEnterServers",WZUILabelTTF)
    local txt = txtServerName:getText()
    return txt
end

--@brief	设置选中的服务器（改变颜色）
--@param	bFlog:设置服务器是否选中，如果为true为选中，false为不选中
--@note		RGB颜色可以为空（默认红色），如果单一存在默认红色
function CellEnterServers:SetSeverColor( bFlog )
	local color = bFlog and GlobalMethod:ccc3(255,0,11) or GlobalMethod:ccc3(0,0,0)
	self.tData.bFlog = bFlog
	local txtServerName = self.m_root:getChildElement("txtServerName_CellEnterServers")
	if txtServerName == nil then return end
	txtServerName = WZUILabelTTF:luaTo( txtServerName )
	txtServerName:setColor( color )
end

-- 获取当前服务器的状态
function CellEnterServers:getServerState()
    --  服务器的当前状态，畅通，拥挤， 爆满
    local serverState
    if self.tData.status == 0 then
        serverState = "维护中"
    else
        if self.tData.currOnline < 200 then
            serverState = LocalStrings.SETTING_SERVERS_STATE_GOOD
        elseif self.tData.currOnline < 1000 then
            serverState = LocalStrings.SETTING_SERVERS_STATE_CROWD
        else
            serverState = LocalStrings.SETTING_SERVERS_STATE_FULL
        end
    end
    return serverState
end
-------------------------------------私有方法模块End----------------------------------------