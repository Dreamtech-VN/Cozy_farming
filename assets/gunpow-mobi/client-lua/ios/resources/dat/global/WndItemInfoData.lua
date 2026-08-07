--WndItemInfoData.lua
--@brief	WndItemInfo的数据模块
--@date		2014/09/01
--@author	liangguang_long
--@note		物品tip信息


WndItemInfo = {
	--请不要在这里定义变量
}


--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndItemInfo:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nIndexImg = 1				--图片索引
	self.m_tSuit = nil
	self.m_tExpired = nil				--过期回调
	self.m_tStreng = nil				--强化回调
	self.m_tWear = nil					--穿上回调
	self.m_tRoyal = nil					--御下
	self.m_tEquip = nil
	self.m_tUse = nil
	self.m_tFromLuaTable = nil
	self.m_tBasic = nil					--物品基本信息表
	self.m_tExtra = nil					--其它
	self.m_winH = nil
	self.m_tTryWear = nil
	self.m_tLay = nil
	self.m_tLua = nil
	self.m_WinPt = nil
	self.m_bButton = nil
	self.m_showLock = false
    self.m_ItemExpSize = CCSize(200,80)
    self.m_sButtonTitle = nil           --按钮文本
    self.m_fClickButton = nil           --点击按钮的回调
	self.m_nItemProHeight = 0
	self.m_nLineH = 0
	self.m_tBtnData = nil
	self.m_nSacleItem = 1
	self.m_nLineExitH = 0 
	self.m_nNotLineH = 10 
	self.m_tOther = nil 
	self.m_x = nil
	self.m_y = nil 
	self.m_nPowerSkillH = 0 
	self.m_nStone = 0 
	self.m_nState = 0					--窗口状态 1显示武器技能
	self.m_nBlankHeight = 0				--空白高度
	self.m_nTag = nil
	self.m_tCell = nil
	self.m_nGiftNum = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndItemInfo:_unInit()
	self.m_root = nil
	self.m_nIndexImg = nil				--图片索引
	self.m_tStone = nil					--
	self.m_tSuit = nil
	self.m_tExpired = nil				--过期回调
	self.m_tStreng = nil				--强化回调
	self.m_tWear = nil
	self.m_tRoyal = nil					--御下
	self.m_tEquip = nil
	self.m_tUse = nil
	self.m_tFromLuaTable = nil
	self.m_tBasic = nil					--物品基本信息表
	self.m_tExtra = nil					--其它
	self.m_winH = nil
	self.m_tTryWear = nil
	self.m_tLay = nil
	--self.m_tLua = nil
	self.m_bButton = nil
	self.m_showLock = nil
    self.m_ItemExpSize = nil
    self.m_sButtonTitle = nil           --按钮文本
    self.m_fClickButton = nil           --点击按钮的回调
	self.m_nItemProHeight = nil
	self.m_nLineH = nil
	self.m_tBtnData = nil
	self.m_nSacleItem = nil
	self.m_nLineExitH = nil
	self.m_nNotLineH = nil
	self.m_tOther = nil 
	self.m_x = nil
	self.m_y = nil 
	self.m_nPowerSkillH = nil
	self.m_nStone = nil
	self.m_nState = nil			
	self.m_nBlankHeight = 0				--空白高度
	self.m_nTag = nil
	self.m_tCell = nil
	self.m_nGiftNum = nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndItemInfo:createElement()
	local element = WZUISystem:getInstance():createElement("WndItemInfo")
	assert(element, "WndItemInfo create element failed!")
	self:_init()
	return element
end

--@brief	通过类型设置tip数据列表
function WndItemInfo:_setTipDataByType(nType,tData,pt,tOther)
	if tData == nil then return end
	WZLog("_setTipDataByType::::",nType)
	self.m_tOther = tOther
	local tempData
	if type(tData) == "table" then
    	tempData = CopyTable(tData)
	else
		tempData = tData
	end

	if nType == 1 then
		self:setEquipData(tempData,pt)
	elseif nType == 3 then
		self:updateExplain(tempData,pt)
	end
end

--@brief	装备列表
function WndItemInfo:setEquipData(tData,pt)
	self.m_tEquip = {}
    self.m_tEquip.basicInfo = tData.basicInfo or GetItemLocalData(tData.id) or {}
	self.m_tEquip.extraInfo = tData.extraInfo or {}
	self.m_tEquip.main_type = self.m_tEquip.basicInfo.main_type
	self.m_tEquip.sub_type = self.m_tEquip.basicInfo.sub_type
	self.m_tEquip.id = tData.id
	self.m_tEquip.playerItemId = tData.playerItemId
	self.m_tEquip.lastNum = tData.lastNum
	self.m_tEquip.lastTime = tData.lastTime
	self.m_tEquip.playerItemId = tData.playerItemId
	self.m_tEquip.isUse = tData.isUse or false
	self.m_tEquip.lock = tData.lock or 0
	self.m_tEquip.tBtnList = tData.tBtnList --放置
	self.m_tEquip.pt = pt or ccp(0,0)
	self.m_tEquip.disappearTime = tData.disappearTime
	self.m_tEquip.customizeLastTime = tData.customizeLastTime
	self.m_tEquip.shopItemId = tData.shopItemId
	self.m_tEquip.color = tData.color
	self.m_tEquip.moneyId = tData.moneyId
	self.m_tEquip.itemIds = tData.itemIds
	self.m_tEquip.commodityIds = tData.commodityIds
	self.m_tEquip.quantitys = tData.quantitys
	self.m_tEquip.magnification = tData.magnification
	self.m_tEquip.receiveTime = tData.receiveTime or (SystemTime:getServerTime()-99999)
	self.m_tEquip.showTimeLimit = tData.showTimeLimit
	self.m_tEquip.ownerId = tData.ownerId or 0 --续费孩子时装的时候需要（时装所属玩家Id）
	self:_updateInfo()
	tData = nil
	pt = nil
