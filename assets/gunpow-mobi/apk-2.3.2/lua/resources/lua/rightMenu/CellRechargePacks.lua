--CellRechargePacks.lua
--@brief	CellRechargePacks的UI模块
--@date		2017/05/28
--@author	 
--@note		充值礼包


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRechargePacks:onEnter(element)
	self.m_root = element
	self:initUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRechargePacks:onExit(element)
	self:_unInit()
end

function CellRechargePacks:initUI()
	WZLog("CellRechargePacks:initUI")
	local GetElement = GetElement
	local tabRechargePacksList = GetElement(self.m_root,"tabRechargePacksList_CellRechargePacks",WZUITableContainer)
	tabRechargePacksList:cleanTable()

	for i,v in ipairs(self.m_tData) do
		local conRechargePack = CreateElement("conRechargePack_CellRechargePacks")
		conRechargePack:setTag(i-1)
		conRechargePack:setVisible(true)
		
		local eItem, tItem = CellGoodItem:createElement()
		eItem:setScale(1)
		--tItem:setFromTag(nIndex-1)
		tItem:setItemClickFun(self, self.onClickListItem)
		local tData = {
		    id = v[11],
		    isUse = false,
		    data = "",
		    playerItemId = -1,
		    basicInfo = GetItemLocalData(v[11])
		}
		tItem:setCellGoodItem(tData, 2)

		local conItem = GetElement(conRechargePack,"conItem_CellRechargePacks",WZUIContainer)
		conItem:addChild(eItem)

		local txtPackName = GetElement(conRechargePack,"txtPackName_CellRechargePacks",WZUILabelTTF)
		txtPackName:setText(v[8])
		
		local txtMonenyCount = GetElement(conRechargePack,"txtMonenyCount_CellRechargePacks",WZUILabelTTF)
		txtMonenyCount:setText(v[10])
		local btnGet = GetElement(conRechargePack,"btnGet_CellRechargePacks",WZUIButton)

		if v[13] <= 0  then
			local imgStats = GetElement(conRechargePack,"imgStats_CellRechargePacks",WZUIImage)
			imgStats:setVisible(true)

			local conGet = GetElement(conRechargePack,"conGet_CellRechargePacks",WZUIContainer)
			conGet:setVisible(false)

			
			btnGet:setVisible(false)
		end
		GetElement(conRechargePack,"btn_CellRechargePacks",WZUIButton):setTag(i)
		btnGet:setTag(i)

		tabRechargePacksList:setCellElement(conRechargePack)
	end
	local gameParam = CacheCenter:getGameParam()
	local tTempStart = SplitStringWithSeparator(gameParam.nianGifeStar,"-")
    local tTempEnd = SplitStringWithSeparator(gameParam.nianGifeEnd,"-")
    
    local timeT = {}
        timeT.year = tonumber(tTempStart[1])
        timeT.month = tonumber(tTempStart[2])
        timeT.day = tonumber(tTempStart[3])
        timeT.hour = 0
        timeT.min = 0
        timeT.sec = 0
    local tempppppStart = os.time(timeT)

    timeT = {}
        timeT.year = tonumber(tTempEnd[1])
        timeT.month = tonumber(tTempEnd[2])
        timeT.day = tonumber(tTempEnd[3])
        timeT.hour = 0
        timeT.min = 0
        timeT.sec = 0
    local tempppppEnd = os.time(timeT)

    local tempS = os.date("%m.%d",tempppppStart)
    local tempE = os.date("%m.%d",tempppppEnd)
	
	local txtTime = GetElement(self.m_root,"txtTime_CellRechargePacks",WZUILabelTTF)
	txtTime:setText(LocalStrings.ACTIVE_TIME .. "："..tempS .. "-"..tempE)
end

function CellRechargePacks:onRechage(element)
	WZLog("CellRechargePacks:onRechage")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not WndNewActivity:_activityIsExit(88888) then
        MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
        return
    end
	local i = element:getTag()
	local dataT = self.m_tData[i]
	
	local data = {
            ids = dataT[1],
            icons = dataT[2],--icons[i],
            number = dataT[3],
            giftNumber = dataT[4],
            price = dataT[5],
            payCodeId = dataT[6],
            flag = dataT[7],
            name = dataT[8],
            remark = dataT[9],
            showPrice = dataT[10],
            itemId = dataT[11],
            sortId = dataT[12],
            leftTimes = dataT[13],
            limitType = dataT[14],
            needVipLv = dataT[15],
            showType = 1
        }

    local sdkData = self:getSDKData(i)
	local wndVipGift = WndVipGift:createElement()
    if wndVipGift ~= nil then
        WindowManager:addWindow(wndVipGift, WndVipGift, false)
        WndVipGift:setData(data,sdkData)
    end
end

function CellRechargePacks:getSDKData(tag)
	WZLog("CellRechargePacks:getSDKData ",tag)
	local dataT = self.m_tData[tag]
	local itemInfo = GDatatab_item["id_"..dataT[11]]
	local productName = itemInfo.name
	local productDesc = dataT[8]
	local quantifier = LocalStrings.SHOP_IND
	local number = dataT[3]
	if dataT[11] == 50 or dataT[11] == 51 or dataT[11]== 52 or dataT[11]== 55 or dataT[11] == 56 then
		quantifier = LocalStrings.Expand
		number = 1
	end
	local sdkData = {
		id = dataT[1],
		price =dataT[5],
		payCode = dataT[6],
		productName = productName,
		productDesc = productDesc,
		quantifier = quantifier,
		number = math.max(1,number),
		giftNumber = dataT[4],
	}
	return sdkData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
