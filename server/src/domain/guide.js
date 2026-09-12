/**
 * Chỉ dẫn nhiệm vụ: đổi một mục tiêu thành một CHỖ ĐỂ ĐI TỚI.
 *
 * Bảng nhiệm vụ nói "nói chuyện với bác Tư", nhưng người mới không biết bác Tư
 * đứng map nào, mà map nào cũng phải bắt xe buýt mới sang được. Thiếu chỉ dẫn
 * thì bước đầu tiên của game đã là một câu đố về địa lý.
 *
 * Giải ở SERVER chứ không ở client: client chỉ giữ map nó đã đi qua, còn server
 * có sẵn toàn bộ map, NPC, vật thể và mạng lưới cửa ngõ. Bắt client tải hết mọi
 * map chỉ để vẽ một mũi tên là đổi lấy vài trăm KB cho một việc nhỏ.
 *
 * Trả về HAI mốc khác nhau, và đây là chỗ dễ nhầm: `target` là đích cuối (bác Tư
 * ở làng), `step` là thứ phải đi tới NGAY BÂY GIỜ trên map đang đứng (trạm xe
 * buýt ở quảng trường). Vẽ mũi tên theo `target` thì nó chỉ xuyên qua tường về
 * phía một map khác, người chơi đi theo là đâm vào mép map.
 */

/**
 * Chỗ NPC đang đứng, theo pha trong ngày.
 *
 * NPC có lịch sinh hoạt nên toạ độ trong data chỉ là chỗ mặc định. Mũi tên chỉ
 * dẫn phải hỏi đúng câu hỏi này, không thì nó chỉ vào chỗ NPC đứng lúc bình
 * minh trong khi người ta đã đi chợ từ lâu.
 *
 * Luật đơn giản đến mức client chép lại một dòng cũng không thành trùng lặp
 * logic: tra bảng theo pha, không có thì về mặc định.
 */
export const npcXAt = (npc, phase) => npc.schedule?.[phase] ?? npc.x;

/** Map của nhiệm vụ nông trại: map nào có luống cây thì là nông trại người chơi. */
const farmMap = (content) => content.maps.find((m) => m.farm_layout);

/** Nơi bấm vào để chơi match-3. */
const match3Spot = (content) => {
  for (const map of content.maps) {
    const object = (map.objects ?? []).find((o) => o.action === 'open_match3');
    if (object) return { map, x: object.x };
  }
  return null;
};

/** Mục tiêu này bảo người chơi đi đâu? `null` nghĩa là không gắn với chỗ nào. */
function placeOf(content, objective, phase) {
  switch (objective.type) {
    case 'talk_npc': {
      for (const map of content.maps) {
        const npc = map.npcs.find((n) => n.npc_id === objective.target);
        if (npc) return { map, x: npcXAt(npc, phase), label_key: npc.name_key };
      }
      return null;
    }
    case 'visit_map': {
      const map = content.byMap.get(objective.target);
      return map ? { map, x: null, label_key: map.name_key } : null;
    }
    case 'harvest':
    case 'collect': {
      const map = farmMap(content);
      return map ? { map, x: null, label_key: map.name_key } : null;
    }
    case 'match3_win': {
      const spot = match3Spot(content);
      return spot ? { map: spot.map, x: spot.x, label_key: spot.map.name_key } : null;
    }
    // `reach_level` không có chỗ nào để đi: cứ chơi là lên. Chỉ đường tới một
    // điểm bất kỳ cho đủ lệ bộ còn tệ hơn không chỉ gì.
    default: return null;
  }
}

/**
 * Cửa ngõ đầu tiên trên đường ngắn nhất từ `fromId` tới `toId`.
 *
 * Duyệt theo bề rộng nên ra đúng đường ít lần đổi map nhất. Mạng chỉ có năm map
 * nên không cần gì hơn; điều đáng giữ là nó đọc THẲNG từ `portals` trong data,
 * thêm map mới là chỉ dẫn tự đúng theo, không phải khai lại đường đi ở đâu cả.
 */
function firstHop(content, fromId, toId) {
  if (fromId === toId) return null;
  const seen = new Set([fromId]);
  // Mỗi phần tử nhớ luôn cửa ngõ ĐẦU TIÊN đã đi, để tới đích là trả về được ngay.
  const queue = (content.byMap.get(fromId)?.portals ?? []).map((p) => ({ mapId: p.target_map_id, first: p }));
  for (const item of queue) seen.add(item.mapId);
  for (let i = 0; i < queue.length; i++) {
    const { mapId, first } = queue[i];
    if (mapId === toId) return first;
    for (const portal of content.byMap.get(mapId)?.portals ?? []) {
      if (seen.has(portal.target_map_id)) continue;
      seen.add(portal.target_map_id);
      queue.push({ mapId: portal.target_map_id, first });
    }
  }
  return null;
}

/** Mục tiêu chưa xong đầu tiên của nhiệm vụ đáng làm nhất. */
function nextObjective(quests) {
  // Cốt truyện trước, rồi tới ngày/tuần, rồi phụ: cùng lúc nhận nhiều nhiệm vụ
  // thì chỉ dẫn phải chọn MỘT, và cốt truyện là thứ dẫn người mới đi tiếp.
  const rank = { main: 0, daily: 1, weekly: 2, side: 3 };
  const doable = quests
    .filter((q) => q.state === 'active')
    .sort((a, b) => (rank[a.type] ?? 9) - (rank[b.type] ?? 9));
  for (const quest of doable) {
    const objective = quest.objectives.find((o) => o.current < o.count);
    if (objective) return { quest, objective };
  }
  return null;
}

/**
 * @param fromMapId map người chơi đang đứng.
 * @param phase pha trong ngày — NPC có lịch sinh hoạt nên chỗ đứng đổi theo giờ.
 * @returns null khi không có gì để chỉ — client hiểu là ẩn mũi tên đi.
 */
export function guideFor(content, quests, fromMapId, phase = 'day') {
  const next = nextObjective(quests);
  if (!next) return null;
  const place = placeOf(content, next.objective, phase);
  if (!place) return null;

  const sameMap = place.map.map_id === fromMapId;
  const hop = sameMap ? null : firstHop(content, fromMapId, place.map.map_id);
  // Đích ở map khác mà không có đường nối nào thì thà không chỉ còn hơn chỉ bừa.
  if (!sameMap && !hop) return null;

  return {
    quest_id: next.quest.quest_id,
    name_key: next.quest.name_key,
    objective: { type: next.objective.type, target: next.objective.target ?? null },
    target: { map_id: place.map.map_id, name_key: place.map.name_key, label_key: place.label_key },
    step: sameMap
      // `x: null` là "cứ ở map này là được" (thu hoạch, ghé map): không có điểm
      // nào để chỉ, client chỉ hiện chữ chứ không vẽ mũi tên.
      ? { same_map: true, x: place.x, portal_id: null }
      : { same_map: false, x: hop.x, portal_id: hop.portal_id },
  };
}
