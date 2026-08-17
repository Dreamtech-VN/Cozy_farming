"use strict";

const CROP_EMOJI = { wheat: "🌾", corn: "🌽", carrot: "🥕", lettuce: "🥬", potato: "🥔", grass: "🌿", bamboo: "🎍", berry: "🍓" };
const SPECIES_EMOJI = { rabbit: "🐰", sheep: "🐑", monkey: "🐵", giraffe: "🦒", elephant: "🐘", panda: "🐼" };
const HABITAT_COLOR = { meadow: "#a5d6a7", forest: "#81c784", grove: "#c5e1a5" };

const canvas = document.getElementById("game");
const ctx = canvas.getContext("2d");
const panelEl = document.getElementById("panel");
const toastEl = document.getElementById("toast");

const state = {
  token: localStorage.getItem("myzoo_token"),
  me: null,
  catalog: null,
  farm: null,
  zoo: null,
  screen: "farm",
  minigame: null,
};

// ---------- Sprite atlas ----------
const sprites = { img: new Image(), atlas: null, ready: false, urls: {}, patterns: {} };

async function loadSprites() {
  try {
    const atlas = await (await fetch("assets/sprites.json")).json();
    await new Promise((ok, err) => {
      sprites.img.onload = ok;
      sprites.img.onerror = err;
      sprites.img.src = "assets/sprites.png";
    });
    sprites.atlas = atlas;
    sprites.ready = true;
    document.querySelector("#hud .gold").firstChild.replaceWith(iconNode("icon_coin", 16));
    document.querySelector("#hud .gem").firstChild.replaceWith(iconNode("icon_gem", 16));
  } catch (e) { /* chạy tiếp bằng emoji */ }
}

function drawSprite(name, x, y, scale) {
  if (!sprites.ready || !sprites.atlas[name]) return false;
  const a = sprites.atlas[name];
  ctx.imageSmoothingEnabled = false;
  ctx.drawImage(sprites.img, a.x, a.y, a.w, a.h, x, y, a.w * scale, a.h * scale);
  return true;
}

function drawSpriteRect(name, x, y, w, h) {
  if (!sprites.ready || !sprites.atlas[name]) return false;
  const a = sprites.atlas[name];
  ctx.imageSmoothingEnabled = false;
  ctx.drawImage(sprites.img, a.x, a.y, a.w, a.h, x, y, w, h);
  return true;
}

function spriteUrl(name) {
  if (!sprites.ready || !sprites.atlas[name]) return null;
  if (sprites.urls[name]) return sprites.urls[name];
  const a = sprites.atlas[name];
  const c = document.createElement("canvas");
  c.width = a.w; c.height = a.h;
  c.getContext("2d").drawImage(sprites.img, a.x, a.y, a.w, a.h, 0, 0, a.w, a.h);
  return (sprites.urls[name] = c.toDataURL());
}

function iconHtml(name, px, fallback) {
  const url = spriteUrl(name);
  if (!url) return fallback || "";
  return `<img src="${url}" style="width:${px}px;height:${px}px;image-rendering:pixelated;vertical-align:middle" alt="">`;
}

function iconNode(name, px) {
  const span = document.createElement("span");
  span.innerHTML = iconHtml(name, px);
  return span.firstChild || document.createTextNode("");
}

function cropIcon(id, px) { return iconHtml("crop_" + id, px || 22, CROP_EMOJI[id]); }
function animalIcon(id, px) { return iconHtml("animal_" + id, px || 26, SPECIES_EMOJI[id]); }

function groundPattern(tile) {
  if (!sprites.ready) return null;
  if (sprites.patterns[tile]) return sprites.patterns[tile];
  const a = sprites.atlas[tile];
  const c = document.createElement("canvas");
  const s = 3;
  c.width = a.w * s; c.height = a.h * s;
  const cc = c.getContext("2d");
  cc.imageSmoothingEnabled = false;
  cc.drawImage(sprites.img, a.x, a.y, a.w, a.h, 0, 0, a.w * s, a.h * s);
  return (sprites.patterns[tile] = ctx.createPattern(c, "repeat"));
}

