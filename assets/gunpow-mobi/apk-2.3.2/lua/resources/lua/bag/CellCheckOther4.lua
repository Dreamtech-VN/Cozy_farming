--CellCheckOther4.lua
--@brief	CellCheckOther4的UI模块
--@date		2015/07/06
--@author	zsq
--@note		玩家信息栏显示装备和时装


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCheckOther4:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	加载动画
function CellCheckOther4:onEnterTransitionDidFinish(element)
    self:initGrid()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOther4:onExit(element)
	self:_unInit()
end

--@brief	添加tips按钮
function CellCheckOther4:addTipsBtn()
	local iconList = {"ui/bag/buff_04.png","ui/bag/buff_03.png","ui/bag/buff_02.png"}
	for i=1,3 do
		local btn = WZUIButton:create()
		local imgNor = WZUI9Image:create()
		imgNor:setFile(iconList[i])
		imgNor:setUseOriginSize(true)
		local imgSel = WZUI9Image:create()
		imgSel:setFile(iconList[i])
		imgSel:setUseOriginSize(true)
		btn:setNormalElement(imgNor)
		btn:setSelectElement(imgSel)
        btn:setLuaDoneFunctionName("onTip"..i)
		btn:setRelativePosition(GlobalMethod:ccp(0.69+i*0.08,0.84))
		btn:setUseAbsSize(true)
		btn:setAbsContentSize(GlobalMethod:CCSize(30,30))
		self.m_root:addChild(btn)
	end
end

