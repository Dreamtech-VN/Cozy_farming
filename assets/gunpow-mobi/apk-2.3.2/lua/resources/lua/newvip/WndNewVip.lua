--WndNewVip.lua
--@brief	WndNewVip的UI模块
--@date		2021/03/18
--@author	hyx
--@note		vip升级版本界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndNewVip:onEnter(element)
	self.m_root = element
	ProtocolProcessorFestivalActivity:regAll6()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndNewVip:onExit(element)
	for i,v in pairs(self.m_tBigView) do
		if v then
			v:removeFromParentAndCleanup(true)
		end
	end
	ProtocolProcessorWndBag:unregAll1()
	if WndSummonEntrance.m_root == nil then
		-- ProtocolProcessorWndRankList:unregAll2()
	end
--	ProtocolProcessorFestivalActivity:unregAll()
	self:_unInit()
end

--打开界面
--@param 	bFamous : 是否跳转到名人榜
function WndNewVip:showInterface(index, sec_index, bFamous)
	if not CheckButtonOpen(ISLAND_UP_RECHARGE) then
        return
    end
    
	local wndVip = WndNewVip:createElement()
	if wndVip ~= nil then
		self.m_bIsJumpToFamous = bFamous or false 
	    WindowManager:addWindow(wndVip, WndNewVip, nil, false)
	end
	self.m_nCurIndex = index or 1
	self.m_nSecIndex = sec_index or 1
end
function WndNewVip:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function WndNewVip:actionCallback()
	ProtocolProcessorWndRankList:regAll2()
	self:initShow()
end
function WndNewVip:setMainContainerVisible(_bool)
	local main_container = GetElement(self.m_root,"main_container",WZUIContainer)
	main_container:setVisible(_bool)
end
function WndNewVip:initShow()
	local main_container = GetElement(self.m_root,"main_container",WZUIContainer)
	self:setShowDiamondNum()
	
	for i=1,5 do
		local tab = {}
		local btn = GetElement(main_container,"btn"..i,WZUIButton)
		tab.select = GetElement(btn,"select",WZUIImage)
		tab.select:setVisible(false)
		tab.name = GetElement(btn,"name",WZUILabelTTF)
		tab.name:setColor(GlobalMethod:ccc3(255,236,193))
		tab.name:setText(LocalStrings.NEWVIP_TEXT1[i])
		self.m_tTitleData[i] = tab
	end
    self.m_tTitleData[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(127,70,26))
    self.m_tTitleData[self.m_nCurIndex].select:setVisible(true)

    self.m_sChildContainer = GetElement(main_container,"child_container",WZUIContainer)

    self:setChangeView(self.m_nCurIndex, self.m_nSecIndex)
end

function WndNewVip:onBtnClickTitle(element)
	local tag = element:getTag()
	if tag == self.m_nCurIndex then
		return
	end	

	self:setChangeView(tag)
	self:setBigTitleChange(tag)
end

function WndNewVip:setBigTitleChange(tag)
	if self.m_tTitleData[tag] then
	    self.m_tTitleData[tag].name:setColor(GlobalMethod:ccc3(127,70,26))
	    self.m_tTitleData[tag].select:setVisible(true)
	end
	if self.m_tTitleData[self.m_nCurIndex] then
		self.m_tTitleData[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
		self.m_tTitleData[self.m_nCurIndex].select:setVisible(false)
	end
	self.m_nCurIndex = tag
end

--[[
tag 大标题
index 小标题 目前存在于贵族福利的时候
]]
function WndNewVip:setChangeView(tag, index)
	index = index or 1
	if self.m_sTouchCurView then
		if self.m_sTouchCurView.setVisible then
			self.m_sTouchCurView:setVisible(false)
		end
		self.m_sTouchCurView = nil
	end
	--2和4每次进去要刷新，重新请求数据
	if self.m_tBigView[tag] == nil or tag == 5 or tag == 3 then
		local panel = nil
		if tag == 1 then
			panel = CellNewVipBuy:createElement()
		elseif tag == 2 then --新货币
			panel = CellNewVipBuy:createElement(2)
		elseif tag == 3 then
			panel = CellNewVipPrivilege:createElement()
			CellNewVipPrivilege.m_bIsJumpToFamous = self.m_bIsJumpToFamous
			self.m_bIsJumpToFamous = false 
		elseif tag == 4 then
			panel = CellNewVipWelfare:createElement(index)
		elseif tag == 5 then
			panel = CellNewVipMedal:createElement()
		end
		if panel then
			self.m_sChildContainer:addChild(panel)
			self.m_tBigView[tag] = panel
		end
	end
	self.m_sTouchCurView = self.m_tBigView[tag]
	if self.m_sTouchCurView then
		if self.m_sTouchCurView.setVisible then
			self.m_sTouchCurView:setVisible(true)
		end
	end
	self:setChangeTitle(tag)
end

--标题替换
function WndNewVip:setChangeTitle(index)
	local img_CurTitle = GetElement(self.m_root,"img_CurTitle",WZUIImage)
	local str_name = {"ui/newvip/bag_icon_cz.png","ui/newvip/bag_icon_cz.png","ui/newvip/common_icon_gztq.png","ui/newvip/common_icon_gzfl.png","ui/newvip/common_icon_gzxz.png",
					 "ui/newvip/bag_icon_mrb.png"}
	img_CurTitle:setFile(str_name[index])
end
function WndNewVip:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--名人榜界面
	if CellNewVipPrivilegeRank.m_root then
		self:setMainContainerVisible(true)
		WndNewVip:setChangeTitle(self.m_nCurIndex)
		CellNewVipPrivilegeRank.m_root:removeFromParentAndCleanup(true)
	else
		WindowManager:removeWindow(self.m_root, self, true)
	end
end
--显示钻石数量
function WndNewVip:setShowDiamondNum()
	if not self.m_root then return end
	local txtCurDiamond = GetElement(self.m_root,"txtCurDiamond",WZUILabelTTF)
	local count = CacheCenter:getPlayerItemCountById(1)
	txtCurDiamond:setText(count)

	local txtCurVnDiamond = GetElement(self.m_root,"txtCurVnDiamond",WZUILabelTTF)
	local count = CacheCenter:getPlayerItemCountById(177)
	txtCurVnDiamond:setText(count)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function WndNewVip:_adaptLanguage_vn()
	for i=1,5 do
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		local name = GetElement(btn,"name",WZUILabelTTF)
		name:setScale(0.8)
		name:setDimensions(GlobalMethod:CCSize(150,0))
	end
end
-------------------------------------语言适配End----------------------------------------
