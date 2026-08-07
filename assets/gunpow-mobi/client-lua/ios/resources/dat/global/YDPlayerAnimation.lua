--YDPlayerAnimation.lua
--@brief	人物动画封装 主要是为了换装方便
--@date  	2015/06/09
--@author 	TaoYinqing
--@note 	人物动画封装对象

local g_YDPlayerAnimation_Config = {
	combatboy = {
		action = {
			["standby1"]={zDefault=0,combatboy_head_1=2,combatboy_head_2=2,combatboy_head_3=2,combatboy_face_tmp=0,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
			["itemskill"]={zDefault=1,combatboy_head_1=2,combatboy_head_2=2,combatboy_head_3=2,combatboy_face_tmp=1,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
			["move"]={zDefault=2,combatboy_head_1=2,combatboy_head_2=2,combatboy_head_3=2,combatboy_face_tmp=2,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
			["attackstart1-s"]={zDefault=3,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=3,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
			["attackstart1-s2"]={zDefault=4,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=4,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
			["attack1-s"]={zDefault=5,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=5,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
			["attackstart2-s3"]={zDefault=6,wuqi=4,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=8,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
			["attackstart1-t"]={zDefault=7,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=7,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
			["attackstart1-t2"]={zDefault=8,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=8,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
			["attack1-t"]={zDefault=9,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=9,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
			["attackstart2-t"]={zDefault=10,wuqi2=0,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=10,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
			["attackstart2-t2"]={zDefault=11,wuqi2=1,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=11,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
			["attack2-t"]={zDefault=12,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=12,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
			["fly"]={zDefault=13,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=13,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["injured"]={zDefault=14,combatboy_head_1=2,combatboy_head_2=2,combatboy_head_3=2,combatboy_face_tmp=14,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
			["ghost"]={zDefault=15,combatboy_head_1=2,combatboy_head_2=2,combatboy_head_3=2,combatboy_face_tmp=15,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
			["win"]={zDefault=16,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=16,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["failure"]={zDefault=17,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=17,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["wait0"]={zDefault=18,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=18,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["run"]={zDefault=19,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=19,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["walk"]={zDefault=20,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=20,combatboy_mount_body=0,combatboy_mount_head=0,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["wait"]={zDefault=21,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=21,combatboy_mount_body=1,combatboy_mount_head=1,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["avatar"]={zDefault=22,combatboy_head_1=1,combatboy_head_2=1,combatboy_head_3=1,combatboy_face_tmp=22,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["mount_show"]={zDefault=23,combatboy_mount_body=1,combatboy_mount_head=1},
            ["walk2"]={zDefault=24,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=24,combatboy_mount_body=0,combatboy_mount_head=0,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
            ["injured2"]={zDefault=25,combatboy_head_1=2,combatboy_head_2=2,combatboy_head_3=2,combatboy_face_tmp=25,combatboy_mount_body=0,combatboy_mount_head=0,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
            ["win2"]={zDefault=26,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=26,combatboy_mount_body=0,combatboy_mount_head=0,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
            ["ghost1"]={zDefault=27,combatboy_ghost=0},
            ["attackstart3-s2"]={zDefault=28,wuqi=3,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=28,combatboy_clothes=0,combatboy_wing_R=0,combatboy_wing_L=0},
            ["walk3"]={zDefault=29,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=29,combatboy_mount_body=0,combatboy_mount_head=0,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["walk4"]={zDefault=21,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=21,combatboy_mount_body=0,combatboy_mount_head=0,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
        },
        shop_action = {
            ["win"]={zDefault=0,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=16,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["wait0"]={zDefault=1,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=18,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["run"]={zDefault=2,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=19,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["walk"]={zDefault=3,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=20,combatboy_mount_body=0,combatboy_mount_head=0,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["wait"]={zDefault=4,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=21,combatboy_mount_body=1,combatboy_mount_head=1,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["avatar"]={zDefault=5,combatboy_head_1=1,combatboy_head_2=1,combatboy_head_3=1,combatboy_face_tmp=22,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["mount_show"]={zDefault=6,combatboy_mount_body=1,combatboy_mount_head=1},
            ["walk2"]={zDefault=7,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=24,combatboy_mount_body=0,combatboy_mount_head=0,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
            ["win2"]={zDefault=8,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=26,combatboy_mount_body=0,combatboy_mount_head=0,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
            ["walk3"]={zDefault=9,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=29,combatboy_mount_body=0,combatboy_mount_head=0,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
			["walk4"]={zDefault=4,combatboy_head_1=0,combatboy_head_2=0,combatboy_head_3=0,combatboy_face_tmp=21,combatboy_mount_body=0,combatboy_mount_head=0,combatboy_clothes=0,combatboy_wing_R=1,combatboy_wing_L=1},
        },
		bone = {
			head = {"combatboy_head_1","combatboy_head_2","combatboy_head_3"},
			body = {"combatboy_clothes18","combatboy_clothes16","combatboy_shank_R1","combatboy_foot_R1","combatboy_thigh_R1","combatboy_thigh_L1",
					"combatboy_foot_L1","combatboy_shank_L1","combatboy_forearm_R1","combatboy_arm_R1","combatboy_body1","combatboy_arm_L1",
					"combatboy_hand_L1","combatboy_forearm_L1","combatboy_hand_R1","combatboy_hand_R_win","combatboy_thigh_L","combatboy_hip",
					"combatboy_shank_L","combatboy_foot_L","combatboy_thigh_R","combatboy_shank_R","combatboy_arm_L2","combatboy_foot_R",
					"combatboy_clothes17","combatboy_body","combatboy_clothes15","combatboy_arm_R2","combatboy_forearm_R2","combatboy_hand_R2",
					"combatboy_forearm_L2","combatboy_hand_L2","combatboy_clothes2","combatboy_clothes4","combatboy_clothes5","combatboy_hand_L",
					"combatboy_forearm_L","combatboy_arm_L","combatboy_scapula_L","combatboy_hand_R","combatboy_forearm_R","combatboy_arm_R",
					"combatboy_scapula_R",},
			mount = {"combatboy_mount_body","combatboy_mount_head"},
			weapon_gun = {"combatboy_gun_back","combatboy_gun"},
			weapon_bomb = {"combatboy_bomb_back","combatboy_bomb"},
			face = {"combatboy_face_tmp"},
			exclude_bone = {"combatboy_fly","combatboy_clothes","combatboy_guihuo_01","combatboy_guihuo_02","wuqi","combatboy_skirt","combatboy_scarf","combatboy_ghost"},
			wing = {"combatboy_wing_R","combatboy_wing_L"},
		},
        particle = {
            body_021 = 21,
            body_026 = 26,
			body_027 = 27,
            body_030 = 30,
            body_032 = 32,
            body_038 = 38,
            body_042 = 42,
            body_045 = 45,
            --body_049 = 49,
        }
	},
	combatgirl = {
		action = {
			["standby1"]={zDefault=0,combatgirl_head_1=2,combatgirl_head_2=2,combatgirl_head_3=2,combatgirl_face_tmp=0,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
			["itemskill"]={zDefault=1,combatgirl_head_1=2,combatgirl_head_2=2,combatgirl_head_3=2,combatgirl_face_tmp=1,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
			["move"]={zDefault=2,combatgirl_head_1=2,combatgirl_head_2=2,combatgirl_head_3=2,combatgirl_face_tmp=2,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
			["attackstart1-s"]={zDefault=3,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=3,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
			["attackstart1-s2"]={zDefault=4,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=4,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
			["attack1-s"]={zDefault=5,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=5,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
			["attackstart2-s3"]={zDefault=6,wuqi=0,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=6,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
			["attackstart1-t"]={zDefault=7,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=7,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
			["attackstart1-t2"]={zDefault=8,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=8,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
			["attack1-t"]={zDefault=9,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=9,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
			["attackstart2-t"]={zDefault=10,wuqi2=0,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=10,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
			["attackstart2-t2"]={zDefault=11,wuqi2=1,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=11,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
			["attack2-t"]={zDefault=12,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=12,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
			["fly"]={zDefault=13,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=13,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["injured"]={zDefault=14,combatgirl_head_1=2,combatgirl_head_2=2,combatgirl_head_3=2,combatgirl_face_tmp=14,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
			["ghost"]={zDefault=15,combatgirl_head_1=2,combatgirl_head_2=2,combatgirl_head_3=2,combatgirl_face_tmp=15,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
			["win"]={zDefault=16,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=16,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["failure"]={zDefault=17,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=17,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["wait0"]={zDefault=18,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=18,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["run"]={zDefault=19,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=19,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["walk"]={zDefault=20,combatgirl_head_1=1,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=20,combatgirl_mount_body=0,combatgirl_mount_head=0,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["wait"]={zDefault=21,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=21,combatgirl_mount_body=1,combatgirl_mount_head=1,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["avatar"]={zDefault=22,combatgirl_head_1=1,combatgirl_head_2=1,combatgirl_head_3=1,combatgirl_face_tmp=22,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["mount_show"]={zDefault=23,combatgirl_mount_body=1,combatgirl_mount_head=1},
            ["walk2"]={zDefault=24,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=24,combatgirl_mount_body=0,combatgirl_mount_head=0,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
            ["injured2"]={zDefault=25,combatgirl_head_1=2,combatgirl_head_2=2,combatgirl_head_3=2,combatgirl_face_tmp=25,combatgirl_mount_body=0,combatgirl_mount_head=0,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
            ["win2"]={zDefault=26,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=26,combatgirl_mount_body=0,combatgirl_mount_head=0,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
            ["ghost1"]={zDefault=27,combatgirl_ghost=0},
            ["attackstart3-s2"]={zDefault=28,wuqi=3,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=28,combatgirl_clothes=0,combatgirl_wing_R=0,combatgirl_wing_L=0},
            ["walk3"]={zDefault=29,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=29,combatgirl_mount_body=0,combatgirl_mount_head=0,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["walk4"]={zDefault=21,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=21,combatgirl_mount_body=0,combatgirl_mount_head=0,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
        },
        shop_action = {
			["win"]={zDefault=0,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=16,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["wait0"]={zDefault=1,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=18,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["run"]={zDefault=2,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=19,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["walk"]={zDefault=3,combatgirl_head_1=1,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=20,combatgirl_mount_body=0,combatgirl_mount_head=0,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["wait"]={zDefault=4,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=21,combatgirl_mount_body=1,combatgirl_mount_head=1,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["avatar"]={zDefault=5,combatgirl_head_1=1,combatgirl_head_2=1,combatgirl_head_3=1,combatgirl_face_tmp=22,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["mount_show"]={zDefault=6,combatgirl_mount_body=1,combatgirl_mount_head=1},
            ["walk2"]={zDefault=7,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=24,combatgirl_mount_body=0,combatgirl_mount_head=0,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
            ["win2"]={zDefault=8,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=26,combatgirl_mount_body=0,combatgirl_mount_head=0,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
            ["walk3"]={zDefault=9,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=29,combatgirl_mount_body=0,combatgirl_mount_head=0,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
			["walk4"]={zDefault=4,combatgirl_head_1=0,combatgirl_head_2=0,combatgirl_head_3=0,combatgirl_face_tmp=21,combatgirl_mount_body=0,combatgirl_mount_head=0,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
        },
		bone = {
			head = {"combatgirl_head_1","combatgirl_head_2","combatgirl_head_3"},
			body = {"combatgirl_clothes16","combatgirl_thigh_L1","combatgirl_shank_L1","combatgirl_clothes18","combatgirl_foot_L1","combatgirl_arm_R1",
					"combatgirl_forearm_R1","combatgirl_body1","combatgirl_arm_L1","combatgirl_hand_L1","combatgirl_forearm_L1","combatgirl_hand_R1",
					"combatgirl_hand_R_win","combatgirl_clothes17","combatgirl_thigh_L","combatgirl_shank_L","combatgirl_foot_L","combatgirl_thigh_R",
					"combatgirl_shank_R","combatgirl_foot_R","combatgirl_hip","combatgirl_arm_L2","combatgirl_clothes15","combatgirl_body",
					"combatgirl_arm_R2","combatgirl_forearm_R2","combatgirl_hand_R2","combatboy_hand_L2","combatboy_forearm_L2","combatgirl_clothes4",
					"combatgirl_hand_L","combatgirl_arm_L","combatgirl_forearm_L","combatgirl_hand_R","combatgirl_arm_R","combatgirl_forearm_R"},
			mount = {"combatgirl_mount_body","combatgirl_mount_head"},
			weapon_gun = {"combatgirl_gun_back","combatgirl_gun"},
			weapon_bomb = {"combatgirl_bomb_back","combatgirl_bomb"},
			face = {"combatgirl_face_tmp"},
			exclude_bone = {"combatgirl_fly","combatgirl_clothes","combatgirl_guihuo_01","combatgirl_guihuo_02","wuqi","combatgirl_skirt","combatgirl_scarf"},
			wing = {"combatgirl_wing_R","combatgirl_wing_L"},
		},
        particle = {
            body_021 = 21,
            body_026 = 26,
			body_027 = 27,
            body_030 = 30,
            body_032 = 32,
            body_038 = 38,
            body_042 = 42,
            body_045 = 44,
            --body_049 = 49,
        }
	},
	wingAction = {
		["0"] = "0",
		["1"] = "1",
	},
	headAction = {
		["0"] = "stangby1",
		["1"] = "avatar",
		["2"] = "stangby2",
	},
	mountAction = {
		["0"] = "walk",
		["1"] = "wait1",
	}
}

YDPlayerAnimation = {
	m_sAninName = nil,  		--动画名字
	m_tLoadArmature = nil, 		--额外加载的骨骼动画名字
    m_tLoadPlist = nil
}

-------------------------------------公有方法模块Begin--------------------------------------


--@brief	创建骨骼动画实例
--@param 	bBoy  是否是男孩
--return    新的实例
function YDPlayerAnimation:createAnimation(bBoy,bShop,bMonster)
	local obj = {}
	setmetatable(obj,{__index = YDPlayerAnimation})
	if bBoy == true then
        obj.m_sAninName = "combatboy"
	else 
        obj.m_sAninName = "combatgirl"
	end
    --bMonster = bMonster or false
	obj.m_isMonster = bMonster
    obj.m_monsterName = ""
    obj.m_tLoadArmature = {}
    obj.m_tLoadPlist = {}
    obj.m_bBoy = bBoy
    if obj.m_bBoy == nil then 
        obj.m_bBoy = true
    end
    obj.m_bShop = bShop
    if obj.m_bShop == nil then 
        obj.m_bShop = true
    end
    if obj.m_isMonster == nil then 
        obj.m_isMonster = false
    end
    if obj.m_isMonster ~= false then 
        obj.m_node = WZUISpine:create()
        --local file = "battle/monster/monster_0014"
        --obj.m_node:setFileJson(file .. ".json")
        --obj.m_node:setFileAtlas(file .. ".atlas")
    else
        obj.m_node = WZArmature:create()
        obj.m_node:setUseOriginSize(true)
		obj.m_spineNode = WZUISpine:create()
		obj.m_node:addChild(obj.m_spineNode)
		obj.m_spineNode:setVisible(false)
    end
	--obj.m_node:setVisible(false)
    
	--obj.m_node:setArmatureFile("player/" .. obj.m_sAninName .. "/" .. obj.m_sAninName .. ".xml")	
	obj.m_node:setLuaObjectIndex(obj)
    --obj.m_node:setDrawElementInfo(true)
    --obj.m_node:setContentSize(GlobalMethod:CCSize(150,150))
    if obj.m_node.setUseABSSize ~= nil then 
        obj.m_node:setUseABSSize(true)
        obj.m_node:setAbsSize(150,150)
    else
        obj.m_node:setContentSize(GlobalMethod:CCSize(150,150))
    end
	
	obj.m_bodyIndex = 1
    obj.m_bodyRanSeIndex = 0
	obj.m_weaponGunIndex = 0
	obj.m_weaponBombIndex = 0
	obj.m_wingIndex = 0
	obj.m_faceIndex = 1
	obj.m_headIndex = 1
    obj.m_headRanSeIndex = 0
	obj.m_currentBodyIndex = 0
    obj.m_currentBodyRanSeIndex = 0
	obj.m_currentWingIndex = 0
	obj.m_currentFaceIndex = 0
	obj.m_currentHeadIndex = 0
    obj.m_currentHeadRanSeIndex = 0
	obj.m_mountIndex = 0
	obj.m_bLoadGhost = false
	obj.m_bLoadGunBigSkill = false
    obj.m_bLoadWeaponBigSkill = false
    
	obj.m_running = false
	obj.m_playName = nil
	obj.m_isLoop = false
	obj.m_flipX = false
	obj.m_flipY = false
    obj.m_rotation = 0
    obj.m_pos = {x = 0,y = 0}
    obj.m_scale = {x = 1,y = 1}
    obj.m_loadEffect = false
	obj.m_spineBody = false
	obj.m_spineHead = false
	obj.m_spineFace = false
	obj.m_spineWing = false
	obj.m_spineMount = false
	obj.m_currentAction = ""
	obj:setArmatureName(obj.m_sAninName,obj.m_bodyIndex)
	
	return obj
end

function YDPlayerAnimation:setArmatureName(sName,_index)
	if self.m_node == nil then return end
	if self.m_running ~= true then return end
	local anchorPoint = {x = self.m_node:getAnchorPoint().x,y = self.m_node:getAnchorPoint().y}
    local position = {x = self.m_node:getPositionX(),y = self.m_node:getPositionY()}
    local index = _index or 1
	local sIndex = self:_formatIndex(tonumber(index))
	self.m_sAninName = sName
    self.m_bodyIndex = tonumber(index)
    local animName = self.m_sAninName .. "_body_" .. sIndex
    local shopName = "shopboy_body_" .. sIndex
    if self.m_bBoy == false then 
        shopName = "shopgirl_body_" .. sIndex
    end
	
	if self.m_spineNode ~= nil then 
		self.m_spineNode:removeFromParentAndCleanup(true)
		self.m_spineNode = WZUISpine:create()
		self.m_node:addChild(self.m_spineNode)
		self.m_spineNode:setVisible(false)
	end
	
	local pathName = "player/" .. self.m_sAninName .. "/" .. sIndex .. "/" .. animName
	local shopPath = "player/" .. self.m_sAninName .. "/" .. sIndex .. "/" .. shopName
	local spinePathName = "player_sp/" .. self.m_sAninName .. "/" .. sIndex .. "/" .. animName
    --self:_checkArmature(animName,"",path)
	--print("YDPlayerAnimation:setArmatureName",self.m_node:getPositionX(),self.m_node:getPositionY(),self.m_node:getAnchorPoint().x,self.m_node:getAnchorPoint().y)
    --self.m_node:setArmatureFile(path .. ".xml")	
	local existArmature = WZDataFile:getInstance():checkFileExist(pathName .. ".xml")
	self.m_spineBody = false
	if not existArmature then 
		self.m_bShop = false
		if WZDataFile:getInstance():checkFileExist(spinePathName .. ".json") then 
			self.m_spineBody = true
		end
	end
	
	if self.m_bShop == true then 
        self.m_node:setArmatureFile(shopPath .. ".xml")
        self.m_node:setPlistFile(pathName .. ".plist")
        self.m_node:setArmatureName(shopName)
    else
		if self.m_spineBody then 
			local childNode = self.m_node:getChildNode()
			if childNode then 
				childNode:setVisible(false)
			end
			self.m_spineNode:setVisible(true)
			self.m_spineNode:setFileJson(spinePathName .. ".json")
			if self.m_bodyRanSeIndex > 0 then 
				local tmpPath = spinePathName .. "_rs" .. self:_formatIndex(self.m_bodyRanSeIndex)
				if WZDataFile:getInstance():checkFileExist(tmpPath .. ".atlas") then 
					spinePathName = tmpPath
				end
			end 
			self.m_spineNode:setFileAtlas(spinePathName .. ".atlas")
		else 
			self.m_node:setArmatureFile(pathName .. ".xml")
			self.m_node:setPlistFile(pathName .. ".plist")
			self.m_node:setArmatureName(animName)
			self.m_spineNode:setVisible(false)
			local childNode = self.m_node:getChildNode()
			if childNode then 
				childNode:setVisible(true)
			end
		end
        
    end
    self.m_loadEffect = false
    --self.m_node:setGrayRender(true);
	self.m_currentBodyIndex = 0
	self.m_currentWingIndex = 0
	self.m_currentFaceIndex = 0
	self.m_currentHeadIndex = 0
    --print("YDPlayerAnimation:setArmatureName after",self.m_node:getArmature():getPositionX(),self.m_node:getArmature():getPositionY(),self.m_node:getArmature():getAnchorPoint().x,self.m_node:getArmature():getAnchorPoint().y)
    self.m_node:setAnchorPoint(GlobalMethod:ccp(anchorPoint.x,anchorPoint.y))
    self.m_node:setPositionX(position.x)
    self.m_node:setPositionY(position.y) 
    --self.m_node:getArmature():setShowAnchor(true)
    self:loadEffect() 
    self.m_node:setContentSize(GlobalMethod:CCSize(150,150))
end

function YDPlayerAnimation:setMonsterId(sId)
    if sId == nil or "" == sId then 
        return 
    end
    self.m_monsterId = "" .. sId
    if not self:isMonster() then return end
    if GDatatab_shape_skins == nil then return end
    if GDatatab_shape_skins["id_" .. self.m_monsterId] == nil then return end
    local skins = GDatatab_shape_skins["id_" .. self.m_monsterId]
    local mosterName = skins.animation
    local file = "battle/monster/" .. mosterName
    self.m_node:setFileJson(file .. ".json")
    self.m_node:setFileAtlas(file .. ".atlas")
    self.m_node:setContentSize(GlobalMethod:CCSize(150,150))
    self:updateAnimAnchor()
end

function YDPlayerAnimation:updateAnimAnchor()
    if not self:isMonster() then return end
    local node = self.m_node:getChildNode()
    if node ~= nil then 
        node:setAnchorPoint(GlobalMethod:ccp(0,0))
        node:setPositionY(15)
        node:setScaleX(-1)
    end
    if GDatatab_shape_skins == nil then return end
    if self.m_monsterId == nil then return end
    if GDatatab_shape_skins["id_" .. self.m_monsterId] == nil then return end
    local skins = GDatatab_shape_skins["id_" .. self.m_monsterId]
    local flipX = true
    if skins.flipx ~= nil and skins.flipx == "false" then 
        flipX = false
    end
    local shopScale = 1
    if skins.scale ~= nil then 
        shopScale = skins.scale/100
    end
    local battleScale = 1
    if skins.battle_scale ~= nil then 
        battleScale = skins.battle_scale/100
    end
    if node ~= nil then
        if self.m_bShop ~= true then
            node:setScaleX(battleScale)
            node:setScaleY(battleScale)
        else 
            node:setScaleX(shopScale)
            node:setScaleY(shopScale)
        end 
        if flipX == true then 
            node:setScaleX(node:getScaleX()*-1)
        end
    end
end

function YDPlayerAnimation:onEnter(element)
	self.m_running = true
	self.m_node:setContentSize(GlobalMethod:CCSize(150,150))
	
end


function YDPlayerAnimation:onEnterTransitionDidFinish(element)
	
    if self.m_bodyIndex ~= nil and  self.m_bodyIndex > 0 then 
		self:_setBody(self.m_bodyIndex)
	end
    self:loadEffect()
	self:setFlipX(self.m_flipX)
	self:setFlipY(self.m_flipY)
    if self.m_pos.x ~= 0 or self.m_pos.y ~= 0 then 
        self:setPosition(self.m_pos)
    end
    if self.m_rotation ~= 0 then 
        self:setRotate(self.m_rotation)
    end
    if self.m_scale.x ~= 1 then 
        self:setScaleX(self.m_scale.x)
    end
    if self.m_scale.y ~= 1 then 
        self:setScaleY(self.m_scale.y)
    end
    if self.m_playName ~= nil then 
		self:play(self.m_playName,self.m_isLoop)
	end
    self.m_node:setContentSize(GlobalMethod:CCSize(150,150))
    self:updateAnimAnchor()
end

function YDPlayerAnimation:onExit(element)
	--print("YDPlayerAnimation:onExit(element)")
	--self.m_node = nil
    self.m_currentBodyIndex = 0
	self.m_currentWingIndex = 0
	self.m_currentFaceIndex = 0
	self.m_currentHeadIndex = 0
    
    for i,v in ipairs(self.m_tLoadPlist)
    do 
        WZDataFile:getInstance():unloadTexturePackFile(v .. ".plist",v .. ".png")
    end
    for i,v in ipairs(self.m_tLoadArmature)
    do 
       if WZDataFile:getInstance().unloadArmatureFile ~= nil then
            WZDataFile:getInstance():unloadArmatureFile(v .. ".xml");
        end
    end
    
    self.m_tLoadArmature = {}
    self.m_tLoadPlist = {}
    self.m_running = false
end
--@brief    判断目前是否是幻化成怪物的模型
function YDPlayerAnimation:isMonster() 
    return self.m_isMonster ~= false
end

--@brief    加载人物特效
function YDPlayerAnimation:loadEffect()
    if self.m_loadEffect == true then return end
    if self.m_node == nil then return end
    if self:isMonster() then return end
    local sIndex = self:_formatIndex(tonumber(self.m_bodyIndex))
    local animName = self.m_sAninName .. "_body_" .. sIndex .."_effect"   --combatboy_body_036_effect
    local effectPath = "player/" .. self.m_sAninName .. "/effect/" .. animName
    if not WZDataFile:getInstance():checkFileExist(effectPath .. ".xml") then
        return
    end
    local boneName = self.m_sAninName .. "_body_" .. sIndex .."_effect" --combatboy_body_036_effect
	if self.m_node:getArmature() == nil or boneName == nil then
		return
	end
    local bone = self.m_node:getArmature():getBone(boneName)
    if bone == nil then return end
    self:_checkArmature(animName,sIndex,effectPath)
    if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(animName) ~= nil then
        self.m_node:setDisplayData(0,boneName,animName)
        self.m_loadEffect = true
    end
end

--@brief    加载粒子特效
function YDPlayerAnimation:loadParticle()
    if self.m_running ~= true then return end
    if self:isMonster() then return end
    if self.m_node:getChildByTag(250) ~= nil then 
        self.m_node:removeChildByTag(250,true)
    end
    local sActionName = self.m_playName
    local _sIndex = self:_formatIndex(self.m_currentBodyIndex)
    local config = g_YDPlayerAnimation_Config[self.m_sAninName]
    if ( sActionName == "walk" or sActionName == "wait" or sActionName == "walk2" or sActionName == "wait0" or sActionName == "run" or sActionName == "win" or sActionName == "win2" or sActionName == "walk3") and config.particle["body_".._sIndex] ~= nil then
        _sIndex = self:_formatIndex(config.particle["body_".._sIndex])
        local particlePath = "armatures/player/particle/combat_".._sIndex.."_lizi.plist"
        local particle = CCParticleSystemQuad:create(particlePath)
        particle:setPositionY(93)
        particle:setPositionX(70)
        self.m_node:addChild(particle,0,250)
        if self:isFlipX() then
            particle:setAngle(0)
            particle:setScaleX(-1)
        end
        -- if self:isFlipX() then 
            -- particle:setSpeed(-110)
            -- particle:setScaleX(-1)
        -- end
        if self.m_mountIndex > 0 and ( sActionName == "walk" or sActionName == "wait" or sActionName == "walk2" or sActionName == "walk3" ) then 
            particle:setPositionY(168)
        end
    end
end

function YDPlayerAnimation:setHead(nIndex, sRanSeIndex_)
	WZLog("YDPlayerAnimation:setHead", nIndex, sRanSeIndex_)
    local sRanSeIndex = sRanSeIndex_ or 0
    self.m_headRanSeIndex = tonumber(sRanSeIndex)
	self.m_headIndex = tonumber(nIndex)
	self.m_d_headIndex = tonumber(nIndex)

    local sIndex = YDPlayerAnimation:_formatIndex(tonumber(nIndex))
    local animName = self.m_sAninName .. "_head_" .. sIndex
    local pathName = "player/" .. self.m_sAninName .. "/" .. sIndex .. "/" .. animName
    local existArmature = WZDataFile:getInstance():checkFileExist(pathName .. ".xml")
    if existArmature then 
        WZLog("YDPlayerAnimation:setHead_1 exist",nIndex)
		self:_setHead(nIndex, sRanSeIndex_)
        return
    end
    WZLog("YDPlayerAnimation:setHead_2 not exist",nIndex) 
	self:_setHead(11, sRanSeIndex_)

	local downloadInfo = self:getDownloadInfo(sIndex)
    if downloadInfo == nil then return end 

	DownloadManager:addDownloadTask(nIndex,downloadInfo.url,downloadInfo.md5,sIndex,"downloadHeadCallback",self)
end

function YDPlayerAnimation:downloadHeadCallback(taskId,extraData,failed)
    WZLog("YDPlayerAnimation:downloadHeadCallback",taskId,extraData,failed)
    WZLog("YDPlayerAnimation:downloadHeadCallback_1",self.m_d_headIndex)
    WZLog("YDPlayerAnimation:downloadHeadCallback_2",failed)
    if failed == 0 then 
		self:_setHead(self.m_d_headIndex, self.m_headRanSeIndex)
		self:play(self.m_playName, self.m_isLoop)
    end
end

--@brief	设置头的显示索引
--@param	sIndex 索引值
function YDPlayerAnimation:_setHead(sIndex,sRanSeIndex_)
	WZLog("YDPlayerAnimation:_setHead", sIndex, sRanSeIndex_)
	local _sIndex = self:_formatIndex(sIndex)
    local sRanSeIndex = sRanSeIndex_ or 0
    self.m_headRanSeIndex = tonumber(sRanSeIndex)
	self.m_headIndex = tonumber(sIndex)
    if self:isMonster() then return end
	if self.m_running ~= true then
		return
	end
	if self.m_currentHeadIndex == self.m_headIndex and self.m_currentHeadRanSeIndex == self.m_headRanSeIndex then 
		return 
	end 
	local totalHeadName = self.m_sAninName .. "_head_" .. _sIndex
    if self.m_headRanSeIndex > 0 then 
        totalHeadName = totalHeadName .. "_hs" .. self:_formatIndex(self.m_headRanSeIndex)
    end
	local path = "player/" .. self.m_sAninName .. "/" .. _sIndex
	
	local spinePath = "player_sp/combatboy/" .. _sIndex .. "/combatboy_head_1_" .. _sIndex
	self.m_spineHead = false
	if WZDataFile:getInstance():checkFileExist(spinePath .. ".json") then 
		self.m_spineHead = true
	end
	
	WZLog("YDPlayerAnimation:_setHead_1", self.m_spineBody, self.m_spineHead)
	if self.m_spineBody == true then 
		if self.m_spineHead == true then 
			self:_setSpineSpineHead(sIndex,sRanSeIndex_)
		else 
			self:_setSpineArmatureHead(sIndex,sRanSeIndex_)
		end
	else
		if self.m_spineHead == true then 
			self:_setArmatureSpineHead(sIndex,sRanSeIndex_)
		else 
			self:_setArmatureArmatureHead(sIndex,sRanSeIndex_)
		end
	end
    
    self.m_currentHeadIndex = self.m_headIndex
    self.m_currentHeadRanSeIndex = self.m_headRanSeIndex
end

function YDPlayerAnimation:_setArmatureArmatureHead(sIndex,sRanSeIndex_)
    WZLog("YDPlayerAnimation:_setArmatureArmatureHead")
	local _sIndex = self:_formatIndex(sIndex)
    local sRanSeIndex = sRanSeIndex_ or 0
	local config = g_YDPlayerAnimation_Config[self.m_sAninName]
	local bones = config.bone
	local bone = bones["head"]
    
    local totalHeadName = self.m_sAninName .. "_head_" .. _sIndex
    if self.m_headRanSeIndex > 0 then 
        totalHeadName = totalHeadName .. "_hs" .. self:_formatIndex(self.m_headRanSeIndex)
    end

    local path = "player/" .. self.m_sAninName .. "/" .. _sIndex 
    self:_checkArmature(totalHeadName,_sIndex,path .. "/" .. totalHeadName)

    for i,v in ipairs(bone) do
		local bone = self.m_node:getArmature():getBone(v)
        local name = v .. _sIndex
        --print(i,v,bone,name)
        if bone ~= nil then            
            bone = tolua.cast(bone,"CCNode")
            local name = v .. "_" ..  _sIndex
            if self.m_headRanSeIndex > 0 then 
                name = name .. "_hs" .. self:_formatIndex(self.m_headRanSeIndex)
            end
            bone:setVisible(true)
            if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(name) ~= nil then
                self.m_node:setDisplayData(0,v,name)
            end
            
        end
	end
end

function YDPlayerAnimation:_setArmatureSpineHead(sIndex,sRanSeIndex_)
	local _sIndex = self:_formatIndex(sIndex)
	local totalHeadName = self.m_sAninName .. "_head_" .. _sIndex
	
	local path1 = "player_sp/combatboy/" .. _sIndex .. "/combatboy_head_1_" .. _sIndex
	local path2 = "player_sp/combatboy/" .. _sIndex .. "/combatboy_head_2_" .. _sIndex
	local path3 = "player_sp/combatboy/" .. _sIndex .. "/combatboy_head_3_" .. _sIndex
	
	local head1 = self.m_sAninName .. "_head_1"
	local head2 = self.m_sAninName .. "_head_2"
	local head3 = self.m_sAninName .. "_head_3"
	
	local atlasPath1 = path1
	local atlasPath2 = path2
	local atlasPath3 = path3
	
	if self.m_headRanSeIndex > 0 then 
		local tmpPath1 = path1 .. "_hs" .. self:_formatIndex(self.m_headRanSeIndex)
		if WZDataFile:getInstance():checkFileExist(tmpPath1 .. ".atlas") then 
			atlasPath1 = path1 .. "_hs" .. self:_formatIndex(self.m_headRanSeIndex)
			atlasPath2 = path2 .. "_hs" .. self:_formatIndex(self.m_headRanSeIndex)
			atlasPath3 = path3 .. "_hs" .. self:_formatIndex(self.m_headRanSeIndex)
		end
	end 
	
	self.m_node:setSpineDisplayData(0,head1,path1 .. ".json",atlasPath1 .. ".atlas")
	self.m_node:setSpineDisplayData(0,head2,path2 .. ".json",atlasPath2 .. ".atlas")
	self.m_node:setSpineDisplayData(0,head3,path3 .. ".json",atlasPath3 .. ".atlas")
end


function YDPlayerAnimation:_setSpineSpineHead(sIndex,sRanSeIndex_)
	local _sIndex = self:_formatIndex(sIndex)
	
	local path1 = "player_sp/combatboy/" .. _sIndex .. "/combatboy_head_1_" .. _sIndex
	local path2 = "player_sp/combatboy/" .. _sIndex .. "/combatboy_head_2_" .. _sIndex
	local path3 = "player_sp/combatboy/" .. _sIndex .. "/combatboy_head_3_" .. _sIndex
	
	local head1 = self.m_sAninName .. "_head_1"
	local head2 = self.m_sAninName .. "_head_2"
	local head3 = self.m_sAninName .. "_head_3"
	
	local atlasPath1 = path1
	local atlasPath2 = path2
	local atlasPath3 = path3
	
	if self.m_headRanSeIndex > 0 then 
		local tmpPath1 = path1 .. "_hs" .. self:_formatIndex(self.m_headRanSeIndex)
		print(tmpPath1)
		print(WZDataFile:getInstance():checkFileExist(tmpPath1 .. ".atlas"))
		if WZDataFile:getInstance():checkFileExist(tmpPath1 .. ".atlas") then 
			atlasPath1 = path1 .. "_hs" .. self:_formatIndex(self.m_headRanSeIndex)
			atlasPath2 = path2 .. "_hs" .. self:_formatIndex(self.m_headRanSeIndex)
			atlasPath3 = path3 .. "_hs" .. self:_formatIndex(self.m_headRanSeIndex)
		end
	end 
	
	local tmp = SkeletonAnimation:createWithFile(path1 .. ".json",atlasPath1 .. ".atlas",1)
	self.m_spineNode:bindSlot(head1,tmp)
	
	tmp = SkeletonAnimation:createWithFile(path2 .. ".json",atlasPath2 .. ".atlas",1)
	self.m_spineNode:bindSlot(head2,tmp)
	
	tmp = SkeletonAnimation:createWithFile(path3 .. ".json",atlasPath3 .. ".atlas",1)
	self.m_spineNode:bindSlot(head3,tmp)
end

function YDPlayerAnimation:_setSpineArmatureHead(sIndex,sRanSeIndex_)
	local _sIndex = self:_formatIndex(sIndex)
    local sRanSeIndex = sRanSeIndex_ or 0
	--CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("player/combatboy/033/combatboy_head_033" .. ".png","player/combatboy/033/combatboy_head_033" .. ".plist","player/combatboy/033/combatboy_head_033" .. ".xml")
	local totalHeadName = self.m_sAninName .. "_head_" .. _sIndex
    if self.m_headRanSeIndex > 0 then 
        totalHeadName = totalHeadName .. "_hs" .. self:_formatIndex(self.m_headRanSeIndex)
    end
	
	local head1 = self.m_sAninName .. "_head_1"
	local head2 = self.m_sAninName .. "_head_2"
	local head3 = self.m_sAninName .. "_head_3"
	
    local path = "player/" .. self.m_sAninName .. "/" .. _sIndex 
    self:_checkArmature(totalHeadName,_sIndex,path .. "/" .. totalHeadName)
	
	local tmp = CCArmature:create(self.m_sAninName .. "_head_1_" .. _sIndex)
	self.m_spineNode:bindSlot(head1,tmp)
	
	tmp = CCArmature:create(self.m_sAninName .. "_head_2_" .. _sIndex)
	self.m_spineNode:bindSlot(head2,tmp)
	
	tmp = CCArmature:create(self.m_sAninName .. "_head_3_" .. _sIndex)
	self.m_spineNode:bindSlot(head3,tmp)
end

--@brief	设置坐骑的显示索引
--@param	sIndex 索引值
function YDPlayerAnimation:setMount(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	self.m_mountIndex = tonumber(sIndex)
    if self:isMonster() then return end
	if self.m_running ~= true then return end
	
	local spinePath = "player_sp/mount/" .. _sIndex .. "/" .. "mount_body_" .. _sIndex
	self.m_spineMount = false
	if WZDataFile:getInstance():checkFileExist(spinePath .. ".json") then 
		self.m_spineMount = true
	end
	
	if self.m_spineBody == true then 
		if self.m_spineMount == true then 
			self:_setSpineSpineMount(sIndex)
		else 
			self:_setSpineArmatureMount(sIndex)
		end
	else
		if self.m_spineMount == true then 
			self:_setArmatureSpineMount(sIndex)
		else 
			self:_setArmatureArmatureMount(sIndex)
		end
	end
	
end

function YDPlayerAnimation:_setArmatureArmatureMount(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	local config = g_YDPlayerAnimation_Config[self.m_sAninName]
	local bones = config.bone
	local bone = bones["mount"]
	
	local displayName = "mount_" .. _sIndex
	local path = "player/mount/" .. displayName
	self:_checkArmature(displayName,_sIndex,path)
	local mountHead = "mount_head_" .. _sIndex
	local mountBody = "mount_body_" .. _sIndex
	
	for i,v in ipairs(bone) do
		local bone = self.m_node:getArmature():getBone(v)
		bone = tolua.cast(bone,"CCNode")
		
		local findex = 0
		findex,_ = string.find(v,"body")
		bone:setVisible(true)
		if findex ~= nil then
			if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(mountBody) ~= nil then
				self.m_node:setDisplayData(0,v,mountBody)
			end
		else
			if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(mountHead) ~= nil then
				self.m_node:setDisplayData(0,v,mountHead)
			end
		end
	end
end

function YDPlayerAnimation:_setArmatureSpineMount(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	local spineBodyPath = "player_sp/mount/" .. _sIndex .. "/" .. "mount_body_" .. _sIndex
	local spineHeadPath = "player_sp/mount/" .. _sIndex .. "/" .. "mount_head_" .. _sIndex
	local mountBody = self.m_sAninName .. "_mount_body"
	local mountHead = self.m_sAninName .. "_mount_head"
	self.m_node:setSpineDisplayData(0,mountBody,spineBodyPath .. ".json",spineBodyPath .. ".atlas")
	self.m_node:setSpineDisplayData(0,mountHead,spineHeadPath .. ".json",spineHeadPath .. ".atlas")
end

function YDPlayerAnimation:_setSpineArmatureMount(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	local displayName = "mount_" .. _sIndex
	local path = "player/mount/" .. displayName
	self:_checkArmature(displayName,_sIndex,path)
	local mountBody = self.m_sAninName .. "_mount_body"
	local mountHead = self.m_sAninName .. "_mount_head"
	local tmp = CCArmature:create("mount_body_" .. _sIndex)
	self.m_spineNode:bindSlot(mountBody,tmp)

	tmp = CCArmature:create("mount_head_" .. _sIndex)
	self.m_spineNode:bindSlot(mountHead,tmp)
end

function YDPlayerAnimation:_setSpineSpineMount(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	local spineBodyPath = "player_sp/mount/" .. _sIndex .. "/" .. "mount_body_" .. _sIndex
	local spineHeadPath = "player_sp/mount/" .. _sIndex .. "/" .. "mount_head_" .. _sIndex
	local mountBody = self.m_sAninName .. "_mount_body"
	local mountHead = self.m_sAninName .. "_mount_head"
	local tmp = SkeletonAnimation:createWithFile(spineHeadPath .. ".json",spineHeadPath .. ".atlas",1)
	self.m_spineNode:bindSlot(mountHead,tmp)
	
	tmp = SkeletonAnimation:createWithFile(spineBodyPath .. ".json",spineBodyPath .. ".atlas",1)
	self.m_spineNode:bindSlot(mountBody,tmp)
end

function YDPlayerAnimation:setBody(nIndex, bBoy)
	WZLog("YDPlayerAnimation:setBody", nIndex, bBoy)
	self.m_bodyIndex = tonumber(nIndex)
	self.m_d_bodyIndex = tonumber(nIndex)

    local sIndex = YDPlayerAnimation:_formatIndex(tonumber(nIndex))
    local animName = self.m_sAninName .. "_body_" .. sIndex
    local pathName = "player/" .. self.m_sAninName .. "/" .. sIndex .. "/" .. animName
    local existArmature = WZDataFile:getInstance():checkFileExist(pathName .. ".xml")
    if existArmature then 
        WZLog("YDPlayerAnimation:setBody exist",nIndex)
		self:_setBody(nIndex, bBoy)
        return
    end
    WZLog("YDPlayerAnimation:setBody not exist",nIndex) 
	self:_setBody(11, bBoy)

	local downloadInfo = self:getDownloadInfo(sIndex)
    if downloadInfo == nil then return end 
    --create(int taskId, const char* url,const char* md5,const char* extraData, int luaCallbackHandle, int luaCallbackTableHandle = 0);

	DownloadManager:addDownloadTask(nIndex,downloadInfo.url,downloadInfo.md5,sIndex,"downloadBodyCallback",self)
end

function YDPlayerAnimation:downloadBodyCallback(taskId,extraData,failed)
    WZLog("YDPlayerAnimation:downloadBodyCallback",taskId,extraData,failed)
    WZLog("YDPlayerAnimation:downloadBodyCallback_1",self.m_d_bodyIndex)
    if failed == 0 then 
		self:_setBody(self.m_d_bodyIndex, bBoy)
		self:play(self.m_playName, self.m_isLoop)
    end
end

--@brief	设置身体的显示索引
--@param	sIndex 索引值
function YDPlayerAnimation:_setBody(sIndex,bBoy)
	self.m_bodyIndex = tonumber(sIndex)
    if self:isMonster() then return end
	if self.m_running ~= true then
		return
	end 
	if self.m_currentBodyIndex == self.m_bodyIndex and bBoy == nil then 
		return 
	end 	
	--self.m_bodyIndex = 0
	local _sIndex = self:_formatIndex(sIndex)
	if bBoy ~= nil then 
		if bBoy == true then
			self.m_sAninName = "combatboy"
			self.m_bBoy = true
		else 
			self.m_sAninName = "combatgirl"
			self.m_bBoy = false
		end
	end
	self:setArmatureName(self.m_sAninName,_sIndex)
	
	
	if self.m_weaponGunIndex ~= nil and self.m_weaponGunIndex > 0 then
		self:setWeaponGun(self.m_weaponGunIndex)
	end 
	
	if self.m_weaponBombIndex ~= nil and self.m_weaponBombIndex > 0 then 
		self:setWeaponBomb(self.m_weaponBombIndex)
	end 
	
	if self.m_wingIndex ~= nil and self.m_wingIndex > 0 then 
		self.m_currentWingIndex = 0
		self:setWing(self.m_wingIndex)
	end 
	
	if self.m_faceIndex ~= nil and self.m_faceIndex > 0 then 
		self.m_currentFaceIndex = 0
		self:_setFace(self.m_faceIndex)
	end 
	
	if self.m_headIndex ~= nil and self.m_headIndex > 0 then 
		self.m_currentHeadIndex = 0
		self:_setHead(self.m_headIndex,self.m_headRanSeIndex)
	end 
	
	if self.m_mountIndex ~= nil and self.m_mountIndex > 0 then 
		self:setMount(self.m_mountIndex)
	end
        
    if self.m_bodyRanSeIndex ~= nil and self.m_bodyRanSeIndex > 0  and self.m_spineBody ~= true then 
        self:setBodyRanSe(self.m_bodyRanSeIndex)
    end
	
	if self.m_bLoadGhost == true then self:setGhost() end
    if self.m_bLoadGunBigSkill == true then self:setGunBigSkill() end
    if self.m_bLoadWeaponBigSkill == true then self:setWeaponBigSkill() end
	self.m_currentBodyIndex = self.m_bodyIndex
    --self.m_currentBodyRanSeIndex = 0
    self.m_node:setContentSize(GlobalMethod:CCSize(150,150))
end

--@brief	设置身体的染色索引
--@param	sIndex 索引值
function YDPlayerAnimation:setBodyRanSe(sIndex)
    self.m_bodyRanSeIndex = tonumber(sIndex)
    if self:isMonster() then return end
    if self.m_running ~= true then
		return
	end
    
	if self.m_spineBody == true then 
		self:_setBodyRanSeSpine(sIndex)
	else 
		self:_setBodyRanSeArmature(sIndex)
	end
    self.m_currentBodyRanSeIndex = self.m_bodyRanSeIndex
end

function YDPlayerAnimation:_setBodyRanSeSpine(sIndex)
	self.m_currentBodyIndex = 0
	self:_setBody(self.m_bodyIndex)
end


function YDPlayerAnimation:_setBodyRanSeArmature(sIndex)
	local dict = self.m_node:getArmature():getBoneDic()
    local arr =  dict:allKeys()
    local nonBody = self:_getNonBodyBone()
    local _sBodyIndex = self:_formatIndex(self.m_bodyIndex)
    local _sIndex = self:_formatIndex(sIndex)
    local xmlFile = "player/" .. self.m_sAninName .. "/" .. _sBodyIndex .. "/" .. self.m_sAninName .. "_body_" .. _sBodyIndex .. "_rs.xml"
    --print(xmlFile,WZDataFile:getInstance():checkFileExist(xmlFile))
    if  not WZDataFile:getInstance():checkFileExist(xmlFile) then
        return
    end
    local animName = self.m_sAninName .. "_body_" .. _sBodyIndex .. "_rs" .. _sIndex
    if self.m_bodyRanSeIndex > 0 then 
        local pathName = "player/" .. self.m_sAninName .. "/" .. _sBodyIndex .. "/" .. animName
        if  not WZDataFile:getInstance():checkFileExist(pathName .. ".plist") then
            return
        end
        WZDataFile:getInstance():loadTexturePackFile(pathName .. ".plist")
        table.insert(self.m_tLoadPlist,pathName)
    end
    local doc = WZDataFile:getInstance():createXmlDocument(xmlFile)
    local rootElem = doc:getRootElement()
    local armatureElem = rootElem:findChildElement("armatures"):findChildElement("armature")
    local boneElem = armatureElem:firstChildElement()
    
    while boneElem
    do
        local str = boneElem:attributeString("name")
        local exist = false
        for k,v in ipairs(nonBody) do
            if v == str then 
                exist = true
            end
        end
        if exist == false then
            local displayElem = boneElem:firstChildElement()
            local displayIndex = 0
            while displayElem 
            do
                local displayName = displayElem:attributeString("name")
                
                displayElem = displayElem:nextSiblingElement()
                if self.m_bodyRanSeIndex > 0 then 
                    local displayName_ = displayName .. "_rs" .. _sIndex .. ".png"
                    self.m_node:setDisplayData(displayIndex,str,displayName_)
                else
                    self.m_node:setDisplayData(displayIndex,str,displayName .. ".png")
                end
                
                displayIndex = displayIndex + 1
            end            
        end
        
        
        boneElem = boneElem:nextSiblingElement()
    end
end

--@brief	设置枪的显示索引
--@param	sIndex 索引值 _changeSpineWeaponDisplay
function YDPlayerAnimation:setWeaponGun(sIndex)
	--self:_changeDisplay("weapon_gun",sIndex)
	self.m_weaponGunIndex = tonumber(sIndex)
    if self:isMonster() then return end
	if self.m_running ~= true then
		return
	end 
	
	if self.m_spineBody == true then 
		self:_setSpineWeaponGun(sIndex)
	else
		self:_setArmatureWeaponGun(sIndex)
	end 
	
end
--weapon_gun = {"combatgirl_gun_back","combatgirl_gun"},
--weapon_bomb = {"combatgirl_bomb_back","combatgirl_bomb"},
function YDPlayerAnimation:_setSpineWeaponGun(sIndex)
	local bone = self.m_sAninName .. "_gun"
	self:_changeSpineWeaponDisplay(bone,sIndex)
	bone = bone .. "_back"
	self:_changeSpineWeaponDisplay(bone,sIndex)
	bone = self.m_sAninName .. "_bomb"
	self.m_spineNode:unbindSlot(bone)
	bone = bone .. "_back"
	self.m_spineNode:unbindSlot(bone)
end

function YDPlayerAnimation:_setArmatureWeaponGun(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	local config = g_YDPlayerAnimation_Config[self.m_sAninName]
	local bones = config.bone
	local bone = bones["weapon_gun"]
	for i,v in ipairs(bone) do 
		self:_changeWeaponDisplay(v,_sIndex)
	end 
	
	if self.m_node == nil or self.m_node:getArmature() == nil then 
		return 
	end 
	
	for i,v in ipairs(bone) do 
		local bone = self.m_node:getArmature():getBone(v)
		bone = tolua.cast(bone,"CCNode")
		if bone ~= nil then bone:setVisible(true)  end 
	end 
	bone = bones["weapon_bomb"]
	for i,v in ipairs(bone) do 
		local bone = self.m_node:getArmature():getBone(v)
		bone = tolua.cast(bone,"CCNode")
		if bone ~= nil then bone:setVisible(false)  end 
	end 	
end

--@brief	设置炸弹的显示索引
--@param	sIndex 索引值
function YDPlayerAnimation:setWeaponBomb(sIndex)
	self.m_weaponBombIndex = tonumber(sIndex)
    if self:isMonster() then return end
	if self.m_running ~= true then 
		return
	end
	--self:_changeDisplay("weapon_bomb",sIndex)
	if self.m_spineBody == true then 
		self:_setSpineWeaponBomb(sIndex)
	else
		self:_setArmatureWeaponBomb(sIndex)
	end 
end

function YDPlayerAnimation:_setSpineWeaponBomb(sIndex)
	local bone = self.m_sAninName .. "_bomb"
	self:_changeSpineWeaponDisplay(bone,sIndex)
	bone = bone .. "_back"
	self:_changeSpineWeaponDisplay(bone,sIndex)
	bone = self.m_sAninName .. "_gun"
	self.m_spineNode:unbindSlot(bone)
	bone = bone .. "_back"
	self.m_spineNode:unbindSlot(bone)
end

function YDPlayerAnimation:_setArmatureWeaponBomb(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	local config = g_YDPlayerAnimation_Config[self.m_sAninName]
	local bones = config.bone
	local bone = bones["weapon_bomb"]
	for i,v in ipairs(bone) do 
		self:_changeWeaponDisplay(v,_sIndex)
	end 
	
	if self.m_node == nil or self.m_node:getArmature() == nil then 
		return 
	end 
	
	for i,v in ipairs(bone) do 
		local bone = self.m_node:getArmature():getBone(v)
		bone = tolua.cast(bone,"CCNode")
		if bone ~= nil then bone:setVisible(true)  end 
	end 
	bone = bones["weapon_gun"]
	for i,v in ipairs(bone) do 
		local bone = self.m_node:getArmature():getBone(v)
		bone = tolua.cast(bone,"CCNode")
		if bone ~= nil then bone:setVisible(false)  end 
	end 
end

function YDPlayerAnimation:setFace(nIndex)
	WZLog("YDPlayerAnimation:setFace", nIndex)
	self.m_faceIndex = tonumber(nIndex)
	self.m_d_faceIndex = tonumber(nIndex)

    local sIndex = YDPlayerAnimation:_formatIndex(tonumber(nIndex))
    local animName = self.m_sAninName .. "_face_" .. sIndex
    local pathName = "player/" .. self.m_sAninName .. "/" .. sIndex .. "/" .. animName
    local existArmature = WZDataFile:getInstance():checkFileExist(pathName .. ".xml")
    if existArmature then 
        WZLog("YDPlayerAnimation:setFace exist",nIndex)
		self:_setFace(nIndex)
        return
    end
    WZLog("YDPlayerAnimation:setFace not exist",nIndex) 
	self:_setFace(11)


	local downloadInfo = self:getDownloadInfo(sIndex)
    if downloadInfo == nil then return end 

    --create(int taskId, const char* url,const char* md5,const char* extraData, int luaCallbackHandle, int luaCallbackTableHandle = 0);
	DownloadManager:addDownloadTask(nIndex,downloadInfo.url,downloadInfo.md5,sIndex,"downloadFaceCallback",self)
end

function YDPlayerAnimation:downloadFaceCallback(taskId,extraData,failed)
    WZLog("YDPlayerAnimation:downloadFaceCallback",taskId,extraData,failed)
    WZLog("YDPlayerAnimation:downloadFaceCallback_1",self.m_d_faceIndex)
    if failed == 0 then 
		self:_setFace(self.m_d_faceIndex)
		self:play(self.m_playName, self.m_isLoop)
    end
end

--@brief	设置脸谱的显示索引
--@param	sIndex 索引值
function YDPlayerAnimation:_setFace(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	self.m_faceIndex = tonumber(sIndex)
    if self:isMonster() then return end
	if self.m_running ~= true then 
		return
	end
	-- if self.m_currentFaceIndex == self.m_faceIndex then 
		-- return
	-- end 
	
	--self:_changeDisplay("face",_sIndex)
	local faceName = self.m_sAninName .. "_face_" .. _sIndex
	local spinePath = "player_sp/" .. self.m_sAninName .. "/" .. _sIndex .. "/" .. faceName
	self.m_spineFace = false
	if WZDataFile:getInstance():checkFileExist(spinePath .. ".json") then 
		self.m_spineFace = true
	end 
	
    if self.m_spineBody == true then 
		if self.m_spineFace == true then 
			self:_setSpineSpineFace(sIndex)
		else
			self:_setSpineArmatureFace(sIndex)
		end
	else 
		if self.m_spineFace == true then 
			self:_setArmatureSpineFace(sIndex)
		else
			self:_setArmatureArmatureFace(sIndex)
		end
	end
	
    self.m_currentFaceIndex = self.m_faceIndex
end

function YDPlayerAnimation:_setArmatureSpineFace(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	local faceName = self.m_sAninName .. "_face_" .. _sIndex
    local path = "player_sp/" .. self.m_sAninName .. "/" .. _sIndex .. "/" .. faceName
	local boneName = self.m_sAninName .. "_face_tmp"
	self.m_node:setSpineDisplayData(0,boneName,path .. ".json",path .. ".atlas")
end

function YDPlayerAnimation:_setArmatureArmatureFace(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	local config = g_YDPlayerAnimation_Config[self.m_sAninName]
	local bones = config.bone
	local bone = bones["face"]
    
    local faceName = self.m_sAninName .. "_face_" .. _sIndex

    local path = "player/" .. self.m_sAninName .. "/" .. _sIndex
    self:_checkArmature(faceName,_sIndex,path .. "/" .. faceName)
    for i,v in ipairs(bone) do
		local bone = self.m_node:getArmature():getBone(v)
        local name = v .. _sIndex
        --print(i,v,bone,name)
        if bone ~= nil then            
            bone = tolua.cast(bone,"CCNode")
            local name = faceName
            bone:setVisible(true)
            if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(name) ~= nil then
                self.m_node:setDisplayData(0,v,name)
            end
            
        end
	end
end


function YDPlayerAnimation:_setSpineArmatureFace(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	local faceName = self.m_sAninName .. "_face_" .. _sIndex

    local path = "player/" .. self.m_sAninName .. "/" .. _sIndex
    self:_checkArmature(faceName,_sIndex,path .. "/" .. faceName)
	local tmp = CCArmature:create("combatboy_face_" .. _sIndex)
	local boneName = self.m_sAninName .. "_face_tmp"
	self.m_spineNode:bindSlot(boneName,tmp)
end

function YDPlayerAnimation:_setSpineSpineFace(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	local faceName = self.m_sAninName .. "_face_" .. _sIndex

    local path = "player_sp/" .. self.m_sAninName .. "/" .. _sIndex .. "/" .. faceName
	local tmp = SkeletonAnimation:createWithFile(path .. ".json",path .. ".atlas",1)
	local boneName = self.m_sAninName .. "_face_tmp"
	self.m_spineNode:bindSlot(boneName,tmp)
end

--@brief    设置翅膀的显示索引
--@param	sIndex	索引id
function YDPlayerAnimation:setWing(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	self.m_wingIndex = tonumber(_sIndex)
    if self:isMonster() then return end
	if self.m_running ~= true then 
		return
	end 
	--if true then return end
	-- if self.m_currentWingIndex == self.m_wingIndex then 
		-- return 
	-- end 
	local spinePathR = "player_sp/wing/" .. _sIndex .. "/wing_R_" .. _sIndex
	self.m_spineWing = false
	if WZDataFile:getInstance():checkFileExist(spinePathR .. ".json") then 
		self.m_spineWing = true
	end 
	
    if self.m_spineBody == true then 
		if self.m_spineWing == true then 
			self:_setSpineSpineWing(sIndex)
		else
			self:_setSpineArmatureWing(sIndex)
		end
	else 
		if self.m_spineWing == true then 
			self:_setArmatureSpineWing(sIndex)
		else
			self:_setArmatureArmatureWing(sIndex)
		end
	end
	
	self.m_currentWingIndex = self.m_wingIndex
end

function YDPlayerAnimation:_setArmatureSpineWing(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	local pathL = "player_sp/wing/" .. _sIndex .. "/wing_L_" .. _sIndex
	local pathR = "player_sp/wing/" .. _sIndex .. "/wing_R_" .. _sIndex
	
	local boneR = self.m_sAninName .. "_wing_R"
	local boneL = self.m_sAninName .. "_wing_L"
	
	self.m_node:setSpineDisplayData(0,boneL,pathL .. ".json",pathL .. ".atlas")
	self.m_node:setSpineDisplayData(0,boneR,pathR .. ".json",pathR .. ".atlas")
end

function YDPlayerAnimation:_setArmatureArmatureWing(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	local config = g_YDPlayerAnimation_Config[self.m_sAninName]
	local bones = config.bone
	local bone = bones["wing"]
    local path = "player/wing/" .. "wing_" .. _sIndex
	for i,v in ipairs(bone) do
        local displayName = string.gsub(v,self.m_sAninName .. "_","")
        displayName = displayName .. "_" .. _sIndex
		self:_checkArmature(displayName,_sIndex,path)
		local bone = self.m_node:getArmature():getBone(v)
		bone = tolua.cast(bone,"CCNode")
		
		local flyBone = self.m_node:getArmature():getBone(self.m_sAninName .. "_fly")
		flyBone = tolua.cast(flyBone,"CCNode")
		
		if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(displayName) == nil then 
			if bone ~= nil then 
                bone:setVisible(false)
            end
			if flyBone ~= nil then 
				flyBone:setVisible(true)
			end
			
		else
            if bone ~= nil then 
                bone:setVisible(true)
            end
			if flyBone ~= nil then 
				flyBone:setVisible(false)
			end
			self.m_node:setDisplayData(0,v,displayName)
		end 
	end 
end


function YDPlayerAnimation:_setSpineArmatureWing(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	local path = "player/wing/" .. "wing_" .. _sIndex
	local displayR = "wing_R_" .. _sIndex
	local displayL = "wing_L_" .. _sIndex
	self:_checkArmature(displayR,_sIndex,path)
	self:_checkArmature(displayL,_sIndex,path)
	
	local boneR = self.m_sAninName .. "_wing_R"
	local boneL = self.m_sAninName .. "_wing_L"
	
	local tmp = CCArmature:create(displayL)
	self.m_spineNode:bindSlot(boneL,tmp)	

	tmp = CCArmature:create(displayR)
	self.m_spineNode:bindSlot(boneR,tmp)
end

function YDPlayerAnimation:_setSpineSpineWing(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	
	local pathR = "player_sp/wing/" .. _sIndex .. "/wing_R_" .. _sIndex
	local pathL = "player_sp/wing/" .. _sIndex .. "/wing_L_" .. _sIndex
	
	local boneR = self.m_sAninName .. "_wing_R"
	local boneL = self.m_sAninName .. "_wing_L"
	
	local tmp = SkeletonAnimation:createWithFile(pathL .. ".json",pathL .. ".atlas",1)
	self.m_spineNode:bindSlot(boneL,tmp)
	
	tmp = SkeletonAnimation:createWithFile(pathR .. ".json",pathR .. ".atlas",1)
	self.m_spineNode:bindSlot(boneR,tmp)
end


--@brief	加载枪的大招动画
function YDPlayerAnimation:setGunBigSkill()
    self.m_bLoadGunBigSkill = true
    if self:isMonster() then return end
    if self.m_running ~= true then return end
	local boneName = "wuqi"
	local path = "player/wuqi/wuqi"
	local displayName = "wuqi"
	self:_checkArmature(displayName,"",path)
	local bone = self.m_node:getArmature():getBone(boneName)
	if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(displayName) ~= nil then
		self.m_node:setDisplayData(0,boneName,displayName)
	end
end

--@brief	加载枪的大招动画
function YDPlayerAnimation:setWeaponBigSkill(sIndex)
    self.m_bLoadWeaponBigSkill = true
    if self:isMonster() then return end
    if self.m_running ~= true then return end
    sIndex = sIndex or "2"
    local index = tonumber(sIndex)
	local boneName = "wuqi2"
	local path = "player/wuqi/wuqi" .. index
	local displayName = "wuqi" .. index
	self:_checkArmature(displayName,"",path)
	local bone = self.m_node:getArmature():getBone(boneName)
	if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(displayName) ~= nil then
		self.m_node:setDisplayData(0,boneName,displayName)
	end
end 
 
--combatboy_ghost
function YDPlayerAnimation:setGhost()
	self.m_bLoadGhost = true
    if self:isMonster() then return end
	if self.m_running ~= true then return end
	local boneName = "ghost"
	local displayName = self.m_sAninName .. "_" .. boneName
	local path = "player/" .. self.m_sAninName .. "/ghost/" .. displayName
	self:_checkArmature(displayName,"",path)
	
	if self.m_spineBody == true then 
		local tmp = CCArmature:create(displayName)
		self.m_spineNode:bindSlot(displayName,tmp)
	else 
		local bone = self.m_node:getArmature():getBone(displayName)
		if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(displayName) ~= nil then
			self.m_node:setDisplayData(0,displayName,displayName)
		end
	end
end

function YDPlayerAnimation:playGunAnim()
    if self:isMonster() then return end
	self:_playIndex(1,"wuqi",1)
end

--@brief	设置头的显示索引
--@param	sActionName 动作名称 例如: walk wait run等
--@param	bLoop 是否循环播放
function YDPlayerAnimation:play(sActionName,bLoop)
    --WZLog("YDPlayerAnimation:play", tostring(self:getAnimNode()), sActionName, tostring(bLoop))
    --如果处于被冰冻状态，不换动画
    if self.m_bIsStopFaceAndWindAnim then
        return
    end
	self.m_playName = sActionName
	self.m_isLoop = bLoop
	if self.m_running ~= true then	
		return
	end
	self.m_currentAction = sActionName
    if self:isMonster() then 
        self:playMonster(sActionName,bLoop)
        return 
    end
    
	local nLoop = 0
	if bLoop == true then nLoop = 1 end
    if self.m_node:getChildByTag(250) ~= nil then 
        self.m_node:removeChildByTag(250,true)
    end
	--self.m_playName = nil
	--self.m_isLoop = false
	local config = g_YDPlayerAnimation_Config[self.m_sAninName]
	local actionInfo = config.action[sActionName]
    if self.m_bShop == true then 
        actionInfo = config.shop_action[sActionName]
    end
	if actionInfo == nil then return end 
	if actionInfo["zDefault"] == nil then return end 
	
	if self.m_spineBody == true then 
		self.m_spineNode:play(sActionName,nLoop==1)
	else
		self:_playIndex(actionInfo["zDefault"],"",nLoop)
	end
	
	self:_playHead(sActionName,bLoop)
	self:_playFace(sActionName,bLoop)
	self:_playWing(sActionName,bLoop)
	self:_playMount(sActionName,bLoop)
	self:_playGhost(sActionName,bLoop)
	
    local sIndex = self:_formatIndex(tonumber(self.m_bodyIndex))
	local boneName = self.m_sAninName .. "_body_" .. sIndex .."_effect"
    local combatActionInfo = config.action[sActionName]
    self:_playIndex(combatActionInfo["zDefault"],boneName,nLoop)
	local i = 0
    
    if self.m_node:getArmature() ~= nil then 
        for i = 1,5 do
            local boneName = self.m_sAninName .. "_child_" .. i
            local bone = self.m_node:getArmature():getBone(boneName)
            --print("YDPlayerAnimation:play",boneName,bone)
            if bone ~= nil then 
                self:_playIndex(0,boneName,nLoop)
            end 
        end
        
        if sActionName ==  "avatar" then 
            self.m_node:getArmature():setDisableUpdate(true)
        else 
            self.m_node:getArmature():setDisableUpdate(false)
        end
    end
    --print(sActionName,config.particle["body_".._sIndex],_sIndex)
    -- walk   wait  walk2 wait0   run    win   win2 
    self:loadParticle()
end


function YDPlayerAnimation:_playHead(sActionName,bLoop)
	local config = g_YDPlayerAnimation_Config[self.m_sAninName]
	local actionInfo = config.action[sActionName]
    if self.m_bShop == true then 
        actionInfo = config.shop_action[sActionName]
    end
	if actionInfo == nil then return end
	local nLoop = 0
	if bLoop == true then nLoop = 1 end
	local head1 = self.m_sAninName .. "_head_1"
	local head2 = self.m_sAninName .. "_head_2"
	local head3 = self.m_sAninName .. "_head_3"
	local nIndex = actionInfo[head1]
	if nIndex == nil then return end 
	local spineAction = g_YDPlayerAnimation_Config.headAction["" .. nIndex]
	--if nIndex == 1 then spineAction = "avatar" end
	if self.m_spineBody == true then 
		if self.m_spineHead == true then 
			self:_playSpineAction(self.m_spineNode:getBindNode(head1),spineAction,bLoop)
			self:_playSpineAction(self.m_spineNode:getBindNode(head2),spineAction,bLoop)
			self:_playSpineAction(self.m_spineNode:getBindNode(head3),spineAction,bLoop)
		else
			self:_playArmatureAction(self.m_spineNode:getBindNode(head1),nIndex,nLoop)
			self:_playArmatureAction(self.m_spineNode:getBindNode(head2),nIndex,nLoop)
			self:_playArmatureAction(self.m_spineNode:getBindNode(head3),nIndex,nLoop)
		end
	else 
		if self:_getChildBone(head1) == nil then return end
		if self.m_spineHead == true then 
			self:_playSpineAction(self:_getChildBone(head1):getChildSpine(),spineAction,bLoop)
			self:_playSpineAction(self:_getChildBone(head2):getChildSpine(),spineAction,bLoop)
			self:_playSpineAction(self:_getChildBone(head3):getChildSpine(),spineAction,bLoop)
		else
			self:_playArmatureAction(self:_getChildBone(head1):getChildArmature(),nIndex,nLoop)
			self:_playArmatureAction(self:_getChildBone(head2):getChildArmature(),nIndex,nLoop)
			self:_playArmatureAction(self:_getChildBone(head3):getChildArmature(),nIndex,nLoop)
		end
	end
end

function YDPlayerAnimation:_playFace(sActionName,bLoop)
	local config = g_YDPlayerAnimation_Config[self.m_sAninName]
	local actionInfo = config.action[sActionName]
    if self.m_bShop == true then 
        actionInfo = config.shop_action[sActionName]
    end
	if actionInfo == nil then return end
	local nLoop = 0
	if bLoop == true then nLoop = 1 end
	local boneName = self.m_sAninName .. "_face_tmp"
	local nIndex = actionInfo[boneName]
	if nIndex == nil then return end
	if self.m_spineBody == true then 
		if self.m_spineFace == true then 
			self:_playSpineAction(self.m_spineNode:getBindNode(boneName),sActionName,bLoop)
		else
			self:_playArmatureAction(self.m_spineNode:getBindNode(boneName),nIndex,nLoop)
		end
	else 
		if self:_getChildBone(boneName) == nil then return end
		if self.m_spineFace == true then 
			self:_playSpineAction(self:_getChildBone(boneName):getChildSpine(),sActionName,bLoop)
		else
			self:_playArmatureAction(self:_getChildBone(boneName):getChildArmature(),nIndex,nLoop)
		end
	end
end

function YDPlayerAnimation:_playWing(sActionName,bLoop)
	local config = g_YDPlayerAnimation_Config[self.m_sAninName]
	local actionInfo = config.action[sActionName]
    if self.m_bShop == true then 
        actionInfo = config.shop_action[sActionName]
    end
	if actionInfo == nil then return end
	local nLoop = 0
	if bLoop == true then nLoop = 1 end
	local boneR = self.m_sAninName .. "_wing_R"
	local boneL = self.m_sAninName .. "_wing_L"
	
	local nIndex = actionInfo[boneR]
	if nIndex == nil then return end
	local spineAction = g_YDPlayerAnimation_Config.wingAction["" .. nIndex] 
	if self.m_spineBody == true then 
		if self.m_spineWing == true then 
			self:_playSpineAction(self.m_spineNode:getBindNode(boneR),spineAction,bLoop)
			self:_playSpineAction(self.m_spineNode:getBindNode(boneL),spineAction,bLoop)
		else
			self:_playArmatureAction(self.m_spineNode:getBindNode(boneR),nIndex,nLoop)
			self:_playArmatureAction(self.m_spineNode:getBindNode(boneL),nIndex,nLoop)
		end
	else 
		if self:_getChildBone(boneR) == nil then return end
		if self.m_spineWing == true then 
			self:_playSpineAction(self:_getChildBone(boneR):getChildSpine(),spineAction,bLoop)
			self:_playSpineAction(self:_getChildBone(boneL):getChildSpine(),spineAction,bLoop)
		else
			self:_playArmatureAction(self:_getChildBone(boneR):getChildArmature(),nIndex,nLoop)
			self:_playArmatureAction(self:_getChildBone(boneL):getChildArmature(),nIndex,nLoop)
		end
	end
end

function YDPlayerAnimation:_playMount(sActionName,bLoop)
	local config = g_YDPlayerAnimation_Config[self.m_sAninName]
	local actionInfo = config.action[sActionName]
    if self.m_bShop == true then 
        actionInfo = config.shop_action[sActionName]
    end
	if actionInfo == nil then return end
	local nLoop = 0
	if bLoop == true then nLoop = 1 end
	local boneBody = self.m_sAninName .. "_mount_body"
	local boneHead = self.m_sAninName .. "_mount_head"
	
	local nIndex = actionInfo[boneBody]
	if nIndex == nil then return end
	local spineAction = g_YDPlayerAnimation_Config.mountAction["" .. nIndex]
	if self.m_spineBody == true then 
		if self.m_spineMount == true then 
			self:_playSpineAction(self.m_spineNode:getBindNode(boneHead),spineAction,bLoop)
			self:_playSpineAction(self.m_spineNode:getBindNode(boneBody),spineAction,bLoop)
		else
			self:_playArmatureAction(self.m_spineNode:getBindNode(boneHead),nIndex,nLoop)
			self:_playArmatureAction(self.m_spineNode:getBindNode(boneBody),nIndex,nLoop)
		end
	else 
		if self:_getChildBone(boneHead) == nil then return end
		if self.m_spineMount == true then 
			self:_playSpineAction(self:_getChildBone(boneHead):getChildSpine(),spineAction,bLoop)
			self:_playSpineAction(self:_getChildBone(boneBody):getChildSpine(),spineAction,bLoop)
		else
			self:_playArmatureAction(self:_getChildBone(boneHead):getChildArmature(),nIndex,nLoop)
			self:_playArmatureAction(self:_getChildBone(boneBody):getChildArmature(),nIndex,nLoop)
		end
	end
end

function YDPlayerAnimation:_playGhost(sActionName,bLoop)
	if sActionName ~= "ghost1" then return end
	local boneName = "ghost"
	local displayName = self.m_sAninName .. "_" .. boneName
	local nLoop = 0
	if bLoop == true then nLoop = 1 end
	if self.m_spineBody == true then 
		self:_playArmatureAction(self.m_spineNode:getBindNode(displayName),0,nLoop)
	else 
		self:_playArmatureAction(self:_getChildBone(displayName):getChildArmature(),0,nLoop)
	end
end


--@brief   根据人物动作播放怪物动作
--@param   sActionName 人物动作名字
--@param   bLoop 是否循环播放
function YDPlayerAnimation:playMonster(sActionName,bLoop)
    local animName = self:getMonsterAnimName(sActionName)
    if animName == nil then return end
    
    local child = self.m_node:getChildByTag(250)
    if child ~= nil then 
        child:removeFromParentAndCleanup(true)
    end
    local node = self.m_node:getChildNode()
    if node then node:setVisible(true) end
    if sActionName == "avatar" then 
        if GDatatab_shape_skins == nil then return end
        if GDatatab_shape_skins["id_" .. self.m_monsterId] == nil then return end
        local skins = GDatatab_shape_skins["id_" .. self.m_monsterId]
        local file = "battle/head/" .. skins.head .. ".png"
        local img = WZUIImage:create()
        img:setFile(file)
        img:setUseOriginSize(true)
		self.m_node:addChild(img,0,250)
        if node then node:setVisible(false) end
        return 
    end
    if sActionName == "ghost1" then 
        local armature = WZArmature:create()
        local pathName = "player/" .. self.m_sAninName .. "/ghost/" .. self.m_sAninName .. "_ghost"
        armature:setArmatureFile(pathName .. ".xml")
        armature:setPlistFile(pathName .. ".plist")
        armature:setArmatureName(self.m_sAninName .. "_ghost")
		self.m_node:addChild(armature,0,250)
        armature:getArmature():getAnimation():playByIndex(0,-1,-1,1);
        armature:setScale(1.3)
        if node then node:setVisible(false) end
        return 
    end 
    self.m_node:play(animName,bLoop == true);
end
--@brief   适配怪物动作
--@param   sActionName 人物动作名字
--@return  #1 返回人物动作对应的怪物动作名字
function YDPlayerAnimation:getMonsterAnimName(sActionName)
    if GDatatab_shape_animation == nil or sActionName == nil then 
        return nil
    end
    if GDatatab_shape_skins == nil then return nil end
    if self.m_monsterId == nil then return nil end
    if GDatatab_shape_skins["id_" .. self.m_monsterId] == nil then return nil end
    local skins = GDatatab_shape_skins["id_" .. self.m_monsterId]
    local actionId = skins.action_id
    for k,v in pairs(GDatatab_shape_animation) do 
        if v.human_act == sActionName and v.set == actionId then 
            return v.monster_act 
        end
    end
    return nil 
end

--@brief	获取骨骼动画的节点
--@return   返回绑定的骨骼动画实例
function YDPlayerAnimation:getAnimNode()
	return self.m_node
end

--@brief    判断当前是否在播放某个动画
--@param    sActionName 动画名字
--@return   #1, true 在播放 false 没有
function YDPlayerAnimation:isPlaying(sActionName)
    if self.m_running ~= true or self.m_node == nil then 
        return false
    end
    
    if self:isMonster() then
        local monsterAnim = self:getMonsterAnimName(sActionName)
        local animId = self.m_node:getAnimationName()
        return monsterAnim == animId
    end
    
	if self.m_spineBody == true then 
		return self.m_spineNode:getAnimationName() == sActionName
	else 
		local config = g_YDPlayerAnimation_Config[self.m_sAninName]
		local actionInfo = config.action[sActionName]
		if self.m_bShop == true then 
			actionInfo = config.shop_action[sActionName]
		end
		if actionInfo == nil then return end 
		if actionInfo["zDefault"] == nil then return end 
		local index = actionInfo["zDefault"]
		local ret = self.m_node:isPlayIndex(index)
		if ret == true then 
			if sActionName == "wait" or sActionName == "walk4" then 
				return sActionName == self.m_currentAction
			end
		end 
		return ret
	end
    return false
end

--@brief 判断当前动画是否播放结束
--@return #1, true 播放结束 false 正在播放中
function YDPlayerAnimation:isCurrentAnimationDone()
    if self.m_running ~= true then 
        return true
    end
    
    if self:isMonster() then 
        return self.m_node:isCurrentAnimationDone()
    end
    
	if self.m_spineBody == true then 
		return self.m_spineNode:isCurrentAnimationDone()
	end
	
    if self.m_currentBone == nil then
		return self.m_node:isCurrentDone("")
	else
		return self.m_node:isCurrentDone(self.m_currentBone)
	end
end

--@brief 	X轴翻转
--@param	bValue 是否X轴翻转
function YDPlayerAnimation:setFlipX(bValue)
    --self.m_node:setFlipX(bValue)
	
	self.m_flipX = bValue
	if self.m_running ~= true then 
        return
    end
	if bValue == true  and self.m_node:getScaleX() > 0 then 
		self.m_node:setScaleX(0-self.m_node:getScaleX())
	end 
	if bValue ~= true  and self.m_node:getScaleX() < 0 then 
		self.m_node:setScaleX(0-self.m_node:getScaleX())
	end
    self:loadParticle()
end

--@brief 	判断是否X轴翻转
--@return	true X轴翻转 false 没有翻转
function YDPlayerAnimation:isFlipX()
    if self.m_running ~= true then 
        return self.m_flipX
    end
    -- if self:isMonster() then 
        -- return self.m_node:getScaleX() > 0
    -- end
	return self.m_node:getScaleX() < 0
end

--@brief 	Y轴翻转
--@param	bValue 是否Y轴翻转
function YDPlayerAnimation:setFlipY(bValue)
	self.m_flipY = bValue
    if self.m_running ~= true then 
        return
    end
	self.m_node:setFlipY(bValue)
end

--@brief 	判断是否Y轴翻转
--@return	true Y轴翻转 false 没有翻转
function YDPlayerAnimation:isFlipY()
    if self.m_running ~= true then 
        return self.m_flipY
    end
	if self.m_node:getArmature() == nil then return false end
	return self.m_node:getArmature():getScaleY() < 0
end

--@brief 	设置X轴缩放
--@param	nScale 缩放值
function YDPlayerAnimation:setScaleX(nScale)
    if nScale == nil then 
        return
    end
    self.m_scale.x = nScale
    if self.m_running ~= true then 
        return
    end
    local baseScale = 1
    if self.m_node:getScaleX() < 0 then
		self.m_node:setScaleX(nScale*baseScale * -1)
	else
		self.m_node:setScaleX(nScale*baseScale)
	end
end

--@brief	设置Y轴缩放
--@param	nScale  缩放值
function YDPlayerAnimation:setScaleY(nScale)
    if nScale == nil then 
        return;
    end
    self.m_scale.y = nScale
    if self.m_running ~= true then 
        return
    end
    local baseScale = 1
	self.m_node:setScaleY(nScale*baseScale)
end

function YDPlayerAnimation:setScale(nScale)
	self:setScaleX(nScale)
	self:setScaleY(nScale)
end

--@brief	设置坐标值
--@param	tPos	坐标点的值可以通过x y访问
function YDPlayerAnimation:setPosition(tPos)
    self.m_pos.x = tPos.x
    self.m_pos.y = tPos.y
    if self.m_running ~= true then 
        return
    end
    self.m_node:setUseAbsCoordinate(true)
    self.m_node:setAbsPosition(GlobalMethod:ccp(tPos.x,tPos.y))
end


--@brief	获取坐标值
--@param	#1, 返回坐标值 格式是{x = 0,y = 0}
function YDPlayerAnimation:getPosition()
	local pos = {x = 0, y = 0}
    if self.m_running ~= true then
        return self.m_pos
    end
	pos.x , pos.y = self.m_node:getPosition()
	return pos
end

--@brief	设置旋转角度
--@param	nAngle 旋转角度
function YDPlayerAnimation:setRotate(nAngle)
    --WZLog("BattleAnimation:setRotate", self.m_node:getArmature(), self.m_bUseDragonBone, nAngle)
	self.m_rotation = nAngle
    if self.m_rotation > 360 then 
        self.m_rotation = self.m_rotation - 360
    end
    if self.m_rotation < -360 then 
        self.m_rotation = self.m_rotation + 360
    end
    if self.m_running == true then	
		self.m_node:setRotation(self.m_rotation)
	end
end

--@brief    获得旋转角度
--@return   #1, 返回旋转角度
function YDPlayerAnimation:getRotate()
    if self.m_running ~= true then	
		return self.m_rotation
	end
    return self.m_node:getRotationX()
end

function YDPlayerAnimation:getActionName(sAnimName,isShop)
	if sAnimName == nil or g_YDPlayerAnimation_Config[sAnimName] == nil then return {} end 
	if isShop == nil then 
		isShop = self.m_bShop
	end
	local action = g_YDPlayerAnimation_Config[sAnimName].action
    if isShop == true then 
        action = g_YDPlayerAnimation_Config[sAnimName].shop_action
    end
	if action == nil then return {} end 
	local actionNames = {}
	for k,v in pairs(action) do
		table.insert(actionNames,k)
	end 
	return actionNames
end

--@brief   删除节点  如果节点已经加入场景了
--@param   bValue 是否移除节点
function YDPlayerAnimation:removeFromParentAndCleanup(bValue)
    if self.m_running ~= true then	
		return
	end
    self.m_node:removeFromParentAndCleanup(bValue)
end

-------------------------------------私有方法模块Begin--------------------------------------

function YDPlayerAnimation:_getDisplayName(sBone,sIndex)
	if sBone == nil or sIndex == nil then 
		return nil
	end 
	local str_tmp = string.reverse(sBone)
	local bone = sBone
	if string.find(str_tmp, "kcab_") == 1 then
		local length = string.len(sBone)
		bone = string.sub(sBone, 1,length-5)
	end
	local name = bone .. "_" .. sIndex
	return name
end

function YDPlayerAnimation:_checkArmature(sName,sIndex,sPathName)
	--if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(sName) ~= nil then 
	--	return 
	--end
	-- if self:_contains(self.m_tLoadArmature,sName) == true then 
		-- return
	-- end
	
	local pathName = ""
	if sPathName == nil then 
		pathName = "player/" .. self.m_sAninName .. "/" .. sIndex .. "/" .. sName
	else 
		pathName = sPathName
	end 
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pathName .. ".png",pathName .. ".plist",pathName .. ".xml")
	if self.m_node and self.m_node.addManageTextureFile ~= nil then 
        self.m_node:addManageTextureFile(pathName .. ".png")
    end
    table.insert(self.m_tLoadArmature,sName)
    table.insert(self.m_tLoadPlist,pathName)
end

function YDPlayerAnimation:_changeDisplay(sName,sIndex)
	local config = g_YDPlayerAnimation_Config[self.m_sAninName]
	local bones = config.bone
	local bone = bones[sName]
	for i,v in ipairs(bone) do
		local displayName = self:_getDisplayName(v,sIndex)
		if displayName ~= nil then 
			self:_checkArmature(displayName,sIndex)
			self.m_node:setDisplayData(0,v,displayName)
		end
		--setDisplayData( int index, const std::string& bone, const std::string& image )
	end
end

function YDPlayerAnimation:_changeWeaponDisplay(sName,sIndex)
	local displayName = self:_getDisplayName(sName,sIndex)
	if displayName == nil then return end 
	displayName = "player/" .. self.m_sAninName .. "/weapon/" .. self.m_sAninName .. "_parts-" .. displayName .. ".png"
	self.m_node:setDisplayData(0,sName,displayName)
end 

function YDPlayerAnimation:_changeSpineWeaponDisplay(sName,sIndex)
	local nIndex = tonumber(sIndex)
	sIndex = self:_formatIndex(nIndex)
	local displayName = ""
	if nIndex > 200 then 
		displayName = self.m_sAninName .. "_parts-" .. self.m_sAninName .. "_bomb_" .. sIndex .. ".png"
	else
		displayName = self.m_sAninName .. "_parts-" .. self.m_sAninName .. "_gun_" .. sIndex .. ".png"
	end
	local path = "player/" .. self.m_sAninName .. "/weapon/" .. displayName
	local tmp = CCSprite:create(path)
	self.m_spineNode:bindSlot(sName,tmp)
end

function YDPlayerAnimation:_changeBodyDisplay(sName,sIndex)
	local displayName = self:_getDisplayName(sName,sIndex)
	if displayName == nil then return end 
	displayName = self.m_sAninName .. "_parts-" .. displayName .. ".png"
	local name = "player/" .. self.m_sAninName .. "/" .. sIndex .. "/" .. self.m_sAninName .. "_body_" .. sIndex
	
	if self:_contains(self.m_tLoadArmature,name) == false then 
		CCArmatureDataManager:sharedArmatureDataManager():addSpriteFrameFromFile(name .. ".plist",name .. ".png")
		table.insert(self.m_tLoadArmature,name);
	end 
	self.m_node:setDisplayData(0,sName,displayName)
end

function YDPlayerAnimation:_changeExtendDisplay(sIndex,extendName)
	local boneName = self.m_sAninName .. extendName --combatboy_skirt
	local bone = self.m_node:getArmature():getBone(boneName)
	bone = tolua.cast(bone,"CCNode")
	if bone == nil then return end
	local displayName = self:_getDisplayName(boneName,sIndex)
	self:_checkArmature(displayName,sIndex)
	if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(displayName) == nil then 
		bone:setVisible(false)
	else 
		bone:setVisible(true)
		self.m_node:setDisplayData(0,boneName,displayName)
	end
	
end 

function YDPlayerAnimation:_getNonBodyBone()
	local nonBody = {}
	local config = g_YDPlayerAnimation_Config[self.m_sAninName]
	for i,v in ipairs(config.bone.head) do
		table.insert(nonBody,v)
	end
	for i,v in ipairs(config.bone.mount) do
		table.insert(nonBody,v)
	end
	for i,v in ipairs(config.bone.weapon_gun) do
		table.insert(nonBody,v)
	end
	for i,v in ipairs(config.bone.weapon_bomb) do
		table.insert(nonBody,v)
	end
	for i,v in ipairs(config.bone.face) do
		table.insert(nonBody,v)
	end
	for i,v in ipairs(config.bone.wing) do
		table.insert(nonBody,v)
	end
	for i,v in ipairs(config.bone.exclude_bone) do
		table.insert(nonBody,v)
	end
    local _sBodyIndex = self:_formatIndex(self.m_bodyIndex)
    local boneName = self.m_sAninName .. "_body_" .. _sBodyIndex .."_effect"
    table.insert(nonBody,boneName)
	return nonBody
end

function YDPlayerAnimation:_contains(tArr,sValue)
	for i,v in ipairs(tArr) do 
		if v == sValue then 
			return true
		end 
	end 
	return false
end

function YDPlayerAnimation:_formatIndex(sIndex)
	local index = tonumber(sIndex)
	return string.format("%03d",sIndex)	
end 


function YDPlayerAnimation:_playIndex(nIndex,sBone,nLoop)
	if self.m_running ~= true then return end 
	
	local armature = self.m_node:getArmature()
	if armature == nil then return end
	
	if sBone ~= nil and string.len(sBone) ~= 0 then
		local bone = armature:getBoneRecursively(sBone)
		if bone == nil then return end
		bone = tolua.cast(bone,"CCBone")
		armature = bone:getChildArmature()
	end
	if armature == nil then return end
	armature:getAnimation():playByIndex(nIndex,-1,-1,nLoop);
end 


function YDPlayerAnimation:_getChildBone(sBone)
	if self.m_running ~= true then return nil end 
	local armature = self.m_node:getArmature()
	if armature == nil then return nil end
	
	if sBone ~= nil and string.len(sBone) ~= 0 then
		local bone = armature:getBoneRecursively(sBone)
		if bone == nil then return nil end
		bone = tolua.cast(bone,"CCBone")
		return bone
	end
	return nil
end

function YDPlayerAnimation:_playArmatureAction(node,nIndex,nLoop)
	if node == nil then return end
	local armature = tolua.cast(node,"CCArmature")
	if armature == nil then return end
	--spine:play(sActionName,bLoop)
	armature:getAnimation():playByIndex(nIndex,-1,-1,nLoop);
end

function YDPlayerAnimation:_playSpineAction(node,sActionName,bLoop)
	if node == nil then return end
	local spine = tolua.cast(node,"SkeletonAnimation")
	if spine == nil then return end
	spine:play(sActionName,bLoop)
end 

function YDPlayerAnimation:pause()
    if self.m_running ~= true then	
		return
	end
    self.m_bIsStopFaceAndWindAnim = true
    self:getAnimNode():pause()
end

function YDPlayerAnimation:resume()
    if self.m_running ~= true then	
		return
	end
    self.m_bIsStopFaceAndWindAnim = false
    self:getAnimNode():resume()
end

function YDPlayerAnimation:getDownloadInfo(sIndex)
	WZLog("YDPlayerAnimation:getDownloadInfo", sIndex)
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."DressAniDownloadConfig.xml"
    local ConfigExist = WZDataFile:getInstance():checkFileExist(path)
	if ConfigExist then
		local xmlDoc = WZDataFile:getInstance():createXmlDocument(path)
		--没有下载配置文件成功，直接返回
		if not xmlDoc then return nil end
    	local rootElement = xmlDoc:getRootElement()
    	local xmlName = "File"
    	local element = rootElement:findChildElement(xmlName)
		while element do
    	    local index = element:attributeString("index")
    	    local sex = element:attributeString("sex")
			WZLog("YDPlayerAnimation:getDownloadInfo_1", index, index == tostring(sIndex), sex == self.m_sAninName)
			if index == tostring(sIndex) and sex == self.m_sAninName then
				local downloadInfo = {}
    	        downloadInfo.url = element:attributeString("url")
    	        downloadInfo.md5 = element:attributeString("md5")
    	        WZLog("下载时装配置",downloadInfo.url,downloadInfo.md5,index)
				return downloadInfo
			end
    	    element = element:nextSiblingElement(xmlName)
    	end
	end
	return nil
end