end

--@brief	通过id设置tip信息列表
function WndItemInfo:setEquipDataById(id)
	if id == nil or tonumber(id) == nil or id < 1 then
		return
	end
	self.m_tEquip.basicInfo = GetItemLocalData(id) or {}
	self.m_tEquip.basicInfo.main_type = self.m_tEquip.basicInfo.main_type
	self.m_tEquip.basicInfo.sub_type = self.m_tEquip.basicInfo.sub_type
end

--@brief	续期回调
function WndItemInfo:setExpiredFun(luaTable,backFun)
	if luaTable and backFun then
		self.m_tExpired = {}
		self.m_tExpired[1] = luaTable
		self.m_tExpired[2] = backFun
	end
end

--@brief	强化回调
function WndItemInfo:setStrengFun(luaTable,backFun,strengBack)
	if luaTable and backFun then
		self.m_tStreng = {}
		self.m_tStreng[1] = luaTable
		self.m_tStreng[2] = backFun
		self.m_tStreng[3] = strengBack
	end
end

--@brief	穿上回调
function WndItemInfo:setWearFun(luaTable,backFun)
	if luaTable and backFun then
		self.m_tWear = {}
		self.m_tWear[1] = luaTable
		self.m_tWear[2] = backFun
	end
end

--@brief	试穿回调
function WndItemInfo:setTryWearFun(luaTable,backFun)
	if luaTable and backFun then
		self.m_tTryWear = {}
		self.m_tWear[1] = luaTable
		self.m_tWear[2] = backFun
	end
end

--@brief	卸下回调
function WndItemInfo:setRoyalFun(luaTable,backFun)
	if luaTable and backFun then
		self.m_tRoyal = {}
		self.m_tRoyal[1] = luaTable
		self.m_tRoyal[2] = backFun
	end
end

--@brief	使用回调
function WndItemInfo:setUseFun(luaTable,backFun)
	if luaTable and backFun then
		self.m_tUse = {}
		self.m_tUse[1] = luaTable
		self.m_tUse[2] = backFun
	end
end

function WndItemInfo:setLay(luaTable,backFun)
	if luaTable and backFun then
		self.m_tLay = {}
		self.m_tLay[1] = luaTable
		self.m_tLay[2] = backFun
	end
end

--@brief	来源luaTable
function WndItemInfo:setFromLuaTable(luaTable)
	self.m_tFromLuaTable = luaTable
end

--@brief	获取来源luaTable
function WndItemInfo:getFromLuaTable()
	return self.m_tFromLuaTable
end

--@brief    设置点击按钮后的回调
function WndItemInfo:setClickButtonCallback(tcell,backFunc)
	if tcell and backFunc then
		self.m_fClickButton = {}
		self.m_fClickButton[1] = tcell
		self.m_fClickButton[2] = backFunc
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	获取装备说明列表
function WndItemInfo:_getItemExplain()
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil then
		return
	elseif self.m_tEquip.basicInfo.main_type == 8 then --卡牌
		return self:_getOthersExplain()--其它
	elseif self:_checkEquipType() == true then--武器,装扮
		return self:_getPropertyData()
	elseif self.m_tEquip.basicInfo.main_type == 10 then--宠物
		return self:_getPetData(self.m_tEquip)
	else
		return self:_getOthersExplain()--其它
	end
end

--@brief	打包数据到table
function WndItemInfo:_checkExp(value1,value2,value3,color1,color2,color3,font1,font2,font3)
	if tonumber(value3) == nil then
        value3 = ""
	else
        if tonumber(value3) >0 then
            value3 = "(+"..tostring(value3)..")"
        else
            value3 = ""
        end
	end
	local tData = {}
	tData.value1 = value1
	tData.value2 = value2
	tData.value3 = value3
	tData.color1 = color1
	tData.color2 = color2
	tData.color3 = color3
	tData.font1 = font1
	tData.font2 = font2
	tData.font3 = font3
	return tData
end

--获取暴击率
function WndItemInfo:_getCrit(criticalCoefficient,proficiency)
	if criticalCoefficient == 0 or proficiency == nil or proficiency == 0 then
		return 0
	else
		local crit =1000 * math.sqrt(proficiency/criticalCoefficient)
		return crit
	end
end

--@brief	物品名称
function WndItemInfo:_getItemName()
	if self.m_root == nil or self.m_tEquip == nil or self.m_tEquip.basicInfo == nil then
		return
	end
	local name = self.m_tEquip.basicInfo.name or ""
	local value = self.m_tEquip.extraInfo.strongLevel
	if value then
		value = "+"..tostring(value)
	end
	return name,value
end