// ---------- Khung ----------
function fitStage() {
  const stage = document.getElementById("stage");
  const scale = Math.min(window.innerWidth / 960, window.innerHeight / 540);
  stage.style.transform = `translate(-50%, -50%) scale(${scale})`;
}
window.addEventListener("resize", fitStage);
fitStage();

function toast(msg) {
  toastEl.textContent = msg;
  toastEl.classList.add("show");
  clearTimeout(toastEl._t);
  toastEl._t = setTimeout(() => toastEl.classList.remove("show"), 2500);
}

async function api(method, path, body) {
  const headers = { "Content-Type": "application/json" };
  if (state.token) headers["X-Guest-Token"] = state.token;
  if (method === "POST") body = Object.assign({ requestId: crypto.randomUUID() }, body || {});
  const res = await fetch(path, { method, headers, body: body ? JSON.stringify(body) : undefined });
  const data = await res.json().catch(() => ({}));
  if (!res.ok) throw new Error(data.error || ("Lỗi " + res.status));
  return data;
}

async function refreshMe() { state.me = await api("GET", "/v1/me"); updateHud(); }
async function refreshFarm() { state.farm = await api("GET", "/v1/farm"); }
async function refreshZoo() { state.zoo = await api("GET", "/v1/zoo"); }

function updateHud() {
  const me = state.me;
  if (!me) return;
  document.getElementById("hud-name").textContent = me.name || "Khách #" + me.playerId;
  document.getElementById("hud-vang").textContent = me.wallets.VANG.toLocaleString("vi");
  document.getElementById("hud-kc").textContent = me.wallets.KC.toLocaleString("vi");
  document.getElementById("hud-farm-lv").textContent = me.farmLevel;
  document.getElementById("hud-zoo-lv").textContent = me.zooLevel;
}

function panel(html, x, y, w) {
  panelEl.innerHTML = `<div class="panel" style="left:${x}px; top:${y}px; width:${w}px">
    <button class="close" onclick="closePanel()">✖</button>${html}</div>`;
}
function closePanel() { panelEl.innerHTML = ""; }
window.closePanel = closePanel;

// ---------- Farm ----------
const FARM_GRID = { x: 210, y: 78, cols: 8, rows: 6, cw: 92, ch: 74 };

function plotAt(mx, my) {
  const g = FARM_GRID;
  const col = Math.floor((mx - g.x) / g.cw), row = Math.floor((my - g.y) / g.ch);
  if (col < 0 || col >= g.cols || row < 0 || row >= g.rows) return -1;
  return row * g.cols + col;
}

async function clickFarm(mx, my) {
  const idx = plotAt(mx, my);
  if (idx < 0 || !state.farm) return;
  const plot = state.farm.plots[idx];
  if (plot.state === "EMPTY") {
    openCropPicker(idx);
  } else if (plot.state === "READY") {
    try {
      const r = await api("POST", "/v1/farm/harvest", { plotIndex: idx });
      toast(`Thu hoạch ${r.yield} ${CROP_EMOJI[r.cropId]} (+${r.xp} XP)`);
      await Promise.all([refreshFarm(), refreshMe()]);
    } catch (e) { toast(e.message); }
  } else {
    const left = Math.max(0, Math.ceil((plot.readyAt - Date.now()) / 1000));
    toast(`${CROP_EMOJI[plot.cropId]} còn ${fmtTime(left)} nữa chín`);
  }
}

function openCropPicker(idx) {
  const rows = state.catalog.crops.map(c =>
    `<div class="row">${cropIcon(c.id)} <b>${c.name}</b>
     <span style="margin-left:auto">🪙${c.seedCost} · ${fmtTime(c.growthSeconds)}</span>
     <button onclick="plant(${idx}, '${c.id}')">Trồng</button></div>`).join("");
  panel(`<h3>Chọn cây trồng — ô ${idx + 1}</h3>${rows}`, 300, 60, 340);
}

