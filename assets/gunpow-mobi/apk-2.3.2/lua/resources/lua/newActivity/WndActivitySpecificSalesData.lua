--WndActivitySpecificSalesData.lua
--@brief	WndActivitySpecificSales的数据模块
--@date		2023/05/30
--@author	nijinlin
--@note		限定活动

WndActivitySpecificSales = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndActivitySpecificSales:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nStartTime = nil 
    self.m_nEndTime = nil 
    self.m_nLoadingId = nil 
    --标签页索引
    self.m_nTag = nil
    --当前选中的子元素索引
    self.m_nTagItemSelect = nil
    self.m_sContent = nil
	--充值消耗以及获取状态
    self.m_vnNums = nil
	--子元素集合
    self.m_tCellList = nil
    --宠物动画
  	self.petAni = nil
  	--是否已领取过的标记 -1未领取 0已领取
  	self.m_nOwnFlag = -1
    --物品数据
    self.m_tEquip = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndActivitySpecificSales:_unInit()
	self.m_root = nil
    self.m_nStartTime = nil 
    self.m_nEndTime = nil 
    self.m_nLoadingId = nil 
    --标签页索引
    self.m_nTag = nil
    --当前选中的子元素索引
    self.m_nTagItemSelect = nil
    self.m_sContent = nil
	--充值消耗以及获取状态
    self.m_vnNums = nil
	--子元素集合
    self.m_tCellList = nil
    --宠物动画
  	self.petAni = nil
  	--是否已领取过的标记 -1未领取 0已领取
  	self.m_nOwnFlag = -1
    --物品数据
    self.m_tEquip = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndActivitySpecificSales:createElement()
	if WndActivitySpecificSales.m_root ~= nil then
		WindowManager:removeWindow(WndActivitySpecificSales.m_root, WndActivitySpecificSales, true)
	end
	local element = WZUISystem:getInstance():createElement("WndActivitySpecificSales")
	assert(element, "WndActivitySpecificSales create element failed!")
	self:_init()
	return element
end


--@brief 	外部接口
function WndActivitySpecificSales:showInterface(nIndex, tMsg)
  LoadNewActivityRes(true)
	local wndActivitySpecificSales = WndActivitySpecificSales:createElement()
	if wndActivitySpecificSales then 
		WindowManager:addWindow(wndActivitySpecificSales, WndActivitySpecificSales, false, nil, nil, true)
	end
end

