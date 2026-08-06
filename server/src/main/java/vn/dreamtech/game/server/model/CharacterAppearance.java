package vn.dreamtech.game.server.model;

/**
 * Các ô trang bị/tuỳ chỉnh sau khi đã tạo nhân vật — tách khỏi
 * {@link Character} (chỉ giữ tóc/áo/quần lúc tạo) theo nguyên tắc chỉ thêm
 * bảng mới, không sửa bảng cũ. Mọi id đều nullable — {@code null} nghĩa là
 * chưa trang bị gì ở ô đó (client tự vẽ mặc định).
 */
public record CharacterAppearance(
        int userId,
        Integer eyesId,
        Integer avatarId,
        Integer avatarFrameId,
        Integer titleId,
        Integer emoteId,
        Integer hatId,
        Integer shirtId,
        Integer pantsId,
        Integer shoesId,
        Integer petId,
        Integer skinId
) {
    public static CharacterAppearance defaultsFor(int userId) {
        return new CharacterAppearance(userId, null, null, null, null, null, null, null, null, null, null, null);
    }

    public CharacterAppearance withSlot(CosmeticType slot, Integer itemId) {
        return switch (slot) {
            case EYES -> new CharacterAppearance(userId, itemId, avatarId, avatarFrameId, titleId, emoteId, hatId, shirtId, pantsId, shoesId, petId, skinId);
            case AVATAR -> new CharacterAppearance(userId, eyesId, itemId, avatarFrameId, titleId, emoteId, hatId, shirtId, pantsId, shoesId, petId, skinId);
            case AVATAR_FRAME -> new CharacterAppearance(userId, eyesId, avatarId, itemId, titleId, emoteId, hatId, shirtId, pantsId, shoesId, petId, skinId);
            case TITLE -> new CharacterAppearance(userId, eyesId, avatarId, avatarFrameId, itemId, emoteId, hatId, shirtId, pantsId, shoesId, petId, skinId);
            case EMOTE -> new CharacterAppearance(userId, eyesId, avatarId, avatarFrameId, titleId, itemId, hatId, shirtId, pantsId, shoesId, petId, skinId);
            case HAT -> new CharacterAppearance(userId, eyesId, avatarId, avatarFrameId, titleId, emoteId, itemId, shirtId, pantsId, shoesId, petId, skinId);
            case SHIRT -> new CharacterAppearance(userId, eyesId, avatarId, avatarFrameId, titleId, emoteId, hatId, itemId, pantsId, shoesId, petId, skinId);
            case PANTS -> new CharacterAppearance(userId, eyesId, avatarId, avatarFrameId, titleId, emoteId, hatId, shirtId, itemId, shoesId, petId, skinId);
            case SHOES -> new CharacterAppearance(userId, eyesId, avatarId, avatarFrameId, titleId, emoteId, hatId, shirtId, pantsId, itemId, petId, skinId);
            case PET -> new CharacterAppearance(userId, eyesId, avatarId, avatarFrameId, titleId, emoteId, hatId, shirtId, pantsId, shoesId, itemId, skinId);
            case SKIN -> new CharacterAppearance(userId, eyesId, avatarId, avatarFrameId, titleId, emoteId, hatId, shirtId, pantsId, shoesId, petId, itemId);
        };
    }

    public Integer slotValue(CosmeticType slot) {
        return switch (slot) {
            case EYES -> eyesId;
            case AVATAR -> avatarId;
            case AVATAR_FRAME -> avatarFrameId;
            case TITLE -> titleId;
            case EMOTE -> emoteId;
            case HAT -> hatId;
            case SHIRT -> shirtId;
            case PANTS -> pantsId;
            case SHOES -> shoesId;
            case PET -> petId;
            case SKIN -> skinId;
        };
    }
}