window.plant = async function (idx, cropId) {
  closePanel();
  try {
    await api("POST", "/v1/farm/plant", { plotIndex: idx, cropId });
    await Promise.all([refreshFarm(), refreshMe()]);
  } catch (e) { toast(e.message); }
};

function drawGround(color, tile) {
  const pat = groundPattern(tile);
  ctx.fillStyle = pat || color;
  ctx.fillRect(0, 280, 960, 260);
}

function drawFarm() {
  drawSky("#bde3ff");
  drawGround("#8bc34a", "tile_grass");
  if (!drawSprite("char_farmer", 55, 300, 6)) drawChibi(95, 330, "#66bb6a", "👒");

  ctx.font = "15px sans-serif";
  ctx.fillStyle = "#1d3311";
  ctx.fillText("Kho nông sản:", 30, 470);
  const storage = state.farm ? state.farm.storage : {};
  const keys = Object.keys(storage);
  if (!keys.length) ctx.fillText("(trống)", 140, 470);
  let sx = 30;
  for (const k of keys) {
    if (drawSprite("crop_" + k, sx, 478, 2)) {
      ctx.fillText("×" + storage[k], sx + 34, 500);
    } else {
      ctx.font = "20px sans-serif";
      ctx.fillText(`${CROP_EMOJI[k]}×${storage[k]}`, sx, 500);
      ctx.font = "15px sans-serif";
    }
    sx += 78;
  }

  const g = FARM_GRID;
  for (let i = 0; i < 48; i++) {
    const col = i % g.cols, row = Math.floor(i / g.cols);
    const x = g.x + col * g.cw, y = g.y + row * g.ch;
    if (!drawSpriteRect("tile_soil", x + 3, y + 3, g.cw - 6, g.ch - 6)) {
      ctx.fillStyle = "#8d6e63";
      roundRect(x + 3, y + 3, g.cw - 6, g.ch - 6, 10);
      ctx.fillStyle = "#a1887f";
      roundRect(x + 7, y + 7, g.cw - 14, g.ch - 14, 8);
    }
    const plot = state.farm && state.farm.plots[i];
    if (!plot || plot.state === "EMPTY") continue;
    const cx = x + g.cw / 2, cy = y + g.ch / 2;
    ctx.textAlign = "center";
    if (plot.state === "READY") {
      if (!drawSprite("crop_" + plot.cropId, cx - 24, cy - 27, 3)) {
        ctx.font = "30px sans-serif";
        ctx.fillText(CROP_EMOJI[plot.cropId], cx, cy + 10);
      }
      ctx.font = "11px sans-serif";
      ctx.fillStyle = "#fff59d";
      ctx.fillText("✨ Thu hoạch!", cx, y + g.ch - 6);
    } else {
      const total = plot.readyAt - plot.plantedAt;
      const done = Math.min(1, (Date.now() - plot.plantedAt) / total);
      const stage = done < 0.5 ? "sprout" : "plant_mid";
      if (!drawSprite(stage, cx - 24, cy - 28, 3)) {
        ctx.font = done > 0.5 ? "22px sans-serif" : "16px sans-serif";
        ctx.fillText("🌱", cx, cy + 6);
      }
      ctx.fillStyle = "#33691e";
      ctx.fillRect(x + 12, y + g.ch - 13, (g.cw - 24) * done, 6);
      ctx.strokeStyle = "#1b5e20";
      ctx.strokeRect(x + 12, y + g.ch - 13, g.cw - 24, 6);
    }
    ctx.textAlign = "left";
  }
}

// ---------- Zoo ----------
const ZOO_CARDS = { x: 226, y: 84, cols: 3, cw: 236, ch: 130, gap: 10 };

function habitatCardAt(mx, my) {
  if (!state.zoo) return null;
  const z = ZOO_CARDS;
  for (let i = 0; i < state.zoo.habitats.length; i++) {
    const col = i % z.cols, row = Math.floor(i / z.cols);
    const x = z.x + col * (z.cw + z.gap), y = z.y + row * (z.ch + z.gap);
    if (mx >= x && mx <= x + z.cw && my >= y && my <= y + z.ch) return state.zoo.habitats[i];
  }
  return null;
}

