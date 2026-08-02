import Phaser from 'phaser';

// Màn hình đầu tiên: phát video intro studio Dreamtech thật (public/assets/video/
// studio_intro.mp4), đồng thời tải trước ảnh nền màn hình chính ở dưới nền.
// Bấm vào video là bỏ qua luôn.
//
// Chỉ phát intro 1 LẦN mỗi tab: đánh dấu vào sessionStorage ngay khi vào Boot.
// Lý do: trang bị load lại (F5, HMR lúc code đang chạy, mất mạng rồi tự nạp
// lại...) thì index.html chạy lại từ đầu -> intro phát lại dù người chơi đã
// xem xong lúc nãy. sessionStorage sống hết phiên tab (khác localStorage vốn
// ở lại vĩnh viễn) nên mở tab MỚI vẫn thấy intro như cũ, chỉ có tải lại trang
// trong CÙNG tab mới bị bỏ qua.
const SEEN_KEY = 'cozy_intro_seen';

export class BootScene extends Phaser.Scene {
  private ready = false;
  private videoDone = false;

  constructor() { super('Boot'); }

  preload() {
    // key art Dreamtech Studio: badge 12+ + dòng bản quyền AI vẽ sẵn trong ảnh
    // gốc đã được xoá (inpaint lại nền sạch) -> vẽ đè logo chữ + badge 12+
    // THẬT (asset gốc Lttt) + bản quyền thật lên trên ở buildTitleScreen()
    this.load.image('title_bg', 'assets/ui/title_bg.jpg');
    this.load.image('age12', 'assets/ui/age12.png');          // hd/12Plus.png gốc Lttt
    this.load.image('sunny_logo', 'assets/ui/logo/sunny_town_wordmark.png');
    this.load.on('complete', () => {
      // game bật pixelArt (lọc NEAREST toàn cục) cho sprite pixel-art, nhưng
      // 2 ảnh này là ảnh vector/HD nên phóng to theo NEAREST bị vỡ hạt/lởm
      // chởm -> ép riêng 2 texture này sang lọc mượt (LINEAR).
      this.textures.get('age12').setFilter(Phaser.Textures.FilterMode.LINEAR);
      this.textures.get('sunny_logo').setFilter(Phaser.Textures.FilterMode.LINEAR);
      this.ready = true; this.tryNext();
    });
  }

  create() {
    this.cameras.main.setBackgroundColor(0x07050f);

    const video = document.getElementById('intro-video') as HTMLVideoElement | null;
    let alreadySeen = false;
    try { alreadySeen = sessionStorage.getItem(SEEN_KEY) === '1'; } catch { /* ignore */ }
    if (!video || alreadySeen) {
      if (video) video.style.display = 'none';
      this.videoDone = true; this.tryNext(); return;
    }
    try { sessionStorage.setItem(SEEN_KEY, '1'); } catch { /* ignore */ }

    const finish = () => {
      if (this.videoDone) return;
      this.videoDone = true;
      video.style.display = 'none';
      video.removeEventListener('ended', finish);
      video.removeEventListener('click', finish);
      video.removeEventListener('error', finish);
      this.tryNext();
    };
    video.style.display = 'block';
    video.currentTime = 0;
    video.addEventListener('ended', finish);
    video.addEventListener('click', finish);   // bấm vào là bỏ qua
    video.addEventListener('error', finish);   // video lỗi/thiếu file -> đừng chặn game
    video.play().catch(finish);   // trình duyệt chặn autoplay -> bỏ qua luôn, đừng đứng hình

    // phòng khi video treo/không bắn 'ended' (thiết bị lạ) -> tự qua sau tối đa 12s
    this.time.delayedCall(12000, finish);
  }

  private tryNext() {
    if (!this.ready || !this.videoDone) return;
    this.scene.start('Preload');
  }
}
