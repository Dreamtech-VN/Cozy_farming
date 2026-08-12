using System;

public static class BattleEvents
{
    public static event Action<BattleStateView> StateUpdated;

    public static void RaiseStateUpdated(BattleStateView view) => StateUpdated?.Invoke(view);
}