function drawZoo() {
  drawSky("#ffe9c9");
  drawGround("#aed581", "tile_grass");
  if (!drawSprite("char_keeper", 55, 300, 6)) drawChibi(95, 330, "#4fc3f7", "🧢");
  const zoo = state.zoo;
  if (!zoo) return;

  ctx.font = "15px sans-serif";
  ctx.fillStyle = "#1d3311";
  ctx.fillText(zoo.isOpen ? "🟢 Zoo ĐANG MỞ" : "🔴 Zoo đóng cửa", 30, 452);
  ctx.fillText(`Độ hấp dẫn: ${zoo.totalAppeal} · No: ${Math.round(zoo.foodCoverage * 100)}%`, 30, 474);
  ctx.fillText(`Chờ thu: 🪙${zoo.pendingVang}`, 30, 496);

  const z = ZOO_CARDS;
  zoo.habitats.forEach((h, i) => {
    const col = i % z.cols, row = Math.floor(i / z.cols);
    const x = z.x + col * (z.cw + z.gap), y = z.y + row * (z.ch + z.gap);
    ctx.fillStyle = HABITAT_COLOR[h.typeId] || "#a5d6a7";
    roundRect(x, y, z.cw, z.ch, 14);
    ctx.strokeStyle = "#6d4c41";
    ctx.lineWidth = 3;
    strokeRoundRect(x, y, z.cw, z.ch, 14);
    for (let f = 0; f < 4; f++) drawSprite("tile_fence", x + 24 + f * 48, y + z.ch - 30, 1.6);
    ctx.fillStyle = "#33422a";
    ctx.font = "bold 14px sans-serif";
    ctx.fillText(`${h.name} (${h.animals.length}/${h.capacity})`, x + 10, y + 20);
    h.animals.forEach((a, j) => {
      const ax = x + 14 + j * 66, ay = y + 30;
      if (!drawSprite("animal_" + a.speciesId, ax, ay, 3)) {
        ctx.font = "34px sans-serif";
        ctx.fillText(SPECIES_EMOJI[a.speciesId], ax, ay + 40);
      }
      if (!drawSprite(a.fed ? "icon_heart" : "icon_hungry", ax + 34, ay - 8, 1)) {
        ctx.font = "14px sans-serif";
        ctx.fillText(a.fed ? "😋" : "🍽️❗", ax + 6, ay + 62);
      }
    });
  });

  const shopY = ZOO_CARDS.y + 2 * (z.ch + z.gap);
  ctx.fillStyle = "#33422a";
  ctx.font = "14px sans-serif";
  const entries = Object.entries(zoo.warehouse);
  ctx.fillText("Kho Zoo:", z.x, shopY + 26);
  if (!entries.length) ctx.fillText("(trống)", z.x + 70, shopY + 26);
  let wx = z.x + 76;
  for (const [k, v] of entries) {
    if (drawSprite("crop_" + k, wx, shopY + 8, 1.6)) {
      ctx.fillText("×" + v, wx + 28, shopY + 26);
    } else {
      ctx.fillText(`${CROP_EMOJI[k]}×${v}`, wx, shopY + 26);
    }
    wx += 66;
  }
}

