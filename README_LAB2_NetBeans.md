# LAB 2 – Mã hóa đối xứng hiện đại (NetBeans)

## 1. Nội dung gói mã nguồn
- `pom.xml`: Maven, JDK 17, SQL Server JDBC, BouncyCastle.
- `src/main/java/week_02/`: giao diện Swing và lớp thuật toán DES, TripleDES, AES-GCM, RC4, Twofish, AES-CTR.
- `SQL/`: tạo CSDL, tạo tài khoản SQL, kiểm tra dữ liệu.
- `LAB2_Python/aes_cbc_gui.py`: AES-256-CBC bằng Python/Tkinter.
- `Hinh_tham_khao_tu_PDF/`: hình tham khảo trích từ tài liệu hướng dẫn LAB2, không phải ảnh chụp máy cá nhân.

## 2. Yêu cầu
- JDK 17 hoặc 21.
- Apache NetBeans 20 trở lên.
- Maven và Internet ở lần build đầu.
- SQL Server Express + SSMS (TCP/IP cổng 14333 theo hướng dẫn).
- Python 3.10+ nếu chạy phần AES-CBC.

## 3. Mở và chạy trên NetBeans
1. Giải nén gói ZIP vào thư mục không dấu, ví dụ `C:\BaoMat\LAB2_MaHoaHienDai`.
2. Mở NetBeans → File → Open Project.
3. Chọn thư mục có `pom.xml`.
4. Nhấp phải project → Clean and Build. Chờ `BUILD SUCCESS`.
5. Nhấp phải project → Run (F6). Main class: `week_02.frm_Menu`.

**Lưu ý giao diện:** bản mã nguồn này tổ chức chức năng thành các tab trong một JFrame `frm_Menu` để chạy thử thuận tiện. PDF gốc hướng dẫn các JFrame Form riêng được thiết kế bằng NetBeans GUI Builder. Nếu yêu cầu chấm bắt buộc có từng tệp `.form`, hãy tạo riêng `frm_DES`, `frm_TripleDES`, `frm_AES`, `frm_RC4`, `frm_Twofish`, `frm_AES_CTR`, `frm_KetNoiSQL`, `frm_LichSu` theo bảng điều khiển trong PDF.

## 4. Cấu hình SQL Server
1. Mở SQL Server Configuration Manager.
2. Bật TCP/IP cho `SQLEXPRESS`; đặt `IPAll → TCP Port = 14333`; xóa TCP Dynamic Ports.
3. Restart dịch vụ SQL Server (SQLEXPRESS).
4. Mở SSMS bằng tài khoản quản trị và chạy lần lượt:
   - `SQL/01_Tao_CSDL.sql`
   - `SQL/02_Tao_Tai_Khoan_SQL.sql`
5. Trong app, mở tab SQL / Lịch sử, cấu hình server `127.0.0.1`, port `14333`, database `LAB2_MaHoaHienDai`, user `lab2_user`, và mật khẩu SQL bạn đã cấu hình tại máy.
6. Chạy `SQL/03_Kiem_Tra_Du_Lieu.sql` để xem tài khoản và lịch sử.

**Bảo mật:** nếu script SQL có mật khẩu mẫu của lab, chỉ dùng trong môi trường thực hành cục bộ. Đổi mật khẩu trước khi dùng lâu dài; không commit mật khẩu thật lên GitHub.

## 5. Dữ liệu kiểm thử
| Bài | Dữ liệu | Kết quả tham chiếu |
|---|---|---|
| DES | Plaintext `Xin chào Lab 2 - Mã hóa hiện đại!`; Key `12345678` | Decrypt trả về đúng bản rõ |
| TripleDES | Key `123456789012345678901234` (24 ký tự ASCII) | Khóa đúng độ dài; 23 ký tự phải báo lỗi |
| AES-GCM | Register/Login user mới | Ticket xuất hiện; sửa ciphertext thì Decrypt thất bại |
| RC4 | Plaintext `Plaintext`; Key `Key` | HEX `BBF316E8D940AF0AD3` |
| Twofish | Generate IV, nhập key và plaintext | Decrypt đúng; Save/Open phục hồi IV |
| AES-CTR | Generate Key + Nonce | Decrypt đúng; không padding; không tái sử dụng cặp key/nonce |
| Python AES-CBC | Văn bản dài | Self-test in `SELF-TEST OK` |

## 6. Chạy Python AES-CBC
Mở Command Prompt:
```bat
py --version
py -m pip install cryptography
cd /d C:\BaoMat\LAB2_MaHoaHienDai\LAB2_Python
py aes_cbc_gui.py --self-test
py aes_cbc_gui.py
```
Trong giao diện: Generate Key → Generate IV → nhập Plaintext → Encrypt → xóa Plaintext → Decrypt. File lưu gồm IV và ciphertext, không lưu Key.

## 7. Hướng dẫn chụp ảnh nộp bài
Chụp màn hình thật, không dùng hình tham khảo trong thư mục `Hinh_tham_khao_tu_PDF` làm bằng chứng cá nhân:
1. NetBeans mở project.
2. Output `BUILD SUCCESS`.
3. Cửa sổ `frm_Menu`.
4. DES Encrypt/Decrypt.
5. TripleDES đúng khóa và thử khóa sai.
6. AES Register/Login và ticket.
7. AES-GCM Encrypt/Decrypt; thử ciphertext bị sửa.
8. SSMS có `app_users`, `crypto_history`.
9. RC4 ra đúng HEX.
10. Twofish Encrypt/Decrypt và Save/Open.
11. AES-CTR Encrypt/Decrypt.
12. Python `SELF-TEST OK` và giao diện AES-CBC.

## 8. Hạn chế và lưu ý an toàn
- DES, TripleDES và RC4 đã lỗi thời/không phù hợp để bảo vệ dữ liệu thật; chỉ dùng để học.
- Với ứng dụng mới, ưu tiên AES-GCM.
- AES-CTR không tự cung cấp xác thực; cần cơ chế xác thực bổ sung trong ứng dụng thực tế.
- Không tái sử dụng nonce với cùng khóa AES-CTR.
- Hình trong thư mục `Hinh_tham_khao_tu_PDF` là ảnh trang tài liệu gốc, không phải ảnh chụp từ máy tính người học.
