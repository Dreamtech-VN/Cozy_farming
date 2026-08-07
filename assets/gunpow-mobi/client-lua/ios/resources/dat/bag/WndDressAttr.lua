--WndDressAttr.lua
--@brief	WndDressAttr的UI模块
--@date		2015/07/09
--@author	zsq
--@note		时装加成属性


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDressAttr:onEnter(element)
	self.m_root = element
end

function WndDressAttr:onEnterTransitionDidFinish(element)
	 AdaptLanguage(self)--多语言版本界面适配
	self:update()
	self:initDressGrid()
	self:updateDressGrid()
    WindowManagerAni:createAction(self.m_root,false,nil,nil)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDressAttr:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮点击回调
function WndDressAttr:onClose(element)
    WZLog("WndDressAttr:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	开始按下回调函数
function WndDressAttr:onTouchBegan(element,pt)
	WZLog("WndDressAttr:onTouchBegin",pt.x,pt.y)
	WndItemInfo:onCloseClick()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	刷新界面
function WndDressAttr:update()
	WZLog("WndDressAttr:update")
	--设置文本
	GetElement(self.m_root,"topTitle1",WZUILabelTTF):setText(LocalStrings.HEAD..":")
	GetElement(self.m_root,"topTitle2",WZUILabelTTF):setText(LocalStrings.WNDDRESS1..":")
	GetElement(self.m_root,"topTitle3",WZUILabelTTF):setText(LocalStrings.CLOTHES..":")
	GetElement(self.m_root,"topTitle4",WZUILabelTTF):setText(LocalStrings.WING..":")
	GetElement(self.m_root,"btmTitle1",WZUILabelTTF):setText(LocalStrings.TIZHI..":")
	GetElement(self.m_root,"btmTitle2",WZUILabelTTF):setText(LocalStrings.POWER..":")
	GetElement(self.m_root,"btmTitle3",WZUILabelTTF):setText(LocalStrings.PRACTICE_ARMOR..":")
	GetElement(self.m_root,"btmTitle4",WZUILabelTTF):setText(LocalStrings.LUCKY..":")
	GetElement(self.m_root,"btmTitle5",WZUILabelTTF):setText(LocalStrings.AGILITY..":")
	GetElement(self.m_root,"btmTitle6",WZUILabelTTF):setText(LocalStrings.ANTIBREAKING..":")
	--设置默认显示
	local gameParam = CacheCenter:getGameParam()
	local list = {4906,4905,4904,4700}
	if tonumber(CacheCenter:getPlayerInfo().sex) == 0 then
		list[1] = gameParam.defaultManHeadId 
		list[2] = gameParam.defaultManFaceId 
		list[3] = gameParam.defaultManBodyId 
	else
		list[1] = gameParam.defaultWomanHeadId 
		list[2] = gameParam.defaultWomanFaceId 
		list[3] = gameParam.defaultWomanBodyId 
	end
	local num = {0,0,0,0}
	local tempList = CacheCenter:getDecorationList()
	for k,v in pairs(tempList) do
		for i=1,4 do
			--if v.subtype == (i-1) and v.lastTime ~= 0 and v.isUse then
			if v.subtype == (i-1) and v.lastTime ~= 0 then
				num[i] = num[i] + 1
			end
		end
	end
	for i=1,4 do
		GetElement(self.m_root,"ttfNum"..i.."_WndDressAttr",WZUILabelTTF):setText(string.format(LocalStrings.ACTIVITY_EQUIPMENT_NUMBER,num[i]))
		--if num[i] == 0 then
			--GetElement(self.m_root,"ttfNum"..i.."_WndDressAttr",WZUILabelTTF):setColor(GlobalMethod:ccc3(195,171,148))
		--	GetElement(self.m_root,"ttfNum"..i.."_WndDressAttr",WZUILabelTTF):setText(LocalStrings.UNEQUIPPED)
		--else
			--GetElement(self.m_root,"ttfNum"..i.."_WndDressAttr",WZUILabelTTF):setColor(GlobalMethod:ccc3(99,255,95))
		--	GetElement(self.m_root,"ttfNum"..i.."_WndDressAttr",WZUILabelTTF):setText(LocalStrings.EQUIPPED)
		--end
		--更新附加属性
		for k,v in pairs(GDatatab_shizhuang) do
			if (v.buwei + 1) == i then
				GetElement(self.m_root,"positionTitle"..i,WZUILabelTTF):setText(ATTR_TITLE[v.shuxing[1][1]]..":")
				if num[i] == v.number then
					GetElement(self.m_root,"positionAttr"..i.."_WndDressAttr",WZUILabelTTF):setText(v.shuxing[1][2])
				end
			end
		end
	end
	self:updateDressAttr()
end

--@brief	初始化时装格子
function WndDressAttr:initDressGrid()
	WZLog("WndDressAttr:initDressGrid")
	if self.m_root == nil then return end
	self.m_tDressGrid = {}
	for i=1,8 do
		local con = self.m_root:getChildElement("conDress"..i)
		if con ~= nil then
		   local celElement,tLuaObj = CellGoodItem:createElement()
			if celElement ~= nil and tLuaObj ~= nil then
    	    	--tLuaObj:setItemClickFun(self,self.onDressClicked)
				GetElement(tLuaObj.m_root,"btnClick_CellGoodItem",WZUIButton):setTouchEnable(false)
				--celElement:setScale(0.8)
				con:addChild(celElement)
            	celElement:setTag(i)
				tLuaObj:setSZBg()
				table.insert(self.m_tDressGrid,tLuaObj)
			end
		end
	end
end

--@brief	更新4个时装格子
function WndDressAttr:updateDressGrid()
	if self.m_root == nil then return end
	if self.m_tDressGrid == nil then return end
	if CacheCenter:getPlayerInfo() == nil then return end
	local dressType = {[1]=0,[2]=1,[3]=2,[4]=3}
	local equipmentList = CacheCenter:getEquipmentList()
	local imgList = {"ui/bag/common_icon_toubu.png","ui/bag/common_icon_biaoqing.png","ui/bag/common_icon_fuzhaung.png","ui/bag/common_icon_chibang.png"}
	if CacheCenter:getPlayerInfo().sex == 0 then
		imgList = {"ui/bag/common_icon_toubu2.png","ui/bag/common_icon_biaoqing2.png","ui/bag/common_icon_fuzhaung2.png","ui/bag/common_icon_chibang.png"}
	end	

	local totalFight = {0,0,0,0}

	for i=1,4 do
		local set = false
    	local txt = GetElement(self.m_root, "dressTxt"..i, WZUIImage)
		for j=1,#equipmentList do
			if equipmentList[j].maintype == 5 and equipmentList[j].subtype == dressType[i] then
   				self.m_tDressGrid[i]:setCellGoodItem(equipmentList[j],1)
    			GetElement(self.m_tDressGrid[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
				txt:setVisible(false)
				set = true
			end
		end
		if set == false then
			self.m_tDressGrid[i]:removeAllChild()
			self.m_tDressGrid[i]:setSZBg()
			txt:setVisible(true)
			txt:setFile(imgList[i])
			txt:setTouchEnable(false)
    		GetElement(self.m_tDressGrid[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi1.png")
    		GetElement(self.m_tDressGrid[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(true)
    		GetElement(self.m_tDressGrid[i].m_root, "btnImg1_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi1.png")
    		GetElement(self.m_tDressGrid[i].m_root, "btnImg2_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi1.png")
		end
	end
	WZLog(Serialize(CacheCenter:getDecorationList()))
	for i=1,4 do
		local set = false
    	local txt = GetElement(self.m_root, "dressTxt"..(i+4), WZUIImage)
		local dressList = CacheCenter:getDecorationList()
		local fight = 0
		for j=1,#dressList do
			if dressList[j].extraInfo.fighting >= fight and dressList[j].subtype == dressType[i] then
   				self.m_tDressGrid[i+4]:setCellGoodItem(dressList[j],1)
    			GetElement(self.m_tDressGrid[i+4].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
				fight = dressList[j].extraInfo.fighting
				totalFight[i] = fight
				txt:setVisible(false)
				set = true
			end
		end
		if set == false then
			self.m_tDressGrid[i+4]:removeAllChild()
			self.m_tDressGrid[i+4]:setSZBg()
			txt:setVisible(true)
			txt:setFile(imgList[i])
			txt:setTouchEnable(false)
    		GetElement(self.m_tDressGrid[i+4].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi1.png")
    		GetElement(self.m_tDressGrid[i+4].m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(true)
    		GetElement(self.m_tDressGrid[i+4].m_root, "btnImg1_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi1.png")
    		GetElement(self.m_tDressGrid[i+4].m_root, "btnImg2_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi1.png")
		end
	end

	GetElement(self.m_root,"maxFight",WZUILabelTTF):setText(totalFight[1]+totalFight[2]+totalFight[3]+totalFight[4])
end

--@brief	更新时装属性
function WndDressAttr:updateDressAttr()
	WZLog("WndDressAttr:updateDressAttr")
	if self.m_root == nil then return end
	self.m_tAttr = {}
	local dressType = {[1]=4,[2]=3,[3]=2,[4]=16}
	local playerInfo = CacheCenter:getPlayerInfo()
	--local attrId = {"9","10","11","13","12","19","20"}
	local attrId = {"1","3","4","12","13"}
	local tFashionProperty = json.decode(playerInfo.fashionProperty)
	--设置时装属性
	for i=1,#attrId do
    	for k,v in pairs(tFashionProperty) do
			if k == attrId[i] then
				self.m_tAttr[i] = v
			end
		end
	end
	----显示时装属性
	for i=1,#attrId do
		WZLog("ttfAttr"..i.."_WndDressAttr")
    	GetElement(self.m_root, "ttfAttr"..i.."_WndDressAttr", WZUILabelTTF):setText(self.m_tAttr[i])
	end
	--显示战斗力
   	GetElement(self.m_root, "fight_WndDressAttr", WZUILabelTTF):setText(playerInfo.fashionFighting)
end

--@brief	时装格子被点击函数
function WndDressAttr:onDressClicked(tLuaObj,tag,tData)
	WZLog("WndDressAttr:onDressClicked",tag)
	if tData ~= nil and tData.basicInfo ~= nil then
		local tOther = {interface = 1}
		local con = GetElement(self.m_root,"con",WZUIContainer)
    	WndItemInfo:showInfo(tLuaObj.m_root,con,1,tData,false,nil,nil,tOther)
	else
		local showWord = {LocalStrings.PHOTO,LocalStrings.WNDDRESS1,LocalStrings.CLOTHES,LocalStrings.WING,LocalStrings.PHOTO,LocalStrings.WNDDRESS1,LocalStrings.CLOTHES,LocalStrings.WING}
		local con = GetElement(self.m_root,"con",WZUIContainer)
		WndItemInfo:showInfo(tLuaObj.m_root,con,3,showWord[tag],false)
	end
end
-------------------------语言适配Began--------------------------------

--@brief	英语适配
function WndDressAttr:_adaptLanguage_en()
	local fight = GetElement(self.m_root,"fight_WndDressAttr",WZUILabelTTF)
	fight:setRelativePosition(GlobalMethod:ccp(0.65,0.418))

	local ttfAttr4 = GetElement(self.m_root,"ttfAttr4_WndDressAttr",WZUILabelTTF)
	ttfAttr4:setRelativePosition(GlobalMethod:ccp(0.546154,0.5))

	local ps = GetElement(self.m_root,"positionTitle1",WZUILabelTTF)
	ps:setRelativePosition(GlobalMethod:ccp(0.65,0.5))

	ps = GetElement(self.m_root,"positionTitle2",WZUILabelTTF)
	ps:setRelativePosition(GlobalMethod:ccp(0.65,0.5))

	ps = GetElement(self.m_root,"positionTitle3",WZUILabelTTF)
	ps:setRelativePosition(GlobalMethod:ccp(0.65,0.5))

	ps = GetElement(self.m_root,"positionTitle4",WZUILabelTTF)
	ps:setRelativePosition(GlobalMethod:ccp(0.65,0.5))

	local maxFight = GetElement(self.m_root,"maxFight",WZUILabelTTF)
	maxFight:setRelativePosition(GlobalMethod:ccp(0.65,0.648))
end

function WndDressAttr:_adaptLanguage_th()
	local txtTitie = GetElement(self.m_root,"txtTitie_WndDressAttr",WZUILabelTTF)
	txtTitie:setScale(0.8)

	local ttfAttr4 = GetElement(self.m_root,"ttfAttr4_WndDressAttr",WZUILabelTTF)
	ttfAttr4:setRelativePosition(GlobalMethod:ccp(0.546154,0.5))

	local ps = GetElement(self.m_root,"positionTitle1",WZUILabelTTF)
	ps:setRelativePosition(GlobalMethod:ccp(0.65,0.5))

	ps = GetElement(self.m_root,"positionTitle2",WZUILabelTTF)
	ps:setRelativePosition(GlobalMethod:ccp(0.65,0.5))

	ps = GetElement(self.m_root,"positionTitle3",WZUILabelTTF)
	ps:setRelativePosition(GlobalMethod:ccp(0.65,0.5))

	ps = GetElement(self.m_root,"positionTitle4",WZUILabelTTF)
	ps:setRelativePosition(GlobalMethod:ccp(0.65,0.5))
 	GetElement(self.m_root,"topTitle1",WZUILabelTTF):setFontSize(18)
 	GetElement(self.m_root,"topTitle2",WZUILabelTTF):setFontSize(16)
 	GetElement(self.m_root,"topTitle3",WZUILabelTTF):setFontSize(18)
 	GetElement(self.m_root,"ttfNum2_WndDressAttr",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.5))
end

function WndDressAttr:_adaptLanguage_pt(  )
	GetElement(self.m_root,"maxFight",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.73,0.64))
	GetElement(self.m_root,"ttfAttr4_WndDressAttr",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.515385,0.5))
	for i=1,4 do
		GetElement(self.m_root,"positionAttr"..i.."_WndDressAttr",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.83,0.5))
	end

	GetElement(self.m_root,"btmTitle4",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.285385,0.5))
	GetElement(self.m_root,"ttfAttr4_WndDressAttr",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.692308,0.5))

	local fight = GetElement(self.m_root,"fight_WndDressAttr",WZUILabelTTF)
	fight:setRelativePosition(GlobalMethod:ccp(0.68,0.418))

end

function WndDressAttr:_adaptLanguage_tr(  )
	--GetElement(self.m_root,"txtTitie_WndDressAttr",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"topTitle1",WZUILabelTTF):setScale(0.8)
	-- GetElement(self.m_root,"ttfNum4_WndDressAttr",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.5))
	for i=1,4 do
		local txtAttr = GetElement(self.m_root,"positionAttr"..i.."_WndDressAttr",WZUILabelTTF)
		txtAttr:setRelativePosition(GlobalMethod:ccp(0.82,0.5))
		GetElement(self.m_root,"positionTitle"..i,WZUILabelTTF):setScale(0.77)
	end

	GetElement(self.m_root,"maxFight",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.64))
end


--@brief	越南语适配
function WndDressAttr:_adaptLanguage_vn()
	WZLog("WndDressAttr:_adaptLanguage_vn")

	local topTitle1 = GetElement(self.m_root,"topTitle1",WZUILabelTTF)
	topTitle1:setFontSize(18)
	topTitle1:setRelativePosition(GlobalMethod:ccp(0.146471,0.5))
	local ttfNum1 = GetElement(self.m_root,"ttfNum1_WndDressAttr",WZUILabelTTF)
	ttfNum1:setFontSize(18)
	ttfNum1:setRelativePosition(GlobalMethod:ccp(0.300588,0.5))

	local topTitle2 = GetElement(self.m_root,"topTitle2",WZUILabelTTF)
	topTitle2:setFontSize(18)
	topTitle2:setRelativePosition(GlobalMethod:ccp(0.18,0.5))
	local ttfNum2 = GetElement(self.m_root,"ttfNum2_WndDressAttr",WZUILabelTTF)
	ttfNum2:setFontSize(18)
	ttfNum2:setRelativePosition(GlobalMethod:ccp(0.40,0.5))

	local topTitle3 = GetElement(self.m_root,"topTitle3",WZUILabelTTF)
	topTitle3:setFontSize(18)
	topTitle3:setRelativePosition(GlobalMethod:ccp(0.205294,0.5))
	local ttfNum3 = GetElement(self.m_root,"ttfNum3_WndDressAttr",WZUILabelTTF)
	ttfNum3:setFontSize(18)
	ttfNum3:setRelativePosition(GlobalMethod:ccp(0.44,0.5))

	local topTitle4= GetElement(self.m_root,"topTitle4",WZUILabelTTF)
	topTitle4:setFontSize(18)
	topTitle4:setRelativePosition(GlobalMethod:ccp(0.146471,0.5))
	local ttfNum4= GetElement(self.m_root,"ttfNum4_WndDressAttr",WZUILabelTTF)
	ttfNum4:setFontSize(18)
	ttfNum4:setRelativePosition(GlobalMethod:ccp(0.3,0.5))

	local btmTitle1 = GetElement(self.m_root,"btmTitle1",WZUILabelTTF)
	btmTitle1:setRelativePosition(GlobalMethod:ccp(0.181765,0.5))
	GetElement(self.m_root,"ttfAttr1_WndDressAttr",WZUILabelTTF):setFontSize(18)

	local btmTitle2 = GetElement(self.m_root,"btmTitle2",WZUILabelTTF)
	btmTitle2:setFontSize(18)
	btmTitle2:setRelativePosition(GlobalMethod:ccp(0.152353,0.5))
	GetElement(self.m_root,"ttfAttr2_WndDressAttr",WZUILabelTTF):setFontSize(18)

	local btmTitle3= GetElement(self.m_root,"btmTitle3",WZUILabelTTF)
	btmTitle3:setFontSize(18)
	btmTitle3:setRelativePosition(GlobalMethod:ccp(0.199412,0.5))
	GetElement(self.m_root,"ttfAttr3_WndDressAttr",WZUILabelTTF):setFontSize(18)

	local btmTitle4 = GetElement(self.m_root,"btmTitle4",WZUILabelTTF)
	btmTitle4:setFontSize(18)
	btmTitle4:setRelativePosition(GlobalMethod:ccp(0.181765,0.5))
	GetElement(self.m_root,"ttfAttr4_WndDressAttr",WZUILabelTTF):setFontSize(18)

	local btmTitle5= GetElement(self.m_root,"btmTitle5",WZUILabelTTF)
	btmTitle5:setFontSize(18)
	btmTitle5:setRelativePosition(GlobalMethod:ccp(0.234706,0.5))
	GetElement(self.m_root,"ttfAttr5_WndDressAttr",WZUILabelTTF):setFontSize(18)

	local btmTitle6= GetElement(self.m_root,"btmTitle6",WZUILabelTTF)
	btmTitle6:setFontSize(18)
	btmTitle6:setRelativePosition(GlobalMethod:ccp(0.193529,0.5))
	GetElement(self.m_root,"ttfAttr5_WndDressAttr",WZUILabelTTF):setFontSize(18)

	GetElement(self.m_root,"maxFight",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.73,0.64))
	GetElement(self.m_root,"ttfAttr5_WndDressAttr",WZUIlabelTTF):setRelativePosition(GlobalMethod:ccp(0.58,0.5))
	for i=1,4 do
		GetElement(self.m_root,"positionAttr"..i.."_WndDressAttr",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.8,0.5))
	end
	
	local fight = GetElement(self.m_root,"fight_WndDressAttr",WZUILabelTTF)
	fight:setRelativePosition(GlobalMethod:ccp(0.65,0.418))
