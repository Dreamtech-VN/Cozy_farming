--CellLotteryShow.lua
--@brief	CellLotteryShow的UI模块
--@date		2021/05/25
--@author	hyc
--@note		抽奖展示cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLotteryShow:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLotteryShow:onExit(element)
	self:_unInit()
end

function CellLotteryShow:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellLotteryShow")
	celElement:setVisible(true)
	element:addChild(celElement)
	self:setViewShow()

	AdaptLanguage(self)
end

function CellLotteryShow:setViewShow()
	-- body
		local tData = self.n_data
		local conTexiao = GetElement(self.m_root,"conTexiao_CellLotteryshow",WZUIContainer)
		conTexiao:setVisible(false)
		local conBg = GetElement(self.m_root,"conBg_CellLotteryShow",WZUIImage)
		conBg:setVisible(false)
		local drawQuality = 0
		local basicInfo = GDatatab_item["id_" .. tData.item_id[1][1]]
		if self.n_type == 3 and basicInfo.main_type == 38 and basicInfo.sub_type >= 9 and basicInfo.sub_type <= 13 then 
				if self.n_natural >= 1 and self.n_natural <= 49 then
	          drawQuality = 1
	      elseif self.n_natural >= 50 and self.n_natural <= 79 then
	          drawQuality = 2
	      elseif self.n_natural >= 80 and self.n_natural <= 94 then
	          drawQuality = 3
	      elseif self.n_natural >= 95 and self.n_natural <= 100 then
	          drawQuality = 4
	      end
		else
				for k,v in pairs(GDatatab_total_draw) do
						if v.item_id[1][1] == tData.item_id[1][1] then
								drawQuality = v.quality
								break 
						end
				end
		end
		if drawQuality == 1 then
				conBg:setVisible(true)
				conBg:setFile("ui/common/common_icon_lg.png")
		elseif drawQuality == 2 then
				conBg:setVisible(true)
				conBg:setFile("ui/common/common_icon_ng.png")
		elseif drawQuality == 3 then
				conBg:setVisible(true)
				conBg:setFile("ui/common/common_icon_zg.png")	
		elseif drawQuality == 4 then
				conBg:setVisible(true)
				conBg:setFile("ui/common/common_icon_hg.png")
		elseif drawQuality >= 5 then
				conTexiao:setVisible(true)
		end 
		if self.n_type == 1 then
				self:showItem(tData)
		elseif self.n_type == 2 then
				if GDatatab_item["id_"..tData.item_id[1][1]].main_type == 10 then
						self:showAni(tData)
				else 
						self:showItem(tData)
				end
		elseif self.n_type == 3 then
				if GDatatab_item["id_"..tData.item_id[1][1]].main_type == 11 then
						self:showAni(tData)
				else 
						self:showItem(tData, drawQuality)
				end
		elseif self.n_type == 4 then
				local sex = CacheCenter:getPlayerInfo().sex
				if GDatatab_item["id_"..tData.item_id[1][1]].main_type == 20 then
						self:showAni(tData)
				else
						self:showItem(tData)
				end		
				-- local sex = CacheCenter:getPlayerInfo().sex
				-- if tData.batch_blue ~= 0 and tData.batch_pink ~= 0 then				
				-- 	if GDatatab_item["id_"..tData.item_id[sex+1][1]].main_type == 20 then
				-- 		self:showAni(tData)
				-- 	end
				-- else 
				-- 	self:showItem(tData)
				-- end 
		elseif self.n_type == 5 then
				if GDatatab_item["id_"..tData.item_id[1][1]].main_type == 23 then
						self:showAni(tData)
				else 
						self:showItem(tData)
				end
		elseif self.n_type == 6 then
			self:showItem(tData)
		end
end

function CellLotteryShow:setShowLabel(nBlean)
	-- body
	GetElement(self.m_root,"txtLabel",WZUILabelTTF):setVisible(true)
end

