--CellCommonBox.lua
--@brief	CellCommonBox的UI模块
--@date		2021/02/22
--@author	hyx
--@note		宝箱的进度条


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommonBox:onEnter(element)
	self.m_root = element

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommonBox:onExit(element)
	self:_unInit()
end

function CellCommonBox:onEnterTransitionDidFinish(element)
	local boxContainer = GetElement(self.m_root,"box_container",WZUIContainer)
	local progress = WZUIProgress:create()
	progress:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	progress:setZOrder(1)
	local str_name = {"ui/common/progress_hd_04.png","ui/activity/progress_jqzl_02.png"}
    progress:setBgPicture(str_name[self.m_nBoxType])
	if self.m_nBoxType == 2 then
		boxContainer:setAbsContentSize(GlobalMethod:CCSize(688,14))
		boxContainer:updateRelativeSize()
		GetElement(boxContainer,"imgBoxBg",WZUI9Image):setFile("ui/activity/progress_jqzl_01.png")
	end
	boxContainer:addChild(progress)
	self.m_sBoxCommonProgress = progress
	for i=1,5 do
		local tab = {}
		tab.btnBox = GetElement(boxContainer, "btnBox"..i.."_CellCommonBox", WZUIButton)
		tab.btnBox:setVisible(false)
		tab.imgBox = GetElement(boxContainer, "imgBtn"..i.."_CellCommonBox", WZUIImage)
        tab.imgBox:setVisible(false)
        tab.txtTimes = GetElement(boxContainer, "txtTimes"..i.."_CellCommonBox", WZUILabelTTF)
        tab.armBox = GetElement(boxContainer, "armBox"..i.."_CellCommonBox", WZArmature)
        tab.armBox:setVisible(false)
		self.m_tCreateCommonBox[i] = tab
	end
	self.m_sBoxCommonProgress:setPercentage(0)

	local txtCurCount = GetElement(self.m_root,"txtCurCount",WZUIFreeTextBox)
	local title = self.m_tBoxBaseMsg.title or LocalStrings.FOURSTAR_TEXT6
	local str = string.format([[<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T><T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">0</T>]],title)
	txtCurCount:setShowText(str)
end

--宝箱的状态
local closeBox = {"ui/common/common_icon_djbx1.png","ui/common/common_icon_lan1.png","ui/common/common_icon_zi1.png","ui/common/common_icon_huang1.png","ui/common/common_icon_zis1.png"}
local openBox = {"ui/common/common_icon_djbx2.png","ui/common/common_icon_lan2.png","ui/common/common_icon_zi2.png","ui/common/common_icon_huang2.png","ui/common/common_icon_zis2.png"}
local nullBox = {"ui/common/common_icon_djbx3.png","ui/common/common_icon_lan3.png","ui/common/common_icon_zi3.png","ui/common/common_icon_huang3.png","ui/common/common_icon_zis3.png"}
--[[
dada数据
{
	id = 1 --宝箱的id
	reward_id = { 551,20007,209 } --物品id
	reward_num = { 10, 5, 10 } --物品数量
	status = 0 --状态  -1未领取  0可领取 1已领取
	tager = 1 --目标数量
}
]]
function CellCommonBox:setInitBoxStatus(count,data)
	count = tonumber(count)
	self.m_nDayTotleCount = count
	self.m_tCommonBoxData = data

	local txtCurCount = GetElement(self.m_root,"txtCurCount",WZUIFreeTextBox)
	local title = self.m_tBoxBaseMsg.title or LocalStrings.FOURSTAR_TEXT6
	local _txt = ""
	if self.m_nBoxType == 2 then
		_txt = LocalStrings.SHOP_CISHU
	end
	local str = string.format([[<T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T><T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s%s</T>]], title, count, _txt)
	txtCurCount:setShowText(str)

	local totle = data[#data].tager
	local percent = count / totle * 100
	local perGapping = math.floor((1 / #data) * 100)
	local reachBoxIndex = 1
	for i=1, #data do
		if i <= 5 and self.m_tCreateCommonBox[i] then 
	        if count <= data[i].tager then
	        	reachBoxIndex = i 
	        	break 
	        end 
		end
	end
	if self.m_tCreateCommonBox[reachBoxIndex] and self.m_sBoxCommonProgress then 
		local lastBoxNum = 0
		if reachBoxIndex > 1 then 
			lastBoxNum = data[reachBoxIndex - 1].tager
		end
        local nTempNum = data[reachBoxIndex].tager - lastBoxNum
        local num = 100 / #data
        percent = perGapping * (reachBoxIndex - 1) + math.floor((count - lastBoxNum) * num/nTempNum) 
		if percent >= 100 then
			percent = 100
		end
    	self.m_sBoxCommonProgress:setPercentage(percent)
    end

	self:setBoxStatus()
end
function CellCommonBox:setBoxStatus()
	if not self.m_tCommonBoxData then return end
	local pos_x = (1 / #self.m_tCommonBoxData)
	
	local box_status = false
	for i=1, #self.m_tCommonBoxData do
		if i > 5 then return end
		if self.m_tCreateCommonBox[i] then
			self.m_tCreateCommonBox[i].btnBox:setVisible(true)
			self.m_tCreateCommonBox[i].btnBox:setRelativePosition(GlobalMethod:ccp(pos_x*i - 0.03, 0.5))

			self.m_tCreateCommonBox[i].txtTimes:setText(self.m_tCommonBoxData[i].tager)
			self.m_tCreateCommonBox[i].armBox:setVisible(self.m_tCommonBoxData[i].status == 0) --领取动画
			self.m_tCreateCommonBox[i].imgBox:setVisible(true)
			
			if self.m_tCommonBoxData[i].status == -1 then
				self.m_tCreateCommonBox[i].imgBox:setFile(closeBox[i])
			elseif self.m_tCommonBoxData[i].status == 0 then
				self.m_tCreateCommonBox[i].imgBox:setFile(openBox[i])
				box_status = true
			elseif self.m_tCommonBoxData[i].status == 1 then
				self.m_tCreateCommonBox[i].imgBox:setFile(nullBox[i])
			end
		end
	end
end

function CellCommonBox:onClickBox(element)
	local index = element:getTag()
	if self.m_tCommonBoxData[index] then
		if self.m_tCommonBoxData[index].status == -1 or self.m_tCommonBoxData[index].status == 1 then
			local data = {}
			data.cur_value = self.m_nDayTotleCount
			data.totle_value = self.m_tCommonBoxData[index].tager
			data.rewardIds = self.m_tCommonBoxData[index].reward_id
			data.rewardNums = self.m_tCommonBoxData[index].reward_num
			WndNewTipsReward:showInterface(self.m_root, element, data)

		elseif self.m_tCommonBoxData[index].status == 0 then
			if self.m_nActivityId then
				ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId, self.m_tCommonBoxData[index].id)
			end
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块begin--------------------------------------
function CellCommonBox:_adaptLanguage_vn()
	local txtCurCount = GetElement(self.m_root,"txtCurCount",WZUIFreeTextBox)
	txtCurCount:setScale(0.7)
end
-------------------------------------语言适配模块end--------------------------------------
