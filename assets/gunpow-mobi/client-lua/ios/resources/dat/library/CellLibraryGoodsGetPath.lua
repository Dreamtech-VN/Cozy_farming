--CellLibraryGoodsGetPathGetPath.lua
--@brief	CellLibraryGoodsGetPathGetPath的UI模块
--@date		2016/05/06
--@author	maopeiting
--@note		图鉴物品获得路径


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLibraryGoodsGetPath:onEnter(element)
	self.m_root = element
    --ChangeChatChannel(Chat_Channel_Library)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLibraryGoodsGetPath:onExit(element)
	self:_unInit()
end

--@brief	cell的点击事件
--@param	element:触发事件的控件引用
function CellLibraryGoodsGetPath:onCellClick( element )
    WZLog("------the cell has been click------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local jump = false
    WZLog("CellLibraryGoodsGetPath:self.id",self.id)
    if self.battelType == 1 then
        if CopyManager:bJumpToSingleCopy(self.id) then
            jump = JumpByUIId(12,nil,self.id,4)
        end
    elseif self.battelType == 2 then
        jump = JumpByUIId(15)
    elseif self.battelType == 3 then
        if self.id == 185 then
            jump = JumpByUIId(12,nil,3)
        elseif self.id == 187 then
            jump = JumpByUIId(12,nil,2)
        else
            jump = JumpByUIId(self.id)
        end
    elseif self.battelType == 5 then
        local nLastNum = CacheCenter:getPlayerItemCountById(self.id)
        if nLastNum <= 0 then
            MsgBoxManager:showTipBox(GDatatab_item["id_" .. self.id].name .. " " .. LocalStrings.NOT_ENABLE)
        else
            WndOpenChest:showInterface(self.id)
        end
        return 
    end
    
    if jump ~= false then
        jump = true
    end
    WZLog("-------jump:--------",jump)
    if jump then
        WindowManager:removeWindow(WndLibrary.m_root,WndLibrary,true)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	获取物品的途径
function CellLibraryGoodsGetPath:_update()
    local path1 = GetElement(self.m_root,"ttfPath1_CellLibraryGoodsGetPath",WZUILabelTTF)
    local path2 = GetElement(self.m_root,"ttfPath2_CellLibraryGoodsGetPath",WZUILabelTTF)
    local path3 = GetElement(self.m_root,"ttfPath3_CellLibraryGoodsGetPath",WZUILabelTTF)
    local path4 = GetElement(self.m_root,"ttfPath4_CellLibraryGoodsGetPath",WZUILabelTTF)
    local path5 = GetElement(self.m_root,"ttfPath5_CellLibraryGoodsGetPath",WZUILabelTTF)
    local path6 = GetElement(self.m_root,"ttfPath6_CellLibraryGoodsGetPath",WZUILabelTTF)
    local path7 = GetElement(self.m_root,"ttfPath7_CellLibraryGoodsGetPath",WZUILabelTTF)
    local path8 = GetElement(self.m_root,"ttfPath8_CellLibraryGoodsGetPath",WZUILabelTTF)
    local path = GetElement(self.m_root,"ttfPath_CellLibraryGoodsGetPath",WZUILabelTTF)
    --单人副本
    if self.battelType == 1 then
        for k,v in pairs(GDatatab_single_map) do

            if v.id == self.id then 
                path1:setText(v.section_name)
                path2:setText(v.map_name)

                if v.map_type == 1 then
                    path3:setText(LocalStrings.NORMAL)
                elseif v.map_type == 2 then
                    path3:setText(LocalStrings.PICK) 
                end  
                
                local nChallengeCount = CopyManager:findSCopyChallengeN(self.id)
                --玩家可玩关卡数的上限
                local nEnabledChallengeCount = v.pass_times

                if nChallengeCount == nil then nChallengeCount = 0 end
                
                nChallengeCount = nEnabledChallengeCount - nChallengeCount  --玩家可玩关卡次数
                challengeCount = "("..nChallengeCount.."/"..nEnabledChallengeCount..")"
                path4:setText(challengeCount)
            end
        end
    --组队副本
    elseif self.battelType == 2 then
        for k,v in pairs(GDatatab_team_map) do
            if v.id == self.id then
                local mapNum = v.map_num
                path5:setText(LocalStrings.MULTI_SCRIPT)
                if v.difficulty == 1 then
                    path6:setText(LocalStrings.COMMON)
                elseif v.difficulty == 2 then
                    path6:setText(LocalStrings.DIFFICULTY)
                elseif v.difficulty == 3 then
                    path6:setText(LocalStrings.HELL)
                end
                path7:setText(v.map_name)
                --玩家可玩关卡的次数
                local nChallengeCount
                --从缓存中获取组队副本的数据
                local tMultiCopyData = CacheCenter:getMultiCopyData() or {}
                for i,v in ipairs(tMultiCopyData) do
                    if v.mapId == mapNum then
                        --WZLog("----CellLibraryGoodsGetPath:v------",Serialize(v))
                        nChallengeCount = v.passTime
                    end
                end
                if nChallengeCount == nil then nChallengeCount = 0 end
                WZLog("-----CellLibraryGoodsGetPath:玩家已玩次数-----",nChallengeCount,v.map_name)
                --玩家可玩关卡数的上限
                local nEnabledChallengeCount = v.challenge_num
                nChallengeCount = nEnabledChallengeCount - nChallengeCount
                WZLog("-----CellLibraryGoodsGetPath:玩家剩余次数-----",nChallengeCount)
                challengeCount = "("..nChallengeCount.."/"..nEnabledChallengeCount..")"
                path8:setText(challengeCount)
            end
        end
    --商城，竞技商店，公会商店
    elseif self.battelType == 3 then
        for k,v in pairs(GDatatab_interface) do
            if v.id == self.id then
                path:setText(v.name)
            end
        end
    --使用打开宝箱
    elseif self.battelType == 5 then
        path:setText(LocalStrings.USE .. GDatatab_item["id_" .. self.id].name)
    end
end
-------------------------------------私有方法模块End---------------------------------------

-------------------------------------语言适配Begin---------------------------------------
--@brief    英语适配
function CellLibraryGoodsGetPath:_adaptLanguage_en(  )
    local path1 = GetElement(self.m_root,"ttfPath1_CellLibraryGoodsGetPath",WZUILabelTTF)
    path1:setFontSize(20)
    local path2 = GetElement(self.m_root,"ttfPath2_CellLibraryGoodsGetPath",WZUILabelTTF)
    path2:setFontSize(20)
    local path3 = GetElement(self.m_root,"ttfPath3_CellLibraryGoodsGetPath",WZUILabelTTF)
    path3:setRelativePosition(ccp(0.7,0.65))
    path3:setFontSize(20)
    local path4 = GetElement(self.m_root,"ttfPath4_CellLibraryGoodsGetPath",WZUILabelTTF)
    path4:setFontSize(20)
    path4:setRelativePosition(ccp(0.88,0.65))
    local path5 = GetElement(self.m_root,"ttfPath5_CellLibraryGoodsGetPath",WZUILabelTTF)
    path5:setFontSize(20)
    path5:setRelativePosition(ccp(0.28,0.63333))
    local path6 = GetElement(self.m_root,"ttfPath6_CellLibraryGoodsGetPath",WZUILabelTTF)
    path6:setFontSize(20)
    path6:setRelativePosition(ccp(0.6,0.63333))
    local path7 = GetElement(self.m_root,"ttfPath7_CellLibraryGoodsGetPath",WZUILabelTTF)
    path7:setFontSize(20)
    local path8 =  GetElement(self.m_root,"ttfPath8_CellLibraryGoodsGetPath",WZUILabelTTF)
    path8:setFontSize(20)
    path8:setRelativePosition(ccp(0.78,0.63))
end

function CellLibraryGoodsGetPath:_adaptLanguage_pt(  )
    local path1 = GetElement(self.m_root,"ttfPath1_CellLibraryGoodsGetPath",WZUILabelTTF)
    path1:setFontSize(16)
    local path2 = GetElement(self.m_root,"ttfPath2_CellLibraryGoodsGetPath",WZUILabelTTF)
    path2:setFontSize(20)
    local path3 = GetElement(self.m_root,"ttfPath3_CellLibraryGoodsGetPath",WZUILabelTTF)
    path3:setRelativePosition(ccp(0.7,0.65))
    path3:setFontSize(20)
    local path4 = GetElement(self.m_root,"ttfPath4_CellLibraryGoodsGetPath",WZUILabelTTF)
    path4:setFontSize(20)
    path4:setRelativePosition(ccp(0.88,0.65))
    local path5 = GetElement(self.m_root,"ttfPath5_CellLibraryGoodsGetPath",WZUILabelTTF)
    path5:setFontSize(16)
    path5:setRelativePosition(ccp(0.28,0.63333))
    local path6 = GetElement(self.m_root,"ttfPath6_CellLibraryGoodsGetPath",WZUILabelTTF)
    path6:setFontSize(20)
    path6:setRelativePosition(ccp(0.6,0.63333))
    local path7 = GetElement(self.m_root,"ttfPath7_CellLibraryGoodsGetPath",WZUILabelTTF)
    path7:setFontSize(20)
    local path8 =  GetElement(self.m_root,"ttfPath8_CellLibraryGoodsGetPath",WZUILabelTTF)
    path8:setFontSize(20)
    path8:setRelativePosition(ccp(0.78,0.63))
end

--@brief    泰语适配
function CellLibraryGoodsGetPath:_adaptLanguage_th(  )
    local path1 = GetElement(self.m_root,"ttfPath1_CellLibraryGoodsGetPath",WZUILabelTTF)
    path1:setFontSize(20)
    local path2 = GetElement(self.m_root,"ttfPath2_CellLibraryGoodsGetPath",WZUILabelTTF)
    path2:setFontSize(20)
    local path3 = GetElement(self.m_root,"ttfPath3_CellLibraryGoodsGetPath",WZUILabelTTF)
    path3:setRelativePosition(ccp(0.66,0.65))
    path3:setFontSize(20)
    local path4 = GetElement(self.m_root,"ttfPath4_CellLibraryGoodsGetPath",WZUILabelTTF)
    path4:setFontSize(20)
    path4:setRelativePosition(ccp(0.88,0.65))
    local path5 = GetElement(self.m_root,"ttfPath5_CellLibraryGoodsGetPath",WZUILabelTTF)
    path5:setFontSize(20)
    local path6 = GetElement(self.m_root,"ttfPath6_CellLibraryGoodsGetPath",WZUILabelTTF)
    path6:setFontSize(20)
    path6:setRelativePosition(ccp(0.6,0.63333))
    local path7 = GetElement(self.m_root,"ttfPath7_CellLibraryGoodsGetPath",WZUILabelTTF)
    path7:setFontSize(20)
    local path8 =  GetElement(self.m_root,"ttfPath8_CellLibraryGoodsGetPath",WZUILabelTTF)
    path8:setFontSize(20)
    path8:setRelativePosition(ccp(0.78,0.63))
end

--@brief    越南语适配
function CellLibraryGoodsGetPath:_adaptLanguage_vn(  )
    GetElement(self.m_root,"ttfPath3_CellLibraryGoodsGetPath",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.65))
    GetElement(self.m_root,"ttfPath4_CellLibraryGoodsGetPath",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.9,0.65))
    GetElement(self.m_root,"ttfPath6_CellLibraryGoodsGetPath",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.69,0.63))
    GetElement(self.m_root,"ttfPath8_CellLibraryGoodsGetPath",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.9,0.63))
