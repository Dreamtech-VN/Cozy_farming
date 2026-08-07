--WndSkinSkill.lua
--@brief	WndSkinSkill的UI模块
--@date		2017/12/21
--@author	zsq
--@note		皮肤技能


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSkinSkill:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

function WndSkinSkill:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList( )
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSkinSkill:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮点击回调
--@param	element:绑定的UI节点引用
function WndSkinSkill:onClickClose(element)
	WZLog("WndSkinSkill:onClickClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WndSkillContainer:onClose()
end

function WndSkinSkill:upSkill(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	ProtocolProcessorWndSkillProp:send_PLAYER_ChangeShapeSkill(self.showSkillId )
end

function WndSkinSkill:onGet(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WndFastGetItems:show(self.channel)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndSkinSkill:update()
	if self.m_root == nil then return end
	WZLog("WndSkinSkill:update")
	local con = GetElement(self.m_root,"tbSkill_WndSkinSkill",WZUITableContainer)
	con:setLoadCountPerFrame(5)
	con:cleanTable()

	local skillIdList = {}
	-----------------------------------------------------
	local mySex = CacheCenter:getPlayerInfo().sex
	local ownNames = {}
	--先放入已拥有的皮肤
	for k,v in pairs(GDatatab_shape_skins) do
		v.own = false
		v.use = false
	end
	local tDataList = WndPhantom.m_tDataList
	for i=1,#tDataList do
		local tData1 = GDatatab_shape_skins["id_"..tDataList[i].shapeId]
		tData1.own = true
		tData1.remainTime = tDataList[i].remainTime
		if tData1.id == WndPhantom.useShapeId then
			tData1.use = true
		end
		table.insert(ownNames, tData1.name)
			local id = tData1.passive_skill[1][1]
			local temp = {}
			temp.id = id
			temp.isUse = (id == self.useSkill)
			temp.isOwn = (tDataList[i].remainTime == -1)
			temp.shapeId = tData1.id
			table.insert(skillIdList, temp)
	end

	for k,v in pairs(GDatatab_shape_skins) do
		if (not utilsValueInTable(v.name, ownNames)) and (v.initial==1) and (v.sex == mySex or v.sex == 2) then
			local id = v.passive_skill[1][1]
			local temp = {}
			temp.id = id
			temp.isUse = false
			temp.isOwn = false
			temp.shapeId = v.id
			table.insert(skillIdList, temp)
		end
	end
	------------------------------------------------------

	local sortSkill = function(a, b)
		if a.isUse ~= b.isUse then
			return a.isUse
		else
			if a.isOwn ~= b.isOwn then
				return a.isOwn
			else
				return a.id > b.id
			end
		end
	end

	table.sort(skillIdList, sortSkill)

	for i=1,#skillIdList do
		local tData = {}
		setmetatable(tData, {__index = GDatatab_skill["id_"..skillIdList[i].id]})
		tData.isUse = skillIdList[i].isUse 
		tData.isOwn = skillIdList[i].isOwn
		tData.shapeId = skillIdList[i].shapeId
		local celElement,tCell = CellSkinSkill:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(tData)
			celElement:setTag(i-1)
			celElement:setScale(0.81)
			con:setCellElement(celElement)
		end 
		if i == 1 then
			self.selectedCell = tCell
		end
	end

		local tShow = {}
		setmetatable(tShow, {__index = GDatatab_skill["id_"..skillIdList[1].id]})
		tShow.isUse = skillIdList[1].isUse 
		tShow.isOwn = skillIdList[1].isOwn 
		tShow.shapeId = skillIdList[1].shapeId
	WndSkinSkill:showDetail(tShow)
	WZLog("WndSkinSkill:update1", Serialize(skillIdList))

	self.m_root:enableSchedule("updateCall",0)
end

function WndSkinSkill:updateCall()
	self.m_root:disableSchedule()
	self.selectedCell:setHighLight(true)
end

--技能详细信息
function WndSkinSkill:showDetail(tData)
	WZLog("WndSkinSkill:showDetail", Serialize(tData))
	if self.m_root == nil then return end
	GetElement(self.m_root,"conRight",WZUIContainer):setVisible(true)
	self.showSkillId = tData.id

	if tData.isOwn then
		GetElement(self.m_root,"btnGet",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnUp",WZUIButton):setVisible(true)
	else
		GetElement(self.m_root,"btnGet",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnUp",WZUIButton):setVisible(false)
	end

	if tData.isUse then
		GetElement(self.m_root,"btnGet",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnUp",WZUIButton):setVisible(false)
	end

	--技能名
	GetElement(self.m_root,"txtSkillName_WndSkillProp",WZUILabelTTF):setText(tData.name)
	--技能图标
	GetElement(self.m_root,"imgSkillPg_WndSkillProp",WZUIImage):setFile(tData.icon)
	--技能等级
	GetElement(self.m_root,"imgSkillL_WndSkillProp",WZUIImage):setFile(tData.lv_icon)
	--技能描述
	GetElement(self.m_root,"skillDesc",WZUILabelTTF):setText(tData.tool_desc)

	--技能对应的皮肤
	local tSkin = CopyTable(GDatatab_shape_skins["id_"..tData.shapeId])
	--for k,v in pairs(GDatatab_shape_skins) do
	--	if v.passive_skill[1][1] == tData.id and (v.sex == 2 or v.sex == CacheCenter:getPlayerInfo().sex) then
	--		tSkin = CopyTable(v)
	--		break
	--	end
	--end

	self.channel = tSkin.channel

	GetElement(self.m_root,"imgHead",WZUIImage):setFile(tSkin.bust)
	GetElement(self.m_root,"skillDesc1",WZUILabelTTF):setText(string.format(LocalStrings.SKINSKILL2, tSkin.name))
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------------
function WndSkinSkill:_adaptLanguage_vn(  )
	local txtSkinType = GetElement(self.m_root,"txtSkinType_WndSkinSkill",WZUILabelTTF)
	txtSkinType:setFontSize(13)

	local skillDesc = GetElement(self.m_root,"skillDesc",WZUILabelTTF)
	skillDesc:setScale(0.9)
	skillDesc:setDimensions(GlobalMethod:CCSize(260,0))
	skillDesc:setRelativePosition(GlobalMethod:ccp(0.03,0.66))
end

function WndSkinSkill:_adaptLanguage_pt(  )
	local txtSkinType = GetElement(self.m_root,"txtSkinType_WndSkinSkill",WZUILabelTTF)
    txtSkinType:setFontSize(13)
    txtSkinType:setDimensions(GlobalMethod:CCSize(110,0))

	local skillDesc = GetElement(self.m_root,"skillDesc",WZUILabelTTF)
	skillDesc:setScale(0.85)
	skillDesc:setDimensions(GlobalMethod:CCSize(250,0))
    local skillDesc1 = GetElement(self.m_root,"skillDesc1",WZUILabelTTF)
	skillDesc1:setScale(0.85)
    skillDesc1:setDimensions(GlobalMethod:CCSize(250,0))
end

function WndSkinSkill:_adaptLanguage_es(  )
	local txtSkinType = GetElement(self.m_root,"txtSkinType_WndSkinSkill",WZUILabelTTF)
    txtSkinType:setFontSize(13)
    txtSkinType:setDimensions(GlobalMethod:CCSize(110,0))

	local skillDesc = GetElement(self.m_root,"skillDesc",WZUILabelTTF)
	skillDesc:setScale(0.85)
	skillDesc:setDimensions(GlobalMethod:CCSize(250,0))
    local skillDesc1 = GetElement(self.m_root,"skillDesc1",WZUILabelTTF)
	skillDesc1:setScale(0.85)
    skillDesc1:setDimensions(GlobalMethod:CCSize(250,0))
end

function WndSkinSkill:_adaptLanguage_en(  )
	local skillDesc = GetElement(self.m_root,"skillDesc",WZUILabelTTF)
	skillDesc:setScale(0.85)
	skillDesc:setDimensions(GlobalMethod:CCSize(250,0))
    local skillDesc1 = GetElement(self.m_root,"skillDesc1",WZUILabelTTF)
	skillDesc1:setScale(0.85)
    skillDesc1:setDimensions(GlobalMethod:CCSize(250,0))
end

function WndSkinSkill:_adaptLanguage_tr(  )
    local skillDesc = GetElement(self.m_root,"skillDesc",WZUILabelTTF)
	skillDesc:setScale(0.85)
	skillDesc:setDimensions(GlobalMethod:CCSize(250,0))
    local skillDesc1 = GetElement(self.m_root,"skillDesc1",WZUILabelTTF)
	skillDesc1:setScale(0.85)
    skillDesc1:setDimensions(GlobalMethod:CCSize(250,0))

	GetElement(self.m_root,"txtInUse_WndSkinSkill",WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配End-------------------------------------------------