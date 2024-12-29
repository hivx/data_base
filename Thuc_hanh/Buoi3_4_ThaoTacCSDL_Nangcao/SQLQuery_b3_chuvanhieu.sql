--3. Yêu cầu thực hành
--a. Xử lý chuỗi, ngày giờ
--1. Cho biết NGAYTD, TENCLB1, TENCLB2, KETQUA các trận đấu diễn ra vào tháng 3 trên sân
--nhà mà không bị thủng lưới.
--SELECT NGAYTD, CLB1.TENCLB, CLB2.TENCLB, KETQUA
--FROM TRANDAU as TD
--JOIN dbo.CAULACBO as CLB1 ON CLB1.MACLB = TD.MACLB1
--JOIN dbo.CAULACBO as CLB2 ON CLB2.MACLB = TD.MACLB2
--WHERE MONTH(NGAYTD) = 3 AND KETQUA LIKE '%-0';

--SELECT NGAYTD, CLB1.TENCLB, CLB2.TENCLB, KETQUA
--FROM TRANDAU as TD
--JOIN dbo.CAULACBO as CLB1 ON CLB1.MACLB = TD.MACLB1
--JOIN dbo.CAULACBO as CLB2 ON CLB2.MACLB = TD.MACLB2
--WHERE MONTH(NGAYTD) = 3 
--  AND ((KETQUA LIKE '%-0'AND CLB1.MASAN = TD.MASAN) OR (KETQUA LIKE '0-%'AND CLB2.MASAN = TD.MASAN));

--2. Cho biết mã số, họ tên, ngày sinh của những cầu thủ có họ lót là “Công”.
--SELECT MACT, HOTEN, NGAYSINH
--FROM CAUTHU
--WHERE HOTEN LIKE N'%Công%';

--3. Cho biết mã số, họ tên, ngày sinh của những cầu thủ có họ không phải là họ “Nguyễn “.
--SELECT MACT, HOTEN, NGAYSINH
--FROM CAUTHU
--WHERE HOTEN NOT LIKE N'Nguyễn %';

--4. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ của những huấn luyện viên Việt
--Nam có tuổi nằm trong khoảng 35-40.
--SELECT MAHLV, TENHLV, NGAYSINH, DIACHI
--FROM dbo.HUANLUYENVIEN as HLV
--JOIN dbo.QUOCGIA as QG ON QG.MAQG = HLV.MAQG
--WHERE TENQG = N'Việt Nam' AND year(GETDATE()) - YEAR(NGAYSINH) BETWEEN 50 AND 60;

--5. Cho biết tên câu lạc bộ có huấn luyện viên trưởng sinh vào ngày 20 tháng 8 năm 2019.
--SELECT TENCLB
--FROM dbo.CAULACBO as CLB
--JOIN dbo.HLV_CLB as HC ON HC.MACLB = CLB.MACLB
--JOIN dbo.HUANLUYENVIEN as HLV ON HLV.MAHLV = HC.MAHLV
--WHERE HC.VAITRO LIKE N'HLV Chính' AND NGAYSINH = '1955-10-15';

--6. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng có số bàn thắng nhiều nhất tính đến
--hết vòng 3 năm 2009.
--select TENCLB, TENTINH, HIEUSO, SUBSTRING(bxh.HIEUSO,1,1) as [so ban thang]
--from CAULACBO as clb
--join TINH as t on t.MATINH = clb.MATINH
--join BANGXH as bxh on bxh.MACLB = clb.MACLB
--where NAM = 2009 and VONG = 3
--group by TENCLB, TENTINH, HIEUSO
--order by [so ban thang] desc;

--WITH thangmax AS (
--    SELECT TOP 1 SUBSTRING(bxh.HIEUSO, 1, 1) AS sobanthang
--    FROM BANGXH AS bxh
--    WHERE bxh.NAM = 2009 AND bxh.VONG = 3
--    ORDER BY sobanthang DESC
--)

--SELECT TENCLB, TENTINH
--FROM CAULACBO AS clb
--JOIN TINH AS t ON clb.MATINH = t.MATINH
--JOIN BANGXH AS bxh ON clb.MACLB = bxh.MACLB
--JOIN thangmax AS tm ON SUBSTRING(bxh.HIEUSO, 1, 1) = tm.sobanthang
--WHERE bxh.NAM = 2009 AND bxh.VONG = 3;

--b. Truy vấn con
--1. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ nước
--ngoài (Có quốc tịch khác “Việt Nam”) tương ứng của các câu lạc bộ có nhiều hơn 2 cầu
--thủ nước ngoài.
--select clb.MACLB, TENCLB, TENSAN, svd.DIACHI
--from CAULACBO as clb
--join SANVD as svd on svd.MASAN = clb.MASAN
--join CAUTHU as ct on ct.MACLB = clb.MACLB
--join QUOCGIA as qg on qg.MAQG = ct.MAQG
--where TENQG not like N'Việt Nam'
--group by clb.MACLB, TENCLB, TENSAN, svd.DIACHI
--having count(clb.MACLB) >=2;

--2. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng có hiệu số bàn thắng bại cao
--nhất năm 2009.
--with hieusomax as (
--	select max(cast(substring(HIEUSO, 1, 1) as int) - cast(substring(HIEUSO, 3, 1) as int)) as [hieusomax]
--	from BANGXH
--	where VONG = 4 and NAM = 2009
--)

