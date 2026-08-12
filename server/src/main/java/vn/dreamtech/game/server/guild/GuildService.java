package vn.dreamtech.game.server.guild;

import vn.dreamtech.game.server.dao.CharacterDao;
import vn.dreamtech.game.server.dao.GuildDao;
import vn.dreamtech.game.server.dao.GuildMemberDao;
import vn.dreamtech.game.server.dao.WalletDao;
import vn.dreamtech.game.server.model.Guild;
import vn.dreamtech.game.server.model.GuildMembership;
import vn.dreamtech.game.server.model.GuildRole;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

import static vn.dreamtech.game.server.guild.GuildConstants.*;

/**
 * Quy tắc guild: 1 user chỉ ở 1 guild tại 1 thời điểm; tạo guild tốn
 * {@value GuildConstants#CREATE_COST_GOLD} vàng (trừ NGAY, không hoàn nếu
 * sau đó rời/giải tán — cùng triết lý "không hoàn tiền" đã dùng ở nhẫn cầu
 * hôn); leader rời guild khi còn thành viên khác phải chuyển quyền trước
 * (tránh guild mất chủ); giải tán chỉ leader làm được.
 */
public final class GuildService {
    private final GuildDao guildDao;
    private final GuildMemberDao guildMemberDao;
    private final CharacterDao characterDao;
    private final WalletDao walletDao;

    public GuildService(GuildDao guildDao, GuildMemberDao guildMemberDao, CharacterDao characterDao, WalletDao walletDao) {
        this.guildDao = guildDao;
        this.guildMemberDao = guildMemberDao;
        this.characterDao = characterDao;
        this.walletDao = walletDao;
    }

    public Guild create(int userId, String name, String tag, String description) {
        String trimmedName = name == null ? "" : name.trim();
        String trimmedTag = tag == null ? "" : tag.trim().toUpperCase();
        if (trimmedName.length() < MIN_NAME_LEN || trimmedName.length() > MAX_NAME_LEN) {
            throw new GuildException(400, "Tên guild phải từ " + MIN_NAME_LEN + "-" + MAX_NAME_LEN + " ký tự");
        }
        if (trimmedTag.length() < MIN_TAG_LEN || trimmedTag.length() > MAX_TAG_LEN) {
            throw new GuildException(400, "Tag guild phải từ " + MIN_TAG_LEN + "-" + MAX_TAG_LEN + " ký tự");
        }
        try {
            if (characterDao.findByUserId(userId).isEmpty()) {
                throw new GuildException(404, "Chưa tạo nhân vật");
            }
            if (guildMemberDao.findByUserId(userId).isPresent()) {
                throw new GuildException(409, "Đã ở trong 1 guild rồi, phải rời trước");
            }
            if (guildDao.nameTaken(trimmedName)) {
                throw new GuildException(409, "Tên guild đã có người dùng");
            }
            if (guildDao.tagTaken(trimmedTag)) {
                throw new GuildException(409, "Tag guild đã có người dùng");
            }
            if (!walletDao.spendGold(userId, CREATE_COST_GOLD)) {
                throw new GuildException(402, "Không đủ vàng để tạo guild (cần " + CREATE_COST_GOLD + ")");
            }
            Guild guild = guildDao.create(trimmedName, trimmedTag, description, userId);
            guildMemberDao.join(userId, guild.id(), GuildRole.LEADER);
            return guild;
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi tạo guild: " + e.getMessage());
        }
    }

    public GuildMembership join(int userId, int guildId) {
        try {
            if (characterDao.findByUserId(userId).isEmpty()) {
                throw new GuildException(404, "Chưa tạo nhân vật");
            }
            if (guildMemberDao.findByUserId(userId).isPresent()) {
                throw new GuildException(409, "Đã ở trong 1 guild rồi, phải rời trước");
            }
            Guild guild = guildDao.findById(guildId).orElseThrow(() -> new GuildException(404, "Không tìm thấy guild"));
            if (guildMemberDao.countMembers(guild.id()) >= MAX_MEMBERS) {
                throw new GuildException(409, "Guild đã đầy thành viên");
            }
            guildMemberDao.join(userId, guild.id(), GuildRole.MEMBER);
            return guildMemberDao.findByUserId(userId).orElseThrow();
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi vào guild: " + e.getMessage());
        }
    }

