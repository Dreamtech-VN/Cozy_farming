--WndMounts.lua
--@brief	WndMounts的UI模块
--@date		2015-12-4
--@author	binshao
--@note		坐骑模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMounts:onEnter(element)
	WZLog("WndMounts:onEnter")
	self.m_root = element
    ProtocolProcessorWndMounts:send_MOUNTS_GetAllMountsList()
    CacheCenter:registerUpatePlayerInfoObserver(self)--注册人物
    self:_addTop()

    --新手定推礼包入口
    local conForMount = GetElement(self.m_root, "conForMount_WndMounts", WZUIContainer)
    CreateLimitPackage(28, conForMount, GlobalMethod:ccp(0.1, 0.93))

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(19)
    WZLog("WndMounts:onEnter", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 26 then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999, 0 )
        WZLog("WndMounts:onEnter2")
    end

    AdaptLanguage(self)

    self:updatePartner()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMounts:onExit(element)
	WZLog("WndMounts:onExit")
    CacheCenter:unregisterUpatePlayerInfoObserver(self)
	self:_unInit()
end

--@brief  更新伙伴
function WndMounts:updatePartner()
  local check1 = GetElement(self.m_root,"checkbox1_WndPartner",WZUICheckBox)
  local check2 = GetElement(self.m_root,"checkbox2_WndPartner",WZUICheckBox)
  local check3 = GetElement(self.m_root,"checkbox3_WndPartner",WZUICheckBox)

  if not CheckButtonOpen(ISLAND_RIGHT_FOOTMARK, true) then
    check3:setVisible(false)
  end

  SceneCity:setRedPoint(check1, CacheCenter:getRedState("btnPet"), GlobalMethod:ccp(115,55))
  SceneCity:setRedPoint(check3, CacheCenter:getRedState("btnFootMark"), GlobalMethod:ccp(115,55))
end

--@brief  宠物被选中时调用的函数
function WndMounts:onPetSelect(element)
  if WndPets.m_root == nil then
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local wndPets = WndPets:createElement()
    if wndPets ~= nil then
        WindowManager:addWindow(wndPets, WndPets, false)
    end
    if WndMounts.m_root then
      WindowManager:removeWindow(WndMounts.m_root, WndMounts, true)
    end
    if WndFootMark.m_root then
      WindowManager:removeWindow(WndFootMark.m_root, WndFootMark, true)
    end
  end
  
end

--@brief  坐骑被选中时调用的函数
function WndMounts:onMountSelect(element)
  if WndMounts.m_root == nil then
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local wndMounts = WndMounts:createElement()
    if wndMounts ~= nil then
        WindowManager:addWindow(wndMounts, WndMounts, false)
    end
    if WndPets.m_root then
      WindowManager:removeWindow(WndPets.m_root, WndPets, true)
    end
    if WndFootMark.m_root then
      WindowManager:removeWindow(WndFootMark.m_root, WndFootMark, true)
    end
  end
end

--@brief  足迹被选中时调用的函数
function WndMounts:onFootSelect(element)
  if WndFootMark.m_root == nil then
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local wndFootMark = WndFootMark:createElement()
    if wndFootMark ~= nil then
        WindowManager:addWindow(wndFootMark, WndFootMark, false)
    end
    if WndPets.m_root then
      WindowManager:removeWindow(WndPets.m_root, WndPets, true)
    end
    if WndMounts.m_root then
      WindowManager:removeWindow(WndMounts.m_root, WndMounts, true)
    end
  end
end

function WndMounts:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/pet/commom_icon_hb3.png",WndMounts,WndMounts.onReturn,true,false,false,"WndMounts")
end

--@brief	关闭按钮回调事件
function WndMounts:onCloseActionCallback(element,data)
    WindowManager:removeWindow(self.m_root, self, true)
end

-- 返回
function WndMounts:onReturn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)


    -- 更新红点状态
    CacheCenter:mountDescRedPoint()
    GlobalGame:getBtnRedPointEvent():dispatcher()

--    local conTop = GetElement(self.m_root,"conTop_WndMounts",WZUIContainer)
--    WindowManagerAni:createTopAction(conTop,1)

    local leftCon = GetElement(self.m_root,"conMountInfo_WndMounts",WZUIContainer)
    WindowManagerAni:createSwitchTabAction(leftCon,0,true,nil,self,self.onCloseActionCallback,true)
