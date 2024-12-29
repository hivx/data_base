--1. Stored Procedures:
--a) In ra dòng "Xin chào"
 
 
--CREATE PROCEDURE sp_Chao
--AS
--BEGIN
--    PRINT 'Xin chào';
--END;
--b) In ra dòng "Xin chào" + @ten với @ten là tham số đầu vào
 
 
--CREATE PROCEDURE sp_ChaoTen (@ten NVARCHAR(100))
--AS
--BEGIN
--    PRINT 'Xin chào ' + @ten;
--END;
--c) In ra tổng của hai số @s1 và @s2
 
 
--CREATE PROCEDURE sp_Tong (@s1 INT, @s2 INT)
--AS
--BEGIN
--    DECLARE @tg INT;
--    SET @tg = @s1 + @s2;
--    PRINT 'Tổng là: ' + CAST(@tg AS NVARCHAR(100));
--END;
--d) Xuất tổng của @s1 và @s2 ra tham số @tong
 
 
--CREATE PROCEDURE sp_TongOut (@s1 INT, @s2 INT, @tong INT OUTPUT)
--AS
--BEGIN
--    SET @tong = @s1 + @s2;
--END;
--e) In ra số lớn nhất trong hai số @s1 và @s2
 
 
--CREATE PROCEDURE sp_Max (@s1 INT, @s2 INT)
--AS
--BEGIN
--    DECLARE @max INT;
--    IF @s1 > @s2
--        SET @max = @s1;
--    ELSE
--        SET @max = @s2;
--    PRINT 'Số lớn nhất của ' + CAST(@s1 AS NVARCHAR(10)) + ' và ' + CAST(@s2 AS NVARCHAR(10)) + ' là ' + CAST(@max AS NVARCHAR(10));
--END;
--f) Xuất giá trị min và max của hai số @s1 và @s2
 
 
--CREATE PROCEDURE sp_MinMax (@s1 INT, @s2 INT, @min INT OUTPUT, @max INT OUTPUT)
--AS
--BEGIN
--    IF @s1 > @s2
--    BEGIN
--        SET @max = @s1;
--        SET @min = @s2;
--    END
--    ELSE
--    BEGIN
--        SET @max = @s2;
--        SET @min = @s1;
--    END
--END;
--g) In ra các số từ 1 đến @n
 
 
--CREATE PROCEDURE sp_InSo (@n INT)
--AS
--BEGIN
--    DECLARE @i INT = 1;
--    WHILE @i <= @n
--    BEGIN
--        PRINT @i;
--        SET @i = @i + 1;
--    END
--END;
--h) In ra tổng các số chẵn từ 1 đến @n
 
 
--CREATE PROCEDURE sp_TongSoChan (@n INT)
--AS
--BEGIN
--    DECLARE @i INT = 2;
--    DECLARE @tong INT = 0;
--    WHILE @i <= @n
--    BEGIN
--        SET @tong = @tong + @i;
--        SET @i = @i + 2;
--    END
--    PRINT 'Tổng các số chẵn là: ' + CAST(@tong AS NVARCHAR(100));
--END;
--i) In ra tổng và số lượng các số chẵn từ 1 đến @n
 
 
--CREATE PROCEDURE sp_TongSoChanVaSoLuong (@n INT)
--AS
--BEGIN
--    DECLARE @i INT = 2;
--    DECLARE @tong INT = 0;
--    DECLARE @soLuong INT = 0;
--    WHILE @i <= @n
--    BEGIN
--        SET @tong = @tong + @i;
--        SET @soLuong = @soLuong + 1;
--        SET @i = @i + 2;
--    END
--    PRINT 'Tổng các số chẵn là: ' + CAST(@tong AS NVARCHAR(100));
--    PRINT 'Số lượng các số chẵn là: ' + CAST(@soLuong AS NVARCHAR(100));
--END;
--2. Triggers:
--a) Khi thêm cầu thủ mới, kiểm tra vị trí trên sân của cầu thủ
 
 
--CREATE TRIGGER tr_CheckViTri
--ON Cauchthu
--AFTER INSERT
--AS
--BEGIN
--    DECLARE @viTri NVARCHAR(50);
--    SELECT @viTri = viTri FROM inserted;      IF @viTri NOT IN ('Thủ môn', 'Tiền đạo', 'Tiền vệ', 'Trung vệ', 'Hậu vệ')
--    BEGIN
--        PRINT 'Vị trí không hợp lệ';
--        ROLLBACK TRANSACTION;
--    END
--END;
--b) Khi thêm cầu thủ mới, kiểm tra số áo của cầu thủ phải khác nhau trong cùng một câu lạc bộ
 
 
--CREATE TRIGGER tr_CheckSoAo
--ON Cauchthu
--AFTER INSERT
--AS
--BEGIN
--    DECLARE @soAo INT, @idCLB INT;
--    SELECT @soAo = soAo, @idCLB = idCLB FROM inserted;      IF EXISTS (SELECT 1 FROM Cauchthu WHERE soAo = @soAo AND idCLB = @idCLB)
--    BEGIN
--        PRINT 'Số áo đã tồn tại trong câu lạc bộ';
--        ROLLBACK TRANSACTION;
--    END
--END;
--c) Khi thêm thông tin cầu thủ, in ra câu thông báo
 
 
--CREATE TRIGGER tr_ThemCauThu
--ON Cauchthu
--AFTER INSERT
--AS
--BEGIN
--    PRINT 'Đã thêm cầu thủ mới';
--END;
--d) Khi thêm cầu thủ mới, kiểm tra số lượng cầu thủ nước ngoài tối đa 8
 
 
--CREATE TRIGGER tr_CheckSoLuongCauThuNgoai
--ON Cauchthu
--AFTER INSERT
--AS
--BEGIN
--    DECLARE @idCLB INT, @soLuongNgoai INT;
--    SELECT @idCLB = idCLB FROM inserted;      SELECT @soLuongNgoai = COUNT(*) FROM Cauchthu WHERE idCLB = @idCLB AND quocTich <> 'Việt Nam';      IF @soLuongNgoai > 8
--    BEGIN
--        PRINT 'Câu lạc bộ này đã có quá 8 cầu thủ nước ngoài';
--        ROLLBACK TRANSACTION;
--    END
--END;
--e) Khi thêm tên quốc gia, kiểm tra không trùng với quốc gia đã có
 
 
--CREATE TRIGGER tr_CheckQuocGia
--ON Quocgia
--AFTER INSERT
--AS
--BEGIN
--    DECLARE @tenQuocGia NVARCHAR(100);
--    SELECT @tenQuocGia = tenQuocGia FROM inserted;      IF EXISTS (SELECT 1 FROM Quocgia WHERE tenQuocGia = @tenQuocGia)
--    BEGIN
--        PRINT 'Tên quốc gia đã tồn tại';
--        ROLLBACK TRANSACTION;
--    END
--END;
--f) Khi thêm tên tỉnh thành, kiểm tra không trùng với tỉnh thành đã có
 
 
--CREATE TRIGGER tr_CheckTinhThanh
--ON TinhThanh
--AFTER INSERT
--AS
--BEGIN
--    DECLARE @tenTinhThanh NVARCHAR(100);
--    SELECT @tenTinhThanh = tenTinhThanh FROM inserted;      IF EXISTS (SELECT 1 FROM TinhThanh WHERE tenTinhThanh = @tenTinhThanh)
--    BEGIN
--        PRINT 'Tên tỉnh thành đã tồn tại';
--        ROLLBACK TRANSACTION;
--    END
--END;
--g) Không cho sửa kết quả của các trận đã diễn ra
 
 
--CREATE TRIGGER tr_KhongSuaKetQua
--ON TranDau
--AFTER UPDATE
--AS
--BEGIN
--    DECLARE @ngayDau DATETIME, @ngayHienTai DATETIME;
--    SELECT @ngayDau = ngayDau FROM inserted;
--    SET @ngayHienTai = GETDATE();      IF @ngayDau < @ngayHienTai
--    BEGIN
--        PRINT 'Không thể sửa kết quả của trận đã diễn ra';
--        ROLLBACK TRANSACTION;
--    END
--END;
--h) Kiểm tra vai trò của huấn luyện viên
 
 
--CREATE TRIGGER tr_CheckVaiTroHLV
--ON HuanLuyenVien
--AFTER INSERT
--AS
--BEGIN
--    DECLARE @vaiTro NVARCHAR(50);
--    SELECT @vaiTro = vaiTro FROM inserted;      IF @vaiTro NOT IN ('HLV chính', 'HLV phụ', 'HLV thể lực', 'HLV thủ môn')
--    BEGIN
--        PRINT 'Vai trò huấn luyện viên không hợp lệ';
--        ROLLBACK TRANSACTION;
--    END
--END;
--i) Kiểm tra mỗi câu lạc bộ chỉ có tối đa 2 HLV chính
 
 
--CREATE TRIGGER tr_CheckSoLuongHLVChinh
--ON HuanLuyenVien
--AFTER INSERT
--AS
--BEGIN
--    DECLARE @idCLB INT, @vaiTro NVARCHAR(50);
--    SELECT @idCLB = idCLB, @vaiTro = vaiTro FROM inserted;      IF @vaiTro = 'HLV chính'
--    BEGIN
--        DECLARE @soLuong INT;
--        SELECT @soLuong = COUNT(*) FROM HuanLuyenVien WHERE idCLB = @idCLB AND vaiTro = 'HLV chính';
--        IF @soLuong > 2
--        BEGIN
--            PRINT 'Câu lạc bộ này đã có quá 2 HLV chính';
--            ROLLBACK TRANSACTION;
--        END
--    END
--END;
--9. Kiểm tra khi thêm câu lạc bộ trùng tên:
--a) Thông báo mà vẫn cho phép insert
 
 
--CREATE TRIGGER tr_CheckTenCLB_Insert
--ON CâuLacBo
--AFTER INSERT
--AS
--BEGIN
--    DECLARE @tenCLB NVARCHAR(100);
--    SELECT @tenCLB = tenCLB FROM inserted;      IF EXISTS (SELECT 1 FROM CâuLacBo WHERE tenCLB = @tenCLB)
--    BEGIN
--        PRINT 'Câu lạc bộ này đã tồn tại, nhưng vẫn cho phép thêm mới';
--    END
--END;
--b) Thông báo và không cho phép insert
 
 
--CREATE TRIGGER tr_CheckTenCLB_Insert
--ON CâuLacBo
--AFTER INSERT
--AS
--BEGIN
--    DECLARE @tenCLB NVARCHAR(100);
--    SELECT @tenCLB = tenCLB FROM inserted;      IF EXISTS (SELECT 1 FROM CâuLacBo WHERE tenCLB = @tenCLB)
--    BEGIN
--        PRINT 'Câu lạc bộ này đã tồn tại, không thể thêm mới';
--        ROLLBACK TRANSACTION;
--    END
--END;
--10. Khi sửa tên cầu thủ:
--a) In ra danh sách mã cầu thủ của các cầu thủ vừa được sửa
 
 
--CREATE TRIGGER tr_SuaTenCauThu
--ON CầuThu
--AFTER UPDATE
--AS
--BEGIN
--    DECLARE @maCauThu NVARCHAR(100);      -- Lấy mã cầu thủ từ bảng inserted (các cầu thủ vừa được sửa)
--    SELECT @maCauThu = maCauThu FROM inserted;
    
