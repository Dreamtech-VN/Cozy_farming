using System;
using System.Collections.Generic;

namespace MyZoo
{
    // Tên field phải trùng JSON server trả về. JsonUtility bỏ qua field lạ nên thừa không sao, thiếu thì mất dữ liệu.

    [Serializable] public class ApiError { public string error; }

    [Serializable]
    public class LoginResult
    {
        public int playerId;
        public string guestToken;
        public string sessionToken;
        public bool isNew;
        public string name;
        public string serverId;
        public bool needsCharacter;
    }

    [Serializable] public class Wallets { public long VANG; public long KC; }

    [Serializable]
    public class Profile
    {
        public int playerId;
        public string name;
        public string avatar;
        public string serverId;
        public bool hasAccount;
        public int farmXp, farmLevel, zooXp, zooLevel;
        public Wallets wallets;
    }

    [Serializable]
    public class ServerInfo
    {
        public string id, name, region, status, population;
        public bool recommended;
    }
    [Serializable] public class ServerList { public List<ServerInfo> servers; }

    [Serializable]
    public class GameConfigDto
    {
        public string gameVersion, minClientVersion, maintenanceMessage;
        public bool maintenance;
        public long serverTime;
    }

    [Serializable]
    public class CropDef
    {
        public string id, name;
        public long seedCost, sellPrice;
        public int growthSeconds, yieldMin, yieldMax, xp, minFarmLevel;
    }
    [Serializable]
    public class SpeciesDef
    {
        public string id, name, rarity;
        public long cost;
        public List<string> diet;
        public int appeal, minZooLevel;
    }
    [Serializable]
    public class HabitatTypeDef
    {
        public string id, name;
        public long cost;
        public int capacity, minZooLevel;
    }
    [Serializable] public class ProductDef { public string id, name; public long sellPrice; }
    [Serializable] public class DecorDef { public string id, name; public long cost; public int appealBonus, minZooLevel; }
    [Serializable]
    public class RecipeDef
    {
        public string id, name, inputFoodId, outputFoodId;
        public int inputQty, outputQty, seconds, minFarmLevel;
    }
    [Serializable] public class GameDef { public string id, name; public int movesAllowed, maxScore; public long vangPerScore; }

    [Serializable]
    public class Catalog
    {
        public List<CropDef> crops;
        public List<SpeciesDef> species;
        public List<HabitatTypeDef> habitatTypes;
        public List<ProductDef> products;
        public List<DecorDef> decors;
        public List<RecipeDef> recipes;
        public List<GameDef> games;
        public int plotCount;
    }

    [Serializable] public class ItemStack { public string foodId; public int quantity; }

    [Serializable]
    public class Plot
    {
        public int plotIndex;
        public string state;      // EMPTY | GROWING | READY
        public string cropId;
        public long plantedAt, readyAt;
    }
    [Serializable]
    public class FarmView
    {
        public List<Plot> plots;
        public List<ItemStack> storage;
    }
    [Serializable] public class PlantResult { public int plotIndex; public string cropId; public long readyAt, vangBalance; }
    [Serializable] public class HarvestResult { public int plotIndex; public string cropId; public int yield, xp; }
    [Serializable] public class SellResult { public string foodId; public int quantity; public long vangEarned, vangBalance; }

    [Serializable]
    public class Animal
    {
        public int id, habitatId, appeal;
        public string speciesId, name, rarity;
        public bool fed;
    }
    [Serializable] public class DecorView { public string decorId, name; public int appealBonus; }
    [Serializable]
    public class Habitat
    {
        public int id, capacity, decorAppeal;
        public string typeId, name;
        public List<Animal> animals;
        public List<DecorView> decors;
    }
    [Serializable]
    public class ZooView
    {
        public List<Habitat> habitats;
        public List<ItemStack> warehouse;
        public bool isOpen;
        public double foodCoverage;
        public int totalAppeal;
        public long pendingVang;
    }
    [Serializable] public class BuyResult { public int id; public long vangBalance; }
    [Serializable] public class DeliverResult { public string foodId; public int quantity; public List<ItemStack> farmStorage, warehouse; }
    [Serializable] public class FeedResult { public int habitatId, animalsFed; public List<ItemStack> warehouse; }
    [Serializable] public class CollectResult { public long vangEarned, vangBalance; public int zooXp; }

    [Serializable]
    public class Mission
    {
        public string id, name;
        public int target, progress;
        public long rewardVang;
        public bool claimed;
    }
    [Serializable] public class MissionList { public List<Mission> missions; }
    [Serializable] public class ClaimResult { public string missionId; public long rewardVang, vangBalance; }
    [Serializable] public class CheckinResult { public string day; public int streak; public long rewardVang, vangBalance; }

    [Serializable]
    public class MinigameSession
    {
        public string sessionId, gameType;
        public long seed, vangPerScore;
        public int movesAllowed, maxScore;
    }
    [Serializable]
    public class MinigameResult
    {
        public string sessionId, gameType;
        public int scoreCounted;
        public long vangReward, vangBalance;
        public bool newlyFinished;
    }

    [Serializable]
    public class Snapshot
    {
        public Profile me;
        public FarmView farm;
        public ZooView zoo;
        public List<Mission> missions;
    }

