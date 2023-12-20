package com.Devex.Controller;



import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.apache.coyote.http11.upgrade.UpgradeServletOutputStream;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Devex.DTO.CartDetailDTo;
import com.Devex.Entity.TransactionHistory;
import com.Devex.Entity.User;
import com.Devex.Sevice.DwalletService;
import com.Devex.Sevice.SessionService;
import com.Devex.Sevice.TransactionHistoryService;
import com.Devex.Sevice.vnPayService;
import com.Devex.Sevice.ServiceImpl.MailerServiceImpl;
import com.nimbusds.oauth2.sdk.util.CollectionUtils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;

@Controller
public class VnpayapiController {

	
	@Autowired
	vnPayService vnPayService;
	
	@Autowired
	MailerServiceImpl mailer;
	@Autowired
    SessionService session;
	
	
	@GetMapping("/thanhtoanhoadon")
	public String index() {
		return "user/formOderpay";
	}

	@PostMapping("/submitOrder")
	public String sumbitOder2(HttpServletRequest request) {
		List<CartDetailDTo> list = session.get("listItemOrder", null);
		double hihi1 = 0;
		for (CartDetailDTo cartDetailDTo : list) {
			hihi1 += (cartDetailDTo.getPrice() * cartDetailDTo.getQuantity());
		}
		int orderTotalInt = (int) hihi1;  
		
		 String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
	        System.out.println(baseUrl);
	        String vnpayUrl = vnPayService.createOrder(orderTotalInt, "hihi", baseUrl);
	        System.out.println(vnpayUrl);
	        User user = session.get("user");
	        try {
		    	  StringBuilder emailContentBuilder = new StringBuilder();
		    	  emailContentBuilder.append("  <table border=\"0\" style=\"margin: 0 auto; font-family: Arial, Helvetica, sans-serif;\" >");
		    	  emailContentBuilder.append("<tr style=\"background-color: rgb(254, 253, 253); width: 500px; height: 100px; outline: 1px solid rgb(180, 158, 158); display: flex; justify-content: center; align-items: center;\">\r\n"
		    	  		+ "            <td><img src=\"https://i.pinimg.com/564x/3a/4c/47/3a4c478ee0994afd0a983082ca14870c.jpg\" style=\"margin-top: 15px;margin-left: 170px;\" width=\"150px\" ></td>\r\n"
		    	  		+ "        </tr>");
		    	  emailContentBuilder.append(" <tr style=\"background-color: rgb(254, 253, 253); width: 500px; height: 500px; outline: 1px solid rgb(180, 158, 158);\">");
		    	  emailContentBuilder.append("<td>\r\n"
		    	  		+ "                <div style=\"width: 400px; margin: auto;\">");
		    	  emailContentBuilder.append("<p style=\"font-family: Arial, Helvetica, sans-serif; font-weight: 600; color: rgb(42, 68, 119); font-size: 18px;\">THÔNG TIN ĐƠN HÀNG SỐ</p>");
		    	  emailContentBuilder.append("<p style=\"font-family: Arial, Helvetica, sans-serif; font-weight: 600; color: rgb(80, 114, 161);\">1. Thông Người Đặt Hàng</p>");
		    	  emailContentBuilder.append("<p style=\"font-family: Arial, Helvetica, sans-serif; font-weight: 600; color: rgb(80, 114, 161); font-size: 15px;\">Họ Và Tên :" +user.getFullname()+"</p>");
		    	  emailContentBuilder.append("<hr>\r\n"
		    	  		+ "                    <p style=\"font-family: Arial, Helvetica, sans-serif; font-weight: 600; color: rgb(80, 114, 161); font-size: 15px;\">Số Điện Thoại :"+user.getPhone()+"</p>");
		    	  emailContentBuilder.append("<hr>\r\n"
		    	  		+ "                    <p style=\"font-family: Arial, Helvetica, sans-serif; font-weight: 600; color: rgb(80, 114, 161); font-size: 15px;\">Địa Chỉ :"+""+"</p>");
		    	  emailContentBuilder.append("<hr>\r\n"
		    	  		+ "                    <p style=\"font-family: Arial, Helvetica, sans-serif; font-weight: 600; color: rgb(80, 114, 161); font-size: 15px;\"> Mô Tả :"+"</p>");
		    	  emailContentBuilder.append("<hr>\r\n"
		    	  		+ "                    <p style=\"font-family: Arial, Helvetica, sans-serif; font-weight: 600; color: rgb(51, 113, 200);\">2.Sản Phẩm Đặt Hàng</p>");
		    	  emailContentBuilder.append(" <table style=\"margin: 0 auto; border-collapse: collapse; width: 100%; text-align: center; font-size: 15px;\" >");
		    	  emailContentBuilder.append("<tr>\r\n"
		    	  		+ "                            <td style=\"border: 2px solid rgb(132, 177, 225);\">STT</td>\r\n"
		    	  		+ "                            <td style=\"border: 2px solid  rgb(132, 177, 225);\">Tên Sản Phẩm</td>\r\n"
		    	  		+ "                            <td style=\"border: 2px solid  rgb(132, 177, 225);\">Số Lượng</td>\r\n"
		    	  		+ "                            <td style=\"border: 2px solid  rgb(132, 177, 225);\">Giá</td>\r\n"
		    	  		+ "                            <td style=\"border: 2px solid  rgb(132, 177, 225);\">Tổng</td>\r\n"
		    	  		+ "                        </tr>");
		    	  
		    	  double tong2= 0;
		    	  DecimalFormat decimalFormat = new DecimalFormat("###,###");
		    	  for (CartDetailDTo cartDetailDTo : list) {
					if(cartDetailDTo.getColor().equals("")) {
						cartDetailDTo.setColor("Không có");
					}
					if(cartDetailDTo.getSize().equals("")) {
						cartDetailDTo.setSize("Không có");
					}
					double tong = cartDetailDTo.getPrice() * cartDetailDTo.getQuantity();
					
					double gia2 = cartDetailDTo.getPrice();
					String formattedNumber = String.format("%,d", (int) gia2);

					String formattedNumber2 = String.format("%,d", (int) tong);
					
					 emailContentBuilder.append("<tr>");
		    		  emailContentBuilder.append(" <td style=\"border: 2px solid  rgb(132, 177, 225);\">"+"</td>");
			    	  emailContentBuilder.append("<td style=\"border: 2px solid  rgb(132, 177, 225);\">"+"<p>"+cartDetailDTo.getNameProduct()+"</p>\r\n"
			    	  		+ "                                <p>Màu Sắc :"+cartDetailDTo.getColor()+"</p>\r\n"
			    	  		+ "                                <p>Size :"+cartDetailDTo.getSize()+"</p>"+  "</td>");
			    	  emailContentBuilder.append("<td style=\"border: 2px solid  rgb(132, 177, 225);\">"+cartDetailDTo.getQuantity()+"</td>");
			    	  emailContentBuilder.append("<td style=\"border: 2px solid  rgb(132, 177, 225);\">"+formattedNumber+"</td>");
			    	  emailContentBuilder.append("<td style=\"border: 2px solid  rgb(132, 177, 225);\">"+formattedNumber2+"</td>");
			    	  emailContentBuilder.append("</tr>");
			    	  tong2 += tong;
				}
		    	  String formattedNumber = String.format("%,d", (int) tong2);
		    	  emailContentBuilder.append("</table>\r\n"
		    	  		+ "                    <hr>");
		    	  emailContentBuilder.append("<p style=\"font-weight: 400;\">Giảm Giá:  <a href=\"\" style=\"color: rgb(51, 51, 51); font-weight: bold;font-size: 15px; float: right;text-decoration: none; \">o VND</a></p> \r\n"
		    	  		+ "                    <p style=\"font-weight: 400;\">Phí Vận Chuyển :  <a href=\"\" style=\"color: rgb(51, 51, 51); font-weight: bold;font-size: 15px; float: right;text-decoration: none; \">10.0000 VND</a></p>\r\n"
		    	  		+ "                    <p style=\"font-weight: bold;\">Tổng Tiền :  <a href=\"\" style=\"color: rgb(254, 3, 3); font-weight: bold;font-size: 16px; float: right;text-decoration: none; \">"+formattedNumber+"VND"
		    	  		+ "                </a></p> </div>");
		    	  emailContentBuilder.append("   </td>\r\n"
		    	  		+ "           \r\n"
		    	  		+ "        </tr>\r\n"
		    	  		+ "        <tr style=\"background-color: rgb(104, 170, 228); width: 500px; height: 100px; outline: 1px solid rgb(180, 158, 158);; margin: 0 auto; display: flex; justify-content: center; align-items: center; color: white;\">\r\n"
		    	  		+ "            <td style=\"font-size: 15px;\">\r\n"
		    	  		+ "                <p> Truy Cập Trang Web Để Nhập Ưu Đãi</p>\r\n"
		    	  		+ "                <p>Cảm Ơn Bạn Đã Tin Tưởng DEVEX</p>\r\n"
		    	  		+ "            </td>\r\n"
		    	  		+ "            \r\n"
		    	  		+ "        </tr>\r\n"
		    	  		+ "    </table>");
		    	

		    	  String emailContent = emailContentBuilder.toString();
		    	  
				mailer.send(user.getEmail(), "DEVEX - THÔNG BÁO XÁC NHẬN ĐƠN HÀNG CỦA BẠN", emailContent);
			} catch (Exception e) {
				System.out.println("Lỗi");
				System.out.println(e);
			}
	        
	        
	        return "redirect:" + vnpayUrl;
	    
	   
	}
	
	
	 @PostMapping("/submitOrder1")
	    public String submidOrder(@RequestParam("amount") String orderTotal1,
	                            @RequestParam("orderInfo") String orderInfo,
	                            @RequestParam(value="product_name",required = false ) List<String> product_name,
	                            @RequestParam(value="product_size",required = false) List<String> product_size,
	                            @RequestParam(value="product_color",required = false) List<String> product_color,
	                            @RequestParam(value="product_price",required = false) List<Integer> product_price,
	                            @RequestParam(value="product_quantity",required = false) List<Integer> quantity,
	                            @RequestParam(value="product_img",required = false) List<String> product_img,
	                            @RequestParam(value="address",required = false) String address,
	                            HttpServletRequest request){
		 
		 
		 
		 int maxLength = Math.max(
		     Math.max(product_name.size(), product_price.size()),
		     Math.max(quantity.size(), product_img.size())
		 );

		 while (product_name.size() < maxLength) {
		     product_name.add("Không có");
		 }

		 while (product_price.size() < maxLength) {
		     product_price.add(0);
		 }

		 while (quantity.size() < maxLength) {
		     quantity.add(0);
		 }

		 while (product_img.size() < maxLength) {
		     product_img.add("Không có");
		 }
		 while (product_size.size() < maxLength) {
			 product_size.add("Không có");
		 }
		 while (product_color.size() < maxLength) {
			 product_color.add("Không có");
		 }

//		 for (int i = 0; i < maxLength; i++) {
//		     System.out.println("Sản phẩm " + (i + 1) + ":");
//		     System.out.println("Tên sản phẩm: " + product_name.get(i));
//		     System.out.println("Giá sản phẩm: " + product_price.get(i));
//		     System.out.println("Số lượng: " + quantity.get(i));
//		     System.out.println("Link ảnh: " + product_img.get(i));
//		     System.out.println("Link ảnh: " + product_size.get(i));
//		     System.out.println("Link ảnh: " + product_color.get(i));
//		     System.out.println();
//		 }
		
		 double orderTotal = Double.parseDouble(orderTotal1);
		 float orderTotalFloat = Float.parseFloat(orderTotal1);
		 int orderTotalInt = (int) orderTotal; 
	     String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
	     String vnpayUrl = vnPayService.createOrder(orderTotalInt, orderInfo, baseUrl);   
	     int list2 = product_name.size();
	     // Gửi Email
	     
	        return "redirect:" + vnpayUrl;
	    }
	 
	 
	 @GetMapping("/vnpay-payment")
	    public String GetMapping(HttpServletRequest request, Model model){
	        int paymentStatus =vnPayService.orderReturn(request);
	        System.out.println("status: "+paymentStatus);
	        String orderInfo = request.getParameter("vnp_OrderInfo");
	        System.out.println("status: "+orderInfo);
	        String paymentTime = request.getParameter("vnp_PayDate");
	        String transactionId = request.getParameter("vnp_TransactionNo");
	        String totalPrice = request.getParameter("vnp_Amount");
	        model.addAttribute("orderId", orderInfo);
	        model.addAttribute("totalPrice", totalPrice);
	        model.addAttribute("paymentTime", paymentTime);
	        model.addAttribute("transactionId", transactionId);
	        	
	        if(orderInfo.equals("naptien")) {
	        	return paymentStatus == 1 ? "redirect:/rechargeSuccess?totalPrice="+totalPrice: "orderfail";
	        }else {
	        	 return paymentStatus == 1 ? "redirect:order/success" : "orderfail";
	        }
	       
	    }
	 