--@brief	获得物品属性数据
function WndItemInfo:_getPropertyData()
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil then
		return
	end
	if self.m_tEquip.basicInfo.main_type == 7 or self.m_tEquip.basicInfo.main_type == 23 then return end    
	if self.m_tEquip.basicInfo.main_type == 10 and self.m_tEquip.basicInfo.sub_type == 0 then return end    

	local tItem = {}
	local tPro = self.m_tEquip.basicInfo.property
	--装备碎片取合成的装备的属性
	if self.m_tEquip.basicInfo.main_type == 9 then
		tPro = GDatatab_item["id_"..GDatatab_itemmerge["id_"..self.m_tEquip.basicInfo.id].items[1][1]].property 
	end
	--WZLog("属性表",Serialize(tPro))
	if tPro == nil or (tPro[1][1]== 0 and tPro[1][2] == 0) then
		return
	end
	for i,data in pairs(tPro) do
		if data[1] <= 20 then
		local value1 = ""
		local value2 = data[2]
		local value3 = ""
		local color1 = ccc3(255,227,116)
		local color2 = ccc3(255,236,193)
		local color3 = ccc3(99,255,95)
		local font1 = 20
		local font2 = 20
		local font3 = 20
		if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "es" then
			font1 = 16
			font2 = 16
			font3 = 16
		end
		if ProjConfig.LANGUAGE == "en" then
			font1 = 18
			font2 = 18
			font3 = 18
		end
		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "tr" then
			font1 = 16
			font2 = 16
			font3 = 16
		end
		local mainType = self.m_tEquip.basicInfo.main_type
		local subType = self.m_tEquip.basicInfo.sub_type
		WZLog("value2 = data[2]L:::",i,data[1],data[2])
		if ATTR_TITLE[tonumber(data[1])] ~= nil then
			value1 = ATTR_TITLE[tonumber(data[1])]..":"
			for k,v in pairs(self.m_tEquip.extraInfo) do
				if tonumber(k) == tonumber(data[1]) then
					value3 = v - value2
				end
			end
		end
		local stoneAttr = 0
		--武器减去宝石攻击力
		if mainType == 4 and (subType == 0 or subType == 1) and self.m_tEquip.extraInfo.attackStone ~= nil and self.m_tEquip.extraInfo.attackStone ~= 0 then
			stoneAttr = GDatatab_item["id_"..self.m_tEquip.extraInfo.attackStone].property[1][2]
			value3 = value3 - stoneAttr
		end
		--手镯减去宝石防御
		if mainType == 4 and subType == 4 and self.m_tEquip.extraInfo.defendStone ~= nil and self.m_tEquip.extraInfo.defendStone ~= 0 then
			stoneAttr = GDatatab_item["id_"..self.m_tEquip.extraInfo.defendStone].property[1][2]
			value3 = value3 - stoneAttr
		end
		--宝物和勋章减去宝石生命
		if mainType == 4 and (subType == 5 or subType == 6) and self.m_tEquip.extraInfo.hpStone ~= nil and self.m_tEquip.extraInfo.hpStone ~= 0 then
			stoneAttr = GDatatab_item["id_"..self.m_tEquip.extraInfo.hpStone].property[1][2]
			value3 = value3 - stoneAttr
		end
		--共鸣宝石显示百分比
		if mainType == 6 and (subType == 5) then
			value2 = value2.."%"
		end

		table.insert(tItem,self:_checkExp(value1,value2,value3,color1,color2,color3,font1,font2,font3))
		end
	end	
	return tItem
end

--@brief	其它说明文本
function WndItemInfo:_getOthersExplain()
	local tItem = {}
	local value1 = self.m_tEquip.basicInfo.name
	local value2 = self.m_tEquip.basicInfo.desc
	local tData = self:_checkExp(value1,"","0",self:_getItemNameColor())
	table.insert(tItem,tData)
	local tData = self:_checkExp(value2,"","0")
	table.insert(tItem,tData)
	return tItem
end

--@brief	宠物说明
function WndItemInfo:_getPetData(tData)
	if tData == nil then
		return
	end--(value1,value2,value3,color1,color2,color3,font1,font2,font3)
	local tItem = {}
	--物品等级
	local temp = self:_checkExp(tData.name..":","LV."..tData.level,0,ccc3(255,234,0))
	table.insert(tItem,temp)
	--生命
	temp = self:_checkExp(LocalStrings.HEALTH..":",tData.hp,0)
	table.insert(tItem,temp)
	--攻击
	temp = self:_checkExp(LocalStrings.ATTACK..":",tData.attack,0)
	table.insert(tItem,temp)
	--防御
	temp = self:_checkExp(LocalStrings.DEFENSE..":",tData.defend,0)
	table.insert(tItem,temp)
	--技能
	temp = self:_checkExp(LocalStrings.SKILL..":",tData.skillName,0)
	table.insert(tItem,temp)
	return tItem
end

--@brief	通过索引获取武器大招
function WndItemInfo:_getPowerskill(tag)
	if type(tag) == "string" then
		return tag
	elseif tag == 0 then
		return LocalStrings.CONTINUOUSATTACKS--"连续攻击"
	elseif tag == 1 then
		return LocalStrings.MIGHTHIT--"威力一击"
	elseif tag == 2 then
		return LocalStrings.TRACKPOSITION--"追踪定位"
	else
		return tag
	end
end

--@brief	通过索引获取文本的节点
function WndItemInfo:_getTextElement(tag)
	local sName = "txtItem%d_WndItemInfo"
	sName = string.format(sName,tag)
	local txtCell = self.m_root:getChildElement(sName)
	if txtCell then
		local size = txtCell:getContentSize()
		local pt = txtCell:getRelativePosition()
		return size,pt
	end
end

--@brief	获取装备容器的大小
function WndItemInfo:_getItemSize()
	local sName = "conItem1_WndItemInfo"
	local txtCell = self.m_root:getChildElement(sName)
	if txtCell then
		local size = txtCell:getContentSize()
		local pt = txtCell:getRelativePosition()
		size.width = size.width * 1.12
		size.height = size.height * 1.12 + 20
		return size,pt
	end
	return CCSize(0,0)
end

--@brief	获取星星的大小位置
function WndItemInfo:_getStar()
	if self:_checkEquipType() == false then
		return 0
	end
	local y = 0
	local imgSun = WZUIImage:luaTo(self.m_root:getChildElement("imgSun1_WndItemInfo"))
	local imgMoon = WZUIImage:luaTo(self.m_root:getChildElement("imgMoon1_WndItemInfo"))
	local imgStar = WZUIImage:luaTo(self.m_root:getChildElement("imgStar1_WndItemInfo"))
	if imgSun then
		y = imgSun:getContentSize().height
	end
	if imgMoon then
		y = math.max(y,imgMoon:getContentSize().height)
	end
	if imgStar then
		y = math.max(y,imgStar:getContentSize().height)
	end
	if y > 0 then
		y = y + 4
	end
	return y