function openZooMenu() {
  const zoo = state.zoo;
  const habitatRows = state.catalog.habitatTypes.map(t =>
    `<div class="row">🏡 <b>${t.name}</b><span style="margin-left:auto">🪙${t.cost} · ${t.capacity} chỗ</span>
     <button onclick="buyHabitat('${t.id}')">Xây</button></div>`).join("");
  const openBtn = zoo.isOpen
    ? `<button class="warn" onclick="zooToggle('close')">Đóng cửa & thu 🪙${zoo.pendingVang}</button>
       <button onclick="zooToggle('collect')">Thu tiền 🪙${zoo.pendingVang}</button>`
    : `<button onclick="zooToggle('open')">Mở cửa đón khách</button>`;
  const deliverRows = Object.entries(state.farm.storage).map(([k, v]) =>
    `<div class="row">${cropIcon(k)}×${v}<button style="margin-left:auto" onclick="deliver('${k}', ${v})">Chuyển hết sang Zoo</button></div>`).join("")
    || "<div class='row'>(Kho nông sản trống — trồng trọt rồi quay lại)</div>";
  panel(`<h3>Quản lý sở thú</h3><div class="row">${openBtn}</div>
    <h3 style="margin-top:8px">Xây chuồng</h3>${habitatRows}
    <h3 style="margin-top:8px">Chuyển thức ăn</h3>${deliverRows}`, 300, 56, 380);
}

function openHabitatPanel(h) {
  const speciesRows = state.catalog.species.map(s =>
    `<div class="row">${animalIcon(s.id)} <b>${s.name}</b> <small>[${s.rarity}] hấp dẫn ${s.appeal}, ăn ${s.diet.map(d => cropIcon(d, 16)).join("")}</small>
     <span style="margin-left:auto">🪙${s.cost}</span>
     <button onclick="buyAnimal(${h.id}, '${s.id}')">Mua</button></div>`).join("");
  panel(`<h3>${h.name} (${h.animals.length}/${h.capacity})</h3>
    <div class="row"><button onclick="feed(${h.id})">🍽️ Cho cả chuồng ăn</button></div>
    <h3 style="margin-top:8px">Mua thú</h3>${speciesRows}`, 280, 56, 420);
}

function act(fn, doneMsg) {
  return async function (...args) {
    closePanel();
    try {
      const r = await fn(...args);
      if (doneMsg) toast(doneMsg(r));
      await Promise.all([refreshFarm(), refreshZoo(), refreshMe()]);
    } catch (e) {
      toast(e.message);
      await Promise.all([refreshFarm(), refreshZoo(), refreshMe()]).catch(() => {});
    }
  };
}

window.buyHabitat = act(typeId => api("POST", "/v1/zoo/habitats", { typeId }));
window.buyAnimal = act((habitatId, speciesId) => api("POST", "/v1/zoo/animals", { habitatId, speciesId }));
window.deliver = act((foodId, quantity) => api("POST", "/v1/zoo/deliver", { foodId, quantity }));
window.feed = act(habitatId => api("POST", "/v1/zoo/feed", { habitatId }),
  r => `Đã cho ${r.animalsFed} con ăn 😋`);
window.zooToggle = act(action => api("POST", "/v1/zoo/" + action, {}),
  r => r && r.vangEarned !== undefined ? `Thu được 🪙${r.vangEarned} (+${r.zooXp} XP)` : "Zoo đã mở cửa 🎉");

// ---------- Minigame (match-3) ----------
const M3 = {
  size: 6,
  fruits: ["🍎", "🍇", "🍊", "🍋", "🫐"],
  spriteNames: ["fruit_apple", "fruit_grape", "fruit_orange", "fruit_lemon", "fruit_blueberry"],
};

function fruitHtml(v) { return iconHtml(M3.spriteNames[v], 34, M3.fruits[v]); }

function mulberry32(a) {
  return function () {
    a |= 0; a = a + 0x6D2B79F5 | 0;
    let t = Math.imul(a ^ a >>> 15, 1 | a);
    t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t;
    return ((t ^ t >>> 14) >>> 0) / 4294967296;
  };
}

async function openMinigame() {
  try {
    const s = await api("POST", "/v1/minigames/session", {});
    const rng = mulberry32(Number(BigInt.asUintN(32, BigInt(s.seed))));
    const board = [];
    for (let i = 0; i < M3.size * M3.size; i++) board.push(Math.floor(rng() * M3.fruits.length));
    state.minigame = { session: s, rng, board, moves: s.movesAllowed, lines: 0, sel: -1 };
    renderMinigame();
  } catch (e) { toast(e.message); }
}

