---- 1. Thông tin khách hàng
--select kh.MAKH, kh.HOTEN, kh.DCHI, kh.SODT
--from KHACHHANG as kh
--join HOADON as hd on hd.MAKH = kh.MAKH
--join CTHOADON as cd on cd.SOHD = hd.SOHD
--where year(NGAYHD) = 2017
--group by kh.MAKH, kh.HOTEN, kh.DCHI, kh.SODT
--having sum(SL) >= 3;

---- 2. Thông tin hóa đơn
--select hd.SOHD, NGAYHD, HOTEN, DCHI, sum(SL * DONGIA) as [tong]
--from HOADON as hd
--join KHACHHANG as kh on kh.MAKH = hd.MAKH
--join CTHOADON as cd on cd.SOHD = hd.SOHD
--join SANPHAM as sp on sp.MASP = cd.MASP
--where year(getdate()) - year(NGSINH) > 5 and year(NGAYHD) = 2019
--group by hd.SOHD, NGAYHD, HOTEN, DCHI;

---- 3. Danh sách mặt hàng
--select top 1 sp.MASP, TENSP, DONGIA, NUOCSX
--from SANPHAM as sp
--join CTHOADON as cd on cd.MASP = sp.MASP
--join HOADON as hd on hd.SOHD = cd.SOHD
--where year(NGAYHD) = 2019
--order by SL asc;

---- 4. Danh sách khách hàng
--select kh.MAKH, HOTEN, DCHI, SODT, NGSINH
--from KHACHHANG as kh
--join HOADON as hd on hd.MAKH = kh.MAKH
--join CTHOADON as cd on cd.SOHD = hd.SOHD
--join SANPHAM as sp on sp.MASP = cd.MASP
--where year(NGAYHD) = 2019 and TENSP = N'Mũ bảo hiểm' and SL > 2;

----5. Thông tin khách hàng mua tất cả sản phẩm sản xuất tại Việt Nam
--WITH vn_products AS (
--    SELECT MASP
--    FROM SANPHAM
--    WHERE NUOCSX = N'Việt Nam'
--),
--cp AS (
--    SELECT kh.MAKH, kh.HOTEN
--    FROM KHACHHANG kh
--    JOIN HOADON hd ON kh.MAKH = hd.MAKH
--    JOIN CTHOADON cd ON hd.SOHD = cd.SOHD
--    WHERE cd.MASP IN (SELECT MASP FROM vn_products)
--    GROUP BY kh.MAKH, kh.HOTEN
--    HAVING COUNT(DISTINCT cd.MASP) = (SELECT COUNT(*) FROM vn_products)
--)
--SELECT kh.MAKH, kh.HOTEN, kh.DCHI, kh.SODT
--FROM KHACHHANG kh
--WHERE kh.MAKH IN (SELECT MAKH FROM cp);

---- 6. Thông tin sản phẩm
--select sp.MASP, TENSP, NUOCSX, DONGIA
--from SANPHAM as sp
--join CTHOADON as cd on cd.MASP = sp.MASP
--join HOADON as hd on hd.SOHD = cd.SOHD
--where year(NGAYHD) = 2017 and SL = 5
--group by sp.MASP, TENSP, NUOCSX, DONGIA;

-- 7. Thông tin khách hàng VIP
with vip as (
	select kh.MAKH, sum(SL * DONGIA) as [tong], count(distinct hd.SOHD) as [solanmua]
	from KHACHHANG as kh
	join HOADON as hd on hd.MAKH = kh.MAKH
	join CTHOADON as cd on cd.SOHD = hd.SOHD
	join SANPHAM as sp on sp.MASP = cd.MASP
	group by kh.MAKH
	
	having sum(SL * DONGIA) > 79 and count(distinct hd.SOHD) > 0
)
select kh.MAKH, HOTEN, DCHI, v.solanmua, v.tong
from KHACHHANG as kh
join vip as v on v.MAKH = kh.MAKH;
