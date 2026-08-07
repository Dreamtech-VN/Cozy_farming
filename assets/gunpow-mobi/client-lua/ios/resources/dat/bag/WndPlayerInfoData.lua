--WndPlayerInfo.lua
--@brief	WndPlayerInfoGoodsList的数据模块
--@date		2014/01/07
--@author	zsq
--@note		玩家物品项

WndPlayerInfo = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndPlayerInfo:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tPlayer = nil
	self.m_nLoadingId = nil

	self.sureBtnState = nil
	self.m_nBtnTag = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPlayerInfo:_unInit()
	self.m_root = nil
	self.m_tPlayer = nil
	self.m_nLoadingId = nil

	self.sureBtnState = nil
	self.m_nBtnTag = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPlayerInfo:createElement()
	local element = WZUISystem:getInstance():createElement("WndPlayerInfo")
	assert(element, "WndPlayerInfo create element failed!")
	self:_init()
	return element
end

--@brief	数据列表
function WndPlayerInfo:setPlayerData(tData)
	WZLog("WndPlayerInfo:setPlayerData",Serialize(tData))
	if self.m_root == nil or tData == nil then
		return
	end

	self.m_tPlayer = tData

	--角色属性
	GetElement(self.m_root,"attr1_WndPlayerInfo",WZUILabelTTF):setText(self.m_tPlayer.hp)
	GetElement(self.m_root,"attr2_WndPlayerInfo",WZUILabelTTF):setText(self.m_tPlayer.attack)
	GetElement(self.m_root,"attr3_WndPlayerInfo",WZUILabelTTF):setText(self.m_tPlayer.defend)
	GetElement(self.m_root,"attr4_WndPlayerInfo",WZUILabelTTF):setText(self.m_tPlayer.critRate)
	GetElement(self.m_root,"attr5_WndPlayerInfo",WZUILabelTTF):setText(self.m_tPlayer.reduceCrit)
	GetElement(self.m_root,"attr6_WndPlayerInfo",WZUILabelTTF):setText(self.m_tPlayer.injuryFree)
	GetElement(self.m_root,"attr7_WndPlayerInfo",WZUILabelTTF):setText(self.m_tPlayer.physique)
	GetElement(self.m_root,"attr8_WndPlayerInfo",WZUILabelTTF):setText(self.m_tPlayer.force)
	GetElement(self.m_root,"attr9_WndPlayerInfo",WZUILabelTTF):setText(self.m_tPlayer.armor)
	GetElement(self.m_root,"attr10_WndPlayerInfo",WZUILabelTTF):setText(self.m_tPlayer.agility)
	GetElement(self.m_root,"attr11_WndPlayerInfo",WZUILabelTTF):setText(self.m_tPlayer.luck)
	GetElement(self.m_root,"attr12_WndPlayerInfo",WZUILabelTTF):setText(self.m_tPlayer.wreckDefense)
	GetElement(self.m_root,"attr13_WndPlayerInfo",WZUILabelTTF):setText(self.m_tPlayer.range)

	--人物等级
	GetElement(self.m_root,"lv_WndPlayerInfo",WZUILabelTTF):setText("Lv"..self.m_tPlayer.level)

	--经验条
	local exp = self.m_tPlayer.exp
	local maxExp = self.m_tPlayer.maxExp 
	if self.m_tPlayer.level ~= nil and GDatatab_player_upgrade["id_"..self.m_tPlayer.level] ~= nil then
		maxExp = GDatatab_player_upgrade["id_"..self.m_tPlayer.level].exp
	end
	local txt = tostring(exp).."/"..tostring(maxExp)
	local percent = tonumber(exp)*100/tonumber(maxExp)
	WZLog("经验条",txt,percent)
	GetElement(self.m_root,"expPer_WndPlayerInfo",WZUILabelTTF):setText(txt)
	GetElement(self.m_root,"progrExpProgress_WndPlayerInfo",WZUIProgress):setPercentage(percent)

	self:_updateSignature()--更新签名

	--角色信息图标
	local hallInfo = GDatatab_integral["id_"..self.m_tPlayer.tournamentLevel]
	local displayLv = self.m_tPlayer.tournamentLevel--%10
	if displayLv == 0 then displayLv = 10 end
	GetElement(self.m_root,"imgIcon2_WndPlayerInfo",WZUIImage):setFile("ui/common/"..hallInfo.iocn..".png")
	GetElement(self.m_root,"imgIcon2Sel_WndPlayerInfo",WZUIImage):setFile("ui/common/"..hallInfo.iocn..".png")
	GetElement(self.m_root,"numIcon2_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.LV..displayLv)
	--设置公会图标
	local level = self.m_tPlayer.totemLevel
	GetElement(self.m_root,"numIcon4_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.LV..level)
	GetElement(self.m_root,"numIcon4_WndPlayerInfo",WZUILabelTTF):setVisible(true)
	GetElement(self.m_root,"btn3img1",WZUIImage):setFile("ui/community/common_icon_gonghui"..level..".png")
	GetElement(self.m_root,"btn3img2",WZUIImage):setFile("ui/community/common_icon_gonghui"..level..".png")
	if tonumber(level) > 10 then
		GetElement(self.m_root,"btn3img1",WZUIImage):setScale(0.4)
		GetElement(self.m_root,"btn3img2",WZUIImage):setScale(0.4)
	end
	--设置恩爱图标
	GetElement(self.m_root,"btn4",WZUIButton):setTouchEnable(CheckButtonShow(8))
	GetElement(self.m_root,"numIcon5_WndPlayerInfo",WZUILabelTTF):setVisible(CheckButtonShow(8))
	GetElement(self.m_root,"numIcon5_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.LV..self.m_tPlayer.loveLevel)
	--设置师德图标
	GetElement(self.m_root,"btn5",WZUIButton):setTouchEnable(CheckButtonShow(30))
	GetElement(self.m_root,"numIcon6_WndPlayerInfo",WZUILabelTTF):setVisible(CheckButtonShow(30))
	GetElement(self.m_root,"numIcon6_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.LV..self.m_tPlayer.moralityLevel)
	if tonumber(self.m_tPlayer.moralityLevel) == 0 then
		GetElement(self.m_root,"numIcon6_WndPlayerInfo",WZUILabelTTF):setText("")
	end
	if tonumber(self.m_tPlayer.level) < MASTERLEVEL then
		GetElement(self.m_root,"numIcon6_WndPlayerInfo",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"img1btn5",WZUIImage):setFile("ui/common/common_icon_shidei.png")
		GetElement(self.m_root,"img2btn5",WZUIImage):setFile("ui/common/common_icon_shidei.png")
	end
	--排位赛图标
	GetElement(self.m_root,"btn2",WZUIButton):setTouchEnable(CheckButtonShow(23))
	GetElement(self.m_root,"btn2",WZUIButton):setVisible(CheckButtonShow(23))
	GetElement(self.m_root,"numIcon3_WndPlayerInfo",WZUILabelTTF):setVisible(CheckButtonShow(23))
	if not CheckButtonShow(23) then
		GetElement(self.m_root,"btn3",WZUIButton):setRelativePosition(ccp(0.33,0.35))
		GetElement(self.m_root,"btn4",WZUIButton):setRelativePosition(ccp(0.5,0.35))
		GetElement(self.m_root,"btn5",WZUIButton):setRelativePosition(ccp(0.67,0.35))
	end
	--GetElement(self.m_root,"numIcon3_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.LV..self.m_tPlayer.segmentLevel)
		if tonumber(self.m_tPlayer.segmentLevel) ~= 0 then
    		local info = GDatatab_trio_rank_match_config["id_"..self.m_tPlayer.segmentLevel]
			for k,v in pairs(GDatatab_trio_rank_match_config) do
				if v.level3 == self.m_tPlayer.segmentLevel then
					info = v
				end
			end
			if self.m_tPlayer.segmentLevel > 106 then
				info = GDatatab_trio_rank_match_config["id_999"]
			end
			WZLog("sdsdsdsd"..info.icon)
			GetElement(self.m_root,"btn2img1",WZUIImage):setFile("ui/common/"..info.icon..".png")
			GetElement(self.m_root,"btn2img2",WZUIImage):setFile("ui/common/"..info.icon..".png")
    		GetElement(self.m_root,"numIcon3_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.LV..info.level3)
		end

	self:updateBtnPosition()
	--设置幻化图标
	local shapeId = self.m_tPlayer.shapeId
	if shapeId ~= nil and shapeId >= 0 then
		GetElement(self.m_root,"btn6",WZUIButton):setTouchEnable(true)
		GetElement(self.m_root,"numIcon7_WndPlayerInfo",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"numIcon7_WndPlayerInfo",WZUILabelTTF):setText(LocalStrings.LV..self.m_tPlayer.shapeLevel)
	end
end

--@brief	空的按钮排到后面
function WndPlayerInfo:updateBtnPosition(  )
	local btnIndex = 1
	local btnPosition = {GlobalMethod:ccp(0.16,0.35),GlobalMethod:ccp(0.33,0.35),GlobalMethod:ccp(0.5,0.35),GlobalMethod:ccp(0.67,0.35),GlobalMethod:ccp(0.84,0.35)}
	for i = 1, 5 do
		if GetElement(self.m_root,"btn" .. i,WZUIButton):getTouchEnable() == true then
			GetElement(self.m_root,"btn" .. i,WZUIButton):setRelativePosition(btnPosition[btnIndex])
			btnIndex = btnIndex + 1
		end
	end 
	for i = 1, 5 do
		if GetElement(self.m_root,"btn" .. i,WZUIButton):getTouchEnable() == false then
			GetElement(self.m_root,"btn" .. i,WZUIButton):setRelativePosition(btnPosition[btnIndex])
			btnIndex = btnIndex + 1
		end
	end 

end

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------数据更新Begin----------------------------------------

--@brief	更新玩家基础数据，缓存数据没有到，就等待更新
function WndPlayerInfo:updatePlayerInfoData()
	WZLog("WndPlayerInfo：更新玩家基础数据，缓存数据没有到，就等待更新")
	self:setPlayerData(CacheCenter:getPlayerInfo())--获取玩家信息列表	
	self:_updateSignature()--更新签名
end

--@brief	更新玩家基本信息(数据更新)
function WndPlayerInfo:updatePlayerInfoData()
	WZLog("WndPlayerInfo:更新玩家基本信息(数据更新)")
	if WndBag.m_bOpenStrengthen == true then return end
	if self.m_root == nil then return end
	self:setPlayerData(CacheCenter:getPlayerInfo())--获取玩家信息列表	
end

--@brief	更新缓存时刷新
function WndPlayerInfo:updatePlayerItemData()
	WZLog("WndPlayerInfo:更新玩家装备信息")
	if WndBag.m_bOpenStrengthen == true then return end
	if self.m_root == nil then return end
	self:setPlayerData(CacheCenter:getPlayerInfo())--获取玩家信息列表	
end

-------------------------------------数据更新End----------------------------------------


-------------------------------------事件回调--------------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