function renderMinigame() {
  const m = state.minigame;
  const cells = m.board.map((v, i) =>
    `<div class="m3-cell ${m.sel === i ? "sel" : ""}" onclick="m3Click(${i})">${fruitHtml(v)}</div>`).join("");
  panel(`<h3>Ghép trái cây 🍎 — còn ${m.moves} lượt · ${m.lines} hàng (🪙${m.session.vangPerLine}/hàng)</h3>
    <div id="m3-board">${cells}</div>
    <div class="row"><button onclick="m3Finish()">Kết thúc & nhận thưởng</button></div>`, 330, 46, 320);
}

window.m3Click = function (i) {
  const m = state.minigame;
  if (!m || m.moves <= 0) return;
  if (m.sel < 0) { m.sel = i; return renderMinigame(); }
  const a = m.sel, b = i;
  m.sel = -1;
  const adjacent = (Math.abs(a - b) === 1 && Math.floor(a / M3.size) === Math.floor(b / M3.size))
      || Math.abs(a - b) === M3.size;
  if (!adjacent) return renderMinigame();
  [m.board[a], m.board[b]] = [m.board[b], m.board[a]];
  m.moves--;
  let made = resolveMatches(m);
  if (!made) [m.board[a], m.board[b]] = [m.board[b], m.board[a]];
  renderMinigame();
};

function resolveMatches(m) {
  let totalLines = 0;
  for (let pass = 0; pass < 10; pass++) {
    const kill = new Set();
    let lines = 0;
    for (let r = 0; r < M3.size; r++) {
      for (let c = 0; c < M3.size - 2; c++) {
        const i = r * M3.size + c;
        if (m.board[i] === m.board[i + 1] && m.board[i] === m.board[i + 2]) {
          lines++; let cc = c;
          while (cc < M3.size && m.board[r * M3.size + cc] === m.board[i]) { kill.add(r * M3.size + cc); cc++; }
          c = cc;
        }
      }
    }
    for (let c = 0; c < M3.size; c++) {
      for (let r = 0; r < M3.size - 2; r++) {
        const i = r * M3.size + c;
        if (m.board[i] === m.board[i + M3.size] && m.board[i] === m.board[i + 2 * M3.size]) {
          lines++; let rr = r;
          while (rr < M3.size && m.board[rr * M3.size + c] === m.board[i]) { kill.add(rr * M3.size + c); rr++; }
          r = rr;
        }
      }
    }
    if (!lines) break;
    totalLines += lines;
    for (let c = 0; c < M3.size; c++) {
      const col = [];
      for (let r = M3.size - 1; r >= 0; r--) {
        const i = r * M3.size + c;
        if (!kill.has(i)) col.push(m.board[i]);
      }
      while (col.length < M3.size) col.push(Math.floor(m.rng() * M3.fruits.length));
      for (let r = M3.size - 1, k = 0; r >= 0; r--, k++) m.board[r * M3.size + c] = col[k];
    }
  }
  m.lines += totalLines;
  return totalLines;
}

window.m3Finish = async function () {
  const m = state.minigame;
  if (!m) return;
  closePanel();
  state.minigame = null;
  try {
    const r = await api("POST", "/v1/minigames/finish", { sessionId: m.session.sessionId, linesMade: m.lines });
    toast(`Nhận 🪙${r.vangReward} cho ${r.linesCounted} hàng!`);
    await refreshMe();
  } catch (e) { toast(e.message); }
};

// ---------- Vẽ nền & fallback ----------
function roundRect(x, y, w, h, r) {
  ctx.beginPath();
  ctx.roundRect(x, y, w, h, r);
  ctx.fill();
}
function strokeRoundRect(x, y, w, h, r) {
  ctx.beginPath();
  ctx.roundRect(x, y, w, h, r);
  ctx.stroke();
}

