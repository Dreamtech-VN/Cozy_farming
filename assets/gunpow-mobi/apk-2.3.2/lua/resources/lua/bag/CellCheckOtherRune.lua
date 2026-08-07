--CellCheckOtherRune.lua
--@brief	CellCheckOtherRune的UI模块
--@date		2018/01/23
--@author	zsq
--@note		符文信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCheckOtherRune:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOtherRune:onExit(element)
	self:_unInit()
end

function CellCheckOtherRune:setData(tData, sTitle, typeNum)
	self.m_tDataList = tData
	self.m_sTitle = sTitle 
	self.m_type = typeNum
	self.m_nRowNum = math.ceil(#tData/6) 
	self:update()
end

function CellCheckOtherRune:onClick(element)
	WZLog("CellCheckOtherRune:onClick", element:getTag())
	local tag = element:getTag()
	local tData = {}
	if self.m_tDataList[tag] == nil then return end 
	local tItem = {}
	if self.m_type == 1 then
		tItem = GDatatab_item["id_"..GDatatab_spirit["id_"..self.m_tDataList[tag].item_id].item_id]
	else 
		tItem = GDatatab_item["id_"..self.m_tDataList[tag].item_id]
	end
	tData.icon = tItem.icon
	tData.name = tItem.name
	local property = tItem.property
	if self.m_type == 1 then
		property = GDatatab_spirit["id_"..self.m_tDataList[tag].item_id].property
		tData.name = "Lv".." "..GDatatab_spirit["id_"..self.m_tDataList[tag].item_id].level..tItem.name
		if type(property) == "number" then 
			tData.winType = 1
			tData.property = property
		end
	end
	for i=1,3 do
		if type(property) == "table" and property[i] ~= nil then
			tData["attr"..i] = property[i][1]
			tData["attrTitle"..i] = ATTR_TITLE[property[i][1]]
			tData["attrVal"..i] = property[i][2]
		end
	end

	WndTips:show(element,WndCheckOther.m_root,47,tData,GlobalMethod:ccp(0,0), true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellCheckOtherRune:update()
	local qualityPic = {"ui/common/common_scale9_lv.png",
					"ui/common/common_scale9_lan.png",
					"ui/common/common_scale9_zi.png",
					"ui/common/common_scale9_cheng.png",
					"ui/common/common_scale9_lv.png"}

	-- for j=1,6 do
 --    	local cell = self.m_root
	-- 	GetElement(cell,"num"..j,WZUILabelTTF):setText("")

	-- 	local index = j
	-- 	if self.m_tDataList[index] ~= nil then
	-- 		local tData = GDatatab_item["id_"..self.m_tDataList[index].item_id]
	-- 		GetElement(cell,"black"..j,WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
	-- 		GetElement(cell,"quality"..j,WZUI9Image):setFile(qualityPic[tData.quality])
	-- 		GetElement(cell,"num"..j,WZUILabelTTF):setText("x"..self.m_tDataList[index].item_num)
	-- 		GetElement(cell,"icon"..j,WZUIImage):setFile(tData.icon)
	-- 		GetElement(cell,"icon"..j.."Sel",WZUIImage):setFile(tData.icon)
	-- 		local btn = GetElement(cell,"btn"..j,WZUIButton)
	-- 		btn:setTouchEnable(true)
	-- 	end
	-- end
	local conIcon = GetElement(self.m_root,"conIcon_CellCheckOtherRune",WZUIContainer)
	local element = nil
	for i=1,#self.m_tDataList do
		local tempRow = math.floor((i-1)/6)
		local tempNum = (i-1)%6+1
		if tempNum == 1 then
			element = WZUIContainer:luaTo(WZUISystem:getInstance():createElement("cellTemplate_CellCheckOtherRune"))
			conIcon:addChild(element)
			element:setVisible(true)
			element:setRelativePosition(GlobalMethod:ccp(0.545,0.5-0.8*tempRow))

			for j = 1, 6 do
				GetElement(element,"btn"..j,WZUIButton):setTouchEnable(false)
				GetElement(element,"num"..j,WZUILabelTTF):setText("")
			end
		end
		if element then
			local tData = {}
			if self.m_type == 1 then 
				local item_id = GDatatab_spirit["id_"..self.m_tDataList[i].item_id].item_id
				GetElement(element,"icon"..tempNum,WZUIImage):setFile(GDatatab_spirit["id_"..self.m_tDataList[i].item_id].icon)
				GetElement(element,"icon"..tempNum.."Sel",WZUIImage):setFile(GDatatab_spirit["id_"..self.m_tDataList[i].item_id].icon)
				GetElement(element,"quality"..tempNum,WZUI9Image):setFile(qualityPic[GDatatab_spirit["id_"..self.m_tDataList[i].item_id].quality])
				local lv =  GetElement(element,"lv"..tempNum,WZUILabelTTF)
				lv:setVisible(true)
				lv:setText("Lv"..GDatatab_spirit["id_"..self.m_tDataList[i].item_id].level)
			else 
				tData = GDatatab_item["id_"..self.m_tDataList[i].item_id]
				GetElement(element,"icon"..tempNum,WZUIImage):setFile(tData.icon)
				GetElement(element,"icon"..tempNum.."Sel",WZUIImage):setFile(tData.icon)
				GetElement(element,"quality"..tempNum,WZUI9Image):setFile(qualityPic[tData.quality])
			end
			-- GetElement(element,"black"..tempNum,WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
			
			GetElement(element,"num"..tempNum,WZUILabelTTF):setText("x"..self.m_tDataList[i].item_num)
			local btn = GetElement(element,"btn"..tempNum,WZUIButton)
			btn:setTouchEnable(true)
			btn:setTag(i)
		end
	end


	self:addTitle()
end

function CellCheckOtherRune:onClickTips(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = {}
	if self.m_type == 1 then --元魂
		tData = {id = 68}
		WndTips:show(element,WndCheckOther.m_root,67,tData,GlobalMethod:ccp(220,30),true,false)
	end
	if self.m_type == 0 then --符文
		tData = {id = 69}
		WndTips:show(element,WndCheckOther.m_root,67,tData,GlobalMethod:ccp(220,30),true,false)
	end
end

--@brief 	标题
function CellCheckOtherRune:addTitle()
	-- body
	if self.m_sTitle == nil then return end 
	if self.m_root == nil then return end 

	-- local conForTitle = GetElement(self.m_root, "conForTitle_CellCheckOtherRune", WZUIContainer)
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
	self.m_root:setAbsContentSize(GlobalMethod:CCSize(nBgWidth, nBgBaseHeight+(self.m_nRowNum-1)*nBgInterval))
	self.m_root:updateRelativeSize()
	local conNewBg = GetElement(self.m_root, "conNewBg_CellCheckOtherRune", WZUIContainer)
	conNewBg:setAbsContentSize(GlobalMethod:CCSize(nBgWidth, nBgBaseHeight+(self.m_nRowNum-1)*nBgInterval))
	conNewBg:updateRelativeSize()
	local conSplitLine = GetElement(self.m_root, "conSplitLine_CellCheckOtherRune", WZUIContainer)
	conSplitLine:setAbsContentSize(GlobalMethod:CCSize(nSlWidth, nSlBaseHeight+(self.m_nRowNum-1)*nSlInterval))
	conSplitLine:updateRelativeSize()
	GetElement(self.m_root, "txtTitle_CellCheckOtherRune", WZUILabelTTF):setText(self.m_sTitle)
end


-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------

function CellCheckOtherRune:_adaptLanguage_vn(  )
	local txtTitle = GetElement(self.m_root, "txtTitle_CellCheckOtherRune", WZUILabelTTF)
	if txtTitle then
		txtTitle:setScale(0.6)
		txtTitle:setDimensions(GlobalMethod:CCSize(60))
	end
end

-------------------------------------语言适配End----------------------------------------