end

--@brief	获取石头数据列表
function WndItemInfo:_getStoneData()
	if self.m_tEquip.basicInfo == nil or self:_checkEquipType() == false then
		return
	end
	local tStone = {}
	if self.m_tEquip.extraInfo.attackStone and self.m_tEquip.extraInfo.attackStone > 0 then--攻击宝石等级
		local title,desc,desc1 = self:_checkStone(GetItemLocalData(self.m_tEquip.extraInfo.attackStone))
		tStone[1] = self:_checkExp(title,desc,desc1,ccc3(255,227,116),ccc3(255,236,193),ccc3(99,255,95),20,20,20)
		tStone[1].itemId = self.m_tEquip.extraInfo.attackStone
	else
		tStone[1] = self:_checkExp(LocalStrings.ATTACK_STONE_1..":",LocalStrings.UNMOUNTED,"0",ccc3(255,227,116),ccc3(255,236,193),20,20,20)--"攻击宝石:未镶嵌"
	end
	if self.m_tEquip.extraInfo.hpStone and self.m_tEquip.extraInfo.hpStone > 0 then --生命宝石等级
		local title,desc,desc1 = self:_checkStone(GetItemLocalData(self.m_tEquip.extraInfo.hpStone))
		tStone[2] = self:_checkExp(title,desc,desc1,ccc3(255,227,116),ccc3(255,236,193),ccc3(99,255,95),20,20,20)
		tStone[2].itemId = self.m_tEquip.extraInfo.hpStone
	else
		tStone[2] = self:_checkExp(LocalStrings.HP_STONE..":",LocalStrings.UNMOUNTED,"0",ccc3(255,227,116),ccc3(255,236,193),20,20,20)--"防御宝石:未镶嵌"
	end
	if self.m_tEquip.extraInfo.defendStone and self.m_tEquip.extraInfo.defendStone > 0 then--防御宝石等级
		local title,desc,desc1 = self:_checkStone(GetItemLocalData(self.m_tEquip.extraInfo.defendStone))
		tStone[3] = self:_checkExp(title,desc,desc1,ccc3(255,227,116),ccc3(255,236,193),ccc3(99,255,95),20,20,20)
		tStone[3].itemId = self.m_tEquip.extraInfo.defendStone
	else
		tStone[3] = self:_checkExp(LocalStrings.DEFENSE_STONE_1..":",LocalStrings.UNMOUNTED,"0",ccc3(255,227,116),ccc3(255,236,193),20,20,20)--"特殊宝石:未镶嵌"
	end
	if self.m_tEquip.extraInfo.gongmingStone and self.m_tEquip.extraInfo.gongmingStone > 0 then--共鸣宝石等级
		local title,desc,desc1 = self:_checkStone(GetItemLocalData(self.m_tEquip.extraInfo.gongmingStone))
		tStone[4] = self:_checkExp(title,desc,desc1,ccc3(255,227,116),ccc3(255,236,193),ccc3(99,255,95),20,20,20)
		tStone[4].itemId = self.m_tEquip.extraInfo.gongmingStone
	else
		tStone[4] = self:_checkExp(LocalStrings.NEWSTONE2..":",LocalStrings.UNMOUNTED,"0",ccc3(255,227,116),ccc3(255,236,193),20,20,20)--"共鸣宝石:未镶嵌"
	end

	WZLog("WndItemInfo:_getStoneData", Serialize(tStone))
	return tStone
end

--@brief	获取石头文本
function WndItemInfo:_checkStone(tStone)
	local title = ""
	if tStone.sub_type == 1 then
		title = LocalStrings.ATTACK_STONE_1..":"--攻击宝石
	elseif tStone.sub_type == 0 then
		title = LocalStrings.HP_STONE..":"--生命宝石
	elseif tStone.sub_type == 2 then
		title = LocalStrings.DEFENSE_STONE_1..":"--防御宝石
	elseif tStone.sub_type == 5 then
		title = LocalStrings.NEWSTONE2..":"--共鸣宝石
	end
	local desc = tStone.name--L1力量石
	desc = desc
	--local desc1 = "("..ATTR_TITLE[tStone.property[1][1]].."+"..tStone.property[1][2]..")"
	local desc1 = tStone.property[1][2]
	if tStone.property[1][1] == 0 then
		desc1 = nil
	end
	return title,desc,desc1
end

--@brief	获取石头的大小位置
function WndItemInfo:_getStoneH()
	return self.m_nStone or 0
end

--@brief	通过索引获取石头的大小位置
function WndItemInfo:_getStoneSizePos(tag)
	local sName = "txtStoneB%d_WndItemInfo"
	sName = string.format(sName,tag)
	local txtStone = self.m_root:getChildElement(sName)
	if txtStone then
		txtStone = WZUILabelTTF:luaTo(txtStone)
		local size = txtStone:getContentSize()
		local pt = txtStone:getRelativePosition()
		return size,pt
	end
end

--@brief	技能锁
function WndItemInfo:_setSkillLock(i,y)
	if self:_checkWeapon() == false then
		return
	end
	local sName = "imgLock%d_WndItemInfo"
	sName = string.format(sName,i)
	local icon = "ui/bottomMenu/player/property_lock.png"
	if self.m_tEquip.extraInfo.skillId1 and self.m_tEquip.extraInfo.skillId1 > 0 and self.m_tEquip.extraInfo.skillLock == self.m_tEquip.extraInfo.skillId1 then
		local img = self:_createImage(icon,ccp(0.88,y-0.05),sName)
		img:setScale(0.5)
		self.m_root:addChild(img)
	elseif self.m_tEquip.extraInfo.skillId2 and self.m_tEquip.extraInfo.skillId2 > 0 and self.m_tEquip.extraInfo.skillLock == self.m_tEquip.extraInfo.skillId2 then
		local img = self:_createImage(icon,ccp(0.88,y-0.05),sName)
		img:setScale(0.5)
		self.m_root:addChild(img)
	end
