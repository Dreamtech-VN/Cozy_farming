using System;
using System.Collections.Generic;
using UnityEngine;

namespace MyZoo
{
    // Giữ dữ liệu đang chơi để các screen dùng chung, khỏi gọi API lại.
    public class App : MonoBehaviour
    {
        public static App I;

        public Catalog Catalog;
        public Profile Me;
        public FarmView Farm;
        public ZooView Zoo;
        public List<Mission> Missions = new List<Mission>();

        // Hud và các screen tự đăng ký để cập nhật khi state đổi (tránh phụ thuộc vòng).
        public event Action OnStateChanged;

        void Awake() { I = this; }

        public void Apply(Snapshot s)
        {
            if (s == null) return;
            Me = s.me;
            Farm = s.farm;
            Zoo = s.zoo;
            Missions = s.missions ?? new List<Mission>();
            Changed();
        }

        public void Changed()
        {
            if (OnStateChanged != null) OnStateChanged();
        }

        public void SetVang(long vang)
        {
            if (Me != null && Me.wallets != null) Me.wallets.VANG = vang;
            Changed();
        }

        public CropDef Crop(string id)
        {
            if (Catalog == null) return null;
            foreach (var c in Catalog.crops) if (c.id == id) return c;
            return null;
        }

        public string CropName(string id)
        {
            var crop = Crop(id);
            return crop != null ? crop.name : id;
        }

        public SpeciesDef Species(string id)
        {
            if (Catalog == null) return null;
            foreach (var s in Catalog.species) if (s.id == id) return s;
            return null;
        }

        public HabitatTypeDef HabitatType(string id)
        {
            if (Catalog == null) return null;
            foreach (var h in Catalog.habitatTypes) if (h.id == id) return h;
            return null;
        }

        // Chấm đỏ trên các nút ở sảnh — tính từ dữ liệu có sẵn, không cần API riêng.
        public bool HasReadyCrop()
        {
            if (Farm == null || Farm.plots == null) return false;
            foreach (var p in Farm.plots) if (p.state == "READY") return true;
            return false;
        }

        public bool ZooNeedsAttention()
        {
            if (Zoo == null) return false;
            if (Zoo.pendingVang > 0) return true;
            if (Zoo.habitats == null) return false;
            foreach (var h in Zoo.habitats)
                if (h.animals != null)
                    foreach (var a in h.animals) if (!a.fed) return true;
            return false;
        }

        public bool HasClaimableMission()
        {
            foreach (var m in Missions) if (m.progress >= m.target && !m.claimed) return true;
            return false;
        }
    }
}
