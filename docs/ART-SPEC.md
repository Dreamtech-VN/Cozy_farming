# Spec art — để ảnh sinh ra lắp thẳng vào game

Tài liệu này dành cho người sinh ảnh (Midjourney / Nano Banana / Stable
Diffusion...). Làm đúng spec thì `npm run import-art` đóng gói được ngay, không
phải sửa tay từng file.

Hướng art: **2D chibi tô mềm**, không phải pixel art. Nét đặc trưng:

- Góc 3/4 cho nhà cửa: thấy mặt trước, một phần hông lùi về sau, và mái phủ lên cả hai.
- Viền tối mảnh quanh dáng vật thể — không có viền thì vật chìm vào nền trời.
- Chuyển màu mềm, có mặt hứng sáng (trên–trái) và mặt khuất (dưới–phải).
- Màu tươi, độ bão hoà cao nhưng không chói.
- Chân vật thể có túm cỏ / vệt đất để "dính" xuống mặt đất.

## Quy tắc chung cho MỌI file

| | |
| --- | --- |
| Định dạng | PNG, **nền trong suốt** (alpha thật, không phải nền trắng) |
| Bố cục | Một vật một file. Không ghép nhiều vật vào một ảnh |
| Neo | Chân vật **chạm đúng cạnh dưới** ảnh, vật **căn giữa** theo chiều ngang |
| Lề | Không chừa lề thừa hai bên; cắt sát dáng vật |
| Bóng đổ | **Không vẽ bóng đổ xuống đất** — game tự vẽ, vẽ sẵn sẽ bị chồng hai lớp |

Nền trắng thay vì trong suốt là lỗi hay gặp nhất. Nếu model không xuất được alpha
thì sinh trên nền **màu lục chói đồng nhất** (`#00ff00`) rồi tách nền; báo tôi
biết để script tách hộ.

## 1. Cảnh vật (nhà, sạp, cây, đá...)

- Kích thước: **512×512**, vật cao khoảng 380–500px trong khung đó.
- Đặt vào `art-src/props/<tên>.png`. Tên phải nằm trong danh sách dưới.

Danh sách cần có (tên file = tên trong game):

```
tree_big  tree_small  bush  rock  flowers
fence  crate  barrel  well  sign
house  stall  lamp  haystack  stump
soil  fountain  arcade  board  chest
grass_tall  leaf_branch  reed  log  mushroom
```

Prompt mẫu cho `house`:

> 2D game asset, cozy farm village house, chibi cartoon style, 3/4 front view
> showing front facade and one receding side wall, pitched red roof, cream
> plaster walls, wooden door with panels, window with white mullions, small
> shop sign above the door, grass tufts at the base, soft painted shading,
> light from upper left, thin dark outline around the silhouette, saturated
> cheerful palette, transparent background, centered, object sitting on the
> bottom edge of the frame, no cast shadow on the ground, no text

Đổi phần mô tả vật thể, **giữ nguyên phần từ "soft painted shading" trở đi** —
đó là phần giữ cho cả bộ art cùng một style.

## 2. Cây trồng

- Kích thước: **256×256** mỗi giai đoạn.
- Mỗi cây **4 giai đoạn**: mới gieo → mầm → lớn → chín.
- Đặt vào `art-src/crops/<crop_id>/0.png` … `3.png`.
- `crop_id` lấy đúng trong `data/content/crops.json` (12 cây: `crop_carrot`,
  `crop_turnip`, `crop_potato`, `crop_tomato`, `crop_corn`, `crop_strawberry`,
  `crop_wheat`, `crop_pumpkin`, `crop_sunflower`, `crop_blueberry`,
  `crop_watermelon`, `crop_moon_lotus`).
- Bốn giai đoạn phải **cùng góc nhìn, cùng cỡ, cùng nguồn sáng** — chỉ khác độ lớn.

## 3. Mặt đất (tile)

- Kích thước: **128×128**, và phải **ghép liền được**: mép trái nối được với mép
  phải của chính nó, mép trên nối với mép dưới.
- Không có hoa văn chạm mép, không có vật thể nổi bật (nhìn ra ngay chỗ lặp).
- Đặt vào `art-src/tiles/<tên>.png`:

```
grass_top_a  grass_top_b  grass_top_c   (mặt cỏ, 3 biến thể để đỡ lặp)
dirt_a  dirt_b                          (đất, phần dưới mặt cắt)
stone_a  stone_b
water_a  water_b
```

## 4. Nhân vật — đọc kỹ phần này

Đây là chỗ khó nhất và là chỗ **thiết kế phải đổi**.

Hệ hiện tại là *paperdoll*: thân quy định 6 khung, mỗi món đồ có sprite riêng cho
đúng 6 khung đó rồi xếp chồng theo `zOrder`. Cách đó chỉ chạy khi mọi món đồ vẽ
khớp chính xác cùng một bộ khớp xương.

**Model sinh ảnh không làm được việc đó.** Sinh 6 khung đã khó giữ nhất quán;
bắt cái áo khớp đúng từng khung của cái thân sinh riêng thì gần như chắc chắn
lệch. Cố ép sẽ ra nhân vật có tay áo trôi khỏi cánh tay.