function CellLotteryShow:showItem(info, mountStoneQuality)
	-- body
	WZLog("CellLotteryShow:showItem",info.item_id[1][1])
	local tData = info
	local conShow = GetElement(self.m_root,"conShow_CellLotteryShow",WZUIContainer)

	local key = "id_"..tData.item_id[1][1]
	local name = GDatatab_item[key].name
    local path = GDatatab_item[key].icon
    local quality = GDatatab_item[key].quality
    if mountStoneQuality and mountStoneQuality > 0 then 
				quality = mountStoneQuality
		end
    local num = info.item_id[1][2]
    local extraInfo = nil
    if tData.m_data and tData.m_data ~= ""  then
    	extraInfo = json.decode(tData.m_data)
    	extraInfo.randAttr = json.decode(extraInfo.randAttr)
	end
	local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key]),extraInfo=extraInfo}
	local basicInfo = GDatatab_item["id_" .. tData.item_id[1][1]]
	if self.n_type == 3 and basicInfo.main_type == 38 and basicInfo.sub_type >= 9 and basicInfo.sub_type <= 13 then 
		itemInfo.extraInfo = {}
		itemInfo.extraInfo.spriteStoneQuality = self.n_natural
	end
    local celElement,tLuaObj = CellGoodItem:createElement()
    tLuaObj:setItemClickFun(CellLotteryShow,self.onItemClick)
    tLuaObj:setCellGoodItem(itemInfo, 15)
    celElement:setScale(0.8)
    celElement:setTag(99)
	conShow:addChild(celElement)		

	if self.n_type == 6 then
		tLuaObj:_showItemNum()
	end

	local name1 = GetElement(self.m_root,"name_CellLotteryShow",WZUILabelTTF)
	name1:setText(name)
	local colorType = {ccc3(255,255,255),ccc3(99,255,95),ccc3(93,222,254),ccc3(198,130,255),ccc3(233,166,62), ccc3(255,89,74),ccc3(255,0,0)}
	name1:setColor(colorType[quality+1])
end

function CellLotteryShow:onItemClick(tCell,tag,tData)
	-- body
	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root,WndLotteryShow.m_root,1,tData,false,nil,true)	
end

function CellLotteryShow:showAni(info)
	local tData = info
	local key
	if self.n_type ~= 4 then
		key = "id_"..tData.item_id[1][1]
	else 
		local sex = CacheCenter:getPlayerInfo().sex
		key = "id_"..tData.item_id[sex+1][1]
	end
	WZLog("皮肤十连抽奖展示的皮肤item",key)
	local quality = GDatatab_item[key].quality
	local name = GDatatab_item[key].name
	local name1 = GetElement(self.m_root,"name_CellLotteryShow",WZUILabelTTF)
	local petBg = GetElement(self.m_root,"petBg_CellLotteryShow",WZUIImage)
	petBg:setVisible(false)
	name1:setText(name)
	local colorType = {ccc3(255,255,255),ccc3(99,255,95),ccc3(93,222,254),ccc3(198,130,255),ccc3(233,166,62), ccc3(255,89,74),ccc3(255,0,0)}
	name1:setColor(colorType[quality + 1])
	
	local conShow = GetElement(self.m_root,"conShow_CellLotteryShow",WZUIContainer)
	if self.n_type == 1 then

	elseif self.n_type == 2 then
		local petAni = CreatePetAni(conShow, nil, GDatatab_item["id_"..tData.item_id[1][1]].animation_index_code)
		petBg:setVisible(true)
		petBg:setFile(self:getTypeById(tData.item_id[1][1]))
		local con = GetElement(self.m_root,"con_CellLotteryshow",WZUIContainer)
	    local aptitude = self:getAptitude(self.n_natural)
	    for i = 1, 7 do
	        GetElement(self.m_root,"imgAptitude"..i.."_WndPets",WZUIImage):setVisible(i <= aptitude)
	    end
	    self:setAptitudePost(self.m_root, "conAptitude_WndPets", aptitude)
	elseif self.n_type == 3 then
		self:_createMountAni(conShow,tData)
	elseif self.n_type == 4 then
		self:showPlayer(conShow,tData)
	elseif self.n_type == 5 then
		for k,v in pairs(GDatatab_footmark) do
			if v.item_id == tData.item_id[1][1] then
				local m_sRoleSpine = FootEffectManager:addEffect1(conShow,v.id,{x=130,y=50 },true)
				m_sRoleSpine:setRelativePosition(GlobalMethod:ccp(0.5 ,0))	
			end
		end  		
	elseif self.n_type == 6 then

	end
