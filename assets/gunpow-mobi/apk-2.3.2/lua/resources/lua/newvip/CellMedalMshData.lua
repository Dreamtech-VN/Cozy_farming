--CellMedalMshData.lua
--@brief	CellMedalMsh的数据模块
--@date		2021/04/08
--@author	hyx
--@note		徽章描述

CellMedalMsh = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellMedalMsh:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tCurMedalData = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMedalMsh:_unInit()
	self.m_root = nil
	self.m_tCurMedalData = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellMedalMsh:createElement()
	if CellMedalMsh.m_root ~= nil then
		WindowManager:removeWindow(CellMedalMsh.m_root, CellMedalMsh, true)
	end
	local element = WZUISystem:getInstance():createElement("CellMedalMsh")
	assert(element, "CellMedalMsh create element failed!")
	self:_init()
	
	return element
end

function CellMedalMsh:setMedalItemType(_type, title, subtitle)
	self.m_nType = _type
	self.m_sTitle = title
	self.m_sSubsubtitle = subtitle
end

function CellMedalMsh:setCurMedalProgress(medalStageIds, medalStageStatus, medalStageProgress, medalStageTargets)
	for i=1,#medalStageIds do
		local tab = {}
		tab.id = medalStageIds[i]
		tab.status = medalStageStatus[i]
		tab.progress = tonumber(medalStageProgress[i])
		tab.target = tonumber(medalStageTargets[i])
		table.insert(self.m_tCurMedalData, tab) 
	end
	table.sort( self.m_tCurMedalData, function(a,b) return a.id < b.id end)
end
--===============================
MedalMsgItem = {}
function MedalMsgItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function MedalMsgItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function MedalMsgItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(286,369))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function MedalMsgItem:setData(data, index, num)
	self.m_nData = data
	self.m_nIndex = index
	self.m_nNum = num
end
--@brief 	开始加载
function MedalMsgItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("medalMsgItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setCurMedalItem()

	AdaptLanguage(self)
end

function MedalMsgItem:setCurMedalItem()
	if not self.m_nData then return end

	local data = self.m_nData
	local info = GDatatab_vip_medal_stage["id_"..data.id]
	if not info then return end

	if self.m_nIndex >= self.m_nNum then
		GetElement(self.m_root,"img_arrow",WZUIImage):setVisible(false)
	end
	GetElement(self.m_root,"txtMedalScore",WZUILabelTTF):setVisible(data.status == -1)
	GetElement(self.m_root,"get_con",WZUIContainer):setVisible(data.status == 1)

	local img_icom = GetElement(self.m_root,"icom",WZUIImage)
	local str_icon = info.icon
	local bExist = WZFileUtil:isFileExist(str_icon)
	if not bExist then
		str_icon = "shopitems/icon_xzdj_01.png"
	end
	img_icom:setFile(str_icon)
	GetElement(self.m_root,"name",WZUILabelTTF):setText(info.title)
	-- GetElement(self.m_root,"medal_desc",WZUILabelTTF):setText(info.subtitle)
	GetElement(self.m_root,"score",WZUILabelTTF):setText(info.reward_point)
	local txtTotleRechcrge = GetElement(self.m_root,"txtTotleRechcrge",WZUIFreeTextBox)
	txtTotleRechcrge:setShowText(string.format(info.des,data.target))
	local txtCurRecharge = GetElement(self.m_root,"txtCurRecharge",WZUILabelTTF)
	txtCurRecharge:setText(string.format("(%s/%s)",data.progress > data.target and tostring(data.target) or tostring(data.progress), tostring(data.target)))

	if info.path ~= 0 then 
		local existSpine = CheckEffectFile("ui/otherUI/" .. info.path)
		if existSpine then 
			local spineIcon = WZUISpine:create()
			spineIcon:setTouchEnable(false)
			spineIcon:setRelativePosition(GlobalMethod:ccp(0.5,0.7086))
			self.m_root:addChild(spineIcon)
			spineIcon:setFileAtlas("ui/otherUI/" .. info.path .. ".atlas")
			spineIcon:setFileJson("ui/otherUI/" .. info.path .. ".json")
			if info.type >= 7 then
				spineIcon:setRelativePosition(GlobalMethod:ccp(0.5,0.735))
			end

			spineIcon:setAnimationName(info.animation)
			spineIcon:play(info.animation, true)
		else
			local _sIndex = info.path
	        local downloadInfo = GetDownloadInfo(_sIndex, "uiEffect")
	        if downloadInfo then 
	        	DownloadManager:addDownloadTask(14021 + info.id,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
	        end
		end
	end
end

--@return	新建的表实例对象
function MedalMsgItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function MedalMsgItem:_adaptLanguage_vn()
	local txtTotleRechcrge = GetElement(self.m_root,"txtTotleRechcrge",WZUIFreeTextBox)
	txtTotleRechcrge:setMaxWidth(400)
	txtTotleRechcrge:setScale(0.8)
	
	GetElement(self.m_root,"name",WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配end----------------------------------------