end

--@brief	技能列表
function WndItemInfo:_getSkillData()
	if self:_checkWeapon() == false then
		return
	end
	local tData = {}
	if self.m_tEquip.extraInfo.skillId1 and self.m_tEquip.extraInfo.skillId1 > 0 then--添加技能1
		local name = WeaponSkills["id_"..self.m_tEquip.extraInfo.skillId1].skill_name
		local remark = WeaponSkills["id_"..self.m_tEquip.extraInfo.skillId1].remark
		tData[1] = self:_checkExp(LocalStrings.SKILL.."1:",name,"0",ccc3(193,0,234))
		tData[2] = self:_checkExp(remark,"","0",ccc3(255,255,255))
	else--"强化等级达到6级可获得!"
		tData[1] = self:_checkExp(LocalStrings.SKILL.."1:",LocalStrings.NONE,"0",ccc3(193,0,234))
		tData[2] = self:_checkExp(string.format(LocalStrings.STRENGTENRECV,6),"","0",ccc3(255,255,255))
	end
	if self.m_tEquip.extraInfo.skillId2 and self.m_tEquip.extraInfo.skillId2 > 0 then--添加技能2
		local name = WeaponSkills["id_"..self.m_tEquip.extraInfo.skillId2].skill_name
		local remark = WeaponSkills["id_"..self.m_tEquip.extraInfo.skillId2].remark
		tData[3] = self:_checkExp(LocalStrings.SKILL.."2:",name,"0",ccc3(193,0,234))
		tData[4] = self:_checkExp(remark,"","0",ccc3(255,255,255))
	else--"强化等级达到10级可获得!"
		tData[3] = self:_checkExp(LocalStrings.SKILL.."2:",LocalStrings.NONE,"0",ccc3(193,0,234))
		tData[4] = self:_checkExp(string.format(LocalStrings.STRENGTENRECV,10),"","0",ccc3(255,255,255))
	end
	return tData
end

--@brief	获取技能的大小位置
function WndItemInfo:_getSikllSizePos(tag)
	local sName = "txtSkill%d_WndItemInfo"
	sName = string.format(sName,tag)
	local txtSkill = self.m_root:getChildElement(sName)
	if txtSkill then
		local size = txtSkill:getContentSize()
		local pt = txtSkill:getRelativePosition()
		return size,pt
	end
end

--@brief	获取技能的大小
function WndItemInfo:_getSikll()
	local h = 0
	for i=1,4 do
		local size = self:_getSikllSizePos(i)
		if size then
			h = h + size.height + 2
		end
	end
	return h
end

--@brief	获取属性
function WndItemInfo:_getProDesc()
	if self.m_tEquip.basicInfo.main_type ~= 8 then --卡牌
		return
	end
	local isExistExtraInfo = false
	if  self.m_tEquip.extraInfo ~= nil then
		if next(self.m_tEquip.extraInfo) ~=nil then
		 isExistExtraInfo = true
		end
	end

	local txtFont1,txtFont2 = self:_getColorFont()
	local tItem = {}
	--力量
	local value1 = LocalStrings.POWER..":"--"力量:"

	local value2 = self.m_tEquip.basicInfo.add_force
	if isExistExtraInfo then
		value2 = value2 + self.m_tEquip.extraInfo.force
	end
	 WZLog("WndItemInfo:_getProDesc 力量= ",value2)
	local value3 = 0
	local tData = self:_checkExp(value1,value2,value3,ccc3(204,125,36),nil,nil,txtFont2)
	table.insert(tItem,tData)

	--护甲
	local value1 = LocalStrings.PRACTICE_ARMOR..":"--"护甲:"
	local value2 = self.m_tEquip.basicInfo.add_armor
	if  isExistExtraInfo then
		 value2 = value2 + self.m_tEquip.extraInfo.armor
	end
    WZLog("WndItemInfo:_getProDesc 护甲= ",value2)
	local value3 = 0
	tData = self:_checkExp(value1,value2,value3,ccc3(204,125,36),nil,nil,txtFont2)
	table.insert(tItem,tData)
	--敏捷
	local value1 = LocalStrings.AGILITY..":"--"敏捷:"
	local value2 = self.m_tEquip.basicInfo.add_agility
	if  isExistExtraInfo then
		value2 = value2+self.m_tEquip.extraInfo.agility
	end
     WZLog("WndItemInfo:_getProDesc 敏捷= ",value2)
	local value3 = 0
	tData = self:_checkExp(value1,value2,value3,ccc3(204,125,36),nil,nil,txtFont2)
	table.insert(tItem,tData)
	--幸运
	local value1 = LocalStrings.LUCKY..":"--"幸运:"
	local value2 = self.m_tEquip.basicInfo.add_luck
    if isExistExtraInfo  then
    	value2 = value2 + self.m_tEquip.extraInfo.luck
    end
    WZLog("WndItemInfo:_getProDesc 幸运= ",value2)
	local value3 = 0
	tData = self:_checkExp(value1,value2,value3,ccc3(204,125,36),nil,nil,txtFont2)
	table.insert(tItem,tData)
	--体质
	local value1 = LocalStrings.TIZHI..":"--"体质:"
	local value2 = self.m_tEquip.basicInfo.add_physique
    if isExistExtraInfo then
    	value2 = value2 + self.m_tEquip.extraInfo.physique
    end
    WZLog("WndItemInfo:_getProDesc 体质 = ",value2)
	local value3 = 0
	tData = self:_checkExp(value1,value2,value3,ccc3(204,125,36),nil,nil,txtFont2)
	table.insert(tItem,tData)
	return tItem
end

