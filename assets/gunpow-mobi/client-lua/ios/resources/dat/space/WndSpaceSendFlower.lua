--WndSpaceSendFlower.lua
--@brief	WndSpaceSendFlower的UI模块
--@date		2016/01/06
--@author	zsq
--@note		送鲜花


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSpaceSendFlower:onEnter(element)
	self.m_root = element
	ProtocolProcessorWndActivityOnLine:regAll()
	
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo( )
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSpaceSendFlower:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮点击回调
function WndSpaceSendFlower:onClose(element)
    WZLog("WndSpaceSendFlower:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新留言
function WndSpaceSendFlower:update()
	if self.m_root == nil then return end
	if GDatatab_flowers == nil then return end

	local flowerActivityConfig = CacheCenter:getGameParam().flowerActivityConfig
	if flowerActivityConfig and tonumber(flowerActivityConfig) ~= 0 and #SplitStringWithSeparator(flowerActivityConfig,",") > 0 then
	end

	local tableContainer = GetElement(self.m_root,"tbCon_WndSpaceSendFlower",WZUITableContainer)
	tableContainer:cleanTable()

	local tFlowerItem = {}
	tFlowerItem = SplitStringWithSeparator(flowerActivityConfig,",")
	WZLog("WndSpaceSendFlower tFlowerItem",Serialize(tFlowerItem))
	local nflowListItemNum = 0
	if self.m_nFlowerTpye == 1 then
		for i = 1, #tFlowerItem do
			local list0 = {1,9,99}
			for j = i, #list0 do
				nflowListItemNum = (i-1)*#list0+j
				local celElement,tCell = CellSpaceFlower:createElement()
				local tData = {isFlower=true,id=i,costType=tFlowerItem[i],cost=list0[j]}
				tCell:update(tData)
				celElement:setTag((i-1)*#list0+j-1)    
				tableContainer:setCellElement(celElement)
			end
		end
	end

	for i = 1,3 do 
		local list1 = {1,9,99}
		local tConf = GDatatab_flowers["id_"..i]
		local tData = {id=i,data1=list1[i],data2=tConf.popularity,data3=tConf.profit[1][2],cost=tConf.consume[1][2],costType=tConf.consume[1][1]}
		local celElement,tCell = CellSpaceFlower:createElement()
		tCell:update(tData)
		celElement:setTag(i-1+nflowListItemNum)
		tableContainer:setCellElement(celElement)
	end 
	if self.m_nFlowerTpye == 1 then
		GetElement(self.m_root,"ttf1_WndSpaceRecord",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"ttf2_WndSpaceRecord",WZUILabelTTF):setVisible(false)
	end

	--今天送花次数
	if WndSpaceMain.m_root then
		if tonumber(WndSpaceMain.m_tData.todayGFNum) < 0 then WndSpaceMain.m_tData.todayGFNum = 0 end
		GetElement(self.m_root,"ttf2_WndSpaceRecord",WZUILabelTTF):setText((5-WndSpaceMain.m_tData.todayGFNum).."/5")
	end
end



-------------------------------------私有方法模块End----------------------------------------
