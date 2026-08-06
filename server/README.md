# Game server — dự án mới

Server Java cho game mới (client Unity/C#). Bắt đầu lại từ đầu sau khi dừng
dự án nông trại cũ (Cozy Farming) — xem lịch sử git nếu cần tham khảo code
cũ.

## Quy trình: từng giai đoạn, xong mới sang giai đoạn kế

- [x] **Giai đoạn 1 — khung project**: Maven project biên dịch + chạy được,
      `DataSourceProvider` (HikariCP, đọc `DB_URL`/`DB_USER`/`DB_PASSWORD`
      từ biến môi trường, không hardcode tài khoản), 1 endpoint `/health`
      xác nhận server sống, có test JUnit xác nhận.
- [x] **Giai đoạn 2 — tài khoản**: 1 bảng `users` duy nhất cho MỌI cách đăng
      nhập — 1 user id xuyên suốt, các cột định danh (`username`,
      `guest_token`, `google_id`, `apple_id`) đều nullable, thêm dần khi liên
      kết chứ không tạo bản ghi mới.
      - `POST /api/auth/register` {username, password} — tài khoản thường.
      - `POST /api/auth/login` {username, password}.
      - `POST /api/auth/guest` {guestToken?} — không gửi token (hoặc gửi
        token lạ) thì tạo khách mới, trả token để client tự lưu; gửi đúng
        token cũ thì vào lại ĐÚNG tài khoản đó (không tạo mới).
      - `POST /api/auth/forgot/{request,reset}` — mã 6 số, hạn 15 phút.
        ⚠️ CHƯA gửi email/SMS thật, trả `devOnlyCode` để test.
      - `POST /api/auth/link/upgrade` {userId, username, password} — khách
        nâng cấp lên tài khoản thường, GIỮ NGUYÊN user id (không mất tiến
        trình). Chặn nếu user không phải khách thuần (409) hoặc username
        trùng (409).
      - `POST /api/auth/social/{google,apple}` {idToken} — đăng nhập THẲNG
        bằng mạng xã hội: đã liên kết thì vào lại đúng tài khoản, chưa từng
        liên kết thì tạo tài khoản MỚI (chỉ có mạng xã hội, chưa có
        username/password).
      - `POST /api/auth/link/{google,apple}` {userId, idToken} — gắn thêm
        mạng xã hội vào tài khoản ĐANG đăng nhập (thường dùng khi đã đăng
        nhập bằng username/password). Chặn nếu id đó đã gắn cho user khác
        (409) — không tự gộp 2 tài khoản.
      - **Khung xác thực OAuth** (`auth/oauth/`): `GoogleTokenVerifier` xác
        thực THẬT qua endpoint `tokeninfo` chính chủ Google (không phải
        placeholder) — cần biến môi trường `GOOGLE_CLIENT_ID` (OAuth client
        ID thật từ Google Cloud Console) để so khớp `aud`. `AppleTokenVerifier`
        CHƯA xong thật (Apple ID token cần verify chữ ký JWT qua JWKS, chưa
        thêm thư viện JWT) — chủ động báo lỗi 401 thay vì tin token gửi lên
        (không chấp nhận kiểu "placeholder tin tưởng luôn" vì đó là lỗ hổng
        bảo mật thật), TODO thêm thư viện JWT (vd. nimbus-jose-jwt) khi làm
        thật.
      Test: `PasswordHasherTest`, `UserDaoTest` (đơn vị); `AuthFlowTest`
      (luồng HTTP thật: đăng ký→đăng nhập→quên mật khẩu→đặt lại→đăng nhập
      lại; khách tạo mới rồi vào lại đúng tài khoản bằng token cũ; nâng cấp
      khách giữ nguyên user id rồi đăng nhập được bằng mật khẩu; đăng nhập
      mạng xã hội tạo mới rồi vào lại đúng tài khoản; liên kết mạng xã hội
      vào tài khoản thường rồi bị chặn khi gắn trùng cho tài khoản khác).
- [x] **Giai đoạn 3 — tạo nhân vật**: 1 user 1 nhân vật (bảng `characters`,
      PK trên `user_id`). Trang phục chỉ 3 ô cơ bản (tóc/áo/quần) — CHƯA có
      bảng vật phẩm thật cho game mới này, id trang phục tạm là số nguyên tự
      do, TODO ràng buộc theo catalog thật khi có hệ vật phẩm.
      - `POST /api/character/create` {userId, name, gender, hairId, topId,
        bottomId} — tên 2-20 ký tự, giới tính 0/1, chặn nếu user đã có nhân
        vật (409) hoặc tên trùng người khác (409, kiểm tra toàn server chứ
        không riêng theo user), 404 nếu user không tồn tại.
      - `GET /api/character?userId=` — 404 nếu chưa tạo (client dựa vào đó
        để biết đưa sang màn tạo nhân vật hay vào thẳng sảnh).
      - `POST /api/character/outfit` {userId, hairId, topId, bottomId} — đổi
        trang phục sau khi đã tạo, 404 nếu chưa có nhân vật.
      Test: `CharacterDaoTest` (đơn vị); `CharacterFlowTest` (luồng HTTP
      thật: chưa tạo trả 404, user không tồn tại bị chặn, tên/giới tính
      không hợp lệ bị chặn, tạo 2 lần bị chặn, tên trùng người khác bị chặn,
      đổi trang phục sau khi tạo).
- [x] **Giai đoạn 4 — sảnh**: Sảnh = màn hình chính sau khi đăng nhập + tạo
      nhân vật, mọi người đứng chung 1 world, thấy được nhân vật/vị trí của
      nhau. ⚠️ Làm bằng REST POLLING (bảng `lobby_presence`), KHÔNG phải
      WebSocket — server hiện tại chỉ có `com.sun.net.httpserver` thuần,
      chưa thêm dependency WebSocket. Polling đủ dùng cho sảnh tĩnh (đứng
      nói chuyện/chọn menu), TODO nâng cấp WebSocket nếu cần đồng bộ di
      chuyển mượt hơn sau này.
      - `POST /api/lobby/heartbeat` {userId, x, y} — client gọi định kỳ
        (khuyến nghị mỗi 1-2 giây) để báo còn hoạt động + cập nhật vị trí.
        404 nếu chưa tạo nhân vật (sảnh chỉ hiện người có nhân vật).
      - `GET /api/lobby/players` — danh sách người ĐANG hoạt động (heartbeat
        trong 15 giây gần nhất), JOIN với `characters` để trả kèm
        tên/giới tính/trang phục cho client vẽ được, không chỉ toạ độ trần.
      - `POST /api/lobby/leave` {userId} — thoát chủ động, gỡ khỏi danh sách
        ngay thay vì chờ hết hạn 15 giây.
      Test: `PresenceDaoTest` (đơn vị, heartbeat/hết hạn/ghi đè vị trí/gỡ
      khỏi danh sách); `LobbyFlowTest` (luồng HTTP thật: chưa có nhân vật bị
      chặn, sảnh trống mặc định, heartbeat hiện đúng tên+vị trí, thoát gỡ
      khỏi danh sách ngay).
- [x] **Giai đoạn 5 — chat**: 1 kênh chat sảnh chung (`chat_messages`, mọi
      người thấy chung), poll bằng REST giống cơ chế sảnh giai đoạn 4 — client
      giữ `id` tin nhắn cuối đã thấy, gọi lại `sinceId` đó để lấy tin mới,
      KHÔNG dùng mốc thời gian (tránh lệch giờ máy giữa client/server).
      - `POST /api/chat/send` {userId, text} — bắt buộc đã tạo nhân vật (404
        nếu chưa), tên hiện trong chat lấy từ TÊN NHÂN VẬT chứ không phải
        username tài khoản. Chặn nội dung rỗng/quá 500 ký tự.
      - `GET /api/chat/recent?sinceId=&limit=` — tin nhắn có `id > sinceId`,
        cũ nhất trước, mặc định 50 tin/lần, tối đa 200.
      - `sender_name` lưu tại thời điểm gửi (denormalize) — lịch sử chat hiện
        đúng tên lúc gửi, không đổi ngược nếu người chơi đổi tên nhân vật
        sau này.
      Test: `ChatMessageDaoTest` (đơn vị, gửi/lọc theo sinceId/giới hạn số
      lượng); `ChatFlowTest` (luồng HTTP thật: chưa có nhân vật bị chặn, nội
      dung rỗng bị chặn, chat trống mặc định, gửi rồi poll tăng dần không lặp
      lại tin đã thấy).
- [x] **Giai đoạn 6 — cài đặt (phần cần server)**: 10 mục cài đặt trong
      game, nhưng CHỈ notifications/privacy & social/account/support cần
      server — graphics/audio/controls/gameplay/language/about là cấu hình
      thuần client (Unity lưu local), không có gì để đồng bộ.
      - `GET /api/settings?userId=` / `POST /api/settings/update` — gộp
        chung "Notifications" (bật/tắt push) + "Privacy & Social"
        (`friendRequestPrivacy`/`messagePrivacy`: EVERYONE/NOBODY) +
        "Language" (đồng bộ đa thiết bị, dù bản thân ngôn ngữ hiển thị vẫn
        client tự xử lý) vào 1 bảng `user_settings`. Update là CẬP NHẬT MỘT
        PHẦN — field nào không gửi (null) thì giữ nguyên, khớp cách người
        dùng thật chỉ đổi 1 mục mỗi lần trong màn cài đặt. Chưa từng lưu thì
        trả về mặc định (khớp cách `WalletDao` đã làm ở dự án trước).
      - **Account**: `POST /api/account/change-password` (đổi mật khẩu khi
        ĐANG đăng nhập, khác `ForgotPasswordResetHandler` — endpoint đó
        dùng khi KHÔNG đăng nhập được). `POST /api/account/delete` — tài
        khoản có mật khẩu bắt buộc xác nhận đúng mật khẩu (401 nếu sai,
        chặn xoá phá hoại nếu lộ userId), tài khoản khách thuần xoá thẳng
        không cần xác nhận gì thêm.
      - **Support**: `POST /api/support/report` {userId, category(bug|contact),
        message} — lưu vào `support_tickets`, chưa có màn admin (xem trực
        tiếp DB). `GET /api/support/tickets?userId=` — người chơi xem lại
        báo cáo của chính mình.
      Test: `UserSettingsDaoTest` (đơn vị); `SettingsFlowTest` (luồng HTTP
      thật: mặc định khi chưa lưu, giá trị riêng tư sai bị chặn, cập nhật
      một phần không ghi đè field không gửi); `AccountFlowTest` (đổi mật
      khẩu sai mật khẩu cũ bị chặn, tài khoản khách chưa có mật khẩu không
      đổi được, xoá tài khoản thường cần đúng mật khẩu, xoá tài khoản khách
      không cần mật khẩu); `SupportFlowTest` (category/nội dung không hợp lệ
      bị chặn, chỉ thấy báo cáo của chính mình).
- [x] **Giai đoạn 7 — bạn bè + quà tặng/thân mật**: 1 cặp bạn bè chỉ 1 dòng
      duy nhất trong `friendships` (chuẩn hoá `userIdA < userIdB`, không quan
      trọng ai gửi lời mời trước) — điểm thân mật (`intimacy_points`) gắn
      liền với tình bạn, mất bạn là mất điểm.
      - `POST /api/friends/request` {fromUserId, toUserId} — tôn trọng cài
        đặt "Privacy & Social" của người NHẬN (giai đoạn 6): `NOBODY` thì
        chặn thẳng (403).
      - `POST /api/friends/respond` {requestId, userId, accept} — `userId`
        BẮT BUỘC là người nhận lời mời (chặn tự duyệt lời mời của mình hoặc
        người thứ 3 duyệt hộ, 403).
      - `GET /api/friends?userId=`, `GET /api/friends/requests?userId=`
        (lời mời đang chờ phản hồi), `POST /api/friends/remove`.
      - `POST /api/friends/gift` {fromUserId, toUserId, giftId} — tặng quà
        CỘNG THẲNG điểm thân mật, chỉ tặng được cho bạn bè (404 nếu chưa kết
        bạn). ⚠️ Game chưa có ví/xu (chưa làm shop/economy) nên quà tặng
        CHƯA tốn tiền — giới hạn 1 LẦN/CẶP BẠN/NGÀY (429 nếu tặng lại sớm)
        để tránh gọi API liên tục max điểm thân mật tức thì, TODO đổi sang
        tốn xu khi có ví. `GiftCatalog` 4 loại quà (hoa/socola/gấu bông/
        trang sức), điểm tăng dần theo độ "đắt" của quà.
      Test: `FriendshipDaoTest` (đơn vị, chuẩn hoá thứ tự cặp/cộng-trừ điểm
      không phụ thuộc thứ tự tham số); `FriendFlowTest` (luồng HTTP thật: tự
      kết bạn bị chặn, privacy NOBODY chặn lời mời, gửi trùng bị chặn, duyệt
      sai người bị chặn, chấp nhận rồi xuất hiện trong danh sách bạn, huỷ kết
      bạn, từ chối không tạo tình bạn); `GiftFlowTest` (tặng cho người lạ bị
      chặn, quà không hợp lệ bị chặn, tặng cộng đúng điểm rồi tặng lại ngay bị
      chặn theo cooldown, hoạt động đúng dù đổi thứ tự from/to).
- [x] **Giai đoạn 8 — kết hôn/đám cưới**: "Đám cưới" hiểu là chính trạng thái
      kết hôn hoàn tất (chưa làm hệ sự kiện/lễ cưới riêng, ví dụ đặt lịch/mời
      khách — chỉ số liệu cân bằng ở `MarriageConstants` là tự đặt, game mới
      không có gốc thật để đối chiếu).
      - `POST /api/marriage/propose` {fromUserId, toUserId} — cầu hôn: phải
        đang là bạn bè (404), chưa ai kết hôn (409), đủ 1000 điểm thân mật
        (409 nếu thiếu). "Mua nhẫn" = TRỪ 200 điểm thân mật chung của cặp
        NGAY khi gửi (chưa có ví/xu, xem TODO giai đoạn 7) — dù bị từ chối
        CŨNG KHÔNG hoàn lại (giống mua nhẫn thật ngoài đời, tăng cân nhắc
        trước khi cầu hôn).
      - `POST /api/marriage/respond` {proposalId, userId, accept} —
        `userId` BẮT BUỘC là người ĐƯỢC cầu hôn (chặn tự chấp nhận lời cầu
        hôn của chính mình, 403). Chấp nhận = tạo hôn nhân (bảng `marriages`,
        chuẩn hoá `userIdA < userIdB` giống `friendships`) + xoá lời cầu
        hôn. Từ chối chỉ xoá lời cầu hôn.
      - `GET /api/marriage/status?userId=` — {married, spouseUserId}.
      - Chưa làm ly hôn (không có yêu cầu) — kết hôn 1 lần vĩnh viễn ở phiên
        bản này.
      Test: `MarriageDaoTest` (đơn vị, chuẩn hoá thứ tự cặp); `MarriageFlowTest`
      (luồng HTTP thật: tự cầu hôn bị chặn, cầu hôn người lạ bị chặn, thiếu
      điểm thân mật bị chặn, chấp nhận sai người bị chặn, cầu hôn thành công
      trừ đúng tiền nhẫn rồi chấp nhận tạo hôn nhân, đã kết hôn rồi không cầu
      hôn người khác được, từ chối không tạo hôn nhân và không hoàn tiền
      nhẫn).
- [x] **Giai đoạn 9 — level/exp + ví vàng/kim cương (nền tảng)**: Người dùng
      đưa ra bản thiết kế chi tiết cho hệ kết hôn (yêu cầu level 20-30+, chi
      phí bằng vàng/kim cương, ly hôn + cooldown...) — nhưng game chưa có hệ
      level hay ví tiền nào cả, nên làm 2 hệ NỀN này trước khi nâng cấp hệ
      kết hôn (giai đoạn 10).
      - `character_levels` (bảng RIÊNG với `characters`, không đụng bảng cũ)
        — `GET /api/level?userId=`, `POST /api/level/add-exp` {userId, amount}.
        Đường cong exp tự đặt (`level * 100` exp lên level kế) — game mới
        không có gốc thật để đối chiếu. ⚠️ CHƯA có hệ chiến đấu/nhiệm vụ thật
        để cộng exp — `add-exp` là HOOK sẵn cho các hệ đó gọi vào sau.
      - `wallets` (vàng/kim cương) — `GET /api/wallet?userId=`,
        `POST /api/wallet/add` {userId, gold?, diamond?}. Người chơi mới
        KHÔNG được cấp sẵn tiền (khác dự án nông trại cũ có `STARTING_COINS`)
        vì chưa có nguồn kiếm tiền nào để cân bằng số khởi điểm hợp lý.
        ⚠️ CHƯA có shop/hệ kiếm tiền thật — `add` là HOOK tương tự.
      Test: `LevelServiceTest` (đơn vị, công thức lên level kể cả lên nhiều
      level 1 lần cộng exp), `LevelDaoTest`, `WalletDaoTest` (đơn vị);
      `LevelFlowTest`, `WalletFlowTest` (luồng HTTP thật).
- [x] **Giai đoạn 10 — nâng cấp hệ kết hôn theo bản thiết kế**: `ProposeHandler`
      kiểm tra ĐỦ điều kiện theo thứ tự (dừng ở điều kiện đầu tiên không đạt):
      bạn bè → đủ level `MIN_LEVEL=25` cả hai → kết bạn đủ 7 ngày (thêm
      `created_at` vào `Friendship`/`FriendshipDao`) → đủ 1000 điểm thân mật
      → cả hai đang online (`PresenceDao.isOnline()`, dùng lại
      `PresenceDao.ONLINE_WINDOW_MS` — tách hằng số này ra khỏi
      `LobbyPlayersHandler` để `ProposeHandler` dùng chung) → chưa ai kết hôn
      → không ai đang trong thời gian chờ sau ly hôn.
      - `currency` ("gold"/"diamond") trong request cầu hôn — "mua nhẫn" trừ
        THẬT vào ví (100.000 Gold HOẶC 500 Kim cương, người cầu hôn chọn 1
        trong 2). Chưa có hệ vật phẩm nên KHÔNG có "nhẫn cưới" dạng item thật,
        chỉ trừ tiền tương ứng.
      - `POST /api/marriage/divorce` {userId} — ly hôn ĐƠN PHƯƠNG (không cần
        đối phương đồng ý, tránh bị "giam" hôn nhân mãi mãi). Cả HAI người
        đều bị áp thời gian chờ 3 ngày (`divorce_cooldowns`) trước khi cưới
        lại được, với BẤT KỲ ai chứ không riêng người vừa ly hôn.
      - Các phần còn lại của bản thiết kế (chơi trận/nhiệm vụ đôi/thắng trận/
        sự kiện cặp đôi tăng thân mật, online cùng +1đ/10 phút, couple
        house/buff tổ đội/bảng xếp hạng/nhiệm vụ hằng ngày cặp đôi) cần hệ
        chiến đấu/nhiệm vụ/nhà ở/đội nhóm/leaderboard CHƯA XÂY — để giai đoạn
        sau khi có hệ gốc, không bịa tạm.
      Test: `DivorceCooldownDaoTest` (đơn vị); `MarriageFlowTest` viết lại
      hoàn toàn — mỗi điều kiện mới có test riêng (thiếu level/kết bạn chưa
      đủ lâu/đối phương offline/không đủ vàng đều bị chặn 409/402), cộng luồng
      đầy đủ: cầu hôn trừ đúng vàng → chấp nhận tạo hôn nhân → ly hôn → cả
      hai vào cooldown → cầu hôn lại ngay bị chặn.
- [x] **Giai đoạn 11 — hệ thống nhân vật mở rộng (tuỳ chỉnh + trang bị làm
      đẹp)**: tách khỏi `Character` (chỉ giữ tóc/áo/quần lúc tạo) sang bảng
      mới `character_appearance` cho các ô chỉnh SAU khi vào game — mắt,
      avatar, khung avatar, danh hiệu, biểu cảm — CỘNG các ô "trang bị cho
      đẹp" không có chỉ số — mũ, áo, quần, giày, pet, skin. 11 ô này gộp
      chung 1 enum `CosmeticType`.
      - `CosmeticCatalog` (tĩnh, giống `GiftCatalog`) — danh mục vật phẩm.
        `GET /api/cosmetics/catalog`.
      - `player_cosmetics` — sở hữu vật phẩm. `GET /api/cosmetics/owned?userId=`.
        `POST /api/cosmetics/unlock` {userId, itemId} — hệ shop/thành tựu/
        gacha CHƯA XÂY nên đây là HOOK tạm (giống `AddCurrencyHandler`) đứng
        thay cho nguồn mở khoá thật sau này.
      - `GET /api/character/appearance?userId=` — các ô đang trang bị (mặc
        định toàn `null` = chưa trang bị gì, client tự vẽ mặc định).
      - `POST /api/character/appearance/equip` {userId, slot, itemId} — trang
        bị 1 vật phẩm vào 1 ô (`itemId` = 0/null để tháo ra). Chặn nếu: chưa
        có nhân vật (404), vật phẩm không khớp loại ô (400), chưa sở hữu vật
        phẩm (403).
      - Giới tính (nam/nữ) và chọn set quần áo lúc tạo nhân vật đã có sẵn từ
        Giai đoạn 3 (`CreateCharacterHandler`, `hairId`/`topId`/`bottomId`),
        không làm lại.
      Test: `PlayerCosmeticDaoTest`, `CharacterAppearanceDaoTest` (đơn vị);
      `AppearanceFlowTest` (luồng HTTP thật: mở khoá → trang bị → tháo, chặn
      trang bị khi chưa sở hữu/sai loại ô/chưa có nhân vật).
- [x] **Giai đoạn 12 — lõi gameplay match-3 (Story mode)**: package
      `vn.dreamtech.game.server.battle`. KHÔNG có client Unity để chạy thử
      bằng mắt — logic server-authoritative, kiểm bằng unit test (engine) +
      test luồng HTTP thật (chấp nhận theo lựa chọn của người dùng).
      - `battle.engine`: `TileBoard` (bàn cờ 8x8, 6 màu), `BoardGenerator`
        (sinh bàn không có sẵn khớp), `MatchFinder` (dò hàng/cột >=3 cùng
        màu), `CascadeResolver` (lặp xoá→rơi→lấp đầy→dò lại cho tới hết
        khớp — mỗi vòng lặp là 1 tầng **chain**).
      - Cơ chế: **combo** (khớp liên tiếp không trượt lượt nào +10%/tầng,
        tối đa 5 tầng, trượt 1 lượt là reset về 0); **mana** (+2/ô khớp, tối
        đa 100); **ultimate** (đủ mana → tốn hết mana, gây 80 sát thương cố
        định, không phụ thuộc bàn cờ); **buff/debuff** (`BuffType` — khớp
        critical (nhóm ≥5 ô) tự nhận buff +20% sát thương 2 lượt kế; địch cứ
        3 lượt phản đòn 1 lần, tự áp debuff -50% mana nhận 2 lượt kế); **chain**
        (mỗi tầng dây chuyền +20% sát thương tầng đó); **critical** (nhóm ≥5
        ô = x2 sát thương, nhóm 4 ô = x1.5).
      - `StoryLevelCatalog` (tĩnh, 3 màn tuyến tính, MVP) — thắng trận cộng
        exp/vàng thật qua `LevelDao`/`WalletDao` (nối vào nền tảng Giai đoạn
        9). `BattleService` giữ phiên trận TRONG BỘ NHỚ (không lưu DB — trận
        đấu là phiên thời gian thực, không phải dữ liệu cần bền vững).
      - `POST /api/battle/story/start` {userId, levelId},
        `POST /api/battle/swap` {battleId, r1, c1, r2, c2},
        `POST /api/battle/ultimate` {battleId},
        `GET /api/battle/state?battleId=`,
        `GET /api/battle/story/levels`.
      - CHƯA làm: Adventure/Daily/Weekly Challenge/Event Puzzle, toàn bộ
        PvP (Ranked/Casual/Custom Room/Tournament/Guild War/Season/Replay/
        Spectate) và phần còn lại của PvE (Dungeon/Elite Dungeon/Tower/Raid/
        Boss Rush/World Boss/Guild Boss) — cần thêm hệ guild/matchmaking/
        replay chưa xây, để giai đoạn sau khi lõi match-3 đã ổn định.
      Test: `MatchFinderTest`, `BoardGeneratorTest`, `CascadeResolverTest`
      (đơn vị, engine thuần logic); `BattleServiceTest` (đơn vị service —
      dò nước đi khớp/không khớp thật trên bàn cờ ngẫu nhiên bằng chính
      `MatchFinder`, không giả lập, để test đúng hành vi server); `BattleFlowTest`
      (luồng HTTP thật cho các endpoint).
- [x] **Giai đoạn 13 — Daily/Weekly Challenge**: dùng lại NGUYÊN lõi match-3
      của Giai đoạn 12 (`EnemyDef` — interface chung cho `StoryLevelDef` và
      `ChallengeDef` — để `BattleSession`/`BattleService` không cần biết
      trận đấu tới từ đâu). Mỗi loại (Daily/Weekly) MVP chỉ có ĐÚNG 1 con
      trùm cố định (`ChallengeCatalog`), TODO xoay vòng nội dung thật sau.
      - Cooldown tính từ LẦN THẮNG gần nhất (không reset theo mốc lịch/tuần
        thật — đơn giản hoá cho MVP): Daily 24h, Weekly 7 ngày
        (`challenge_attempts`, `ChallengeAttemptDao`). Thắng mới tính là
        hoàn thành — thua không bị tính cooldown, được thử lại ngay.
      - `POST /api/battle/challenge/start` {userId, type} — 429 nếu còn
        trong thời gian chờ (kèm số ms còn lại).
      - `GET /api/battle/challenge/status?userId=&type=` — còn làm được
        không, còn bao lâu nếu chưa.
      - `swap`/`ultimate`/`state` dùng chung y hệt endpoint của Story
        (không tách riêng — cùng `battleId`).
      Test: `ChallengeFlowTest` (luồng HTTP thật: mặc định làm được ngay,
      chặn loại thử thách sai, chặn làm lại khi còn cooldown, làm lại được
      khi cooldown đã hết).
- [x] **Giai đoạn 14 — Dungeon (nhiều tầng)**: dùng lại lõi match-3 lần thứ
      3 (`EnemyDef`). Khác Story/Challenge (1 địch/trận), Dungeon là 1 trận
      NHIỀU tầng đấu liên tiếp trong CÙNG 1 `battleId` — thắng 1 tầng không
      kết thúc trận, tự động sinh bàn cờ mới và chuyển sang địch tầng kế
      (`BattleSession#advanceFloor`). Máu người chơi/hiệu ứng buff/debuff
      KHÔNG hồi lại giữa các tầng (khó dần); mana/combo/số lượt reset về 0
      mỗi tầng mới. Thưởng (exp/vàng) chỉ phát khi qua tầng CUỐI — bỏ giữa
      chừng (thua) không mất gì thêm ngoài lượt chơi.
      - `DungeonCatalog` (tĩnh, MVP 2 dungeon x 3 tầng).
      - `POST /api/battle/dungeon/start` {userId, dungeonId},
        `GET /api/battle/dungeon/list`.
      - `swap`/`ultimate`/`state` dùng CHUNG endpoint với Story/Challenge.
        Response `BattleStateView` thêm `floorIndex`/`totalFloors` (chỉ có
        giá trị khi mode DUNGEON) và `floorCleared` (true đúng 1 lần ở
        swap/ultimate vừa hạ gục tầng hiện tại, còn tầng sau nên KHÔNG
        chuyển sang WON).
      Test: `DungeonFlowTest` (qua `BattleService` trực tiếp — dò nước đi
      khớp thật để đẩy trận qua nhiều tầng, kiểm tầng mới hồi đầy máu địch
      MỚI chứ không cộng dồn máu tầng cũ, mana/combo reset về 0, thắng đủ
      tầng cuối mới phát thưởng); `DungeonHttpFlowTest` (nối dây HTTP).
- [x] **Giai đoạn 15 — Tower**: tách interface `FloorSource` (Dungeon lẫn
      Tower cùng implement) khỏi `DungeonDef` để `BattleSession` dùng lại
      NGUYÊN cơ chế nhiều tầng của Giai đoạn 14 mà không cần biết tầng tới
      từ đâu. Khác Dungeon (danh sách tầng cố định): `TowerDef` sinh địch
      theo CÔNG THỨC tuyến tính (`enemyHp = start + step * floorIndex`,
      tương tự `enemyCounterDamage`) — mạnh dần vô hạn về mặt thiết kế
      nhưng có mốc `maxFloors` (MVP đơn giản hoá, chưa phải "leo mãi thật" —
      TODO leaderboard theo tầng cao nhất khi có hệ leaderboard).
      - KHÁC Dungeon: MỖI tầng qua đều phát thưởng NGAY
        (`rewardExpPerFloor`/`rewardGoldPerFloor` cố định mỗi tầng), không
        đợi tới tầng cuối — hợp lý vì không đảm bảo người chơi lên được tới
        đỉnh. `BattleService` gộp chung logic này (`grantFloorReward`) dùng
        được cho cả Dungeon (tầng giữa thưởng 0/0 nên no-op) lẫn Tower.
      - `POST /api/battle/tower/start` {userId, towerId},
        `GET /api/battle/tower/list`. `swap`/`ultimate`/`state` dùng CHUNG
        endpoint với Story/Challenge/Dungeon.
      Test: `TowerFlowTest` (qua `BattleService` trực tiếp — tầng đầu đúng
      chỉ số gốc, tầng 2 chỉ số tăng đúng công thức, mana reset khi sang
      tầng); `TowerHttpFlowTest` (nối dây HTTP).

## Chạy thử

```
cd server
mvn compile
mvn test
mvn -Dserver.port=8080 exec:java
# hoặc: mvn package && java -jar target/game-server-0.1.0-SNAPSHOT.jar
```
