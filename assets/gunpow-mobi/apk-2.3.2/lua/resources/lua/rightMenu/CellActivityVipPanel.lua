--CellActivityVipPanel.lua
--@brief	CellActivityVipPanel的UI模块
--@date		2015/07/04
--@author	weidong_wu
--@note		VIP等级礼包


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellActivityVipPanel:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	self:_setStaticTxtInfo()
	self.m_nMaxViplevel = GetMaxVipLevel()

    --非审核,形象改变
    if CacheCenter:getGameParam().gameStatus == "1" then
        local imgInstructor = GetElement(self.m_root, "imgInstructor_CellActivityVipPanel", WZUIImage)
        imgInstructor:setFile("ui/combat/common_pic_meinv4.png")
        imgInstructor:setFlipX(true)
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellActivityVipPanel:onExit(element)
	self:_unInit()
end


--@brief 	显示窗口
function CellActivityVipPanel:showWindow(  )
	local cur_viplevel = CacheCenter:getPlayerInfo().vipLevel
	local next_viplevel = cur_viplevel+1
	self:_setVIPIcon(cur_viplevel,next_viplevel)
	local nValues = self.maxCount-self.count
	self:_setRechargeValue(nValues, cur_viplevel)
	if cur_viplevel == self.m_nMaxViplevel then
		self:_setProgressPercentage(self.count,self.count)
	else
		self:_setProgressPercentage(self.count,self.maxCount)
	end
	self:_setRewardList()
end

--@brief 	移除已领取的奖励
function CellActivityVipPanel:removeItemByIndex( nIndex )
	WZLog("CellActivityVipPanel:removeItemByIndex index="..nIndex)
	local flconCellActivityVipPanel = GetElement(CellActivityVipPanel.m_current.m_root,"flconCellActivityVipPanel",WZUIFreeListContainer)
	if flconCellActivityVipPanel==nil then 
		WZLog("flconCellActivityVipPanel is nil")
		return 
	end 

	for idx=1,#CellActivityVipPanel.m_current.m_tActivityList do
		if tonumber(CellActivityVipPanel.m_current.m_tActivityList[idx].tips) == nIndex then
			CellActivityVipPanel.m_current.m_tActivityList[idx].status = 1
			break
		end
	end

	table.sort(CellActivityVipPanel.m_current.m_tActivityList, sortActivity)
	CellActivityVipPanel.m_current:_setRewardList()
	-- for i = 0, flconCellActivityVipPanel:size() - 1 do 
	-- 	local element = flconCellActivityVipPanel:getAt(i)
	-- 	if element == nil then return end
	-- 	element = WZUIContainer:luaTo(element)
	-- 	local tNewObj = element:getLuaObjectIndex()
	-- 	if tNewObj:getIndex() == nIndex then
	-- 		flconCellActivityVipPanel:removeAt(i)
	-- 		break
	-- 	end
	-- end

	-- flconCellActivityVipPanel:updateListItemPosition()
 --    flconCellActivityVipPanel:getMoveElement():setPositionY(flconCellActivityVipPanel:getMinPosition().y)
end

--@排序函数
function sortActivity(a, b)
	-- body
	local statusA = CellActivityVipPanel:changeValue(a)
	local statusB = CellActivityVipPanel:changeValue(b)
	if statusA ~= statusB then
		return statusA > statusB
	else
		return a.rewardId < b.rewardId
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief 设置静态初始文本
function CellActivityVipPanel:_setStaticTxtInfo(  )
	
	local txtCurVipExpValue_CellActivityPanel = GetElement(self.m_root,"txtCurVipExpValue_CellActivityPanel",WZUILabelTTF)
	if txtCurVipExpValue_CellActivityPanel~= nil then 
		txtCurVipExpValue_CellActivityPanel:setText("")
	end 
	local txtCurrVip1_CellActivityVipPanel = GetElement(self.m_root,"txtCurrVip1_CellActivityVipPanel",WZUILabelTTF)
	if txtCurrVip1_CellActivityVipPanel~=nil then 
	end 
	self:_setRechargeValue(0) 
	local txtCurrVip3_CellActivityVipPanel = GetElement(self.m_root,"txtCurrVip3_CellActivityVipPanel",WZUILabelTTF)
	if txtCurrVip3_CellActivityVipPanel~= nil then 