    public void leave(int userId) {
        try {
            GuildMembership membership = requireMembership(userId);
            if (membership.role() == GuildRole.LEADER) {
                int otherMembers = guildMemberDao.countMembers(membership.guildId()) - 1;
                if (otherMembers > 0) {
                    throw new GuildException(409, "Phải chuyển quyền hội trưởng cho người khác trước khi rời");
                }
                guildDao.delete(membership.guildId());
            }
            guildMemberDao.leave(userId);
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi rời guild: " + e.getMessage());
        }
    }

    public void kick(int actorUserId, int targetUserId) {
        try {
            GuildMembership actor = requireMembership(actorUserId);
            if (actor.role() == GuildRole.MEMBER) {
                throw new GuildException(403, "Chỉ hội trưởng/phó mới đuổi được thành viên");
            }
            GuildMembership target = guildMemberDao.findByUserId(targetUserId)
                    .orElseThrow(() -> new GuildException(404, "Người này không trong guild"));
            if (target.guildId() != actor.guildId()) {
                throw new GuildException(400, "Không cùng guild");
            }
            if (target.role() == GuildRole.LEADER) {
                throw new GuildException(403, "Không thể đuổi hội trưởng");
            }
            if (targetUserId == actorUserId) {
                throw new GuildException(400, "Không thể tự đuổi bản thân, dùng chức năng rời guild");
            }
            guildMemberDao.leave(targetUserId);
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi đuổi thành viên: " + e.getMessage());
        }
    }

    public void changeRole(int actorUserId, int targetUserId, GuildRole newRole) {
        if (newRole == GuildRole.LEADER) {
            throw new GuildException(400, "Dùng chức năng chuyển quyền hội trưởng để đặt LEADER");
        }
        try {
            GuildMembership actor = requireMembership(actorUserId);
            if (actor.role() != GuildRole.LEADER) {
                throw new GuildException(403, "Chỉ hội trưởng mới đổi được cấp bậc");
            }
            GuildMembership target = guildMemberDao.findByUserId(targetUserId)
                    .orElseThrow(() -> new GuildException(404, "Người này không trong guild"));
            if (target.guildId() != actor.guildId()) {
                throw new GuildException(400, "Không cùng guild");
            }
            if (target.role() == GuildRole.LEADER) {
                throw new GuildException(400, "Không thể đổi cấp bậc của chính hội trưởng");
            }
            guildMemberDao.updateRole(targetUserId, newRole);
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi đổi cấp bậc: " + e.getMessage());
        }
    }

    public void transferLeader(int actorUserId, int targetUserId) {
        try {
            GuildMembership actor = requireMembership(actorUserId);
            if (actor.role() != GuildRole.LEADER) {
                throw new GuildException(403, "Chỉ hội trưởng mới chuyển quyền được");
            }
            GuildMembership target = guildMemberDao.findByUserId(targetUserId)
                    .orElseThrow(() -> new GuildException(404, "Người này không trong guild"));
            if (target.guildId() != actor.guildId()) {
                throw new GuildException(400, "Không cùng guild");
            }
            if (targetUserId == actorUserId) {
                throw new GuildException(400, "Đã là hội trưởng rồi");
            }
            guildDao.updateLeader(actor.guildId(), targetUserId);
            guildMemberDao.updateRole(targetUserId, GuildRole.LEADER);
            guildMemberDao.updateRole(actorUserId, GuildRole.OFFICER);
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi chuyển quyền hội trưởng: " + e.getMessage());
        }
    }

    public void disband(int userId) {
        try {
            GuildMembership membership = requireMembership(userId);
            if (membership.role() != GuildRole.LEADER) {
                throw new GuildException(403, "Chỉ hội trưởng mới giải tán được guild");
            }
            guildMemberDao.leaveGuild(membership.guildId());
            guildDao.delete(membership.guildId());
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi giải tán guild: " + e.getMessage());
        }
    }