Nên nhân vật chuyển sang **bộ trang phục dựng sẵn**: mỗi bộ là một nhân vật hoàn
chỉnh đã mặc đồ, không tháo rời. Người chơi đổi đồ = đổi bộ. Đây là cách nhiều
game 2D làm, và là cách duy nhất chạy được với ảnh sinh bằng model.

- Kích thước: **1 file mỗi bộ**, dải ngang **6 khung**, mỗi khung **256×384**
  → ảnh **1536×384**.
- Thứ tự khung: `0,1` đứng yên (thở), `2,3,4,5` chu kỳ đi.
- Nhân vật **quay sang phải** ở mọi khung; game tự lật khi đi sang trái.
- Chân chạm đúng cạnh dưới mỗi khung, người căn giữa khung.
- Đặt vào `art-src/chars/<tên bộ>.png`.

Prompt mẫu:

> 2D game character sprite sheet, chibi farm girl, side view facing right,
> 6 frames in a horizontal row, frames 1-2 idle breathing, frames 3-6 walk
> cycle, straw hat, pink dress, brown boots, big head small body chibi
> proportions, soft painted shading, light from upper left, thin dark outline,
> consistent character design across all frames, same size and position in
> every frame, transparent background, feet touching bottom edge of each frame,
> no cast shadow, no text

Thực tế model hay ra 6 khung lệch nhau. Cách chữa: sinh **một khung đứng** trước,
ưng rồi mới dùng nó làm ảnh tham chiếu (img2img / character reference) để sinh 5
khung còn lại. Sinh thẳng cả dải một lần rất hiếm khi khớp.

Nếu chỉ có 1 khung đứng: vẫn dùng được, game sẽ đứng yên không có chu kỳ đi.
Cứ gửi, tôi lắp rồi bổ sung khung sau.

## 5. Giao diện

Bộ Cozy UI Pack đã mua đang dùng cho HUD, không cần sinh thêm.

## Đã có gì rồi

**760 vật** đã nhập, chia hai trang atlas. Xem `docs/art-index.html` để biết
tên nào là vật nào (`npm run art-index` sinh lại).

| Trang | Tấm | Vật | Nặng |
| --- | --- | --- | --- |
| `outdoor` | `city`, `village` | 213 | 7,2 MB |
| `indoor` | `home`, `kitchen`, `retail`, `civic`, `decor` | 547 | 15,5 MB |
| `chars` | `hero`, `npc` | 104 | 2,0 MB |

Cả ba trang tải hết ở màn chờ trước khi vào game (tổng 24,7 MB), có thanh tiến
độ chạy theo số byte thật. Thêm art là thêm vào con số này — cân nhắc trước khi
sinh thêm tấm mới.

Đồ nội thất **chưa dùng được**: game chỉ có map ngoài trời, chưa có map trong
nhà nào. Cần thêm loại map nội thất, cửa dẫn vào, và hệ đặt đồ.

Còn thiếu, xếp theo mức ảnh hưởng:

| Cần | Vì sao gấp |
| --- | --- |
| **Nhân vật** | Đang là art sinh bằng code, đứng cạnh cảnh vật vẽ tay thì lệch hẳn — đây là chỗ chỏi mắt nhất hiện giờ |
| **Tile mặt đất** | Cỏ và đất chiếm nhiều diện tích màn hình nhất, cũng vẫn là art sinh bằng code |
| **Cây trồng** | 12 cây × 4 giai đoạn, là thứ người chơi nhìn lâu nhất trong game nông trại |

Cả ba phần này đều KHÔNG bày chung một tấm được như cảnh vật: nhân vật cần đúng
số khung, tile cần ghép liền được, cây trồng cần đủ bộ 4 giai đoạn cùng góc nhìn.
Xem mục 2, 3 và 4.

## Gửi file thế nào

Đẩy vào repo theo đúng cây thư mục trên:

```
art-src/
  props/   house.png  tree_big.png  ...
  crops/   crop_carrot/0.png 1.png 2.png 3.png
  tiles/   grass_top_a.png  ...
  chars/   farm_girl.png  farm_boy.png  ...
```

Không cần đủ hết mới gửi. Có file nào tôi lắp file đó, phần còn thiếu vẫn dùng
art cũ cho tới khi có ảnh thay thế.

**Gửi cả tấm gộp cũng được** — không cần tự cắt. Bày các vật rời nhau trên một
nền phẳng một màu, cách nhau ít nhất 20px, rồi để nguyên một file. `npm run
import-art` tự tách nền, cắt từng vật và đóng vào atlas; tôi chỉ phải đặt tên
trong `<tấm>.names.json`, trong đó `page` quyết định vật nằm ở trang atlas nào.

Hai điều kiện để bộ tách chạy đúng:
- Nền **phẳng một màu**, không hoa văn, không đổ bóng ra nền.
- Các vật **không chạm nhau**. Chạm là dính thành một vật.
