--CellDesignationThree.lua
--@brief	CellDesignationThree的UI模块
--@date		2015/03/27
--@author	clc
--@note		成就系统-称号面板-称号cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDesignationThree:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDesignationThree:onExit(element)
	self:_unInit()
end


--@brief   点击本cell回调函数
function CellDesignationThree:onClickCell( element)
	WZLog("CellDesignationThree:onClickCell", self.m_tData.nStatus)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData.nStatus == 0 then
	--	MsgBoxManager:showTipBox(LocalStrings.NOTDESIGNAME)
	else
		local  nTag  = self.m_root:getTag()
		WndDesignationMain:onClickDesignation( nTag)
	end
end

--@brief    初始化cell数据
--@param    称号分类、称号ID、称号名称、剩余天数、称号状态
function CellDesignationThree:setCellUI( nType , nId , nDesignation , nRemain , nStatus)
	-- body
	WZLog("setCellUI",nDesignation  , nRemain , nStatus)
	if self.m_tData == nil then
		self.m_tData = {}
	end

	self.m_tData.nType = nType
	self.m_tData.nId = nId
	self.m_tData.nDesignation = nDesignation
	self.m_tData.nRemain = nRemain
	self.m_tData.nStatus = nStatus
end

--@brief 	根据状态设置红点是否可见
--@brief 	status称号的状态：0：不可用；1：可用；2：在使用；3：新增
function CellDesignationThree:setRedPointVisible(status)
	-- body 
	self.m_tData.nStatus = status
	if self.m_bIsLoad == false then return end

	if status == 3 then
		GetElement(self.m_root, "imgRedPoint_CellDesignationThree", WZUIImage):setVisible(true)
	else
		GetElement(self.m_root, "imgRedPoint_CellDesignationThree", WZUIImage):setVisible(false)
	end
end

--@brief 	点击设置是否勾选
function CellDesignationThree:setClicked( bValue )
	-- body
	self.m_bGouVisible = bValue
	if self.m_bIsLoad == false then return end

	local  selected_Image   = GetElement(self.m_root , "selected_Image", WZUIImage)
	local  selectedGou_Image = GetElement(self.m_root, "selectedGou_Image", WZUIImage)
	if bValue == false then
		selected_Image:setVisible(false)
		selectedGou_Image:setVisible(false)
	else
		selected_Image:setVisible(true)
		selectedGou_Image:setVisible(true)
	end
end

--@brief 	加载节点数据
function CellDesignationThree:onLoadData(element)
	-- body
	local cellElement = WZUISystem:getInstance():createElement("CellDesignationThree")
	self.m_root:addChild(cellElement)

	self.m_bIsLoad = true
	self:_update(self.m_tData.nType, self.m_tData.nId, self.m_tData.nDesignation, self.m_tData.nRemain, self.m_tData.nStatus)
	AdaptLanguage(self)
end

