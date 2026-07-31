// ===== Xe cộ =====
// Xe buýt công cộng (miễn phí) + xe riêng mua ở Garage.
// Sprite: public/assets/vehicles/*.png

export interface VehicleDef {
  id: string;
  name: string;
  price: number;           // xu
  rubyPrice?: number;
  w: number;               // kích thước file sprite (để vẽ icon DOM)
  h: number;
  desc: string;
}

export const VEHICLES: Record<string, VehicleDef> = {
  truck_orange: { id: 'truck_orange', name: 'Xe tải cam', price: 15000, w: 80, h: 50, desc: 'Chiếc xe đầu tiên chở bạn đi muôn nơi.' },
  camper_pink: { id: 'camper_pink', name: 'Camper dưa hấu', price: 30000, w: 80, h: 50, desc: 'Ngọt ngào như mùa hè.' },
  camper_yellow: { id: 'camper_yellow', name: 'Camper vàng', price: 30000, w: 80, h: 50, desc: 'Nắng vàng trên mọi nẻo đường.' },
  truck_bee: { id: 'truck_bee', name: 'Xe ong chăm chỉ', price: 0, rubyPrice: 30, w: 80, h: 53, desc: 'Vo ve~ xe hiếm phiên bản ong.' },
  camper_green: { id: 'camper_green', name: 'Camper cỏ non', price: 22000, w: 80, h: 50, desc: 'Xanh mát, hợp mấy chuyến về quê.' },
  truck_gift: { id: 'truck_gift', name: 'Xe quà Giáng Sinh', price: 0, rubyPrice: 40, w: 80, h: 56, desc: 'Chở đầy quà và niềm vui.' }
};

export const VEHICLE_LIST = Object.values(VEHICLES);
export const BUS_SPRITE = { w: 234, h: 194 };   // xe buýt gốc Avatar (repo Lttt)
