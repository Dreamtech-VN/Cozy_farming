package vn.dreamtech.myzoo.server.time;

// Mọi service dùng chung 1 nguồn thời gian để test giả lập được thời gian trôi (trồng trọt, doanh thu...).
@FunctionalInterface
public interface TimeSource {
    long now();

    static TimeSource system() {
        return System::currentTimeMillis;
    }
}
