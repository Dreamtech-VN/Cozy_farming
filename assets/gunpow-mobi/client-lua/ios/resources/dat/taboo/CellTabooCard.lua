--CellTabooCard.lua
--@brief	CellTabooCard的UI模块
--@date		2017/04/21
--@note		card


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTabooCard:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTabooCard:onExit(element)
	self:_unInit()
end


--@brief	点击按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function CellTabooCard:onClick(element)
    if not self.m_tData then
        return
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local template = GDatatab_forbidden_cell["id_"..self.m_tData.id]
    if template then
        WndItemInfo:showInfo(self.m_root,SceneTabooBattle.m_root,3,template.test,false,nil,true)
    end
end

--@brief	旋转卡片
function CellTabooCard:flipCard(isAction)
    if self.m_root == nil then
        return
    end
    local conFront = GetElement(self.m_root, "conFront_CellTabooCard",WZUIContainer)
    local conBack = GetElement(self.m_root, "conBack_CellTabooCard",WZUIContainer)
    if self.m_bCardFace then
        conFront:setVisible(true)
        conBack:setVisible(false)
    else
        conFront:setVisible(false)
        conBack:setVisible(true)
    end
    if isAction then
        if not self.m_bCardFace then
            self.m_root:setScaleX(-1)
        else
            self.m_root:setScaleX(1)
        end
        local aniflip = CCOrbitCamera:create(0.2, 1.0, 0.0, 0.0, -180, 0.0, 0.0)
        self.m_root:runAction(aniflip)

        -- SoundManager:playEffectSound(SoundDefine.E_S_TABOO_RESET)
    end
    self.m_bCardFace = not self.m_bCardFace
end

function CellTabooCard:setBgFile(imgPath)
    local imgFront =  GetElement(self.m_root,"imgCardFrontBg_CellTabooCard",WZUIImage)
    local imgBack = GetElement(self.m_root,"imgCardBackBg_CellTabooCard",WZUIImage)
    imgFront:setFile(imgPath)
    imgBack:setFile(imgPath)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新界面
function CellTabooCard:_update()
    if self.m_root == nil then
        return
    end
    if self.m_tData == nil then
        --待反转面
        if self.m_bCardFace then
            GetElement(self.m_root,"imgCardFront_CellTabooCard",WZUIImage):setFile("")
            GetElement(self.m_root,"labDirFront_CellTabooCard",WZUILabelTTF):setText("")
            GetElement(self.m_root,"imgDirFront_CellTabooCard",WZUIImage):setFile("")
            GetElement(self.m_root,"labNumFront_CellTabooCard",WZUILabelTTF):setText("")

        else
            GetElement(self.m_root,"imgCardBack_CellTabooCard",WZUIImage):setFile("")
            GetElement(self.m_root,"labDirBack_CellTabooCard",WZUILabelTTF):setText("")
            GetElement(self.m_root,"imgDirBack_CellTabooCard",WZUIImage):setFile("")
            GetElement(self.m_root,"labNumBack_CellTabooCard",WZUILabelTTF):setText("")
        end
        return
    end
    local template = GDatatab_forbidden_cell["id_"..self.m_tData.id]
    local imgPath = ""
    if not template then
        return
    end
    imgPath = template.icon

    --正面
    local labDir = nil
    local imgDir = nil
    local labNum = nil

    local rotaList = {180,0,270,90}
    if self.m_bCardFace then
        local img = GetElement(self.m_root,"imgCardFront_CellTabooCard",WZUIImage)
        img:setFile(imgPath)

        labDir = GetElement(self.m_root,"labDirFront_CellTabooCard",WZUILabelTTF)
        imgDir = GetElement(self.m_root,"imgDirFront_CellTabooCard",WZUIImage)
        labNum = GetElement(self.m_root,"labNumFront_CellTabooCard",WZUILabelTTF)
    else
        local img = GetElement(self.m_root,"imgCardBack_CellTabooCard",WZUIImage)
        img:setFile(imgPath)

        labDir = GetElement(self.m_root,"labDirBack_CellTabooCard",WZUILabelTTF)
        imgDir = GetElement(self.m_root,"imgDirBack_CellTabooCard",WZUIImage)
        labNum = GetElement(self.m_root,"labNumBack_CellTabooCard",WZUILabelTTF)
    end

    --方向ui
    if template.room == TabooEventType.Advance then
        imgDir:setFile("ui/taboo/jinji_qianjin1.png")
        imgDir:setRotation(rotaList[self.m_nFront])
        labDir:setText(LocalStrings.TABOO_DIR_FRONT)
    elseif template.room == TabooEventType.Back then
        imgDir:setFile("ui/taboo/jinji_houtui1.png")
        imgDir:setRotation(rotaList[self.m_nBack])
        labDir:setText(LocalStrings.TABOO_DIR_BACK)
    elseif template.room == TabooEventType.Box and template.gezi == 35 then
        labDir:setText(LocalStrings.TABOO_CELL_END)
    else
        imgDir:setFile("")
        labDir:setText("")
    end
    if template.room == TabooEventType.Reward then
        labNum:setText(template.roomis[1][2])
    else
        labNum:setText("")
    end

end

-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function CellTabooCard:_adaptLanguage_vn(  )
    GetElement(self.m_root,"labDirBack_CellTabooCard",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"labDirFront_CellTabooCard",WZUILabelTTF):setScale(0.8)
end

function CellTabooCard:_adaptLanguage_en(  )
    GetElement(self.m_root,"labDirBack_CellTabooCard",WZUILabelTTF):setScale(0.65)
    GetElement(self.m_root,"labDirFront_CellTabooCard",WZUILabelTTF):setScale(0.65)
end

function CellTabooCard:_adaptLanguage_th(  )
    GetElement(self.m_root,"labDirBack_CellTabooCard",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"labDirFront_CellTabooCard",WZUILabelTTF):setScale(0.8)
end

function CellTabooCard:_adaptLanguage_pt(  )
    GetElement(self.m_root,"labDirBack_CellTabooCard",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"labDirFront_CellTabooCard",WZUILabelTTF):setScale(0.8)
end

function CellTabooCard:_adaptLanguage_es(  )
    GetElement(self.m_root,"labDirBack_CellTabooCard",WZUILabelTTF):setScale(0.65)
    GetElement(self.m_root,"labDirFront_CellTabooCard",WZUILabelTTF):setScale(0.65)
end

function CellTabooCard:_adaptLanguage_tr(  )
    GetElement(self.m_root,"labDirBack_CellTabooCard",WZUILabelTTF):setScale(0.65)
    GetElement(self.m_root,"labDirFront_CellTabooCard",WZUILabelTTF):setScale(0.65)
end
---------------------------------------语言适配End------------------------------------------