--CellFamilyShop.lua
--@brief	CellFamilyShop的UI模块
--@date		2017/08/01
--@author	zsq
--@note		家园商店


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFamilyShop:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFamilyShop:onExit(element)
	self:_unInit()
end

function CellFamilyShop:setData(tData) 
	WZLog("CellFamilyShop:setData")
	self.m_tData = tData
	self:_update()
end

--@brief	显示建筑描述
function CellFamilyShop:onDesc(element) 
	WZLog("CellFamilyShop:onDesc")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	GetElement(self.m_root,"conMain",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conDesc_CellFamilyShop",WZUIContainer):setVisible(true)
end

--@brief	显示建筑信息
function CellFamilyShop:onMain(element) 
	WZLog("CellFamilyShop:onMain")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	GetElement(self.m_root,"conMain",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conDesc_CellFamilyShop",WZUIContainer):setVisible(false)
end

function CellFamilyShop:onBuild() 
	WZLog("CellFamilyShop:onBuild")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	
	local tData = GDatatab_home_building["id_"..self.m_tData.configId]
	local houseLv = SceneFamily:getMainRoomLevel()
	local m_nFamilyLevel = SceneFamily.m_nFamilyLevel
	--升级家园解锁
	if type(tData.upgrade_condition) == "table" and tData.upgrade_condition[1][1] == -1 and m_nFamilyLevel < tData.upgrade_condition[1][2] then
		MsgBoxManager:showTipBox(string.format(LocalStrings.FAMILY_TEXT17, tonumber(tData.upgrade_condition[1][2])))
		return
	end
	--将主人房升至%s级以解锁
	if type(tData.upgrade_condition) == "table" and tData.upgrade_condition[2] ~= nil and tData.upgrade_condition[2][1] ~= -1 then
		local needHouseLv = GDatatab_home_building["id_"..tData.upgrade_condition[2][1]].level
		if houseLv < needHouseLv then
			MsgBoxManager:showTipBox(string.format(LocalStrings.FAMILYSHOP5, tostring(needHouseLv)))
			return
		end
	end
	--升级主人房可建造更多
	if self.m_tData.currentNum >= self.m_tData.numLimit then
		MsgBoxManager:showTipBox(LocalStrings.FAMILYSHOP6)
		return
	end

	CellFamilyShop.func = self
	
	--资源不足
	local money = CacheCenter:getPlayerItemCountById(tData.build_cost[1][1])
	WZLog("圣水数量", money)
	if self.m_tData.freeTimes >= 1 then
		--免费
	--elseif not JudgeMoneyIsEnough(tData.build_cost[1][1], tData.build_cost[1][2], nil, nil, 151, nil, nil, nil, nil, nil, call) then
	elseif not JudgeMoneyIsEnough(tData.build_cost[1][1], tData.build_cost[1][2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, CellFamilyShop.func, CellFamilyShop.func.call) then
		--MsgBoxManager:showTipBox(LocalStrings.FAMILYSHOP4)
		local isEndTeach, finishStep = TeachGroup1:isTeachFinish(45)
	    if isEndTeach ~= true then
			TeachGroup1:setTeachFinish(45,-1)
			TeachGroup1:removeTeach()
		end
		return
	end

	--开始建造
	SceneFamily:buildNewBuilding(self.m_tData.configId)
    WindowManager:removeWindow(WndFamilyShop.m_root, WndFamilyShop, true)
end

function CellFamilyShop:call() 
	WZLog("CellFamilyShop:call")
	SceneFamily:buildNewBuilding(CellFamilyShop.func.m_tData.configId)
   	WindowManager:removeWindow(WndFamilyShop.m_root, WndFamilyShop, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellFamilyShop:_update() 
	WZLog("CellFamilyShop:_update")
	if self.m_root == nil then return end

	local tData = GDatatab_home_building["id_"..self.m_tData.configId]
	GetElement(self.m_root,"buildName",WZUILabelTTF):setText(tData.name)

	--装饰物暂时没有
	local spine = GetElement(self.m_root,"spine_CellFamilyShop",WZUISpine)
	local tSpine = SplitStringWithSeparator(tData.animation,",")

	--用图片
	if tData.type == 2 and tData.sub_type == 6 then
		spine:setVisible(false)
		GetElement(self.m_root,"imgBuild",WZUIImage):setFile(tSpine[1]..tSpine[2]..".png")
	elseif tData.type == 1 and tData.sub_type == 7 then
		spine:setVisible(false)
		local imgBuild = GetElement(self.m_root,"imgBuild",WZUIImage)
		imgBuild:setFile(tSpine[1]..tSpine[2]..".png")
		imgBuild:setScale(0.17)
	-- elseif tData.type == 1 and tData.sub_type == 8 then --坐骑牧场
	-- 	GetElement(self.m_root,"imgBuild",WZUIImage):setRelativePosition(ccp(0.5,0.65))
	else
		if tSpine[1] ~= "mine" and tSpine[1] ~= "action" then
			spine:setFileAtlas("ui/family/building/"..tSpine[1]..".atlas")
			spine:setFileJson("ui/family/building/"..tSpine[1]..".json")
			spine:setVisible(true)
			spine:play(tSpine[2], true)
			if tData.size[1][1] == 1 then
				spine:setRelativePosition(ccp(0.5,0.65))
			elseif tData.size[1][1] == 2 then
				spine:setRelativePosition(ccp(0.5,0.5))
			elseif tData.size[1][1] == 3 then
				spine:setRelativePosition(ccp(0.5,0.45))
			elseif tData.size[1][1] == 4 then
				spine:setRelativePosition(ccp(0.5,0.4))
			end
		end
		if tData.type == 1 and (tData.sub_type == 5 or tData.sub_type == 6) then 
			spine:setScale(0.4)
			spine:setRelativePosition(ccp(0.5,0.5))
		elseif tData.type == 1 and tData.sub_type == 8 then --坐骑牧场
			spine:setRelativePosition(ccp(0.5,0.62))
		end
	end
	WZLog("CellFamilyShop:_update1", tData.id, tData.name)
	if tData.id == 40415 then
		WZLog("CellFamilyShop:_update2", tData.id, tData.name)
		spine:setScale(0.3)
		spine:setRelativePosition(ccp(0.5,0.5))
	end

	--建筑描述
	GetElement(self.m_root,"txtDesc",WZUILabelTTF):setText(tData.desc)

	--已建数量/上限
	GetElement(self.m_root,"buildNum",WZUILabelTTF):setText(self.m_tData.currentNum.."/"..self.m_tData.numLimit)
	--消耗时间
	local textTime 
	if tData.build_time < 60 then
		textTime = tData.build_time..LocalStrings.SECOND
	elseif tData.build_time < 3600 then
		textTime = math.floor(tData.build_time/60)..LocalStrings.MINUTE
	elseif tData.build_time < 86400 then
		textTime = math.floor(tData.build_time/3600)..LocalStrings.HOUR
	else
		textTime = math.floor(tData.build_time/86400)..LocalStrings.DAY
	end
	GetElement(self.m_root,"buildTime",WZUILabelTTF):setText(textTime)
	--建筑消耗
	GetElement(self.m_root,"imgCost_CellFamilyShop",WZUIImage):setFile(GDatatab_item["id_"..tData.build_cost[1][1]].icon)
	GetElement(self.m_root,"txtCost_CellFamilyShop",WZUILabelTTF):setText(tData.build_cost[1][2])
	--是否不可建筑
	if self.m_tData.numLimit == 0 then
		spine:setGrayRender(true)
	else
		spine:setGrayRender(false)
	end
	--是否免费
	if self.m_tData.freeTimes >= 1 then
		GetElement(self.m_root,"txtCost_CellFamilyShop",WZUILabelTTF):setText(LocalStrings.FAMILYSHOP18)
	end

	GetElement(self.m_root,"needLv",WZUILabelTTF):setText("")
	GetElement(self.m_root,"needHouseLv",WZUILabelTTF):setText("")
	local temp = LocalStrings.FAMILYSHOP14
	local houseLv = SceneFamily:getMainRoomLevel()
	local m_nFamilyLevel = SceneFamily.m_nFamilyLevel

	if m_nFamilyLevel == nil then m_nFamilyLevel = 1 end
	GetElement(self.m_root,"conBtm",WZUIContainer):setVisible(true)
	if temp == nil then temp = "需要%s级主人房" end
	--需要%d级家园
	if type(tData.upgrade_condition) == "table" and tData.upgrade_condition[1][1] == -1 and m_nFamilyLevel < tData.upgrade_condition[1][2] then
		GetElement(self.m_root,"needLv",WZUILabelTTF):setText(string.format(temp, tostring(tData.upgrade_condition[1][2])))
		GetElement(self.m_root,"conBtm",WZUIContainer):setVisible(false)
	end
	local temp1 = LocalStrings.FAMILYSHOP13
	--需要%d级主人房
	if type(tData.upgrade_condition) == "table" and tData.upgrade_condition[2] ~= nil and tData.upgrade_condition[2][1] ~= -1 then
		local needHouseLv = GDatatab_home_building["id_"..tData.upgrade_condition[2][1]].level
		if houseLv < needHouseLv then
		GetElement(self.m_root,"needHouseLv",WZUILabelTTF):setText(string.format(temp1, tostring(needHouseLv)))
		GetElement(self.m_root,"conBtm",WZUIContainer):setVisible(false)
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellFamilyShop:_adaptLanguage_th()
	GetElement(self.m_root,"txtBuilded_CellFamilyShop",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"buildName",WZUILabelTTF):setScale(0.7)
end	

function CellFamilyShop:_adaptLanguage_en()
	GetElement(self.m_root,"buildName",WZUILabelTTF):setScale(0.65)

	local needLv = GetElement(self.m_root,"needLv",WZUILabelTTF)
	needLv:setScale(0.7)
	needLv:setRelativePosition(GlobalMethod:ccp(0.04,0.254167))
	local needHouseLv = GetElement(self.m_root,"needHouseLv",WZUILabelTTF)
	needHouseLv:setScale(0.7)
	needHouseLv:setRelativePosition(GlobalMethod:ccp(0.04,0.183333))

	local txtDesc = GetElement(self.m_root,"txtDesc",WZUILabelTTF)
	txtDesc:setScale(0.8)
	txtDesc:setDimensions(GlobalMethod:CCSize(220,220))

	local imgCost = GetElement(self.m_root,"imgCost_CellFamilyShop",WZUIImage)
	imgCost:setRelativePosition(GlobalMethod:ccp(0.0975737,0.5))
	local txtCost = GetElement(self.m_root,"txtCost_CellFamilyShop",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.154651,0.45))
	txtCost:setScale(0.8)
end	

function CellFamilyShop:_adaptLanguage_vn()
	GetElement(self.m_root,"txtBuilded_CellFamilyShop",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"buildName",WZUILabelTTF):setScale(0.6)

	local needLv = GetElement(self.m_root,"needLv",WZUILabelTTF)
	needLv:setScale(0.7)
	needLv:setRelativePosition(GlobalMethod:ccp(0.04,0.254167))
	local needHouseLv = GetElement(self.m_root,"needHouseLv",WZUILabelTTF)
	needHouseLv:setScale(0.7)
	needHouseLv:setRelativePosition(GlobalMethod:ccp(0.04,0.183333))

	local txtDesc = GetElement(self.m_root,"txtDesc",WZUILabelTTF)
	txtDesc:setScale(0.8)
	txtDesc:setDimensions(GlobalMethod:CCSize(220,220))
end	

function CellFamilyShop:_adaptLanguage_es()
	local buildName = GetElement(self.m_root,"buildName",WZUILabelTTF)
	buildName:setScale(0.65)
	buildName:setDimensions(GlobalMethod:CCSize(230,0))

	local needLv = GetElement(self.m_root,"needLv",WZUILabelTTF)
	needLv:setScale(0.6)
	needLv:setRelativePosition(GlobalMethod:ccp(0.04,0.3))
	needLv:setDimensions(GlobalMethod:CCSize(350,0))

	local needHouseLv = GetElement(self.m_root,"needHouseLv",WZUILabelTTF)
	needHouseLv:setScale(0.6)
	needHouseLv:setRelativePosition(GlobalMethod:ccp(0.04,0.2))
	needHouseLv:setDimensions(GlobalMethod:CCSize(350,0))

	local txtBuilded = GetElement(self.m_root,"txtBuilded_CellFamilyShop",WZUILabelTTF)
	txtBuilded:setScale(0.8)
	txtBuilded:setRelativePosition(GlobalMethod:ccp(0.83,1.032))

	local txtDesc = GetElement(self.m_root,"txtDesc",WZUILabelTTF)
	txtDesc:setScale(0.8)
	txtDesc:setDimensions(GlobalMethod:CCSize(220,220))

	local imgCost = GetElement(self.m_root,"imgCost_CellFamilyShop",WZUIImage)
	imgCost:setRelativePosition(GlobalMethod:ccp(0.0975737,0.5))
	local txtCost = GetElement(self.m_root,"txtCost_CellFamilyShop",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.154651,0.45))
	txtCost:setScale(0.8)
end

function CellFamilyShop:_adaptLanguage_pt()
	local buildName = GetElement(self.m_root,"buildName",WZUILabelTTF)
	buildName:setScale(0.65)
	buildName:setDimensions(GlobalMethod:CCSize(230,0))

	local needLv = GetElement(self.m_root,"needLv",WZUILabelTTF)
	needLv:setScale(0.7)
	needLv:setRelativePosition(GlobalMethod:ccp(0.04,0.254167))
	
	local needHouseLv = GetElement(self.m_root,"needHouseLv",WZUILabelTTF)
	needHouseLv:setScale(0.7)
	needHouseLv:setRelativePosition(GlobalMethod:ccp(0.04,0.183333))

	local txtBuilded = GetElement(self.m_root,"txtBuilded_CellFamilyShop",WZUILabelTTF)
	txtBuilded:setScale(0.8)
	txtBuilded:setRelativePosition(GlobalMethod:ccp(0.83,1.032))

	local txtDesc = GetElement(self.m_root,"txtDesc",WZUILabelTTF)
	txtDesc:setScale(0.8)
	txtDesc:setDimensions(GlobalMethod:CCSize(220,220))

	local imgCost = GetElement(self.m_root,"imgCost_CellFamilyShop",WZUIImage)
	imgCost:setRelativePosition(GlobalMethod:ccp(0.0975737,0.5))
	local txtCost = GetElement(self.m_root,"txtCost_CellFamilyShop",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.154651,0.45))
	txtCost:setScale(0.8)
end	

function CellFamilyShop:_adaptLanguage_tr()
	local buildName = GetElement(self.m_root,"buildName",WZUILabelTTF)
	buildName:setScale(0.65)
	buildName:setDimensions(GlobalMethod:CCSize(230,0))

	local needLv = GetElement(self.m_root,"needLv",WZUILabelTTF)
	needLv:setScale(0.6)
	needLv:setRelativePosition(GlobalMethod:ccp(0.04,0.3))
	needLv:setDimensions(GlobalMethod:CCSize(350,0))

	local needHouseLv = GetElement(self.m_root,"needHouseLv",WZUILabelTTF)
	needHouseLv:setScale(0.6)
	needHouseLv:setRelativePosition(GlobalMethod:ccp(0.04,0.2))
	needHouseLv:setDimensions(GlobalMethod:CCSize(350,0))

	local txtBuilded = GetElement(self.m_root,"txtBuilded_CellFamilyShop",WZUILabelTTF)
	txtBuilded:setScale(0.8)
	txtBuilded:setRelativePosition(GlobalMethod:ccp(0.83,1.032))

	local txtDesc = GetElement(self.m_root,"txtDesc",WZUILabelTTF)
	txtDesc:setScale(0.8)
	txtDesc:setDimensions(GlobalMethod:CCSize(220,220))
end

function CellFamilyShop:_adaptLanguage_ug()
	local buildName = GetElement(self.m_root,"buildName",WZUILabelTTF)
	buildName:setScale(0.65)
	buildName:setDimensions(GlobalMethod:CCSize(230,0))

	local needLv = GetElement(self.m_root,"needLv",WZUILabelTTF)
	needLv:setScale(0.7)
	needLv:setRelativePosition(GlobalMethod:ccp(0.04,0.254167))
	
	local needHouseLv = GetElement(self.m_root,"needHouseLv",WZUILabelTTF)
	needHouseLv:setScale(0.7)
	needHouseLv:setRelativePosition(GlobalMethod:ccp(0.04,0.183333))

	local txtBuilded = GetElement(self.m_root,"txtBuilded_CellFamilyShop",WZUILabelTTF)
	txtBuilded:setScale(0.8)
	txtBuilded:setRelativePosition(GlobalMethod:ccp(0.83,1.032))

	local txtDesc = GetElement(self.m_root,"txtDesc",WZUILabelTTF)
	txtDesc:setScale(0.8)
	txtDesc:setDimensions(GlobalMethod:CCSize(220,220))

	local imgCost = GetElement(self.m_root,"imgCost_CellFamilyShop",WZUIImage)
	imgCost:setRelativePosition(GlobalMethod:ccp(0.0975737,0.5))
	local txtCost = GetElement(self.m_root,"txtCost_CellFamilyShop",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.154651,0.45))
	txtCost:setScale(0.8)
end	
---------------------------------------语言适配End---------------------------------------------