--select TENCLB, TENTINH
--from CAULACBO as clb
--join TINH as t on t.MATINH = clb.MATINH
--join BANGXH as bxh on bxh.MACLB = clb.MACLB
--join hieusomax as hm on hm.hieusomax = cast(substring(HIEUSO, 1, 1) as int) - cast(substring(HIEUSO, 3, 1) as int)
--where NAM = 2009 and VONG = 4;

--3. Cho biết danh sách các trận đấu ( NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) của
--câu lạc bộ CLB có thứ hạng thấp nhất trong bảng xếp hạng vòng 3 năm 2009.
--doi co thu hang cao la doi co so nho nhat va nguoc lai 🤣🤣
--with clbmin as (
--	select top 1 MACLB
--	from BANGXH
--	where VONG = 3 and NAM = 2009
--	order by HANG desc
--)
--select NGAYTD, TENSAN, clb1.TENCLB, clb2.TENCLB, KETQUA
--from TRANDAU as td
--join SANVD as svd on svd.MASAN = td.MASAN
--join CAULACBO as clb1 on clb1.MACLB = td.MACLB1
--join CAULACBO as clb2 on clb2.MACLB = td.MACLB2
--join clbmin as cm on cm.MACLB = td.MACLB1 or cm.MACLB = td.MACLB2 

--4. Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại
--(kể cả sân nhà và sân khách) trong mùa giải năm 2009.
--select clb1.MACLB, clb1.TENCLB
--from CAULACBO as clb1
----neu co doi chua thi dau vs clb1 thi return fasle va ngc lai
--where not exists (
----tim clb2 ma chua thi dau voi clb1
--	select 1
--	from CAULACBO as clb2
--	where clb2.MACLB <> clb1.MACLB
--	and not exists (
--	--tim tran dau ma clb2 da dau voi clb1
--		select 1
--		from TRANDAU as td
--		where (td.MACLB1 = clb1.MACLB and td.MACLB2 = clb2.MACLB)
--		or (td.MACLB1 = clb2.MACLB and td.MACLB2 = clb1.MACLB)
--	)
--)

--5. Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại
--( chỉ tính sân nhà) tro ng mùa giải năm 2009.
select clb1.MACLB, clb1.TENCLB
from CAULACBO as clb1
--neu co doi chua thi dau vs clb1 thi return fasle va ngc lai
where not exists (
--tim clb2 ma chua thi dau voi clb1
	select 1
	from CAULACBO as clb2
	where clb2.MACLB <> clb1.MACLB
	and not exists (
	--tim tran dau ma clb2 da dau voi clb1
		select 1
		from TRANDAU as td
		where td.MACLB1 = clb1.MACLB and td.MACLB2 = clb2.MACLB
	)
)

--c. Bài tập về Rule
--1. Khi thêm cầu thủ mới, kiểm tra vị trí trên sân của cầu thủ chỉ thuộc một trong các vị
--trí sau: Thủ môn, tiền đạo, tiền vệ, trung vệ, hậu vệ.


--2. Khi phân công huấn luyện viên, kiểm tra vai trò của huấn luyện vi ên chỉ thuộc một trong
--các vai trò sau: HLV chính, HLV phụ, HLV thể lực, HLV thủ môn.
--3. Khi thêm cầu thủ mới, kiểm tra cầu thủ đó có tuổi phải đủ 18 trở lên (chỉ tính năm sinh)
--4. Kiểm tra kết quả trận đấu có dạng số_bàn_thắng- số_bàn_thua.

--//ko thuc hanh cai nay😁😁
--d. Bài tập về View
--1. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bón g “SHB
--Đà Nẵng” có quốc tịch “Bra-xin”.
--2. Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các trận
--đấu vòng 3 của mùa bóng năm 2009.
--3. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc
--của các huấn luyện viên có quốc tịch “Việt Nam”.
--4. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ
--nước ngoài (có quốc tịch khác “Việt Nam”) tương ứng của các câu lạc bộ nhiều hơn
--2 cầu thủ nước ngoài.
--5. Cho biết tên tỉnh, số lượng câu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc
--bộ thuộc địa bàn tỉnh đó quản lý.
--6. Cho biết tên câu lạc bộ,tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng xếp
--hạng của vòng 3 năm 2009.
--7. Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong 1 câu lạc bộ mà chưa có số
--điện thoại.
--8. Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện tại
--bất kỳ một câu lạc bộ
--Bài tập thực hành CSDL– IT3090 – Ver20201
--9. Cho biết kết quả các trận đấu đã diễn ra (MACLB1, MACLB2, NAM, VONG,
--SOBANTHANG,SOBANTHUA).
--10. Cho biết kết quả các trận đấu trên sân nhà (MACLB, NAM, VONG,
--SOBANTHANG, SOBANTHUA).
--11. Cho biết kết quả các trận đấu trên sân khách (MACLB, NAM, VONG,
--SOBANTHANG,SOBANTHUA).
--12. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2,
--KETQUA) của câu lạc bộ CLB đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009.
--13. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA)
--của câu lạc bộ CLB có thứ hạng thấp nhất trong bảng xếp hạng vòng 3 năm 2009
