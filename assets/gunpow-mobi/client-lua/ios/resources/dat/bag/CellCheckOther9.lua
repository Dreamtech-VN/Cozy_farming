--CellCheckOther9.lua
--@brief	CellCheckOther9的UI模块
--@date		2015/07/06
--@author	zsq
--@note		玩家信息栏2


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCheckOther9:onEnter(element)
	self.m_root = element
	self.m_nType = nil					--1:坐骑栏,2:星魂栏,3:祈福
	self.m_tDataList = nil
	self.m_nBtnTag = nil
	self.sureBtnState = "change"
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOther9:onExit(element)
	self:_unInit()
	self.m_nType = nil
	self.m_tDataList = nil
	self.m_nBtnTag = nil
end

--@brief 	开始加载
function CellCheckOther9:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellCheckOther9")

	self.m_root:addChild(celElement)

	if self.m_nType == 1 then
		self:showMounts()
	elseif self.m_nType == 5 then
		self:showFootMark()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	点击图标
function CellCheckOther9:onClick(element)
	WZLog("CellCheckOther9:onClick",element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = element:getTag()
	if self.m_nType == 1 or self.m_nType == 5 then
		if self.m_tDataList[element:getTag()] == nil then return end
		WndTips:show(element,WndCheckOther.m_root,14,self.m_tDataList[element:getTag()])
	end
end

--@brief	设置高亮
function CellCheckOther9:setHighLight(bool)
	local btn = GetElement(self.m_root,"btn"..self.m_nBtnTag,WZUIButton)
	if bool == true then
		btn:setButtonStatus(1)
	elseif bool == false then
		btn:setButtonStatus(0)
	end
end

--@brief	显示坐骑
function CellCheckOther9:showMounts()
	local qualityPic = {"ui/common/common_scale9_lv.png",
					"ui/common/common_scale9_lan.png",
					"ui/common/common_scale9_zi.png",
					"ui/common/common_scale9_cheng.png",
					"ui/common/common_scale9_lv.png"}
	--全部设置不可点击
	for i = 1, 5 do
		GetElement(self.m_root,"btn"..i,WZUIButton):setTouchEnable(false)
	end
	if self.m_tDataList == nil then return end

	for i=1,#self.m_tDataList do
		GetElement(self.m_root,"black"..i,WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
		GetElement(self.m_root,"quality"..i,WZUI9Image):setFile(qualityPic[self.m_tDataList[i].quality])
		GetElement(self.m_root,"icon"..i,WZUIImage):setFile(self.m_tDataList[i].icon)
		GetElement(self.m_root,"icon"..i.."Sel",WZUIImage):setFile(self.m_tDataList[i].icon)
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		btn:setTouchEnable(true)
		if btn:getChildByTag(421) then btn:removeChildByTag(421,true) end
	
		if self.m_tDataList[i].quality == 4 then
			local spine = WZUISpine:create()
   			spine:setTouchEnable(false)
   			spine:setFileJson("ui/ui_icon_effect.json")
   			spine:setFileAtlas("ui/ui_icon_effect.atlas")
			spine:play("zuoqi_cheng", true)	
   			spine:setRelativePosition(GlobalMethod:ccp(0.5,1.18))
			--spine:setScale(0.8)
			btn:addChild(spine, 421, 421)
		end
	end
end

--@brief	显示足迹
function CellCheckOther9:showFootMark()
	local qualityPic = {"ui/common/common_scale9_lv.png",
					"ui/common/common_scale9_lan.png",
					"ui/common/common_scale9_zi.png",
					"ui/common/common_scale9_cheng.png",
					"ui/common/common_scale9_lv.png"}
	--全部设置不可点击
	for i = 1, 5 do
		GetElement(self.m_root,"btn"..i,WZUIButton):setTouchEnable(false)
	end
	if self.m_tDataList == nil then return end
	
	for i=1,#self.m_tDataList do
		GetElement(self.m_root,"black"..i,WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
		GetElement(self.m_root,"quality"..i,WZUI9Image):setFile(qualityPic[self.m_tDataList[i].quality])
		GetElement(self.m_root,"icon"..i,WZUIImage):setFile(self.m_tDataList[i].icon)
		GetElement(self.m_root,"icon"..i.."Sel",WZUIImage):setFile(self.m_tDataList[i].icon)
		GetElement(self.m_root,"icon"..i,WZUIImage):setScale(1)
		GetElement(self.m_root,"icon"..i.."Sel",WZUIImage):setScale(1)
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		btn:setTouchEnable(true)
		if btn:getChildByTag(421) then btn:removeChildByTag(421,true) end
	
		if self.m_tDataList[i].quality == 4 then
			local spine = WZUISpine:create()
   			spine:setTouchEnable(false)
   			spine:setFileJson("ui/ui_icon_effect.json")
   			spine:setFileAtlas("ui/ui_icon_effect.atlas")
			spine:play("zuoqi_cheng", true)	
   			spine:setRelativePosition(GlobalMethod:ccp(0.5,1.18))
			--spine:setScale(0.8)
			btn:addChild(spine, 421, 421)
		end
	end
end

--@brief  坐骑按品质排序
function sortQuality(a,b)
	return a.quality > b.quality
end



-------------------------------------私有方法模块End----------------------------------------
