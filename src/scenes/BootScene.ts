import Phaser from 'phaser';

// Màn hình đầu tiên: phát video intro studio Dreamtech thật (public/assets/video/
// studio_intro.mp4), đồng thời tải trước ảnh nền màn hình chính ở dưới nền.
// Bấm vào video là bỏ qua luôn.
export class BootScene extends Phaser.Scene {
  private ready = false;
  private videoDone = false;

  constructor() { super('Boot'); }

  preload() {
    // key art Dreamtech Studio: đã có sẵn badge 12+, cảnh báo sức khỏe, bản quyền
    this.load.image('title_bg', 'assets/ui/title_bg.jpg');
    this.load.on('complete', () => { this.ready = true; this.tryNext(); });
  }

  create() {
    this.cameras.main.setBackgroundColor(0x07050f);

    const video = document.getElementById('intro-video') as HTMLVideoElement | null;
    if (!video) { this.videoDone = true; this.tryNext(); return; }

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