--    PRINT 'Mã cầu thủ vừa sửa: ' + @maCauThu;
--END;
--b) In ra danh sách mã cầu thủ vừa được sửa và tên cầu thủ mới
 
 
--CREATE TRIGGER tr_SuaTenCauThu_NewName
--ON CầuThu
--AFTER UPDATE
--AS
--BEGIN
--    DECLARE @maCauThu NVARCHAR(100), @tenMoi NVARCHAR(100);      -- Lấy mã cầu thủ và tên mới từ bảng inserted
--    SELECT @maCauThu = maCauThu, @tenMoi = tenCauThu FROM inserted;
    
--    PRINT 'Mã cầu thủ vừa sửa: ' + @maCauThu + ', Tên cầu thủ mới: ' + @tenMoi;
--END;
--c) In ra danh sách mã cầu thủ vừa được sửa và tên cầu thủ cũ
 
 
--CREATE TRIGGER tr_SuaTenCauThu_OldName
--ON CầuThu
--AFTER UPDATE
--AS
--BEGIN
--    DECLARE @maCauThu NVARCHAR(100), @tenCu NVARCHAR(100);      -- Lấy mã cầu thủ và tên cũ từ bảng deleted
--    SELECT @maCauThu = maCauThu, @tenCu = tenCauThu FROM deleted;
    