function CellCheckOther4:onTip1(element)
	WZLog("CellCheckOther4:onTip1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = WndCheckOther.m_tPlayerInfo.strongSuitId
	if id == 0 then id = -1 end
	local tData = {id=id}
    
	WndTips:show(element,WndCheckOther.m_root,9,tData,GlobalMethod:ccp(50,-20), true)
	WndTips.m_root:setShowAll(true)
end

function CellCheckOther4:onTip2(element)
	WZLog("CellCheckOther4:onTip2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = WndCheckOther.m_tPlayerInfo.starSuitId
	if id == 0 then id = -2 end
	local tData = {id=id}
    
	WndTips:show(element,WndCheckOther.m_root,9,tData,GlobalMethod:ccp(50,-20), true)
	WndTips.m_root:setShowAll(true)
end

function CellCheckOther4:onTip3(element)
	WZLog("CellCheckOther4:onTip3")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = WndCheckOther.m_tPlayerInfo.mosaicSuitId
	if id == 0 then id = -3 end
	local tData = {id=id}
    
	WndTips:show(element,WndCheckOther.m_root,9,tData,GlobalMethod:ccp(50,-20), true)
	WndTips.m_root:setShowAll(true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	查看其他玩家信息:初始化4个时装格子
function CellCheckOther4:initGrid()
	WZLog("CellCheckOther4:initOtherGrid")
	if self.m_root == nil then return end
	self.gridList = {}
	for i=1,6 do
		local con = self.m_root:getChildElement("con"..i)
		if con ~= nil then
		   local celElement,tLuaObj = CellGoodItem:createElement()
			if celElement ~= nil and tLuaObj ~= nil then
	    	    tLuaObj:setItemClickFun(self,self.onClick)
				con:addChild(celElement)
            	celElement:setTag(i)
				celElement:setScale(0.894)
				table.insert(self.gridList,tLuaObj)
			end
		end
	end
end

--@brief	显示时装
function CellCheckOther4:showDress(tData)
	if self.m_root == nil then return end
	if WndCheckOther.m_root == nil then return end
	self.m_nType = 2

	--设置标题
	self.m_sTitle = LocalStrings.BAGTIP43 
	self.m_nRowNum = 1 
	self:addTitle()

	local dressType = {[1]=0,[2]=1,[3]=2,[4]=3}
	local equipmentList = tData
	local imgList = {"ui/bag/common_icon_toubu.png","ui/bag/common_icon_biaoqing.png","ui/bag/common_icon_fuzhaung.png","ui/bag/common_icon_chibang.png"}
	if WndCheckOther.m_tPlayerInfo.sex == 0 then
		imgList = {"ui/bag/common_icon_toubu2.png","ui/bag/common_icon_biaoqing2.png","ui/bag/common_icon_fuzhaung2.png","ui/bag/common_icon_chibang.png"}
	end	

	for i=1,4 do
		local set = false
    	local txt = GetElement(self.m_root, "blank"..i, WZUIImage)
		for j=1,#equipmentList do
			if equipmentList[j].maintype == 5 and equipmentList[j].subtype == dressType[i] and equipmentList[j].isUse == true then
   				self.gridList[i]:setCellGoodItem(equipmentList[j],13)
    			--GetElement(self.gridList[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
				txt:setVisible(false)
				set = true
			end
		end
		if set == false then
			self.gridList[i]:removeAllChild()
			--self.gridList[i]:setSZBg()
			txt:setVisible(true)
			txt:setFile(imgList[i])
		end
	end
	GetElement(self.m_root,"imgTitle_CellCheckOther4",WZUIImage):setVisible(false)
	GetElement(self.m_root,"btnTips_CellCheckOther4",WZUIButton):setTouchEnable(false)
	GetElement(self.gridList[5].m_root,"btnClick_CellGoodItem",WZUIButton):setTouchEnable(false)
	GetElement(self.gridList[6].m_root,"btnClick_CellGoodItem",WZUIButton):setTouchEnable(false)
--	self:createLabel("("..LocalStrings.BAGTIP43..")")
end

--@brief	显示战力最高时装
function CellCheckOther4:showDress1(tData)
	if self.m_root == nil then return end
	if WndCheckOther.m_root == nil then return end
	self.m_nType = 2
	--设置标题
	self.m_sTitle = LocalStrings.BATTLE 
	self.m_nRowNum = 1 
	self:addTitle()
	if "vn" == ProjConfig.LANGUAGE then
		
	end
	
	local dressType = {[1]=0,[2]=1,[3]=2,[4]=3}
	local equipmentList = tData
	local imgList = {"ui/bag/common_icon_toubu.png","ui/bag/common_icon_biaoqing.png","ui/bag/common_icon_fuzhaung.png","ui/bag/common_icon_chibang.png"}
	if WndCheckOther.m_tPlayerInfo.sex == 0 then
		imgList = {"ui/bag/common_icon_toubu2.png","ui/bag/common_icon_biaoqing2.png","ui/bag/common_icon_fuzhaung2.png","ui/bag/common_icon_chibang.png"}
	end	

	local myself = false
	if WndCheckOther.m_nPlayerId == CacheCenter:getPlayerInfo().id then
		myself = true
	else
		myself = false
	end
	for i=1,4 do
		local set = false
		local fight = 0
    	local txt = GetElement(self.m_root, "blank"..i, WZUIImage)
		for j=1,#equipmentList do
			if equipmentList[j].maintype == 5 and equipmentList[j].subtype == dressType[i] and tonumber(equipmentList[j].extraInfo.fighting) >= fight then
				if myself then
					if equipmentList[j].lastTime == -1 or equipmentList[j].lastTime > 0 then
   					self.gridList[i]:setCellGoodItem(equipmentList[j],13)
					txt:setVisible(false)
					fight = equipmentList[j].extraInfo.fighting
					set = true
					end
				else
   					self.gridList[i]:setCellGoodItem(equipmentList[j],13)
					txt:setVisible(false)
					fight = equipmentList[j].extraInfo.fighting
					set = true
				end
			end
		end
		if set == false then
			self.gridList[i]:removeAllChild()
			txt:setVisible(true)
			txt:setFile(imgList[i])
		end
	end
	GetElement(self.m_root,"btnTips_CellCheckOther4",WZUIButton):setVisible(true)
	GetElement(self.gridList[5].m_root,"btnClick_CellGoodItem",WZUIButton):setTouchEnable(false)
	GetElement(self.gridList[6].m_root,"btnClick_CellGoodItem",WZUIButton):setTouchEnable(false)
--	self:createLabel("("..LocalStrings.BATTLE..")")
end

--@brief	创建文本
function CellCheckOther4:createLabel(text)
	local text = text or ""
    local con = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellGoodItem"))
    local exPlain = WZUILabelTTF:create()
    exPlain:setColor(ccc3(255,236,193))
    exPlain:setFontSize(22)
    exPlain:setBoldFont(true)
    exPlain:setEnableStroke(false)
    exPlain:setStrokeColor(ccc3(60,19,12))
    --exPlain:setDimensions(CCSize(60,60))
    if ProjConfig.LANGUAGE == "pt" then
    	exPlain:setRelativePosition(ccp(0.36,0.83))
	elseif ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "ug" then
    	exPlain:setRelativePosition(ccp(0.42,0.83))
    else
	    exPlain:setRelativePosition(ccp(0.33,0.83))
	end
    exPlain:setText(text)
    self.m_root:addChild(exPlain)
end

--@brief	点击图标
function CellCheckOther4:onClick(tCell,tag,tData)
	WZLog("CellCheckOther4:onClick",tag, Serialize(tData))
	local tips
	if self.m_nType == 1 then
		tips = {LocalStrings.WEAPON,LocalStrings.NECKLACE,LocalStrings.RING,LocalStrings.BRACELET,LocalStrings.TREASURE,LocalStrings.MEDAL}
	elseif self.m_nType == 2 then
		tips = {LocalStrings.HEAD,LocalStrings.WNDDRESS1,LocalStrings.CLOTHES,LocalStrings.WING}
	elseif self.m_nType == 3 then
		tips = {LocalStrings.WEAPON,LocalStrings.NEWBAG9,LocalStrings.PHANTOM_EQUIPMENT2,LocalStrings.PHANTOM_EQUIPMENT3,LocalStrings.PHANTOM_EQUIPMENT4,LocalStrings.PHANTOM_EQUIPMENT5,}
	end
	if tData ~= nil then
    	WndItemInfo:showInfo(tCell.m_root,WndCheckOther.m_root,1,tData,false, nil, true)
	else
		WndItemInfo:showInfo(tCell.m_root,WndCheckOther.m_root,3,tips[tag],false, nil, true)
    	GetElement(tCell.m_root, "btnImg2_CellGoodItem", WZUI9Image):setVisible(false)
	end
end

--@brief	显示装备
function CellCheckOther4:showEquip(tEquip)
	--WZLog("CellCheckOther2:showEquip",Serialize(tEquip))
	if tEquip == nil then return end
	--添加tips按钮
	self:addTipsBtn()
	--设置标题
	self.m_sTitle = LocalStrings.CHECKOTHER7 
	self.m_nRowNum = 2 
	self:addTitle()
	--语言适配
	local language = ProjConfig.LANGUAGE
	if "en" == language then
		
	end
	if "vn" == language then
	end	
	--tag 1:武器，2：项链，3：戒指，4：手镯，5：宝物，6：勋章
	local iconList = {"ui/bag/common_icon_wuqi.png","ui/bag/common_icon_xianglian.png","ui/bag/common_icon_jiezhi.png",
			"ui/bag/common_icon_shouzhuo.png","ui/bag/common_icon_baowu.png","ui/bag/common_icon_xunzhang.png",}
	--设置底图
	for i=1,5 do
		local emptyIcon = GetElement(self.m_root,"blank"..i,WZUIImage)
		emptyIcon:setFile(iconList[i])
		emptyIcon:setVisible(true)
	end
	self.m_nType = 1
	self.m_tDataList = {}
	local itemSuitNum = WndCheckOther.m_tPlayerInfo.itemSuitNum
	local itemSuitId = WndCheckOther.m_tPlayerInfo.itemSuitId
	for i=1,#tEquip do
		if tEquip[i].basicInfo then
			for j=1,5 do
				local emptyIcon = GetElement(self.m_root,"blank"..j,WZUIImage)
	    		GetElement(self.gridList[j].m_root, "btnImg2_CellGoodItem", WZUI9Image):setVisible(false)
	    		
				if j == 1 then
					if tEquip[i].basicInfo.main_type == 4 and (tEquip[i].basicInfo.sub_type == 0 or tEquip[i].basicInfo.sub_type == 1) 
						and tEquip[i].isUse == true then
						self.m_tDataList[j] = tEquip[i]
						GetElement(self.m_root,"blank"..j,WZUIImage):setVisible(false)
	   					self.gridList[j]:setCellGoodItem(tEquip[i],1)
						self.gridList[j]:_showSuitAni(itemSuitNum, itemSuitId)
						if self.gridList[j].m_labelLevel ~= nil then
	        				self.gridList[j].m_labelLevel:setRelativePosition(GlobalMethod:ccp(0.75,0.93))
						end
	    				GetElement(self.gridList[j].m_root, "btnImg2_CellGoodItem", WZUI9Image):setVisible(true)
					end
				else
					if tEquip[i].basicInfo.main_type == 4 and tEquip[i].basicInfo.sub_type == j and tEquip[i].isUse == true then
						self.m_tDataList[j] = tEquip[i]
						GetElement(self.m_root,"blank"..j,WZUIImage):setVisible(false)
	   					self.gridList[j]:setCellGoodItem(tEquip[i],1)
						self.gridList[j]:_showSuitAni(itemSuitNum, itemSuitId)
						if self.gridList[j].m_labelLevel ~= nil then
	        				self.gridList[j].m_labelLevel:setRelativePosition(GlobalMethod:ccp(0.75,0.93))
						end
	    				GetElement(self.gridList[j].m_root, "btnImg2_CellGoodItem", WZUI9Image):setVisible(true)
					end
				end
			end
		end
	end
end

--@brief	显示皮肤装备
function CellCheckOther4:showPhantomEquip(tEquip)
	WZLog("CellCheckOther4:showPhantomEquip1",tEquip)
	self.m_nType = 3
	--设置标题
	self.m_sTitle = LocalStrings.PHANTOM_EQUIPMENT1
	self.m_nRowNum = 1
	self:addTitle()
	GetElement(self.m_root, "txtTitle_CellCheckOther4", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(36,0))
	GetElement(self.m_root, "txtTitle_CellCheckOther4", WZUILabelTTF):setFontSize(16)

	-- 1：武器，2：副手，3：帽子，4：上衣，5：裤子，6：鞋子
	local iconList = {"ui/phantom/common_icon_wq.png","ui/phantom/common_icon_fs.png","ui/phantom/common_icon_mz.png",
		"ui/phantom/common_icon_sy.png","ui/phantom/common_icon_kz.png","ui/phantom/common_icon_xz.png",}

	--设置底图
	for i=1,6 do
		local emptyIcon = GetElement(self.m_root,"blank"..i,WZUIImage)
		emptyIcon:setFile(iconList[i])
		emptyIcon:setVisible(true)
	end

	if tEquip == nil then return end

	local tEquip = json.decode(tEquip)
	WZLog("CellCheckOther4:showPhantomEquip2 tEquip=",Serialize(tEquip))

	self.m_tDataList = {}
	for i=1,#tEquip.equip do
		if tEquip.equip[i] ~= 0 then
			local emptyIcon = GetElement(self.m_root,"blank"..i,WZUIImage)
			emptyIcon:setVisible(false)
			self.m_tDataList[i] = tEquip.equip[i]
	    	self.gridList[i]:setCellGoodLocalId(tEquip.equip[i],1,1)
	    	GetElement(self.gridList[i].m_root, "btnImg2_CellGoodItem", WZUI9Image):setVisible(true)
		end
	end

end

--@brief 	标题
function CellCheckOther4:addTitle()
	-- body
	if self.m_sTitle == nil then return end 
	if self.m_root == nil then return end 

	-- local conForTitle = GetElement(self.m_root, "conForTitle_CellCheckOther4", WZUIContainer)
	-- local celElement,tCell = CellCheckOther8:createElement()
	-- if celElement ~= nil and tCell ~= nil then 
	-- 	celElement = WZUIContainer:luaTo(celElement)
	-- 	tCell:setTitle(self.m_sTitle, self.m_nRowNum)

	-- 	conForTitle:addChild(celElement)
	-- end

	local nBgWidth = 482 --背景宽度
	local nBgBaseHeight = 90 --背景一行的高度
	local nBgInterval = 72 --背景每增加一行高度
	local nSlWidth = 3 --分割线宽度
	local nSlBaseHeight = 60 --分割线一行的高度
	local nSlInterval = 72 --分割线每增加一行高度

	local conNewBg = GetElement(self.m_root, "conNewBg_CellCheckOther4", WZUIContainer)
	conNewBg:setAbsContentSize(GlobalMethod:CCSize(nBgWidth, nBgBaseHeight+(self.m_nRowNum-1)*nBgInterval))
	conNewBg:updateRelativeSize()
	local conSplitLine = GetElement(self.m_root, "conSplitLine_CellCheckOther4", WZUIContainer)
	conSplitLine:setAbsContentSize(GlobalMethod:CCSize(nSlWidth, nSlBaseHeight+(self.m_nRowNum-1)*nSlInterval))
	conSplitLine:updateRelativeSize()
	GetElement(self.m_root, "txtTitle_CellCheckOther4", WZUILabelTTF):setText(self.m_sTitle)
end

function CellCheckOther4:onClickTips(element)
	-- body
	local tData = {}
	tData = {id = 75}
	local tempccp = GlobalMethod:ccp(220,30)
	if self.m_nType == 3 then
		tData = {id = 76}
		tempccp = GlobalMethod:ccp(220,50)
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndTips:show(element,WndCheckOther.m_root,67,tData,tempccp,true,false)
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin------------------------------------------
function CellCheckOther4:_adaptLanguage_vn(  )
	local txtTitle = GetElement(self.m_root, "txtTitle_CellCheckOther4", WZUILabelTTF)
	if txtTitle then
		txtTitle:setScale(0.6)
		txtTitle:setDimensions(GlobalMethod:CCSize(60))
	end
end

function CellCheckOther4:_adaptLanguage_ug(  )
	local txtTitle = GetElement(self.m_root, "txtTitle_CellCheckOther4", WZUILabelTTF)
	txtTitle:setScale(0.7)
	txtTitle:setRelativePosition(GlobalMethod:ccp(0.0153659,0.760714))
end
-------------------------------------语言适配End--------------------------------------------
