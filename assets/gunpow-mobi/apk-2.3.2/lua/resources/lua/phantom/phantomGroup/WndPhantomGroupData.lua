--WndPhantomGroupData.lua
--@brief	WndPhantomGroup的数据模块
--@date		2021/12/30
--@author	yrd
--@note		皮肤幻化-共生录

WndPhantomGroup = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPhantomGroup:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil
	self.m_nUseShapeGroupId = nil
	self.m_nCurPagesNum = 1 			--当前页数
	self.m_tShapeGroupObj = {}			--存放每个组合格子对象
	self.m_nCurShapeIndex = 1 			--记录当前点击的皮肤详情下标
	self.m_nUIType = 1 					--界面类型 1主界面 2激活进阶界面
	self.m_tProperty = {}				--皮肤总属性加成
	self.m_nFighting = 0				--战力加成
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPhantomGroup:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_nUseShapeGroupId = nil
	self.m_nCurPagesNum = nil
	self.m_tShapeGroupObj = nil
	self.m_nCurShapeIndex = nil
	self.m_nUIType = nil
	self.m_tProperty = nil
	self.m_nFighting = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPhantomGroup:createElement()
	if WndPhantomGroup.m_root ~= nil then
		WindowManager:removeWindow(WndPhantomGroup.m_root, WndPhantomGroup, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPhantomGroup")
	assert(element, "WndPhantomGroup create element failed!")
	self:_init()
	return element
end

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPhantomGroup:getShapeGroupListOk(shapeGroupId, status, advanceLevel, advanceBlessingValue, useShapeGroupId, property, fighting)
	if WndPhantomGroup.m_root == nil then
		return
	end

	self.m_tData = {}
	for i=1,#shapeGroupId do
		local tShapeGroup = {}
		tShapeGroup.shapeGroupId = shapeGroupId[i]
		tShapeGroup.status = status[i]
		tShapeGroup.advanceLevel = advanceLevel[i]
		tShapeGroup.advanceBlessingValue = advanceBlessingValue[i]

		tShapeGroup.shapeGroupInfo = GDatatab_shape_group["id_"..shapeGroupId[i]]

		table.insert(self.m_tData,tShapeGroup)
	end
	table.sort(self.m_tData, function(a,b)
		return a.shapeGroupId > b.shapeGroupId
	end)
	self.m_nUseShapeGroupId = useShapeGroupId

	self.m_tProperty = json.decode(property)
	self.m_nFighting = fighting

	self:updateUI()
end

--@brief 	皮肤是否拥有
function WndPhantomGroup:hasSkin(skinId)
	local tShapeInfo = GDatatab_shape_skins["id_"..skinId]
	local mySkinList = CacheCenter:getSkinStatus()
	for i=1,#mySkinList do
		if mySkinList[i].status ~= 0 and (mySkinList[i].id == skinId or mySkinList[i].id == tShapeInfo.next_shape) then
			return true
		end
	end
	return false
end

--@brief 	激活皮肤组合共生技能OK
function WndPhantomGroup:getActiveShapeGroupOk(result, shapeGroupId, status, advanceLevel, advanceBlessingValue)
	if not self.m_root or not self.m_tData then
		return 
	end

	if result == 0 then --激活成功
		MsgBoxManager:showTipBox(LocalStrings.NEWSKILL15)
	else --激活失败
		MsgBoxManager:showTipBox(LocalStrings.PHANTOM_COMBINATION_4)
	end

	for i=1,#self.m_tData do
		if self.m_tData[i].shapeGroupId == shapeGroupId then
			self.m_tData[i].shapeGroupId = shapeGroupId
			self.m_tData[i].status = status
			self.m_tData[i].advanceLevel = advanceLevel
			self.m_tData[i].advanceBlessingValue = advanceBlessingValue

			self.m_tData[i].shapeGroupInfo = GDatatab_shape_group["id_"..shapeGroupId]
			break
		end
	end

	self:updateUI()
end

--@brief 	皮肤组合进阶OK
function WndPhantomGroup:getAdvanceShapeGroupOk(result, shapeGroupId, advanceLevel, advanceBlessingValue, property, fighting)
	if not self.m_root or not self.m_tData then
		return 
	end

	if result == 0 then --激活成功
	    PopupResult("ui/common/common_icon_jjz.png")
	    SoundManager:playEffectSound(SoundDefine.E_MUSIC_ADDSTAR)
	else --激活失败
	    PopupResult("ui/common/common_icon_jjsb.png")
	    SoundManager:playEffectSound(SoundDefine.E_MUSIC_ADDSTAR)
	end

	for i=1,#self.m_tData do
		if self.m_tData[i].shapeGroupId == shapeGroupId then
			self.m_tData[i].shapeGroupId = shapeGroupId
			-- self.m_tData[i].status = status
			self.m_tData[i].advanceLevel = advanceLevel
			self.m_tData[i].advanceBlessingValue = advanceBlessingValue

			self.m_tData[i].shapeGroupInfo = GDatatab_shape_group["id_"..shapeGroupId]
			break
		end
	end

	self.m_tProperty = json.decode(property)
	self.m_nFighting = fighting

	self:updateUI()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------皮肤组合格子begin----------------------------------------

--@note		皮肤幻化-共生录格子

CellPhantomGroup = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellPhantomGroup:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bIsLoaded = nil 				--是否加载完成
	self.m_tData = nil
	self.m_nIndex = nil 				--对应WndPhantomGroup.m_tData的下标
	self.m_bUsed = false 				--皮肤使用的状态
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPhantomGroup:_unInit()
	self.m_root = nil
	self.m_bIsLoaded = nil
	self.m_tData = nil
	self.m_nIndex = nil
	self.m_bUsed = nil
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPhantomGroup:createElement()
	local tNewObj = self:_new()

	local element = WZUIContainer:create()
	element:setName("__CellPhantomGroup")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(400,90))
	element:setLuaObjectIndex(tNewObj)

	return element,tNewObj
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPhantomGroup:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPhantomGroup:onEnter(element)
	self.m_root = element
