package vn.dreamtech.game.server.guild.boss;

public record GuildBossReportView(int damageApplied, int remainingHp, boolean poolDepleted, int rewardExp, int rewardGold) {
}
