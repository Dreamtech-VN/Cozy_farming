--CellActMakeWasteProfitable.lua
--@brief	CellActMakeWasteProfitable的UI模块
--@date		2023/03/01
--@author	yrd
--@note		变废为宝活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellActMakeWasteProfitable:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellActMakeWasteProfitable:onExit(element)
	self:_unInit()
end

function CellActMakeWasteProfitable:showWindow()
    self:updateEndTime()
    local txtTimeAtt = GetElement(self.m_root,"txtTimeAtt_CellActMakeWasteProfitable",WZUILabelTTF)
    txtTimeAtt:enableSchedule("updateEndTime", 1)
end

--@brief	更新结束时间
function CellActMakeWasteProfitable:updateEndTime(element)
	local txtTimeAtt = GetElement(self.m_root,"txtTimeAtt_CellActMakeWasteProfitable",WZUILabelTTF)

	local nEndTime = SystemTime:getServerTime()
	if #self.target < 31 then
		while true do
			local bIsOpen = false
			for i=1,#self.target do
				if self.target[i] == tonumber(os.date("%d",(nEndTime + 86400))) then
					bIsOpen = true
					break
				end
			end
			if bIsOpen then
				nEndTime = nEndTime + 86400
			else
				nEndTime = os.time({year=os.date("%Y",nEndTime), month=os.date("%m",nEndTime), day=os.date("%d",nEndTime), hour=23, min=59, sec=59})
				break
			end
		end
		nEndTime = math.min(nEndTime, self.endTime)
	else
		nEndTime = self.endTime
	end
	local nLeftTime = nEndTime - SystemTime:getServerTime()

	if nLeftTime > 86400 then
		local day = math.floor(nLeftTime / 86400)
		txtTimeAtt:setText(string.format(LocalStrings.ACT_MAKE_WASTE_PROFITABLE[2],day))
	elseif nLeftTime > 3600 then
		local hour = math.floor(nLeftTime / 3600)
		txtTimeAtt:setText(string.format(LocalStrings.ACT_MAKE_WASTE_PROFITABLE[3],hour))
	else
		local min = math.ceil(nLeftTime / 60)
		txtTimeAtt:setText(string.format(LocalStrings.ACT_MAKE_WASTE_PROFITABLE[4],min))
	end
end

--@brief	点击前往
function CellActMakeWasteProfitable:onClickGoto()
	WZLog("CellActMakeWasteProfitable:onClickGoto")
	JumpByUIId(300)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
