--WndRechargeDefault
--@brief	WndRechargeDefault的UI模块
--@date		2014/01/20
--@author	杨高山
--@note		充值窗口，默认的充值入口，没有任何界面，直接调用dopay


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRechargeDefault:onEnter(element)
	self.m_root = element
	--彩色喇叭
	ChangeChatChannel(Chat_Channel_TopUp)
	--注册充值相关协议
	ProtocolProcessorRecharge:regAll()
    --ProtocolProcessorRecharge:send_PLAYER_GetPlayerInfo(0)
    ProtocolProcessorRecharge:send_PURCHASE_GetRuleList()
    ProtocolProcessorRecharge:send_PURCHASE_GetProductIdList(PassportSdkManager:getChannelId(),3)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRechargeDefault:onExit(element)
	--反注册充值相关协议
	ProtocolProcessorRecharge:unregAll()
	self:_unInit()
end

--@brief	关闭窗口的函数
--@param	element:表绑定的UI节点引用
function WndRechargeDefault:onCloseWindowBtn(element)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndRechargeDefault, true)
	end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
end 

--@brief	提供给外部调用充值窗口的接口函数
--@param    nOrder,窗口层次
--[[function WndRechargeDefault:showRechargePage(nOrder)
	local WndRechargeDefault = WndRechargeDefault:createElement()
	if WndRechargeDefault ~= nil then 
		if nOrder ~= nil then 
			WndRechargeDefault:setZOrder(nOrder)
		end 
		WindowManager:addWindow(WndRechargeDefault,WndRechargeDefault)
	end 
end 
]]--
--@brief	点击单元格的充值按钮响应方法
--@param    nTag,单元格的tag
--@note     由CellRechargeList按钮响应方法回调回来
function WndRechargeDefault:onClickRecharge(nTag)
    WZLog("WndRechargeDefault:onClickRecharge", nTag)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新容器内充值列表的函数
function WndRechargeDefault:_update()
	if self.m_root == nil or self.m_tProductList == nil or self.m_tProductList.ids == nil then 
		WZLog(" WndRechargeDefault:_update() self.m_root is nil")
		return 
	end 
	
    local tbconProductList = GetElement(self.m_root, "tbconProductList_WndRechargeDefault", WZUITableContainer)
    tbconProductList:cleanTable()
	
	for var = 1 ,#self.m_tProductList.ids do 
		local celElement,tCell = CellRechargeList:createElement()
        celElement:setTag(var - 1)
        tbconProductList:setCellElement(celElement)
        
        local sIconPath = self.m_tProductList.icons[var]..".png"
        local nTickets = math.floor(self:_getTicketsForPrice(self.m_tProductList.pices[var]))
        tCell:setProductInfo(self.m_tProductList.pices[var], sIconPath, nTickets,self.m_tProductList.discount[var])
	end 

	self:setTotalDiamond()
end 



--@brief	设置总钻石数量的函数
function WndRechargeDefault:setTotalDiamond()
	if self.m_root == nil then 
		WZLog(" WndRechargeDefault:setTotalDiamond() self.m_root is nil")
		return 
	end 
	local txtDiamond = self.m_root:getChildElement("txtDiamond_WndRechargeDefault")
	if txtDiamond ~= nil then 
		WZUILabelTTF:luaTo(txtDiamond):setText(tostring(GlobalGame.g_tPlayerInfo.nTickets))
	end 
end 








-------------------------------------私有方法模块End----------------------------------------
