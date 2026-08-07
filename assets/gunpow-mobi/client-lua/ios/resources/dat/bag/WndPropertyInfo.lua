--WndPropertyInfo.lua
--@brief	WndPropertyInfo的UI模块
--@date		2017/05/26
--@author	zsq
--@note		属性信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPropertyInfo:onEnter(element)
	self.m_root = element
end

function WndPropertyInfo:onEnterTransitionDidFinish(element)
	self:_setUIStaticText()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPropertyInfo:onExit(element)
	self:_unInit()
end

function WndPropertyInfo:onTempClose() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	外部调用接口
function WndPropertyInfo:show(tData)
	if tData == nil then return end
	-- body
	local wnd = WndPropertyInfo:createElement()
	WindowManager:addWindow(wnd,WndPropertyInfo,nil,nil,nil,true)
	self.m_tData = tData
	self:update()
	AdaptLanguage(self)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPropertyInfo:update() 
	--设置属性
	local otherInfo = {}
	otherInfo[1] = self.m_tData.hp
	otherInfo[2] = self.m_tData.attack
	otherInfo[3] = self.m_tData.defend
	otherInfo[4] = self.m_tData.critRate
	otherInfo[5] = self.m_tData.reduceCrit
	otherInfo[6] = self.m_tData.injuryFree
	otherInfo[7] = self.m_tData.physique
	otherInfo[8] = self.m_tData.force
	otherInfo[9] = self.m_tData.armor
	otherInfo[10] = self.m_tData.agility
	otherInfo[11] = self.m_tData.luck
	otherInfo[12] = self.m_tData.wreckDefense
	otherInfo[13] = self.m_tData.range
	for i = 1, #otherInfo do
		GetElement(self.m_root,"attr" .. i .. "_WndPlayerInfo",WZUILabelTTF):setText(otherInfo[i])
	end

	local myInfo = {}
	myInfo[1] = CacheCenter:getPlayerInfo().hp
	myInfo[2] = CacheCenter:getPlayerInfo().attack
	myInfo[3] = CacheCenter:getPlayerInfo().defend
	myInfo[4] = CacheCenter:getPlayerInfo().critRate
	myInfo[5] = CacheCenter:getPlayerInfo().reduceCrit
	myInfo[6] = CacheCenter:getPlayerInfo().injuryFree
	myInfo[7] = CacheCenter:getPlayerInfo().physique
	myInfo[8] = CacheCenter:getPlayerInfo().force
	myInfo[9] = CacheCenter:getPlayerInfo().armor
	myInfo[10] = CacheCenter:getPlayerInfo().agility
	myInfo[11] = CacheCenter:getPlayerInfo().luck
	myInfo[12] = CacheCenter:getPlayerInfo().wreckDefense
	myInfo[13] = CacheCenter:getPlayerInfo().range

	if self.m_tData.id ~= CacheCenter:getPlayerInfo().id then 
		for i = 1, 13 do
			GetElement(self.m_root, "conMyAtt" .. i .. "_WndPropertyInfo", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "txtMyAtt" .. i .. "_WndPropertyInfo", WZUILabelTTF):setText("(" .. myInfo[i] .. ")")
			if myInfo[i] > otherInfo[i] then 
				GetElement(self.m_root, "imgState" .. i .. "_WndPropertyInfo", WZUIImage):setFile("ui/common/battle_icon_shangsheng.png")
			elseif myInfo[i] < otherInfo[i] then 
				GetElement(self.m_root, "imgState" .. i .. "_WndPropertyInfo", WZUIImage):setFile("ui/common/battle_icon_xiajiang.png")
			else
				GetElement(self.m_root, "imgState" .. i .. "_WndPropertyInfo", WZUIImage):setVisible(false)
			end
		end
	end

	local tData = {
		attrInfo1=string.format([[<T C="105,65,46" S="20" P="0">%s:</T><T C="105,65,46" S="20" P="0">%s</T>]],LocalStrings.HEALTH,LocalStrings.ATTRTIP1),
		attrInfo2=string.format([[<T C="105,65,46" S="20" P="0">%s:</T><T C="105,65,46" S="20" P="0">%s</T>]],LocalStrings.ATTACK,LocalStrings.ATTRTIP2),
		attrInfo3=string.format([[<T C="105,65,46" S="20" P="0">%s:</T><T C="105,65,46" S="20" P="0">%s</T>]],LocalStrings.DEFENSE,LocalStrings.ATTRTIP3),
		attrInfo4=string.format([[<T C="105,65,46" S="20" P="0">%s:</T><T C="105,65,46" S="20" P="0">%s</T>]],LocalStrings.CRIT,LocalStrings.ATTRTIP4),
		attrInfo5=string.format([[<T C="105,65,46" S="20" P="0">%s:</T><T C="105,65,46" S="20" P="0">%s</T>]],LocalStrings.FREESTORM,LocalStrings.ATTRTIP5),
		attrInfo6=string.format([[<T C="105,65,46" S="20" P="0">%s:</T><T C="105,65,46" S="20" P="0">%s</T>]],LocalStrings.TIZHI,LocalStrings.ATTRTIP6),
		attrInfo7=string.format([[<T C="105,65,46" S="20" P="0">%s:</T><T C="105,65,46" S="20" P="0">%s</T>]],LocalStrings.POWER,LocalStrings.ATTRTIP7),
		attrInfo8=string.format([[<T C="105,65,46" S="20" P="0">%s:</T><T C="105,65,46" S="20" P="0">%s</T>]],LocalStrings.PRACTICE_ARMOR,LocalStrings.ATTRTIP8),
		attrInfo9=string.format([[<T C="105,65,46" S="20" P="0">%s:</T><T C="105,65,46" S="20" P="0">%s</T>]],LocalStrings.AGILITY,LocalStrings.ATTRTIP9),
		attrInfo10=string.format([[<T C="105,65,46" S="20" P="0">%s:</T><T C="105,65,46" S="20" P="0">%s</T>]],LocalStrings.LUCKY,LocalStrings.ATTRTIP10),
		attrInfo11=string.format([[<T C="105,65,46" S="20" P="0">%s:</T><T C="105,65,46" S="20" P="0">%s</T>]],LocalStrings.ANTIBREAKING,LocalStrings.ATTRTIP11),
		attrInfo12=string.format([[<T C="105,65,46" S="20" P="0">%s:</T><T C="105,65,46" S="20" P="0">%s</T>]],LocalStrings.AVOIDINJURY,LocalStrings.ATTRTIP12),
		attrInfo13=string.format([[<T C="105,65,46" S="20" P="0">%s:</T><T C="105,65,46" S="20" P="0">%s</T>]],LocalStrings.RANGE,LocalStrings.ATTRTIP13),
	}
	for i=1,13 do
		GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox):setShowText(tData["attrInfo"..i])
	end