--@brief 	获取是否有红点
function CellDesignationThree:getRedDotState()
	-- body
	if self.m_tData.nStatus == 3 then
		return true
	else
		return false
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	更新节点数据信息
function CellDesignationThree:_update(nType , nId , nDesignation , nRemain , nStatus)
	-- body
	if self.m_root == nil then
		return
	end
    if nStatus > 10 or nStatus < 0 then  nStatus = 0 end
    WZLog("name,status:",nDesignation,nStatus)
	self.nDesignationId = nId
	self.nType          = nType
	self.nStatus = status


	local  title_Label             = GetElement(self.m_root, "title_Label" , WZUILabelTTF)  --称号类型
	local  descrition1_Label       = GetElement(self.m_root, "descrition1_Label" , WZUILabelTTF)--称号不可使用描述
	local  notSelect_Image         = GetElement(self.m_root, "notSelect_Image", WZUIImage)--选中框
	local  selected_Image          = GetElement(self.m_root, "selected_Image", WZUIImage)--选中标志
	local  noDesignation_Container = GetElement(self.m_root, "noDesignation_Container" , WZUIContainer)--未获得容器
	local  designation_Container   = GetElement(self.m_root, "designation_Container" , WZUIContainer)--获得容器
	local  txtFreeBox_Descrition   = GetElement(self.m_root, "txtFreeDescrition_CellDesignationThree", WZUIFreeTextBox)
    --称号类型
	if nType == 1 then
		title_Label:setText(LocalStrings.DESIGNATION_SPECIAL)
	elseif nType == 2 then
		title_Label:setText(LocalStrings.DESIGNATION_ACTIVITY)
	elseif nType == 3 then
		title_Label:setText(LocalStrings.DESIGNATION_ASSOCITION)
	elseif nType == 4 then
		title_Label:setText(LocalStrings.DESIGNATION_SHIP)
	elseif nType == 5 then
		title_Label:setText(LocalStrings.DESIGNATION_ACHIE)
	elseif nType == 6 then
		title_Label:setText(LocalStrings.MASTER_DESIGNATION)
	end

	--红点
	if nStatus == 3 then
		GetElement(self.m_root, "imgRedPoint_CellDesignationThree", WZUIImage):setVisible(true)
	else
		GetElement(self.m_root, "imgRedPoint_CellDesignationThree", WZUIImage):setVisible(false)
	end

	if  nStatus == 0 then
		noDesignation_Container:setVisible(true)
		designation_Container:setVisible(false)
		local tDesiData = GDatatab_achievement["id_"..self.nDesignationId]
        --称号描述
		descrition1_Label:setText(tDesiData.desc)
		--隐藏复选框
		GetElement(self.m_root, "conKuang_CellDesignationThree", WZUIContainer):setVisible(false)
	else
		GetElement(self.m_root, "conKuang_CellDesignationThree", WZUIContainer):setVisible(true)
		noDesignation_Container:setVisible(false)
		designation_Container:setVisible(true)
		--称号描述
        local sTitleName = SplitStringWithSeparator(nDesignation,"&")
        local sNewTitle, nLetterNum = string.gsub(nDesignation, "&", ",")
        local sContentTitle = ""
        if sTitleName[2] == nil or sTitleName[2] == "" then
        	sContentTitle = nDesignation
        else
        	if tonumber(sTitleName[2]) == nil or nLetterNum > 2 then
        		sContentTitle = nDesignation
        	else
	        	local bExist = WZFileUtil:isFileExist(string.format(g_sTitleSpineName, sTitleName[2]) .. ".json")
	        	if not bExist then
	        		sContentTitle = nDesignation
	        	else
	        		sContentTitle = sTitleName[1]
	        	end
	        end
        end
        local sDesignation = "【"..string.gsub(sContentTitle, "&", "＆").."】"

		local tDesiData = GDatatab_achievement["id_"..self.nDesignationId]
		if tDesiData and tDesiData.p_id ~= -1 then
			nDesignation =  tDesiData.name 
		end

        local sTitleName = SplitStringWithSeparator(nDesignation,"&")
        local sNewTitle, nLetterNum = string.gsub(nDesignation, "&", ",")
        local sContentTitle = ""
        if sTitleName[2] == nil or sTitleName[2] == "" then
        	sContentTitle = nDesignation
        else
        	if tonumber(sTitleName[2]) == nil or nLetterNum > 2 then
        		sContentTitle = nDesignation
        	else
	        	local bExist = WZFileUtil:isFileExist(string.format(g_sTitleSpineName, sTitleName[2]) .. ".json")
	        	if not bExist then
	        		sContentTitle = nDesignation
	        	else
	        		sContentTitle = sTitleName[1]
	        	end
	        end
        end
        local sDesignation = "【"..string.gsub(sContentTitle, "&", "＆").."】"
        --剩余时间
        local sRemainDay = nil
		if nRemain > 0 then
			sRemainDay = "("..nRemain..LocalStrings.DAY..")"
		else
			sRemainDay = ""
		end
		local sTxtFormat = [[<T S="24" C="128,54,13">%s</T><T S="22" C="158,0,0">%s</T>]]
		local sDescrition = string.format(sTxtFormat, sDesignation, sRemainDay)
		txtFreeBox_Descrition:setShowText(sDescrition)
	end

	self:setClicked(self.m_bGouVisible)
	if self.nStatus then
		self:setRedPointVisible(self.nStatus)
	end
end



-------------------------------------私有方法模块End----------------------------------------
------------------------------------语言适配Begin---------------------------------------
function CellDesignationThree:_adaptLanguage_pt(  )
	GetElement(self.m_root,"title_Label",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"descrition1_Label",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtFreeDescrition_CellDesignationThree",WZUIFreeTextBox):setMaxWidth(500)
end

function CellDesignationThree:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtFreeDescrition_CellDesignationThree",WZUIFreeTextBox):setMaxWidth(500)
end

function CellDesignationThree:_adaptLanguage_es(  )
	local title = GetElement(self.m_root,"title_Label",WZUILabelTTF)
	title:setFontSize(18)
	title:setDimensions(GlobalMethod:CCSize(180,0))

	local descrition = GetElement(self.m_root,"descrition1_Label",WZUILabelTTF)
	descrition:setFontSize(20)
	descrition:setDimensions(GlobalMethod:CCSize(470,0))

	GetElement(self.m_root,"txtFreeDescrition_CellDesignationThree",WZUIFreeTextBox):setMaxWidth(500)
end

function CellDesignationThree:_adaptLanguage_en(  )
	GetElement(self.m_root,"descrition1_Label",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(520))
end

function CellDesignationThree:_adaptLanguage_tr(  )
	GetElement(self.m_root,"descrition1_Label",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(520))
end

function CellDesignationThree:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtFreeDescrition_CellDesignationThree",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.1,0.5))
end
------------------------------------语言适配End----------------------------------------