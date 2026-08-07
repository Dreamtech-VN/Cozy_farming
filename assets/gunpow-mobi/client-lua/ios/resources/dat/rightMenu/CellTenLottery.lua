--CellTenLottery.lua
--@brief	CellTenLottery的UI模块
--@date		2016/11/04
--@author	zsq
--@note		装备十连抽活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTenLottery:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief    界面加载完成后回调
function CellTenLottery:onEnterTransitionDidFinish(element)

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTenLottery:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 计算倒计时时间
function CellTenLottery:_caculateTime(  )
    local n_hour = 0
    local n_min = 0
    local n_sec = 0
    local CellTotal_day_value = GetElement(self.m_root,"CellTotal_day_value",WZUILabelTTF)
    local DayStartTab = os.date("*t",self.startTime)
    local DayEndTab = os.date("*t",self.endTime)
	WZLog("CellTenLottery:_caculateTime", DayStartTab, DayEndTab)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)

    CellTotal_day_value:setText(needDay_str)

    local imgBK = GetElement(self.m_root, "imgBK_CellCutePetPanel", WZUIImage)
    if self.m_sContent ~= nil then
        local nStart, nEnd = string.find(self.m_sContent, ".png")
        if nStart then
            if imgBK then
                imgBK:setFile(self.m_sContent)
            end
        end
    end
end

function CellTenLottery:showWindow()
	WZLog("CellTenLottery:showWindow")
    self:_caculateTime()
end

--@brief	跳转
function CellTenLottery:jumpTo()
	WZLog("CellTenLottery:jumpTo")
	JumpByUIId(151)
end
-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配Begin------------------------------------------
function CellTenLottery:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtSummon_CellTenLottery",WZUILabelTTF):setScale(0.7)
end

function CellTenLottery:_adaptLanguage_vn(  )
    GetElement(self.m_root,"CellTotal_day_value",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.45,0.5))
end

function CellTenLottery:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtSummon_CellTenLottery",WZUILabelTTF):setScale(0.7)
end

function CellTenLottery:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtSummon_CellTenLottery",WZUILabelTTF):setScale(0.65)
end
-------------------------------------语言适配End--------------------------------------------