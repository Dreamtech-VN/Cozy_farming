--WndMasterDisciple.lua
--@brief	WndMasterDisciple的UI模块
--@date		2021/09/02
--@author	hyx
--@note		师徒和徒弟共存的时候tips


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMasterDisciple:onEnter(element)
	self.m_root = element

	local con1 = GetElement(self.m_root,"con1", WZUIContainer)
	if con1 then
		con1:setVisible(false)
	end
	local con2 = GetElement(self.m_root,"con2", WZUIContainer)
	if con2 then
		con2:setVisible(false)
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMasterDisciple:onExit(element)
	self:_unInit()
end
function WndMasterDisciple:showInterface(data1, data2)
	local wndTips = WndMasterDisciple:createElement()
	if wndTips ~= nil then
	    WindowManager:addWindow(wndTips,WndMasterDisciple,nil,nil)
	end
	self:setData(data1, data2)
end
function WndMasterDisciple:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndMasterDisciple:actionCallback()
	--徒弟
	self:showMessage(1, self.m_tDiscipleData)
	--师傅
	self:showMessage(2, self.m_tMasterData)
end

function WndMasterDisciple:showMessage(index, data)
	WZLog("WndMasterDisciple:showMessage =", index)
	--WZLog("WndMasterDisciple:showMessage =", index, Serialize(data))
	--WZLog("WndMasterDisciple:showMessage WndCheckOther.m_tPlayerInfo=", index, Serialize(WndCheckOther.m_tPlayerInfo))
	local con = GetElement(self.m_root,"con"..index, WZUIContainer)
	if con then
		con:setVisible(false)
	end
	GetElement(con,"imgHeadType",WZUIImage):setFile(data.icon)
	GetElement(con,"ttf1Type",WZUILabelTTF):setText(data.title1)
	GetElement(con,"ttf3Type",WZUILabelTTF):setText(data.title3)
	--师徒列表
	local conList = GetElement(con, "conList_"..index, WZUIContainer)
	--有多个徒弟时，拉长底图，属性往下移
	--计算是否超过5个徒弟，超过则需要分页
	local maxCount = 5
	local nPages = (data.title2 ~= nil and #data.title2 > 1) and math.ceil(#data.title2 / maxCount) or 1
	WZLog("WndMasterDisciple:showMessage nPages=", nPages)
	if data.title2 ~= nil and #data.title2 > 1 then
		local nCount = (#data.title2 > maxCount) and maxCount or #data.title2
		conList:setAbsContentSize(GlobalMethod:CCSize(260 * nPages, 80 * nCount))
		conList:updateRelativeSize()
		con:setAbsContentSize(GlobalMethod:CCSize(260 * nPages, 312 + 80 * (nCount - 1)))
		con:updateRelativeSize()

		--设置两条分割线的缩放
		local fengexian01 = GetElement(con, "fengexian01_".."con"..index, WZUIImage)
		if fengexian01 then
			fengexian01:setScaleX(1.25 * nPages)
		end
		local fengexian02 = GetElement(con, "fengexian02_".."con"..index, WZUIImage)
		if fengexian02 then
			fengexian02:setScaleX(1.25 * nPages)
		end		
	end

	for i=1, #data.title2 do
		local tempCount = (#data.title2 > maxCount) and maxCount or #data.title2
		local tempPos = {130 + math.floor((i - 1) / maxCount) * 260, 40 + ((tempCount - 1) - ((i - 1) % maxCount)) * 80}
		WZLog("WndMasterDisciple:showMessage tempPos=", Serialize(tempPos))

		local tempInfo = data.title2[i]
		WZLog("WndMasterDisciple:showMessage tempInfo=", Serialize(tempInfo))
		local conHeadCell = WZUISystem:getInstance():createElement("conHeadCell")
		conHeadCell:setVisible(true)
		local conHead = GetElement(conHeadCell, "conHead", WZUIContainer)
		CellHead:show(conHead, tonumber(tempInfo.headId), tonumber(tempInfo.faceId), tonumber(tempInfo.sex), nil, nil, tonumber(tempInfo.vip), tonumber(tempInfo.headcolour))
		GetElement(conHeadCell, "btnHead", WZUIButton):setTag(tonumber(tempInfo.playerId))

		GetElement(conHeadCell,"ttf5Type",WZUILabelTTF):setText(data.title)
		GetElement(conHeadCell,"ttf7Type",WZUILabelTTF):setText(tempInfo.lv)
		GetElement(conHeadCell,"ttf8Type",WZUILabelTTF):setText(tempInfo.name)
		GetElement(conHeadCell,"ttf10Type",WZUILabelTTF):setText(tempInfo.fight)
		
		conHeadCell:setUseAbsCoordinate(true)
		conHeadCell:setAbsPosition(GlobalMethod:ccp(tempPos[1], tempPos[2]))
		conList:addChild(conHeadCell)
	end
	--加成战力
	local nFighting = WndCard:_caculateFighting(data.property)
	local conAttrType = GetElement(con,"conAttrType"..index,WZUIContainer)
	local txtFight = GetElement(conAttrType,"txtFight",WZUILabelTTF)
	GetElement(txtFight, "txtFighting", WZUILabelTTF):setText("+" .. nFighting .. LocalStrings.BATTLE)

	--属性加成
	GetElement(conAttrType,"label1Type",WZUILabelTTF):setText(data.attr1)
	GetElement(conAttrType,"label2Type",WZUILabelTTF):setText("+"..data.attrVal1)
	GetElement(conAttrType,"label3Type",WZUILabelTTF):setText(data.attr2)
	GetElement(conAttrType,"label4Type",WZUILabelTTF):setText("+"..data.attrVal2)
	GetElement(conAttrType,"label5Type",WZUILabelTTF):setText(data.attr3)
	GetElement(conAttrType,"label6Type",WZUILabelTTF):setText("+"..data.attrVal3)

	if con then
		con:setVisible(true)
	end
end

--@brief 	点击头像回调
function WndMasterDisciple:onClickHead(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	WndCheckOther:show(nTag)
	WindowManager:removeWindow(self.m_root, self, true)
end
function WndMasterDisciple:onBtnClose()
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
