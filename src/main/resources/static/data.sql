﻿use master
go
create database HB_Coffee
go
use HB_Coffee
go

-- create table
create table [Account] (
	[ID] int identity(101,1) primary key,
	[Fullname] nvarchar(50) not null,
	[Email] nvarchar(30) not null,
	[Password] nvarchar(30) not null,
	[Gender] bit,
	[Birthday] date,
	[Address] nvarchar(100),
	[Role] bit,
	[VerifiCode] nvarchar(6),
	[isActive] bit not null
)
go
create table [TypeOfBeverage] (
	[ID] int identity(101,1) primary key,
	[Name] nvarchar(50) not null
)
go
create table [Beverage] (
	[ID] int identity(10001,1) primary key,
	[Name] nvarchar(100) not null,
	[Price] float not null,
	[Description] varchar(max) not null,
	[Image] nvarchar(100) not null,
	[Type_ID] int not null,
	FOREIGN KEY ([Type_ID]) REFERENCES [TypeOfBeverage](ID)
)
go
create table [TypeOfTopping] (
	[ID] int identity(101,1) primary key,
	[Name] nvarchar(30) not null
)
go
create table [Topping] (
	[ID] int identity(101,1) primary key,
	[Name] nvarchar(50) not null,
	[Price] float not null,
	[Type_ID] int not null,
	FOREIGN KEY ([Type_ID]) REFERENCES [TypeOfTopping](ID)
)
go
create table [Voucher] (
	[ID] int identity(1001,1) primary key,
	[Name] nvarchar(100) not null,
	[Description] nvarchar(max) not null,
	[Code] nvarchar(10) not null,
	[Start_Date] date not null,
	[End_Date] date not null,
	[RequestTotal] float null,
	[Discount] float not null
)
go
create table [DetailOfVoucher] (
	[ID] int identity(1001,1) primary key,
	[Customer_ID] int not null,
	[Voucher_ID] int not null,
	FOREIGN KEY ([Customer_ID]) REFERENCES [Account](ID),
	FOREIGN KEY ([Voucher_ID]) REFERENCES [Voucher](ID)
)
go
create table [Bill] (
	[ID] int identity(10001,1) primary key,
	[Total] float not null,
	[Date] date not null,
	[Payment] nvarchar(15) not null CHECK ([Payment] IN(N'Tiền mặt', N'Chuyển khoản')),
	[Customer_ID] int not null,
	[Voucher_ID] int null,
	FOREIGN KEY ([Customer_ID]) REFERENCES [Account](ID),
	FOREIGN KEY ([Voucher_ID]) REFERENCES [Voucher](ID)
)
go
create table [DetailOfBill] (
	[ID] int identity(10001,1) primary key,
	[Quantity] int not null,
	[Size] varchar(1) not null CHECK ([Size] IN('S', 'M', 'L')),
	[Price] float not null,
	[Bill_ID] int not null,
	[Beverage_ID] int not null,
	[Topping_ID] int null,
	FOREIGN KEY ([Bill_ID]) REFERENCES [Bill](ID),
	FOREIGN KEY ([Beverage_ID]) REFERENCES [Beverage](ID),
	FOREIGN KEY ([Topping_ID]) REFERENCES [Topping](ID)
)
go
-- Insert data
insert into Account
values	(N'Lê Huy Bảo', N'baolh106@gmail.com', '123', 1, '2003-06-10', N'Phú Nhuận', 0,'123456',1),
		(N'Phạm Gia Hào', N'haoireal@gmail.com', '123', 1, '2003-11-11', N'Gò Vấp', 0,'123456',1),
		(N'HB Coffee', N'hbcoffee@gmail.com', '123', 0, '2003-06-20', N'Quận 1', 1,'123456',1)

go
insert into TypeOfBeverage
values	(N'Cà phê'),
		(N'CloudFee'),
		(N'CloudTea'),
		(N'Hi-Tea Healthy'),
		(N'Trà Trái Cây - Trà Sữa')

