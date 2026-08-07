--CellCheckOther7.lua
--@brief	CellCheckOther7的UI模块
--@date		2015/07/06
--@author	zsq
--@note		玩家信息栏显示装备和时装


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCheckOther7:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	加载动画
function CellCheckOther7:onEnterTransitionDidFinish(element)
    self:initGrid()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOther7:onExit(element)
	self:_unInit()
end

--@brief	添加tips按钮
function CellCheckOther7:addTipsBtn()
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
		btn:setRelativePosition(GlobalMethod:ccp(0.69+i*0.08,0.88))
		btn:setUseAbsSize(true)
		btn:setAbsContentSize(GlobalMethod:CCSize(30,30))
		self.m_root:addChild(btn)
	end
end

function CellCheckOther7:onTip1(element)
	WZLog("CellCheckOther7:onTip1")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = WndCheckOther.m_tPlayerInfo.strongSuitId
	if id == 0 then id = -1 end
	local tData = {id=id}
    
	WndTips:show(element,WndCheckOther.m_root,9,tData,GlobalMethod:ccp(50,-20))
	WndTips.m_root:setShowAll(true)
end

function CellCheckOther7:onTip2(element)
	WZLog("CellCheckOther7:onTip2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = WndCheckOther.m_tPlayerInfo.starSuitId
	if id == 0 then id = -2 end
	local tData = {id=id}
    
	WndTips:show(element,WndCheckOther.m_root,9,tData,GlobalMethod:ccp(50,-20))
	WndTips.m_root:setShowAll(true)
end

function CellCheckOther7:onTip3(element)
	WZLog("CellCheckOther7:onTip3")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = WndCheckOther.m_tPlayerInfo.mosaicSuitId
	if id == 0 then id = -3 end
	local tData = {id=id}
    
	WndTips:show(element,WndCheckOther.m_root,9,tData,GlobalMethod:ccp(50,-20))
	WndTips.m_root:setShowAll(true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	查看其他玩家信息:初始化
function CellCheckOther7:initGrid()
	WZLog("CellCheckOther7:initOtherGrid")
	if self.m_root == nil then return end
	self.gridList = {}
	for i=1,8 do
		local con = self.m_root:getChildElement("con"..i)
		if con ~= nil then
		   local celElement,tLuaObj = CellGoodItem:createElement()
			if celElement ~= nil and tLuaObj ~= nil then
    	    	tLuaObj:setItemClickFun(self,self.onClick)
				con:addChild(celElement)
            	celElement:setTag(i)
				celElement:setScale(0.925)
				table.insert(self.gridList,tLuaObj)
			end
		end
	end
end

--@brief	显示时装
function CellCheckOther7:showDress(tData)
	if self.m_root == nil then return end
	if WndCheckOther.m_root == nil then return end
	self.m_nType = 2
	--设置标题
	GetElement(self.m_root,"txtTitle_CellCheckOther7",WZUILabelTTF):setText(LocalStrings.CHECKOTHER8)

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
	GetElement(self.gridList[5].m_root,"btnClick_CellGoodItem",WZUIButton):setTouchEnable(false)
	GetElement(self.gridList[6].m_root,"btnClick_CellGoodItem",WZUIButton):setTouchEnable(false)
	self:createLabel("("..LocalStrings.BAGTIP43..")")
end

--@brief	显示战力最高时装
function CellCheckOther7:showDress1(tData)
	if self.m_root == nil then return end
	if WndCheckOther.m_root == nil then return end
	self.m_nType = 2
	--设置标题
	GetElement(self.m_root,"txtTitle_CellCheckOther7",WZUILabelTTF):setText(LocalStrings.CHECKOTHER8)

	local dressType = {[1]=0,[2]=1,[3]=2,[4]=3}
	local equipmentList = tData
	local imgList = {"ui/bag/common_icon_toubu.png","ui/bag/common_icon_biaoqing.png","ui/bag/common_icon_fuzhaung.png","ui/bag/common_icon_chibang.png"}
	if WndCheckOther.m_tPlayerInfo.sex == 0 then
		imgList = {"ui/bag/common_icon_toubu2.png","ui/bag/common_icon_biaoqing2.png","ui/bag/common_icon_fuzhaung2.png","ui/bag/common_icon_chibang.png"}
	end	

	for i=1,4 do
		local set = false
		local fight = 0
    	local txt = GetElement(self.m_root, "blank"..i, WZUIImage)
		for j=1,#equipmentList do
			if equipmentList[j].maintype == 5 and equipmentList[j].subtype == dressType[i] and tonumber(equipmentList[j].extraInfo.fighting) >= fight then
   				self.gridList[i]:setCellGoodItem(equipmentList[j],13)
				txt:setVisible(false)
				fight = equipmentList[j].extraInfo.fighting
				set = true
			end
		end
		if set == false then
			self.gridList[i]:removeAllChild()
			txt:setVisible(true)
			txt:setFile(imgList[i])
		end
	end
	GetElement(self.gridList[5].m_root,"btnClick_CellGoodItem",WZUIButton):setTouchEnable(false)
	GetElement(self.gridList[6].m_root,"btnClick_CellGoodItem",WZUIButton):setTouchEnable(false)
	self:createLabel("("..LocalStrings.BATTLE..")")
end

--@brief	创建文本
function CellCheckOther7:createLabel(text)
	local text = text or ""
    local con = WZUIContainer:luaTo(self.m_root:getChildElement("conItem_CellGoodItem"))
    local exPlain = WZUILabelTTF:create()
    exPlain:setColor(ccc3(255,236,193))
    exPlain:setFontSize(22)
    exPlain:setBoldFont(true)
    exPlain:setEnableStroke(false)
    exPlain:setStrokeColor(ccc3(60,19,12))
    --exPlain:setDimensions(CCSize(60,60))
    exPlain:setRelativePosition(ccp(0.3,0.83))
    exPlain:setText(text)
    self.m_root:addChild(exPlain)
end

--@brief	点击图标
function CellCheckOther7:onClick(tCell,tag,tData)
	WZLog("CellCheckOther7:onClick",tag)
	local tips
	if self.m_nType == 1 then
		tips = {LocalStrings.WEAPON,LocalStrings.NECKLACE,LocalStrings.RING,LocalStrings.BRACELET,LocalStrings.TREASURE,LocalStrings.MEDAL}
	elseif self.m_nType == 2 then
		tips = {LocalStrings.PHOTO,LocalStrings.WNDDRESS1,LocalStrings.CLOTHES,LocalStrings.WING}
	end
	if tData ~= nil then
    	WndItemInfo:showInfo(tCell.m_root,WndCheckOther.m_root,1,tData,false)
	else
		WndItemInfo:showInfo(tCell.m_root,WndCheckOther.m_root,3,tips[tag],false)
    	GetElement(tCell.m_root, "btnImg2_CellGoodItem", WZUI9Image):setVisible(false)
	end
end

--@brief	显示装备
function CellCheckOther7:showEquip(tEquip)
	--WZLog("CellCheckOther2:showEquip",Serialize(tEquip))
	if tEquip == nil then return end
	--添加tips按钮
	self:addTipsBtn()
	--设置标题
	GetElement(self.m_root,"txtTitle_CellCheckOther7",WZUILabelTTF):setText(LocalStrings.CHECKOTHER7)
	--tag 1:武器，2：项链，3：戒指，4：手镯，5：宝物，6：勋章
	local iconList = {"ui/bag/common_icon_wuqi.png","ui/bag/common_icon_xianglian.png","ui/bag/common_icon_jiezhi.png",
			"ui/bag/common_icon_shouzhuo.png","ui/bag/common_icon_baowu.png","ui/bag/common_icon_xunzhang.png",
			"ui/bag/common_icon_erhuan.png","ui/bag/common_icon_fushou.png","ui/bag/common_icon_xunzhang.png",}
	--设置底图
	for i=1,8 do
		local emptyIcon = GetElement(self.m_root,"blank"..i,WZUIImage)
		emptyIcon:setFile(iconList[i])
		emptyIcon:setVisible(true)
	end
	self.m_nType = 1
	self.m_tDataList = {}
	local itemSuitNum = WndCheckOther.m_tPlayerInfo.itemSuitNum
	local itemSuitId = WndCheckOther.m_tPlayerInfo.itemSuitId
	for i=1,#tEquip do
		for j=1,8 do
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
-------------------------------------私有方法模块End----------------------------------------

function CellCheckOther7:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtTitle_CellCheckOther7",WZUILabelTTF):setScale(0.7)
end

function CellCheckOther7:_adaptLanguage_tr(  )
	local txtTitle = GetElement(self.m_root,"txtTitle_CellCheckOther7",WZUILabelTTF)
	txtTitle:setRelativePosition(GlobalMethod:ccp(0.01,0.8))
end