	 @PostMapping("/sumbitRecharge")
	 public String Recharge(@RequestParam("amount") int total, String noteOder,HttpServletRequest request) {
			noteOder="naptien";
		 	String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
	        String vnpayUrl = vnPayService.createOrder(total, noteOder, baseUrl);
	        System.out.println(vnpayUrl);
		 return "redirect:" + vnpayUrl;
		 
	 }
	 
	 @Autowired
	private DwalletService dwalletService;
	 @Autowired
	 private TransactionHistoryService transactionHistoryService;
	 @GetMapping("/rechargeSuccess")
		public String rechargeSuccess(Model mdoel,HttpServletRequest request)
		{
			
		 	long orderTotal = Long.parseLong(request.getParameter("totalPrice")) / 100;
		 	int intValue = (int) orderTotal;
			double doubleValue = (double) orderTotal;
			User user = session.get("user");
			dwalletService.updateDwalletbyUsername(intValue, user.getUsername());
			TransactionHistory transactional = new TransactionHistory();
			transactional.setFrom("6393354612293475394132454613191791413327669698937398338115217662142713457395040659847955435853662737");
			transactional.setTo( user.getDwallet().getId());
			transactional.setValue(doubleValue);
			transactionHistoryService.save(transactional);
			return "user/paymentSuccess"; 
		}
	 
	 
	
	
}
