/* 3. Yêu cầu thực hành 
a. Truy vấn cơ bản 
1. Cho biết thông tin (mã cầu thủ, họ tên, số áo, vị trí, ngày sinh, địa chỉ) của tất cả các 
cầu thủ’. */
--SELECT MACT, HOTEN, SO, VITRI, NGAYSINH, DIACHI
--FROM CAUTHU;

/* 2. Hiển thị thông tin tất cả các cầu thủ có số áo là 7 chơi ở vị trí Tiền vệ. */
--SELECT *
--FROM dbo.CAUTHU
--WHERE SO = 7 AND VITRI = N'Tiền vệ ';

/*3. Cho biết tên, ngày sinh, địa chỉ, điện thoại của tất cả các huấn luyện viên. */
--SELECT TENHLV, NGAYSINH, DIACHI, DIENTHOAI
--FROM dbo.HUANLUYENVIEN

/* 4. Hiển thi thông tin tất cả các cầu thủ có quốc tịch Việt Nam thuộc câu lạc bộ 
Becamex Bình Dương. */
--SELECT *
--FROM dbo.CAUTHU
--WHERE MAQG = N'VN' AND MACLB = N'BBD';

/*5. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bóng 
‘SHB Đà Nẵng’ có quốc tịch khác VN */
--SELECT SO, HOTEN, NGAYSINH, DIACHI, VITRI
--FROM dbo.CAUTHU
--WHERE MACLB = N'SDN' AND MAQG != 'VN';

/* 6. Hiển thị thông tin tất cả các cầu thủ đang thi đấu trong câu lạc bộ có sân nhà là 
“Long An”. */
--SELECT CT.*
--FROM dbo.CAUTHU CT
--JOIN dbo.CAULACBO CLB ON CT.MACLB = CLB.MACLB
--WHERE CLB.MASAN = N'LA';

/* 7. Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các 
trận đấu vòng 2 của mùa bóng năm 2009. */
--SELECT MATRAN, NGAYTD, TENSAN, CLB1.TENCLB, CLB2.TENCLB, KETQUA
--FROM dbo.TRANDAU TD
--JOIN dbo.SANVD SVD ON SVD.MASAN = TD.MASAN
--JOIN dbo.CAULACBO CLB1 ON CLB1.MACLB = TD.MACLB1
--JOIN dbo.CAULACBO CLB2 ON CLB2.MACLB = TD.MACLB2
--WHERE VONG = 2 AND NAM = 2009;

/* 8. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB 
đang làm việc  của các huấn luyện viên có quốc tịch “ViệtNam”. */
--SELECT 
--FROM dbo.HUANLUYENVIEN HLV
--JOIN dbo.HLV_CLB HC ON HC.MAHLV = HLV

/* 9. Lấy tên 3 câu lạc bộ có điểm cao nhất sau vòng 3 năm 2009. */
--SELECT top 3 TENCLB, DIEM
--FROM dbo.CAULACBO as CLB
--JOIN dbo.BANGXH as BXH ON BXH.MACLB = CLB.MACLB
--WHERE NAM = 2009 AND VONG = 3
--order by DIEM desc

/*10. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc 
mà câu lạc bộ đó đóng ở tỉnh Binh Dương. */
--select hlv.MAHLV, hlv.TENHLV, hlv.NGAYSINH, hlv.DIACHI, hc.VAITRO, clb.TENCLB
--from dbo.HUANLUYENVIEN as hlv
--join dbo.HLV_CLB as hc on hc.MAHLV = hlv.MAHLV
--join dbo.CAULACBO as clb on clb.MACLB = hc.MACLB
--join dbo.TINH as tinh on tinh.MATINH = clb.MATINH
--where tinh.TENTINH = N'Bình Dương';

/*
b. Các phép toán trên nhóm 
1. Thống kê số lượng cầu thủ của mỗi câu lạc bộ. */
--select clb.TENCLB, COUNT(ct.MACT) as [so luong]
--from CAULACBO as clb 
--join CAUTHU as ct on ct.MACLB = clb.MACLB
--group by clb.TENCLB;

/* 
2. Thống kê số lượng cầu thủ nước ngoài (có quốc tịch khác  Việt Nam) của mỗi câu lạc bộ */
--select clb.TENCLB, count (ct.MAQG) as [so luong]
--from CAUTHU as ct
--join QUOCGIA as qg on qg.MAQG = ct.MAQG
--join CAULACBO as clb on clb.MACLB = ct.MACLB
--where qg.TENQG not like N'Việt Nam'
--group by clb.TENCLB;

--SELECT COUNT(ct.MACT) AS [Tong so luong]
--FROM CAUTHU AS ct
--JOIN QUOCGIA AS qg ON qg.MAQG = ct.MAQG
--WHERE qg.TENQG NOT LIKE N'Việt Nam';

/*
3. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu 
thủ nước ngoài (có quốc tịch khác Việt Nam) tương ứng của các câu lạc bộ có nhiều 
hơn 2 cầu thủ nước ngoài.*/
--select clb.MACLB, clb.TENCLB, clb.MASAN, t.TENTINH, COUNT(ct.MACT) as [so cau thu]
--from CAULACBO as clb
--join TINH as t on t.MATINH = clb.MATINH
--join CAUTHU as ct on ct.MACLB = clb.MACLB
--join QUOCGIA as qg on qg.MAQG = ct.MAQG
--where qg.TENQG != N'Việt Nam'
--group by clb.TENCLB, clb.MACLB, clb.MASAN, t.TENTINH
--having COUNT(ct.MACT) >= 2;

