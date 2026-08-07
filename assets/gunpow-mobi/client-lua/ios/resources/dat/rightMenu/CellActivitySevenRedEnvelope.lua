--CellActivitySevenRedEnvelope.lua
--@brief	CellActivitySevenRedEnvelope的UI模块
--@date		2016/08/11
--@author	Zsq
--@note		新角色红包


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellActivitySevenRedEnvelope:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	--self:update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellActivitySevenRedEnvelope:onExit(element)
	self:_unInit()
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellActivitySevenRedEnvelope:showWindow()
	local key
	if CacheCenter:getGameParam().isUseTicket == "0" then
		key = "id_70"
	else
		key = "id_1"
	end
    local name = GDatatab_item[key].name
    local path = GDatatab_item[key].icon
    local num =  0
    local quality = GDatatab_item[key].quality
	for i=1,7 do
		local parent = GetElement(self.m_root,"conZuan"..i.."_CellActivitySevenRedEnvelope",WZUIContainer)
		local celElement,tLuaObj = CellGoodItem:createElement()
		celElement:setScale(0.7)
        if celElement ~= nil then 
			num = self.rewardCounts[i]
    		local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		  	celElement = WZUIContainer:luaTo(celElement)
            tLuaObj:setCellGoodItem(itemInfo, 16)
            --tLuaObj:setItemClickFun(self, self.onClickItem)
            parent:addChild(celElement)
        end
		GetElement(self.m_root,"ttf"..i,WZUILabelTTF):setVisible(true)
		if num > 0 then
			GetElement(self.m_root,"ttf"..i,WZUILabelTTF):setVisible(false)
		end
		--是否已领取
		if self.status[i] == 0 then
			GetElement(self.m_root,"cover"..i,WZUI9Image):setVisible(false)
			GetElement(self.m_root,"release"..i,WZUIImage):setVisible(false)
		end
		if self.status[i] == 1 then
			GetElement(self.m_root,"ttf"..i,WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"cover"..i,WZUI9Image):setVisible(true)
			GetElement(self.m_root,"release"..i,WZUIImage):setVisible(true)
		end
	end

	--第七天不显示明日可领取项
	if self.status[6] == 1 then
		GetElement(self.m_root,"txtCost2_CellActivitySevenRedEnvelope",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"imgCostIcon2_CellActivitySevenRedEnvelope",WZUIImage):setVisible(false)
		GetElement(self.m_root,"get2",WZUILabelTTF):setVisible(false)

	end

    for i = 1, 4 do
        local imgCostIcon = GetElement(self.m_root, "imgCostIcon" .. i .. "_CellActivitySevenRedEnvelope", WZUIImage)
        if imgCostIcon then
        	if CacheCenter:getGameParam().isUseTicket == "0" then
            	imgCostIcon:setFile(GDatatab_item["id_70"].icon)
            else
            	imgCostIcon:setFile(GDatatab_item["id_1"].icon)
            end
            imgCostIcon:setScale(0.5)
        end
    end

	GetElement(self.m_root,"get1",WZUILabelTTF):setText(self.count)
	GetElement(self.m_root,"get2",WZUILabelTTF):setText(math.ceil(self.count/10))
	GetElement(self.m_root,"get3",WZUILabelTTF):setText(self.maxCount)
	GetElement(self.m_root,"get4",WZUILabelTTF):setText(math.ceil(self.maxCount/10))
end

function CellActivitySevenRedEnvelope:update()
	WZLog("CellActivitySevenRedEnvelope:update")
	--local text = GetElement(self.m_root,"text_CellActivitySevenRedEnvelope",WZUIFreeTextBox)
	--text:setShowText(string.format(LocalStrings.NEWYEARTIP7,"","",tostring(self.maxCount)))
end

function CellActivitySevenRedEnvelope:onRuleClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.SEVENDESC)
end
-------------------------------------私有方法模块End----------------------------------------

------------------------------------语言适配Begin-------------------------------------------
function CellActivitySevenRedEnvelope:_adaptLanguage_pt(  )
	for i=1,4 do
		local txtCost = GetElement(self.m_root,"txtCost"..i.."_CellActivitySevenRedEnvelope",WZUILabelTTF)
		txtCost:setScale(0.7)
	end
	local txtTime = GetElement(self.m_root,"txtTime_CellActivitySevenRedEnvelope",WZUILabelTTF)
	txtTime:setRelativePosition(GlobalMethod:ccp(0.43,0.5))
	
	local imgCost1 = GetElement(self.m_root,"imgCostIcon1_CellActivitySevenRedEnvelope",WZUIImage)
	imgCost1:setRelativePosition(GlobalMethod:ccp(0.28,0.675))

	local imgCost3 = GetElement(self.m_root,"imgCostIcon3_CellActivitySevenRedEnvelope",WZUIImage)
	imgCost3:setRelativePosition(GlobalMethod:ccp(0.3,0.266))
	
	local get1 = GetElement(self.m_root,"get1",WZUILabelTTF)
	get1:setRelativePosition(GlobalMethod:ccp(0.325,0.63))
	local get3 = GetElement(self.m_root,"get3",WZUILabelTTF)
	get3:setRelativePosition(GlobalMethod:ccp(0.345,0.24))
end