end

--@brief    土耳其语适配
function CellLibraryGoodsGetPath:_adaptLanguage_tr(  )
    local path1 = GetElement(self.m_root,"ttfPath1_CellLibraryGoodsGetPath",WZUILabelTTF)
    path1:setFontSize(20)
    local path2 = GetElement(self.m_root,"ttfPath2_CellLibraryGoodsGetPath",WZUILabelTTF)
    path2:setFontSize(20)
    local path3 = GetElement(self.m_root,"ttfPath3_CellLibraryGoodsGetPath",WZUILabelTTF)
    path3:setRelativePosition(ccp(0.68,0.65))
    path3:setFontSize(20)
    local path4 = GetElement(self.m_root,"ttfPath4_CellLibraryGoodsGetPath",WZUILabelTTF)
    path4:setFontSize(20)
    path4:setRelativePosition(ccp(0.88,0.65))
    local path5 = GetElement(self.m_root,"ttfPath5_CellLibraryGoodsGetPath",WZUILabelTTF)
    path5:setFontSize(16)
    path5:setRelativePosition(ccp(0.28,0.63333))
    local path6 = GetElement(self.m_root,"ttfPath6_CellLibraryGoodsGetPath",WZUILabelTTF)
    path6:setFontSize(20)
    path6:setRelativePosition(ccp(0.65,0.63333))
    local path7 = GetElement(self.m_root,"ttfPath7_CellLibraryGoodsGetPath",WZUILabelTTF)
    path7:setFontSize(20)
    local path8 =  GetElement(self.m_root,"ttfPath8_CellLibraryGoodsGetPath",WZUILabelTTF)
    path8:setFontSize(20)
    path8:setRelativePosition(ccp(0.88,0.63))
