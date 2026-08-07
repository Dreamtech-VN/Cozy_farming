--CellCharmRecommend.lua
--@brief	CellCharmRecommend的UI模块
--@date		2016/08/24
--@author	mpt
--@note		魅力空间推荐


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCharmRecommend:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCharmRecommend:onExit(element)
	self:_unInit()
end

--@brief	点击头像进入玩家空间
function CellCharmRecommend:onEnterSpace1( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	--if self.cross == 1 then --跨服
		--WZLog("--CellCharmRecommend1--",self.cross)
		--MsgBoxManager:showTipBox(LocalStrings.CHARM_NOT_INTO_SPACE)
		--return
	--end
	--WZLog("--CellCharmRecommend2--",self.playerId)
	WndSpaceMain:show(self.playerId)
end

--@brief	更新内容
function CellCharmRecommend:_update()
	WZLog("---CellCharmRecommend:_update---")
	if self.m_root == nil then return end
	local imgHead = GetElement(self.m_root,"imgHead_CellCharmRecommend",WZUIImage) --玩家头像
	local txtLevel1 = GetElement(self.m_root,"txtLevel1_CellCharmRecommend",WZUILabelTTF)
	local txtName1 = GetElement(self.m_root,"txtName1_CellCharmRecommend",WZUILabelTTF)
	local img = GetElement(self.m_root,"img_CellCharmRecommend",WZUIImage) --跨服标识
	local imgBoy = GetElement(self.m_root,"imgBoy_CellCharmRecommend",WZUI9Image) --男性标识
	local imgGirl = GetElement(self.m_root,"imgGirl_CellCharmRecommend",WZUI9Image) --女性标识

	if self.sex == 0 then
		imgBoy:setVisible(true)
		imgGirl:setVisible(false)
		
	elseif self.sex == 1 then
		imgBoy:setVisible(false)
		imgGirl:setVisible(true)

	end

	txtName1:setText(self.playerName)
	txtLevel1:setText("Lv"..self.level)
	--判断是否跨服
	if self.cross == 0 then 
		img:setVisible(false)
	elseif self.cross == 1 then
		img:setVisible(true)
	end

	if self.photoUrl == "" and self.sex == 0 then
		imgHead:setFile("ui/space/common_icon_renxiangnan.png")
	elseif self.photoUrl == "" and self.sex == 1 then
		imgHead:setFile("ui/space/common_icon_renxiangnv.png")
	elseif self.photoUrl ~= "" then
		-- local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..self.photoUrl
		-- local bExist = WZFileUtil:isFileExist(path)
		-- if bExist then
		-- 	imgHead:setFile(path)
		-- else
			--下载头像
		    --添加下载图片Cell
			local con = GetElement(self.m_root,"con_CellCharmRecommend",WZUIContainer)
		    --con:removeAllChildrenWithCleanup(true)
			local celElement,tCell = CellDownloadImg:createElement()
			con:addChild(celElement)
			WndCharmSpace:addDownloadFileList(self.photoUrl, tCell, nil, 116)
			-- if self.sex == 1 then
			-- 	imgHead:setFile("ui/space/common_icon_renxiangnv.png")
			-- elseif self.sex == 0 then
			-- 	imgHead:setFile("ui/space/common_icon_renxiangnan.png")
			-- end
		--end
		--WZLog("----CellCharmRecommend:path----",path)
		-- imgHead:setFile(self.photoUrl)
	end
	--WZLog("---CellCharmRecommend:photoUrl--",self.photoUrl)
	--WZLog("---CellCharmRecommend:sex--",self.sex)

end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