end

--@brief 	开始加载
function CellPhantomGroup:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellItem_WndPhantomGroup")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true

	self:updateUI()
	AdaptLanguage(self)
end

--@brief 	设置数据
function CellPhantomGroup:setData(tData, nIndex)
	self.m_tData = tData
	self.m_nIndex = nIndex

	if self.m_bIsLoaded then
		self:updateUI()
	end
end

--@brief 	更新界面
function CellPhantomGroup:updateUI()

	local txtName = GetElement(self.m_root,"txtName_CellItem_WndPhantomGroup",WZUILabelTTF)
	txtName:setText(self.m_tData.shapeGroupInfo.name)

	local tSkinIds = {}
	local sex = CacheCenter:getPlayerInfo().sex
	if sex == 0 then
		tSkinIds = self.m_tData.shapeGroupInfo.skin_male[1]
	else
		tSkinIds = self.m_tData.shapeGroupInfo.skin_female[1]
	end
	for i=1,#tSkinIds do
		local tShapeInfo = GDatatab_shape_skins["id_"..tSkinIds[i]]
		local conHead = GetElement(self.m_root,"conHead"..i.."_CellItem_WndPhantomGroup",WZUIContainer)
		conHead:setVisible(true)
		local imgHead = GetElement(conHead,"imgHead_CellItem_WndPhantomGroup",WZUIImage)
		imgHead:setFile("battle/head/"..tShapeInfo.head..".png")
		local bhasSkin = WndPhantomGroup:hasSkin(tSkinIds[i])
		imgHead:setGrayRender(not bhasSkin)
	end
	if self.m_tData.status == 2 and self.m_nUseShapeGroupId == WndPhantomGroup.m_tData[self.m_nIndex].shapeGroupId then
		self:setUsedStatus(true)
	else
		self:setUsedStatus(false)
	end

	GetElement(self.m_root,"conRedDot_CellItem_WndPhantomGroup",WZUIContainer):setVisible(self.m_tData.status == 1)
end

--@brief 	皮肤组合是否使用的状态
function CellPhantomGroup:setUsedStatus(bUsed)
	self.m_bUsed = bUsed
	if self.m_root then
		GetElement(self.m_root,"conCombat_CellItem_WndPhantomGroup",WZUIContainer):setVisible(bUsed)
	end
end

--@brief 	皮肤组合是否使用的状态
--@prarm 	nUseShapeGroupId : 当前使用中的皮肤组合ID【0=没有使用中的 (但是服务端没有判断是否是激活的,所以客户端自己判断)
function CellPhantomGroup:setUseIndex(nUseShapeGroupId)
	self.m_nUseShapeGroupId = nUseShapeGroupId
end

-------------------------------------皮肤组合格子end----------------------------------------


-------------------------------------语言适配Begin----------------------------------------

function CellPhantomGroup:_adaptLanguage_vn()
	GetElement(self.m_root,"txtName_CellItem_WndPhantomGroup",WZUILabelTTF):setScale(0.7)
end

-------------------------------------语言适配End----------------------------------------