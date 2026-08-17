using System.Collections.Generic;
using UnityEngine;

namespace MyZoo
{
    // Nhắc việc trong game: tính từ dữ liệu đã tải sẵn, không cần endpoint riêng.
    // Thông báo ngoài game (khi đã thoát) cần gói com.unity.mobile.notifications — xem OsNotifications bên dưới.
    public static class Notifications
    {
        public struct Item
        {
            public string text;
            public string screen;   // màn hình mở khi bấm vào
        }

        public static List<Item> Pending()
        {
            var items = new List<Item>();
            var app = App.I;
            if (app == null) return items;

            if (app.HasReadyCrop()) items.Add(new Item { text = "Có cây đã chín, ra thu hoạch thôi", screen = "S10_Farm" });
            if (app.ZooNeedsAttention())
            {
                string reason = app.Zoo != null && app.Zoo.pendingVang > 0
                    ? "Sở thú có " + app.Zoo.pendingVang + " Vàng chờ thu"
                    : "Có thú đang đói trong sở thú";
                items.Add(new Item { text = reason, screen = "S20_Zoo" });
            }
            if (app.HasClaimableMission()) items.Add(new Item { text = "Nhiệm vụ đã xong, vào nhận thưởng", screen = "S30_Missions" });
            return items;
        }

        // Lần chín sớm nhất của cây và lần đói sớm nhất của thú — dùng để hẹn giờ thông báo hệ thống.
        public static long NextCropReadyAt()
        {
            long soonest = 0;
            var farm = App.I != null ? App.I.Farm : null;
            if (farm == null || farm.plots == null) return 0;
            foreach (var plot in farm.plots)
            {
                if (plot.state != "GROWING" || plot.readyAt <= 0) continue;
                if (soonest == 0 || plot.readyAt < soonest) soonest = plot.readyAt;
            }
            return soonest;
        }
    }

    // Thông báo hệ thống (hiện cả khi đã thoát game).
    // Bật bằng cách: Window → Package Manager → cài "Mobile Notifications",
    // rồi Project Settings → Player → Scripting Define Symbols thêm MYZOO_MOBILE_NOTIFICATIONS.
    // Không cài thì phần này bị bỏ qua, game vẫn chạy bình thường.
    public static class OsNotifications
    {
        public static void ScheduleCropReady(long readyAtEpochMs)
        {
            long delayMs = readyAtEpochMs - Api.I.Now;
            if (delayMs <= 0) return;
#if MYZOO_MOBILE_NOTIFICATIONS && UNITY_ANDROID
            var channel = new Unity.Notifications.Android.AndroidNotificationChannel(
                "myzoo_farm", "Nông trại", "Nhắc cây chín, thú đói",
                Unity.Notifications.Android.Importance.Default);
            Unity.Notifications.Android.AndroidNotificationCenter.RegisterNotificationChannel(channel);

            var notification = new Unity.Notifications.Android.AndroidNotification
            {
                Title = "MyZoo",
                Text = "Cây đã chín, vào thu hoạch nào!",
                FireTime = System.DateTime.Now.AddMilliseconds(delayMs)
            };
            Unity.Notifications.Android.AndroidNotificationCenter.SendNotification(notification, "myzoo_farm");
#elif MYZOO_MOBILE_NOTIFICATIONS && UNITY_IOS
            Unity.Notifications.iOS.iOSNotificationCenter.ScheduleNotification(
                new Unity.Notifications.iOS.iOSNotification
                {
                    Title = "MyZoo",
                    Body = "Cây đã chín, vào thu hoạch nào!",
                    Trigger = new Unity.Notifications.iOS.iOSNotificationTimeIntervalTrigger
                    {
                        TimeInterval = System.TimeSpan.FromMilliseconds(delayMs),
                        Repeats = false
                    }
                });
#endif
        }

        public static void CancelAll()
        {
#if MYZOO_MOBILE_NOTIFICATIONS && UNITY_ANDROID
            Unity.Notifications.Android.AndroidNotificationCenter.CancelAllScheduledNotifications();
#elif MYZOO_MOBILE_NOTIFICATIONS && UNITY_IOS
            Unity.Notifications.iOS.iOSNotificationCenter.RemoveAllScheduledNotifications();
#endif
        }
    }
}