function drawSky(sky) {
  const grd = ctx.createLinearGradient(0, 0, 0, 300);
  grd.addColorStop(0, sky);
  grd.addColorStop(1, "#fffde7");
  ctx.fillStyle = grd;
  ctx.fillRect(0, 0, 960, 300);
  ctx.font = "36px sans-serif";
  ctx.fillText("☁️", 700, 70);
  ctx.fillText("☀️", 880, 60);
}

function drawChibi(x, y, shirt, hatEmoji) {
  ctx.fillStyle = shirt;
  roundRect(x - 22, y + 30, 44, 46, 14);
  ctx.fillStyle = "#ffe0b2";
  ctx.beginPath();
  ctx.arc(x, y, 34, 0, Math.PI * 2);
  ctx.fill();
  ctx.fillStyle = "#3e2723";
  ctx.beginPath(); ctx.arc(x - 12, y - 2, 4, 0, Math.PI * 2); ctx.fill();
  ctx.beginPath(); ctx.arc(x + 12, y - 2, 4, 0, Math.PI * 2); ctx.fill();
  ctx.strokeStyle = "#3e2723";
  ctx.lineWidth = 2.5;
  ctx.beginPath(); ctx.arc(x, y + 8, 10, 0.15 * Math.PI, 0.85 * Math.PI); ctx.stroke();
  ctx.fillStyle = "#ef9a9a";
  ctx.beginPath(); ctx.arc(x - 20, y + 8, 5, 0, Math.PI * 2); ctx.fill();
  ctx.beginPath(); ctx.arc(x + 20, y + 8, 5, 0, Math.PI * 2); ctx.fill();
  ctx.font = "30px sans-serif";
  ctx.textAlign = "center";
  ctx.fillText(hatEmoji, x, y - 36);
  ctx.textAlign = "left";
}

function fmtTime(sec) {
  if (sec >= 3600) return Math.floor(sec / 3600) + "h" + Math.floor((sec % 3600) / 60) + "p";
  if (sec >= 60) return Math.floor(sec / 60) + "p" + (sec % 60) + "s";
  return sec + "s";
}

// ---------- Input & vòng lặp ----------
canvas.addEventListener("click", e => {
  const rect = canvas.getBoundingClientRect();
  const mx = (e.clientX - rect.left) * (960 / rect.width);
  const my = (e.clientY - rect.top) * (540 / rect.height);
  if (state.screen === "farm") clickFarm(mx, my);
  else if (state.screen === "zoo") {
    const h = habitatCardAt(mx, my);
    if (h) openHabitatPanel(h);
    else openZooMenu();
  }
});

function setScreen(s) {
  state.screen = s;
  closePanel();
  document.getElementById("tab-farm").classList.toggle("active", s === "farm");
  document.getElementById("tab-zoo").classList.toggle("active", s === "zoo");
}
document.getElementById("tab-farm").onclick = () => setScreen("farm");
document.getElementById("tab-zoo").onclick = () => setScreen("zoo");
document.getElementById("tab-game").onclick = () => openMinigame();

function loop() {
  ctx.clearRect(0, 0, 960, 540);
  if (state.screen === "farm") drawFarm();
  else drawZoo();
  requestAnimationFrame(loop);
}

async function boot() {
  const spritesLoading = loadSprites();
  const login = await api("POST", "/v1/auth/guest", { guestToken: state.token });
  state.token = login.guestToken;
  localStorage.setItem("myzoo_token", state.token);
  state.catalog = await api("GET", "/v1/catalog");
  await Promise.all([refreshMe(), refreshFarm(), refreshZoo(), spritesLoading]);
  if (!state.me.name) {
    const name = prompt("Đặt tên nông trại của bạn (2-20 ký tự):", "");
    if (name && name.trim().length >= 2) {
      try {
        state.me = await api("POST", "/v1/players/name", { name: name.trim() });
        updateHud();
      } catch (e) { toast(e.message); }
    }
  }
  setInterval(() => { refreshFarm().catch(() => {}); refreshZoo().catch(() => {}); refreshMe().catch(() => {}); }, 10000);
  loop();
}

boot().catch(e => toast("Không kết nối được máy chủ: " + e.message));