/*
4. Cho biết tên tỉnh, số lượng cầu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc 
bộ thuộc địa bàn tỉnh đó quản lý. */
--select t.TENTINH, COUNT(*) as [So luong cau thu]
--from TINH as t
--join CAULACBO as clb on clb.MATINH = t.MATINH
--join CAUTHU as ct on ct.MACLB = clb.MACLB
--where ct.VITRI = N'tiền đạo'
--group by t.TENTINH;

/*
5. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng 
xếp hạng vòng 3, năm 2009. */
--select top 1 clb.TENCLB, t.TENTINH
--from CAULACBO as clb
--join TINH as t on t.MATINH = clb.MATINH
--join BANGXH as bxh on bxh.MACLB = clb.MACLB
--where bxh.VONG = 3 and NAM =2009
--order by bxh.HANG asc

/*
c. Các toán tử nâng cao 
1. Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong một câu lạc bộ 
mà chưa có số điện thoại. */
--select hlv.TENHLV
--from HUANLUYENVIEN as hlv
--join HLV_CLB as hc on hc.MAHLV = hlv.MAHLV
--where hlv.DIENTHOAI is null

--SELECT hlv.TENHLV
--FROM HUANLUYENVIEN AS hlv
--WHERE hlv.DIENTHOAI IS NULL
--  AND EXISTS (
--    SELECT 1
--    FROM HLV_CLB AS hc
--    WHERE hc.MAHLV = hlv.MAHLV
--  );

/*
2. Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện 
tại bất kỳ một câu lạc bộ nào. */
--select hlv.*
--from HUANLUYENVIEN as hlv
--join QUOCGIA as qg on qg.MAQG = hlv.MAQG
--where TENQG like N'Việt Nam'
--	and not exists (
--		select 1
--		FROM HLV_CLB AS hc
--		WHERE hc.MAHLV = hlv.MAHLV
--	)

--select *
--from HUANLUYENVIEN as hlv
--join QUOCGIA as qg on qg.MAQG = hlv.MAQG
--left join HLV_CLB as hc on hc.MAHLV = hlv.MAHLV
--where TENQG like N'Việt Nam' and hc.MAHLV is null;

/*
3. Liệt kê các cầu thủ đang thi đấu trong các câu lạc bộ có thứ hạng ở vòng 3 năm 2009 
lớn hơn 6 hoặc nhỏ hơn 3. */
--select ct.*
--from CAUTHU as ct
----join CAULACBO as clb on clb.MACLB = ct.MACLB
--join BANGXH as bxh on bxh.MACLB = ct.MACLB
--where NAM = 2009 and VONG = 3 and bxh.HANG between 3 and 6

/*
4. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) 
của câu lạc bộ (CLB) đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009. */
--select NGAYTD, TENSAN, clb1.TENCLB as [cau lac bo 1], clb2.TENCLB as [cau lac bo 2], KETQUA
--from TRANDAU as td
--join SANVD as svd on svd.MASAN = td.MASAN
--join CAULACBO as clb1 on clb1.MACLB = td.MACLB1
--join CAULACBO as clb2 on clb2.MACLB = td.MACLB2
--where td.MACLB1 = (select MACLB
--from BANGXH as bxh
--where bxh.NAM = 2009 and bxh.VONG = 3 and bxh.HANG = 1)
--or td.MACLB2 = (select MACLB
--from BANGXH as bxh
--where bxh.NAM = 2009 and bxh.VONG = 3 and bxh.HANG = 1)

--WITH TopClub AS (
--    SELECT MACLB
--    FROM BANGXH
--    WHERE NAM = 2009 AND VONG = 3 AND HANG = 1
--)
--SELECT 
--    td.NGAYTD, 
--    svd.TENSAN, 
--    clb1.TENCLB AS [Câu lạc bộ 1], 
--    clb2.TENCLB AS [Câu lạc bộ 2], 
--    td.KETQUA
--FROM TRANDAU AS td
--JOIN SANVD AS svd ON svd.MASAN = td.MASAN
--JOIN CAULACBO AS clb1 ON clb1.MACLB = td.MACLB1
--JOIN CAULACBO AS clb2 ON clb2.MACLB = td.MACLB2
--JOIN TopClub AS tc ON td.MACLB1 = tc.MACLB OR td.MACLB2 = tc.MACLB;

--WITH TOPCLB AS (
--    SELECT MACLB
--    FROM BANGXH
--    WHERE NAM = 2009 AND VONG = 3 AND HANG = 1
--)
--select NGAYTD, TENSAN, clb1.TENCLB as [cau lac bo 1], clb2.TENCLB as [cau lac bo 2], KETQUA
--from TRANDAU as td
--join SANVD as svd on svd.MASAN = td.MASAN
--join CAULACBO as clb1 on clb1.MACLB = td.MACLB1
--join CAULACBO as clb2 on clb2.MACLB = td.MACLB2
--join TOPCLB as tc on tc.MACLB = clb1.MACLB or tc.MACLB = clb2.MACLB