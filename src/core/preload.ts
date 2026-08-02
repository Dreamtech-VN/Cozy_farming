// ===== Tải hết tài nguyên ngay ở màn chờ =====
// Trước đây ảnh DOM (emoji, khung chat, skin, icon...) đợi mở bảng nào mới tải
// bảng đó nên hay thấy ảnh nhảy vào sau. Giờ màn chờ kéo sạch danh sách trong
// preload-manifest.json (sinh bằng scripts/make_preload_manifest.py) rồi mới
// cho vào game — vào rồi là chạy mượt, không chờ lắt nhắt nữa.
import MANIFEST from '@/data/preload-manifest.json';

const FILES = MANIFEST as unknown as [string, number][];
const CONCURRENCY = 8;

export const preloadTotalBytes = FILES.reduce((s, f) => s + f[1], 0);

export interface PreloadProgress {
  done: number;      // số file đã xong
  total: number;     // tổng số file
  bytes: number;     // số byte đã tải (tính theo bảng, không theo mạng)
  totalBytes: number;
}

/** Kéo hết tài nguyên về cache trình duyệt. Lỗi một file thì bỏ qua file đó,
 *  không chặn cả màn chờ (mạng chập chờn vẫn vào được game). */
export async function preloadAll(
  onProgress?: (p: PreloadProgress) => void,
  signal?: AbortSignal
): Promise<void> {
  // đường dẫn để tương đối như Phaser đang dùng -> tự khớp base của bản build
  let done = 0, bytes = 0, next = 0;

  const worker = async () => {
    for (;;) {
      const i = next++;
      if (i >= FILES.length || signal?.aborted) return;
      const [path, size] = FILES[i];
      try {
        // chỉ cần trình duyệt lưu vào cache, không dùng tới nội dung
        await fetch(path, { cache: 'force-cache' }).then(r => r.arrayBuffer());
      } catch {
        // thiếu một ảnh lẻ thì thôi, lát game tự tải lại lúc cần
      }
      done++; bytes += size;
      onProgress?.({ done, total: FILES.length, bytes, totalBytes: preloadTotalBytes });
    }
  };

  await Promise.all(Array.from({ length: CONCURRENCY }, worker));
}

export function mb(bytes: number): string {
  return (bytes / 1024 / 1024).toFixed(1);
}