end

function WndMounts:onClickMount()
    WZLog("------------play ani mount------------------")
    local mountId = self.m_tHorses[self.curSelIndex].id
	local item_id = GDatatab_mounts["id_"..mountId].item_id
    local aniType = GDatatab_item["id_"..item_id].sub_type

	--魔幻麋鹿特殊处理
	if item_id == 10056 then
    	local node = self.mountAni:getAnimNode()
		if self.walking then
			self.walking = false
    		node:stopAllActions()
    		self.mountAni:play("wait", true)
		else
			self:walk()
		end
		return
	end

    WZLog("--------------id , aniTYpe--------------",mountId,aniType)
    local name = "walk"
    if aniType == 1 then
        name = "wait"
    elseif aniType == 2 then
        name = "walk2"
    elseif aniType == 3 then
        name = "walk3"
    elseif aniType == 4 then
         name = "walk4"
    end
    self.mountAni:play(name,false)
    self.m_root:enableSchedule("judgeAniFinish",0)
end

function WndMounts:judgeAniFinish()
    --if not self.mountAni:isPlaying() then
    local isEnd = self.mountAni:isCurrentAnimationDone()
    if isEnd == true then
        self.mountAni:play("wait",true)
        self.m_root:disableSchedule()
     --   end
    end
end

-- 点击响应
function WndMounts:onBegin(element, pt)
	WZLog("WndMounts:onBegin")
    if WndTips then
		WndTips:onCloseClick()
    end
    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
end

