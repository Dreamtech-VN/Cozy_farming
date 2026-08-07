--WndFighting.lua
--@brief	WndFighting的UI模块
--@date		2015/09/22
--@author	zsq
--@note		弹出战斗力动画


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFighting:onEnter(element)
	self.m_root = element
    WZLog("WndFighting:onEnter", tostring(GlobalGame.g_bIfInBattle), tostring(GlobalGame.g_tInfo.nFighting))
    if GlobalGame.g_tWndFightingList == nil then
        WZLog("WndFighting:onEnter222")
        GlobalGame.g_tWndFightingList = {}
    end
    if self == nil then
        WZLog("WndFighting:onEnter333")
        return
    end
    table.insert(GlobalGame.g_tWndFightingList, self)
    WZLog("WndFighting:onEnter444")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFighting:onExit(element)
    WZLog("WndFighting:onExit")
	self:_unInit()
end

function WndFighting:onEnterTransitionDidFinish(element)
    WZLog("WndFighting:onEnterTransitionDidFinish")
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFighting:_update(element)
	WZLog("WndFighting:_update")
	local tMsg = self.m_tMsgData
	local nExp = tMsg.sMsgBody.m_nExp
	local startPt = tMsg.sMsgBody.m_startPt
	local sDesc = tMsg.sMsgBody.m_sDesc
	local icon = "ui/common_num/commom_num_zdljia.png"
	local wordImg = "ui/common/commom_icon_zdljia.png"
	local symbolImg = "ui/common/commom_icon_zdljia2.png"
	WZLog("WndFighting:_update",tostring(nExp),type(nExp), nExp)
	WZLog("WndFighting:_update1",(tostring(nExp) == "0"),(tostring(nExp) == nil), (tonumber(nExp) == nil))
	if (tostring(nExp) == "0") or (tostring(nExp) == nil) or (tonumber(nExp) == nil) then
		WZLog(" 战斗力变化为0删除")
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
	    if self.m_root then self.m_root:removeFromParentAndCleanup(true) end
		return
	elseif (tonumber(nExp) ~= nil and tonumber(nExp) > 0) then
		nExp = tostring(nExp)
		--设置图片数字
		local label = GetElement(self.m_root,"ttfNum1_WndFighting",WZUILabelAtlasFont)
		label:setText(0)
		self.m_nFighting = nExp
		GetElement(self.m_root,"ttfNum_WndFighting",WZUILabelAtlasFont):setVisible(false)
		GetElement(self.m_root,"fightingDown",WZUIImage):setVisible(false)
	else
		nExp = tostring(nExp)
		self.m_nFighting = 0 - nExp
		nExp = nExp:gsub("-","")
		icon = "ui/common_num/commom_num_zdljian2.png"
		wordImg = "ui/common/commom_icon_zdljian.png"
		symbolImg = "ui/common/commom_icon_zdljian2.png"
		--设置图片数字
		local label = GetElement(self.m_root,"ttfNum_WndFighting",WZUILabelAtlasFont)
		label:setText(0)
		GetElement(self.m_root,"ttfNum1_WndFighting",WZUILabelAtlasFont):setVisible(false)
		GetElement(self.m_root,"fightingUp",WZUIImage):setVisible(false)
	end
	WZLog("WndFighting:_update1",nExp)
	self.m_root:setTag(1)
	--获得经验位数
	local digit = (math.floor(math.log10(nExp))+1)
	--根据战斗力位数调整窗口位置
	GetElement(self.m_root,"con_WndFighting",WZUIContainer):setRelativePosition(ccp(0.56-0.015*(digit-1),0.5))
	--设置加减号
	local symbol = GetElement(self.m_root,"imgSymbol_WndFighting",WZUIImage)
	symbol:setFile(symbolImg)
	--symbol:setVisible(false)
	--设置战斗力图片
	local word = GetElement(self.m_root,"imgWord_WndFighting",WZUIImage)
	word:setFile(wordImg)

	--变化战斗力数字
	self.m_nTime = 0
	self.m_root:enableSchedule("aniForNum", 0.02)
	SoundManager:playEffectSound(SoundDefine.E_S_FIGHTING)
end

--@brief	战斗力变化
function WndFighting:aniForNum(element,t)
	local count = 20
	if self.m_nTime <= count then
		--local fighting = CacheCenter:getPlayerInfo().fighting - self.m_nFighting + math.floor(self.m_nFighting/count*self.m_nTime)
		local fighting = math.floor(self.m_nFighting/count*self.m_nTime)
		GetElement(self.m_root,"ttfNum_WndFighting",WZUILabelAtlasFont):setText(fighting)
		GetElement(self.m_root,"ttfNum1_WndFighting",WZUILabelAtlasFont):setText(fighting)
		self.m_nTime = self.m_nTime + 1
	else
		GetElement(self.m_root,"ttfNum_WndFighting",WZUILabelAtlasFont):setText(self.m_nFighting)
		GetElement(self.m_root,"ttfNum1_WndFighting",WZUILabelAtlasFont):setText(self.m_nFighting)
		element:disableSchedule()
	end
end

--@brief	动画完成时的回调方法
--@note		动画完成后移除窗口
function WndFighting:onFinish(element)
    if self.m_root then
        WindowManager:removeWindow(self.m_root, self, true)
    --    self.m_root:removeFromParentAndCleanup(true)
    end
end
-------------------------------------私有方法模块End----------------------------------------