    [Serializable]
    public class FriendView
    {
        public int playerId, farmLevel, zooLevel, zooAppeal;
        public string name, avatar;
    }
    [Serializable]
    public class FriendsView
    {
        public List<FriendView> friends, incoming, outgoing;
        public int helpsLeftToday;
    }
    [Serializable]
    public class VisitView
    {
        public int playerId, farmLevel, zooLevel, totalAppeal;
        public string name, avatar;
        public List<Plot> plots;
        public List<Habitat> habitats;
        public bool isOpen, canHelp;
    }
    [Serializable] public class HelpResult { public int friendId, helpsLeftToday; public long vangEarned, vangBalance; }

    [Serializable]
    public class RankRow
    {
        public int rank, playerId, zooLevel, farmLevel, score;
        public string name;
    }
    [Serializable] public class Leaderboard { public List<RankRow> rows; }

    [Serializable]
    public class MailView
    {
        public long id, rewardVang, rewardKc, createdAt, expiresAt;
        public string title, body, rewardFoodId;
        public int rewardFoodQty;
        public bool claimed;
    }
    [Serializable] public class MailList { public List<MailView> mails; }
    [Serializable]
    public class MailClaimResult
    {
        public long mailId, rewardVang, rewardKc, vangBalance, kcBalance;
        public string rewardFoodId;
        public int rewardFoodQty;
    }
    [Serializable] public class ClaimAllResult { public int claimed; }
    [Serializable] public class RedeemResult { public string code, message; public long mailId; }

    [Serializable]
    public class Achievement
    {
        public string id, name;
        public int target, progress;
        public long rewardVang;
        public bool claimed;
    }
    [Serializable] public class AchievementList { public List<Achievement> achievements; }
    [Serializable] public class AchievementClaimResult { public string achievementId; public long rewardVang, vangBalance; }

    [Serializable]
    public class SpeciesEntry
    {
        public string speciesId, name, rarity;
        public int appeal;
        public bool owned;
        public long firstOwnedAt;
    }
    [Serializable] public class CollectionList { public List<SpeciesEntry> species; }

    [Serializable]
    public class ShopItem
    {
        public string id, name, description, currency, type, param;
        public long price;
        public int value;
    }
    [Serializable] public class KcPack { public string id, name; public long kcAmount, priceVnd; }
    [Serializable] public class ShopCatalogDto { public List<ShopItem> items; public List<KcPack> kcPacks; }

    [Serializable]
    public class InventoryEntry
    {
        public string itemId, name, description, type;
        public int quantity;
    }
    [Serializable] public class InventoryList { public List<InventoryEntry> items; }
    [Serializable]
    public class PurchaseResult
    {
        public string itemId, currency;
        public int quantity;
        public long spent, vangBalance, kcBalance;
        public List<InventoryEntry> inventory;
    }
    [Serializable]
    public class UseItemResult
    {
        public string itemId, effect;
        public int remaining;
        public List<ItemStack> farmStorage;
        public List<InventoryEntry> inventory;
    }
    [Serializable] public class TopupResult { public string packId; public long kcAdded, kcBalance; }

    [Serializable]
    public class ProcessingSlot
    {
        public long id, startedAt, readyAt;
        public string recipeId, name, outputFoodId;
        public int outputQty;
        public bool ready;
    }
    [Serializable]
    public class ProcessingView
    {
        public List<ProcessingSlot> slots;
        public int maxSlots;
        public List<ItemStack> storage;
    }
    [Serializable] public class ProcessStartResult { public long slotId, readyAt; public string recipeId; public List<ItemStack> storage; }
    [Serializable] public class ProcessCollectResult { public long slotId; public string outputFoodId; public int quantity; public List<ItemStack> storage; }

    [Serializable]
    public class ChatMessage
    {
        public long id, createdAt;
        public string channel, senderName, type, text, refId;
        public int senderId;
        public int targetId;
        public bool deleted;
    }
    [Serializable] public class ChatBan { public bool banned; public long until; public string reason; }
    [Serializable] public class ChatFeed { public List<ChatMessage> messages; public ChatBan ban; }
    [Serializable]
    public class ChatSendResult
    {
        public long id, createdAt;
        public string channel, type, text, refId, notice;
    }
    [Serializable] public class StickerDef { public string id, name; }
    [Serializable]
    public class ChatCatalogDto
    {
        public List<StickerDef> stickers, gifs;
        public int maxTextLength;
    }
    [Serializable] public class ChatRelations { public List<int> muted, blocked; }
    [Serializable] public class VoiceMeta { public string voiceId; public int durationMs, bytes; }

    [Serializable]
    public class LedgerEntry
    {
        public long id, amount, balanceAfter, createdAt;
        public string currency, reason, refType, refId;
    }
    [Serializable]
    public class WalletView
    {
        public long vang, kc, nextCursor;
        public List<LedgerEntry> entries;
    }

    [Serializable] public class OkResult { public bool ok; }

    public static class Items
    {
        public static int Qty(List<ItemStack> stacks, string foodId)
        {
            if (stacks == null) return 0;
            foreach (var s in stacks) if (s.foodId == foodId) return s.quantity;
            return 0;
        }

        public static void Set(List<ItemStack> stacks, string foodId, int quantity)
        {
            if (stacks == null) return;
            foreach (var s in stacks)
            {
                if (s.foodId != foodId) continue;
                s.quantity = quantity;
                return;
            }
            if (quantity > 0) stacks.Add(new ItemStack { foodId = foodId, quantity = quantity });
        }
    }
}