-- 点击解锁
function WndMounts:onUnlock()
    WZLog("---------------onUnlock------------",self.curSelIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local curTcell = self.m_MountsList[self.curSelIndex].tcell
    curTcell:onUnlock()
    self:updateMountInfo()

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(19)
    WZLog("WndMounts:onUnlock", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 26 then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999, 0 )
        WZLog("WndMounts:onUnlock2")
    end
end

-- 升级
function WndMounts:onUpLevel()
    WZLog("-----------------upLevel------------------",self.curSelIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndMountsCenter:showWndUI(self.m_tHorses[self.curSelIndex],1)

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(19)
    WZLog("WndMounts:onUpLevel", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 26 then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999, 0 )
        WZLog("WndMounts:onUpLevel2")
    end
end

-- 进阶
function WndMounts:onAddStar()
    WZLog("-----------------addStar------------------",self.curSelIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndMountsCenter:showWndUI(self.m_tHorses[self.curSelIndex],2)
end

-- 点击查看战斗力
function WndMounts:onCheckMountInfo(element)
    WZLog("WndMounts:onCheckMountInfo")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local parent = GetElement(self.m_root,"conMountsFight_WndMounts",WZUIContainer)
	local tData = {attack=0,defend=0,hp=0,critRate=0,reduceCrit=0 }
	for k,v in pairs(self.m_tHorses) do
        -- 对属性数据进行修改
        if v.isHave then
            local t = self:_getProperty(v.property)
            tData.attack = tData.attack + t.attack
            tData.defend = tData.defend + t.defend
            tData.hp = tData.hp + t.hp
            tData.critRate = tData.critRate + t.crit
            tData.reduceCrit = tData.reduceCrit + t.reduceCrit
        end
    end
	WndTips:show(element,parent,6,tData,GlobalMethod:ccp(110,120))
end

--@brief  打开坐骑属性界面
function WndMounts:openMounts(info)
    WndMountsCenter:showWndUI(info,1)
--	local wnd = WndMountsCenter:createElement()
--	WindowManager:addWindow(wnd, WndMountsCenter,true,nil,nil)
--    WndMountsCenter:setMountsData(info)
end

-- 乘骑与取消乘骑
function WndMounts:changeMountsState(mountsId)
    for i = 0, mountsId:size()-1 do
        local id = mountsId:get(i)
        self:updateByCacheCenterById(id)
        self:_updateSingleCell(id,true)
    end

    -- 坐骑特效
    local spine = GetElement(self.m_root,"spineDress_WndMounts",WZUISpine)
    spine:play("2",false)
end

-- 更新坐骑信息，包括（激活、升级、进阶）
function WndMounts:updateNewMountsData(id,originType,isResult)
    -- 当不在主城界面收到激活消息不处理
    if not self.m_root then return end

    if originType == 1 or originType == 3 then
        WZLog("---------------new mount add----------------")
        self:initAllMountsData()
        self:_getNewMountAni(id)
    else
        -- 更新数据，更新cell
        WZLog("---------------mount update----------------")
        self:_updateSingleCell(id)
        self:_updateFightingAndLvAndStar()
        -- 假如是进阶或者升级，更新当前界面
        local index,newData = self:getIndexById(id)
        WndMountsCenter:updateMountsUI(newData,isResult)
    end
end

--@brief  点击限时特惠礼包按钮回调
function WndMounts:OpenNewUserPackage(element)
    --body
    OpenNewUserPackage(element)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function WndMounts:_update()
    self:_createMountsList()
    self:_updateFight()
    --self:updateMountInfo()
end

-- 动态创建坐骑列表，一次创建一个
function WndMounts:scheduleCreateMountsList()
    WZLog("------------self.createIndex-------------",self.createIndex)
    local tab = GetElement(self.m_root,"tabList_WndMounts",WZUITableContainer)
    local data = self.m_tHorses[self.createIndex]
    if data then
        local cell , tcell = CellMounts:createElement()
        cell:setTag(self.createIndex-1)
        tab:setCellElement(cell)
        -- 对属性数据进行修改
        if data.isHave then
            local t = self:_getProperty(data.property)
            data.descProperty = t
        end
        tcell:setCellAllElement(data)
        self:setCellData(self.createIndex,cell,tcell)
        self.createIndex = self.createIndex + 1
    end
    if self.createIndex > #self.m_tHorses then
        self:updateMountInfo()
        self.m_root:disableSchedule()
    end
end


-- 一次性创建坐骑列表
function WndMounts:createMountsListOnce()
    local tab = GetElement(self.m_root,"tabList_WndMounts",WZUITableContainer)
    tab:cleanTable()
    for i = 1, #self.m_tHorses do
        local data = self.m_tHorses[i]
        if data then
            local cell , tcell = CellMounts:createElement()
            cell:setTag(i-1)
            tab:setCellElement(cell)
            -- 对属性数据进行修改
            if data.isHave then
                local t = self:_getProperty(data.property)
                data.descProperty = t
            end
            tcell:setCellAllElement(data)
            self:setCellData(i,cell,tcell)
        end
    end
    self:updateMountInfo()

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(19)
    WZLog("WndMounts:onEnter two", isEndTeach, finishStep, Serialize(CacheCenter:getPlayerInfo().allMountsMessage))
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 26 then
        WindowManager:removeTeachShelterLayer()

        local isHaveMounts = false
        if type(CacheCenter:getPlayerInfo().allMountsMessage) == "table" and #CacheCenter:getPlayerInfo().allMountsMessage > 0 then
            isHaveMounts = true
        end
        if isHaveMounts == false then
            TeachGroup1:startGroup({19,4,self.m_root})
        else
            TeachGroup1:startGroup({19,6,self.m_root})
        end
    else
        WindowManager:removeTeachShelterLayer()
    end
end

-- 创建坐骑列表
function WndMounts:_createMountsList()
    local tab = GetElement(self.m_root,"tabList_WndMounts",WZUITableContainer)
    tab:cleanTable()
    self.createIndex = 1
    local haveCnt = 0
    self.m_MountsList = {}
    for i = 1, #self.m_tHorses do
        if self.m_tHorses[i].isHave then
            haveCnt = haveCnt + 1
        end
    end

    -- 显示当前坐骑的数量
    local txtCnt = GetElement(self.m_root,"txtMountCnt_WndMounts",WZUILabelTTF)
    txtCnt:setText(haveCnt.."/"..#self.m_tHorses)

    --self.m_root:enableSchedule("scheduleCreateMountsList",0)
    self:createMountsListOnce()
end

-- 更新战斗力
function WndMounts:_updateFight()
    local fight = 0
    for k,v in pairs(self.m_tHorses) do
        if v.isHave then
            fight = fight + self:getFight(v.property)
            WZLog("------------------_updateFight---------------",fight)
        end
    end
    local labFight = GetElement(self.m_root,"labFireCnt_WndMounts",WZUILabelAtlasFont)
    labFight:setText(fight)
end

-- 更新坐骑信息
function WndMounts:updateMountInfo(moundId)
    if moundId then
        if self.m_curSelMountId  == moundId then return end
        self.m_curSelMountId  = moundId
    else
        if self.m_curSelMountId == nil then
            self.m_curSelMountId  = self.m_tHorses[1].basicInfo.id
            self.curSelIndex = 1
        end
    end

    local data = nil
    WZLog("asdfjkd ",self.m_curSelMountId)
    for i,v in ipairs(self.m_tHorses) do
        if self.m_curSelMountId == v.basicInfo.id then
            data = v
            self.curSelIndex = i
            break
        end
    end

    self:_updateCellSel()
    
    local state = {data.isHave,not data.isHave}
    for i = 1, 2 do
        local conInfo = GetElement(self.m_root,"conInfo"..i.."_WndMounts",WZUIContainer)
        local conBtn = GetElement(self.m_root,"conBtn"..i.."_WndMounts",WZUIContainer)
        conInfo:setVisible(state[i])
        conBtn:setVisible(state[i])
    end

    if data.isHave then
        -- 名字和等级
        local txtName = GetElement(self.m_root,"txtMountName_WndMounts",WZUILabelTTF)
        local txtLv = GetElement(self.m_root,"txtMountLv_WndMounts",WZUILabelTTF)
        local maxLv = self:_getMountMaxLevel(data)
        txtName:setText(data.basicInfo.name)
        txtName:setColor(QUALITYCOLOR[data.basicInfo.quality])
        txtLv:setText("Lv"..data.upgradeLevel.."/"..maxLv)
        txtLv:setColor(QUALITYCOLOR[data.basicInfo.quality])

        -- 星级
        local starCnt = data.advancedLevel
        local imgPath = {"ui/common/common_icon_xingxing2.png","ui/common/common_icon_xingxing3.png" }
        for i =1, 10 do
            local index = starCnt >= i and 1 or 2
            local star = GetElement(self.m_root,"imgStar"..i.."_WndMounts",WZUIImage)
            star:setFile(imgPath[index])
        end
    else
        local txtName = GetElement(self.m_root,"txtMountName2_WndMounts",WZUILabelTTF)
        txtName:setText(data.basicInfo.name)
        txtName:setColor(QUALITYCOLOR[data.basicInfo.quality])

        local data = self.m_MountsList[self.curSelIndex].tcell:getWayResult()
        WZLog("WndMounts:updateMountInfo 22222", Serialize(data))
        if not data.isUnlock then
            local visible = data.type == 3 and true or false
            local conBuy = GetElement(self.m_root,"conBuy_WndMounts",WZUIContainer)
            local conNotBuy = GetElement(self.m_root,"conNotBuy_WndMounts",WZUIContainer)
            conBuy:setVisible(visible)
            conNotBuy:setVisible(not visible)
            if data.type == 3 then
                local itemInfo = GDatatab_item["id_"..data.payId]
                local ftb = GetElement(self.m_root,"ftbBuy_WndMounts",WZUIFreeTextBox)
                if data.payId == 1 or data.payId == 2 or data.payId == 70 then
                    ftb:setShowText(string.format(LocalStrings.MOUNT_GET_COST1,data.payCnt,itemInfo.icon))
                else
                    local lolStr = string.format(LocalStrings.MOUNT_GET_COST2,itemInfo.icon,itemInfo.name,data.payCnt)
                    WZLog("WndMounts:updateMountInfo =",lolStr)
                    ftb:setShowText(lolStr)
                end
                if ProjConfig.LANGUAGE == "pt" then
                    ftb:setScale(0.8)
                end
            else
                local txtLock = GetElement(self.m_root,"txtLockDesc_WndMounts",WZUILabelTTF)
                txtLock:setText(data.str)
            end
        else
            local conBuy = GetElement(self.m_root,"conBuy_WndMounts",WZUIContainer)
            local conNotBuy = GetElement(self.m_root,"conNotBuy_WndMounts",WZUIContainer)
            conBuy:setVisible(false)
            conNotBuy:setVisible(false)
        end
    end
    self:_createRoleAndMount(data)
    self:_initFightTips()
end

-- 优化更新，更新坐骑列表的单个cell，isModifyInfo 是否改变左边的坐骑信息
function WndMounts:_updateSingleCell(id,isModifyInfo)
    local tab = GetElement(self.m_root,"tabList_WndMounts",WZUITableContainer)
    self:updateByCacheCenterById(id)
    local index,newData = self:getIndexById(id)
    WZLog("--------------------cell Index----------------",index,newData.basicInfo.name)

    local tcell = self.m_MountsList[index].tcell
    --tcell:setCellAllElement(newData)
    tcell:updateData(newData)
    self:_updateFight()

    -- 出站坐骑需要更新
    if newData.isPlay and isModifyInfo then
        self:updateMountInfo(newData.basicInfo.id)
    end
end

--战斗力变化动画
function WndMounts:updatePlayerInfoData()
    if self.m_root then  upPlayerFightingAni() end
end

-- 坐骑动画
function WndMounts:_createMountAni(con,info)
    local sex = CacheCenter:getPlayerInfo().sex == 1 and true or false
    if con:getChildByTag(99) then con:removeChildByTag(99,true) end

    local head,body = CacheCenter:getHeadAndBodyColor()
    local ani = CreatePlayerFigure(sex, nil, "mount_show",nil,nil,nil,nil,nil,nil,nil,head,body,false)
    ani:setMount(info.basicInfo.animation_index_code)

    local node = ani:getAnimNode()
    node:setScale(0.6)
    con:addChild(node,0,99)
    con:setScale(0)
    local scaleTo = CCScaleTo:create(0.5,1,1)
    con:runAction(scaleTo)
end

function WndMounts:_initFightTips()
    local _,pro = self:_getProperty(self.m_tHorses[self.curSelIndex].property)
    local str = {LocalStrings.PETHEALTH,LocalStrings.PETATTACK,LocalStrings.PETDEFENSE,LocalStrings.MOUNT_SPEED,LocalStrings.MOUNT_LUCKY}
    for i = 1, 5 do
        local text = [[<T C="105,65,46" S="22" >%s</T><T C="128,54,13" S="22" >%d</T>]]
        local txtPro = GetElement(self.m_root,"ftbPro"..i.."_WndMounts",WZUIFreeTextBox)
        txtPro:setShowText(string.format(text,str[i],pro[i]))
    end

    local fight = self:getFight(self.m_tHorses[self.curSelIndex].property)
    local ftbFight = GetElement(self.m_root,"ftbFight_WndMounts",WZUIFreeTextBox)
    ftbFight:setShowText(string.format(LocalStrings.FIGHT_POWER1,fight))
end

-- 获得坐骑后回调
function WndMounts:onReturnClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local con = GetElement(self.m_root,"conAniGet_WndMounts",WZUIContainer)
    con:setVisible(false)

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(19)
    WZLog("WndMounts:onReturnClick two", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 26 then
        TeachGroup1:endTeachStep({19,5})
        TeachGroup1:startGroup({19,6,self.m_root})
    else
        WindowManager:removeTeachShelterLayer()
    end
end

-- 获得坐骑动画
function WndMounts:_getNewMountAni(id)
    SoundManager:playEffectSound(SoundDefine.E_S_GET_DESIGNATION)
    local con = GetElement(self.m_root,"conAniGet_WndMounts",WZUIContainer)
    con:setVisible(true)

    local _,info = self:getIndexById(id)
    local conM = GetElement(self.m_root,"conMountAnim_WndMounts",WZUIContainer)
    self:_createMountAni(conM,info)

    local txtName = GetElement(self.m_root,"txtMountAniName_WndMounts",WZUILabelTTF)
    txtName:setText(info.basicInfo.name)

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(19)
    WZLog("WndMounts:_getNewMountAni two", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() and CacheCenter:getPlayerInfo().level == 26 then
        TeachGroup1:endTeachStep({19,4})
        TeachGroup1:startGroup({19,5,self.m_root})
    else
        WindowManager:removeTeachShelterLayer()
    end
end
-------------------------------------私有方法模块End--------------------------------------

-- 创建角色和坐骑动画
function WndMounts:_createRoleAndMount(data)
    local conAni = GetElement(self.m_root,"conMountRole_WndMounts",WZUIContainer)
    if conAni:getChildByTag(99) then conAni:removeChildByTag(99,true) end

    local equipList = CacheCenter:getDecorationList()
    local equip = {}
    for k, v in pairs(equipList) do
        if  v.maintype == 5 and v.isUse then table.insert(equip, v.id)  end
    end
    local head,body = CacheCenter:getHeadAndBodyColor()
    local ani = CreatePlayerFigure(CacheCenter:getPlayerInfo().sex, equip,"wait",nil,nil,nil,nil,nil,nil,nil,head,body,false)
    ani:setMount(data.basicInfo.animation_index_code)
    local node = ani:getAnimNode()
    node:setScale(0.75)
    conAni:addChild(node,0,99)
    self.mountAni = ani

	--魔幻麋鹿特殊处理
	if data.basicInfo.id == 10056 then
		self:walk()
	end
end

function WndMounts:walk()
    local node = self.mountAni:getAnimNode()
	self.walking = true
    self.mountAni:play("walk4", true)
	node:setRelativePosition(ccp(-1,0))

   	local array = CCArray:create()
   	array:addObject(CCMoveBy:create(8,GlobalMethod:ccp(800,0)))
	array:addObject( CCCallFunc:create(function()
		node:setRelativePosition(ccp(-1,0))
	end ))
   	local action =  CCRepeatForever:create(CCSequence:create(array))
   	node:runAction(action)
end

-- 更新cell的选中状态
function WndMounts:_updateCellSel()
    WZLog("--------------update sel----------------",self.curSelIndex)
    for i = 1, #self.m_MountsList do
        local tcell = self.m_MountsList[i].tcell
        tcell:setSelectState(self.curSelIndex == i)
    end

    -- 坐骑特效
    local spine = GetElement(self.m_root,"spineDress_WndMounts",WZUISpine)
    spine:play("2",false)
end

function WndMounts:_updateFightingAndLvAndStar()
    self:_initFightTips()
    self:_updateFight()


    local data = self.m_tHorses[self.curSelIndex]

    -- 更新cell的信息
    local tcell = self.m_MountsList[self.curSelIndex].tcell
    local index,newData = self:getIndexById(data.id)
    tcell:updateData(newData)

    -- 名字和等级
    local txtName = GetElement(self.m_root,"txtMountName_WndMounts",WZUILabelTTF)
    local txtLv = GetElement(self.m_root,"txtMountLv_WndMounts",WZUILabelTTF)
    local maxLv = self:_getMountMaxLevel(data)
    txtName:setText(data.basicInfo.name)
    txtName:setColor(QUALITYCOLOR[data.basicInfo.quality])
    txtLv:setText("Lv"..data.upgradeLevel.."/"..maxLv)
    txtLv:setColor(QUALITYCOLOR[data.basicInfo.quality])

    -- 星级
    local starCnt = data.advancedLevel
    local imgPath = {"ui/common/common_icon_xingxing2.png","ui/common/common_icon_xingxing3.png" }
    for i =1, 10 do
        local index = starCnt >= i and 1 or 2
        local star = GetElement(self.m_root,"imgStar"..i.."_WndMounts",WZUIImage)
        star:setFile(imgPath[index])
    end
end

-------------------------------------语言适配Begin----------------------------------------
function WndMounts:_adaptLanguage_pt()
    WZLog("WndMounts:_adaptLanguage_pt")
    GetElement(self.m_root,"txtLockDesc_WndMounts",WZUILabelTTF):setFontSize(16)

    for i = 1, 5 do
        local ftbProName = string.format("ftbPro%d_WndMounts",i)
        GetElement(self.m_root,ftbProName,WZUIFreeTextBox):setScale(0.9)
    end

    GetElement(self.m_root,"txtTransfer1_WndStrengthen",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"txtTransfer2_WndStrengthen",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"txtTransfer3_WndStrengthen",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"txtTransfer4_WndStrengthen",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"txtTransfer5_WndStrengthen",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"txtTransfer6_WndStrengthen",WZUILabelTTF):setScale(0.75)

    GetElement(self.m_root,"txtForMountTip_WndMounts",WZUILabelTTF):setScale(0.75)
end

function WndMounts:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtLockDesc_WndMounts",WZUILabelTTF):setFontSize(18)
end

function WndMounts:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtLockDesc_WndMounts",WZUILabelTTF):setFontSize(18)
    local ftbBuy = GetElement(self.m_root,"ftbBuy_WndMounts",WZUIFreeTextBox)
    ftbBuy:setScale(0.77)
    ftbBuy:setMaxWidth(550)

    GetElement(self.m_root,"txtForMountTip_WndMounts",WZUILabelTTF):setScale(0.8)
end

function WndMounts:_adaptLanguage_vn(  )
    local ftbBuy = GetElement(self.m_root,"ftbBuy_WndMounts",WZUIFreeTextBox)
    ftbBuy:setScale(0.8)
end
-------------------------------------语言适配End------------------------------------------