go
insert into Beverage
values	(N'Cà phê sữa đá', 25000, N'Cà phê Đắk Lắk nguyên chất được pha phin truyền thống kết hợp với sữa đặc tạo nên hương vị đậm đà, hài hòa giữa vị ngọt đầu lưỡi và vị đắng thanh thoát nơi hậu vị.', N'ca-phe-sua-da.png', 101),
		(N'Cà phê đen đá', 23000, N'Không ngọt ngào như Bạc sỉu hay Cà phê sữa, Cà phê đen mang trong mình phong vị trầm lắng, thi vị hơn. Người ta thường phải ngồi rất lâu mới cảm nhận được hết hương thơm ngào ngạt, phảng phất mùi cacao và cái đắng mượt mà trôi tuột xuống vòm họng.', N'ca-phe-den-da.jpg', 101),
		(N'Bạc xỉu', 39000, N'Bạc sỉu chính là "Ly sữa trắng kèm một chút cà phê". Thức uống này rất phù hợp những ai vừa muốn trải nghiệm chút vị đắng của cà phê vừa muốn thưởng thức vị ngọt béo ngậy từ sữa.', N'bac-siu.jpg', 101),
		(N'Đường đen sữa đá', 35000, N'Nếu chuộng vị cà phê đậm đà, bùng nổ và thích vị đường đen ngọt thơm, Đường Đen Sữa Đá đích thị là thức uống dành cho bạn. Không chỉ giúp bạn tỉnh táo buổi sáng, Đường Đen Sữa Đá còn hấp dẫn đến ngụm cuối cùng bởi thạch cà phê giòn dai, nhai cực cuốn. - Khuấy đều trước khi sử dụng', N'dd-suada.jpg', 101),
		(N'Đường đen Marble Latte', 40000, N'Đường Đen Marble Latte êm dịu cực hấp dẫn bởi vị cà phê đắng nhẹ hoà quyện cùng vị đường đen ngọt thơm và sữa tươi béo mịn. Sự kết hợp đầy mới mẻ của cà phê và đường đen cũng tạo nên diện mạo phân tầng đẹp mắt. Đây là lựa chọn đáng thử để bạn khởi đầu ngày mới đầy hứng khởi. - Khuấy đều trước khi sử dụng', N'dd-latte.jpg', 101),
		(N'Caramel Macchiato đá', 40000, N'Khuấy đều trước khi sử dụng Caramel Macchiato sẽ mang đến một sự ngạc nhiên thú vị khi vị thơm béo của bọt sữa, sữa tươi, vị đắng thanh thoát của cà phê Espresso hảo hạng và vị ngọt đậm của sốt caramel được gói gọn trong một tách cà phê.', N'caramel-macchiato.jpg', 101),
		(N'Latte - đá', 40000, N'Một sự kết hợp tinh tế giữa vị đắng cà phê Espresso nguyên chất hòa quyện cùng vị sữa nóng ngọt ngào, bên trên là một lớp kem mỏng nhẹ tạo nên một tách cà phê hoàn hảo về hương vị lẫn nhãn quan.', N'latte-da.jpg', 101),
		(N'Latte - nóng', 40000, N'Một sự kết hợp tinh tế giữa vị đắng cà phê Espresso nguyên chất hòa quyện cùng vị sữa nóng ngọt ngào, bên trên là một lớp kem mỏng nhẹ tạo nên một tách cà phê hoàn hảo về hương vị lẫn nhãn quan.', N'latte_nong.jpg', 101),
		(N'Americano - đá', 38000, N'Americano được pha chế bằng cách pha thêm nước với tỷ lệ nhất định vào tách cà phê Espresso, từ đó mang lại hương vị nhẹ nhàng và giữ trọn được mùi hương cà phê đặc trưng.', N'arme-da.jpg', 101),
		(N'Americano - nóng', 38000, N'Americano được pha chế bằng cách pha thêm nước với tỷ lệ nhất định vào tách cà phê Espresso, từ đó mang lại hương vị nhẹ nhàng và giữ trọn được mùi hương cà phê đặc trưng.', N'arme-nong.jpg', 101),
		(N'Cappuccino - đá', 40000, N'Capuchino là thức uống hòa quyện giữa hương thơm của sữa, vị béo của bọt kem cùng vị đậm đà từ cà phê Espresso. Tất cả tạo nên một hương vị đặc biệt, một chút nhẹ nhàng, trầm lắng và tinh tế.', N'Capu-da.jpg', 101),
		(N'Cappuccino - nóng', 40000, N'Capuchino là thức uống hòa quyện giữa hương thơm của sữa, vị béo của bọt kem cùng vị đậm đà từ cà phê Espresso. Tất cả tạo nên một hương vị đặc biệt, một chút nhẹ nhàng, trầm lắng và tinh tế.', N'capu-nong.jpg', 101),
		(N'Espresso - đá', 39000, N'Một tách Espresso nguyên bản được bắt đầu bởi những hạt Arabica chất lượng, phối trộn với tỉ lệ cân đối hạt Robusta, cho ra vị ngọt caramel, vị chua dịu và sánh đặc.', N'espressoDa.jpg', 101),
		(N'Espresso - nóng', 39000, N'Một tách Espresso nguyên bản được bắt đầu bởi những hạt Arabica chất lượng, phối trộn với tỉ lệ cân đối hạt Robusta, cho ra vị ngọt caramel, vị chua dịu và sánh đặc.', N'espressoNong.jpg', 101),
		(N'CloudFee hạnh nhân nướng', 50000, N'Vị đắng nhẹ từ cà phê phin truyền thống kết hợp Espresso Ý, lẫn chút ngọt ngào của kem sữa và lớp foam trứng cacao, nhấn thêm hạnh nhân nướng thơm bùi, kèm topping thạch cà phê dai giòn mê ly. Tất cả cùng quyện hoà trong một thức uống làm vị giác "thức giấc", thơm ngon hết nấc.', N'cloudfee-hanh-nhan-nuong-min.png', 102),
		(N'CloudFee caramel', 50000, N'Ngon khó cưỡng bởi xíu đắng nhẹ từ cà phê phin truyền thống pha trộn với Espresso lừng danh nước Ý, quyện vị kem sữa và caramel ngọt ngọt, thêm lớp foam trứng cacao bồng bềnh béo mịn, kèm topping thạch cà phê dai giòn nhai cực cuốn. Một thức uống "điểm mười" cho cả ngày tươi không cần tưới.', N'cloudfee-caramel.jpg', 102),
		(N'CloudFee Sài Gòn', 50000, N'Khiến bạn mê mẩn ngay ngụm đầu tiên bởi vị đắng nhẹ của cà phê phin truyền thống kết hợp Espresso Ý, quyện hòa cùng chút ngọt ngào của kem sữa, và thơm béo từ foam trứng cacao. Nhấp một ngụm rồi nhai cùng thạch cà phê dai dai giòn giòn, đúng chuẩn "ngon quên lối về". CloudFee Classic là món đậm vị cà phê nhất trong bộ sưu tập nhưng không quá đắng, ngậy nhưng không hề ngấy.', N'cloudfee-classic.jpg', 102),
		(N'CloudTea Oolong nướng kem dừa', 49000, N'Vừa chạm môi là mê mẩn ngay lớp kem dừa beo béo, kèm vụn bánh quy phô mai giòn tan trong miệng. Đặc biệt, trà Oolong nướng đậm đà, hòa cùng sữa dừa ngọt dịu. Hương vị thêm bùng nổ nhờ có thạch Oolong nướng nguyên chất, giòn dai.', N'cloudtea-oolong-nuong-kem-dua-min.png', 103),
		(N'CloudTea Oolong nướng caramel', 49000, N'Chiếc trà sữa chân ái dành cho tín đồ hảo ngọt gọi tên CloudTea Oolong Nướng Caramel. Sự kết hợp của foam trứng béo mịn, caramel thơm lừng, trà Oolong nướng rõ vị quyện kem sữa ngọt ngào, làm tan chảy vị giác tựa khoảnh khắc chạm môi người thương. Thêm bột cacao đậm đà và thạch Oolong nướng dai giòn giúp độ ngon nhân đôi.', N'cloudtea-caramel.jpg', 103),
		(N'CloudTea Oolong nướng kem cheese', 49000, N'Hội mê cheese sao có thể bỏ lỡ chiếc trà sữa siêu mlem này. Món đậm vị Oolong nướng - nền trà được yêu thích nhất hiện nay, quyện thêm kem sữa thơm béo. Đặc biệt, chinh phục ngay fan ghiền cheese bởi lớp foam phô mai mềm tan mằn mặn. Càng ngon cực với thạch Oolong nướng nguyên chất giòn dai nhai siêu thích.', N'cloudtea_cheese.jpg', 103),
		(N'CloudTea Oolong nướng kem dừa đá xay', 49000, N'Trà sữa đá xay - phiên bản nâng cấp đầy mới lạ của trà sữa truyền thống, lần đầu xuất hiện tại Nhà. Ngon khó cưỡng với lớp kem dừa béo ngậy nhưng không ngấy, thêm vụn bánh quy phô mai giòn tan vui miệng. Trà Oolong nướng rõ hương đậm vị, quyện với sữa dừa beo béo, được xay mịn cùng đá, mát rượi trong tích tắc. Đặc biệt, thạch Oolong nướng nguyên chất giúp giữ trọn vị đậm đà của trà sữa đến giọt cuối cùng.', N'cloudtea-daxay.jpg', 103),
		(N'Hi-Tea vải', 45000, N'Chút ngọt ngào của Vải, mix cùng vị chua thanh tao từ trà hoa Hibiscus, mang đến cho bạn thức uống đúng chuẩn vừa ngon, vừa healthy.', N'hi-tea-vai.png', 104),
		(N'Hi-Tea đào', 45000, N'Sự kết hợp ăn ý giữa Đào cùng trà hoa Hibiscus, tạo nên tổng thể hài hoà dễ gây “thương nhớ” cho team thích món thanh mát, có vị chua nhẹ.', N'hi-tea-dao.jpg', 104),
		(N'Hi-Tea thơm trân châu', 49000, N'Với nền trà Hibiscus 0% caffeine và thơm giàu vitamin C, Hi-Tea Thơm là thức uống dành cho hội healthy. Đặc biệt, Hi-Tea Thơm chua chua ngọt ngọt thêm phần hấp dẫn nhờ kết hợp cùng trân châu trắng giòn dai cực vui miệng.', N'hitea-thom.jpg', 104),
		(N'Hi-Tea phúc bồn tử', 45000, N'Nền trà Hibiscus thanh mát, quyện vị chua chua ngọt ngọt của phúc bồn tử 100% tự nhiên cùng quýt mọng nước mang đến cảm giác sảng khoái tức thì.', N'hitea-phuc-bon-tu.jpg', 104),
		(N'Hi-Tea đá tuyết Yuzu', 49000, N'Vị trà hoa Hibiscus chua chua, kết hợp cùng đá tuyết Yuzu mát lạnh tái tê, thêm miếng vải căng mọng, ngọt ngào sẽ khiến bạn thích thú ngay từ lần thử đầu tiên.', N'hitea-da-tuyet-vai.jpg', 104),
		(N'Trà sữa Oolong nướng trân châu', 49000, N'Hương vị chân ái đúng gu đậm đà với trà oolong được “sao” (nướng) lâu hơn cho hương vị đậm đà, hòa quyện với sữa thơm béo mang đến cảm giác mát lạnh, lưu luyến vị trà sữa đậm đà nơi vòm họng.', N'tra-sua-oolong-nuong-tran-chau.png', 105),
		(N'Hồng trà sữa trân châu', 45000, N'Thêm chút ngọt ngào cho ngày mới với hồng trà nguyên lá, sữa thơm ngậy được cân chỉnh với tỉ lệ hoàn hảo, cùng trân châu trắng dai giòn có sẵn để bạn tận hưởng từng ngụm trà sữa ngọt ngào thơm ngậy thiệt đã.', N'hong-tra-sua-tran-chau.jpg', 105),
		(N'Trà đào cam sả', 49000, N'Vị thanh ngọt của đào, vị chua dịu của Cam Vàng nguyên vỏ, vị chát của trà đen tươi được ủ mới mỗi 4 tiếng, cùng hương thơm nồng đặc trưng của sả chính là điểm sáng làm nên sức hấp dẫn của thức uống này.', N'tra-dao-cam-sa-da.png', 105),
		(N'Trà hạt sen', 49000, N'Nền trà oolong hảo hạng kết hợp cùng hạt sen tươi, bùi bùi và lớp foam cheese béo ngậy. Trà hạt sen là thức uống thanh mát, nhẹ nhàng phù hợp cho cả buổi sáng và chiều tối.', N'tra-sen.jpg', 105),
		(N'Trà đen Macchiato', 45000, N'Trà đen được ủ mới mỗi ngày, giữ nguyên được vị chát mạnh mẽ đặc trưng của lá trà, phủ bên trên là lớp Macchiato "homemade" bồng bềnh quyến rũ vị phô mai mặn mặn mà béo béo.', N'tra-den-matchiato.jpg', 105),
		(N'Trà sữa mắc ca trân châu', 49000, N'Mỗi ngày với The Coffee House sẽ là điều tươi mới hơn với sữa hạt mắc ca thơm ngon, bổ dưỡng quyện cùng nền trà oolong cho vị cân bằng, ngọt dịu đi kèm cùng Trân châu trắng giòn dai mang lại cảm giác “đã” trong từng ngụm trà sữa.', N'tra-sua-mac-ca.jpg', 105)

