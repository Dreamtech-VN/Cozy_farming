--CellNewVipPrivilegeRank.lua
--@brief	CellNewVipPrivilegeRank的UI模块
--@date		2021/04/06
--@author	hyx
--@note		vip福利排行榜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewVipPrivilegeRank:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewVipPrivilegeRank:onExit(element)
	for i,v in pairs(self.m_tRankBigView) do
		if v then
			v:removeFromParentAndCleanup(true)
		end
	end
	self:_unInit()
end
--打开界面
function CellNewVipPrivilegeRank:showInterface(index)    
	local panel = CellNewVipPrivilegeRank:createElement()
	WndNewVip.m_root:addChild(panel)
	self.m_nCurIndex = index or 1
end

function CellNewVipPrivilegeRank:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function CellNewVipPrivilegeRank:actionCallback()
	self:initShow()
end
function CellNewVipPrivilegeRank:initShow()
	local main_container = GetElement(self.m_root,"main_container",WZUIContainer)
	for i=1,3 do
		local tab = {}
		local btn = GetElement(main_container,"btn"..i,WZUIButton)
		tab.select = GetElement(btn,"select",WZUIImage)
		tab.select:setVisible(false)
		tab.name = GetElement(btn,"name",WZUILabelTTF)
		tab.name:setColor(GlobalMethod:ccc3(255,236,193))
		tab.name:setText(LocalStrings.NEWVIP_TEXT12[i])
		self.m_tTitleData[i] = tab
	end
    self.m_tTitleData[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(127,70,26))
    self.m_tTitleData[self.m_nCurIndex].select:setVisible(true)

    self.m_sChildRankContainer = GetElement(main_container,"child_container",WZUIContainer)

    self:setChangeView(self.m_nCurIndex)
end

function CellNewVipPrivilegeRank:onBtnClickTitle(element)
	local tag = element:getTag() 
	if tag == self.m_nCurIndex then
		return
	end

	if self.m_tTitleData[tag] then
	    self.m_tTitleData[tag].name:setColor(GlobalMethod:ccc3(127,70,26))
	    self.m_tTitleData[tag].select:setVisible(true)
	end
	if self.m_tTitleData[self.m_nCurIndex] then
		self.m_tTitleData[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
		self.m_tTitleData[self.m_nCurIndex].select:setVisible(false)
	end
	self:setChangeView(tag)
	self.m_nCurIndex = tag
end

function  CellNewVipPrivilegeRank:setChangeView(tag)
	if self.m_sTouchCurRankView then
		if self.m_sTouchCurRankView.setVisible then
			self.m_sTouchCurRankView:setVisible(false)
		end
		self.m_sTouchCurRankView = nil
	end
	if self.m_tRankBigView[tag] == nil then
		local panel = nil
		if tag == 1 then
			panel = CellPrivilegeRank:createElement()
		elseif tag == 2 then
			panel = CellPrivilegeRankReward:createElement()
		elseif tag == 3 then
			panel = CellPrivilegeRankChanpion:createElement()
		end
		if panel then
			self.m_sChildRankContainer:addChild(panel)
			self.m_tRankBigView[tag] = panel
		end
	end

	self.m_sTouchCurRankView = self.m_tRankBigView[tag]
	if self.m_sTouchCurRankView then
		if self.m_sTouchCurRankView.setVisible then
			self.m_sTouchCurRankView:setVisible(true)
		end
	end
end

--@brief	点击说明按钮回调
function CellNewVipPrivilegeRank:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface1(LocalStrings.VIP_TEXT38)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function CellNewVipPrivilegeRank:_adaptLanguage_vn()
	for i=1,3 do
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		local name = GetElement(btn,"name",WZUILabelTTF)
		name:setScale(0.8)
		name:setDimensions(GlobalMethod:CCSize(150,0))
	end
end
-------------------------------------语言适配End----------------------------------------

