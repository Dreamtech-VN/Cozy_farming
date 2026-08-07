package vn.dreamtech.game.server.event;

import vn.dreamtech.game.server.dao.EventBoardDao;
import vn.dreamtech.game.server.item.ItemException;

import java.sql.SQLException;
import java.util.List;

public final class EventBoardService {
    private final EventBoardDao eventBoardDao;

    public EventBoardService(EventBoardDao eventBoardDao) {
        this.eventBoardDao = eventBoardDao;
    }

    public EventBoardDao.EventEntry create(String title, String description, long startAt, long endAt) {
        if (title == null || title.isBlank()) {
            throw new ItemException(400, "Thiếu title");
        }
        if (endAt <= startAt) {
            throw new ItemException(400, "endAt phải sau startAt");
        }
        try {
            return eventBoardDao.create(title, description, startAt, endAt);
        } catch (SQLException e) {
            throw new ItemException(500, "Lỗi tạo sự kiện: " + e.getMessage());
        }
    }

    public EventBoardDao.EventEntry update(int id, String title, String description, long startAt, long endAt, boolean active) {
        if (endAt <= startAt) {
            throw new ItemException(400, "endAt phải sau startAt");
        }
        try {
            eventBoardDao.find(id).orElseThrow(() -> new ItemException(404, "Không tìm thấy sự kiện"));
            eventBoardDao.update(id, title, description, startAt, endAt, active);
            return eventBoardDao.find(id).orElseThrow();
        } catch (SQLException e) {
            throw new ItemException(500, "Lỗi cập nhật sự kiện: " + e.getMessage());
        }
    }

    public void delete(int id) {
        try {
            eventBoardDao.find(id).orElseThrow(() -> new ItemException(404, "Không tìm thấy sự kiện"));
            eventBoardDao.delete(id);
        } catch (SQLException e) {
            throw new ItemException(500, "Lỗi xoá sự kiện: " + e.getMessage());
        }
    }

    public List<EventBoardDao.EventEntry> board() {
        try {
            return eventBoardDao.findActive(System.currentTimeMillis());
        } catch (SQLException e) {
            throw new ItemException(500, "Lỗi lấy bảng sự kiện: " + e.getMessage());
        }
    }

    public List<EventBoardDao.EventEntry> listAll() {
        try {
            return eventBoardDao.findAll();
        } catch (SQLException e) {
            throw new ItemException(500, "Lỗi lấy danh sách sự kiện: " + e.getMessage());
        }
    }
}
