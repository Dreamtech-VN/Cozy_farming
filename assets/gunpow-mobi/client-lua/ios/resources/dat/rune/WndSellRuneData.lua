--WndSellRuneData.lua
--@brief	WndSellRune的数据模块
--@date		2017/03/24
--@author	peiting_mao
--@note		批量出售符文

WndSellRune = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSellRune:_init()
	self.m_root = nil	 	  			--场景根节点
	self.itemIds = nil			--符文ID
	self.itemNums = nil			--符文数量
	self.isUseds = nil			--符文装载数量
	self.tag = {}				--记录被选中的符文
	self.firstRune = {}		--一级符文
	self.secondRune = {} 	--二级符文
	self.thirdRune = {} 	--三级符文
	self.fourRune = {} 		--四级符文
	self.fiveRune = {} 		--五级符文
	self.price = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSellRune:_unInit()
	self.m_root = nil
	self.itemIds = nil
	self.itemNums = nil
	self.isUseds = nil
	self.tag = nil
	self.firstRune = nil		
	self.secondRune = nil 	
	self.thirdRune = nil	
	self.fourRune = nil	
	self.fiveRune = nil 
	self.price = nil	
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSellRune:createElement()
	local element = WZUISystem:getInstance():createElement("WndSellRune")
	assert(element, "WndSellRune create element failed!")
	self:_init()
	return element
end

function WndSellRune:onSaleStatus(status)
	WZLog("--WndSellRune:onSaleStatus--",status)
	if status == 0 then
		WndRewardShow:showById({59},{self.price})
    	WndRewardShow:closeCallBack(self,nil, _G, pushEquipInList)
		for i=1, 5 do
			GetElement(self.m_root,"txtTips"..i.."_WndSellRune",WZUILabelTTF):setVisible(true)
			GetElement(self.m_root,"imgSel"..i.."_WndSellRune",WZUI9Image):setVisible(false)
			GetElement(self.m_root,"btnSellDes"..i.."_WndSellRune",WZUIButton):setVisible(false)
		end
		for i=1,#self.tag do
			if self.tag[i] == 1 then
				local tTempData = CopyTable(self.firstRune)
				self.firstRune = {}
				for k = 1, #tTempData do
					if not tTempData[k].bChoose then
						table.insert(self.firstRune, tTempData[k])
					end
				end
			elseif self.tag[i] == 2 then
				local tTempData = CopyTable(self.secondRune)
				self.secondRune = {}
				for k = 1, #tTempData do
					if not tTempData[k].bChoose then
						table.insert(self.secondRune, tTempData[k])
					end
				end
			elseif self.tag[i] == 3 then
				local tTempData = CopyTable(self.thirdRune)
				self.thirdRune = {}
				for k = 1, #tTempData do
					if not tTempData[k].bChoose then
						table.insert(self.thirdRune, tTempData[k])
					end
				end
			elseif self.tag[i] == 4 then
				local tTempData = CopyTable(self.fourRune)
				self.fourRune = {}
				for k = 1, #tTempData do
					if not tTempData[k].bChoose then
						table.insert(self.fourRune, tTempData[k])
					end
				end
			elseif self.tag[i] == 5 then
				local tTempData = CopyTable(self.fiveRune)
				self.fiveRune = {}
				for k = 1, #tTempData do
					if not tTempData[k].bChoose then
						table.insert(self.fiveRune, tTempData[k])
					end
				end
			end
		end
		self.tag = {}
		self.price = 0
		GetElement(self.m_root,"txtPrice_WndSellRune",WZUILabelTTF):setText(self.price)
		ProtocolProcessorSceneRune:send_RUNE_GetRuneInfo()
		--MsgBoxManager:showTipBox(LocalStrings.SALE_SUCCESS)
	else
		MsgBoxManager:showTipBox(LocalStrings.RUNEBOOK18)
	end
end

--@brief 	改变某个符文的选中状态
function WndSellRune:resetRuneChooseState(tag, tItemData)
	-- body
	if self.m_root == nil then return end 

	if tag == 1 then
		for i = 1, #self.firstRune do
			if self.firstRune[i].id == tItemData.id then
				self.firstRune[i].bChoose = not self.firstRune[i].bChoose
				break 
			end
		end
	elseif tag == 2 then
		for i = 1, #self.secondRune do
			if self.secondRune[i].id == tItemData.id then
				self.secondRune[i].bChoose = not self.secondRune[i].bChoose
				break 
			end
		end
		WndSellDes:showWindow(self.secondRune, tag)
	elseif tag == 3 then
		for i = 1, #self.thirdRune do
			if self.thirdRune[i].id == tItemData.id then
				self.thirdRune[i].bChoose = not self.thirdRune[i].bChoose
				break 
			end
		end
	elseif tag == 4 then
		for i = 1, #self.fourRune do
			if self.fourRune[i].id == tItemData.id then
				self.fourRune[i].bChoose = not self.fourRune[i].bChoose
				break 
			end
		end
	elseif tag == 5 then
		for i = 1, #self.fiveRune do
			if self.fiveRune[i].id == tItemData.id then
				self.fiveRune[i].bChoose = not self.fiveRune[i].bChoose
				break 
			end
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
