--WndSkillPreViewData.lua
--@brief	WndSkillPreView的数据模块
--@date		2020/08/26
--@author	hyx
--@note		技能预览界面

WndSkillPreView = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSkillPreView:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tTabTitleView = {}
	self.m_nCurrentIndex = 1
	self.m_tFreeList = {}
	self.m_tSkillPreview = {}
	self.m_tSkillProfes = {}
	self.m_tSkillItemObj = {}
	self.m_nSkillVocatIndex = 1 --职业技能的初始化index
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSkillPreView:_unInit()
	self.m_root = nil
	self.m_tTabTitleView = {}
	self.m_nCurrentIndex = 1
	self.m_tFreeList = {}
	self.m_tSkillPreview = {}
	self.m_tSkillProfes = {}
	self.m_tSkillItemObj = {}
	self.m_nSkillVocatIndex = 1
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSkillPreView:createElement(skill, profes, skill_lev, skill_id)
	if WndSkillPreView.m_root ~= nil then
		WindowManager:removeWindow(WndSkillPreView.m_root, WndSkillPreView, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSkillPreView")
	assert(element, "WndSkillPreView create element failed!")
	self:_init()
	self.m_tSkillPreview = skill
	self.m_tSkillProfes = profes
	self.m_nSkillLev = skill_lev or 1 --职业初始化的index
	self.m_nSkill_Id = skill_id
	return element
end



--************* 技能預覽子項 ****************
WndSkillPreViewItem = {}
function WndSkillPreViewItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSkillPreViewItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function WndSkillPreViewItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(104,350))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function WndSkillPreViewItem:setPreviewItemMessage(data, index, cur_lev, tag)
	self.m_tSkillData = data
	self.m_nLevIndex = index
	self.m_nCurLev = cur_lev
	self.touch_flag = tag --点击的是技能还是职业技能
end
function WndSkillPreViewItem:setPreviewItemCallFunc(callfunc)
	self.preview_callfunc = callfunc
end

--@brief 	开始加载
function WndSkillPreViewItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("preview_item")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:upSkillPreviewDateItem()
end
function WndSkillPreViewItem:upSkillPreviewDateItem()
	if not self.m_tSkillData then return end

	self.top = GetElement(self.m_root,"top",WZUIContainer)
	self.botton = GetElement(self.m_root,"botton",WZUIContainer)

	if self.m_nLevIndex == self.m_nCurLev then
		GetElement(self.m_root,"botton",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"top",WZUIContainer):setVisible(true)
	end
	local level_desc = GetElement(self.m_root,"level_desc",WZUILabelTTF)
	level_desc:setText(LocalStrings.AUCTION_HOUSE_TEXT16[self.m_nLevIndex] .. LocalStrings.LEVEL1)

	local start_number = GetElement(self.m_root,"start_number",WZUILabelTTF)
	start_number:setText(self.m_tSkillData.start_num)

	local hurt_number = GetElement(self.m_root,"hurt_number",WZUILabelTTF)
	hurt_number:setText(self.m_tSkillData.describe.."%")
	
	local consume_number = GetElement(self.m_root,"consume_number",WZUILabelTTF)
	consume_number:setText(self.m_tSkillData.consume)

	local cool_number = GetElement(self.m_root,"cool_number",WZUILabelTTF)
	cool_number:setText(self.m_tSkillData.coolingTime)
end

function WndSkillPreViewItem:onBtnClickPreview()
	if not self.m_nLevIndex then return end
	if self.preview_callfunc then
		self.preview_callfunc(self.touch_flag, self.m_nLevIndex)
	end
end

function WndSkillPreViewItem:setNormal()
	if self.top then
		self.top:setVisible(false)
	end
	if self.botton then
		self.botton:setVisible(false)
	end
end
function WndSkillPreViewItem:setSelect()
	if self.top then
		self.top:setVisible(true)
	end
	if self.botton then
		self.botton:setVisible(true)
	end
end
--@return	新建的表实例对象
function WndSkillPreViewItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