--@brief	获取属性文本大小位置
function WndItemInfo:_getProSizePos(tag)
	local sName = "txtPro%d_WndItemInfo"
	sName = string.format(sName,tag)
	local txtPro = self.m_root:getChildElement(sName)
	if txtPro then
		local size = txtPro:getContentSize()
		local pt = txtPro:getRelativePosition()
		size.height = size.height
		return size,pt
	end
end

--@brief	获取属性文本所有高度
function WndItemInfo:_getPro()
	local h = 0
	for i=1,7  do
		local size = self:_getProSizePos(i)
		if size then
			h = h + size.height + 2
		end
	end
	return h
end

--@brief	解冻锁高度
function WndItemInfo:_getLockTipH()
	local txt = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtLock_WndItemInfo"))
	if txt then
		return txt:getContentSize().height + 10
	else
		return 0
	end
end

--@brief	按钮
function WndItemInfo:_getBtn()
	if self.m_bButton == fasle or self.m_tBtnData == nil then
		return 0
	end
	for i,data in pairs(self.m_tBtnData) do
		local sName = string.format("btn%d_WndItemInfo",i)
		local btn = WZUIButton:luaTo(self.m_root:getChildElement(sName))
		if btn == nil then return 0 end
		return btn:getContentSize().height + 10
	end
	return 0
end

--@brief	获取按钮节点
function WndItemInfo:_getBtnElement(index)
	local sName = "btn%d_WndItemInfo"
	sName = string.format(sName,index)
	local btnElement = self.m_root:getChildElement(sName)
	if btnElement then
		btnElement = WZUIButton:luaTo(btnElement)
		return btnElement
	end
end

--@brief	获取套装按钮节点
function WndItemInfo:_getSuitBtn(index)
	local sName = "suitBtn"..index
	local btnElement = self.m_root:getChildElement(sName)
	if btnElement then
		btnElement = WZUIButton:luaTo(btnElement)
		return btnElement
	end
end

--@brief	获取礼包按钮节点
function WndItemInfo:_getGiftBtn(index)
	local sName = "giftBtn"..index
	local btnElement = self.m_root:getChildElement(sName)
	if btnElement then
		btnElement = WZUIButton:luaTo(btnElement)
		return btnElement
	end
end

function WndItemInfo:_getItemIconX()
	local x = 0.07
	local dir = 95
	if self.m_tEquip and self.m_tEquip.basicInfo and self.m_tEquip.basicInfo.icon ~= nil then
		x = x + dir /self:_getWindowsW()
	end
	return x
end

--物品名称的高度
function WndItemInfo:_getItemNameHeight()
	local txtItem = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtItemName_WndItemInfo"))
	if txtItem == nil then
		return 0
	else
		return txtItem:getContentSize().height + 4
	end
end

--@brief	获取装备所有说明的大小
function WndItemInfo:_getItemExplainHeight()
	local conItemExplain = WZUIContainer:luaTo(self.m_root:getChildElement("conItemExplain_WndItemInfo"))
	if conItemExplain == nil then
		return 0
	else
		return conItemExplain:getContentSize().height + 4
	end
end

--物品属性高度
function WndItemInfo:_getItemProHeight()
	return self.m_nItemProHeight or 0 
end

--@brief	时装过期描述高度
function WndItemInfo:_getDressDescH()
	local txtDress = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtDress_WndItemInfo"))
	if txtDress == nil then
		return 0 
	end
	return txtDress:getContentSize().height + 4
end

function WndItemInfo:_getPowerSkillH()
	return self.m_nPowerSkillH or 0 
end

--@brief	判断是否是套装
--@param	id:物品id
--@return	true:是套装部件,false:不是套装部件
function WndItemInfo:checkIsSuit(id)
	local id = id % 10000
	for k,v in pairs(GDatatab_item_suit) do
		for i=1,7 do
			if tonumber(id) == tonumber(v.item_list[1][i]) then
				return true
			end
		end
	end
	return false
end

--@brief	获取总高
function WndItemInfo:_getAllHeight()
	local winH = 200--窗口大小
	local h = 0
	local txtItemNameH = self:_getItemNameHeight()
	h = h + txtItemNameH
	local txtH = self:_getItemExplainHeight()--所有装备的文本说明
	h = h + txtH
	local starH = self:_getStar()--获取星星的大小位置
	h = h + starH
	local proH = self:_getItemProHeight()
	h = h + proH
	local stoneH = self:_getStoneH()--获取石头大小
	h = h + stoneH
	local powerSkillH = self:_getPowerSkillH()
	h = h + powerSkillH
	local skillH = self:_getSikll()--获取技能的大小
	h = h + skillH
	local dressH = self:_getDressDescH()--时装提示语的高度
	h = h + dressH
	--[[local proSizeH = self:_getPro()--物品属性
	h = h + proSizeH
	local suitAH = self:_getSuitA()--套装A
	h = h + suitAH
	local suitBH = self:_getSuitB()--套装B
	h = h + suitBH
	local lockH = self:_getLockTipH()--解冻锁高度
	h = h + lockH--]]
	h = h + self.m_nLineH
	h = h + self.m_nBlankHeight
	local btnH = self:_getBtn()--按钮
	h = h + btnH
	if self.m_nLineExitH == 1 then
		h = h + self.m_nNotLineH
		self.m_nLineExitH = 0 
	elseif self.m_nLineExitH == 3 then
		h = h + self.m_nNotLineH
	end
	local y = 0.9 - h/winH + 0.12
	return y , h + self:_addWinH()
end

