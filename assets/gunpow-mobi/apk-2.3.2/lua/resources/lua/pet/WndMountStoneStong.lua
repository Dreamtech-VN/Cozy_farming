--WndMountStoneStong.lua
--@brief	WndMountStoneStong的UI模块
--@date		2021/04/28
--@author	hyx
--@note		坐骑灵石强化


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMountStoneStong:onEnter(element)
	self.m_root = element

	self.m_nHasEffectMaxLevel = tonumber(CacheCenter:getGameParam().spriteStoneMaxLv)

	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMountStoneStong:onExit(element)
	doStopAllActions(self.m_root)
	self:unregister()
	self:_unInit()
end
function WndMountStoneStong:register()
	GlobalGame:getGameEventDispathcer():Add(PetMountEvent.PetMountEvent_StoneUpgradeResult,self._onStoneUpgrade,self)
end
function WndMountStoneStong:unregister()
	GlobalGame:getGameEventDispathcer():Remove(PetMountEvent.PetMountEvent_StoneUpgradeResult,self._onStoneUpgrade,self)
end
function WndMountStoneStong:showInterface(id, playerItemId)
	local wndStong = WndMountStoneStong:createElement(id, playerItemId)
	if wndStong ~= nil then
	    WindowManager:addWindow(wndStong,WndMountStoneStong,nil,false)
	end
end
function WndMountStoneStong:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndMountStoneStong:actionCallback()
	self:initShow()
