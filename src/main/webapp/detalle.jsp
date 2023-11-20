<%--
  Created by IntelliJ IDEA.
  User: cristianserrano
  Date: 20/11/23
  Time: 14:12
  To change this template use File | Settings | File Templates.
--%>
<%@page import="java.sql.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    String id = request.getParameter("socioid");

    Connection conn = null;
    PreparedStatement ps = null;
    try {

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/baloncesto", "root", "user");

        String sql = "select * from socio where socio = "+id;

        ps = conn.prepareStatement(sql);
        int idx = 1;
        ps.setInt(idx++, numero);
        ps.setString(idx++, nombre);
        ps.setInt(idx++, estatura);
        ps.setInt(idx++, edad);
        ps.setString(idx++, localidad);

        int filasAfectadas = ps.executeUpdate();
        System.out.println("SOCIOS GRABADOS:  " + filasAfectadas);


    } catch (Exception ex) {
        ex.printStackTrace();
    } finally {
        //BLOQUE FINALLY PARA CERRAR LA CONEXIÓN CON PROTECCIÓN DE try-catch
        //SIEMPRE HAY QUE CERRAR LOS ELEMENTOS DE LA  CONEXIÓN DESPUÉS DE UTILIZARLOS
        //try { rs.close(); } catch (Exception e) { /* Ignored */ }
        try {
            ps.close();
        } catch (Exception e) { /* Ignored */ }
        try {
            conn.close();
        } catch (Exception e) { /* Ignored */ }
    }
%>
<a href="index.jsp">Volver</a>
</body>
</html>
