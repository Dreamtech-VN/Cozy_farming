--CellDesignationOne.lua
--@brief	CellDesignationOne的UI模块
--@date		2015/03/26
--@author	clc
--@note		成就系统-成就面板-主分类cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDesignationOne:onEnter(element)
	self.m_root = element
	self.n_CellType = 1
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDesignationOne:onExit(element)
	self:_unInit()
end


function CellDesignationOne:onClickCell()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndDesignationMain:onClickMainCellForAchie( self.n_JobId , self.n_CellPos, self)
end

--@brief  设置主分类成就Cell的UI
--@param  title:成就主分类名字
--@param  DoneNum:成就主分类子成就已完成数
--@param  allNum:成就主分类子成就总数
function CellDesignationOne:setCellUI(title , DoneNum , allNum)
    WZLog("CellDesignationOne:setCellUI", title , DoneNum , allNum)
	-- body
	self.m_sName = title
	self.m_nDoneNum = DoneNum
	self.m_nAllNum = allNum
end

--@brief  设置是否cell显示红点
function CellDesignationOne:showAperture( vBool )
	-- body
	self.m_bIsRedDotVisible = vBool
	if self.m_bIsLoad == false then return end
	GetElement(self.m_root , "aperture_Image",WZUIImage):setVisible(vBool)
end


--@brief    设置主分类成就Id
function CellDesignationOne:setJobId( nJobId )
    self.n_JobId = nJobId
end

--@brief 	设置选中状态
function CellDesignationOne:setLightVisible(bBool)
	-- body
	self.m_bIsSelected = bBool or false
	if self.m_bIsLoad == false then return end
	GetElement(self.m_root, "imgLightSel_CellDesignationOne", WZUI9Image):setVisible(bBool)
end

--@brief    获得主分类成就Id
function CellDesignationOne:getJobId()
    return  self.n_JobId
end

--@brief    保留此cell在FreeListContainer的位置
function CellDesignationOne:setCellPos( nPos )
    self.n_CellPos  = nPos
end

--@brief    获得此cell在FreeListContainer的位置
function CellDesignationOne:getCellPos()
    return self.n_CellPos
end

--@brief    获得此cell的类型
function CellDesignationOne:getCellType()
	-- body
	return self.n_CellType
end

--@brief	加载cell中的内容
function CellDesignationOne:onLoadData(element)
	-- body
	local cellElement = WZUISystem:getInstance():createElement("CellDesignationOne")
	self.m_root:addChild(cellElement)

	self.m_bIsLoad = true
	self:_update(self.m_sName, self.m_nDoneNum, self.m_nAllNum)
	AdaptLanguage(self)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	节点信息刷新
function CellDesignationOne:_update(title , DoneNum , allNum)
	-- body
	if self.m_root == nil then return end 

	local  title_Label       = GetElement(self.m_root, "title_Label", WZUILabelTTF)
	local  progress_Main_Progress = GetElement(self.m_root,"proMainProgress_CellDesignationOne",WZUIProgress)
	local  imgProBk = GetElement(self.m_root, "imgProBk_CellDesignationOne", WZUIImage)
	if DoneNum == 0 then
		imgProBk:setOpacity(76)
	else
		imgProBk:setOpacity(204)
	end

	title_Label:setText(title) 
	progress_Main_Progress:setPercentage(100 * DoneNum / allNum)

	--设置选中状态
	self:setLightVisible(self.m_bIsSelected)
	--设置红点状态
	self:showAperture(self.m_bIsRedDotVisible)
end




-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin------------------------------------------
function CellDesignationOne:_adaptLanguage_pt(  )
	local title = GetElement(self.m_root,"title_Label",WZUILabelTTF)
	title:setFontSize(16)
	title:setDimensions(GlobalMethod:CCSize(170,0))
end

function CellDesignationOne:_adaptLanguage_es(  )
	local title = GetElement(self.m_root,"title_Label",WZUILabelTTF)
	title:setFontSize(16)
	title:setDimensions(GlobalMethod:CCSize(170,0))
end

function CellDesignationOne:_adaptLanguage_en(  )
	local title = GetElement(self.m_root,"title_Label",WZUILabelTTF)
	title:setFontSize(16)
	title:setDimensions(GlobalMethod:CCSize(170,0))
end

function CellDesignationOne:_adaptLanguage_vn(  )
	local title = GetElement(self.m_root,"title_Label",WZUILabelTTF)
	title:setFontSize(16)
	title:setDimensions(GlobalMethod:CCSize(170,0))
end

function CellDesignationOne:_adaptLanguage_tr(  )
	local title = GetElement(self.m_root,"title_Label",WZUILabelTTF)
	title:setFontSize(16)
	title:setDimensions(GlobalMethod:CCSize(170,0))
end
---------------------------------------语言适配End--------------------------------------------