    /**
     * Admin giải tán BẤT KỲ guild nào — khác {@link #disband(int)} (chỉ
     * hội trưởng tự giải tán guild của mình), dùng cho kiểm duyệt (vd. tên
     * guild vi phạm) khi không có hội trưởng hợp tác.
     */
    public void adminDisband(int guildId) {
        try {
            guildDao.findById(guildId).orElseThrow(() -> new GuildException(404, "Không tìm thấy guild"));
            guildMemberDao.leaveGuild(guildId);
            guildDao.delete(guildId);
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi giải tán guild: " + e.getMessage());
        }
    }

    /**
     * Admin đuổi BẤT KỲ thành viên nào khỏi guild — khác {@link #kick(int, int)}
     * (chỉ hội trưởng/phó, không đuổi được hội trưởng), admin đuổi được cả
     * hội trưởng (guild mất chủ, còn thành viên khác thì vẫn tồn tại không
     * hội trưởng cho tới khi tự chuyển quyền — TODO tự động thăng cấp
     * officer cũ nhất lên hội trưởng nếu cần).
     */
    public void adminKick(int guildId, int targetUserId) {
        try {
            GuildMembership target = guildMemberDao.findByUserId(targetUserId)
                    .orElseThrow(() -> new GuildException(404, "Người này không trong guild nào"));
            if (target.guildId() != guildId) {
                throw new GuildException(400, "Người này không ở guild đó");
            }
            guildMemberDao.leave(targetUserId);
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi đuổi thành viên: " + e.getMessage());
        }
    }

    public void adminTransferLeader(int guildId, int targetUserId) {
        try {
            Guild guild = guildDao.findById(guildId).orElseThrow(() -> new GuildException(404, "Không tìm thấy guild"));
            GuildMembership target = guildMemberDao.findByUserId(targetUserId)
                    .orElseThrow(() -> new GuildException(404, "Người này không trong guild nào"));
            if (target.guildId() != guildId) {
                throw new GuildException(400, "Người này không ở guild đó");
            }
            if (guildMemberDao.findByUserId(guild.leaderUserId())
                    .filter(m -> m.guildId() == guildId).isPresent()) {
                guildMemberDao.updateRole(guild.leaderUserId(), GuildRole.OFFICER);
            }
            guildDao.updateLeader(guildId, targetUserId);
            guildMemberDao.updateRole(targetUserId, GuildRole.LEADER);
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi chuyển quyền hội trưởng: " + e.getMessage());
        }
    }

    public List<GuildSummaryView> list() {
        try {
            List<Guild> guilds = guildDao.listAll();
            return guilds.stream().map(g -> {
                try {
                    return new GuildSummaryView(g.id(), g.name(), g.tag(), g.description(), g.leaderUserId(),
                            guildMemberDao.countMembers(g.id()), MAX_MEMBERS);
                } catch (SQLException e) {
                    throw new GuildException(500, "Lỗi lấy danh sách guild: " + e.getMessage());
                }
            }).toList();
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi lấy danh sách guild: " + e.getMessage());
        }
    }

    public GuildInfoView info(int guildId) {
        try {
            Guild guild = guildDao.findById(guildId).orElseThrow(() -> new GuildException(404, "Không tìm thấy guild"));
            List<GuildMembership> members = guildMemberDao.listByGuild(guildId);
            return new GuildInfoView(guild.id(), guild.name(), guild.tag(), guild.description(), guild.leaderUserId(),
                    members.size(), MAX_MEMBERS, members);
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi lấy thông tin guild: " + e.getMessage());
        }
    }

    public Optional<GuildInfoView> myGuild(int userId) {
        try {
            Optional<GuildMembership> membership = guildMemberDao.findByUserId(userId);
            if (membership.isEmpty()) return Optional.empty();
            return Optional.of(info(membership.get().guildId()));
        } catch (SQLException e) {
            throw new GuildException(500, "Lỗi lấy guild của bạn: " + e.getMessage());
        }
    }

    private GuildMembership requireMembership(int userId) throws SQLException {
        return guildMemberDao.findByUserId(userId)
                .orElseThrow(() -> new GuildException(404, "Bạn chưa ở trong guild nào"));
    }
}
