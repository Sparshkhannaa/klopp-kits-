<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Shopping Cart</title>
    <style>
        table {
            border-collapse: collapse;
            width: 80%;
        }
        th, td {
		border: 2px solid #D3D3D3;
		padding: 8px;
		text-align: left;
	}
	th {
		background-color: #Fdb0c0;
	}
        a {
            color: blue;
        }
        h1, h2 {
            margin: 20px 0;
        }
        .button-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 150px;
        }
    
        .button-container form {
            margin: 10px 0;
        }
    
        .button-container button {
        padding: 10px 20px;
        background-color: transparent;
        color: #000;
        border: 2px solid #000;
        border-radius: 5px;
        cursor: pointer;
        font-size: large;
        }
        .button-container button:hover {
            background-color: #000;
            color: #fff;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

<%
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null) {
    out.println("<H1>Your shopping cart is empty!</H1>");
    productList = new HashMap<String, ArrayList<Object>>();
} else {
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    out.println("<h1>Your Shopping Cart</h1>");
    out.print("<table>");
    out.print("<tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
    out.println("<th>Price</th><th>Subtotal</th><th></th></tr>");

    double total = 0;
    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    while (iterator.hasNext()) {
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
        if (product.size() < 4) {
            out.println("Expected product with four entries. Got: " + product);
            continue;
        }

        out.print("<tr>");
        out.print("<td>" + product.get(0) + "</td>");
        out.print("<td>" + product.get(1) + "</td>");

        out.print("<td align=\"center\">" + product.get(3) + "</td>");
        Object price = product.get(2);
        Object itemqty = product.get(3);
        double pr = 0;
        int qty = 0;

        try {
            pr = Double.parseDouble(price.toString());
        } catch (Exception e) {
            out.println("Invalid price for product: " + product.get(0) + " price: " + price);
        }
        try {
            qty = Integer.parseInt(itemqty.toString());
        } catch (Exception e) {
            out.println("Invalid quantity for product: " + product.get(0) + " quantity: " + qty);
        }

        out.print("<td align=\"right\">" + currFormat.format(pr) + "</td>");
        out.print("<td align=\"right\">" + currFormat.format(pr * qty) + "</td>");
        %>
       
        <td><div class="button-container">
            <form action="addcart.jsp" method="get">
                <input type="hidden" name="id" value="<%= product.get(0) %>">
                <input type="hidden" name="name" value="<%= product.get(1) %>">
                <input type="hidden" name="price" value="<%= product.get(2) %>">
                <button type="submit">+</button>
            </form>
            <form action="reducecart.jsp" method="get">
                <input type="hidden" name="id" value="<%= product.get(0) %>">
                <input type="hidden" name="name" value="<%= product.get(1) %>">
                <input type="hidden" name="price" value="<%= product.get(2) %>">
                <button type="submit">-</button>
            </form>
            <form action="removecart.jsp" method="get">
                <input type="hidden" name="id" value="<%= product.get(0) %>">
                <button type="submit">Remove</button> </form>
        
        </td>
        <%
        out.println("</tr>");

        total = total + pr * qty;
    }

    out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
            + "<td align=\"right\">" + currFormat.format(total) + "</td></tr>");
    out.println("</table>");

    out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
}
%>
<h2><a href="index.jsp">Continue Shopping</a></h2>
</body>
</html>
