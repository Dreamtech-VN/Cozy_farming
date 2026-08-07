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
	self.sureBtnState = "change"
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOther9:onExit(element)
	self:_unInit()
end

--@brief 	开始加载
function CellCheckOther9:update()
	-- body
	if self.m_nType == 1 then
		self:showMounts()
	elseif self.m_nType == 5 then
		self:showFootMark()
	elseif self.m_nType == 6 then
		self:showSkin()
	elseif self.m_nType == 7 then
		self:showFootBeatCard()
	elseif self.m_nType == 8 then
		self:showVipMadel()
	end

	self:addTitle()
end

--@brief 	加载数据
function CellCheckOther9:onLoadData(element)
	-- body
	WZLog("CellCheckOther9:onLoadData")
	local celElement = WZUISystem:getInstance():createElement("CellCheckOther9")
	self.m_root:addChild(celElement)

	self:update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	点击图标
function CellCheckOther9:onClick(element)
	-- WZLog("CellCheckOther9:onClick",element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nBtnTag = element:getTag()
	if self.m_nType == 1 or self.m_nType == 5 or self.m_nType == 6 then
		if self.m_tDataList[element:getTag()] == nil then return end
		WndTips:show(element,WndCheckOther.m_root,14,self.m_tDataList[element:getTag()], nil, true)
	elseif self.m_nType == 7 then 
		local tData = {}
		tData.tipsType = 1 
		local nTag = self.m_nBtnTag
		tData.id = self.m_tDataList[nTag].id
		tData.time = self.m_tDataList[nTag].time
		WndTips:show(element,WndCheckOther.m_root,5,tData,GlobalMethod:ccp(20,30),true,false)
	elseif self.m_nType == 8 then 
		local tData = self.m_tDataList.stage[self.m_nBtnTag]
		if tData then
			WndTips:show(element, WndCheckOther.m_root,69,tData,GlobalMethod:ccp(55,50), true)
		end
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

--@brief 	显示皮肤
function CellCheckOther9:showSkin()
	-- body
	local qualityPic = {"ui/common/common_scale9_lv.png",
					"ui/common/common_scale9_lan.png",
					"ui/common/common_scale9_zi.png",
					"ui/common/common_scale9_cheng.png",
					"ui/common/common_scale9_hong.png"}
	-- --全部设置不可点击
	for i = 1, 6 do
		GetElement(self.m_root,"btn"..i,WZUIButton):setTouchEnable(false)
	end
	if self.m_tDataList == nil then return end
	-- WZLog("显示皮肤",Serialize(self.m_tDataList))
	local conMain = GetElement(self.m_root,"conMain_CellCheckOther9",WZUIContainer)
	local element = GetElement(conMain, "conItems_CellCheckOther9", WZUIContainer)
	for i=1,#self.m_tDataList do
		local tempNum = i

		if element then
			-- GetElement(element,"black"..tempNum,WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
			GetElement(element,"quality"..tempNum,WZUI9Image):setFile(qualityPic[self.m_tDataList[i].quality])
			GetElement(element,"icon"..tempNum,WZUIImage):setFile(self.m_tDataList[i].icon)
			GetElement(element,"icon"..tempNum.."Sel",WZUIImage):setFile(self.m_tDataList[i].icon)
			local btn = GetElement(element,"btn"..tempNum,WZUIButton)
			btn:setTouchEnable(true)
			btn:setTag(i)
			if btn:getChildByTag(421) then btn:removeChildByTag(421,true) end
			if self.m_tDataList[i].quality == 4 then
				local spine = WZUISpine:create()
				spine:setTouchEnable(false)
				spine:setFileJson("ui/ui_icon_effect.json")
				spine:setFileAtlas("ui/ui_icon_effect.atlas")
				spine:play("zuoqi_cheng", true)	
				spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
				--spine:setScale(0.8)
				btn:addChild(spine, 421, 421)
			end
			if self.m_tDataList[i].quality == 5 then
				local spine = WZUISpine:create()
				spine:setTouchEnable(false)
				spine:setFileJson("ui/ui_icon_effect.json")
				spine:setFileAtlas("ui/ui_icon_effect.atlas")
				spine:play("hongkuang1", true)	
				spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
				--spine:setScale(0.8)
				btn:addChild(spine, 421, 421)
			end
		end

	end
end

--@brief	显示坐骑
function CellCheckOther9:showMounts()
	local qualityPic = {"ui/common/common_scale9_lv.png",
					"ui/common/common_scale9_lan.png",
					"ui/common/common_scale9_zi.png",
					"ui/common/common_scale9_cheng.png",
					"ui/common/common_scale9_hong.png"}
	-- --全部设置不可点击
	for i = 1, 6 do
		GetElement(self.m_root,"btn"..i,WZUIButton):setTouchEnable(false)
	end
	if self.m_tDataList == nil then return end
	local conMain = GetElement(self.m_root,"conMain_CellCheckOther9",WZUIContainer)
	local element = GetElement(conMain, "conItems_CellCheckOther9", WZUIContainer)
	for i=1, #self.m_tDataList do
		local tempNum = i

		if element then
			-- GetElement(element,"black"..tempNum,WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
			GetElement(element,"quality"..tempNum,WZUI9Image):setFile(qualityPic[self.m_tDataList[i].quality])
			GetElement(element,"icon"..tempNum,WZUIImage):setFile(self.m_tDataList[i].icon)
			GetElement(element,"icon"..tempNum.."Sel",WZUIImage):setFile(self.m_tDataList[i].icon)
			local btn = GetElement(element,"btn"..tempNum,WZUIButton)
			btn:setTouchEnable(true)
			btn:setTag(i)
			if btn:getChildByTag(421) then btn:removeChildByTag(421,true) end
			if tonumber(self.m_tDataList[i].advancedLevel) == 20 then --进阶20会替换品质4特效框
				local spinePath = "ui/otherUI/ui_icon_effect01"
				local bIsExist = CheckEffectFile(spinePath)
				if bIsExist then
					local spine = WZUISpine:create()
					spine:setTouchEnable(false)
					spine:setFileJson(spinePath .. ".json")
					spine:setFileAtlas(spinePath .. ".atlas")
					spine:play("wait", true)
					spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
					--spine:setScale(0.8)
					btn:addChild(spine, 421, 421)
				end
			elseif self.m_tDataList[i].quality == 4 then
				local spine = WZUISpine:create()
				spine:setTouchEnable(false)
				spine:setFileJson("ui/ui_icon_effect.json")
				spine:setFileAtlas("ui/ui_icon_effect.atlas")
				spine:play("zuoqi_cheng", true)	
				spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
				--spine:setScale(0.8)
				btn:addChild(spine, 421, 421)
			end
		end
	end
end

function CellCheckOther9:onClickTips(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = {}
	if self.m_nType == 1 then --坐骑
		tData = {id = 71}
		WndTips:show(element,WndCheckOther.m_root,67,tData,GlobalMethod:ccp(220,30),true,false)
	elseif self.m_nType == 5 then --足迹
		tData = {id = 72}
		WndTips:show(element,WndCheckOther.m_root,67,tData,GlobalMethod:ccp(220,30),true,false)
	elseif self.m_nType == 6 then --幻化
		tData = {id = 73}
		WndTips:show(element,WndCheckOther.m_root,67,tData,GlobalMethod:ccp(220,30),true,false)
	end
end

--@brief	显示足迹
function CellCheckOther9:showFootMark()
	local qualityPic = {"ui/common/common_scale9_lv.png",
					"ui/common/common_scale9_lan.png",
					"ui/common/common_scale9_zi.png",
					"ui/common/common_scale9_cheng.png",
					"ui/common/common_scale9_hong.png"}
	-- --全部设置不可点击
	for i = 1, 6 do
		GetElement(self.m_root,"btn"..i,WZUIButton):setTouchEnable(false)
	end
	if self.m_tDataList == nil then return end
	local conMain = GetElement(self.m_root,"conMain_CellCheckOther9",WZUIContainer)
	local element = GetElement(conMain, "conItems_CellCheckOther9", WZUIContainer)
	for i=1,#self.m_tDataList do
		local tempNum = i
		-- local upgradeLevel = self.m_tDataList[i]["upgradeLevel"]
		local advancedLevel = tonumber(self.m_tDataList[i].advancedLevel)
		WZLog("CellCheckOther9:showFootMark advancedLevel",i, advancedLevel)
		
		local advancedLevel = tonumber(self.m_tDataList[i].advancedLevel)
		if element then
			-- GetElement(element,"black"..tempNum,WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
			GetElement(element,"quality"..tempNum,WZUI9Image):setFile(qualityPic[self.m_tDataList[i].quality])
			GetElement(element,"icon"..tempNum,WZUIImage):setFile(self.m_tDataList[i].icon)
			GetElement(element,"icon"..tempNum.."Sel",WZUIImage):setFile(self.m_tDataList[i].icon)
			local btn = GetElement(element,"btn"..tempNum,WZUIButton)
			btn:setTouchEnable(true)
			btn:setTag(i)
			if btn:getChildByTag(421) then btn:removeChildByTag(421,true) end
			if btn:getChildByTag(422) then btn:removeChildByTag(422,true) end
			if self.m_tDataList[i].quality == 4 then
				local spine = WZUISpine:create()
				spine:setTouchEnable(false)
				spine:setFileJson("ui/ui_icon_effect.json")
				spine:setFileAtlas("ui/ui_icon_effect.atlas")
				spine:play("zuoqi_cheng", true)
				spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
				--spine:setScale(0.8)
				btn:addChild(spine, 421, 421)
			elseif self.m_tDataList[i].quality == 5 then
				local spinePath = "ui/otherUI/ui_icon_effect02"
				local bIsExist = CheckEffectFile(spinePath)
				if bIsExist then 
					local spine = WZUISpine:create()
					spine:setTouchEnable(false)
					spine:setFileJson(spinePath .. ".json")
					spine:setFileAtlas(spinePath .. ".atlas")
					spine:play("wait", true)
					spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
					--spine:setScale(0.8)
					btn:addChild(spine, 421, 421)
				end
			end

			if advancedLevel >= 20 then				
				local spinePath = "ui/otherUI/ui_icon_effect03"
				local bIsExist = CheckEffectFile(spinePath)
				if bIsExist then 	
					local spine = WZUISpine:create()
					spine:setTouchEnable(false)
					spine:setFileJson(spinePath .. ".json")
					spine:setFileAtlas(spinePath .. ".atlas")
					spine:play("wait", true)
					spine:setRelativePosition(GlobalMethod:ccp(0.5,1.36))
					--spine:setScale(0.8)
					btn:addChild(spine, 422, 422)
				end
			end
		end
	end
end

--@brief  坐骑按品质排序
function sortQuality(a,b)
	return a.quality > b.quality
end

--@brief 	标题
function CellCheckOther9:addTitle()
	-- body
	if self.m_sTitle == nil then return end 
	if self.m_root == nil then return end 

	local conForTitle = GetElement(self.m_root, "conForTitle_CellCheckOther9", WZUIContainer)
	local celElement,tCell = CellCheckOther8:createElement()
	if celElement ~= nil and tCell ~= nil then 
		celElement = WZUIContainer:luaTo(celElement)
		tCell:setTitle(self.m_sTitle, self.m_nRowNum, self.m_nType)

		conForTitle:addChild(celElement)
	end
end

--@brief 	显示足迹打卡印记
function CellCheckOther9:showFootBeatCard()
	if self.m_tDataList == nil then return end
	for j = 1, 6 do
		GetElement(self.m_root,"btn"..j,WZUIButton):setTouchEnable(false)
	end
	local conMain = GetElement(self.m_root,"conMain_CellCheckOther9",WZUIContainer)
	local element = GetElement(conMain, "conItems_CellCheckOther9", WZUIContainer)
	for i = 1, #self.m_tDataList do
		local tempNum = i

		if element then
			local configData = GDatatab_footmark_city["id_" .. self.m_tDataList[i].id]
			GetElement(element,"icon"..tempNum, WZUIImage):setFile("ui/footmark/" .. configData.icon .. ".png")
			GetElement(element,"icon"..tempNum.."Sel", WZUIImage):setFile("ui/footmark/" .. configData.icon .. ".png")
			local btn = GetElement(element,"btn"..tempNum,WZUIButton)
			btn:setTouchEnable(true)
			btn:setTag(i)

			--特效
			local strName = string.gsub(configData.icon, "dkzj_", "")
			--local existSpine = CheckEffectFile("checkother/ui_" .. strName .. "_1")
			--改用通用特效
			local existSpine = CheckEffectFile("checkother/ui_zjdk_01")
			if not existSpine then 
		        local downloadInfo = GetDownloadInfo(configData.icon, "dkzj")
		        if downloadInfo == nil then return end 

		        --DownloadManager:addDownloadTask(13000 + tonumber(self.m_tDataList[i].id),downloadInfo.url,downloadInfo.md5,configData.icon,"DownloadResourceCallback", _G)
			else
				local spineEffect = WZUISpine:create()
	            spineEffect:setScale(0.9)
	            spineEffect:setLoop(true)
	            spineEffect:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
	            spineEffect:setVisible(true)
	            spineEffect:setTouchEnable(false)
	            -- spineEffect:setFileJson("checkother/ui_" .. strName .. "_1.json")
	            -- spineEffect:setFileAtlas("checkother/ui_" .. strName .. "_1.atlas")
	            --改用通用特效
	            spineEffect:setFileJson("checkother/ui_zjdk_01.json")
	            spineEffect:setFileAtlas("checkother/ui_zjdk_01.atlas")
	            spineEffect:setAnimationName("animation")

	            btn:addChild(spineEffect)
	        end
		end
	end
end

function CellCheckOther9:showVipMadel()
	if next(self.m_tDataList) ~= nil then
		for j = 1, 6 do
			GetElement(self.m_root,"btn"..j,WZUIButton):setTouchEnable(false)
		end
		local conMain = GetElement(self.m_root,"conMain_CellCheckOther9",WZUIContainer)
		local element = GetElement(conMain, "conItems_CellCheckOther9", WZUIContainer)
		for i=1, #self.m_tDataList.stage do
			if self.m_tDataList.stage[i] then
				local tempNum = i
				if element then
					local info = GDatatab_vip_medal_stage["id_"..self.m_tDataList.stage[i][2]]
					if info then
						GetElement(element,"black"..tempNum,WZUI9Image):setFile("ui/common/common_scale9_beibaodi.png")
						GetElement(element,"quality"..tempNum,WZUI9Image):setFile("")
						GetElement(element,"icon"..tempNum,WZUIImage):setFile(info.icon)
						GetElement(element,"icon"..tempNum.."Sel",WZUIImage):setFile(info.icon)
						local btn = GetElement(element,"btn"..tempNum,WZUIButton)
						btn:setTouchEnable(true)
						btn:setTag(i)

						if info.path ~= 0 then 
							local existSpine = CheckEffectFile("ui/otherUI/" .. info.path)
							if existSpine then 
								local spineIcon = WZUISpine:create()
				                spineIcon:setScale(0.51)
				                spineIcon:setLoop(true)
				                spineIcon:setRelativePosition(GlobalMethod:ccp(0.5,0.42))
				                spineIcon:setVisible(true)
				                spineIcon:setTouchEnable(false)
								spineIcon:setFileAtlas("ui/otherUI/" .. info.path .. ".atlas")
								spineIcon:setFileJson("ui/otherUI/" .. info.path .. ".json")
				                if info.type >= 7 then
				                	spineIcon:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
								end
								spineIcon:setAnimationName(info.animation)
								btn:addChild(spineIcon)						
							else
								local _sIndex = info.path
						        local downloadInfo = GetDownloadInfo(_sIndex, "uiEffect")
						        if downloadInfo then 
						        	DownloadManager:addDownloadTask(14021 + info.id,downloadInfo.url,downloadInfo.md5,_sIndex,"DownloadResourceCallback", _G)
						        end
							end
						end
					end
				end
			end
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
