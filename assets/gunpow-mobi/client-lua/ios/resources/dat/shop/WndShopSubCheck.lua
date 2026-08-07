--WndShopSubCheck.lua
--@brief	WndShopSubCheck的UI模块
--@date		2017/09/01
--@author	zsq
--@note		商城子栏


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndShopSubCheck:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndShopSubCheck:onExit(element)
	self:_unInit()
end

function WndShopSubCheck:onCheck(element) 
	WZLog("WndShopSubCheck:onCheck", element:getTag())
	if WndShop.m_root == nil then return end
	local checkLists = {"","onTopDressTitle","onTopPropTitle","onTopLimitTitle","onTop5Title","onTopGiveTitle","onCheck7","onTop8Title"}
	local index = WndShop.leftIndex
	WndShop[checkLists[index]](WndShop, element)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndShopSubCheck:_update() 
	if WndShop.m_root == nil then return end
	local tPositionY = {1, 0.8333, 0.667, 0.5, 0.3333, 0.16666, 0}
	local tFuncId = {7, 131, 27, 80, 7, 7, 120} --和道具标签中出售的功能模块的功能Id
	local tSortFuncIndex = {1, 5, 3, 2, 7, 4, 6} --功能的排序索引
	local allTitle = {{},
		{LocalStrings.CHAT_ALL,LocalStrings.HEAD,LocalStrings.FACE,LocalStrings.BODY,LocalStrings.WING,LocalStrings.SUIT},
		{LocalStrings.ITEM8,LocalStrings.FAMILY_TEXT85,LocalStrings.PHANTOM27,LocalStrings.ASCENDING9,LocalStrings.SKILL_TXT,LocalStrings.OTHERS,LocalStrings.WAKEUP_TEXT5},
		{LocalStrings.TASK_MEIRI,LocalStrings.NEW_SHOP_9},
		{LocalStrings.NEWSHOP24,"",LocalStrings.NEWSHOP23,LocalStrings.SHOP_NEWCOIN},
		{LocalStrings.HEAD,LocalStrings.FACE,LocalStrings.BODY,LocalStrings.WING,LocalStrings.SUIT,LocalStrings.BAG1},
		{"",LocalStrings.NEWSHOP9,LocalStrings.LUCKY_GIFT},
		{LocalStrings.NEWSHOP81,LocalStrings.NEWSHOP82,LocalStrings.NEWSHOP83,LocalStrings.NEWSHOP84,LocalStrings.NEWSHOP85,LocalStrings.NEWSHOP86,LocalStrings.NEWSHOP87},
	}
	local titles = allTitle[WndShop.leftIndex]
	if titles == nil then return end
	if WndShop.leftIndex == 1 then
		self.m_root:setVisible(false)
	else
		self.m_root:setVisible(true)
	end
	if WndShop.leftIndex == 3 then
		GetElement(self.m_root,"tab2_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.5))
		GetElement(self.m_root,"tab5_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.8333))
		GetElement(self.m_root,"tab4_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.16666))
		GetElement(self.m_root,"tab6_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0))
		GetElement(self.m_root,"tab7_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.3333))
	else
		GetElement(self.m_root,"tab2_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.8333))
		GetElement(self.m_root,"tab5_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.3333))
		GetElement(self.m_root,"tab4_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.5))
		
		GetElement(self.m_root,"tab6_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.16666))
		GetElement(self.m_root,"tab7_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0))
	end
	if WndShop.leftIndex == 5 then
		GetElement(self.m_root,"tab3_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.83333))
	else
		GetElement(self.m_root,"tab3_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.66667))
	end
	if WndShop.leftIndex == 7 then
		GetElement(self.m_root,"tab2_WndShop",WZUICheckBox):setRelativePosition(ccp(0,1))
		GetElement(self.m_root,"tab3_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.8333))
	else
		GetElement(self.m_root,"tab2_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.8333))
		GetElement(self.m_root,"tab3_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.66667))
	end
	if WndShop.leftIndex == 5 then
		GetElement(self.m_root,"tab3_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.83333))
		GetElement(self.m_root,"tab4_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.66667))
	end
	if WndShop.leftIndex == 3 then
		GetElement(self.m_root,"tab2_WndShop",WZUICheckBox):setRelativePosition(ccp(0,0.5))
	end

	for i=1,7 do
		GetElement(self.m_root,"tab"..i.."_WndShop",WZUICheckBox):setVisible(false)
	end
	if WndShop.leftIndex == 3 then
		for i=1, #titles do
			if titles[i] ~= "" then
				GetElement(self.m_root,"txt"..i,WZUILabelTTF):setText(titles[i])
				GetElement(self.m_root,"txt"..i.."_sel",WZUILabelTTF):setText(titles[i])
			end
		end

		local nTotalNum = 1
		for i = 1, #tSortFuncIndex do
			local nIndex = tSortFuncIndex[i]
			if CheckButtonOpen(tFuncId[nIndex], false) then
				local tab = GetElement(self.m_root,"tab"..nIndex.."_WndShop",WZUICheckBox)
				tab:setVisible(true)
				tab:setRelativePosition(GlobalMethod:ccp(0, tPositionY[nTotalNum]))

				nTotalNum = nTotalNum + 1
			end
		end
	else
		for i=1,#titles do
			if titles[i] ~= "" then
			GetElement(self.m_root,"tab"..i.."_WndShop",WZUICheckBox):setVisible(true)
			GetElement(self.m_root,"txt"..i,WZUILabelTTF):setText(titles[i])
			GetElement(self.m_root,"txt"..i.."_sel",WZUILabelTTF):setText(titles[i])
			end
		end
	end

end




-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function WndShopSubCheck:_adaptLanguage_vn(  )
	for i = 1, 7 do
		local txt1 = GetElement(self.m_root,"txt" .. i, WZUILabelTTF)
		local txt2 = GetElement(self.m_root,"txt" .. i .."_sel", WZUILabelTTF)
		txt1:setScale(0.65)
		txt1:setDimensions(GlobalMethod:CCSize(110))
		txt2:setScale(0.65)
		txt2:setDimensions(GlobalMethod:CCSize(110))
	end
end

function WndShopSubCheck:_adaptLanguage_th(  )
	for i = 1, 7 do
		local txt1 = GetElement(self.m_root,"txt" .. i, WZUILabelTTF)
		local txt2 = GetElement(self.m_root,"txt" .. i .."_sel", WZUILabelTTF)
		txt1:setScale(0.65)
		txt1:setDimensions(GlobalMethod:CCSize(110))
		txt2:setScale(0.65)
		txt2:setDimensions(GlobalMethod:CCSize(110))
	end
end

function WndShopSubCheck:_adaptLanguage_en(  )
	for i = 1, 7 do
		local txt1 = GetElement(self.m_root,"txt" .. i, WZUILabelTTF)
		local txt2 = GetElement(self.m_root,"txt" .. i .."_sel", WZUILabelTTF)
		txt1:setScale(0.65)
		txt1:setDimensions(GlobalMethod:CCSize(110))
		txt2:setScale(0.65)
		txt2:setDimensions(GlobalMethod:CCSize(110))
	end
end

function WndShopSubCheck:_adaptLanguage_hk(  )
	for i = 1, 7 do
		local txt1 = GetElement(self.m_root,"txt" .. i, WZUILabelTTF)
		local txt2 = GetElement(self.m_root,"txt" .. i .."_sel", WZUILabelTTF)
		txt1:setScale(0.9)
		txt1:setDimensions(GlobalMethod:CCSize(60))
		txt2:setScale(0.9)
		txt2:setDimensions(GlobalMethod:CCSize(60))
	end
end

function WndShopSubCheck:_adaptLanguage_pt(  )
	for i = 1, 7 do
		local txt1 = GetElement(self.m_root,"txt" .. i, WZUILabelTTF)
		local txt2 = GetElement(self.m_root,"txt" .. i .."_sel", WZUILabelTTF)
		txt1:setScale(0.65)
		txt1:setDimensions(GlobalMethod:CCSize(110))
		txt2:setScale(0.65)
		txt2:setDimensions(GlobalMethod:CCSize(110))
	end
end

function WndShopSubCheck:_adaptLanguage_es(  )
	for i = 1, 7 do
		local txt1 = GetElement(self.m_root,"txt" .. i, WZUILabelTTF)
		local txt2 = GetElement(self.m_root,"txt" .. i .."_sel", WZUILabelTTF)
		txt1:setScale(0.65)
		txt1:setDimensions(GlobalMethod:CCSize(110))
		txt2:setScale(0.65)
		txt2:setDimensions(GlobalMethod:CCSize(110))
	end
end

function WndShopSubCheck:_adaptLanguage_tr(  )
	for i = 1, 7 do
		local txt1 = GetElement(self.m_root,"txt" .. i, WZUILabelTTF)
		local txt2 = GetElement(self.m_root,"txt" .. i .."_sel", WZUILabelTTF)
		txt1:setScale(0.65)
		txt1:setDimensions(GlobalMethod:CCSize(110))
		txt2:setScale(0.65)
		txt2:setDimensions(GlobalMethod:CCSize(110))
	end
end

--------------------------------------语言适配End-----------------------------------------