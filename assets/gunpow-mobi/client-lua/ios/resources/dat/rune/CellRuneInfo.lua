--CellRuneInfo.lua
--@brief	CellRuneInfo的UI模块
--@date		2017/03/21
--@author	qixiang
--@note		符文信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRuneInfo:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRuneInfo:onExit(element)
	self:_unInit()
end


--@brief  加载数据
function CellRuneInfo:onLoadData(element)
	local cellRuneInfo = CreateElement("CellRuneInfo")    
	element:addChild(cellRuneInfo)
	WZLog("CellRuneInfo:onLoadData")
	if self.m_nRuneId then
		local getElement = GetElement
		local imgRune = getElement(self.m_root,"imgRune_CellRuneInfo",WZUIImage)
		local txtRuneNum = getElement(self.m_root,"txtRuneNum_CellRuneInfo",WZUILabelTTF)

		txtRuneNum:setText("X"..self.m_nNum)
		local itemInfo = GDatatab_item["id_" .. self.m_nRuneId]
		imgRune:setFile(itemInfo.icon)
		local property = itemInfo.property
		local aTTR_TITLE = ATTR_TITLE
		for i,v in ipairs(property) do
			local propertyIndex = v[1]
			local proStr = aTTR_TITLE[propertyIndex]
			getElement(self.m_root,"txt" .. i .. "_CellRuneInfo",WZUILabelTTF):setText(proStr)
			getElement(self.m_root,"txtV" .. i .. "_CellRuneInfo",WZUILabelTTF):setText("+"..v[2])
			if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" then
				getElement(self.m_root,"txt" .. i .. "_CellRuneInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.49,1.1111111-i*0.2999999))
				getElement(self.m_root,"txtV" .. i .. "_CellRuneInfo",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.574,1.1111111-i*0.2999999))
			end
		end
	end
	AdaptLanguage(self)
end

--装载符文
function CellRuneInfo:onClickRuneCell(element)
	WZLog("CellRuneInfo:onClickRuneCell")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tClickBackFun then
		element = element:getParent()
		element = element:getParent()
		local tag = element:getTag()
		self.m_tClickBackFun(self.m_tClickBackLau,self.m_nRuneId,tag)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellRuneInfo:_adaptLanguage_es(  )
	local txt1 = GetElement(self.m_root,"txt1_CellRuneInfo",WZUILabelTTF)
	txt1:setRelativePosition(GlobalMethod:ccp(0.595,0.822222))
	txt1:setScale(0.75)
	local txt2 = GetElement(self.m_root,"txt2_CellRuneInfo",WZUILabelTTF)
	txt2:setRelativePosition(GlobalMethod:ccp(0.595,0.533333))
	txt2:setScale(0.75)
	local txt3 = GetElement(self.m_root,"txt3_CellRuneInfo",WZUILabelTTF)
	txt3:setRelativePosition(GlobalMethod:ccp(0.595,0.244444))
	txt3:setScale(0.75)

	local txtV1 = GetElement(self.m_root,"txtV1_CellRuneInfo",WZUILabelTTF)
	txtV1:setRelativePosition(GlobalMethod:ccp(0.637,0.822222))
	local txtV2 = GetElement(self.m_root,"txtV2_CellRuneInfo",WZUILabelTTF)
	txtV2:setRelativePosition(GlobalMethod:ccp(0.637,0.533333))
	local txtV3 = GetElement(self.m_root,"txtV3_CellRuneInfo",WZUILabelTTF)
	txtV3:setRelativePosition(GlobalMethod:ccp(0.637,0.244444))
end

function CellRuneInfo:_adaptLanguage_th(  )
	local txt1 = GetElement(self.m_root,"txt1_CellRuneInfo",WZUILabelTTF)
	txt1:setRelativePosition(GlobalMethod:ccp(0.6,0.822222))
	txt1:setScale(0.75)
	local txt2 = GetElement(self.m_root,"txt2_CellRuneInfo",WZUILabelTTF)
	txt2:setRelativePosition(GlobalMethod:ccp(0.6,0.533333))
	txt2:setScale(0.75)
	local txt3 = GetElement(self.m_root,"txt3_CellRuneInfo",WZUILabelTTF)
	txt3:setRelativePosition(GlobalMethod:ccp(0.6,0.244444))
	txt3:setScale(0.75)

	local txtV1 = GetElement(self.m_root,"txtV1_CellRuneInfo",WZUILabelTTF)
	txtV1:setScale(0.75)
	txtV1:setRelativePosition(GlobalMethod:ccp(0.637,0.822222))
	local txtV2 = GetElement(self.m_root,"txtV2_CellRuneInfo",WZUILabelTTF)
	txtV2:setScale(0.75)
	txtV2:setRelativePosition(GlobalMethod:ccp(0.637,0.533333))
	local txtV3 = GetElement(self.m_root,"txtV3_CellRuneInfo",WZUILabelTTF)
	txtV3:setScale(0.75)
	txtV3:setRelativePosition(GlobalMethod:ccp(0.637,0.244444))
end

