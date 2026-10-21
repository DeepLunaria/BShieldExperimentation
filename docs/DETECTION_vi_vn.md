# Tổng hợp những kiểm tra, phát hiện lỗ hổng bảo mật của BShield trên Android

Tài liệu này liệt kê tất cả các cơ chế kiểm tra, phát hiện lỗ hổng bảo mật của Bshield trên thiết bị Android và cách để bypass các cơ chế trên tính đến ngày 20 tháng 10 năm 2026. Nếu bạn phát hiện thêm các cơ chế phát hiện khác, hãy thoải mái báo cáo trong tab Issues.

> [!CAUTION]
> **Dự án này chỉ phục vụ mục đích giáo dục. Mục tiêu là làm nổi bật những điểm yếu của các giải pháp bảo mật hiện tại và khuyến khích phát triển những giải pháp thay thế tốt hơn, đáng tin cậy hơn. Hãy sử dụng thông tin này một cách có trách nhiệm. KHÔNG sử dụng cho mục đích độc hại. Tôi không chịu trách nhiệm cho bất kỳ hành động nào được thực hiện bởi người dùng của module hoặc dự án này.**

**Mục lục:**

<!-- TOC -->

- [Tổng hợp những kiểm tra, phát hiện lỗ hổng bảo mật của BShield trên Android](#t%E1%BB%95ng-h%E1%BB%A3p-nh%E1%BB%AFng-ki%E1%BB%83m-tra-ph%C3%A1t-hi%E1%BB%87n-l%E1%BB%97-h%E1%BB%95ng-b%E1%BA%A3o-m%E1%BA%ADt-c%E1%BB%A7a-bshield-tr%C3%AAn-android)
  - [JNI bị Crash ở những phiên bản Android 16 QPR1 hoặc mới hơn (app bị đóng ngay lập tức)](#jni-b%E1%BB%8B-crash-%E1%BB%9F-nh%E1%BB%AFng-phi%C3%AAn-b%E1%BA%A3n-android-16-qpr1-ho%E1%BA%B7c-m%E1%BB%9Bi-h%C6%A1n-app-b%E1%BB%8B-%C4%91%C3%B3ng-ngay-l%E1%BA%ADp-t%E1%BB%A9c)
  - [Mã lỗi 1 (Phát hiện ứng dụng đã bị chỉnh sửa)](#m%C3%A3-l%E1%BB%97i-1-ph%C3%A1t-hi%E1%BB%87n-%E1%BB%A9ng-d%E1%BB%A5ng-%C4%91%C3%A3-b%E1%BB%8B-ch%E1%BB%89nh-s%E1%BB%ADa)
  - [Mã lỗi 2 (Phát hiện cài đặt trên máy ảo, giả lập)](#m%C3%A3-l%E1%BB%97i-2-ph%C3%A1t-hi%E1%BB%87n-c%C3%A0i-%C4%91%E1%BA%B7t-tr%C3%AAn-m%C3%A1y-%E1%BA%A3o-gi%E1%BA%A3-l%E1%BA%ADp)
  - [Mã lỗi 3 (Phát hiện danh sách ứng dụng và PIF Inject của KOW)](#m%C3%A3-l%E1%BB%97i-3-ph%C3%A1t-hi%E1%BB%87n-danh-s%C3%A1ch-%E1%BB%A9ng-d%E1%BB%A5ng-v%C3%A0-pif-inject-c%E1%BB%A7a-kow)
  - [Mã lỗi 4 (Phát hiện công cụ debug, hiếm)](#m%C3%A3-l%E1%BB%97i-4-ph%C3%A1t-hi%E1%BB%87n-c%C3%B4ng-c%E1%BB%A5-debug-hi%E1%BA%BFm)
  - [Mã lỗi 5 (Phát hiện root)](#m%C3%A3-l%E1%BB%97i-5-ph%C3%A1t-hi%E1%BB%87n-root)
    - [Đặc tính hệ thống](#%C4%91%E1%BA%B7c-t%C3%ADnh-h%E1%BB%87-th%E1%BB%91ng)
    - [Phát hiện bộ nhớ map đã bị injected](#ph%C3%A1t-hi%E1%BB%87n-b%E1%BB%99-nh%E1%BB%9B-map-%C4%91%C3%A3-b%E1%BB%8B-injected)
    - [Trạng thái Enforcing của Kernel](#tr%E1%BA%A1ng-th%C3%A1i-enforcing-c%E1%BB%A7a-kernel)
    - [Phát hiện tên gói của trình quản lý root](#ph%C3%A1t-hi%E1%BB%87n-t%C3%AAn-g%C3%B3i-c%E1%BB%A7a-tr%C3%ACnh-qu%E1%BA%A3n-l%C3%BD-root)
    - [Phát hiện dùng module thay đổi launcher tùy chỉnh](#ph%C3%A1t-hi%E1%BB%87n-d%C3%B9ng-module-thay-%C4%91%E1%BB%95i-launcher-t%C3%B9y-ch%E1%BB%89nh)
    - [Kiểm tra bootloader có unlock hay không](#ki%E1%BB%83m-tra-bootloader-c%C3%B3-unlock-hay-kh%C3%B4ng)
    - [Mount đáng ngờ](#mount-%C4%91%C3%A1ng-ng%E1%BB%9D)
    - [[CHƯA XÁC NHẬN] Phát hiện vòng lặp image proc của module KSU/AP](#ch%C6%B0a-x%C3%A1c-nh%E1%BA%ADn-ph%C3%A1t-hi%E1%BB%87n-v%C3%B2ng-l%E1%BA%B7p-image-proc-c%E1%BB%A7a-module-ksuap)
  - [Mã lỗi 6 (Phát hiện bootloader mở khóa) hiện tại không sử dụng hoặc có thể đã đưa vào chung code 5 mục Kiểm tra bootloader](#m%C3%A3-l%E1%BB%97i-6-ph%C3%A1t-hi%E1%BB%87n-bootloader-m%E1%BB%9F-kh%C3%B3a-hi%E1%BB%87n-t%E1%BA%A1i-kh%C3%B4ng-s%E1%BB%AD-d%E1%BB%A5ng-ho%E1%BA%B7c-c%C3%B3-th%E1%BB%83-%C4%91%C3%A3-%C4%91%C6%B0a-v%C3%A0o-chung-code-5-m%E1%BB%A5c-ki%E1%BB%83m-tra-bootloader)
  - [Mã lỗi 7 (Phát hiện ứng dụng đáng ngờ) hiếm khi xuất hiện](#m%C3%A3-l%E1%BB%97i-7-ph%C3%A1t-hi%E1%BB%87n-%E1%BB%A9ng-d%E1%BB%A5ng-%C4%91%C3%A1ng-ng%E1%BB%9D-hi%E1%BA%BFm-khi-xu%E1%BA%A5t-hi%E1%BB%87n)
  - [Mã lỗi 8 (Phát hiện ứng dụng đang được chạy ở chế độ không gian khác khác với không gian gốc của máy)](#m%C3%A3-l%E1%BB%97i-8-ph%C3%A1t-hi%E1%BB%87n-%E1%BB%A9ng-d%E1%BB%A5ng-%C4%91ang-%C4%91%C6%B0%E1%BB%A3c-ch%E1%BA%A1y-%E1%BB%9F-ch%E1%BA%BF-%C4%91%E1%BB%99-kh%C3%B4ng-gian-kh%C3%A1c-kh%C3%A1c-v%E1%BB%9Bi-kh%C3%B4ng-gian-g%E1%BB%91c-c%E1%BB%A7a-m%C3%A1y)
  - [Mã lỗi 10 (Phát hiện chế độ debug ADB)](#m%C3%A3-l%E1%BB%97i-10-ph%C3%A1t-hi%E1%BB%87n-ch%E1%BA%BF-%C4%91%E1%BB%99-debug-adb)
  - [Mã lỗi 11 (Phát hiện chế độ nhà phát triển)](#m%C3%A3-l%E1%BB%97i-11-ph%C3%A1t-hi%E1%BB%87n-ch%E1%BA%BF-%C4%91%E1%BB%99-nh%C3%A0-ph%C3%A1t-tri%E1%BB%83n)
  - [Mã lỗi 12 (Phát hiện thiết bị đang sử dụng ROM tùy chỉnh)](#m%C3%A3-l%E1%BB%97i-12-ph%C3%A1t-hi%E1%BB%87n-thi%E1%BA%BFt-b%E1%BB%8B-%C4%91ang-s%E1%BB%AD-d%E1%BB%A5ng-rom-t%C3%B9y-ch%E1%BB%89nh)
    - [Cơ chế](#c%C6%A1-ch%E1%BA%BF)
    - [Cách khắc phục tạm thời (Workaround)](#c%C3%A1ch-kh%E1%BA%AFc-ph%E1%BB%A5c-t%E1%BA%A1m-th%E1%BB%9Di-workaround)
  - [Mã lỗi 13 (Phát hiện thiết bị đang chạy dịch vụ trợ năng đang chạy)](#m%C3%A3-l%E1%BB%97i-13-ph%C3%A1t-hi%E1%BB%87n-thi%E1%BA%BFt-b%E1%BB%8B-%C4%91ang-ch%E1%BA%A1y-d%E1%BB%8Bch-v%E1%BB%A5-tr%E1%BB%A3-n%C4%83ng-%C4%91ang-ch%E1%BA%A1y)
  - [Mã lỗi 14 (Phát hiện ứng dụng cài từ nguồn không xác định)](#m%C3%A3-l%E1%BB%97i-14-ph%C3%A1t-hi%E1%BB%87n-%E1%BB%A9ng-d%E1%BB%A5ng-c%C3%A0i-t%E1%BB%AB-ngu%E1%BB%93n-kh%C3%B4ng-x%C3%A1c-%C4%91%E1%BB%8Bnh)
  - [Mã lỗi 15 (Phát hiện ứng dụng độc hại)](#m%C3%A3-l%E1%BB%97i-15-ph%C3%A1t-hi%E1%BB%87n-%E1%BB%A9ng-d%E1%BB%A5ng-%C4%91%E1%BB%99c-h%E1%BA%A1i)
  - [Mã lỗi 16 (Bàn phím ảo không trong danh sách tin cậy)](#m%C3%A3-l%E1%BB%97i-16-b%C3%A0n-ph%C3%ADm-%E1%BA%A3o-kh%C3%B4ng-trong-danh-s%C3%A1ch-tin-c%E1%BA%ADy)
  - [Mã lỗi 17 (Ứng dụng cài trong hồ sơ công việc)](#m%C3%A3-l%E1%BB%97i-17-%E1%BB%A9ng-d%E1%BB%A5ng-c%C3%A0i-trong-h%E1%BB%93-s%C6%A1-c%C3%B4ng-vi%E1%BB%87c)
  - [Mã lỗi 18 (Đang dùng nhập liệu mô phỏng)](#m%C3%A3-l%E1%BB%97i-18-%C4%91ang-d%C3%B9ng-nh%E1%BA%ADp-li%E1%BB%87u-m%C3%B4-ph%E1%BB%8Fng)
  - [Mã lỗi 19 (Đang dùng chế độ proxy trên thiết bị)](#m%C3%A3-l%E1%BB%97i-19-%C4%91ang-d%C3%B9ng-ch%E1%BA%BF-%C4%91%E1%BB%99-proxy-tr%C3%AAn-thi%E1%BA%BFt-b%E1%BB%8B)
  - [Mã lỗi 20 (Ứng dụng không hỗ trợ hệ điều hành MacOS)](#m%C3%A3-l%E1%BB%97i-20-%E1%BB%A9ng-d%E1%BB%A5ng-kh%C3%B4ng-h%E1%BB%97-tr%E1%BB%A3-h%E1%BB%87-%C4%91i%E1%BB%81u-h%C3%A0nh-macos)
  - [Mã lỗi 21 (Phát hiện có vẻ đã bị bẻ khóa (root))](#m%C3%A3-l%E1%BB%97i-21-ph%C3%A1t-hi%E1%BB%87n-c%C3%B3-v%E1%BA%BB-%C4%91%C3%A3-b%E1%BB%8B-b%E1%BA%BB-kh%C3%B3a-root)
  - [Mã lỗi 22 (Thiết bị của bạn có vẻ đã bị can thiệp hệ thống (hook))](#m%C3%A3-l%E1%BB%97i-22-thi%E1%BA%BFt-b%E1%BB%8B-c%E1%BB%A7a-b%E1%BA%A1n-c%C3%B3-v%E1%BA%BB-%C4%91%C3%A3-b%E1%BB%8B-can-thi%E1%BB%87p-h%E1%BB%87-th%E1%BB%91ng-hook)
  - [Mã lỗi 23 (Thiết bị đang kết nối VPN)](#m%C3%A3-l%E1%BB%97i-23-thi%E1%BA%BFt-b%E1%BB%8B-%C4%91ang-k%E1%BA%BFt-n%E1%BB%91i-vpn)

<!-- /TOC -->

## JNI bị Crash ở những phiên bản Android 16 QPR1 hoặc mới hơn (app bị đóng ngay lập tức)

> [!NOTE]
> Thời gian gần đây, chúng tôi có để ý đến một crash kì lạ trên những app chạy BShield khi ta update phiên bản android lên 16 QPR1+. Sau 3 tháng nghiên cứu, chúng tôi đã phát hiện nguyên nhân đầu tiên đến từ các custom recovery cũ.
>
> Trong bản cập nhật 16 QPR1+, chúng tôi tin rằng cách mà A16 QPR1+ quản lý bộ nhớ đã khác hẳn so với các custom recovery cũ. Điều này không chỉ gây ảnh hưởng đến các app dùng BShield mà còn một số app ngoại lệ nữa.
>
> Nếu như bạn biết thêm về JNI crash trong app dùng BShield, hãy báo cáo cho chúng tôi qua tab [Issues](https://github.com/DeepLunaria/BShieldExperimentation).

Crash này xảy ra khi thiết bị sử dụng các custom recovery cũ để flash ROM A16 QPR1+ rom, kernel,....

Nếu như bạn đã lỡ flash A16 QPR1+ bằng các custom recovery cũ, chúng tôi khuyên bạn nên clean flash lại ROM bằng recovery đi theo ROM để tránh tình trạng này. 

## Mã lỗi 1 (Phát hiện ứng dụng đã bị chỉnh sửa)

**Link tham khảo:** <https://s.bshield.io/?code=1>

Lỗi này xảy ra khi bạn cài đặt ứng dụng dùng cơ chế kiểm tra của BShield mà chưa được ký hoặc đã bị chỉnh sửa. Đối với các nhà phát triển đã patch ứng dụng , hiện tại tôi không tìm ra cách nào để làm cho nó hoạt động. Bạn có thể thử, nhưng sẽ rất khó để thành công.

**Cách khắc phục:**  
Gỡ bỏ ứng dụng dùng cơ chế kiểm tra của BShield đã bị chỉnh sửa hoặc chưa ký khỏi hệ thống và cài đặt lại từ Google Play.

## Mã lỗi 2 (Phát hiện cài đặt trên máy ảo, giả lập)

**Link tham khảo:** <https://s.bshield.io/?code=2>

Lỗi này xảy ra khi bạn cài đặt ứng dụng trong máy ảo, giả lập.

**Cách khắc phục:**  
Không cài đặt ứng dụng trong máy ảo, giả lập (hiển nhiên :v).

## Mã lỗi 3 (Phát hiện danh sách ứng dụng và PIF Inject của KOW)

**Link tham khảo:** <https://s.bshield.io/?code=3>

Lỗi này xảy ra khi bạn cài đặt trình quản lý root hoặc các ứng dụng đáng ngờ, module lsposed trên thiết bị hoặc đang dùng module PIF Inject.

Dưới đây là danh sách các ứng dụng mà BShield hiện đang phát hiện (có thể còn nhiều hơn; đây chỉ là những ứng dụng đã được xác nhận qua thử nghiệm. Bạn có thể yêu cầu cập nhật trong tab Issues):

```txt
com.topjohnwu.magisk
com.drdisagree.iconify
<phần lớn các module lsposed>
```

**Cách khắc phục:**
Bạn hãy sử dụng module KSU/Magisk và module LSposed dưới đây (ưu tiên FOSS):

- [ReLSPosed](https://github.com/ThePedroo/ReLSPosed)
- [HMA-OSS](https://github.com/frknkrc44/HMA-OSS)

để ẩn các ứng dụng này.

Hoặc nếu bạn không dùng root, đơn giản là đừng cài đặt trình quản lý root trên thiết bị.

Chuyển sang dùng PIF Fork của osm0sis nếu bạn vẫn thấy lỗi 3 xuất hiện: https://github.com/osm0sis/PlayIntegrityFork

Đối với các bạn dùng Meta Module thì hãy dùng magicmount hoặc hybrid mount để tránh lỗi 3 cũng như lỗi 5 (Chỉ dùng 2 meta module này):

- Magicmount module: https://github.com/KernelSU-Modules-Repo/meta-mm/releases
- Hybrid mount: https://github.com/Hybrid-Mount/meta-hybrid_mount/releases

## Mã lỗi 4 (Phát hiện công cụ debug, hiếm)

**Link tham khảo:** <https://s.bshield.io/?code=4>

Lỗi này xảy ra khi bạn chạy ứng dụng dùng cơ chế kiểm tra của BShield bằng các công cụ debug của Google. Lỗi này sẽ không xuất hiện trong bản build production của ứng dụng. Nếu bạn gặp lỗi này, hãy liên hệ với nhà phát triển ứng dụng hoặc báo cho tôi biết.

## Mã lỗi 5 (Phát hiện root)

**Link tham khảo:** <https://s.bshield.io/?code=5>

Đây là cơ chế phát hiện khó vượt qua nhất của BShield khi bạn sử dụng trên thiết bị đã root hoặc thiết bị chạy custom rom, bao gồm nhiều dạng phát hiện root và các đặc tính hệ thống khác nhau. Dưới đây là một số cơ chế đã được xác nhận:

### Đặc tính hệ thống

BShield phát hiện đặc tính hệ thống Android dưới đây (xuất hiện ở đa số custom rom AOSP). Một số đã biết:

- `init.svc.adb_root`
- `service.adb.root`

**Cách khắc phục:**
Các đặc tính này có thể được fix bằng cách override, ví dụ:

```sh
resetprop -n -p init.svc.adb_root ""
resetprop -n -p service.adb.root ""
```

**Lưu ý:** Các đặc tính này sẽ bị khôi phục lại như cũ sau khi reboot. Bạn có thể sử dụng module của tôi trong tab Release để tự động fix sau mỗi lần khởi động.

### Phát hiện bộ nhớ map đã bị injected

BShield phát hiện bộ nhớ map có bị injection hay không.

Bạn có thể kiểm tra bằng công cụ **Native Detector** ([tải tại đây](https://github.com/reveny/Android-Native-Root-Detector/releases/latest)).

Ví dụ, nó có thể báo lỗi "Injection Detection".

**Một số cách khắc phục:**

- Nếu kernel của bạn hỗ trợ KernelSU + SuSFS (đã bật tính năng SUS_MAP), bạn có thể thêm các đường dẫn bộ nhớ map bị phát hiện injected vào danh sách map của SuSFS (SUS_MAP).
- Nếu bạn dùng module thay đổi font, nó cũng có thể làm cho bộ nhớ map bị injected. Hãy gỡ bỏ hoặc thêm đường dẫn của nó vào SUS_MAP như trên.
- Bạn cũng có thể thử dùng module TreatWheel của Pedro để ẩn các bộ nhớ map bị injected, nhưng hiệu quả có hạn (so với SUS_MAP của SUSFS) và yêu cầu dùng chung với ReZygisk.

**Lưu ý về phát hiện các đường dẫn bộ nhớ maps của /system/framework/framework-res.apk.**

Bạn có thể thấy trong công cụ **Native Detector** báo **Found Injection**, với kết quả tương tự như sau:

```txt
7982fef000-7983031000 r--s 00000000 fd:00 1549 /system/framework/framework-res.apk
7988432000-7988448000 r--s 00344000 fd:01 1631 /system/framework/framework-res.apk
7988538000-7988546000 r--s 00000000 fd:03 3165 /system/framework/framework-res.apk
798bf3d000-798bf3e000 r--s 00055000 fd:00 1549 /system/framework/framework-res.apk
798bf3e000-798bf3f000 r--s 00000000 fd:03 3166 /system/framework/framework-res.apk
798bf4d000-798bf4e000 r--s 00002000 fd:03 3166 /system/framework/framework-res.apk
798bf4e000-798bf4f000 r--s 00000000 fd:27 518  /system/framework/framework-res.apk
7992736000-799273c000 r--s 0035d000 fd:01 1631 /system/framework/framework-res.apk
7992826000-7992827000 r--s 00000000 fd:27 503  /system/framework/framework-res.apk
7992976000-799297c000 r--s 00013000 fd:03 3165 /system/framework/framework-res.apk
79929ef000-79929f0000 r--s 00000000 fd:27 500  /system/framework/framework-res.apk
```

Điều này xảy ra vì kernel tùy chỉnh của bạn có thể đã chứa bản vá ẩn file LineageOS trong `task_mmu.c`. Xem [commit tham khảo (MoonWake@bea4fe4)](https://github.com/RainyXeon/moonwake_kernel_xiaomi_ruby/commit/bea4fe4ecfa41edb52f26ce9254a16643dda57ea).

Mục đích của bản vá này là thay thế đường dẫn file LineageOS thật bằng `framework-res.apk`. Nếu một file được map bởi VMA có chứa `lineage` trong tên, thì `/proc/<pid>/map_files/<start>-<end>` sẽ trỏ tới `framework-res.apk` thay vì file thật, nhằm tránh bị các công cụ kiểm tra root phát hiện.

Tuy nhiên, cơ chế này đã lỗi thời và vô tình kích hoạt **Found Injection** trong **Native Detector**, do header VMA giả vẫn có thể bị phát hiện. Có thể vì chỉ thay thế đường dẫn file mà không thay thế toàn bộ metadata của VMA.

Nếu bạn là nhà phát triển kernel tùy chỉnh, bạn có thể revert commit chứa đoạn code ẩn file LineageOS. Nếu bạn là người dùng, bạn không thể làm gì trừ khi thay kernel hoặc yêu cầu nhà phát triển kernel sửa đổi.

### Trạng thái Enforcing của Kernel

Đây là dạng phát hiện phổ biến. Không nên sử dụng ROM với **SELinux permissive**, vì bị xem là không an toàn theo tiêu chuẩn hiện đại.

BShield yêu cầu **SELinux** phải ở trạng thái **Enforced** để hoạt động bình thường.

**Cách khắc phục:**

- Đặt SELinux sang **Enforcing**

```sh
setenforce 1
```

- Sử dụng kernel hoặc ROM với **SELinux Enforcing**

### Phát hiện tên gói của trình quản lý root

BShield kiểm tra danh sách ứng dụng đã cài để tìm các ứng dụng thường liên quan đến root cũng như đáng ngờ [mã lỗi 3](#mã-lỗi-3-phát-hiện-danh-sách-ứng-dụng), nhưng vì lý do nào đó, các app như `me.bmax.apatch` hoặc `com.rifsxd.ksunext` sẽ kích hoạt mã lỗi 5 thay vì 3

Danh sách ứng dụng bị phát hiện:

```txt
com.topjohnwu.magisk
com.drdisagree.iconify
com.rifsxd.ksunext
me.bmax.apatch
me.weishu.kernelsu
```

**Cách khắc phục:**
Bạn hãy sử dụng module KSU/Magisk và module LSposed dưới đây (ưu tiên FOSS):

- [ReLSPosed](https://github.com/ThePedroo/ReLSPosed)
- [HMA-OSS](https://github.com/frknkrc44/HMA-OSS)

để ẩn các ứng dụng này.

### Phát hiện dùng module thay đổi launcher tùy chỉnh

BShield có thể phát hiện nhiều module thay đổi launcher tùy chỉnh, có thể thông qua mount, memory maps hoặc các chỉ dấu khác.

**Cách khắc phục:**
Cách đơn giản nhất là gỡ launcher tùy chỉnh và dùng launcher mặc định của hệ thống. Hoặc dùng launcher tiêu chuẩn từ Play Store.

### Kiểm tra bootloader có unlock hay không

Tôi có thể xác nhận rằng BShield đã kiểm tra bootloader vào đầu năm 2026. Nó chỉ kiểm tra trạng thái khóa và với AOSP keybox; hoặc keybox bị revoke hiện vẫn dùng được.

**Cách khắc phục:**
Cài đặt [JingMatrix/TEESimulator](https://github.com/JingMatrix/TEESimulator), thêm tên gói vào file `target.txt` như sau:

```txt
com.vnid
```

### Mount đáng ngờ

Từ lâu, BShield kiểm tra mount để phát hiện root. Điều này xảy ra khi cài các module dùng cơ chế mount để thay đổi file hệ thống.

Bạn có thể kiểm tra bằng **Native Detector**.

Ví dụ, nó có thể báo "Suspicious Mount".

**Cách khắc phục:**

- Nếu file zip của module có `mount --bind`, hãy cẩn thận vì có thể kích hoạt lỗi này. Yêu cầu dev sử dụng [phương pháp này thay thế](https://kernelsu.org/guide/module.html).
- KSU 3.0 và một số phiên bản mới của APatch, Magisk đã xử lý tốt hơn vấn đề này.
- Trên một số thiết bị, ReZygisk không thể unmount một số path. Nếu bạn gặp lỗi này, hãy báo cho tôi.

**KSU 3:**
- Đối với KSU 3 trở lên thì phải dùng Meta module magicmount module hoặc hybrid mount để tránh bị lộ mount
- Magicmount module: https://github.com/KernelSU-Modules-Repo/meta-mm/releases
- Hybrid mount: https://github.com/Hybrid-Mount/meta-hybrid_mount/releases

### [CHƯA XÁC NHẬN] Phát hiện vòng lặp image proc của module KSU/AP

Theo báo cáo gần đây từ [@Hzzmonet](https://t.me/Hzzmonet), BShield có thể phát hiện vòng lặp image proc của module KSU/AP. Nguyên nhân là các phiên bản KSU/AP cũ dùng cơ chế mount OverlayFS, dẫn đến bị phát hiện.

Bạn có thể kiểm tra bằng **Native Detector**.

Ví dụ, nó sẽ báo "KSU/AP loop".

**Cách khắc phục:**

- Nếu bạn dùng KernelSU bản gốc và phiên bản cũ, hãy dùng module TreatWheel của Pedro + ReZygisk để ẩn.
- Nếu bạn dùng KernelSU-Next phiên bản bản cũ, hãy tắt tùy chọn Use OverlayFS trong phần cài đặt. Nhớ sao lưu module trước khi thao tác vì tất cả module sẽ bị xóa.
- Với các bạn dùng KSU gốc và fork bản v3 cũng như APatch bản mới đã fix lỗi này

## Mã lỗi 6 (Phát hiện bootloader mở khóa) hiện tại không sử dụng hoặc có thể đã đưa vào chung code 5 mục Kiểm tra bootloader

**Link tham khảo:** <https://s.bshield.io/?code=6>

Lỗi này xảy ra khi bootloader bị mở khóa. Hiện tại hầu hết các ứng dụng dùng BShield chưa kích hoạt phát hiện này. Nếu trong tương lai có dùng, bạn có thể tham khảo cách khắc phục bên dưới.

**Cách khắc phục:**
Cài đặt [JingMatrix/TEESimulator](https://github.com/JingMatrix/TEESimulator), thêm tên gói vào `target.txt`:

```txt
com.vnid
```

## Mã lỗi 7 (Phát hiện ứng dụng đáng ngờ) hiếm khi xuất hiện

**Link tham khảo:** <https://s.bshield.io/?code=7>

Lỗi này xảy ra khi danh sách ứng dụng có ứng dụng đáng ngờ trên thiết bị. Hiếm khi gặp trong thực tế.

**Cách khắc phục:**
Giống [mã lỗi 3](#mã-lỗi-3-phát-hiện-danh-sách-ứng-dụng).

## Mã lỗi 8 (Phát hiện ứng dụng đang được chạy ở chế độ không gian khác khác với không gian gốc của máy)

**Link tham khảo:** <https://s.bshield.io/?code=8>

Lỗi này xảy ra khi bạn sử dụng ứng dụng dùng cơ chế kiểm tra của BShield trong không gian riêng tư, không gian thứ 2 khác với không gian gốc của máy.

**Cách khắc phục:**
Không sử dụng ứng dụng bên trong app của bên thứ ba.

## Mã lỗi 10 (Phát hiện chế độ debug ADB)

**Link tham khảo:** <https://s.bshield.io/?code=10>

Lỗi này xảy ra khi bạn bật chế độ debug ADB trên thiết bị.

**Cách khắc phục:**
Bạn hãy sử dụng module KSU/Magisk và module LSposed dưới đây (ưu tiên FOSS):

- [ReLSPosed](https://github.com/ThePedroo/ReLSPosed)
- [HMA-OSS](https://github.com/frknkrc44/HMA-OSS)

để ẩn debug ADB

## Mã lỗi 11 (Phát hiện chế độ nhà phát triển)

**Link tham khảo:** <https://s.bshield.io/?code=11>

Lỗi này xảy ra khi bạn bật Developer Mode trên thiết bị.

**Cách khắc phục:**
Bạn hãy sử dụng module KSU/Magisk và module LSposed dưới đây (ưu tiên FOSS):

- [ReLSPosed](https://github.com/ThePedroo/ReLSPosed)
- [HMA-OSS](https://github.com/frknkrc44/HMA-OSS)

để ẩn Developer Mode và ADB debug mode.

Hoặc cách tốt nhất: không bật Developer Mode khi không sử dụng.

## Mã lỗi 12 (Phát hiện thiết bị đang sử dụng ROM tùy chỉnh)

**Link tham khảo:** <https://s.bshield.io/?code=12>

Lỗi này xảy ra khi bạn dùng ROM custom trên thiết bị.

### Cơ chế

Trước hết, BShield quét các thư mục / phân vùng như `/system`, `/system_ext` và `/product` để  kiểm tra xem có thư mục, tệp tin lineage nào không

Bạn có thể kiểm tra qua những lệnh này trên termux như sau:

```sh
find /system -iname '*lineage*' 2>/dev/null
find /product -iname '*lineage*' 2>/dev/null
find /system_ext -iname '*lineage*' 2>/dev/null
stat /system/addon.d
```

Tiếp theo, BShield kiểm tra xem `ro.build.display.id` và `ro.build.keys` xem có test-key nào ko ([Theo gợi ý của nhóm FPT Night-Wolf](https://blogs.night-wolf.io/ai-assisted-on-rasp-analysis)).

Cuối cùng, BShield kiểm tra xem trạng thái trình khởi động có mở hay không.

### Cách khắc phục tạm thời (Workaround)
- Cài đặt [JingMatrix/TEESimulator](https://github.com/JingMatrix/TEESimulator), sau đó thêm tên package vào file `target.txt`.
- Cài đặt bản mới nhất của `simple_bshield_bypass_module`
- Đối với cơ chế đầu tiên, hiện tại chúng ta có 2 cách khắc phục:
  - Phương pháp 1: Đối với thiết bị có hỗ trợ susfs, bạn có thể cài đặt BRENE và bật Hide Custom ROM Paths cùng Hide /system/addon.d Path. Lưu ý: Nếu bạn vẫn muốn sử dụng susfs4ksu-module, bạn có thể cần lấy danh sách từ termux bằng lệnh trong mục Cơ chế (Mechanism) ở trên và thêm vào SUS PATH LOOP.
  - Phương pháp 2: Bạn có thể cài đặt module NoMount Bypass for BShield cùng với việc cài đặt và khởi chạy thành công module NoMount.

Đối với người dùng không sử dụng susfs hay nomount, chúng tôi đang phát triển một giải pháp tạm thời qua zygisk. Tuy nhiên, nó có thể sẽ là mã nguồn đóng trong một khoảng thời gian cho đến khi có bản phát hành ổn định, tương tự như trường hợp của TreatWheel.

## Mã lỗi 13 (Phát hiện thiết bị đang chạy dịch vụ trợ năng đang chạy)

**Link tham khảo:** <https://s.bshield.io/?code=13>

Lỗi này xảy ra khi bạn dùng ứng dụng dùng dịch vụ trợ năng trên thiết bị.

**Cách khắc phục:**
Cài đặt [Nitsuya/DoNotTryAccessibility](https://github.com/Nitsuya/DoNotTryAccessibility), mở LSPosed và vào module DoNotTryAccessibility chọn hook vào `System Framework`.

## Mã lỗi 14 (Phát hiện ứng dụng cài từ nguồn không xác định)

**Link tham khảo:** <https://s.bshield.io/?code=14>

**Cách khắc phục:**

Cài đặt app từ Google Play Store hoặc Aurora Store.

Bạn có thể thử bật `Spoof Installation Source` trong `HMA-OSS` nếu bạn muốn.

## Mã lỗi 15 (Phát hiện ứng dụng độc hại)

**Link tham khảo:** <https://s.bshield.io/?code=15>

Lỗi này xảy ra khi bạn dùng ứng dụng dùng có dấu hiệu độc hại trên thiết bị.

**Cách khắc phục:**
Chúng tôi khuyên bạn nên rà soát lại ứng dụng đã cài đặt, nếu bạn muốn không gỡ ứng dụng mà chỉ muốn pass mã lỗi này thì xem lại [Mã lỗi 3 (Phát hiện danh sách ứng dụng)](#mã-lỗi-3-phát-hiện-danh-sách-ứng-dụng).

## Mã lỗi 16 (Bàn phím ảo không trong danh sách tin cậy)

**Link tham khảo:** <https://s.bshield.io/?code=16>

Lỗi này xảy ra khi bạn dùng ứng dụng bàn phím bên thứ 3 không nằm trong danh sách tin cậy của BShield.

**Cách khắc phục:**
Chúng tôi khuyên bạn nên dùng bàn phím đến từ nhà phát hành tin cậy như GBoard từ Google.

## Mã lỗi 17 (Ứng dụng cài trong hồ sơ công việc)

**Link tham khảo:** <https://s.bshield.io/?code=17>

Lỗi này xảy ra khi bạn cài ứng dụng trong hồ sơ công việc

**Cách khắc phục:**
Cài đặt lại ứng dụng ngoài hồ sơ công việc.
Hiên tại không có cách nào ẩn được tính năng này.

## Mã lỗi 18 (Đang dùng nhập liệu mô phỏng)

**Link tham khảo:** <https://s.bshield.io/?code=18>

Lỗi này xảy ra khi bạn dùng nhập liệu mô phỏng cho ứng dụng

**Cách khắc phục:**
Chúng tôi khuyên bạn không nên sử dụng các phần mềm autoclick hay bất kì ứng dụng, phần mềm này mô phong lại nhập liệu (ví dụ như keyboard) trong ứng dụng này.

## Mã lỗi 19 (Đang dùng chế độ proxy trên thiết bị)

**Link tham khảo:** <https://s.bshield.io/?code=19>

Lỗi này xảy ra khi bạn đang dùng proxy trong cài đặt SSID trong cài đặt Wi-fi.

**Cách khắc phục:**
Chúng tôi khuyên bạn tạm tắt proxy hoặc tốt nhất là không dùng proxy.

## Mã lỗi 20 (Ứng dụng không hỗ trợ hệ điều hành MacOS)

**Link tham khảo:** <https://s.bshield.io/?code=20>

Đây là mã lỗi khác đặc biệt khi sử dụng các trình ảo hóa iphone trên hệ thống MacOS.
Hiện tại lỗi này cũng hiếm khi xuất hiện, nhưng nếu có, điều đó cho thấy rằng bạn không nên sử dụng ứng dụng này trong các môi trường ảo hóa iphone.

## Mã lỗi 21 (Phát hiện có vẻ đã bị bẻ khóa (root))

**Link tham khảo:** <https://s.bshield.io/?code=21>

Mã lỗi này hiện tại theo như được tìm hiểu có cách hoạt động giống hệt mã lỗi số 5.
Bạn có thể đọc qua [bằng cách bấm vào đây](#mã-lỗi-5-phát-hiện-root)

## Mã lỗi 22 (Thiết bị của bạn có vẻ đã bị can thiệp hệ thống (hook))

**Link tham khảo:** <https://s.bshield.io/?code=22>

Lỗi này xảy ra khi bạn dùng module để hook (LSposed, Xposed)

**Cách khắc phục:**
Sử dụng bản LSPosed 2.0 chính thức (<https://lsposed.zip>) hoặc các bản fork của LSPosed như (Irena, IrenaX, Vector)

## Mã lỗi 23 (Thiết bị đang kết nối VPN)

**Link tham khảo:** <https://s.bshield.io/?code=23>

Lỗi này xảy ra khi bạn đang kết nối đến VPN

**Cách khắc phục:**
Cài đặt [RuslanUC/NoVPNDetect](https://github.com/RuslanUC/NoVPNDetect), mở LSPosed và vào module NoVPNDetect chọn hook vào app đang detect VPN