end

function CellLibraryGoodsGetPath:_adaptLanguage_es(  )
    local path1 = GetElement(self.m_root,"ttfPath1_CellLibraryGoodsGetPath",WZUILabelTTF)
    path1:setFontSize(16)
    path1:setDimensions(GlobalMethod:CCSize(160,0))
    local path2 = GetElement(self.m_root,"ttfPath2_CellLibraryGoodsGetPath",WZUILabelTTF)
    path2:setFontSize(20)
    local path3 = GetElement(self.m_root,"ttfPath3_CellLibraryGoodsGetPath",WZUILabelTTF)
    path3:setRelativePosition(ccp(0.7,0.65))
    path3:setFontSize(20)
    local path4 = GetElement(self.m_root,"ttfPath4_CellLibraryGoodsGetPath",WZUILabelTTF)
    path4:setFontSize(20)
    path4:setRelativePosition(ccp(0.88,0.65))
    local path5 = GetElement(self.m_root,"ttfPath5_CellLibraryGoodsGetPath",WZUILabelTTF)
    path5:setFontSize(16)
    path5:setRelativePosition(ccp(0.28,0.63333))
    path5:setDimensions(GlobalMethod:CCSize(160,0))
    local path6 = GetElement(self.m_root,"ttfPath6_CellLibraryGoodsGetPath",WZUILabelTTF)
    path6:setFontSize(20)
    path6:setRelativePosition(ccp(0.7,0.63333))
    local path7 = GetElement(self.m_root,"ttfPath7_CellLibraryGoodsGetPath",WZUILabelTTF)
    path7:setFontSize(20)
    local path8 =  GetElement(self.m_root,"ttfPath8_CellLibraryGoodsGetPath",WZUILabelTTF)
    path8:setFontSize(20)
    path8:setRelativePosition(ccp(0.88,0.63))
end
-------------------------------------语言适配End---------------------------------------