function CellRuneInfo:_adaptLanguage_en(  )
	local txt1 = GetElement(self.m_root,"txt1_CellRuneInfo",WZUILabelTTF)
	txt1:setRelativePosition(GlobalMethod:ccp(0.6,0.822222))
	txt1:setScale(0.75)
	local txt2 = GetElement(self.m_root,"txt2_CellRuneInfo",WZUILabelTTF)
	txt2:setRelativePosition(GlobalMethod:ccp(0.6,0.533333))
	txt2:setScale(0.75)
	local txt3 = GetElement(self.m_root,"txt3_CellRuneInfo",WZUILabelTTF)
	txt3:setRelativePosition(GlobalMethod:ccp(0.6,0.244444))
	txt3:setScale(0.75)

	local txtV1 = GetElement(self.m_root,"txtV1_CellRuneInfo",WZUILabelTTF)
	txtV1:setScale(0.75)
	txtV1:setRelativePosition(GlobalMethod:ccp(0.637,0.822222))
	local txtV2 = GetElement(self.m_root,"txtV2_CellRuneInfo",WZUILabelTTF)
	txtV2:setScale(0.75)
	txtV2:setRelativePosition(GlobalMethod:ccp(0.637,0.533333))
	local txtV3 = GetElement(self.m_root,"txtV3_CellRuneInfo",WZUILabelTTF)
	txtV3:setScale(0.75)
	txtV3:setRelativePosition(GlobalMethod:ccp(0.637,0.244444))
end

function CellRuneInfo:_adaptLanguage_vn(  )
	local txt1 = GetElement(self.m_root,"txt1_CellRuneInfo",WZUILabelTTF)
	txt1:setRelativePosition(GlobalMethod:ccp(0.6,0.822222))
	txt1:setScale(0.75)
	local txt2 = GetElement(self.m_root,"txt2_CellRuneInfo",WZUILabelTTF)
	txt2:setRelativePosition(GlobalMethod:ccp(0.6,0.533333))
	txt2:setScale(0.75)
	local txt3 = GetElement(self.m_root,"txt3_CellRuneInfo",WZUILabelTTF)
	txt3:setRelativePosition(GlobalMethod:ccp(0.6,0.244444))
	txt3:setScale(0.75)

	local txtV1 = GetElement(self.m_root,"txtV1_CellRuneInfo",WZUILabelTTF)
	txtV1:setScale(0.75)
	txtV1:setRelativePosition(GlobalMethod:ccp(0.637,0.822222))
	local txtV2 = GetElement(self.m_root,"txtV2_CellRuneInfo",WZUILabelTTF)
	txtV2:setScale(0.75)
	txtV2:setRelativePosition(GlobalMethod:ccp(0.637,0.533333))
	local txtV3 = GetElement(self.m_root,"txtV3_CellRuneInfo",WZUILabelTTF)
	txtV3:setScale(0.75)
	txtV3:setRelativePosition(GlobalMethod:ccp(0.637,0.244444))
end

function CellRuneInfo:_adaptLanguage_pt(  )
	local txt1 = GetElement(self.m_root,"txt1_CellRuneInfo",WZUILabelTTF)
	txt1:setRelativePosition(GlobalMethod:ccp(0.6,0.822222))
	txt1:setScale(0.75)
	local txt2 = GetElement(self.m_root,"txt2_CellRuneInfo",WZUILabelTTF)
	txt2:setRelativePosition(GlobalMethod:ccp(0.6,0.533333))
	txt2:setScale(0.75)
	local txt3 = GetElement(self.m_root,"txt3_CellRuneInfo",WZUILabelTTF)
	txt3:setRelativePosition(GlobalMethod:ccp(0.6,0.244444))
	txt3:setScale(0.75)

	local txtV1 = GetElement(self.m_root,"txtV1_CellRuneInfo",WZUILabelTTF)
	txtV1:setScale(0.75)
	txtV1:setRelativePosition(GlobalMethod:ccp(0.637,0.822222))
	local txtV2 = GetElement(self.m_root,"txtV2_CellRuneInfo",WZUILabelTTF)
	txtV2:setScale(0.75)
	txtV2:setRelativePosition(GlobalMethod:ccp(0.637,0.533333))
	local txtV3 = GetElement(self.m_root,"txtV3_CellRuneInfo",WZUILabelTTF)
	txtV3:setScale(0.75)
	txtV3:setRelativePosition(GlobalMethod:ccp(0.637,0.244444))
end

function CellRuneInfo:_adaptLanguage_tr(  )
	local txt1 = GetElement(self.m_root,"txt1_CellRuneInfo",WZUILabelTTF)
	txt1:setRelativePosition(GlobalMethod:ccp(0.6,0.822222))
	txt1:setScale(0.6)
	local txt2 = GetElement(self.m_root,"txt2_CellRuneInfo",WZUILabelTTF)
	txt2:setRelativePosition(GlobalMethod:ccp(0.6,0.533333))
	txt2:setScale(0.6)
	local txt3 = GetElement(self.m_root,"txt3_CellRuneInfo",WZUILabelTTF)
	txt3:setRelativePosition(GlobalMethod:ccp(0.6,0.244444))
	txt3:setScale(0.6)

	local txtV1 = GetElement(self.m_root,"txtV1_CellRuneInfo",WZUILabelTTF)
	txtV1:setScale(0.8)
	txtV1:setRelativePosition(GlobalMethod:ccp(0.637,0.822222))
	local txtV2 = GetElement(self.m_root,"txtV2_CellRuneInfo",WZUILabelTTF)
	txtV2:setScale(0.8)
	txtV2:setRelativePosition(GlobalMethod:ccp(0.637,0.533333))
	local txtV3 = GetElement(self.m_root,"txtV3_CellRuneInfo",WZUILabelTTF)
	txtV3:setScale(0.8)
	txtV3:setRelativePosition(GlobalMethod:ccp(0.637,0.244444))
end
-------------------------------------语言适配End--------------------------------------------