go
insert into TypeOfTopping
values	(N'Coffee-Cloud'),
		(N'Tea')

go
insert into Topping
values	(N'Kem phô mai Macchiato', 10000, 101),
		(N'Sốt Caramel', 5000, 101),
		(N'Thạch cafe', 10000, 101),
		(N'Kem trứng', 10000, 101),
		(N'Đào miếng', 8000, 102),
		(N'Trái vải', 8000, 102),
		(N'Trân châu trắng', 10000, 102),
		(N'Hạt sen', 8000, 102),
		(N'Milk foam', 10000, 102)

go
insert into Voucher
values	(N'Voucher Nice Day', N'Giảm 20% cho hoá đơn trên 120K khi uống tại quán', 'DONFLOW20', '2023-5-1', '2023-5-30', 120000, 0.2),
		(N'Voucher Happy Birthday H&B Coffee', N'Giảm 30K cho hoá đơn trên 70K duy nhất trong ngày khi đến quán uống trực tiếp và đã đăng kí thành viên H&B Coffee', 'BIRTHDAY30', '2023-3-20', '2023-3-21', 70000, -30000),
		(N'Voucher Couple Festival', N'Giảm 15% cho các cặp đôi nhân ngày 14-2 khi order hoá đơn trên 80K kéo dài đến hết ngày 16-2', 'COUPLE142', '2023-2-14', '2023-2-16', 80000, 0.15),
		(N'Voucher Tết Dương Lịch 1-1', N'Giảm 11% cho hoá đơn trên 111K khi uống tại quán duy nhất trong ngày 1-1', 'TETTET11', '2023-1-1', '2023-1-2', 111000,  0.11),
		(N'Voucher Combo 30-4 & 1-5', N' Giảm 25K cho hoá đơn trên 80K khi uống tại quán trong hai ngày 30-4 và 1-5', 'HOLIDAY25', '2023-4-30', '2023-5-1', 80000, -25000),
		(N'Voucher Quốc Tế Thiếu Nhi', N' Giảm 16% cho hoá đơn trên 70K chỉ áp dụng cho khách hàng dưới 18 tuổi', 'YOUNG16', '2023-6-1', '2023-6-2', 70000, 0.16)

go
insert into DetailOfVoucher
values	(101, 1006),
		(101, 1002),
		(102, 1003),
		(102, 1001)

go
insert into Bill
values	(80000, '2023-4-16', N'Chuyển khoản', 101, null),
		(65000, '2023-4-30', N'Tiền mặt', 102, 1005),
		(105000, '2023-5-15', N'Tiền mặt', 101, null)

go
insert into DetailOfBill
values	(1, 'M', 30000, 10001, 10001, null),
		(1, 'S', 50000, 10001, 10017, null),
		(1, 'M', 45000, 10002, 10007, null),
		(1, 'S', 45000, 10002, 10023, null),
		(1, 'S', 59000, 10003, 10030, 107),
		(2, 'S', 46000, 10003, 10002, null)
