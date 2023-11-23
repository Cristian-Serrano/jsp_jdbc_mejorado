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
    <title>Detalle socio</title>
</head>
<body>
<%
    ResultSet rs = null;
    //CÓDIGO DE VALIDACIÓN
    boolean valida = true;
    int id = -1;
    try {
        id = Integer.parseInt(request.getParameter("socioid"));
    } catch (NumberFormatException nfe) {
        nfe.printStackTrace();
        valida = false;
    }
    //FIN CÓDIGO DE VALIDACIÓN


    if (valida) {


        id = Integer.parseInt(request.getParameter("socioid"));

        Connection conn = null;
        PreparedStatement ps = null;

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/baloncesto", "root", "user");


            String sql = "select * from socio where socioID = ?";

            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            rs = ps.executeQuery();
            if (rs.next())
            {
                int socio = rs.getInt("socioID");
                String nombre = rs.getString("nombre");
                int estatura = rs.getInt("estatura");
                int edad = rs.getInt("edad");
                String localidad = rs.getString("localidad");
                %>
                <h1>Detalle socio</h1>
                <p>ID del socio: <%= socio %></p>
                <p>Nombre: <%= nombre %></p>
                <p>Estatura: <%= estatura %></p>
                <p>Edad: <%= edad %></p>
                <p>Localidad: <%= localidad %></p>
                <%
            }


            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {
                //BLOQUE FINALLY PARA CERRAR LA CONEXIÓN CON PROTECCIÓN DE try-catch
                //SIEMPRE HAY QUE CERRAR LOS ELEMENTOS DE LA  CONEXIÓN DESPUÉS DE UTILIZARLOS
                try {
                    rs.close();
                } catch (Exception e) {
                    /* Ignored */
                }
                try {
                    ps.close();
                } catch (Exception e) { /* Ignored */ }
                try {
                    conn.close();
                } catch (Exception e) { /* Ignored */ }
            }
        }else{
                response.sendRedirect("pideNumeroSocio.jsp");
            }
%>
<a href="index.jsp">Volver</a>
</body>
</html>