end

function WndDressAttr:_adaptLanguage_es(  )
	local maxFight = GetElement(self.m_root,"maxFight",WZUILabelTTF)
	maxFight:setRelativePosition(GlobalMethod:ccp(0.75,0.64))
	for i=2,5 do
		GetElement(self.m_root,"btmTitle"..i,WZUILabelTTF):setScale(0.8)
	end
	local ttfAttr3 = GetElement(self.m_root,"ttfAttr3_WndDressAttr",WZUILabelTTF)
	ttfAttr3:setRelativePosition(GlobalMethod:ccp(0.53,0.5))
	local ttfAttr4 = GetElement(self.m_root,"ttfAttr4_WndDressAttr",WZUILabelTTF)
	ttfAttr4:setRelativePosition(GlobalMethod:ccp(0.57,0.5))
	local positionAttr1 = GetElement(self.m_root,"positionAttr1_WndDressAttr",WZUILabelTTF)
	positionAttr1:setRelativePosition(GlobalMethod:ccp(0.78,0.5))
	local positionAttr3 = GetElement(self.m_root,"positionAttr3_WndDressAttr",WZUILabelTTF)
	positionAttr3:setRelativePosition(GlobalMethod:ccp(0.8,0.5))
	local positionAttr4 = GetElement(self.m_root,"positionAttr4_WndDressAttr",WZUILabelTTF)
	positionAttr4:setRelativePosition(GlobalMethod:ccp(0.9,0.5))

	GetElement(self.m_root,"topTitle2",WZUILabelTTF):setFontSize(16)
	local ttfNum2 = GetElement(self.m_root,"ttfNum2_WndDressAttr",WZUILabelTTF)
	ttfNum2:setRelativePosition(GlobalMethod:ccp(0.41,0.5))

	local fight = GetElement(self.m_root,"fight_WndDressAttr",WZUILabelTTF)
	fight:setRelativePosition(GlobalMethod:ccp(0.7,0.418))
end
-------------------------语言适配End----------------------------------