--    PRINT 'Mã cầu thủ vừa sửa: ' + @maCauThu + ', Tên cầu thủ cũ: ' + @tenCu;
--END;
--d) In ra danh sách mã cầu thủ vừa được sửa và tên cầu thủ cũ và cầu thủ mới
 
 
--CREATE TRIGGER tr_SuaTenCauThu_CuMoi
--ON CầuThu
--AFTER UPDATE
--AS
--BEGIN
--    DECLARE @maCauThu NVARCHAR(100), @tenCu NVARCHAR(100), @tenMoi NVARCHAR(100);      -- Lấy mã cầu thủ, tên cũ và tên mới từ bảng deleted và inserted
--    SELECT @maCauThu = maCauThu FROM inserted;
--    SELECT @tenCu = tenCauThu FROM deleted;
--    SELECT @tenMoi = tenCauThu FROM inserted;
    
--    PRINT 'Mã cầu thủ vừa sửa: ' + @maCauThu + ', Tên cầu thủ cũ: ' + @tenCu + ', Tên cầu thủ mới: ' + @tenMoi;
--END;
--e) Câu thông báo bằng Tiếng Việt: 'Vừa sửa thông tin của cầu thủ có mã số xxx'
 
--CREATE TRIGGER tr_SuaThongTinCauThu
--ON CầuThu
--AFTER UPDATE
--AS
--BEGIN
--    DECLARE @maCauThu NVARCHAR(100);      -- Lấy mã cầu thủ từ bảng inserted
--    SELECT @maCauThu = maCauThu FROM inserted;
    
--    PRINT 'Vừa sửa thông tin của cầu thủ có mã số: ' + @maCauThu;
--END;