--@brief	检查是否按下在按钮下
function WndItemInfo:_checkBtnPoint(pt)
	for i=1,3 do
		local btn = self:_getBtnElement(i)
		if btn then
			local x = btn:getPositionX()
			local y = btn:getPositionY()
			local pt1 = btn:convertToNodeSpace(GlobalMethod:ccp(pt.x,pt.y))
			local btnSize = btn:getContentSize()
			if pt1.x > 0 and pt1.x < btnSize.width and pt1.y > 0 and pt1.y < btnSize.height then
				return true
			end
		end
	end
	--检查套装按钮
	for i=1,6 do
		local btn = self:_getSuitBtn(i)
		if btn then
			local x = btn:getPositionX()
			local y = btn:getPositionY()
			local pt1 = btn:convertToNodeSpace(GlobalMethod:ccp(pt.x,pt.y))
			local btnSize = btn:getContentSize()
			if pt1.x > 0 and pt1.x < btnSize.width and pt1.y > 0 and pt1.y < btnSize.height then
				return true
			end
		end
	end
	--检查礼包按钮
	if self.m_nGiftNum ~= nil then
	for i=1,self.m_nGiftNum do
		local btn = self:_getGiftBtn(i)
		if btn then
			local x = btn:getPositionX()
			local y = btn:getPositionY()
			local pt1 = btn:convertToNodeSpace(GlobalMethod:ccp(pt.x,pt.y))
			local btnSize = btn:getContentSize()
			if pt1.x > 0 and pt1.x < btnSize.width and pt1.y > 0 and pt1.y < btnSize.height then
				return true
			end
		end
	end
	end
	return false
end

--@brief	获取节点的位置
function WndItemInfo:_gettToNodePt()
	local x = self.m_tLua[1]:getPositionX()
	local y = self.m_tLua[1]:getPositionY()
	local ptA = self.m_tLua[1]:getParentElement():convertToWorldSpace( ccp(x,y) )
	local pt = self.m_tLua[2]:convertToNodeSpace(ptA)
	return pt,ptA
end

function WndItemInfo:_createColorTxt(data,sName,pt,nDimen,nDimenB,sNameB)
	local txtFont1,txtFont2 = self:_getColorFont()
	local pt = pt or ccp(0.5,0.5)
	local color1 = data.color1 or ccc3(220,207,169)
	local color2 = data.color2 or ccc3(255,255,255)
	local color3 = data.color3 or ccc3(0,246,34)
	local font1 = data.font1 or txtFont1
	local font2 = data.font2 or txtFont2
	local font3 = data.font3 or txtFont2
	if ProjConfig.LANGUAGE == "vn" then
		font1 = 14
		font2 = 14
		font3 = 14
	end

	if ProjConfig.LANGUAGE == "en" then
		font1 = 14
		font2 = 14
		font3 = 14
	end
	if ProjConfig.LANGUAGE == "pt" or 
		ProjConfig.LANGUAGE == "es" then
		font1 = 12
		font2 = 12
		font3 = 12
	end
	if ProjConfig.LANGUAGE == "tr" then
		font1 = 14
		font2 = 14
		font3 = 14
		nDimen = 200
	end
	if ProjConfig.LANGUAGE == "th" then
		font1 = 16
		font2 = 18
		font3 = 18
	end

	nDimen = nDimen or 270
	sNameB = sNameB or "txtColor_WndItemInfo"
	local w = self:_getWindowsW()
	local txtA = WZUILabelTTF:create()
	txtA:setAlignment(kCCTextAlignmentLeft)
	txtA:setFontSize(font1)
	txtA:setText(data.value1)
	txtA:setAnchorPoint(ccp(0,1))
	txtA:setRelativePosition(pt)
	txtA:setName(sName)
	txtA:setColor(color1)
	self.m_root:addChild(txtA)
	local txtASize = txtA:getLabelContentSize()
	if nDimenB then
		nDimenB = self:_getWindowsW()*(1-1.5*pt.x)-txtASize.width-4
	else
		nDimenB = 0
	end
	local x = pt.x + (txtASize.width + 12)/w
	txtA:setDimensions(CCSize(nDimen,0))
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
		txtA:setDimensions(GlobalMethod:CCSize(180,0))
		x=pt.x + (txtASize.width + 6)/w
	end
	if data.value2 and data.value2 ~= "" then
		local txtB = WZUILabelTTF:create()
		txtB:setAnchorPoint(ccp(0,1))
		txtB:setRelativePosition(ccp(x,pt.y))
		txtB:setAlignment(kCCTextAlignmentLeft)
		txtB:setFontSize(font2)
		txtB:setText(data.value2)
		txtB:setColor(color2)
		txtB:setName(sNameB)
		txtB:setDimensions(CCSize(nDimenB,0))
		self.m_root:addChild(txtB)
		local txtBSize = txtB:getContentSize()
		x = x + (txtBSize.width + 8)/w
		txtB = nil
		txtBSize = nil
	end

	if data.value3 and data.value3 ~= "" then
		local txtC = WZUILabelTTF:create()
		txtC:setRelativePosition(ccp(x,pt.y))
		txtC:setAnchorPoint(ccp(0,1))
		txtC:setAlignment(kCCTextAlignmentLeft)
		txtC:setFontSize(font3)
		txtC:setText(data.value3)
		txtC:setColor(color3)
		self.m_root:addChild(txtC)
		local txtCSize = txtC:getContentSize()
		x = x + (txtCSize.width + 8)/w
		txtC = nil
	end

	if data.value4 and data.value4 ~= "" then
		local txtD = WZUILabelTTF:create()
		txtD:setRelativePosition(ccp(x,pt.y))
		txtD:setAnchorPoint(ccp(0,1))
		txtD:setAlignment(kCCTextAlignmentLeft)
		txtD:setFontSize(font3)
		txtD:setText(data.value4)
		txtD:setColor(ccc3(255,227,116))
		self.m_root:addChild(txtD)
		local txtCSize = txtD:getContentSize()
		x = x + (txtCSize.width + 8)/w
		txtD = nil
	end
	return txtA,txtB,txtC,x
end