function CellActivitySevenRedEnvelope:_adaptLanguage_en(  )
	for i=1,4 do
		local txtCost = GetElement(self.m_root,"txtCost"..i.."_CellActivitySevenRedEnvelope",WZUILabelTTF)
		txtCost:setScale(0.8)
	end

	GetElement(self.m_root,"txtTime_CellActivitySevenRedEnvelope",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.38,0.5))

	GetElement(self.m_root,"imgCostIcon1_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.28,0.675))
	GetElement(self.m_root,"imgCostIcon3_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.28,0.266))

	GetElement(self.m_root,"get1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.31,0.63))
	GetElement(self.m_root,"get3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.31,0.24))
end

function CellActivitySevenRedEnvelope:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtTime_CellActivitySevenRedEnvelope",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.362,0.5))

	GetElement(self.m_root,"imgCostIcon1_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.295756,0.675))
	GetElement(self.m_root,"imgCostIcon2_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.821554,0.675))
	GetElement(self.m_root,"imgCostIcon3_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.28726,0.266))
	GetElement(self.m_root,"imgCostIcon4_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.873727,0.266))
	
	GetElement(self.m_root,"get1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.328478,0.63))
	GetElement(self.m_root,"get2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.855217,0.63))
	GetElement(self.m_root,"get3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.321957,0.24))
	GetElement(self.m_root,"get4",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.907391,0.24))
end

function CellActivitySevenRedEnvelope:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtTime_CellActivitySevenRedEnvelope",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.612,0.5))

	-- GetElement(self.m_root,"imgCost1_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.274348,0.675))
	-- GetElement(self.m_root,"get1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.306739,0.63))
	-- GetElement(self.m_root,"imgCost2_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.826522,0.675))
	-- GetElement(self.m_root,"get2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.857391,0.63))
	-- GetElement(self.m_root,"imgCost3_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.274348,0.266))
	-- GetElement(self.m_root,"get3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.306739,0.24))
	-- GetElement(self.m_root,"imgCost4_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.826522,0.266))
	-- GetElement(self.m_root,"get4",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.857391,0.24))

	GetElement(self.m_root,"imgCostIcon1_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.28,0.675))
	GetElement(self.m_root,"imgCostIcon2_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.845,0.675))
	GetElement(self.m_root,"imgCostIcon3_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.28,0.266))
	GetElement(self.m_root,"imgCostIcon4_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.845,0.266))

	GetElement(self.m_root,"get1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.32,0.63))
	GetElement(self.m_root,"get3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.32,0.24))
end
function CellActivitySevenRedEnvelope:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtTime_CellActivitySevenRedEnvelope",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.5))
	GetElement(self.m_root,"txtTimeWord_CellActivitySevenRedEnvelope",WZUILabelTTF):setFontSize(18)

	GetElement(self.m_root,"imgCostIcon1_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.295756,0.675))
	GetElement(self.m_root,"imgCostIcon2_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.821554,0.675))
	GetElement(self.m_root,"imgCostIcon3_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.28726,0.266))
	GetElement(self.m_root,"imgCostIcon4_CellActivitySevenRedEnvelope",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.873727,0.266))
	
	GetElement(self.m_root,"get1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.328478,0.63))
	GetElement(self.m_root,"get2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.855217,0.63))
	GetElement(self.m_root,"get3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.321957,0.24))
	GetElement(self.m_root,"get4",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.907391,0.24))

	for i=1,4 do
		local txtCost = GetElement(self.m_root,"txtCost"..i.."_CellActivitySevenRedEnvelope",WZUILabelTTF)
		txtCost:setScale(0.6)
	end
end


function CellActivitySevenRedEnvelope:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtTime_CellActivitySevenRedEnvelope",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.558,0.5))

	GetElement(self.m_root,"txtCost1_CellActivitySevenRedEnvelope",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCost2_CellActivitySevenRedEnvelope",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCost3_CellActivitySevenRedEnvelope",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCost4_CellActivitySevenRedEnvelope",WZUILabelTTF):setScale(0.8)

	local imgCost1 = GetElement(self.m_root,"imgCostIcon1_CellActivitySevenRedEnvelope",WZUIImage)
	imgCost1:setScale(0.5)
	imgCost1:setRelativePosition(GlobalMethod:ccp(0.28,0.675))
	local imgCost2 = GetElement(self.m_root,"imgCostIcon2_CellActivitySevenRedEnvelope",WZUIImage)
	imgCost2:setScale(0.5)
	imgCost2:setRelativePosition(GlobalMethod:ccp(0.85851,0.675))
	local imgCost3 = GetElement(self.m_root,"imgCostIcon3_CellActivitySevenRedEnvelope",WZUIImage)
	imgCost3:setScale(0.5)
	imgCost3:setRelativePosition(GlobalMethod:ccp(0.28,0.266))
	local imgCost4 = GetElement(self.m_root,"imgCostIcon4_CellActivitySevenRedEnvelope",WZUIImage)
	imgCost4:setScale(0.5)
	imgCost4:setRelativePosition(GlobalMethod:ccp(0.85851,0.266))

	local get1 = GetElement(self.m_root,"get1",WZUILabelTTF)
	get1:setScale(0.8)
	get1:setRelativePosition(GlobalMethod:ccp(0.31,0.63))
	local get2 = GetElement(self.m_root,"get2",WZUILabelTTF)
	get2:setScale(0.8)
	local get3 = GetElement(self.m_root,"get3",WZUILabelTTF)
	get3:setScale(0.8)
	get3:setRelativePosition(GlobalMethod:ccp(0.31,0.24))
	local get4 = GetElement(self.m_root,"get4",WZUILabelTTF)
	get4:setScale(0.8)
end
------------------------------------语言适配End----------------------------------------------