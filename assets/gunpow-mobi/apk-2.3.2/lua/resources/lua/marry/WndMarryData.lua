--WndMarryData.lua
--@brief	WndMarry的数据模块
--@date		2014/01/07
--@author	叶威
--@note		结婚礼堂模块

WndMarry = {
	--请不要在这里定义变量
}



--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMarry:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nMarryType = 1               --求婚类型
    self.m_tMarryStatus = nil           --保存婚姻状况的表
    self.m_nOperType = 1
    self.m_tCallbackT = nil
    self.m_tCallbackF = nil
    self.m_tGiftData = nil
    self.m_nSendGiftCount = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMarry:_unInit()
	self.m_root = nil
    self.m_nMarryType = nil
    self.m_tMarryStatus = nil
    self.m_nOperType = nil
    self.m_tCallbackT = nil
    self.m_tCallbackF = nil
    self.m_tGiftData = nil
    self.m_nSendGiftCount = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMarry:createElement()
    if WndMarry.m_root ~= nil then
        WindowManager:removeWindow(WndMarry.m_root, WndMarry, true)
    end
	local element = WZUISystem:getInstance():createElement("WndMarry")
	assert(element, "WndMarry create element failed!")
	self:_init()
	return element
end

--@brief	外部接口
function WndMarry:showInterface(marryCDTime)
	--判断是否在冷却时间，冷却时间不让求婚
	WZLog("WndMarry:showInterface", marryCDTime, SystemTime:getServerTime())
	if marryCDTime and marryCDTime > SystemTime:getServerTime() then 
		local leftTime = marryCDTime - SystemTime:getServerTime()
		local strTime = returnToTimeFormat_Day(leftTime)
		local strContent = string.format(LocalStrings.MARRY_END[1], strTime)
		MsgBoxManager:showTipBox(strContent)
		return 
	end
	local wndMarry = WndMarry:createElement()
    WindowManager:addWindow(wndMarry, WndMarry,true,nil,nil,true)
end

--@breif  根据optType显示相应的UI
function WndMarry:setOperationType(opeType,giftData)
	WZLog("WndMarry:setOperationType")
	self.m_nOperType = opeType
	self.m_tGiftData = giftData
end

--@brief  设置发送礼物回调
function WndMarry:setSendOperCallback(callbackT,callbackF)
	WZLog("WndMarry:setSendOperCallback")
	self.m_tCallbackT = callbackT
	self.m_tCallbackF = callbackF
end

--@brief  设置可以送礼物的次数
function WndMarry:setGiftCount(count)
	self.m_nSendGiftCount = count
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