end

--@brief 调整星级数量
--@param nNum:宠物的品质
function CellLotteryShow:getAptitude(nNum)
  WZLog("CellLotteryShow:getAptitude:", nNum)
  local nGift = math.ceil(nNum/100)
  local tab = GDatatab_petStar
  for k,v in pairs(tab) do
    local gift = v.gift
    if  nGift >  gift[1][1] and nGift <= gift[1][2] then
      WZLog("CellLotteryShow:getAptitude:", nGift, v.id)
      return v.id
    end
  end
  return 1
end

--@brief 调整星级位置
function CellLotteryShow:setAptitudePost(root, elementName, nNum)
  if root == nil or elementName == nil then
     return
  end
  local element = GetElement(root,elementName,WZUIContainer)
  local pos = element:getRelativePosition()
  if nNum % 2 == 0 then
    element:setRelativePosition(GlobalMethod:ccp(0.54,pos.y))
  else
    element:setRelativePosition(GlobalMethod:ccp(0.5,pos.y))
  end
end

--@brief 根据宠物Id获取宠物类型图标
function CellLotteryShow:getTypeById(petId)
  WZLog("WndPets:getTypeById:",petId)
  local petType = 0
  for k, v in pairs(GDatatab_pet) do
    if v.item_id == petId then
      petType = v.id_type
    end
  end
  if petType == 1 then --生命
    return "ui/common/common_cw_xue.png"
  elseif petType == 2 then --攻击
    return "ui/common/common_cw_gong.png"
  elseif petType == 3 then --防御
    return "ui/common/common_cw_fang.png"
  elseif petType == 4 then --均衡
    return "ui/common/common_cw_jun.png"
  elseif petType == 5 then --经验
    return "ui/common/common_cw_exp.png"
  end
  return ""
end

--皮肤动画
function CellLotteryShow:showPlayer(conP,tdata)
	local playerInfo = CacheCenter:getPlayerInfo()
	local sex = playerInfo.sex

	local data = {}
	for k,v in pairs(GDatatab_shape_skins) do
		if v.channel == tdata.item_id[sex + 1][1] then
			data = v
		end
	end

	local tEquip1 = CacheCenter:getPlayerItems()
	if tEquip1 == nil then return end

	local tEquip = {}
	for k,v in pairs(tEquip1) do
		if v.isUse == true then
			table.insert(tEquip, v)
		end
	end

    -- local conP = WZUIContainer:luaTo(self.m_root:getChildElement("conAni_CellBookItem"))
	--local tData = self.m_tSelectedCell.m_tData
	local showId = data.id
	WZLog("皮肤1")

	local conPlayer
	local isMonster = true
	if isMonster then
   		conPlayer = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, nil, nil,true, showId)
    	conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))
		conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0))
	end
	conPlayer:setScale(0.6)
    conP:addChild(conPlayer:getAnimNode(),5)

end

-- 坐骑动画
function CellLotteryShow:_createMountAni(con,info)

    local sex = CacheCenter:getPlayerInfo().sex 
    if con:getChildByTag(99) then con:removeChildByTag(99,true) end

    local head,body = CacheCenter:getHeadAndBodyColor()
    local ani = CreatePlayerFigure(sex, nil, "mount_show",nil,nil,nil,nil,nil,nil,nil,head,body,false)
    local animation_index_code = GDatatab_item["id_"..info.item_id[1][1]].animation_index_code
    ani:setMount(animation_index_code)

    local node = ani:getAnimNode()
    node:setScale(0.4)
    node:setAnchorPoint(GlobalMethod:ccp(0.5,0))
    node:setRelativePosition(GlobalMethod:ccp(0.5,0))
    con:addChild(node,0,99)
    con:setScale(0)
    local scaleTo = CCScaleTo:create(0.5,1,1)

    con:runAction(scaleTo)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function CellLotteryShow:_adaptLanguage_vn()
	local name = GetElement(self.m_root,"name_CellLotteryShow",WZUILabelTTF)
	name:setScale(0.7)
end
-------------------------------------语言适配end----------------------------------------
