--WndFamilyShop.lua
--@brief	WndFamilyShop的UI模块
--@date		2017/08/01
--@author	zsq
--@note		家园商店


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFamilyShop:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)

	local isEndTeach, finishStep = TeachGroup1:isTeachFinish(45)
    if isEndTeach ~= true and TeachGroup1:isTeach() then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999, 0 )
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFamilyShop:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndFamilyShop:onEnterTransitionDidFinish(element)
    -- body
	self.m_nTag = 1
    ProtocolProcessorFamily:send_HOME_GetStore()
end

function WndFamilyShop:onCloseClick() 
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WndFamilyOperate.m_bIsClickFunc = false
    WindowManager:removeWindow(self.m_root, self, true)
end

function WndFamilyShop:onCheck(element) 
	WZLog("WndFamilyShop:onCheck",element:getTag())
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	local tag = tonumber(element:getTag())
	self.m_nTag = tag
	self:_update()

	if tag == 1 then
		GetElement(self.m_root,"imgTab1_WndExtraction",WZUI9Image):setVisible(true)
		GetElement(self.m_root,"txtTab1_WndExtraction",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txtTab1Sel_WndExtraction",WZUILabelTTF):setVisible(true)

		GetElement(self.m_root,"imgTab2_WndExtraction",WZUI9Image):setVisible(false)
		GetElement(self.m_root,"txtTab2_WndExtraction",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txtTab2Sel_WndExtraction",WZUILabelTTF):setVisible(false)
	elseif tag == 2 then
		GetElement(self.m_root,"imgTab1_WndExtraction",WZUI9Image):setVisible(false)
		GetElement(self.m_root,"txtTab1_WndExtraction",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txtTab1Sel_WndExtraction",WZUILabelTTF):setVisible(false)

		GetElement(self.m_root,"imgTab2_WndExtraction",WZUI9Image):setVisible(true)
		GetElement(self.m_root,"txtTab2_WndExtraction",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txtTab2Sel_WndExtraction",WZUILabelTTF):setVisible(true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFamilyShop:_update() 
	if self.m_root == nil then return end
	local tbCon = GetElement(self.m_root,"tableCon_WndFamilyShop",WZUITableContainer)
	tbCon:cleanTable()

	--没有数据时显示提示
	if self.m_tDataList == nil or #self.m_tDataList == 0 then 
		ShowPanelNullTip(tbCon,nil,GlobalMethod:ccc3(255,236,193))
	else
		removeShowPanelNullTip(tbCon)
	end

	local index = 0
	for i=1,#self.m_tDataList do
		local tData = GDatatab_home_building["id_"..self.m_tDataList[i].configId]

		local showBuild = false
		if self.m_nTag == 1 then
			if tData.type == 0 or tData.type == 1 then
				showBuild = true
			end
		elseif self.m_nTag == 2 then
			if tData.type == 2 then
				showBuild = true
			end
		end
		if showBuild then
			local celElement,tCell = CellFamilyShop:createElement()
			if celElement ~= nil and tCell ~= nil then 
				celElement = WZUIContainer:luaTo(celElement)
				tCell:setData(self.m_tDataList[i])
				celElement:setTag(index)
				tbCon:setCellElement(celElement)
				tbCon:getMoveElement():setPositionY(tbCon:getMinPosition().y)
				index = index + 1
			end 
		end
	end

	local isEndTeach, finishStep = TeachGroup1:isTeachFinish(45)
	WZLog("WndFamilyShop:_update one", finishStep)
	if isEndTeach ~= true then
        local buildingCK = SceneFamily:getBuildingCellById(40300)
        local buildingSS = SceneFamily:getBuildingCellById(40100)
        WZLog("WndFamilyShop:_update two", tostring(buildingCK), tostring(buildingSS))
        if buildingCK == nil then
            TeachGroup1:startGroup({45,2,self.m_root})
        elseif buildingCK and buildingSS == nil then
            TeachGroup1:endTeachStep({45,3})
            TeachGroup1:startGroup({45,5,self.m_root})
        else
        	TeachGroup1:removeTeach()
        end
    end
    -- if isEndTeach ~= true and finishStep < 3 then
    --     TeachGroup1:startGroup({45,2,self.m_root})
    -- elseif isEndTeach ~= true and finishStep >= 3 then
    -- 	TeachGroup1:startGroup({45,5,self.m_root})
    -- end
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndFamilyShop:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtTab1_WndExtraction",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtTab1Sel_WndExtraction",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtTab2_WndExtraction",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtTab2Sel_WndExtraction",WZUILabelTTF):setScale(0.7)
end

function WndFamilyShop:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtTab1_WndExtraction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab1Sel_WndExtraction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab2_WndExtraction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab2Sel_WndExtraction",WZUILabelTTF):setScale(0.8)
end

function WndFamilyShop:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtTab1_WndExtraction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab1Sel_WndExtraction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab2_WndExtraction",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtTab2Sel_WndExtraction",WZUILabelTTF):setScale(0.6)
end

function WndFamilyShop:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtTab2_WndExtraction",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtTab2Sel_WndExtraction",WZUILabelTTF):setScale(0.6)
end

function WndFamilyShop:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtTab1_WndExtraction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab1Sel_WndExtraction",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTab2_WndExtraction",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtTab2Sel_WndExtraction",WZUILabelTTF):setScale(0.6)
end
--------------------------------语言适配End--------------------------------------------------