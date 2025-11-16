1. Dựng: ```DOCKER_BUILDKIT=1 docker build -t app:contest -f Dockerfile.linux_contest vite-react-template``` (Kiến trúc xây dựng là linux/amd64).
2. Chạy: ```docker run -d --rm --name contest-app -p 8080:3000 app:contest```. 
3. Lấy thông tin với ```docker ps```, sau đó ```docker stop contest-app```, container dừng trong vòng 10s và bị xoá, do có --rm.
4. Healthcheck: 
    a. ```docker inspect --format='{{json .State.Health}}' contest-app``` - Kiểm tra Healthy và Exit code 0
    b. Truy cập trinh duyệt: http://localhost:8080/ - Kết quả trả về: trang web được hiển thị đầy đủ
5. Hạng mục đăng ký thưởng bổ sung:
    a. Kích thước: 18.4MB, nhờ tối giản toàn bộ tính năng không cần thiết, giảm bề mặt tấn công của tin tặc
    b. Bảo mật: Sử dụng Syft và Grype quét an toàn với 0 CVE tại thời điểm quét
6. Lưu ý: Không có yêu cầu về mạng, không cần cấp quyền đặc biệt để chạy bất kỳ lệnh nào trong file này. 