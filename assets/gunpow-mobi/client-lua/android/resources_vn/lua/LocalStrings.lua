--LocalStrings.lua
--@brief	界面文字字符串定义文件，不同的语言具有相同的键。
LocalStrings =
{	
LOGIN = "Đăng nhập",
PASSWORD = "Mật khẩu",
INBOX = "Nhận",
OUTBOX = "Gửi",
WRITEBOX = "Viết thư",
SEND = "Gửi",
SUCCESS = "Thành công",
FAIL = "Thất bại",
EDIT = "Xóa hết",
DELECT = "Xóa",
COMPLETE = "Hoàn thành",
REPLY = "Trả lời",
UPPAGE = "Trước",
DOWNPAGE = "Sau",
SENDER = "Người gửi: ",
TIME = "Thời gian: ",
EDITMAILID = "Chọn người nhận",
EDITMAILTHEME = "Nhập chủ đề thư",
EDITMAILCONTENT = "Nhập nội dung thư",
NOTDESIGNAME = "Chưa nhận danh hiệu này!",
MAIL_THEME = "Chủ đề: ",
MAIL_RECV = "Người nhận: ",
MAIL_SENDER = "Người gửi: ",
MAIL_GETALL = "Nhận",
REINC_REINCTXT = "Chuyển sinh",
VIP_CURDAYRECV = "Đã nhận",
VIP_RECVSUCCESS = "Nhận thành công",
VIP_INFOFAIL = "Nhận thông tin VIP thất bại",
INVITE_RECEIVE = "Nhận",
INVITE_SERVER = "Máy chủ",
NAME = "Tên",
CURSERVER = "Máy chủ: ",
BACKGROUND = "Nhạc nền",
GAME = "Âm thanh",
MUSIC = "Nhạc",
ABOUT = "Giới thiệu game",
REGISTER = "Đăng ký",
SETTING_ACCOUNT = "Tài khoản",
HELP = "Hỗ trợ",
INPUTDETAIL = "Nhập nội dung",
EXCHANGE = "Đổi",
CURNUM = "Số người tham chiến: %d",
URLFAIL = "Mở URL thất bại!" ,
QUALIFYING_ORDER = "Thứ tự",
QUALIFYING_NAME = "Tên",
INTEGRATION = "Điểm",
HURTOUTPUT = "Sát thương gây ra",
MATCHFAIL = "Ghép thất bại",
TEACH_BOSSMAP = "Hãy cùng chiến hữu vừa nhận được thám hiểm phó bản",
TEACH_BOSSMAP_CHALLENGE = [[Nhấp "Ải khiêu chiến" chọn độ khó phó bản]],
TEACH_BOSSMAP_SIMPLE = "Chọn độ khó là dễ. Sau khi vượt ải sẽ tự mở khóa độ khó kế",
TEACH_BOSSMAP_SURE = "Tạo phòng phó bản",
TEACH_STRENGTHEN = "Muốn tăng lực chiến nhanh không? Hãy cường hóa trang bị",
TEACH_STRENGTHENSTART = "Bắt đầu cường hóa trang bị",
TEACH_STRENGTHEN_WEAPON = "Chọn vũ khí cần cường hóa",
TEACH_STRENGTHEN_OTHER = "Chọn đạo cụ cần cường hóa",
TEACH_STRENGTHEN_SELECTSTONE = "Chọn Đá Cường Hóa",
TEACH_STRENGTHEN_START = "Nhấp cường hóa tăng cấp vũ khí",
TEACH_STRENGTHEN_CLOSE = "Hoàn thành cường hóa, quay về Sảnh",
--登录界面
LOGINING = "Đang đăng nhập",
GET_ROLELIST_SUCCESS = "Nhận nhân vật thành công",
--创建角色界面
PLEASE_INPUT_ACTORNAME = "Nhập tên nhân vật",
REGISTER_AGAIN = "Đăng ký lại",
LOGIN_AGAIN = "Nhập lại",
--账号界面
FINDBACK_PSW = "Tìm lại mật khẩu",
CHANGE_ACCOUNT = "Đổi tài khoản",
CHANGE_PSW = "Đổi mật khẩu",
FINDBACK_PSW_TIP = "Chú ý: Nhập địa chỉ hộp thư khi đăng ký có thể tìm lại được tài khoản và mật khẩu",
EMAIL_SENDED = "Đã gửi thư",
OLD_PSW = [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">Mật khẩu cũ: </T>]],
NEW_PSW = [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">Mật khẩu mới: </T>]],
PASSWORD_CONFIRM = [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">Xác nhận mật khẩu: </T>]],
PLEASE_INPUT_OLD_PSW = "Nhập mật khẩu cũ",
PLEASE_INPUT_NEW_PSW = "Nhập mật khẩu mới",
PLEASE_INPUT_PSWCONFIRM = "Nhập mật khẩu xác nhận",
CHANGE_PSW_SUCCESS = "Sửa mật khẩu thành công",
VERIFICATION_FAILED = "Mật khẩu tài khoản sai",
--注册界面
CLICK_INPUT_ACCOUNT = "Nhập tài khoản",
CLICK_INPUT_PASSWORD = "Nhập mật khẩu",
CLICK_INPUT_MAIL = "Nhập email",
CLICK_INPUT_INVITECODE = "Nhập Code mời",
ACCOUNT= [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">Tài khoản: </T>]],
PASSWORD1 = [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">Mật khẩu: </T>]],
PSW_CONFIRM= [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">Xác nhận mật khẩu: </T>]],
MAIL = [[<T C="255,0,0" S="30" P="0">*</T><T C="80,38,3" S="30" P="0">Email: </T>]],
INVITE_CODE = [[<T C="80,38,3" S="30" P="0">Code: </T>]],
STAR_MEANS_ESSENTIAL = [[<T C="255,0,0" S="24" P="0">*</T><T C="80,38,3" S="24" P="0">Số chỉ mục cần điền vào</T>]],
PLEASE_INPUT_ACCOUNT = "Nhập tài khoản",
ONLY_NUM_AND_LETTER = "Chỉ được nhập số và chữ",
ACCOUNT_LEN_ILLEGAL = "Độ dài tài khoản không hợp yêu cầu",
PLEASE_INPUT_PSW = "Nhập mật khẩu",
PSW_LEN_ILLEGAL = "Độ dài mật khẩu không hợp yêu cầu",
PSWCONFIRM_NOT_THE_SAME = "Mật khẩu không thống nhất",
PLEASE_INPUT_MAIL = "Nhập email",
PLEASE_INPUT_CORRECT_MAIL = "Nhập email chính xác",
--成长基金界面
BUY_FUND = "Mua quỹ",
INTRODUCTION = "Thông tin",
--每日签到界面
SIGN = "Điểm danh",
--物品回收界面
RECYCLING = "Thu hồi",
WEAPON = "Vũ khí",
CLOTH = "Trang phục",
OTHERS = "Khác",
SALE_SUCCESS = "Bán thành công",
--强化研究院
ENTER = "Vào",
--强化界面
HOLY_STONE = "Đá Thánh",
--镶嵌界面
EQUIPMENT = "Trang bị",
ATTACK_STONE = "Công",
DEFENSE_STONE  = "Phòng",
GEMMOUNTING = "Khảm",
PLEASE_ADD_WEAPON_FIRST = "Đặt trang bị vào!",
--升星界面
IMPROVE = "Tăng sao",
STAR_STONE = "Đá Tăng Sao",
--重铸界面
FIRE = "Tôi luyện",
LOCK = "Khóa",
--继承界面
TRANSFER = "Kế thừa",
--合成界面
MATERIAL = "N.Liệu",
SYNTHESIS = "Ghép",
--链接游戏服务器提示
NETWORK_UNAVAILABLE = "Kết nối thất bại, thử lại sau! (PS: Hãy chơi game khi mạng ổn định để trải nghiệm game tốt hơn)",
SERVER_MAINTAINING = "Máy chủ đang bảo trì",
--好友
TXT_NOSOCISY_FREND = [[Chưa vào Công Hội]],
FRONT_PAGE = "Trượt trang xuống",
NEXT_PAGE = "Trượt trang lên",
--排行榜
BATTLE = "Lực chiến",
WIN = "Chiến thắng",
--公会
CUR_PRESIDENT = "Chủ Công Hội",
PRESTIGE = "Danh vọng",
FUNDS = "Quỹ",
RANK = "Hạng",
MY_COMMUNITY = "Công Hội",
CREATE_COMMUNITY = "Tạo Công Hội",
COMMUNITY_NAME = "Tên: ",
COMMUNITY_LEVEL = "Cấp Công Hội",
COMMUNITY_PRESTIGE = "Danh vọng",
WIN_RATE = "Thắng",
PLEASE_INPUT_COMMUNITY_ID = "Nhập ID Công Hội",
COMMUNITY_ID_INPUT_MUST_ALL_NUMBER = "ID Công Hội phải là số",
CREATE_COMMUNITY_SUCCESS = "Đã tạo Công Hội!",
CLICK_INPUT_NAME = "Nhập tên",
ALREADAY_APPLAY_FOR_COMMUNITY_MESSAGE = "Đã gửi thông tin xin vào Công Hội",
GOLD_COIN = "Vàng: ",
DIAMOND = "Kim Cương: ",
ASK_YES_OR_NO_GIVEWAY = "Xác nhận nhường chức Chủ Hội?\nBạn và mục tiêu sẽ đổi chức cho nhau!",
MAIL_SEND_SUCCUSS = "Đã gửi thư!",
PRESIDENT = "Hội Trưởng",
VICE_PRESIDENT = "Phó Hội",
ELDERS = "Trưởng Lão",
PICK = "Tinh Anh",
NORMAL_COMMUNITY_MEMBER = "Hội viên",
ENEMY_COMMUNITY = "Công Hội địch",
SET_EMEMY_COMMUNITY_SUCCESS = "Đã thiết lập Công Hội địch!",
FRIEND_ADD_SUCCESS = "Đã thêm bạn",
SUCCESS_UP_JOB = "Đã thăng chức!",
SUCCESS_DOWN_JOB = "Đã giáng chức!",
ARE_YOU_SURE_DISMISS_THIS_PLAYER = "Xác nhận trục xuất %s?",
ALREADY_REMOVE_COMMUNITY = " bị trục xuất khỏi Công Hội!",
ALREADY_EXIT_COMMUNITY = " đã rời Công Hội!",
COMMUNITY_ALREADY_DISSMISS = "Công Hội đã giải tán!",
SUCESS_AS_PRESIDENT = " đã trở thành chủ Công Hội",
NOT_REACH_LEVEL_CANNOT_BUILD_GUILD = "Đạt Lv15 mới được tạo Công Hội",
DISMISS_COMMUNITY = "Giải tán Công Hội",
--密境探险
YES_OR_NO_SPEND = "Đồng ý dùng ",
DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE = "Kim Cương không đủ, cần thêm không?",
MEDAL_NOT_ENOUGH_PLEASE_GET_MORE_MEDAL = "Huy Hiệu không đủ, cần thêm không?",
GAME_HALL = "Sảnh trò chơi",
START = "Bắt đầu",
GOLD_COIN_NOT_ENOUGH = "Vàng không đủ, cần thêm không?",
--副本大厅
COPY_HALL = "Sảnh phó bản",
FIND_ROOM = "Tìm phòng",
QUICK_JOIN ="Vào nhanh",
QUICK_JOIN1 ="Vào nhanh",
COMMON = "Dễ",
DIFFICULTY = "Khó",
HELL = "Địa Ngục",
MODEL = "Dạng",
SIMPLE_MODEL_EXPLAIN = "Độ khó thường, thưởng cũng bình thường.",
DIFFICULTY_MODEL_EXPLAIN = "Độ khó càng cao thưởng càng nhiều.",
HELL_MODEL_EXPLAIN = "Thưởng cao nhất chỉ dành cho đội dũng cảm nhất!",
DIFFICULTY_MODLE_SHOW_ERROR_MEESSAGE = "Chưa vượt dạng Dễ, không thể khiêu chiến dạng Khó.",
HELL_MODLE_SHOW_ERROR_MESSAGE = "Chưa vượt dạng Khó, không thể khiêu chiến dạng Địa Ngục.",
UNABLE_PASS_THIS_CHECKPOINT_ERR_MESSAGE = "Chưa vượt ải trước, không thể khiêu chiến ải này",
LEVEL_OPEN_THIS_FUNCTION = " cấp mở chức năng này",
QUICKEN = "Tăng tốc",
--弹王挑战赛
EXIT = "Thoát",
PLAYER_NAME = "Tên",
PEOPLE_NUM = "Số người:",
WHERE_THE_SERVER = "Máy chủ",
PLAYER_LEVEL = "Cấp người chơi",

--任务，每日签到
BACK = "Quay về",
CONFIRM = "Xác nhận",
SAVE = "Lưu",
CANCEL = "Hủy",
CALENDAR_WEEK = {
"CN",
"1",
"2",
"3",
"4",
"5",
"6"
},
TASK_JUQING = "Chính",
TASK_MEIRI = "Hàng Ngày",
TASK_TARGET = "Mục tiêu",
TASK_DESCRIPTION = "Miêu tả",
TASK_REWARD = "Thưởng nhiệm vụ",
ACTIVE_TIME = "Thời gian hoạt động",
EXP = "EXP: ",
GOLD = "Tiền:",
GET_REWARD = "Nhận thưởng",
IMMEDIATELY_RECHARGE = "Nạp ngay",
START_FIGHTING = "Chiến đấu",
CONTINUE_GAME = "Tiếp tục",
GOODS_INFO = "Thông tin vật phẩm",
RENEWAL = "Gia hạn",
USE = "Dùng",
NOLIMIT = "Vĩnh viễn",
INPUT_NEW_NAME = "Hãy nhập tên mới: ",
CLICK_TO_INPUT_NAME = "Nhập tên mới",
USE_RESET_FAIL_NUM = "Dùng sẽ xóa số lần chiến đấu thất bại",
GIFTBAG_LEVEL_NO = "Cấp chưa đạt điều kiện",
SPREE_SUCCESS = "Chúc mừng nhận vật phẩm sau",
IMPROVE_REWARD = "Tăng thưởng",
--背包
COMBAT = "Lực chiến",
COMMUNITY = "Công Hội",
POST = "Chức",
DESIGNATION = "Danh hiệu",
LEVEL = "Cấp",
HEALTH = "S.Lực",
DEFENSE = "P.Thủ",
CRIT = "Bạo kích",
PHYSICAL = "Thể lực",
ATTACK = "T.Công",
FREESTORM = "Miễn bạo",
ANTIBREAKING = "Phá giáp",
LUCKY = "M.Mắn",
STRENGTEN = "Cường hóa",
BAG1 = "Vật phẩm",
SHOP = "Cửa Hàng",
NONE = "Không",
HEAD = "Đầu",
FACE = "Biểu cảm",
BODY = "Thân",
WING = "Cánh",
RING = "Nhẫn",
NECKLACE = "Dây chuyền",
--游戏大厅
PRIMARY = "Kênh sơ cấp",
ADVANCE = "Kênh cao cấp",
ROOM_PASSWORD = "Mật khẩu: ",
ROOM_PEOPLO_NUM = "Số người trong phòng",
MACTH_TYPE = "Trung gian",
RANDOM = "Ghép",
TEAM = "Đội",
ROOM_NAME_RANDOM = {"Hãy cùng vui chơi!",
"Hãy cảm nhận trận chiến quyết liệt!",
"Dám đấu chứ?!",
"Hãy cùng thi đấu!",
"Đánh một trận tơi bời nào!"},
NO_PASSWORD = "Không mật khẩu",
INPUT_ROOM_ID = "Hãy nhập ID phòng",
ROOM_ID = "ID phòng",
CLICK_TO_INPUT_ID = "Nhập ID phòng",
CLICK_TO_INPUT_PASSWORD = "Nhập mật khẩu phòng",
PASSWORD_NOT_MATCH = "Mật khẩu không đúng",
ROOM_BATTLEING = "Người khác đang chơi game!~",
ROOM_FULL = "Phòng đầy người",
OPEN_ON_ADVANCED_CHANNEL = "Mở kênh cao cấp",
SKILL = "Lĩnh ngộ",
PROP = "Đạo cụ",
INVITATION_HAS_BEEN_SENT = "Đã gửi lời mời",
READY_GAME = "Chuẩn bị vào game",
START_GAME = "Chơi ngay",
MATCH_FAILED = "Thao tác thất bại",
TIPS = "Nhắc nhở",
ROOM = "Danh sách phòng",
PRIMAY_CHANNEL = "Kênh sơ cấp",
ADVANCE_CHANNEL = "Kênh cao cấp",
TARGET_VIP_LEVEL_OVER_THEN_YOU = "Cấp VIP không đủ, không thể mời đối phương ra",
--聊天
CHAT_SENDMORE = "Tin chat gửi quá nhiều!",
CHAT_CONTENTNULL = "Nhập nội dung chat",
CHAT_ALL = "Toàn bộ",
CHAT_COLORLIAO = "Chat màu",
CHAT_WORLD = "Thế Giới",
CHAT_PRIVATE = "Chat riêng",
CHAT_CURRENT = "Hiện tại",
CHAT_MSG_CONTENT = "Nhập nội dung chat!",
CHAT_MSG_ID = "Không thể chat riêng với trợ thủ!",
CHAT_SYSTEM = "Hệ thống",
CHAT_RIGHT = "với",
CHAT_COLORLIAOK = "[Chat màu]",
CHAT_WORLDK = "[Thế Giới]",
CHAT_GONGHUIK = "[Công Hội]",
CHAT_PRIVATEK = "[Chat riêng]",
CHAT_CURRENTK = "[Hiện tại]",
CHAT_SYSTEMK = "[Hệ thống]",
CHAT_NOCOLORLABA = "Loa Liên Server không đủ, hãy đi mua!",
CHAT_NOLABA = "Loa không đủ, hãy đi mua!",
--爱心许愿
STRENGTHENTIP = "6 trang bị %s +%d",
REWARD_CURRENTLOTTERYTIMES = "Số lần rút thưởng hiện tại: ",
REWARD_NEXTZUAN = "Số Kim Cương cần nạp cho thưởng bậc kế: ",
REWARD_NEXTLOTTERYTIMES = "Số lần rút thưởng bậc kế: ",
REWARD_MSGCHONGZHI = "Không thể rút thưởng, hãy nạp.",
REWARD_BTN_FIRSTGET = "Nhận thưởng",
REWARD_BTN_GET = "Nạp",
REWARD_BTN_REWARD = "Rút thưởng",
REWARD_FIRST_INTORDUCE = "Nạp lần đầu sẽ nhận: ",
--商城
SHOP_LIFT = "S.Lực: ",
SHOP_GONGJI = "T.Công: ",
SHOP_BAOJI = "B.Kích:",
SHOP_DEFEND = "P.Thủ: ",
SHOP_NOCHENGHAO = "<Không danh hiệu>",
SHOP_NOGONGHUI = "Chưa vào Công Hội",
SHOP_GOODSSHEGN = "Còn ",
SHOP_CISHU = " lần",
--活跃度
ACTIVE_BTN_GET = "Nhận",
ACTIVE_BTN_GO = "Đến ",
ACTIVE_FINISH = "Đã hoàn thành",
ACTIVE_GET = "Đã nhận",
--砸蛋
THROWINGEGGS_MSG_ZUAN = "Lần đập trứng này trừ     Kim Cương",
THROWINGEGGS_MSG_THROWEGG = "Đang đợi người chơi khác đập trứng: ",
--结婚
MARRY_DREAM_CONTENT = "Mình nghĩ rằng không ai có thể thích hợp sở hữu nó hơn bạn.",
MARRY_ROMAN_CONTENT = "999 đóa hoa hồng tượng trưng cho mãi ở bên nhau, mà bạn thì nên có đầy trời hoa hồng, có tất cả mọi điều hạnh phúc.",
MARRY_WARM_CONTENT = "Mình chỉ muốn đeo nó lên tay bạn, cả đời mãi có nhau!",
MARRY_SIMPLE_CONTENT = "Mình chắc chắn nó sẽ hợp với bạn, vì nó là lời ước hẹn rằng bạn sẽ luôn có mình ở bên cạnh.",
AGREE = "Đồng ý",
REJECT = "Từ chối",
MARRY_ITEM_NOT_ENOUGH = "Chưa có đạo cụ cầu hôn, đồng ý mua?",
MARRY_OK = "Chúc mừng, %s và bạn đính hôn thành công!",
MARRY_FAILD = "Cầu hôn thất bại, %s từ chối lời cầu hôn của bạn!",
MARRY_END = "Hủy quan hệ",
MARRY_END_TIPS = "Hủy quan hệ sẽ nộp phí %d Kim Cương, đồng ý chứ?",
MARRY_END_SUCCESS = "%s đã xin phép hủy đính hôn thành công, quan hệ đính hôn của các bạn đã bị xóa.",
WEDDING_LUXURY = "Hôn Lễ Xa Hoa",
WEDDING_RICH = "Hôn Lễ Hào Hoa",
WEDDING_ROMAN = "Hôn Lễ Lãng Mạn",
WEDDING_ORIGINAL = "Hôn Lễ Thường",
WEDDING_ASK_TIPS = "Người yêu muốn cùng bạn tổ chức %s",
WILLING = "Đồng ý",
THINK_ABOUT = "Suy nghĩ lại",
WEDDING_SUCCUSS = 
[[
Chúc mừng, kết hôn thành công với %s, 
Chúc hai bạn trăm năm hạnh phúc!
]],
WEDDING_FAILD = "Hôn lễ thất bại, người yêu của bạn cần thêm thời gian để suy nghĩ!",
WEDDING_DIVORCE = "Ly hôn",
WEDDING_END_REQUEST = "Xin phép ly hôn sẽ nộp phí %d Kim Cương, sau khi ly hôn sẽ mất lễ phục, đồng ý?",
WEDDING_END_TIPS = "%s đã xin phép ly hôn thành công, quan hệ hôn nhân và lễ phục của các bạn đã bị xóa.",
GIVE = "Tặng",
GIVE_DIAMOND_TIPS = "%s tặng bạn %d Kim Cương.",
--战斗
BATTLE_EXIT_WARNING = "Nhắc nhở: Cố ý thoát sẽ trừ EXP thi đấu!",
BATTLE_EXIT_WARNING2 = "Đừng bỏ rơi đồng đội chứ!",
BATTLE_EXIT_WARNING3 = "Vượt phó bản sẽ nhận thưởng!",
BATTLE_EXIT = "Thoát",
BATTLE_EXT_ITEMSKILL_LIMIT = "VIP1 sẽ mở tính năng này",
BATTLE_ANGER_LIMIT = "Nộ Khí chưa đầy",
BATTLE_USE_BIGSKILL = "Dùng POW",
BATTLE_FAIL_BIGSKILL = "Đã dùng kỹ năng, không thể tiếp tục dùng POW",
--副本房间
BOSSROOM_SKILLPROP = "Đạo cụ kỹ năng",
BOSSROOM_INVITATION_HAS_BEEN_SENT = "Đã gửi lời mời",
BOSSROOM_MATCH_FAILED = "Thao tác thất bại",
BOOSROOM_KICKEDOUT= "Bạn bị chủ phòng mời khỏi phòng",

BATTLETEAM_PLAYER_ALREADY_ROOM = "Người chơi đã ở trong phòng",
--显示炮弹的高度
BULLET_HEIGHT = "Độ cao: %dm",
--新手战斗教学
SKILL_DIVIDE_THREE = "Bắn Lan Tỏa x3",
SKILL_ATTACKUP_FIVE = "Tấn Công +50%",
SKILL_ADDTIMES_ONE = "Bắn Liên Tục +1",
ITEM_BLOOD = "Túi Trị Liệu",
START_MY_TURN = "Đến lượt bạn",
START_OTHER_TURN = "Đến lượt đối phương",
TEACH_GUIDE_USEFLY = "Nhấn máy bay sẽ có thể khiến nhân vật bay ở lượt tiếp theo",
TEACH_GUIDE_FLY = "Nhấn tay vào nhân vật và kéo theo hướng ngược hướng bay sẽ khiến nhân vật bay đến đó",
TEACH_GUIDE_BIGSKILL = "Khi Nộ Khí đầy, nhấn Power sẽ dùng tuyệt chiêu gây sát thương mạnh.",
REACH_TOP_STRENGTHENLEVEL = "Trang bị đã cường hóa đến cấp tối đa, không thể tiếp tục cường hóa!",
BOSSROOM_SWITCH_DIFFICULTY_TIPS1 = "Chưa vượt dạng Dễ, không thể khiêu chiến dạng Khó ",
BOSSROOM_SWITCH_DIFFICULTY_TIPS2 = "Chưa vượt dạng Khó, không thể khiêu chiến dạng Địa Ngục ",
BOSSROOM_SWITCH_DIFFICULTY_TIPS3 = "Đổi thất bại, phòng có thành viên chưa đủ điều kiện",
SOUND = "Âm thanh",
DIALOG_GUIDE_FAST_ENTER = "Nhấn ở đây để vào phòng nhanh!",
BUY_STARSTONE_MESSAGE = "Đá Tăng Sao không đủ, muốn mua chứ?",
CANCEL_ENEMY_COMMUNITY_SUCESS = "Hủy Công Hội địch thành công",
WND_EXISTACCOUNT_ACCOUNT = "Tài khoản: ",
WND_EXISTACCOUNT_PASSWORD = "Mật khẩu: ",
E_BATTLE_GIFTYES = "Có ",
SHOP_PAY = [[<T C="255,255,255" S="30" >]]..[[%d ngày: ]]..[[</T>]]..[[<I>%s</I><T C="232,223,0" S="30" >]]..[[%d]]..[[</T>]]..[[<T C="255,255,255" S="30" >]]..[[Kim Cương]]..[[</T>]],
LOADING_TIP = "Có thể cường hóa để tăng thuộc tính cơ bản cho vũ khí, trang phục",
BATTLE_MODEL_SPORT = "Dạng Thi Đấu",
BATTLE_MODEL_REVIVE = "Dạng Hồi Sinh",
BATTLE_MODEL_MIX = "Dạng Giao Chiến",
BATTLE_MODEL_COMMUNITY = "Dạng Công Hội",
ROOM_BEINVITED = "%s mời tham gia\n%s (%s)",
BATTLE_NOT_MY_TURN = "Chưa đến lượt thao tác",
LEVEL_NOT_ENOUGH_CHALLENGE = "Chưa đạt Lv%d, không thể khiêu chiến ải này",
ACCELERATE_SUCCESS = "Tăng tốc thành công",
ONLY_ROOMOWNER_CAN_SELECT = "Chỉ có chủ phòng mới có thể chọn độ khó!",
DOWNLOAD_RES_FAIL_TIPS = "Không thể kết nối đường truyền, hãy kiểm tra lại",
NO_SPACE_TO_DOWNLOAD_TIPS = "Dung lượng không đủ, hãy sắp xếp lại thiết bị rồi thử lại",
ACTIVE_NOLEVEL = [[Cấp không đủ, cần đạt Lv%d mới mở tính năng này]],
NEED_DOWNLOAD_TIPS = "Lần cập nhật này cần tải %0.2fMB. (Gợi ý: File khá lớn, kiến nghị dùng WIFI để tải)",
NEED_DOWNLOAD_TIPS_V16 = "Game đang cập nhật, vui lòng đợi.",
SIGN_REWARD = "Nhận: ",
SHOP_DAY = [[%d ngày]],
RESOURCES_LOADING = "Đang tải",
DAILYSIGN_REWARD = "Thưởng điểm danh ngày",
CONTINUALSIGN = "Điểm danh liên tục",
MONTHLYSIGN = "Điểm danh tháng",
DAILYSIGN_MSG = " ngày có thể nhận",
STAR_LEVEL = "Cấp sao",
POWER = "S.Mạnh",
AGILITY = "Tốc độ",
TIZHI = "T.Chất",
SHI = "Đá",
SUGGESTION_INIT = "Nhập nội dung (150 ký tự)",
CHECK_VESION = "Đang kiểm tra tài nguyên",
LOADING_TIPS = {
[[Có thể rèn để tăng thuộc tính cơ bản trang bị.]],
[[Trong chiến đấu, có thể dùng hai ngón tay để thu nhỏ phóng to]],
[[Đạt Lv15 có thể tạo Công Hội!~]],
[[Bạn bè có thể tặng Thể Lực cho nhau mỗi ngày!~]],
[[Nhấn giữ hai bên nhân vật có thể di chuyển trái phải!]],
},
RECHARGE_FAIL = "Nạp thất bại!",
SELECT_ALL = "Chọn hết",
BATTLE_RECONNECT_FAIL = "Kết nối chiến đấu thất bại, quay về sảnh",
RECHARGE_SUCCESS = "Nạp thành công!",
REWARD_FIRST = "Nhận thưởng nạp lần đầu thành công",
SHOOT_GUIDE_CLOSE = "Chúc mừng đạt Lv%d! Hệ thống sẽ không hiện chỉ dẫn tự động nữa!",
LOGIN_FAILD = "Hãy dùng tài khoản đúng để đăng nhập.",
ROLEINFO_MATE ="Người yêu",
MARRY_PROPOSE = "Cầu hôn",
WEDDING_LIST = "Danh sách hôn lễ",
WEDDING = "Cử hành hôn lễ",
RECHARGETIP = "Nạp nhận thưởng bạo kích",
TASK_UPEXP_LIMIT = "Nhiệm vụ này đã đạt cấp tăng tối đa",
BRIGE_GROOM_NAME = "Chú rể: ",
BRIGE_NAME = "Cô dâu: ", 
START_TIME = "Bắt đầu: ",
UPPHOTO = "UploadAvatar: ",
RECHARGEFAIL = "Chưa thể nhận phúc lợi hoàn trả!",
RECHARGESUCCESS = "Chúc mừng nhận hoàn trả nạp bạo kích Kim Cương!",
EXIT_WEDDING_SCENE = "Thoát Sảnh Hôn Lễ?",
NOT_WEDDING_LIST = "Tạm chưa có thông tin tổ chức Hôn Lễ",
LEO = "Sư Tử",
PHOTO = " Avatar",
SEX = "Giới tính",
DISTANCE = "Cự ly",
SINGLE_MAP_USEVIGOR = "Thể Lực tốn: ",
SINGLE_MAP_VIGOR = "Thể Lực: ",
SINGLE_MAP_CHALLENGE = "Lần khiêu chiến: ",
RECHARGEDESC = "Nạp Kim Cương sẽ tích lũy bạo kích, đạt bạo kích nhất định sẽ nhận thưởng hoàn trả! Mức nạp càng lớn, mức hoàn trả càng cao!",
WEDDING_OVER = "Hôn lễ này đã kết thúc!",
NEXT_PAGE_TIP = "Kéo lên trên sẽ tải trang sau",
FRONT_PAGE_TIP = "Kéo xuống dưới sẽ tải trang trước",
VOICECHAT = "Ngăn Voice",
SUGGESTTYPE="Loại ý kiến:",
UPPHOTOFAIL = "Chụp thất bại!",
SUGGESTTYPE_SUGGEST="Kiến nghị",
SUGGESTTYPE_QUESTIONASK="Trưng cầu vấn đề",
SUGGESTTYPE_PAYASK="Trưng cầu nạp",
LITLE_MAP = "Bản đồ",
NEED_UPDATE_VERSION = "Hãy cập nhật phiên bản mới.",
TIP_INPUT_ACCOUNT = "Gồm chữ cái (Hoa và thường) và chữ số, 6-16 ký tự",
TIP_INPUT_PASSWORD = "Gồm chữ cái (Hoa và thường) và ký hiệu đặc biệt, 6-12 ký tự",
TIP_INPUT_PASSWORD_CONFIRM = "Nhập lại mật khẩu",
TIP_INPUT_MAIL = "Nhập email để dùng khi tìm lại mật khẩu",
ExchangeGift = "Hãy nhập code:",
INVITECODE = "Code",
PURCHASE = "Mua vật phẩm",
CHALLENGE = "Ải khiêu chiến",
WIPE_OUT = "Càn quét",
REFRESH = "Tạo mới",
ADDFRIEND = "Kết bạn",
DELFRIEND = "Xóa bạn",
MARRY_GUEST = "Khách",
APPLY_ATTEND_COMMUNITY = "Xin vào Công Hội",
DAY = " ngày",
RECHARGE_ORDER_FAIL = "Kiểm tra thất bại",
RECHARGE__IN_PROCESS = "Đang xử lý",
DOWNROAD_REQUIRE_SD_CARD = "Dùng ứng dụng này cần có thẻ SD",
SELECTROLE_ENTER_GAME = "Vào game",
YES = "Đúng",
DOWNLOADREWARD_BADGE = "Huy Hiệu",
DOWNLOADREWARD_TIP = 
[[
Đang cập nhật, cập nhật xong nhận được: 
(Chú ý: Thưởng chỉ phát 1 lần)
]],
NO_BLACKCHAR = "Tài khoản hoặc mật khẩu không thể có khoảng trắng",
NO_CONTROLCHAR = "Mật khẩu không thể có ký hiệu đặc biệt",
GOTOPROTOCOL = "Xem Điều khoản người dùng",
ISBLANKKEY= "Nội dung không thể để trống!",
PLAYER_RENAME = "Đổi tên nhân vật thành công",
COMMUNITY_RENAME = "Đổi tên Công Hội thành công",
MULTI_SCRIPT = "Phó bản nhóm",
SINGLE_SCRIPT = "Vùng Mạo Hiểm",
BAG = "Túi",
CARDS = "Thẻ",
PRACTICE = "Tu luyện",
BSTRONG = "Mạnh lên",
CLOSE_SCRIPT = "Chưa mở",
PRACTICE_BLOOD = "S.Lực",
PRACTICE_ARMOR = "H.Giáp",
NOSTONE_STRENGTHEN = "Chưa khảm đá",
AVOIDINJURY= "M.Thương",
XH_REDUCEBURY = "Chống đào",
ACTIVITY = "Năng động",
UNLIMITE = "Không giới hạn",
CHOISE_CARTON = "Chọn phó bản",
REWARD_CARTON = "Thưởng phó bản",
SWEEP_TIME = "Số lần càn quét",
NEED_ACTIVITY = "Thể Lực cần",
LEFT_ACTIVITY = "Thể Lực còn ",
SWEEP_DESC = 
[[
1. Ải đã vượt mới được càn quét.
2. Có thể chọn số lần càn quét.
3. Đang càn quét không thể dừng.
4. Thưởng sẽ tự gửi vào Túi.
5. Càn quét xong có thể xem phần thưởng được nhận.
]],
OVER_SWEEP_COUNT = "Không thể vượt số lần càn quét tối đa!",
SWEEPING_NOT_SHUT = "Đang càn quét, không thể đóng!",
SWEEPING_NOW = [[<T C="255,255,255" S="25" P="0">Đang càn quét...</T>]],
SWEEPTIME_EXP = [[<T C="255,255,255" S="25" P="0">Lần </T><T C="0,246,34" S="25" P="0">%d</T><T C="255,255,255" S="25" P="0">: Nhận </T><T C="0,246,34" S="25" P="0">%d</T><T C="255,255,255" S="25" P="0"> EXP, </T>]],
SWEEP_GET_SWARD = [[<T C="255,255,255" S="25" P="0">Nhận</T><T C="0,246,34" S="25" P="0"> %s </T>]],
SWEEP_TIMMING = [[<T C="255,255,255" S="25" P="0">Đang càn quét </T><T C="0,246,34" S="25" P="0">［%s］</T><T C="255,255,255" S="25" P="0"> sau kết thúc</T>]],
CHECK_REWARD = "Xem thưởng",
NO_LESS_ONE = "Số lần càn quét không thể dưới 1!",
SWEEP_ENDIND = [[<T C="255,255,255" S="25" P="1">Càn quét kết thúc</T>]],
SWEEP_MAPNAME = [[<T C="255,255,255" S="25" P="0">Ải càn quét: </T><T C="0,246,34" S="25" P="0">%s</T>]],
SWEEP_TIMES = [[<T C="255,255,255" S="25" P="0">Lần khiêu chiến còn: </T><T C="0,246,34" S="25" P="0">%s</T>]],
SWEEP_USEDACT = [[<T C="255,255,255" S="25" P="0">Thể Lực tốn: </T><T C="0,246,34" S="25" P="0">%d</T>]],
SWEEP_WINEXP = [[<T C="255,255,255" S="25" P="0">Tổng EXP nhận: </T><T C="0,246,34" S="25" P="0">%d</T>]],
--在线奖励
REWARD_BTN_LOGIN = "Đăng nhập",
REWARD_BTN_ONLINE = "Online",
BUY_UNSUCCESS = "Số lần mua hôm nay đã đạt tối đa, hãy tăng cấp VIP để tăng số lần mua!",
TASK_QUICKCOMPLETE = "Xong nhanh",
TASK_DOING = "Đang làm",
SPECIAL = "Đặc biệt",
CONTINUOUSATTACKS = "Liên tục tấn công",
MIGHTHIT = "Uy lực",
TRACKPOSITION = "Định vị",
UNMOUNTED = "Chưa khảm",
RENEWALS = "Gia hạn",
RANGE  = "Phạm vi",
SKAT = "POW",
GEM = "Đá",
WEAR = "Mặc",
UNROYAL = "Tháo",
SELL = "Bán",
TRYWEAR = "Mặc thử",
VIP = "Hội viên",
STRENGTENRECV = "Cường hóa đạt Lv%d nhận",
PRACTICE_NOLEVEL= "Cấp tu luyện đã đầy, hãy tăng đến Lv%d",
LAY = "Thiết lập",
DAILY_FRIST_RECHARGE = "Nạp lần đầu mỗi ngày sẽ nhận đạo cụ sau",
NO_CHALLENGE_TIMES = "Số lần khiêu chiến không đủ để càn quét!",
CANNOT_BUY_VIGOR = "Thể Lực đã cao nhất, không thể mua tiếp",
UPGRADE = "Tăng cấp",
MAP_EVENT = "Sự kiện đặc biệt",
MAP_EVENT_ON = "Mở",
TEACH_CHICK = "Nhấp đồng ý",
MAINTASK_UPLEVEL_TITLE = "Đạt Lv%d",
MAINTASK_UPLEVEL_GOALS = [[<T C="0,246,34" S="24" P="0">Đạt Lv%d </T><T C="255,0,0" S="24" P="0">(%d/%d)</T>]],
IKNOW = "Đã xem",
DAILY_RECHARGE = "Nạp ngày",
TZSX = "Thuộc tính bộ",
IMPROVE_REWARD_NEED = "Tăng thưởng cần tốn ",
NOMORETIP = "Không nhắc lại",
MONTH_CARDS_TIP6 = "Hết hạn",
MONTH_CARDS_DIAMOND = "Kim Cương",
CONTINUOUS = "Liên tục ",
BUY = "Mua",
COMPLETE_TASK = "Hoàn thành",
RINGLEFT = "Nhẫn",
VIP_TIP02 = "Cấp VIP đã đủ, cảm ơn đã ủng hộ!",
VIP_TIP04 = "Hiện tại: ",
VIP_TIP06 = "Nạp tiếp",
VIP_TIP08 = [[<T C="255,255,255" S="32" P="0">Cần đạt </T><T C="255,255,0" S="32" P="0">VIP%d</T><T C="255,255,255" S="32" P="0"> mới được nhận</T>]],
VIP_POWER = "Đặc quyền",
PRACTICE_DAY_COST_TIP = "Không đủ huy chương, cấp hiện tại mỗi ngày tốn %d huy chương",
RINGLEFTEXP = "Nhẫn",
REWARD_EXPLAIN_MESSAGE = 
[[
1. Nạp lần đầu hằng ngày nhận thưởng tương ứng.
2. Tối đa nhận thưởng %d lần.
3. %d-%d Kim Cương nhận %d lần, %d-%d Kim Cương nhận %d lần, %d Kim Cương trở lên nhận %d lần.
]],
TEACH_OPEN = "Mở tính năng mới",
PRACTICE_HELP = 
[[
1. Lv35 mở Tu Luyện.
2. Tu luyện gồm 80 cấp.
3. Hoàn thành nhiệm vụ ngày và nhận quà VIP được nhận Huy Hiệu.
4. Huy Hiệu dùng để tăng tu luyện, tăng cấp tu luyện nhận thuộc tính tương ứng.
]], 
ATGHLETICS = "Thi Đấu",
QUICK_COMPLETE_NEED = "Xong nhanh nhiệm vụ này cần tốn",
GIRL = "Giới tính (Nữ)",
BOY = "Giới tính (Nam)",
DEFAULT = "Mặc định",
TIP_INPUT_OLD_PASSWORD = "Nhập mật khẩu cũ",
ISFRIEND = "Người chơi này đã trong danh sách bạn bè",
PRACTICE_ATTRIBUTE_NAME = "Thuộc tính tu luyện",
PRACTICE_NEED_NAME = "Tu luyện cần",
TIP_WILLBE_OPEN_MULTILPE = "Lv%d mở phó bản nhóm",
MONEY_UNIT = " Đồng",
NONE_CHALLENGE_TIMES = "Lượt khiêu chiến không đủ!",
ZSLEVEL_NOT_ENOUGH_CHALLENGE = "Chưa đạt chuyển sinh Lv%d, không thể khiêu chiến ải này",
ENERGY = "Thể Lực",
BUY_VIGORS = "Thể Lực không đủ, hãy dùng Bánh Donut hoặc mua trực tiếp.",
GETREWARD_GOLDS = [[<T C="0,246,34" S="25" P="0"> %d </T><T C="255,255,255" S="25" P="0">Vàng, </T>]],
SWEEP_WINGOLDS = [[<T C="255,255,255" S="25" P="0">Vàng nhận: </T><T C="0,246,34" S="25" P="0">%d</T>]],
MAILMAXLENG = "Nhấn viết nội dung thư, tối đa 200 ký tự",
MAILTITELENT = "Nhập tiêu đề thư",
NUM1 = "Số lượng ",
Praticefull = "Cấp tu luyện thuộc tính hiện tại đã đầy!",
MONTH_CARDS = "Thẻ Tháng",
DIALOG_TASK_ISLAND = "Hiện tại còn nhiệm vụ chưa hoàn thành!",
CAN_NOT_MATERIALS = "Nguyên liệu ghép không đủ!",
TEACH_BOSS_NAME = "Nấm Tròn",
TEACH_BATTLE_TALK_TEXT_8 = "Nấm Nhỏ đợi hiệu lệnh của ta, bay nào!",
CONNECTED_SERVER = "Đang kết nối máy chủ",
DOWNLOAD_RESOURCE = "Đang dữ liệu",
SETTLMENT_KILL = "Diệt", 
SETTLMENT_DAMAGE = "Sát thương", 
SETTLMENT_HIT = "Chính xác", 
SETTLMENT_GANGFIGHT = "Công Hội Chiến ",  
LOTTERY_OPEN = "Mở ô thần bí",
LOTTERY_OPENNING = "Đang mở thưởng",
duihuan = "Đổi",
USEPASSWORD = "Dùng mật khẩu",
SetPASSWORD = "Đặt mật khẩu",
MAINTASK_UPLEVEL_GOALS_NEEDZS = [[<T C="0,246,34" S="24" P="0">Chuyển sinh Lv%d </T><T C="255,0,0" S="24" P="0">(%s %d/%s %d)</T>]],
MAINTASK_UPLEVEL_ZS_TITLE = "Tăng cấp đến chuyển sinh Lv%d",
TASK_BRANCH = "Phụ",
SINGLEMAP_DESC = 
[[
1. Vào Vùng Mạo Hiểm cần tốn Thể Lực, Thể Lực mỗi 6 phút hồi 1 điểm.
2. Mỗi ải tốn Thể Lực khác nhau.
3. Số lần vượt ải mỗi ải khác nhau.
4. Số lần vượt ải tạo mới mỗi ngày.
5. Mở ải cần cấp nhất định.
6. Đạt cấp yêu cầu cần vượt ải trước mới được khiêu chiến ải kế tiếp.
7. Vùng Mạo Hiểm đã vượt có thể càn quét, mỗi lần tốn Vé Càn Quét.
8. VIP4 được càn quét liên tục.
]],
STAR_SOUL_BUTTON_UPDATE = "Tăng cấp", 
STAR_SOUL_LIGHT_FAIL = "Tăng cấp thất bại",
ACTIVITY_END_COUNTDOWN = "Kết thúc còn ",
ACTIVITY_START_COUNTDOWN = "Bắt đầu đếm ngược",
ACTIVITY_EATTING_TXT = "Thưởng thức",
ACTIVITY_TASTEOK_TIPS = "Thêm Thể Lực thành công",
BATTLE_MODEL_RANK = "Đấu Hạng",
CHESTTITLE = "Hãy chọn số rương mở",
CHEXTTIP = "Một lần mở tối đa %d",
ACITIVITY_RECHARGE_MSG = "Không có nhật ký nạp, không thể nhận thưởng.",
SALETIP = "Vật phẩm bán có thuộc tính cường hóa, tăng sao hoặc khảm, đồng ý bán?",
CARD_ADVANCE = "Tiến giới",
PLAYER = "Người chơi",
OFFLINE = "Không online.",
WIPE_OUT_MULTI = "Càn quét %d lần",
WIPEOUTNUM = "Vé Càn Quét không đủ",
ACTIVITY_TIME_KEY = "Thời gian hoạt động",
ACTIVITY_TIMELINE_KEY = "%d/%d - %d/%d",
ACTIVITY_COST_KEY = "Tích lũy tiêu phí",
ACTIVITY_CURRENT_COMPETILIVE_LEVEL = "Cấp thi đấu: ",
ACTIVITY_CURRENT_FIGHTING = "Lực chiến: ",
ACTIVITY_SHOW_LEVEL = "Lv%d",
ACTIVITY_BIG_GIFTPACKS = "Đạt ",
ACTIVITY_CUMULATIVE_LOGIN = "Đã tích lũy đăng nhập ",
ACTIVITY_CUMULATIVE_LOGIN_CP = " ngày",
ACTIVITY_SUCCESSFUL_STRENGTHEN_ANY = "Thành công cường hóa ",
ACTIVITY_EQUIPMENT_NUMBER = "%d món",
ACTIVITY_EQUIPMENT_TO = "Trang bị đến ",
ACTIVITY_EQUIPMENT_TOTARGET = "+%d",
ACTIVITY_CURRENT_CONSUMPTION = "Đã tốn ",
ACTIVITY_PREPAID_PHONE = "Đã nạp ",
CHESTMAXNUM = "Đã đạt tối đa",
CHESTMINNUM = "Đã đạt tối thiểu",
CHESTNOKEY = "Chìa Khóa không đủ",
ROOM_FIND_TIPS = "Hãy nhập đúng số phòng",
EQUIP = "Trang bị",
BRACELET = "Bao tay",
MEDAL = "Huy hiệu",
TREASURE = "Bảo vật",
CREATE_ROOM = "Tạo phòng",
CHANGE = "Sửa",
BAGBTNTEXT3 = "Kết bạn",
CLOTHES = "Trang phục",
HALL = "Sảnh",
MASTER_APPRENTICE = "Sư đồ",
MASTER = "Sư phụ",
APPRENTICE = "Đệ tử",
COMBATTING = "Chiến đấu",
ROOM_NUMBER = "Số phòng: ",
ROOM_NAME_BATTLE = "Tên phòng: ",
EVOLUTION = "Tiến hóa",
REBIRTH = "Trùng sinh",
MY_PETS = "Pet",
INTELLIGENCE = "Tư chất",
EXTRACTING_PETS = "Nhận Pet",
EXTRACTION = "Rút",
EXTRACTION_AGAIN = "Lần nữa",
PET_REBIRTH = "Trùng sinh",
DRESS = "Thời trang",
ROOM_SETTING = "Thiết lập phòng",
INVITE_PLAYER = "Mời",
PUT_SYNTHESIS_MATERIAL = "Hãy bỏ vào vật phẩm cần ghép",
CANNOT_FIND_SYNTHESIS_DATA = "Không thể ghép",
PLAYER_RANK_SCENEWORLDBOSS = "Hạng: ",
MAYBE_SUCCESS_SCENEWORLDBOSS = "Tỉ lệ thành công",
RANK_TIPS_1 = "Hạng %d",
RANK_TIPS_2 = "%d + Tên",
RANK_TIPS_3 = "Hạng %d-%d",
HURT_RANK_INFO = "Hạng ST: ",
COPY_VIGOUR_COST = "Thể Lực tốn: ",
NORMAL = "Thường",
PROBABILITY_DROP = "Tỉ lệ rơi",
MUST_SUCCESS_SCENEWORLDBOSS = "Chắc chắn thành công",
HURTTIPS_MSG_1 = "Người chơi top 3 sát thương được thưởng phong phú",
HURTTIPS_MSG_2 = "Diệt Khuyển Vực Sâu được nhận thêm thưởng tiêu diệt",
CHALLENGE_NOT_ENOUGH = "Lượt khiêu chiến ải không đủ",
SWEEP_INDEX = "Trận thứ %d",
FIRST_PASS = "Lần đầu vượt ải",
PASS_REWARD = "Thưởng vượt ải",
BACK_TIME = "%02d giây sau tự quay về",
LEVEL_LOCKED = "Vượt ải trước mới được khiêu chiến ải này",
LEVEL_UNREACHED = "Lv%d mở",
ACHIE_TITLE = "Thành tựu",
ACHIE_EFFECT = "Thuộc tính danh hiệu",
DESIGNATION_NO = "Không có danh hiệu",
DESIGNATION_SHOW = "Hiện tại",
DESIGNATION_ASSOCITION = "Công Hội",
DESIGNATION_ACTIVITY = "Hoạt Động",
DESIGNATION_SPECIAL = "Đặc Biệt",
DESIGNATION_SHIP = "Kết Hôn",
MASTER_DESIGNATION = "Danh hiệu sư đồ",
DESIGNATION_ACHIE = "Thành Tựu",
PLAYER_LEVEL_UNREACHED = "Lv%d mở Chat Thế Giới",
WAITING = "Đang đợi",
CREATE_COPY = "Tạo phó bản",
DIFFICULTY_LEVEL = "Độ khó",
RESET = "Tạo mới",
RESET_TIPS = [[<T S="24" C="220,211,185">Số lần khiêu chiến phó bản này = </T><T S="24" C="220,0,0">%d </T><BR>10</BR><T S="24" C="220,211,185" P="0">Tốn </T><I>%s </I><T S="25" C="246,246,0" P="0">%d%s</T><T S="24" C="220,211,185" P="0"> có thể tạo mới phó bản tiếp tục khiêu chiến</T>]],
WAITING_OTHERS_TURN_CARD = "Đang đợi người chơi khác lật thẻ: ",
TURN_CARD_COST = [[<T S="26" C="220,211,185" P="0">Lật thẻ trừ </T><I P="0">%s </I><T S="24" C="246,246,0" P="0">%d Kim Cương</T>]],
PLAYER_LEVEL_UNLOCK_COPY = "Lv%d mở",
COPY_LOCKED = "Vượt phó bản trước mới được khiêu chiến",
PET_REBRITH_EXPLAIN = "Trùng sinh Pet có thể nhận EXP Pet và Pet cần để tiến hóa",
RESET_NOT_ENOUGH = "Số lần tạo mới không đủ",
CONFORM_CHANGE = "Đồng ý sửa",
LEVEL_UNLOCK = "Lv%d mở",
LOCKED = "Chưa mở khóa",
RANKLIST_ITEM_MRT = "Top 3",
RANKLIST_ITEM_RYD = "Điện Vinh Dự",
RANKLIST_ITEM_SJH = "DHUB",
RANKLIST_ITEM_ZHANLI = "Lực Chiến",
RANKLIST_ITEM_DENGJI = "Cấp",
RANKLIST_ITEM_CHONGWU = "Pet",
RANKLIST_ITEM_ZUOQI = "Thú Cưỡi",
RANKLIST_ITEM_ZHANJI = "Chiến Tích",
RANKLIST_ITEM_CHENGJIU = "Thành Tựu",
RANKLIST_ITEM_GONGHUI = "Công Hội",
RANKLIST_ITEM_MEILI = "Hấp Dẫn",
RANKLIST_ITEM_SHIDE = "Sư Đức",
RANKLIST_ITEM_ENAI = "Tình Cảm",
POPUPMENUSTRING1 = "Thêm bạn",
POPUPMENUSTRING2 = "Đưa vào sổ đen",
POPUPMENUSTRING3 = "Chat riêng",
POPUPMENUSTRING4 = "Xóa",
POPUPMENUSTRING5 = "Giáng chức",
POPUPMENUSTRING6 = "Trục xuất",
POPUPMENUSTRING7 = "Đưa vào Bạn bè",
POPUPMENUSTRING8 = "Thông tin",
POPUPMENUSTRING9 = "Gửi thư",
POPUPMENUSTRING10 = "Thăng chức",
POPUPMENUSTRING11 = "Đồng ý chọn",
POPUPMENUSTRING12 = "Mời ra",
POPUPMENUSTRING13 = "Nhường",
DAILYCOPY_NOT_OPEN_TIPS = "Phó bản %s, hôm nay không thể khiêu chiến",
DAILYCOPY_LOCKED_TIPS = "Chưa mở, không thể khiêu chiến",
DAILYCOPY_OPEN_DAY = "Thứ %s mở",
OPEN_EVERYDAY = "Mở hằng ngày",
NUMBER_LEVEL = "Tầng %d",
PASS_CONDITION = "Yêu cầu: ",
SWEEPING = "Đang càn quét",
REMAIN_TIME = "Thời gian: ",
REMAIN_RESET_COUNT = "Tạo mới còn: ",
BELONG_TO_COMMUNITY = "Công Hội ",
CURRENT_PET = "Pet",
PET_COMBAT = "Lực chiến",
MOUNT_LEVEL = "Cấp thú cưỡi",
MOUNT_GRADE = "Điểm thú cưỡi",
KING_COMPETITION = "Vua Xạ Thủ",
COMPETITION_TIMES = "Đấu Trường",
REACH_ACHIEVEMENT = "Đạt thành tựu",
COMBAT_IN_ALL = "Tổng lực chiến",
USERRCP = "Hấp Dẫn",
DISCIPLE = "Đệ tử xuất sư",
HUSBAND = "Chồng",
WIFE = "Vợ",
COUPLE_LOVE = "Tình cảm",
SETTING_GAME_SETTING = "Thiết lập",
SETTING_CREATE_ACCOUNT = "Tạo tài khoản",
SETTING_INPUT_ACCOUNT = "Nhập tên tài khoản",
SETTING_INPUT_PASSWORD = "Nhập mật khẩu",
SETTING_INPUT_SUREWORD = "Nhập lại mật khẩu",
SETTING_INPUT_MAIL = "Hãy nhập hộp thư liên kết",
SETTING_SERVERS_STATE_FULL = "Hot",
SETTING_SERVERS_STATE_CROWD = "Đầy",
SETTING_SERVERS_STATE_GOOD = "Tốt",
SETTING_SERVER_AREA = "Server",
SETTING_EXCHANGEWORD = "Code",
COMMUNITYLOG1 = [[<T S="22" C="255,236,193" P="0">%s </T><T S="22" C="233,166,62" P="0"> đã vào Công Hội</T>]], 
COMMUNITYLOG2 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62"> tăng chức cho  </T><T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62" P="0"> lên làm  </T><T S="22" C="233,166,62" P="0">%s</T>]], 
COMMUNITYLOG3 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62"> đã rời Công Hội</T>]], 
COMMUNITYLOG4 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62"> giáng chức </T><T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62" P="0"> xuống làm </T><T S="22" C="233,166,62" P="0">%s</T>]],
COMMUNITYLOG5 = [[<T S="22" C="255,236,193" P="0">%s </T><T S="22" C="233,166,62"> tăng </T><T S="22" C="233,166,62" P="0"> Công Hội </T><T S="22" C="233,166,62" P="0"> đến </T><T S="22" C="233,166,62" P="0"> Lv%d</T>]], 
COMMUNITYLOG6 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62"> tăng </T><T S="22" C="233,166,62" P="0"> Tiệm Công Hội </T><T S="22" C="233,166,62" P="0"> đến </T><T S="22" C="233,166,62" P="0"> Lv%d</T>]], 
COMMUNITYLOG7 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62"> trục xuất  </T><T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62" P="0"> khỏi Công Hội</T>]], 
COMMUNITYLOG8 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62"> góp </T><T S="22" C="233,166,62" P="0">%d Kim Cương </T><T S="22" C="233,166,62" P="0"> nhận </T><T S="22" C="233,166,62" P="0"> %d Cống Hiến</T>]], 
COMMUNITYLOG9 = [[<T S="22" C="255,236,193" P="0">%s</T><T S="22" C="233,166,62"> góp </T><T S="22" C="233,166,62" P="0">%d Vàng </T><T S="22" C="233,166,62" P="0"> nhận </T><T S="22" C="233,166,62" P="0"> %d Cống Hiến</T>]], 
COMMUNITYLOG10 = [[<T S="22" C="255,236,193" P="0">%s </T><T S="22" C="233,166,62"> tăng </T><T S="22" C="233,166,62" P="0"> Vật Tổ Công Hội </T><T S="22" C="233,166,62" P="0"> đến </T><T S="22" C="233,166,62" P="0"> Lv%d</T>]], 
COMMUNITYLOG11 = [[<T S="22" C="255,236,193" P="0">%s </T><T S="22" C="233,166,62"> tăng </T><T S="22" C="233,166,62" P="0"> Trường Kỹ Năng </T><T S="22" C="233,166,62" P="0"> đến </T><T S="22" C="233,166,62" P="0"> Lv%d</T>]],
FRIEND = "Bạn bè",
RANKING = "Xếp hạng",
FRIENDNUM = "S.Lượng bạn",
TODAYRECV = "Lần nhận Thể Lực còn ",
INVITE = "Mời",
AKEYGIFT = "Tặng nhanh",
TOWER_MY_RECORD = "Nhật ký: ",
PET_SUM_EXCEED_ALTER ="Tối đa có thể có 200 Pet",
CHAT_ME = "Tôi",
SINGLECOPY_LOCKED_TIPS = "Vượt tất cả ải phó bản trước mới được xem phó bản kế",
HOUR = " giờ",
MINUTE = " phút",
SECOND = " giây",
AGING = "Hiệu lực",
APPFRIEND = "Xin phép bạn bè",
COMMUNITYINFO1 = "Tạm chưa có thông tin Công Hội, bạn có thể tự tạo Công Hội!",
COMMUNITYINFO2 = "Tên Công Hội không thể để trống",
COMMUNITYINFO3 = "Tên chứa từ không hợp lệ",
COMMUNITYINFO4 = "Tên Công Hội này đã tồn tại, hãy đặt lại",
COMMUNITYINFO5 = "Tên quá 8 ký tự",
COMMUNITYINFO6 = "Công Hội bạn nhập không tồn tại",
COMMUNITYINFO9 = "Đã gửi xin phép, vui lòng đợi",
COMMUNITYINFO17 = "Công Hội đã đủ người, không thể vào",
COMMUNITYINFO22 = "Thông tin Công Hội",
COMMUNITYINFO23 = "Hãy nhường chức chủ Công Hội trước",
COMMUNITYINFO24 = "Xác nhận rời Công Hội?\nCông Hội sẽ bị giải tán      ",
COMMUNITYINFO27 = "Tăng cấp Vật Tổ Công Hội thành công",
COMMUNITYINFO29 = "Vật Tổ Công Hội đã đạt cấp tối đa",
COMMUNITYINFO30 = "Hãy tăng cấp Công Hội",
COMMUNITYINFO31 = "Danh vọng Công Hội không đủ",
COMMUNITYINFO32 = "Tăng cấp Trường Kỹ Năng thành công",
COMMUNITYINFO33 = "Trường Kỹ Năng đã đạt cấp tối đa",
COMMUNITYINFO34 = "Học kỹ năng thành công",
COMMUNITYINFO35 = "Tăng cấp Tiệm Công Hội thành công",
COMMUNITYINFO37 = "Cống hiến cá nhân không đủ",
COMMUNITYINFO38 = "Tiệm Công Hội không đủ cấp, không thể mua",
COMMUNITYINFO39 = "Tiệm Công Hội đã đạt cấp tối đa",
COMMUNITYINFO40 = "Hội viên tăng %s: ",
COMMUNITYINFO41 = "Hãy tăng cấp Trường Kỹ Năng",
COMMUNITYINFO42 = "Đã đạt cấp tối đa",
COMMUNITYINFO43 = "Công Hội cần đạt Lv%d mới mở kiến trúc này",
COMMUNITYINFO44 = "Nhập nội dung tuyên ngôn",
COMMUNITYINFO45 = "Công Hội đã đạt cấp tối đa",
COMMUNITYINFO46 = "Dùng %d Kim Cương để tạo mới?",
COMMUNITYINFO47 = "Thiết lập cấp cơ bản thành viên vào Công Hội: ",
COMMUNITYINFO48 = "Cấp thiết lập phải là số",
COMMUNITYINFO49 = "Bạn chưa đủ cấp để vào Công Hội này",
COMMUNITYINFO50 = "C.Hiến ngày",
COMMUNITYINFO51 = "Trạng thái",
COMMUNITYINFO53 = "Rời Công Hội sẽ xóa cống hiến,\nxác nhận rời Công Hội?",
COMMUNITYINFO54 = "Nhập nội dung thư (tối đa 200 ký tự)",
COMMUNITYINFO55 = "Hội Trưởng: ",
COMMUNITYINFO56 = "Tuyên ngôn: ",
COMMUNITYINFO57 = "Danh vọng: ",
COMMUNITYINFO58 = "Tuyên ngôn Công Hội: ",
COMMUNITYINFO59 = "C.Hiến cá nhân: ",
COMMUNITYINFO60 = [[<T S="20" C="127,70,26" P="0">Góp </T><I Z="0.5">%s</I><T S="20" C="127,70,26" P="0">%d, nhận </T><I Z="1">ui/common/common_icon_ghgx.png</I><T S="20" C="127,70,26" P="0">%d và </T><I Z="1">ui/common/common_icon_gzww.png</I><T S="20" C="127,70,26" P="0">%d</T>]],
COMMUNITYINFO61 = [[<T S="20" C="127,70,26" P="0">Góp </T><I Z="0.5">ui/common/common_icon_jinbi.png</I><T S="20" C="127,70,26" P="0">%d, nhận </T><I Z="1">ui/common/common_icon_ghgx.png</I><T S="20" C="127,70,26" P="0">%d và </T><I Z="1">ui/common/common_icon_gzww.png</I><T S="20" C="127,70,26" P="0">%d</T>]],
COMMUNITYINFO62 = "Thuộc tính Vật Tổ ",
COMMUNITYINFO63 = "Cấp thiết lập phải nhỏ hơn hoặc bằng %s",
COMMUNITYINFO64 = "(PS: Xếp hạng chiến tích Công Hội tạo mới mỗi tuần!)",
COMMUNITYINFO65 =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> Thứ 2 đến thứ 7 mở Công Hội Chiến</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> Công Hội Chiến là dạng ghép đội 3V3</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> Công Hội Chiến sẽ chỉ chiến đấu với đội của Công Hội khác, cùng Công Hội không xếp chiến đấu với nhau</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> Công Hội Chiến kết thúc, người chơi sẽ được nhận Điểm Công Hội Chiến tương ứng biểu hiện trong trận chiến</T><BR></BR>
<T C="158,0,0" S="22" P="0">5.</T><T C="62,34,8" S="22" P="0"> Điểm Công Hội Chiến được thống kê để tính Hạng Chiến Tích Công Hội và Hạng Cá Nhân</T><BR></BR>
<T C="158,0,0" S="22" P="0">6.</T><T C="62,34,8" S="22" P="0"> Chiến tích cá nhân tạo mới hằng ngày, phát thưởng hằng ngày</T><BR></BR>
<T C="158,0,0" S="22" P="0">7.</T><T C="62,34,8" S="22" P="0"> Chiến tích Công Hội tạo mới hằng tuần, phần thưởng phát vào chủ nhật</T><BR></BR>
<T C="158,0,0" S="22" P="0">8.</T><T C="62,34,8" S="22" P="0"> Thưởng hạng chiến tích được gửi qua thư</T><BR></BR>
]],
COMMUNITYINFO66 = "(PS: Xếp hạng chiến tích cá nhân tạo mới sáng mỗi ngày!)",
COMMUNITYINFO67 = "%d trận thắng %d",
COMMUNITYINFO68 = "Thứ 2 đến thứ 7 mở Công Hội Chiến",
COMMUNITYINFO69 = "Công Hội đạt Lv%d mới mở tính năng này",
COMMUNITY1 = "Duyệt hội viên",
COMMUNITY2 = "Sửa tuyên ngôn",
COMMUNITY3 = "Tăng cấp Công Hội",
COMMUNITY4 = "Thiết lập Công Hội",
COMMUNITY5 = "Gửi thư nhóm",
COMMUNITY6 = "Rời Công Hội",
CommunityExplain1 =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> Vật Tổ Công Hội có thể tăng thuộc tính công, thủ, sinh lực thành viên</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> Vật Tổ Công Hội cấp càng cao tăng càng nhiều thuộc tính</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> Tăng cấp Vật Tổ Công Hội cần tốn Danh Vọng Công Hội</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> Cấp Vật Tổ Công Hội ≤ Cấp Công Hội</T><BR></BR>
<T C="158,0,0" S="22" P="0">5.</T><T C="62,34,8" S="22" P="0"> Thành viên Công Hội muốn nhận tăng thuộc tính, cần bái Vật Tổ Công Hội</T><BR></BR>
<T C="158,0,0" S="22" P="0">6.</T><T C="62,34,8" S="22" P="0"> Mỗi người được bái 1 lần/ngày</T><BR></BR>
<T C="158,0,0" S="22" P="0">7.</T><T C="62,34,8" S="22" P="0"> Bái thành công sẽ được nhận tăng thuộc tính, kéo dài đến 24:00 trong ngày</T><BR></BR>
]],
CommunityExplain2 =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> Có thể học kỹ năng trong Trường Kỹ Năng để tăng thuộc tính</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> Cấp Trường Kỹ Năng càng cao, cấp kỹ năng càng cao</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> Học kỹ năng tốn cống hiến cá nhân</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> Mỗi tăng 1 cấp Công Hội có thể tăng 10 cấp giới hạn kỹ năng Công Hội</T><BR></BR>
]],
CommunityExplain3 =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> Cấp Tiệm Công Hội càng cao, thành viên hưởng ưu đãi càng cao</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> Thành viên nhận Xu Khiêu Chiến từ phó bản Công Hội</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> Chỉ khi BOSS phó bản Công Hội tử vong, Tiệm Công Hội mới dùng thưởng rơi BOSS tương ứng bán cho thành viên</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> Mỗi ngày được mua 2 món hàng trong Tiệm Phó Bản Công Hội</T><BR></BR>
]],
PASS_ALL_TOWER_TIPS = "Chúc mừng đã vượt tất cả Tháp Thí Luyện",
SWEEP_RESULT_TIPS = "Càn quét tầng %s đã kết thúc, nhận thưởng: ",
APPROVALFRIEND = "Duyệt bạn bè",
FRIENDDYNAMIC = "H.Động",
NEXT_FLOOR = "Tầng kế",
ISGIVE = "Đã tặng",
EMPTYFRIENDTIP1 = [[Chưa có thông tin bạn bè]],
EMPTYFRIENDTIP2 = [[Chưa có thông tin động thái bạn]],
EMPTYFRIENDTIP3 = [[Chưa có thông tin xin phép bạn bè]],
DIITSUCCESS = "Tặng thành công",
REBATE = "Tặng lại",
FRIEND_MAX = "Bạn bè đã đạt tối đa",
FRIEND_EXIST = "Người chơi này và bạn đã là bạn bè",
FRIEND_WAIT = "Đã gửi xin phép bạn bè, vui lòng đợi",
FRIEND_SUC = "Đã gửi xin phép thêm bạn",
FRIEND_APPSUC = "Duyệt thêm bạn thành công",
FRIEND_OTHERMAX = "Số lượng bạn của mục tiêu đã đầy",
FRIEND_NOFRIENDVIGOR = "Tạm chưa có bạn bè tặng Thể Lực",
FRIEND_OVERVIGOR = "Lượt nhận hôm nay đã hết",
FRIEND_REFUSESUC = "Từ chối thêm bạn thành công",
LOVING_LEVEL = "Cấp tình cảm",
SEND_GIFT = "Tặng quà",
LOVING_BLOG = "Nhật ký",
ADVANCED_SUCCESS = "Thành công",
ADVANCED_ERROR = "Thất bại",
PET_REBORN_SUCCESS = "Trùng sinh Pet thành công",
PET_REBORN_ERROR = "Trùng sinh Pet thất bại",
RAFFLE_PET_ERROR = "Rút Pet thất bại",
CHANGE_PET_SKILL_ERROR = "Tẩy luyện kỹ năng Pet thất bại",
STRENGTHENINFO1 = "Trang bị cùng loại mới được kế thừa",
KING_DAYAWARD_TITLE = "Mỗi ngày nhận thưởng Điểm Vua Xạ Thủ",
KING_NO_MATCH = "Không có đối thủ thật là chán...",
KING_MATCHING = "Đang ghép...",
KING_TODAY_SCORE = "Điểm: ",
KING_WILL_AWARD = "Có thể nhận",
KING_REST_TIMES = "Số lần còn: ",
KING_SEASONSCORE = "Điểm mùa giải: ",
KING_SEASONRANK = "Hạng mùa giải: ",
KING_BATTLE_MATCH_OTHER = "Ghép đối thủ Tranh Bá",
KING_BATTLE = "Tranh Bá",
KING_SCORE_RANK = "Hạng điểm",
KING_STOP = "Kết thúc",
KING_GO_ON_MATCHING = "Ghép tiếp",
KING_JOIN_BATTLE = "Vào chiến trường",
KING_REST_OPEN_TIME = "Mở còn: ",
KING_REST_CLOSE_TIME = "Kết thúc còn: ",
KING_BATTLE_INTRODUCE = "Hướng dẫn Tranh Bá",
KING_BATTLE_OPENTIME = [[<T C="255,255,255" S="34">Thứ 2 đến Thứ 7 </T><T C="255,255,0" S="34">21:30 </T><T C="255,255,255" S="34">mở</T>]],
KING_END = "Tranh Bá kết thúc",
KING_END_TODAY = "Tranh Bá đã kết thúc",
KING_END_BATTLE_RESULT = "Chiến tích",
KING_END_HIGHEST_WINNING_STREAK = "Số lần liên thắng cao nhất",
KING_END_TODAY_SCORE = "Điểm Vua Xạ Thủ",
KING_END_TODAY_MONEY = "Lệnh Vua Xạ Thủ",
NOW_RANK = "Hạng hiện tại",
KING_FAMOUS = "Vua Xạ Thủ",
FIRST_PLACE = "Quán Quân",
SECOND_PLACE = "Hạng 2",
THIRD_PLACE = "Hạng 3",
WHAT_SEASON = "Mùa %d",
BATTLE_RESULT = "Chiến tích",
KING_RANK_MY_SCORE = "Điểm: ",
KING_RANK_MY_RANK = "Hạng: ",
KING_RANK_NO_PLAYER = "Đấu Vua Xạ Thủ mùa mới chưa mở, chưa có bảng điểm",
KING_RANK_TITLE = "Điểm Vua Xạ Thủ",
KING_RANK_BATTLERESULT = "%d trận thắng %d (Thắng: %d%s)",
KING_RANK_SUB_TITLE = [[<T C="255,255,255" S="20">Thứ 7 23:00 </T><T C="255,238,144" S="20">tổng kết hạng điểm và phát thưởng, Top 5 thưởng rất phong phú!~</T>]],
WIN_LOSE = "Thắng bại",
GET_AWARD = "Nhận thưởng",
KING_SCORE = "Điểm Vua Xạ Thủ",
KING_AWARD_SUBTITLE = "23:00 thứ 7 phát thưởng hạng căn cứ hạng Vua Xạ Thủ của người chơi",
KING_AWARD_TITLE = "Thưởng hạng Đấu Vua Xạ Thủ",
KING_AWARD_RANK = "Hạng %s",
KING_SHOP = "Tiệm Vua Xạ Thủ",
KING_MONEY = "Lệnh Vua Xạ Thủ",
ITEMNOTSALE = "Vật phẩm chưa bày bán",
TOWER_SWEEPING = "Đang càn quét...",
BAGBTNTEXT5 = "Xóa bạn bè",
RECHALLENGE = "Khiêu chiến lại",
GET = "Nhận",
MASTERINFO1 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">1: </T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">Được thu nhận %d đệ tử</T><BR>16</BR> <T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">2: </T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">Thuộc tính tăng: S.Lực </T><T C="99,255,95" S="20" P="1" SC="79,60,48" SS="4" SE="1">+%d%s</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">Công</T><T C="99,255,95" S="20" P="1" SC="79,60,48" SS="4" SE="1">+%d%s</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">Phòng</T><T C="99,255,95" S="20" P="1" SC="79,60,48" SS="4" SE="1">+%d%s</T><BR>16</BR> <T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">3: </T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">Thuộc tính đệ tử tăng: S.Lực</T><T C="99,255,95" S="20" P="1" SC="79,60,48" SS="4" SE="1">+%d%s</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">Công</T><T C="99,255,95" S="20" P="1" SC="79,60,48" SS="4" SE="1">+%d%s</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">Phòng</T><T C="99,255,95" S="20" P="1" SC="79,60,48" SS="4" SE="1">+%d%s</T> ]],
MASTERINFO2 = 
[[
Cách nhận sư đức
1. Đệ tử tăng cấp sư phụ có thể nhận sư đức, 
cấp càng cao nhận sư đức càng nhiều
2. Đệ tử xuất sư sư phụ có thể nhận sư đức, 
cấp khi bái sư càng thấp nhận sư đức càng nhiều
]],
MASTERINFO3 = 
[[
<T C="158,0,0" S="20">Bái Sư</T><BR></BR>
<T C="158,0,0" S="18">1.</T><T C="62,34,8" S="18">Từ Lv10-24 chưa có quan hệ sư đồ có thể bái sư</T><BR></BR>
<T C="158,0,0" S="18">2.</T><T C="62,34,8" S="18">Cấp người chơi được bái sư cần ≥ Lv25 và chưa đầy đệ tử</T><BR></BR>
<T C="158,0,0" S="20">Nhận Đệ Tử</T><BR></BR>
<T C="158,0,0" S="18">1.</T><T C="62,34,8" S="18">Người chơi Lv25 trở lên và chưa nhận đủ đệ tử</T><BR></BR>
<T C="158,0,0" S="18">2.</T><T C="62,34,8" S="18">Lv người bái sư phải trên Lv9 và nhỏ hơn Lv25, không có quan hệ sư đồ</T><BR></BR>
<T C="158,0,0" S="20">Xuất Sư</T><BR></BR>
<T C="62,34,8" S="18">Đệ tử Lv25 tự động xuất sư, sau khi xuất sư 2 bên sư đồ nhận quà xuất sư</T><BR></BR>
<T C="158,0,0" S="20">Phúc Lợi Sư Đồ</T><BR></BR>
<T C="158,0,0" S="18">1.</T><T C="62,34,8" S="18">Đệ tử có thể nhận BUFF Sư Môn, cấp Sư Đức sư phụ càng cao hiệu quả BUFF càng cao</T><BR></BR>
<T C="158,0,0" S="18">2.</T><T C="62,34,8" S="18">Đệ tử tăng cấp có thể nhận Quà Cấp</T><BR></BR>
<T C="158,0,0" S="18">3.</T><T C="62,34,8" S="18">Sư phụ có thể nhận tăng thuộc tính từ cấp Sư Đức, cấp Sư Đức càng cao nhận càng nhiều thuộc tính</T><BR></BR>
<T C="158,0,0" S="18">4.</T><T C="62,34,8" S="18">Đệ tử tốn Thể Lực, sư phụ sẽ nhận Thể Lực</T><BR></BR>
<T C="158,0,0" S="20">Sư Đức</T><BR></BR>
<T C="158,0,0" S="18">1.</T><T C="62,34,8" S="18">Đệ tử lên cấp, sư phụ nhận Sư Đức</T><BR></BR>
<T C="158,0,0" S="18">2.</T><T C="62,34,8" S="18">Đệ tử xuất sư, sư phụ nhận Sư Đức, cấp đệ tử khi nhận vào càng thấp, Sư Đức nhận khi xuất sư càng cao</T><BR></BR>
]],
MASTERINFO4 = 
[[
2015/6/1 6:00 Lv.66
%s
]],
MASTERINFO6 = "Bạn làm sư phụ tôi nhé!!!",
MASTERINFO7 = "Tôi rất ngưỡng mộ bạn, làm sư phụ tôi nhé!!",
MASTERINFO8 = "Tôi thật sự rất ngưỡng mộ bạn, làm sư phụ tôi đi!",
MASTERINFO9 = "Làm sư phụ và dẫn tôi đi ăn nha, tôi sẽ cố gắng lên cấp mà!",
MASTERINFO10 = "Tôi rất có tiềm năng, hãy nhận tôi đi.",
MASTERINFO11 = "Để tôi hướng dẫn bạn, làm đệ tử tôi nha",
MASTERINFO12 = "Tôi muốn nhận đệ tử, bạn đồng ý không?",
MASTERINFO13 = "Làm đệ tử tôi đi, đừng từ chối duyên phận này",
MASTERINFO14 = "Tôi là sư phụ tốt, hiện cần tuyển đệ!",
MASTERINFO15 = "Hãy cùng tôi ngao du khắp nơi nào",
MASTERINFO16 = "Hãy nhập ID người chơi",
MASTERINFO17 = [[<T C="151,64,19" S="20">Xác nhận hủy quan hệ sư đồ với %s?</T><BR></BR><T C="134,113,92" S="20">Đối phương rời mạng dưới </T><T C="158,0,0" S="20"> 72 </T><T C="134,113,92" S="20"> giờ, cưỡng chế hủy quan hệ sư đồ, trong </T><T C="158,0,0" S="20"> %d </T><T C="134,113,92" S="20"> giờ tới không thể %s lại. </T><T C="158,0,0" S="20">(Hủy Kim Cương không hạn chế thời gian)</T>  ]],
MASTERINFO18 = "Bái sư",
MASTERINFO19 = "Nhận đệ tử",
MASTERINFO20 = "Hủy quan hệ",
MASTERINFO21 = "Tăng cấp sư đức",
MASTERINFO22 = "ID người chơi chỉ được là số",
MASTERINFO23 = "Bạn có %d đệ tử, hãy xem họ xuất sư",
MASTERINFO24 = "Tin tức",
MASTERINFO25 = "Đổi",
MASTERINFO26 = "Bạn đã có sư phụ",
MASTERINFO27 = "Đã bái sư",
MASTERINFO28 = "Đã nhận đệ tử",
MASTERINFO29 = "Thổ lộ chân tình để cảm động %s tương lai",
MASTERINFO30 = "Yêu cầu",
SUREDELFRIEND = "Xóa bạn sẽ xóa thân mật, tiếp tục không?",
WEDDING_DIARY_1= [[<T C="236,166,62" S="22">%s </T><T C="255,236,193" S="22"> đã vào lễ đường </T><T C="79,49,68" S="20">     %s</T>]],
WEDDING_DIARY_2= [[<T C="236,166,62" S="22">%s </T><T C="255,236,193" S="22"> đã vào lễ đường </T><T C="79,49,68" S="20">     %s</T>]],
WEDDING_DIARY_3= [[<T C="236,166,62" S="22">%s </T><T C="255,236,193" S="22"> đã phát Lì Xì </T><T C="79,49,68" S="20">     %s</T>]],
WEDDING_DIARY_4= [[<T C="236,166,62" S="22">%s </T><T C="255,236,193" S="22"> đã giành được Lì Xì, nhận </T><T C="255,89,74" S="22">%d </T> <T C="255,236,193" S="22"> Vàng </T><T C="79,49,68" S="20">     %s</T>]],
WEDDING_DIARY_5= [[<T C="236,166,62" S="22">%s </T><T C="255,236,193" S="22"> đã phát Kẹo Hỉ </T><T C="79,49,68" S="20">     %s</T>]],
WEDDING_DIARY_6= [[<T C="236,166,62" S="22">%s </T><T C="255,236,193" S="22"> đã giành được Kẹo Hỉ, nhận </T><T C="255,89,74" S="22">%d </T><T C="255,236,193" S="22"> Thể Lực </T><T C="79,49,68" S="20">    %s</T>]],
WEDDING_DIARY_7= [[<T C="236,166,62" S="22">%s </T><T C="255,236,193" S="22"> đã bắn Pháo Hoa, tăng </T><T C="255,89,74" S="22">%d </T><T C="255,236,193" S="22"> EXP </T><T C="79,49,68" S="20">    %s</T>]],
WEDDING_DIARY_8= [[<T C="236,166,62" S="22">%s </T><T C="255,236,193" S="22"> đã tặng Chúc phúc, tăng </T><T C="255,89,74" S="22">%d </T><T C="255,236,193" S="22"> EXP </T><T C="79,49,68" S="20">     %s</T>]],
WEDDING_DIARY_9= [[<T C="236,166,62" S="22">%s và %s </T><T C="255,236,193" S="22"> đã tăng </T><T C="255,89,74" S="22">%d </T><T C="255,236,193" S="22"> tình cảm </T><T C="79,49,68" S="20">     %s</T>]],
LOVING_DIARY_1 = [[<T C="255,236,193" S="22"> Bạn </T><T C="255,236,193" S="22"> tặng </T><T C="255,227,116" S="22">%s </T><T C="255,236,193" S="22">1 </T><T C="255,227,116" S="22">%s </T><T C="255,236,193" S="22">, tăng </T><T C="255,89,74" S="22">%d </T><T C="255,236,193" S="22"> tình cảm </T><T C="79,49,68" S="20">     %s</T>]],
LOVING_DIARY_2 = [[<T C="236,166,62" S="22">%s</T><T C="255,236,193" S="22"> tặng </T><T C="255,236,193" S="22">bạn </T><T C="255,236,193" S="22">1 </T><T C="255,227,116" S="22">%s </T><T C="255,236,193" S="22">, tăng </T><T C="255,89,74" S="22">%d </T><T C="255,236,193" S="22">tình cảm </T><T C="79,49,68" S="20">     %s</T>]],
LOVING_DIARY_3 = [[<T C="255,236,193" S="22"> Vợ chồng cùng </T><T C="255,236,193" S="22"> hoàn thành 1 trận chiến, </T><T C="255,236,193" S="22"> tăng </T><T C="255,89,74" S="22">%d </T><T C="255,236,193" S="22"> tình cảm </T><T C="79,49,68" S="20">     %s</T>]],
WEDDING_INVITE_TIPS = "%s mời bạn dự Hôn Lễ, bây giờ đồng ý đi chứ?",
SEND_BLESSING_1 = "Chúc cô dâu chú rể trăm năm hạnh phúc",
SEND_BLESSING_2 = "Chúc cô dâu chú rể răng long đầu bạc",
SEND_BLESSING_3 = "Chúc cô dâu chú rể hạnh phúc mỹ mãn",
ROB_TRUE_RED = "Chúc mừng bạn giành được 1 Lì Xì\n Nhận %d Vàng",
ROB_TRUE_CADDIES = "Chúc mừng bạn giành được 1 Kẹo Hỉ\n Nhận %d Thể Lực",
CANDIES_FALSE = "Chậm quá, Kẹo Hỉ đã bị giành hết",
ROB_FALSE = "Chậm quá, Lì Xì đã bị giành hết",
WEDDING_FILLED = "Hội trường đông nghịt",
WHAT_WORLD_TIPS = "Cách 15 giây mới được phát!!",
SHOP_RECOMMEND = "Đề cử",
SHOP_SAVE_IMG = "Giỏ Hàng",
SHOP_NEW = "Vật phẩm mới",
SHOP_HOT = "Bán chạy",
SHOP_DAY_LIMITED = "Lượt mua hôm nay đã đạt tối đa",
SHOP_DAY_LIMIT = "Giới hạn mua hôm nay",
SHOP_IND = " cái",
SHOP_NO_NEED = "Bạn có vật phẩm này vô thời hạn, không cần mua",
MATCHES_MODE = "Dạng Ghép",
FREE_MODE = "Dạng Tổ Đội",
SCUFFLE_MODE = "Dạng Giao Chiến",
HOMEOWNER = "Chủ phòng",
READY = "Chuẩn bị",
CHANGE_MATCH_ERROR = "Số người trong phòng quá nhiều, không thể ghép, đổi thất bại",
OFFLINESTATE = "Rời mạng",
QUALIFYING_SEASON = "Chiến tích mùa giải",
QUALIFYING_REWARDDESC = "Hướng dẫn thưởng",
QUALIFYING_RANK = "BXH đơn",
QUALIFYING_LOG = "Nhật ký chiến tích",
QUALIFYING_SHOP = "Tiệm Xếp Hạng",
QUALIFYING_MAKEPAIR = "Đang tìm đối thủ",
QUALIFYING_FIGHT = "Khai chiến",
QUALIFYING_CLOSETIPS = "Thứ 2 đến Thứ 7 12:00-21:00 mở",
QUALIFYING_WIN = "Thắng: %d trận thắng %d (%d%%)",
QUALIFYING_WINSTREAK = "Liên thắng cao nhất: %d trận",
QUALIFYING_CURRENCY = "Cấp bậc Xu: %d",
QUALIFYING_SCORE = "Điểm hạng: %d",
QUALIFYING_TITLE = [[<T C="255,255,255" S="22">Danh hiệu bậc: </T><T C="%d,%d,%d" S="22">%s</T>]],
QUALIFYING_DAILY = [[<T C="127,70,26" S="20">Chiến tích hôm nay: </T><T C="158,0,0" S="20"> %d trận, thắng %d</T>]],
LOVING_DAILY = "Không có nhật ký tình cảm",
RELIEVE_RELATT_SUCCESS = "Hủy quan hệ thành công",
ROOM_NAME = "Tên phòng",
ROOM_PASS = "Mật khẩu",
SELECT_MAP_TIPS = "Dạng ghép đội chỉ được dùng bản đồ ngẫu nhiên",
ROOM_PASS_ERROR = "Mật khẩu phòng chỉ được dùng số và chữ cái",
ROOM_PASS_ERROR2 = "Mật khẩu phòng tối đa 8 ký tự",
ROOM_NAME_ERROR = "Tên phòng tối đa 8 ký tự",
ROOM_NAME_ERROR2 = "Tên phòng không thể có khoảng trống",
COST_GOODS_TIPS1 = "Vật phẩm cần không đủ, tốn Kim Cương %d",
COST_GOODS_TIPS2 = "Vật phẩm cần không đủ, tốn Vàng %d",
SEND_WEDDING_GOODS1 = "Đang phát Lì Xì",
SEND_WEDDING_GOODS2 = "Đang phát Kẹo Hỉ",
SEND_WEDDING_GOODS3 = "Đã có người đang tặng Chúc phúc",
SEND_WEDDING_GOODS4 = "Đã có người đang bắn súng chào",
SEND_PROPOSAL_LETTER1 = "Gửi thư cầu hôn thành công",
SEND_PROPOSAL_LETTER2 = "Đạo cụ không đủ",
SEND_PROPOSAL_LETTER3 = "Đối phương không online",
SEND_PROPOSAL_LETTER4 = "Đối phương không đủ cấp",
SEND_PROPOSAL_LETTER5 = "Đối phương đang chiến đấu",
SEND_PROPOSAL_LETTER6 = "Đã gửi cầu hôn",
SEND_PROPOSAL_LETTER7 = "Mục tiêu đã đính hôn hoặc đã kết hôn",
SEND_PROPOSAL_LETTER8 = "Trong 10 phút chỉ có thể tổ chức hôn lễ 1 lần",
PROPOSE_TIPS = "Cầu hôn thành công hay không cũng tốn đạo cụ cầu hôn",
CHANGE_LOVER= "Hãy chọn bạn đời!",
PROPPSE_LIST_TIPS = " gửi %s cầu hôn.",
MINUTE_BEFORE = "%d phút trước",
HOUR_BEFORE = "%d giờ trước",
DAY_BEFORE = "%d ngày trước",
QUALIFYING_REFRESHTIME = "Tự tạo mới: 21:00 hằng ngày",
QUALIFYING_MYCOIN = "Xu Xếp Hạng: ",
SWEEP_CARD = "Vé càn quét",
MULTI_SWEEP = "Càn quét nhiều",
COPY_ENEMY = "Xuất hiện địch",
COPY_PROBABLE_DROP = "Có thể nhận",
COPY_GOAL = "Mục tiêu",
COPY_VIGOUR = [[<T S="21" C="83,56,29" P="1">Tốn Thể Lực: </T><I>ui/common/015.png</I><T S="21" C="83,56,29" P="1">%d</T>]],
COPY_GOAL1 = "Vượt phó bản",
COPY_GOAL2 = "Sinh lực trên %d%%",
COPY_GOAL3 = "Thắng sau %d lượt",
COPY_SWEEP = "Càn quét phó bản",
COPY_GOAL2_2 = "Còn %d%% sinh lực",
COPY_GOAL3_2 = "%d lượt",
MY_EQUIP = "Trang bị",
ON_BODY = "Trên người",
REACH_MAX_STRONG_LEVLE = "Đã cường hóa tối đa",
OWN = "Có ",
EQUIP_REACHED_MAX_STAR_LEVEL = "Đã tăng sao tối đa",
ATTACK_STONE_1 = "Đá Tấn Công",
DEFENSE_STONE_1 = "Đá Phòng Thủ",
HP_STONE = "Đá Sinh Lực",
CLICK_TO_REMOVE = "Tháo",
CLICK_TO_ADD = "Thêm",
TRANSFER_COST = "Kế thừa tốn ",
BUY_TRANSFERSTONE_MESSAGE = "Đá Kế Thừa không đủ, mua ngay?",
PLEASE_SELECT_TRANSFER_EQUIP = "Chọn trang bị kế thừa",
EQUIPONE_LESS_THAN_EQUIPTWO = "Cấp cường hóa và tăng sao cần lớn hơn trang bị kế thừa",
IN_USE = "Đang dùng",
MY_GEM = "Đá Quý",
TURNCARD_VIP_TIPS = "VIP5 mới được lật thẻ",
ATH_DAILY_REWARD = "Thưởng Cấp Thi Đấu",
ATH_REFRESH_LIMIT = "Lần tạo mới hiện tại của bạn đã đạt tối đa",
ATH_SHOP = "Tiệm",
ATH_SHOP_REFRESH = "Tạo mới vào 24:00 mỗi ngày",
ATH_REWARD_CHECK = "Thưởng",
ATH_FREE = "Tổ đội",
ATH_MIX = "Giao Chiến",
SETTING_EXCHANGEWORD1 = "Code này đã được sử dụng",
SETTING_EXCHANGEWORD2 = "Bạn đã sử dụng code rồi",
SETTING_EXCHANGEWORD3 = "Hãy nhập chính xác code",
WNDPLAYERINFO1 = "Thuộc tính của tôi",
WNDPLAYERINFO2 = "Thông tin",
WNDPLAYERINFO3 = "Thuộc tính",
WNDPLAYERINFO4 = "Chữ ký",
WNDDRESS1 = "Biểu cảm",
WNDDRESS2 = "Thời trang",
OPAN_FOR_LEVEL = "Lv%d mở",
SERVER_TIME = "Thời gian máy chủ: ",
REVIVE_MODES = "Hồi sinh",
ATH_SHOP_HAVE_NUM = [[<T C="79,60,48" S="22" P="0">Có </T><T C="158,0,0" S="22" P="0">%d</T><T C="79,60,48" S="22" P="0"> món</T>]],
ATH_SHOP_COST = "Tốn ",
ATH_WAIT = "Đợi",
SHOP_BUY_DESC = [[<T C="79,60,48" S="20" P="0">Gồm %d vật phẩm, cần chi trả </T><I Z="0.8">ui/common/common_icon_zuanshi.png</I><T C="79,60,48" S="20" P="0">%d</T>]],
WAITING_MATCHES = "Ghép chiến đấu",
ROOM_INFO = "Thông tin phòng",
FRIENDS_SEND_TIP_1 = " tặng bạn ",
FRIENDS_SEND_TIP_2 = " Thể Lực",
FRIENDS_SEND_TIP_3 = [[Chưa có dữ liệu]],
PLEASE_INPUT_ID_FIRST = "Nhập ID người chơi",
PLEASE_CHOOSE_PLAYER = "Hãy chọn người chơi",
NO_PLAYER_IN_HALL = [[Sảnh không có người khác]],
NO_VATALITY_CAN_GET = "Không có Thể Lực để nhận",
PLEASE_SEND_AFTER_GETTING = "Hãy nhận rồi tặng",
DAILY_KILL_SMALLM = "Diệt quái nhỏ",
DAILY_KILL_BIGM = "Diệt quái Tinh Anh",
DAILY_KILL_BOSS = "Diệt BOSS",
ATH_JINGJI_DESC = "Dạng ghép, hệ thống sẽ ghép kẻ địch thích hợp nhất, chiến thắng được nhận điểm thi đấu",
ATH_SAFE_DESC = "Được tự do chọn đồng đội và đối thủ, dạng này không được điểm thi đấu",
ATH_SAFE_DESC2 = "Đấu tập có thể đấu với người chơi chỉ định nhưng sẽ không nhận thưởng, dùng để tập luyện cách đấu hoặc hẹn chiến",
ATH_SAFE_DESC3 = "Dạng Giao Chiến không có mục chọn",
RESULT_DOWN_TIME = [[<T C = "255,255,255" S = "24" P = "0">%02d</T><T C = "255,255,255" S = "22" P = "0"> giây sau quay về</T><T C = "255,255,255" S = "20" P = "0">(Nhấn khoảng trống để bỏ qua)</T>]],
RESULT_DOWN_TIME2 = [[<T C = "255,255,255" S = "24" P = "0">%02d</T><T C = "255,255,255" S = "22" P = "0"> giây sau quay về</T>]],
NOT_START_GAME = "Số người 2 đội không bằng nhau, không thể bắt đầu",
CLOSE_SETAT_TIP = "Vị trí này đã có người chơi, không thể đóng chỗ này",
BATTLE_SKILL = "Đạo cụ chiến đấu",
SKILL_TIP = "Chọn đạo cụ cần từ danh sách đạo cụ, dùng trong chiến đấu",
SKILL_CELL_FULL = "Đã đạt tối đa",
SKILL_OPEN = "Mở",
LOADING_NICKNAME = "Tên",
EQUIPPED = "Đã trang bị",
UNEQUIPPED = "Chưa trang bị",
MAIL_NAME = "Thư",
HIGHEST_RECORD = "Kỷ lục cao nhất: ",
SWEPT_LEAVE_TIEM = "Thời gian càn quét còn lại ",
TOWER_LEVEL = "Tầng tháp",
HAVE_NOT_ROOM = "Chưa có phòng",
TOWER_LEVEL2 = "Tầng",
CHALLEGE_OVER = "Lượt khiêu chiến đã hết",
SWEEPING_TIP = "Trạng thái càn quét không thể chủ động chiến đấu",
MOVING = "Đang di chuyển",
TEAM_MAYBE_GET = "Có thể\nnhận",
STOP_SWEEPING = "Dừng càn quét",
CHANGE_SEAT_TIPS = "Chuẩn bị vào game, không thể đổi chỗ!",
NOT_ENABLE = "Không đủ",
SWEEPING_TIP2 = "Ải dưới kỷ lục cao nhất mới được càn quét",
ATHMONEY_NOT_ENOUGH = "Xu Thi Đấu không đủ, mau hoàn thành mục tiêu thi đấu",
SELL_CONFIRM = "Có vật phẩm tốt\nĐồng ý bán?",
NOT_ATTENTION_TODAY = "Hôm nay không nhắc lại",
TODAY_REST_COUNT = "Số lần hôm nay còn: ",
CHALLENGE_AGAIN = "Khiêu chiến lại",
SHARE = "Chia sẻ",
CONTINUE = "Tiếp tục",
CURRENT_LEVEL = [[<T C="79,60,48" S="22" P="0">Hiện ở tầng </T><T C="99,255,95" S="22" P="0">%d</T><T C="79,60,48" S="22" P="0"></T>]],
RESERT_TIPS2 = "Tạo mới sẽ quay về tầng 1 và khôi phục số lần khiêu chiến",
MAIL_NOLIST = "Danh sách thư trống, không thể biên tập",
MAIL_ISWRITE = "Không thể sửa thư đang viết",
MAIL_GETANNEX = "Hãy lấy đính kèm",
MAIL_OUTTHEME = "Tiêu đề không được quá 36 ký tự!",
MAIL_OUTTEXT = "Nội dung thư không được quá 200 ký tự!",
DAILYCOPY_NOOPEN = "Phó bản hiện tại chưa mở",
DAILYCOPY_OPENLEVEL = "Độ khó phó bản này Lv%d mở",
SWEEP_ENDIND2 = "Càn quét kết thúc",
ROOM_HAVE_NOT_READY = "Phòng có người chơi chưa chuẩn bị",
BAGINFO1 = "Không có thời trang quá hạn",
ROOM_BEINVITED_2 = "%s mời tham gia\nđấu đội %s",
FAST_SWEEP_TIP = "Dùng %d Kim Cương hủy CD càn quét",
OPEN_SKILL_TAB_TIP = "Dùng 50 Kim Cương mua ô đạo cụ",
SHOP_LIMIT_TITLE = "Mua giới hạn",
LV = "Lv",
INTERACTIVE = "Tương tác",
CONTEXT = "Nội dung",
TURNCARD_DIAMOND_TIPS = "Kim Cương không đủ, không thể lật thẻ!",
WHISPER_TO_ME = " với tôi",
ME_TO_WHISPER = "Tôi với",
COST = "Tốn: ",
TOWER_SEND_DESC = [[<T C="127,70,26" S="20" P="0">Mỗi ngày</T> <T C="255,89,74" S="20" P="0"> %s </T><T C="127,70,26" S="20" P="0">Căn cứ hạng Tháp Thí Luyện phát thưởng</T>]],
MOUNTS_UP = "Cưỡi",
TXT_ONLINEFRIEND_ISNULL = [[Chưa có bạn bè online]],
TXT_ONLINEGUILD_ISNULL = [[Chưa có thành viên Công Hội online]],
MOUNTS_LEVEL = "Cấp: %d",
MOUNTS_PRE_ADD = "Tổng thuộc tính tăng",
HAS_GET = "Đã nhận ",
INHERIT = "Kế thừa",
NO_CHALLENGE_TIMES2 = "Lượt khiêu chiến không đủ, không thể khiêu chiến!",
SHOP_MIANBAO = "Miễn Bạo: ",
MOUNTS_TITLE_STAR = "Tiến Giới Thú Cưỡi",
MOUNTS_TITLE_UPGRAGE = "Tăng cấp thú cưỡi",
DISAPPEAR = "mất",
MOUNTS_MAX_UPGRADE = "Thú cưỡi này đã đạt cấp cao nhất",
MOUNTS_MAX_STAR = "Thú cưỡi này đã đạt sao cao nhất",
MOUNTS_STAR_NOLEVEL = "Thú cưỡi cần đạt Lv%d mới được tăng sao",
DESIGNATION_ATTENTION = "Trang bị ô chọn đã có danh hiệu, nhận tăng thuộc tính!",
STRENGTHEN_TOP = "Cấp cường hóa đạt tối đa! Giỏi quá!",
PETHEALTH = "S.Lực: ",
PETDEFENSE = "P.Thủ: ",
PETATTACK = "T.Công: ",
PETINTELLIGENCE = "Tư chất: ",
PETLOOK = "Xem",
PETEATFORUP = "Pet gộp tăng cấp",
PETEATFORADVANCE = "Pet gộp tiến hóa",
PETONECHOICE = "Chọn nhanh",
PETTOUP = "Tăng cấp",
PETADCANCE = "Tiến Hóa",
PETUSE = "Tốn",
PETHASNUM = "(Có %d)",
PETHAS = "Có :",
PETSKILL = "Lĩnh ngộ",
PETOPENEGE = "Đập trứng",
PETTOFREE = " sau miễn phí",
SHOP_NAME_AND_LEVEL = [[<T C="255,227,116" S="22" P="0">Lv%d </T><T C="255,255,255" S="22" P="0">%s</T>]],
MOUNTS_STAR_MAX = "Tăng bậc giới hạn",
CLICKCONTINUE = "Nhấp tiếp tục",
ACHIE_DISCRIPTION_TITLE = "Điều kiện nhận: ",
ACTOR_NAME_ERROR = "Tên nhân vật không được có khoảng trống",
ACTOR_MAX_NAME = "Tên nhân vật không quá %d ký tự",
ATH_REFRESH_COST = [[<T S="24" C="127,70,26" P="1">Muốn dùng %d Kim Cương tạo mới Tiệm?</T><BR></BR><BL>48</BL><T S="24" C="127,70,26" P="1">(Hôm nay đã tạo mới %d lần)</T>]], 
FailToBag = "Tăng các loại thuộc tính",
FailToTak = "Hoàn thành nhiệm vụ, tăng cấp",
FailToEquie = "Cường hóa trang bị, tăng các loại thuộc tính",
FailToItem = "Khác chờ mở rộng",
LOGIN_MY_SERVER = "Máy chủ của tôi",
LOGIN_RECOMMEND_SERVER = "Máy chủ đề cử",
SHOP_STONE = "Rương",
LOGIN_SERVER_STATE_CLOSE = "Bảo trì",
PET_1 = "Tư chất Pet",
PET_2 = "Thuộc tính",
PET_3 = "Chiến đấu",
PET_4 = "%d%s của sinh lực, tấn công, phòng thủ cộng lên nhân vật",
PET_5 = "Pet tấn công gây %d%s sát thương thường của nhân vật",
LEVEL1 = "",
PETOPENEGE1 = "Đập (Mảnh)",
PETOPENEGE2 = "Đập (KC)",
PETOPENEGE3 = "Đập x10",
Wedding_CountDown = "Hôn lễ còn ",
Wedding_Desc = "Tổ chức hôn lễ càng hào hoa, số lần tặng quà hằng ngày càng nhiều!",
Propose_Desc = 
[[
<T C="229,105,22" S="22" P="0">Sau khi kết hôn được nhận thời trang vĩnh viễn tăng lực chiến</T><T C="127,70,26" S="22" P="0"></T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Mỗi lần cầu hôn đều tốn đạo cụ cầu hôn</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Mỗi loại đạo cụ tương ứng một cách cầu hôn</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Đối tượng cầu hôn cần Lv21 trở lên</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Điểm thân mật với đối tượng cầu hôn phải trên 1000</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> Thân Mật nhận từ tặng quà hằng ngày, Thể Lực, cùng hoàn thành chiến đấu</T><BR>20</BR>
]],
Engagement_Desc = 
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> Đính hôn thành công sẽ nhận danh hiệu tương ứng</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> Hôn Lễ gồm: Hôn Lễ Xa Hoa, Hôn Lễ Hào Hoa, Hôn Lễ Lãng Mạn</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> Cấp Hôn Lễ càng cao, áo cưới càng đẹp</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> Cấp Hôn Lễ càng cao, thời gian chờ phát Lì Xì, Kẹo Hỉ, Pháo, tặng chúc phúc càng ngắn</T><BR></BR>
<T C="158,0,0" S="22" P="0">5.</T><T C="62,34,8" S="22" P="0"> Cấp Hôn Lễ càng cao, lợi ích nhận được càng nhiều</T><BR></BR>
<T C="158,0,0" S="22" P="0">6.</T><T C="62,34,8" S="22" P="0"> Cấp Hôn Lễ càng cao, tương tác vợ chồng hằng ngày càng nhiều (Có thể tăng nhanh cấp tình cảm để kích hoạt kỹ năng tương ứng)</T><BR></BR>
<T C="158,0,0" S="22" P="0">7.</T><T C="62,34,8" S="22" P="0"> Chọn loại hỗn lễ và thời gian cử hành, sẽ có thể gửi thiệp mời cho bạn bè và thành viên Công Hội</T><BR></BR>
<T C="158,0,0" S="22" P="0">8.</T><T C="62,34,8" S="22" P="0"> Gửi thiệp mời thành công, người nhận được thiệp đến tham dự hôn lễ, cả người nhận và người gửi đều được nhận Vàng tương ứng</T><BR></BR>
<T C="158,0,0" S="22" P="0">9.</T><T C="62,34,8" S="22" P="0"> Vàng nhận được nhiều hay ít tùy vào loại thiệp mời, thiệp mời giá càng cao Vàng nhận được càng nhiều</T><BR></BR>
<T C="158,0,0" S="22" P="0">10.</T><T C="62,34,8" S="22" P="0">Trong Hôn Lễ không được gửi thiệp mời</T><BR></BR>
<T C="158,0,0" S="22" P="0">11.</T><T C="62,34,8" S="22" P="0">Có thể đơn phương hủy quan hệ, nhưng sẽ tốn 333 Kim Cương </T><BR></BR>
]],
Propose_Item1 = "Đóa Hồng",
Propose_Item2 = "Giày Thủy Tinh",
Propose_Item3 = "Thế Kỷ Giai Duyên",
Propose_Item4 = "Nhẫn Kim Cương",
My_Love = "Thân yêu: ",
Love = "Người yêu: ",
MOUNTS_LEVEL_GET = "Lv%d nhận",
MOUNTS_GM_GET = "Hoạt động tặng",
BUY_ACTIVITY_LIMIT = "Có thể mua: ",
FULL_RECOVERY = "Hồi phục hoàn toàn",
NEXT_RECOVERY = "Hồi phục tiếp",
BUY_GOLD_LIMIT = "Có thể gọi: ",
SHAKE_TIMES = "Gọi %d lần",
RANDOM_MAP = "Bản đồ ngẫu nhiên",
SEND_INVITATION = "Gửi lời mời",
RICH_INVITAION = "Thiệp Phú Hào",
BEAUTIFUL_INVITAION = "Thiệp Tinh Xảo",
COMMON_INVITATION = "Thiệp Thường",
SELECT_WEDDING_TYPE = "Chọn hôn lễ muốn tổ chức",
SELECT_WEDDING_INV = "Chọn loại thiệp mời",
MARRY_INV_INFO = "Sự hiện diện của bạn là niềm vinh dự cho gia đình chúng tôi!",
INVITATION_CARD = "Thiệp Mời",
INVITATION_TIP = "Mời bạn tham dự hôn lễ của chúng tôi",
INVITATION_TIP2 = "Tổ chức hôn lễ",
WEDDING_TIME = "Thời gian: ",
SingInDesc = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Tích lũy điểm danh, nhận thưởng tương ứng</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Trong thời gian cố định đạt cấp VIP yêu cầu được nhận thưởng x2</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Thưởng 2 (Thưởng VIP x2) có thể nhận bù trong ngày khi tăng cấp VIP</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Thưởng điểm danh ngày tính lại vào lúc 24:00 mỗi ngày, thưởng trong ngày chưa nhận sẽ không thể nhận bù vào hôm sau</T><BR>20</BR>
]],
SingInTitle = "Thưởng điểm danh",
SingInDAYS = "Ngày %d",
SingInVipTips = "Đã nhận thưởng điểm danh trong ngày, tăng đến VIP%d có thể nhận thưởng x2, đồng ý nạp?",
SingInProgress = [[<T S="22" C="255,236,193" P="0">Điểm danh tích lũy tháng: </T><T S="22" C="255,227,116" P="0">%d</T><T S="22" C="255,236,193" P="0"> ngày</T>]],
ACTIVITY_HAVED_FULL = "Thể Lực đã đầy",
HOUR1 = " giờ",
MINUTE1 = " phút",
BEFORE = "Trước",
VIP_FIRST_DOUBLE = "Nạp lần đầu",
OppositeSexFriend = "Bạn khác giới",
LevelAndNameFormat = [[<T S="24" C="158,0,0"  P="0">Lv%d</T><BL>10</BL><T S="24" C="79,60,48" P="0">%s</T>]],
BeStrongBtnNameArrays = {"Mạnh hơn","Kiếm Vàng","Trang bị","Tăng cấp","Đá quý","Thú cưng","Muốn ăn thịt"},
BUY_FIVE_ATTENTION = [[<T C="255,236,193" S="18" P="0">Liên tục chiêu </T><T C="233,166,62" S="18" P="0">%d lần</T><T C="255,236,193" S="18" P="0"> Mèo Chiêu Tài</T>]],
BUY_FIVE_NEED_CONSUME = "Cần tốn ",
BUY_FIVE_CAN_GET = "Tối thiểu nhận ",
BUY_FIVE_AFFIRM = "Đồng ý",
PETREST = "Nghỉ",
PETATWAR = "Chiến",
PETNOREBIIRTH = "Pet chiến đấu không thể trùng sinh",
PETNOADVANCEGOODS = "Thuốc không đủ", 
PETNOENOUGHNUM = "Số Pet không đủ",
PETENOUGHNUM = "Ô gộp đã đầy, hãy dùng bớt",
PETNOADVANCELEVEL = "Pet chưa đạt cấp %s, hãy tăng cấp",
PETNOGOODS = "Nguyên liệu tiêu hao không đủ",
PETSKILL1 = "Ô kỹ năng 1",
PETSKILL2 = "Ô kỹ năng 2",
PETNOSKILL = "Kích hoạt kỹ năng mới có thể tẩy luyện",
PETSKILLSUC = "Tẩy luyện kỹ năng thành công",
PETENOUGHEXP = "EXP đã đủ để tăng cấp",
PETNOUPEXP = "Chưa thêm Pet",
PETUPTOLEVEL = "Cấp Pet không được hơn nhân vật",
PETMAXNUM = "Tối đa có 200 Pet",
PETNORAFFLEGOODS = "Mảnh Pet không đủ",
PETMAXEXP = "EXP: ",
PETFREE2 = "M.Phí",
PETRAFFLEDESC1 = "Có cơ hội nhận Pet Lam",
PETRAFFLEDESC2 = "Có cơ hội nhận Pet Tím",
PETRAFFLEDESC3 = "Chắc chắn nhận Pet Tím",
PETFULLADVANCELEVEL = "Đã đạt bậc cao nhất",
NO_GIFT = "Chưa có vật phẩm này, đồng ý mua?",
CONJUGAL_RELATION_TIP = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Vợ chồng mỗi ngày tặng quà cho nhau nhận điểm tình cảm, tăng cấp tình cảm</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Cấp tình cảm càng cao, kích hoạt càng nhiều kỹ năng vợ chồng</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Thuộc tính thêm của kỹ năng vợ chồng chỉ có hiệu lực khi vợ chồng cùng chiến trường, cùng phe </T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Ly hôn sẽ trừ 886 Kim Cương phí thủ tục của bên đề nghị</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> Sau khi ly hôn sẽ hủy kỹ năng vợ chồng, cấp tình cảm sẽ tính lại từ đầu</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="22" P="0"> Sau khi ly hôn, áo cưới của cả hai cũng sẽ biến mất</T><BR>20</BR>
]],
VIP_LEVEL_1 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Tích lũy nạp 50 Kim Cương tăng cấp VIP</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1. Nhận đặc quyền thêm ô đạo cụ</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2. Nhận đặc quyền Rèn-Cường Hóa 5 lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3. Số bạn tối đa</T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 110</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> người</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày nhận Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 22</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Vàng tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 6</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 9</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tháp Thí Luyện </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Phó bản nhóm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Vùng Mạo Hiểm-Tinh Anh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 11</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Pha Lê tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Giới hạn Xúc Xắc Đất Cấm tăng 1, mỗi ngày tối đa mua Xúc Xắc </T><T C="99,255,95" 
S="20" P="0" SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày tìm thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày giở mánh khóe thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 20</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Có thể mua Vé Lãnh Chúa Vực Sâu mỗi ngày</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 1</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">17.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">18.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 6</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
]],
VIP_LEVEL_2 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Tích lũy nạp 500 Kim Cương tăng cấp VIP này</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Hưởng đặc quyền VIP1</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mở càn quét 10 lần Vùng Mạo Hiểm</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Bạn tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 120</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  người</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày nhận Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 24</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Vàng tối đa  </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 15</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 13</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tháp Thí Luyện </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Phó bản nhóm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Vùng Mạo Hiểm-Tinh Anh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 12</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Pha Lê tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 15</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Giới hạn Xúc Xắc Đất Cấm tăng 2, mỗi ngày tối đa mua Xúc Xắc </T><T C="99,255,95" 
S="20" P="0" SC="79,60,48" SE="1" SS="4"> 6</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 13</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày tìm thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">17. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày giở mánh khóe thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 25</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">18. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Có thể mua Vé Lãnh Chúa Vực Sâu mỗi ngày</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">19.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">20.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 7</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
]],
VIP_LEVEL_3 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Nạp đủ 1000 Kim Cương tăng đến cấp VIP này</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Hưởng đặc quyền VIP2</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mở ghép nhanh, ghép dễ dàng hơn</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Bạn tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 130</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  người</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày nhận Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 26</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Vàng tối đa  </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 20</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 12</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 17</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tháp Thí Luyện </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Phó bản nhóm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Vùng Mạo Hiểm-Tinh Anh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 13</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Pha Lê tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 20</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Giới hạn Xúc Xắc Đất Cấm tăng 3, mỗi ngày tối đa mua Xúc Xắc </T><T C="99,255,95" 
S="20" P="0" SC="79,60,48" SE="1" SS="4"> 8</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 17</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày tìm thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày giở mánh khóe thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 30</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">17. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Có thể mua Vé Lãnh Chúa Vực Sâu mỗi ngày</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">18.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">19.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 7</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
]],
VIP_LEVEL_4 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Nạp đủ 2000 Kim Cương tăng đến cấp VIP này</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Hưởng đặc quyền VIP3</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mở dùng "Mèo Chiêu Tài" nhiều lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mở Cửa Hàng tặng đặc quyền</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Bạn tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 140</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  người</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày nhận Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 28</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Vàng tối đa  </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 25</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 14</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 21</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tháp Thí Luyện </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Phó bản nhóm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Vùng Mạo Hiểm-Tinh Anh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 14</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Pha Lê tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 25</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Giới hạn Xúc Xắc Đất Cấm tăng 4, mỗi ngày tối đa mua Xúc Xắc </T><T C="99,255,95" 
S="20" P="0" SC="79,60,48" SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 19</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày tìm thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 5</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">17. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày giở mánh khóe thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 35</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">18. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Có thể mua Vé Lãnh Chúa Vực Sâu mỗi ngày</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">19.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">20.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 8</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
]],
VIP_LEVEL_5 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Nạp đủ 5000 Kim Cương tăng đến cấp VIP này</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Hưởng đặc quyền VIP4</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mở thưởng thêm phó bản nhóm</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Bạn tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 150</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  người</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày nhận Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 30</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Vàng tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 30</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 16</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 23</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tháp Thí Luyện </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Phó bản nhóm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Vùng Mạo Hiểm-Tinh Anh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 15</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Pha Lê tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 30</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Giới hạn Xúc Xắc Đất Cấm tăng 5, mỗi ngày tối đa mua Xúc Xắc </T><T C="99,255,95" 
S="20" P="0" SC="79,60,48" SE="1" SS="4"> 12</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 21</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Bí Cảnh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 1</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày tìm thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 6</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">17. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày giở mánh khóe thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 40</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">18. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Có thể mua Vé Lãnh Chúa Vực Sâu mỗi ngày</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 5</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">19.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">20.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
]],
VIP_LEVEL_6 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Nạp đủ 10000 Kim Cương tăng đến cấp VIP này</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Hưởng đặc quyền VIP5</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Nhận thú cưỡi VIP</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Bạn tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 160</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  người</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày nhận Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Vàng tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 35</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 18</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 25</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tháp Thí Luyện </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Phó bản nhóm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Vùng Mạo Hiểm-Tinh Anh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 16</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Pha Lê tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 35</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Giới hạn Xúc Xắc Đất Cấm tăng 6, mỗi ngày tối đa mua Xúc Xắc </T><T C="99,255,95" 
S="20" P="0" SC="79,60,48" SE="1" SS="4"> 14</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 23</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Bí Cảnh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 1</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày tìm thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 7</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">17. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày giở mánh khóe thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 45</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">18. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Có thể mua Vé Lãnh Chúa Vực Sâu mỗi ngày</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 6</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">19.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">20.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 8</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
]],
VIP_LEVEL_7 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Nạp đủ 20000 Kim Cương tăng đến cấp VIP này</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Hưởng đặc quyền VIP6</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Bạn tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 170</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  người</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày nhận Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 34</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Vàng tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 40</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 20</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 27</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tháp Thí Luyện </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Phó bản nhóm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Vùng Mạo Hiểm-Tinh Anh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 5</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 17</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Pha Lê tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 40</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Giới hạn Xúc Xắc Đất Cấm tăng 7, mỗi ngày tối đa mua Xúc Xắc </T><T C="99,255,95" 
S="20" P="0" SC="79,60,48" SE="1" SS="4"> 16</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 25</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Bí Cảnh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 1</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày tìm thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 8</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày giở mánh khóe thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 48</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">17. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Có thể mua Vé Lãnh Chúa Vực Sâu mỗi ngày</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 7</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">18.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">19.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 9</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
]],
VIP_LEVEL_8 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Nạp đủ 50000 Kim Cương tăng đến cấp VIP này</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Hưởng đặc quyền VIP7</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Nhận Cánh VIP</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Bạn tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 180</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  người</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày nhận Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 36</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Vàng tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 45</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 22</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 29</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tháp Thí Luyện </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Phó bản nhóm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Vùng Mạo Hiểm-Tinh Anh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 5</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 18</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Pha Lê tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 45</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Giới hạn Xúc Xắc Đất Cấm tăng 8, mỗi ngày tối đa mua Xúc Xắc </T><T C="99,255,95" 
S="20" P="0" SC="79,60,48" SE="1" SS="4"> 18</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 27</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Bí Cảnh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 1</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày tìm thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 9</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">17. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày giở mánh khóe thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 51</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">18. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Có thể mua Vé Lãnh Chúa Vực Sâu mỗi ngày</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 8</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">19.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">20.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 9</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
]],
VIP_LEVEL_9 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Nạp đủ 80000 Kim Cương tăng đến cấp VIP này</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Hưởng đặc quyền VIP8</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Bạn tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 190</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  người</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày nhận Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 38</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Vàng tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 50</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 24</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 31</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tháp Thí Luyện </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Phó bản nhóm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 3</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Vùng Mạo Hiểm-Tinh Anh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 6</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 19</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Pha Lê tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 50</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Giới hạn Xúc Xắc Đất Cấm tăng 9, mỗi ngày tối đa mua Xúc Xắc </T><T C="99,255,95" 
S="20" P="0" SC="79,60,48" SE="1" SS="4"> 20</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 29</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Bí Cảnh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 1</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày tìm thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày giở mánh khóe thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 54</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">17. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Có thể mua Vé Lãnh Chúa Vực Sâu mỗi ngày</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 9</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">18.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">20.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 9</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
]],
VIP_LEVEL_10 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Nạp đủ 100000 Kim Cương tăng đến cấp VIP này</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Hưởng đặc quyền VIP9</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Bạn tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 200</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  người</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày nhận Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 40</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Vàng tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 55</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 26</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 33</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tháp Thí Luyện </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Phó bản nhóm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Vùng Mạo Hiểm-Tinh Anh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 7</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 20</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Pha Lê tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 55</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Giới hạn Xúc Xắc Đất Cấm tăng 10, mỗi ngày tối đa mua Xúc Xắc </T><T C="99,255,95" 
S="20" P="0" SC="79,60,48" SE="1" SS="4"> 22</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 31</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Bí Cảnh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày tìm thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 11</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày giở mánh khóe thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 57</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">17. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Có thể mua Vé Lãnh Chúa Vực Sâu mỗi ngày</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">18.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">19.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
]],
VIP_LEVEL_11 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Nạp đủ 150000 Kim Cương tăng đến cấp VIP này</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Hưởng đặc quyền VIP10</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Bạn tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 210</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  người</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày nhận Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 42</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Vàng tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 60</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 28</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 35</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tháp Thí Luyện </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Phó bản nhóm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Vùng Mạo Hiểm-Tinh Anh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 8</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 21</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Pha Lê tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 60</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Giới hạn Xúc Xắc Đất Cấm tăng 11, mỗi ngày tối đa mua Xúc Xắc </T><T C="99,255,95" 
S="20" P="0" SC="79,60,48" SE="1" SS="4"> 24</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 33</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Bí Cảnh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày tìm thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 12</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày giở mánh khóe thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 60</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">17. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Có thể mua Vé Lãnh Chúa Vực Sâu mỗi ngày</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 11</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">18.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">19.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
]],
VIP_LEVEL_12 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Nạp đủ 200000 Kim Cương tăng đến cấp VIP này</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Hưởng đặc quyền VIP11</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Bạn tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 220</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  người</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày nhận Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 44</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Vàng tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 65</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 30</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 37</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tháp Thí Luyện </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Phó bản nhóm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Vùng Mạo Hiểm-Tinh Anh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 9</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 22</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Pha Lê tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 65</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Giới hạn Xúc Xắc Đất Cấm tăng 12, mỗi ngày tối đa mua Xúc Xắc </T><T C="99,255,95" 
S="20" P="0" SC="79,60,48" SE="1" SS="4"> 26</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 35</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Bí Cảnh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày tìm thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 13</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày giở mánh khóe thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 63</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">17. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Có thể mua Vé Lãnh Chúa Vực Sâu mỗi ngày</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 12</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">18.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">19.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
]],
VIP_LEVEL_13 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Nạp đủ 300000 Kim Cương tăng đến cấp VIP này</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Hưởng đặc quyền VIP12</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Bạn tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 230</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  người</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày nhận Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 46</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Vàng tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 70</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 39</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tháp Thí Luyện </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Phó bản nhóm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Vùng Mạo Hiểm-Tinh Anh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 23</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Pha Lê tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 70</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Giới hạn Xúc Xắc Đất Cấm tăng 13, mỗi ngày tối đa mua Xúc Xắc </T><T C="99,255,95" 
S="20" P="0" SC="79,60,48" SE="1" SS="4"> 28</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 37</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Bí Cảnh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày tìm thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 14</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày giở mánh khóe thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 66</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">17. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Có thể mua Vé Lãnh Chúa Vực Sâu mỗi ngày</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 13</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">18.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">19.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
]],
VIP_LEVEL_14 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Nạp đủ 400000 Kim Cương tăng đến cấp VIP này</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Hưởng đặc quyền VIP13</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Bạn tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 240</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  người</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày nhận Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 48</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Vàng tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 75</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 34</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 41</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tháp Thí Luyện </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Phó bản nhóm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Vùng Mạo Hiểm-Tinh Anh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 11</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 24</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Pha Lê tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 75</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Giới hạn Xúc Xắc Đất Cấm tăng 14, mỗi ngày tối đa mua Xúc Xắc </T><T C="99,255,95" 
S="20" P="0" SC="79,60,48" SE="1" SS="4"> 30</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 39</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Bí Cảnh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày tìm thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 15</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày giở mánh khóe thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 68</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">17. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Có thể mua Vé Lãnh Chúa Vực Sâu mỗi ngày</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 14</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">18.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">19.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
]],
VIP_LEVEL_15 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Nạp đủ 500000 Kim Cương tăng đến cấp VIP này</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Hưởng đặc quyền VIP14</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Bạn tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 250</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  người</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày nhận Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 50</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Vàng tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 80</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Thể Lực tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 40</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">6. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Thi Đấu </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 41</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">7. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tháp Thí Luyện </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 4</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">8. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Phó bản nhóm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 5</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">9. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Vùng Mạo Hiểm-Tinh Anh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 12</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">10. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Pet </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 25</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">11. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày mua Pha Lê tối đa </T><T C="99,255,95" S="20" P="0" SC="79,60,48" 
SE="1" SS="4"> 80</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">12. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Giới hạn Xúc Xắc Đất Cấm tăng 16, mỗi ngày tối đa mua Xúc Xắc </T><T C="99,255,95" 
S="20" P="0" SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">13. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Tiệm Trang Bị </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 14</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">14. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày tối đa tạo mới Bí Cảnh </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 2</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">15. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày tìm thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 16</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">16. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Chú Hề Tìm Kho Báu mỗi ngày giở mánh khóe thêm </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 70</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">17. </T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Có thể mua Vé Lãnh Chúa Vực Sâu mỗi ngày</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 15</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">18.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày sẽ tạo mới đối thủ trong Tháp Anh Hùng</T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 32</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">19.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">Mỗi ngày được mua Ảo Cảnh Không Gian </T><T C="99,255,95" S="20" P="0" 
SC="79,60,48" SE="1" SS="4"> 10</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> lần</T><BR></BR>
]],
EQUIP_STRA_LEVEL_UP = "Tăng cấp tăng sao",
EQUIP_REACHED_MAX_STAR_LEVEL = "Đã tăng đến cấp sao tối đa",
SEND_GIFT_TIP = "Số lần tặng quà hôm nay đã hết",
ATT_ROUND = "Số lượt: ", 
MY_GEM = "Chọn đá",
BESTRONG_NAME = "Cẩm nang",
TASK_UINAME = "Nhiệm vụ",
SETTING_GAME_NAME = "Tên nhân vật: ",
SETTING_SERVE_NAME = "Máy chủ: ",
SETTING_SOUND = "Âm thanh:",
SETTING_SHIELD_PLAEYER = "Người gần: ",
SETTING_SHIELD_INVITE = "Mời bạn bè: ",
SETTING_SHIELD_INVITE2 = "Mời đội:",
SETTING_EXCHANGE_GIFT = "Đổi Quà",
SETTING_SHARE_GAME = "Chia sẻ game: ",
SETTING_ADVISE_MAIL = "Góp ý",
SETTING_EXIT = "Thông báo",
SETTING_SYSTEM = "Thiết lập hệ thống",
SETTING_GAME = "Thiết lập tính năng",
SETTING_MUSIC = "Nhạc: ",
SEND_WEDDING_CARD_TIP = "Gửi thiệp mời thành công",
APPLY = "Xin phép",
ATH_REWARD_SEND = [[<T C="79,60,48" S="18" P="0">Đạt cấp thi đấu tương ứng sẽ nhận thưởng (Một lần)</T>]],
ATH_SHOP_CHANGE = [[<T C="127,70,26" S="22" P="0">Thời gian tự tạo mới: </T><T C="158,0,0" S="22" P="0">%s</T>]],
VIP_DESC2 = [[<T C="255,236,193" S="20" P="0">Nạp thêm </T><T C="99,255,95" S="22" P="0">%d</T><I Z="0.7">ui/common/common_icon_zuanshi.png</I><T C="255,236,193" S="20" P="0"> sẽ thành </T><T C="99,255,95" S="22" P="0">VIP%d</T>]],
STRENGTHENTIP = "Cả set %s +%d",
STRENGTHENTIP1 = "Thuộc tính set khóa",
BAGTIP1 = "Tên này rất lười, chả để lại gì cả!",
SELECT_GIFT_TYPE = "Hãy chọn quà muốn tặng",
PUPIL_REWARD = "Thưởng đệ tử",
DAILY_COPY_GOLD_DESC1 = "Gây sát thương",
DAILY_COPY_GOLD_DESC2 = "Vàng Lớn",
DAILY_COPY_GOLD_DESC3 = "Vàng Nhỏ",
DAILY_COPY_GOLD_DESC4 = "Diệt Quái Rương",
DAILY_COPY_CLICK_CONTINUE = "Nhấn màn hình tiếp tục",
NAME_TOO_SHOOT = "Tên quá ngắn, hãy nhập lại!",
NAME_HAVED_EXIST = "Trùng tên, hãy nhập lại!",
NAME_CANT_BE_NUMBER = "Tên không được dùng số!",
SHAKE_TIMES_FINISH = "Đã hết lượt chiêu tài",
BUY_ACTIVITY_TIMES_FINISH = "Đã hết số lần mua Thể Lực!",
WEDDING_HALL_PASS = "Mật khẩu lễ đường: ",
SETTING_WEDDING_HALL_PASS = "Thiết lập mật khẩu lễ đường thành công", 
YOU_CANT_CHANGE_NAME = "Không phải chủ Công Hội, không thể sửa tên Công Hội!",
WEDDING_NO_GUEST = "Hiện chưa có khách",
PRIEST_SAY = {"Cô dâu chú rể có thể tặng Lì Xì Vàng!",
"Đoạt Lì Xì nhận Vàng thử vận may!",
"Mỗi Lì Xì có thể nhận số Vàng ngẫu nhiên!",
"Cô dâu chú rể có thể phát Kẹo Hỉ tặng Thể Lực!",
"Đoạt Kẹo Hỉ nhận ngay Thể Lực!",
"Đốt Pháo có thể nhận EXP!",
"Tặng chúc phúc cho cô dâu chú rể sẽ tăng tình cảm cho họ!",
"Tặng chúc phúc cũng được nhận EXP!"},
GET_OUT_WEDDING_HALL = "Bị chủ nhân hôn lễ trục xuất",
SINGCOPY_FAIL = "Thắng thua là chuyện bình thường thôi, biết không?",
LOSE_TIPS = "Thử lại đi! Biết đâu thành công?",
ENERGY_NOT_SHORTAGE = "Thể Lực không đủ, cần thêm không?",
WIPEOUTNUM = "Vé Càn Quét không đủ, mua thêm không?",
TOWER_DAILY_RANKING = "Hạng mỗi ngày",
TEAM_COPY_COUNTDOWN = "Khiêu chiến còn",
TEAM_COPY_COUNTDOWN2 = "Đếm ngược",
REMOVE = "Giải trừ",
COMPETIVITY_LEVEL = "Cấp thi đấu",
COMPETIVITY_DATA  = "Dữ liệu thi đấu",
COMPETIVITY_INTEGRAL = "Điểm thi đấu",
COMPETIVITY_RESULT = "Thắng %d trận\n(Tỷ lệ thắng: %d%%)",
ACHIE_NUMBER = "Số thành tựu",
TEACHER_LEVEL = "Cấp Sư Đức",
TEACHER_PUPIL_NUMBER = "Số đệ tử tốt nghiệp",
TEACHER_VALUE = "Sư Đức",
WORLD_BOSS_DESC1 = "Khiêu chiến BOSS Thế Giới, nhận thưởng lớn!", 
JUST_NOW = "Vừa mới",
MINITE_AGO = "%d phút trước",
HOURS_AGO = "%d giờ trước",
DAYS_AGO = "%d ngày trước",
LONG_AGO = "Trước đó khá lâu",
XX_WORSHIP_XX = "Đã thích",
HAVED_WORSHIP_TODAY = "Hôm nay đã thích",
WORSHIP_SUCCESS = "Thích thành công, nhận %d điểm Thể Lực",
CANT_WORSHIP_SELF = "Không thể tự yêu bản thân!",
OPENCHEST = "Mở rương",
OPENCHEST1 = "Hãy chọn số lượng (1 lần tối đa 100)",
DAILY_LOSE_DESC1 = [[<T C="255,223,116" S="26" P="0">Sát thương thấp nhất:  </T><T C="255,236,193" S="26" P="0">%s</T>]],
DAILY_LOSE_DESC2 = [[<T C="255,223,116" S="26" P="0">Quái bỏ trốn:  </T><T C="255,236,193" S="26" P="0">%s</T>]],
DAILY_LOSE_DESC3 = "Thưởng Vàng: ",
DAILY_LOSE_DESC4 = [[<T C="255,223,116" S="16" P="0">Sát thương thấp nhất:  </T><T C="255,236,193" S="16" P="0">%s</T>]],
WORSHIP_WORD = "Thích",
CHECK_HUSBAND = "Xem chồng",
CHECK_WIFE = "Xem vợ",
UPGRADE_TIPS0 = "Giờ hãy tìm hiểu tính năng mới nào!~",
UPGRADE_TIPS1 = "Mạnh hơn rồi, nhớ kết thêm bạn đấy",
UPGRADE_TIPS2 = "Trên con đường rèn luyện luôn cô độc, nhưng phong cảnh luôn là đẹp nhất",
UPGRADE_TIPS3 = "Đúng là dũng sĩ ta chọn, thật dũng mãnh",
UPGRADE_TIPS4 = "Tiếp tục cố gắng, ngươi đã có thực lực rất mạnh",
TEACH_1 = "Vào ải phó bản",
TEACH_2 = "Chọn ải 1",
TEACH_3 = "Bắt đầu khiêu chiến nào",
TEACH_4 = "Ngón tay nhấn giữ nhân vật, kéo ngược hướng mục tiêu tấn công, ngắm kỹ tấn công",
TEACH_5 = "Chọn kỹ năng tấn công",
TEACH_6 = "Luyện tập thao tác tấn công lần nữa",
TEACH_7 = "Mở thanh hướng dẫn",
TEACH_8 = "Xem nhiệm vụ",
TEACH_9 = "Nhiệm vụ đã hoàn thành, hãy nhận thưởng",
TEACH_10 = "Đã có nhiệm vụ mới, nhấn vào",
TEACH_11 = "Nhấn vào ải",
TEACH_12 = "Bắt đầu khiêu chiến nào",
TEACH_13 = "Dùng đạo cụ bay",
TEACH_14 = "Vuốt màn hình, kéo ngược hướng muốn bay",
TEACH_15 = "Nhấn giữ màn hình để di chuyển, di chuyển theo hướng chỉ định",
TEACH_16 = "Tấn công địch",
TEACH_17 = "Mở thanh hướng dẫn",
TEACH_18 = "Xem tính năng kỹ năng",
TEACH_19 = "Chọn đạo cụ nộ khí",
TEACH_20 = "Hoàn thành",
TEACH_21 = "Mở nhiệm vụ",
TEACH_22 = "Nhấn nhận thưởng nhiệm vụ",
TEACH_23 = "Hãy tới nhiệm vụ mới",
TEACH_24 = "Vào phó bản Tinh Anh",
TEACH_25 = "Bắt đầu khiêu chiến nào",
TEACH_26 = "Dùng đạo cụ nộ khí sẽ thi triển POW nhanh hơn",
TEACH_27 = "Nhấn dùng POW, có thể gây sát thương lớn",
TEACH_28 = "Hãy tiêu diệt hắn",
TEACH_29 = "Nhấn mở rương",
TEACH_30 = "Đóng giao diện nhiệm vụ",
TEACH_31 = "Nhấn thanh hướng dẫn",
TEACH_32 = "Nhấp nhân vật",
TEACH_33 = "Nhấn trang bị",
TEACH_34 = "Nhấn mặc",
TEACH_35 = "Quay về",
TEACH_36 = "Mở thanh hướng dẫn",
TEACH_37 = "Nhấn rèn",
TEACH_38 = "Chọn vũ khí",
TEACH_39 = "Đây là nguyên liệu cần tốn khi cường hóa trang bị",
TEACH_40 = "Nhấn cường hóa",
TEACH_41 = "Nhấn quay về",
TEACH_42 = "Mở thanh hướng dẫn",
TEACH_43 = "Nhấn rèn",
TEACH_44 = "Chọn trang Tăng Sao",
TEACH_45 = "Chọn vũ khí",
TEACH_46 = "Nhấn tăng sao",
TEACH_47 = "Mở thanh hướng dẫn",
TEACH_48 = "Nhấn rèn",
TEACH_49 = "Chọn trang Khảm",
TEACH_50 = "Chọn vũ khí",
TEACH_51 = "Khảm đá tấn công",
TEACH_52 = "Chọn đá tấn công",
TEACH_53 = "Khảm",
TEACH_54 = "Mở thanh hướng dẫn",
TEACH_55 = "Nhấn Pet",
TEACH_56 = "Nhấn nhận Pet",
TEACH_57 = "Nhấn đập trứng miễn phí",
TEACH_58 = "Nhấn đập trứng Kim Cương",
TEACH_59 = "Bắt đầu",
TEACH_60 = "Khiêu chiến",
TEACH_61 = "Khiêu chiến",
TEACH_62 = "Khiêu chiến",
TEACH_63 = "Bắt đầu",
TEACH_64 = "Nhấn BXH",
TEACH_65 = "Nhấn nút hướng dẫn",
TEACH_66 = "Nhấn nút thú cưỡi",
TEACH_67 = "Mở thanh hướng dẫn",
TEACH_68 = "Nhấn nút nhiệm vụ",
TEACH_69 = "Nhấn trang phụ tuyến",
TEACH_70 = "Vào Đấu Trường",
TEACH_71 = "Nhấn nút tạo phòng",
TEACH_72 = "Nhấn nút xác nhận",
TEACH_73 = "Nhấn nút chơi ngay",
TEACH_74 = "Nhấn nút thú cưỡi",
TEACH_75 = "Nhấn hình năng động",
TEACH_76 = "Nhấn kiến trúc Công Hội",
TEACH_77 = "Nhấn kiến trúc kết hôn",
TEACH_78 = "Nhấn kiến trúc Cửa Hàng",
TEACH_79 = "Mở thanh hướng dẫn",
TEACH_80 = "Nhấn túi",
TEACH_81 = "Nhấn thời trang",
TEACH_82 = "Nhấn mặc",
TEACH_83 = "Khiêu chiến",
TEACH_84 = "Nhấn quay về",
TEACH_85 = "Nhấn xuất chiến",
TEACH_86 = "Mau đến bắt đầu Mạo Hiểm mới nào!",
TEACH_87 = "Rất nhiều nhiệm vụ đang đợi bạn!",
TEACH_88 = "Dùng đạo cụ nộ khí sẽ tăng nộ khí!",
TEACH_89 = "Nhớ dùng Túi Sinh Lực để tăng sinh lực!",
TEACH_90 = "Đồng ý dùng",
TEACH_91 = "Gió sẽ ảnh hướng tới quỹ đạo ném, phải kiểm soát tốt lực ném",
TEACH_92 = "Gió cấp 3 khá mạnh, hãy tính toán kỹ lực tấn công",
TEACH_93 = "Gió cấp 3 khá mạnh, hãy tính toán kỹ lực tấn công",
TEACH_94 = "Gió cấp 4 rất mạnh, hãy tính toán kỹ lực tấn công",
TEACH_95 = "Gió cấp 4 rất mạnh, hãy tính toán kỹ lực tấn công",
TEACH_96 = "Gió cấp 5 siêu mạnh, hãy tính toán kỹ lực tấn công",
TEACH_97 = "Gió cấp 5 siêu mạnh, hãy tính toán kỹ lực tấn công",
TEACH_98 = "Gió cấp 6 gió lốc, hãy tính toán kỹ lực tấn công",
TEACH_99 = "Gió cấp 6 gió lốc, hãy tính toán kỹ lực tấn công",
TEACH_100 = "Vào",
TEACH_101 = "Chọn dạng Tinh Anh",
TEACH_102 = "Chọn ải 1",
TEACH_103 = "Nhấn mặc",
SUIT = "Set",
NOT_IN_RANKLIST = "Chưa vào BXH",
MAIL_FULLBAG = "Túi đã đầy, một số thưởng chưa nhận",
DAILY_Fail_MONSTER = "Quái bỏ trốn",
HALL_NO_SEAT = "Phòng không đủ chỗ",
NOTENOUTH1 = "Quà không đủ",
NOTENOUTH2 = "Rương không đủ",
NOTENOUTH3 = "Chìa khóa không đủ",
OPENGIFT = "Mở quà",
CURRENT_LEVEL2 = [[<T C="79,60,48" S="22" P="0">Hiện ở tầng </T><T C="99,255,95" S="22" P="0">%s</T><T C="79,60,48" S="22" P="0"></T>]],
START_LEVEL = "Bắt đầu",
ATHLETICS_LIST = "BXH Thi Đấu",
RANK_NO_DATA_ATT = "BXH này chưa ai lọt vào",
MUL_RESET_COPY = "Đồng ý tốn %d Kim Cương tạo mới %s phó bản (Hôm nay còn được tái lập %d lần)",
PET_MSG1 = "Tăng thêm %d cấp mở",
WORLD_BOSS_TITLE = "BOSS Thế Giới",
OPENGIFTLEVEL = "Chưa đạt cấp, không thể dùng",
ATTRTIP1 = "Lượng sinh lực của nhân vật",
ATTRTIP2 = "Ảnh hưởng sát thương nhân vật gây ra",
ATTRTIP3 = "Kháng và giảm sát thương cho nhân vật",
ATTRTIP4 = "Tỉ lệ bạo kích và sát thương bạo kích",
ATTRTIP5 = "Giảm tỉ lệ bị bạo kích và sát thương bạo kích",
ATTRTIP6 = "Tăng sát thương, giảm sát thương nhận vào",
ATTRTIP7 = "Tăng tấn công nhân vật",
ATTRTIP8 = "Tăng phòng thủ nhân vật",
ATTRTIP9 = "Ảnh hưởng thứ tự ra tay trong chiến đấu",
ATTRTIP10 = "Ảnh hưởng thứ tự ra tay khi bắt đầu trận",
ATTRTIP11 = "Giảm phòng thủ của đối thủ",
ATTRTIP12 = "Giảm sát thương nhận vào",
ATTRTIP13 = "Khả năng phá địa hình của vũ khí",
IMPROVE_TOP = "Cấp sao đã đạt tối đa! Giỏi quá!",
BELONG_PLAYER = "Người sở hữu",
RANKLIST_TITLE = "Xếp hạng",
RANKLIST_LAOGONG = "Chồng",
RANKLIST_LAOPO = "Vợ",
STRENGTENTIP2 = "(Thêm Đá Thánh sẽ đảm bảo thất bại không giảm cấp)",
MASTEROPENTIPS = "%d ngày sau mở",
HURT_ALL_VALUE = "Tổng ST: ",
GET_RANK_REWARD = "Nhận thưởng hạng",
GET_KILL_REWARD = "Nhận thưởng tiêu diệt",
LOGIN_YOUKE = "Chơi ngay",
LOGIN_REGIST = "Đăng ký",
LOGIN_SAVE_ACCOUNT = "Nhớ tài khoản",
FIGHTADD = "Lực chiến tăng: ",
LOGIN_PASSWORD_SURE = "Xác nhận mật khẩu: ",
LOGIN_MAIL = "Email: ",
LOGIN_REGIST_SUCCESS = "Đăng ký thành công",
LOGIN_ERROR = "Tài khoản hoặc mật khẩu sai",
LOGIN_REGISTED = "Tài khoản đã được đăng ký",
LOGIN_REGIST_FAIL = "Tài khoản đăng ký thất bại",
UP_TO_LOAD_MORE = "Vuốt lên tải thêm",
RELAX_TO_LOAD = "Thả ra tải",
POWER_NOT_ENOUGH = "Thể Lực không đủ, cần thêm không?",
WORSHIP_INFO = "Thông tin thích",
ACTIVITY_TARGET_TYPE_1 = {"Cấp thi đấu đạt %s","bậc"},
ACTIVITY_TARGET_ARRAYS = {"Đồng","Bạc","Vàng","Bạch Kim","Bậc Thầy"},
VOICE_CHAT = "Ấn   nói",
STOP_SWEEPING2 = "Dừng càn quét?",
SWEEP_RESULT_TIPS2 = "Càn quét tầng %s chưa kết thúc, chưa nhận được thưởng: ",
SEND_RECORDING = "Thả   gửi",
RECODRING_ERROR = "Ghi âm thất bại, thời gian ngắn nhất 1 giây",
LOOSEN_YOUR_FINGER_CANCEL = "Thả tay ra, hủy gửi",
WORLD_BOSS_KILL = "Đã diệt thành công %s",
WORLD_BOSS_KILLED = "%s đã diệt %s",
WORLD_BOSS_NOTKILL = "Bạn không diệt BOSS, không thể nhận thưởng!",
WORLD_BOSS_NOKILL = "Yếu quá, không ai diệt được BOSS. %s thất vọng bỏ đi!",
TOWER_DESC = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> 00:00 mỗi ngày hệ thống tạo mới, sau khi tạo mới sẽ quay về tầng 1, hồi phục số lần khiêu chiến. (Người chơi đang càn quét sẽ dừng càn quét, trở về tầng 1)</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> 00:00 mỗi ngày phát thưởng theo hạng Tháp Thí Luyện.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Tháp Thí Luyện có 3 lần khiêu chiến, khiêu chiến thất bại trừ 1 lần, khi còn 0 lần sẽ kết thúc khiêu chiến.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Tháp Thí Luyện cần đạt mục tiêu của tầng hiện tại, nếu không sẽ khiêu chiến thất bại.</T><BR>20</BR>
]],
MULTI_SWEEP_TIP = "VIP%d mở tính năng này, nạp?",
COMMUNITY_HISTORY_FIGHT = [[<T C="62,34,8" S="22" P="0">Chiến tích: </T><T C="128,54,13" S="22" P="0">%d trận %d thắng (%s)</T>]],
COMMUNITY_HISTORY_FIRST = [[<T C="62,34,8" S="22" P="0">Hạng 1: </T><T C="128,54,13" S="22" P="0">%d lần</T>]],
COMMUNITY_HISTORY_SECOND = [[<T C="62,34,8" S="22" P="0">Hạng 2:</T><T C="128,54,13" S="22" P="0">%d lần</T>]],
COMMUNITY_HISTORY_THIRD = [[<T C="62,34,8" S="22" P="0">Hạng 3: </T><T C="128,54,13" S="22" P="0">%d lần</T>]],
COMMUNITY_CUR_DATA = [[<T C="62,34,8" S="22" P="0">Chiến tích tuần: </T><T C="128,54,13" S="22" P="0">%d trận %d thắng (%s)</T>]],
COMMUNITY_CUR_SCORE = [[<T C="62,34,8" S="22" P="0">Điểm hiện tại: </T><T C="128,54,13" S="22" P="0">%d</T>]],
COMMUNITY_CUR_RANK = [[<T C="62,34,8" S="22" P="0">Hạng hiện tại: </T><T C="128,54,13" S="22" P="0">%d</T>]],
COMMUNITY_CUR_RESULT = [[<T C="110,89,67" S="20" P="0">(Công Hội Chiến sẽ tổng kết sau %d%s)</T>]],
COMMUNITY_MY_FIGHT = "Chiến tích Công Hội",
WORLD_BOSS_DESC = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Trong thời gian chỉ định, người chơi có thể chặn đánh BOSS xâm nhập.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Người chơi có thể cổ vũ tăng thêm sát thương</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Hiệu quả tăng chỉ hiệu lực trong chiến đấu với BOSS tương ứng trong ngày</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Cổ vũ Vàng có tỉ lệ thành công, cổ vũ Kim Cương chắc chắn thành công</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> Sát thương tăng tối đa 100%</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="22" P="0"> Sau khi sát thương đạt tối đa không thể tiếp tục cổ vũ</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">7.</T><T C="127,70,26" S="22" P="0"> Mỗi lần bắt đầu chiến đấu, khiêu chiến sẽ vào trạng thái chờ</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">8.</T><T C="127,70,26" S="22" P="0"> Chiến đấu kết thúc vẫn ở trạng thái chờ khiêu chiến, hết thời gian chờ mới có thể khiêu chiến tiếp, có thể dùng Kim Cương xóa chờ</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">9.</T><T C="127,70,26" S="22" P="0"> Thưởng BOSS Thế Giới gồm thưởng hạng tiêu diệt và thưởng hạng sát thương. Khi thời gian hoạt động trong ngày kết thúc sẽ gửi toàn bộ thưởng qua thư</T><BR>20</BR>
]],
WORLD_BOSS_END_TITLE = "Hoạt động kết thúc",
WORLD_BOSS_WIN_DESC = [[<T C="255,236,193" S="22" P="0"></T><T C="99,255,95" S="22" P="0"> %s </T><T C="255,236,193" S="22" P="0"> đã diệt BOSS %s !</T>]],
WORLD_BOSS_FAIL_DESC = [[<T C="255,236,193" S="22" P="0">BOSS %s đã rời khỏi, hãy đợi BOSS trở lại!</T>]],
WORLD_BOSS_TITLE_DEAC = "Ngày mai %s hãy diệt quái %s tiếp!",
WORLD_BOSS_OPEN_TIME = [[<T C="255,236,193" S="22" P="0"></T><T C="255,89,74" S="22" P="0">%s-%s</T><T C="255,236,193" S="22" P="0"> mỗi ngày mở</T>]],
WORLD_BOSS_NOT_OPEN = [[<T C="255,236,193" S="22" P="0">Chưa mở</T>]],
WORLD_BOSS_OPEN_TIME_DOWN = "Mở còn: ",
WORLD_BOSS_TIME_DOWN1 = [[<T C="255,236,193" S="20" P="1"  SC="79,60,48" SS="2" SE="1">Đang chờ </T><T C="255,89,74" S="20" P="1"  SC="79,60,48" SS="2" SE="1">%s</T>]],
WORLD_BOSS_INSPIRE =  [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="22" P="1" SC="128,54,13" SS="4" SE="1">%d Cổ vũ</T>]],
WORLD_BOSS_TIME_DOWN2 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">Đang chờ </T><T C="255,89,74" S="20" P="1"  SC="79,60,48" SS="4" SE="1">%s</T>]],
WORLD_BOSS_SUB_TIME = "%d xóa",
WORLD_INSPIRE_ADD = [[<T C="255,227,116" S="20" P="1" SC="79,60,48" SS="4" SE="1">Sát thương tăng: </T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]],
WORLD_INSPIRE_GOLD_LAST = "Cổ vũ Vàng đang chờ...",
WORLD_INSPIRE_INSPIRE_NO = "BOSS Thế Giới chưa mở, cổ vũ vô hiệu!",
WORLD_INSPIRE_ADD_SUCCESS = "Cổ vũ thành công",
WORLD_INSPIRE_ADD_Fail = "Cổ vũ thất bại",
WORLD_BOSS_DEAD = "BOSS Thế Giới đã tử vong!",
WORLD_BOSS_DEAD1 = "BOSS Thế Giới đã trốn thoát!",
SHOP_LIMIT = "[Còn %d]",
COMMUNITY_BATTLE = "Công Hội: ",
COMMUNITY_FIGHT_END = "Công Hội Chiến đã kết thúc!",
DOWN_LOADING_PRO = "Tiến độ: %dKB/%dKB  (%s)",
APPLY1 = "Đã xin phép",
SEND_RECORD_CHAT_ERROR  = "Gửi voice thất bại",
NPC_NAME_1 = "Mirya",
NPC_NAME_2 = "Giáo Sư",
ACCOUNT_NOT_EXIST = "Tài khoản không tồn tại",
PASSWORD_ERROR = "Mật khẩu sai",
NOTCHOOSEEQUIP = "Chưa chọn trang bị",
LOGIN_ALL_SERVER = "Tất cả máy chủ",
LOGIN_TIPS_ACCOUNT = "6-16 ký tự, có thể dùng thư, chữ cái, số, gạch dưới",
LOGIN_TIPS_PASSWORD = "6-12 ký tự, phân biệt hoa thường",
LOGIN_TIPS_PASSWORD1 = "Hãy nhập lại mật khẩu",
EVERYDAY = "Mỗi ngày",
DANADNDAO_WELCOME = "Xin chào! Hãy cùng nhau vui chơi thỏa thích!",
RECHARGE_SUCCESS1 = "Nạp thành công",
RECHARGE_SUCCESS2 = [[<T C="62,34,8" S="22" P="0">Hiện tại </T><I Z="0.6">ui/common/commom_icon_v.png</I><A IMG = "ui/common_num/common_num_vip.png" Z ="0.6" W = "22" H = "40" CHAR = "0">%d</A><T C="62,34,8" S="22" P="0">, nhận %d</T><I Z="0.7">ui/common/common_icon_zuanshi.png</I>]],
RECHARGE_SUCCESS3 = [[<T C="62,34,8" S="22" P="0">Nạp tiếp </T><T C="158,0,0" S="22" P="0">%d</T><I Z="0.7">ui/common/common_icon_zuanshi.png</I><T C="62,34,8" S="22" P="0">, sẽ trở thành </T><I Z="0.6">ui/common/commom_icon_v.png</I><A IMG = "ui/common_num/common_num_vip.png" Z ="0.6" W = "22" H = "40" CHAR = "0">%d</A>]],
ANNOUNCE  = "Thông báo",
CAN_GET = "Có thể nhận",
WILL_BECOME = "Sẽ trở thành ",
FUNDINFO1 = [[<T C="255,255,255" S="20" P="0">Nạp thẻ nhận </T><T C="255,89,74" S="20" P="0">%s</T><T C="255,255,255" S="20" P="0"> có thể mua!</T>]],
FUNDINFO2 = [[<T C="255,255,255" S="20" P="0">Nạp </T><T C="255,89,74" S="20" P="0">%s</T><T C="255,255,255" S="20" P="0">, tích lũy nhận hoàn trả </T><T C="255,89,74" S="20" P="0">%s</T><T C="255,255,255" S="20" P="0">!</T>]],
FUNDINFO3 = [[<T C="255,255,255" S="20" P="0">Đã mua quỹ trưởng thành, đã nhận </T><T C="255,89,74" S="20" P="0">%s</T><T C="255,255,255" S="20" P="0">!</T>]],
FUNDINFO4 = "Cấp VIP không đủ, không thể mua quỹ, tăng cấp VIP?",
FUNDINFO5 = "Nhận hoàn trả thành công",
FUNDINFO6 = "Quỹ trưởng thành",
LIMETED_LOGIN_REWARD = "Thưởng đăng nhập %s-%s",
FORBIT_RECORD_VOICE = "Đã cấm quyền ghi âm!",
FIRST_RECHARGE_ACTIVITY = "Thưởng nạp lần đầu",
MONTHCARDINFO1 = "Chưa vào Công Hội, không thể dùng đạo cụ này",
MONTHCARDINFO2 = "Hãy chọn mục tiêu dùng",
ACTIVITY_TOTAL_RECHARGE = "Tích lũy nạp",
TOO_FULL = "No quá",
EACH_DAY_TO_GET = "Ăn thịt nướng mỗi ngày, tăng nhiều Thể Lực!",
WORD_E = "Ồ!!",
TASTE_NEXT_TIME = "Hãy chờ bữa sau!",
LIMITE_TIME_GIFT = "Quà ưu đãi hạn giờ: ",
CAN_BUY_GIFT = "Quà có thể mua",
BATTLE_PASS = "Điều kiện vượt: ",
BATTLE_SINGLE_PASS= "Vượt phó bản",
BD_ACCOUNT_OK = "Khóa tài khoản thành công",
WOLRD_BOSS_INSPIRE_FULL = "Sát thương cổ vũ đã tăng tối đa",
WOLRD_BOSS_DEAD_NOT_INSPIRE = "BOSS đã bị diệt, không thể cổ vũ",
CONSUME = "Tốn: ",
RECHARGE_TODAY = "Hôm nay nạp ",
GET_BIG_GIFT = ", sẽ nhận quà lớn!",
CAN_GET_ONCE = "Trong hoạt động chỉ được nhận 1 lần",
RECHARGE_BETWEEN = "Nạp ",
ANY_MONEY = " mức bất kỳ ",
CAN_RECEIVE = "nhận: ",
RANK_DAY_DATA = [[<T C="255,228,108" S="24" P="0">Chiến tích: </T><T C="255,89,74" S="24" P="0">%d</T><T C="255,237,192" S="24" P="0"> trận </T><T C="255,89,74" S="24" P="0">thắng %d</T><T C="255,237,192" S="24" P="0">    </T><T C="255,228,108" S="24" P="0">Liên thắng: </T><T C="255,89,74" S="24" P="0">%d</T>]],
RANK_BOX_DESC1 = "Tham chiến %d lần",
RANK_BOX_DESC2 = "Chiến thắng %d lần",
ITEM_NOT_ENOUGH = "Tim không đủ, không thể mua đạo cụ này?",
VIP_NOT_GET = "Chưa nhận được",
NO_ANNOUNCE_MES = "Không có thông báo",
RECHARGE_DESC =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> EXP trưởng thành VIP là số Kim Cương thực tế nạp</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> Số Kim Cương trở thành EXP trưởng thành VIP không bao gồm số Kim Cương khuyến mãi, nhận từ hệ thống hoặc Kim Cương tặng</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> Thẻ Tháng, Thẻ Tháng Công Hội gồm số Kim Cương nhận 1 lần và số Kim Cương nhận liên tục</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> Thẻ Tháng mua ngay là 250 Kim Cương, tức sau khi mua nhận ngay 250 Kim Cương</T><BR></BR>
<T C="158,0,0" S="22" P="0">5.</T><T C="62,34,8" S="22" P="0"> Thẻ Tháng Công Hội mua ngay là 250 Kim Cương, tức sau khi mua nhận ngay 250 Kim Cương</T><BR></BR>
<T C="158,0,0" S="22" P="0">6.</T><T C="62,34,8" S="22" P="0"> Số Kim Cương nhận liên tục của Thẻ Tháng, Thẻ Tháng Công Hội sẽ nhận từ thưởng nhiệm vụ ngày. Sau khi mua có thể liên tục đăng nhập 30 ngày, mỗi ngày nhận 100 Kim Cương</T><BR></BR>
<T C="158,0,0" S="22" P="0">7.</T><T C="62,34,8" S="22" P="0"> Thẻ Tháng khác Thẻ Tháng Công Hội ở chỗ Thẻ Tháng chỉ dùng cho bản thân, Thẻ Tháng Công Hội có thể tặng cho các hội viên khác, tức là tặng Kim Cương thưởng đăng nhập 30 ngày</T><BR></BR>
<T C="158,0,0" S="22" P="0">8.</T><T C="62,34,8" S="22" P="0">Mua vật phẩm trong trang quà không tăng EXP VIP</T><BR>30</BR>
]],
SKILL_COOL_TIME = "Kỹ năng đang chờ",
RANK_FIGHT_WIN = [[<T C="158,0,0" S="22" P="0">%d</T><T C="62,34,8" S="22" P="0"> trận </T><T C="158,0,0" S="22" P="0">thắng %d</T><T C="62,34,8" S="22" P="0"></T>]],
RANK_WIN_STREAK = "(%d liên thắng)",
SELECT_VIP_GIFT_ATT = "Hưởng đặc quyền VIP sẽ có thưởng phong phú! Nạp ngay?",
SETTING_TALK = "Chat voice: ",
RANK_SEGMENT = "Hạng bậc",
RANK_WEEK_REWARD = "Thưởng bậc tuần",
RANK_SEGMENT_REWARD = "Thưởng bậc",
RANK_REWARD_SEGMENT = "Thưởng tăng bậc",
RANK_WEEK_RANK = "BXH Đấu Hạng",
RANK_REWARD_WEEK = "Thưởng hạng tuần",
RANK_REWARD_GET = [[<T C="127,70,26" S="22" P="0"></T><T C="255,89,72" S="22" P="0"></T><T C="127,70,26" S="22" P="0">Kết thúc mùa giải, sẽ thưởng theo hạng hiện tại</T>]],
RANK_LOG = "Nhật ký chiến tích",
RANK_LOG_FAIL = "%s trước, bạn bị đánh bại bởi ",
RANK_LOG_WIN = "%s trước, bạn đánh bại người chơi ",
RANK_LOG_LV_UP = "Tăng cấp hạng, hiện tại là  ",
RANK_LOG_LV_Down = "Giảm cấp hạng, hiện tại là ",
RANK_LOG_DESC1 = [[<T C="255,236,193" S="22" P="0">Đánh bại %s</T><T C="254,167,48" S="22" P="0">, điểm bậc </T><T C="0,255,78" S="22" P="0"> %s</T>]],
RANK_KING_DESC1 = [[<T C="99,255,95" S="22" P="0">%s</T><T C="255,237,192" S="22" P="0">Giành hạng 1 trong Đấu Hạng!</T>]],
RANK_KING_DESC2 = "Chiến tích mùa giải: ",
RANK_KING_DESC3 = "Thắng: ",
RANK_KING_DESC4 = "Liên thắng hiện tại: ",
RANK_KING_WORSHIP_CNT = [[<T C="255,228,108" S="22" P="0">Được thích </T><T C="0,255,78" S="22" P="0"> %d </T><T C="255,228,108" S="22" P="0"> lần</T>]],
RANK_KING_GOLD_CNT = [[<T C="255,228,108" S="22" P="0">Có thể nhận </T><I Z="0.6">ui/common/common_icon_jinbi.png</I><T C="0,255,78" S="22" P="0"> %d</T>]],
ACCOUNT_BD_DESC = "Chưa khóa tài khoản, nếu đổi thiết bị sẽ mất hết dữ liệu",
ACCOUNT_BD = "Khóa tài khoản",
ACCOUNT_BD1 = "Khóa",
PET_HIGH_QULITY = "Pet tốt không thể chọn nhanh",
TOTAL_COUNT = "Tích lũy",
RANK_KING_WORSHIP = [[<T C="255,236,193" S="22" P="0">%s </T><T C="254,167,48" S="22" P="0">%s trước đã thích</T>]],
RANK_OPEN_DESC1 = [[<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">(%s đến %s)</T><T C="255,89,74" S="22" P="0" SC="79,60,48" SE="1" SS="4"> %s-%s</T><T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Mở</T>]],
RANK_END_DESC1 = "Chiến tích hôm nay",
RANK_END_DESC2 = "Số lần liên thắng",
RANK_END_DESC3 = "Điểm nhận",
RANK_END_DESC4 = "Điểm nhận: ",
WEEK_FIGHT_RESULT = "Chiến tích mùa giải:",
PVP_RANK_DESC =
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Điểm Dũng Sĩ khi tích lũy đến mức quy định sẽ tự dùng để nâng cấp 1 bậc</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Điểm nhận từ tăng thành tựu, tăng MVP, tăng liên thắng trong Đấu Hạng</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Khi rớt cấp bậc sẽ ưu tiên trừ Điểm Dũng Sĩ trước (Điểm không đủ sẽ trực tiếp rớt bậc)</T><BR>20</BR>
<T C="229,105,22" S="22">Hướng dẫn</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Mùa giải sẽ bắt đầu vào ngày đầu mỗi tháng, kết thúc vào ngày cuối mỗi tháng</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Khi Mùa Giải mới mở, cấp bậc sẽ giảm xuống nhất định</T><BR>20</BR>
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Kết thúc mùa giải, người hạng 1 sẽ nhận thưởng đặc biệt và thiết lập tượng thành chủ</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Mỗi mùa giải đạt cấp bậc chỉ định sẽ nhận thưởng (Tạo mới mỗi mùa giải)</T><BR>10</BR>
]],
WORD_FIGHTING = "Đấu",
WORD_WIN = "Thắng",
CURRENT_WIN_STREAK = "Liên thắng: ",
NICKNAME = "Tên: ",
COMEFROM = "Giới tính: ",
SHARE_SUCCESS = "Chia sẻ thành công",
DRESSSTATE = "Trạng thái trang bị",
LEVELSTATE1 = "Sơ",
LEVELSTATE2 = "Thường",
LEVELSTATE3 = "Cao",
LEVELSTATE4 = "Hiếm",
ANDROID_RECORD_ERROR = "Microphone bị cấm dùng, hãy thiết lập quyền sử dụng",
IOS_RECORD_ERROR = "[Thiết lập-Riêng-Microphone], cho phép dùng microphone",
NO_GET_WORDS = "Chưa nhận",
TIPSWORD1 = "Hành động: ",
TIPSWORD2 = "Chờ khởi tạo: ",
TIPSWORD3 = "Hiệu quả: ",
TIPSWORD4 = "VIP%d mở đạo cụ này",
TIPSWORD5 = "Lv%d mở đạo cụ này",
TIPSWORD6 = "Mở khóa",
DIVORCE_WEDDING_NOT_ENOUGH = "Xin ly hôn cần tốn %d Kim Cương, Kim Cương không đủ! Tăng thêm?",
ONEKEY_GIFTBACK = "Tặng lại",
ACCOUNT_NOT_MAIL = "Tài khoản hiện chưa khóa với hộp thư!",
FRIENDS_FULL_ATT = "Bạn bè đã đạt tối đa, tăng cấp VIP để tăng thêm?",
RECEIVE_TIMES_OUT = "Lượt nhận hôm nay đã hết, tăng cấp VIP để tăng thêm?",
ONEKEYSTRENGTEN = "Cường hóa nhanh",
PASSWORD_FORGET = "Quên mật khẩu",
PASSWORD_CHANGE = "Sửa mật khẩu: ",
PASSWORD_NEW = "Mật khẩu mới: ",
CHALLENGE_ELITE_ERROR = "Vượt ải thường hiện tại sẽ mở",
SETTING_BIND_MAIL = "Khóa hộp thư: ",
SETTING_BIND_MAIL1 = "Khóa hộp thư",
PASSWORD_FORGET_ACCOUNT = "Thông tin: ",
PASSWORD_MAIL_ERROR = "Hộp thư không đúng", 
SETTING_BINDED_MAIL = "Tài khoản đã khóa với hộp thư!",
SETTING_INPUT_PASS = "Mật khẩu: ",
SETTING_INPUT_MAIL = "Hộp thư: ",
SETTING_MAIL_DESC = "Hãy nhập hộp thư dùng khi cần tìm lại mật khẩu",
SETTING_MAIL_BIND_SUCCESS = "Khóa hộp thư thành công",
SETTING_MAIL_BIND_FAIL = "Mật khẩu sai, khóa hộp thư thất bại",
SINGLE_RESERT_TIP = "Dùng %s Kim Cương để tạo mới? (Đã tạo mới %s/%s lần)",
SINGLE_RESERT_TIP2 = "VIP%s được tạo mới nhiều lần hơn, nạp?",
TODAY_RESERT_NOT_ENOUGH = "Số lần tạo mới hôm nay đã dùng hết",
HOMEOWNER_TIP = "Bạn đã trở thành chủ phòng",
STRENGTHEN1 = "Tăng sao trang bị phải tốn Đá Tăng Sao, không thể tháo",
STRENGTHEN2 = "Cường hóa tối đa không thể quá cấp nhân vật",
STRENGTHEN3 = "Tăng cấp nhân vật mới được tiếp tục cường hóa",
STRENGTHEN4 = "Đã đạt cấp tối đa, không cần cường hóa nữa",
STRENGTHEN5 = "Cường hóa đã đạt giới hạn cấp nhân vật",
MAIL_INFO = "Thông tin hộp thư: ",
MAIL_ACCOUNT = "Hãy nhập hộp thư khóa chung với tài khoản",
SETTING_BIND_MAIL_AGAIN = "Hộp thư khóa lại: ",
UPGRADE_LEVEL_UNREACHED = "Lv%d mở",
MOUNT_LIST = "Danh sách thú cưỡi",
MOUNT_CAN_LOCK = "Có thể nhận",
MOUNT_CANNOT_LOCK = "Chưa nhận",
PASS_COMMON_SECTION_TIP = "Vượt ải dạng thường chương này sẽ mở",
MOUNTS_SUCCESS1 = "Tỉ lệ thành công: ",
MOUNTS_LV_LIMIT = "Cấp thú cưỡi đã đạt giới hạn cấp nhân vật",
MOUNTS_LV_LIMIT = "Tăng cấp nhân vật mới được tiếp tục tăng cấp thú cưỡi",
MOUNTS_LV_MAX = "Tăng cấp thú cưỡi đã đạt tối đa! Giỏi lắm!",
MOUNTS_STAR_MAX = "Tiến giới đạt tối đa",
MOUNT_LEVEL1 = "Cấp: ",
MOUNT_Star1 = "Tiến giới:",
MOUNT_PILL_CNT = "(Có %d)",
MOUNT_BUY_DESC1 = "Dùng %s %d nhận thú cưỡi này",
GET_ACHIE_POINTS = "Thành tựu: ",
LEFT_ACHIE_POINTS = "Thành tựu còn: ",
TOTAL_PROGRESS = "Tổng tiến độ: ",
BADGE_FULL_LEVEL = "Huy Hiệu đạt cấp tối đa.",
BADGE_UPGRADE_FAILED = "Điểm thành tựu không đủ, hãy hoàn thành thêm thành tựu.",
RANK_DAY_DATA = "Chiến tích: ",
RANK_WIN_AGAIN = "Liên thắng: ",
RANK_SCORE_RANK = "Hạng: ",
PETADVANCESHOW = "Xem trước",
PETSHOW = "Xem trước",
PETSKILL3 = "Kỹ năng thiên phú",
PETSKILLDESC1 = "Tiến hóa Pet +1 mở",
PETSKILLDESC2 = "Tiến hóa Pet +3 mở",
PETSKILLDESC3 = "Kỹ năng thiên phú nhận ngẫu nhiên",
PETSHOWNAME1 = [[<T C="5,180,0" S="22" P="0">+2 </T><T C="79,60,48" S="22" P="0">(Đang lớn)</T>]],
PETSHOWNAME2 = [[<T C="5,180,0" S="22" P="0">+4 </T><T C="79,60,48" S="22" P="0">(Trưởng thành)</T>]],
PETSHOWNAME3 = [[<T C="5,180,0" S="22" P="0">+6 </T><T C="79,60,48" S="22" P="0">(Hoàn chỉnh)</T>]],
RECORD_NET_ERROR = "Voice đang bận, hãy thử lại sau~",
PETNOREBIRTH = "Pet từng tăng cấp hoặc tiến hóa mới được trùng sinh.",
PETNOSKILL1 = "Tiến hóa Pet được mở khóa kỹ năng",
PETNOSKILL2 = "Hiện tại chưa mở khóa kỹ năng nào",
PETCONFIRMREBIRTH = "Trùng sinh Pet sẽ mất cấp và hiệu quả tiến hóa, tiếp tục?",
PETSHOWTIP1 = 
--<T C="255,236,193" S="22" P="0">Kích hoạt kỹ năng Pet</T>
--<T C="99,255,96" S="22" P="0">1</T>
[[
<T C="255,227,116" S="22" P="0">Tiến hóa </T>
<T C="99,255,95" S="22" P="0">+1</T>
<T C="255,227,116" S="22" P="0">:</T>
<T C="255,236,193" S="22" P="0"> Mở khóa </T>
<T C="99,255,95" S="22" P="0">kỹ năng 1</T>
<T C="255,236,193" S="22" P="0">, tăng </T>
<T C="99,255,95" S="22" P="0">7%</T>
<T C="255,236,193" S="22" P="0"> tất cả thuộc tính</T>
]],
PETSHOWTIP2 = 
[[
<T C="255,227,116" S="22" P="0">Tiến hóa </T>
<T C="99,255,95" S="22" P="0">+2</T>
<T C="255,227,116" S="22" P="0">:</T>
<T C="255,236,193" S="22" P="0"> Ngoại hình thay đổi</T>
<T C="255,236,193" S="22" P="0">, tăng</T>
<T C="99,255,95" S="22" P="0">13%</T>
<T C="255,236,193" S="22" P="0"> tất cả thuộc tính</T>
]],
--<T C="255,236,193" S="22" P="0">Kích hoạt kỹ năng </T>
--<T C="99,255,96" S="22" P="0">2</T>
PETSHOWTIP3 = 
[[
<T C="255,227,116" S="22" P="0">Tiến hóa </T>
<T C="99,255,95" S="22" P="0">+3</T>
<T C="255,227,116" S="22" P="0">:</T>
<T C="255,236,193" S="22" P="0"> Mở khóa </T>
<T C="99,255,95" S="22" P="0">kỹ năng 2</T>
<T C="255,236,193" S="22" P="0">, tăng</T>
<T C="99,255,95" S="22" P="0">25%</T>
<T C="255,236,193" S="22" P="0"> tất cả thuộc tính</T>
]],
PETSHOWTIP4 = 
[[
<T C="255,227,116" S="22" P="0">Tiến hóa </T>
<T C="99,255,95" S="22" P="0">+4</T>
<T C="255,227,116" S="22" P="0">:</T>
<T C="255,236,193" S="22" P="0"> Ngoại hình thay đổi</T>
<T C="255,236,193" S="22" P="0">, tăng</T>
<T C="99,255,95" S="22" P="0">50%</T>
<T C="255,236,193" S="22" P="0"> tất cả thuộc tính</T>
]],
PETSHOWTIP5 = 
[[
<T C="255,227,116" S="22" P="0">Tiến hóa </T>
<T C="99,255,95" S="22" P="0">+5</T>
<T C="255,227,116" S="22" P="0">:</T>
<T C="255,236,193" S="22" P="0"> Mở khóa </T>
<T C="99,255,95" S="22" P="0">kỹ năng 3</T>
<T C="255,236,193" S="22" P="0">, tăng</T>
<T C="99,255,95" S="22" P="0">75%</T>
<T C="255,236,193" S="22" P="0"> tất cả thuộc tính</T>
]],
PETSHOWTIP6 = 
[[
<T C="255,227,116" S="22" P="0">Tiến hóa </T>
<T C="99,255,95" S="22" P="0">+6</T>
<T C="255,227,116" S="22" P="0">:</T>
<T C="255,236,193" S="22" P="0"> Mở khóa </T>
<T C="99,255,95" S="22" P="0">kỹ năng 4</T>
<T C="255,236,193" S="22" P="0">, tăng</T>
<T C="99,255,95" S="22" P="0">100%</T>
<T C="255,236,193" S="22" P="0"> tất cả thuộc tính</T>
]],
RANK_NO_WIN = "(Bắn tỉa liên thắng)",
ISEXPPET = "Pet EXP không thể thao tác",
GET_WORSHIP_GOLD = "Nhận Vàng thành công",
PVPRANK_LIST_DESC1 = "BXH sẽ tạo mới theo giờ",
PVPRANK_LIST_DESC2 = "Thi đấu kết thúc sẽ thưởng theo hạng",
PVPRANK_LIST_DESC3 = "Thưởng tăng bậc (Gửi qua thư, chỉ được nhận 1 lần)",
PVPRANK_LIST_DESC4 = "Dữ liệu BXH mùa trước",
NO_CHANGE = "Không đổi",
CAN_GET_DESIGNATION = "Nhận danh hiệu",
HAVED_SEND = "Đã gửi",
WHERE_GET_COPY = "Vượt Vùng Mạo Hiểm có thể nhận nhiều Tinh Hồn Thám Hiểm, vượt phó bản nhóm có thể nhận Tinh Hồn Vinh Dự",
STAR_SOUL_HAVED_ACTIVE = "Đã mở",
STAR_SOUL_NOT_ACTIVE = "Khóa",
STAR_PROPERTY_ADD = "Tăng Tinh Hồn",
TOTAL_FIGHTING_ADD = "Tổng Tinh Hồn tăng",
STARSOUL_ACTIVITY_SUCCESS = "Kích hoạt thành công",
STARSOUL_LOCKED_TIPS = "Kích hoạt tất cả Tinh Hồn của hệ sao trước đó mới có thể xem hệ kế.",
CHECKOTHER1 = "Thú Cưỡi",
CHECKOTHER2 = "Tinh Hồn",
CHECKOTHER3 = "Thẻ Bài",
CHECKOTHER4 = "Ký Tên",
CHECKOTHER5 = "Tăng Tinh Hồn",
CHECKOTHER6 = "Huân Chương",
CHECKOTHER7 = "Trang Bị",
CHECKOTHER8 = "Thời Trang",
KNOW = "Đã xem",
REMOVE_STONE = "Tháo",
TIPS1 = "Nguyên liệu Đá Thánh không đủ, tiếp tục tăng sao sẽ giảm cấp.",
WOLRD_BOSS_LEFT_NOT_INSPIRE = "BOSS đã chạy trốn, không thể cổ vũ",
NOT_ATTENTION_THISTIME = "Không nhắc lại",
TIPS2 = "Điểm may mắn đạt tối đa sẽ tăng sao thành công, điểm may mắn mỗi ngày đều xóa hết.",
SETTING_SERVERS_STATE_FULL1 = "Đủ người",
SETTING_SERVERS_LIST = "Danh sách máy chủ",
CLICK_OPEN = "Nhấp mở",
SEARCH_STAR_SOUL = "Tinh Hồn Thám Hiểm",
HONOUR_STAR_SOUL = "Tinh Hồn Vinh Dự",
NEED_STAR = "Cần",
TEACH_104 = "Nhấn giữ màn hình để di chuyển, di chuyển theo hướng chỉ định",
TEACH_105 = "Hiện năng lượng Nộ Khí",
TEACH_106 = "Nhấn màn hình tiếp tục",
TEACH_107 = "Nhấn giữ vào nhân vật, kéo về hướng ngược lại với mục tiêu, sau đó nhắm bắn (Lên xuống chỉnh góc ngắm)",
TEACH_108 = "Đạn Liên Tục: 1 lần bắn 2 viên đạn, liên tục tấn công địch",
TEACH_109 = "Đạn Lan Tỏa: Phân tán bắn 2 viên đạn vào kẻ địch, tấn công phạm vi",
TEACH_110 = "Đạn Uy Lực: Tấn công cực mạnh, gây sát thương lớn lên kẻ địch",
TEACH_111 = "Đạn Truy Đuổi: Truy đuổi và tấn công địch trong phạm vi nhất định (Trước Lv7 tự động có hiệu quả này)",
TEACH_112 = "POWER: Gây sát thương nặng lên kẻ địch (Vũ khí khác nhau, có POW và kỹ năng khác nhau)",
TEACH_113 = "Nhấn tay vào nhân vật và kéo theo hướng ngược hướng bay sẽ khiến nhân vật bay đến đó",
TEACH_114 = "Trượt ra ngoài để thu nhỏ, kéo vào trong để phóng to",
TEACH_115 = "Thanh hành động đầy sẽ đến lượt tấn công",
TEACH_116 = "Hiện thời gian lượt còn lại và ký hiệu hướng gió",
TEACH_117 = "Nút thiết lập nhạc trong game và hủy lượt hiện tại.",
TEACH_118 = "Chat sẽ hiện ở khu vực này",
TEACH_119 = "Khu thao tác đạo cụ chiến đấu và kỹ năng",
TEACH_120 = "Vào Cửa Hàng",
TEACH_121 = "Chọn thời trang",
TEACH_122 = "Mặc thử",
TEACH_123 = "Mua",
TEACH_124 = "Đồng ý mua",
TEACH_125 = "Mở thanh hướng dẫn",
TEACH_126 = "Mở túi",
TEACH_127 = "Nhấn thời trang",
TEACH_128 = "Chọn mặc",
TEACH_129 = "Nhấn quay về",
TEACH_130 = "Mở nhiệm vụ",
TEACH_131 = "Cấp 1-7 là thời gian bảo vệ người mới, tấn công sẽ kèm hiệu quả Truy Đuổi.",
TEACH_132 = "Mở thanh hướng dẫn",
TEACH_133 = "Nhấn rèn",
TEACH_134 = "Chọn tẩy luyện",
TEACH_135 = "Chọn vũ khí",
TEACH_136 = "Tẩy luyện",
TEACH_137 = "Chọn kế thừa",
TEACH_138 = "Chọn vũ khí",
TEACH_139 = "Chọn vũ khí cần kế thừa",
TEACH_140 = "Chọn vũ khí được kế thừa",
TEACH_141 = "Chọn vũ khí",
TEACH_142 = "Nhấp đồng ý",
TEACH_143 = "Nhấn nút kế thừa",
TEACH_144 = "Dùng Đạn Liên Tục tấn công liên tục",
TEACH_145 = "Dùng Đạn Lan Tỏa tấn công phân tán",
TEACH_146 = "Dùng Đạn Uy Lực tấn công kết liễu",
TEACH_147 = "Tại biên màn hình có thể phóng to khu vực thao tác",
TEACH_148 = "Từ biên Dấu Chân bắt đầu kéo dây sẽ có phạm vi thao tác rộng hơn",
TEACH_149 = "Rương May Mắn",
TEACH_150 = "Gọi thử",
TEACH_151 = "Đổi trang bị mới",
TEACH_152 = "Gọi cấp cao hơn",
TEACH_153 = "Mở thanh hướng dẫn",
TEACH_154 = "Tiếp tục làm nhiệm vụ",
TEACH_155 = "Nhận thưởng nhiệm vụ trước",
TEACH_156 = "Trải nghiệm uy lực trang bị mới",
TEACH_157 = "Mở giao diện Cầu Phúc",
TEACH_158 = "Hãy cầu phúc!",
TEACH_159 = "Nhặt Cầu Phúc này",
TEACH_160 = "Đến Túi để đeo Cầu Phúc",
TEACH_161 = "Chọn Cầu Phúc nhận được",
TEACH_162 = "Hãy trang bị vào",
TEACH_163 = "Xem thêm",
TEACH_164 = "Mở giao diện Tu Luyện",
TEACH_165 = "Tu luyện 1 lần nào",
TEACH_166 = "Vào hệ thống Thẻ Bài",
TEACH_167 = "Mở Bộ Thẻ",
TEACH_168 = "Chọn Bộ Thẻ",
TEACH_169 = "Nhấp để mở",
WORLD_BOSS_NO_OPEN = "Chưa đến giờ để khiêu chiến BOSS TG.",
STAR_PROPERTY_ADD = "Tăng",
VIPTIP1 = "Nạp VIP",
VIPTIP2 = "Đặc quyền",
LUCKVALUE = "Điểm may mắn",
HAVE = "Đã có",
RANK_KING_DESC5 = "Chiến tích: ",
RANK_KING_DESC6 = "Thuộc tính tăng: ",
TIPS3 = [[<T C="138,122,106" S="20" P="0">Chưa tham gia Thi Đấu</T>]],
TIPS4 = [[<T C="138,122,106" S="20" P="0">Chưa tham gia Đấu Hạng</T>]],
RANK_KING_DESC7 = "Chức: ",
TIPS5 = [[<T C="138,122,106" S="20" P="0">Chưa vào Công Hội</T>]],
TIPS6 = "Vật Tổ Công Hội ", 
RANK_KING_DESC8 = "Bạn đời: ",
RANK_KING_DESC9 = "Tên sư phụ: ",
RANK_KING_DESC10 = "Tên đệ tử: ",
RANK_KING_DESC11 = [[Sư đức Lv%d]],
RANK_KING_DESC12 = [[BUFF sư đồ]],
TIPS7 = [[<T C="138,122,106" S="20" P="0">Độc thân</T>]], 
TIPS8 = [[<T C="138,122,106" S="20" P="0">Chưa bái sư</T>]], 
TIPS9 = [[<T C="138,122,106" S="20" P="0">Chưa nhận đệ tử</T>]],
SERVER_FULL_PERSON = "Máy chủ đủ người",
MOREDRESS = "Cửa Hàng",
BATCHBUY = "Gia hạn nhanh",
TOUCH_TO_INPUT = "Nhập ID người chơi",
WEDDING_HOLD_TIME = "Chọn thời gian muốn tổ chức hôn lễ",
WEDDING_HOLE_TIPS = "Nếu thời gian chọn đã bắt đầu hoặc kết thúc sẽ cử hành vào ngày mai cùng giờ",
EDIT_MAIL = "Viết thư",
ACTIVITY_REWARD_ATT = "Đăng nhập vào các ngày chỉ định sẽ nhận thưởng",
GOTO_RECHARGE = "Nạp",
FIGHTING_TO = "Lực chiến đạt",
CLICK_CLOSE = "Đóng",
SPACE1 = "Trang cá nhân",
NOT_RECORD_VOICE = "Vuốt ngón tay hủy gửi",
EQUIPMENG_SKILL_LIST = "Đạo cụ",
SOPHISTIC = "Tẩy luyện",
SOPHISTIC_LOCK_ATT = "(Khóa kỹ năng khi tẩy luyện để không bị tẩy luyện)",
SOPHISTIC_PUT_WEAPON = "Hãy thiết lập vũ khí cần tẩy luyện trước",
SOPHISTIC_STONE_NOT_ENOUGH = "Đá Tẩy Luyện không đủ, đồng ý mua?",
SOPHISTIC_LOCK_ASK = "Bạn có kỹ năng cao cấp chưa khóa, tiếp tục tẩy luyện không?",
SOPHISTIC_COST = [[<T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >Tốn: </T><I Z = "0.45">%s</I><T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >%d</T><T C="158,139,121" S="20" P="1" SC="79,60,48" SE="0" SS="4" >(Có %d)  </T><I Z = "0.45">%s</I><T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >%d</T><T C="158,139,121" S="20" P="1" SC="79,60,48" SE="0" SS="4" >(Có %d)</T>]],
SETTING_TITLE = "Thiết lập",
ACTIVATION = "Kích hoạt",
SPACE2 = "Lịch sử chọc",
SPACE3 = "Lịch sử nhận hoa",
GET_ACCESS = "Cách nhận",
EXP_PETDESC = "Có thể tăng EXP cho Pet đã tăng cấp (Không thể xuất chiến, tăng cấp, tiến hóa)",
WORD_LOCK = "Khóa",
SHOP_NAME_AND_LEVEL1 = [[<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4" >Lv%d </T><T C="255,255,255" S="22" P="0" SC="79,60,48" SE="1" SS="4">%s</T>]],
PROPOSE_TIPS2 = "Chúng ta mãi bên nhau nhé?",
SKILL_UPGRADE_FULL = "Đã đạt cấp cao nhất",
SOPHISTIC_LOCK_NOT_ENOUGH = "Khóa kỹ năng không đủ, mua đạo cụ không?",
SPACE4 = " phần",
ACTIVE_SKILL_TIPS = "Không đủ vật phẩm kích hoạt kỹ năng đạo cụ ",
SPACE5 = "Gần đây",
SPACE6 = "Tổng lượng khách",
SPACE7 = "Khách hôm nay",
SPACE8 = "Người",
SPACE9 = "Nổi Tiếng",
SPACE10 = "Quà đã tặng",
SPACE11 = "Số lần nhận hoa",
SPACE12 = "Hấp Dẫn",
SERVER_PLAYER_FULL = "Số người đăng nhập máy chủ đã đạt tối đa",
VERSION_LOW = "Có nội dung cập nhật mới, hãy đăng nhập lại để cập nhật!",
NETWORK_CONNECTION_FAILURE = "Đã offline, hãy đăng nhập lại!",
SPACE13 = "Nhận quà",
SPACE14 = "Chọc",
SPACE15 = [[Tặng bạn %d Hoa Hồng]],
SPACE16 = [[Chọc thành công, nhưng không nhận được quà o~|>_<|~o]],
SPACE17 = [[Hôm nay đã chọc đối phương]],
SPACE18 = [[Đã tặng %d Hoa Hồng cho đối phương, Thể Lực +%d]],
SPACE19 = [[Số lần tặng hoa hôm nay quá nhiều!]],
SPACE20 = "Để lại lời nhắn",
SPACE21 = "Hãy nhập tin nhắn",
SPACE22 = "Xem hình",
SPACE23 = "Máy ảnh",
SPACE24 = "Upload",
SPACE25 = [[Tặng Hoa Hồng]],
SPACE26 = [[Hoa Hồng]],
SPACE27 = [[Nổi Tiếng của đối phương]],
SPACE28 = [[Bản thân]],
SPACE29 = [[Nhận Quà Zone.~]],
SPACE30 = [[Năm]],
SPACE31 = [[Tháng]],
SPACE32 = [[Ngày]],
SETTING_CHANGE_SERVER_CONFIRM = "Đổi máy chủ không?",
MOUNTS_LEVEL_GET5 = "Thi Đấu đạt Lv%s nhận",
MOUNTS_LEVEL_GET6 = "Tình cảm đạt Lv%d nhận",
MOUNTS_LEVEL_GET7 = "Công Hội đạt Lv%d nhận",
MOUNTS_LEVEL_GET8 = "Xếp hạng đạt Lv%d nhận",
COMMUNITYINFO70 = "Tăng cấp Vật Tổ",
COMMUNITYINFO71 = "Tăng cấp",
COMMUNITYINFO72 = "Tăng cấp Tiệm Công Hội",
SHOP_BUY_SUCCESS = "Mua thành công",
SHOP_BUY_FAIL = "Mua thất bại",
SPACE33 = [[Đã tặng hoa rồi]],
TIME_NOT_UP = "Chưa đến giờ",
MOUNT_SPEED = "Tốc độ: ",
MOUNT_LUCKY = "May mắn: ",
HURDLES_NOT_OPEN = "Chưa vượt ải này",
ATH_GOAL_RESET_TIME = [[<T C="79,60,48" S="22" P="0">Mỗi ngày </T><T C="158,0,0" S="22" P="0">24:00</T><T C="79,60,48" S="22" P="0"> tạo mới</T>]],
ATH_GOAL = "Mục tiêu Đấu Điểm mỗi ngày",
COMMUNITYINFO73 = [[(Tiệm Lv%d có thể mua)]],
COMMUNITYINFO74 = [[Nhật ký]],
COMMUNITYINFO75 = [[Quản lý]],
COMMUNITYINFO76 = [[Góp]],
COMMUNITYINFO77 = [[Nhật ký góp]],
COMMUNITYINFO78 = [[Nhật ký thao tác]],
COMMUNITYINFO79 = [[Góp]],
COMMUNITYINFO80 = [[Cấp Vật Tổ: ]],
COMMUNITYINFO81 = [[Tăng Vật Tổ]],
COMMUNITYINFO82 = [[Lễ bái tốn]],
COMMUNITYINFO83 = [[Lễ bái Vật Tổ]],
COMMUNITYINFO84 = [[Cấp Trường: ]],
COMMUNITYINFO85 = [[Học kỹ năng]],
COMMUNITYINFO86 = [[Tên Công Hội]],
COMMUNITYINFO87 = [[Chiến tích]],
COMMUNITYINFO88 = [[Hạng chiến tích]],
COMMUNITYINFO89 = [[Chiến tích Công Hội]],
COMMUNITYINFO90 = [[Chiến tích cá nhân]],
COMMUNITYINFO91 = [[Thưởng Công Hội]],
COMMUNITYINFO92 = [[Thưởng cá nhân]],
COMMUNITYINFO93 = [[Cấp Tiệm: ]],
COMMUNITYINFO94 = [[Miễn phí tạo mới: ]],
COMMUNITYINFO95 = [[Tự tạo mới: ]],
DOWN_TO_LOAD_MORE = "Kéo xuống tải thêm",
SPACE34 = [[Nam]],
SPACE35 = [[Nữ]],
SPACE36 = [[Bảo mật]],
PETUP = "Tăng cấp Pet",
CAN_EQUIPPED_PROPS = "Đạo cụ có thể trang bị",
STAR_NOT_ENOUGH1 = "Sao Thám Hiểm không đủ, đến Vùng Mạo Hiểm nhận sao?",
STAR_NOT_ENOUGH2 = "Sao Vinh Dự không đủ, đến Phó bản nhóm nhận sao?",
ATH_CNT_NOT_ENOUGH = "Số lần không đủ",
ATH_REWARD_SEND1 = [[<T C="127,70,26" S="20" P="0">Mỗi CN lúc </T><T C="158,0,0" S="20" P="0">24:00</T><T C="127,70,26" S="20" P="0"> căn cứ điểm hiện tại phát thưởng</T>]],
ATH_DESC_1 = "Hạng Đấu Điểm-Tuần",
ATH_DESC_2 = "Thưởng Hạng Đấu Điểm",
ATH_DESC_3 = "Nhật ký",
ATH_DESC_4 = "Nhật ký Hạng Đấu Điểm",
ATH_DESC_5 = [[<T C="127,70,26" S="20" P="0">Dữ liệu hạng Đấu Điếm tuần trước, tạo mới lúc </T><T C="158,0,0" S="20" P="0">24:00</T><T C="127,70,26" S="20" P="0"> CN hằng tuần</T>]],
SUGGESTCLICK = "Thiết lập",
ATH_DESC_6 = "Không",
ATH_DESC_7 = "Đấu %d thắng %d\n(Thắng: %d%%)",
ATH_DESC_8 = [[<T C="127,70,26" S="20" P="0">Mỗi CN lúc </T><T C="158,0,0" S="20" P="0">24:00</T><T C="127,70,26" S="20" P="0"> tạo mới</T>]],
ATH_DESC_9 = "Hạng",
ATH_DESC_10 = "Thưởng",
BAG2 = "Tăng thuộc tính",
SEND_MAIL_SUCCESS = "Gửi thư thành công",
DEL_MAIL_SUCCESS = "Xóa thư thành công",
SELECT_MARRYGIFT_ITEM = "Hãy chọn đạo cụ cầu hôn",
ILLEGAL_CHARACTER = "Có ký tự không hợp lệ",
INTRODUCTION1 = "Giới thiệu",
MAIL_ALL = "Chọn hết",
EAT_SOME_SWEETS = "Thể Lực không đủ, hãy thêm Bánh Donut?",
USED_TODAY_ACTIVITY = "Thể Lực không đủ, hãy tăng cấp VIP hoặc mua Bánh Donut bổ sung thể lực",
USE_THINGS = "Dùng vật phẩm",
ROOM1 = "Phòng",
INFO = "Thông tin",
REWARD_DESC = "Xem thưởng: ",
BEWORSHIP_TIMES = [[<T C = "255,236,193" S = "20">Được thích</T><T C = "99,255,95" S = "20">%d</T><T C = "255,236,193" S = "20"> lần</T>]],
MOUNT_GET_COST1 = [[<T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">%d</T><I P="1" Z="0.45">%s</I><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">Có thể nhận</T>]],
MOUNT_GET_COST2 = [[<I P="1" Z="0.45">%s</I><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">x%d có thể nhận</T>]],
GOLD1 = "Vàng",
CARD_COUNT = "%s không đủ, có tăng cấp VIP để nhận không?",
LOGIN_TIPS_ACCOUNT1 = "6-16 ký tự",
LOGIN_TIPS_ACCOUNT2 = "Dùng email, ký tự, chữ số, gạch dưới",
HALL_GET_RAEARD = "Đấu thêm %d trận có thể nhận thưởng",
HALL_GET_RAEARD1 = "Thắng thêm %d trận có thể nhận thưởng",
PASSWORD_CHANGE1 = "Sửa mật khẩu",
SETTING_ADVISE_MAIL1 = "Góp ý",
HALL_MATCH_1 = "Đấu Điểm",
HALL_MATCH_2 = "Đấu Tập",
HALL_WAIT = "Đợi",
HALL_01 = "Có mục tiêu Thi Đấu chưa xong",
WNDPLAYERINFO5 = "Túi",
SPACE37 = [[Đang nhận]],
MATCHES_TIMEOUT = "Hiện tại số người quá ít",
MATCHES_TIMEOUT2 = "Hiện tại số người quá ít",
CANCEL_READY_ERROR = "Sắp chơi ngay, không thể hủy",
COMMUNITYINFO96 = "Sửa chức thành công",
COMMUNITYINFO97 = "Trục xuất thành công",
COMMUNITYINFO98 = "Sửa tuyên ngôn Công Hội thành công",
COMMUNITYINFO99 = "Gửi thư Công Hội thành công",
COMMUNITYINFO100 = "Thiết lập Công Hội thành công",
COMMUNITYINFO101 = "Góp cho Công Hội thành công",
COMMUNITYINFO102 = "Bái thành công",
Entries = " cái",
Expand = " Tờ",
REWARD_HAVED_GET = "Đã nhận thưởng!",
SELLGET = "Bán nhận:",
SIXIN = "Thư riêng",
SENDMAIL = "Gửi thư",
PET_MAJOR = "Giới thiệu Pet",
BATTLE_LEFT_HP = "% sinh lực còn: ",
BATTLE_ATT_TIME = " lượt: ",
SHOP_DRESS_FULL = "Đã có Set mặc thử này",
FIRST_SOPHISTIC_ATT = "Sau khi tẩy luyện, kỹ năng trước sẽ bị thay thế bằng kỹ năng mới, tiếp tục?",
FIRST_LOCK_ATT = "(Nhấp kỹ năng để khóa sẽ không bị thay thế)",
SPACE38 = [[Tặng Hoa]],
SPACE39 = [[Xem nhân vật]],
SPACE40 = [[Xác nhận xóa tin nhắn này]],
SPACE41 = [[Xóa tin nhắn thành công]],
SPACE42 = [[Tối đa thiết lập 100 quà, không thể thêm nữa~]],
SPACE43 = [[Bạn cần thiết lập thêm bảo nhiêu ô quà?]],
COMMUNITYINFO103 = "Hôm nay đã góp rồi",
LOGIN_QUEUE = "Xếp hàng đăng nhập",
LOGIN_QUEUE1 = [[<T C="128,54,13" S="22" P="0">Máy chủ [%s] đã đủ người</T>]],
LOGIN_QUEUE2 = [[<T C="105,65,46" S="24" P="0">Hiện đang xếp </T><T C="1,72,4" S="24" P="0"> hạng %s</T>]],
LOGIN_QUEUE3 = [[<T C="105,65,46" S="22" P="0">Thời gian chờ dự kiến </T><T C="158,0,0" S="22" P="0"> %s...</T>]],
LOGIN_QUEUE4 = "Hủy xếp hàng thành công",
LOGIN_QUEUE5 = "Hủy xếp hàng thất bại",
LOGIN_QUEUE6 = "Nhận danh sách xếp hàng thất bại",
LOGIN_EXIT_QUEUE = "Thoát xếp hàng",
SUG_FIGHT1 = [[<T C="127,70,26" S="22" P="0">Lực Chiến đội đề cử: </T><T C="158,0,0" S="22" P="0"> %d</T>]],
SUG_FIGHT2 = [[<T C="127,70,26" S="22" P="0">Lực Chiến đội đề cử: </T><T C="0,72,3" S="22" P="0"> %d</T>]],
SPACE44 = [[Khung ảnh hiện tại đang khóa, đạt VIP Lv%d sẽ mở]],
RECHARGE_DESC1 = "(PS: Đến nhiệm vụ ngày nhận hoàn trả thẻ tháng)",
RECHARGE_DESC2 = "(PS: Mau vào túi dùng thẻ tặng thành viên Công Hội)",
ABOUT2 = "Giới thiệu game: ",
SPACE45 = [[Xóa hình thành công]],
SPACE46 = [[Dung lượng không đủ, không thể chụp hình]],
SPACE47 = [[Upload ghi âm thành công]],
SPACE48 = [[Upload ghi âm thất bại]],
SPACE49 = [[Xóa ghi âm thành công]],
SPACE50 = [[Chụp thành công, hệ thống duyệt xong mọi người sẽ thấy hình của bạn.]],
SPACE51 = [[Chụp thất bại]],
SPACE52 = [[Xóa hình này không?]],
SPACE53 = [[Đồng ý xóa ghi âm?]],
SPACE54 = [[Chọn ngày sinh, hệ thống sẽ tự chuyển thành tuổi và cung]],
SPACE55 = [[Tuổi: ]],
SPACE56 = [[Cung: ]],
SPACE57 = [[Thiết lập tin cá nhân]],
SPACE58 = [[Tên: ]],
SPACE59 = [[Hiệu: ]],
SPACE60 = [[Cự ly: ]],
SPACE61 = [[Voice: ]],
SPACE62 = [[Bạn đời: ]],
SPACE63 = [[Chưa upload]],
SPACE64 = [[Nhắn tin]],
SPACE65 = [[Thông tin]],
SPACE66 = [[Tin nhắn]],
SPACE67 = [[Album ảnh]],
SPACE68 = [[Những người vào có thể nhận được quà của bạn]],
SPACE69 = [[Thiết lập ô quà]],
SPACE70 = [[Tặng Hoa]],
SPACE71 = [[Còn lại: ]],
SPACE72 = [[Voice giới thiệu: ]],
SPACE73 = [[Upload]],
SPACE74 = [[Hình upload cần được duyệt mới có hiệu lực]],
SPACE75 = [[Chọn lại]],
SPACE76 = [[Đồng ý Upload]],
SPACE77 = [[Upload]],
SPACE78 = [[Mạng quá chậm, upload thất bại]],
SPACE79 = [[Bạch Dương]],
SPACE80 = [[Kim Ngưu]],
SPACE81 = [[Song Tử]],
SPACE82 = [[Cự Giải]],
SPACE83 = [[Sư Tử]],
SPACE84 = [[Xử Nữ]],
SPACE85 = [[Thiên Bình]],
SPACE86 = [[Thiên Hạt]],
SPACE87 = [[Xạ Thủ]],
SPACE88 = [[Ma Kết]],
SPACE89 = [[Thủy Bình]],
SPACE90 = [[Song Ngư]],
SPACE91 = [[Tuổi]],
SPACE92 = [[Cách thức sau]],
BAGTIP2 = "Đã đính hôn",
MARRY_TIPS = "Chúng ta đang chìm đắm trong hạnh phúc!",
SPACE93 = [[Công khai thông tin cá nhân]],
SPACE94 = [[Bạn bè mới thấy avatar bản thân]],
SPACE95 = [[Bạn bè mới nhắn vào trang cá nhân]],
CLOSE_VIP = "Tạm chưa mở nạp",
BAGTIP3 = "Danh sách thu hồi",
BAGTIP4 = "Danh sách thu hồi đã đầy",
PVP_RANK_1 = "Cấp bậc",
PVP_RANK_2 = "Hướng dẫn: ",	
PVP_RANK_3 = "Hạng hiện tại: ",
PVP_RANK_4 = "%d liên thắng",
SEND_PROPOSAL_LETTER9 = "Thân mật %d mới được cầu hôn",
DEVOUR_GET = "Nhận EXP: ",
DEVOUR_CHOOSE = "Chọn gộp",
SURE_CHOOSE = "Xác nhận",
DEVOUR_WORDS = "Gộp",
SURE_DEVOUR = "Đồng ý",
WAIT_FOR_DEVOUR = "Chúc phúc chờ gộp",
BLESS_CALL = "Gọi",
BLESS_ONCE = "Cầu phúc 1 lần",
BLESS_QUICK = "Cầu phúc nhanh",
DEVOUR_ALL = "Gộp nhanh",
SELL_ALL = "Bán nhanh",
PICK_ALL = "Nhặt nhanh",
BLESS_BAG = "Túi Cầu Phúc",
BLESS_SHOP = "Tiệm Cầu Phúc",
GOTO_BLESS = "Cầu phúc",
BLESS_FIGHTING = "Lực chiến: ",
BLESS_BAG_FULL1 = "Túi đã đầy, tháo thất bại",
DEVOUR_MOST = "Mỗi lần chỉ gộp 8 chúc phúc",
BLESS_BAG_FULL2 = "Túi Chúc Phúc không đủ chỗ",
BLESS_BAG_FULL3 = "Túi Chúc Phúc đã đầy",
DEVOUR_ATT = "Chúc phúc %s sẽ gộp chúc phúc khác, tiếp tục?",
BLESS_LEVEL_ATT = "Cấp chúc phúc không thể vượt cấp nhân vật",
BLESS_FAILED_BACK = "Cầu phúc thất bại, trả lại %d Vàng",
BLESS_HOUSE_FULL = "Ô cầu phúc đã hết, nhặt rồi cầu phúc tiếp tục",
BLESSEDMEN_LEVEL_ATT = "Thầy Cầu Phúc đã đạt Lv%d, tiếp tục gọi Thầy Cầu Phúc?",
PVP_RANK_5 = "Điểm: ",
PVP_RANK_6 = "Thưởng Đấu Hạng-Ngày",
PVP_RANK_7 = "Chiến tích hôm nay: %d trận %d thắng",
PVP_RANK_8 = "Thưởng Đấu Hạng-Mùa",
PVP_RANK_9 = "Thưởng Hạng Mùa",
PVP_RANK_10 = "Thưởng Mùa",
PVP_RANK_11 = "Thưởng hạng",
PVP_RANK_12 = "Hạng Mùa",
PVP_RANK_13 = "Nhật ký hạng",
PVP_RANK_14 = "BXH Đấu Hạng-Mùa",
PVP_RANK_15 = "BXH Đấu Hạng-Tất Cả",
PVP_RANK_16 = "Chiến tích mùa giải: %d trận %d thắng",
CLICK_TO_CHANGE = "Nhấp đổi",
MASTERINFO31 = [[Xem trước phúc lợi sư đức Lv%d]],
MASTERINFO32 = [[Chưa có sư phụ]],
MASTERINFO33 = [[Chưa có đệ tử]],
MASTERINFO34 = [[Đã bái sư]],
MASTERINFO35 = [[Chưa bái sư]],
MASTERINFO36 = [[Số đệ tử nhận]],
MASTERINFO37 = [[<T C="158,139,121" S="22" >Đệ tử tốn: </T><I Z="0.7">ui/common/common_icon_huoli.png</I><T C="232,236,193" S="22" >%d</T>]],
MASTERINFO38 = [[<T C="158,139,121" S="22" >Nhận: </T><I Z="0.7">ui/common/common_icon_huoli.png</I><T C="232,236,193" S="22" >%d</T>]],
MASTERINFO39 = [[<T C="255,236,193" S="22" >Số đệ tử nhận:</T><T C="99,255,95" S="22" >%s</T>]],
MASTERINFO40 = [[<T C="236,209,108" S="20">BUFF Sư Môn: </T><T C="255,236,195" S="20">Sinh Lực</T><T C="95,255,99" S="20"> +%s</T><T C="255,236,195" S="20">Tấn Công</T><T C="95,255,99" S="20"> +%s</T><T C="255,236,195" S="20">Phòng Thủ</T><T C="95,255,99" S="20"> +%s</T>]],
MASTERINFO41 = [[<T C="236,209,108" S="20">Số đệ tử tối đa:</T><T C="255,236,195" S="20"> %d người</T>]],
MASTERINFO42 = [[<T C="236,209,108" S="20">Nhận danh hiệu:</T><T C="241,115,30" S="20"> %s</T>]],
MASTERINFO43 = [[<T C="236,209,108" S="20">Thuộc tính tăng: </T><BR></BR><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T>]],
MASTERINFO44 = [[<T C="236,209,108" S="20">BUFF Đệ Tử: </T><BR></BR><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T><T C="255,236,195" S="20">%s</T><T C="95,255,99" S="20"> +%d</T>]],
TO_YOU = [[<T C="79,60,48" S="22">%s </T><T C="105,65,46" S="22" P="1"> tặng cho bạn </T>]],
YOU_TO = [[<T C="105,65,46" S="22">Bạn tặng cho </T><T C="79,60,48" S="22"> %s</T>]],
VIGOR_ADD_FRIENDLINESS = [[<T C="105,65,46" S="20" P="1">Tặng </T><T C="158,0,0" S="20" P="1"> %d</T><T C="105,65,46" S="20" P="1"> Thể Lực, các bạn tăng</T><T C="158,0,0" S="20" P="1"> %d</T><T C="105,65,46" S="20" P="1"> thân mật.</T>]],
FRIEND_APPLY = [[<T C="127,70,26" S="20" P="1">Đã gửi xin kết bạn.</T>]],
GIFT_ADD_FRIENDLINESS = [[<T C="105,65,46" S="20" P="1"> một món quà, các bạn tăng</T><T C="158,0,0" S="20" P="1"> %d</T><T C="105,65,46" S="20" P="1"> thân mật</T>]],
FRIENDLINESS = "Thân mật: ",
MY_SPACE = "Trang cá nhân",
GIVE_GIFT = "Tặng quà",
ADD_FRIENDLINESS = [[<T C="105,65,46" S="24" P="1">Tăng</T><T C="158,0,0" S="24" P="1"> %d</T><T C="105,65,46" S="24" P="1"> thân mật</T>]],
EMPTY_INFO = "Không có thông tin",
WITH_YOU = [[<T C="79,60,48" S="22">%s </T><T C="105,65,46" S="22" P="1">và bạn </T>]],
FIGHT_TOGETHER_FRIENDLINESS = [[<T C="105,65,46" S="20" P="1">hoàn thành chiến đấu, các bạn cùng tăng</T><T C="158,0,0" S="20" P="1"> %d</T><T C="105,65,46" S="24" P="1"> thân mật.</T>]],
FRIEND_GIFT_NOT_ENOUGH = "%s không đủ, có mua quà này không?",
GIVE_GIFT_SUCCESS = "Tặng quà thành công, tăng %d thân mật.",
GIVE_VIGOR_SUCCESS = "Tặng Thể Lực thành công, tăng %d thân mật.",
GET_VIGOR_OK = "Đã nhận %d Thể Lực",
MASTERINFO45 = "Đã xin nhận đệ tử",
MASTERINFO46 = "Xin nhận đệ tử thành công",
MASTERINFO47 = [[%d giờ nữa mới được nhận đệ tử]],
MASTERINFO48 = [[Đối phương %d giờ nữa mới có thể bái sư]],
MASTERINFO49 = [[Đối phương đã có sư phụ]],
MASTERINFO50 = [[Đã xin bái sư]],
MASTERINFO51 = [[Xin bái sư thành công]],
MASTERINFO52 = [[%d giờ nữa mới có thể bái sư]],
MASTERINFO53 = [[Đối phương %d giờ nữa mới có thể nhận đệ tử]],
MASTERINFO54 = [[Đệ tử đối phương đã đạt tối đa]],
MASTERINFO55 = [[Thao tác thành công]],
MASTERINFO56 = [[Đối phương đã có sư phụ]],
MASTERINFO57 = [[Đệ tử đối phương đã đạt tối đa]],
MASTERINFO58 = [[Đã hủy quan hệ sư đồ]],
MASTERINFO59 = [[<T C="151,64,19" S="20">Đồng ý hủy quan hệ sư đồ với %s? </T><BR>22</BR><T C="134,113,92" S="20">Đối phương rời mạng trên </T><T C="158,0,0" S="20">72 </T><T C="134,113,92" S="20">giờ, hủy quan hệ không bị trừng phạt, đồng ý hủy không</T> ]],
SPACE96 = "Đang chiến đấu không thể vào trang cá nhân",
CLICK_ME_TOTRY = "Nhấn vào xem thử",
BLESS_LEVEL_MAX = "Cấp chúc phúc đạt tối đa, không thể gộp nữa",
BLESS_PICK = "Nhặt",
BLESS_CHOOSE_NIL = "Hãy chọn chúc phúc muốn gộp",
DEVOUR_GET_EXP = [[<T C="127,70,26" S="22" P="1">EXP có thể nhận: </T><T C="5,180,0" S="22" P="1">%d</T>]],
BLESS_EQUIP_OPEN_ATT = [[<T C="255,239,193" S="22" P="1" SC="79,60,48" SE="1" SS="4">Lv%d</T><BR></BR><T C="255,239,193" S="22" P="1" SC="79,60,48" SE="1" SS="4"> mở</T>]],
NO_BLESS_TO_DEVOUR = "Không có chúc phúc có thể gộp",
ENOUGH_TO_DEVOUR = "Chúc phúc đã đạt tối đa, không thể chọn nữa",
PLAYER_MOVING = "Đang đi...",
NO_USE_EQUIP_RECT = "Không đủ ô trang bị",
WEDDING_PRIVILEGE = "Đặc quyền hôn lễ",
GET_DRESS = "Nhận thời trang",
WEDDING_TYPE_1_TIP =
[[
<T C="233,166,62" S="20" P="0">1.</T><T C="255,236,193" S="20" P="0"> Nhận Lễ Phục Hôn Lễ Xa Hoa</T><BR></BR>
<T C="233,166,62" S="20" P="0">2.</T><T C="255,236,193" S="20" P="0"> Nơi hôn lễ phát Lì Xì chờ 80 giây</T><BR></BR>
<T C="233,166,62" S="20" P="0">3.</T><T C="255,236,193" S="20" P="0"> Nơi hôn lễ phát Kẹo Hỉ chờ 80 giây</T><BR></BR>
<T C="233,166,62" S="20" P="0">4.</T><T C="255,236,193" S="20" P="0"> Nơi hôn lễ bắn Pháo chờ 80 giây</T><BR></BR>
<T C="233,166,62" S="20" P="0">5.</T><T C="255,236,193" S="20" P="0"> Nơi hôn lễ tặng chúc phúc chờ 80 giây, mỗi lần bản thân được +15 EXP, tân lang tân nương +3 tình cảm</T><BR></BR>
<T C="233,166,62" S="20" P="0">6.</T><T C="255,236,193" S="20" P="0"> Sau khi kết hôn, mỗi ngày vợ chồng tặng quà cho nhau 15 lần sẽ tăng tình cảm</T><BR></BR>
]],
WEDDING_TYPE_2_TIP =
[[
<T C="233,166,62" S="20" P="0">1.</T><T C="255,236,193" S="20" P="0"> Nhận Lễ Phục Hôn Lễ Hào Hoa</T><BR></BR>
<T C="233,166,62" S="20" P="0">2.</T><T C="255,236,193" S="20" P="0"> Nơi hôn lễ phát Lì Xì chờ 100 giây</T><BR></BR>
<T C="233,166,62" S="20" P="0">3.</T><T C="255,236,193" S="20" P="0"> Nơi hôn lễ phát Kẹo Hỉ chờ 100 giây</T><BR></BR>
<T C="233,166,62" S="20" P="0">4.</T><T C="255,236,193" S="20" P="0"> Nơi hôn lễ bắn Pháo chờ 100 giây</T><BR></BR>
<T C="233,166,62" S="20" P="0">5.</T><T C="255,236,193" S="20" P="0"> Nơi hôn lễ tặng chúc phúc chờ 100 giây, mỗi lần bản thân được +10 EXP, tân lang tân nương +2 tình cảm</T><BR></BR>
<T C="233,166,62" S="20" P="0">6.</T><T C="255,236,193" S="20" P="0"> Sau khi kết hôn, mỗi ngày vợ chồng tặng quà cho nhau 10 lần sẽ tăng tình cảm</T><BR></BR>
]],
WEDDING_TYPE_3_TIP =
[[
<T C="233,166,62" S="20" P="0">1.</T><T C="255,236,193" S="20" P="0"> Nhận Lễ Phục Áo Hôn Lễ Lãng Mạn</T><BR></BR>
<T C="233,166,62" S="20" P="0">2.</T><T C="255,236,193" S="20" P="0"> Nơi hôn lễ phát Lì Xì chờ 120 giây</T><BR></BR>
<T C="233,166,62" S="20" P="0">3.</T><T C="255,236,193" S="20" P="0"> Nơi hôn lễ phát Kẹo Hỉ chờ 120 giây</T><BR></BR>
<T C="233,166,62" S="20" P="0">4.</T><T C="255,236,193" S="20" P="0"> Nơi hôn lễ bắn Pháo chờ 120 giây</T><BR></BR>
<T C="233,166,62" S="20" P="0">5.</T><T C="255,236,193" S="20" P="0"> Nơi hôn lễ tặng chúc phúc chờ 120 giây, mỗi lần bản thân được +5 EXP, tân lang tân nương +1 tình cảm</T><BR></BR>
<T C="233,166,62" S="20" P="0">6.</T><T C="255,236,193" S="20" P="0"> Sau khi kết hôn, mỗi ngày vợ chồng tặng quà cho nhau 5 lần sẽ tăng tình cảm</T><BR></BR>
]],
PVP_RANK_17 = "Thưởng ngày",
PVP_RANK_18 = "Thưởng Mùa",
PVP_RANK_19 = "Hướng dẫn",
BLESS_HOUSE_NIL = "Không có chúc phúc có thể dùng",
ORDER_HUSBAND = "Chồng chưa cưới",
ORDER_WIFE = "Vợ chưa cưới",
CANCEL_READY = "Hãy hủy sẵn sàng",
NO_BLESS_TOSELL = "Không có chúc phúc có thể bán",
NO_BLESS_TOPICK = "Không có chúc phúc có thể nhặt",
NO_BLESS_TOP1 = "Hiện đã kết hôn không thể xóa bạn",
NO_BLESS_TOP2 = "Hiện là sư đồ không thể xóa bạn",
HALL_DESC1 = "Đang ghép...",
HALL_DESC2 = 
{
[[Khi gió lớn thì lực tấn công cũng phải lớn để tránh đạn bị thổi bay mất!]],
[[Kỹ năng khác nhau tốn  điểm hành động khác nhau, cần tính kỹ thời cơ ra tay.]],
[[Thi đấu nhiều người đòi hỏi sự phối hợp ăn ý, tinh thần đồng đội làm nên tất cả!]],
[[Dùng đạo cụ và kỹ năng hợp lý, có thể đảo ngược thế cờ! Hãy nhắm đúng thời cơ xuất kích!]],
[[Trong Đấu Hạng, thuộc tính người chơi hoàn toàn giống nhau, không có chênh lệch lực chiến.]],

},
FIGHT_POWER = [[<I Z="1">ui/common/common_icon_zhandouli.png</I><A IMG = "ui/common_num/common_num_zhandouli.png" Z ="1" W = "16" H = "26" CHAR = "0">%d</A>]],
FIGHT_POWER1 = [[<I Z="1">ui/common/common_icon_zqzl.png</I><A IMG = "ui/common_num/common_num_zhandouli.png" Z ="1" W = "16" H = "26" CHAR = "0">%d</A>]],
FIGHT_POWER2 = [[<I Z="1">ui/common/common_icon_cwzli.png</I><A IMG = "ui/common_num/common_num_zhandouli.png" Z ="1" W = "16" H = "26" CHAR = "0">%d</A>]],
SPACE97 = "Trong phòng không thể xem trang cá nhân",
CALL_TIMES_FINISH = "Số lần gọi hôm nay đã hết",
CALL_UNSUCCESS = "Số lần gọi đã đạt tối đa, tăng cấp VIP sẽ tăng giới hạn!",
CALL_TIMES_COST = "Muốn tốn %d Kim Cương gọi Thầy Cầu Phúc?    (Đã gọi %d  lần)", 
CALL_FREE_ATT = "Lần đầu gọi hôm nay sẽ miễn phí, tiếp tục?",
SHOP_BUY_DESC1 = "Đòi",
SHOP_BUY_DESC2 = [[<T C="79,60,48" S="20" P="0">Gồm %d vật phẩm, cần chi trả </T><I Z="0.8">ui/common/common_icon_jinbi.png</I><T C="5,180,0" S="24" P="0">%d</T>]],
SHOP_DESC1 = "Nhắn tin: ",
SHOP_DESC2 = [[<T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4">Mua vật phẩm cần trả </T><I Z="0.8">ui/common/common_icon_zuanshi.png</I><T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4">%d</T>]],
SHOP_DESC3 = "Nhấp soạn tin nhắn",
VIP_DESC3 = "Tặng",
SPACE98 = "Nhấn tải lên",
SPACE99 = "Đang duyệt",
NETTIP1 = "Đường truyền ổn định",
NETTIP2 = "Đường truyền bình thường",
NETTIP3 = "Đường truyền kém, dễ rớt mạng",
FRIEND_ONLINE_ATT = "Nhắc nhở online",
SELECT_ONLINE_HINT= "Hãy chọn bạn cần nhắc nhở online: ",
SELECT_ONLINE_TITLE = "Nhắc nhở online",
SET_SUCCESS = "Thiết lập thành công",
COMMUNITYINFO104 = "Cống hiến hội viên",
COMMUNITYINFO105 = "Tổng",
COMMUNITYINFO106 = "Tuần này",
COMMUNITYINFO107 = "Tuần trước",
COMMUNITYINFO108 = "Cống hiến",
TIP = "[Nhắc nhở]",
FRIENG_ONLINE_TIP = "%s đã online!",
SHOP_DESC4 = "Vật phẩm không thể mua",
SHOP_DESC5 = "Chọn bạn bè",
SHOP_DESC6 = "Yêu cầu gửi quà thành công",
SHOP_DESC7 = "Tặng thành công",
SPACE100 = "Chưa mở",
HURT = "Sát thương: ",
MAIL_SHOP = "Quà Tặng",
MAIL_PAY = "Cần trả",
MAIL_DOPAY = "Chi trả",
BATTLE_LINK_OUT = "Đường truyền đã khôi phục, đang kết nối máy chủ", 
BATTLE_RELINK_OK = "Kết nối lại",
BATTLE_RELINK_FAILURE = "Kết nối lại quá hạn, hãy về Sảnh", 
MUL_ID = "ID: ",
MAIL_HASPAY = "Đã tặng",
STRENGTENTIP3 = "May mắn đầy sẽ thành công, mỗi ngày quay về 0!",
STRENGTENTIP4 = "Trước",
STRENGTENTIP5 = "Sau",
STRENGTENTIP6 = "Chọn trang bị kế thừa",
SPACE101 = "Quà: ",
SHOP_DESC8 = "Vật phẩm này không thể đòi",
NO_INBATTLE_TIP = "Chưa có đội",
PROBABILITY_GET = "Có cơ hội nhận ",
PURPLE = "T.Bị Tím",
TAKE_OUT_AGAIN = "Rút thêm %d lần chắn chắn được",
CHOOSE_BLESSITEM = "Chọn chúc phúc",
CHOOSE_EQUIP_BLESSITEM = "Hãy chọn chúc phúc cần dùng",
NO_BLESSITEM_CAN_EQUIP = "Không có chúc phúc, hãy mau đi cầu phúc",
COPY_LIFT = "Tăng lực chiến",
SHOP_DESC9 = "Cấp VIP không đủ để tặng quà, tăng cấp VIP ngay?",
SHOP_DESC10 = "Tặng",
SHOP_DESC11 = "Đòi",
SETTING_SHIELD_ALLINVITE = "Người lạ mời: ",
MAIL_SHOPTIPS = "Thông tin tặng và đòi quà Cửa Hàng",

SHOP_DESC12 = "Bạn bè Lv%d và VIP%d trở lên, thân mật %d",
SHOP_DESC13 = "Thân mật %d trở lên",
GOODS_FULL = "Thư Viện Vật Phẩm",
FRAGMENT_BLESS_SHOW = "Xem trước (Mảnh)",
DIAMONDS_BLESS_SHOW = "Xem trước (Kim Cương)",
HAVED_INVITED = "Đã mời",
BATTLE_OTHER_RELINK_OK = "Đã khôi phục  %s",
SPACE102 = "Nhấp nút phía trên để ghi âm",
SPACE103 = "Vuốt ngón tay lên hủy ghi âm",
REEL_NOT_ENOUGH = "Quyển Đồ Tím không đủ",
TEN_RAFFLE = "Mở x10 nhận",
CALL = "Triệu Hồi",
ISONLINE = "Đang online",
ISOFFLINE = "Chưa online",
WEEK_BEFORE = "%d tuần trước",
MONTH_BEFORE = "%d tháng trước",
YEAR_BEFORE = "%d năm trước",
LASTONLINE = "Đăng nhập gần nhất: ",
REPLACE_RAFFLE_TIP = "Mở thay thế Kim Cương",
FRAGMENT_NOT_ENOUGH = "Mảnh không đủ",
COMMUNITYINFO109 = "Học kỹ năng thành công",
ALL_SERCER_RANK_NAME = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="62,34,8" S="24" P="0">%s</T>]],
SPACE104 = "Người chơi liên server không thể thực hiện thao tác này",
PET_KAPIAN = "Có thể dùng đập trứng thay Kim Cương ",
PETOPENEGE4 = "Đập Vé", 
ITEM_TYPE1 = "Vũ khí", 
ITEM_TYPE2 = "Set Lục Bảo",
ITEM_TYPE3 = "Set Hoàng Kim",
ITEM_TYPE4 = "Set Lam Bảo",
ITEM_TYPE5 = "Set Rừng Xanh",
ITEM_TYPE6 = "Món Biển Cả",
ITEM_TYPE7 = "Set Sa Mạc",
ITEM_TYPE8 = "Set Sấm Sét ", 
ITEM_TYPE9 = "Set Băng",
ITEM_TYPE10 = "Set Trắng",
ITEM_TYPE11 = "Món Đen",
ITEM_TYPE12 = "Set Ma Ảo",
ITEM_TYPE13 = "Set Bóng Tối",
ITEM_TYPE14 = "Set Tương Lai",
ITEM_TYPE15 = "Set Ác Quỷ",
ITEM_TYPE16 = "Món Chú Hề",
NOT_OPEN_CHAN = "Kênh chưa mở", 
CLICK_CLOSE_CONTAINER = "Nhấp đóng tiếp tục",
COLOR_CHAT_NOT_CROSS_SERVER = "Liên server không hỗ trợ chat voice",
NOT_RECORD_VOICE2 = "Vuốt ngón tay lên hủy gửi, chỉ có hiệu lực ở server này",
GET_BLESS_COIN = "Nhận Xu Cầu Phúc",
CHAT_TEAM = "[Đội]",
ITEM_PRODUCT = "Vật phẩm này tạm không có nguồn ra",
ALL_SERCER_RANK_NAME1 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,236,193" S="24" P="0">%s</T>]],
LUCK_DRAW_AGAIN = "Gọi lại 1 lần",
LUCK_DRAW_AGAIN_TIP = "Mở",
LUACK_DRAW_AGAIN_TIP2 = " lần nhận",
LUACK_DRAW_AGAIN_TIP3 = "Mở lần này chắc chắn nhận",
MAIL_FULLBAG2 = "Túi đã đầy, sắp xếp rồi quay lại",
BLESSCOIN_NOT_ENOUGH = "Xu Cầu Phúc không đủ",
BATTLE_ACTION_VALUE_NO_ENOUGH = "Điểm hành động không đủ",
WIFFTP1 = "Đang kết nối lại",
WIFFTP2 = "Đợi %s phản hồi",
LOVELOTTERY = "Ước Nguyện Yêu Thương",
MONTHCARD_LEFTTIME = "Thẻ Tháng còn: ",
BUY_NOW = "Mua ngay",

INVITE_FRIENDS = "Code Bạn bè",
INVITE_REWARDS = "Thưởng mời",
COPY_SUCCESS = "Copy thành công",
SUBMIT_OK = "Đã gửi code",
INPUT_INVITE_CODE = "Hãy nhập code",
INVITE_CODE_NOT_EXIST = "Code không tồn tại",
IS_MY_INVITE_CODE = "Không thể nhập code của bản thân",
INVITE_GET_SUCCESS = "Nhận thưởng thành công",
WRITE_INVIDE_CODE = "Nhập code",
MY_INVITE_CODE = "Code: ",
COPY = "Copy",
WRITE_INVITE_CODE_ATT = "Nhập code, sẽ nhận phần thưởng sau",
INVITE_CODE_ATT1 = "Code nhập: ",
INVITE_CODE_ATT2 = "Code bạn bè: ",
INVITE_CODE_ATT3 = "Đã nhận thưởng code: ",
MOUNT_UP_FIVE = "Tăng cấp %d lần",
MOUNT_UP_LOG1 = "Nhật ký",
MOUNT_UP_LOG2 = [[<T C="195,171,148" S="18" P="0">Tăng lần thứ %d, %d->%d, tốn %d Vàng, tỉ lệ thành công %s,</T><T C="99,255,95" S="18" P="0">Thành công</T>]],
MOUNT_UP_LOG3 = [[<T C="195,171,148" S="18" P="0">Tăng lần thứ %d, %d->%d, tốn %d Vàng, tỉ lệ thành công %s,</T><T C="255,89,74" S="18" P="0">Thất bại</T>]],
MOUNT_UP_LOG4 = [[<T C="195,171,148" S="18" P="0">Tăng cấp %d lần, thú cưỡi đã tăng %d Lv, tốn %d Vàng </T>]],
LUACK_DRAW_BOX_UNLOCK_TIP_FRONT = "Rương thưởng chương trước chưa nhận!",
LUACK_DRAW_BOX_UNLOCK_TIP_BEHINE = "Rương thưởng chương sau chưa nhận!",
BATTLE_ACTION_VALUE_NO_ENOUGH_BIG = "Không đủ 8 điểm hành động",
LOOK_VIDEO = "Xem",
TEAM_FIGHT = "Lực chiến đội: ",
FIGHT_VIDEO = "Video",
BEST_VIDEO = "Video vượt ải hay nhất",
BEST_VIDEO_DIF1 = "Dễ",
BEST_VIDEO_DIF2 = "Khó",
BEST_VIDEO_DIF3 = "Địa Ngục",
INVITE_CODE_ATT4 = "Tạm không có bạn code",
LIBRARY_NAME = "Thư Viện",
LEAGUE1 = "Thi Đấu",
LEAGUE2 = "Chiến Đội",
LEAGUE3 = "Vinh Dự",
LEAGUE4 = "Phát Lại",
LEAGUE5 = "Hạng Vòng Loại",
LEAGUE6 = "Tình hình đấu bảng",
LEAGUE7 = "Top 16",
LEAGUE8 = "Quyết đấu Top 8",
LEAGUE9 = "Hướng dẫn",
ATH_DAILY_GOAL = "Mục tiêu ngày",
INVITE_SUBMIT = "Giao",
LEAGUE10 = [[Xạ Thủ Liên Đấu]],
LEAGUE11 = 
[[
<T C="255,227,116" S="22">[Lịch thi đấu]</T><BR></BR>
<T C="255,236,193" S="18">13/12-19/12 Vòng loại</T><BR></BR>
<T C="255,236,193" S="18">20/12-21/12 báo danh thi đấu</T><BR></BR>
<T C="255,236,193" S="18">22/12 Đấu Top 32 (Đấu bảng)</T><BR></BR>
<T C="255,236,193" S="18">23/12 Đấu Top 16</T><BR></BR>
<T C="255,236,193" S="18">24/12 Đấu Top 8</T><BR></BR>
<T C="255,236,193" S="18">25/12 Đấu Top 4</T><BR></BR>
<T C="255,236,193" S="18">26/12 Đấu Quán Quân, Đấu Hạng 3</T><BR>30</BR>

<T C="255,227,116" S="22">[Thưởng giải đấu]</T><BR></BR>
<T C="255,236,193" S="18">Quán Quân: Kim Cương x10000, Túi Vàng-Lớn x100, Quà Thời Trang Black Power x1, Quán Quân Vua Xạ Thủ (Danh hiệu)</T><BR></BR>
<T C="255,236,193" S="18">Hạng 2: Kim Cương x8000, Túi Vàng-Lớn x80, Hạng 2 Vua Xạ Thủ (Danh hiệu)</T><BR></BR>
<T C="255,236,193" S="18">Hạng 3: Kim Cương x5000, Túi Vàng-Lớn x70, Hạng 3 Vua Xạ Thủ (Danh hiệu)</T><BR></BR>
<T C="255,236,193" S="18">Hạng 4: Đá Sao-Thánh Quang x100, Đá Vô Cực L4 x5, Túi Vàng-Lớn x40</T><BR></BR>
<T C="255,236,193" S="18">Top 8 (Hạng 5-8): Đá Sao-Thánh Quang x50, Đá Vô Cực L4 x4, Túi Vàng-Lớn x30</T><BR></BR>
<T C="255,236,193" S="18">Top 16 (Hạng 9-16): Đá Sao-Thánh Quang x40, Đá Vô Cực L4 x3, Túi Vàng-Lớn x20</T><BR></BR>
<T C="255,236,193" S="18">Top 32 (Hạng 17-32): Đá Sao-Thánh Quang x30, Đá Vô Cực L4 x2, Túi Vàng-Lớn x10</T><BR></BR>
<T C="255,236,193" S="18">Thưởng đặc biệt: Hạng Vòng Loại 1-2000 có thể nhận danh hiệu cá nhân [Cao Thủ Độc Hành]</T><BR></BR>

<T C="255,227,116" S="22">[Quy tắc bầu cử biển]</T><BR></BR>
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18">Phải mất 100 viên kim cương nghi lễ / viên kim cương để tạo ra một đội và tuyển dụng những người chơi giỏi.Trong giai đoạn mở đầu của cuộc bầu cử biển, ba thành viên trong nhóm có thể phù hợp bất cứ lúc nào;</T><BR></BR>
<T C="255,236,193" S="20">2.</T><T C="255,236,193" S="18">Sau khi kết thúc cuộc thử nghiệm trên biển, bạn có thể đăng ký vào cuộc thi 32-strong sau khi đạt được các điểm được chỉ định Hệ thống cuối cùng sẽ sàng lọc 32 đội có số điểm cao nhất trong cuộc bầu cử trên biển;</T><BR></BR>
<T C="255,236,193" S="20">3.</T><T C="255,236,193" S="18">Nếu các điểm của cuộc bầu cử biển là như nhau, các bảng xếp hạng sẽ được xếp hạng theo các yếu tố toàn diện như thắng và tỷ lệ chiến thắng, và cuối cùng là đội được hệ thống lựa chọn sẽ thắng thế.</T><BR>30</BR>

<T C="255,227,116" S="22">Quy tắc</T><BR></BR>
<T C="255,227,116" S="18">Top 32 Đấu Bảng: </T><BR></BR>
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18"> Đấu bảng do 32 đội báo danh thành công chia ra 8 nhóm, mỗi nhóm 4 đội.</T><BR></BR>
<T C="255,236,193" S="20">2.</T><T C="255,236,193" S="18"> Đấu bảng gồm 3 lượt đấu, mỗi đội của mỗi nhóm lần lượt đấu 1 lần với 3 đội khác, cuối cùng chọn ra 2 đội có số lần chiến thắng nhiều nhất để vào vòng trong.</T><BR></BR>
<T C="255,236,193" S="20">3.</T><T C="255,236,193" S="18"> Nếu nhiều đội trong cùng 1 nhóm có số lần thắng giống nhau thì chọn đội có số điểm vòng loại cao hơn để vào vòng trong.</T><BR></BR>
<T C="255,227,116" S="18">Đấu Top 16 :</T><BR></BR>
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18"> Các đội vào Top 16 chia thành 8 nhóm, dùng cơ chế 3 trận thắng 2, 8 đội thắng sẽ vào vòng trong.</T><BR></BR>
<T C="255,227,116" S="18">Đấu Top 8: </T><BR></BR>
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18"> Các đội vào Top 8 chia thành 4 nhóm, dùng cơ chế 3 trận thắng 2, 4 đội thắng sẽ vào vòng trong.</T><BR></BR>
<T C="255,227,116" S="18">Chung Kết Top 4: </T><BR></BR>
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18"> Top 4 chia thành 2 nhóm, dùng cơ chế 3 trận thắng 2, 2 đội thắng sẽ đấu tổng chung kết, 2 đội thua sẽ đấu hạng 2.</T><BR></BR>
<T C="255,236,193" S="20">2.</T><T C="255,236,193" S="18"> Đấu hạng 3 và đấu tổng chung kết, dùng cơ chế 3 trận thắng 2, đội thắng 2 trận sẽ giành chiến thắng.</T><BR></BR>
<T C="255,227,116" S="18">Tranh Quán Quân và Tranh Hạng 3: </T><BR></BR>
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18"> Đấu Quán Quân chia thành 2 nhóm, dùng cơ chế 3 trận thắng 2, thắng sẽ là quán quân, thua sẽ là hạng 2.</T><BR></BR>
<T C="255,236,193" S="20">2.</T><T C="255,236,193" S="18"> Đấu Hạng 3 chia thành 2 nhóm, dùng cơ chế 3 trận thắng 2, phe thắng sẽ giành hạng 3.</T>
<T C="255,236,193" S="20">3.</T><T C="255,236,193" S="18">Tranh Quán Quân và Tranh Hạng 3 sẽ tiến hành cùng lúc, hãy tham gia đúng giờ</T><BR>30</BR>

<T C="255,227,116" S="22">Hướng dẫn: </T><BR></BR>
<T C="255,236,193" S="20">1.</T><T C="255,236,193" S="18"> Mỗi lượt đấu cần hoàn thành trong thời gian quy định, vượt quá thời gian sẽ thất bại.</T><BR></BR>
<T C="255,236,193" S="20">2.</T><T C="255,236,193" S="18"> Trong vòng loại và đấu chính thức, thuộc tính nhân vật sẽ chia đều, chỉ hiệu lực trong Liên Đấu.</T><BR></BR>
<T C="255,236,193" S="20">3.</T><T C="255,236,193" S="18"> Thời gian mỗi trận là 15 phút, vượt quá giờ sẽ dựa vào số người sống sót và sinh lực còn lại để chọn ra bên thắng.</T><BR>30</BR>
<T C="255,236,193" S="20">4.</T><T C="255,236,193" S="18">Trong thời gian diễn ra sự kiện, hoàn toàn bị cấm hành động thay mặt cho trò chơi, và nếu nó được tìm thấy, nó sẽ trực tiếp hủy bỏ các bằng cấp và phần thưởng liên quan.</T><BR>30</BR>
]],
LEAGUE12 = "Lập chiến đội",
VIDEO_FIGHT_ONE = "Đơn Đấu",
VIDEO_FIGHT_TWO = "Song Đấu",
VIDEO_FIGHT_THREE = "Tam Đấu",
VIDEO_FIGHT_MY = "Video",
VIDEO_FIGHT_ONE_LOOK = "Phát lại Đơn Đấu",
VIDEO_FIGHT_TWO_LOOK = "Phát lại Song Đấu",
VIDEO_FIGHT_THREE_LOOK = "Phát lại Tam Đấu",
VIDEO_FIGHT_MY_LOOK = "Phát lại Video",
SINGLE_FIGHT = "Lực chiến cá nhân: ",
LEAGUE13 = 
[[
<T C="255,227,116" S="20" P="0"> Vòng loại:</T><T C="195,171,48" S="20" P="0">2015.11.21 - 2016.12.22</T><BR>10</BR>
<T C="255,227,116" S="20" P="0"> Thời gian tham gia:</T>
<T C="195,171,48" S="20" P="0">12:00-21:00 Điểm chiến thắng </T>
<T C="99,255,95" S="20" P="0">+10</T>
<T C="195,171,48" S="20" P="0"> , điểm thất bại </T>
<T C="99,255,95" S="20" P="0">-5</T>
<T C="195,171,48" S="20" P="0"> 0</T>
]],
LEAGUE14 = 
[[
<T C="158,0,0" S="22" P="0"></T><T C="62,34,8" S="22" P="0"> Đội online: 3</T><BR></BR>
]],
LEAGUE15 = 
[[
<T C="158,0,0" S="22" P="0"></T><T C="127,70,26" S="22" P="0">Đấu bảng</T><BR></BR>
<T C="158,0,0" S="22" P="0"></T><T C="127,70,26" S="22" P="0">(Thứ 7)</T><BR></BR>
<T C="158,0,0" S="22" P="0"></T><T C="127,70,26" S="22" P="0">2016.6.6</T><BR></BR>
]],
LEAGUE16 = 
[[
<T C="79,60,48" S="22" P="0">1. Sau khi báo danh căn cứ điểm chọn ra 32 đội, thông báo sẽ gửi qua Thư</T><BR>13</BR>
<T C="79,60,48" S="22" P="0">2. Nếu trong thời gian Thi Đấu không tham chiến sẽ coi như bỏ cuộc</T><BR>13</BR>
<T C="79,60,48" S="22" P="0">3. Báo danh phải đạt %d điểm</T><BR></BR>
]],
SHARE_GAME = "Chia sẻ trò chơi",
SHARE_FRIEND = "Chia sẻ bạn bè",
SHARE_MOMENTS = "Chia sẻ khoảnh khắc",
LANGUAGE_CHANGE = "Đổi ngôn ngữ: ",
LANGUAGE_CHANGE2 = "Đổi ngôn ngữ",
LANGUAGE_CHANGE3 = "Sau khi đổi sẽ đăng nhập lại",
LEAGUE17 = " trận",
LEAGUE18 = "Vòng loại",
CITY_SCENE_NOT_SUPPORT_CHAT = "Phát ngôn kênh thành chính cần đạt Lv12",
LEAGUE_HONOUR_TITLE = "Quán Quân Liên Đấu mùa %d",
LEAGUE_REPLAY_ITEM1 = "Đang diễn ra",
LEAGUE_REPLAY_ITEM2 = "Đặc sắc",
LEAGUE_REPLAY_ITEM3 = "Quyết đấu",
LEAGUE_REPLAY_ITEM4 = "Cá nhân",
LEAGUE_REPLAY_TEXT1 = "ID chiến đội:",
LEAGUE_REPLAY_TEXT2 = " người xem",
LEAGUE_REPLAY_TEXT3 = " vạn người xem",
LEAGUE_REPLAY_TEXT4 = "Đã xem",
LEAGUE_REWARD_ITEM1 = "Thưởng vòng loại",
LEAGUE_REWARD_ITEM2 = "Thưởng hạng vòng loại",
LEAGUE_REWARD_ITEM3 = [[Xạ Thủ Liên Đấu]],
LEAGUE_REWARD_ITEM4 = "Thưởng tiêu diệt",
LEAGUE_REWARD_TEXT1 = [[<T C="255,227,116" S="22" P="1">Chiến tích hôm nay: </T><T C="255,236,193" S="22" P="1">Đấu %d thắng %d</T>]],
LEAGUE_REWARD_TEXT2 = [[<T C="255,227,116" S="22" P="1">Mỗi ngày </T><T C="255,89,74" S="22" P="1">00:00</T><T C="255,227,116" S="22" P="1"> tạo mới</T>]],
PLAY_AGAIN = "Phát lại",
BATTLE_SURE_REPLAY_EXIT = "Muốn thoát Video trận này?",
YOU_HAVE_NO_COMMUNITY = "Vẫn chưa vào Công Hội",
LEAGUE19 = "Vòng 1",
LEAGUE20 = "Vòng 2",
LEAGUE21 = "Vòng 3",
NO_BLESS_NEED_DEVOUR = "Không có chúc phúc để gộp",
LEAGUE_REWARD_TEXT3 = [[<T C="255,227,116" S="22" P="1">Vòng loại </T><T C="255,89,74" S="22" P="1">%s</T><T C="255,236,193" S="22" P="1">Phát thưởng hạng</T>]],
LEAGUE_REWARD_TEXT4 = [[<T C="255,227,116" S="22" P="1">Hạng đội: </T><T C="255,236,193" S="22" P="1">%s</T>]],
LEAGUE_REWARD_TEXT5 = [[<T C="255,227,116" S="22" P="1">Số diệt: </T><T C="255,236,193" S="22" P="1">%d</T>]],
LEAGUE_REPLAY_TEXT5 = "Không có trận đang đấu",
LEAGUE_REPLAY_TEXT6 = "Không có video đặc sắc",
LEAGUE_LEAVETEAM_TIMES = "Số lần rời đội: %d",
LEAGUE22 = "Thưởng",
ROLESOUND = "Đổi giọng nhân vật",
ROLESOUND2 = "Nhân vật:",
ROLESOUND_1 = "Trang chủ",
ROLESOUND_2 = "Cá tính",
ROLESOUND_3 = "Dễ thương",

LEAGUE_PLAYER_KF1 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,255,255" S="22" P="1">%s</T>]],
LEAGUE_PLAYER_1 = [[<T C="255,255,255" S="22" P="0">%s</T>]],
LEAGUE_WAIT_PLAYER = "Đang đợi đối thủ...",
LEAGUE_NO_JOIN = "(Đội chưa vào xem như bỏ cuộc)",
LEAGUE_READY_JOIN = "%d giây sau vào đấu",
LEAGUE23 = "Thiết lập tham chiến",
LEAGUE24 = "Thiết lập ứng viên",
LEAGUE25 = "Mời vào ",
LEAGUE26 = "Mời khỏi Đội",
LEAGUE27 = "Tên chiến đội không thể để trống",
LEAGUE28 = "Tên chiến đội tối đa 5 ký tự",
LEAGUE29 = "Chọn hình chiến đội",
ATH_GOAL_DESC1 = "Tổ đội vợ chồng tham chiến",
ATH_GOAL_DESC2 = "Tổ đội vợ chồng chiến thắng",
ATH_GOAL_DESC3 = "Tổ đội Công Hội tham chiến",
ATH_GOAL_DESC4 = "Tổ đội Công Hội chiến thắng",
ATH_GOAL_DESC5 = "Tổ đội bạn bè tham chiến",
ATH_GOAL_DESC6 = "Tổ đội bạn bè chiến thắng",
ATH_DESC_11 = [[<T C="127,70,26" S="20" P="0">Mỗi ngày </T><T C="158,0,0" S="20" P="0">24:00</T><T C="127,70,26" S="20" P="0"> tạo mới</T>]],
COMMUNITYINFO110 = "Nhiệm vụ Công Hội",
COMMUNITYINFO111 = "Quỹ",
COMMUNITYINFO112 = "%d Quỹ trở lên",
COMMUNITYINFO113 = "Quỹ hiện tại: %d",
COMMUNITYINFO114 = [[24:00 Chủ Nhật mỗi tuần thống kê cấp Quỹ, phát thưởng qua thư theo chức Công Hội]],
COMMUNITYINFO115 = [[10 tin gần nhất]],
COMMUNITYINFO116 = [[Hôm nay chưa phát nhiệm vụ Công Hội, nhiệm vụ Công Hội có thể tăng nhanh danh vọng Công Hội, hội viên có thể nhận thưởng phong phú]],
COMMUNITYINFO117 = [[Đến phát]],
COMMUNITYINFO118 = [[Khóa không tạo mới]],
COMMUNITYINFO119 = [[Cá nhân]],
COMMUNITYINFO120 = [[Phát nhiệm vụ]],
COMMUNITYINFO121 = [[Đợi phát]],
COMMUNITYINFO122 = [[Phát nhiệm vụ thành công]],
COMMUNITYINFO123 = [[Khóa nhiệm vụ thành công]],
COMMUNITYINFO124 = [[Mở khóa nhiệm vụ thành công]],

BLESS_MEDAL_NOT_ENOUGH = "Huy Chương cầu phúc không đủ",
MARRYSKILL = "Kỹ năng vợ chồng",
WELFARE_COMPETE_TEXT1 = "Vui lòng đợi...",
WELFARE_COMPETE_TEXT2 = "Đang đấu Vòng Loại",
WELFARE_COMPETE_TEXT3 = "Đang đấu Vòng Bảng",
WELFARE_COMPETE_TEXT4 = "Đang đấu Top 16",
WELFARE_COMPETE_TEXT5 = "Đang đấu Top ",
LEAGUE_REWARD_TEXT6 = "Chưa đạt điều kiện",
LEAGUE_REWARD_TEXT7 = "Đã phát",
LEAGUE_REWARD_TEXT8 = "Rời đội sẽ tính lại số tiêu diệt, mùa giải kết thúc sẽ xóa",
LEAGUE_REPLAY_TEXT7 = "Vòng loại",
LEAGUE_REPLAY_TEXT8 = "Đấu bảng",
LEAGUE_REPLAY_TEXT9 = "Top 16",
LEAGUE_REPLAY_TEXT10 = "Top 8",
LEAGUE_REPLAY_TEXT11 = "Bán kết",
LEAGUE_REPLAY_TEXT12 = "Chung kết",
LEAGUE_REPLAY_TEXT13 = "Không có video quyết đấu",
LEAGUE_REPLAY_TEXT14 = "Không có nhật ký phát lại",
SHOP_DESC14 = "Cấp nhân vật chưa đạt Lv%d không thể tặng",
LEAGUE_HONOUR_TEXT1 = "Vẫn chưa tìm được Quán Quân, cố gắng giành danh hiệu nào",
LEAGUE30 = "Lập chiến đội",
LEAGUE31 = "Thiết lập chiến đội",
LEAGUE32 = [[Muốn giải tán đội, giải tán không thể quay lại, tiêu phí không hoàn trả, sau khi giải tán đội viên sẽ rời đội?]],
LEAGUE33 = [[Muốn rời chiến đội %s, đội này hơn 48 giờ chưa thi đấu, thoát không bị phạt, đồng ý thoát?]],
LEAGUE34 = [[Muốn rời chiến đội %s, đội này trong 48 giờ có thi đấu, sau khi thoát trong %d phút không thể vào đội khác, đồng ý thoát?]],
EXPLAIN1 = "Gửi biểu cảm ở trạng thái tàng hình sẽ bị lộ vị trí",
EXPLAIN2 = "Trạng thái cưỡi của thú cưỡi không ảnh hưởng lực chiến thú cưỡi cộng thêm",
COMMUNITYINFO125 = [[Nhiệm vụ đã phát, đếm ngược ]],
COMMUNITYINFO127 = [[Hãy chọn nhiệm vụ]],
LEAGUE35 = [[Chiến đội không tồn tại]],
LEAGUE_REPLAY_TEXT15 = "Xem chiến",
LEAGUE36 = [[Tuyên ngôn quá dài]],
LEAGUE37 = [[Tuyên ngôn chiến đội]],
LEAGUE38 = [[Bị đuổi khỏi chiến đội]],
LEAGUE39 = [[Người chơi rời mạng lâu hơn 48 giờ, mời khỏi đội không bị phạt, đồng ý mời khỏi?]],
LEAGUE40 = [[Người chơi rời mạng ít hơn 48 giờ, mởi khỏi đội sẽ không thể ghép trong %d phút, đồng ý mời khỏi?]],
LEAGUE41 = [[Thi đấu chưa bắt đầu]],
COMMUNITYINFO126 = [[Xác nhận phát 4 nhiệm vụ này?]],
LEAGUE42 = [[Không được chứa ký tự đặc biệt]],
LEAGUE43 = [[Bạn chưa có đội liên đấu]],
LEAGUE44 = [[Chiến đội đã đủ người]],
LEAGUE45 = [[ sau bắt đầu]],
LEAGUE46 = [[Đội %d điểm trở lên mới được báo danh]],
LEAGUE47 = [[Sau khi kết thúc vòng loại mới được báo danh]],
LEAGUE48 = [[Chỉ đội trưởng có thể báo danh]],
LEAGUE49 = [[Báo danh thành công, lấy danh sách tham gia gửi qua Thư làm chuẩn]],
LEAGUE50 = [[Đã báo danh thành công]],
GOTO_ATHLETICS = "Đến thi Đấu",
GOTO_SECRETSCENE = "Đến Bí Cảnh",
LEAGUE51 = [[Trong thời gian Liên Đấu không thể đuổi thành viên]],
LEAGUE52 = [[Trong thời gian Liên Đấu không thể thoát]],
LEAGUE53 = [[Chưa nhận tư cách đấu vòng này]],
LEAGUE54 = [[Chưa đến thời gian thi đấu, không thể chiến đấu]],
LEAGUE55 = [[Số người trong phòng chưa đủ 3 người, không thể khai chiến]],
VOICE_CHAT_STOP = "Bạn đã cấm chat voice, có thể mở trong thiết lập",
LEAGUE56 = [[Đội tối đa 4 người, đừng tham quá nhé]],
LEAGUE57 = [[Thiết lập đội phó]],
LEAGUE58 = [[Thiết lập đội viên]],
LEAGUE59 = [[Hủy chuẩn bị]],
ACTIVITY_WINWORDS = "Trận thắng",
LEAGUE_TEAM_SEND_MSG = "Giao diện này không thể chat đội",
BLESS_RULE =
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Huy Chương cầu phúc nhận qua thưởng mục tiêu Thi Đấu, có thể mua ở Tiệm Thi Đấu</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Cầu phúc tốn Huy Chương cầu phúc nhận chúc phúc, Thầy Cầu Phúc cấp càng cao huy chương cầu phúc tốn càng nhiều</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Trong quá trình cầu phúc có xác suất kích hoạt Thầy Cầu Phúc cấp cao hơn, nếu không sẽ khôi phục Thầy Cầu Phúc ban đầu</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Cầu phúc có xác suất nhận Mảnh Cầu Phúc, Mảnh Cầu Phúc có thể vào Tiệm Cầu Phúc mua Cầu Phúc phẩm chất cao</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> Cầu phúc khác nhau tương ứng các thuộc tính khác nhau, đồng thời chỉ được trang bị Cầu Phúc có 1 loại hiệu quả thuộc tính</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="22" P="0"> Cầu phúc có thể tăng cấp thông qua gộp cầu phúc khác, cấp càng cao thuộc tính cầu phúc càng cao</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">7.</T><T C="127,70,26" S="22" P="0"> Cầu phúc có phân biệt phẩm chất, phẩm chất càng cao thuộc tính càng tốt, EXP tăng cấp cũng nhiều hơn</T><BR>20</BR>
]],
LEAGUE60 = [[Kéo tạo mới]],
WELFARE_COMPETE_TEXT6 = "Bắt đầu vòng loại",
UNITY = " đến ",
LEAGUE61 = [[Tên không được chứa khoảng trắng]],
WELFARE_COMPETE_TEXT7 = "Bắt đầu vòng bảng",
WELFARE_COMPETE_TEXT8 = "Bắt đầu Top 16",
WELFARE_COMPETE_TEXT9 = "Bắt đầu Top 8 và chung kết",
CHECKOTHER9 = "Cầu Phúc",
CommunityExplain4 =
[[
<T C="229,105,22" S="22">Sảnh Công Hội</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Căn cứ quản lý Công Hội</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Góp Công Hội có thể nhận danh vọng Công Hội và cống hiến cá nhân</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18"> Có thể tiến hành điều chỉnh, phê duyệt trong Công Hội</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18"> Có thể tăng cấp Công Hội, tăng cấp sẽ tăng giới hạn hội viên, đồng thời mở kiến trúc Công Hội cấp tương ứng</T><BR></BR>
<T C="229,105,22" S="22">Nhiệm vụ Công Hội</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Chủ Hội mỗi ngày có thể phát nhiệm vụ Công Hội</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Tất cả hội viên có thể cùng hoàn thành nhiệm vụ, sau đó nhận thưởng nhiệm vụ</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Mỗi tuần căn cứ theo quỹ Công Hội nhận được qua nhiệm vụ để phát thưởng tương ứng chức vị</T><BR></BR>
<T C="229,105,22" S="22">Vật Tổ Công Hội</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Nơi lễ bái Vật Tổ Công Hội</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Hội viên mỗi ngày có thể lễ bái Vật Tổ nhận BUFF</T><BR></BR>
<T C="229,105,22" S="22">Trường Kỹ Năng</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Hội viên có thể dùng cống hiến bản thân học kỹ năng Công Hội</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Cấp Trường Kỹ Năng càng cao, giới hạn cấp học kỹ năng càng cao</T><BR></BR>
<T C="229,105,22" S="22">Tiệm Công Hội</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Diệt BOSS phó bản Công Hội nhận vật phẩm</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Diệt BOSS phó bản Công Hội nhận Xu Khiêu Chiến để đổi vật phẩm hiếm</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Cấp tiệm càng cao, ưu đãi khi mua vật phẩm càng cao</T><BR></BR>
<T C="229,105,22" S="22">Thành viên Công Hội</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Công Hội Lv1, tổng thành viên 100, chủ hội 1, phó hội 2, trưởng lão 10, tinh anh 20</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Công Hội Lv2, tổng thành viên 110, chủ hội 1, phó hội 2, trưởng lão 11, tinh anh 22</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Công Hội Lv3, tổng thành viên 120, chủ hội 1, phó hội 2, trưởng lão 12, tinh anh 24</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Công Hội Lv4, tổng thành viên 130, chủ hội 1, phó hội 2, trưởng lão 13, tinh anh 26</T><BR></BR>
<T C="127,70,26" S="20">5.</T><T C="127,70,26" S="18">Công Hội Lv5, tổng thành viên 140, chủ hội 1, phó hội 2, trưởng lão 14, tinh anh 28</T><BR></BR>
<T C="127,70,26" S="20">6.</T><T C="127,70,26" S="18">Công Hội Lv6, tổng thành viên 150, chủ hội 1, phó hội 2, trưởng lão 15, tinh anh 30</T><BR></BR>
<T C="127,70,26" S="20">7.</T><T C="127,70,26" S="18">Công Hội Lv7, tổng thành viên 160, chủ hội 1, phó hội 2, trưởng lão 16, tinh anh 32</T><BR></BR>
<T C="127,70,26" S="20">8.</T><T C="127,70,26" S="18">Công Hội Lv8, tổng thành viên 180, chủ hội 1, phó hội 2, trưởng lão 18, tinh anh 36</T><BR></BR>
<T C="127,70,26" S="20">9.</T><T C="127,70,26" S="18">Công Hội Lv9, tổng thành viên 200, chủ hội 1, phó hội 2, trưởng lão 20, tinh anh 40</T><BR></BR>
<T C="127,70,26" S="20">10.</T><T C="127,70,26" S="18">Công Hội Lv10, tổng thành viên 200, chủ hội 1, phó hội 2, trưởng lão 22, tinh anh 44</T><BR></BR>
<T C="127,70,26" S="20">11.</T><T C="127,70,26" S="18">Công Hội Lv11, tổng thành viên 200, chủ hội 1, phó hội 2, trưởng lão 24, tinh anh 48</T><BR></BR>
<T C="127,70,26" S="20">12.</T><T C="127,70,26" S="18">Công Hội Lv12, tổng thành viên 200, chủ hội 1, phó hội 2, trưởng lão 26, tinh anh 52</T><BR></BR>
<T C="127,70,26" S="20">13.</T><T C="127,70,26" S="18"> Công Hội Lv13, tổng thành viên 200, chủ hội 1, phó hội 2, trưởng lão 28, tinh anh 56</T><BR></BR>
<T C="127,70,26" S="20">14.</T><T C="127,70,26" S="18"> Công Hội Lv14, tổng thành viên 200, chủ hội 1, phó hội 2, trưởng lão 30, tinh anh 60</T><BR></BR>
<T C="127,70,26" S="20">15.</T><T C="127,70,26" S="18"> Công Hội Lv15, tổng thành viên 200, chủ hội 1, phó hội 2, trưởng lão 32, tinh anh 64</T><BR></BR>
<T C="229,105,22" S="22">Hướng dẫn chức vụ</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Chủ Hội có thể xét duyệt, bổ nhiệm, sửa tuyên ngôn, tăng cấp Công Hội (Bao gồm kiến trúc), gửi thư, thiết lập Công Hội</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Phó Hội có thể xét duyệt, bổ nhiệm (Thấp hơn chức bản thân), sửa tuyên ngôn, tăng cấp Công Hội (Bao gồm kiến trúc), gửi thư</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18"> Trưởng lão có thể xét duyệt, bổ nhiệm (Thấp hơn chức bản thân), gửi thư</T><BR></BR>
<T C="229,105,22" S="22">Hướng dẫn Thẻ Tháng Công Hội</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Hội viên có thể tặng nhau Thẻ Tháng Công Hội</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Sau khi mua Thẻ Tháng Công Hội, phải mở túi, chọn Thẻ Tháng Công Hội và tặng cho hội viên khác, cũng có thể tặng cho bản thân</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18"> Sau khi mua Thẻ Tháng Công Hội, được nhận ngay một phần Kim Cương. Sau khi tặng, người được tặng sẽ được nhận Phúc Lợi Thẻ Tháng từ nhiệm vụ ngày trong 30 ngày liên tục.</T><BR></BR>
<T C="229,105,22" S="22">Hướng dẫn tố cáo</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Chủ Hội Công Hội rời mạng quá 5 ngày, sẽ kích hoạt tố cáo vào 12h đêm</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Tố cáo sẽ duy trì 24 giờ, thành viên có cống hiến Công Hội hôm đó ＞2000 có thể bỏ phiếu</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Nếu hơn 10 thành viên bỏ phiếu, tức tố cáo thành công, hệ thống sẽ chỉ định 1 thành viên Công Hội làm Chủ Hội mới</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Người chức càng cao càng dễ làm Chủ Hội mới nhưng cần cống hiến tuần này ＞0</T><BR></BR>
]],
SPACE105 = [[Tặng thành công, nhận %d Thể Lực]],
SPACE106 = [[Số lần tặng hoa hôm nay đã hết]],
SPACE107 = [[Một ngày chỉ được tặng người ấy 1 lần]],
MARRY_ROOM_FIND = "Không tìm thấy ID hôn lễ này",
EDIT_MARRY_ID = "Nhấp nhập ID hôn lễ",
NO_FIND_MARRY_TIP = "Nhập ID hôn lễ",
LEAGUE62 = "Đấu bảng vòng %d ",
MARRY_ID = "ID hôn lễ:",
WEDDING_TIP_STATS1 = "Hôn lễ chưa bắt đầu",
WEDDING_TIP_STATS2 = "Hôn lễ đã kết thúc",
ARE_YOU_SURE_DISMISS_THIS_PLAYER1 = "Xác nhận trục xuất %s?\n(Hôm nay còn có thể trục xuất %d người)", 
ARE_YOU_SURE_DISMISS_THIS_PLAYER2 = "Số lần trục xuất thành viên đã hết",
STRENGTENTIP7 = "Ghép lên cấp tốn:",
STRENGTENTIP8 = "Lên cấp tốn:",
LEAGUE63 = "Top 16 vòng %d",
LEAGUE64 = "Top 8 vòng %d",
LEAGUE65 = "Bán kết vòng %d",
LEAGUE66 = "Chung kết vòng %d",
LEAGUE67 = "Đối thủ bỏ cuộc trận này, chiến đội chúng ta chiến thắng",
PRACTICE_TITLE = "Tu Luyện",
NEEDMOREPRACTICE = "Điểm Tu Luyện không đủ",
COMMUNITY_COMPETE = "Lịch thi đấu",
COMMUNITY_TARGET = "Mục tiêu",
COMMUNITY_COMPETE_TEXT1 = "Danh sách Công Hội đi tiếp",
COMMUNITY_COMPETE_TEXT2 = "Báo danh",
COMMUNITY_COMPETE_TEXT3 = "Tổng cống hiến tuần trước",
COMMUNITY_COMPETE_TEXT4 = "Trạng thái",
COMMUNITY_COMPETE_TEXT5 = "Chưa báo danh",
COMMUNITY_COMPETE_TEXT6 = "Đã báo danh",
COMMUNITY_COMPETE_TEXT7 = "Báo danh",
COMMUNITY_COMPETE_TEXT8 = "Thứ %d",
COMMUNITY_COMPETE_TEXT9 = "Nhóm",
COMMUNITY_COMPETE_TEXT10 = "Chia nhóm",
COMMUNITY_COMPETE_TEXT11 = [[<T C="195,171,148" S="20" P="1">Hạng </T><T C="99,255,95" S="20" P="1">%d</T><T C="195,171,148" S="20" P="1"></T>]],
COMMUNITY_COMPETE_TEXT12 = "Đấu bảng",
COMMUNITY_COMPETE_TEXT13 = "Vào phòng",
COMMUNITY_COMPETE_TEXT14 = "%d vào %d",
COMMUNITY_COMPETE_TEXT15 = "Tạm chưa có",
COMMUNITY_COMPETE_TEXT16 = "Chưa bắt đầu",
COMMUNITY_COMPETE_TEXT17 = "Tổng chung kết",
COMMUNITY_COMPETE_TEXT18 = "Chung kết",
COMMUNITY_COMPETE_TEXT19 = "Bán kết",
COMMUNITY_COMPETE_TEXT20 = "Thứ 6 bán kết",
MOUNT_ALL_ADD = "Thuộc tính mỗi thú cưỡi đều là cộng dồn, và trạng thái cưỡi không ảnh hưởng đến lực chiến tăng",
STRENGTENTIP9 = "Số lượng Đá không đủ",
RANK_OPEN_DESC2 = [[<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">(%s đến %s)</T><T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Mở mùa giải kế</T>]],
PVP_LAST_TIME = "Mùa giải %d (%s-%s)",
CAN_BE_GET_REWARD = " nhận thưởng (24:00 mỗi ngày tạo mới)",
RANK_KING_WORSHIP1 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,236,193" S="22" P="0">%s </T><T C="254,167,48" S="22" P="0">%s trước đã Thích</T>]],
RANK_RESULT_KF = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="99,255,95" S="20" P="0" SC="3,111,8" SE="1" SS="4">%s</T>]],
RANK_RESULT_NOKF = [[<T C="99,255,95" S="20" P="0" SC="3,111,8" SE="1" SS="4">%s</T>]],
RANK_FIGHT_PRO = "Thuộc tính Đấu Hạng",
RANK_FIGHT_PRO_DESC = "*Đấu Hạng là dạng thi đấu nghiêng về kỹ thuật, trong cách chơi này thuộc tính nhân vật cân bằng",
GOTO_MARRY = "Đến kết hôn",
MARRY_DISCOUNT = "Trong thời gian hoạt động cử hành hôn lễ, hưởng ưu đãi",
MASTERINFO60 = [[Sư đồ truyền dạy]],
MASTERINFO61 = [[Truyền Dạy]],
MASTERINFO62 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">Sư phụ:</T><BR>8</BR><T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">Sau khi truyền dạy nhận %d sư đức</T><BR>5</BR><T C="99,255,95" S="18" P="1" SC="79,60,48" SS="4" SE="1">(Đệ tử Online càng nhiều, sư đức nhận được càng nhiều, hiện Online %d/%d)</T>]],
MASTERINFO63 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">Đệ tử:</T><BR>8</BR><T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">Online được nhận </T><I Z="1">ui/common/common_icon_exp.png</I><T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">%d</T><BR>5</BR><T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">Rời mạng được nhận </T><I Z="1">ui/common/common_icon_exp.png</I><T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1">%d</T><BR>5</BR><T C="99,255,95" S="18" P="1" SC="79,60,48" SS="4" SE="1">(Cấp sư đức càng cao, EXP đệ tử càng nhiều, hiện tại Lv%d)</T>]],
MASTERINFO64 = [[<T C="255,89,74" S="20" P="1">%s</T><T C="79,60,48" S="20" P="1"> có thể truyền dạy</T>]],
POWER2 = "S.Mạnh: ",
AGILITY2 = "H.Giáp: ",
TIZHI2 = "T.Chất: ",
WNDPRATICE_TIPS_TITLE = "Tổng thuộc tính tu luyện tăng: ",
WNDPRATICE_TIPS_TITLE2 = "Lắc được ngôi sao sẽ được tăng EXP",
PRACTICE_VALUEDESC1  = "Sinh Lực sẽ tăng sinh lực của bạn",
PRACTICE_VALUEDESC2  = "Tấn Công sẽ tăng sát thương của bạn",
PRACTICE_VALUEDESC3  = "Phòng Thủ sẽ tăng khả năng đỡ sát thương",
PRACTICE_VALUEDESC4  = "Thể Chất sẽ tăng hiệu quả giàm sát thương",
PRACTICE_VALUEDESC5  = "Sức Mạnh sẽ tăng sát thương gây ra",
PRACTICE_VALUEDESC6  = "Hộ Giáp sẽ giảm sát thương phải chịu",
MASTERINFO65 = [[Hoàn thành]],
SPOUSE_COPY = "P.Bản vợ chồng",
PRACTICE_USE = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >Tiêu phí trong ngày:</T><I Z ="0.45">ui/common/common_icon_hylqhltb.png</I><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >%d</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >  Được nhận: </T><I P="1">ui/common/common_icon_xl.png</I><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >%d</T>]],
PRACTICE_USE2 = [[<T C="255,227,116" S="18" P="1" >Hôm nay tu luyện lần thứ %d:</T><I P="1">ui/common/common_icon_xl.png</I><T C="255,236,193" S="18" P="1" >%s</T>]],	
MASTERINFO66 = [[<T C="127,70,26" S="20" P="1">Mục tiêu ngày tạo mới </T><T C="255,89,74" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1"> mỗi ngày</T>]],
BAG_FULL = "Túi không đủ chỗ",
LEAGUE68 = [[Thiết lập %s thành đội phó (Quyền mở chiến đấu khi đội trưởng không trong phòng, chỉ được chọn 1 người)]],
LEAGUE69 = [[Hủy chức đội phó của %s)]],
LEAGUE70 = [[ID chiến đội]],
LEAGUE71 = [[Đấu bảng (Bo1): %s]].."\n"..[[Thời gian tham chiến vòng 1: %s]].."\n"..[[Thời gian tham chiến vòng 2: %s]].."\n"..[[Thời gian tham chiến vòng 3: %s]], 
LEAGUE72 = [[Vòng 1/16 (Bo3): %s]].."\n"..[[Thời gian tham chiến trận 1: %s]].."\n"..[[Thời gian tham chiến trận 2: %s]].."\n"..[[Thời gian tham chiến trận 3: %s]], 
LEAGUE73 = [[Vòng 1/8 (Bo3): %s]].."\n"..[[Thời gian tham chiến trận 1: %s]].."\n"..[[Thời gian tham chiến trận 2: %s]].."\n"..[[Thời gian tham chiến trận 3: %s]], 
LEAGUE74 = [[Bán kết (Bo3): %s]].."\n"..[[Thời gian tham chiến trận 1: %s]].."\n"..[[Thời gian tham chiến trận 2: %s]].."\n"..[[Thời gian tham chiến trận 3: %s]], 
LEAGUE75 = [[Chung kết (Bo3): %s]].."\n"..[[Thời gian tham chiến trận 1: %s]].."\n"..[[Thời gian tham chiến trận 2: %s]].."\n"..[[Thời gian tham chiến trận 3: %s]],
LEAGUE76 = [[Lập chiến đội thành công]],
LEAGUE77 = [[ phút sau mới được xin phép]],
LEAGUE78 = [[Xin phép chiến đội thành công]],
LEAGUE79 = [[Đã kiểm duyệt]],
LEAGUE80 = [[Mời khỏi đội thành công]],
LEAGUE81 = [[Vào chiến đội thành công]],
LEAGUE82 = [[Rời khỏi đội thành công]],
LEAGUE83 = [[Mời bạn vào giao diện chiến đội]],
LEAGUE84 = [[ phút sau mới được ghép]],
LEAGUE85 = [[Báo danh Liên Đấu]],
LEAGUE86 = [[Xác nhận báo danh]],
LEAGUE87 = [[Tìm kiếm báo danh]],
LEAGUE88 = [[Điều kiện tìm kiếm]],
LEAGUE89 = [[Tên chiến đội]],
LEAGUE90 = [[Điểm chiến đội]],
LEAGUE91 = [[Tối đa 5 ký tự]],
LEAGUE92 = [[Tuyên ngôn:]],
LEAGUE93 = [[Cần:]],
LEAGUE94 = [[(Tên chiến đội không thể sửa)]],
LEAGUE95 = [[Upload phải qua kiểm duyệt mới được dùng (Kiến nghị kích thước 150*150)]],
LEAGUE96 = [[Đến thi Đấu]],
LEAGUE97 = [[Hạng đội:]],
LEAGUE98 = [[Điểm:]],
LEAGUE99 = [[Duyệt thành viên]],
LEAGUE100 = [[Thành viên:]],
LEAGUE101 = [[Hạng Vòng Loại:]],
LEAGUE102 = [[Chiến tích:]],
LEAGUE103 = [[Tên chiến đội]],
LEAGUE104 = [[ID chiến đội:]],
LEAGUE105 = [[Hướng dẫn lịch thi đấu]],
LEAGUE106 = [[Mời thành viên]],
LEAGUE107 = [[Trạng thái dự bị]],
LEAGUE108 = [[Nhập ID chiến đội]],
LEAGUE109 = [[Hình:]],
LEAGUE110 = [[Chuẩn bị chiến đấu]],
LEAGUE111 = [[Thời gian tham chiến]], 
LEAGUE112 = [[Điểm chiến thắng]], 
LEAGUE113 = [[Điểm thất bại]],
ADVISE_FIGHT = "Lực chiến đội đề cử: ",
COMMUNITY_COMPETE_TEXT21 = 
[[
<T C="127,70,26" S="20" P="0">Quy tắc Công Hội Chiến</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Công Hội Chiến 2 tuần tổ chức 1 lần.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Số lượng Công Hội ≥ Lv2 của máy chủ ≥10 sẽ mở Công Hội Chiến (Kiểm tra lúc 0 giờ Thứ 2 hằng tuần)</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Sau khi mở Công Hội Chiến, tiến hành tranh đoạt tư cách 1 tuần, sau đó theo xếp hạng danh vọng từ cao xuống thấp, Công Hội Top 30 có thể báo danh vào tuần sau.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Tuần thứ 2 công bố xếp hạng (Thứ 2), báo danh (Thứ 3), chọn vào vòng trong và chia nhóm (Thứ 4), lịch thi đấu (Thứ 5-Thứ 7).</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">  Thứ 4 chọn ra Top 16 hạng danh vọng báo danh tuần trước để chia nhóm và công bố.</T><BR></BR>
<T C="229,105,22" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0"> Công Hội Chiến mỗi Công Hội có thể xuất chiến 3 đội 1 lần, mỗi đội tối đa 3 người. Điều kiện: Cấp ≥ 25, vào Công Hội ≥ 48 giờ.</T><BR></BR>
<T C="229,105,22" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0"> Nếu trong đội chưa thiết lập thành viên sẽ không cần đấu, đối thủ trực tiếp vào vòng trong. Nếu 2 đội đều trống, hệ thống sẽ phân thắng thua. Cơ chế 3 trận thắng 2, nếu 2 đội thắng trở lên sẽ vào vòng trong.</T><BR></BR>
]],
CARD_TEXT1 = "Đã thu thập %d Thẻ Bài",
CARD_TEXT2 = "Bộ Thẻ",
CARD_TEXT3 = "Chưa thu thập %d Thẻ Bài",
CARD_TEXT4 = "Còn lại: %d/%d",
CARD_TEXT5 = [[<T C="255,89,74" S="22" P="1" SC="158,0,0" SS="4" SE="1">%s </T><T C="195,171,148" S="22" P="1" SC="79,60,48" SS="4" SE="1"> sau mở Bộ Thẻ</T>]],
CARD_TEXT6 = [[<T C="255,227,116" S="22" P="1">Nhận Phiếu: </T><I Z="0.8" P="1">ui/common/common_icon_emzz.png</I><T C="255,236,193" S="22" P="1">%d-%d</T>]],
CARD_TEXT7 = [[<T C="255,227,116" S="22" P="1">Nhận Thẻ: </T><I Z="1" P="1">%s</I><T C="255,236,193" S="22" P="1">%d-%d</T>]],
CARD_TEXT8 = [[<T C="255,227,116" S="22" P="1">Mở tốn CD: </T><T C="255,236,193" S="22" P="1">%s</T>]],
CARD_TEXT9 = "Có cơ hội nhận các thẻ sau",
CARD_TEXT10 = "Mở Bộ Thẻ",
CARD_TEXT11 = [[<T C="195,171,148" S="22" P="1" SC="79,60,48" SS="4" SE="1">Mỗi ngày </T><T C="255,89,74" S="22" P="1" SC="158,0,0" SS="4" SE="1">%s </T><T C="195,171,148" S="22" P="1" SC="79,60,48" SS="4" SE="1">tạo mới Tiệm</T>]],
CARD_TEXT12 = [[<T C="255,227,116" S="22" P="1"> Tối thiểu gồm Thẻ Tinh Anh: </T><I Z="1" P="1">%s</I><T C="255,236,193" S="22" P="1">%d</T>]],
CARD_TEXT13 = [[<T C="255,227,116" S="22" P="1"> Tối thiểu gồm Thẻ Truyền Kỳ: </T><I Z="1" P="1">%s</I><T C="255,236,193" S="22" P="1">%d</T>]],
CARD_TEXT14 = [[<T C="255,227,116" S="22" P="1" SC="158,0,0" SS="4" SE="1">%s</T><I Z="1" P="1">%s</I><T C="255,236,193" S="22" P="1" SC="158,0,0" SS="4" SE="1">%d</T>]],
MARRY_COPY_COST_LIFE = "(Cần %d)",
MASTERINFO67 = [[Kính biếu]],
MASTERINFO68 = [[Kính biếu thành công]],
MASTERINFO69 = [[Sư phụ online mới được kính biếu]],
MASTERINFO70 = [[Hôm nay đã kính biếu đủ, mai hãy đến tiếp]],
MASTERINFO71 = [[Chờ]],
CARD_TEXT15 = "P.Chất: ",
CARD_TEXT16 = "Số lượng Thẻ Bài không đủ, không thể tăng cấp",
CARD_TEXT17 = "Số lượng phiếu không đủ, không thể tăng cấp",
CARD_TEXT18 = "Hôm nay đã đạt số lượng mở bộ Thẻ",
CARD_TEXT19 = "Đang trong thời gian chờ, dùng %d Kim Cương mở?",
CARD_TEXT20 = "Số lượng phiếu không đủ, không thể mua", 
CARD_TEXT21 = "Thẻ Bài %s đã mở",
CARD_TEXT22 = "Thẻ Bài %s + %d",
MASTERINFO72 = [[<T C="79,60,48" S="20" P="1">Còn %d lần</T>]],
MASTERINFO73 = [[ phút sau có thể truyền dạy]],
MASTERINFO74 = [[Số lần truyền dạy hôm nay đã hết]],
MASTERINFO75 = [[Truyền dạy thành công nhận %d Sư Đức]],
MASTERINFO76 = [[Đang chờ không thể kính biếu]],
MASTERINFO77 = [[Đệ tử hiện chưa online, không thể truyền dạy]],
INV_OBJECT = "Mời nửa kia",
COMMUNITYINFO128 = [[Chủ Hội hôm nay chưa phát nhiệm vụ Công Hội!]],
COMMUNITYINFO129 = [[Nhấp để nhắn tin cho Chủ Hội]],
CARD_TEXT23 = "Thường",
CARD_TEXT24 = "Tinh Anh",
CARD_TEXT25 = "Truyền Kỳ",
CARD_TEXT37 = "Sử Thi",
RANK_RESULT_KF1 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,236,193" S="20" P="0" SC="105,65,46" SE="1" SS="4">%s</T>]],
FOREVER_WELFARE_CARD = "Thẻ Phúc Lợi",
CARD_TEXT26 = "Không có Thẻ Bài đã mở",
RANK_RESULT_NOKF1 = [[<T C="255,236,193" S="20" P="0" SC="105,65,46" SE="1" SS="4">%s</T>]],
CHECKOTHER10 = "Tu luyện",
CARD_TEXT27 = "Mở Túi Thẻ",
CARD_TEXT28 = "Phiếu +%d",
CARD_TEXT29 = "Số liệu Bộ Thẻ bất thường, hãy liên hệ CSKH",
CARD_TEXT30 = "Bộ Thẻ này không rõ nguồn gốc, không thể mở",
CARD_TEXT31 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">Nhấp mở Bộ Thẻ</T>]],
CARD_TEXT32 = "Chờ xong rồi, hãy đi mở thẻ thôi",
CARD_TEXT33 = "Không có Bộ Thẻ, hãy đi càn quét phó bản để lấy nào!",
CARD_TEXT34 = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Vượt ải độ khó Thường, Tinh Anh và phó bản nhóm có thể nhận Bộ Thẻ.</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Mở Bộ Thẻ có thể nhận Thẻ quái vật và Phiếu, dùng kích hoạt, nâng cấp Thẻ Bài.</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Sau khi mở Bộ Thẻ sẽ có CD, cần chờ mới được mở tiếp. Mỗi ngày giới hạn số lần mở Bộ Thẻ.</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Tiệm Thẻ Bài mỗi ngày 0 giờ tạo mới, ngẫu nhiên tạo mới Thẻ Bài khác nhau.</T><BR></BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> Thẻ Bài có 3 loại Thường, Tinh Anh, Truyền Thuyết, rớt ở các phó bản độ khó khác nhau</T><BR></BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="22" P="0"> Ngoài mở Bộ Thẻ và mua ở Tiệm, còn có thể mở túi thẻ, túi thẻ không tốn lần mở, không có CD.</T><BR></BR>
]],
CARD_COUNT1 = "%s không đủ",
LIMITE_BUY_ACTIVITY = "Có thể mua",
LIMITE_BUY_ORIGINPRICE = "Giá gốc",
MASTERINFO78 = [[Ta vừa mới truyền dạy, bạn nhận %d EXP]],
MASTERINFO79 = [[Tôi vừa kính biếu, bạn nhận %d Sư đức]],
GOTO_MULTIPLECOPY = "ĐếnNhómĐội",
GOTO_ELITE = "ĐếnTinh Anh",
LIMITE_BUY_CURPRICE = "Giá",
LIMITE_BUY_SOLDOUT = "Hết",
PETSKILL1 = "Kỹ năng 1",
PETSKILL2 = "Kỹ năng 2",
PETSKILL3 = "Kỹ năng 3",
PETSKILL4 = "Kỹ năng 4",
PETSKILLDESC1 = "Pet tiến hóa +1 mở lỗ kỹ năng",
PETSKILLDESC2 = "Pet tiến hóa +3 mở lỗ kỹ năng",
PETSKILLDESC3 = "Pet tiến hóa +5 mở lỗ kỹ năng",
PETSKILLDESC4 = "Pet tiến hóa +6 mở lỗ kỹ năng",
PETSKILL_LOCK_ASK = "Không nhắc lại",
PETSKILL_LOCK_ASK2 = "Pet có kỹ năng cao chưa khóa, tiếp tục lĩnh ngộ?",
PETSKILLNUM = "Kỹ năng:",
PETNEEDUPADVANCELEVEL = "Cần Pet tăng bậc +1 trở lên",
PRACTICE_QUICK = "Bỏ qua",
GOTO_PET = "Đến rút",
PRACTICE_QUICK_LV = "VIP2 sẽ mở, tăng cấp VIP ngay?",
WARN_DESC1 = [[<T C="255,236,193" S="12" P="0" SC="138,122,106" SE="1" SS="2">Chú ý giữ gìn sức khỏe  Đề phòng các hành vi lừa đảo  Phòng chống trộm cắp tài khoản  Sắp xếp thời gian chơi game hợp lý</T>]],
WARN_DESC2 = [[<T C="255,236,193" S="12" P="0" SC="138,122,106" SE="1" SS="2">Sản xuất: ZHWYD   Ấn bản: SSTLP   Số đăng ký: XG-2016-1266   ISSN: ISBN978-7-7979-0084-3</T>]],
INPUT_MAX_CHAT = "Nhập tối đa 24 ký tự",

COMMUNITY_COMPETE_TEXT23 = "Đấu vòng 1",
COMMUNITY_COMPETE_TEXT24 = "Đấu vòng 2",
COMMUNITY_COMPETE_TEXT25 = "Đã kết thúc",
COMMONITY_DESC1 = "Mục tiêu Công Hội",
COMMONITY_DESC2 = "Thưởng Công Hội",
COMMONITY_DESC3 = "Tham gia đủ %d trận Công Hội Chiến",
CHARM_SPACE = "Trang Hấp Dẫn",
CHARM_RANK_RELOAD = "Đề cử ngẫu nhiên",
CHARM_RECOMMEND = "BXH tuần",
CHARM_TOTAL_RANK  = "BXH tổng",
RANK_REWARD = "Thưởng hạng",
EVERY_WEEKDAY = "Mỗi chủ nhật ",
CHARM_TIME= "24:00",
CHARM_SEND_REWRAD = " giờ, phát thưởng theo Hạng Hoa Tuần",
CHARM_PLAYER = "Người chơi",
CHARM_ID = "ID",
CHARM_SERVER = "Server",
CHARM_FLOWER_NUM = "Số hoa nhận",
CHARM_MESSAGE = "Thông tin",
SPACE = "Trang cá nhân",
CHARM_ALL = "Tất cả",
CHARM_BOY = "Nam",
CHARM_GIRL = "Nữ",
CHARM_REFRESH = "Tạo mới",
COMMUNITY_COMPETE_TEXT26 = "Phòng không có ai",
FRIENDS_LOCALFRIEND = "Bạn cùng server",
FRIENDS_OTHERFRIEND = "Bạn liên server",
CHARM_RELOAD = "Tạo mới lúc 24 giờ mỗi chủ nhật (Số hoa > %d vào BXH)",
CHARM_RELOAD2 = "Số hoa > %d vào BXH",

INVITE_LEAGUE = "Có thể tham gia Liên Đấu, vào ngay không?",

FRIENDS_NO_OTHERFRIEND = [[Hiện chưa có thông tin bạn liên server]],
FRIENDS_KUAFU = "Liên server",
ATT_ONLINEFRIEND_NULL = [[Chưa có bạn liên server online]],
HAD_ONLINE = "Đã online",
ONLINE_REWRAD = "Nhận thưởng",
CONTINUE_ONLINE = "Tiếp tục online",
LEAGUE_REWARD_TEXT9 = "Chưa được",
MASTERINFO80 = [[Giải thưởng cấp độ hiện tại như sau:]],
COMMONITY_DESC4 = [[<T C="255,236,193" S="18" P="1">%s</T><T C="255,227,116" S="18" P="1"> %s</T>]],
COMMONITY_DESC5 = [[<T C="255,236,193" S="18" P="1">%s</T><T C="233,166,62" S="18" P="1"> %s</T>]],
COMMONITY_DESC6 = [[<T C="255,236,193" S="18" P="1">Tạm chưa có</T>]],
COMMONITY_DESC7 = "Tranh vô địch",
COMMONITY_DESC8 = "Tranh hạng 3",

ATH_DESC12 =
[[
<T C="229,105,22" S="22">Hướng dẫn</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Cấp Thi Đấu sẽ tăng theo Điểm Thi Đấu, Cấp Thi Đấu sẽ có thuộc tính cộng thêm.</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Cấp Thi Đấu dưới Đồng 5 thất bại sẽ không bị trừ Điểm Thi Đấu.</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18"> Các yếu tố ảnh hưởng Điểm Thi Đấu: Số người tham gia, diệt đầu tiên, số tiêu diệt.</T><BR>10</BR>
]],
MEMBER_TEAM = "Chia đội",
COMMUNITY_COMPETE_TEXT27 = "Thành viên phòng Công Hội",
COMMUNITY_COMPETE_TEXT28 = "Hiện đã có %d hội viên vào Công Hội Chiến",
COMMUNITY_COMPETE_TEXT29 = "Hủy tham gia",
COMMUNITY_COMPETE_TEXT30 = "Xem thông tin",
COMMUNITY_COMPETE_TEXT31 = "Nhấp để thiết lập thành viên",
COMMUNITY_COMPETE_TEXT22 = "Nhóm",
COMMUNITYINFO130 = [[Bổ nhiệm]],
COMMONITY_DESC9 = "Quyết đấu",
COMMONITY_DESC10 = [[<T C="255,89,74" S="20" P="1">%s</T><T C="127,70,26" S="22" P="1">Bắt đầu</T>]],
COMMUNITYINFO131 = [[Số lượng %s cấp Công Hội hiện tại có thể bổ nhiệm:]],
COMMUNITYINFO132 = [[Xác nhận bổ nhiệm]],
COMMONITY_DESC11 = "Kỳ %d",
COMMUNITYINFO133 = [[Chức này đã bổ nhiệm tối đa]],
COMMUNITYINFO134 = [[Số người được bổ nhiệm chức này vượt giới hạn, hãy chọn lại]],
COMMUNITYINFO135 = [[Trong mục tiêu chọn có hội viên đã thay đổi chức]],
COMMUNITYINFO136 = [[Trong mục tiêu chọn có hội viên đã rời Công Hội]],
COMMUNITYINFO137 = [[Bổ nhiệm thành công]],
CHARM_DES =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> Đề cử ngẫu nhiên chỉ đề cử người chơi đăng kèm ảnh</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> Hình upload lên trang cá nhân càng nhiều, càng có cơ hội được đề cử</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> Số hoa nhận trong tuần càng nhiều, càng có cơ hội được đề cử</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> Upload voice lên trang cá nhân sẽ tăng cơ hội được đề cử</T><BR></BR>
]],
COMMYNITY_COMPETE_TEXT32 = "Đội đã đầy, hãy thiết lập lại",
COMMYNITY_COMPETE_TEXT33 = "Chưa thiết lập",
COMMYNITY_COMPETE_TEXT34 = "Đội",
CHARM_RESULT = "Chưa có dữ liệu",  
CHARM_SINGLE = "Độc thân",
CHARM_COMMUNITY = "Công Hội:",
CHARM_NOT_INTO_SPACE = "Trang liên server chưa mở",
CHARM_NO_PLAYER = "Không có người chơi đề cử",
COMMUNITYINFO138 = [[Hội viên được nhận thưởng]],

SPACE108 = [[More>>]],
SPACE109 = [[Đã có thể vào]],
SUREDELFRIEND1 = "Xác nhận xóa bạn?",
COMMYNITY_COMPETE_TEXT35 = "Hủy tham gia",
GAME_ACTIVITY_TITLE1 = "Nạp lần đầu",
GAME_ACTIVITY_TITLE2 = "Nạp Lần Đầu Ngày",
GAME_ACTIVITY_TITLE3 = "Nạp lần đầu hạn giờ",
GAME_ACTIVITY_TITLE4 = "Tích lũy nạp",
GAME_ACTIVITY_TITLE5 = "Hoàn trả nạp",
GAME_ACTIVITY_TITLE6 = "Tích lũy tiêu phí",
GAME_ACTIVITY_TITLE7 = "Đăng nhập giới hạn",
GAME_ACTIVITY_TITLE8 = "Tích lũy đăng nhập",
GAME_ACTIVITY_TITLE9 = "Cường hóa",
GAME_ACTIVITY_TITLE10 = "Thăng Cấp",
GAME_ACTIVITY_TITLE11 = "Tăng lực chiến",
GAME_ACTIVITY_TITLE12 = "Thưởng cấp VIP",
GAME_ACTIVITY_TITLE13 = "Túi Quà Ưu Đãi",
GAME_ACTIVITY_TITLE14 = "Điểm thi đấu",
GAME_ACTIVITY_TITLE15 = "Nạp Mỗi Ngày",
GAME_ACTIVITY_TITLE16 = "Dự Tiệc",
GAME_ACTIVITY_TITLE17 = "Nạp trước CB",
GAME_ACTIVITY_TITLE18 = "Hạng Đua Top",
GAME_ACTIVITY_TITLE19 = "Hạng Thi Đấu",
GAME_ACTIVITY_TITLE20 = "Hạng Lực Chiến",
GAME_ACTIVITY_TITLE21 = "Đồng Tâm Chiến",
GAME_ACTIVITY_TITLE22 = "Công Hội Tác Chiến",
GAME_ACTIVITY_TITLE23 = "Bí Cảnh x2",
GAME_ACTIVITY_TITLE24 = "Đấu Trường x2",
GAME_ACTIVITY_TITLE25 = "Vòng Quay May Mắn",
GAME_ACTIVITY_TITLE26 = "Giảm Giá Hàng Mới",
GAME_ACTIVITY_TITLE27 = "Ưu Đãi Giảm Giá",
GAME_ACTIVITY_TITLE28 = "Giới Hạn Đổi Quà",
GAME_ACTIVITY_TITLE29 = "Tổ Đội x2",
GAME_ACTIVITY_TITLE30 = "Tinh Anh x2",
GAME_ACTIVITY_TITLE31 = "Thưởng Nạp Lần Đầu",
GAME_ACTIVITY_TITLE32 = "Yêu Là Cưới",
GAME_ACTIVITY_TITLE33 = "Ra Mắt Thú Cưng ",
GAME_ACTIVITY_TITLE34 = "Thưởng online",
GAME_ACTIVITY_TITLE35 = "Thưởng Nạp Mỗi Ngày",
GAME_ACTIVITY_TITLE36 = "Husky",
ACTOR_NAME_LV = [[<T C="255,227,116" S="22" P="0">Lv%s</T><T C="255,255,255" S="22" P="0"> %s</T>]],
ACTOR_FIGHT = [[<T C="255,227,116" S="22" P="0">Lực chiến:</T><T C="255,255,255" S="22" P="0">%s</T>]],
TEN_TAKE_OUT = "Rút x10",
ATH_DESC13 = "Hạng Sơ: Cấp Điểm Đối Kháng %d-%d ",
ATH_DESC14 = "Hạng Trung: Cấp Điểm Đối Kháng %d-%d ",
ATH_DESC15 = "Hạng Cao: Cấp Điểm Đối Kháng %d-%d ",
ATH_DESC16 = "Hạng Sơ",
ATH_DESC17 = "Hạng Trung",
ATH_DESC18 = "Hạng Cao",
ATH_DESC19 = [[<T C="127,70,26" S="20" P="1">Hạng: </T><T C="0,72,3" S="20" P="1">Trống</T>]],
ATH_DESC20 = [[<T C="127,70,26" S="20" P="1">Hạng: </T><T C="0,72,3" S="20" P="1">%s</T>]],
ATH_DESC21 = [[<T C="127,70,26" S="20" P="1">Thuộc Hạng Sơ</T>]],
ATH_DESC22 = [[<T C="127,70,26" S="20" P="1">Thuộc Hạng Trung</T>]],
ATH_DESC23 = [[<T C="127,70,26" S="20" P="1">Thuộc Hạng Cao</T>]],
COMMYNITY_COMPETE_TEXT36 = "Chưa đạt Lv%d, không thể thiết lập xuất chiến",
COMMYNITY_COMPETE_TEXT37 = "Vào Công Hội chưa đủ %d giờ, không thể thiết lập xuất chiến",
COMMYNITY_COMPETE_TEXT38 = "Chưa vào mùa đấu mới",
COMMYNITY_COMPETE_TEXT39 = "Mùa đấu chưa mở, không thể xem",

ASCENDING1 = "Chế tạo",
ASCENDING2 = "Đổi phẩm",
ASCENDING3 = "Trước khi chế tạo",
ASCENDING4 = "Xem trước",
ASCENDING5 = "Nguyên liệu",
ASCENDING6 = "Tăng bậc",
ASCENDING7 = "T.Bị Lam",
ASCENDING8 = "Sách Chế Tạo",
ASCENDING9 = "Thánh Quang",
ASCENDING10 = "Sắt",
ASCENDING11 = "Vải",
ASCENDING12 = "Bảo lưu cường hóa, cấp tăng sao",
ASCENDING13 = "Thượng hạ phẩm",
ASCENDING14 = "Phẩm chất mới",
ASCENDING15 = "Phẩm chất cũ",
ASCENDING16 = "Chú ý: Sau khi đổi phẩm thuộc tính bị giảm, bảo lưu thuộc tính trước đó?",
NEARBY = "Người gần",
MALE = "Nam",
WOMAN = "Nữ",
ASCENDING17 = "Trang bị Lam:\nCường hóa +%d, cấp sao +%d có thể chế tạo trang bị Tím",
ASCENDING18 = "Trang bị Tím:\nCường hóa +%d, cấp sao +%d có thể chế tạo trang bị Cam",
COMMYNITY_COMPETE_TEXT40 = "Bắt đầu chuẩn bị",
COMMUNITY_COMPETE_TEXT41 = "Thoát phòng",
COMMUNITY_COMPETE_TEXT42 = " sau tự bắt đầu thi đấu",
COMMUNITY_COMPETE_TEXT43 = "Trống",
COMMUNITY_COMPETE_TEXT44 = "Trống",
ASCENDING19 = "Nguyên liệu không đủ, đến mở Rương Thánh Quang để nhận",
ASCENDING20 = "Chưa có trang bị Cam, hãy đến chế tạo",
COMMONITY_DESC12 = "Tích lũy số lần chiến thắng Công Hội Chiến %d lần",
COMMONITY_DESC13 = "Tích lũy số người diệt ở Công Hội Chiến %d người",
COMMUNITY_COMPETE_TEXT45 = 
[[
<T C="255,236,193" S="20" P="1">Báo danh：</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1">Chủ Hội của Công Hội Top 30 cống hiến có thể báo danh vào Thứ 3.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1">Báo danh tốn 200000 Vàng.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1">Sau khi tất cả Công Hội báo danh xong, sẽ căn cứ theo hạng danh vọng mới tăng của Công Hội báo danh, lấy Công Hội ở Top 16 để chia nhóm.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1">Công Hội nào không được chia nhóm, sẽ hoàn trả phí báo danh cho Chủ Hội qua Thư.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1">16 Công Hội được chọn sẽ chia nhóm ngẫu nhiên, Thứ 5 bắt đầu Công Hội Chiến.</T><BR></BR>
<T C="229,105,22" S="20" P="0">6.</T><T C="255,236,193" S="20" P="1">Thanh viên có tham gia Công Hội Chiến cần đạt 2 điều kiện: Nhân vật ≥ Lv25, vào Công Hội ≥ 48 giờ.</T><BR></BR>
<T C="229,105,22" S="20" P="0">7.</T><T C="255,236,193" S="20" P="1">Công Hội Chiến chia làm 3 đội, do Chủ Hội sắp xếp thành viên.</T><BR></BR>
]],
COMMUNITY_COMPETE_TEXT46 = 
[[
<T C="255,236,193" S="20" P="1">Đấu bảng: </T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1"> Theo nhóm đã chia, sẽ thi đấu vào tối Thứ 5.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1"> Các nhóm sẽ đấu loại căn cứ theo số, thắng vào vòng trong, thua bị loại.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1"> Quy tắc đấu cặp theo số của nhóm, Công Hội 1 VS Công Hội 2, Công Hội 3 VS Công Hội 4.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1"> Phòng Công Hội Chiến sẽ mở vào 20:00 tối thứ 5, sau khi mở có thể vào thiết lập thành viên.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1"> 20:10 tối thứ 5 chính thức thi đấu, trước đó có thể thiết lập thành viên tùy ý.</T><BR></BR>
]],
COMMUNITY_COMPETE_TEXT47 = 
[[
<T C="255,236,193" S="20" P="1">Tứ kết: </T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1"> Tối Thứ 6 thi đấu (Tứ kết).</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1"> Thắng trận đấu tối Thứ 5 sẽ còn thi đấu tiếp.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1"> 2 Công Hội vào vòng trong của các nhóm sẽ đấu với nhau, chọn ra Công Hội đứng đầu nhóm.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1"> Phòng Công Hội Chiến sẽ mở vào 20:00 tối Thứ 6, sau khi mở có thể vào thiết lập thành viên.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1"> 20:00 tối Thứ 6 bắt đầu trận đấu, trước đó có thể thiết lập thành viên tùy ý.</T><BR></BR>
]],
COMMUNITY_COMPETE_TEXT48 = 
[[
<T C="255,236,193" S="20" P="1">Chung kết: </T>
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1"> Tối Thứ 7 thi đấu (Bán kết) và trận tranh Quán Quân, Hạng 3.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1"> Công Hội vào vòng trong còn lại thi đấu (Bán kết) trước, thắng sẽ đấu tiếp trận Quán Quân, thua tranh Hạng 3.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1"> Công Hội nhất nhóm A đấu với Công Hội nhất nhóm B, Công Hội nhất nhóm C đấu với Công Hội nhất nhóm D.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1"> 20:00-20:10 thiết lập thành viên thi đấu (Bán kết), 20:10-20:25 thi đấu.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1">20:30-20:40 thiết lập thành viên tranh Quán Quân, Hạng 3, 20:40-20:55 thi đấu.</T><BR></BR>
]],
COMMUNITY_COMPETE_TEXT49 = 
[[
<T C="255,236,193" S="20" P="1">Phòng đấu bảng: </T>
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1"> Thi Đấu dùng cơ chế 1 trận, sau khi tiêu diệt toàn bộ thành viên đội đối phương xem như chiến thắng.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1"> Khi hết thời gian mà chưa phân định được thắng thua, hệ thống sẽ căn cứ theo tổng tỉ lệ sinh lực của thành viên còn lại 2 bên để quyết định thắng thua.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1"> Nếu vẫn bất phân thắng bại, thì sẽ căn cứ theo hạng danh vọng mới tăng, hạng cao hơn sẽ chiến thắng.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1"> Cuối cùng, căn cứ tổng tỉ số 3 đội của 2 bên phân thắng thua, phe thắng nhiều sẽ giành chiến thắng, được đi tiếp.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1"> 20:00-20:10 có thể tự do thiết lập thành viên, 20:10-20:25 là thời gian thi đấu </T><BR></BR>
]],
COMMUNITY_COMPETE_TEXT50 = 
[[
<T C="255,236,193" S="20" P="1">Phòng tứ kết: </T>
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1"> Thi Đấu dùng cơ chế 1 trận, sau khi tiêu diệt toàn bộ thành viên đội đối phương xem như chiến thắng.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1"> Khi hết thời gian mà chưa phân định được thắng thua, hệ thống sẽ căn cứ theo tổng tỉ lệ sinh lực của thành viên còn lại 2 bên để quyết định thắng thua.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1"> Nếu vẫn bất phân thắng bại, thì sẽ căn cứ theo hạng danh vọng mới tăng, hạng cao hơn sẽ chiến thắng.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1"> Cuối cùng, căn cứ tổng tỉ số 3 đội của 2 bên phân thắng thua, phe thắng nhiều sẽ giành chiến thắng, được đi tiếp.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1"> 20:00-20:10 có thể tự do thiết lập thành viên, 20:10-20:25 là thời gian thi đấu </T><BR></BR>
]],
COMMUNITY_COMPETE_TEXT51 = 
[[
<T C="255,236,193" S="20" P="1">Phòng chung kết: </T>
<T C="229,105,22" S="20" P="0">1.</T><T C="255,236,193" S="20" P="1"> Thi Đấu dùng cơ chế 1 trận, sau khi tiêu diệt toàn bộ thành viên đội đối phương xem như chiến thắng.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="255,236,193" S="20" P="1"> Khi hết thời gian mà chưa phân định được thắng thua, hệ thống sẽ căn cứ theo tổng tỉ lệ sinh lực của thành viên còn lại 2 bên để quyết định thắng thua.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="255,236,193" S="20" P="1"> Nếu vẫn bất phân thắng bại, thì sẽ căn cứ theo hạng danh vọng mới tăng, hạng cao hơn sẽ chiến thắng.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="255,236,193" S="20" P="1"> Cuối cùng, căn cứ tổng tỉ số 3 đội của 2 bên phân thắng thua, phe thắng nhiều sẽ giành chiến thắng, được đi tiếp.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="255,236,193" S="20" P="1"> 20:00-20:10 là thời gian thiết lập thành viên thi đấu (Bán kết), 20:10-20:25 là thời gian thi đấu</T><BR></BR>
<T C="229,105,22" S="20" P="0">6.</T><T C="255,236,193" S="20" P="1"> 20:30-20:40 là thời gian thiết lập thành viên thi đấu tranh Quán Quân, Hạng 3, 20:40-20:55 là thời gian thi đấu.</T><BR></BR>
]],
COMMUNITY_COMPETE_TEXT52 = [[Bạn được thiết lập là trạng thái xuất chiến, rời phòng sẽ hủy trạng thái xuất chiến, đồng ý?]],
COMMUNITY_COMPETE_TEXT53 = "%s mời bạn vào phòng Công Hội Chiến cùng chiến đấu",
ASCENDING21 = "Thuốc Thánh Quang không đủ, mua thêm?",
COMMUNITY_COMPETE_TEXT54 = "Công Hội Chiến đã bắt đầu\nĐợi ghép Công Hội Chiến...",
COMMUNITY_COMPETE_TEXT55 = "Thứ 6 bắt đầu bán kết",
COMMUNITY_COMPETE_TEXT56 = "Không có đối thủ chán quá, thắng quá dễ dàng!",
COMMUNITY_COMPETE_TEXT57 = "Tranh đoạt tư cách vào vòng trong Công Hội Chiến mùa mới!",
COMMONITY_DESC14 = "Không cần đấu",
COMMONITY_DESC15 = "Vòng 1/8",
COMMONITY_DESC16 = "Tứ Kết",
COMMONITY_DESC17 = "Bán Kết",
COMMONITY_DESC18 = "Tranh hạng 3",
COMMONITY_DESC19 = "Tranh vô địch",
COMMONITY_DESC20 = "Thứ 5",
COMMONITY_DESC21 = "Thứ 6",
COMMONITY_DESC22 = "Thứ 7",
COMMUNITYINFO139 = [[Hạng tổng]],
COMMUNITYINFO140 = [[Hạng tuần]],
COMMUNITYINFO141 = [[Hạng Công Hội Chiến kỷ lục:]],
COMMUNITYINFO142 = [[Hạng Công Hội Chiến lần trước:]],
COMMUNITYINFO143 = [[Top 4]],
COMMUNITYINFO144 = [[Danh vọng tuần]],
COMMUNITYINFO145 = [[Danh vọng tuần trước]],
ASCENDING22 = [[Đạo cụ không đủ, không thể mua nhanh]],
COMMUNITY_COMPETE_TEXT58 = "Công Hội Chiến hôm nay đã kết thúc, sẽ tự động rời phòng Công Hội Chiến",
COMMUNITY_COMPETE_TEXT59 = "Tranh tư cách tham gia",
COMMUNITY_COMPETE_TEXT60 = "Đến cùng chiến đấu!",
COMMUNITY_COMPETE_TEXT61 = "Công Hội Lv2 không đủ 10, mở Công Hội Chiến thất bại",
COMMUNITY_COMPETE_TEXT62 = "Công Hội vào vòng trong không đủ, Công Hội Chiến kết thúc",
COMMUNITY_COMPETE_TEXT63 = "Công Hội báo danh không đủ, Công Hội Chiến kết thúc",
COMMONITY_DESC23 = "Tạm không có mục tiêu mới",
ASCENDING23 = [[Trang bị Cam chỉ có thể kế thừa trang bị Cam]],

ASCENDINGEXPLAIN = 
[[
<T C="127,70,26" S="20" P="1">Hệ thống Thánh Quang：</T><BR></BR>
<T C="127,70,26" S="20" P="1">　</T><BR></BR>
<T C="229,105,22" S="20" P="1">Trang bị Lam:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">Trang bị Lam đạt điều kiện cấp cường hóa ≥ 35, cấp sao ≥ 10, có thể chế tạo trang bị Tím.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">Sau khi chế tạo, cấp cường hóa và cấp sao của trang bị Tím nhận được sẽ bị giảm nhất định, trước khi chế tạo có thể dùng ít Kim Cương để bảo lưu.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">Sau khi chế tạo trang bị Lam thành trang bị Tím, không đổi thuộc tính Set.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="1">Chế tạo cần tốn Sách Chế Tạo Tím của bộ phận tương ứng, Thánh Quang Tinh Hoa, Sắt-Thấp, Vải-Thấp, khi mở Rương Thánh Quang có thể nhận các nguyên liệu này.</T><BR></BR>
<T C="127,70,26" S="20" P="1">　</T><BR></BR>
<T C="229,105,22" S="20" P="1">Trang bị Tím:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">Trang bị Tím đạt điều kiện cấp cường hóa ≥ 40, cấp sao = 12, có thể chế tạo trang bị Cam.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">Sau khi chế tạo, trang bị Cam sẽ kế thừa cấp cường hóa lớn hơn Lv40 của trang bị Tím, cấp sao sẽ tạo mới.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">Sau khi chế tạo đồ Tím thành trang bị Cam, không đổi thuộc tính Set.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="1">Chế tạo cần tốn Sách Chế Tạo Cam của bộ phận tương ứng, Tinh Thánh Quang, Sắt-Cao, Vải-Cao, khi mở Rương Thánh Quang có thể nhận các nguyên liệu này.</T><BR></BR>
<T C="127,70,26" S="20" P="1">　</T><BR></BR>
<T C="229,105,22" S="20" P="1">Trang bị Cam:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">Trang bị Cam có phẩm chất, có thể đổi phẩm chất của trang bị thông qua tính năng [Đổi Phẩm] của hệ thống Thánh Quang.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">[Đổi phẩm] cần tốn Sách Chế Tạo Cam của bộ phận tương ứng và Thuốc Thánh Quang.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="1">Trang bị cam chỉ được kế thừa trang bị cam.</T><BR></BR>
<T C="127,70,26" S="20" P="1">　</T><BR></BR>
]],
ASCENDING24 = [[Đề cử]],
COMMUNITY_COMPETE_TEXT64 = "Chưa đến giờ, không chưa thể vào phòng, vui lòng đợi",
MAIL_DOPAY2 = "Thay đối phương trả %s Kim Cương",
INN1 = "Thương Nhân Chợ Đen xuất hiện!!",
INN2 = "Thương Nhân Chợ Đen mang theo nhiều bảo vật, nếu gặp hãy tranh thủ cơ hội!",
INN3 = "Thương Nhân Chợ Đen đã xuất hiện, mau mua nào",
INN4 = "Mở Tiệm",
INN5 = "Vượt phó bản có xác suất gặp Thương Nhân Chợ Đen",
INN6 = "Phó bản nhóm",
INN7 = "Vùng Mạo Hiểm",
INN8 = [[<T C="127,70,26" S="16" P="0">Thương Nhân Chợ Đen sau </T><T C="158,0,0" S="16" P="0">%s</T><T C="127,70,26" S="16" P="0"> rời khỏi</T><BR></BR>
<T C="127,70,26" S="16" P="0">(Sau khi rời khỏi có tỉ lệ gặp lại)</T>]],
INN9 = "Mời khỏi",
INN10 = "Mời Thương Nhân Chợ Đen đi? Mời đi xong Tiệm Chợ Đen sẽ đóng",
INN11 = 
[[
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1"> Vượt Vùng Mạo Hiểm có cơ hội tìm thấy Tiệm</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1"> Càn quét Vùng Mạo Hiểm có cơ hội tìm thấy Tiệm</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1"> Tổ đội vượt phó bản có cơ hội tìm thấy Tiệm</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="1"> Khi Thương Nhân tồn tại sẽ không tìm thấy nữa</T><BR>10</BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="1"> Khi Thương Nhân xuất hiện lại, Tiệm sẽ bày vật phẩm mới</T><BR>10</BR>
]],
INN12 = "Thương Nhân Chợ Đen đã rời khỏi",
PASS_ELITE_SECTION_TIP = "Vượt Tinh Anh của chương để mở",
ASCENDING_FUSE1 = "Ghép",
ASCENDING_FUSE2 = [[<T C="255,89,74" S="22" P="1">(Chọn cầu phúc bên phải để ghép)</T>]],
ASCENDING_FUSE3 = "Chưa ghép",
ASCENDING_FUSE4 = "Đã ghép",
ASCENDING_FUSE5 = "Cầu phúc không đủ điều kiện ghép",
ASCENDING_FUSE6 = "Cầu phúc",
ASCENDING_FUSE7 = [[<T C="255,89,74" S="22" P="1">(Chúc phúc cam chỉ được ghép 1 lần)</T>]],
ASCENDING_FUSE8 = "Đã ghép xong tất cả",
ASCENDING_FUSE9 = "Chưa có chúc phúc đã ghép xong",
ASCENDING_FUSE10 = "(Chưa đạt Lv%d)",
ASCENDING_FUSE11 = "(Thiếu)",
ASCENDING_FUSE12 = "(Đã có)",
ASCENDING_FUSE13 = [[<T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >%s</T><I Z = "0.45">%s</I><T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >%d</T><T C="158,139,121" S="20" P="1" SC="79,60,48" SE="0" SS="4" >(Có  %d)  </T><I Z = "0.45">%s</I><T C="255,227,116" S="22" P="1" SC="79,60,48" SE="1" SS="4" >%d</T><T C="158,139,121" S="20" P="1" SC="79,60,48" SE="0" SS="4" >(Có  %d)</T>]],
ASCENDING_FUSE14 = "Nguyên liệu không đủ",
ASCENDING_FUSE15 = "%s không đủ, mua đạo cụ này không?",
ASCENDING_FUSE16 = "Ghép cầu phúc",
FIXED_REWARD = "Được nhận",
ASCENDING_FUSE17 = "Không thể ghép",
ASCENDING_FUSE18 = "Có thể ghép",
PASS_LEVEL = "Đã vượt ải",
PASS_LEVEL_STAT = "%d sao",
TEN_DRAW = "Rút liên tục %d lần",
BLESS_HOUSE_FULL2 = "Ô cầu phúc đầy, hãy nhặt rồi gọi lại",
GAME_ACTIVITY_TITLE37 = "Tơ Hồng",
DRAW_AGAIN_TEN = "Rút tiếp %d lần",
WELFARE_COMPETE1 = "Giải Trí",
ACTIVITY_HAVED_ATT = "Đã sở hữu %s vĩnh viễn, xác nhận mua lại?",
MELEE_DESC1 = "Hệ thống sẽ ghép 4 kẻ địch có thực lực tương đồng giao chiến, cần diệt 4 người chơi mới có thể chiến thắng, rời khỏi sẽ bị trừ Điểm Thi Đấu",
MELEE_DESC2 = "Tham gia: ",
MELEE_DESC3 = "Chiến thắng: ",
MELEE_DESC4 = "Diệt địch: ",
MELEE_DESC5 = [[<T C="255,227,116" S="22" P="1">%d (%d/%d)</T>]],
MELEE_DESC6 = [[<T C="255,227,116" S="22" P="1">%d (</T><T C="99,255,95" S="22" P="1">%d/%d</T><T C="255,227,116" S="22" P="1">)</T>]],
MELEE_DESC7 = [[<T C="255,227,116" S="22" P="1">%d (Đã hoàn thành)</T>]],
MELEE_DESC8 = "Hướng dẫn: ",
MELEE_DESC9 = "Thưởng hôm nay",
MELEE_DESC10 = "Diệt %d lần",
MELEE_DESC11 = "Chiến tích Loạn Đấu: %d trận, thắng %d, diệt %d",
MELEE_DESC12 = [[<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Chủ nhật 00:00-24:00 mở</T>]],
WELFARE_COMPETE2 = "Chủ Nhật",
WELFARE_COMPETE3 = "Thứ 2",
WELFARE_COMPETE4 = "Thứ 3",
WELFARE_COMPETE5 = "Thứ 4",
WELFARE_COMPETE6 = "Thứ 5",
WELFARE_COMPETE7 = "Thứ 6",
WELFARE_COMPETE8 = "Thứ 7",
GOTO_CALL = "Gọi",

ASCENDING25 = "Pet Tím tiến hóa +%d và cấp trên %d có thể\ntiến hóa thành pet Cam",
ASCENDING26 = "Nhỏ",
ASCENDING27 = "Đang lớn",
ASCENDING28 = "Trưởng thành",
ASCENDING29 = "Hoàn chỉnh",
ASCENDING30 = "Chọn Pet",
PET_STORE_COST_NO_ENOUGH = "Tinh Hoa Pet không đủ, hãy thu hồi Pet để nhận",
PET_STORE_REFRESH_TIMES_LIMIT = "Lần tạo mới không đủ, hãy tăng cấp VIP",

WASHPETGIFT = "Tẩy T.Chất",
GAME_ACTIVITY_TITLE38 = "Nạp liên tục",
CONTINUE_RECHARGE_WORD = "Tiến độ nạp hôm nay",
CONTINUE_RECHARGE_WORD2 = "Hoàn thành nạp %d ngày (%d/%d)",
PETMAXGIFT = "Pet đạt tư chất cao nhất",
ASCENDING31 = "Bồi dưỡng Pet",
BAG3 = "Xóa bạn thân",

ASCENDING32 = "Tạm chưa mở", 
ASCENDING33 = "Đang cập nhật",
ASCENDING34 = "Chọn Pet cần tiến hóa", 
ASCENDING35 = "Pet không đủ",
PETNOOPEN = "Pet chưa mở phẩm chất Cam, đang cập nhật",
PURPLEPET = "Pet Tím",
ORANGEPET = "Pet Cam",
PETNORECOVER = "Tạm chưa có pet thu hồi",
PETNOENOUGHITEM = "Tinh Hoa Pet không đủ, thu hồi Pet có thể nhận",
LOVE_VALUE = "Tình cảm: ",
ZUDUI_ROOM_KF1 = [[<I Z="1">ui/chat/chat_common_icon_kuafu.png</I><T C="255,227,116" S="22" P="0" SC="60,19,12" SE="1" SS="3">%s</T>]],
ZUDUI_ROOM_NOKF = [[<T C="99,255,95" S="22" P="0" SC="60,19,12" SE="1" SS="3" >%s</T>]],
ZUDUI_ROOM_NOKF1 = [[<T C="255,227,116" S="22" P="0" SC="60,19,12" SE="1" SS="3" >%s</T>]],
ASCENDINGEXPLAIN2 = 
[[
<T C="229,105,22" S="20" P="1">Cầu Phúc Cam:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">Cầu Phúc Cam cần ghép 2 Câu Phúc Tím Lv10 có thuộc tính chỉ định, nhận 2 loại Cầu Phúc Cam có 2 thuộc tính</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">Sau khi ghép cấp trở lại là 1, cấp tối đa là 30</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">Ghép sẽ tốn Xu Cầu Phúc</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="1">Không thể mang Cầu Phúc thuộc tính trùng nhau</T>
]],
ASCENDINGEXPLAIN3 = 
[[
<T C="127,70,26" S="20" P="1">Hệ thống Thánh Quang：</T><BR></BR>
<T C="127,70,26" S="20" P="1">　</T><BR></BR>
<T C="229,105,22" S="20" P="1">Pet Cam:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">Pet Tím tiến hóa +4, Cấp ≥45 có thể tiến hóa Pet Cam.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">Sau khi tiến hóa Pet Cam, tư chất và cấp tiến hóa Pet Tím sẽ được kế thừa.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">Sau khi tiến hóa Pet Cam, cấp Pet sẽ suy giảm nhất định.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4.</T><T C="127,70,26" S="20" P="1">Sau khi tiến hóa Pet Cam, tiến hóa Pet không còn giới hạn cấp (Có thể tiến hoa +6 trước).</T><BR></BR>
<T C="229,105,22" S="20" P="0">5.</T><T C="127,70,26" S="20" P="1">Tiến hóa Pet Cam cần tốn Tinh Thánh Quang, 4 Pet tương tự (Chưa tiến hóa, chưa tăng cấp). Thuốc Tiến Hóa và các nguyên liệu khác.</T><BR></BR>
]],
ASCENDING36 = "Số lần mua giới hạn đạo cụ không đủ, không thể mua nhanh",
ASCENDING37 = "Tăng phẩm",
ASCENDING38 = "Tím",
ASCENDING39 = "Lam",
ASCENDING40 = "Lục",
ASCENDING41 = "Trước khi tăng phẩm",
ASCENDING42 = "Sau khi tăng phẩm",
MAX_MOUTH_CARD = "Thẻ Tháng còn hiệu lực trên %d ngày, không cần gia hạn",
ATTACH_EGG_SCORE = "Điểm thưởng:",
TARGET_HURT_HP = "Sát thương SL mục tiêu:",
EGG_SCORE = "Điểm thưởng:",
EXCHANGEEXP_TEXT1 = "Chuyển hóa EXP",
EXCHANGEEXP_TEXT2 = "Chuyển hóa nhanh",
EXCHANGEEXP_TEXT3 = "Chuyển hóa",
EXCHANGEEXP_TEXT4 = "iEXP dư ra hiện tại: %d",
EXCHANGEEXP_TEXT5 = "Chuyển hoa lần %d",
EXCHANGEEXP_TEXT6 = "%s không đủ, không thể chuyển %s",
EXCHANGEEXP_TEXT7 = "Tốn %d%s, nhận %d%s, tiếp tục?",
EXCHANGEEXP_TEXT8 = "Chuyển hóa EXP",
EXCHANGEEXP_TEXT9 = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Khi EXP nhân vật nhận đat giới hạn, sẽ bảo lưu EXP dư ra.</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> EXP dư ra được bảo lưu không thể dùng tăng cấp nhân vật.</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Có thể dùng EXP dư ra chuyển thành Điểm Tu Luyện, tiêu hao của mỗi lần sẽ tăng theo số lần chuyển.</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> 0 giờ mỗi ngày tạo mới số lần đổi.</T><BR></BR>
]],
ASCENDING43 = "Đá Tăng Phẩm",
ASCENDING44 = "Thuốc Tăng Sao",
ASCENDING45 = "Thú Cưỡi",
ASCENDING46 = "Nuôi thú cưỡi",
ASCENDING47 = "Chọn thú cưỡi muốn tăng phẩm", 
ASCENDINGEXPLAIN5 = 
[[
<T C="127,70,26" S="20" P="1">Hệ thống Thánh Quang：</T><BR></BR>
<T C="127,70,26" S="20" P="1">　</T><BR></BR>
<T C="229,105,22" S="20" P="1">Thú cưỡi:</T><BR></BR>
<T C="229,105,22" S="20" P="0">1.</T><T C="127,70,26" S="20" P="1">Thú cưỡi có thể tăng phẩm để thay đổi phẩm chất.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2.</T><T C="127,70,26" S="20" P="1">Sau khi tăng phẩm đến Cam, cấp cường hóa tối đa của thú cưỡi +5.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3.</T><T C="127,70,26" S="20" P="1">Tăng phẩm thú cưỡi cần tốn Thuốc Tăng Phẩm Thú, nguyên liệu Thánh Quang, Thuốc Tăng Sao.</T><BR></BR>
]],
ASCENDING48 = "Thú cưỡi Lục tăng sao +%d và cấp trên %d có thể\ntăng phẩm thành thú cưỡi Lam",
ASCENDING49 = "Thú cưỡi Lam tăng sao +%d và cấp trên %d có thể\ntăng phẩm thành thú cưỡi Tím",
ASCENDING50 = "Thú cưỡi Tím tăng sao +%d và cấp trên %d có thể\ntăng phẩm thành thú cưỡi Cam",
STRENGTHEN6 = "Kế thừa đồ Cam chỉ giữ phẩm chất, thuộc tính sẽ ngẫu nhiên, tiếp tục?",
PETEXPFULL = "EXP đã dư ra, hãy tự thao tác gộp Pet",
FYBER_TIP1 = "Phát video có thể nhận thưởng sau",
FYBER_TIP2 = "Còn được nhận thưởng %d lần",
FYBER_TIP3 = "Tải video thất bại, hãy thử lại",
LEAGUE114 = "Giải đấu Anh Hùng mùa 1",
LEAGUE115 = "Chiến đội:",

COPYENTRY_NAME = "Mirya",
COPYENTRY_DIALOG = "Phía trước thật thênh thang, chúc bạn may mắn!~",
FAST_CHAT_1 = "Mọi người mở chat voice!",
FAST_CHAT_2 = "Tập trung kẻ yếu nhất!",
FAST_CHAT_3 = "Cùng tấn công kẻ địch bắn cuối cùng!",
FAST_CHAT_4 = "Chuẩn bị phối hợp đào!",
FAST_CHAT_5 = "Mở khiên để bảo vệ bản thân trước!",
FAST_CHAT_6 = "Chú ý hướng gió!",
FAST_CHAT_7 = "Vị trí không tốt, cần phân tán!",
FAST_CHAT_8 = "Buff sinh lực cho tôi!",
SUMMON_1 = "Rương May Mắn",
SUMMON_2 = "Đập Trứng Vui Vẻ",
SUMMON_3 = "Cầu Phúc Thần Bí",

PVP_HALL_1 = "Trường Huấn Luyện",
PVP_HALL_2 = "Quan chiến",
PVP_HALL_3 = "Tiệm Thi Đấu",
PVP_HALL_4 = "Đối Kháng",
PVP_HALL_5 = "Giải Trí",
PVP_HALL_6 = "Tranh Đua Lực Chiến, Kẻ Mạnh Làm Vua",
PVP_HALL_7 = "Cách Chơi Đa Dạng, Phần Thưởng Phong Phú",
PVP_HALL_8 = "Thực Lực Là Vua, Vinh Dự Tối Thượng",
PVP_HALL_9 = "Đấu Trường",
PVP_HALL_10 = "Ghép phòng",
PVP_HALL_11 = "Tổ đội cùng bạn",
PVP_HALL_12 = "Ghép đơn",
PVP_HALL_13 = "Ngẫu Nhiên",
PVP_HALL_14 = "Đào Hố",
PVP_HALL_15 = "Đội Trưởng",
PVP_HALL_16 = "Đạo Cụ",
PVP_HALL_17 = "Loạn Đấu",
PVP_HALL_18 = "Hồi Sinh",
PVP_HALL_19 = "Không sát thương, chỉ đào hố",
PVP_HALL_20 = "Đội trưởng phải bị tiêu diệt",
PVP_HALL_21 = "Đoạt thì sẽ được",
PVP_HALL_22 = "Ta là bất tử",
PVP_HALL_23 = "Còn 1 lần chiến đấu",
PVP_HALL_24 = "Mở Theo Sự Kiện",
PVP_HALL_25 = [[<T C="255,236,193" S="20" P="0" >Thứ 2</T>]],
PVP_HALL_26 = [[<T C="255,236,193" S="20" P="0" >Thứ 3</T>]],
PVP_HALL_27 = [[<T C="255,236,193" S="20" P="0" >Thứ 4</T>]],
PVP_HALL_28 = [[<T C="255,236,193" S="20" P="0" >Thứ 5</T>]],
PVP_HALL_29 = [[<T C="255,236,193" S="20" P="0" >Thứ 6</T>]],
PVP_HALL_30 = "Giải Trí",
PVP_HALL_31 = [[<T C="255,236,193" S="20" P="0" SC="127,70,26" SE="1" SS="4">Điểm Dũng Sĩ: %d/%d</T>]],
PVP_HALL_32 = [[<T C="255,236,193" S="18" P="0" SC="127,70,26" SE="1" SS="4">Điểm Dũng Sĩ (Đạt %d điểm=%d Sao)</T>]],
PVP_HALL_33 = [[<I Z="1">ui/pvp/event_icon_s1sj_s.png</I><A IMG = "ui/common_num/common_num_jccsz.png" Z ="1" W = "26" H = "44" CHAR = "0">%d</A><I Z="1">ui/pvp/event_icon_s1sj_sj.png</I>]],
PVP_HALL_34 = "Dạng này chưa được mở",
PVP_HALL_35 = [[<T C="255,236,193" S="20" P="0" >Lv%d mở</T>]],
PVP_HALL_36 = "Đối Kháng Tự Do",
PVP_HALL_37 = "Cách Chơi Phong Phú, Niềm Vui Bất Tận",
PVP_HALL_38 = "Xếp Hạng Thực Lực",


BAGTIP5 = [[<T C="255,89,74" S="20" P="0">%d món tăng thêm (</T><T C="255,236,193" S="20" P="0">%d</T><T C="255,89,74" S="20" P="0">/%d)</T>]],
BAGTIP6 = [[<T C="255,89,74" S="20" P="0">%d món tăng thêm (%d/%d)</T>]],
BAGTIP7 = [[Dùng sẽ nhận tất cả thưởng]],
BAGTIP8 = [[Dùng nhận ngẫu nhiên 1 phần thưởng]],
BAGTIP9 = [[Thông tin]],
BAGTIP10 = [[ID người chơi: ]],
BAGTIP11 = [[ID người chơi]],
BAGTIP12 = [[Thành công: ]],
BAGTIP13 = [[Ghép nhanh]],
BAGTIP14 = [[(VIP3 được ghép nhanh)]],
BAGTIP15 = [[Ghép tốn: ]],
BAGTIP16 = [[Chọn cách phối màu]],
BAGTIP17 = [[Dùng nhuộm màu]],
BAGTIP18 = [[Màu gốc]],
BAGTIP19 = [[Biểu Cảm và Cánh không thể nhuộm màu, thời trang quá hạn sẽ trở về màu gốc]],
BAGTIP20 = [[Bắt đầu nhuộm]],
BAGTIP21 = [[Xem trước phối màu]],
BAGTIP22 = [[Trang phục hiện tại có thời trang chưa mua, mua ngay?]],
BAGTIP23 = [[Nhuộm thời trang]],
BAGTIP24 = [[Không có thời trang, không thể nhuộm]],
BAGTIP25 = [[Phối màu]],
BAGTIP26 = [[Thông tin thời trang người chơi]],
BAGTIP27 = [[Hiển thị thời trang hiện tại]],
BAGTIP28 = [[Lực chiến thời trang tối đa:]],
BAGTIP29 = [[Thời trang đã sưu tập]],
BAGTIP30 = [[Tổng lực chiến thời trang:]],
BAGTIP31 = [[Số lượng tóc:]],
BAGTIP32 = [[Số lượng biểu cảm:]],
BAGTIP33 = [[Số lượng trang phục:]],
BAGTIP34 = [[Số lượng cánh:]],
BAGTIP35 = [[Nhận chat riêng]],
BAGTIP36 = [[Đã ẩn (Đăng nhập lần này)]],
BAGTIP37 = [[Hủy ẩn]],
BAGTIP39 = [[Vị trí này chưa có thời trang, mua ngay?]],
BAGTIP38 = [[Chọn thời trang cần nhuộm]],
BAGTIP40 = [[Nhuộm thành công]],
BAGTIP41 = [[Sau]],
BAGTIP42 = [[Màu hiện tại:]],
BAGTIP43 = [[Hiển thị]],
BAGTIP44 = [[Thời trang hiện tại không thể nhuộm]],
BAGTIP45 = [[Không thể nhuộm màu]],
BAGTIP46 = [[Hãy chọn ghép nhanh]],
BAGTIP47 = [[Số lượng thu hồi]],
BAGTIP48 = [[Đặt vào]],
BAGTIP49 = "Nhập số lượng",

CHALLENGEENTRANCE_TITLE = "Khiêu chiến",
CHALLENGEENTRANCE_TEXT1 = "Tháp Thí Luyện",
CHALLENGEENTRANCE_TEXT2 = "BOSS Thế Giới",

COMMUNITYINFO146 = [[Tố cáo]],
COMMUNITYINFO147 = [[Đang chờ tố cáo, xin hãy đợi!]],
COMMUNITYINFO148 = [[<T C="79,60,48" S="22" P="0">Chủ hội </T><T C="1,72,4" S="22" P="0">%s</T><T C="79,60,48" S="22" P="0"> đã rời mạng </T><T C="1,72,4" S="22" P="0">%s</T><T C="79,60,48" S="22" P="0"> ngày, muốn tố cáo?</T>]],
COMMUNITYINFO149 = [[Số người tố cáo:]],
COMMUNITYINFO150 = [[Cống hiến trong ngày ≥2000 có thể tố cáo]],
COMMUNITYINFO151 = [[Đã tố cáo]],
VIP_TIP09 = [[Quà]],
VIP_TIP10 = [[Phúc Lợi tuần]],
VIP_TIP11 = [[(Gửi qua thư trong 1 lần)]],
VIP_TIP12 = [[(Gửi qua thư vào mỗi thứ 2)]],
EQUIP_THE_SAME_ATT = "Xung đột với Châu Cầu Phúc trên người",
FYBER_REWARD = "Thưởng quảng cáo",
PETSKILL_DES = 
[[
<T C="127,70,26" S="20" P="0">Quy tắc Lĩnh Ngộ</T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0"> Pet tăng bậc đến +1, +3, +5, +6 lần lượt mở 1 ô kỹ năng Pet.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0"> Lĩnh ngộ có thể ngẫu nhiên thay đổi kỹ năng Pet.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0"> Mỗi lần lĩnh ngộ tốn 1 Sách Lĩnh Ngộ.</T><BR></BR>
<T C="229,105,22" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0"> Nếu có kỹ năng muốn giữ lại có thể chọn khóa hoàn toàn để khóa.</T><BR></BR>
<T C="229,105,22" S="20" P="0">5. </T><T C="127,70,26" S="20" P="0"> Sau khi khóa hoàn toàn, mỗi lần lĩnh ngộ sẽ tốn thêm Đá Khóa Skill, số lượng tương đương với số lượng kỹ năng khóa.</T><BR></BR>
<T C="229,105,22" S="20" P="0">6. </T><T C="127,70,26" S="20" P="0"> Nếu có loại kỹ năng muốn giữ lại, nhưng muốn thay đổi cấp có thể chọn Khóa loại để khóa.</T><BR></BR>
<T C="229,105,22" S="20" P="0">7.</T><T C="127,70,26" S="20" P="0"> Sau khi khóa loại, mỗi lần lĩnh ngộ sẽ tốn thêm Đá Khóa Sao, số lượng tương đương với số lượng kỹ năng khóa đã chọn.</T><BR></BR>
]],

BUYACTIVITY_RETURN = [[<T C="255,255,255" S="22" P="1" SC="105,65,46" SS="4" SE="1">Tốn </T><I Z="0.45" P="1">%s</I><T C="255,255,255" S="22" P="1" SC="105,65,46" SS="4" SE="1">%d/%d   Hoàn trả %d</T><I Z="0.45" P="1">%s</I>]],
TEACH_170 = "Nhấn đến Mạo Hiểm-Đơn",
TEACH_171 = "Nhấn đến Đấu Tự Do",
TEACH_172 = "Nhấn mở Rương May Mắn",
TEACH_173 = "Nhấn đến phó bản nhóm",
TEACH_174 = "Nhấn đến Bí Cảnh Mạo Hiểm",
TEACH_175 = "Nhấn vào Tháp Thí Luyện",
TEACH_176 = "Nhấn khiêu chiến BOSS Thế Giới",
TEACH_177 = "Nhấn mở lối triệu hồi",
TEACH_178 = "Chọn thẻ",

WORLDBOSS_TITLE = "BOSS Thế Giới",

FRIENDS_TEXT1 = "Tìm kiếm",
FRIENDS_TEXT2 = "Server",
FRIENDS_TEXT3 = "Xin kết bạn",
FRIENDS_TEXT4 = "Mời bạn thân",
FRIENDS_TEXT5 = "Tặng Thể Lực",
FRIENDS_TEXT6 = "Số bạn thân",
FRIENDS_TEXT6 = "Số bạn thân",
FRIENDS_TEXT7 = "Đồng ý nhanh",
FRIENDS_TEXT8 = "Từ chối nhanh",
FRIENDS_TEXT9 = "Chỉ thiết lập nhắc online đối với bạn trong server",
FRIENDS_TEXT10 = "Đã thiết lập số lượng nhắc online",
FRIENDS_TEXT11 = "Làm Đệ Tử",
FRIENDS_TEXT12 = "Làm Sư Phụ",

FRIENDS_TEXT13 = 
[[
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">1.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Từ Lv10-24 chưa có quan hệ sư đồ có thể bái sư</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">2.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Người được bái sư cần ≥ Lv25 và chưa đủ đệ tử</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">3.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Đệ tử Lv25 tự xuất sư, sau khi xuất sư 2 bên sư đồ nhận quà xuất sư</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">4.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Đệ tử có thể nhận BUFF Sư Môn, cấp sư đức sư phụ càng cao hiệu quả BUFF càng cao</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">5.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Sau khi làm đệ tử sẽ có nhiệm vụ và mục tiêu sư đồ, hoàn thành nhận nhiều EXP</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">6.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Sau khi làm đệ tử, được sư phụ truyền dạy sẽ nhận nhiều EXP</T><BR></BR>
]],
FRIENDS_TEXT14 = 
[[
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">1.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Người Lv25 trở lên và chưa nhận đủ đệ tử</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">2.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Người bái sư phải trên Lv9 và nhỏ hơn Lv25, không có quan hệ sư đồ</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">3.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Sư phụ có thể được tăng thuộc tính từ cấp Sư Đức, cấp sư đức càng cao nhận càng nhiều thuộc tính</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">4.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Đệ tử tốn Thể Lực, sư phụ sẽ nhận Thể Lực</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">5.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Đệ tử lên cấp hoặc kính biếu sư phụ, sư phụ được nhận sư đức.</T><BR></BR>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">5.</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1"> Sau khi làm sư phụ, truyền dạy cho đệ tử sẽ được nhiều sư đức</T><BR></BR>
]],
FRIENDS_TEXT15 = "Đã xuất sư",
FRIENDS_TEXT16 = "Truyền Dạy",
FRIENDS_TEXT17 = "Xem phúc lợi sư đức",
FRIENDS_TEXT18 = "Danh sách xin phép",
FRIENDS_TEXT19 = "Nhận đệ tử",
FRIENDS_TEXT20 = "Đồng môn",
--FRIENDS_TEXT21 = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1">Số người xuất sư sư đức Lv%d: %d</T>]],
FRIENDS_TEXT22 = "Danh sách xuất sư",
FRIENDS_TEXT21 = [[<I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1">Số người xuất sư sư đức Lv%d: %d</T>]],


MULTI_WIN_GOAL1 = "Dễ",
MULTI_WIN_GOAL2 = "Khó",
MULTI_WIN_GOAL3 = "Ác Mộng",
UNCOMPLETE =  "Chưa xong",
Daily_GOAL1_1 = "Sát thương đạt: %d/%d",
Daily_GOAL1_2 = "Số lượt: %d/%d",
Daily_GOAL1_3 = "Đã diệt: %d/%d",
Daily_GOAL1_4 = "Tổng Vàng được thưởng: ",

Daily_GOAL2_1 = "Đã diệt: %d/%d",
Daily_GOAL2_2 = "Sinh lực còn: %d/%d",
Daily_GOAL2_3 = "Đã thoát: %d/%d",
Daily_GOAL2_4 = "Tổng EXP được thưởng: ",

Daily_GOAL3_1 = "Sinh lực còn: %d/%d",
Daily_GOAL3_2 = "Trứng đã đập: %d/%d",
Daily_GOAL3_3 = "Đã diệt: %d/%d",
Daily_GOAL3_4 = "Tổng Trứng Pet được thưởng: ",

BATTLE_HURT_TARGET = "Mục tiêu sát thương: ",
BATTLE_KILL_COPPER_MONSTER = "Đã diệt: ",
BATTLE_KILL_NUM = "Đã diệt: ",
BATTLE_REMAIN_HP_PRE = "Sinh lực còn: ",
BATTLE_RUN_NUM = "Đã thoát: ",
BATTLE_PET_EGG_NUM = "Trứng đã đập: ",
BATTLE_KILL_MONSTER = "Đã diệt: ",

COMMUNITYINFO152 = [[Xin vào]],
COMMUNITYINFO153 = [[Sảnh]],
COMMUNITYINFO154 = [[Tăng Cấp]],
COMMUNITYINFO155 = [[Quản Lý]],
COMMUNITYINFO156 = [[Thiết Lập]],
COMMUNITYINFO157 = [[Cống hiến Thể Lực trong ngày: ]],
COMMUNITYINFO158 = [[Quảng Trường Công Hội]],
COMMUNITYINFO159 = [[Phó bản Công Hội]],
COMMUNITYINFO160 = [[Thông Báo Công Hội Chiến]],
COMMUNITYINFO161 = [[Đang diễn ra Công Hội Chiến]],
COMMUNITYINFO162 = [[Người chơi/Cấp/Chức]],
COMMUNITYINFO163 = [[Tăng cấp Sảnh Công Hội sẽ trở nên mạnh hơn, chứa càng nhiều người và được càng nhiều phúc lợi.]],
COMMUNITYINFO164 = [[Tăng cấp Vật Tổ Công Hội, người lễ bái nhận được lực chiến mạnh hơn]],
COMMUNITYINFO165 = [[Sau khi tăng cấp Trường Công Hội có thể dùng cống hiến tăng cấp kỹ năng Công Hội]],
COMMUNITYINFO166 = [[Tăng cấp Tiệm Công Hội nhận thêm càng nhiều ưu đãi]],
COMMUNITYINFO167 = [[Sảnh Công Hội]],
COMMUNITYINFO168 = [[Trường Công Hội]],
COMMUNITYINFO169 = [[Mở khóa Sảnh Công Hội Lv%d]],
COMMUNITYINFO170 = [[Đã đạt cấp tối đa]],
COMMUNITYINFO171 = [[Thành viên: ]],
COMMUNITYINFO172 = [[Tố cáo Chủ Hội]],
COMMUNITYINFO173 = [[Trục xuất thành viên]],
COMMUNITYINFO174 = [[Xem cống hiến]],
COMMUNITYINFO175 = [[Bổ nhiệm 1]],
COMMUNITYINFO176 = [[Danh sách xin phép 1]],
COMMUNITYINFO177 = [[Thư nhóm]],
COMMUNITYINFO178 = [[Thiết lập cơ bản]],
COMMUNITYINFO179 = [[Tên Công Hội: ]],
COMMUNITYINFO180 = [[Điều kiện xin phép: ]],
COMMUNITYINFO181 = [[Cấp bậc trở lên,]],
COMMUNITYINFO182 = [[Duyệt]],
COMMUNITYINFO183 = [[Thông báo Công Hội (Nội bộ)]],
COMMUNITYINFO184 = [[Tuyên ngôn Công Hội (Nội bộ)]],
COMMUNITYINFO185 = [[Góp Kim Cương-Cao]],
COMMUNITYINFO186 = [[Góp Kim Cương]],
COMMUNITYINFO187 = [[Góp Vàng]],
COMMUNITYINFO188 = [[Công Hội tăng %d danh vọng]],
COMMUNITYINFO189 = [[Cá nhân tăng %d cống hiến]],
COMMUNITYINFO190 = [[Nhiệm vụ]],
COMMUNITYINFO191 = [[Quỹ]],
COMMUNITYINFO192 = [[Quỹ Tuần]],

WNDCHECKOTHER50 = "Thay đổi vũ khí",
FRIENT_CHAT = "Liên hệ gần đây",
ASSISTANT2 = "Trợ thủ",

WORLD_LEVEL_WEEK = "Điểm Tuần",
WORLD_LEVEL = "Bảng Điểm",
HISTORY_WEEK_RANKG = "Nhật Ký Điểm Tuần",
RANGK_REWARD = "Thưởng BXH",
			   
COMMUNITY_UPDATE_TIP = [[Trường Kỹ Năng Công Hội Lv%d, kỹ năng được tăng tối đa đến Lv%d]],
SECRETSCENE = "Bí Cảnh",

COMMUNITYINFO193 = [[Danh sách Công Hội]],
COMMUNITYINFO194 = [[Công Hội đề cử]],
COMMUNITYINFO195 = [[Cấp/Công Hội/ID]],
COMMUNITYINFO196 = [[Số người]],
COMMUNITYINFO197 = [[Giới hạn]],
COMMUNITYINFO198 = [[Tuyên ngôn Công Hội]],


BAG4 = "Thời Trang",
BAG5 = "Cầu Phúc",
BAG6 = "Danh Hiệu",
BAG7 = "Pet",
BAG8 = "Thú Cưỡi",
BAG9 = "Thay đổi",
BAG10 = "Nuôi Dưỡng",
BAG11 = "Xem kỹ năng",
BAG12 = "Thuộc tính nhân vật",
BAG13 = "Thuộc tính thời trang",
BAG14 = "Thời trang lực chiến cao nhất",
BAG15 = "Thu thập thuộc tính thời trang",
BAG16 = "Lực chiến thời trang:",
BAG17 = "Quá hạn",
BAG18 = "Nhuộm",
BAG19 = "Quà",

COMMUNITYINFO199 = [[Số người xin phép:]],
COMMUNITYINFO200 = [[Thành viên:]],
COMMUNITYINFO201 = [[Người chơi/Cấp/Lực chiến]],
COMMUNITYINFO202 = [[Cấp thi đấu]],
COMMUNITYINFO203 = [[Cấp bậc]],
COMMUNITYINFO204 = [[Lời nhắn]],




TASK_TEXT1 = "Trưởng Thành",
TASK_TEXT2 = "Mạnh Hơn",
TASK_TEXT3 = "Tài Nguyên",
TASK_TEXT4 = "Lv%d kích hoạt nhiệm vụ",
TASK_TEXT5 = "Thành Tựu Lv%d",
TASK_TEXT6 = "Thuộc tính cấp thành tựu tăng: ",
TASK_TEXT7 = "Hạng Toàn Server",
TASK_TEXT8 = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Năng động: </T><T C="99,255,95" S="22" P="1" SC="0,72,3" SS="4" SE="1">%d</T>]],
TASK_TEXT9 = "Thưởng Lv%d",
TASK_TEXT10 = "Nhiệm vụ Lv%d",
TASK_TEXT11 = "Mở tính năng Lv%d",
TASK_TEXT12 = "Mỗi Ngày",
TASK_TEXT13 = "Chính Tuyến",
TASK_TEXT14 = "Thành Tựu",
TASK_TEXT15 = "Cấp này không mở thêm tính năng",
TASK_TEXT16 = "Cấp này không được thưởng tăng cấp",
TASK_TEXT17 = "Cấp này không có nhiệm vụ",

STRENGTEN1 = "Cường Hóa",
STRENGTEN2 = "Tăng Sao",
STRENGTEN3 = "Khảm",
STRENGTEN4 = "Đổi Phẩm",
STRENGTEN5 = "Rèn",

STRENGTEN6 = "Cường hóa 5 lần",

RULE = "Quy tắc",
COMMUNITY_STORE = "Tiệm Công Hội",
PET_STORE = "Tiệm Pet",
REFRESH_COUNT = "Số lần tạo mới",

AUTO_REFRESH_COUNT_DOWN = "Tự tạo mới còn",

EVERYDAY_REFRESH_TIME = "(Tạo mới vào %s giờ mỗi ngày)",

EVERYDAY_REFRESH_TIME2 = "(Tạo mới vào %s giờ, %s giờ, %s giờ, %s giờ mỗi ngày)",


NEW_SHOP_1 = "Ngẫu nhiên",
NEW_SHOP_2 = "Khôi phục",
NEW_SHOP_3 = [[<T C="255,236,193" S="26" P="0" SC="79,60,48" SE="1" SS="4">Mặc thử: %d món</T>]],
NEW_SHOP_4 = "Đề Cử",
NEW_SHOP_5 = "Đạo Cụ",
NEW_SHOP_6 = "Mua Giới Hạn",
NEW_SHOP_7 = "Tặng",
NEW_SHOP_8 = "Bán Chạy",
NEW_SHOP_9 = "Tân Thủ",
NEW_SHOP_10 = [[<I Z="0.5" P="2">%s</I><T C="99,255,96" S="18" P="1" SC="0,72,3" SE="1" SS="4">%d</T>]],
NEW_SHOP_11 = "Thử",

COST_ITEM_NOTENOUGH = "Đạo cụ %s không đủ, tạo mới thất bại!",
ASSISTANT = "Hỗ Trợ",
TACTICS = "Chiến Thuật",
WEAPON_LIST = "Danh sách vũ khí",
OBTAIN = "Nhận",

FINISH_ACHIEVEMENT_TIPS = "Xong thành tựu có thể nhận thêm điểm kỹ năng thành tựu",
PETRECOVERNUM = "Đã chọn thu hồi:",
PET_REFRESH_COST = [[<T S="24" C="127,70,26" P="1">Dùng %d Tinh Hoa Pet tạo mới Tiệm?</T><BR></BR><BL>48</BL><T S="24" C="127,70,26" P="1"> (Đã tạo mới %d lần)</T>]],
GAME_ACTIVITY_TITLE39 = "Tiệm Chợ Đen",

CALL_TEXT1 = "Trang Bị",
CALL_TEXT2 = "Pet",
CALL_TEXT3 = "Cầu Phúc",
CALL_TEXT4 = "Đã được trải nghiệm cảm giác tiêu tiền như nước!",
CALL_TEXT5 = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1"></T><T C="99,255,95" S="22" P="1" SC="127,70,26" SS="4" SE="1">%d</T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1"> lần nữa được ngay </T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Đồ Tím</T>]],
CALL_TEXT6 = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Lần này được ngay </T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Đồ Tím</T>]],
CALL_TEXT7 = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Có cơ hội nhận </T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Đồ Tím</T>]],
CALL_TEXT8 = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Rút x10 được ngay </T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">Đồ Tím</T>]],
CALL_TEXT9 = [[<I Z="0.6" P="1">%s</I><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1">%s</T>]],
CALL_TEXT10 = [[<T C="255,89,74" S="22" P="1" SC="127,70,26" SS="4" SE="1">%s</T><T C="255,236,193" S="22" P="1" SC="127,70,26" SS="4" SE="1"> sau được miễn phí</T>]],
CALL_TEXT11 = "Rút x1",
CALL_TEXT12 = "Rút x10",

NEW_MOUNT1 = "Tổng lực chiến: %d",
BAG19 = "Quà",
NEW_MOUNT2 = "Thuộc tính",
NEW_MOUNT3 = "Nuôi Thú Cưỡi",
NEW_MOUNT4 = [[<T C="79,60,48" S="20" P="1">%d</T><I Z="0.65" P="2">ui/common/common_icon_xingxing2.png</I>]],
NEW_MOUNT5 = [[<T C="0,72,3" S="20" P="1">%d</T><I Z="0.65" P="2">ui/common/common_icon_xingxing2.png</I>]],
PUT_SELL_MATERIAL = "Hãy đặt vào vật phẩm muốn thu hồi",
WNDEXPIRED1 = "Thời trang hết hạn",
WNDEXPIRED2 = "Sắp hết hạn",
WNDEXPIRED3 = "Gia hạn hết",
WNDCHECKOTHER1 = "Thông tin",
WNDCHECKOTHER2 = "Chi tiết",
WNDCHECKOTHER3 = "Chiến tích",
WNDCHECKOTHER4 = "Quan hệ",
WNDCHECKOTHER5 = "Sư Đồ",
WNDCHECKOTHER6 = "Trang cá nhân",
WNDCHECKOTHER7 = "Công Hội:",
WNDCHECKOTHER8 = "Bạn đời:",
WNDCHECKOTHER9 = "Giới tính:",
WNDCHECKOTHER10 = "Tuổi:",
WNDCHECKOTHER11 = "Chòm sao:",
WNDCHECKOTHER12 = "Khu vực:",
WNDCHECKOTHER13 = "Voice:",
WNDCHECKOTHER14 = "Biên tập",
WNDCHECKOTHER15 = "Đổi tên",
WNDCHECKOTHER16 = [[<T C="255,227,116" S="22" P="1">Tổng lực chiến  </T><A IMG = "ui/common_num/common_num_zhandouli.png" Z ="0.9" W = "16" H = "26" CHAR = "0" >%d</A>]],
WNDCHECKOTHER17 = "Vợ chồng",
WNDCHECKOTHER18 = "Đồng chí",

FIGHT_COPY = "Phó bản",
FIGHT_COPY_1 = "Mạo Hiểm-Đơn", 
FIGHT_COPY_2 = "Mạo Hiểm-Nhóm",
FIGHT_COPY_3 = "Bí Cảnh",
E_DRAW = "Ác Mộng",

MONSTER = "Quái",

PASS_LEVEL_TAGET = "Mục tiêu vượt ải",
PREPARE_FOR_WAR = "Chuẩn bị chiến",
WNDCHECKOTHER19 = "Số trận: ",
WNDCHECKOTHER20 = "First Blood: ",
WNDCHECKOTHER21 = "Double Kill: ",
WNDCHECKOTHER22 = "Triple Kill: ",
WNDCHECKOTHER23 = "Tỉ lệ thắng: ",
WNDCHECKOTHER24 = "Tỉ lệ diệt: ",
WNDCHECKOTHER25 = "Tỉ lệ đào: ",
WNDCHECKOTHER26 = "Tỉ lệ chính xác: ",
WNDCHECKOTHER27 = "Tỉ lệ tử vong: ",
WNDCHECKOTHER28 = "Toàn bộ thi đấu",

DROP_OUT = "Rơi",

RESERT_TIP = "Số lần khiêu chiến còn 0 mới được tạo mới",

FANPAI = "Lật thẻ",
WNDCHECKOTHER29 = "Đệ tử",
WNDCHECKOTHER30 = "Cấp sư đức: ",
WNDCHECKOTHER31 = "EXP sư đức: ",
WNDCHECKOTHER32 = "Danh hiệu sư đức: ",
WNDCHECKOTHER33 = "Thuộc tính cấp: ",
WNDCHECKOTHER34 = "Nhỏ",
WNDCHECKOTHER35 = "Đang lớn",
WNDCHECKOTHER36 = "Trưởng thành",
WNDCHECKOTHER37 = "Hoàn chỉnh",
WNDCHECKOTHER38 = "Tạm không có quan hệ vợ chồng",
WNDCHECKOTHER39 = "Tạm không có quan hệ đồng chí",
WNDCHECKOTHER40 = "Tình Cảm Lv%d",
WNDCHECKOTHER41 = "Thân mật",
WNDCHECKOTHER42 = "Sư phụ: ",
WNDCHECKOTHER43 = "Sư phụ tăng thêm thuộc tính: ",
WNDCHECKOTHER44 = "Sau Lv25 mới được nhận đệ tử",
WNDCHECKOTHER45 = "Lưu thành công",
WNDCHECKOTHER46 = "Tạm không",
WNDCHECKOTHER47 = "Đệ tử đã xuất sư",
WNDCHECKOTHER48 = "Thay đổi Pet",
WNDCHECKOTHER49 = "Thay đổi thú cưỡi",
FRIENDS_BESTFRIEND = "Thêm bạn thân",
FRIENDS_BESTFRIEND2 = "Thân mật cần đạt ",
FRIENDS_BESTFRIEND3 = "Đã chọn bạn thân",
FRIENDS_BESTFRIEND4 = "Thêm bạn thân thành công",
FRIENDS_BESTFRIEND5 = [[<T C="127,70,26" S="20" P="1">Gửi lời mời bạn thân. (Còn được mời thêm %d)</T>]],
FRIENDS_BESTFRIEND6 = [[<T C="127,70,26" S="20" P="1">Hủy quan hệ bạn thân</T>]],
FRIENDS_BESTFRIEND7 = "Có tối đa %d bạn thân",
FRIENDS_BESTFRIEND8 = "Mời bạn thân",
FRIENDS_BESTFRIEND9 = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Tối đa được thêm 3 bạn thân, bạn thân có hiển thị hiệu quả</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Bạn thân tặng Thể Lực sẽ được x2 thân mật và Thể Lực</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Bạn thân tổ đội chiến đấu được x2 thân mật</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Trở thành bạn thân 2 bên cần đạt 500 thân mật</T><BR></BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> Vợ chồng không thể trở thành bạn thân</T><BR></BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="22" P="0"> Thân mật đạt nhất định sẽ mở danh hiệu đặc biệt</T><BR></BR>
<T C="229,105,22" S="22" P="0">7.</T><T C="127,70,26" S="22" P="0"> Lv30 mới được thêm bạn thân</T><BR></BR>
]],
FRIENDS_BESTFRIEND10 = "Số bạn thân đã đạt tối đa",
FRIENDS_BESTFRIEND11 = "Mời bạn thân thành công",
FRIENDS_BESTFRIEND12 = "Chưa phải là bạn bè!",
FRIENDS_BESTFRIEND13 = "Thân mật chưa đạt điều kiện",
FRIENDS_BESTFRIEND14 = "Quan hệ vợ chồng không thể đổi thành bạn thân",
FRIENDS_BESTFRIEND15 = "Thêm bạn thân thành công",
FRIENDS_BESTFRIEND16 = "Đã từ chối làm bạn thân",
FRIENDS_BESTFRIEND17 = "Hủy quan hệ bạn thân với %s?",
FRIENDS_BESTFRIEND18 = "Hủy quan hệ bạn thân thành công",







BUYACTIVITY_RULE = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Dùng Kim Cương trong tính năng, tiến độ đầy được hoàn trả Kim Cương.</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Mỗi ngày không giới hạn số lần hoàn trả, mua nhiều trả nhiều.</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> 0 giờ mỗi ngày tạo mới tiến độ.</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Mua thể lực, Mèo Chiêu Tài đều được ưu đãi hoàn trả, tiêu phí 2 tính năng khác nhau.</T><BR></BR>
]],


FRIENDS_TEXT23 = [[<T C="255,236,193" S="20" P="1">Tiêu phí trong ngày</T><I Z="0.5" P="1">shopitems/activity.png</I><T C="255,236,193" S="20" P="1">%d Thể Lực, sư phụ nhận </T><I Z="0.5" P="1">shopitems/activity.png</I><T C="255,236,193" S="20" P="1">%d Thể Lực</T>]],

BeStrongBtnNameArrays1 = {"Trang bị","Pet","Thú cưỡi","Cầu phúc","Thẻ Bài","Tu luyện","Ăn thịt"},
BeStrongBtnNameArrays2 = {"Vàng","Kim Cương","Huy Chương Cầu Phúc"},

FIGHT_TARGET = "Mục tiêu",
COMMUNITYINFO205 = [[Người chơi/Cấp/Lực chiến/Chức]],
COMMUNITYINFO206 = [[Cống hiến hôm nay/Cống hiến tuần]],
COMMUNITYINFO207 = [[3 ngày chưa đăng nhập]],
COMMUNITYINFO208 = [[3 ngày chưa cống hiến]],
COMMUNITYINFO209 = [[Ngoài Tinh Anh trở lên]],
COMMUNITYINFO210 = [[Đã hủy:]],
COMMUNITYINFO211 = [[Bỏ chọn]],
COMMUNITYINFO212 = [[Cấp vào Công Hội]],
COMMUNITYINFO213 = [[Cấp Xếp Hạng]],
COMMUNITYINFO214 = [[Duyệt không?]],
COMMUNITYINFO215 = [[Không]],
COMMUNITYINFO216 = [[Không cần]],
COMMUNITYINFO217 = [[8 giờ mỗi tối thứ 5, 6, 7 mở]],
COMMUNITYINFO218 = [[Không có tin nhắn]],
COMMUNITYINFO219 = [[Chờ Chủ Hội lên cấp]],

BAG_TITLE_SHOW = "Không hiện danh hiệu",
SKILL_TXT = "Kỹ năng",
NOT_GOODS_TIP = "Không có vật phẩm",
COMMUNITYINFO228 = [[(Tối đa 16 ký tự)]],
NOT_GOODS_TIP = "Không có vật phẩm",
FRIENDS_TEXT24 = "Không có tin mời bạn thân",
SETTING_TIPS1 = "Code Quà",
SETTING_TIPS2 = "Thêm ý kiến",
WORLDBOSS_MYHURT = [[<T C="255,227,116" S="20" P="1" SC="79,60,48" SS="4" SE="1">Sát thương: </T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">%d (Hạng %d)</T>]],
WEEK_FIGHT_LEVEL = "Bảng Điểm Tuần",
COPY_TIP = "Ta là mỹ nhân",



FRIENDS_TEXT25 = [[<T C="255,255,255" S="22" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]],
FRIENDS_TEXT26 = [[<T C="127,70,26" S="20" P="1"> mời bạn, đồng ý 2 người sẽ trở thành </T><T C="255,89,74" S="20" P="1">%s</T>]],
FRIENDS_TEXT27 = [[<T C="127,70,26" S="20" P="1"> tặng bạn </T><T C="5,180,0" S="20" P="1"> %d</T><I Z="0.45" P="1">%s</I><T C="127,70,26" S="20" P="1">, thân mật 2 người +</T><T C="5,180,0" S="20" P="1"> %d</T><T C="127,70,26" S="20" P="1"></T>]],
FRIENDS_TEXT28 = [[<T C="127,70,26" S="20" P="1"> tặng bạn quà, thân mật 2 người +</T><T C="5,180,0" S="20" P="1"> %d</T><T C="127,70,26" S="20" P="1"></T>]],
FRIENDS_TEXT29 = [[<T C="127,70,26" S="20" P="1"> tặng quà cho người ấy, thân mật 2 người +</T><T C="5,180,0" S="20" P="1"> %d</T><T C="127,70,26" S="20" P="1"></T>]],
FRIENDS_TEXT30 = [[<T C="127,70,26" S="20" P="1"> tặng cho người ấy </T><T C="5,180,0" S="20" P="1"> %d</T><I Z="0.45" P="1">%s</I><T C="127,70,26" S="20" P="1">, thân mật 2 người +</T><T C="5,180,0" S="20" P="1"> %d</T><T C="127,70,26" S="20" P="1"></T>]],
FRIENDS_TEXT31 = [[<T C="127,70,26" S="20" P="1"> cùng bạn chiến đấu, thân mật 2 người +</T><T C="5,180,0" S="20" P="1"> %d</T><T C="127,70,26" S="20" P="1"></T>]],

CURRENT_CHAT_OPEN_LEVEL = "Lv%d mở kênh chat hiện tại",
COLOR_CHAT_OPEN_LEVEL = "Lv%d mở kênh chat màu",
WHISPER_CHAT_OPEN_LEVLE = "Lv%d mở kênh chat riêng",

CHALLENGEENTRANCE_TEXT3 = "Đất Cấm",
CHALLENGEENTRANCE_TEXT4 = "Thành Bóng Đêm",
CHALLENGEENTRANCE_TEXT5 = "Tính năng này chưa mở",

MAIL_SHOP1 = "Xin rương",
MAIL_SHOP2 = "Rương Quà",
MAIL_SHOP3 = "Không nhận yêu cầu",
MAIL_SHOP4 = "Nhật ký tặng",
MAIL_SHOP5 = [[<T C="79,60,48" S="20" P="1" >%s</T><I Z="0.5">shopitems/diamond.png</I><T C="79,60,48" S="20" P="1" >,Tặng cho </T><T C="5,180,0" S="20" P="1" >%s</T>]],
CURRENT_CHAT_OPEN_LEVEL = "Lv%d mở kênh chat hiện tại",
COLOR_CHAT_OPEN_LEVEL = "Lv%d mở kênh chat màu",
WHISPER_CHAT_OPEN_LEVLE = "Lv%d mở kênh chat riêng",
ENTERTAINMENT_MATCH_1 = "Đào Hố",
ENTERTAINMENT_MATCH_2 = "Đội Trưởng",
ENTERTAINMENT_MATCH_3 = "Đạo Cụ",
ENTERTAINMENT_MATCH_4 = "Loạn Đấu",
ENTERTAINMENT_MATCH_5 = "Hồi Sinh",

ROOM_FIGHT_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Ghép đội và đối thủ theo cấp thi đấu người chơi</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Có thể Góp Công Hội, có thể nhận danh vọng Công Hội và Cống hiến cá nhân</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Có thể tiến hành điều chỉnh, phê duyệt trong Công Hội</T><BR>10</BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Có thể tăng cấp Công Hội, tăng cấp sẽ tăng giới hạn hội viên, đồng thời mở kiến trúc Công Hội cấp tương ứng</T><BR>10</BR>
]],

QUALIFYING_FIGHT_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Ghép đội và đối thủ theo cấp bậc người chơi</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Thuộc tính người chơi được điều chỉnh cân bằng, lực thực ngang nhau</T><BR>10</BR>
]],

YULE_FIGHT_RULE1 = 
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Sát thương người chơi vô hiệu, chỉ cần phá địa hình tiêu diệt đối thủ</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Ghép đội và đối thủ theo cấp thi đấu của người chơi</T><BR>10</BR>
]],

YULE_FIGHT_RULE2 = 
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Nếu đội trưởng tử vong chiến đấu thất bại, cần bảo vệ đội trưởng phe mình, tấn công đội trưởng phe địch</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Mỗi lần là 1 thành viên ngẫu nhiên nhận thân phận đội trưởng</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Thuộc tính đội trưởng tăng mạnh</T><BR>10</BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Ghép đội và đối thủ theo cấp thi đấu của người chơi</T><BR>10</BR>
]],


YULE_FIGHT_RULE3 = 
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Tạo mới 3 đạo cụ ngẫu nhiên phân bố trong chiến trường, nhận hiệu quả đạo cụ từ đạn và bay</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Khi 3 đạo cụ được nhặt và tiếp tục lượt kế, sẽ tạo mới 3 đạo cụ mới</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Ghép đội và đối thủ theo cấp thi đấu của người chơi</T><BR>10</BR>
]],

YULE_FIGHT_RULE5 = 
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Đội diệt 4 kẻ địch sẽ thắng</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Trước khi quyết định thắng thua, tử vong được hồi sinh</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Ghép đội và đối thủ theo cấp thi đấu của người chơi</T><BR>10</BR>
]],

ROOM_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Người chơi có thể dùng kỹ năng chỉ định, không bị giới hạn chờ</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Thưởng được nhận 1 lần, khiêu chiến lại không được thưởng</T><BR>10</BR>
]],


ENTERTAINMENT1_TEXT_1 = "",
ENTERTAINMENT1_TEXT_2 = "",
ENTERTAINMENT1_TEXT_3 = "",


ENTERTAINMENT2_TEXT_1 = "",
ENTERTAINMENT2_TEXT_2 = "",
ENTERTAINMENT2_TEXT_3 = "",


ENTERTAINMENT3_TEXT_1 = "",
ENTERTAINMENT3_TEXT_2 = "",
ENTERTAINMENT3_TEXT_3 = "",


ENTERTAINMENT4_TEXT_1 = "",
ENTERTAINMENT4_TEXT_2 = "",
ENTERTAINMENT4_TEXT_3 = "",


ENTERTAINMENT5_TEXT_1 = "",
ENTERTAINMENT5_TEXT_2 = "",
ENTERTAINMENT5_TEXT_3 = "",

--Mời Loạn Đấu (Bạn bè, Công Hội, Sảnh)
ENTERTAINMENT6_TEXT_1 = "",
ENTERTAINMENT6_TEXT_2 = "Hướng dẫn",
ENTERTAINMENT6_TEXT_3 = "Hướng dẫn",

--Mời Hồi Sinh (Bạn bè, Công Hội, Sảnh)
ENTERTAINMENT7_TEXT_1 = "",
ENTERTAINMENT7_TEXT_2 = "",
ENTERTAINMENT7_TEXT_3 = "",


FRIENDS_TEXT32 = [[Không nhận]],
GAMEACTIVITY_NEWTEXT1 = "Hoạt động",
GAMEACTIVITY_NEWTEXT2 = [[<T C="255,227,116" S="22" P="1" SC="128,54,13" SS="4" SE="1">Thời gian: </T><T C="99,255,95" S="22" P="1" SC="0,72,3" SS="4" SE="1">%d giờ %d phút</T>]],
WELFARE_NEWTEXT1 = "Phúc Lợi",
WELFARE_NEWTEXT2 = "Thi Đấu",

BATTLE_ROLE_EXP = "EXP nhân vật",
BATTLE_COPPER = "Xu Thi Đấu",
BATTLE_WEEK_AWARD = "Lợi ích tuần",
BATTLE_WEEK_AWARD_FULL = "Lợi ích tuần đạt tối đa",
BATTLE_HERO_SCORE = "Điểm Dũng Sĩ",
BATTLE_RANK_WINS = "%d liên thắng",
BATTLE_GET_MVP = "Nhận MVP",
BATTLE_RANK_KILL_SCORE = "Đạt %d Kill",
BATTLE_RANK_SCORE_DES = "100 điểm = 1 Sao",
BATTLE_RANK_UPGRADE_TIPS = "Trận này tăng %d Sao",
BATTLE_RANK_UPGRADE_TIPS_II = "Trận này tăng %d Sao và cấp bậc tăng",
BATTLE_RANK_DnGRADE_TIPS = "Trận này giảm %d Sao",
BATTLE_RANK_DnGRADE_TIPS_II = "Trận này giảm %d Sao và cấp bậc giảm",
BATTLE_GET_KILL_ACHIEVE = "Lần %d nhận %d Kill",
BATTLE_GET_VIP_ACHIEVE = "Lần %d nhận VIP",

COMMUNITYINFO220 = "Đã sửa thông báo",
COMMUNITYINFO221 = "Vào cần Lv%d",
COMMUNITYINFO222 = "Cấp bậc %s trở lên",
COMMUNITYINFO223 = "Cấp",
COMMUNITYINFO224 = "Sao",
FRIENDS_TEXT33 = [[Người này từ chối bái sư]],
FRIENDS_TEXT34 = [[Người này từ chối nhận đệ tử]],

PRACTICE_ALL_FIGHTING = "Lực chiến tu luyện",

TOWER_GOAL1_1 = "Thắng sau %d lượt: %d",
TOWER_GOAL1_2 = "Còn %d%% sinh lực: %d%%",
TRY_STRONG_OTHER = "Thử cách dưới xem!",
WNDCHECKOTHER51 = "Độ hoàn thành thông tin",
WNDCHECKOTHER52 = "Không có Pet",
WNDCHECKOTHER53 = "Không có đệ tử đã xuất sư",

COPY_GOAL1_LOSE = "Vượt phó bản",
COPY_GOAL2_LOSE = "Còn %d%% sinh lực: %d%%",
COPY_GOAL3_LOSE = "Thắng sau %d lượt: %d lần",

PVP_RANK_TEXT1 = "Tạo mới thưởng cấp bậc",
PVP_RANK_TEXT2 = [[<T C="79,60,48" S="18" P="1">Mùa giải này </T><T C="158,0,0" S="18" P="1"> %d-%d %d giờ</T><T C="79,60,48" S="18" P="1"> kết thúc</T>]],
PVP_RANK_TEXT3 = [[<T C="79,60,48" S="18" P="1">Cấp bậc: </T><T C="0,72,3" S="18" P="1">Cấp %s%d</T>]],
PVP_RANK_TEXT5 = [[<T C="79,60,48" S="18" P="1">Cấp bậc: </T><T C="0,72,3" S="18" P="1">%s</T>]],
PVP_RANK_TEXT4 = [[<T C="158,0,0" S="22" P="1">(Thắng %d%%)</T>]],

BLESS_AAT_TITLE = "Chúc phúc",
BLESS_AAT_TITLE = "Cầu phúc",

PETGIFT1 = "Hướng dẫn: Tư chất hiện tại ",
PETGIFT2 = " ",
PETGIFT3 = "Thuộc tính chuyển đến nhân vật",

SETTING_POSITION = "Công khai vị trí",
SETTING_MESSAGE = "Cho phép nhắn tin",
ONLINE_STATS_1 = "Bận",
PET_EXTERIOR_DESC = "Tiến hóa +%d mở",
PET_EXTERIOR_MAX = "Hoàn chỉnh",
PET_EXTERIOR_MAX2 = "Tiến hóa Pet Cam mở",
ROOM_INVITE_INFO = "Phó bản nhóm",
ROOM_INVITE_INFO_1 = "Phó bản nhóm 2222",
PVP_RANK_TEXT6 = [[<T C="127,70,26" S="20" P="1" SC="127,70,26" SS="4" SE="0">Hạng 1 mùa giải có thể nhận </T><T C="5,180,0" S="20" P="1" SC="0,72,3" SS="4" SE="0">vũ khí đặc biệt</T>]],
PVP_RANK_TEXT7 = [[<T C="127,70,26" S="20" P="1" SC="127,70,26" SS="4" SE="0">Cấp bậc đạt </T><T C="5,180,0" S="20" P="1" SC="0,72,3" SS="4" SE="0">%s</T><T C="127,70,26" S="20" P="1" SC="127,70,26" SS="4" SE="0"> sẽ nhận thưởng đặc biệt</T><T C="127,70,26" S="18" P="1"> (Chỉ 1 lần)</T>]],

VipRebateDesc = "Nạp đủ %d Kim Cương",

COMMUNITYINFO225 = "Cấp chưa đạt để xin phép",
COMMUNITYINFO226 = "Cấp bậc chưa đạt để xin phép",
COMMUNITYINFO227 = "Muốn tham gia",

GIFT_TITLE = "Mua quà",
GIFT_ITEM = "Gồm quà sau",
BUY_GIFT_NO_COUNT = "Không còn lần mua",
BUY_GIFT_NO_VIP = "Cấp VIP không đủ",
GIFT_PRICE = "Mua %s",
BUY_GIFT_LIMIT1 = [[<T C="138,122,106" S="20" P="0">Còn </T><T C="158,0,0" S="20" P="0">%d</T><T C="138,122,106" S="20" P="0"></T>]],
BUY_GIFT_LIMIT2 = [[<T C="138,122,106" S="20" P="0">Còn </T><T C="158,0,0" S="20" P="0">%d</T><T C="138,122,106" S="20" P="0"></T>]],
BUY_GIFT_LIMIT4 = [[<T C="138,122,106" S="20" P="0">VIP%d có thể mua, còn </T><T C="158,0,0" S="20" P="0">%d</T><T C="138,122,106" S="20" P="0"></T>]],
BUY_GIFT_LIMIT5 = [[<T C="138,122,106" S="20" P="0">VIP%d có thể mua, còn </T><T C="158,0,0" S="20" P="0">%d</T><T C="138,122,106" S="20" P="0"></T>]],
BUY_GIFT_LIMIT6 = [[<T C="138,122,106" S="20" P="0">VIP%d có thể mua</T>]],

LAST_COUNT = "Còn %d",
RANKLIST_HOST = "Chủ nhân: ",
BATTLE_FINAL_AWARD = "Thưởng cuối cùng: ",
MARRY_WEDDING = "Kết hôn",
MY_WEDDING = "Hôn Lễ",
RELIEVE_WEDDING = "Hủy đính hôn",
MARRY = "Kết Hôn",
PLAYAYER_INFO = [[<T C="255,227,116" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s </T><T C="255,255,255" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]],
TIPS10 = [[Thể Lực đã đầy]],
TASKTIP1 = "Có thưởng có thể nhận",
TASKTIP2 = "Có nhiệm vụ đang làm",
TASKTIP3 = "Đã xong",
PLAYAYER_INFO2 = [[<T C="99,255,95" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]],
REDPACK_ATT = "Đến kênh thế giới phát\nkhẩu lệnh sẽ nhận Lì Xì",
REDPACK_ATT2 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1">Còn có thể nhận Lì Xì: </T><T S="20" C="99,255,95" P="1" SC="79,60,48" SS="4" SE="1">%d/%d</T>]],
REDPACK_ATT3 = [[<T C="255,255,255" S="20" P="1" SC="158,0,0" SS="4" SE="1">%s</T><T C="255,255,255" S="20" P="1" SC="158,0,0" SS="4" SE="1"> sau có thể nhận thêm</T>]],
REDPACK_ATT4 = "Nhập ",
GUILD_SKILL_OPEN_TIP = "Công Hội Lv%d mở",

TEAM_BOSS_SIMPLE = "Vượt ải Thường",
TEAM_BOSS_NORMAL = "Vượt ải Khó",
TEAM_BOSS_HARD = "Vượt ải Địa Ngục",
DYEING = "Biểu cảm và cánh không thể nhuộm, thời trang quá hạn sẽ trở về màu gốc",

NEEDSTONE = "Đá không đủ",
BLOCTIPS = "Tính năng này cần cài đặt bản mới nhất",
CHAT_LATELY_PEOPLE = "Liên hệ gần đây",
ASSISTANT2 = "Trợ thủ",
LUCKY_GIFT = "Hộp Quà",
LUCKYGIFT_HASDRAW = "Rút thưởng lần %d",
LUCKYGIFT_FREEDRAW = "%d lần",
LUCKYGIFT_FREE = "Lật thẻ miễn phí còn: ",
LUCKYGIFT_RESET = "Thời gian tạo mới hộp quà: ",
LUCKYGIFT_BOMB = "Rút phải Bomb, hôm nay không thể rút thưởng",
LUCKYGIFT_STARTDRAW = "Lật thẻ",
LUCKYGIFT_DES = 
[[
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hộp Quà May Mắn mỗi ngày tạo mới lúc 24 giờ</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Lật thẻ quà cần tốn Kim Cương, lật thẻ càng nhiều tiêu phí càng nhiều</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Mỗi ngày có số lần lật thẻ quà miễn phí nhất định</T><BR>10</BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Sau khi rút được Thẻ Tỉ Lệ, giá lật thẻ sẽ nhân với số trên Thẻ Tỉ Lệ</T><BR>10</BR>
<T C="127,70,26" S="20">5.</T><T C="127,70,26" S="18">Khi nhận Xu Ban Ân có thể dùng mua vật phẩm trong Cửa Hàng</T><BR>10</BR>
]],
LUCKYGIFT_FINISH = "Đã rút xong",
OnlineReward = "Thưởng online",
TODAY_CHALLENGE_TOTAL = "Số lần khiêu chiến: ",
TODAY_OBTAIN = "Nhận: ",
LUCKY_BOMB = "Rút phải Bomb, hôm nay không thể rút thưởng nữa",

TRAINCAMP_DEC1 = [[<T C="127,70,26" S="20" P="0">Thưởng: </T><T C="5,180,0" S="20" P="0">%s</T>]],
TRAINCAMP_DEC2 = "(Đã nhận)",
TRAINCAMP_DEC3 = "Đã vượt",
ROOMS = "Phòng %s",
COMMUNITY_OPEN_TIP = "Công Hội Lv%d mở",
HURT_BUFFER = "Sát thương +%d",
WEEK_TOTAL_HURT = "Tích lũy sát thương tuần: ",
PASS_RANK ="Xếp hạng vượt ải",
CHALLENGEING = "Đang khiêu chiến",
QUICK_MATCH = "Ghép nhanh",
TRAINCAMP_DEC4 = "Trường Huấn Luyện",
TRAINCAMP_DEC5 = "Vượt độ khó trước mới được khiêu chiến",
TRAINCAMP_DEC6 = "Bay đến mục tiêu %d lần: ",
TRAINCAMP_DEC7 = "Diệt %d quái: ",
TRAINCAMP_DEC8 = "Đánh trúng mục tiêu %d lần: ",
MY_PVPRANK = [[<T C="79,60,48" S="18" P="1">Hạng: </T><T C="0,72,3" S="18" P="1">%s</T>]],
VipRebateDesc1 =
[[
<T C="105,65,46" S="22">Nạp đủ </T>
<T C="255,227,116" S="22" SC="105,65,46" SS="4" SE="1"> %s</T>
<I Z="0.75">ui/common/common_icon_zuanshi.png</I>
]],
VipRebateDesc2 =
[[
<T C="79,60,48" S="20">Cần nạp thêm </T>
<T C="3,111,8" S="20"> %s</T>
<I Z="0.6">ui/common/common_icon_zuanshi.png</I>
<T C="79,60,48" S="20">Lên cấp</T>
<T C="3,111,8" S="20">%s</T>
<T C="79,60,48" S="20">Ồ!</T>
]],
RETURNMONEY = "Hoàn trả",
CARD_SHOP = "Tiệm Thẻ Bài",
EVERYDAY_AUTO_REFRESH = [[<T C="127,70,26" S="16" P="1">Mỗi ngày: </T><T C="158,0,0" S="16" P="1">%s</T><T C="127,70,26" S="16" P="1"> tạo mới Tiệm</T>]],
LOG = "Nhật ký",
COMMUNITY_STORE_DISCOUNT = [[<T C="127,70,26" S="20" P="1">Mua vật phẩm Công Hội với giá</T><T C="158,0,0" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1"></T>]],	
COMMUNITY_SHOP_OWN_COUNT = "Tiệm Công Hội có vật phẩm này là 0",
HEROBLOC = "Câu Lạc Bộ",
PLAYERBACK1 = "Chưa thỏa điều kiện, không thể nhận",
PLAYERBACK2 = "Người quá %d ngày chưa đăng nhập, đăng nhập trong thời gian hoạt động sẽ nhận thưởng",
PLAYERBACK3 = 
[[
<T C="255,227,116" S="22" P="0" SC="79,60,48" SE="1" SS="4">Quy tắc người cũ trở lại</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">1.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  Lv1-20 được nhận Vàng x15000</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">2.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  Lv21-40 được nhận Vàng x15000, Kim Cương x100</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">3.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  Lv41-60 được nhận Vàng x15000, Kim Cương x100, Rương Thánh Quang x10</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">4.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4">  Lv61-70 được nhận Vàng x15000, Kim Cương x100, Rương Thánh Quang x10, Đá Sao-Đỉnh x10</T><BR></BR>
<T C="99,255,95" S="20" P="0" SC="79,60,48" SE="1" SS="4">5.</T><T C="255,236,193" S="20" P="0" SC="79,60,48" SE="1" SS="4"> VIP5 trở lên được nhận thêm Kim Cương x500</T><BR></BR>
]],
PLAYERBACK4 = "Nhận thưởng",
STORAGE_LOG = "Lưu trữ",
COMMUNITY_SHOP_LOG = "Mua",
STORAGE_LOG_TIP = [[<T S="18" C="255,236,193" P="1">Boss</T><T S="18" C="233,166,62" P="1" >%s</T><T S="18" C="255,236,193" P="1"> tử vong, rơi vật phẩm </T><T S="18" C="5,180,0" P="1" >%s</T><T S="18" C="255,236,193" P="1"> đã trữ trong Tiệm Công Hội</T>]], 
COMMUNITY_SHOP_LOG_TIP = [[<T S="18" C="233,166,62" P="1" >%s</T><T S="18" C="255,236,193" P="1"> đã mua </T><T S="18" C="5,180,0" P="1" >%s</T>]],
GUILD_BOSS_FIGHT_COST = "Khiêu chiến tốn: %d",
GUILD_BOSS_DROP = "BOSS có thể rơi đạo cụ sau",
GUILD_BOSS_FIGHTER = "Số người đang khiêu chiến: %d",
GUILD_BOSS_HURT_PRE = "Sát thương tất cả +%d%%",
GUILD_BOSS_INSPIRE_TIPS = "(PS: Sát thương lần này chỉ hiệu lực với BOSS)",
GUILD_BOSS_INSPIRE_PLAYERS = "Người cổ vũ lần này",
GUILD_BOSS_INSPIRE_ALL = "Cổ vũ tất cả",
GUILD_BOSS_INSPIRE_ADD = "Sát thương +%d%%",
GUILD_BOSS_INSPIRE = "Cổ vũ",
GUILD_BOSS_INSPIRE_NUM = "Cổ vũ %d lần",
GUILD_BOSS_INSPIRE_DES = "(PS. Cổ vũ thành công, tất cả thành viên đều được cộng thêm)",
GUILD_BOSS_RAND_FIRST = "Lần đầu vượt toàn SV",
GUILD_BOSS_RAND_FAST = "Nhanh nhất toàn SV",
GUILD_BOSS_PASS_TIME_TITLE = "Thời gian",
GUILD_BOSS_WIN_DESC = [[<T C="255,236,193" S="22" P="0"></T><T C="99,255,95" S="22" P="0"> %s </T><T C="255,236,193" S="22" P="0"> đã diệt BOSS %s</T>]],
GUILD_BOSS_WIN_TITLE1 = "Đánh đòn cuối lên BOSS\nDiệt BOSS!",
GUILD_BOSS_WIN_TITLE2 = "%s đánh đòn cuối lên BOSS\nDiệt BOSS!",
GUILD_BOSS_WIN_TITLE3 = "BOSS chưa bị diệt, hãy cố gắng thêm!",
GUILD_BOSS_WIN_HURT_TITLE = "Chi tiết",
GUILD_BOSS_WIN_HURT = "Gây sát thương",
GUILD_BOSS_WIN_HP_PRE = "BOSS còn lại",
GUILD_BOSS_WIN_HURT_REWARD = "Thưởng sát thương",
GUILD_BOSS_WIN_KILL_REWARD = "Thưởng tiêu diệt",
PVPRANK_MODIFYING = "Đấu Hạng đang điều chỉnh",
PLAYERBACK5 = "Không đạt yêu cầu, không có thưởng",
CURRENT_COPY = "Phó bản hiện tại: ",
SWEEP_TEAM_COPY_DIFF_TIP = "Hãy chọn độ khó: ",
SWEEP_TEAM_COPY_FIGHTING = "Càn quét cần",
SURPLUS_SWEEP_COUNT_LESS = "Số lần càn quét không đủ",
GUILD_BOSS_PASS_TIME = "%02d giờ %02d phút",
GUILD_BOSS_INSPIRE_FULL = "Cổ vũ đã đầy!",
SWEEP_COPY_NOT_TIP = "Phó bản không hỗ trợ càn quét",
SWEEP_COPY_LEVEL_OPEN_TIP = "Lv%d mở càn quét phó bản này",
COMMUNITYWAR_TEXT1 = "Đứng đầu",
COMMUNITYWAR_TEXT2 = "Vào vòng trong",
COMMUNITYWAR_TEXT3 = "Tuần %d",
COMMUNITYWAR_TEXT4 = "Công Hội (Chủ Hội)",
COMMUNITYWAR_TEXT5 = "Lịch thi đấu",
COMMUNITYWAR_TEXT6 = "Hạng Sơ Tuyển",
COMMUNITYWAR_TEXT7 = "Hạng Đối Đầu",
COMMUNITYWAR_TEXT8 = "Quy tắc",
COMMUNITYWAR_TEXT9 = "Quy tắc",
COMMUNITYWAR_TEXT10 = [[<T C="255,227,116" S="20" P="1">Lịch thi đấu bảng </T><T C="255,227,116" S="20" P="1">(%s)</T><T C="255,227,116" S="20" P="1"></T>]],
COMMUNITYWAR_TEXT11 = [[<T C="255,227,116" S="20" P="1">Lịch thi đấu chung kết </T><T C="255,227,116" S="20" P="1">(%s)</T><T C="255,227,116" S="20" P="1"></T>]],
COMMUNITYWAR_TEXT12 = 
[[
<T C="255,89,74" S="20" P="0">1.</T><T C="255,236,193" S="20" P="0"> Thời gian mở: Ngày 1, 3, 5, 7 20h-21h mỗi tháng ghép Công Hội Chiến-Sơ Tuyển.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="255,236,193" S="20" P="0"> Người chơi cùng Công Hội tạo thành đội 3 người, đấu với đội của Công Hội khác.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="255,236,193" S="20" P="0"> Mỗi trận đấu giới hạn 15 phút, hết giờ sẽ do hệ thống phán đoán thắng thua căn cứ số người, sinh lực còn lại của 2 bên.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="255,236,193" S="20" P="0"> Người chơi rời khỏi hoặc rớt mạng sẽ bị trừ điểm.</T><BR></BR>
<T C="255,89,74" S="20" P="0">5.</T><T C="255,236,193" S="20" P="0"> Hệ thống sẽ căn cứ điểm Công Hội Chiến xếp hạng.</T><BR></BR>
<T C="255,89,74" S="20" P="0">6.</T><T C="255,236,193" S="20" P="0"> Hạng Công Hội Chiến-Sơ Tuyển là hạng SV, Công Hội nằm trong Top 4 sẽ có tư cách vào Công Hội Chiến-Đối Đầu.</T><BR></BR>
]],
COMMUNITYWAR_TEXT13 = 
[[
<T C="255,89,74" S="20" P="0">1.</T><T C="255,236,193" S="20" P="0"> Thời gian mở: Ngày 8, 10, 12, 14 20h-21h mỗi tháng ghép Công Hội Chiến-Đối Đầu.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="255,236,193" S="20" P="0"> Người chơi cùng Công Hội tạo thành đội 3 người, đấu với đội của Công Hội khác.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="255,236,193" S="20" P="0"> Mỗi trận đấu giới hạn 15 phút, hết giờ sẽ do hệ thống phán đoán thắng thua căn cứ số người, sinh lực còn lại của 2 bên.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="255,236,193" S="20" P="0"> Người chơi rời khỏi hoặc rớt mạng sẽ bị trừ điểm.</T><BR></BR>
<T C="255,89,74" S="20" P="0">5.</T><T C="255,236,193" S="20" P="0"> Hệ thống sẽ căn cứ điểm Công Hội Chiến xếp hạng.</T><BR></BR>
<T C="255,89,74" S="20" P="0">6.</T><T C="255,236,193" S="20" P="0"> Hạng Công Hội Chiến-Sơ Tuyển là hạng SV, Công Hội nằm trong Top 4 sẽ có tư cách vào Công Hội Chiến-Đối Đầu.</T><BR></BR>
]],
COMMUNITYWAR_TEXT14 = [[<T C="195,171,148" S="20" P="1">Guild: Hạng </T><T C="5,180,0" S="20" P="1">%d</T><T C="195,171,148" S="20" P="1"></T>]],
COMMUNITYWAR_TEXT15 = "Nhìn lại trận đấu",
COMMUNITYWAR_TEXT16 = " sau mở",
COMMUNITYWAR_TEXT17 = "Chưa bắt đầu, xin đợi",
COMMUNITYWAR_TEXT18 = "Cấp không đủ",
COMMUNITYWAR_TEXT19 = "Cấp Công Hội không đủ",
COMMUNITYWAR_TEXT20 = "Thi Đấu đã kết thúc",
COMMUNITYWAR_TEXT21 = "Công Hội chưa vào trận Đối Đầu, lần sau cố gắng hơn!",
COMMUNITYWAR_TEXT22 = "Công Hội đã mất tư cách, lần sau cố gắng hơn!",
COMMUNITYWAR_TEXT23 = "Công Hội Chiến đã kết thúc",
COMMUNITYWAR_TEXT24 = "Ngày %s",
COMMUNITYWAR_TEXT25 = "1, 3, 5, 7 diễn ra Sơ Tuyển",
COMMUNITYWAR_TEXT26 = "8, 10, 12, 14 diễn ra Đối Đầu",
COMMUNITYWAR_TEXT27 = "Đấu Loại đang diễn ra",
COMMUNITYWAR_TEXT28 = "Chung kết đang diễn ra",
COMMUNITYWAR_TEXT29 = "Đang là thời gian nghỉ ngơi...",
COMMUNITYWAR_TEXT30 = "Khai chiến: ",
COMMUNITYWAR_TEXT31 = "Công Hội (Máy chủ)",
COMMUNITYWAR_TEXT32= "Tên (Cấp)",
COMMUNITYWAR_TEXT33 = "Hạng SV",
COMMUNITYWAR_TEXT34 = "Hạng thành viên",
UNIT_PRICE = "Giá",
PASS_HARD_COPY_TIP = "Vượt ải Địa Ngục mới được càn quét",
WEEK_CARD = "Thẻ Tuần",
ENJOY_CARD = "Thẻ Chí Tôn Vĩnh Viễn",
SWEEP_COPY_NOT_ITEM_TIP = "%s không đủ, muốn mua?",
PVPRANK_INVITE_NO_DATA = "Không có dữ liệu phù hợp yêu cầu",
KNOCKOUT1 = "Nhóm A",
KNOCKOUT2 = "Nhóm B",
KNOCKOUT3 = "Nhóm C",
KNOCKOUT4 = "Hiện tại đã có %s thành viên vào Công Hội Chiến",
KNOCKOUT5 = "Công Hội Chiến-Đấu Loại",
KNOCKOUT6 = "Quy tắc",
KNOCKOUT7 = "Tự bắt đầu",
KNOCKOUT8 = "Thành viên",
KNOCKOUT_DESC =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> Quy tắc</T><BR></BR>
]],
KNOCKOUT9 = "Trong phòng",
KNOCKOUT10 = "Chủ Hội hoặc đại diện có thể thiết lập",
SHOUCHONG4 = [[<T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">Đã nạp </T><T C="255,227,116" S="20" P="1" SC="0,0,0" SE="1" SS="4">%s Kim Cương</T><T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">:</T>]],
UNIT_PRICE = "Giá",
PASS_HARD_COPY_TIP = "Vượt ải Địa Ngục mới được càn quét",
WEEK_CARD = "Thẻ Tuần",
ENJOY_CARD = "Thẻ Chí Tôn Vĩnh Viễn",
COMMUNITYWARGIFT_TEXT1 = "Sơ Tuyển",
COMMUNITYWARGIFT_TEXT2 = "Đối Đầu",
COMMUNITYWARGIFT_TEXT3 = "Đấu Loại",
COMMUNITYWARGIFT_TEXT4 = "Thưởng",
COMMUNITYWARGIFT_TEXT6 = "Sau khi kết thúc lịch thi đấu, thưởng được gửi qua thư",
COMMUNITYWARTASK_TEXT1 = "Mục tiêu",
COMMUNITYWARTASK_TEXT2 = "Tham gia",
COMMUNITYWARTASK_TEXT3 = "Kết thúc chung kết, nhật ký sẽ được tạo mới, thưởng chưa nhận được gửi qua thư",
COMMUNITYWARTASK_TEXT4 = "Nhận",
COMMUNITYWARTASK_TEXT5 = "Chiến thắng",
COMMUNITYWARTASK_TEXT6 = "Diệt",
COMMUNITYWARHISTORY_TEXT2 = "Các đời",
COMMUNITYWARHISTORY_TEXT3 = "Lần %s",
COMMUNITYWARHISTORY_NUMBER = {
"1", "2", "3", "4", "5",
"6", "7", "8", "9", "10",
},
COMMUNITYWARAGENT_TEXT1 = "Thiết lập đại diện",
COMMUNITYWARAGENT_TEXT2 = "Đồng ý",
GUILD_WAR_RW_TITLE = "Công Hội Chiến-Đối Đầu",
GUILD_WAR_CX_TITLE = "Công Hội Chiến-Sơ Tuyển",
CANCEL_READY_GAME = "Hủy chuẩn bị",
CANCEL_PAIR_GAME = "Hủy ghép",
PVPRANK_INVITE_NO_DATA = "Không có dữ liệu phù hợp",
HAVE_KILL_BOSS = "BOSS đã tử vong",
SHOUCHONG1 = [[<T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">Gợi Ý: Đầu Tư 1000 Kim Cương Quỹ Trưởng Thành hoàn trả 10.000 Kim Cương</T>]],
SHOUCHONG2 = [[<T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">Nạp Thêm 250 Kim Cương Tặng PET Ong Vàng, Sách Kỹ Năng, Đá Sao</T>]],
SHOUCHONG3 = [[<T C="255,255,255" S="20" P="1" SC="0,0,0" SE="1" SS="4">Nạp Thêm 500 Kim Cương ẫm trọn Bộ Thời Trang, Cánh cực HOT</T>]],
GUILD_WAR_RANK_REWARD_VIEW = "Xem trước thưởng hạng",
GUILD_WAR_TEAM_SCORE = "Tổng điểm: %s",
SWEEP_FUNCTION_LAST = "Càn quét còn: ",
COMMUNITYWAR_TEXT35 = "Top 16",
LUCKYGIFT1 = "Ban Ân đổi",
SHOP_BUY_DESC3 = [[<T C="79,60,48" S="20" P="0">Gồm %d vật phẩm, cần chi trả </T><I Z="0.5">%s</I><T C="79,60,48" S="20" P="0">%d</T>]],
NOTRECOMMOEND = "Không có vật phẩm đề cử!",
ARENA_CARD_DES = 
[[
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Tăng điểm Thi Đấu từ Thẻ Thắng và Thẻ Ngày.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Thẻ Thắng hiệu lực khi thắng Thi Đấu, mỗi lần hiệu lực, trận duy trì -1, 0 sẽ mất hiệu lực.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Thẻ Ngày hiệu lực khi Thi Đấu＞0 điểm. Thời gian duy trì vẫn tính khi nhân vật rời mạng, 0 sẽ mất hiệu lực.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Hiệu quả Thẻ Thắng và Thẻ Ngày được cộng dồn.</T><BR></BR>
<T C="255,89,74" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0">Nhân vật tử vong trong kiểu Đấu Hạng và Đối Kháng sẽ biến thành linh hồn, có thể di chuyển tự do</T><BR></BR>
<T C="255,89,74" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0"> Linh hồn có thể nhặt Rương Linh Hồn, nhận kỹ năng linh hồn. Có thể dùng kỹ năng cho đồng đội hoặc đối thủ tùy hiệu quả mỗi loại, được tích trữ tối đa 3 kỹ năng, nếu vượt hơn sẽ không thể nhặt nữa</T><BR></BR>
]],
ARENA_CARD_TIME_TITLE = "Thẻ Lần chiến thắng tăng",
ARENA_CARD_TIME_LEFT = "Số trận còn: %d",
ARENA_CARD_ADD_PREC = "Thi đấu ngẫu nhiên thắng, điểm +%d%%",
ARENA_CARD_DAY_TITLE = "Thẻ Ngày chiến thắng tăng",
ARENA_CARD_DAY_LEFT = "Thời gian còn: %d ngày %d giờ",
ARENA_CARD_DAY_LEFT2 = "Thời gian còn: %d giờ %d phút",
ARENA_CARD_DAY_LEFT3 = "Thời gian còn: %d phút",
ARENA_CARD_TIME_TIP = "Điểm thắng Thi Đấu +%d%%, số trận +%d",
ARENA_CARD_DAY_TIP = "Điểm tổng kết Thi Đấu +%d%%, thời hạn +%d",
ARENA_CARD_ADD = "Điểm Thi Đấu tăng",
COMMUNITYWARAGENT_TEXT3 = "Nhấn \"+\" hoặc Avatar để thiết lập",
COMMUNITYWARAGENT_TEXT4 = "Đại diện",
DAY1 = "Ngày 1",
DAY2 = "Ngày 2",
DAY3 = "Ngày 3",
DAY4 = "Ngày 4",
DAY5 = "Ngày 5",
DAY6 = "Ngày 6",
DAY7 = "Ngày 7",
NOSAVE = "Chưa nạp",
SEVEN1 = "Tiêu phí hôm nay",
SEVEN2 = "Tích lũy tiêu phí",
SEVEN3 = "Mai có thể nhận",
SEVEN4 = "Ngày 8 có thể nhận",
SEVENDESC =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> Hoạt động tính từ khi tạo nhân vật, duy trì 1 tuần</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> Ngày 2 được nhận 10% Kim Cương tiêu phí của ngày trước</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> Ngày 8 được nhận 10% Kim Cương tổng tiêu phí tuần trước</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> Kim Cương hoàn trả đúng 12 giờ sẽ gửi qua thư</T><BR></BR>
<T C="158,0,0" S="22" P="0">5.</T><T C="62,34,8" S="22" P="0"> Hoạt động chỉ hiệu lực trước 1 tuần tạo nhân vật mới</T><BR></BR>
]],
KNOCKOUT_DESC = 
[[
<T C="255,89,74" S="20" P="0">1.</T><T C="255,236,193" S="20" P="0"> Thời gian mở: Ngày 15-20 mỗi tháng là lịch Đấu Loại, theo hình thức 3 trận thắng 2, thắng được vào vòng trong. Mỗi ngày 20:00-20:15 là thời gian chuẩn bị, đúng 20:15 là bắt đầu thi đấu, thành viên đã thiết lập được trực tiếp vào trận đấu.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="255,236,193" S="20" P="0"> Chủ Hội có thể thiết lập thành viên tham gia mỗi đội tại phòng, cũng có thể thiết lập đại diện ở bản đồ Công Hội, do đại diện thiết lập.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="255,236,193" S="20" P="0"> Mỗi trận đấu giới hạn 15 phút, hết giờ sẽ do hệ thống phán đoán thắng thua căn cứ số người, sinh lực còn lại của 2 bên.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="255,236,193" S="20" P="0"> Ngày 19 sẽ tiến hành trận đấu giành hạng 3, ngày 20 diễn ra trận Quán Quân.</T><BR></BR>
]],
ROOM_BEINVITED_3 = "%s mời tham gia\n%s",
CANTJOINGUILD1 = "Chưa đạt cấp vào Công Hội",

COUNTDOWN = "Hoạt động còn:",
COMMUNITYWAR_TEXT36 = "Công Hội hôm nay không có thi đấu",
COMMUNITYWAR_TEXT37 = "Chủ Hội mới được thiết lập đại diện!",
COMMUNITYWAR_TEXT38 = "Đại diện quyền hạn cao hơn đã vào, bạn mất quyền thiết lập!",
SHOP_DRESS_NULL = "Hiện tại không có thời trang mặc thử",
COMMUNITYWARAGENT_TEXT5 = 
[[
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Người Người Đại Diện có thể thiết lập thành viên tham gia tại phòng Công Hội Chiến-Đấu Loại.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Tối đa được thiết lập 4 Người Người Đại Diện.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Trong phòng chỉ 1 người được quyền thiết lập, Chủ Hội luôn có quyền tuyệt đối.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Trong phòng, nếu Chủ Hội không có mặt thì Người Người Đại Diện có mã số nhỏ nhất có quyền thiết lập.</T><BR></BR>
]],
BATTLE_FIRST_KILL = "First Blood",
TEACH_179 = "Nhấn để bỏ qua",
INVITE_LIST = "Danh sách mời",
GAME_ACTIVITY_TITLE40 = "Bắn pháo bông",
GAME_ACTIVITY_TITLE41 = "Lì xì giờ chẵn",
GAME_ACTIVITY_TITLE42 = "Lì xì",
GAME_ACTIVITY_TITLE43 = "Nguời chơi cũ trở về",
GAME_ACTIVITY_TITLE44 = "Khuyến mãi nhân vật mới",
GAME_ACTIVITY_TITLE45 = "Lì xì nhân vật mới",
NEWYEARTIP7 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Thời gian: Mỗi ngày </T>
<T C="99,255,95" S="20" P="1" SC="79,60,48" SE="1" SS="4">%s</T>
<T C="99,255,95" S="20" P="1" SC="79,60,48" SE="1" SS="4">%s</T>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Vào giờ chẵn, chỉ cần ở Thành chủ là có thể nhận 1 Lì Xì, 1 ngày có thể nhận  </T>
<T C="99,255,95" S="20" P="1" SC="79,60,48" SE="1" SS="4">%s</T>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4"> Lì Xì, mở Lì Xì nhận ngẫu nhiên </T>
<I Z="0.8" P="1">ui/common/common_icon_zuanshi.png</I>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Thưởng. </T>]],
MAX_Week_CARD = "Hiện tại Thẻ Tuần còn hơn %d ngày, không cần gia hạn",
LUCKYGIFT2 = "%.1f lần",
COMMUNITYWARAGENT_TEXT5 = 
[[
<T C="229,105,22" S="22">Người Đại Diện thiết lập đội viên Công Hội Chiến</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Người Đại Diện có thể thiết lập thành viên tham gia trong phòng Công Hội Chiến-Đấu Loại</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Có thể thiết lập nhiều nhất 4 Người Đại Diện</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Trong phòng chỉ 1 người có quyền thiết lập, Chủ Hội có quyền hạn tuyệt đối</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Nếu Chủ Hội vắng mặt, Người Đại Diện mã số nhỏ nhất mới được dùng quyền thiết lập</T><BR>20</BR>
<T C="229,105,22" S="22">Người Đại Diện tạo mới nhiệm vụ Công Hội</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Chủ Hội và Người Đại Diện đều được tạo mới nhiệm vụ Công Hội</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Cùng lúc, chỉ có 1 người được quyền tạo mới</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Chủ Hội không online, tức Người Đại Diện có mã số nhỏ nhất có quyền</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Khi người chơi có cấp ưu tiên cao hơn online, quyền hạn sẽ thay đổi</T><BR></BR>
]],
NEWUSER_WEAFARE_RETURN_RULE =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> Hoạt động tính từ khi tạo nhân vật, duy trì 1 tuần</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> Nạp đạt mức chỉ định sẽ nhận thưởng tương ứng</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> Hoạt động chỉ duy trì 7 ngày</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> Hoạt động chỉ hiệu lực trước 1 tuần tạo nhân vật mới</T><BR></BR>
<T C="158,0,0" S="22" P="0">5.</T><T C="62,34,8" S="22" P="0"> Sau khi hoạt động kết thúc nạp sẽ vô hiệu</T><BR></BR>
]],
DIGGEM_TEXT1 = "Túi Bảo Vật",
DIGGEM_TEXT2 = "Nhật ký Đào Bảo",
DIGGEM_TEXT3 = "Dự đoán thời gian còn lại: ",
DIGGEM_TEXT4 = "Bắt đầu Đào Bảo",
DIGGEM_TEXT5 = "Dừng Đào Bảo",
DIGGEM_TEXT6 = "Điểm Thuần Thục",
DIGGEM_TEXT7 = "Dung lượng",
DIGGEM_TEXT8 = "Chỉ lưu 50 nhật ký 3 ngày gần nhất",
DIGGEM_TEXT9 = [[<T C="255,236,193" S="20" P="0">Đã chọn </T><T C="233,166,62" S="20" P="0">[%s]</T><T C="255,236,193" S="20" P="0">, bắt đầu Đào Bảo</T>]],
DIGGEM_TEXT10 = [[<T C="255,236,193" S="20" P="0">Có làm thì mới có ăn, đào được </T><T C="233,166,62" S="20" P="0">[%s]</T><T C="255,236,193" S="20" P="0">, Điểm Thuần Thục </T><T C="5,180,0" S="20" P="0">+%d</T>]],
DIGGEM_TEXT11 = [[<T C="255,236,193" S="20" P="0">Hết thời gian, Đào Bảo kết thúc</T>]],
DIGGEM_TEXT12 = [[<T C="255,236,193" S="20" P="0">Túi Bảo Vật đã đầy, hãy dọn kịp thời, dừng Đào Bảo</T>]],
DIGGEM_TEXT13 = [[<T C="255,236,193" S="20" P="0">Cấp thông thạo lên đến </T><T C="5,180,0" S="20" P="0">Lv[%d]</T>]],
DIGGEM_TEXT14 = [[<T C="255,236,193" S="20" P="0">Hãy nghỉ ngơi một lát, dừng Đào Bảo</T>]],
DIGGEM_TEXT15 = "Thời gian đào: ",
DIGGEM_TEXT16 = "Hiệu suất đào: ",
DIGGEM_TEXT17 = "Tăng Điểm Thuần Thục: %d điểm",
DIGGEM_TEXT18 = "Giá",
DIGGEM_TEXT19 = 
[[
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Hướng dẫn 1.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Hướng dẫn 2.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Hướng dẫn 3.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Hướng dẫn 4.</T><BR></BR>
]],
DIGGEM_TEXT20 = "Chọn công cụ",
DIGGEM_TEXT21 = "Chưa có dữ liệu nhật ký",
DIGGEM_TEXT22 = "Thư viện bảo vật",
DIGGEM_TEXT23 = "Phí giám định",
DIGGEM_TEXT24 = " Điểm Thuần Thục có tỷ lệ đào được",
DIGGEM_TEXT25 = [[<T C="255,236,193" S="20" P="0">Có làm thì mới có ăn，</T>]],
DIGGEM_TEXT26 = [[<T C="255,236,193" S="20" P="0">May mắn đấy，</T>]],
DIGGEM_TEXT27 = [[<T C="255,236,193" S="20" P="0">Thật may mắn，</T>]],
DIGGEM_TEXT28 = [[<T C="255,236,193" S="20" P="0">Huyết thống Âu Hoàng!</T>]],
DIGGEM_TEXT29 = [[<T C="255,236,193" S="20" P="0">Chúc mừng đã nhận bảo vật hiếm!</T>]],
DIGGEM_TEXT30 = [[<T C="255,236,193" S="20" P="0">Đào được </T><T C="233,166,62" S="20" P="0">[%s]</T><T C="255,236,193" S="20" P="0">, Điểm Thuần Thục </T><T C="5,180,0" S="20" P="0">+%d</T>]],
DIGGEM_TEXT31 = "Giám định bảo vật",
DIGGEM_TEXT32 = "Giám định",
DIGGEM_TEXT33 = "Hãy chọn bảo vật cần giám định",
DIGGEM_TEXT34 = "Đồng ý tốn %d Kim Cương đổi %d Pha Lê hay không\nHôm nay còn được đổi %d lần",
DIGGEM_TEXT35 = "Số lần đổi hôm nay đã dùng hết",
DIGGEM_TEXT36 = "Số lượng giám định",
DIGGEM_TEXT37 = "Hãy chọn bảo vật bên phải để giám định",
DIGGEM_TEXT38 = "Đơn giá giám định",
DIGGEM_TEXT39 = "Tổng giá giám định",
DIGGEM_TEXT40 = "Ô giám định đã đầy, hãy giám định trước",
DIGGEM_TEXT41 = "Không có Đá chưa giám định",
TRANSACTION1 = "Giao Dịch",
TRANSACTION2 = "Đá Đỏ",
TRANSACTION3 = "Đá Lục",
TRANSACTION4 = "Đá Vàng",
TRANSACTION5 = "Đá Màu",
TRANSACTION6 = "Thường",
TRANSACTION7 = "Lấp lánh",
TRANSACTION8 = "Chói Lóa",
TRANSACTION9 = "Cần mua",
TRANSACTION10 = "Cần bán",
TRANSACTION11 = "Hệ thống thu hồi",
TRANSACTION12 = "Phân loại vật phẩm",
TRANSACTION13 = "Bảng vật phẩm",
TRANSACTION14 = "Số lượng mua",
TRANSACTION15 = "Túi Bảo Vật",
TRANSACTION16 = "Vật phẩm đang bán",
TRANSACTION18 = "Đã bán: ",
TRANSACTION19 = "Số lượng lên kệ",
TRANSACTION20 = "Lên kệ",
TRANSACTION21 = "Đơn giá bán",
TRANSACTION22 = "Tổng giá bán",
TRANSACTION23 = "Bán thành công sẽ thu 10% phí thủ tục",
TRANSACTION24 = "Pha Lê",
TRANSACTION25 = "Ngưng bán",
TRANSACTION26 = 
[[
<T C="127,70,26" S="20" P="0">Có %s vật phẩm có thể thu hồi</T><I Z="0.6">ui/common/common_icon_kuangjing.png</I><T C="127,70,26" S="20" P="0">%s</T>
]],
TRANSACTION27 = "Số lượng thu hồi: ",
TRANSACTION28 = "Đơn giá thu hồi",
TRANSACTION29 = "Tổng thu hồi",
TRANSACTION30 = "Hệ thống chỉ lưu 50 lần nhật ký giao dịch gần đây",
TRANSACTION31 = "Nhật ký",
TRANSACTION32 = "Bảng nhật ký giao dịch",
TRANSACTION33 =
[[
<T C="255,236,193" S="18" P="0">Bán </T><T C="99,255,95" S="18" P="0">[%s] x%s</T>
<T C="255,227,116" S="18" P="0">, giá thỏa thuận %s Pha Lê, nhận được %s Pha Lê</T>
]],
TRANSACTION34 =
[[
<T C="255,236,193" S="18" P="0">Bán </T><T C="93,222,254" S="18" P="0">[%s] x%s</T>
<T C="255,227,116" S="18" P="0">, giá thỏa thuận %s Pha Lê, nhận được %s Pha Lê</T>
]],
TRANSACTION35 =
[[
<T C="255,236,193" S="18" P="0">Bán </T><T C="198,130,255" S="18" P="0">[%s] x%s</T>
<T C="255,227,116" S="18" P="0">, giá thỏa thuận %s Pha Lê, nhận được %s Pha Lê</T>
]],
TRANSACTION36 =
[[
<T C="255,236,193" S="18" P="0">Bán </T><T C="233,166,62" S="18" P="0">[%s] x%s</T>
<T C="255,227,116" S="18" P="0">, giá thỏa thuận %s Pha Lê, nhận được %s Pha Lê</T>
]],
TRANSACTION37 =
[[
<T C="255,236,193" S="18" P="0">Mua </T><T C="99,255,95" S="18" P="0">[%s] x%s</T>
<T C="255,227,116" S="18" P="0">,Giá thỏa thuận %s Pha Lê</T>
]],
TRANSACTION38 =
[[
<T C="255,236,193" S="18" P="0">Mua </T><T C="93,222,254" S="18" P="0">[%s] x%s</T>
<T C="255,227,116" S="18" P="0">,Giá thỏa thuận %s Pha Lê</T>
]],
TRANSACTION39 =
[[
<T C="255,236,193" S="18" P="0">Mua </T><T C="198,130,255" S="18" P="0">[%s] x%s</T>
<T C="255,227,116" S="18" P="0">,Giá thỏa thuận %s Pha Lê</T>
]],
TRANSACTION40 =
[[
<T C="255,236,193" S="18" P="0">Mua </T><T C="233,166,62" S="18" P="0">[%s] x%s</T>
<T C="255,227,116" S="18" P="0">,Giá thỏa thuận %s Pha Lê</T>
]],
TRANSACTION41 = "Bán",
TRANSACTION42 = "Mua",
TRANSACTION43 = "Đơn giá mua",
TRANSACTION44 = "Tổng mua",
TRANSACTION45 = "Không đủ Pha Lê",
TRANSACTION46 = "Vật phẩm đã bán hết",
TRANSACTION47 = "Lên kệ thành công",
TRANSACTION48 = "Ô kệ đã đầy",
TRANSACTION49 = "Số lượng vật phẩm không đủ",
TRANSACTION50 = "Ngưng bán thành công",
TRANSACTION51 = "Đã bị mua",
TRANSACTION52 = "Mỗi lần thu hồi nhiều nhất 10 vật phẩm",
TRANSACTION53 = "Đã bán %s cái",
TRANSACTION54 = "Đồng ý ngưng bán %s?",
TRANSACTION55 = "Túi đã đầy, ngưng bán thất bại",
TRANSACTION56 = "Tổng",
TRANSACTION57 = "Lộng lẫy",
TRANSACTION_DESC =
[[
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Vật phẩm sau khi lên kệ phải được mua bởi người chơi khác mới có thể nhận Pha Lê</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Vật phẩm trong Giao Dịch đều do người chơi bày bán</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Những vật phẩm trên bảng sẽ được đề cử ngẫu nhiên</T><BR>10</BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Lên kệ có giới hạn thời gian, quá hạn sẽ ngưng bán vật phẩm đó</T><BR>10</BR>
<T C="127,70,26" S="20">5.</T><T C="127,70,26" S="18">Đá phẩm chất thấp không thể lên kệ</T><BR>20</BR>
<T C="127,70,26" S="20">6.</T><T C="127,70,26" S="18">Sau khi bán thành công, hệ thống sẽ thu phí bằng 10% giá vật phẩm</T><BR>20</BR>
<T C="127,70,26" S="20">7.</T><T C="127,70,26" S="18">Thu hồi vật phẩm là bán cho hệ thống, sau khi bán có thể nhận Pha Lê</T><BR>10</BR>
]],
PROMISE_SHRINE_TEXT1 = "Thưởng ban đầu",
PROMISE_SHRINE_TEXT2 = "Cầu Nguyện lần sau còn: ",
PROMISE_SHRINE_TEXT3 = "Phúc Lợi còn: ",
PROMISE_SHRINE_TEXT4 = "Nạp ưu đãi",
PROMISE_SHRINE_TEXT5 = "",
PROMISE_SHRINE_TEXT6 = "Nạp",
PROMISE_SHRINE_TEXT7 = "Đang có buff Cầu Nguyện: Nạp bất kì để nhận thưởng!",
PROMISE_SHRINE_TEXT8 = 
[[
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Cầu Nguyện không tốn Xu, mỗi ngày chỉ được Cầu Nguyện 1 lần</T><BR>10</BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Buff phúc lợi sau khi Cầu Nguyện chỉ được dùng 1 lần</T><BR>10</BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Cầu Nguyện sẽ không còn sau khi hoạt động kết thúc</T><BR>10</BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Hoạt động Cầu Nguyện tạo mới vào 05:00 mỗi ngày</T><BR>10</BR>
<T C="127,70,26" S="20">5.</T><T C="127,70,26" S="18">Nạp thẻ đạt yêu cầu sau khi Cầu Nguyện sẽ nhận được thưởng Cầu Nguyện qua thư</T><BR>10</BR>
]],
PROMISE_SHRINE_TEXT9 = "Nạp lần đầu nhân đôi",
PROMISE_SHRINE_TEXT10 = "Cầu Nguyện",
PROMISE_SHRINE_TEXT11 = "Cầu Nguyện hoàn trả ", 
PROMISE_SHRINE_TEXT12 = "Hồ Ước Nguyện: ",
PROMISE_SHRINE_TEXT13 = "Lợi ích cuối cùng",
TDONATE = "Cống hiến thể lực: ",
LEAGUE_HONOUR_TITLE1 = "Giải đấu Xạ Thủ Liên Đấu mùa %s",
SUMMON_4 = "Rút Bùa",
PETDES = 
[[
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Nếu tư chất Pet chưa đạt tối đa, có thể tẩy luyện để nhận tư chất ngẫu nhiên.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Mỗi lần tẩy luyện cần tốn 1 Tinh Thạch Pet, có thể nhận tại Tiệm Pet.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Khi tư chất Pet đạt cao nhất, sẽ không thể tiếp tục tẩy luyện.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Tư chất tẩy luyện có dạng ngẫu nhiên, hãy chọn kỹ.</T><BR></BR>
]],
DIGGEM_TEXT19 =
[[
<T C="229,105,22" S="22">Công cụ Đào Bảo</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Dùng công cụ cao để Đào Bảo, tốc độ thu hoạch càng nhanh, nhận Điểm Thuần Thục càng nhiều và dễ nhận bảo vật.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Công cụ cao duy trì lâu hơn.</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Mua công cụ cần tốn Pha Lê, Pha Lê nhận khi bán hoặc treo bán các bảo vật.</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Dừng Đào Bảo sẽ tốn thời gian, cần duy trì một khoảng thời gian mới được nhận bảo vật, nên đừng thao tác quá nhiều.</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Khi Túi Bảo Vật đầy sẽ tự động dừng Đào Bảo, sắp xếp túi để hạn chế tổn thất.</T><BR></BR>
]],
DIGGEM_TEXT42 =
[[
<T C="229,105,22" S="22">Hướng dẫn Đào Bảo</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Dùng công cụ để Đào Bảo, sau thời gian nhất định sẽ nhận được bảo vật.</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Đào Bảo sẽ nhận được Điểm Thuần Thục, đạt mức nhất định sẽ tăng cấp kỹ năng Đào Bảo, giúp đào được bảo vật tốt hơn.</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Giám định bảo vật sẽ nhận được các loại Đá, Kim Cương Khóa, Pha Lê, Vàng.</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Nếu không giám định, cũng có thể bán trực tiếp cho hệ thống, hoặc bán cho người khác nhận Pha Lê.</T><BR></BR>
]],
RUNE_LOCK_TIP = "Hãy mở ô Bùa trước",
RUNE_OPEN_BY_DIAMONDS = "Đồng ý tốn %d Kim Cương để mở ô trước?",
RUNE_STORE = "Tiệm Bùa",
RUNE_TOTAL_LEVEL = "Tổng cấp Bùa",
RUNE_ATTRIBUTE = "Thuộc tính cộng thêm",
FAST_DISASSEMBLE = "Tháo nhanh",
RUNE_BAG = "Túi Bùa",
RUNE_INFO = "Thông tin Bùa",
RUNE_EXTRACT = "Rút Bùa",
RUNE_LOAD = "Gắn Bùa",
RUNE_ITEM_ATTRIBUTE1 = [[<T C="255,227,116" S="20" P="0">%s         </T><T C="99,255,95" S="20" P="0">+%s</T>]],
RUNE_ITEM_ATTRIBUTE2 = [[<T C="255,227,116" S="20" P="0">%s    </T><T C="99,255,95" S="20" P="0">+%s</T>]],
COMMUNITYINFO228 = "Cấp thiết lập phải lớn hơn hoặc bằng %s",
COMMUNITYINFO229 = "Cấp VIP thiết lập phải nhỏ hơn hoặc bằng %s",
COMMUNITYINFO230 = "Cấp VIP thiết lập phải lớn hơn hoặc bằng %s",
COMMUNITYINFO231 = "Công Hội mục tiêu cần người chơi đạt cấp %s",
COMMUNITYINFO232 = "Công Hội mục tiêu cần cấp người chơi đạt VIP %s",
COMMUNITYINFO233 = "Công Hội mục tiêu đã đầy, không thể vào",
COMMUNITYINFO234 = "%s mời bạn vào Công Hội %s",
REVIEW1 = "Duyệt thủ công",
REVIEW2 = "Duyệt tự động",
REVIEW3 = "Cấp nhân vật vào Hội",
REVIEW4 = "Cấp VIP nhân vật vào Hội",
COMMUNITYINFO195 = [[Cấp/Tên/ID]],
COMMUNITYINFO235 = "Không hạn chế",
COMMUNITYINFO236 = "Nhân vật cấp %s",
COMMUNITYINFO237 = "Hạn chế vào Hội",
COMMUNITYINFO238 = "Mời Công Hội",
LUCK_DRAW_ONE = "Rút 1 lần",
LUCK_DRAW_FIVE = "Rút 5 lần",
TO_RUNE_SYSTEM = "Đến trang bị",
LUCK_DRAW_TIP = "Rút 5 lần được Bùa Lv2-Lv3",
LUCK_DRAW_TIP2 = "Rút 5 lần được Bùa Lv4-Lv5",
LUCK_DRAW_TIP3 = "Rút thêm %d lần được Bùa Lv2-Lv3",
LUCK_DRAW_TIP4 = "Rút thêm %d lần được Bùa Lv4-Lv5",
UNLOAD_ALL_RUNE = "Xác nhận tháo toàn bộ Bùa?",
OPERATION_ERROR = "Thao tác thất bại",
DIAMONDS_OPEN_SLOT_ERROR_TIP = "Dùng Kim Cương mở ô thất bại",
RUNE_BAG_NULL_TIP = "Tạm không có Bùa để gắn",
BIG_RUNE_LEVEL ="Dấu Thánh Lv%d",
RED_RUNE_LEVEL = "(Bùa Đỏ tổng Lv%d kích hoạt)",
GREEN_RUNE_LEVEL = "(Bùa Xanh tổng Lv%d kích hoạt)",
YELLOW_RUNE_LEVEL = "(Bùa Vàng tổng Lv%d kích hoạt)",
BIG_RUNE_LEVEL_ACT = "(Bùa tổng Lv%d kích hoạt)",
RUNE_LEVEL_MAX = "(Cấp hiện tại đã đầy)",
RED_RUNE_UPDATE_LEVEL = "(Bùa Đỏ tổng Lv%d lên cấp)",
GREEN_RUNE_UPDATE_LEVEL = "(Bùa Xanh tổng Lv%d lên cấp)",
YELLOW_RUNE_UPDATE_LEVEL = "(Bùa Vàng tổng Lv%d lên cấp)",
BIG_UPDATE_LEVEL = "(Bùa tổng Lv%d lên cấp)",
BUY_RUNE_STORE_NOT_ENOUGTH = "%s không đủ %d, có thể đến bán Bùa để nhận",
NOT_RUNE_TO_UNLOAD = "Không có Bùa để tháo",
RUNEBOOK1 = "Cấp sàng lọc",
RUNEBOOK2 = "Bán nhiều",
RUNEBOOK3 = "Nhận Bùa",
RUNEBOOK4 = "Thông tin bán",
RUNEBOOK5 = "Nhấp chọn",
RUNEBOOK6 = "Không bán Bùa đã gắn",
RUNEBOOK7 = "Toàn bộ Bùa Lv1",
RUNEBOOK8 = "Bán Bùa",
RUNEBOOK9 = "Hãy chọn vật phẩm cần bán",
RUNEBOOK10 = "Tạm chưa nhận Bùa này",
RUNEBOOK11 = "Bùa đã trang bị, đồng ý bán?",
RUNEBOOK12 = "Đồng ý bán Bùa này?",
RUNEBOOK13 = "Toàn bộ Bùa Lv2",
RUNEBOOK14 = "Toàn bộ Bùa Lv3",
RUNEBOOK15 = "Toàn bộ Bùa Lv4",
RUNEBOOK16 = "Tạm không có Bùa loại này",
RUNEBOOK17 = "Không có Bùa để bán",
RUNEBOOK18 = "Bán thất bại",
PVPRANK_PROTECTED_ATT1 = "Còn %d điểm sẽ mở bảo vệ bậc",
PVPRANK_PROTECTED_ATT2 = "Bảo vệ bậc đã mở",
BATTLE_RANK_LOSE_TIPS = "Điểm Dũng Sĩ không đủ, bảo vệ thất bại",
BATTLE_RANK_LOSE_TIPS2 = "Mở bảo vệ cấp bậc",
BATTLE_RANK_LOSE_TIPS3 = "Điểm lên cấp ngăn bị trừ sao",
BATTLE_RANK_WIN_TIPS = "Điểm đầy, tăng thêm 1 sao",
BATTLE_RANK_COMMON_TIPS = "Điểm đầy %d = 1 sao",
BATTLE_RANK_LOSE_ICON_TIPS1 = "Bảo vệ bậc Đồng, cấp bậc không đổi",
BATTLE_RANK_LOSE_ICON_TIPS2 = "Thưởng Điểm Dũng Sĩ, ngăn bị trừ sao",
BATTLE_RANK_LOSE_ICON_TIPS3 = "Bảo vệ Điểm Dũng Sĩ, bậc không đổi",
OWNMOUNT = "Đã có thú cưỡi này, tiếp tục mua?",
OWN1 = "Đã có %s, tiếp tục mua?",
VOICE_CHAT_NOT_SUPPORT = "Phiên bản này không hỗ trợ chức năng Voice, hãy cập nhật phiên bản mới nhất",
LUCKYGIFT3 = "Còn %d",
LUCKYGIFT4 = "Ngẫu nhiên",
FAKEROOM = "Không thể vào phòng này",
VOICE_CLICKMORE = "Đừng nhấp nút chat voice liên tục",
VOICE_RECORDING_ERROR = "Trong cảnh chat voice không thể thu âm",
VOICE_RECORDING_ERROR2 = "Đã dùng chat voice trực tiếp, không thể phát voice",
ACTIVITYCLOSE = "Hoạt động chưa mở",
VOICE_NOSUPPORT = "Chức năng này cần cài đặt phiên bản mới nhất mới được dùng, vui lòng tải và cài đặt",
CANTBUY = "Không thể mua vật phẩm này.",
VOICE_OPENSTR= "Hiện tại chức năng Voice đã đóng, xác nhận mở chức năng Voice?",
CANTOPER = "Người có quyền hạn cao hơn đã online, không thể thao tác nhiệm vụ Công Hội",
INPUT_KEY_SEARCH = "Nhập từ khóa để tìm",
INPUTRECT_NULL_ATT = "Nhập ID bạn bè hoặc từ khóa của tên để tìm",
SEARCH_NO_RESULT = "Không tìm thấy mục tiêu phù hợp",
LOAD_SLOT_NULL_TIP = "Không có ô trống để gắn",
RANK32 = "Top 32",
BUY_FIVEGEM_ATTENTION = [[<T C="255,236,193" S="20" P="0">Liên tục mua </T><T C="233,166,62" S="20" P="0">%d lần </T><T C="255,236,193" S="20" P="0">Pha Lê</T>]],
BUY_TIMES = "Mua %d lần",
DRAW_RUNE_ERROR = "Rút thưởng Bùa thất bại",
LEAGUE114 = [[Top 32]],
RUNE_EXPLAIN = 
[[
<T C="229,105,22" S="22">Hệ thống Bùa</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Sau khi tăng cấp sẽ mở thêm ô.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Có thể dùng Kim Cương để mở ô Bùa, nhưng không thay đổi cấp mở của các ô khác.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Bùa tương ứng đạt cấp nhất định sẽ kích hoạt Dấu Thánh tương ứng, nhận thuộc tính cộng thêm.</T><BR>20</BR>
<T C="229,105,22" S="22">Nhận Bùa</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Rút thưởng Bùa để nhận Bùa.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Bùa có thể mua ở Tiệm Bùa</T><BR>20</BR>
<T C="229,105,22" S="22">Thu hồi Bùa</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Có thể bán các Bùa dư để nhận Mảnh Bùa.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Mảnh Bùa dùng để mua tại Tiệm Bùa.</T><BR></BR>
]],
PHANTOM1 = "Ảo Hóa",
PHANTOM2 = "Rương Ảo Hóa",
PHANTOM3 = "Ảo Lực",
PHANTOM4 = [[<T C="255,236,193" S="21" SC="79,60,48" SE="1" SS="4">Có cơ hội nhận </T><T C="99,255,95" S="21" SC="79,60,48" SE="1" SS="4"> skin Thường</T>]],
PHANTOM5 = [[<T C="255,236,193" S="21" SC="79,60,48" SE="1" SS="4">Có cơ hội nhận </T><T C="93,222,254" S="21" SC="79,60,48" SE="1" SS="4"> skin Dũng Sĩ</T>]],
PHANTOM6 = [[<T C="255,236,193" S="21" SC="79,60,48" SE="1" SS="4">Có cơ hội nhận </T><T C="198,130,255" S="21" SC="79,60,48" SE="1" SS="4"> skin Sử Thi</T>]],
PHANTOM7 = "Có cơ hội nhận skin Master",
PHANTOM8 = "Ảo Lực",
PHANTOM9 = "Dùng Thẻ",
PHANTOM10 = "Ảo Hóa Lực",
PHANTOM11 = "Thẻ Thử Nghiệm",
PHANTOM12 = "Thường",
PHANTOM13 = "Dũng Sĩ",
PHANTOM14 = "Sử Thi",
PHANTOM15 = "Master",
PHANTOM16 = "Skin Ảo Hóa",
PHANTOM17 = "Ảo Hóa thành công",
PHANTOM18 = "Thời gian thử %d ngày",
PHANTOM19 = "Thời gian thử còn lại ",
PHANTOM_DESC =
[[
<T C="229,105,22" S="22">Ảo Hóa</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Sau khi kích hoạt skin, có thể Ảo Hóa.</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Sau khi Ảo Hóa có thể thay đổi ngoại hình và nhận hiệu quả cộng thêm.</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Bỏ chọn hiện skin, ngoại hình skin sẽ không hiển thị.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Chỉ có skin kích hoạt vĩnh viễn mới có thể nhận Ảo Lực, Ảo Lực dùng tăng cấp Ảo Hóa Lực.</T><BR></BR>
<T C="255,89,74" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0"> Skin dưới phẩm chất tím có thể dùng Mảnh Skin để tăng phẩm chất skin.</T><BR></BR>
]],
PHANTOM20 = "Mở rương",
PHANTOM21 = "Rương Thường",
PHANTOM22 = "Rương Hiếm",
PHANTOM23 = "Rương Sử Thi",
PHANTOM_CHEST_DESC =
[[
<T C="229,105,22" S="22">Rương Ảo Hóa</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Tốn số lượng Tinh Thạch Ảo Hóa nhất định có thể mở Rương Ảo Hóa</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Mở Rương Ảo Hóa có cơ hội nhận skin vĩnh viễn</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Nhận skin vĩnh viễn đã có sẽ chuyển thành Tinh Thạch Ảo Hóa</T><BR></BR>
]],
PHANTOM24 = "Đã có skin này, chuyển thành ",
COMMENT1 = "Nếu thích trò chơi này, hãy đến bình luận nhé!",
COMMENT2 = "Bình luận ngay",
COMMENT3 = "Lần sau",
COMMENT4 = "Từ chối",
TABOO_BOX_OPEN_NOW = "Mở ngay",
TABOO_BOX_OPEN_LOCK = "Nhấp mở khóa",
TABOO_BOX_OPEN = "Nhấp mở",
TABOO_BOX_EMPTY = "Rương trống",
TABOO_BOX_GET_DES = "Có thể nhận: ",
TABOO_BOX_TITLE1 = "Mở khóa rương",
TABOO_BOX_TITLE2 = "Mở rương",
TABOO_BOX_TITLE3 = "Rương Bất Ngờ",
TABOO_BOX_OPEN_START = "Bắt đầu mở khóa",
TABOO_BOX_OPEN_CANCEL = "Vứt bỏ",
TABOO_BOX_OPEN_CANCEL2 = "Bỏ rương mới",
--TABOO_BOX_OPEN_CANCEL = "Vứt bỏ\n(Vứt bỏ là mất)",
TABOO_BOX_OPEN_COMMON_DES = "May mắn đấy, nhặt được 1 Rương Bất Ngờ!",
TABOO_BOX_DISCARD = "Đồng ý vứt bỏ rương này?\n(Vứt bỏ sẽ không thể tìm lại)",
TABOO_DICE_RUSH = "Hồi phục còn: ",
TABOO_BOX_OUT = "Không đủ ô rương, không nhận được rương này",
TABOO_EVENT_1 = "Nhận được %d Xúc Xắc",
TABOO_EVENT_2 = "Đi tiếp %d bước",
TABOO_EVENT_3 = "Lùi lại %d bước",
TABOO_EVENT_4 = "Chuyển đến vị trí khác",
TABOO_EVENT_5 = "Đã xóa thời gian mở khóa rương",
TABOO_BOX_OPENING = "Cùng lúc chỉ được mở khóa 1 rương",
TABOO_BOX_OPEN_COMMON_DES_1 = "Ô rương đã đầy, mở ngay rương đã mở khóa có thể nhận rương mới",
TABOO_BOX_OPEN_COMMON_DES_2 = "Ô rương đã đầy, mở ngay rương đang mở khóa có thể nhận rương mới",
BUY_FIVETOUZI_ATTENTION = [[<T C="255,236,193" S="20" P="0">Liên tục mua </T><T C="233,166,62" S="20" P="0">%d lần </T><T C="255,236,193" S="20" P="0">Xúc Xắc</T>]],
PHANTOM25 = "Chưa dùng",
TABOO_DIR_FRONT = "Đi tiếp",
TABOO_DIR_BACK = "Lùi lại",
PHANTOM26 = "Mảnh skin",
PHANTOM27 = "Đồng hành",
PHANTOM28 = "Hủy Ảo Hóa thành công",
TABOO_CELL_END = "Điểm đến",
PHANTOM29 = "Hiệu quả bị động",
PHANTOM30 = "Hiện skin",
PHANTOM31 = "Hãy Ảo Hóa trước",
TABOO_BOX_OPEN_ALREADY = "Đã mở khóa",
TABOO_DESC = 
[[
<T C="229,105,22" S="22">Đất Cấm</T><BR>5</BR>
<T C="255,89,74" S="20" P="0">1.</T><T C="127,70,26" S="20" P="0"> Đất Cấm mỗi lần tốn 1 Xúc Xắc</T><BR></BR>
<T C="255,89,74" S="20" P="0">2.</T><T C="127,70,26" S="20" P="0"> Xúc Xắc Đất Cấm mỗi 60 phút hồi 1 viên, không hồi tiếp sau khi đạt giới hạn</T><BR></BR>
<T C="255,89,74" S="20" P="0">3.</T><T C="127,70,26" S="20" P="0"> Rương của chương khác nhau sẽ có skin khác nhau.</T><BR></BR>
<T C="255,89,74" S="20" P="0">4.</T><T C="127,70,26" S="20" P="0"> Chỉ có 3 ô rương, tất cả chương đều dùng chung, khi đầy không thể nhận thêm rương mới, trừ phi mở ngay những rương đã hoặc đang mở khóa</T><BR></BR>
<T C="255,89,74" S="20" P="0">5.</T><T C="127,70,26" S="20" P="0"> Cấp VIP khác nhau giới hạn số lượng Xúc Xắc được mua mỗi ngày khác nhau, 24h mỗi ngày tạo mới</T><BR></BR>
<T C="255,89,74" S="20" P="0">6.</T><T C="127,70,26" S="20" P="0"> Mở rương cần thời gian chờ nhất định, rương phẩm chất càng tốt mở càng lâu, quà càng phong phú</T><BR></BR>
]],
SECTION_WORD = "Chương thứ %d",
WEEK_DAY = "Thời gian Thẻ Tuần còn",
VIP_WEB = "Nạp Thẻ Qua Web",
VIP_WEB_DESC = "Mỗi ngày nạp thẻ qua trang web 3 lần đầu sẽ nhận được thêm phần thưởng đặc biệt",
VIP_WEB_REWARD = "Phần thưởng nạp lần thứ %d",
VIP_WEB_REWARD2 = "Hôm nay đã hoàn thành 3 lần nạp",
VIP_WEB_GO = "Nạp qua web",
NO_ATTR_ADD = "không có thuộc tính cộng dồn",
MULTI_ROOM_EMPTY = "Phòng không tồn tại",
NOORANGE = "Chưa có trang bị Cam",
WAKEUP_TEXT1 = {"Thức Tỉnh", "Hồn Thức Tỉnh", "Thể Thức Tỉnh", "Sức Mạnh Thức Tỉnh", "Kỹ Năng Thức Tỉnh", "Thức Tỉnh-Tiến Hóa"},
WAKEUP_TEXT2 = {"Bậc 1-Hồn ", "Bậc 2-Thể ", "Bậc 3-Lực ", "Bậc 4-Kỹ ", "Bậc 5-Tiến Hóa"},
WAKEUP_TEXT3 = "Điều Kiện",
WAKEUP_TEXT4 = "Tiêu Hao",
WAKEUP_TEXT5 = "Thức Tỉnh",
WAKEUP_TEXT6 = {"Kích hoạt-Hồn Thức Tỉnh ", "Kích hoạt-Thể Thức Tỉnh ", "Kích hoạt-Sức Mạnh Thức Tỉnh ", "Kích hoạt-Kỹ Năng Thức Tỉnh ", "Kích hoạt-Thức Tỉnh-Tiến Hóa"},
WAKEUP_TEXT7 = {"Hồn Thức Tỉnh đã mở ", "Thể Thức Tỉnh đã mở ", "Sức Mạnh Thức Tỉnh đã mở ", "Kỹ Năng Thức Tỉnh đã mở ", "Thức Tỉnh-Tiến Hóa đã mở"},
WAKEUP_TEXT8 = "Đã hoàn thành",
WAKEUP_TEXT9 = {"Nuôi dưỡng-Thường", "Nuôi dưỡng-Trung", "nuôi dưỡng-Cao", "Nuôi dưỡng-Siêu"},
WAKEUP_TEXT10 = "Lên cấp có thể nhận %d điểm thiên phú",
WAKEUP_TEXT11 = "Điểm thiên phú",
WAKEUP_TEXT12 = "Mỗi lần nuôi dưỡng tốn %d đạo cụ",
WAKEUP_TEXT13 = "Đến Ảo Hóa",
WAKEUP_TEXT14 = "Sau khi Thức Tỉnh %s có thể nhận",
WAKEUP_TEXT15 =
[[
<T C="229,105,22" S="22">Tính năng Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Hoàn thành 5 giai đoạn Thức Tỉnh, sẽ lần lượt mở 5 tính năng.</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Bậc 1-Hồn: Hoàn thành sẽ mở Hồn Thức Tỉnh, đạt cấp nhất định mới được mở Thức Tỉnh tiếp theo.</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Bậc 2-Thể: Hoàn thành được nhận Skin Thức Tỉnh vĩnh viễn.</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Bậc 3-Lực: Hoàn thành sẽ kích hoạt kỹ năng thiên phú.</T><BR></BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Bậc 4-Kỹ: Hoàn thành sẽ có thể dùng kỹ năng Thức Tỉnh trong chiến đấu.</T><BR></BR>
<T C="127,70,26" S="20">6. </T><T C="127,70,26" S="18">Bậc 5-Tiến Hóa: Hoàn thành sẽ mở tính năng Thức Tỉnh-Tiến Hóa.</T><BR></BR>
]],
WAKEUP_TEXT16 = "[Điều kiện %d]",
WAKEUP_TEXT17 = "Hãy lên cấp đã",
WAKEUP_TEXT18 = "Hãy hoàn thành toàn bộ điều kiện Thức Tỉnh trước",
WAKEUP_TEXT19 = "EXP",
WAKEUP_TEXT20 = 
[[
<T C="229,105,22" S="22">Hồn Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 1-Hồn mở Hồn Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Hồn Thức Tỉnh có thể dùng Đá Thức Tỉnh nuôi dưỡng nhận EXP để tăng cấp.</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Sau khi tăng cấp Hồn Thức Tỉnh, có thể nhận thuộc tính cao hơn và điểm thiên phú.</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Cấp của Hồn Thức Tỉnh là điều kiện Thức Tỉnh, cần đạt cấp nhất định để tiếp tục Thức Tỉnh.</T><BR></BR>
]],
WAKEUP_TEXT21 = 
[[
<T C="229,105,22" S="22">Thể Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 2-Thể mở Thể Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Thông qua tính năng Thể Thức Tỉnh người chơi có thể nhận bộ skin Thức Tỉnh vĩnh viễn.</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Skin Thức Tỉnh đẹp, kỹ năng hữu ích và hiệu quả.</T><BR></BR>
]],
WAKEUP_TEXT22 = 
[[
<T C="229,105,22" S="22">Sức Mạnh Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 3-Lực mở Sức Mạnh Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Thông qua chức năng Lực Thức Tỉnh có thể dùng điểm thiên phú để học thiên phú, nhận đạo cụ thưởng hoặc thuộc tính tăng.</T><BR></BR>
]],
WAKEUP_TEXT23 = 
[[
<T C="229,105,22" S="22">Kỹ Năng Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 4-Kỹ mở Kỹ Năng Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Kỹ năng Thức Tỉnh, dùng thay đổi điểm hành động trong chiến đấu</T><BR></BR>
]],
PROPERTYINFO1 = "Thông tin thuộc tính",
EXTRACTION_TEXT1 = "Nhận",
EXTRACTION_TEXT2 = "Bùa",
EXTRACTION_TEXT3 = "Chúc phúc",
EXTRACTION_TEXT4 = "Tự thêm",
EXTRACTION_TEXT5 = "Giá tách",
EXTRACTION_TEXT6 = "Tổng nhận",
ONE_YEAR_ACTIVITY = "Quà Mừng Lễ",
INTEGRAL_VALUE = "Điểm tích lũy",
FIREWORKS_LIST = "Thưởng Bảng Pháo Hoa",
RANK_VALUE = "%d - %d",
NEWYEARTIP10 = "Đốt Pháo Hoa",
NEWYEARTIP6 = "Lần đăng nhập này không xem pháo hoa",
NEWYEARTIP1 = "Pháo hoa-Thường",
NEWYEARTIP2 = "Pháo hoa-Lớn",
NEWYEARTIP3 = "Pháo hoa-Hào Hoa",
NEWYEARTIP4 = "Thời gian chờ pháo hoa: ",
NEWYEARTIP5 = "Quy tắc: Tốn Kim Cương để phát hiệu ứng pháo hoa toàn server",
NEWYEARTIP7 =
[[
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Thời gian: Mỗi ngày</T>
<T C="99,255,95" S="20" P="1" SC="79,60,48" SE="1" SS="4">%s</T>
<T C="99,255,95" S="20" P="1" SC="79,60,48" SE="1" SS="4">%s</T>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4"> giờ chẵn, có thể nhận Lì Xì trong thành chính, mỗi lần có thể nhận 1 Lì Xì, 1 ngày có thể nhận </T>
<T C="99,255,95" S="20" P="1" SC="79,60,48" SE="1" SS="4">%s</T>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4"> Lì Xì, dùng Lì Xì có thể nhận ngẫu nhiên </T>
<I Z="0.8" P="1">ui/common/common_icon_zuanshi.png</I>
<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Thưởng.</T>
]],
NEWCOMMUNITY1 = "Cấp: ",
NEWCOMMUNITY2 = "Quản lý",
EXTRACTION_TEXT7 = {"Chưa có bùa để tách", "Chưa có trang bị để tách", "Chưa có Pet để tách", "Chưa có chúc phúc để tách"},
EXTRACTION_TEXT8 = "Phí tách",
PLAY_FIREWORKS_CLOSE = "Hoạt động Pháo Hoa đã kết thúc",
EXTRACTION_TEXT9 = "Đến Ghép",
EXTRACTION_TEXT10 = "Đến nhận",
EXTRACTION_TEXT11 = "Phân tích Đá Thức Tỉnh",
NEWCOMMUNITY3 = "Mời vào",
NEWCOMMUNITY4 = "Mời Ra",
RECHARGE_VALUE_TIP = "Nạp đạt mức tương ứng có thể nhận quà, mỗi quà chỉ có thể mua 1 lần!",
LOGIN_COUNT_SEVEN_TIP = "Hoạt động tích lũy đăng nhập 7 ngày có thể nhận danh hiệu riêng",
ONE_YEAR_DES =
[[
<T C="229,105,22" S="22">Hướng dẫn Sinh Nhật Đăng Nhập</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Mỗi ngày đăng nhập điểm danh có thể nhận thưởng</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Mỗi phần thưởng chỉ có thể nhận 1 lần</T><BR>20</BR>
<T C="229,105,22" S="22">Hướng dẫn Pháo Hoa Tưng Bừng</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Khi đốt Pháo Hoa, tất cả người chơi khác sẽ nhìn thấy</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Đốt Pháo Hoa có thể nhận điểm tích lũy, tiến hành xếp hạng dựa vào điểm tích lũy</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Trước khi hoạt động kết thúc 1 khoản thời gian sẽ ngừng chức năng đốt pháo hoa, sau khi hoạt động kết thúc sẽ gửi phần thưởng xếp hạng qua thư</T><BR>20</BR>
]],
RECHARGE_DOUBLE = "Nạp thẻ nhân đôi",
RECHARGE_DOUBLE_RULE = "Quy tắc: Mỗi mức chỉ có thể nhận 1 lần thưởng nạp nhân đôi",
REDPACK_ATT22 = "Số Lì Xì còn lại hôm nay: %d/%d",
GO_TO_WISHING = "Đến Cầu Nguyện",
WISHING_COME_BACK = "Cầu Nguyện trở lại",
WISHING_NOT_OPEN_TITLE = "Mừng Lễ Bí Mật",
WISHING_ONE_YEAR_TIP = "Mừng tròn 1 năm, Hồ Ước Nguyện sắp tái hiện",
PASS_OVER = "Đã nhận xong",
NEWCOMMUNITY5 = "Mời Ra",
NEWCOMMUNITY6 = "Trục xuất các thành viên đã chọn ra khỏi Công Hội?",
NEWCOMMUNITY7 = "Công Hội Chiến chưa mở",
NEWCOMMUNITY8 = "Không đủ quyền hạn",
NEWCOMMUNITY9 = "Thiết lập vào hội",
NEWCOMMUNITY10 = "Loại xét duyệt",
NEWCOMMUNITY11 = "Điều kiện hạn chế",
NEWCOMMUNITY12 = "Người chơi/Chức vụ",
ANNIV_END = "Hoạt động đã kết thúc",
ANNIV_END2 = "Hoạt động sẽ mở vào 16/6",
WAKEUP_TEXT24 = 
[[
<T C="229,105,22" S="22">Hồn Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 1-Hồn mở Hồn Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Hồn Thức Tỉnh có thể dùng Đá Thức Tỉnh để nuôi dưỡng và tăng cấp.</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Tăng cấp Hồn Thức Tỉnh có thể nhận nhiều thuộc tính tăng và điểm thiên phú.</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Cấp của Hồn Thức Tỉnh cũng là điều kiện Thức Tỉnh.</T><BR></BR>
]],
WAKEUP_TEXT25 = 
[[
<T C="229,105,22" S="22">Thể Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 2-Thể mở Thể Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Thể Thức Tỉnh đã mở, có thể nhận skin Thức Tỉnh</T><BR></BR>
]],
WAKEUP_TEXT26 = 
[[
<T C="229,105,22" S="22">Sức Mạnh Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 3-Lực mở Sức Mạnh Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Sau khi mở Lực Thức Tỉnh, có thể tốn điểm thiên phú để học thiên phú.</T><BR></BR>
]],
WAKEUP_TEXT27 = 
[[
<T C="229,105,22" S="22">Kỹ Năng Thức Tỉnh</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành Bậc 4-Kỹ mở Kỹ Năng Thức Tỉnh.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Sau khi mở Kỹ Năng Thức Tỉnh, có thể học các kỹ năng Thức Tỉnh để chiến đấu.</T><BR></BR>
]],
ACTIVITY_START_TITLE = "Thông báo hoạt động Kỷ Niệm (Hoạt động mở vào 16/6)",
ACTIVITY_START_TIP_1 = "1. Tặng quà khi đăng nhập (Kim Cương, Vàng, danh hiệu riêng)",
ACTIVITY_START_TIP_2 = "2. Chúc phúc khẩu lệnh (Tặng 616 Kim Cương!)",
ACTIVITY_START_TIP_3 = "3. Quà Lớn Kỷ Niệm (Tặng skin Cam!)",
ACTIVITY_START_TIP_4 = "4. Lễ Hội Pháo Hoa (Pháo hoa tỏa sáng trên bầu trời)",
ACTIVITY_START_TIP_5 = "Còn nhiều hoạt động khác",
WECHATTIPS1 =  "Chia sẻ có thể nhận thưởng trên",
WECHATTIPS2 =  "Hoàn thành nhiệm vụ chia sẻ mỗi ngày để nhận thưởng",
Promise1 = 
[[
<T C="255,227,116" SC="79,60,48" SS="4" S="22" P="1" SE="1">Nạp mức bất kỳ có thể nhận thêm</T>
<T C="93,222,254" SC="79,60,48" SS="4" S="30" P="1" SE="1">%d</T>
<T C="255,227,116" SC="79,60,48" SS="4" S="22" P="1" SE="1"> phúc lợi Kim Cương gấp bội</T>
]],
WAKEUP_TEXT28 = "Hãy chọn vật phẩm cần tách",
WAKEUP_TEXT29 = "Hãy chọn vật phẩm bên phải để tách",
WAKEUP_TEXT30 = "Ô tách đã đầy, hãy tách trước",
SEND_FIREWORK_TIP = "Đang đốt pháo hoa, hãy quay lại sau",
CLICK_TO_OPEN_REDBOX = "Nhấp mở Lì Xì",
WAKEUP_TEXT31 = "Tất cả vật phẩm đã trong ô tách",
WAKEUP_TEXT32 = "Không có vật phẩm để thêm",
WAKEUP_TEXT33 = "Vật phẩm phẩm chất cao không thể tự thêm",
WAKEUP_TEXT34 = "Có vật phẩm phẩm chất cao sẽ được tách, đồng ý tiếp tục?",
WAKEUP_TEXT35 = "Kích hoạt thuộc tính thưởng",
TIPS11 = [[<T C="138,122,106" S="20" P="0">Chưa Thức Tỉnh</T>]], 
TIPS12 = [[Bậc %d]], 
TIPS13 = [[Tăng bậc Thức Tỉnh]],
TIPS14 = [[Hồn Thức Tỉnh: ]],
LEAGUE_NOT_SEND = "Chưa phát",
ACTIVITY_YEAR_END = "Hoạt động đã kết thúc",
RECHARGE_YEAR_ACTIVITY_BAG = "Đang mua, vui lòng đợi",
COMPETE_TASK_NO_DATA = "Đã hoàn thành tất cả mục tiêu",
WAKEUP1 = "Nhật ký dùng",
WAKEUP2 = "Dùng 5 lần",
WAKEUP3 = [[<T C="195,171,148" S="22" P="0">Lần %d, %d->%d, chưa bạo kích nhận %d EXP</T>]],
WAKEUP4 = [[<T C="195,171,148" S="22" P="0">Lần %d, %d->%d, bạo kích x%d, nhận %d EXP</T>]],
WAKEUP5 = [[<T C="195,171,148" S="22" P="0">Dùng %d lần, Hồn Thức Tỉnh tăng đến Lv%d, nhận %d EXP</T>]],

ITEM_LIST = "Danh sách vật phẩm",
SETTING_COMMENT = "Bình luận: ",
WAKEUP6 = "Đá Thức Tỉnh",
ORANGE_COLOR = "Cam",
PURPLE_COLOR = "Tím",
BLUE_COLOR = "Lam",
GREEN_COLOR = "Lục",
FRAGMENT = "Mảnh",
HANDLE_PRODUCT = "Bao Tay",
ITEM1 = "Vật phẩm tốn",
ITEM2 = "Đạo cụ xã hội",
ITEM3 = "Mặt",
ITEM4 = "Loại cân bằng",
ITEM5 = "Loại tấn công",
ITEM6 = "Loại phòng thủ",
ITEM7 = "Loại sinh lực",
ITEM8 = "Rèn",
ITEM9 = "Mảnh Đạo Cụ",
ITEM10 = "Mảnh Skin",
ITEM11 = "Mảnh Thời Trang",
ITEM12 = "Mảnh Trang Bị",
CURRENT_TYPE = "(Hiện tại)",
ONLINE_REWARD_RECEVICED = "Đã nhận hết thưởng online hôm nay",
FAST_GET_ITEM = "Chưa thể nhận",
CONSUME_FIRST = "Ưu tiên tốn %s",
ZHANYANGTIME = "Hôm nay đã lễ bái Vật Tổ",
GAME_ACTIVITY_TITLE46 = "Tích lũy tiêu phí",
GAME_ACTIVITY_TITLE47 = "Ưu Đãi Giới Hạn",
GAME_ACTIVITY_TITLE48 = "Ưu đãi vật phẩm mới",
GAME_ACTIVITY_TITLE49 = "Quà ưu đãi",
NEWBAG1 = "Tủ Đồ",
NEWBAG2 = "Bảo vệ",
NEWBAG3 = "Túi Thời Trang",
NEWBAG4 = "Lực chiến Ảo Hóa: ",
NEWBAG5 = "Trang bị nhanh",
NEWBAG6 = "Thuộc tính trang bị",
NEWBAG7 = "Lực chiến trang bị: ",
RUNE_FIGHT = "Lực chiến Bùa",
NEWBAG8 = "Bông Tai",
NEWBAG9 = "Trợ Thủ",
NEWBAG11 = "Lực chiến Tủ Áo: ",
DESIGNATION_NO_POINT = "Không có điểm thành tựu",
SUMMER_VACTION_DES =
[[
<T C="229,105,22" S="22">Mùa Hè</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Mua Skin Mùa Hè có thể nhận thêm Kim Cương</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Skin Mùa Hè chỉ được mua 1 lần (Đơn hàng có thể trễ, đừng chi trả lần nữa)</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18"> Mua Skin không tăng EXP VIP</T><BR>20</BR>
<T C="229,105,22" S="22">Ưu Đãi Hè</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Mỗi Quà Ưu Đãi Hè mỗi ngày được mua 1 (Đơn hàng có thể trễ đừng chi trả lần nữa)</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Quà Ưu Đãi Hè 24:00 mỗi ngày tạo mới số lần mua</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Quà Ưu Đãi Siêu không tăng EXP VIP</T><BR>20</BR>
<T C="229,105,22" S="22">Thưởng Hè</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Mỗi ngày ngẫu nhiên tạo mới 4 Quái Truy Nã Thưởng (24:00 tạo mới)</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Diệt Quái Truy Nã đạt số lượng chỉ định có thể hoàn thành nhiệm vụ và nhận thưởng (Càn quét không tính)</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18"> Diệt Quái Truy Nã khi đã tổ đội, thành viên được xem như hoàn thành diệt</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18"> Điểm thưởng toàn server căn cứ điểm thưởng diệt cá nhân tích lũy, đạt mức nhất định cần nhận thủ công thưởng giai đoạn tương ứng</T><BR>20</BR>
<T C="229,105,22" S="22">Khuyến Mãi Hè</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18"> Khuyến Mãi Hè giới hạn số lượng mua, đạt giới hạn không thể mua tiếp</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18"> Vật phẩm Khuyến Mãi Hè cách một thời gian sẽ có vật phẩm mới lên kệ</T><BR>20</BR>
]],
FULL_SERVICE_SCORE = "Điểm thưởng toàn server",
THE_WANTED = "Truy Nã hôm nay",
BOUGHT = "Đã mua",
KILL_REWARD_TIP = "Diệt kẻ bị truy nã có thể nhận điểm thưởng, điểm thưởng toàn server đạt %d nhận thưởng",
BUY_SKIN_GET = "Mua Skin tặng",
BOUNTY = "Điểm thưởng: ",
SUMMER_VACTION_1 = "Mùa Hè",
SUMMER_VACTION_2 = "Ưu Đãi Hè",
SUMMER_VACTION_3 = "Thưởng Hè",
SUMMER_VACTION_4 = "Khuyến Mãi Hè",
SUMMER_VACTION_DES_1 = "Skin Hè Băng Tuyết Rơi",
SUMMER_VACTION_DES_2 = "Mua nhận nhiều ưu đãi",
SUMMER_VACTION_DES_3 = "Cùng hợp sức nhận quà lớn",
SUMMER_VACTION_DES_4 = [[Khuyến mãi "Giá thấp nhất"]],
SUMMER_VACTION_START_T = "Hoạt động đặc sắc %s mở",
SHOPBUY1 = "Đã mua tổng cộng %s vật phẩm %s, cần trả",
SUMMER_END = "Ngày Hội Mùa Hè đã kết thúc",
COPY_CHAPTER_NOT_OPEN_TIP = "Chương mục tiêu chưa mở",
SUMMER_BUY_FASHION_TIP = "Mùa hè sôi động, bán có giới hạn",
WARN_DESC3 = [[<T C="255,236,193" S="12" P="0" SC="138,122,106" SE="1" SS="2">ISSN: ISBN 978-7-7979-0084-3   Bản quyền: 2015SR235509   Sản xuất: ZHWYD</T>]],
DECOMPRESSION = "Đang giải nén dữ liệu, xin đợi",
NEWACTIVITY_TEXT2 = "Sử dụng nhận phần thưởng",

TEACH_181 = "Nhấp vào trạng thái viết",
TEACH_182 = "Nhấp kỹ năng cần mang theo",
TEACH_183 = "Đến trang đạo cụ",
TEACH_184 = "Nhấp đạo cụ cần mang theo",
TEACH_185 = "Hãy thử hiệu quả kỹ năng mới",
NEWSKILL1 = "Chiến đấu mang theo",
NEWSKILL2 = "Danh sách kỹ năng",
NEWSKILL3 = "Chờ: ",
NEWSKILL4 = "Hướng dẫn: ",
NEWSKILL5 = "Cấp kế",
NEWSKILL6 = "Nhật ký thao tác",
NEWSKILL7 = [[<T C="255,227,116" S="16" P="0">%s kế thừa từ vũ khí Lv%s%s %s sao</T><BR>8</BR>]],
NEWSKILL8 = [[<T C="255,227,116" S="16" P="0">Kích hoạt %s thành công</T><BR>8</BR>]],
NEWSKILL9 = [[<T C="255,227,116" S="16" P="0">Tăng cấp kỹ năng, %s tốn %s điểm kỹ năng</T><BR>8</BR>]],
NEWSKILL10 = "Kỹ năng có thể học",
NEWSKILL11 = "Kỹ năng đã đạt cấp tối đa",
NEWSKILL12 = "Xem trước hiệu quả",
NEWSKILL13 = "Điểm kỹ năng không đủ",
NEWSKILL14 = "Lên cấp thành công",
NEWSKILL15 = "Kích hoạt thành công",
NEWSKILL16 = "Học thành công",
NEWSKILL17 = "Học",
NEWSKILL18 = "Kỹ năng có thể trang bị",
NEWSKILL19 = "Trang bị tối thiểu 1 kỹ năng",
NEWSKILL20 = "Đạo cụ có thể kích hoạt",
PLAYER_NAME_LEVEL = [[<T C="255,227,116" S="18"  SE="1" SS="4" SC="105,65,46" >%s </T><T C="255,255,255" S="18"  SE="1" SS="4" SC="79,60,48" >%s</T>]],
PLAYER_NAME_LEVEL2 = [[<T C="255,227,116" S="18"  SE="1" SS="4" SC="105,65,46" >%s </T><T C="99,255,95" S="18"  SE="1" SS="4" SC="79,60,48" >%s</T>]],
NEWLEAGUE1 = [[Hạng:]],
NEWLEAGUE2 = [[Điểm vòng loại:]],
NEWPRACTICE1 = "Lấy %s lần",
NEWPRACTICE2 =
[[
<T C="255,89,74" S="20" P="0">1. </T><T C="127,70,26" S="20" P="0"> Mỗi tốn 1 thể lực được nhận 10 điểm tu luyện, khi lấy điểm tu luyện sẽ chuyển thành EXP thuộc tính</T><BR></BR>
<T C="255,89,74" S="20" P="0">2. </T><T C="127,70,26" S="20" P="0"> Mỗi lần tu luyện sẽ nhận ngẫu nhiên 3 loại hiệu quả (Sinh lực, tấn công, phòng thủ, thể chất, sức mạnh, hộ giáp, EXP)</T><BR></BR>
<T C="255,89,74" S="20" P="0">3. </T><T C="127,70,26" S="20" P="0">Hiệu quả thuộc tính nhận được từ tu luyện sẽ tăng EXP tu luyện của thuộc tính đó, nếu có 2 hoặc 3 loại hiệu quả thuộc tính lặp lại thì EXP tu luyện thuộc tính tăng vẫn được cộng thêm</T><BR></BR>
<T C="255,89,74" S="20" P="0">4. </T><T C="127,70,26" S="20" P="0">Hiệu quả EXP nhận được từ tu luyện vẫn sẽ tăng cho EXP tu luyện thuộc tính, nếu đồng thời nhận được 3 loại đều là EXP thì đều tăng EXP tu luyện tất cả thuộc tính.</T><BR>20</BR>
]],
FAMILY_TEXT1 = "Xây Vườn",
FAMILY_TEXT2 = [[<T C="255,227,116" S="20" P="1" SC="79,60,48" SS="4" SE="1">Đồng ý tốn </T><I Z="0.5" P="1">%s</I><T C="255,227,116" S="20" P="1" SC="79,60,48" SS="4" SE="1">x%d </T><T C="255,227,116" S="20" P="1" SC="79,60,48" SS="4" SE="1"> xây Vườn</T>]],
FAMILY_TEXT3 = "Độ Hào Hoa",
FAMILY_TEXT4 = "Thu thập",
FAMILY_TEXT5 = "Đồng ý trả %d %s tăng tốc lên cấp %s?",
FAMILY_TEXT6 = "Đồng ý trả %d %s tăng tốc xây %s?",
FAMILY_TEXT7 = "Đồng ý trả %d %s tăng tốc hủy %s?",
FAMILY_TEXT8 = "Tất cả Giúp Việc đều bận, đồng ý trả %d%s hoàn thành ngay 1 kiến trúc?",
FAMILY_TEXT9 = "Đồng ý hủy lên cấp %s, hủy sẽ hoàn trả 50%% phí.",
FAMILY_TEXT10 = "Đồng ý hủy xây %s, hủy sẽ hoàn trả 50%% phí.",
FAMILY_TEXT11 = "Đồng ý hủy bỏ %s, hủy sẽ hoàn trả 50%% phí.",
FAMILY_TEXT12 = "Dung lượng sản xuất: ",
FAMILY_TEXT13 = "Tốc độ sản xuất: ",
FAMILY_TEXT14 = "Đá Lạ tối đa: ",
FAMILY_TEXT15 = "Nước Thánh tối đa: ",
FAMILY_TEXT16 = "Đồng ý bán %s để đổi %d%s?",
FAMILY_TEXT17 = "Vườn cần đạt Lv%d",
FAMILY_TEXT18 = "Cần xây đạt Lv%d: %s%d",
SKILLNUM = "Điểm kỹ năng: ",
NEWSKILL21 = "Tạo mới kỹ năng thành công",
NEWSKILL22 = "Đồng ý dùng Thuốc Quên Kỹ Năng để tạo mới kỹ năng, tạo mới sẽ quên kỹ năng đã học và trả lại điểm kỹ năng",
FAMILYSHOP1 = "Kiến Trúc",
FAMILYSHOP2 = "Trang Sức",
FAMILYSHOP3 = "Tiệm Vườn",
NEWSKILL23 = "Hãy hủy sẵn sàng",
NEWSKILL24 = "Đang viết không thể tạo mới kỹ năng",
NEWSKILL26 = "Đang chỉnh sửa, không thể học kỹ năng",
NEWSKILL27 = "Đang chỉnh sửa, không thể nâng cấp kỹ năng",
NEWSKILL25 = "Đã dùng",
FAMILYSHOP4 = "Không đủ tài nguyên",
FAMILYSHOP5 = "Phòng Chủ Nhân đạt Lv%s mở khóa",
FAMILYSHOP6 = "Lên cấp Phòng Chủ Nhân có thể xây nhiều hơn",
FAMILYSHOP7 = "Hạng Vườn",
FAMILYSHOP8 = "Cấp Vườn",
FAMILYSHOP9 = "Chủ Nhân",
FAMILY_TEXT19 = "Hãy xây 1 Phòng Giúp Việc trước để có người lao động",
BUY_FIVEFAMILY_ATTENTION = [[<T C="255,236,193" S="20" P="0">Liên tục mua </T><T C="233,166,62" S="20" P="0"> %d lần</T><T C="255,236,193" S="20" P="0">%s</T>]],
FAMILY_TEXT20 = "Về Nhà",
FAMILY_TEXT21 = "Lật lại",
FAMILY_TEXT22 = "Có thể xây nhiều kiến trúc hơn",
FAMILY_TEXT23 = "Mở khóa thêm nhiều nhiều kiến trúc",
LOURAACT1 = "7 Ngày Vui Vẻ",
LOURAACT2 = "Nhanh Như Tia Chớp",
LOURAACT3 = "Chung Cư Tình Yêu",
LOURAACT4 = "Nạp thẻ nhân đôi",
LOURAACT5 = "Chia sẻ hoạt động",
LOURAACT6 = "Đề cử",
FAMILY_TEXT24 = "Đang tham quan...",
FAMILYSHOP10 = "Đã xây",
FAMILYSHOP11 = "Hạng bạn bè",
FAMILYSHOP12 = [[<T C="138,122,106" S="20" P="0">Chưa tạo</T>]], 
FAMILYSHOP13 = "Cần Phòng Chủ Nhân Lv%s",
LOURAACT7 = "Quy tắc: Mỗi ngày đăng nhập điểm danh nhận thưởng.",
LOURAACT8 = "Trong thời gian hoạt động thu thập đủ đạo cụ có thể nhận quà tương ứng.",
LOURAACT9 = "Quà mỗi ngày giới hạn mua 1 lần.",
LOURAACT10 = "Thưởng chia sẻ lần đầu mỗi ngày: ",
FAMILYSHOP14 = "Cần Vườn Lv%s",
FAMILYSHOP15 = "BXH Server",
FAMILYSHOP16 = "BXH Toàn Server",
FAMILYSHOP17 = "1:00 thứ 2 mỗi tuần gửi thưởng qua thư",
FAMILYRANK_DESC =
[[
<T C="127,70,26" S="20" P="1">Hướng dẫn: </T><BR></BR>
<T C="127,70,26" S="20" P="1">　</T><BR></BR>
<T C="229,105,22" S="20" P="1">BXH chia thành: </T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="1">BXH gồm BXH Server, BXH Toàn Server, BXH Bạn Bè.</T><BR></BR>
<T C="229,105,22" S="20" P="0">2. </T><T C="127,70,26" S="20" P="1">Xếp hạng dựa theo độ hào hoa của Vườn.</T><BR></BR>
<T C="229,105,22" S="20" P="0">3. </T><T C="127,70,26" S="20" P="1">Chỉ có BXH Server, BXH Toàn Server được nhận thưởng hạng, BXH Bạn Bè không có thưởng hạng.</T><BR></BR>
<T C="127,70,26" S="20" P="1">　</T><BR></BR>
<T C="229,105,22" S="20" P="1">Phát thưởng: </T><BR></BR>
<T C="229,105,22" S="20" P="0">1. </T><T C="127,70,26" S="20" P="1">1:00 thứ 2 mỗi tuần gửi thưởng hạng qua thư.</T><BR></BR>
<T C="127,70,26" S="20" P="1">　</T><BR></BR>
]],
FAMILYSHOP18 = "Lần này xây miễn phí",
FAMILY_TEXT25 = "Nước Thánh",
FAMILY_TEXT26 = "Đá Lạ",
FAMILY_TEXT27 = "Kho không đủ chỗ, hãy tăng cấp Kho hoặc xây thêm Kho",
TEACH_186 = "Nhấp Tiệm Vườn",
TEACH_187 = "Chọn Kho",
TEACH_188 = "Đồng ý xây",
TEACH_189 = "Hãy chọn Máy Nước Thánh",
TEACH_190 = "Bắt đầu thu thập",
LOURAACT_DESC =
[[
<T C="229,105,22" S="22">Hướng dẫn</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Thời trang Long Cung, trong hoạt động Skin 11.11 chỉ được mua 1 lần, mua quà không tính EXP VIP, không tính hoạt động tích lũy</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Hoạt động đổi hạn giờ, tìm đủ đạo cụ liên quan có thể đổi ngay đạo cụ tương ứng</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Quà Trở Lại-Cực mỗi ngày giới hạn mua 1 lần, mua quà không tính EXP VIP, không tính hoạt động tích lũy</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Quà siêu giá trị mỗi ngày giới hạn mua 1 lần, hoạt động Quà Thánh Quang giới hạn mua 1 lần, mua quà không tính EXP VIP, không tính hoạt động tích lũy</T><BR>20</BR>
]],

LOURAACT14 = "Đừng bỏ lỡ Quà Siêu Cấp!",
LOURAACT11= "Thần Tài Đến",
LOURAACT12 = "Bán trước Skin",
LOURAACT2 = "Đổi hạn giờ",
LOURAACT3 = "Quà Siêu Cấp",
LOURAACT13 = "Mua giới hạn siêu giá trị",

FAMILY_TEXT28 = "Không có Giúp Việc rảnh, hãy xây nhiều Phòng Giúp Việc hoặc tăng tốc công việc đang làm.",
FAMILY_TEXT29 = "Đang sản xuất tài nguyên...",
FAMILY_TEXT30 = "Kiến trúc đã xây xong, không thể hủy",
FAMILY_TEXT31 = "Kiến trúc đã thăng cấp xong, không thể hủy",
FAMILY_TEXT32 = "Kiến trúc đã xóa, không thể hủy",
LIMITEQUIP1 = "Trang bị thử nghiệm [%s] đã quá hạn.",
USINGLIMITEQUIP = "Đang dùng trang bị hạn giờ, khi hết hạn cần giữ lại trang bị cùng loại để thay thế, tiếp tục?",
LIMITEQUIP2 = "Đang dùng trang bị hạn giờ, cần giữ lại 1 trang bị cùng loại để thay thế.",
NEWACTIVITY_TEXT1 = [[<T C="255,227,116" S="14" P="1" SC="105,65,46" SS="4" SE="1">Mỗi nạp %d </T><I Z="0.5" P="1">ui/common/common_icon_zuanshi.png</I><T C="255,227,116" S="14" P="1" SC="105,65,46" SS="4" SE="1"> được nhận 1 </T><I Z="0.3" P="1">shopitems/kf_chuizi.png</I><T C="255,227,116" S="14" P="1" SC="105,65,46" SS="4" SE="1">, (Đã tích lũy nạp %d</T><I Z="0.5" P="1">ui/common/common_icon_zuanshi.png</I><T C="255,227,116" S="14" P="1" SC="105,65,46" SS="4" SE="1">)</T>]],
NEWACTIVITY_TEXT3 = "Đã hết số lần mua",
NEWACTIVITY_TEXT4 = [[<T C="79,60,48" S="16" P="1" SC="105,65,46" SS="4" SE="0">Nhấp trứng cần đập, tốn 1 </T><I Z="0.3" P="1">shopitems/kf_chuizi.png</I><T C="79,60,48" S="16" P="1" SC="105,65,46" SS="4" SE="0"> (Hiện có %d)</T>]],
NEWACTIVITY_TEXT5 = "Đập lần nữa chắc chắn nhận thưởng cao",
NEWACTIVITY_TEXT6 = "Trống",
NEWACTIVITY_TEXT7 = "Được Thích %d lần",
NEWACTIVITY_TEXT8 = "Riêng",
NEWACTIVITY_TEXT9 = "Cấp VIP không đủ không thể mua, đồng ý tăng cấp VIP?",
NEWACTIVITY_TEXT10 = {"Quà Vượt Ải 1 Sao","Quà Vượt Ải 2 Sao","Quà Vượt Ải 3 Sao"},
NEWACTIVITY_TEXT11 = "Tích lũy nhận phó bản",
NEWACTIVITY_TEXT12 = "Đã không còn Búa, đồng ý nạp nhận nhiều hơn?",
NEWACTIVITY_TEXT13 = "Khi tổng kết hạng mỗi mùa sẽ phát thưởng",
NEWACTIVITY_TEXT14 = "Ưu đãi server mới",
NEWACTIVITY_TEXT15 = "Tăng bậc server mới",
NEWACTIVITY_TEXT16 = "Tích lũy nạp server mới",
NEWACTIVITY_TEXT17 = "Lực chiến server mới",
NEWACTIVITY_TEXT18 = "Đập trứng server mới",
NEWACTIVITY_TEXT19 = "Vòng quay server mới",
NEWACTIVITY_TEXT20 = "Phó bản server mới",
NEWACTIVITY_TEXT21 = "Dự phòng server mới",
NEWACTIVITY_TEXT22 = "Dự phòng server mới 2",
CUR_TURN_COUNT = "Số lần rút còn: %d",
CUR_TURN_COUNT_NOT = "Số lần còn không đủ",
DIAMONDS_TURNTABLE_TIP =
[[
<T C="229,105,22" S="22">Hướng dẫn</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">VIP2 trở lên được rút 1 lần Vòng Quay Kim Cương</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">VIP3 được rút 2 lần Vòng Quay Kim Cương</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">VIP4 được rút 3 lần Vòng Quay Kim Cương</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">VIP5 được rút 4 lần Vòng Quay Kim Cương</T><BR></BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">VIP6 được rút 5 lần Vòng Quay Kim Cương</T><BR></BR>
<T C="127,70,26" S="20">6. </T><T C="127,70,26" S="18">VIP7 được rút 6 lần Vòng Quay Kim Cương</T><BR></BR>
<T C="127,70,26" S="20">7. </T><T C="127,70,26" S="18">VIP8 được rút 7 lần Vòng Quay Kim Cương</T><BR></BR>
<T C="127,70,26" S="20">8. </T><T C="127,70,26" S="18">VIP9 được rút 8 lần Vòng Quay Kim Cương</T><BR></BR>
<T C="127,70,26" S="20">9. </T><T C="127,70,26" S="18">VIP10 trở lên được rút 8 lần Vòng Quay Kim Cương</T><BR>20</BR>
]],
CROSS_SERVICE_TIP = "Hiện không thể chat liên server",
CROSS_SERVICE_TIP2 = "Không hỗ trợ xem thông tin người chơi liên server",
CROSS_SERVICE = "Toàn server",
CROSS_SERVICE_TIP3 = "Sau khi liên server sẽ mở Đấu Hạng",
NEWSHOP1 = "Vật phẩm mới lên kệ",
NEWSHOP2 = "Giảm giá còn",
NEWSHOP3 = "Đã có set này",
NEWSHOP4 = "Xem trước",
NEWSHOP5 = "Danh sách mặc thử",
NEWSHOP6 = "Ưu đãi",
NEWSHOP7 = "Tầm Bảo",
NEWSHOP8 = "Kim Cương",
NEWSHOP9 = "Kim Cương",
NEWSHOP10 = "Điểm may mắn",
NEWSHOP11 = [[<T C="158,0,0" S="20" P="1">[Giá gốc </T><T C="5,180,0" S="20" P="1">%s</T><T C="158,0,0" S="20" P="1">]</T>]],
NEWSHOP12 = [[ phần trăm]],
NEWSHOP13 = [[Mỗi ngày mua giới hạn ưu đãi]],
NEWSHOP14 = [[Vật phẩm ưu đãi hôm nay]],
NEWSHOP15 = [[Giá gốc: ]],
NEWSHOP16 = [[Giá mua giới hạn: ]],
NEWSHOP17 = "Giảm\n-%s%s",
NEWSHOP18 = [[Đoạt Bảo %s lần, sẽ nhận được %s điểm may mắn]],
NEWSHOP19 = [[Điểm may mắn càng nhiều, tỉ lệ nhận vật phẩm hiếm càng cao]],
NEWSHOP20 = [[Lần sau lật thẻ tốn: ]],
NEWSHOP21 = [[Mỗi ngày miễn phí lật thẻ lần đầu]],
NEWSHOP22 = [[Đá Mắt Phượng]],
NEWSHOP23 = [[Đá Mắt Phượng]],
NEWSHOP24 = [[Xu Ban Ân]],
NEWSHOP25 = [[Tranh mua còn: ]],
EQUIPSTORE = "Tiệm Trang Bị",
NEWACTIVITY_FIGHTINGLIST_RULE = 
[[	
<T C="229,105,22" S="22">Quy tắc hoạt động Lực Chiến</T><BR></BR>	
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoạt động kéo dài 4 tuần, 2 tuần đầu sẽ chọn Top 10 Vua Lực Chiến, 2 tuần cuối tất cả người chơi có thể chọn Thích；</T><BR>10</BR>	
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Mỗi ngày, mỗi người có thể chọn Thích 1 Vua Lực Chiến, chọn xong sẽ nhận được Thể Lực；</T><BR>10</BR>	
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Vua Lực Chiến sẽ được nhận thưởng Vàng theo tổng lượt được Thích mỗi ngày；</T><BR>10</BR>	
]],	
ADVISE_HERO_DESC = "Có thể đến trang CSKH tìm kiếm vấn đề thường gặp trong game, đồng thời giao lưu online!",    
ADVISE_HERO = "Đến trang CSKH",
DRAW_LUCKY_TIP = "Mua %d Vàng\n(Tặng quay %d lần)",
BUY2 = "Mua",
DRAW_TIP_FREE_TEXT = [[<T C="255,236,193" S="20" P="1">%s</T><I Z="0.4">%s</I><T C="255,236,193" S="20" P="1">%s</T><I Z="0.4">%s</I><BR></BR><T C="195,171,148" S="16" P="1" >    (%s)</T>]],
SEND_DRAW_COUNT = "Tặng Gọi %d lần",
DRAW_TIP_FREE_TEXT2 = [[<T C="195,171,148" S="16" P="1">%s</T><T C="99,255,95" S="16" P="1">%d</T><T C="195,171,148" S="16" P="1">%s</T>]],
DRAW_RUNE_TIP2 = "Tặng rút",
DRAW_COUNT = " lần",
PET_BUY_GOLD1 = "Mua",
PET_BUY_GOLD2 = "Mua 10000",
PET_BUY_GOLDDESC1 = "Tặng Gọi 1 lần",
PET_BUY_GOLDDESC2 = "Tặng Gọi 10 lần",
TEACH_191 = "Bắn theo đường nhắm",
TEACH_192 = "Nhấp hạng 1 BXH",
TEACH_193 = "Mỗi ngày tiến hành Thích sẽ được nhận thể lực",
TEACH_194 = "Lễ Đường là nơi tham gia hôn lễ của người khác, có thể nhận được Lì Xì",
TEACH_195 = "Cầu hôn là một việc rất lãng mạn, cùng tìm hiểu nào",
TEACH_196 = "Tìm hiểu điều kiện kết hôn",
TEACH_197 = "Đấu Hạng thi đấu công bằng đã mở",
TEACH_198 = "Thuộc tính nhân vật Đấu Hạng đều bằng nhau",
TEACH_199 = "Xem thuộc tính nhân vật",
TEACH_200 = "Kích hoạt thú cưỡi sẽ tăng thuộc tính",
TEACH_201 = "Tăng cấp thú cưỡi nhận hiệu quả thuộc tính cao hơn",
TEACH_202 = "Tốn Vàng tăng cấp thú cưỡi",
TEACH_203 = "Cách chơi mới đã mở",
TEACH_204 = "Vào Đất Cấm thần bí",
TEACH_205 = "Cấp càng cao mở khóa càng nhiều khu vực",
TEACH_206 = "Hãy ném Xúc Xắc tiến hành Mạo Hiểm",
TEACH_207 = "Tiếp tục online %d phút sẽ được nhận vũ khí",
TEACH_208 = "Mau đến nhận vũ khí Tím",
TEACH_209 = "Tiếp tục online %d phút sẽ được nhận danh hiệu",
TEACH_210 = "Mau đến nhận danh hiệu",
TEACH_211 = "Đang có Nộ Hỏa, hãy dùng POW đánh xuyên gỗ!",
FINISH_TASK_UPDATE_TIP = "Cách lên cấp nhanh",
CAN_BE_GET_REWARD1 = " có thể nhận thưởng",
TOTALLOGIN_DESC =
[[
<T C="158,0,0" S="22" P="0">1. </T><T C="62,34,8" S="22" P="0"> Tích lũy đăng nhập số ngày chỉ định được nhận thưởng tương ứng</T><BR></BR>
]],
SELLINFO1 = "Xác nhận thu hồi Thẻ Đổi Thú Cưỡi?",
STRENGTHEN_RULE1 = 
[[
<T C="229,105,22" S="22">Cường hóa cần tốn Vàng và cấp cường hóa phải thấp hơn cấp nhân vật.</T><BR></BR>
]],
STRENGTHEN_RULE2 = 
[[
<T C="229,105,22" S="22">1. </T><T C="127,70,26" S="18">Kế thừa vũ khí có thể kế thừa kỹ năng của vũ khí tương ứng</T><BR></BR>
<T C="229,105,22" S="22">2. </T><T C="127,70,26" S="18">Kỹ năng vũ khí được kế thừa sẽ khôi phục về kỹ năng mặc định</T><BR>10</BR>
]],
STRENGTHEN_RULE3 = 
[[
<T C="229,105,22" S="22">1. </T><T C="127,70,26" S="18">Mỗi lần tăng sao cần tốn Đá Sao, Vàng, Đá Thánh.</T><BR></BR>
<T C="229,105,22" S="22">2. </T><T C="127,70,26" S="18">Tăng sao dù thành công hay thất bại đều trừ vật phẩm tốn.</T><BR></BR>
<T C="229,105,22" S="22">3. </T><T C="127,70,26" S="18">Cấp tăng sao từ 3 trở xuống, thất bại không bị giảm cấp.</T><BR></BR>
<T C="229,105,22" S="22">4. </T><T C="127,70,26" S="18">Cấp tăng sao trên 3, khi thất bại sẽ bị giảm cấp.</T><BR>10</BR>
]],
STRENGTHEN_RULE4 = 
[[
  <T C="229,105,22" S="22">1. </T><T C="127,70,26" S="18">Đá khảm bao gồm 4 loại: Tấn Công, Phòng Thủ, Sinh Lực, Cộng Hưởng, cấp đá cao nhất là Lv12.</T><BR></BR>
  <T C="229,105,22" S="22">2. </T><T C="127,70,26" S="18">Đá khảm cùng thuộc tính có thể ghép với nhau để nâng cấp.</T><BR></BR>
  <T C="229,105,22" S="22">3. </T><T C="127,70,26" S="18">Mỗi lần khảm cần tốn số Vàng nhất định.</T><BR></BR>
  <T C="229,105,22" S="22">4. </T><T C="127,70,26" S="18">Mỗi loại đá chỉ được khảm vào ô tương ứng.</T><BR></BR>
  <T C="229,105,22" S="22">5. </T><T C="127,70,26" S="18">Nếu ô đã khảm đá, tiếp tục bỏ vào sẽ thay thế đá đã khảm.</T><BR>10</BR>
  <T C="229,105,22" S="22">6. </T><T C="127,70,26" S="18">Đá Lv7 trở lên có thể ghép thành Đá Ma Lực, giữ lại EXP vượt trên Lv7. Đá Ma Lực có thuộc tính mạnh hơn, tối đa tăng đến Đá Thần Lv6.</T><BR>10</BR>
  <T C="229,105,22" S="22">7. </T><T C="127,70,26" S="18">Đá Ma Lực cần dùng nhiều Tinh Hoa Đá Quý về Kết Tinh Đá Quý để nâng cấp, nhận từ Phó Bản Đào Mỏ.</T><BR>10</BR>
  <T C="229,105,22" S="22">8. </T><T C="127,70,26" S="18">Ngoài Đá Cộng Hưởng, các loại đá khác có thể dùng làm nguyên liệu EXP, dùng gộp vào Đá Ma Lực.</T><BR>10</BR>
  <T C="229,105,22" S="22">9. </T><T C="127,70,26" S="18">Đá Thần Lv6 sẽ không thể nhận EXP, cũng không hoàn trả EXP dư nữa.</T><BR>10</BR>
  <T C="229,105,22" S="22">10. </T><T C="127,70,26" S="18">Đá Ma Lực mới: Đá Lục, Đá Lam, Đá Quỷ, Đá Thần sẽ lần lượt đối ứng với bậc 13, 14, 15, 16.</T><BR>10</BR>
]],
STRENGTHEN_RULE5 = 
[[
<T C="229,105,22" S="20">1. </T><T C="127,70,26" S="18">Chỉ có trang bị Cam mới được đổi phẩm.</T><BR></BR>
<T C="229,105,22" S="20">2. </T><T C="127,70,26" S="18">Trang bị Cam có phẩm cấp, có thể thông qua hệ thống Thánh Quang tính năng [Đổi phẩm] để thay đổi phẩm cấp hiện tại của trang bị.</T><BR></BR>
<T C="229,105,22" S="20">3. </T><T C="127,70,26" S="18">[Đổi phẩm] cần tốn Sách Chế Tạo Cam vị trí tương ứng của trang bị và Thuốc Thánh Quang.</T><BR>10</BR>
<T C="229,105,22" S="20">4. </T><T C="127,70,26" S="18">Khi chưa tăng phẩm sẽ tăng điểm may mắn, khi điểm may mắn đầy chắc chắn tăng phẩm thành công</T><BR></BR>
<T C="229,105,22" S="20">5. </T><T C="127,70,26" S="18">Điểm may mắn vĩnh viễn có hiệu lực, các trang bị ghi nhận riêng</T><BR></BR>
<T C="229,105,22" S="20">6.</T><T C="127,70,26" S="18">Tăng phẩm thành công sẽ xóa điểm may mắn</T><BR></BR>
]],
DRESS_RULE = 
[[
  <T C="229,105,22" S="22">1.</T><T C="127,70,26" S="18">Mỗi món thời trang Đầu Tóc sẽ tăng 10 điểm Sức Mạnh.</T><BR></BR>		
  <T C="229,105,22" S="22">2.</T><T C="127,70,26" S="18">Mỗi món thời trang Biểu Cảm sẽ tăng 10 điểm Hộ Giáp.</T><BR></BR>		
  <T C="229,105,22" S="22">3.</T><T C="127,70,26" S="18">Mỗi món thời trang Trang Phục sẽ tăng 10 điểm Thể Chất.</T><BR></BR>		
  <T C="229,105,22" S="22">4.</T><T C="127,70,26" S="18">Mỗi món thời trang Cánh sẽ tăng 10 điểm Phá Giáp.</T><BR></BR>		
  <T C="229,105,22" S="22">5.</T><T C="127,70,26" S="18">Thời trang còn hiệu lực mới tăng thuộc tính.</T><BR></BR>		
  <T C="229,105,22" S="22">6.</T><T C="127,70,26" S="18">Lực chiến chỉ tính thời trang thuộc tính cap nhất, mỗi vị trí 1 món. Nhận thời trang cùng vị trí, chỉ tăng thuộc tính sưu tầm của Tủ Áo.</T><BR></BR>		
]],

FIRST_CHARGE_RULE = 
[[
<T C="229,105,22" S="22">1. </T><T C="127,70,26" S="18">Tại giao diện Nạp mua quà không tính vào nạp lần đầu.</T><BR></BR>
<T C="229,105,22" S="22">2. </T><T C="127,70,26" S="18">Mua Quà Lễ Kỷ Niệm không tính vào nạp lần đầu.</T><BR></BR>
]],
SHOP_5_RULE1 = 
[[
<T C="229,105,22" S="22">1. </T><T C="127,70,26" S="18">Xu Ban Ân từ Hộp Quà trong giao diện Cửa Hàng-Kho Báu.</T><BR></BR>
<T C="229,105,22" S="22">1. </T><T C="127,70,26" S="18">Có thể vào giao diện đổi trong Cửa Hàng tốn Xu Ban Ân đổi vật phẩm tương ứng.</T><BR></BR>
]],
SHOP_5_RULE3 = 
[[
<T C="229,105,22" S="22">1. </T><T C="127,70,26" S="18">Đá Purple từ giao diện Tiệm-Kho Báu dùng Kim Cương rút.</T><BR></BR>
<T C="229,105,22" S="22">1. </T><T C="127,70,26" S="18">Có thể vào giao diện đổi trong Cửa Hàng tốn Đá Purple đổi vật phẩm tương ứng.</T><BR></BR>
]],
FAMILY2_TEXT1 = "Chưa nhận thưởng",
FAMILY2_TEXT2 = "Đang trống",
FAMILY2_TEXT3 = "Số lần Nuôi đã đạt giới hạn, hãy tăng cấp kiến trúc chính để tăng giới hạn",
FAMILY2_TEXT4 = "Số lần Nuôi đã đạt giới hạn, 0:30 mỗi ngày tạo mới",
FAMILY2_TEXT5 = "Nuôi kết thúc, hãy nhận thưởng",
FAMILY2_TEXT6 = "Thưởng Nuôi",
FAMILY2_TEXT7 = [[<T C="255,255,255" S="20" P="1" SC="79,60,48" SS="4" SE="1">Nuôi còn: </T><T C="255,255,255" S="22" P="1" SC="79,60,48" SS="4" SE="1">%d:%02d:%02d</T>]],
FAMILY2_TEXT8 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1"></T><T C="99,255,95" S="18" P="1" SC="79,60,48" SS="4" SE="1"></T><T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1"></T>]],
FAMILY2_TEXT9 = "Bắt đầu Nuôi",
FAMILY2_TEXT10 = "Nghiên cứu đã kết thúc, hãy về nhận thưởng",
FAMILY2_TEXT11 = [[<T C="79,60,48" S="20" P="1">Tăng tốc cần tốn </T><I Z="0.5" P="1">%s</I><T C="79,60,48" S="20" P="1"> x%d, tiếp tục?</T>]],
FAMILY2_TEXT12 = "Nuôi đã hoàn thành, không cần tăng tốc",
FAMILY2_TEXT13 = "Thám Hiểm hoàn thành, không cần tăng tốc",
FAMILY2_TEXT14 = "Thưởng Thám Hiểm",
FAMILY2_TEXT15 = "Bắt đầu Thám Hiểm",
FAMILY2_TEXT16 = "Thám Hiểm kết thúc, hãy nhận thưởng",
FAMILY2_TEXT17 = [[<T C="255,255,255" S="20" P="1" SC="79,60,48" SS="4" SE="1">Thám Hiểm còn: </T><T C="255,255,255" S="22" P="1" SC="79,60,48" SS="4" SE="1">%d:%02d:%02d</T>]],
FAMILY2_TEXT18 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1"></T><T C="99,255,95" S="18" P="1" SC="79,60,48" SS="4" SE="1"></T><T C="255,236,193" S="18" P="1" SC="79,60,48" SS="4" SE="1"></T>]],
FAMILY2_TEXT19 = "Số lần Thám Hiểm đã đạt tối đa, hãy tăng cấp kiến trúc chính để tăng giới hạn",
FAMILY2_TEXT20 = "Số lần Thám Hiểm đã đạt tối đa, 0:30 mỗi ngày tạo mới",
FAMILY2_TEXT21 = "Nuôi",
FAMILY2_TEXT22 = "Thám Hiểm",
REBATE1 = "Hối lộ ta sẽ được giảm giá!",
REBATE2 = "Hối lộ",
REBATE3 = "Thời gian bán: ",
REBATE4 = "Mấy cái này có thể bán rẻ chút.",
REBATE5 = "Đã hối lộ",
REBATE6 = "Đồng ý trả %s Kim Cương hối lộ thương nhân, sau khi hối lộ sẽ giảm giá 10-40% cho 3 vật phẩm ngẫu nhiên đợt này",
REBATE7 = "Vật phẩm đợt này không có giảm giá thấp hơn",
REBATE8 = "Đồng ý trả %s Kim Cương tạo mới danh sách, tạo mới sẽ mất giảm giá",
REBATE9 = "Vật phẩm đợt này không có giảm giá thấp hơn",
REBATE_DESC =
[[
<T C="229,105,22" S="22">Quy tắc hối lộ</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Sau khi hối lộ sẽ giảm giá 3 vật phẩm ngẫu nhiên đợt này</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Sau khi hối lộ giảm 10-40%</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Đợt này không đủ 5 vật phẩm không thể hối lộ, phải chờ tạo mới vật phẩm đợt sau</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Nếu mua vật phẩm được giảm giá nhờ hối lộ, khi tạo mới vật phẩm sẽ về giá cũ</T><BR>20</BR>
]],
GAMEACTIVITY_TIPTEXT1 = [[<T C="255,236,193" S="22" P="1" SC="105,60,46" SS="4" SE="1"></T><T C="255,227,116" S="22" P="1" SC="105,60,46" SS="4" SE="1">%d trang bị </T><T C="255,236,193" S="22" P="1" SC="105,60,46" SS="4" SE="1"> bất kỳ tăng đến </T><T C="255,227,116" S="22" P="1" SC="105,60,46" SS="4" SE="1"> %d Sao</T>]],
GAMEACTIVITY_TIPTEXT2 = {"Thưởng Rút Rương May Mắn x10","Thưởng Rút Đập Trứng x10","Thưởng Rút Bùa (Kim Cương) x10","Thưởng Rút Cửa Hàng (Kim Cương) x5"},
GAMEACTIVITY_TIPTEXT3 = ", ngày %s có thể nhận",
GAMEACTIVITY_TIPTEXT4 = " hoàn trả x%s",
GAMEACTIVITY_TIPTEXT5 = "Tăng sao trang bị",
GAMEACTIVITY_TIPTEXT6 = "Rút x10",
GAMEACTIVITY_TIPTEXT7 = "Hoàn trả Kim Cương",
GAMEACTIVITY_TIPTEXT8 = "Nạp x3",
NEWEXCHANGE_TEXT1 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Mỗi lần đổi tốn </T><I Z="0.4">%s </I><T C="255,227,116" S="20" P="1" SC="79,60,48" SE="1" SS="4">x%d</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">, mỗi ngày có thể đổi </T><T C="255,227,116" S="20" P="1" SC="79,60,48" SE="1" SS="4">%d</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4"> lần</T>]],
NEWEXCHANGE_TEXT2 = "Hoạt động Đổi",
GAMEACTIVITY_TIPTEXT9 = "Nạp 1 lần",
GAMEACTIVITY_TIPTEXT10 = 
[[
<T C="229,105,22" S="22">Nạp Ít Nhận Nhiều</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Trong thời gian hoạt động, nạp 1 lần đúng mốc yêu cầu, sẽ hoàn thành điều kiện nhận thưởng</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Sau khi thỏa điều kiện nhận thưởng, sẽ nhận thưởng bắt đầu từ phẩn thưởng của ngày 1</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Sau khi sự kiện kết thúc, phần thưởng còn lại chưa nhận, hệ thống sẽ gửi bù qua thư</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Mua Túi Quà Vip sẽ không được tính, phải nạp 1 lần đúng mốc chứ không được tích lũy nạp</T><BR>20</BR>
]],
GIFTTIP1 = "Đã có tất cả Thú Cưỡi trong quà, đồng ý mua?",
GIFTTIP2 = "Đã có tất cả Skin trong quà, đồng ý mua?",
MANYCOLLECT_TEXT1 = "Vui Góp",
MANYCOLLECT_TEXT2 = "Danh sách thưởng",
MANYCOLLECT_TEXT3 = "Góp thành công",
MANYCOLLECT_TEXT4 = "Góp",
MANYCOLLECT_TEXT5 = "Số lượng đầu tư",
MANYCOLLECT_TEXT6 = 
[[
<T C="229,105,22" S="22">Quy Tắc Đầu Tư</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Đầu tư 1 lần sẽ nhận được Giải Tham Dự, phần thưởng Giải Tham Dự sẽ gửi trực tiếp  vào túi của người chơi.</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Phần thưởng Giải Tham Dự của mỗi mốc Đầu Tư chỉ có thể nhận 1 lần, phần thưởng  Giải Đặc Biệt sau khi mở thưởng sẽ được gửi vào hộp thư của người chơi trúng thưởng.</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Mỗi mốc đầu tư sau khi mở thưởng, thì mốc đầu tư này sẽ được làm mới lại từ đầu.</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Trong sự kiện Đầu Tư, đầu tư Giải Tham Dự càng nhiều thì càng có cơ hội trúng  Giải Đặc Biệt.</T><BR></BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Trong thời gian diễn ra sự kiện, nếu chưa đạt đủ số lượng Giải Tham Dự yêu cầu để  có thể mở thưởng Giải Đặc Biệt, thì sẽ không mở thưởng Giải Đặc Biệt.</T><BR>10</BR>
]],
MANYCOLLECT_TEXT7 = "Mỗi phiếu",
MANYCOLLECT_TEXT8 = "Giải Tham Dự",
MANYCOLLECT_TEXT9 = "Giải Đặc Biệt",
MANYCOLLECT_TEXT10 = [[<T C="255,236,193" S="22" P="1" SC="105,60,46" SS="4" SE="1">Xác nhận mua </T><T C="255,227,116" S="22" P="1" SC="105,60,46" SS="4" SE="1">%d</T><T C="255,236,193" S="22" P="1" SC="105,60,46" SS="4" SE="1"> phiếu</T>]],
MANYCOLLECT_TEXT11 = "Chỉ được nhập số",
MANYCOLLECT_TEXT12 = "Chưa có danh sách thưởng",
MANYCOLLECT_TEXT13 = [[<T C="255,255,255" S="20" P="1" SC="105,60,46" SS="4" SE="1">%s </T><T C="255,236,193" S="20" P="1" SC="105,60,46" SS="4" SE="1"> trong thời gian rút thưởng </T><T C="255,227,116" S="20" P="1" SC="105,60,46" SS="4" SE="1">(%s)</T><T C="255,236,193" S="20" P="1" SC="105,60,46" SS="4" SE="1"> nhận quà siêu!!</T>]],
MANYCOLLECT_TEXT14 = "Chỉ được góp 1 lần",
ACTIVITY_BUY_SECOND = "Thao tác sẽ tốn Kim Cương nhất định, mua không?",
MUTLIP_COPY_SWEEP_TIP = "Không thể càn quét phó bản này",
MANYCOLLECT_TEXT15 = [[<T C="105,65,46" S="18" P="1" SC="105,60,46" SS="4" SE="0">(Nhấp nhập số lượng mua)</T>]],
GAMEACTIVITY_TIPTEXT5 = [[Chỉ định nạp]],
GAMEACTIVITY_TIPTEXT6 = 
[[
<T C="229,105,22" S="22">Quy tắc</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Hoạt động tổng cộng có 3 loại quà 1,6,12 đồng, thưởng phong phú</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Mỗi quà mỗi ngày được mua 1 lần, 24 giờ mỗi ngày sẽ tạo mới</T><BR></BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Quà sau khi mua sẽ đưa vào túi, hãy kiểm tra</T><BR>10</BR>
]],
WORLD_TEAM_IV_TIP = "Mời Thế Giới",
WORLD_TEAM_IV_TXT = "Đang ở phó bản %s, nhấp cùng đánh BOSS!",
WORLD_TEAM_IV_ERROR = "Thiết lập mật khẩu không thể mời tổ đội thế giới",
WORLD_TEAM_IV_ERROR2 = "Cảnh hiện tại không thể bỏ qua",
CANTADD = "Tạm không thể thêm người chơi liên server!",
LUCKYFULL1 = "Điểm may mắn đầy chắc chắn tăng phẩm", 
PETLOCK1 = "Khóa loại",
PETLOCK2 = "Khóa tất cả",
PETLOCK3 = "Tối thiểu chừa 1 kỹ năng cần tẩy luyện",
ACTIVITY_RECHARGELEVEL = "Nạp Định Mức",
ACTIVITY_RECHARGE_MONEY = "Nạp 1 lần đúng %s",
ACTIVITY_RECHARGELEVEL_DESC = "Nạp mức tương ứng có thể nhận thưởng, hoạt động tạo mới mỗi ngày",
GAMEACTIVITY_NEWRECHARGEBACK = 
[[
<T C="229,105,22" S="22">Hoàn trả tích lũy nạp x5</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Trong thời gian hoạt động nạp tích lũy 880 Kim Cương, đạt điều kiện nhận thưởng</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Mua vật phẩm quà không tính vào tích lũy nạp</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Hoàn thành điều kiện nhận thưởng sẽ nhận từ ngày thưởng đầu tiên</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Hoạt động kết thúc sẽ hủy thưởng chưa nhận hoặc thưởng chưa đạt, hãy mua sớm</T><BR>20</BR>
]],
GAMEACTIVITY_NEWRECHARGEBACK2 = "Hoàn trả tích lũy nạp",
GAMEACTIVITY_NEWRECHARGEBACK3 = "Tích lũy nạp đạt",
TEACH_212 = "Nhấp nút vào nhanh",
TEACH_213 = "Nhấp nút chuẩn bị vào game",
WAKEUP_TEXT36 = "Loại thuộc tính",
WAKEUP_TEXT37 = "Loại tài phù",
LOVELOTTERY_TEXT1 = "Nhắc nhở: Rút đạt số lần nhất định có thể nhận thưởng lớn",
NEWSHOP81 = "Bộ Ma Ảo",
NEWSHOP82 = "Bộ Tương Lai",
NEWSHOP83 = "Bộ Ác Ma",
NEWSHOP84 = "Bộ Sa Mạc",
NEWSHOP85 = "Bộ Sấm Sét",
NEWSHOP86 = "Bộ Băng",
NEWSHOP87 = "Bộ Trắng",
NEWSHOP26 = [[Rương May Mắn nhận]],
LOVELOTTERY_TEXT2 = 
[[
<T C="229,105,22" S="22">Quy tắc rút thưởng may mắn</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Mỗi lần rút thưởng tăng 1 điểm tiến độ</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Khi tiến độ đạt 20, 100, 200 sẽ được nhận thưởng gửi qua thư.</T><BR></BR>
<T C="127,70,26" S="20">3.</T><T C="127,70,26" S="18">Sau khi hoàn thành và nhận thưởng, sẽ tạo mới tiến độ. (Được nhận thưởng nhiều lần nhé!)</T><BR></BR>
<T C="127,70,26" S="20">4.</T><T C="127,70,26" S="18">Khi hoạt động kết thúc, phần thưởng chưa nhận sẽ bị hủy! Mua càng sớm, thưởng càng nhiều</T><BR>20</BR>
<T C="127,70,26" S="20">Xác suất rút thưởng</T><T C="127,70,26" S="18"></T><BR>20</BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Thời trang/Thú cưỡi/Skin/Vũ khí:             1%</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Rương Mảnh Đá Tăng Phẩm-Cao:              3%</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Pet:                           4%</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Mảnh Bùa/Đá Thức Tỉnh-Cao/Cầu Mộng Ảo: 15%</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Thuốc Nhuộm/Sách Lĩnh Ngộ:                20%</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Sách Kỹ Năng-Trung/Đá Thức Tỉnh-Trung:         28%<BR></BR>
]],

IS_COST_MONEY = "Tốn %d Kim Cương, đồng ý tiếp tục?",
LOURAACT14 = "Quà siêu giá trị!",
LOURAACT11= "Thời trang Long Cung",
LOURAACT12 = "Độc Thân",
LOURAACT2 = "Đổi hạn giờ",
LOURAACT3 = "Giảm giá cực thấp",
LOURAACT13 = "Mua giới hạn siêu giá trị",
CARD_ACTIVITY_TEXT1 = [[<T C="255,236,193" S="18" P="1" SC="105,60,46" SS="4" SE="0">Giá cực tốt, chỉ 1 lần</T>]],
CARD_ACTIVITY_TEXT2 = [[<BR></BR><T C="255,236,193" S="18" P="1" SC="105,60,46" SS="4" SE="0">(Chỉ giới hạn 1 lần)</T>]],
CARD_ACTIVITY_TEXT3 = [[<T C="255,236,193" S="18" P="1" SC="105,60,46" SS="4" SE="0">11/11, mua 1 tặng 1</T>]],
CARD_ACTIVITY_TEXT4 = [[<BR></BR><T C="255,236,193" S="18" P="1" SC="105,60,46" SS="4" SE="0">(Đã mua)</T>]],
CARD_ACTIVITY_TEXT5 = [[<T C="255,236,193" S="18" P="1" SC="105,60,46" SS="4" SE="0">Mua 1 tặng 1, chỉ được 1 lần</T>]],
CARD_ACTIVITY_TEXT6 = "Phúc lợi Thẻ Tháng",
CARD_ACTIVITY_TEXT7 = "Phúc lợi Thẻ Tuần",
NO_ATTR_ADD = "Tạm không có thuộc tính tăng",
EQUIPTYPETIP2 = "Tăng phòng Thủ nhân vật",
EQUIPTYPETIP3 = "Tăng miễn bạo nhân vật",
EQUIPTYPETIP4 = "Tăng sinh lực nhân vật",
EQUIPTYPETIP5 = "Tăng bạo Kích nhân vật",
EQUIPTYPETIP6 = "Tăng sinh lực nhân vật",
EQUIPTYPETIP7 = "Tăng phá giáp nhân vật",
EQUIPTYPETIP8 = "Tăng miễn thương nhân vật",
ACIVIITY_RECHARGERANK = "BXH Nạp Máy Chủ Này",
ACIVIITY_CROSS_RECHARGERANK = "BXH Nạp Toàn Máy Chủ",
ACIVIITY_CONSUMERANK = "BXH Tiêu Máy Chủ Này",
ACIVIITY_CROSS_CONSUMERANK = "BXH Tiêu Toàn Máy Chủ",
GIVE_MOVE = "Gọi lại %d lần tặng thêm",
GIVE_MOVE2 = [[<T C="79,60,48" S="20" P="1" >Gọi lại </T><T C="128,54,13" S="20" P="1" >%d</T><T C="79,60,48" S="20" P="1" > lần tặng thêm </T>]],
CALL_REWAR = "Thưởng Gọi",
GIVE_MOVE3 = [[<T C="79,60,48" S="20" P="1" >Có thể nhận</T>]],
GIVE_MOVE4 = [[<T C="79,60,48" S="20" P="1" >Đã nhận</T>]],
VIPWEEK_PACKAGE = "Quà Tuần",
VIPWEEK_PACKAGE2 = [[<T C="255,227,116" S="22" P="1" SC="105,60,46" SS="4" SE="1">VIP%d</T><T C="255,236,193" S="22" P="1" SC="105,60,46" SS="4" SE="1"> trở lên có thể mua</T><T C="105,64,46" S="18" P="1" SC="105,60,46" SS="4" SE="0">(Mỗi Chủ nhật 24:00 tạo mới)</T>]],
ADVENTURE_STORE = "Tiệm Mạo Hiểm",
JEDI_ADVENTURE_OVER = "Hoạt động khiêu chiến Mạo Hiểm lần này đã kết thúc!",
ADVENTURE_DESC1 = 
[[
1. 12:00-14:00 mỗi ngày mở khiêu chiến Mạo Hiểm
2. Lv35 mới được tham gia khiêu chiến
3. Khiêu chiến gồm hỗn chiến 6 người, người tồn tại sau cùng sẽ là Vua
4. Sau khi vào chiến đấu, kỹ năng chiến đấu hoàn toàn ngẫu nhiên
5. Sau khi vào chiến đấu, ô đạo cụ sẽ trống, cần tự mở hoặc dùng đạn mở rương mới nhận được đạo cụ sử dụng
6. Sau khi vào chiến đấu, người chơi cần tự di chuyển, bay và dùng vũ khí để mở rộng phạm vi tầm nhìn
7. Sau khi vào chiến đấu sẽ có khói độc tăng dần theo thời gian và lan khắp bản đồ, người chơi phải tránh khói độc
]],
JUEDITIPS1 = "Thuộc tính chiến đấu Mạo Hiểm",
JUEDITIPS2 = "*Mạo Hiểm là dạng thi đấu nghiêng về kỹ thuật, trong cách chơi này thuộc tính nhân vật cân bằng",
ESCAPE_TREASURE = "Rương Đạo Cụ",
ADVENTURE_COIN = "Xu Mạo Hiểm",
VIPWEEK_PACKAGE3 = "Ưu đãi hạn giờ",
VIPWEEK_PACKAGE4 = [[<T C="255,227,116" S="20" P="1" SC="105,60,46" SS="4" SE="1">Quà hạn giờ còn: </T><T C="255,236,193" S="20" P="1" SC="105,60,46" SS="4" SE="1">%d:%02d:%02d</T>]],
VIPWEEK_PACKAGE5 = "Đã đóng đăng ký, hãy đến máy chủ mới nhận trải nghiệm tốt nhất!", 
LOURAACT15 = "Tiệm Thần Bí",
EQUIPMENT_DRAW_EXPLAIN =
[[
<T C="229,105,22" S="22">Quy tắc thưởng thêm Rút x10</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Gọi x10 thưởng thêm chỉ giới hạn mức 1888 Kim Cương</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Thưởng thêm phải nhận thủ công</T><BR></BR>
]],
CHANGE_OPEN_TIP = "Nhân vật cần đạt Lv%d mới có thể khiêu chiến!",
DAILYRESET1 = "Lượt tạo mới hôm nay đã dùng hết",
DAILYRESET2 = "Đồng ý dùng %s tạo mới Bí Cảnh?",
DAILYRESET3 = "Hạng sát thương",
CONVERSION1 = "Đã có",
CONVERSION2 = "Tu luyện x2",
CONVERSION3 = "Mở tu luyện x2, mỗi lần tu luyện tốn %s Kim Cương nhận tu luyện x2 EXP",
FAST_GET_ITEM = "Tạm không được nhận nhanh",

FOOTMARK_TEXT1 = [[<I Z="0.8">ui/common/commom_icon_zj2.png</I><A IMG = "ui/common_num/common_num_zhandouli.png" Z ="0.8" W = "16" H = "26" CHAR = "0">%d</A>]],
FOOTMARK_TEXT2 = "Tinh luyện",
FOOTMARK_TEXT3 = "DS Dấu Chân",
FOOTMARK_TEXT4 = "Ẩn",
FOOTMARK_TEXT5 = "Nhắc nhở: Tất cả thuộc tính Dấu Chân được cộng dồn",
FOOTMARK_TEXT6 = "Dấu Chân vĩnh viễn mới được lên cấp",
FOOTMARK_TEXT7 = "Dấu Chân vĩnh viễn mới được tinh luyện",
FOOTMARK_TEXT8 = "Tinh luyện Dấu Chân",
FOOTMARK_TEXT9 = "Dấu Chân lên cấp",
FOOTMARK_TEXT10 = "Tổng thuộc tính Dấu Chân",
FOOTMARK_TEXT11 = "Mỗi Dấu Chân được cộng dồn thuộc tính, khi sử dụng không ảnh hưởng đến thuộc tính đã tăng",
FOOTMARK_TEXT12 = "Đồng ý tốn %s%d kích hoạt Dấu Chân",
CRANK1 = "Tổng sát thương",
CRANK2 = "Không có thông tin sát thương",
PETLIBRARY1 = "Thư Viện kỹ năng Pet",
CRANK3 = "Tỉ lệ sát thương",
FOOTMARK_TEXT13 = "Dấu Chân đã đạt cấp cao nhất",
FOOTMARK_TEXT14 = "Dấu Chân đạt cấp tinh luyện cao nhất",
FOOTMARK_TEXT15 = "Dấu Chân cần đạt Lv%d mới được tinh luyện",
FOOTMARK_TEXT16 = [[<T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">%d </T><I P="1" Z="0.45">%s</I><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4"> kích hoạt</T>]],
FOOTMARK_TEXT17 = [[<I P="1" Z="0.45">%s </I><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">x%d</T><T C="158,0,0" S="22" P="1">(Chưa nhận)</T>]],
FOOTMARK_TEXT18 = "Kích hoạt",
FOOTMARK_TEXT19 = [[<T C="195,171,148" S="16" P="0">Tăng cấp %d lần,Dấu Chân tăng Lv%d, tốn %d%s </T>]],
FOOTMARK_TEXT20 = [[<T C="195,171,148" S="14" P="0">Tăng cấp lần %d, %d->%d, tốn %d%s, tỉ lệ thành công %s, </T><T C="99,255,95" S="14" P="0">thành công</T>]],
FOOTMARK_TEXT21 = [[<T C="195,171,148" S="14" P="0">Tăng cấp lần %d, %d->%d, tốn %d%s, tỉ lệ thành công %s, </T><T C="255,89,74" S="14" P="0">thất bại</T>]],
FOOTMARK_TEXT22 = "Thời gian thử còn",
FOOTMARK_TEXT23 = "Dùng Thẻ Thử Nghiệm thành công, thời gian +%d ngày",
FOOTMARK_TEXT24 = [[<I P="1" Z="0.45">%s </I><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="233,166,62" S="22" P="1" SC="79,60,48" SE="1" SS="4">x%d</T><T C="0,72,3" S="22" P="1">(Đã nhận)</T>]],
FOOTMARK_TEXT25 = "Tăng cấp nhân vật mới được tiếp tục tăng cấp Dấu Chân",
FOOTMARK_TEXT26 = "Dấu Chân đạt giới hạn cấp! Giỏi quá!",
FOOTMARK_TEXT27 = "Tinh luyện Dấu Chân đạt giới hạn! Giỏi quá!",
FOOTMARK_TEXT28 = "Tăng cấp nhân vật mới được tiếp tục tinh luyện Dấu Chân",
CLOWN_EXPLAIN = 
[[
<T C="229,105,22" S="22">Quy tắc Chú Hề Tìm Kho Báu</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Mỗi ngày được tìm kho báu miễn phí 3 lần, 24:00 tạo mới</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Mỗi ngày được giở mánh khóe miễn phí 3 lần, 24:00 tạo mới</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Tìm báu vật được càng nhiều Nón Chú Hề thưởng càng cao, có thể dùng mánh khóe để thay đổi kết quả</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Xem trước thưởng</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">  --Không có 5 Huy Chương Cầu Phúc Chú Hề tương ứng</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">  --1 Nón Chú Hề tương ứng 10 Huy Chương Cầu Phúc</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">  --2 Nón Chú Hề tương ứng 20 Huy Chương Cầu Phúc</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">  --3 Nón Chú Hề tương ứng 30 Huy Chương Cầu Phúc</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">  --4 Nón Chú Hề tương ứng 50 Huy Chương Cầu Phúc, 1 Xu Cầu Phúc</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">  --5 Nón Chú Hề tương ứng 70 Huy Chương Cầu Phúc, 2 Xu Cầu Phúc</T><BR></BR>
]],
CLOWN_TIP1 = "Kéo thử xem?",
CLOWN_TIP2 = "Hôm nay may mắn, thử lần nữa nào!",
CLOWN_TIP3 = "Lại gặp mặt",
CLOWN_TIP4 = "Trúng số lần nào chưa?",
CLOWN_TIP5 = "Chúc may mắn!",
CLOWN_TIP6 = "Hay là chúng ta giở mánh khóe một tí nhỉ?",
CLOWN_TIP7 = "Xem ra đổi tiếp là đến lượt rồi!",
CLOWN_TIP8 = "Thay đổi 1 chút, tăng phần thưởng",
CLOWN_TIP9 = "Thay đổi chút đi",
CLOWN_TIP10 = "Tiếp tục nào, sắp trúng thưởng rồi!",
TODAY_TREASURE_COUNT = "Lần %d tầm bảo: ",
NOT_GET_TREASURE_TIP = "Hãy nhận thưởng tầm bảo lần này",
TREASURE_RESERT_TIP3 = "Số lần không đủ, dùng %d Kim Cương tìm kho báu không? (Đã dùng %d/%d lần)",
TREASURE_RESERT_TIP4 = "Hôm nay đã dùng %d/%d lần, VIP%d được nhiều lần hơn!",
TREASURE_RESERT_TIP5 = "Đồng ý trả %d Kim Cương giở mánh khóe? (Đã dùng %d/%d lần)",
TREASURE_RESET_TIP6 = "Đợi nhận thưởng tầm bảo",
CHALLENGE_SURPLUS_COUNT = "Khiêu chiến còn: ",
CANTUPLOAD = "Không thể Upload",
NO_UPLOAD_PHOTOS = "Upload hình không hợp lệ, tạm cấm Upload",
ADVISE_HERO_DESC2 = "Nếu gặp vấn đề trong game, vui lòng liên hệ CSKH để được hướng dẫn.",
GUILDWAR_NEWTEXT1 = "Công Hội Chiến đã kết thúc",

AUTOSELL = "Tự bán",
CHECKOTHER11 = "Dấu Chân",
AUTOSELL1 = "Tự động",
CHRISTMASTREE_TEXT1 = "Hạng điểm Noel",
CHRISTMASTREE_TEXT2 = "Hoạt động mở sau: ",
CHRISTMASTREE_TEXT3 = "Hoạt động kết thúc sau: ",
CHRISTMASTREE_TEXT4 = "Đóng giao diện sau: ",
CHRISTMASTREE_TEXT5 = [[<T C="255,255,255" S="16" P="1" SC="79,60,48" SE="0" SS="4">Toàn server mỗi khi mua %d Điểm, mỗi người được rút miễn phí 1 lần</T>]],
CHRISTMASTREE_TEXT6 = "Rương quà",
CHRISTMASTREE_TEXT7 = "Rút thưởng miễn phí",
CHRISTMASTREE_TEXT8 = "Cầu Nguyện 10 lần",
CHRISTMASTREE_TEXT9 = 
[[
<T C="229,105,22" S="22">Hướng dẫn HĐ Cây Noel</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Cầu Nguyện Cây Noel có thể nhận điểm, miễn phí được 1 điểm, rút được 2 điểm, Rút x10 được 20 điểm</T><BR></BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Điểm Cầu Nguyện toàn server đạt 10000, người chơi toàn server được Cầu Nguyện miễn phí 1 lần</T><BR></BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Điểm Cầu Nguyện càng cao, hạng càng cao nhận thưởng càng nhiều</T><BR></BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Thưởng hạng: </T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Hạng 1: </T><T C="99,255,95" S="16" P="0" SC="79,60,48" SE="1" SS="4">Dấu Chân Chuông x1, Đá Tinh Luyện-Cao x5, Đạn Cấp Dấu Chân x500, Vàng x1000 Vạn</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Hạng 2: </T><T C="99,255,95" S="16" P="0" SC="79,60,48" SE="1" SS="4">Dấu Chân Chuông x1, Đá Tinh Luyện-Trung x5, Đạn Cấp Dấu Chân x300, Vàng x500 Vạn</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Hạng 3: </T><T C="99,255,95" S="16" P="0" SC="79,60,48" SE="1" SS="4">Dấu Chân Chuông x1, Đá Tinh Luyện-Sơ x10, Đạn Cấp Dấu Chân x200, Vàng x300 Vạn</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Hạng 4-10</T><T C="99,255,95" S="16" P="0" SC="79,60,48" SE="1" SS="4"> Dấu Chân Chuông (7 ngày) x1, Đạn Cấp Dấu Chân x100, Vàng x200 Vạn</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Hạng 11-50: </T><T C="99,255,95" S="16" P="0" SC="79,60,48" SE="1" SS="4"> Dấu Chân Chuông (3 ngày) x1, Đạn Cấp Dấu Chân x50, Vàng x100 Vạn</T><BR></BR>
<T C="127,70,26" S="20"></T><T C="127,70,26" S="18">Hạng 51-10000: </T><T C="99,255,95" S="16" P="0" SC="79,60,48" SE="1" SS="4"> Đạn Cấp Dấu Chân x100, Vàng x50 Vạn</T><BR></BR>
]],
CHRISTMASTREE_TEXT10 = "Rương quà đã đầy, sắp xếp rồi rút",
CHRISTMASTREE_TEXT11 = "Rút hết",
CHRISTMASTREE_TEXT12 = "Sắp xếp ngay",
CHRISTMASTREE_TEXT13 = [[<T C="255,236,193" S="16" P="1">Miễn phí %d lần</T>]],
CHRISTMASTREE_TEXT14 = "Rương quà trống, hãy rút thưởng",
CHRISTMASTREE_TEXT15 = "Không có quà",
CHRISTMASTREE_TEXT16 = "Hoạt động chưa bắt đầu, đang cập nhật!",
CHRISTMASTREE_TEXT17 = "Hoạt động đã kết thúc, không thể rút thưởng",
CHRISTMASTREE_TEXT18 = "Đã sắp xếp",
CHRISTMASTREE_TEXT19 = "Rút thành công",
CHRISTMASTREE_TEXT20 = "Cây Noel",
CHRISTMASTREE_TEXT21 = "Cầu Nguyện 1 lần",
THEMATIC_TASKS = "NV hoạt động",
DAILY_TASKS_TYPE = "(Mỗi ngày)",
ONLY_TASKS_TYPE = "(Duy nhất)",
LINE_VIP_ENGOUH = "Màu sắc dành riêng VIP, bạn chưa phải VIP",
SETTING_LINE = "Màu sắc: ",
LOURAACT16 = "Khuyến mãi Noel",
SECKILL1 = "Tranh mua -%s",
SECKILL2 = "Giới thiệu: ",
SECKILL3 = "Tranh mua hôm nay: [%s], mỗi người mua nhiều nhất %s. Ngoài thời gian tranh mua sẽ bán ưu đãi và được mua giới hạn!",
SECKILL4 = "Tranh mua còn",
SECKILL5 = "Bắt đầu: ",
SECKILL6 = "Kết thúc: ",
SECKILL7 = "Chậm quá, bán hết hàng rồi!",
SECKILL8 = "[Máy chủ còn %d]",

NEW_PRODUCT_PACKS = "Túi Quà Gói Vật Phẩm Mới",
TEACH_180 = "Tính năng mới ở đây",
NEWACTIVITY_THE_SERVICE_RECHARGE_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc sự kiện:</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Sự kiện áp dụng chỉ cho người chơi tại máy chủ này.</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Người chơi nằm trong top BXH nạp kim cương sẽ được nhận thưởng tương ứng với thứ hạng.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Kết quả sẽ được tổng kết lúc 23 giờ 59 phút 00 giây của ngày cuối sự kiện.</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Các trường hợp nạp sau 23 giờ 59 phút 01 giây sẽ không được hệ thống ghi nhận.</T><BR>10</BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Phần thưởng sẽ được tự động trao qua thư sau khi sự kiện kết thúc.</T><BR>10</BR>
<T C="127,70,26" S="20">6. </T><T C="127,70,26" S="18">BXH sẽ được duy trì hiển thị thêm 1 ngày sau khi sự kiện kết thúc để người chơi tiện theo dõi.</T><BR>10</BR>
<T C="127,70,26" S="20">Đặc biệt:  </T><T C="127,70,26" S="18">Phần thưởng TOP 1 chỉ xuất hiện duy nhất độc quyền trong các sự kiện đua top!</T><BR>10</BR>
]],
NEWACTIVITY_CROSS_SERVICE_RECHARGE_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc sự kiện:</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Sự kiện áp dụng cho người chơi trên tất cả máy chủ.</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Người chơi nằm trong top BXH nạp kim cương sẽ được nhận thưởng tương ứng với thứ hạng.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Kết quả sẽ được tổng kết lúc 23 giờ 59 phút 00 giây của ngày cuối sự kiện.</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Các trường hợp nạp sau 23 giờ 59 phút 01 giây sẽ không được hệ thống ghi nhận.</T><BR>10</BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Phần thưởng sẽ được tự động trao qua thư sau khi sự kiện kết thúc.</T><BR>10</BR>
<T C="127,70,26" S="20">6. </T><T C="127,70,26" S="18">BXH sẽ được duy trì hiển thị thêm 1 ngày sau khi sự kiện kết thúc để người chơi tiện theo dõi.</T><BR>10</BR>
<T C="127,70,26" S="20">Đặc biệt:  </T><T C="127,70,26" S="18">Phần thưởng TOP 1 chỉ xuất hiện duy nhất độc quyền trong các sự kiện đua top!</T><BR>10</BR>
]],
NEWACTIVITY_THE_SERVICE_CONSUMPTION_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc sự kiện:</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Sự kiện áp dụng chỉ cho người chơi tại máy chủ này.</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Người chơi nằm trong top BXH tiêu kim cương sẽ được nhận thưởng tương ứng với thứ hạng.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Kết quả sẽ được tổng kết lúc 23 giờ 59 phút 00 giây của ngày cuối sự kiện.</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Các trường hợp tiêu sau 23 giờ 59 phút 01 giây sẽ không được hệ thống ghi nhận.</T><BR>10</BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Phần thưởng sẽ được tự động trao qua thư sau khi sự kiện kết thúc.</T><BR>10</BR>
<T C="127,70,26" S="20">6. </T><T C="127,70,26" S="18">BXH sẽ được duy trì hiển thị thêm 1 ngày sau khi sự kiện kết thúc để người chơi tiện theo dõi.</T><BR>10</BR>
<T C="127,70,26" S="20">Đặc biệt:  </T><T C="127,70,26" S="18">Phần thưởng TOP 1 chỉ xuất hiện duy nhất độc quyền trong các sự kiện đua top!</T><BR>10</BR>
]],
NEWACTIVITY_CROSS_SERVICE_CONSUMPTION_RULE = 
[[
<T C="229,105,22" S="22">Quy tắc sự kiện:</T><BR></BR>
<T C="127,70,26" S="20">1. </T><T C="127,70,26" S="18">Sự kiện áp dụng cho người chơi tất cả máy chủ.</T><BR>10</BR>
<T C="127,70,26" S="20">2. </T><T C="127,70,26" S="18">Người chơi nằm trong top BXH tiêu kim cương sẽ được nhận thưởng tương ứng với thứ hạng.</T><BR>10</BR>
<T C="127,70,26" S="20">3. </T><T C="127,70,26" S="18">Kết quả sẽ được tổng kết lúc 23 giờ 59 phút 00 giây của ngày cuối sự kiện.</T><BR>10</BR>
<T C="127,70,26" S="20">4. </T><T C="127,70,26" S="18">Các trường hợp tiêu sau 23 giờ 59 phút 01 giây sẽ không được hệ thống ghi nhận.</T><BR>10</BR>
<T C="127,70,26" S="20">5. </T><T C="127,70,26" S="18">Phần thưởng sẽ được tự động trao qua thư sau khi sự kiện kết thúc.</T><BR>10</BR>
<T C="127,70,26" S="20">6. </T><T C="127,70,26" S="18">BXH sẽ được duy trì hiển thị thêm 1 ngày sau khi sự kiện kết thúc để người chơi tiện theo dõi.</T><BR>10</BR>
<T C="127,70,26" S="20">Đặc biệt:  </T><T C="127,70,26" S="18">Phần thưởng TOP 1 chỉ xuất hiện duy nhất độc quyền trong các sự kiện đua top!</T><BR>10</BR>
]],
GAMEACTIVITY_COST_ONLYDIAMOND ="Tích lũy tiêu phí",
GAMEACTIVITY_TYPE_5009 ="Thưởng online server mới",
GAMEACTIVITY_NEWSERVER_CARPACKAGE ="Rút thưởng túi thẻ",
GAMEACTIVITY_NEWSERVER_BREAKEGGS ="Đập Trứng Vàng",
GAMEACTIVITY_NEWSERVER_TIMEDISCOUNT ="Ưu đãi ngày",
GAMEACTIVITY_NEWSERVER_DIAMONDROUND ="Vòng Quay Kim Cương",
GAMEACTIVITY_NEWSERVER_TIMECHALLENGE ="Khiêu chiến hạn giờ",
GAMEACTIVITY_NEWSERVER_ATHLETICSUP ="Tăng bậc Thi Đấu",
GAMEACTIVITY_NEWSERVER_TOTALRECHARGE ="Tích Lũy Nạp",
GAMEACTIVITY_NEWSERVER_SINGLECOPY ="Phó Bản Tích Lũy",
GAMEACTIVITY_NEWSERVER_FIGHTINGRANK ="Lực Chiến BXH Tháng",
BIND_TOURISTS = "Liên Kết Tài Khoản",
GAME_ACTIVITY_TYPE_5010 = "Nhân vật mới tích lũy đăng nhập",
GAME_ACTIVITY_TEN_LOTTERY ="Thưởng Rút x10",
GAME_ACTIVITY_MANY_COLLECT ="Vui Góp",
GAME_ACIVIITY_OLD_EXCHANGE ="Đổi",
TEACH_214 = "Nhấp nút Đồng Hành",
LOURAACT14 = "Đừng bỏ lỡ Quà Siêu Cấp!",
LOURAACT11= "Thời trang Long Cung",
LOURAACT12 = "Độc Thân",
LOURAACT2 = "Đổi Hạn Giờ",
LOURAACT3 = "Trở Lại-Cực",
LOURAACT13 = "Mua giới hạn siêu giá trị",

GUILDWAR_NEWTEXT1 = "Công Hội Chiến đã kết thúc",
ACTIVITYTIME_FORMAT = "%02d.%02d %02d:%02d-%02d.%02d %02d:%02d",
NEWDESC1 = "Thuộc tính thời trang có thể cộng dồn",
NEWSTONE1 = "Thuộc tính Đá",
NEWSTONE2 = "Đá Vô Cực",
NEWSTONE3 = "Lv%s mở Đá Vô Cực",
NEWSTONE4 = "Thuộc tính đá cơ bản",
NEWSINGIN1 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">Tháng này tích lũy </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> lần có thể nhận</T>]],
NEWSINGIN2 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">Tháng này đã điểm danh </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> lần</T>]],
NEWSINGIN3 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">Người chơi VIP3 trở lên có thể tốn </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><I Z="0.46">%s</I><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> điểm danh bù ngay</T>]],
NEWSINGIN4 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">Hiện tại có thể điểm danh bù </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> lần</T>]],
NEWSINGIN5 = "Điểm danh bù",
NEWSINGIN6 = "Không cần điểm danh bù",
SEVENDAY_TEXT1 = {"Ngày 1", "Ngày 2", "Ngày 3", "Ngày 4", "Ngày 5", "Ngày 6", "Ngày 7", "Ngày 8", "Ngày 9", "Ngày 10"},
SEVENDAY_TEXT2 = "Ngày thứ %d mở",
SEVENDAY_TEXT3 = {"Phúc Lợi Ngày", "Vùng Mạo Hiểm", "Cường hóa trang bị", "Ưu Đãi Giới Hạn"},
SEVENDAY_TEXT4 = [[<T C="255,236,193" S="18" P="1" SC="105,65,46" SE="1" SS="4">Thời gian kết thúc hoạt động: </T>]],
SEVENDAY_TEXT5 = [[<T C="255,236,193" S="18" P="1" SC="105,65,46" SE="1" SS="4">Thời gian kết thúc nhận thưởng: </T>]],
SEVENDAY_TEXT6 = [[<T C="255,89,74" S="18" P="1" SC="105,65,46" SE="1" SS="4">%02d</T><T C="255,236,193" S="18" P="1" SC="105,65,46" SE="1" SS="4">ngày </T><T C="255,89,74" S="18" P="1" SC="105,65,46" SE="1" SS="4">%02d</T><T C="255,236,193" S="18" P="1" SC="105,65,46" SE="1" SS="4"> giờ </T><T C="255,89,74" S="18" P="1" SC="105,65,46" SE="1" SS="4">%02d</T><T C="255,236,193" S="18" P="1" SC="105,65,46" SE="1" SS="4"> phút </T><T C="255,89,74" S="18" P="1" SC="105,65,46" SE="1" SS="4">%02d</T><T C="255,236,193" S="18" P="1" SC="105,65,46" SE="1" SS="4"> giây</T>]],
FIRST_RECHARGE_TALK = "Vũ khí giới hạn đã đến hạn, dùng rất thích phải không? Mau nạp lần đầu để sở hữu nó và sẵn tiện rước tôi về nhà nhé",
NEWSINGIN6 = "Không cần điểm danh bù",
SKINSKILL1 = "Kỹ năng ảo",
SKINSKILL2 = "Từ Skin--%s", 
SKINSKILL3 = "Duyên Nợ",
SKINSKILL4 = "Cách nhận",
BATTLE_EXIT_WARNING4 = "Cưỡng chế thoát sẽ bị phạt cấm thi đấu",
NEWDESC2 = "Nhắc nhở: Thuộc tính thú cưỡi được cộng dồn",
ASSIST_IN_FIGHTING= "Trợ chiến",
SUSPENSION_TITLE = "Phạt cấm thi đấu",
SUSPENSION_TIP = "Bạn vừa thoát chiến đấu trong Đấu Hạng, trong khoảng thời gian sau sẽ không được tham gia xếp hạng",
SUSPENSION_TIP2 = "Số lần thoát trong ngày càng nhiều, thời gian cấm càng lâu",
SUSPENSION_TIP3 = "PS: Người chơi trợ chiến sẽ không tốn thể lực và số lần, nhưng chỉ được nhận rất ít thưởng",
SUSPENSION_TIP4 = "(PS: Người chơi trợ chiến sẽ không tốn thể lực và số lần, nhưng chỉ được nhận rất ít thưởng)",
ROOM_BEINVITED_4 = "%s mời bạn trợ chiến\n%s(%s)",
ROOM_BEINVITED_5 = "Người chơi được giúp đã thoát phòng, phòng giải tán",
ROOM_BEINVITED_6 = "Chỉ người chơi trợ chiến không được chơi ngay",
PARTNER_1 = "Đồng hành",
PARTNER_2 = "Dấu Chân",
CHANGESEX1 = [[
<T C="79,60,48" S="20" P="1">Đổi giới tính phải đạt điều kiện sau:</T><BR>5</BR>
<T C="79,60,48" S="20" P="1">1. Đã hủy quan hệ hộn nhân </T><T C="%s" S="20" P="1">%s</T><BR>5</BR>
<T C="79,60,48" S="20" P="1">2. Đã nhận hết đính kèm trong thư </T><T C="%s" S="20" P="1">%s</T><BR>5</BR>
]],
CHANGESEX2 = [[(Chưa hủy)]],
CHANGESEX3 = [[(Chưa hủy)]],
CHANGESEX4 = [[(Chưa nhận)]],
CHANGESEX5 = [[Xác nhận đổi giới tính?]],
CHANGESEX6 = [[Đổi giới tính phải hủy quan hệ hôn nhân trước]],
CHANGESEX7 = [[Đổi giới tính phải nhận hết đính kèm trong thư trước]],
BUBBLE_OPEN_BY_VIP= "VIP%d được dùng, tăng chứ?",
CHAT_BUBBLE_MESSAGE= "Khung chat đã mở, không thể kích hoạt lại",
CHANGESEX8 = [[Đổi giới tính thành công]],
WAKEUP_TEXT38 = "Đang khôi phục hành động không được dùng",
WAKEUP_TEXT39 = "Nhanh Nhẹn",
WAKEUP_TEXT40 = "Hiệu quả kỹ năng: Trong chiến đấu có thể hồi ngay %.1f điểm lực hành động",
WAKEUP_TEXT41 = {"Linh","động","nhanh"},
WAKEUP_TEXT42 = {"Chờ ban đầu","Chờ giãn cách","Hiệu quả khôi phục"},
COMMUNITYTASK_TEXT1 = {"Hôm nay","Ngày mai","Ngày mốt"},
COMMUNITYTASK_TEXT2 = "Nhiệm vụ đã công bố, thời gian hiệu lực còn ",
COMMUNITYTASK_TEXT3 = "Hãy phát nhiệm vụ ngày hôm trước rồi đến thực hiện thao tác!",
SKINSKILL5 = "Phẩm chất cao nhất",
WAKEUP_TEXT43 = "Điểm hành động đầy, không thể dùng kỹ năng Thức Tỉnh", 
YJ = "Vĩnh viễn",
GAME_ACTIVITY_EIGHTTIMES_DIAMOND ="Hoàn Trả Kim Cương x8",
CHECKOTHER12 = "Bùa",
QUICKSELECT1 = "Chọn nhanh",
SUMMER_REWARD1 = "Truy Nã Tết",
QUICKSELECT2 = "Đá khác không hỗ trợ chọn nhanh",
QUICKSELECT3 = "Không còn vật phẩm có thể ghép",
QUICKSELECT4 = "Không có trang bị có thể chọn nhanh",
ITEM_COOL_TIME = "Đạo cụ đang chờ",
QUICKSELECT5 = "Pet phẩm chất cao không hỗ trợ chọn nhanh",
QUICKSELECT6 = "Nhấn giữ xem thông tin pet",
QUICKSELECT7 = "Nhấn giữ xem thông tin vật phẩm",
QUICKSELECT8 = "Mỗi lần tối đa thu hồi 16 pet",
PVPNEW_TEXT1 = "Vinh Dự Đấu Hạng Đặc Biệt",
PVPNEW_TEXT2 = "Mùa Giải S12 mở, khi tổng kết, người đạt Vinh Dự Tối Cao có thể nhận dấu ấn này",
PVPNEW_TEXT3 = "Giới hạn: %d/%d",
PVPNEW_TEXT4 = "Dấu Kẻ Mạnh",
GAME_ACTIVITY_RANKPVP_REWARD = "Thưởng Đấu Hạng",
FAMILY_TEXT33 = "Làm Thuê",
FAMILY_TEXT34 = "Bảo Vệ",
FAMILY_TEXT35 = "Hồi Phục",
FAMILY_TEXT36 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">Đang bị thương không thể trộm, dùng </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%d</T> <I Z="0.46">%s</I><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> tăng tốc hồi phục</T>]],
FAMILY_TEXT37 = "Pet Làm Thuê",
FAMILY_TEXT38 = "Pet Bảo Vệ",
FAMILY_TEXT39 = [[<T C="195,171,148" S="20" P="1">Số làm thuê: </T><T C="233,166,62" S="20" P="1">%d/%d</T>]],
FAMILY_TEXT40 = "Hiệu suất",
FAMILY_TEXT41 = "Bắt đầu",
FAMILY_TEXT42 = "Tăng hiệu suất",
FAMILY_TEXT43 = "Đang làm thuê...",
FAMILY_TEXT44 = "Pet đang làm thuê...",
FAMILY_TEXT45 = "May mắn đầy sẽ tăng hiệu suất",
FAMILY_TEXT46 = "Danh sách Pet Bảo Vệ",
FAMILY_TEXT47 = [[<T C="105,65,46" S="18" P="1">Bảo vệ còn: </T><T C="158,0,0" S="18" P="1">%s</T>]],
FAMILY_TEXT48 = "Đang sẽ mất hiệu quả bảo vệ, hãy cho ăn",
FAMILY_TEXT49 = "Ăn hết nổi rồi",
FAMILY_TEXT50 = "Cho Ăn",
FAMILY_TEXT51 = "Đạt hiệu suất cao nhất",
FAMILY_TEXT52 = "Thu hoạch xong, chưa bị trộm",
FAMILY_TEXT53 = "Thu hoạch xong, đã bị trộm %d lần",
FAMILY_TEXT54 = "Trộm thành công",
FAMILY_TEXT55 = "Bắt đầu bảo vệ",
FAMILY_TEXT56 = "Đặc tính: %d%% phát hiện và tấn công kẻ trộm",
FAMILY_TEXT57 = [[<T C="195,171,148" S="20" P="1" SC="105,65,46" SE="0" SS="4">%s %d giờ Lợi ích </T><T C="233,166,62" S="20" P="1" SC="105,65,46" SE="0" SS="4">%d</T><I Z="0.5">%s</I>]],
FAMILY_TEXT58 = "Đã tăng hiệu suất",
FAMILY_TEXT59 = "Chưa tăng hiệu suất",
FAMILY_TEXT60 = "Đang bảo vệ…",
FAMILY_TEXT61 = "Số Pet làm thuê đạt tối đa",
FAMILY_TEXT62 = "Nhật Ký Trộm",
FAMILY_TEXT63 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s,</T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4"> %s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> đã trộm vật tư của pet </T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">!</T>]],
FAMILY_TEXT64 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s,</T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4"> %s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> trộm vật tư bị Pet Bảo Vệ </T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> phát hiện, trộm thất bại</T>]],
FAMILY_TEXT65 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s,</T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4"> %s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> trộm vật tư bị Pet Bảo Vệ </T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> phát hiện, đoạt lại vật tư</T>]],
FAMILY_TEXT66 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s,</T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4"> Đã trộm được vật tư từ Pet của </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"></T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">!</T>]],
FAMILY_TEXT67 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s,</T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4"> Đến trộm vật tư của </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> nhưng bị Pet Bảo Vệ </T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> phát hiện, trộm thất bại</T>]],
FAMILY_TEXT68 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s,</T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4"> Đến trộm vật tư từ pet của </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> bị Pet Bảo Vệ </T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">%s</T><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4"> phát hiện, đoạt lại vật tư</T>]],
FAMILY_TEXT69 = "Tư chất không đủ, hãy tăng cấp Sảnh Thuê",
FAMILY_TEXT70 = "Dùng %d %s mở ô pet thứ %d?",
FAMILY_TEXT71 = "Lv%d mới được tăng thêm ô",
FAMILY_TEXT72 = "Thiết lập bảo vệ thành công",
FAMILY_TEXT73 = "Đã trộm từ pet này rồi",
FAMILY_TEXT74 = "Pet bị trộm quá nhiều",
FAMILY_TEXT75 = "Bị Pet Bảo Vệ phát hiện, trộm thất bại",
FAMILY_TEXT76 = "Bị Pet Bảo Vệ phát hiện và tấn công, trộm thất bại",
FAMILY_TEXT77 = "Xong",
FAMILY_TEXT78 = "Đói",
FAMILY_TEXT79 = "Vườn bạn bè",
FAMILY_TEXT80 = "Pet chưa làm thuê xong",
FAMILY_TEXT81 = "Nhấp nút dưới để tăng hiệu suất",
FAMILY_TEXT82 = [[
<T C="229,105,22" S="22" P="0">Hướng dẫn Làm Thuê</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0"> Pet Làm Thuê là pet của bản thân, nhưng lợi ích không ảnh hưởng bởi mạnh yếu</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="20" P="0"> Ban đầu có 2 vị trí Pet Làm Thuê, đạt cấp yêu cầu có thể dùng Kim Cương mở thêm, tối đa 6 ô</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0"> Lợi ích nhận được tính theo hiệu suất, nhận khi kết thúc, không nhận kịp có thể bị trộm</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="20" P="0"> Có thể dùng Kim Cương tăng hiệu suất, thất bại tăng may mắn, điểm đầy sẽ tăng</T><BR></BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="20" P="0"> Khi bắt đầu lượt làm thuê mới, sẽ tạo mới ngẫu nhiên hiệu suất</T><BR>30</BR>

<T C="229,105,22" S="22" P="0">Hướng dẫn Trộm</T><BR></BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="20" P="0"> Pet làm thuê xong có thể bị trộm, hãy thu hoạch kịp thời</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0"> Mỗi Pet Làm Thuê tối đa có thể bị trộm lợi ích 3 lần, cùng 1 người chỉ được trộm 1 lần</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0"> Mỗi lần bị trộm mất 10% lợi ích làm thuê lần này, mỗi người mỗi ngày tối đa trộm thành công 10 lần</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0"> Khi trộm có khả năng bị Pet Bảo Vệ tấn công, phẩm chất Pet Bảo Vệ càng cao, thời gian bị thương càng lâu, bị thương không thể trộm, có thể dùng Kim Cương tăng tốc hồi phục</T><BR>30</BR>

<T C="229,105,22" S="22" P="0">Hướng dẫn bảo vệ</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="20" P="0"> Phẩm chất Pet bảo vệ không liên quan đến thú cưỡi của bản thân, mà tùy vào cấp Phòng Bảo Vệ</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0"> Mỗi lần chỉ được chọn 1 Pet Bảo Vệ canh giữ</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="20" P="0"> Thời gian bảo vệ tùy vào thời hiệu thức ăn, hết hiệu lực sẽ mất đặc tính bảo vệ</T><BR></BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="20" P="0"> Pet Bảo Vệ phẩm chất càng cao, càng dễ phát hiện địch. Pet phẩm chất cao có thể tấn công, khiến địch bị thương và không thể trộm trong thời gian ngắn</T><BR></BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="20" P="0"> Khi bị Pet Bảo Vệ phát hiện, lần trộm này sẽ thất bại</T><BR></BR>

]],
FAMILY_TEXT83 = "Trễ rồi, chủ nhân đã nhận xong",
FAMILY_TEXT84 = "Không đủ số Pet làm thuê",
RUNEBOOK19 = "Toàn bộ Bùa Lv5",
RUNEBOOK20 = "Bùa muốn bán có %d Bùa Lv5, bán ngay?",
VIGOR_MAX = "Thể lực đạt tối đa, không thể dùng",
EXCHANGE1 = "Đổi vật phẩm",
EXCHANGE2 = "Chọn số lượng (1 lần tối đa %s)",
NPC_NAME_3 = "Thương Nhân",
CHALLENGE_SURPLUS_COUNT = "Khiêu chiến còn: ",
DAY_OF_THE_WEEK = {"Chủ Nhật","Thứ Hai","Thứ Ba","Thứ Tư","Thứ Năm","Thứ Sáu","Thứ Bảy"},
THE_NEXT_OPENING_TIME = "Chưa mở, thời gian mở gần nhất là %s %s-%s",
FOOTBALL_SHOOT = "Sút Luân Lưu",
FOOTBALL_SHOOT_FAIL = "Phát bóng thất bại",
FOOTBALL1 = "Bóng chưa vào lưới",
FOOTBALL_SUCCESS = "Sút vào lưới, điểm +%d",
FOOTBALL_FAIL = "Sút chưa vào, điểm +%d",
FOOTBALL_RESULT = "Kết quả thưởng",
FOOTBALL_STATE = "Đợi mở thưởng",
FOOTBALL_TEXT1 = "Tổng cược %s thắng: %d",
FOOTBALL_TEXT2 = "Tổng cược hòa: %d",
FOOTBALL_TEXT3 = "Bắt đầu",
FIELD_BETTING = "Cược trận này: ",
GUESS_WIN = "Đoán thắng",
GUESS_LOSE = "Đoán thua",
GUESS_DRAW = "Đoán hòa",
STOP_BETTING_AFTER_STARTING = " (Vào trận sẽ ngừng nhận cược)",
DRAW = "Hòa",
CURRENT_BET_WHO_WINS = "Hiện đang cược cho %s",
BET_AVAILABLE = "Dự đoán %d, được nhận %d %s",
REDEEM_PRIZES = "Đổi thưởng",
GUESSING_RECORDS = "Nhật ký dự đoán",
QUERIES_RANKING = "Hạng dự đoán",
QUIZ_PEOPLE = "Vua Dự Đoán",
CURRENT_WINNING = "Trúng thưởng",
RANK_REWARDS = "Thưởng Hạng",
QUIZZES_ISSUED_VIA_EMAIL = "Thưởng dự đoán sẽ được gửi qua thư khi thi đấu kết thúc (Do số liệu lớn, sẽ có trì hoãn)",
GAME_ACTIVITY_FOOTBALL_QUIZ = "Dự Đoán",
COUNTDOWN_TO_THE_GAME = "Thi đấu còn: %d ngày %d giờ %d phút %d giây",
FOOTBALL_TEXT4 = "Hãy đặt cược",
FOOTBALL_TEXT5 = "Đã đặt cược",
THE_GAME_HAS_STARTED = "Trận Đấu đã bắt đầu",
LABEL_END = "Kết thúc",
GAME_STARTED_CAN_NOT_BET = "Thi đấu đã kết thúc, không thể đặt cược",
MATCH_RESULTS = "Kết quả thi đấu:%d-%d",
FOOTBALL_TEXT6 = "Bóng không đủ, không sút được",
FOOTBALL_TEXT7 = "Tỉ suất:",
FOOTBALL_TEXT8 = [[
<T C="229,105,22" S="22" P="0">Thuyết minh Đường Đến Khung Thành</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0"> Dùng đạo cụ bóng để sút, nhận bóng từ event</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="20" P="0"> Phần thưởng của event Đường Đến Khung Thành được gửi qua Thư, xin chú ý nhận</T><BR></BR>
<T C="229,105,22" S="22" P="0">Thuyết minh Vui Cùng World Cup</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0"> Dùng Xu Đặt Cược để đặt cược, Xu Đặt Cược nhận từ event</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="20" P="0"> Phần thưởng Vui Cùng World Cup sẽ gửi qua thư. </T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0"> Phần thưởng BXH Vui Cùng World Cup sẽ được gửi qua thư, xin hãy chú ý</T><BR></BR>
]],
LEVELUP_TO_TEN= "Bỏ qua tân thủ?",
WAKEUP_TEXT44 = "Dùng Thẻ Quên Thiên Phú tạo mới thiên phú? Thiên phú đã học sẽ quên hết và hoàn trả điểm thiên phú",
WAKEUP_TEXT45 = "Tạo mới thiên phú thành công",
WAKEUP_TEXT46 = "Không cần tạo mới thiên phú",

PET_TEXT1 = "Biến hình",
PET_TEXT2 = "Pet biến hình",
PET_TEXT3 = "Đang biến hình...",
PET_TEXT4 = "Pet có thể biến hình",
PET_TEXT5 = "Không có Pet có thể biến hình",
PET_TEXT6 = "Pet không thể biến hình",
PET_TEXT7 = "Biến hình thành công",
PET_TEXT8 = "Đã trong hình dạng đang chọn, không cần biến hình",
PET_TEXT9 = "Hãy chọn Pet muốn biến hình",
PET_TEXT10 = "Pet sắp gộp có Pet đã biến hình, tiếp tục không?",
PET_TEXT11 = "Pet thu hồi có Pet đã biến hình, tiếp tục không?",
PET_TEXT12 = "Pet sắp tách có Pet đã biến hình, tiếp tục không?",

MATCHING_TEXT1 = "Đang ghép trận, không thao thao tác",
MATCHING_TEXT2 = "Treo",
PET_TEXT13 = [[
<T C = "229,105,22" S = "22" P = "0">Hướng dẫn biến hình</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">1.</T><T C = "127,70,26" S = "20" P = "0">Chỉ có thể biến hình thành Pet có giới hạn tư chất ban đầu giống nhau</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">2.</T><T C = "127,70,26" S = "20" P = "0">Phải từng sở hữu Pet muốn biến hình (Chỉ cần đã từng sở hữu, nhưng chỉ tính cho Pet sở hữu sau cập nhật lần này)</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">3.</T><T C = "127,70,26" S = "20" P = "0">Pet sau khi biến hình sẽ hiển thị ngoại hình mới, nhưng thuộc tính và lực chiến không đổi</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">4.</T><T C = "127,70,26" S = "20" P = "0">Biến hình có hiệu lực vĩnh viễn, có thể biến hình thành ngoại hình khác</T><BR></BR>
]],


CARD_TEXT35 = "Cấp Thẻ Bài: ",
CARD_TEXT36 = {"Tổng Cấp Thẻ Cam:  ","Tổng Cấp Thẻ Tím:  ","Tổng Cấp Thẻ Lam:  ","Tổng Cấp Thẻ Lục: "},
DRESSSUIT_TEXT1 = "Tên tối đa 8 ký tự",
DRESSSUIT_TEXT2 = "Đổi tên thành công",
DRESSSUIT_TEXT3 = "Trả %d %s để mở bộ thứ %d?",
FAMILY_TEXT85 = "Vườn",
PVP_RANK_TEXT8 = [[<T C = "127,70,26" S = "20" P = "1" SC = "127,70,26" SS = "4" SE = "0">Khi mùa giải kết thúc, đạt bậc </T><T C = "5,180,0" S = "20" P = "1" SC = "0,72,3" SS = "4" SE = "0">%s</T><T C = "127,70,26" S = "20" P = "1" SC = "127,70,26" SS = "4" SE = "0"> sẽ được nhận Thưởng Mùa Giải</T><T C = "127,70,26" S = "18" P = "1"></T>]],
SKILL_TEXT1 = "Nhấp chọn kỹ năng để dùng hoặc tháo",
SKILL_TEXT2 = "Nhấp chọn đạo cụ để dùng hoặc tháo",
COMMUNITY_DECLARElEN_ATT = "Tuyên ngôn Công Hội tối đa 66 ký tự",
BLACKLIST_TEXT1 = "Sổ Đen",
BLACKLIST_TEXT2 = "Thêm Sổ Đen sẽ không thể chat với người này trên kênh Riêng, Hiện Tại, Thế Giới, đồng ý?",
BLACKLIST_TEXT3 = "Thêm Sổ Đen sẽ hủy quan hệ bạn bè, không thể chat với người này trên kênh Riêng, Hiện Tại, Thế Giới, đồng ý?",
BLACKLIST_TEXT4 = "Người chơi này trong Sổ Đen, xin kết bạn sẽ xóa khỏi Sổ Đen, tiếp tục không?",
BLACKLIST_TEXT5 = "Không thể nhận tin chat từ người này trên kênh Riêng, Hiện Tại, Thế Giới",
BLACKLIST_TEXT6 = "Không có ai trong Sổ Đen",
BLACKLIST_TEXT7 = "Xóa Sổ Đen",
BLACKLIST_TEXT8 = "Thêm Sổ Đen",
BLACKLIST_TEXT9 = "Hai bên là bạn thân, không thể thêm Sổ Đen",
BLACKLIST_TEXT10 = "Hai bên là thầy trò, không thể thêm Sổ Đen",
BLACKLIST_TEXT11 = "Hai bên là vợ chồng, không thể thêm Sổ Đen",
BLACKLIST_TEXT12 = "Đã xóa Sổ Đen",
BLACKLIST_TEXT13 = "Đã thêm Sổ Đen",
COMMUNITY_DECLARElEN_ATT2 = "Đã sửa",
BLACKLIST_TEXT14 = "Sổ Đen đã đầy, không thể thêm",
PET_TEXT14 = "Xem Pet",
DAILY_TEXT1 = "VIP%d mở tạo mới, nạp ngay?",
CHECKOTHER_TEXT1 = "Hiện đang dùng thử, trả %d %s để mua?",
CHECKOTHER_TEXT2 = "Sau khi kết hôn mới hiển thị bạn đời",
CHECKOTHER_TEXT3 = "Thiết lập nền",
CHECKOTHER_TEXT4 = "Hiển thị Cánh",
CHECKOTHER_TEXT5 = "Hiển thị bạn đời",
CHECKOTHER_TEXT6 = "Hiển thị Pet",
CHECKOTHER_TEXT7 = "Hiển thị con",
CHECKOTHER_TEXT8 = "Chưa mở Pet",
DAILY_TEXT2 = "Chưa nhận lợi ích tối đa, không thể càn quét!",
KID_TEXT1 = [[<T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">Tuổi: </T><T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">%.1f tuổi</T>]],
KID_TEXT2 = [[<T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">Trưởng thành: </T><T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">%d</T>]],
KID_TEXT3 = [[<T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">Chăm sóc: </T><T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">%d</T>]],
KID_TEXT4 = "Chọn cho ăn",
KID_TEXT5 = "Nhập số lượng",
KID_TEXT6 = "Dùng %s có thể tăng %d điểm trưởng thành",
KID_TEXT7 = "Nhận buff Chăm Sóc sẽ tăng %d lực chiến, kéo dài %d giờ, đồng ý?",
KID_TEXT8 = "Sau khi có con mới được chăm sóc",
KID_TEXT9 = "Nhận buff Chăm Sóc",
KID_TEXT10 = "Chọn chăm sóc",
KID_TEXT11 = "Chọn Tã",
KID_TEXT12 = "Thay Tã",
KID_TEXT13 = {"Đồ dùng","Trang sức","Con","Bảo Mẫu","Thức ăn","Thời trang","Túi"}, 
KID_TEXT14 = "Bảo Mẫu Dễ Thương",
KID_TEXT15 = "Có thể tự động dùng thức ăn giúp con trưởng thành, giảm 50% thời gian mang thai",
KID_TEXT16 = "Thuê",
KID_TEXT17 = "Chọn thời gian thuê",
KID_TEXT18 = "Thời gian còn lại",
KID_TEXT19 = "Bảo mẫu đã ngưng việc",
KID_TEXT20 = "Nhận Nuôi",
KID_TEXT21 = "Sinh Con",
KID_TEXT22 = "Chưa kết hôn mới được nhận nuôi",
KID_TEXT23 = "Kết hôn mới được sinh con",
KID_TEXT24 = "Mang thai thất bại, hãy thử lại nhé!",
KID_TEXT25 = "Yêu Thương đạt Lv%d mới được sinh con",
KID_TEXT26 = "Độc thân chỉ được nuôi 1 con!",
KID_TEXT27 = "Vợ chồng sinh tối đa 2 con!",
KID_TEXT28 = "Nhận nuôi",
KID_TEXT29 = "Sinh con",
KID_TEXT30 = "Không có bạn đời có thể nhận con nuôi",
KID_TEXT31 = "Yêu Thương đạt Lv%d mới được sinh con",
KID_TEXT32 = "Xác xuất mang thai %d%% ",
KID_TEXT33 = "Nhận nuôi thành công",
KID_TEXT34 = "Mang thai thành công",
KID_TEXT35 = "Đứa con hiện thời là bé trai, có muốn đổi không?",
KID_TEXT36 = "Đứa con hiện thời là bé gái, có muốn đổi không?",
KID_TEXT37 = "Đứa con hiện thời là bé trai, chọn xác định sẽ không thể đổi nữa",
KID_TEXT38 = "Đứa con hiện thời là bé gái, chọn xác định sẽ không thể đổi nữa",
KID_TEXT39 = "Tên con tối đa 8 ký tự",
KID_TEXT40 = "Đã thuê, Bảo Mẫu sẽ chăm lo cho bé!",
KID_TEXT41 = "Đã tăng thời gian thuê",
KID_TEXT42 = "Nhà",
KID_TEXT43 = "Lễ Đường",
KID_TEXT44 = "Kết Bạn",
KID_TEXT45 = "Vợ chồng",
KID_TEXT46 = "Cầu Hôn",
KID_TEXT47 = "Quen Biết",
KID_TEXT48 = "Đính Hôn",
KID_TEXT49 = "Chăm Sóc",
KID_TEXT50 = "Quản Lý",
KID_TEXT51 = "Nhà Bạn",
KID_TEXT52 = "Thuộc tính thời trang có thể cộng dồn",
KID_TEXT53 = "Thoải Mái",
KID_TEXT54 = "Đang Yêu",
KID_TEXT55 = "Hôn Lễ",
KID_TEXT56 = "Mang Thai",
KID_TEXT57 = "Đang chăm sóc...",
KID_TEXT58 = "Đang mang thai...",
KID_TEXT59 = "Đang làm thủ tục",
KID_TEXT60 = "Thú Nhún",
KID_TEXT61 = "Đã hết lượt mua",
KID_TEXT62 = "Cần có có trước đã!",
KID_TEXT63 = "Đang mang thai, làm sao mang thai tiếp được...",
KID_TEXT64 = "Đang làm thủ tục, không thể nhận nuôi tiếp",
KID_TEXT65 = "Bắt đầu Thú Nhún",
KID_TEXT66 = "Thú Nhún",
KID_TEXT67 = [[<T C="79,60,48" S="20" P="1" SC="127,70,26" SS="4" SE="0">Trả %d </T><I Z="0.5">%s</I><T C="79,60,48" S="20" P="1" SC="127,70,26" SS="4" SE="0"> cho %s chơi Thú Nhún? Có thể tăng %d điểm Chăm Sóc</T>]],
KID_TEXT68 = "Mỗi ngày chỉ 1 lần!",
KID_TEXT69 = "Chăm sóc thành công",
KID_TEXT70 = "Bắt đầu chơi Thú Nhún",
KID_TEXT71 = "Mỗi ngày chỉ 1 lần!",
KID_TEXT72 = "Không thể tăng thời gian thuê nữa",
KID_TEXT73 = "Đây là đồ chơi trẻ em, có con chưa?",
CHECKOTHER_TEXT9 = "Đang ghép trận, không thể thiết lập",
CHECKOTHER_TEXT10 = "Đang chiến đấu, không thể thiết lập",
KID_TEXT74 = "Túi trống",
KID_TEXT75 = "Không bán loại vật phẩm này",
KID_TEXT76 = "Không bán loại thời trang này",
KID_TEXT77 = [[<T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">Cha cống hiến: </T><T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">%d</T>]], 
KID_TEXT78 = [[<T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">Mẹ cống hiến: </T><T C = "255,236,193" S = "18" P = "1" SC = "127,70,26" SS = "4" SE = "0">%d</T>]],
KID_TEXT79 = "Thủ tục ly hôn",
KID_TEXT80 = "Xác nhận ly hôn",
KID_TEXT81 = "Bỏ quyền nuôi con",
KID_TEXT82 = "Bạn xác định bỏ quyền nuôi con?",
KID_TEXT83 = "Bạn cống hiến cho %s nhiều nhất, chọn quyền nuôi dưỡng %s, quyền nuôi dưỡng %s sẽ chuyển cho bên kia",
KID_TEXT84 = "Bạn cống hiến cho %s nhiều nhất, nếu chọn quyền nuôi dưỡng %s cần được bên kia đồng ý (Nếu bị từ chối, bạn được nhận quyền nuôi %s)",
KID_TEXT85 = "Bên kia cống hiến cho con nhiều nhất, bạn chọn quyền nuôi dưỡng %s cần bên kia đồng ý (Nếu bị từ chối, bạn nhận được quyền nuôi dưỡng %s)",
KID_TEXT86 = "Bạn đời đã yêu cầu ly hôn, (sau khi ly hôn đồ cưới sẽ biến mất), đồng thời muốn được quyền nuôi %s. Hãy xác định đứa con bạn muốn nuôi (Đứa con còn lại sẽ thuộc về người kia. Sau 5 ngày không xử lý sẽ buộc thực hiện theo lựa chọn của bên kia)",
KID_TEXT87 = "Không thể bỏ con riêng của mình",
KID_TEXT88 = "Không thể chọn con riêng của bên kia",
KID_TEXT89 = "Đã chọn quyền nuôi dưỡng %s, tiếp tục?",
KID_TEXT90 = "Xin ly hôn phải nộp %d Kim Cương Khóa làm thủ tục, sau khi ly hôn đồ cưới sẽ biến mất, ",
KID_TEXT91 = "Chỉ có thể chọn con riêng của mình",
KID_TEXT92 = "Bạn cống hiến cho con nhiều hơn, sau khi bạn chọn quyền nuôi dưỡng, quyền nuôi con sẽ thuộc về bạn, đồng ý?",
KID_TEXT93 = "Bạn đời cống hiến cho con nhiều hơn, khi chọn quyền nuôi dưỡng cần bên kia đồng ý (Nếu bị từ chối, bạn buộc phải bỏ quyền nuôi con), đồng ý?",
KID_TEXT94 = "Nếu chọn đứa con mà bạn đời cống hiến nhiều hơn, cần bên kia đồng ý. Nếu có con riêng thì chỉ có thể chọn con riêng.",
KID_TEXT95 = "Bạn đời đã yêu cầu ly hôn, (sau khi ly hôn đồ cưới sẽ biến mất), đồng thời muốn được quyền nuôi %s. Hãy xác định đứa con bạn muốn nuôi (Đứa con còn lại (nếu có) sẽ thuộc về người kia. Sau 5 ngày không xử lý sẽ buộc thực hiện theo lựa chọn của bên kia)",
KID_TEXT96 = "Bạn đời đã yêu cầu ly hôn, (sau khi ly hôn đồ cưới sẽ biến mất), bên kia muốn bỏ quyền nuôi con, hãy xác nhận lựa chọn của bạn? (Nếu bạn cũng bỏ, người nuôi đứa bé sẽ được quyết định theo mức cống hiến)",
KID_TEXT97 = "Ly hôn thành công, bạn được quyền nuôi dưỡng %s",
KID_TEXT98 = "Ly hôn thành công, bên kia được quyền nuôi dưỡng %s",
KID_TEXT99 = "Ly hôn thành công, bạn được quyền nuôi dưỡng %s, bên kia được quyền nuôi dưỡng %s",
KID_TEXT100 = [[<T C = "255,236,193" S = "18" P = "1" SC = "127, 70, 26" SS = "4" SE = "0">Thuộc ngườichơi: </T><T C = "255,236,193" S = "18" P = "1" SC = "127, 70, 26" SS = "4" SE = "0">%s</T>]],
KID_TEXT101 = "Vỗ về thành công",
KID_TEXT102 = "Cho ăn thành công",
KID_TEXT103 = "Đã thay tã",
KID_TEXT104 = {"Tiệm Đồ Dùng","Tiệm Trang Sức","Con","Tiệm Bảo Mẫu","Tiệm Thức Ăn","Thời Trang Trẻ Em","Túi"},
KID_TEXT105 = "Nhận",
KID_TEXT106 = [[
<T C = "229,105,22" S = "22" P = "0">Hướng dẫn Nhà</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">1.</T><T C = "127,70,26" S = "20" P = "0">Phòng càng thoải mái, trẻ càng mau lớn, thêm đồ gia dụng có thể tăng điểm thoải mái (Đã mua chưa đặt vào cũng sẽ tăng)</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">2.</T><T C = "127,70,26" S = "20" P = "0">Điểm trưởng thành của con càng cao, trưởng thành càng nhanh</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">3.</T><T C = "127,70,26" S = "20" P = "0">Con khóc, đói, ướt tã sẽ giảm trưởng thành, cần vỗ về, cho ăn hay thay tã để hồi phục</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">4.</T><T C = "127,70,26" S = "20" P = "0">Điểm Chăm Sóc có thể thông qua vuốt ve, chơi Thú Nhún, mua thời trang để hồi phục</T><BR></BR>
<T C = "229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="20" P="0"> Ly hôn khi đang mang thai, con sẽ không thể ra đời! Hãy thao tác cẩn thận!</T><BR></BR>
<T C = "229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="20" P="0"> Kết hôn khi đang nhận nuôi, sẽ không thể nhận nuôi con, hãy thao tác cẩn thận</T><BR></BR>
]],
KID_TEXT107 = [[
<T C = "229,105,22" S = "22" P = "0">Hướng dẫn Chăm Sóc</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">1.</T><T C = "127,70,26" S = "20" P = "0">Chọn chăm sóc có thể nhận tỉ lệ thuộc tính tăng thêm từ con. Con chưa chọn cũng có thể tăng 20% thuộc tính nếu chăm sóc đạt 100%</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">2.</T><T C = "127,70,26" S = "20" P = "0">Mỗi ngày chỉ 1 lần! Duy trì 20 giờ</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">3.</T><T C = "127,70,26" S = "20" P = "0">BUFF Chăm Sóc bị trùng sẽ tính hiệu quả BUFF mới nhất</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">4.</T><T C = "127,70,26" S = "20" P = "0">Khi được BUFF Chăm Sóc sẽ không thay đổi khi con tăng thuộc tính</T><BR></BR>
]],
KID_TEXT108 = [[
<T C = "229,105,22" S = "22" P = "0">Hướng dẫn Thuê</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">1.</T><T C = "127,70,26" S = "20" P = "0">Khi mang thai, có thể nhờ bảo mẫu chăm sóc, rút ngắn 1/2 thời gian ra đời</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">2.</T><T C = "127,70,26" S = "20" P = "0">Bảo mẫu sẽ chăm sóc trẻ, tự động vỗ về, cho ăn, thay tã (Nếu không đủ tã và thức ăn, bảo mẫu cũng hết cách)</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">3.</T><T C = "127,70,26" S = "20" P = "0">Cần trả phí để bảo mẫu làm việc, nếu không sẽ ngưng việc đấy!</T><BR></BR>
]],
KID_TEXT109 = [[
<T C = "229,105,22" S = "22" P = "0">Hướng dẫn Thời Trang</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">1.</T><T C = "127,70,26" S = "20" P = "0">Mua thời trang sẽ tăng thuộc tính tất cả con đang có</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">2.</T><T C = "127,70,26" S = "20" P = "0">Được nhận thuộc tính tăng thêm đầy đủ từ thời trang thuộc tính cao nhất (Không cần mặc), thời trang khác sẽ tăng 10% thuộc tính</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">3.</T><T C = "127,70,26" S = "20" P = "0">Thời trang do cha mẹ mua sẽ hiển thị riêng biệt, có thể chọn đồ mặc tùy ý.</T><BR></BR>
]],

KID_TEXT110 = "Kiên nhẫn chờ con chào đời",
KID_TEXT111 = [[<T C = "255,227,116" S = "20" P = "1" SC = "105, 65, 46" SS = "4" SE = "1">Trưởng thành: </T><T C = "99, 255, 95" S = "20" P = "1" SC = "0, 72, 3" SS = "4" SE = "1">%d/%d</T>]],
KID_TEXT112 = "Thay %s có thể tăng %d điểm trưởng thành",
KID_TEXT113 = "Trưởng thành đã đạt tối đa",
KID_TEXT114 = "Không thể vượt quá trưởng thành tối đa",

KID_TEXT115 = [[
<T C = "229,105,22" S = "22" P = "0">Hướng dẫn Túi</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">1.</T><T C = "127,70,26" S = "20" P = "0">Vợ chồng dùng chung túi, cùng chăm con, sắp xếp nhà cửa</T><BR></BR>
<T C = "229,105,22" S = "22" P = "0">2.</T><T C = "127,70,26" S = "20" P = "0">Cha mẹ mua vật phẩm sẽ hiện riêng, có thể dùng chung</T><BR></BR>
]],
KID_TEXT116 = "Trên tường đã hết chỗ ",
KID_TEXT117 = "Vuốt ve thành công",
KID_TEXT118 = "Mỗi ngày chỉ 1 lần!",
KID_TEXT119 = "Cha",
KID_TEXT120 = "Mẹ",
KID_TEXT121 = "Con đang chơi thú nhún",
GAME_ACTIVITY_ATHLETIC_VICTORY ="Trận Thắng Thi Đấu",
GAME_ACTIVITY_RANKING_VICTORY ="Trận Thắng Xếp Hạng",
GAME_ACTIVITY_PET_UPGRADE ="Tăng cấp Pet",
GAME_ACTIVITY_MOUNT_UPGRADE ="Tăng cấp thú cưỡi",
GAME_ACTIVITY_EQUIPMENT_CALL ="Nhận Trang Bị",
GAME_ACTIVITY_PET_QUAIL ="Đập Trứng Pet",
GAME_ACTIVITY_CONTINUOUS_LOGIN = "Đăng nhập liên tục",
GAME_ACTIVITY_CHANNEL_RECHARGE = "Nạp qua kênh",
CHECKOTHER_TEXT11 = "Thuộc tính chăm sóc: ",
CHECKOTHER_TEXT12 = "Hôm nay chưa chăm sóc",
CHECKOTHER_TEXT13 = " (%.1f tuổi)",
SINGLECOPY_TEXT1 = "Lãnh Chúa",
SINGLECOPY_TEXT2 = " (Mỗi CN bình chọn Lãnh Chúa)",
SINGLECOPY_TEXT3 = "Thông tin khiêu chiến Lãnh Chúa lần này",
SINGLECOPY_TEXT4 = [[<T C="79,60,48" S="20" P="0">Thưởng Lãnh Chúa: </T><T C="195,171,148" S="20" P="0">(CN gửi qua thư)</T>]],
SINGLECOPY_TEXT5 = "Ứng viên kỳ sau",
SINGLECOPY_TEXT6 = "Điểm ải: ",
SINGLECOPY_TEXT7 = "Hạng khiêu chiến",
SINGLECOPY_TEXT8 = "Lãnh Địa",
SINGLECOPY_TEXT9 = "Sở Hữu Lãnh Địa",
SINGLECOPY_TEXT10 = "Đã Chiếm Lãnh Địa",
SINGLECOPY_TEXT11 = "Lãnh Địa ứng viên kỳ sau",
SINGLECOPY_TEXT12 = "Đã đoạt hạng 1 ải cao hơn, không thể lên BXH",
SINGLECOPY_TEXT13 = [[
<T C="229,105,22" S="22" P="0">Hướng Dẫn Lãnh Chúa</T><BR></BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="20" P="0"> Bình chọn Lãnh Chúa theo điểm vượt ải</T><BR></BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="20" P="0"> Lãnh Chúa được bình chọn vào 21:00 mỗi CN, đồng thời phát thưởng cho kỳ trước.</T><BR></BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="20" P="0"> Mỗi người được chiếm vị trí bình chọn của tối đa 3 ải. Cùng một độ khó, ải càng về sau thưởng càng nhiều.</T><BR></BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="20" P="0"> Trong độ khó Ác Mộng, chỉ khiêu chiến 3 Sao được tính điểm Lãnh Chúa.</T><BR></BR>
]],
MATCHMAKE_TEXT1 = "Đã kết hôn, không thể tìm bạn đời nữa",
MATCHMAKE_TEXT2 = [[<T C="105,65,46" S="20" P="0">Dùng %d </T><I Z="0.5">%s</I><T C="105,65,46" S="20" P="0"> nhận trạng thái đề cử? Cần đề cử không? (Hiệu lực trong lần đăng ký này)</T>]],
MATCHMAKE_TEXT3 = "Thông tin đăng ký lần này đã được đề cử rồi!",
MATCHMAKE_TEXT4 = "Đăng ký xong mới được đề cử",
MATCHMAKE_TEXT5 = "Chưa có thông tin đăng ký!",
MATCHMAKE_TEXT6 = "Đăng ký",
MATCHMAKE_TEXT7 = "Hủy thông tin đăng ký tìm bạn đời? Hủy sẽ không hoàn trả Kim Cương!",
MATCHMAKE_TEXT8 = "Xem Nữ",
MATCHMAKE_TEXT9 = "Xem Nam",
MATCHMAKE_TEXT10 = "Đã đề cử",
MATCHMAKE_TEXT11 = "Tuyên Ngôn Kết Bạn: ",
MATCHMAKE_TEXT12 = " (Đăng ký có hiệu lực %d ngày, quá hạn phải đăng ký lại)",
MATCHMAKE_TEXT13 = "Hạn đăng ký: ",
MATCHMAKE_TEXT14 = "Hủy đăng ký",
MATCHMAKE_TEXT15 = "Xác nhận sửa",
MATCHMAKE_TEXT16 = "Đã sửa tuyên ngôn",
MATCHMAKE_TEXT17 = "Đăng ký thành công",
MATCHMAKE_TEXT18 = "Tuyên Ngôn Kết Bạn không thể có khoảng trắng",
MATCHMAKE_TEXT19 = "Tuyên Ngôn Kết Bạn không được quá %d chữ",
MATCHMAKE_TEXT20 = "Nhập Tuyên Ngôn Kết Bạn",
MATCHMAKE_TEXT21 = "Đã hủy đăng ký",
MATCHMAKE_TEXT22 = "Đã sửa tuyên ngôn",
KID_TEXT122 = "Đang có thời trang mặc thử chưa mua, mua ngay?",
FIRST_DAY_CAN_NOT_DONATE = "Ngày đầu gia nhập Guild không thể cống hiến, ngày mai hãy quay lại !!!",
TEAMBOSS_TEXT1 = "Lãnh Chúa Vực Sâu",
TEAMBOSS_TEXT2 = 
[[
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="24" P="0"> Quy tắc Lãnh Chúa Vực Sâu</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Đội gây càng nhiều sát thương cho Lãnh Chúa Vực Sâu, nhận thưởng càng nhiều!</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Thưởng mục tiêu sinh lực Lãnh Chúa Vực Sâu sẽ được phát lúc 22:00</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Thưởng hạng Lãnh Chúa Vực Sâu sẽ được phát lúc 22:00</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Cổ Vũ Lãnh Chúa Vực Sâu chỉ hiệu lực trong thời gian chiến đấu trong ngày</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0"> Khiêu Chiến Lãnh Chúa Vực Sâu sẽ kết thúc khi Lãnh Chúa tấn công 10 lượt</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">6.</T><T C="127,70,26" S="22" P="0"> Lãnh Chúa Vực Sâu sẽ thay đổi tuần hoàn mỗi ngày, Túi Thẻ Thưởng Hạng sẽ là Thẻ của BOSS tương ứng</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">7.</T><T C="127,70,26" S="22" P="0"> BXH Sát Thương Lãnh Chúa Vực Sâu ghi nhận sát thương cao nhất trong 1 lần khiêu chiến của đội</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">8.</T><T C="127,70,26" S="22" P="0"> Cùng một người chơi đạt được nhiều thứ hạng trong BXH Sát Thương, thì chỉ nhận được phần thưởng dành cho thứ hạng cao nhất đã đạt</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">9.</T><T C="127,70,26" S="22" P="0"> Thời gian khiêu chiến Lãnh Chúa Vực Sâu là 9:00-22:00 (Nếu BOSS đã bị diệt thì kết thúc ngay)</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">10.</T><T C="127,70,26" S="22" P="0"> Lãnh Chúa Vực Sâu bị tiêu diệt sẽ tăng thêm sức mạnh</T><BR>10</BR>
]],
TEAMBOSS_TEXT3 = "ID:",
TEAMBOSS_TEXT4 = "Lãnh Chúa Vực Sâu",
TEAMBOSS_TEXT5 = "Chỉ chủ phòng được thiết lập",
TEAMBOSS_TEXT6 = "%s mời bạn vào Phòng Lãnh Chúa Vực Sâu cùng chiến đấu",
TEAMBOSS_TEXT7 = "Chi tiết",
TEAMBOSS_TEXT8 = "Sát thương đội",
TEAMBOSS_TEXT9 = "Sát thương đơn",
TEAMBOSS_TEXT10 = "BOSS còn ",
TEAMBOSS_TEXT11 = "Thưởng sát thương",
TEAMBOSS_TEXT12 = "Lãnh Chúa Vực Sâu chưa bị tiêu diệt, hãy cố gắng hơn!",
TEAMBOSS_TEXT13 = "Đã tiêu diệt BOSS Lãnh Chúa Vực Sâu!",
TEAMBOSS_TEXT14 = [[<T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">Đã hết lượt khiêu chiến, dùng </T><T C="99,255,95" S="18" P="1" SC="79,60,48" SE="1" SS="4">%d</T> <I Z="0.46">%s</I><T C="255,236,193" S="18" P="1" SC="79,60,48" SE="1" SS="4">mua 1 cơ hội?</T>]],
TEAMBOSS_TEXT15 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Đạt </T><T C="99,255,95" S="20" P="1" SC="0,72,3" SE="1" SS="4">VIP%d</T> <T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">được mua nhiều lượt hơn, tăng cấp VIP ngay?</T>]],
TEAMBOSS_TEXT16 = "Sát thương: ",
TEAMBOSS_TEXT17 = [[Đã diệt được BOSS!]],
TEAMBOSS_TEXT18 = "Chưa đến giờ khiêu chiến Lãnh Chúa Vực Sâu, cổ vũ vô hiệu!",
TEAMBOSS_TEXT19 = "Khiêu chiến Lãnh Chúa Vực Sâu hôm nay đã kết thúc, không thể cổ vũ!",
TEAMBOSS_TEXT20 = "Khiêu chiến Lãnh Chúa Vực Sâu hôm nay đã kết thúc!",
TEAMBOSS_TEXT21 = "Lãnh Chúa Vực Sâu xuất hiện lúc 9:00",
TEAMBOSS_TEXT22 = "Lãnh Chúa Vực Sâu đã bị đẩy lui! Mai chiến tiếp nhé!",
TEAMBOSS_TEXT23 = "Sinh lực BOSS: ",
TEAMBOSS_TEXT24 = "Lượt còn lại: ",
CHAT_CANTBUY = "Đang chiến đấu, không thể mua",
PVPGOOD_TEXT1 = "Đã thích %s",
PVPGOOD_TEXT2 = "%s đã thích bạn",
PVPGOOD_TEXT3 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">Bạn được thích trong Đấu Hạng </T><BR></BR><T C="255,236,193" S="20" P="1" SC="79,60,48" SE="1" SS="4">%d lần</T>]],
GHOSTBATTLE_TEXT1 = "Hãy chọn muc tiêu",
GHOSTBATTLE_TEXT2 = "Kỹ năng chỉ dùng cho phe ta",
GHOSTBATTLE_TEXT3 = "Kỹ năng chỉ dùng cho phe địch",
GHOSTBATTLE_TEXT4 = "Mục tiêu đã tử vong",
GHOSTBATTLE_TEXT5 = "Chậm rồi, rương bị lấy hết!",
GHOSTBATTLE_TEXT6 = "Đã xuất hiện Rương U Linh mới!",
GHOSTBATTLE_TEXT7 = "Chỉ được dùng trong lượt hành động của mục tiêu",
GENERAL_LIST = "Tổng Hợp",
RANK_SCORE_DESC1 = [[<T C="99,255,95" S="22" P="0">%s</T><T C="255,237,192" S="22" P="0"> Đấu Điểm đoạt được hạng 1! Bá đạo tuyệt đỉnh!</T>]],
RANK_SCORE_DESC2 = "Đã nhận hết Vàng",
RANK_SCORE_DESC3 = 
[[
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="24" P="0">Trùm Thi Đấu</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Trùm Thi Đấu sẽ hiện tên 3 người chơi hạng cao nhất trong Đấu Hạng.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Chọn "Thích" người chơi bất kỳ, sẽ nhận được Thể Lực</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Mỗi Mùa Giải kết thúc sẽ thay đổi đối tượng hiển thị</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0">Người chơi khác có thể chọn Thích nhân vật lọt vào BXH, nhận thưởng Vàng (Nhận thủ công)</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0">Có thể xem xếp hạng mới nhất tại giao diện "BXH"</T><BR>10</BR>
]],
RANK_SCORE_DESC4 = 
[[
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="24" P="0">Sao Tuần</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Sao Tuần sẽ hiện tên 3 người chơi điểm cao nhất trong Đấu Điểm tuần này.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Chọn "Thích" người chơi bất kỳ, sẽ nhận được Thể Lực</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0">Người chơi khác có thể chọn Thích nhân vật lọt vào BXH, nhận thưởng Vàng (Thưởng gửi qua thư lúc 0 giờ mỗi ngày)</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0">Có thể xem xếp hạng mới nhất tại giao diện "BXH"</T><BR>10</BR>
]],
GUILD_BOSS_TEXT1 = "Tổng sát thương",
GUILD_BOSS_TEXT2 = "CD Pow BOSS",
BOSSROOM_SWITCH_DIFFICULTY_TIPS_DIYU = "Chưa vượt qua độ khó trước, không thể khiêu chiến độ khó cao hơn",

TEAMBOSSROOM_NAME_ERROR = "Tên phòng tối đa 9 ký tự",
BADGELEVEL = "Cấp Huy Hiệu: ",
PAIWEISAI_SEASON_MODE_1V1 ="Mùa giải là này dạng 1V1, không thể mở vị trí này",
PAIWEISAI_SEASON_MODE_2V2 ="Mùa giải là này dạng 2V2, không thể mở vị trí này",
PVP_HALL_39 = "Dạng Quái Thú",
PVP_HALL_40 = "Kẻ Địch Ngụy Trang",
PVP_HALL_41 = "Hãy cẩn thận những kẻ địch ẩn nấp xung quanh! Có thể chúng là quái thú đấy!",
MELEE_DESC13 = "Hệ thống sẽ ghép 4 người có thực lực tương đương với nhau, trong đó 1 người sẽ biến thành Quái Thú, những người còn lại phải đánh bại Quái Thú mới giành được thắng lợi. Nếu thoát ra giữa chừng sẽ bị trừ Điểm Thi Đấu",
FLOP_CARD_DISCOUNT = "Ưu Đãi Lật Thẻ",

GAME_ACTIVITY_FLOWER_LIST ="Hoạt Động BXH Hoa Tươi",
FLOWER_LIST_RULE =
[[
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="24" P="0">Quy Tắc BXH Hoa Tươi</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0">Xếp hạng Đại Sứ GunPow được tính thông qua số lượng Hoa Quyến Rũ mà người chơi nhận được</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0">Hoa Quyến Rũ nhận từ sự kiện</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0">Người chơi tặng Hoa Quyến Rũ cho người chơi khác thông qua tính năng Tặng Hoa trong Trang Cá Nhân</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0">Sau khi sự kiện kết thúc, top 5 người chơi (tính riêng nam và nữ) sẽ nhận được  tư cách tham gia trình diễn và ứng xử tại hoạt động offline GunPow để giành giải thưởng đặc biệt, đồng thời sẽ nhận được phần thưởng từ xếp hạng</T><BR>10</BR>
]],
FREE_FLOWERS_WITHOUT_LIMIT ="Không giới hạn số lần tặng hoa",
NUMBER_OF_FLOWERS_RECEIVED = "Nhận Hoa",

RESOURCE_LOADING_TEXT = "Đang giải nén",
ACTIVITY_BACK_TEXT1 = "Đăng Nhập Trở Về",
ACTIVITY_BACK_TEXT2 = "Nạp Trở Về",
ACTIVITY_BACK_TEXT3 = "Chiến Đấu Trở Về",
ACTIVITY_BACK_TEXT4 = "Đăng nhập đủ %d ngày",
ROOM_TEXT1 = "Chưa có nửa kia",
SHOP_NEWCOIN = "Xu Điểm Danh",
SHOP_5_RULE4 = 
[[
<T C="229,105,22" S="22">1.</T><T C="127,70,26" S="18">Xu Điểm Danh có thể rút được bằng Kim Cương Khóa tại giao diện Kho Báu trong Cửa Hàng.</T><BR></BR>
<T C="229,105,22" S="22">1.</T><T C="127,70,26" S="18">Xu Điểm Danh dùng đổi vật phẩm tương ứng trong Cửa Hàng.</T><BR></BR>
]],

PRACTICE_TEXT1 = "Mời Song Tu",
PRACTICE_TEXT2 = "Hôm nay đã dùng: ",
PRACTICE_TEXT3 = "Trả %d %s để mở Ô Song Tu? Sau khi mở, hai bên sẽ dùng chung điểm thể lực, chuyển thành Điểm Tu Luyện cho mỗi bên.",
PRACTICE_TEXT4 = [[<T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >Hôm nay đã dùng: </T><I Z ="0.45">ui/common/common_icon_hylqhltb.png</I><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >%d</T><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >  Nhận: </T><I P="1">ui/common/common_icon_xl.png</I><T C="255,236,193" S="20" P="1" SC="79,60,48" SS="4" SE="1" >%d</T>]],
PRACTICE_TEXT5 = "Rời trạng thái Song Tu? Sau khi rời, %d giờ sau mới được mời bạn Song Tu mới.",
PRACTICE_TEXT6 = "Đã mở Song Tu, hãy mời nửa kia cùng Song Tu ngay nào!",
PRACTICE_TEXT7 = "Đã hủy Song Tu",
PRACTICE_TEXT8 = [[<T C="127,70,26" S="20" P="1">Đã xin Song Tu</T>]],
PRACTICE_TEXT9 = "Đã từ chối Song Tu",
PRACTICE_TEXT10 = "Có thể bắt đầu Song Tu",
PRACTICE_TEXT11 = "Đã gửi yêu cầu Song Tu",
PRACTICE_TEXT12 = "Đã gửi yêu cầu, hãy chờ phản hồi.",
PRACTICE_TEXT13 = "Đã có người rồi",
PRACTICE_TEXT14 = "Sau khi rời trạng thái Song Tu, %02d giờ %02d phút sau mới được mở lại",

GAMEACTIVITY_CUMULATIVELOGIN2 ="Tích lũy đăng nhập",
GAME_ACTIVITY_TYPE_3037 = "Hoàn Trả Kim Cương x3",
GAME_ACTIVITY_TYPE_3049 = "Giảm Giá Thẻ Tuần",
GAME_ACTIVITY_TYPE_3050 = "Giảm Giá Thẻ Tháng",   
TOPGOLD_TEXT1 = "%d ngày %d giờ",	
TOPGOLD_TEXT2 = "%d giờ %d phút",	
TOPGOLD_TEXT3 = [[<T C="229,105,22" S="22" P="0">Trả </T><I Z="0.5" P="0">%s</I><T C="127,70,26" S="24" P="0"> để tăng tốc %d giờ %d phút?</T>]],TOPGOLD_TEXT4 = "Tăng tốc thành công",	
PET_FETTER1 = "Duyên Nợ",	
PET_FETTER2 = "Pet Chính đạt Lv%d mới kích hoạt thuộc tính Duyên Nợ\nThuộc tính sẽ được tăng trực tiếp lên Pet Chính",	
PET_FETTER3 = "Cần Pet đạt Lv%d - %d Sao",	
PET_FETTER4 = "Pet không có Duyên Nợ với Pet khác",	
PET_FETTER5 = "Pet Tím trở lên sẽ có tính năng Duyên Nợ",	
PET_FETTER6 = "Bạn chưa có Pet",	
PET_FETTER7 = "Năng Động Hôm Nay",	
PET_FETTER8 = "Duyên Nợ Pet",	
PVP_HALL_42 = "Đấu Cân Bằng",	
PVP_HALL_43 = "Tuyệt Đối Công Bằng",	
PVP_HALL_44 = "Người chơi tham gia Đấu Cân Bằng sẽ có thuộc tính ngang nhau\nKhông Pet, không Ảo Hóa, không Thức Tỉnh",	
PVP_CARD_TIME_TITLE = "Đấu Hạng nhận Điểm Dũng Sĩ x3",	
PVP_CARD_ADD_PREC = "5 lần đầu Đấu Xếp Hạng mỗi ngày, Điểm Dũng Sĩ tăng %d%%",

TOWER_DESC_HERO = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Chỉ khi không ngừng khiêu chiến kẻ mạnh, bản thân mới trở nên mạnh hơn, cuối cùng đạt đến đỉnh cao.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Không giới hạn lượt khiêu chiến. Thất bại sẽ trở về trạng thái trước khi khiêu chiến, thành công sẽ giữ nguyên nộ khí và sinh lực hiện tại. Khi thành công, nếu sinh lực dưới 1% tính là 1%, mỗi lần khiêu chiến sẽ tạo mới đạo cụ kỹ năng.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Thưởng chưa nhận sẽ được gửi qua thư.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Quy tắc tạo mới nút: Không giới hạn số lần, tạo mới sẽ giảm một mức độ khó tầng hiện tại, mỗi lần cần tốn Kim Cương nhất định.</T><BR>20</BR>
]],
 TOWER_HERO_TEXT1 = "Chịu ảnh hưởng Tháp Anh Hùng",
 TOWER_HERO_TEXT2 = "Tạo mới lần này tốn: %d Kim Cương Khóa",
 TOWER_HERO_TEXT3 = "Khiêu chiến ải hiện tại",
 TOWER_HERO_TEXT4 = "Sinh lực còn lại",
 THREE_YEAR_TEXT1 = "Hướng dẫn hoạt động",
  THREE_YEAR_TEXT2 = "Đến ngay",
  THREE_YEAR_TEXT3 = "Xu Kỷ Niệm",
  GAMEACTIVITY_MARK_COIN = "Hoạt Động Xu Kỷ Niệm",
  THREE_YEAR_TEXT4 = 
[[
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0"> Quy tắc hoạt động Xu Kỷ Niệm</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0"> Mọi người đều có thể tham gia hoạt động Xu Kỷ Niệm, hoàn thành nhiệm vụ có thể nhận nhiều phần thưởng.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0"> Phần thưởng đặc biệt dành cho người mua Xu Kỷ Niệm. Nếu chưa mua Xu Kỷ Niệm, sẽ chỉ được nhận thưởng thường.</T><BR>20</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0"> Người đạt điều kiện hãy nhận thưởng kịp thời! Hoạt động kết thúc sẽ không thể nhận nữa!</T><BR>20</BR>
]],
 THREE_YEAR_TEXT5 = "Phần thưởng kỷ niệm trong nhiệm vụ giới hạn, cần mua Xu Kỷ Niệm để kích hoạt.",
 THREE_YEAR_TEXT6 = "Mua ngay",

 WAKEUP_TEXT47 = 
[[
<T C="229,105,22" S="22">Thức Tỉnh-Tiến Hóa</T><BR></BR>
<T C="127,70,26" S="20">1.</T><T C="127,70,26" S="18">Hoàn thành "Bậc 4-Kỹ Năng" và đạt Lv40 sẽ mở tính năng Thức Tỉnh-Tiến Hóa.</T><BR></BR>
<T C="127,70,26" S="20">2.</T><T C="127,70,26" S="18">Dùng Đá Thức Tỉnh mở "Bậc 5-Tiến Hóa", có thể tăng cấp tối đa, tăng thêm nhiều thuộc tính.</T><BR></BR>
]],

 WAKEUP_TEXT49 = "Tiến hóa",
 WAKEUP_TEXT50 = "Đã tiến hóa",
 WAKEUP_TEXT51 = {"Cần hoàn thành CS1 ","Cần hoàn thành CS2","Cần hoàn thành CS3","Cần hoàn thành CS4"},
 WAKEUP_TEXT52 = "Tiến hóa thành công",
 WAKEUP_TEXT53 = "Tăng ngay lực chiến",
 SPACE110 = "Chỉ cho bạn bè nhắn tin",
 GAMEACTIVITY_TOW_PACKAGE = "Hai gói quà",
 LIMIT_EQUIP_ATT = "Thiết bị này đã bị cấm đăng nhập, nếu có thắc mắc, hãy liên hệ CSKH.",

  CHARM_LIFT1 = "Đã báo danh",
  CHARM_LIFT2 = "BXH Thích (Tuần)",
  CHARM_LIFT3 = "BXH Thích (Tổng)",
  CHARM_LIFT4 = "Thời Trang Hấp Dẫn",
  CHARM_LIFT5 = "Mỗi ngày chỉ có thể chọn thích mỗi người 1 lần.",
  CHARM_LIFT6 = "Đã hết lượt chọn thích, mai hãy quay lại nhé!",
  CHARM_LIFT7 = "Đã chọn thích, nhận %d điểm Nổi Tiếng",
  CHARM_LIFT8 = "Thích",
  CHARM_LIFT9 = "Thích: ",
  CHARM_LIFT10 = "Đã báo danh thành công, xin đợi.",
  CHARM_LIFT11 = "Phải mặc Thời Trang trên người mới được báo danh!",
  CHARM_LIFT12 = "Dùng thời trang này để báo danh tham gia?",
  CHARM_LIFT13 = "Đang đề cử, xin vui lòng chờ.",
  CHARM_LIFT14 = "BXH Các Kỳ",
  CHARM_LIFT15 = "Kỳ %d",
  CHARM_LIFT16 = "Đang đề cử",
  CHARM_LIFT17 = "Báo danh thành công",
  CHARM_LIFT18 = "Báo danh thất bại",
  CHARM_LIFT19 = "Đã đề cử",
CHARM_LIFT20 = [[<T C="127,70,26" S="20" P="1">Dùng </T><T C="127,70,26" S="20" P="1">%d</T><I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1"> để đề cử? Duy trì %d giờ</T>]],
  CHARM_LIFT21 = "Chưa tìm được Quán Quân",
  CHARM_LIFT22 = "Chưa báo danh, cần báo danh mới được đề cử",
  CHARM_LIFT23 = " điểm, phát thưởng theo BXH Thích",
  CHARM_LIFT24 = "24 giờ chủ nhật hàng tuần tạo mới (Được thích > %d được vào BXH)",
 CHARM_LIFT25 = "Được thích > %d được vào BXH",
 CHARM_LIFT26 = "Được thích",
 CHARM_LIFT27 = "Được thích tuần này: ",
 CHARM_LIFT28 = "Được thích tổng cộng: ",
 CHARM_LIFT29 = "Không thể tự chọn thích bản thân",
 CHARM_LIFT30 = "Ảo Hóa không thể tham gia thi đấu",
 CHARM_LIFT31 = "Chưa có số liệu đề cử, hãy báo danh tham gia nhé!",

 CHARM_LIFT32 =
[[
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> Chọn Thích người khác sẽ nhận được thưởng Nổi Tiếng.</T><BR></BR>
<T C="158,0,0" S="22" P="0">1.</T><T C="62,34,8" S="22" P="0"> Người chơi Upload Ảnh trong trang cá nhân được đề cử nhiều hơn.</T><BR></BR>
<T C="158,0,0" S="22" P="0">2.</T><T C="62,34,8" S="22" P="0"> Người chơi hôm qua điểm năng động cao được đều cử nhiều hơn.</T><BR></BR>
<T C="158,0,0" S="22" P="0">3.</T><T C="62,34,8" S="22" P="0"> Người chơi Upload Voice trong trang cá nhân được đề cử nhiều hơn.</T><BR></BR>
<T C="158,0,0" S="22" P="0">4.</T><T C="62,34,8" S="22" P="0"> Phần thưởng thi đấu được gửi qua thư.</T><BR></BR>
]],

RELIC_TEXT_1 = "Ánh Sáng Di Tích",
RELIC_TEXT_2 = "Chưa có khiêu chiến",
RELIC_TEXT_3 = "Có thể nhận",
RELIC_TEXT_4 = [[<T C="255,227,116" S="18" P="0">Thời gian còn: </T><T C="255,236,193" S="18" P="0">%02d:%02d</T>]],
RELIC_TEXT_5 = "Khiêu chiến thành công",
RELIC_TEXT_6 = "Khiêu chiến thất bại",
RELIC_TEXT_7 = "Thời gian còn",
RELIC_TEXT_8 = "Tỉ lệ",
RELIC_TEXT_9 = "%02d:%02d:%02d sẽ hồi phục 1 lần",
RELIC_TEXT_10 = "Khiêu Chiến Di Tích",
RELIC_TEXT_11 = "Phát hiện",
RELIC_TEXT_12 = "Mời Thám Hiểm,Nhấp để vào.",
RELIC_TEXT_13 = "Tích lũy sát thương",
RELIC_TEXT_14 = "Hiện không có lượt trợ giúp, hãy quay lại sau.",
RELIC_TEXT_15 = "%s khiêu chiến thành công! Mọi người hãy cùng cố gắng!",
RELIC_TEXT_16 = "Khiêu chiến đã kết thúc",
RELIC_TEXT_17 = "Chia sẻ thất bại",

RELIC_TEXT_18 = {
[[<T C="255,236,193" S="20" P="0">Dùng hết sức đập vỡ phiến đá trước mặt, nhìn thấy 1 </T><T C="233,166,62" S="20" P="0">[%s]</T>]],
[[<T C="255,236,193" S="20" P="0">Càng đào sâu, càng cảm nhận được sức mạnh bí ẩn, ngẩng đầu thấy ngay </T><T C="233,166,62" S="20" P="0">[%s]</T>]],
},

GEM_MOUNTING_1 = "Ô Chính",
GEM_MOUNTING_2 = "Ô Phụ",
GEM_MOUNTING_3 = "Chọn",
GEM_MOUNTING_4 = "EXP sẽ dôi ra %d, vẫn tiếp tục?",
GEM_MOUNTING_5 = "Ghép thành công",
GEM_MOUNTING_6 = "Ghép thất bại",
GEM_MOUNTING_7 = "Tăng bậc thành công",
GEM_MOUNTING_8 = "Tăng bậc thất bại",
GEM_MOUNTING_9 = "Gộp thành công",
GEM_MOUNTING_10 = "Gộp thất bại",
GEM_MOUNTING_11 = " (Có %d)",
RELIC_TEXT_19 = "Người phát hiện",
GUILD_STORES_BUY_LIMIT = "Vật phẩm trong tiệm, mỗi người mỗi ngày chỉ được mua 2 món.",
PHANTOM32 = "Biến hình sẽ mất ngoại hình Pet hiện tại, tiếp tục không?",
PHANTOM33 = "Khôi phục sẽ mất ngoại hình Pet hiện tại, tiếp tục không?",
GEM_MOUNTING_12 = "Có Đá Lv7 trở lên, hoặc có Đá Ma Lực, tiếp tục không?",
OPENCHEST2 = "Mỗi ngày được mua 2 lần (Còn: %d)",
GEM_MOUNTING_13 = "Ghép nhận EXP: %d",
GEM_MOUNTING_14 = "Đã đạt cấp tối đa của giai đoạn này",
GEM_MOUNTING_15 = "Chọn đạo cụ lên cấp:",

BATTLE_HELP_TEXT1 = "Tình hình trợ chiến",
BATTLE_HELP_TEXT2 = "Đã giúp đỡ: ",
BATTLE_HELP_TEXT3 = "Số lần có thưởng: ",
BATTLE_HELP_TEXT4 = "Có thể giúp",
BATTLE_HELP_TEXT5 = "Giúp",
BATTLE_HELP_TEXT6 = "Mở Treo Thưởng",
BATTLE_HELP_TEXT7 = "Trận được nhận thưởng",

CHAT_REPORT_TEXT1 = "Đã tố cáo",
CHAT_REPORT_TEXT2 = "Chọn lý do tố cáo",
CHAT_REPORT_TEXT3 = "Bạn đang tố cáo“%s”",
CHAT_REPORT_TEXT4 = {"Đăng tin quấy rối ","Ngôn từ xúc phạm","Quảng cáo","Nội dung xấu","Khác"},
CHAT_REPORT_TEXT5 = "Nhập nội dung vào đây. Sau khi xác thực, sự việc sẽ được xử lý.",
CHAT_REPORT_TEXT6 = "Tố cáo",
CHAT_REPORT_TEXT7 = "Chọn lý do tố cáo",
CHAT_REPORT_TEXT8 = {"Số lần tố cáo đạt tối đa", "Tố cáo trong thời gian chờ", "Nội dung tố cáo đang bỏ trống", "Nội dung tố cáo vượt quá giới hạn", "Lỗi khác"},
LevelAndNameFormat2 = [[<T S="24" C="158,0,0"  P="0">Lv%d</T><BL>10</BL><I Z="1" P="0">ui/common/common_icon_kuafu.png</I><T S="24" C="79,60,48" P="0">%s</T>]],
KID_HOME_TEXT1 = "Xác nhận mua và dùng %s",
YOU_TO_KUAFU = [[<T C="105,65,46" S="22">Đang </T>]],

CHECKOTHER_NEWTEXT1 = "Gần đây",
CHECKOTHER_NEWTEXT2 = "Chế giễu sẽ nhận ngẫu nhiên: Kim Cương Đỏ, Vàng, EXP, Thể Lực, v.v",
CHECKOTHER_NEWTEXT3 = "Đừng chế giễu bản thân!",
CHECKOTHER_NEWTEXT4 = "Ai tặng hoa cho bản thân vậy?",
CHECKOTHER_NEWTEXT5 = "Đang chiến đấu, không thể vào thăm",
CHECKOTHER_NEWTEXT6 = "Phòng này không thể vào",

PROFESSION_TEXT1 = "Hãy chọn hệ bạn muốn",
PROFESSION_TEXT2 = {"Chiến Sĩ","Sát Thủ","Phù Thủy"},
PROFESSION_TEXT3 = {"Chống đỡ chuyên nghiệp, gây thêm sát thương cho Sát Thủ","Chuyên gia tấn công, gây thêm sát thương cho Phù Thủy","Thiên tài khống chế, gây thêm sát thương cho Chiến Sĩ"},
PROFESSION_TEXT4 = "Xác nhận",
PROFESSION_TEXT5 = "Hãy chọn 1 hệ",
PROFESSION_TEXT6 = "Xác nhận chuyển hệ thành %s? (Chuyển hệ thành công sẽ vào mục Thiên Phú)",
PROFESSION_TEXT7 = "Hãy hoàn thành tất cả nhiệm vụ cần thiết!",
PROFESSION_TEXT8 = "Hệ",
PROFESSION_TEXT9 = [[
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="24" P="0">Quy tắc Hệ</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0">Không cần làm nhiệm vụ lần nữa!</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0">Lần đầu chuyển hệ sẽ trả lại tất cả Học Thức, những lần sau đó chỉ trả 90%, Thiên Phú được tạo mới sẽ trả lại toàn bộ</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0">Chỉ được chọn 1 loại kỹ năng hệ để cường hóa</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0">Sau khi cường hóa kỹ năng hệ, cần vào mục đạo cụ kỹ năng để nâng cấp</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0">Hiệu quả khắc chế giữa các hệ chỉ hiệu lực trong chiến đấu</T><BR>10</BR>
]],
PROFESSION_TEXT10 = "Chưa hoàn thành chuyển hệ, hãy quay lại sau.",
PROFESSION_TEXT11 = "Kỹ Năng Hệ",
PROFESSION_TEXT12 = "Cấp Kế",
PROFESSION_TEXT13 = "Chọn hệ muốn xem",
PROFESSION_TEXT14 = "Lên cấp tốn",
PROFESSION_TEXT15 = "Đã đạt cấp tối đa",
PROFESSION_TEXT16 = "Chuyển Hệ",
PROFESSION_TEXT18 = "Hiện không cần tạo mới Thiên Phú",
PROFESSION_TEXT20 = "Chỉ được chọn 1 Thiên Phú để cường hóa, xác nhận chọn tuyến Thiên Phú (%s)?",
PROFESSION_TEXT21 = "Cần kích hoạt kỹ năng tiền đề",
PROFESSION_TEXT22 = "Cần tăng kỹ năng tiền đề đến cấp tối đa",
PROFESSION_TEXT24 = "Mở Hệ",
PROFESSION_TEXT25 = {"Khắc Chế", "Bị địch"},

DOUBLETOWER_TEXT1 = "Ảo Cảnh Không Gian",
 DOUBLETOWER_TEXT2 = "Điều kiện vượt ải hoàn mỹ",
 DOUBLETOWER_TEXT3 = "Vượt lần đầu được nhận",
 DOUBLETOWER_TEXT4 = "Chiến",
 DOUBLETOWER_TEXT5 =  [[
<T C="229,105,22" S="22" P="0"></T><T C="127,70,26" S="24" P="0">Quy tắc Ảo Cảnh Không Gian</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">1.</T><T C="127,70,26" S="22" P="0">Mỗi ngày có 3 cơ hội khiêu chiến.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">2.</T><T C="127,70,26" S="22" P="0">Ngày 1 hằng tháng sẽ tạo mới tiến độ và trạng thái vượt ải, đồng thời phát thưởng theo hạng.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">3.</T><T C="127,70,26" S="22" P="0">0 giờ mỗi ngày sẽ quay về tầng thứ 1.</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">4.</T><T C="127,70,26" S="22" P="0">Sau khi vượt ải hoàn mỹ sẽ có thể càn quét</T><BR>10</BR>
<T C="229,105,22" S="22" P="0">5.</T><T C="127,70,26" S="22" P="0">Điều kiện vượt ải tính chung cho cả đội, hãy phối hợp thật ăn ý!</T><BR>10</BR>
]],
 DOUBLETOWER_TEXT6 = {"Sinh lực còn lại＞%d%%", "Số lần ra tay＜%d", "Sát thương 1 lần＞%d", "Tỉ lệ chính xác=%d%%", "Số lần dùng đạo cụ＜%d", "Không dùng%s", "Số người tử vong=%d"},
 DOUBLETOWER_TEXT7 = "Vượt ải hoàn mỹ được nhận",
 DOUBLETOWER_TEXT8 = [[<T C="127,70,26" S="20" P="0">Ngày 1 hàng tháng </T> <T C="255,89,74" S="20" P="0"> %s </T><T C="127,70,26" S="20" P="0"> sẽ phát thưởng theo hạng Ảo Cảnh Không Gian</T>]],
 DOUBLETOWER_TEXT9 = "Lượt trợ chiến: ",
 DOUBLETOWER_TEXT10 = "%s mời bạn cùng khiêu chiến\nẢo Cảnh Không Gian %s",
 DOUBLETOWER_TEXT11 = [[<T C="127,70,26" S="20" P="1">Bạn đã dùng hết lượt khiêu chiến, dùng %d </T><I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1"> mua 1 lượt?</T>]],
 DOUBLETOWER_TEXT12 = "Đang đợi đồng đội sẵn sàng",
 DOUBLETOWER_TEXT13 = "Sau khi sẵn sằng, chủ phòng được mở khiêu chiến",
 DOUBLETOWER_TEXT14 = "Sau khi vượt ải hoàn mỹ tầng này mới được càn quét",
 DOUBLETOWER_TEXT15 = "Số lần trợ chiến không đủ",
 DOUBLETOWER_TEXT16 = "Số lần khiêu chiến không đủ",
 DOUBLETOWER_TEXT17 = "Đã vượt hết",
 DOUBLETOWER_TEXT18 = "Trợ chiến thành công được nhận",
 DOUBLETOWER_TEXT19 = "Trợ chiến thất bại được nhận",
 DOUBLETOWER_TEXT20 = "Hôm nay đã hết lượt mua",
 DOUBLETOWER_TEXT21 = "Số lần mua hôm nay đã đạt tối đa, hãy Tăng cấp VIP để Tăng số lần mua!",
PROFESSION_TEXT26 = [[<T C="127,70,26" S="24" P="0">Từ bỏ chuyển hệ lần này? (Lần này miễn phí)</T><BR>10</BR><T C="127,70,26" S="24" P="0">, hoàn trả %d%% Học Thức</T>]],
PROFESSION_TEXT17 = [[<T C="127,70,26" S="24" P="0">Từ bỏ hệ hiện tại?</T><BR>10</BR><T C="127,70,26" S="24" P="0">Tốn %d</T><I Z="0.5" P="0">%s</I><T C="127,70,26" S="24" P="0">, hoàn trả %d%% Học Thức</T>]],
PROFESSION_TEXT23 = [[<T C="127,70,26" S="24" P="0">Xác nhận tạo mới Thiên Phú? (Lần này miễn phí)</T><BR>10</BR><T C="127,70,26" S="24" P="0">, hoàn trả %d%% Học Thức</T>]],
PROFESSION_TEXT19 = [[<T C="127,70,26" S="24" P="0">Tạo mới Thiên Phú ngay?</T><BR>10</BR><T C="127,70,26" S="24" P="0">Tốn %d</T><I Z="0.5" P="0">%s</I><T C="127,70,26" S="24" P="0">, hoàn trả %d%% Học Thức</T>]],

}