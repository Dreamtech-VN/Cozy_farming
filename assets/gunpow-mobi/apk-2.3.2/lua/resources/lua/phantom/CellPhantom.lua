--CellPhantom.lua
--@brief	CellPhantom的UI模块
--@date		2017/04/25
--@author	zsq
--@note		幻化Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPhantom:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPhantom:onExit(element)
	self:_unInit()
end

function CellPhantom:setData(tData) 
	self.m_tData = tData
	self:update()
end

function CellPhantom:setHighLight(bool) 
	if self.m_root == nil then return end
	local bool = bool or false
	GetElement(self.m_root,"imgHighlight_CellPhantom",WZUI9Image):setVisible(bool)
end

function CellPhantom:onCheck() 
	WZLog("CellPhantom:onCheck")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if WndPhantom.m_tSelectedCell ~= nil then
		WndPhantom.m_tSelectedCell:setHighLight(false)
	end

	WndPhantom.m_tSelectedCell = self
	WndPhantom.RefineData = self.m_tData
    WndPhantom.showId = self.m_tData.id
	self:setHighLight(true)

	WndPhantom:onFresh(self.m_tData) 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellPhantom:update() 
	local tData = self.m_tData
	local qualityName = {LocalStrings.PHANTOM12, LocalStrings.PHANTOM13, LocalStrings.PHANTOM14, LocalStrings.PHANTOM15, LocalStrings.PHANTOM_NEWTEXT8}
	--怪物图片
	GetElement(self.m_root,"imgMonster",WZUIImage):setFile(tData.bust)
	GetElement(self.m_root,"imgMonster",WZUIImage):setGrayRender(false)
	--未拥有的灰化
	if tData.use == false and tData.own == false then
		GetElement(self.m_root,"imgMonster",WZUIImage):setGrayRender(true)
	end
	--怪物名字
	GetElement(self.m_root,"ttfQuality_CellPhantom",WZUILabelTTF):setText("【"..qualityName[tData.quality].."】")
	GetElement(self.m_root,"ttfQuality_CellPhantom",WZUILabelTTF):setColor(QUALITYCOLOR[tData.quality])
	GetElement(self.m_root,"ttfName_CellPhantom", WZUILabelTTF):setText(tData.name)
	GetElement(self.m_root,"ttfName_CellPhantom", WZUILabelTTF):setColor(QUALITYCOLOR[tData.quality])
	--品质框
	local qualityFile = {"ui/common/common_icon_pflv.png","ui/common/common_icon_pflan.png",
		"ui/common/common_icon_pfzi.png","ui/common/common_icon_pfcheng.png","ui/common/common_icon_pfhong.png"}
	GetElement(self.m_root,"imgQuality",WZUI9Image):setFile(qualityFile[tData.quality])
	--WZLog("sgsd",Serialize(tData))
	--是否体验卡
	if tData.own == true and tData.remainTime ~= -1 then
		GetElement(self.m_root,"imgExperience_CellPhantom",WZUIImage):setVisible(true)
	else
		GetElement(self.m_root,"imgExperience_CellPhantom",WZUIImage):setVisible(false)
	end
	--是否在使用
	if tData.use == true then
		GetElement(self.m_root,"imgEquiped_CellPhantom",WZUIImage):setVisible(true)
	else
		GetElement(self.m_root,"imgEquiped_CellPhantom",WZUIImage):setVisible(false)
	end
	if ProjConfig.LANGUAGE == "es" then
		GetElement(self.m_root,"ttfQuality_CellPhantom",WZUILabelTTF):setText("["..qualityName[tData.quality].."]")
	end

	--碎片数量
	local itemId = tData.channel
	local needNum = 1
	local debrisId 
	for k,v in pairs(GDatatab_itemmerge) do
		if ((v.id >= 8000 and v.id < 10000) or (v.id >= 161000 and v.id < 163000) or (v.id >= 157000 and v.id < 160000)) and v.items[1][1] == itemId then
			debrisId = v.id
			needNum = v.scrap[1][2]
		end
	end
	--已拥有，升品数量
	if tData.own then
		if tData.sp_cost == -1 then
			needNum = 1
			GetElement(self.m_root,"conPublish",WZUIContainer):setVisible(false)
			GetElement(self.m_root,"conMax_CellPhantom", WZUIContainer):setVisible(true)
		else
			debrisId = tData.sp_cost[1][1]
			needNum = tData.sp_cost[1][2]
		end
	end
	local tDebris = CacheCenter:getPlayerItemById(debrisId)
	local debrisNum = 0
	if tDebris ~= nil then
		debrisNum = tDebris.lastNum
	else
		debrisNum = 0
	end
	GetElement(self.m_root,"txtProgress",WZUILabelTTF):setText(debrisNum.."/"..needNum)

	self.tDebris = tDebris
	--碎片数量是否足够
	self.enough = (debrisNum>=needNum)
	WZLog(tData.name.."碎片足够？",self.enough)
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------私有方法模块End----------------------------------------
function CellPhantom:_adaptLanguage_vn(  )
	GetElement(self.m_root,"ttfName_CellPhantom", WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"ttfName_CellPhantom", WZUILabelTTF):setMaxLength(50)
	GetElement(self.m_root,"txtMax",WZUILabelTTF):setScale(0.7)
end

function CellPhantom:_adaptLanguage_en(  )
	GetElement(self.m_root,"ttfName_CellPhantom", WZUILabelTTF):setScale(0.8)
	local ttfName = GetElement(self.m_root,"ttfName_CellPhantom", WZUILabelTTF)
	ttfName:setScale(0.6)
	ttfName:setMaxLength(50)
	ttfName:setDimensions(GlobalMethod:CCSize(170))
end

function CellPhantom:_adaptLanguage_tr(  )
	GetElement(self.m_root,"ttfName_CellPhantom", WZUILabelTTF):setScale(0.8)
	local ttfName = GetElement(self.m_root,"ttfName_CellPhantom", WZUILabelTTF)
	ttfName:setScale(0.6)
	ttfName:setMaxLength(50)
	ttfName:setDimensions(GlobalMethod:CCSize(170))
end
-------------------------------------私有方法模块End----------------------------------------
