--WndRechargeAndroidData.lua
--@brief	WndRechargeAndroid的数据模块
--@date		2014/04/27
--@author	liangguang_long
--@note		Android充值模块

WndRechargeAndroid = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRechargeAndroid:_init()
	self.m_root = nil	 	  	--场景根节点
	self.m_tBtn = nil 			--按钮数据列表
	self.m_nTag = nil 			--当前的索引
	self.m_nIndex = nil 
	self.m_nPar = nil 
	self.m_tIp = nil
	self.m_nLoadingId = nil
	self.m_nThread = 0
	self.m_bAviailable = false --SIM卡是否可用
	self.m_cardType = {"SMS","SZX","TELECOM","UNICOM","JUNNET","SNDACARD","ZHENGTU","QQCARD","NETEASE","JIUYOU","YPCARD","WANMEI","SOHU","ZONGYOU","TIANXIA","TIANHONG",}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRechargeAndroid:_unInit()
	self.m_root = nil
	self.m_tBtn = nil 			--按钮数据列表
	self.m_nTag = nil 			--当前的索引
	self.m_nIndex = nil 
	self.m_nPar = nil 
	self.m_tIp = nil
	self.m_nLoadingId = nil
	self.m_nThread = nil
	self.m_cardType = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRechargeAndroid:createElement()
	local element = WZUISystem:getInstance():createElement("WndRechargeAndroid")
	assert(element, "WndRechargeAndroid create element failed!")
	self:_init()
	return element
end

--@brief	初始化数据
function WndRechargeAndroid:_initData()
	self.m_nPar = 0 
	self:_setPayName()
	self:_setPayPwd()
end

--@brief	获取按钮数据列表
function WndRechargeAndroid:setRechargeBtn()
	self.m_tBtn = {}
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD1)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD2)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD3)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD4)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD5)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD6)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD7)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD8)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD9)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD10)
	self:_update()
end

--@brief	获取按钮数据列表(具有移动，联通或电信卡)
function WndRechargeAndroid:setRechargeBtnWithSMS()
	self.m_tBtn = {}
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD1)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD11)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD2)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD3)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD4)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD5)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD6)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD7)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD8)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD9)
	table.insert(self.m_tBtn,GlobalGame.PayCard.PAYCARD10)
	self:_update()
end

function WndRechargeAndroid:getCallBackUrlOk(ip, port)
	self.m_tIp = {}
	table.insert(self.m_tIp,ip)
	table.insert(self.m_tIp,port)
	self:_totoPayment()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 进入充值
function WndRechargeAndroid:_totoPayment()
	local payName = self:_getPayName()
	local payPwd = self:_getPayPwd()
	WZLog("payName:",payName)
	WZLog("payPwd:",payPwd)
	local tData = self:_getPayData(self.m_nTag)
	local parConut = tData[self.m_nPar+1]--面值
	WZLog("parConut::",self.m_nTag,self.m_nPar,tData[self.m_nPar+1],parConut)
	if self.m_bAviailable then
		if self.m_nTag == 1 then
			self:_gotoSMSPayment()
			return
		end
		if self.m_nTag == 2 then
			self:_gotoAlipy(parConut)
		else
			--其它付费方式
			if payName == nil or payName == "" or payPwd == nil or payPwd == "" then
				MsgBoxManager:showTipBox("请输入正确信息!")
				return
			end
			self:_payOthers(parConut,payName,payPwd)
		end
	else
		--支付宝
		if self.m_nTag == 1 then
			self:_gotoAlipy(parConut)
		else
			--其它付费方式
			if payName == nil or payName == "" or payPwd == nil or payPwd == "" then
				MsgBoxManager:showTipBox("请输入正确信息!")
				return
			end
			self:_payOthers(parConut,payName,payPwd)
		end
	end	
end

--@brief  	短信支付
function WndRechargeAndroid:_gotoSMSPayment()
	WZLog("进行短信支付")
	--PassportSdkManager:doPayWithSDK()
	local ip = self.m_tIp[1]
	local port = self.m_tIp[2]
	PassportSdkManager:getCallBackUrlOk(ip,port)
end

