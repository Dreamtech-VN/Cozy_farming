package vn.dreamtech.cozyfarming.server.fishpond;

/** Khớp {@code FryDef} client ({@code src/systems/fishfarm.ts}). */
public record FryDef(String id, String name, int price, int growMin, int qtyMin, int qtyMax, int exp) {
}
