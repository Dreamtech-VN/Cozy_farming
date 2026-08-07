--BattleChooseMethod.lua
--@brief    技能选择目标配置
--@date     2015/05/28

--技能选择目标配置
ChooseTargetConfig =
{
    RANDOM = 1, --随机目标
    NEAREST = 2, --最近目标敌人
    FAREST = 3, --最远目标敌人
    HP_MAX = 4, --血量最大敌人
    HP_MIN = 5, --血量最小敌人
    NEAR_BOSS_LIST = 6, --距离boss 指定距离 敌人
    NEAR_POSITION_LIST = 7, --距离指定点 指定距离 敌人
    ALL_HERO = 8,   --所有玩家
    MYSELF = 9, --自身
    ALL_BOSS = 10,  --所有怪物
    DISTANCE_X = 11, --x距离判断
    DISTANCE = 12,--距离判断
    ALL_HERO_AND_KID = 13,   --所有玩家和孩子

    TARGET_IN_RECT = 18,    --目标范围内（18,x,y,w,h）
}

--BattleChooseMethod.lua
--@brief    战斗特效
--@date     2015/05/28

BattleChooseMethod = {
}

-------------------------------------公有方法模块Begin--------------------------------------
function BattleChooseMethod:chooseTarget(hero,effectParm)
    hero = hero or WBattleGlobal:getCurrent():getCurrentCharacter()

    local chooseTargetType = effectParm[1]
    local tSkillTargetHeroList = {}
    if chooseTargetType == ChooseTargetConfig.RANDOM then
        table.insert(tSkillTargetHeroList, WMonster:getRandomPlayer())
    elseif chooseTargetType == ChooseTargetConfig.NEAREST then
        table.insert(tSkillTargetHeroList, hero:getNearestPlayer())
    elseif chooseTargetType== ChooseTargetConfig.FAREST then
        table.insert(tSkillTargetHeroList, WMonster:getFarestPlayer())
    elseif chooseTargetType == ChooseTargetConfig.HP_MAX then
        table.insert(tSkillTargetHeroList, WMonster:getHpMaxPlayer())
    elseif chooseTargetType == ChooseTargetConfig.HP_MIN then
        table.insert(tSkillTargetHeroList, WMonster:getHpMinPlayer())
    elseif chooseTargetType == ChooseTargetConfig.NEAR_BOSS_LIST then
        _, tSkillTargetHeroList = hero:getHeroNearBoss(effectParm[2][1])
    elseif chooseTargetType == ChooseTargetConfig.NEAR_POSITION_LIST then
        _, tSkillTargetHeroList = hero:getHeroNearPos(effectParm[2][1],BattleCommon:getPointTable(effectParm[2][2],effectParm[2][3]))
    elseif chooseTargetType == ChooseTargetConfig.ALL_HERO then
        tSkillTargetHeroList = WMonster:getAllPlayer()
    elseif chooseTargetType == ChooseTargetConfig.MYSELF then
        table.insert(tSkillTargetHeroList, hero)
    elseif chooseTargetType == ChooseTargetConfig.ALL_BOSS then
        tSkillTargetHeroList = WMonster:getAllMonsterBoss()
    elseif chooseTargetType == ChooseTargetConfig.DISTANCE_X then
        local centerPos = effectParm[3] and BattleCommon:getPointTable(effectParm[3][1],effectParm[3][2]) or hero:getPosition() --指定中心点或者以自身为中心计算
        tSkillTargetHeroList = WMonster:getDistanceXPlayer(centerPos,effectParm[2][1],effectParm[2][2],effectParm[2][3])
    elseif chooseTargetType == ChooseTargetConfig.DISTANCE then
        --技能表 chooseParam{{1},{2}}     chooseParam[1]相关系数，chooseParam[2]指定点 sample：12-[600,6,4];12-[600,6,3]
        local centerPos = effectParm[3] and BattleCommon:getPointTable(effectParm[3][1],effectParm[3][2]) or hero:getPosition() --指定中心点或者以自身为中心计算
        tSkillTargetHeroList = WMonster:getDistancePlayer(centerPos,effectParm[2][1],effectParm[2][2],effectParm[2][3],hero:getCamp())
    elseif chooseTargetType == ChooseTargetConfig.TARGET_IN_RECT then
        local x = effectParm[2][1]
        local y = effectParm[2][2]
        local tx = x + effectParm[2][3]
        local ty = y + effectParm[2][4]
        local result,heroList = WMonster:getPlayerWithArea(x, tx, y, ty,true)
        tSkillTargetHeroList = heroList
    elseif chooseTargetType == ChooseTargetConfig.ALL_HERO_AND_KID then
        tSkillTargetHeroList = WMonster:getAllPlayer()
        local kidList = WMonster:getAllKid()
        AddTableToTable(tSkillTargetHeroList, kidList)
    else
        table.insert(tSkillTargetHeroList, WMonster:getRandomPlayer())
    end
    
    WZLog("BattleChooseMethod:chooseTarget",chooseTargetType,#tSkillTargetHeroList)
    -- if #tSkillTargetHeroList == 0 then
    --     table.insert(tSkillTargetHeroList, WMonster:getRandomPlayer())
    --     WZLog("BattleChooseMethod:chooseTarget miss target")
    -- end
    return tSkillTargetHeroList
end
  