--@brief  获得活动内容成功
function WndActivitySpecificSales:GetActivityInfoOK(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	self:_closeLoading()
    WZLog("********* WndActivitySpecificSales:GetActivityInfoOK *****")
	self:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
end

--@brief   创建加载框
function WndActivitySpecificSales:_createLoading()
	if self.m_nLoadingId == nil then 
		self.m_nLoadingId = MsgBoxManager:showLoadingBox()
	end
end

--@brief   关闭加载框
function WndActivitySpecificSales:_closeLoading()
	if self.m_nLoadingId then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
		self.m_nLoadingId = nil 
	end
end

--@brief  获取装备说明列表
function WndActivitySpecificSales:_getItemExplain()
  if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil then
    return
  elseif self.m_tEquip.basicInfo.main_type == 8 then --卡牌
    return-- self:_getOthersExplain()--其它
  elseif self:_checkEquipType() == true then--武器,装扮
    return self:_getPropertyData()
  elseif self.m_tEquip.basicInfo.main_type == 10 then--宠物
    return self:_getPetData(self.m_tEquip)
  else
    return-- self:_getOthersExplain()--其它
  end
end

--@brief  获得物品属性数据
function WndActivitySpecificSales:_getPropertyData()
  if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil then
    return
  end
  if self.m_tEquip.basicInfo.main_type == 7 or self.m_tEquip.basicInfo.main_type == 23 then return end    
  if self.m_tEquip.basicInfo.main_type == 10 and self.m_tEquip.basicInfo.sub_type == 0 then return end
  if self.m_tEquip.basicInfo.main_type == 25 and self.m_tEquip.basicInfo.sub_type ~= 3 then return end
  if self.m_tEquip.basicInfo.main_type == 38 and (self.m_tEquip.extraInfo == nil or self.m_tEquip.extraInfo.spriteStoneQuality == nil) then return end    

  local tItem = {}
  local tempData = CopyTable(self.m_tEquip)
  local tPro = tempData.basicInfo.property
  if tempData.basicInfo.main_type == 9 then --装备碎片取合成的装备的属性
    tempData.basicInfo = GDatatab_item["id_"..GDatatab_itemmerge["id_"..tempData.basicInfo.id].items[1][1]]
    tPro = tempData.basicInfo.property
  elseif tempData.basicInfo.main_type == 2 and tempData.basicInfo.sub_type == 11 then --宠物激活卡
    for k,v in pairs(GDatatab_mounts) do
      if v.way ~= -1 and v.way[1][2] == 2 and v.way[2][2] == tempData.basicInfo.id then
        tempData.basicInfo = GDatatab_item["id_"..v.item_id]
        break
      end
    end
    tPro = tempData.basicInfo.property
  end
  
  if tempData.basicInfo.main_type == 25 and tempData.basicInfo.sub_type == 3 then
    tPro = nil
    local backgroundcardInfo = GDatatab_backgroundcard["id_"..tempData.basicInfo.value]
    if backgroundcardInfo then
      tPro = backgroundcardInfo.property
    end
  elseif tempData.basicInfo.main_type == 20 then
    tPro = GDatatab_item["id_"..tempData.basicInfo.id].property
    tPro = GDatatab_shape_skins["id_"..tPro[1][1]].property
  elseif tempData.basicInfo.main_type == 23 then
    for k,v in pairs(GDatatab_footmark) do
      if v.item_id == tempData.basicInfo.id then
        tPro = v.property
        break 
      end
    end
  end
  --WZLog("属性表",Serialize(tPro))
  if tPro == nil or tPro == -1 or (tPro[1][1]== 0 and tPro[1][2] == 0) then
    return
  end
  for i,data in pairs(tPro) do
    if data[1] <= 20 then
    local value1 = ""
    local value2 = data[2]
    local value3 = ""
    local color1 = ccc3(127,70,26)
    local color2 = ccc3(127,70,26)
    local color3 = ccc3(5,180,0)
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
    local mainType = tempData.basicInfo.main_type
    local subType = tempData.basicInfo.sub_type
    WZLog("value2 = data[2]L:::",i,data[1],data[2])
    if mainType == 38 then --灵石之源
      value1 = LocalStrings.CARD_TEXT15
      value2 = tempData.extraInfo.spriteStoneQuality
    elseif mainType == 35 and subType == 4 then  
      value1 = LocalStrings.CASTSOUL_TEXT24 .. ":"
      value2 = string.format("%0.2f%%", (value2*100/10000))
    elseif mainType == 46 then 
      value1 = HVATTR_TITLE[tonumber(data[1])]..":" 
      value2 = string.format("%0.2f%%", (value2*100/10000))
    else
      if ATTR_TITLE[tonumber(data[1])] ~= nil then
        value1 = ATTR_TITLE[tonumber(data[1])]..":"
        if tempData.extraInfo ~= nil then
          for k,v in pairs(tempData.extraInfo) do
            if tonumber(k) == tonumber(data[1]) then
              value3 = v - value2
            end
          end
        end
      end
    end
    local stoneAttr = 0
    if tempData.extraInfo ~= nil then
        --武器减去宝石攻击力
        if (mainType == 4 and (subType == 0 or subType == 1) or mainType == 43 and (subType == 0 or subType == 4)) and tempData.extraInfo.attackStone ~= nil and tempData.extraInfo.attackStone ~= 0 then
          stoneAttr = GDatatab_item["id_"..tempData.extraInfo.attackStone].property[1][2]
          value3 = value3 - stoneAttr
        end
        --手镯减去宝石防御
        if (mainType == 4 and (subType == 4) or mainType == 43 and (subType == 2 or subType == 3)) and tempData.extraInfo.defendStone ~= nil and tempData.extraInfo.defendStone ~= 0 then
          stoneAttr = GDatatab_item["id_"..tempData.extraInfo.defendStone].property[1][2]
          value3 = value3 - stoneAttr
        end
        --宝物和勋章减去宝石生命
        if (mainType == 4 and (subType == 5 or subType == 6) or mainType == 43 and (subType == 1 or subType == 5)) and tempData.extraInfo.hpStone ~= nil and tempData.extraInfo.hpStone ~= 0 then
          stoneAttr = GDatatab_item["id_"..tempData.extraInfo.hpStone].property[1][2]
          value3 = value3 - stoneAttr
        end
        --共鸣宝石显示百分比
        if (mainType == 6 or mainType == 44) and (subType == 5) then
          value2 = value2.."%"
        end
    end

    table.insert(tItem,self:_checkExp(value1,value2,value3,color1,color2,color3,font1,font2,font3))
    end
  end 
  local tItem2 = {}
  if tempData.basicInfo.main_type == 50 then 
    local tConfigData = self:getFlowerpotFieldProperty(tempData.basicInfo.id)
    if tConfigData then 
      for i = 1, #tConfigData.addition do
        local value1 = HVATTR_TITLE[tConfigData.addition[i][1]] .. ":"
        local value2 = (tConfigData.addition[i][2] * 100 / 10000).."%"
        local value3 = ""
        local color1 = ccc3(127,70,26)
        local color2 = ccc3(127,70,26)
        local color3 = ccc3(5,180,0)
        local font1 = 20
        local font2 = 20
        local font3 = 20

        table.insert(tItem2, self:_checkExp(value1,value2,value3,color1,color2,color3,font1,font2,font3))
      end
    end
  end
  return tItem, tItem2
end

--@brief  其它说明文本
function WndActivitySpecificSales:_getOthersExplain()
  local tItem = {}
  local value1 = self.m_tEquip.basicInfo.name
  local value2 = self.m_tEquip.basicInfo.desc
  local tData = self:_checkExp(value1,"","0",self:_getItemNameColor())
  table.insert(tItem,tData)
  local tData = self:_checkExp(value2,"","0")
  table.insert(tItem,tData)
  return tItem
end

--@brief  宠物说明
function WndActivitySpecificSales:_getPetData(tData)
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

--@brief  打包数据到table
function WndActivitySpecificSales:_checkExp(value1,value2,value3,color1,color2,color3,font1,font2,font3)
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

--@brief  获取属性
function WndActivitySpecificSales:_getProDesc()
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
   WZLog("WndActiVitySpecificSales:_getProDesc 力量= ",value2)
  local value3 = 0
  local tData = self:_checkExp(value1,value2,value3,ccc3(204,125,36),nil,nil,txtFont2)
  table.insert(tItem,tData)

  --护甲
  local value1 = LocalStrings.PRACTICE_ARMOR..":"--"护甲:"
  local value2 = self.m_tEquip.basicInfo.add_armor
  if  isExistExtraInfo then
     value2 = value2 + self.m_tEquip.extraInfo.armor
  end
    WZLog("WndActiVitySpecificSales:_getProDesc 护甲= ",value2)
  local value3 = 0
  tData = self:_checkExp(value1,value2,value3,ccc3(204,125,36),nil,nil,txtFont2)
  table.insert(tItem,tData)
  --敏捷
  local value1 = LocalStrings.AGILITY..":"--"敏捷:"
  local value2 = self.m_tEquip.basicInfo.add_agility
  if  isExistExtraInfo then
    value2 = value2+self.m_tEquip.extraInfo.agility
  end
     WZLog("WndActiVitySpecificSales:_getProDesc 敏捷= ",value2)
  local value3 = 0
  tData = self:_checkExp(value1,value2,value3,ccc3(204,125,36),nil,nil,txtFont2)
  table.insert(tItem,tData)
  --幸运
  local value1 = LocalStrings.LUCKY..":"--"幸运:"
  local value2 = self.m_tEquip.basicInfo.add_luck
    if isExistExtraInfo  then
      value2 = value2 + self.m_tEquip.extraInfo.luck
    end
    WZLog("WndActiVitySpecificSales:_getProDesc 幸运= ",value2)
  local value3 = 0
  tData = self:_checkExp(value1,value2,value3,ccc3(204,125,36),nil,nil,txtFont2)
  table.insert(tItem,tData)
  --体质
  local value1 = LocalStrings.TIZHI..":"--"体质:"
  local value2 = self.m_tEquip.basicInfo.add_physique
    if isExistExtraInfo then
      value2 = value2 + self.m_tEquip.extraInfo.physique
    end
    WZLog("WndActiVitySpecificSales:_getProDesc 体质 = ",value2)
  local value3 = 0
  tData = self:_checkExp(value1,value2,value3,ccc3(204,125,36),nil,nil,txtFont2)
  table.insert(tItem,tData)
  return tItem
end

--@brief  判断是否是套装
--@param  id:物品id
--@return true:是套装部件,false:不是套装部件
function WndActivitySpecificSales:checkIsSuit(id)
  if not id then return end
  
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

--@brief  检查是否属于武器，装扮
function WndActivitySpecificSales:_checkEquipType()
  if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil or self.m_tEquip.basicInfo.main_type == nil then
    return false
  elseif self.m_tEquip.basicInfo.main_type == 4 or self.m_tEquip.basicInfo.main_type == 43 or
      (self.m_tEquip.basicInfo.main_type == 9 and self.m_tEquip.basicInfo.sub_type == 1) then --装备或装备碎片
    return true
  else
    return false
  end
end

--@brief    检查是否是武器
function WndActivitySpecificSales:_checkWeapon()
    if self.m_tEquip.basicInfo and self.m_tEquip.basicInfo.main_type == 4 and
        (self.m_tEquip.basicInfo.sub_type == 0 or self.m_tEquip.basicInfo.sub_type == 1) then
        return true
    end
    return false
end

function WndActivitySpecificSales:_getWinSize()
    return WZUIContainer:luaTo(self.m_root):getContentSize()
end

--@brief  获取彩色文字的默认字体大小
function WndActivitySpecificSales:_getColorFont()
  local txt1 = 20
  local txt2 = 20
  return txt1,txt2
end

--@brief  品质名称
--@param  nType:用来判断默认颜色
function WndActivitySpecificSales:_getItemNameColor(nType)
  local tempType = nType or 1
  local quality = self.m_tEquip.basicInfo.quality
  if self.m_tEquip.basicInfo.main_type == 38 and (self.m_tEquip.basicInfo.sub_type >= 9 and self.m_tEquip.basicInfo.sub_type <= 13) then
    local quality_score = self.m_tEquip.extraInfo.spriteStoneQuality
    if quality_score then 
          if quality_score >= 1 and quality_score <= 49 then
              quality = 1
          elseif quality_score >= 50 and quality_score <= 79 then
              quality = 2
          elseif quality_score >= 80 and quality_score <= 94 then
              quality = 3
          elseif quality_score >= 95 and quality_score <= 100 then
              quality = 4
          end
      end
  end
  local color = QUALITYCOLOR[quality]
  if color == nil then
    if tempType == 1 then
      color = ccc3(127,70,26)
    elseif tempType == 2 then
      color = ccc3(255,255,255)
    end
  end
  return color
end
--@brief  获取相应的花盆土坑属性
function WndActivitySpecificSales:getFlowerpotFieldProperty(itemId)
  for i, value in pairs(GDatatab_holiday_pot) do
    if value.item_id == itemId then 
      return value
    end
  end

  return nil 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