--		txtCurrVip3_CellActivityVipPanel:setText("10000")
	end  
end

--@brief 	设置再需要充值的钻石数
function CellActivityVipPanel:_setRechargeValue( nValues, cur_viplevel)
	local txtCurrVip2_CellActivityVipPanel = GetElement(self.m_root,"txtCurrVip2_CellActivityVipPanel",WZUILabelTTF)
	if txtCurrVip2_CellActivityVipPanel~= nil then 
		txtCurrVip2_CellActivityVipPanel:setText(nValues)
		if cur_viplevel == self.m_nMaxViplevel then
			txtCurrVip2_CellActivityVipPanel:setText(0)
		end
	end
end

--@brief 	设置VIP图标
function CellActivityVipPanel:_setVIPIcon(nCurrentVipLevel,nNextVipLevel)
	local txtCurrVip_CellActivityPanel = GetElement(self.m_root,"txtCurVip_CellActivityVipPanel",WZUILabelTTF)
	if txtCurrVip_CellActivityPanel~=nil then 
		txtCurrVip_CellActivityPanel:setText(LocalStrings.CHAT_CURRENT .. "VIP" .. tostring(nCurrentVipLevel) .. ":")
	end

	local imgCurrVip_CellActivityVipPanel = GetElement(self.m_root,"imgCurrVip_CellActivityVipPanel",WZUIImage)
	if imgCurrVip_CellActivityVipPanel== nil then 
		WZLog("imgCurrVip_CellActivityVipPanel is nil ")
		return 
	end 
	local imgNextVip_CellActivityPanel = GetElement(self.m_root,"imgNextVip_CellActivityPanel",WZUIImage)
	if imgNextVip_CellActivityPanel==nil then 
		WZLog("imgNextVip_CellActivityPanel is nil ")
		return 
	end 
	if nCurrentVipLevel<1 then 
		GetElement(self.m_root, "txtCurVipLevel_CellActivityVipPanel", WZUILabelAtlasFont):setText(nCurrentVipLevel)
		GetElement(self.m_root, "txtNextVipLevel_CellActivityVipPanel", WZUILabelAtlasFont):setText(nCurrentVipLevel + 1)
	else
		if nCurrentVipLevel == self.m_nMaxViplevel then 
			local txtCurrVip2_CellActivityVipPanel = GetElement(self.m_root,"txtCurrVip2_CellActivityVipPanel",WZUILabelTTF)
			if txtCurrVip2_CellActivityVipPanel~= nil then 
			--	txtCurrVip2_CellActivityVipPanel:setVisible(false)
			end 
			GetElement(self.m_root, "txtNextVipLevel_CellActivityVipPanel", WZUILabelAtlasFont):setText(nCurrentVipLevel)
		else 
			GetElement(self.m_root, "txtNextVipLevel_CellActivityVipPanel", WZUILabelAtlasFont):setText(nNextVipLevel)
		end 
		GetElement(self.m_root, "txtCurVipLevel_CellActivityVipPanel", WZUILabelAtlasFont):setText(nCurrentVipLevel)
	end 
end


--@brief 	设置当前进度
function CellActivityVipPanel:_setProgressPercentage( nCurrentTag,nTagetTag)
	local Percentage = string.format("%d/%d",nCurrentTag,nTagetTag)
	local PercentageValue = math.floor((nCurrentTag/nTagetTag)*100)
	local txtCurVipExpValue_CellActivityPanel = GetElement(self.m_root,"txtCurVipExpValue_CellActivityPanel",WZUILabelTTF)
	if txtCurVipExpValue_CellActivityPanel~= nil then 
		txtCurVipExpValue_CellActivityPanel:setText(Percentage)
	end 
	local progVipExpProgress_CellActivityVipPanel = GetElement(self.m_root,"progVipExpProgress_CellActivityVipPanel",WZUIProgress)
	if progVipExpProgress_CellActivityVipPanel~= nil then 
		progVipExpProgress_CellActivityVipPanel:setPercentage(PercentageValue)
	end 
end


