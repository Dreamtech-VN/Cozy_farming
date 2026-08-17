using System;
using UnityEngine;

namespace MyZoo
{
    // Ghi âm bằng Microphone rồi đóng gói WAV 16-bit mono. 8kHz để 12 giây vẫn dưới hạn 200KB của server.
    public static class ChatVoice
    {
        public const int SampleRate = 8000;
        public const int MaxSeconds = 12;

        static AudioClip recording;
        static string device;

        public static bool IsRecording { get { return recording != null; } }

        public static bool Start()
        {
#if UNITY_ANDROID && !UNITY_EDITOR
            // Android 6 trở lên phải xin quyền lúc chạy; lần đầu bấm sẽ hiện hộp thoại, người chơi bấm lại là thu được.
            if (!UnityEngine.Android.Permission.HasUserAuthorizedPermission(UnityEngine.Android.Permission.Microphone))
            {
                UnityEngine.Android.Permission.RequestUserPermission(UnityEngine.Android.Permission.Microphone);
                return false;
            }
#endif
            if (Microphone.devices.Length == 0) return false;
            device = Microphone.devices[0];
            recording = Microphone.Start(device, false, MaxSeconds, SampleRate);
            return recording != null;
        }

        // Trả về WAV đã cắt đúng phần đã thu; durationMs là độ dài thực tế.
        public static byte[] Stop(out int durationMs)
        {
            durationMs = 0;
            if (recording == null) return null;
            int written = Microphone.GetPosition(device);
            Microphone.End(device);
            var clip = recording;
            recording = null;
            if (written <= 0) return null;

            var samples = new float[written * clip.channels];
            clip.GetData(samples, 0);
            durationMs = (int)(written * 1000L / clip.frequency);
            return EncodeWav(samples, clip.frequency, clip.channels);
        }

        public static void Cancel()
        {
            if (recording == null) return;
            Microphone.End(device);
            recording = null;
        }

        public static byte[] EncodeWav(float[] samples, int frequency, int channels)
        {
            var wav = new byte[44 + samples.Length * 2];
            int byteRate = frequency * channels * 2;
            WriteAscii(wav, 0, "RIFF");
            WriteInt(wav, 4, wav.Length - 8);
            WriteAscii(wav, 8, "WAVE");
            WriteAscii(wav, 12, "fmt ");
            WriteInt(wav, 16, 16);
            WriteShort(wav, 20, 1);
            WriteShort(wav, 22, (short)channels);
            WriteInt(wav, 24, frequency);
            WriteInt(wav, 28, byteRate);
            WriteShort(wav, 32, (short)(channels * 2));
            WriteShort(wav, 34, 16);
            WriteAscii(wav, 36, "data");
            WriteInt(wav, 40, samples.Length * 2);
            for (int i = 0; i < samples.Length; i++)
            {
                short value = (short)(Mathf.Clamp(samples[i], -1f, 1f) * short.MaxValue);
                WriteShort(wav, 44 + i * 2, value);
            }
            return wav;
        }

        public static AudioClip DecodeWav(byte[] wav, string name)
        {
            if (wav == null || wav.Length < 44) return null;
            int channels = BitConverter.ToInt16(wav, 22);
            int frequency = BitConverter.ToInt32(wav, 24);
            int count = (wav.Length - 44) / 2;
            var samples = new float[count];
            for (int i = 0; i < count; i++) samples[i] = BitConverter.ToInt16(wav, 44 + i * 2) / (float)short.MaxValue;

            var clip = AudioClip.Create(name, count / Mathf.Max(1, channels), Mathf.Max(1, channels),
                                        frequency > 0 ? frequency : SampleRate, false);
            clip.SetData(samples, 0);
            return clip;
        }

        static void WriteAscii(byte[] buffer, int offset, string text)
        {
            for (int i = 0; i < text.Length; i++) buffer[offset + i] = (byte)text[i];
        }

        static void WriteInt(byte[] buffer, int offset, int value)
        {
            Buffer.BlockCopy(BitConverter.GetBytes(value), 0, buffer, offset, 4);
        }

        static void WriteShort(byte[] buffer, int offset, short value)
        {
            Buffer.BlockCopy(BitConverter.GetBytes(value), 0, buffer, offset, 2);
        }
    }
}