--@brief	创建文本
function WndItemInfo:_createFreeText(desc,pt,sName,maxWidth,anchor)
	maxWidth = maxWidth or 400
	anchor = anchor or ccp(0,1)
	sName = sName or "txtItem_WndItemInfo"
	local txt = WZUIFreeTextBox:create()
	txt:setShowText(desc)
	txt:setName(sName)
	txt:setMaxWidth(maxWidth)
	txt:setAnchorPoint(anchor)
	txt:setRelativePosition(pt)
	return txt
end

--@brief	品质图片
function WndItemInfo:_getItemQuality()
	WZLog("WndItemInfo:_getItemQuality",self.m_tEquip.basicInfo.quality)
	if self.m_tEquip == nil and self.m_tEquip.basicInfo == nil then
		return
	end
	if self.m_tEquip.basicInfo.quality == 0 then
		return
	elseif self.m_tEquip.basicInfo.quality == 1 then
		return "ui/common/frame_green.png"
	elseif self.m_tEquip.basicInfo.quality == 2 then
		return "ui/common/frame_bule.png"
	elseif self.m_tEquip.basicInfo.quality == 3 then
		return "ui/common/frame_violet.png"
	elseif self.m_tEquip.basicInfo.quality == 4 then
		return "ui/common/frame_orange.png"
	elseif self.m_tEquip.basicInfo.quality == 5 then
		return "ui/common/common_scale9_beibaodi1.png"
	end
end

--@brief	品质名称
function WndItemInfo:_getItemNameColor()
	local quality = self.m_tEquip.basicInfo.quality
	local color = QUALITYCOLOR[quality]
	if color == nil then
		color = ccc3(255,255,255)
	end
	return color
end

--@brief	检查是否属于武器，装扮
function WndItemInfo:_checkEquipType()
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil or self.m_tEquip.basicInfo.main_type == nil then
		return false
	elseif self.m_tEquip.basicInfo.main_type == 4 or 
			(self.m_tEquip.basicInfo.main_type == 9 and self.m_tEquip.basicInfo.sub_type == 1) then --装备或装备碎片
		return true
	else
		return false
	end
end

function WndItemInfo:_getWindowsW()
	return WZUIContainer:luaTo(self.m_root):getAbsContentSize().width
end

function WndItemInfo:_getWindowsH()
	return WZUIContainer:luaTo(self.m_root):getAbsContentSize().height
end

--@brief	获取彩色文字的默认字体大小
function WndItemInfo:_getColorFont()
	local txt1 = 20
	local txt2 = 20
	return txt1,txt2
end

--@brief	通过不同语言获取装备按钮上的文字
function WndItemInfo:_getWearTextByLan(maintype,subtype,isUser)
	if (maintype == 4 and subtype ~= 0 and subtype ~= 1) or maintype == 5 then --装备(不包括武器)、时装
		if isUser and isUser == true then
			return LocalStrings.UNROYAL
		end
		return LocalStrings.WEAR
	else
		local txt = LocalStrings.EQUIPMENT
		if ProjConfig.LANGUAGE == "pt" then
			txt = LocalStrings.WEAR
		end
		return txt
	end
	return LocalStrings.WEAR
end

--@brief	通过不同语言获取宠物窗口大小
function WndItemInfo:_getPetWinByLan()
	local w = 300
	if ProjConfig.LANGUAGE == "pt" then
		w = 400
	elseif ProjConfig.LANGUAGE == "en" then
		w = 400
	elseif ProjConfig.LANGUAGE == "vn" then
		w = 400
	end
	return w
end

function WndItemInfo:_addWinH()
	if self.m_nLineExitH == 3 then 
		return 0 --有按钮
	elseif self.m_nLineH >= 10 and self.m_nLineH < 20 then
		return 10--没有按钮，有一条线
	elseif self.m_nLineH >= 10 then
		return 6
	else
		return 2--没有按钮，没有线
	end
end

function WndItemInfo:_checkOther()
	if self.m_tEquip == nil or self.m_tEquip.maintype == nil then
		return true
    elseif self.m_tEquip.maintype == 4 or self.m_tEquip.maintype == 5 then --装备和时装
        return false
    else
        return true

    end
end

function WndItemInfo:_checkLock()
	if self.m_tEquip == nil or self.m_tEquip.lock == nil or self.m_tEquip.lock == 0 then
		return 0
	elseif self.m_tEquip.lock == 1 then
		return 1
	elseif self:_checkOther() == false then
		return 2
	end
	return 0
end

--@brief	获取解冻锁状态
function WndItemInfo:_checkLockTip()
	if self.m_root == nil or self.m_tEquip == nil or self.m_tEquip.extraInfo == nil or self.m_tEquip.extraInfo.strongLevel == nil or self.m_tEquip.lastTimeBak == nil then
		return 0
	elseif CacheCenter:getStrenthenRateList() == nil or CacheCenter:getStrenthenRateList().indefiniteStrongLevel == nil then
		return 0
	elseif self.m_tEquip.extraInfo.strongLevel < CacheCenter:getStrenthenRateList().indefiniteStrongLevel then
		return 0
	else--如果强化等级大于等于加锁等级
		if self.m_tEquip.lastTimeBak == 0 then--如果解冻锁时间为0，不能加锁，有提示语
			return 1
		else--能加锁，有提示语
			return 2
		end
	end
end

--@brief    检查是否是武器
function WndItemInfo:_checkWeapon()
    if self.m_tEquip.basicInfo and self.m_tEquip.basicInfo.main_type == 4 and
        (self.m_tEquip.basicInfo.sub_type == 0 or self.m_tEquip.basicInfo.sub_type == 1) then
        return true
    end
    return false
end

function WndItemInfo:_getWinSize()
	return WZUIContainer:luaTo(self.m_root):getContentSize()
end
-------------------------------------私有方法模块End----------------------------------------