--@brief 	设置奖励列表
function CellActivityVipPanel:_setRewardList(  )
	local flconCellActivityVipPanel = GetElement(self.m_root,"flconCellActivityVipPanel",WZUIFreeListContainer)
	if flconCellActivityVipPanel==nil then 
		return 
	end 
	if flconCellActivityVipPanel:size() >0 then 
		flconCellActivityVipPanel:removeAll()
	end 
	local itemCount = 1
	for idx=1,#self.m_tActivityList do
		local m_tData = self.m_tActivityList[idx].m_tData
		
		local element,tnewLua = CellActivityVipItem:createElement()
		tnewLua:setMessage(self.activityId,self.m_tActivityList[idx].status,m_tData,self.m_tActivityList[idx].rewardId,tonumber(self.m_tActivityList[idx].tips))
		tnewLua:setFunc(self.removeItemByIndex,CellActivityVipPanel)
		element:setContentSize(GlobalMethod:CCSize(640,120))
    	element:setRelativeSize(GlobalMethod:CCSize(1,120/340))
		flconCellActivityVipPanel:pushBack(WZUIContainer:luaTo(element))
	end
	flconCellActivityVipPanel:update()
    flconCellActivityVipPanel:getMoveElement():setPositionY(flconCellActivityVipPanel:getMinPosition().y)
end

function CellActivityVipPanel:_getMaxLevel()
	-- body
	return GetMaxVipLevel()
end


-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配模块Start--------------------------------------
--@brief 英文适配函数
--@note  英文适配
function CellActivityVipPanel:_adaptLanguage_en()
    local txtCurVip = GetElement(self.m_root, "txtCurVip_CellActivityVipPanel", WZUILabelTTF)
    if txtCurVip then
        txtCurVip:setFontSize(18)
    end
    local txt = GetElement(self.m_root,"txtCurrVip1_CellActivityVipPanel",WZUILabelTTF)
    txt:setFontSize(20)
    txt:setRelativePosition(GlobalMethod:ccp(1.07,0.5))
end

function CellActivityVipPanel:_adaptLanguage_pt(  )
	local txtCurVip = GetElement(self.m_root, "txtCurVip_CellActivityVipPanel", WZUILabelTTF)
    if txtCurVip then
        txtCurVip:setFontSize(18)
    end
    local txt = GetElement(self.m_root,"txtCurrVip1_CellActivityVipPanel",WZUILabelTTF)
    txt:setFontSize(20)
    txt:setRelativePosition(GlobalMethod:ccp(1.07,0.5))
end

function CellActivityVipPanel:_adaptLanguage_th()
    local txtCurVip = GetElement(self.m_root, "txtCurVip_CellActivityVipPanel", WZUILabelTTF)
    if txtCurVip then
        txtCurVip:setFontSize(20)
    end
end

function CellActivityVipPanel:_adaptLanguage_vn()
    local txtCurVip = GetElement(self.m_root, "txtCurVip_CellActivityVipPanel", WZUILabelTTF)
    if txtCurVip then
        txtCurVip:setFontSize(18)
        txtCurVip:setRelativePosition(GlobalMethod:ccp(-0.08,0.85))
    end
    local txtCurr = GetElement(self.m_root,"txtCurrVip1_CellActivityVipPanel",WZUILabelTTF)
    txtCurr:setRelativePosition(GlobalMethod:ccp(1.14091,0.5))
    txtCurr:setFontSize(20)
end

function CellActivityVipPanel:_adaptLanguage_es()
    local txtCurVip = GetElement(self.m_root, "txtCurVip_CellActivityVipPanel", WZUILabelTTF)
    txtCurVip:setFontSize(16)
   	txtCurVip:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
    
    local txtCurr = GetElement(self.m_root,"txtCurrVip1_CellActivityVipPanel",WZUILabelTTF)
    txtCurr:setRelativePosition(GlobalMethod:ccp(0.8,0.5))
end

function CellActivityVipPanel:_adaptLanguage_tr()
	GetElement(self.m_root, "txtCurVip_CellActivityVipPanel", WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,	"txtCurrVip1_CellActivityVipPanel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.35,0.5))
end
-------------------------------------语言适配模块End----------------------------------------