end

--@brief	设置控件静态文本
function WndPropertyInfo:_setUIStaticText()
	--属性名称
	GetElement(self.m_root,"attrTitle1_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.HEALTH..":")
	GetElement(self.m_root,"attrTitle2_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.ATTACK..":")
	GetElement(self.m_root,"attrTitle3_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.DEFENSE..":")
	GetElement(self.m_root,"attrTitle4_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.CRIT..":")
	GetElement(self.m_root,"attrTitle5_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.FREESTORM..":")
	GetElement(self.m_root,"attrTitle6_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.AVOIDINJURY..":")
	GetElement(self.m_root,"attrTitle7_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.TIZHI..":")
	GetElement(self.m_root,"attrTitle8_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.POWER..":")
	GetElement(self.m_root,"attrTitle9_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.PRACTICE_ARMOR..":")
	GetElement(self.m_root,"attrTitle10_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.AGILITY..":")
	GetElement(self.m_root,"attrTitle11_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.LUCKY..":")
	GetElement(self.m_root,"attrTitle12_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.ANTIBREAKING..":")
	GetElement(self.m_root,"attrTitle13_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.RANGE..":")
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndPropertyInfo:_adaptLanguage_vn(  )
    GetElement(self.m_root,"attrTitle1_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle2_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle3_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle4_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle5_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle6_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle7_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle8_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle9_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle10_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle11_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle12_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle13_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    local attr1 = GetElement(self.m_root,"attr1_WndPlayerInfo",WZUILabelTTF)
    attr1:setScale(0.8)
    local attr2 =  GetElement(self.m_root,"attr2_WndPlayerInfo",WZUILabelTTF)
    attr2:setScale(0.8)
    local attr3 = GetElement(self.m_root,"attr3_WndPlayerInfo",WZUILabelTTF)
    attr3:setScale(0.8)
    local attr4 =  GetElement(self.m_root,"attr4_WndPlayerInfo",WZUILabelTTF)
    attr4:setScale(0.8)
    local attr5 = GetElement(self.m_root,"attr5_WndPlayerInfo",WZUILabelTTF)
    attr5:setScale(0.8)
    local attr6 = GetElement(self.m_root,"attr6_WndPlayerInfo",WZUILabelTTF)
    attr6:setScale(0.8)
    local attr7 = GetElement(self.m_root,"attr7_WndPlayerInfo",WZUILabelTTF)
    attr7:setScale(0.8)
    local attr8 = GetElement(self.m_root,"attr8_WndPlayerInfo",WZUILabelTTF)
    attr8:setScale(0.8)
    local attr9 = GetElement(self.m_root,"attr9_WndPlayerInfo",WZUILabelTTF)
    attr9:setScale(0.8)
    local attr10 = GetElement(self.m_root,"attr10_WndPlayerInfo",WZUILabelTTF)
    attr10:setScale(0.8)
    local attr11 = GetElement(self.m_root,"attr11_WndPlayerInfo",WZUILabelTTF)
    attr11:setScale(0.8)
    local attr12 = GetElement(self.m_root,"attr12_WndPlayerInfo",WZUILabelTTF)
    attr12:setScale(0.8)
    local attr13 = GetElement(self.m_root,"attr13_WndPlayerInfo",WZUILabelTTF)
    attr13:setScale(0.8)

    attr1:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
    attr2:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
    attr3:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
    attr4:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
    attr5:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
    attr6:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
    attr7:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
    attr8:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
    attr9:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
    attr10:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
    attr11:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
    attr12:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
    attr13:setRelativePosition(GlobalMethod:ccp(0.58,0.5))

	for i=1,13 do
		local conMyAtt = GetElement(self.m_root,"conMyAtt"..i.."_WndPropertyInfo",WZUIContainer)
		conMyAtt:setScale(0.8)
		local attrInfo = GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox)
		attrInfo:setScale(0.7)
		attrInfo:setMaxWidth(560)
	end
end

function WndPropertyInfo:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtUser_WndPlayerInfo",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"attrTitle1_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle2_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle3_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle4_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle5_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle6_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle7_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle8_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle9_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle10_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle11_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle12_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle13_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
	local attr1 = GetElement(self.m_root,"attr1_WndPlayerInfo",WZUILabelTTF)
    attr1:setScale(0.8)
    local attr2 =  GetElement(self.m_root,"attr2_WndPlayerInfo",WZUILabelTTF)
    attr2:setScale(0.8)
    local attr3 = GetElement(self.m_root,"attr3_WndPlayerInfo",WZUILabelTTF)
    attr3:setScale(0.8)
    local attr4 =  GetElement(self.m_root,"attr4_WndPlayerInfo",WZUILabelTTF)
    attr4:setScale(0.8)
    local attr5 = GetElement(self.m_root,"attr5_WndPlayerInfo",WZUILabelTTF)
    attr5:setScale(0.8)
    local attr6 = GetElement(self.m_root,"attr6_WndPlayerInfo",WZUILabelTTF)
    attr6:setScale(0.8)
    local attr7 = GetElement(self.m_root,"attr7_WndPlayerInfo",WZUILabelTTF)
    attr7:setScale(0.8)
    local attr8 = GetElement(self.m_root,"attr8_WndPlayerInfo",WZUILabelTTF)
    attr8:setScale(0.8)
    local attr9 = GetElement(self.m_root,"attr9_WndPlayerInfo",WZUILabelTTF)
    attr9:setScale(0.8)
    local attr10 = GetElement(self.m_root,"attr10_WndPlayerInfo",WZUILabelTTF)
    attr10:setScale(0.8)
    local attr11 = GetElement(self.m_root,"attr11_WndPlayerInfo",WZUILabelTTF)
    attr11:setScale(0.8)
    local attr12 = GetElement(self.m_root,"attr12_WndPlayerInfo",WZUILabelTTF)
    attr12:setScale(0.8)
    local attr13 = GetElement(self.m_root,"attr13_WndPlayerInfo",WZUILabelTTF)
    attr13:setScale(0.8)
    attr1:setRelativePosition(GlobalMethod:ccp(0.28,0.5))
    attr2:setRelativePosition(GlobalMethod:ccp(0.34,0.5))
    attr3:setRelativePosition(GlobalMethod:ccp(0.346667,0.5))
    attr4:setRelativePosition(GlobalMethod:ccp(0.306667,0.5))
    attr5:setRelativePosition(GlobalMethod:ccp(0.613333,0.5))
    attr6:setRelativePosition(GlobalMethod:ccp(0.68,0.5))
    attr7:setRelativePosition(GlobalMethod:ccp(0.52,0.5))
    attr8:setRelativePosition(GlobalMethod:ccp(0.54,0.5))
    attr9:setRelativePosition(GlobalMethod:ccp(0.433333,0.5))
    attr10:setRelativePosition(GlobalMethod:ccp(0.446667,0.5))
    attr11:setRelativePosition(GlobalMethod:ccp(0.36,0.5))
    attr12:setRelativePosition(GlobalMethod:ccp(0.579629,0.497783))
    attr13:setRelativePosition(GlobalMethod:ccp(0.446667,0.5))
end

function WndPropertyInfo:_adaptLanguage_th(  )
	GetElement(self.m_root,"attrTitle1_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle2_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle3_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle4_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle5_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle6_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle7_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle8_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle9_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle10_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle11_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle12_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle13_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
	local attr1 = GetElement(self.m_root,"attr1_WndPlayerInfo",WZUILabelTTF)
    attr1:setScale(0.8)
    local attr2 =  GetElement(self.m_root,"attr2_WndPlayerInfo",WZUILabelTTF)
    attr2:setScale(0.8)
    local attr3 = GetElement(self.m_root,"attr3_WndPlayerInfo",WZUILabelTTF)
    attr3:setScale(0.8)
    local attr4 =  GetElement(self.m_root,"attr4_WndPlayerInfo",WZUILabelTTF)
    attr4:setScale(0.8)
    local attr5 = GetElement(self.m_root,"attr5_WndPlayerInfo",WZUILabelTTF)
    attr5:setScale(0.8)
    local attr6 = GetElement(self.m_root,"attr6_WndPlayerInfo",WZUILabelTTF)
    attr6:setScale(0.8)
    local attr7 = GetElement(self.m_root,"attr7_WndPlayerInfo",WZUILabelTTF)
    attr7:setScale(0.8)
    local attr8 = GetElement(self.m_root,"attr8_WndPlayerInfo",WZUILabelTTF)
    attr8:setScale(0.8)
    local attr9 = GetElement(self.m_root,"attr9_WndPlayerInfo",WZUILabelTTF)
    attr9:setScale(0.8)
    local attr10 = GetElement(self.m_root,"attr10_WndPlayerInfo",WZUILabelTTF)
    attr10:setScale(0.8)
    local attr11 = GetElement(self.m_root,"attr11_WndPlayerInfo",WZUILabelTTF)
    attr11:setScale(0.8)
    local attr12 = GetElement(self.m_root,"attr12_WndPlayerInfo",WZUILabelTTF)
    attr12:setScale(0.8)
    local attr13 = GetElement(self.m_root,"attr13_WndPlayerInfo",WZUILabelTTF)
    attr13:setScale(0.8)
    attr1:setRelativePosition(GlobalMethod:ccp(0.28,0.5))
    attr2:setRelativePosition(GlobalMethod:ccp(0.34,0.5))
    attr3:setRelativePosition(GlobalMethod:ccp(0.346667,0.5))
    attr4:setRelativePosition(GlobalMethod:ccp(0.366667,0.5))
    attr5:setRelativePosition(GlobalMethod:ccp(0.553333,0.5))
    attr6:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
    attr7:setRelativePosition(GlobalMethod:ccp(0.346667,0.5))
    attr8:setRelativePosition(GlobalMethod:ccp(0.326667,0.5))
    attr9:setRelativePosition(GlobalMethod:ccp(0.486667,0.5))
    attr10:setRelativePosition(GlobalMethod:ccp(0.333333,0.5))
    attr11:setRelativePosition(GlobalMethod:ccp(0.393333,0.5))
    attr12:setRelativePosition(GlobalMethod:ccp(0.412962,0.4977833))
    attr13:setRelativePosition(GlobalMethod:ccp(0.506667,0.5))

    for i=1,13 do
        local attrInfo = GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox)
        attrInfo:setScale(0.8)
        attrInfo:setMaxWidth(560)
    end
end

function WndPropertyInfo:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtUser_WndPlayerInfo",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"attrTitle1_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle2_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle3_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle4_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle5_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle6_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle7_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle8_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle9_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle10_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle11_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle12_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle13_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
	local attr1 = GetElement(self.m_root,"attr1_WndPlayerInfo",WZUILabelTTF)
    attr1:setScale(0.8)
    local attr2 =  GetElement(self.m_root,"attr2_WndPlayerInfo",WZUILabelTTF)
    attr2:setScale(0.8)
    local attr3 = GetElement(self.m_root,"attr3_WndPlayerInfo",WZUILabelTTF)
    attr3:setScale(0.8)
    local attr4 =  GetElement(self.m_root,"attr4_WndPlayerInfo",WZUILabelTTF)
    attr4:setScale(0.8)
    local attr5 = GetElement(self.m_root,"attr5_WndPlayerInfo",WZUILabelTTF)
    attr5:setScale(0.8)
    local attr6 = GetElement(self.m_root,"attr6_WndPlayerInfo",WZUILabelTTF)
    attr6:setScale(0.8)
    local attr7 = GetElement(self.m_root,"attr7_WndPlayerInfo",WZUILabelTTF)
    attr7:setScale(0.8)
    local attr8 = GetElement(self.m_root,"attr8_WndPlayerInfo",WZUILabelTTF)
    attr8:setScale(0.8)
    local attr9 = GetElement(self.m_root,"attr9_WndPlayerInfo",WZUILabelTTF)
    attr9:setScale(0.8)
    local attr10 = GetElement(self.m_root,"attr10_WndPlayerInfo",WZUILabelTTF)
    attr10:setScale(0.8)
    local attr11 = GetElement(self.m_root,"attr11_WndPlayerInfo",WZUILabelTTF)
    attr11:setScale(0.8)
    local attr12 = GetElement(self.m_root,"attr12_WndPlayerInfo",WZUILabelTTF)
    attr12:setScale(0.8)
    local attr13 = GetElement(self.m_root,"attr13_WndPlayerInfo",WZUILabelTTF)
    attr13:setScale(0.8)
    attr1:setRelativePosition(GlobalMethod:ccp(0.28,0.5))
    attr2:setRelativePosition(GlobalMethod:ccp(0.34,0.5))
    attr3:setRelativePosition(GlobalMethod:ccp(0.346667,0.5))
    attr4:setRelativePosition(GlobalMethod:ccp(0.306667,0.5))
    attr5:setRelativePosition(GlobalMethod:ccp(0.613333,0.5))
    attr6:setRelativePosition(GlobalMethod:ccp(0.68,0.5))
    attr7:setRelativePosition(GlobalMethod:ccp(0.52,0.5))
    attr9:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
    attr10:setRelativePosition(GlobalMethod:ccp(0.66,0.5))
    attr12:setRelativePosition(GlobalMethod:ccp(0.579629,0.497783))
    attr13:setRelativePosition(GlobalMethod:ccp(0.54,0.5))

    for i=1,13 do
    	GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox):setScale(0.8)
    end
end

function WndPropertyInfo:_adaptLanguage_es(  )
	local txtUser = GetElement(self.m_root,"txtUser_WndPlayerInfo",WZUILabelTTF)
    txtUser:setScale(0.7)
    txtUser:setDimensions(GlobalMethod:CCSize(110,0))

	GetElement(self.m_root,"attrTitle1_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle2_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle3_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle4_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle5_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle6_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle7_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle8_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle9_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle10_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle11_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle12_WndPlayerInfo",WZUILabelTTF):setScale(0.6)
    GetElement(self.m_root,"attrTitle13_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
	local attr1 = GetElement(self.m_root,"attr1_WndPlayerInfo",WZUILabelTTF)
    attr1:setScale(0.8)
    local attr2 =  GetElement(self.m_root,"attr2_WndPlayerInfo",WZUILabelTTF)
    attr2:setScale(0.8)
    local attr3 = GetElement(self.m_root,"attr3_WndPlayerInfo",WZUILabelTTF)
    attr3:setScale(0.8)
    local attr4 =  GetElement(self.m_root,"attr4_WndPlayerInfo",WZUILabelTTF)
    attr4:setScale(0.8)
    local attr5 = GetElement(self.m_root,"attr5_WndPlayerInfo",WZUILabelTTF)
    attr5:setScale(0.8)
    local attr6 = GetElement(self.m_root,"attr6_WndPlayerInfo",WZUILabelTTF)
    attr6:setScale(0.8)
    local attr7 = GetElement(self.m_root,"attr7_WndPlayerInfo",WZUILabelTTF)
    attr7:setScale(0.8)
    local attr8 = GetElement(self.m_root,"attr8_WndPlayerInfo",WZUILabelTTF)
    attr8:setScale(0.8)
    local attr9 = GetElement(self.m_root,"attr9_WndPlayerInfo",WZUILabelTTF)
    attr9:setScale(0.8)
    local attr10 = GetElement(self.m_root,"attr10_WndPlayerInfo",WZUILabelTTF)
    attr10:setScale(0.8)
    local attr11 = GetElement(self.m_root,"attr11_WndPlayerInfo",WZUILabelTTF)
    attr11:setScale(0.8)
    local attr12 = GetElement(self.m_root,"attr12_WndPlayerInfo",WZUILabelTTF)
    attr12:setScale(0.8)
    local attr13 = GetElement(self.m_root,"attr13_WndPlayerInfo",WZUILabelTTF)
    attr13:setScale(0.8)
    attr1:setRelativePosition(GlobalMethod:ccp(0.28,0.5))
    attr2:setRelativePosition(GlobalMethod:ccp(0.47,0.5))
    --attr3:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    attr4:setRelativePosition(GlobalMethod:ccp(0.306667,0.5))
    attr5:setRelativePosition(GlobalMethod:ccp(0.613333,0.5))
    attr6:setRelativePosition(GlobalMethod:ccp(0.68,0.5))
    attr7:setRelativePosition(GlobalMethod:ccp(0.52,0.5))
    --attr9:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
    attr10:setRelativePosition(GlobalMethod:ccp(0.66,0.5))
    attr12:setRelativePosition(GlobalMethod:ccp(0.7,0.497783))
    attr13:setRelativePosition(GlobalMethod:ccp(0.54,0.5))

    for i=1,13 do
    	local attrInfo = GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox)
    	attrInfo:setScale(0.7)
    	attrInfo:setMaxWidth(660)
    end
end

function WndPropertyInfo:_adaptLanguage_tr(  )
	local txtUser = GetElement(self.m_root,"txtUser_WndPlayerInfo",WZUILabelTTF)
	txtUser:setScale(0.7)
	txtUser:setDimensions(GlobalMethod:CCSize(130,0))

	GetElement(self.m_root,"attrTitle1_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle2_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle3_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle4_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle5_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle6_WndPlayerInfo",WZUILabelTTF):setScale(0.6)
    GetElement(self.m_root,"attrTitle7_WndPlayerInfo",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"attrTitle8_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle9_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle10_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle11_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle12_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"attrTitle13_WndPlayerInfo",WZUILabelTTF):setScale(0.8)
	local attr1 = GetElement(self.m_root,"attr1_WndPlayerInfo",WZUILabelTTF)
    attr1:setScale(0.8)
    local attr2 =  GetElement(self.m_root,"attr2_WndPlayerInfo",WZUILabelTTF)
    attr2:setScale(0.8)
    local attr3 = GetElement(self.m_root,"attr3_WndPlayerInfo",WZUILabelTTF)
    attr3:setScale(0.8)
    local attr4 =  GetElement(self.m_root,"attr4_WndPlayerInfo",WZUILabelTTF)
    attr4:setScale(0.8)
    local attr5 = GetElement(self.m_root,"attr5_WndPlayerInfo",WZUILabelTTF)
    attr5:setScale(0.8)
    local attr6 = GetElement(self.m_root,"attr6_WndPlayerInfo",WZUILabelTTF)
    attr6:setScale(0.8)
    local attr7 = GetElement(self.m_root,"attr7_WndPlayerInfo",WZUILabelTTF)
    attr7:setScale(0.8)
    local attr8 = GetElement(self.m_root,"attr8_WndPlayerInfo",WZUILabelTTF)
    attr8:setScale(0.8)
    local attr9 = GetElement(self.m_root,"attr9_WndPlayerInfo",WZUILabelTTF)
    attr9:setScale(0.8)
    local attr10 = GetElement(self.m_root,"attr10_WndPlayerInfo",WZUILabelTTF)
    attr10:setScale(0.8)
    local attr11 = GetElement(self.m_root,"attr11_WndPlayerInfo",WZUILabelTTF)
    attr11:setScale(0.8)
    local attr12 = GetElement(self.m_root,"attr12_WndPlayerInfo",WZUILabelTTF)
    attr12:setScale(0.8)
    local attr13 = GetElement(self.m_root,"attr13_WndPlayerInfo",WZUILabelTTF)
    attr13:setScale(0.8)
    attr1:setRelativePosition(GlobalMethod:ccp(0.28,0.5))
    attr2:setRelativePosition(GlobalMethod:ccp(0.34,0.5))
    attr3:setRelativePosition(GlobalMethod:ccp(0.346667,0.5))
    attr4:setRelativePosition(GlobalMethod:ccp(0.306667,0.5))
    attr5:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    attr6:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
    attr7:setRelativePosition(GlobalMethod:ccp(0.63,0.5))
    --attr9:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
    --attr10:setRelativePosition(GlobalMethod:ccp(0.66,0.5))
    --attr12:setRelativePosition(GlobalMethod:ccp(0.579629,0.497783))
    --attr13:setRelativePosition(GlobalMethod:ccp(0.54,0.5))

    for i=1,13 do
    	GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox):setScale(0.8)
    end
end
-------------------------------------语言适配End--------------------------------------------