end
local table_insert = table.insert
function WndMountStoneStong:initShow()
	self:setMainStoneData()

	self.m_tQuickChooseData[1] = true --快速选择的时候默认选择经验石
	local goods_con = GetElement(self.m_root,"goods_con",WZUIContainer)
	local tabItem = GDatatab_item["id_"..self.m_nUpgradeID]
	local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=1,quality=tabItem.quality,basicInfo=CopyTable(tabItem)}
	local celElement,tCell = CellGoodItem:createElement()
	tCell:setCellGoodItem(itemInfo, 4)
	goods_con:addChild(celElement)
	self.m_nMainStoneQuality = tabItem.quality

	local bagData = CacheCenter:getMountStoneList()
	local configId,level,cur_exp, effectId = nil,1,0,0
	for i,v in pairs(bagData) do
		if v.playerItemId == self.m_nPlayerItemId then
			level = v.extraInfo.strongLevel
			configId = v.extraInfo.spriteStoneConfigId
			cur_exp = v.extraInfo.strongExp
			effectId = v.extraInfo.spriteStoneEffect or 0
			break
		end
	end
	local raise_info = GDatatab_sprite_stone_effect["id_"..effectId]
	if raise_info and raise_info.type == 4 then
		self.m_nRaiseExpProporte = raise_info.value[1][2] / 100
	end
	--根据等级计算出来的id
	local temp_id = self.m_tMainStoneData[self.m_nMainStoneQuality][level+1].id
	if temp_id ~= configId then
		configId = temp_id
	end
	self.m_nMainStoneConfigId = configId
	local stone_info = GDatatab_sprite_stone["id_"..configId]
	local max_info = self.m_tMainStoneData[self.m_nMainStoneQuality][#self.m_tMainStoneData[self.m_nMainStoneQuality]-1]
	local spriteStoneMaxLv = tonumber(CacheCenter:getGameParam().spriteStoneMaxLv)
	if raise_info then
		if raise_info.type ~= 2 then --没有特效加持的时候
			self.m_nIsHasEffect = 0
			self.m_nHasEffectMaxLevel = spriteStoneMaxLv
		else
			self.m_nIsHasEffect = 1
			self.m_nHasEffectMaxLevel = spriteStoneMaxLv + raise_info.value[1][2]
		end
	end
	self.m_nInitCurLevel = level
	if stone_info then
		if level < self.m_nHasEffectMaxLevel then
			self.m_nCurLevel = level
			self.m_nCurExp = cur_exp
			self.m_nTotleExp = stone_info.exp_need
			self:setStongProgress(level, cur_exp, stone_info.exp_need)
		else --最大等级的时候
			self.m_nCurLevel = level
			self.m_nCurExp = max_info.exp_need
			self.m_nTotleExp = max_info.exp_need
			self:setMaxProgress()
		end
	end

	self.m_nQualityInitExp = self.m_nCurExp
	self.m_nSaveInitExp = self:getSunExp(level)
	
	self.m_sItemTableContainer = GetElement(self.m_root,"ItemTableContainer",WZUITableContainer)
	self.m_sItemTableContainer:cleanTable()
 	local data = CacheCenter:getMountStoneList()
	local data1 = CacheCenter:getMountStoneSourceList()
	local temp_data = self:setMergeTables(data, data1)

	self:setSortData(temp_data)
	self.m_tStrongUpgradeData = temp_data
	doStopAllActions(self.m_root)
	for i=1, #temp_data do
		delayRun(self.m_root, i / DEFAULT_FPS,function ()
			local celElement,tCell = CellGoodItem:createElement()
			celElement:setTag(i-1)
			self.m_tChooseCellItem[temp_data[i].playerItemId] = tCell
	        self.m_sItemTableContainer:setCellElement(celElement)
	        tCell:setItemClickFun(self, self.onItemClick)
	        
	        --经验石的时候
	        if temp_data[i].subtype == 14 then
	        	tCell:setReduceCallFunc(function(tag, itenData, txtNode, _type)
	        		self:setExpStone(tag, itenData, txtNode, _type)
	        	end)				
			end
			tCell:setCellGoodItem(temp_data[i], 2)
			if temp_data[i].subtype >= 9 and temp_data[i].subtype <= 13 then
				tCell:setVisibleItemCount(temp_data[i].extraInfo.spriteStoneQuality)
				tCell:clearItemQualityPic(nil, temp_data[i].extraInfo.spriteStoneQuality)
			end
			tCell:setTouchHeightVisible(false)
		end)
	end
end
--合并两个table
function WndMountStoneStong:setMergeTables(...)
    local tabs = {...}
    if not tabs then
        return {}
    end
    local origin = tabs[1]
    for i = 2,#tabs do
        if origin then
            if tabs[i] then
                for k,v in pairs(tabs[i]) do
                    table_insert(origin,v)
                end
            end
        else
            origin = tabs[i]
        end
    end
    local temp_tab = {}
    local souece_data = WndMountStone:getUseStoneSourceData()
    for i,v in pairs(origin) do
    	if v.isUse == true then
    	else
    		if souece_data[v.playerItemId] == nil then
	    		table_insert(temp_tab, v)
	    	end
    	end
    end
    return temp_tab
end
--排序
function WndMountStoneStong:setSortData(temp_data)
	function sortFunc(a, b)
		if a.subtype == 14 and b.subtype == 14 then
			if a.basicInfo.quality and b.basicInfo.quality then
				return a.basicInfo.quality > b.basicInfo.quality
			end
		elseif ((a.subtype >= 1 and a.subtype <= 8) and (b.subtype >= 9 and b.subtype <= 13)) or ((a.subtype >= 9 and a.subtype <= 13) and (b.subtype >= 1 and b.subtype <= 8)) then
			return a.subtype > b.subtype
		elseif (a.subtype >= 9 and a.subtype <= 13) and (b.subtype >= 9 and b.subtype <= 13) then
			if a.extraInfo.spriteStoneQuality and b.extraInfo.spriteStoneQuality then
				if a.extraInfo.spriteStoneQuality == b.extraInfo.spriteStoneQuality then
					return a.id < b.id
				else
					return a.extraInfo.spriteStoneQuality < b.extraInfo.spriteStoneQuality
				end
			end
		elseif (a.subtype >= 1 and a.subtype <= 8) and (b.subtype >= 1 and b.subtype <= 8) then
			if a.basicInfo.quality and b.basicInfo.quality then
				if a.basicInfo.quality == b.basicInfo.quality then
					return a.id < b.id
				else
					return a.basicInfo.quality < b.basicInfo.quality
				end
			end
		else
			return a.subtype > b.subtype
		end

	end
	table.sort(temp_data, sortFunc)
end
--进度条的显示
function WndMountStoneStong:setStongProgress(curLevel, curExp, totleExp, diff_num, isAdd)
	diff_num = diff_num or 0
	isAdd = isAdd or nil
	local txtLev = GetElement(self.m_root,"txtLev",WZUILabelTTF)
	local stongProgress = GetElement(self.m_root,"stongProgress",WZUIProgress)
	local txtStongCount = GetElement(self.m_root,"txtStongCount",WZUILabelTTF)
	txtLev:setText("Lv."..self.m_nInitCurLevel)

	local temp_exp = curExp
	if isAdd == true then
		local init_exp = self:getSunExp(curLevel)
		temp_exp = curExp - init_exp
	end
	
	stongProgress:setPercentage(temp_exp/totleExp * 100)
	txtStongCount:setText(temp_exp.."/"..totleExp)

	local txtStrongLev = GetElement(self.m_root,"txtStrongLev",WZUIFreeTextBox)
	local str = [[<T C="127,70,26" S="20" P="1">%s</T><T C="229,105,22" S="20" P="1"> %d</T><BL>16</BL><I Z="0.8">ui/common/common_icon_jiehunjiantou.png</I><BL>16</BL><T C="5,180,0" S="20" P="1">%d</T>]]
	txtStrongLev:setShowText(string.format(str,LocalStrings.MOUNTSTONE_TEXT12,self.m_nInitCurLevel,curLevel))
end
--计算当前等级之前的经验之和
function WndMountStoneStong:getSunExp(lev)
	local sum = 0
	for i=1, #self.m_tMainStoneData[self.m_nMainStoneQuality] do
		if self.m_tMainStoneData[self.m_nMainStoneQuality][i].lv < lev then
			sum = sum + self.m_tMainStoneData[self.m_nMainStoneQuality][i].exp_need
		end
	end
	return sum
end

function WndMountStoneStong:getSunExp1(lev, quality)
	local sum = 0
	for i=1, #self.m_tMainStoneData[quality] do
		if self.m_tMainStoneData[quality][i].lv <= lev then
			sum = sum + self.m_tMainStoneData[quality][i].exp_need
		end
	end
	return sum
end
--最大等级的时候
function WndMountStoneStong:setMaxProgress()
	if self.m_nCurLevel >= self.m_nHasEffectMaxLevel then
		self:setShowMax()
	end
end
function WndMountStoneStong:setShowMax()
	if not self.m_root then return end

	GetElement(self.m_root,"stongProgress",WZUIProgress):setPercentage(100)
	GetElement(self.m_root,"txtStongCount",WZUILabelTTF):setText("Max")
	GetElement(self.m_root,"txtLev",WZUILabelTTF):setText("Lv."..self.m_nInitCurLevel)
	local txtStrongLev = GetElement(self.m_root,"txtStrongLev",WZUIFreeTextBox)
	local str = [[<T C="127,70,26" S="20" P="1">%s</T><T C="229,105,22" S="20" P="1"> %d</T>]]
	txtStrongLev:setShowText(string.format(str,LocalStrings.MOUNTSTONE_TEXT12,self.m_nCurLevel))
end

function WndMountStoneStong:onItemClick( tCell,tag,tData )
	if tData == nil then
       return
    end

    tag = tag + 1
    local add_exp = 0
    if self.m_nCurLevel >= self.m_nHasEffectMaxLevel then
    	if self.m_tChooseCellPos[tData.playerItemId] and tData.subtype ~= 14 then
	    	tCell:setItemSelState(false)
			if tData.subtype >= 1 and tData.subtype <= 8 then
				if tData.extraInfo.strongLevel > 0 then
					local temp_num = math.ceil((self:getSunExp1(tData.extraInfo.strongLevel-1,tData.basicInfo.quality) + tData.extraInfo.strongExp)*0.8)
					add_exp = temp_num + math.ceil(temp_num * self.m_nRaiseExpProporte)
				else
					local stone_info = GDatatab_sprite_stone["id_"..tData.extraInfo.spriteStoneConfigId]
					if stone_info then
						add_exp = stone_info.exp_provide * tData.lastNum
						add_exp = add_exp + math.ceil(add_exp * self.m_nRaiseExpProporte)
					end
				end
			elseif tData.subtype >= 9 and tData.subtype <= 13 then
				local stone_info = GDatatab_sprite_stone_source["id_"..tData.extraInfo.spriteStoneConfigId]
				if stone_info then
					add_exp = stone_info.exp_provide * tData.lastNum
					add_exp = add_exp + math.ceil(add_exp * self.m_nRaiseExpProporte)
				end
			end
			self.m_nCurExp = self.m_nSaveInitExp + self.m_nCurExp - add_exp
			self.m_tChooseCellPos[tData.playerItemId] = nil
			self.m_tChooseItemId[tData.playerItemId] = nil
			self.m_tChooseItemNum[tData.playerItemId] = nil

			
			local configId = self:setExpRange1(self.m_nCurExp)

			local stone_info = GDatatab_sprite_stone["id_"..configId]
			if stone_info then
				self.m_nCurLevel = stone_info.lv
				if self.m_nCurLevel >= self.m_nHasEffectMaxLevel then
				else
					self.m_nTotleExp = stone_info.exp_need
					self.m_nMainStoneConfigId = stone_info.id
				end
			end
		    self:setStongProgress(self.m_nCurLevel, self.m_nCurExp, self.m_nTotleExp, self.m_nSaveInitExp, true)
		    self.m_nCurExp = self.m_nCurExp - self.m_nSaveInitExp
			self:setMaxProgress()
		else
	    	MsgBoxManager:showTipBox(LocalStrings.REACH_MAX_STRONG_LEVLE)
	    end
	    return
    end
    --经验石的时候
    if tData.subtype == 14 then
    	tCell:setReduce(true)
		if self.m_nChooseStoneCount[tData.playerItemId] == nil then
			self.m_nChooseStoneCount[tData.playerItemId] = 0
		end
		self.m_nChooseStoneCount[tData.playerItemId] = self.m_nChooseStoneCount[tData.playerItemId] + 1
		if self.m_nChooseStoneCount[tData.playerItemId] > tData.lastNum then
			self.m_nChooseStoneCount[tData.playerItemId] = tData.lastNum
		    return
		end
		self.m_tChooseItemId[tData.playerItemId] = tData.playerItemId
		self.m_tChooseItemNum[tData.playerItemId] = self.m_nChooseStoneCount[tData.playerItemId]
		self.m_nCurExp = self.m_nSaveInitExp + self.m_nCurExp + tData.basicInfo.value + math.ceil(tData.basicInfo.value * self.m_nRaiseExpProporte)
    else
	    if self.m_tChooseCellPos[tData.playerItemId] == nil then
	    	self.m_tChooseCellPos[tData.playerItemId] = true
			tCell:setItemSelState(true)
	    	self.m_tChooseItemId[tData.playerItemId] = tData.playerItemId
			self.m_tChooseItemNum[tData.playerItemId] = tData.lastNum

			if tData.subtype >= 1 and tData.subtype <= 8 then
				if tData.extraInfo.strongLevel > 0 then
					local temp_num = math.ceil((self:getSunExp1(tData.extraInfo.strongLevel-1, tData.basicInfo.quality) + tData.extraInfo.strongExp)*0.8)
					add_exp = temp_num + math.ceil(temp_num * self.m_nRaiseExpProporte)
				else
					local stone_info = GDatatab_sprite_stone["id_"..tData.extraInfo.spriteStoneConfigId]
					if stone_info then
						add_exp = stone_info.exp_provide * tData.lastNum
						add_exp = add_exp + math.ceil(add_exp * self.m_nRaiseExpProporte)
					end
				end
			elseif tData.subtype >= 9 and tData.subtype <= 13 then
				local stone_info = GDatatab_sprite_stone_source["id_"..tData.extraInfo.spriteStoneConfigId]
				if stone_info then
					add_exp = stone_info.exp_provide * tData.lastNum
					add_exp = add_exp + math.ceil(add_exp * self.m_nRaiseExpProporte)
				end
			end
			self.m_nCurExp = self.m_nSaveInitExp + self.m_nCurExp + add_exp
	    else
	    	tCell:setItemSelState(false)
			if tData.subtype >= 1 and tData.subtype <= 8 then
				if tData.extraInfo.strongLevel > 0 then
					local temp_num = math.ceil((self:getSunExp1(tData.extraInfo.strongLevel-1,tData.basicInfo.quality) + tData.extraInfo.strongExp)*0.8)
					add_exp = temp_num + math.ceil(temp_num * self.m_nRaiseExpProporte)
				else
					local stone_info = GDatatab_sprite_stone["id_"..tData.extraInfo.spriteStoneConfigId]
					if stone_info then
						add_exp = stone_info.exp_provide * tData.lastNum
						add_exp = add_exp + math.ceil(add_exp * self.m_nRaiseExpProporte)
					end
				end
			elseif tData.subtype >= 9 and tData.subtype <= 13 then
				local stone_info = GDatatab_sprite_stone_source["id_"..tData.extraInfo.spriteStoneConfigId]
				if stone_info then
					add_exp = stone_info.exp_provide * tData.lastNum
					add_exp = add_exp + math.ceil(add_exp * self.m_nRaiseExpProporte)
				end
			end
			self.m_nCurExp = self.m_nSaveInitExp + self.m_nCurExp - add_exp
			self.m_tChooseCellPos[tData.playerItemId] = nil
			self.m_tChooseItemId[tData.playerItemId] = nil
			self.m_tChooseItemNum[tData.playerItemId] = nil
	    end
	end
	
	local configId = self:setExpRange1(self.m_nCurExp)
	local stone_info = GDatatab_sprite_stone["id_"..configId]
	if stone_info then
		self.m_nCurLevel = stone_info.lv
		if self.m_nCurLevel >= self.m_nHasEffectMaxLevel then
		else
			self.m_nTotleExp = stone_info.exp_need
			self.m_nMainStoneConfigId = stone_info.id
		end
	elseif configId == -1 then
		self.m_nCurLevel = self.m_nHasEffectMaxLevel
		local configId = self.m_tMainStoneData[self.m_nMainStoneQuality][self.m_nHasEffectMaxLevel].id
		local stone_info = GDatatab_sprite_stone["id_"..configId]
		if stone_info then
			self.m_nTotleExp = stone_info.exp_need
			self.m_nMainStoneConfigId = stone_info.id
		end
	end

    self:setStongProgress(self.m_nCurLevel, self.m_nCurExp, self.m_nTotleExp, self.m_nSaveInitExp, true)
    self.m_nCurExp = self.m_nCurExp - self.m_nSaveInitExp

	self:setMaxProgress()
end
--减经验石的时候
--_type 1:加  2:减
function WndMountStoneStong:setExpStone(tag, itenData, txtNode, _type)
	if _type == 2 then
		tag = tag + 1
		self.m_nChooseStoneCount[itenData.playerItemId] = self.m_nChooseStoneCount[itenData.playerItemId] - 1

		if self.m_tChooseItemId[itenData.playerItemId] then
			self.m_nCurExp = self.m_nSaveInitExp + self.m_nCurExp - itenData.basicInfo.value - math.ceil(itenData.basicInfo.value * self.m_nRaiseExpProporte)
			local configId = self:setExpRange1(self.m_nCurExp)
			local stone_info = GDatatab_sprite_stone["id_"..configId]
			if stone_info then
				self.m_nTotleExp = stone_info.exp_need
				self.m_nCurLevel = stone_info.lv
				self.m_nMainStoneConfigId = stone_info.id
			end
		    self:setStongProgress(self.m_nCurLevel, self.m_nCurExp, self.m_nTotleExp, self.m_nSaveInitExp, true)
		    self.m_nCurExp = self.m_nCurExp - self.m_nSaveInitExp
		end
		self.m_tChooseItemNum[itenData.playerItemId] = self.m_nChooseStoneCount[itenData.playerItemId]
		if self.m_nChooseStoneCount[itenData.playerItemId] <= 0 then
			self.m_nChooseStoneCount[itenData.playerItemId] = 0
			if txtNode then
				txtNode:setText(self.m_nChooseStoneCount[itenData.playerItemId].."/"..itenData.lastNum)
			end
			self.m_tChooseItemId[itenData.playerItemId] = nil
			return
		end
	end
	if txtNode then
		txtNode:setText(self.m_nChooseStoneCount[itenData.playerItemId].."/"..itenData.lastNum)
	end
end
--根据经验计算出唯一的id
function WndMountStoneStong:setExpRange1(exp)
	local quality = self.m_nMainStoneQuality or 1
	local config = -1
	if exp < self.m_tMainStoneData[quality][1].exp_need then
		return self.m_tMainStoneData[quality][1].id
	else
		local _exp = 0
		for i=1,#self.m_tMainStoneData[quality] do
			_exp = _exp + self.m_tMainStoneData[quality][i].exp_need
			if _exp > exp then
				return self.m_tMainStoneData[quality][i].id
			end
		end
	end
	return config
end

function WndMountStoneStong:onBtnQuickSet( ... )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndMountStoneQuick:showInterface()
end
function WndMountStoneStong:onBtnQuick( ... )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local max_exp = self.m_tMainStoneData[self.m_nMainStoneQuality][self.m_nHasEffectMaxLevel].exp_need
 	if self.m_nIsHasEffect and self.m_nIsHasEffect == 0 then
    	max_exp = self.m_tMainStoneData[self.m_nMainStoneQuality][10].exp_need
    end
    if self.m_nCurLevel >= self.m_nHasEffectMaxLevel then
    	MsgBoxManager:showTipBox(LocalStrings.REACH_MAX_STRONG_LEVLE)
    	return
    end
	
	self.m_tChooseItemId = {}
	self.m_tChooseItemNum = {}
	self.m_tChooseCellPos = {}
	local init_exp = self.m_nQualityInitExp
	local max_info = self.m_tMainStoneData[self.m_nMainStoneQuality][self.m_nHasEffectMaxLevel]
	for i,v in pairs(self.m_tChooseCellItem) do
		if v and v.m_root then
			v:setItemSelState(false)
		end
	end

	for i,v in pairs(self.m_tStrongUpgradeData) do
		if self.m_tChooseCellItem[v.playerItemId] then
			-- 紫色及以上主石和 品质>50副石 只能手动选择
			if (v.basicInfo.quality >= 3 and v.subtype >= 1 and v.subtype <= 8) or (v.subtype >= 9 and v.subtype <= 13 and v.extraInfo.spriteStoneQuality >= 50) then
			else
				if self.m_nCurLevel >= self.m_nHasEffectMaxLevel then
					MsgBoxManager:showTipBox(LocalStrings.REACH_MAX_STRONG_LEVLE)
    				return
				else
					if self.m_tQuickChooseData[1] == true and v.subtype == 14 then --默认的经验石
						self.m_tChooseCellItem[v.playerItemId]:setReduce(true)
						if self.m_nChooseStoneCount[v.playerItemId] == nil then --经验石的类型
							self.m_nChooseStoneCount[v.playerItemId] = 0
						end
						self.m_tChooseCellPos[v.playerItemId] = true

						self.m_tChooseItemId[v.playerItemId] = v.playerItemId
						for i=1, v.lastNum do
							self.m_nChooseStoneCount[v.playerItemId] = i
							self.m_tChooseCellItem[v.playerItemId]:setTxtReduceNumber(self.m_nChooseStoneCount[v.playerItemId], v.lastNum)
							self.m_tChooseItemNum[v.playerItemId] = i

							init_exp = init_exp + (v.basicInfo.value + math.ceil(v.basicInfo.value * self.m_nRaiseExpProporte) )
							self:setCalculatMax(init_exp)
							if self.m_nCurLevel >= self.m_nHasEffectMaxLevel then
								self:setShowMax()
								MsgBoxManager:showTipBox(LocalStrings.REACH_MAX_STRONG_LEVLE)
			    				return
			    			end
						end
					end
					if self.m_tQuickChooseData[2] == true and v.basicInfo.quality == 1 then --绿色
						self.m_tChooseCellItem[v.playerItemId]:setItemSelState(true)
						self.m_tChooseItemId[v.playerItemId] = v.playerItemId
						self.m_tChooseItemNum[v.playerItemId] = v.lastNum
						if self.m_tChooseCellPos[v.playerItemId] == nil then
							if v.extraInfo.strongLevel > 0 then
								local temp_num = math.ceil((self:getSunExp1(v.extraInfo.strongLevel-1, v.basicInfo.quality) + v.extraInfo.strongExp)*0.8)
								init_exp = init_exp + temp_num + math.ceil(temp_num * self.m_nRaiseExpProporte)
							else
								local stone_info = GDatatab_sprite_stone["id_"..v.extraInfo.spriteStoneConfigId]
								if stone_info then
									init_exp = init_exp + (stone_info.exp_provide + math.ceil(stone_info.exp_provide * self.m_nRaiseExpProporte)) * v.lastNum
								end
							end
						end
						self.m_tChooseCellPos[v.playerItemId] = true
						self:setCalculatMax(init_exp)
					end
					if self.m_tQuickChooseData[3] == true and v.basicInfo.quality == 2 then --蓝色
						self.m_tChooseCellItem[v.playerItemId]:setItemSelState(true)
						self.m_tChooseItemId[v.playerItemId] = v.playerItemId
						self.m_tChooseItemNum[v.playerItemId] = v.lastNum
						if self.m_tChooseCellPos[v.playerItemId] == nil then
							if v.extraInfo.strongLevel > 0 then
								local temp_num = math.ceil((self:getSunExp1(v.extraInfo.strongLevel-1, v.basicInfo.quality) + v.extraInfo.strongExp)*0.8)
								init_exp = init_exp + temp_num + math.ceil(temp_num * self.m_nRaiseExpProporte)
							else
								local stone_info = GDatatab_sprite_stone["id_"..v.extraInfo.spriteStoneConfigId]
								if stone_info then
									init_exp = init_exp + (stone_info.exp_provide + math.ceil(stone_info.exp_provide * self.m_nRaiseExpProporte)) * v.lastNum
								end
							end
						end
						self.m_tChooseCellPos[v.playerItemId] = true
						self:setCalculatMax(init_exp)
					end
					if self.m_tQuickChooseData[4] == true and (v.subtype >= 9 and v.subtype <= 13 and v.extraInfo.spriteStoneQuality < 50) then
						self.m_tChooseCellItem[v.playerItemId]:setItemSelState(true)
						self.m_tChooseItemId[v.playerItemId] = v.playerItemId
						self.m_tChooseItemNum[v.playerItemId] = v.lastNum
						if self.m_tChooseCellPos[v.playerItemId] == nil then
							local stone_info = GDatatab_sprite_stone_source["id_"..v.extraInfo.spriteStoneConfigId]
							if stone_info then
								init_exp = init_exp + (stone_info.exp_provide + math.ceil(stone_info.exp_provide * self.m_nRaiseExpProporte)) * v.lastNum
							end
						end
						self.m_tChooseCellPos[v.playerItemId] = true
						self:setCalculatMax(init_exp)
					end
				end
			end
		end
	end
	local choose_status = false
	for i,v in pairs(self.m_tChooseItemId) do
		if v then
			choose_status = true
			break
		end
	end
	if choose_status == false then
		MsgBoxManager:showTipBox(LocalStrings.MOUNTSTONE_TEXT25)
		return
	end
end

--快速选择的计算是否到最大值
function WndMountStoneStong:setCalculatMax(init_exp)
	init_exp = init_exp + self.m_nSaveInitExp
	local configId = self:setExpRange1(init_exp)
	if configId == -1 then
		self.m_nCurLevel = self.m_nHasEffectMaxLevel
	else
		local stone_info = GDatatab_sprite_stone["id_"..configId]
		if stone_info then
			self.m_nCurLevel = stone_info.lv
			if self.m_nCurLevel >= self.m_nHasEffectMaxLevel then
				self.m_nTotleExp = stone_info.exp_need
				self.m_nMainStoneConfigId = stone_info.id
			else
				self.m_nTotleExp = stone_info.exp_need
				self.m_nMainStoneConfigId = stone_info.id
			end
		end
		self:setStongProgress(self.m_nCurLevel, init_exp, self.m_nTotleExp, self.m_nSaveInitExp, true)
		self.m_nCurExp = init_exp - self.m_nSaveInitExp
	end
	if configId == -1 then
		self.m_nCurExp = self:getSunExp(self.m_nCurLevel)
	end
	self:setMaxProgress()	
end

function WndMountStoneStong:onBtnStrong( ... )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local ids = {}
	for i,v in pairs(self.m_tChooseItemId) do
		if v then
			table_insert(ids, v)
		end
	end
	if next(ids) == nil then
		MsgBoxManager:showTipBox(LocalStrings.MOUNTSTONE_TEXT20)
		return
	end
	local nums = {}
	for i,v in pairs(self.m_tChooseItemNum) do
		if v and v ~= 0 then
			table_insert(nums, v)
		end
	end
	ProtocolProcessorScenePets:send_MOUNTS_StoneUpgrade(self.m_nPlayerItemId, TableToVector(ids, WZLuaVector_int_), TableToVector(nums, WZLuaVector_int_))
end

function WndMountStoneStong:onBtnClose( ... )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndMountStoneStong:_onStoneUpgrade(playerItemId, lv, exp, consumeItemId, consumeNum, effectConfig)
	local info = GDatatab_sprite_stone_effect["id_"..effectConfig]
	if info then
		MsgBoxManager:showTipBox(info.des)
	end
	if self.m_sItemTableContainer then
		local imgStrongSccess = GetElement(self.m_root,"imgStrongSccess",WZUIImage)
		imgStrongSccess:setVisible(true)
		imgStrongSccess:setScale(1)
		local actionTo = CCScaleTo:create(0.6, 0)
		imgStrongSccess:runAction(actionTo)

		self.m_sItemTableContainer:cleanTable()
		local data = CacheCenter:getMountStoneList()

		local exp_need,configId = 0,0
		if lv == 0 then
			lv = self.m_nCurLevel
		end
		for i=1,#self.m_tMainStoneData[self.m_nMainStoneQuality] do
			if lv == self.m_tMainStoneData[self.m_nMainStoneQuality][i].lv then
				exp_need = self.m_tMainStoneData[self.m_nMainStoneQuality][i].exp_need
				configId = self.m_tMainStoneData[self.m_nMainStoneQuality][i].id
				break
			end
		end
		self.m_nInitCurLevel = lv
		self:setStongProgress(lv, exp, exp_need, 0)
		self.m_nCurLevel = lv
		self.m_nCurExp = exp
		self.m_nTotleExp = exp_need
		self.m_nMainStoneConfigId = configId

		local max_lev = self.m_tMainStoneData[self.m_nMainStoneQuality][self.m_nHasEffectMaxLevel].lv
	    if lv > max_lev then
	    	local max_exp = self.m_tMainStoneData[self.m_nMainStoneQuality][self.m_nHasEffectMaxLevel].exp_need
	    	self.m_nCurLevel = lv
			self.m_nCurExp = max_exp
			self.m_nTotleExp = max_exp
			self:setShowMax()
		end

		local init_exp = self:getSunExp(lv)
		self.m_nSaveInitExp = init_exp
		
		local data1 = CacheCenter:getMountStoneSourceList()
		local temp_data = self:setMergeTables(data, data1)
		self:setSortData(temp_data)

		self.m_tStrongUpgradeData = temp_data
		for i=1,#temp_data do
			delayRun(self.m_root, i / DEFAULT_FPS,function ()
				local celElement,tCell = CellGoodItem:createElement()
				celElement:setTag(i-1)
				self.m_tChooseCellItem[temp_data[i].playerItemId] = tCell
		        self.m_sItemTableContainer:setCellElement(celElement)
		        tCell:setItemClickFun(self, self.onItemClick)
				
				--经验石的时候
		        if temp_data[i].subtype == 14 then
		        	tCell:setReduceCallFunc(function(tag, itenData, txtNode, _type)
		        		self:setExpStone(tag, itenData, txtNode, _type)
		        	end)
				end
				tCell:setCellGoodItem(temp_data[i], 2)
				if temp_data[i].subtype >= 9 and temp_data[i].subtype <= 13 then
					tCell:setVisibleItemCount(temp_data[i].extraInfo.spriteStoneQuality)
					tCell:clearItemQualityPic(nil, temp_data[i].extraInfo.spriteStoneQuality)
				end
				tCell:setTouchHeightVisible(false)
			end)
		end
		self.m_tChooseCellPos = {}
		self.m_tChooseItemId = {}
		self.m_tChooseItemNum = {}
		self.m_nChooseStoneCount = {}
	end	
end


-------------------------------------私有方法模块End----------------------------------------