--@brief  	初始化支付宝面值
function WndRechargeAndroid:_gotoAlipy(sMoney)
	if self.m_root == nil or self.m_tIp == nil then
		return
	end
	local url = "app_name=com.wyd.dandandao&ip=%s&port=%s&user_token=%d&channel=%d&money=%d"
	local ip = self.m_tIp[1]
	local port = self.m_tIp[2]
	local token = GlobalGame.g_tPlayerInfo.nPlayerId
	local channel = ProjConfig.CHANNEL_ID
	local money = tonumber(sMoney)
	url = string.format(url,ip,port,token,channel,money)
	--加密
	local encUdid = WGameCmUtil:EnCrypt(url, ENCRYPT_KEY)
	local sUrl = string.format("http://pay2.zhwyd.com:5000/wydpay/input?key=%s",WGameCmUtil:transformBytesToString(encUdid))
	WZPush:openURL(sUrl)
	self.m_tIp = nil 
end

--@brief 	其它付费方式
function WndRechargeAndroid:_payOthers(parConut,payName,payPwd)
	if self == nil or self.m_root == nil or self.m_tIp == nil then
		return
	end
	local  tag = self.m_nTag
	if self.m_bAviailable then
	 	tag = self.m_nTag-1
	end
	local tData = {}
	if  ProjConfig.CHANNEL_ID == 1002 then	
		tData.agent = "DOWNJOY"	
	else
		tData.agent = "ZHWYD-W"
	end
	
	tData.app_name = "com.wyd.dandandao"--应用名称，如王冠
	tData.card_medium = self.m_cardType[tag]--卡类
	tData.pay_amt = parConut--充值金
	tData.card_amt = parConut--*self:_getMoney2Diamond(parConut)--卡面
	tData.card_no = payName--卡号
	tData.card_pwd = payPwd--卡密
	tData.ip = self.m_tIp[1]
	tData.port = self.m_tIp[2]
	tData.user_token = GlobalGame.g_tPlayerInfo.nPlayerId--游戏帐户ID
	tData.channel = ProjConfig.CHANNEL_ID--渠道
	local url = [[http://pay2.zhwyd.com:5000/wydpay/post_order?]]
	for i,data in pairs(tData) do
		local path = tostring(i).."="..tostring(data)
		url = url.."&"..path
	end
	url = url:gsub("?&","?")
	WZLog("url:::",url)
	local thread = WZUISystem:getInstance():getMultiThreadSystem()
	thread:addDownloadTask(WZHTTPInfoLuaTask:create(self.m_nThread, url, self.urlBackFun, self))
	self.m_nThread = self.m_nThread + 1
	self:createLoading(30)--创建加载框
end

--@brief 	其它付费方式回调
function WndRechargeAndroid:urlBackFun(id, tData, bFinish, bFailed)
	WZLog("id:",id)
	WZLog("bFailed::",bFailed)
	WZLog("bFinish::",bFinish)
	WZLog("tData::",tData)
	if bFinish then--如果成功
		MsgBoxManager:showTipBox("订单提交成功!")
	else
		MsgBoxManager:showTipBox("订单提交失败!")
	end
	self:closeLoading()--关闭加载框
end

--@brief	初始化默认界面
function WndRechargeAndroid:_initSurface()
	self.m_nIndex = 0
	self.m_nTag = 0--默认选择第一个按钮
	self:_initPay()--初始化默认选择第一个面值
end

--@brief	设置checkbox的状态
--@param	tCell:表绑定的UI节点引用
--@param	index:索引
function WndRechargeAndroid:_setCellCheckIndex(tCell,index)
	if self.m_root == nil or tCell == nil then
		return
	end
	local checkItem = tCell:getChildElement("checkItem_CellRechargeAndroid")
	checkItem = WZUICheckBox:luaTo(checkItem)
	checkItem:setCheckIndex(index)
end

--@brief	移除所有child
function WndRechargeAndroid:removeAllMoveChild(tCell)
	if tCell == nil then
		return
	end
	for i = 0 , self.m_nIndex do 
		tCell:removeChildByTag(i,true)
	end
	self.m_nIndex = 0
end

--@brief	获取TTF的大小位置
function WndRechargeAndroid:_getText(tCell)
	if tCell then
		tCell = WZUILabelTTF:luaTo(tCell)
		return tCell:getContentSize(),tCell:getRelativePosition()
	end
end

--@brief	设置TTF的位置
function WndRechargeAndroid:_setTextPt(tCell,tCellValue,nDir)
	if self.m_root == nil or tCell == nil or tCellValue == nil then
		return
	end
	nDir = nDir or 4
	local tCellSize = tCell:getContentSize()
	local tCellPt = tCell:getRelativePosition()
	local lpSize = tCell:getParentElement():getContentSize()
	local y = tCellPt.y - ( tCellSize.height + nDir )/lpSize.height
	tCellValue:setRelativePosition(GlobalMethod:ccp(tCellPt.x,y))
	tCell = nil 
	tCellValue = nil
end

--@brief	设置控件的位置
function WndRechargeAndroid:_setPayPt(tCell,tCellValue,nDir)
	if self.m_root == nil or tCell == nil or tCellValue == nil then
		return
	end
	nDir = nDir or 8
	local tCellSize = tCell:getContentSize()
	local lpSize = tCell:getParentElement():getContentSize()
	local tCellPt = tCell:getRelativePosition()
	local valuePt = tCellValue:getRelativePosition()
	local y = tCellPt.y - ( tCellSize.height + nDir )/lpSize.height
	local x = valuePt.x
	tCellValue:setRelativePosition(GlobalMethod:ccp(x,y))
	tCell = nil 
	tCellValue = nil
end

--@brief	设置文本
function WndRechargeAndroid:_setTextDesc(tCell,desc)
	if tCell then
		tCell = WZUILabelTTF:luaTo(tCell)
		tCell:setText(desc)
	end
end

--@brief	获取帧容器的索引
function WndRechargeAndroid:_getFrameIndex(tag)
	if tag == 0 then
		return 0
	elseif tag >= 1 then
		return 1
	end
end

--获取右边界面基础属性
function WndRechargeAndroid:_getParProperty(tag)
	local parConut = 0 
	local bPay = false
	local btnText = "充值"
	WZLog("gyq",tag)
	if self.m_bAviailable then
		if tag == 0 then
			parConut = 0 
			bPay = false
		elseif tag == 1 then
			parConut = 0 
			bPay = false
		elseif tag == 2 then
			parConut = 12 
			btnText = "去支付宝"
			bPay = false
		elseif tag == 3 then
			parConut = 6 
			bPay = true
		elseif tag == 4 then
			parConut = 2 
			bPay = true
		elseif tag == 5 then
			parConut = 6 
			bPay = true
		elseif tag == 6 then
			parConut = 5
			bPay = true
		elseif tag == 7 then
			parConut = 4 
			bPay = true
		elseif tag == 8 then
			parConut = 11 
			bPay = true
		elseif tag == 9 then
			parConut = 9 
			bPay = true
		elseif tag == 10 then
			parConut = 6 
			bPay = true
		end
	else
		if tag == 0 then
			parConut = 0 
			bPay = false
		elseif tag == 1 then
			parConut = 12 
			bPay = false
			btnText = "去支付宝"
		elseif tag == 2 then
			parConut = 6 
			bPay = true
		elseif tag == 3 then
			parConut = 2 
			bPay = true
		elseif tag == 4 then
			parConut = 6 
			bPay = true
		elseif tag == 5 then
			parConut = 5 
			bPay = true
		elseif tag == 6 then
			parConut = 4
			bPay = true
		elseif tag == 7 then
			parConut = 11 
			bPay = true
		elseif tag == 8 then
			parConut = 9 
			bPay = true
		elseif tag == 9 then
			parConut = 6 
			bPay = true
		end
	end
	
	return parConut,bPay,btnText
end

function WndRechargeAndroid:_getVar(i,var,maxCount)
	local lest = maxCount-(i-1)*var
	if lest < var then
		return lest
	else
		return var
	end
end

function WndRechargeAndroid:_getPayData(tag)
	if self.m_bAviailable then
		tag = tag -1
	end

	local tData = {}
	local tTemp = {}
	table.insert(tTemp,"5")
	table.insert(tTemp,"10")
	table.insert(tTemp,"20")
	table.insert(tTemp,"30")
	table.insert(tTemp,"50")
	table.insert(tTemp,"100")
	table.insert(tTemp,"200")
	table.insert(tTemp,"300")
	table.insert(tTemp,"500")
	table.insert(tTemp,"1000")
	table.insert(tTemp,"1500")
	table.insert(tTemp,"2000")
	table.insert(tTemp,"15")
	if tag == 1 then
		tData = tTemp
	elseif tag == 2 then --or tag == 9 then
		tData[1] = tTemp[2]
		tData[2] = tTemp[4]
		tData[3] = tTemp[5]
		tData[4] = tTemp[6]
		tData[5] = tTemp[8]
		tData[6] = tTemp[9]
	elseif tag == 4 then
		tData[1] = tTemp[3]
		tData[2] = tTemp[4]
		tData[3] = tTemp[5]
		tData[4] = tTemp[6]
		tData[5] = tTemp[8]
		tData[6] = tTemp[9]
	elseif tag == 3 then
		tData[1] = tTemp[5]
		tData[2] = tTemp[6]
	elseif tag == 5 then
		tData[1] = tTemp[2]
		tData[2] = tTemp[13]
		tData[3] = tTemp[4]
		tData[4] = tTemp[5]
		tData[5] = tTemp[6]
	elseif tag == 6 then
		tData[1] = tTemp[1]
		tData[2] = tTemp[2]
		tData[3] = tTemp[4]
		tData[4] = tTemp[6]
	elseif tag == 7 then
		tData[1] = "5"
		tData[2] = "10"
		tData[3] = "15"
		tData[4] = "20"
		tData[5] = "25"
		tData[6] = "30"
		tData[7] = "50"
		tData[8] = "100"
		tData[9] = "250"
		tData[10] = "300"
		tData[11] = "500"
	elseif tag == 8 then
		tData[1] = "1"
		tData[2] = "5"
		tData[3] = "6"
		tData[4] = "10"
		tData[5] = "15"
		tData[6] = "30"
		tData[7] = "50"
		tData[8] = "60"
		tData[9] ="100"
	elseif tag == 9 then
		tData[1] = "5"
		tData[2] = "10"
		tData[3] = "15"
		tData[4] = "30"
		tData[5] = "50"
		tData[6] = "100"
	end
	return tData
end

function WndRechargeAndroid:_getSpaceByTag(tag)
	WZLog("_getSpaceByTag(tag):",tag)
	if self.m_bAviailable then
		tag = tag -1
	end
	local space = 30
	if tag <= 0 then
		space =  60
	elseif tag == 1 then
		space = 35
	elseif tag == 2 then
		space = 35
	elseif tag == 3 then
		space = 15
	elseif tag == 4 then
		space = 35
	elseif tag == 5 then
		space = 35
	elseif tag == 6 then
		space = 35
	elseif tag == 7 then
		space = 96
	elseif tag == 8 then
		space = 60
	else
		space = 30
	end
	return space
end

function WndRechargeAndroid:_getMoney2Diamond(nNum)
	--折扣优惠
	local nMoney = tonumber(nNum)
	if nMoney >=301 then
		return nMoney*1.25
	elseif nMoney >=101 then
		return nMoney*1.20
	elseif nMoney >=51 then
		return nMoney*1.15
	elseif nMoney >= 11 then
		return nMoney*1.1
	else
		return nMoney
	end
end

--@brief	检查账号
function WndRechargeAndroid:checkName(payName)
	if payName == nil or payName == "" or Regexp:isLettersAndNumbers(payName) == false then
		return false 
	elseif string.len(payName) > 32 or string.len(payName)<6  then
		return false
	else	
		return true
	end
end

--@brief	检查密码
function WndRechargeAndroid:checkPwd(payPwd)
	if payPwd == nil or payPwd == "" or Regexp:isLettersAndNumbers(payPwd) == false then
		return false
	elseif string.len(payPwd)> 32 or string.len(payPwd)< 6 then 
		return false
	else
		return true
	end
end

--@brief	购买完成后的回调
--@param    nCode，错误码:-1，成功，0订单验证失败，1服务器增加点卷失败，2订单正在处理中
--@param    nTickets，点卷数量
function WndRechargeAndroid:buyCallBack(nCode, nTickets,orderNumber)
	WZLog("购买完成后的回调::::",nCode,nTickets)
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingBoxId)
    self.m_archiveData = {}
    self.m_archiveData.m_orderNumber =orderNumber
    self.m_archiveData.m_playerId =GlobalGame.g_tPlayerInfo.nPlayerId
    self.m_archiveData.m_channelId =ProjConfig.CHANNEL_ID
    local jesonOrder = json.encode(self.m_archiveData)
    saveCurrentOrder(jesonOrder)
    if nCode == -1 then
        GlobalGame.g_tPlayerInfo.nTickets = nTickets or GlobalGame.g_tPlayerInfo.nTickets
       -- self:setTotalDiamond()
        MsgBoxManager:showTipBox(LocalStrings.RECHARGE_SUCCESS)
    elseif nCode == 0 then
        MsgBoxManager:showTipBox(LocalStrings.RECHARGE_ORDER_FAIL)--"订单验证失败"
    elseif nCode == 1 then
        --MsgBoxManager:showTipBox(LocalStrings.RECHARGE_FAIL)--"充值失败"
    elseif nCode == 2 then
        MsgBoxManager:showTipBox(LocalStrings.RECHARGE__IN_PROCESS)--"订单正在处理中"
    else
         MsgBoxManager:showTipBox(LocalStrings.RECHARGE_FAIL)--"充值失败"
    end
	self.m_root:enableSchedule("_showPayTip",1)
end
-------------------------------------私有方法模块End----------------------------------------





